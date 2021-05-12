Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D53837EFCE
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbhELXZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 19:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbhELXVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 19:21:06 -0400
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C1AC06138A;
        Wed, 12 May 2021 16:19:54 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AA08B4100B;
        Thu, 13 May 2021 01:19:52 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [net-next v3 06/11] net: bridge: mcast: prepare expiry functions for mcast router split
Date:   Thu, 13 May 2021 01:19:36 +0200
Message-Id: <20210512231941.19211-7-linus.luessing@c0d3.blue>
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
their IPv4 and IPv6 variants move the protocol specific timer access to
an ip4 wrapper function.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 net/bridge/br_multicast.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 048b5b9..7815991 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1354,16 +1354,16 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 }
 #endif
 
-static void br_multicast_router_expired(struct timer_list *t)
+static void br_multicast_router_expired(struct net_bridge_port *port,
+					struct timer_list *t,
+					struct hlist_node *rlist)
 {
-	struct net_bridge_port *port =
-			from_timer(port, t, ip4_mc_router_timer);
 	struct net_bridge *br = port->br;
 
 	spin_lock(&br->multicast_lock);
 	if (port->multicast_router == MDB_RTR_TYPE_DISABLED ||
 	    port->multicast_router == MDB_RTR_TYPE_PERM ||
-	    timer_pending(&port->ip4_mc_router_timer))
+	    timer_pending(t))
 		goto out;
 
 	__del_port_router(port);
@@ -1371,6 +1371,13 @@ out:
 	spin_unlock(&br->multicast_lock);
 }
 
+static void br_ip4_multicast_router_expired(struct timer_list *t)
+{
+	struct net_bridge_port *port = from_timer(port, t, ip4_mc_router_timer);
+
+	br_multicast_router_expired(port, t, &port->ip4_rlist);
+}
+
 static void br_mc_router_state_change(struct net_bridge *p,
 				      bool is_mc_router)
 {
@@ -1384,10 +1391,9 @@ static void br_mc_router_state_change(struct net_bridge *p,
 	switchdev_port_attr_set(p->dev, &attr, NULL);
 }
 
-static void br_multicast_local_router_expired(struct timer_list *t)
+static void br_multicast_local_router_expired(struct net_bridge *br,
+					      struct timer_list *timer)
 {
-	struct net_bridge *br = from_timer(br, t, ip4_mc_router_timer);
-
 	spin_lock(&br->multicast_lock);
 	if (br->multicast_router == MDB_RTR_TYPE_DISABLED ||
 	    br->multicast_router == MDB_RTR_TYPE_PERM ||
@@ -1400,6 +1406,13 @@ out:
 	spin_unlock(&br->multicast_lock);
 }
 
+static void br_ip4_multicast_local_router_expired(struct timer_list *t)
+{
+	struct net_bridge *br = from_timer(br, t, ip4_mc_router_timer);
+
+	br_multicast_local_router_expired(br, t);
+}
+
 static void br_multicast_querier_expired(struct net_bridge *br,
 					 struct bridge_mcast_own_query *query)
 {
@@ -1615,7 +1628,7 @@ int br_multicast_add_port(struct net_bridge_port *port)
 	port->multicast_eht_hosts_limit = BR_MCAST_DEFAULT_EHT_HOSTS_LIMIT;
 
 	timer_setup(&port->ip4_mc_router_timer,
-		    br_multicast_router_expired, 0);
+		    br_ip4_multicast_router_expired, 0);
 	timer_setup(&port->ip4_own_query.timer,
 		    br_ip4_multicast_port_query_expired, 0);
 #if IS_ENABLED(CONFIG_IPV6)
@@ -3319,7 +3332,7 @@ void br_multicast_init(struct net_bridge *br)
 
 	spin_lock_init(&br->multicast_lock);
 	timer_setup(&br->ip4_mc_router_timer,
-		    br_multicast_local_router_expired, 0);
+		    br_ip4_multicast_local_router_expired, 0);
 	timer_setup(&br->ip4_other_query.timer,
 		    br_ip4_multicast_querier_expired, 0);
 	timer_setup(&br->ip4_own_query.timer,
-- 
2.31.0

