Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC40837F89B
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 15:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhEMNWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 09:22:31 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:52774 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhEMNWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 09:22:18 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2511641009;
        Thu, 13 May 2021 15:21:02 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [net-next v4 04/11] net: bridge: mcast: prepare query reception for mcast router split
Date:   Thu, 13 May 2021 15:20:46 +0200
Message-Id: <20210513132053.23445-5-linus.luessing@c0d3.blue>
In-Reply-To: <20210513132053.23445-1-linus.luessing@c0d3.blue>
References: <20210513132053.23445-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the upcoming split of multicast router state into
their IPv4 and IPv6 variants and as the br_multicast_mark_router() will
be split for that remove the select querier wrapper and instead add
ip4 and ip6 variants for br_multicast_query_received().

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 net/bridge/br_multicast.c | 53 ++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 6fe93a3..7edbbc9 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2615,22 +2615,6 @@ update:
 }
 #endif
 
-static bool br_multicast_select_querier(struct net_bridge *br,
-					struct net_bridge_port *port,
-					struct br_ip *saddr)
-{
-	switch (saddr->proto) {
-	case htons(ETH_P_IP):
-		return br_ip4_multicast_select_querier(br, port, saddr->src.ip4);
-#if IS_ENABLED(CONFIG_IPV6)
-	case htons(ETH_P_IPV6):
-		return br_ip6_multicast_select_querier(br, port, &saddr->src.ip6);
-#endif
-	}
-
-	return false;
-}
-
 static void
 br_multicast_update_query_timer(struct net_bridge *br,
 				struct bridge_mcast_other_query *query,
@@ -2708,19 +2692,36 @@ static void br_multicast_mark_router(struct net_bridge *br,
 		  now + br->multicast_querier_interval);
 }
 
-static void br_multicast_query_received(struct net_bridge *br,
-					struct net_bridge_port *port,
-					struct bridge_mcast_other_query *query,
-					struct br_ip *saddr,
-					unsigned long max_delay)
+static void
+br_ip4_multicast_query_received(struct net_bridge *br,
+				struct net_bridge_port *port,
+				struct bridge_mcast_other_query *query,
+				struct br_ip *saddr,
+				unsigned long max_delay)
 {
-	if (!br_multicast_select_querier(br, port, saddr))
+	if (!br_ip4_multicast_select_querier(br, port, saddr->src.ip4))
 		return;
 
 	br_multicast_update_query_timer(br, query, max_delay);
 	br_multicast_mark_router(br, port);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static void
+br_ip6_multicast_query_received(struct net_bridge *br,
+				struct net_bridge_port *port,
+				struct bridge_mcast_other_query *query,
+				struct br_ip *saddr,
+				unsigned long max_delay)
+{
+	if (!br_ip6_multicast_select_querier(br, port, &saddr->src.ip6))
+		return;
+
+	br_multicast_update_query_timer(br, query, max_delay);
+	br_multicast_mark_router(br, port);
+}
+#endif
+
 static void br_ip4_multicast_query(struct net_bridge *br,
 				   struct net_bridge_port *port,
 				   struct sk_buff *skb,
@@ -2768,8 +2769,8 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 		saddr.proto = htons(ETH_P_IP);
 		saddr.src.ip4 = iph->saddr;
 
-		br_multicast_query_received(br, port, &br->ip4_other_query,
-					    &saddr, max_delay);
+		br_ip4_multicast_query_received(br, port, &br->ip4_other_query,
+						&saddr, max_delay);
 		goto out;
 	}
 
@@ -2856,8 +2857,8 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		saddr.proto = htons(ETH_P_IPV6);
 		saddr.src.ip6 = ipv6_hdr(skb)->saddr;
 
-		br_multicast_query_received(br, port, &br->ip6_other_query,
-					    &saddr, max_delay);
+		br_ip6_multicast_query_received(br, port, &br->ip6_other_query,
+						&saddr, max_delay);
 		goto out;
 	} else if (!group) {
 		goto out;
-- 
2.31.0

