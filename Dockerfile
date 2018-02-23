# Base image: https://hub.docker.com/_/golang/
FROM golang:1.9

ENV GOPATH /go
ENV PATH ${GOPATH}/bin:$PATH

# Install dep
RUN go get -u -v golang.org/x/sys
RUN go get -u -v golang.org/x/vgo
RUN go get -u golang.org/x/text
RUN go get -u golang.org/x/net
RUN go get -u golang.org/x/exp
RUN go get -u golang.org/x/perf
RUN go get -u golang.org/x/image
RUN go get -u golang.org/x/sync
RUN go get -u golang.org/x/time
RUN go get -u golang.org/x/crypto/...
RUN go get -u golang.org/x/tools/...
RUN go get -u golang.org/x/lint/golint
RUN go get -u github.com/golang/dep/cmd/dep
RUN go get -u gopkg.in/alecthomas/gometalinter.v2

RUN gometalinter.v2 -i

# Add apt key for LLVM repository
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

# Add LLVM apt repository
RUN echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-5.0 main" | tee -a /etc/apt/sources.list

# Install clang from LLVM repository
RUN apt-get update && apt-get install -y --no-install-recommends clang-5.0

# Set Clang as default CC
ENV set_clang /etc/profile.d/set-clang-cc.sh
RUN echo "export CC=clang-5.0" | tee -a ${set_clang} && chmod a+x ${set_clang}

# Remove cache
RUN apt-get autoremove \
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*