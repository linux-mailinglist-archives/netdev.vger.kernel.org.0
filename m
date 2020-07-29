Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35632326A4
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgG2VM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:12:58 -0400
Received: from mail.efficios.com ([167.114.26.124]:33320 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgG2VM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 17:12:58 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id E8A602A579A;
        Wed, 29 Jul 2020 17:12:56 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZwQr0TonsNU0; Wed, 29 Jul 2020 17:12:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A2F892A5E0B;
        Wed, 29 Jul 2020 17:12:56 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com A2F892A5E0B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1596057176;
        bh=gt3bVhTf4NH8xJJdNbMFxQ+mzNS6Qgctt02qgftClfg=;
        h=From:To:Date:Message-Id;
        b=E5oF6wmDEW195Nnbqp/abwNLagRdwGAU1SkSaoXelIsW/W/EIFwG8YVNT7Cudnn0w
         r99cd7VtNDhrzddUtYO4IPG//mPqOogs19kwO/ctXT7Kb6hkwI6AX5PGFT9ol8MYEL
         ay2wK8ZLXMN9vO5EUNm8HQyH94k4LsN5mBLDLJBtcfXqR6jM771J6vZcGwmslRM0JC
         tzpH6/HgTFd62W014nSoyy4ccgKUZZY8KH8o3fLPnh9sAxhI7W5swBJ8xrcPcDcdD1
         AgeI2ICz1Yldx1OxrUguvrWRXaER6LU3zVKri9HbxRsf9qE1YsWt1nQmgX8FZxxFFQ
         zhcqRBwXRKkBg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id v4D23FbX4-eV; Wed, 29 Jul 2020 17:12:56 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 560292A5C33;
        Wed, 29 Jul 2020 17:12:56 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsa@cumulusnetworks.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [RFC PATCH 3/3] ipv6/icmp: l3mdev: Perform icmp error route lookup on source device routing table
Date:   Wed, 29 Jul 2020 17:12:48 -0400
Message-Id: <20200729211248.10146-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200729211248.10146-1-mathieu.desnoyers@efficios.com>
References: <20200729211248.10146-1-mathieu.desnoyers@efficios.com>
Sender: netdev-owner@vger.kernel.org
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

Preferably use the source device routing table when sending ICMPv6 error
messages. If no source device is set, fall-back on the destination
device routing table.

Link: https://tools.ietf.org/html/rfc4443
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Ahern <dsa@cumulusnetworks.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 net/ipv6/icmp.c       | 15 +++++++++++++--
 net/ipv6/ip6_output.c |  2 --
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 9df8737ae0d3..beee93065688 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -501,8 +501,19 @@ static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	if (__ipv6_addr_needs_scope_id(addr_type)) {
 		iif = icmp6_iif(skb);
 	} else {
-		dst = skb_dst(skb);
-		iif = l3mdev_master_ifindex(dst ? dst->dev : skb->dev);
+		struct net_device *route_lookup_dev = NULL;
+
+		/*
+		 * The device used for looking up which routing table to use is
+		 * preferably the source whenever it is set, which should
+		 * ensure the icmp error can be sent to the source host, else
+		 * fallback on the destination device.
+		 */
+		if (skb->dev)
+			route_lookup_dev = skb->dev;
+		else if (skb_dst(skb))
+			route_lookup_dev = skb_dst(skb)->dev;
+		iif = l3mdev_master_ifindex(route_lookup_dev);
 	}
 
 	/*
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8a8c2d0cfcc8..00243d7d276c 100644
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

