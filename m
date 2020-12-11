Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB50B2D72CA
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 10:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405618AbgLKJ2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 04:28:31 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18767 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404425AbgLKJ1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 04:27:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607678873; x=1639214873;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GyMmX3D/jsJ9E6NpxK0JHdKPYb1uHzNbBgKwWLSpo6s=;
  b=v9SKh+uNqrHXszmhpuJa60/l8blbksd8BSnj+r+3svX+rZTliH7pfgfh
   ee3UrjQioIucqP7jqVkXMxsRR4qtydIet85JNyaK/oq2Xi7huqlsXlnHZ
   dBfE959JHACUE578RFhWqThCwXavvo75EEyEkrMuOpvC7hQyu59C3BmeS
   Bd+uADpTYRO3sNoZ4PbNRrqA1Wf21t5w40B07lPd6hLTcT92+gnNdl3Em
   kTA0yA3dnHp3MD6skcvaMeMJ4MA44OnQljofGm9nYYkcnwOTlTrgv+UK8
   xnz4d/f5EXV/Bl5kUP12pFO/gbtO4hVnIUHAifX2lf0bm8eBb/7+5SJRF
   A==;
IronPort-SDR: 6bbgw3ZaRcyLYoY+nUL+/4xfc6wypDm6fdcfk3/QHuR88R1VcfjCUeXLau1+AqPG2ba+bUZ0jS
 7XS7Rfl5zsx+EQG2vDWYHARPv1YNYLvhtfptoEM1DzFv+iRe8Jg6DpJNJ1Sd16fFN7T9ejXLVv
 0SthXPIqVqHrMSdpU6f5QpuiBev9q+E/eHTXCXjHytn0CDHB6obPg24enuJ+P5KuJfeFYByyQJ
 WgMzavb0Hd8tVlLmUUIRfsu4tUFUn/h+gR1FfVGHV8gbu0ABSOi/z7N8/FH6BQSfM0PBU3Jxa3
 NJM=
X-IronPort-AV: E=Sophos;i="5.78,410,1599548400"; 
   d="scan'208";a="96746864"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Dec 2020 02:26:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Dec 2020 02:26:33 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 11 Dec 2020 02:26:31 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@nvidia.com>, <roopa@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <bridge@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <allan.nielsen@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next] net: bridge: igmp: Extend IGMP query with vlan support
Date:   Fri, 11 Dec 2020 10:26:26 +0100
Message-ID: <20201211092626.809206-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch tries to add vlan support to IGMP queries.
It extends the function 'br_ip4_multicast_alloc_query' to add
also a vlan tag if vlan is enabled. Therefore the bridge will send
queries for each vlan the ports are in.

There are few other places that needs to be updated to be fully
functional. But I am curious if this is the way to go forward or is
there a different way of implementing this?

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_multicast.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 484820c223a3..4c2db8a9efe0 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -688,7 +688,8 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 						    __be32 ip_dst, __be32 group,
 						    bool with_srcs, bool over_lmqt,
 						    u8 sflag, u8 *igmp_type,
-						    bool *need_rexmit)
+						    bool *need_rexmit,
+						    __u16 vid)
 {
 	struct net_bridge_port *p = pg ? pg->key.port : NULL;
 	struct net_bridge_group_src *ent;
@@ -724,6 +725,9 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 	}
 
 	pkt_size = sizeof(*eth) + sizeof(*iph) + 4 + igmp_hdr_size;
+	if (br_vlan_enabled(br->dev) && vid != 0)
+		pkt_size += 4;
+
 	if ((p && pkt_size > p->dev->mtu) ||
 	    pkt_size > br->dev->mtu)
 		return NULL;
@@ -732,6 +736,9 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 	if (!skb)
 		goto out;
 
+	if (br_vlan_enabled(br->dev) && vid != 0)
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
+
 	skb->protocol = htons(ETH_P_IP);
 
 	skb_reset_mac_header(skb);
@@ -1008,7 +1015,8 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 						    ip4_dst, group->dst.ip4,
 						    with_srcs, over_lmqt,
 						    sflag, igmp_type,
-						    need_rexmit);
+						    need_rexmit,
+						    group->vid);
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6): {
 		struct in6_addr ip6_dst;
@@ -1477,6 +1485,8 @@ static void br_multicast_send_query(struct net_bridge *br,
 				    struct bridge_mcast_own_query *own_query)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
 	struct br_ip br_group;
 	unsigned long time;
 
@@ -1485,7 +1495,7 @@ static void br_multicast_send_query(struct net_bridge *br,
 	    !br_opt_get(br, BROPT_MULTICAST_QUERIER))
 		return;
 
-	memset(&br_group.dst, 0, sizeof(br_group.dst));
+	memset(&br_group, 0, sizeof(br_group));
 
 	if (port ? (own_query == &port->ip4_own_query) :
 		   (own_query == &br->ip4_own_query)) {
@@ -1501,8 +1511,19 @@ static void br_multicast_send_query(struct net_bridge *br,
 	if (!other_query || timer_pending(&other_query->timer))
 		return;
 
-	__br_multicast_send_query(br, port, NULL, NULL, &br_group, false, 0,
-				  NULL);
+	if (br_vlan_enabled(br->dev) && port) {
+		vg = nbp_vlan_group(port);
+
+		list_for_each_entry(v, &vg->vlan_list, vlist) {
+			br_group.vid = v->vid == vg->pvid ? 0 : v->vid;
+
+			__br_multicast_send_query(br, port, NULL, NULL,
+						  &br_group, false, 0, NULL);
+		}
+	} else {
+		__br_multicast_send_query(br, port, NULL, NULL, &br_group,
+					  false, 0, NULL);
+	}
 
 	time = jiffies;
 	time += own_query->startup_sent < br->multicast_startup_query_count ?
-- 
2.27.0

