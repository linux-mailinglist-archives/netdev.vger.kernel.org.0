Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002A937EFCD
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbhELXYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 19:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbhELXVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 19:21:06 -0400
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A865C061763;
        Wed, 12 May 2021 16:19:51 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D4C1341008;
        Thu, 13 May 2021 01:19:49 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [net-next v3 03/11] net: bridge: mcast: prepare mdb netlink for mcast router split
Date:   Thu, 13 May 2021 01:19:33 +0200
Message-Id: <20210512231941.19211-4-linus.luessing@c0d3.blue>
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
their IPv4 and IPv6 variants and to avoid IPv6 #ifdef clutter later add
some inline functions for the protocol specific parts in the mdb router
netlink code. Also the we need iterate over the port instead of router
list to be able put one router port entry with both the IPv4 and IPv6
multicast router info later.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 net/bridge/br_mdb.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index d61def8..482edb9 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -16,29 +16,58 @@
 
 #include "br_private.h"
 
+static bool br_rports_have_mc_router(struct net_bridge *br)
+{
+	return !hlist_empty(&br->ip4_mc_router_list);
+}
+
+static bool
+br_ip4_rports_get_timer(struct net_bridge_port *port, unsigned long *timer)
+{
+	*timer = br_timer_value(&port->ip4_mc_router_timer);
+	return !hlist_unhashed(&port->ip4_rlist);
+}
+
+static bool
+br_ip6_rports_get_timer(struct net_bridge_port *port, unsigned long *timer)
+{
+	*timer = 0;
+	return false;
+}
+
 static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 			       struct net_device *dev)
 {
 	struct net_bridge *br = netdev_priv(dev);
-	struct net_bridge_port *p;
+	bool have_ip4_mc_rtr, have_ip6_mc_rtr;
+	unsigned long ip4_timer, ip6_timer;
 	struct nlattr *nest, *port_nest;
+	struct net_bridge_port *p;
 
-	if (!br->multicast_router || hlist_empty(&br->ip4_mc_router_list))
+	if (!br->multicast_router)
+		return 0;
+
+	if (!br_rports_have_mc_router(br))
 		return 0;
 
 	nest = nla_nest_start_noflag(skb, MDBA_ROUTER);
 	if (nest == NULL)
 		return -EMSGSIZE;
 
-	hlist_for_each_entry_rcu(p, &br->ip4_mc_router_list, ip4_rlist) {
-		if (!p)
+	list_for_each_entry_rcu(p, &br->port_list, list) {
+		have_ip4_mc_rtr = br_ip4_rports_get_timer(p, &ip4_timer);
+		have_ip6_mc_rtr = br_ip6_rports_get_timer(p, &ip6_timer);
+
+		if (!have_ip4_mc_rtr && !have_ip6_mc_rtr)
 			continue;
+
 		port_nest = nla_nest_start_noflag(skb, MDBA_ROUTER_PORT);
 		if (!port_nest)
 			goto fail;
+
 		if (nla_put_nohdr(skb, sizeof(u32), &p->dev->ifindex) ||
 		    nla_put_u32(skb, MDBA_ROUTER_PATTR_TIMER,
-				br_timer_value(&p->ip4_mc_router_timer)) ||
+				max(ip4_timer, ip6_timer)) ||
 		    nla_put_u8(skb, MDBA_ROUTER_PATTR_TYPE,
 			       p->multicast_router)) {
 			nla_nest_cancel(skb, port_nest);
-- 
2.31.0

