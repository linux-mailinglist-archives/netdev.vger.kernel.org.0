Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B586546D8B
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbfFOBcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:32:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfFOBcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 21:32:54 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 28F4F81DE9;
        Sat, 15 Jun 2019 01:32:44 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A33D35C542;
        Sat, 15 Jun 2019 01:32:39 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v4 0/8] Fix listing (IPv4, IPv6) and flushing (IPv6) of cached route exceptions
Date:   Sat, 15 Jun 2019 03:32:08 +0200
Message-Id: <cover.1560561432.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Sat, 15 Jun 2019 01:32:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For IPv6 cached routes, the commands 'ip -6 route list cache' and
'ip -6 route flush cache' don't work at all after route exceptions have
been moved to a separate hash table in commit 2b760fcf5cfb ("ipv6: hook
up exception table to store dst cache").

For IPv4 cached routes, the command 'ip route list cache' has also
stopped working in kernel 3.5 after commit 4895c771c7f0 ("ipv4: Add FIB
nexthop exceptions.") introduced storage for route exceptions as a
separate entity.

Fix this by allowing userspace to clearly request cached routes with
the RTM_F_CLONED flag used as a filter (in conjuction with strict
checking or NLM_F_MATCH) and by retrieving and dumping cached routes
if requested.

I'm submitting this for net as these changes fix rather relevant
breakages. However, the scope might be a bit broad, and said breakages
have been introduced 7 and 2 years ago, respectively, for IPv4 and IPv6.
Let me know if I should rebase this on net-next instead.

For IPv4, cache flushing uses a completely different mechanism, so it
wasn't affected. Listing of exception routes (modified routes pre-3.5) was
tested against these versions of kernel and iproute2:

                    iproute2
kernel         4.14.0   4.15.0   4.19.0   5.0.0   5.1.0
 3.5-rc4         +        +        +        +       +
 4.4
 4.9
 4.14
 4.15
 4.19
 5.0
 5.1
 fixed           +        +        +        +       +


For IPv6, a separate iproute2 patch is required. Versions of iproute2
and kernel tested:

                    iproute2
kernel             4.14.0   4.15.0   4.19.0   5.0.0   5.1.0    5.1.0, patched
 3.18    list        +        +        +        +       +            +
         flush       +        +        +        +       +            +
 4.4     list        +        +        +        +       +            +
         flush       +        +        +        +       +            +
 4.9     list        +        +        +        +       +            +
         flush       +        +        +        +       +            +
 4.14    list        +        +        +        +       +            +
         flush       +        +        +        +       +            +
 4.15    list
         flush
 4.19    list
         flush
 5.0     list
         flush
 5.1     list
         flush
 with    list        +        +        +        +       +            +
 fix     flush                                                       +


v4: Fix the listing issue also for IPv4, making the behaviour consistent
    with IPv6. Honour NLM_F_MATCH as per RFC 3549 and allow usage of
    RTM_F_CLONED filter. Split patches into smaller logical changes.

v3: Drop check on RTM_F_CLONED and rework logic of return values of
    rt6_dump_route()

v2: Add count of routes handled in partial dumps, and skip them, in patch 1/2.
*** BLURB HERE ***

Stefano Brivio (8):
  ipv4/fib_frontend: Rename ip_valid_fib_dump_req, provide non-strict
    version
  ipv4: Honour NLM_F_MATCH, make semantics of NETLINK_GET_STRICT_CHK
    consistent
  ipv4/fib_frontend: Allow RTM_F_CLONED flag to be used for filtering
  ipv4: Dump routed caches if requested
  Revert "net/ipv6: Bail early if user only wants cloned entries"
  ipv6: Honour NLM_F_MATCH, make semantics of NETLINK_GET_STRICT_CHK
    consistent
  ipv6: Dump route exceptions too in rt6_dump_route()
  ip6_fib: Don't discard nodes with valid routing information in
    fib6_locate_1()

 include/net/ip6_fib.h   |   1 +
 include/net/ip6_route.h |   2 +-
 include/net/ip_fib.h    |   6 +--
 include/net/route.h     |   3 ++
 net/ipv4/fib_frontend.c |  50 ++++++++++++-------
 net/ipv4/fib_trie.c     | 103 +++++++++++++++++++++++++++++++++++-----
 net/ipv4/ipmr.c         |   4 +-
 net/ipv4/route.c        |   6 +--
 net/ipv6/ip6_fib.c      |  37 ++++++++++-----
 net/ipv6/ip6mr.c        |   4 +-
 net/ipv6/route.c        |  74 ++++++++++++++++++++++++++---
 net/mpls/af_mpls.c      |   2 +-
 12 files changed, 230 insertions(+), 62 deletions(-)

-- 
2.20.1

