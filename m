Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CC64A1EF
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfFRNUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:20:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbfFRNUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:20:48 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DE520300181C;
        Tue, 18 Jun 2019 13:20:47 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E50025C660;
        Tue, 18 Jun 2019 13:20:44 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v5 0/6] Fix listing (IPv4, IPv6) and flushing (IPv6) of cached route exceptions
Date:   Tue, 18 Jun 2019 15:20:33 +0200
Message-Id: <cover.1560827176.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 18 Jun 2019 13:20:47 +0000 (UTC)
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
checking) and by retrieving and dumping cached routes if requested.

If strict checking is not requested (iproute2 < 5.0.0), we don't have a
way to consistently filter results on other selectors (e.g. on tables),
so skip filtering entirely and dump both regular routes and exceptions.

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
 fix     flush       +        +        +                             +

v5: Skip filtering altogether if no strict checking is requested: selecting
    routes or exceptions only would be inconsistent with the fact we can't
    filter on tables. Drop 1/8 (non-strict dump filter function no longer
    needed), replace 2/8 (don't use NLM_F_MATCH, decide to skip routes or
    exceptions in filter function), drop 6/8 (2/8 is enough for IPv6 too).
    Introduce dump_routes and dump_exceptions flags in filter, adapt other
    patches to that.

v4: Fix the listing issue also for IPv4, making the behaviour consistent
    with IPv6. Honour NLM_F_MATCH as per RFC 3549 and allow usage of
    RTM_F_CLONED filter. Split patches into smaller logical changes.

v3: Drop check on RTM_F_CLONED and rework logic of return values of
    rt6_dump_route()

v2: Add count of routes handled in partial dumps, and skip them, in patch 1/2.

Stefano Brivio (6):
  fib_frontend, ip6_fib: Select routes or exceptions dump from
    RTM_F_CLONED
  ipv4/fib_frontend: Allow RTM_F_CLONED flag to be used for filtering
  ipv4: Dump route exceptions if requested
  Revert "net/ipv6: Bail early if user only wants cloned entries"
  ipv6: Dump route exceptions if requested
  ip6_fib: Don't discard nodes with valid routing information in
    fib6_locate_1()

 include/net/ip6_fib.h   |   1 +
 include/net/ip6_route.h |   2 +-
 include/net/ip_fib.h    |   2 +
 include/net/route.h     |   3 ++
 net/ipv4/fib_frontend.c |  12 +++--
 net/ipv4/fib_trie.c     | 101 +++++++++++++++++++++++++++++++++++-----
 net/ipv4/route.c        |   6 +--
 net/ipv6/ip6_fib.c      |  27 +++++++----
 net/ipv6/route.c        |  85 ++++++++++++++++++++++++++++-----
 9 files changed, 199 insertions(+), 40 deletions(-)

-- 
2.20.1

