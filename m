Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864D72792CE
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgIYVAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:00:09 -0400
Received: from mail.efficios.com ([167.114.26.124]:36158 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgIYVAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:00:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id EE0052D1ADA;
        Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id spLe2dxU-C2P; Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 626DC2D1D08;
        Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 626DC2D1D08
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1601064299;
        bh=BuUEY6vVZAx7YvCmo3Gcuwe0FMd/Hehs/wIysAuLkpc=;
        h=From:To:Date:Message-Id;
        b=gwvCmoyOKCMoiKB6PUp4JxxFq+dANciTgnVnrnRNKpjjfpZXWrI8G7HNKaHk8Emvm
         7guySPJWS0bBKExv9WCxe4lmuVKfhfjbwGwC691+V1fTGjdrAcG4ksilxKgaqY9YtE
         2WTrSu9vqZXX/nDsEGrNDiSWb5fj+B6HEVePiXRXiQ6iEmZZn6e6gQ7+DLgf9DZI5D
         gQXiJuANoZtCDpeUrsDAgkUimArIvmKYTnvQjoSXa1QBxcyFrgqcgFCmhf8xyrgp3G
         gr4iRGZBpGHv+I7O14KLerfMVTe8cKGSDmP1vFsyhoJ4Y13Cgmdyv2XrTr2z6doCr2
         kR97WakZMTlrw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QncIDgrZ3d6M; Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 3CB4F2D1651;
        Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Michael Jeanson <mjeanson@efficios.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH 1/3] ipv4/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)
Date:   Fri, 25 Sep 2020 16:04:50 -0400
Message-Id: <20200925200452.2080-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200925200452.2080-1-mathieu.desnoyers@efficios.com>
References: <20200925200452.2080-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per RFC792, ICMP errors should be sent to the source host.

However, in configurations with Virtual Routing and Forwarding tables,
looking up which routing table to use is currently done by using the
destination net_device.

commit 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to
determine L3 domain") changes the interface passed to
l3mdev_master_ifindex() and inet_addr_type_dev_table() from skb_in->dev
to skb_dst(skb_in)->dev. This effectively uses the destination device
rather than the source device for choosing which routing table should be
used to lookup where to send the ICMP error.

Therefore, if the source and destination interfaces are within separate
VRFs, or one in the global routing table and the other in a VRF, looking
up the source host in the destination interface's routing table will
fail if the destination interface's routing table contains no route to
the source host.

One observable effect of this issue is that traceroute does not work in
the following cases:

- Route leaking between global routing table and VRF
- Route leaking between VRFs

Preferably use the source device routing table when sending ICMP error
messages. If no source device is set, fall-back on the destination
device routing table. Else, use the main routing table (index 0).

[ It has been pointed out that a similar issue may exist with ICMP
  errors triggered when forwarding between network namespaces. It would
  be worthwhile to investigate, but is outside of the scope of this
  investigation. ]

[ It has also been pointed out that a similar issue exists with
  unreachable / fragmentation needed messages, which can be triggered by
  changing the MTU of eth1 in r1 to 1400 and running:

  ip netns exec h1 ping -s 1450 -Mdo -c1 172.16.2.2

  Some investigation points to raw_icmp_error() and raw_err() as being
  involved in this last scenario. The focus of this patch is TTL expired
  ICMP messages, which go through icmp_route_lookup.
  Investigation of failure modes related to raw_icmp_error() is beyond
  this investigation's scope. ]

Fixes: 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to determine L3 domain")
Link: https://tools.ietf.org/html/rfc792
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
Changes since v1:
- Introduce icmp_get_route_lookup_dev.
---
 net/ipv4/icmp.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index cf36f955bfe6..9ea66d903c41 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -457,6 +457,23 @@ static void icmp_reply(struct icmp_bxm *icmp_param, struct sk_buff *skb)
 	local_bh_enable();
 }
 
+/*
+ * The device used for looking up which routing table to use for sending an ICMP
+ * error is preferably the source whenever it is set, which should ensure the
+ * icmp error can be sent to the source host, else lookup using the routing
+ * table of the destination device, else use the main routing table (index 0).
+ */
+static struct net_device *icmp_get_route_lookup_dev(struct sk_buff *skb)
+{
+	struct net_device *route_lookup_dev = NULL;
+
+	if (skb->dev)
+		route_lookup_dev = skb->dev;
+	else if (skb_dst(skb))
+		route_lookup_dev = skb_dst(skb)->dev;
+	return route_lookup_dev;
+}
+
 static struct rtable *icmp_route_lookup(struct net *net,
 					struct flowi4 *fl4,
 					struct sk_buff *skb_in,
@@ -465,6 +482,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 					int type, int code,
 					struct icmp_bxm *param)
 {
+	struct net_device *route_lookup_dev;
 	struct rtable *rt, *rt2;
 	struct flowi4 fl4_dec;
 	int err;
@@ -479,7 +497,8 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	fl4->flowi4_proto = IPPROTO_ICMP;
 	fl4->fl4_icmp_type = type;
 	fl4->fl4_icmp_code = code;
-	fl4->flowi4_oif = l3mdev_master_ifindex(skb_dst(skb_in)->dev);
+	route_lookup_dev = icmp_get_route_lookup_dev(skb_in);
+	fl4->flowi4_oif = l3mdev_master_ifindex(route_lookup_dev);
 
 	security_skb_classify_flow(skb_in, flowi4_to_flowi(fl4));
 	rt = ip_route_output_key_hash(net, fl4, skb_in);
@@ -503,7 +522,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	if (err)
 		goto relookup_failed;
 
-	if (inet_addr_type_dev_table(net, skb_dst(skb_in)->dev,
+	if (inet_addr_type_dev_table(net, route_lookup_dev,
 				     fl4_dec.saddr) == RTN_LOCAL) {
 		rt2 = __ip_route_output_key(net, &fl4_dec);
 		if (IS_ERR(rt2))
-- 
2.17.1

