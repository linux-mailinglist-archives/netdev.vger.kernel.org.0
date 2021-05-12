Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A2E37EFD3
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbhELX0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 19:26:11 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:50830 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbhELXVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 19:21:12 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A1D274100C;
        Thu, 13 May 2021 01:19:53 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [net-next v3 07/11] net: bridge: mcast: prepare add-router function for mcast router split
Date:   Thu, 13 May 2021 01:19:37 +0200
Message-Id: <20210512231941.19211-8-linus.luessing@c0d3.blue>
In-Reply-To: <20210512231941.19211-1-linus.luessing@c0d3.blue>
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the upcoming split of multicast router state into
their IPv4 and IPv6 variants move the protocol specific router list
access to an ip4 wrapper function.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 net/bridge/br_multicast.c | 59 +++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 18 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 7815991..1d55709 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -51,8 +51,8 @@ static const struct rhashtable_params br_sg_port_rht_params = {
 
 static void br_multicast_start_querier(struct net_bridge *br,
 				       struct bridge_mcast_own_query *query);
-static void br_multicast_add_router(struct net_bridge *br,
-				    struct net_bridge_port *port);
+static void br_ip4_multicast_add_router(struct net_bridge *br,
+					struct net_bridge_port *port);
 static void br_ip4_multicast_leave_group(struct net_bridge *br,
 					 struct net_bridge_port *port,
 					 __be32 group,
@@ -1689,7 +1689,7 @@ static void __br_multicast_enable_port(struct net_bridge_port *port)
 #endif
 	if (port->multicast_router == MDB_RTR_TYPE_PERM &&
 	    hlist_unhashed(&port->ip4_rlist))
-		br_multicast_add_router(br, port);
+		br_ip4_multicast_add_router(br, port);
 }
 
 void br_multicast_enable_port(struct net_bridge_port *port)
@@ -2659,28 +2659,51 @@ static void br_port_mc_router_state_change(struct net_bridge_port *p,
  *  and locked by br->multicast_lock and RCU
  */
 static void br_multicast_add_router(struct net_bridge *br,
-				    struct net_bridge_port *port)
+				    struct net_bridge_port *port,
+				    struct hlist_node *slot,
+				    struct hlist_node *rlist,
+				    struct hlist_head *mc_router_list)
 {
-	struct net_bridge_port *p;
-	struct hlist_node *slot = NULL;
-
-	if (!hlist_unhashed(&port->ip4_rlist))
+	if (!hlist_unhashed(rlist))
 		return;
 
-	hlist_for_each_entry(p, &br->ip4_mc_router_list, ip4_rlist) {
-		if ((unsigned long) port >= (unsigned long) p)
-			break;
-		slot = &p->ip4_rlist;
-	}
-
 	if (slot)
-		hlist_add_behind_rcu(&port->ip4_rlist, slot);
+		hlist_add_behind_rcu(rlist, slot);
 	else
-		hlist_add_head_rcu(&port->ip4_rlist, &br->ip4_mc_router_list);
+		hlist_add_head_rcu(rlist, mc_router_list);
+
 	br_rtr_notify(br->dev, port, RTM_NEWMDB);
 	br_port_mc_router_state_change(port, true);
 }
 
+static struct hlist_node *
+br_ip4_multicast_get_rport_slot(struct net_bridge *br, struct net_bridge_port *port)
+{
+	struct hlist_node *slot = NULL;
+	struct net_bridge_port *p;
+
+	hlist_for_each_entry(p, &br->ip4_mc_router_list, ip4_rlist) {
+		if ((unsigned long)port >= (unsigned long)p)
+			break;
+		slot = &p->ip4_rlist;
+	}
+
+	return slot;
+}
+
+/* Add port to router_list
+ *  list is maintained ordered by pointer value
+ *  and locked by br->multicast_lock and RCU
+ */
+static void br_ip4_multicast_add_router(struct net_bridge *br,
+					struct net_bridge_port *port)
+{
+	struct hlist_node *slot = br_ip4_multicast_get_rport_slot(br, port);
+
+	br_multicast_add_router(br, port, slot, &port->ip4_rlist,
+				&br->ip4_mc_router_list);
+}
+
 static void br_multicast_mark_router(struct net_bridge *br,
 				     struct net_bridge_port *port)
 {
@@ -2700,7 +2723,7 @@ static void br_multicast_mark_router(struct net_bridge *br,
 	    port->multicast_router == MDB_RTR_TYPE_PERM)
 		return;
 
-	br_multicast_add_router(br, port);
+	br_ip4_multicast_add_router(br, port);
 
 	mod_timer(&port->ip4_mc_router_timer,
 		  now + br->multicast_querier_interval);
@@ -3526,7 +3549,7 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	case MDB_RTR_TYPE_PERM:
 		p->multicast_router = MDB_RTR_TYPE_PERM;
 		del_timer(&p->ip4_mc_router_timer);
-		br_multicast_add_router(br, p);
+		br_ip4_multicast_add_router(br, p);
 		break;
 	case MDB_RTR_TYPE_TEMP:
 		p->multicast_router = MDB_RTR_TYPE_TEMP;
-- 
2.31.0

