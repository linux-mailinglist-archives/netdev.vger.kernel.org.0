Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE9F37EFD5
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbhELX0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 19:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbhELXVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 19:21:11 -0400
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64AFC06174A;
        Wed, 12 May 2021 16:19:59 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DC7C03E942;
        Thu, 13 May 2021 01:19:57 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [net-next v3 11/11] net: bridge: mcast: export multicast router presence adjacent to a port
Date:   Thu, 13 May 2021 01:19:41 +0200
Message-Id: <20210512231941.19211-12-linus.luessing@c0d3.blue>
In-Reply-To: <20210512231941.19211-1-linus.luessing@c0d3.blue>
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To properly support routable multicast addresses in batman-adv in a
group-aware way, a batman-adv node needs to know if it serves multicast
routers.

This adds a function to the bridge to export this so that batman-adv
can then make full use of the Multicast Router Discovery capability of
the bridge.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 include/linux/if_bridge.h |  8 ++++++
 net/bridge/br_multicast.c | 55 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 2cc3503..12e9a32 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -67,6 +67,7 @@ int br_multicast_list_adjacent(struct net_device *dev,
 			       struct list_head *br_ip_list);
 bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto);
 bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto);
+bool br_multicast_has_router_adjacent(struct net_device *dev, int proto);
 bool br_multicast_enabled(const struct net_device *dev);
 bool br_multicast_router(const struct net_device *dev);
 int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
@@ -87,6 +88,13 @@ static inline bool br_multicast_has_querier_adjacent(struct net_device *dev,
 {
 	return false;
 }
+
+static inline bool br_multicast_has_router_adjacent(struct net_device *dev,
+						    int proto)
+{
+	return true;
+}
+
 static inline bool br_multicast_enabled(const struct net_device *dev)
 {
 	return false;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 4448490..fe21f52 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4061,6 +4061,61 @@ unlock:
 }
 EXPORT_SYMBOL_GPL(br_multicast_has_querier_adjacent);
 
+/**
+ * br_multicast_has_router_adjacent - Checks for a router behind a bridge port
+ * @dev: The bridge port adjacent to which to check for a multicast router
+ * @proto: The protocol family to check for: IGMP -> ETH_P_IP, MLD -> ETH_P_IPV6
+ *
+ * Checks whether the given interface has a bridge on top and if so returns
+ * true if a multicast router is behind one of the other ports of this
+ * bridge. Otherwise returns false.
+ */
+bool br_multicast_has_router_adjacent(struct net_device *dev, int proto)
+{
+	struct net_bridge_port *port, *p;
+	bool ret = false;
+
+	rcu_read_lock();
+	port = br_port_get_check_rcu(dev);
+	if (!port)
+		goto unlock;
+
+	switch (proto) {
+	case ETH_P_IP:
+		hlist_for_each_entry_rcu(p, &port->br->ip4_mc_router_list,
+					 ip4_rlist) {
+			if (p == port)
+				continue;
+
+			ret = true;
+			goto unlock;
+		}
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case ETH_P_IPV6:
+		hlist_for_each_entry_rcu(p, &port->br->ip6_mc_router_list,
+					 ip6_rlist) {
+			if (p == port)
+				continue;
+
+			ret = true;
+			goto unlock;
+		}
+		break;
+#endif
+	default:
+		/* when compiled without IPv6 support, be conservative and
+		 * always assume presence of an IPv6 multicast router
+		 */
+		ret = true;
+	}
+
+unlock:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(br_multicast_has_router_adjacent);
+
 static void br_mcast_stats_add(struct bridge_mcast_stats __percpu *stats,
 			       const struct sk_buff *skb, u8 type, u8 dir)
 {
-- 
2.31.0

