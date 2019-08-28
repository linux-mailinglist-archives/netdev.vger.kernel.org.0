Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A819FB75
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfH1HW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:22:56 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38172 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfH1HWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:22:55 -0400
Received: by mail-lf1-f68.google.com with SMTP id c12so1236126lfh.5
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=095Hu7dvtdB4T1s4IQFBQWtbFveYiA+Tv6pUB2rK3XQ=;
        b=HyXgiB7XwN5k7cZkuQ+hY4O2lQB9dZsiDCE4w1dFEJYKlc+scKCt/fwOSz/ILb9bsN
         UT5N4yxmfdzQVb7FFkXIQYzajv+qiXLcjN7STcJIemPwYWzcT2tKki/jomm2ts/CxI7e
         MLXAmbI9zmwqAoOAndSjiaubfjZriCbE/ubSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=095Hu7dvtdB4T1s4IQFBQWtbFveYiA+Tv6pUB2rK3XQ=;
        b=YJDcsXHxxZUf7AwbvAakRUwYQMWVOxO7zTCFEuBDcIcvhkgBoZdMTkagXJ0BO9HwoR
         25ww8cME83BO7/C6Al/hPxK+xO77CNjd6C7T1e4guKTcIcUxSnnNk8mRJtgMn0stsht3
         ysDWQG6Yyt8XX7r3AHfRiTOs37tsifFP5N2MIuR+gL5z26Oh5YSy3NHwNfRZWdIx1bt7
         rolLzXzQ+olTddzU815LWopKxoUH+u2VXok8QY84D23EFYakC9eAHRFiQuU2ZWgCmfzA
         zAfiK1W0qCHc96nDPp39T8MAkKtiKzhRCYUknVMyJJfviGoFbPF+dAVsJSRmr0Z4RtOd
         TjhQ==
X-Gm-Message-State: APjAAAW4gJz+2FU3S04t7bWJczZsqEcFUkE4DjnUdUL5EwLxqb+Y9lWk
        T43PZAif1orh8y7Rk6V4532uKg==
X-Google-Smtp-Source: APXvYqz1FugCrzsZ/nST7XVxhdGCHTQSXdYNZn5OGkOa6u/e4XovZZNV8rrqLqnWN6Dhr6EIvXSKgA==
X-Received: by 2002:ac2:484b:: with SMTP id 11mr1676709lfy.156.1566976972113;
        Wed, 28 Aug 2019 00:22:52 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id s21sm418079ljm.28.2019.08.28.00.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:22:51 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [RFCv2 bpf-next 00/12] Programming socket lookup with BPF
Date:   Wed, 28 Aug 2019 09:22:38 +0200
Message-Id: <20190828072250.29828-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds a mechanism for programming mappings between the local
addresses and listening/receiving sockets with BPF.

It introduces a new per-netns BPF program type, called inet_lookup, which
runs during the socket lookup. The program is allowed to select a
listening/receiving socket from a SOCKARRAY map that the packet will be
delivered to.

BPF inet_lookup intends to be an alternative for:

* SO_BINDTOPREFIX [1] - a mechanism that provides a way to listen/receive
  on all local addresses that belong to a network prefix. An alternative to
  binding to INADDR_ANY that allows applications bound to disjoint network
  prefixes to share a port. Not generic. Never got upstreamed.

* TPROXY [2] - a powerful mechanism that allows steering packets destined
  to non-local addresses to a local socket. It also works for local
  addresses, which is a less restrictive case. Can be used to implement
  what SO_BINDTOPREFIX does, and more - in particular, all ports can be
  redirected to a single socket. Socket dispatch happens early in ingress
  path (PREROUTING hook). Versatile but comes with complexities.

Compared to the above, inet_lookup aims to be a programmatic way to map
(address, port) pairs to a socket. It runs after a routing decision for
local delivery was made, and hence is limited to local addresses only.

Being part of the socket lookup, has a desired effect that redirection is
visible to XDP programs which call bpf_sk_lookup helpers.

When it comes to use cases, we have presented them in RFCv1 [3] cover
letter and also at last Netconf [4]. To recap, they are:

1) sharing a port between two services

   Services are accepting connections on different (disjoint) IP ranges but
   same port. Requests going to 192.0.2.0/24 tcp/80 are handled by NGINX,
   while 198.51.100.0/24 tcp/80 IP range is handled by Apache server.
   Applications are running as different users, in a flat single-netns
   setup.

2) receiving traffic on all ports

   We have a proxy server that accepts connections to _any_ port [5].

A simple demo program that implements (1) could look like

#define NET1 (IP4(192,  0,   2, 0) >> 8)
#define NET2 (IP4(198, 51, 100, 0) >> 8)

#define MAX_SERVERS 2

struct {
	__uint(type, BPF_MAP_TYPE_REUSEPORT_SOCKARRAY);
	__uint(max_entries, MAX_SERVERS);
	__type(key, __u32);
	__type(value, __u64);
} redir_map SEC(".maps");

SEC("inet_lookup/demo_two_servers")
int demo_two_http_servers(struct bpf_inet_lookup *ctx)
{
	__u32 index = 0;
	__u64 flags = 0;

        if (ctx->family != AF_INET)
                return BPF_OK;
	if (ctx->protocol != IPPROTO_TCP)
		return BPF_OK;
        if (ctx->local_port != 80)
                return BPF_OK;

        switch (bpf_ntohl(ctx->local_ip4) >> 8) {
        case NET1:
		index = 0;
		break;
        case NET2:
		index = 1;
		break;
	default:
		return BPF_OK;
        }

        return bpf_redirect_lookup(ctx, &redir_map, &index, flags);
}

Since RFCv1, we've changed the approach from rewriting the lookup key to
map-based redirection. This has been suggested at Netconf, and is a
recurring pattern in existing BPF program types.

We're posting the 2nd version of RFC patch set to collect further feedback
and set context for the presentation and discussions at the upcoming
Network Summit at LPC '19 [6].

Patches are also available on GitHub [7].

Thanks,
Jakub

[1] https://www.spinics.net/lists/netdev/msg370789.html
[2] https://www.kernel.org/doc/Documentation/networking/tproxy.txt
[3] https://lore.kernel.org/netdev/20190618130050.8344-1-jakub@cloudflare.com/
[4] http://vger.kernel.org/netconf2019_files/Programmable%20socket%20lookup.pdf
[5] https://blog.cloudflare.com/how-we-built-spectrum/
[6] https://linuxplumbersconf.org/event/4/contributions/487/
[7] https://github.com/jsitnicki/linux/commits/bpf-inet-lookup

Changes RFCv1 -> RFCv2:

- Make socket lookup redirection map-based. BPF program now uses a
  dedicated helper and a SOCKARRAY map to select the socket to redirect to.
  A consequence of this change is that bpf_inet_lookup context is now
  read-only.

- Look for connected UDP sockets before allowing redirection from BPF.
  This makes connected UDP socket work as expected in the presence of
  inet_lookup prog.

- Share the code for BPF_PROG_{ATTACH,DETACH,QUERY} with flow_dissector,
  the only other per-netns BPF prog type.


Jakub Sitnicki (12):
  flow_dissector: Extract attach/detach/query helpers
  bpf: Introduce inet_lookup program type for redirecting socket lookup
  bpf: Add verifier tests for inet_lookup context access
  inet: Store layer 4 protocol in inet_hashinfo
  udp: Store layer 4 protocol in udp_table
  inet: Run inet_lookup bpf program on socket lookup
  inet6: Run inet_lookup bpf program on socket lookup
  udp: Run inet_lookup bpf program on socket lookup
  udp6: Run inet_lookup bpf program on socket lookup
  bpf: Sync linux/bpf.h to tools/
  libbpf: Add support for inet_lookup program type
  bpf: Test redirecting listening/receiving socket lookup

 include/linux/bpf.h                           |   8 +
 include/linux/bpf_types.h                     |   1 +
 include/linux/filter.h                        |  18 +
 include/net/inet6_hashtables.h                |  19 +
 include/net/inet_hashtables.h                 |  36 +
 include/net/net_namespace.h                   |   2 +
 include/net/udp.h                             |  10 +-
 include/uapi/linux/bpf.h                      |  58 +-
 kernel/bpf/syscall.c                          |  10 +
 kernel/bpf/verifier.c                         |   7 +-
 net/core/filter.c                             | 304 ++++++++
 net/core/flow_dissector.c                     |  65 +-
 net/dccp/proto.c                              |   2 +-
 net/ipv4/inet_hashtables.c                    |   5 +
 net/ipv4/tcp_ipv4.c                           |   2 +-
 net/ipv4/udp.c                                |  59 +-
 net/ipv4/udp_impl.h                           |   2 +-
 net/ipv4/udplite.c                            |   4 +-
 net/ipv6/inet6_hashtables.c                   |   5 +
 net/ipv6/udp.c                                |  54 +-
 net/ipv6/udp_impl.h                           |   2 +-
 net/ipv6/udplite.c                            |   2 +-
 tools/include/uapi/linux/bpf.h                |  58 +-
 tools/lib/bpf/libbpf.c                        |   4 +
 tools/lib/bpf/libbpf.h                        |   2 +
 tools/lib/bpf/libbpf.map                      |   2 +
 tools/lib/bpf/libbpf_probes.c                 |   1 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
 .../selftests/bpf/progs/inet_lookup_progs.c   |  78 ++
 .../testing/selftests/bpf/test_inet_lookup.c  | 522 +++++++++++++
 .../testing/selftests/bpf/test_inet_lookup.sh |  35 +
 .../selftests/bpf/verifier/ctx_inet_lookup.c  | 696 ++++++++++++++++++
 34 files changed, 1974 insertions(+), 108 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/inet_lookup_progs.c
 create mode 100644 tools/testing/selftests/bpf/test_inet_lookup.c
 create mode 100755 tools/testing/selftests/bpf/test_inet_lookup.sh
 create mode 100644 tools/testing/selftests/bpf/verifier/ctx_inet_lookup.c

-- 
2.20.1

