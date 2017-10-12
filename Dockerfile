FROM alpine:latest
MAINTAINER Vadim Aleksandrov <valeksandrov@me.com>

COPY rootfs /

RUN echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    apk add --update \
    ca-certificates \
    python \
    py2-pip \
    && pip install --upgrade pip \
    && pip install j2cli \
    && update-ca-certificates \
    && apk del \
    ca-certificates \
    # Clean up
    && rm -rf \
    /usr/share/man \
    /tmp/* \
    /var/cache/apk/*

# Add s6-overlay
ENV S6_OVERLAY_VERSION v1.20.0.0

RUN apk add --update curl && \
    curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz \
    | tar xvfz - -C / && \
    apk del curl && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/init"]
CMD []
