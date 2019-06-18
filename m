Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749744A151
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfFRNAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:00:54 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:35511 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfFRNAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:00:54 -0400
Received: by mail-lj1-f180.google.com with SMTP id x25so3440270ljh.2
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zUCt1Xr2sEbY7cfOrXi8lz4heLXYX7H0RXCZwsrzX+w=;
        b=WlrdVYiPw/B2a+O95RjnvMnYcDrLm2DlWVIEE84iQKWH0Z+Jc2UbhUj2+9cv5cRz6q
         onb65iR10RRF6QrdA1R8Cjv18vEC8efYZNxZ2OgnRshdZaEkkfvHHtQu3XuFXnvm12M2
         lc3IZo6x9PatujDr7JK7j/HL/M+qBhsa9bUXA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zUCt1Xr2sEbY7cfOrXi8lz4heLXYX7H0RXCZwsrzX+w=;
        b=JrMNGhejuRHcvhKxZgoKQHDOIRzRU4Nf6wOjuEyM5YhoVwR0OdVdyoFjwYHQa1dVqT
         n1k5CoPqPEPjAKQVqdC1n/a5B2dxeoKDH7ix03ZgwhRy05ruPcIySiusdpqesJjAVG5R
         ffShHizn+/FrWS6QOiyV2gGY25NJbDjpaxJ0oyH6TjtX7QhT4iz9QVT3XswsE2PbgVp/
         zRX1Z3SxkG5MG5YHqhf++OLNNlms1GKdzcWWwGIx9pTiHm3Cpm+qgdok9/+iNph9ARC9
         nYveEyONmrp8n/6wsed8/3MV9M8grLBGI6ByGa0/7KVM2wPVzDW2eZgISKru4dyWab49
         XMAg==
X-Gm-Message-State: APjAAAW0qe5OG2MPDb/xWWALxk8ArELhnGEZF0VRgzLS1Ip2U4rh/ax7
        lHl/BOuFkX3xLG4Cf2/QzXYAv4TlkpNzbg==
X-Google-Smtp-Source: APXvYqx4fB1k/SIYL91oI3Q49ZteGat9gPL0g4OhKU5bZ7a/hjiGUCPW3yuFZyTIraGUp7MX+o8RGA==
X-Received: by 2002:a2e:301a:: with SMTP id w26mr52809173ljw.76.1560862852079;
        Tue, 18 Jun 2019 06:00:52 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id d5sm2169695lfc.96.2019.06.18.06.00.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 06:00:51 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-team@cloudflare.com
Subject: [RFC bpf-next 0/7] Programming socket lookup with BPF
Date:   Tue, 18 Jun 2019 15:00:43 +0200
Message-Id: <20190618130050.8344-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have been exploring an idea of making listening socket
lookup (inet_lookup) programmable with BPF.

Why? At last Netdev Marek talked [1] about two limitations of bind() API
we're hitting when running services on our edge servers:

1) sharing a port between two services

   Services are accepting connections on different (disjoint) IP ranges but
   use the same port. Say, packets to 192.0.2.0/24 tcp/80 go to NGINX,
   while 198.51.100.0/24 tcp/80 is handled by Apache. Servers are running
   as different users, in a flat single-netns setup.

2) receiving traffic on all ports

   Proxy accepts connections a specific IP range but on any port [2].

In both cases we've found that bind() and a combination of INADDR_ANY,
SO_REUSEADDR, or SO_REUSEPORT doesn't allow for the setup we need, short of
binding each service to every IP:port pair combination :-)

We've resorted at first to custom patches [3], and more recently to traffic
steering with TPROXY. Not without pain points:

 - XDP programs using bpf_sk_lookup helpers, like load balancers, can't
   find the listening socket to check for SYN cookies with TPROXY redirect.

 - TPROXY takes a reference to the listening socket on dispatch, which
   raises lock contention concerns.

 - Traffic steering configuration is split over several iptables rules, at
   least one per service, which makes configuration changes error prone.

Now back to the patch set, it introduces a new BPF program type, dubbed
inet_lookup, that runs before listening socket lookup, and can override the
destination IP:port pair used as lookup key. Program attaches to netns in
scope of which the lookup happens.

What an inet_lookup program might look like? For the mentioned scenario
with two HTTP servers sharing port 80:

#define NET1 (IP4(192,  0,   2, 0) >> 8)
#define NET2 (IP4(198, 51, 100, 0) >> 8)

SEC("inet_lookup/demo_two_http_servers")
int demo_two_http_servers(struct bpf_inet_lookup *ctx)
{
        if (ctx->family != AF_INET)
                return BPF_OK;
        if (ctx->local_port != 80)
                return BPF_OK;

        switch (bpf_ntohl(ctx->local_ip4) >> 8) {
        case NET1:
                ctx->local_ip4 = bpf_htonl(IP4(127, 0, 0, 1));
                ctx->local_port = 81;
                return BPF_REDIRECT;
        case NET2:
                ctx->local_ip4 = bpf_htonl(IP4(127, 0, 0, 1));
                ctx->local_port = 82;
                return BPF_REDIRECT;
        }

        return BPF_OK;
}

What are the downsides?

 - BPF program, if attached, runs on the receive hot path,
 - introspection is worse than for TPROXY iptables rules.

Also UDP packet steering has to be reworked. In current form we run the
inet_lookup program before checking for any connected UDP sockets, which is
unexpected.

The patches, while still in their early stages, show what we're trying to
solve. We're reaching out early for feedback to see what are the technical
concerns and if we can address them.

Just in time for the coming Netconf conference.

Thanks,
Jakub

[1] https://netdevconf.org/0x13/session.html?panel-industry-perspectives
[2] https://blog.cloudflare.com/how-we-built-spectrum/
[3] https://www.spinics.net/lists/netdev/msg370789.html


Jakub Sitnicki (7):
  bpf: Introduce inet_lookup program type
  ipv4: Run inet_lookup bpf program on socket lookup
  ipv6: Run inet_lookup bpf program on socket lookup
  bpf: Sync linux/bpf.h to tools/
  libbpf: Add support for inet_lookup program type
  bpf: Test destination address remapping with inet_lookup
  bpf: Add verifier tests for inet_lookup context access

 include/linux/bpf_types.h                     |   1 +
 include/linux/filter.h                        |  17 +
 include/net/inet6_hashtables.h                |  39 ++
 include/net/inet_hashtables.h                 |  39 ++
 include/net/net_namespace.h                   |   3 +
 include/uapi/linux/bpf.h                      |  27 +
 kernel/bpf/syscall.c                          |  10 +
 net/core/filter.c                             | 216 ++++++++
 net/ipv4/inet_hashtables.c                    |  11 +-
 net/ipv4/udp.c                                |   1 +
 net/ipv6/inet6_hashtables.c                   |  11 +-
 net/ipv6/udp.c                                |   6 +-
 tools/include/uapi/linux/bpf.h                |  27 +
 tools/lib/bpf/libbpf.c                        |   4 +
 tools/lib/bpf/libbpf.h                        |   2 +
 tools/lib/bpf/libbpf.map                      |   2 +
 tools/lib/bpf/libbpf_probes.c                 |   1 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   6 +-
 .../selftests/bpf/progs/inet_lookup_prog.c    |  68 +++
 .../testing/selftests/bpf/test_inet_lookup.c  | 392 ++++++++++++++
 .../testing/selftests/bpf/test_inet_lookup.sh |  35 ++
 .../selftests/bpf/verifier/ctx_inet_lookup.c  | 511 ++++++++++++++++++
 23 files changed, 1418 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/inet_lookup_prog.c
 create mode 100644 tools/testing/selftests/bpf/test_inet_lookup.c
 create mode 100755 tools/testing/selftests/bpf/test_inet_lookup.sh
 create mode 100644 tools/testing/selftests/bpf/verifier/ctx_inet_lookup.c

-- 
2.20.1

