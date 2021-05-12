Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DF737EFCF
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237727AbhELXZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 19:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbhELXVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 19:21:09 -0400
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236BCC06138E;
        Wed, 12 May 2021 16:19:56 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E09484100D;
        Thu, 13 May 2021 01:19:54 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [net-next v3 08/11] net: bridge: mcast: split router port del+notify for mcast router split
Date:   Thu, 13 May 2021 01:19:38 +0200
Message-Id: <20210512231941.19211-9-linus.luessing@c0d3.blue>
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
their IPv4 and IPv6 variants split router port deletion and notification
into two functions. When we disable a port for instance later we want to
only send one notification to switchdev and netlink for compatibility
and want to avoid sending one for IPv4 and one for IPv6. For that the
split is needed.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 net/bridge/br_multicast.c | 40 ++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 1d55709..01a1de4 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -60,7 +60,8 @@ static void br_ip4_multicast_leave_group(struct net_bridge *br,
 					 const unsigned char *src);
 static void br_multicast_port_group_rexmit(struct timer_list *t);
 
-static void __del_port_router(struct net_bridge_port *p);
+static void
+br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted);
 #if IS_ENABLED(CONFIG_IPV6)
 static void br_ip6_multicast_leave_group(struct net_bridge *br,
 					 struct net_bridge_port *port,
@@ -1354,11 +1355,26 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 }
 #endif
 
+static bool br_multicast_rport_del(struct hlist_node *rlist)
+{
+	if (hlist_unhashed(rlist))
+		return false;
+
+	hlist_del_init_rcu(rlist);
+	return true;
+}
+
+static bool br_ip4_multicast_rport_del(struct net_bridge_port *p)
+{
+	return br_multicast_rport_del(&p->ip4_rlist);
+}
+
 static void br_multicast_router_expired(struct net_bridge_port *port,
 					struct timer_list *t,
 					struct hlist_node *rlist)
 {
 	struct net_bridge *br = port->br;
+	bool del;
 
 	spin_lock(&br->multicast_lock);
 	if (port->multicast_router == MDB_RTR_TYPE_DISABLED ||
@@ -1366,7 +1382,8 @@ static void br_multicast_router_expired(struct net_bridge_port *port,
 	    timer_pending(t))
 		goto out;
 
-	__del_port_router(port);
+	del = br_multicast_rport_del(rlist);
+	br_multicast_rport_del_notify(port, del);
 out:
 	spin_unlock(&br->multicast_lock);
 }
@@ -1706,19 +1723,20 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 	struct net_bridge *br = port->br;
 	struct net_bridge_port_group *pg;
 	struct hlist_node *n;
+	bool del = false;
 
 	spin_lock(&br->multicast_lock);
 	hlist_for_each_entry_safe(pg, n, &port->mglist, mglist)
 		if (!(pg->flags & MDB_PG_FLAGS_PERMANENT))
 			br_multicast_find_del_pg(br, pg);
 
-	__del_port_router(port);
-
+	del |= br_ip4_multicast_rport_del(port);
 	del_timer(&port->ip4_mc_router_timer);
 	del_timer(&port->ip4_own_query.timer);
 #if IS_ENABLED(CONFIG_IPV6)
 	del_timer(&port->ip6_own_query.timer);
 #endif
+	br_multicast_rport_del_notify(port, del);
 	spin_unlock(&br->multicast_lock);
 }
 
@@ -3508,11 +3526,12 @@ int br_multicast_set_router(struct net_bridge *br, unsigned long val)
 	return err;
 }
 
-static void __del_port_router(struct net_bridge_port *p)
+static void
+br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted)
 {
-	if (hlist_unhashed(&p->ip4_rlist))
+	if (!deleted)
 		return;
-	hlist_del_init_rcu(&p->ip4_rlist);
+
 	br_rtr_notify(p->br->dev, p, RTM_DELMDB);
 	br_port_mc_router_state_change(p, false);
 
@@ -3526,6 +3545,7 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	struct net_bridge *br = p->br;
 	unsigned long now = jiffies;
 	int err = -EINVAL;
+	bool del = false;
 
 	spin_lock(&br->multicast_lock);
 	if (p->multicast_router == val) {
@@ -3539,12 +3559,14 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	switch (val) {
 	case MDB_RTR_TYPE_DISABLED:
 		p->multicast_router = MDB_RTR_TYPE_DISABLED;
-		__del_port_router(p);
+		del |= br_ip4_multicast_rport_del(p);
 		del_timer(&p->ip4_mc_router_timer);
+		br_multicast_rport_del_notify(p, del);
 		break;
 	case MDB_RTR_TYPE_TEMP_QUERY:
 		p->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
-		__del_port_router(p);
+		del |= br_ip4_multicast_rport_del(p);
+		br_multicast_rport_del_notify(p, del);
 		break;
 	case MDB_RTR_TYPE_PERM:
 		p->multicast_router = MDB_RTR_TYPE_PERM;
-- 
2.31.0

