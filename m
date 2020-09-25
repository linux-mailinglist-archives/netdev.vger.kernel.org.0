Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6A727920B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgIYUdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:33:12 -0400
Received: from mail.efficios.com ([167.114.26.124]:50758 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbgIYUUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 16:20:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 30D382D1ADB;
        Fri, 25 Sep 2020 16:05:00 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id sk2Ybp6UR8WG; Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 8DB572D1A6A;
        Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 8DB572D1A6A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1601064299;
        bh=yrIS8m3rknvWl9hL7dggbRVvRNlMDfO6Jcr+vUoXE2M=;
        h=From:To:Date:Message-Id;
        b=O00q3CG1AzTRajoVJQQJ6s0DiWmpafLjvuxywMG3b8XFhDnx6W9QAHN+qmB4xj4Dn
         V0uwYlZPGeakNqkdoECu0jDAO+VnYZaprUMWs/kpNuE9yWrmFa3QJwRG+gb4uj9dTL
         Ot6Ro5/t/NEwKU44iRKma6OOVIDvwKV1iLwsWODOEfW+IKgo4e5qy0phhTbpfPdqei
         AoxRMvadGCqoJLHIVA8yv+RDg++3DkFA0mIyVSf20CmeIvmwEMuABz43MfQtY7C85d
         KpDP61UOf6DT+j2SDlZsAzz55RUcC8yeIQ3/zq58Jn50KQEPeVwAkS7Jc2yrwNZG2I
         Rh8aYp6Z8g+/A==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id j_hJPL4vaurz; Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 5F38D2D1652;
        Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Michael Jeanson <mjeanson@efficios.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH 2/3] ipv6/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)
Date:   Fri, 25 Sep 2020 16:04:51 -0400
Message-Id: <20200925200452.2080-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200925200452.2080-1-mathieu.desnoyers@efficios.com>
References: <20200925200452.2080-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per RFC4443, the destination address field for ICMPv6 error messages
is copied from the source address field of the invoking packet.

In configurations with Virtual Routing and Forwarding tables, looking up
which routing table to use for sending ICMPv6 error messages is
currently done by using the destination net_device.

If the source and destination interfaces are within separate VRFs, or
one in the global routing table and the other in a VRF, looking up the
source address of the invoking packet in the destination interface's
routing table will fail if the destination interface's routing table
contains no route to the invoking packet's source address.

One observable effect of this issue is that traceroute6 does not work in
the following cases:

- Route leaking between global routing table and VRF
- Route leaking between VRFs

Use the source device routing table when sending ICMPv6 error
messages.

[ In the context of ipv4, it has been pointed out that a similar issue
  may exist with ICMP errors triggered when forwarding between network
  namespaces. It would be worthwhile to investigate whether ipv6 has
  similar issues, but is outside of the scope of this investigation. ]

[ Testing shows that similar issues exist with ipv6 unreachable /
  fragmentation needed messages.  However, investigation of this
  additional failure mode is beyond this investigation's scope. ]

Link: https://tools.ietf.org/html/rfc4443
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
Changes since v1:
- Introduce icmp6_get_route_lookup_dev.
- Use skb->dev for routing table lookup, because it is guaranteed to be
  non-NULL.
---
 net/ipv6/icmp.c       | 7 +++++--
 net/ipv6/ip6_output.c | 2 --
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index a4e4912ad607..91209a2760aa 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -501,8 +501,11 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	if (__ipv6_addr_needs_scope_id(addr_type)) {
 		iif = icmp6_iif(skb);
 	} else {
-		dst = skb_dst(skb);
-		iif = l3mdev_master_ifindex(dst ? dst->dev : skb->dev);
+		/*
+		 * The source device is used for looking up which routing table
+		 * to use for sending an ICMP error.
+		 */
+		iif = l3mdev_master_ifindex(skb->dev);
 	}
 
 	/*
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c78e67d7747f..cd623068de53 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -468,8 +468,6 @@ int ip6_forward(struct sk_buff *skb)
 	 *	check and decrement ttl
 	 */
 	if (hdr->hop_limit <= 1) {
-		/* Force OUTPUT device used as source address */
-		skb->dev = dst->dev;
 		icmpv6_send(skb, ICMPV6_TIME_EXCEED, ICMPV6_EXC_HOPLIMIT, 0);
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
 
-- 
2.17.1

