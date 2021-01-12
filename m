Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760042F3272
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 15:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388312AbhALOAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 09:00:30 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:13934 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbhALOAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 09:00:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610460029; x=1641996029;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5z9omTjY3Vfs28VHRGtBI4ChySpQs9sX+Ize/g3yiJs=;
  b=F0Dn6H8a7NZhhnVyR+klShKKyUlYfg79WsD5ARk7Mi1i0OZMjd++5xMp
   Z9DzOPX9slSNHLMOrVpG9XHm7D9mR5vZFXvmwxCHF172Ox4YxdQs9iW+A
   HNKoO4Caw01o8WV7NS22MRL+lC1qwQnjppG+qDAJzVmD+erKGohfgzD4b
   zYpfAUpk8+apBi3aBRzCGysNfzxyL7uHk7FKQepsCuRKvPvhRinb0iiRC
   jz3GAKxzIoB3kvG+thsbiZzFxak31tLF+WhGuKdV/xMd3681vSaxrnyu8
   E3zaQqgjE0T+rmhCsXy8wbwZPb9AKHrxiqWQGzQetEEj9DzP+GLzTSUgY
   g==;
IronPort-SDR: KlNLc8eSSOscXmt4YX6G+8Qh5rqTv4fdxuig6MYoTkXsOcVuIT/0L0u6qlVUHoEC7r8rALENeV
 /dAVVqb6r7zrsk4tHote4Qp+n9hXRPePkFnQfrrIYkaPl8rf4rXJ24+1IEqZk/tcVsYPrH3/Hx
 lPn1H4IufyjcFClwek/lClg3tnniM7yAozh4275WqJ1HX4MLNhWJ0IVvIFfJPVDcFVLSoPZFhR
 6Em8iBqOSuygyP6pL933gz8WLsJMSWAhjTQjW9yyMXk9o5px/g5bCg6uaLLcv8hPbY3q4Ptrao
 s+4=
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="105676140"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jan 2021 06:59:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 06:59:13 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 12 Jan 2021 06:59:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <allan.nielsen@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH v2] net: bridge: igmp: Extend IGMP query to be per vlan
Date:   Tue, 12 Jan 2021 14:59:03 +0100
Message-ID: <20210112135903.3730765-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the comments of the previous version, we started to work on a
new version, so it would be possible to enable/disable queries per vlan.
This is still work in progress and there are plenty of things that are
not implemented and tested:
- ipv6 support
- the fast path needs to be improved
- currently it is possible only to enable/disable the queries per vlan,
  all the other configurations are global
- toggling vlan_filtering is not tested
- remove duplicated information
- etc...

But there are few things that are working like:
- sending queries per vlan
- stop sending queries if there is a better querier per vlan
- when ports are added/removed from vlan
- etc...

We were wondering if this what you had in mind when you proposed to have
this per vlan? Or we are completely off? Or we should fix some of the
issues that I mentioned, before you can see more clearly the direction?

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/if_link.h |   1 +
 net/bridge/br_device.c       |   2 +-
 net/bridge/br_input.c        |   2 +-
 net/bridge/br_multicast.c    | 505 ++++++++++++++++++++++++++++++-----
 net/bridge/br_netlink.c      |   9 +-
 net/bridge/br_private.h      |  90 ++++++-
 net/bridge/br_sysfs_br.c     |  31 ++-
 net/bridge/br_vlan.c         |   3 +
 8 files changed, 560 insertions(+), 83 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 82708c6db432..11ec1d45c24e 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -472,6 +472,7 @@ enum {
 	IFLA_BR_MCAST_MLD_VERSION,
 	IFLA_BR_VLAN_STATS_PER_PORT,
 	IFLA_BR_MULTI_BOOLOPT,
+	IFLA_BR_MCAST_QUERIER_VID,
 	__IFLA_BR_MAX,
 };
 
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 3f2f06b4dd27..aca4e8074a8f 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -89,7 +89,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		mdst = br_mdb_get(br, skb, vid);
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb), mdst))
+		    br_multicast_querier_exists(br, eth_hdr(skb), mdst, vid))
 			br_multicast_flood(mdst, skb, false, true);
 		else
 			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 222285d9dae2..03e445af6c1f 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -130,7 +130,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	case BR_PKT_MULTICAST:
 		mdst = br_mdb_get(br, skb, vid);
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb), mdst)) {
+		    br_multicast_querier_exists(br, eth_hdr(skb), mdst, vid)) {
 			if ((mdst && mdst->host_joined) ||
 			    br_multicast_is_router(br)) {
 				local_rcv = true;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 257ac4e25f6d..b4fac25101e4 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -48,8 +48,11 @@ static const struct rhashtable_params br_sg_port_rht_params = {
 	.automatic_shrinking = true,
 };
 
+static void br_ip4_multicast_query_expired(struct timer_list *t);
+static void br_ip4_multicast_querier_expired(struct timer_list *t);
 static void br_multicast_start_querier(struct net_bridge *br,
-				       struct bridge_mcast_own_query *query);
+				       struct bridge_mcast_own_query *query,
+				       u16 vid);
 static void br_multicast_add_router(struct net_bridge *br,
 				    struct net_bridge_port *port);
 static void br_ip4_multicast_leave_group(struct net_bridge *br,
@@ -87,6 +90,112 @@ br_sg_port_find(struct net_bridge *br,
 				      br_sg_port_rht_params);
 }
 
+static void br_mcast_del_other_query(struct bridge_mcast_other_query *query)
+{
+	del_timer_sync(&query->timer);
+	list_del(&query->list);
+	kfree(query);
+}
+
+static struct bridge_mcast_other_query *
+br_mcast_add_other_query(struct list_head *list, u16 vid,
+			 void (*callback)(struct timer_list *t))
+{
+	struct bridge_mcast_other_query *query;
+
+	query = kzalloc(sizeof(*query), GFP_KERNEL);
+	if (!query)
+		return NULL;
+
+	query->vid = vid;
+	timer_setup(&query->timer, callback, 0);
+
+	list_add(&query->list, list);
+
+	return query;
+}
+
+static void br_mcast_del_own_query(struct bridge_mcast_own_query *query)
+{
+	del_timer_sync(&query->timer);
+	list_del(&query->list);
+	kfree(query);
+}
+
+static struct bridge_mcast_own_query *
+br_mcast_add_own_query(struct list_head *list, u16 vid,
+		       void (*callback)(struct timer_list *t))
+{
+	struct bridge_mcast_own_query *query;
+
+	query = kzalloc(sizeof(*query), GFP_KERNEL);
+	if (!query)
+		return NULL;
+
+	query->vid = vid;
+	timer_setup(&query->timer, callback, 0);
+
+	list_add(&query->list, list);
+
+	return query;
+}
+
+static void br_mcast_add_queries(struct net_bridge *br, u16 vid)
+{
+	struct bridge_mcast_other_query *other;
+	struct bridge_mcast_own_query *own;
+
+	own = br_mcast_find_own_query(&br->ip4_own_queries, vid);
+	if (!own) {
+		own = br_mcast_add_own_query(&br->ip4_own_queries, vid,
+					     br_ip4_multicast_query_expired);
+		own->ip4 = true;
+		own->br = br;
+	}
+
+	other = br_mcast_find_other_query(&br->ip4_other_queries, vid);
+	if (!other) {
+		other = br_mcast_add_other_query(&br->ip4_other_queries, vid,
+						 br_ip4_multicast_querier_expired);
+		other->br = br;
+	}
+}
+
+struct bridge_mcast_own_query *
+br_mcast_find_own_query(struct list_head *list, u16 vid)
+{
+	struct bridge_mcast_own_query *query = NULL;
+
+	list_for_each_entry(query, list, list)
+		if (query->vid == vid)
+			return query;
+
+	return NULL;
+}
+
+struct bridge_mcast_other_query *
+br_mcast_find_other_query(struct list_head *list, u16 vid)
+{
+	struct bridge_mcast_other_query *query = NULL;
+
+	list_for_each_entry(query, list, list)
+		if (query->vid == vid)
+			return query;
+
+	return NULL;
+}
+
+bool br_mcast_exist_own_query(struct net_bridge *br)
+{
+	struct bridge_mcast_own_query *query = NULL;
+
+	list_for_each_entry(query, &br->ip4_own_queries, list)
+		if (query->enabled)
+			return true;
+
+	return false;
+}
+
 static struct net_bridge_mdb_entry *br_mdb_ip_get_rcu(struct net_bridge *br,
 						      struct br_ip *dst)
 {
@@ -688,7 +797,8 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 						    __be32 ip_dst, __be32 group,
 						    bool with_srcs, bool over_lmqt,
 						    u8 sflag, u8 *igmp_type,
-						    bool *need_rexmit)
+						    bool *need_rexmit,
+						    u16 vid)
 {
 	struct net_bridge_port *p = pg ? pg->key.port : NULL;
 	struct net_bridge_group_src *ent;
@@ -724,6 +834,9 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 	}
 
 	pkt_size = sizeof(*eth) + sizeof(*iph) + 4 + igmp_hdr_size;
+	if (br_vlan_enabled(br->dev) && vid != 0)
+		pkt_size += 4;
+
 	if ((p && pkt_size > p->dev->mtu) ||
 	    pkt_size > br->dev->mtu)
 		return NULL;
@@ -732,6 +845,9 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 	if (!skb)
 		goto out;
 
+	if (br_vlan_enabled(br->dev) && vid != 0)
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
+
 	skb->protocol = htons(ETH_P_IP);
 
 	skb_reset_mac_header(skb);
@@ -1008,7 +1124,7 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 						    ip4_dst, group->dst.ip4,
 						    with_srcs, over_lmqt,
 						    sflag, igmp_type,
-						    need_rexmit);
+						    need_rexmit, group->vid);
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6): {
 		struct in6_addr ip6_dst;
@@ -1398,7 +1514,7 @@ static void br_multicast_querier_expired(struct net_bridge *br,
 	if (!netif_running(br->dev) || !br_opt_get(br, BROPT_MULTICAST_ENABLED))
 		goto out;
 
-	br_multicast_start_querier(br, query);
+	br_multicast_start_querier(br, query, query->vid);
 
 out:
 	spin_unlock(&br->multicast_lock);
@@ -1406,9 +1522,14 @@ static void br_multicast_querier_expired(struct net_bridge *br,
 
 static void br_ip4_multicast_querier_expired(struct timer_list *t)
 {
-	struct net_bridge *br = from_timer(br, t, ip4_other_query.timer);
+	struct bridge_mcast_other_query *other_query =
+		from_timer(other_query, t, timer);
+	struct net_bridge *br = other_query->br;
+	struct bridge_mcast_own_query *query;
 
-	br_multicast_querier_expired(br, &br->ip4_own_query);
+	list_for_each_entry(query, &br->ip4_own_queries, list)
+		if (query->enabled && query->vid == other_query->vid)
+			br_multicast_querier_expired(br, query);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1477,19 +1598,22 @@ static void br_multicast_send_query(struct net_bridge *br,
 				    struct bridge_mcast_own_query *own_query)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
+	struct net_bridge_vlan_group *vg;
 	struct br_ip br_group;
 	unsigned long time;
 
 	if (!netif_running(br->dev) ||
-	    !br_opt_get(br, BROPT_MULTICAST_ENABLED) ||
-	    !br_opt_get(br, BROPT_MULTICAST_QUERIER))
+	    !br_opt_get(br, BROPT_MULTICAST_ENABLED))
 		return;
 
-	memset(&br_group.dst, 0, sizeof(br_group.dst));
+	if (!own_query->enabled)
+		return;
 
-	if (port ? (own_query == &port->ip4_own_query) :
-		   (own_query == &br->ip4_own_query)) {
-		other_query = &br->ip4_other_query;
+	memset(&br_group, 0, sizeof(br_group));
+
+	if (own_query->ip4) {
+		other_query = br_mcast_find_other_query(&br->ip4_other_queries,
+							own_query->vid);
 		br_group.proto = htons(ETH_P_IP);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
@@ -1501,6 +1625,12 @@ static void br_multicast_send_query(struct net_bridge *br,
 	if (!other_query || timer_pending(&other_query->timer))
 		return;
 
+	br_group.vid = own_query->vid;
+
+	vg =  port ? nbp_vlan_group(port) : br_vlan_group(br);
+	if (vg->pvid == own_query->vid)
+		br_group.vid = 0;
+
 	__br_multicast_send_query(br, port, NULL, NULL, &br_group, false, 0,
 				  NULL);
 
@@ -1533,9 +1663,10 @@ br_multicast_port_query_expired(struct net_bridge_port *port,
 
 static void br_ip4_multicast_port_query_expired(struct timer_list *t)
 {
-	struct net_bridge_port *port = from_timer(port, t, ip4_own_query.timer);
+	struct bridge_mcast_own_query *query = from_timer(query, t, timer);
+	struct net_bridge_port *port = query->port;
 
-	br_multicast_port_query_expired(port, &port->ip4_own_query);
+	br_multicast_port_query_expired(port, query);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1551,17 +1682,23 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 {
 	struct net_bridge_port_group *pg = from_timer(pg, t, rexmit_timer);
 	struct bridge_mcast_other_query *other_query = NULL;
+	struct bridge_mcast_own_query *own_query = NULL;
 	struct net_bridge *br = pg->key.port->br;
+	u16 vid = pg->key.addr.vid;
 	bool need_rexmit = false;
 
 	spin_lock(&br->multicast_lock);
+	own_query = br_mcast_find_own_query(&pg->key.port->ip4_own_queries,
+					    vid);
+
 	if (!netif_running(br->dev) || hlist_unhashed(&pg->mglist) ||
 	    !br_opt_get(br, BROPT_MULTICAST_ENABLED) ||
-	    !br_opt_get(br, BROPT_MULTICAST_QUERIER))
+	    !own_query || !own_query->enabled)
 		goto out;
 
 	if (pg->key.addr.proto == htons(ETH_P_IP))
-		other_query = &br->ip4_other_query;
+		other_query = br_mcast_find_other_query(&br->ip4_other_queries,
+							vid);
 #if IS_ENABLED(CONFIG_IPV6)
 	else
 		other_query = &br->ip6_other_query;
@@ -1603,8 +1740,7 @@ int br_multicast_add_port(struct net_bridge_port *port)
 
 	timer_setup(&port->multicast_router_timer,
 		    br_multicast_router_expired, 0);
-	timer_setup(&port->ip4_own_query.timer,
-		    br_ip4_multicast_port_query_expired, 0);
+	INIT_LIST_HEAD(&port->ip4_own_queries);
 #if IS_ENABLED(CONFIG_IPV6)
 	timer_setup(&port->ip6_own_query.timer,
 		    br_ip6_multicast_port_query_expired, 0);
@@ -1621,6 +1757,7 @@ int br_multicast_add_port(struct net_bridge_port *port)
 
 void br_multicast_del_port(struct net_bridge_port *port)
 {
+	struct bridge_mcast_own_query *query, *tmp;
 	struct net_bridge *br = port->br;
 	struct net_bridge_port_group *pg;
 	HLIST_HEAD(deleted_head);
@@ -1635,6 +1772,9 @@ void br_multicast_del_port(struct net_bridge_port *port)
 	br_multicast_gc(&deleted_head);
 	del_timer_sync(&port->multicast_router_timer);
 	free_percpu(port->mcast_stats);
+
+	list_for_each_entry_safe(query, tmp, &port->ip4_own_queries, list)
+		br_mcast_del_own_query(query);
 }
 
 static void br_multicast_enable(struct bridge_mcast_own_query *query)
@@ -1646,14 +1786,49 @@ static void br_multicast_enable(struct bridge_mcast_own_query *query)
 		mod_timer(&query->timer, jiffies);
 }
 
+static void br_multicast_disable(struct bridge_mcast_own_query *query)
+{
+	del_timer_sync(&query->timer);
+}
+
 static void __br_multicast_enable_port(struct net_bridge_port *port)
 {
+	struct bridge_mcast_own_query *query;
 	struct net_bridge *br = port->br;
 
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED) || !netif_running(br->dev))
 		return;
 
-	br_multicast_enable(&port->ip4_own_query);
+	list_for_each_entry(query, &br->ip4_own_queries, list) {
+		struct bridge_mcast_own_query *port_query;
+		struct net_bridge_vlan_group *vg;
+
+		if (!query->enabled)
+			continue;
+
+		if (br_vlan_enabled(br->dev)) {
+			vg = nbp_vlan_group(port);
+			if (!vg || (vg && !br_vlan_find(vg, query->vid)))
+				continue;
+		}
+
+		port_query = br_mcast_find_own_query(&port->ip4_own_queries,
+						     query->vid);
+		if (!port_query) {
+			port_query = br_mcast_add_own_query(&port->ip4_own_queries,
+							    query->vid,
+							    br_ip4_multicast_port_query_expired);
+			if (!port_query)
+				continue;
+
+			port_query->port = port;
+		}
+
+		if (query->ip4) {
+			port_query->ip4 = true;
+			br_multicast_enable(port_query);
+		}
+	}
 #if IS_ENABLED(CONFIG_IPV6)
 	br_multicast_enable(&port->ip6_own_query);
 #endif
@@ -1673,6 +1848,7 @@ void br_multicast_enable_port(struct net_bridge_port *port)
 
 void br_multicast_disable_port(struct net_bridge_port *port)
 {
+	struct bridge_mcast_own_query *query;
 	struct net_bridge *br = port->br;
 	struct net_bridge_port_group *pg;
 	struct hlist_node *n;
@@ -1685,7 +1861,8 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 	__del_port_router(port);
 
 	del_timer(&port->multicast_router_timer);
-	del_timer(&port->ip4_own_query.timer);
+	list_for_each_entry(query, &port->ip4_own_queries, list)
+		del_timer(&query->timer);
 #if IS_ENABLED(CONFIG_IPV6)
 	del_timer(&port->ip6_own_query.timer);
 #endif
@@ -1717,17 +1894,23 @@ static void __grp_src_mod_timer(struct net_bridge_group_src *src,
 static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
+	struct bridge_mcast_own_query *own_query = NULL;
 	struct net_bridge *br = pg->key.port->br;
 	u32 lmqc = br->multicast_last_member_count;
 	unsigned long lmqt, lmi, now = jiffies;
 	struct net_bridge_group_src *ent;
+	u16 vid = pg->key.addr.vid;
+
+	own_query = br_mcast_find_own_query(&pg->key.port->ip4_own_queries,
+					    vid);
 
 	if (!netif_running(br->dev) ||
 	    !br_opt_get(br, BROPT_MULTICAST_ENABLED))
 		return;
 
 	if (pg->key.addr.proto == htons(ETH_P_IP))
-		other_query = &br->ip4_other_query;
+		other_query = br_mcast_find_other_query(&br->ip4_other_queries,
+							vid);
 #if IS_ENABLED(CONFIG_IPV6)
 	else
 		other_query = &br->ip6_other_query;
@@ -1738,7 +1921,7 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 		if (ent->flags & BR_SGRP_F_SEND) {
 			ent->flags &= ~BR_SGRP_F_SEND;
 			if (ent->timer.expires > lmqt) {
-				if (br_opt_get(br, BROPT_MULTICAST_QUERIER) &&
+				if (own_query && own_query->enabled &&
 				    other_query &&
 				    !timer_pending(&other_query->timer))
 					ent->src_query_rexmit_cnt = lmqc;
@@ -1747,7 +1930,7 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 		}
 	}
 
-	if (!br_opt_get(br, BROPT_MULTICAST_QUERIER) ||
+	if (!own_query || !own_query->enabled ||
 	    !other_query || timer_pending(&other_query->timer))
 		return;
 
@@ -1763,21 +1946,27 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
+	struct bridge_mcast_own_query *own_query = NULL;
 	struct net_bridge *br = pg->key.port->br;
 	unsigned long now = jiffies, lmi;
+	u16 vid = pg->key.addr.vid;
 
 	if (!netif_running(br->dev) ||
 	    !br_opt_get(br, BROPT_MULTICAST_ENABLED))
 		return;
 
+	own_query = br_mcast_find_own_query(&pg->key.port->ip4_own_queries,
+					    vid);
+
 	if (pg->key.addr.proto == htons(ETH_P_IP))
-		other_query = &br->ip4_other_query;
+		other_query = br_mcast_find_other_query(&br->ip4_other_queries,
+							vid);
 #if IS_ENABLED(CONFIG_IPV6)
 	else
 		other_query = &br->ip6_other_query;
 #endif
 
-	if (br_opt_get(br, BROPT_MULTICAST_QUERIER) &&
+	if (own_query && own_query->enabled &&
 	    other_query && !timer_pending(&other_query->timer)) {
 		lmi = now + br->multicast_last_member_interval;
 		pg->grp_query_rexmit_cnt = br->multicast_last_member_count - 1;
@@ -2484,10 +2673,12 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 
 static bool br_ip4_multicast_select_querier(struct net_bridge *br,
 					    struct net_bridge_port *port,
-					    __be32 saddr)
+					    __be32 saddr,
+					    struct bridge_mcast_own_query *own,
+					    struct bridge_mcast_other_query *other)
 {
-	if (!timer_pending(&br->ip4_own_query.timer) &&
-	    !timer_pending(&br->ip4_other_query.timer))
+	if (own && !timer_pending(&own->timer) &&
+	    !timer_pending(&other->timer))
 		goto update;
 
 	if (!br->ip4_querier.addr.src.ip4)
@@ -2533,11 +2724,14 @@ static bool br_ip6_multicast_select_querier(struct net_bridge *br,
 
 static bool br_multicast_select_querier(struct net_bridge *br,
 					struct net_bridge_port *port,
-					struct br_ip *saddr)
+					struct br_ip *saddr,
+					struct bridge_mcast_own_query *query,
+					struct bridge_mcast_other_query *other_query)
 {
 	switch (saddr->proto) {
 	case htons(ETH_P_IP):
-		return br_ip4_multicast_select_querier(br, port, saddr->src.ip4);
+		return br_ip4_multicast_select_querier(br, port, saddr->src.ip4,
+						       query, other_query);
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
 		return br_ip6_multicast_select_querier(br, port, &saddr->src.ip6);
@@ -2628,9 +2822,10 @@ static void br_multicast_query_received(struct net_bridge *br,
 					struct net_bridge_port *port,
 					struct bridge_mcast_other_query *query,
 					struct br_ip *saddr,
-					unsigned long max_delay)
+					unsigned long max_delay,
+					struct bridge_mcast_own_query *own_query)
 {
-	if (!br_multicast_select_querier(br, port, saddr))
+	if (!br_multicast_select_querier(br, port, saddr, own_query, query))
 		return;
 
 	br_multicast_update_query_timer(br, query, max_delay);
@@ -2643,6 +2838,8 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 				   u16 vid)
 {
 	unsigned int transport_len = ip_transport_len(skb);
+	struct bridge_mcast_other_query *other_query;
+	struct bridge_mcast_own_query *own_query;
 	const struct iphdr *iph = ip_hdr(skb);
 	struct igmphdr *ih = igmp_hdr(skb);
 	struct net_bridge_mdb_entry *mp;
@@ -2684,8 +2881,13 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 		saddr.proto = htons(ETH_P_IP);
 		saddr.src.ip4 = iph->saddr;
 
-		br_multicast_query_received(br, port, &br->ip4_other_query,
-					    &saddr, max_delay);
+		br_mcast_add_queries(br, vid);
+
+		own_query = br_mcast_find_own_query(&br->ip4_own_queries, vid);
+		other_query = br_mcast_find_other_query(&br->ip4_other_queries,
+							vid);
+		br_multicast_query_received(br, port, other_query, &saddr,
+					    max_delay, own_query);
 		goto out;
 	}
 
@@ -2773,7 +2975,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		saddr.src.ip6 = ipv6_hdr(skb)->saddr;
 
 		br_multicast_query_received(br, port, &br->ip6_other_query,
-					    &saddr, max_delay);
+					    &saddr, max_delay, NULL);
 		goto out;
 	} else if (!group) {
 		goto out;
@@ -2850,7 +3052,7 @@ br_multicast_leave_group(struct net_bridge *br,
 	if (timer_pending(&other_query->timer))
 		goto out;
 
-	if (br_opt_get(br, BROPT_MULTICAST_QUERIER)) {
+	if (own_query && own_query->enabled) {
 		__br_multicast_send_query(br, port, NULL, NULL, &mp->addr,
 					  false, 0, NULL);
 
@@ -2916,21 +3118,26 @@ static void br_ip4_multicast_leave_group(struct net_bridge *br,
 					 __u16 vid,
 					 const unsigned char *src)
 {
-	struct br_ip br_group;
+	struct bridge_mcast_other_query *other_query;
 	struct bridge_mcast_own_query *own_query;
+	struct br_ip br_group;
 
 	if (ipv4_is_local_multicast(group))
 		return;
 
-	own_query = port ? &port->ip4_own_query : &br->ip4_own_query;
+	if (port)
+		own_query = br_mcast_find_own_query(&port->ip4_own_queries, vid);
+	else
+		own_query = br_mcast_find_own_query(&br->ip4_own_queries, vid);
 
 	memset(&br_group, 0, sizeof(br_group));
 	br_group.dst.ip4 = group;
 	br_group.proto = htons(ETH_P_IP);
 	br_group.vid = vid;
 
-	br_multicast_leave_group(br, port, &br_group, &br->ip4_other_query,
-				 own_query, src);
+	other_query = br_mcast_find_other_query(&br->ip4_other_queries, vid);
+	br_multicast_leave_group(br, port, &br_group, other_query, own_query,
+				 src);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -3195,9 +3402,10 @@ static void br_multicast_query_expired(struct net_bridge *br,
 
 static void br_ip4_multicast_query_expired(struct timer_list *t)
 {
-	struct net_bridge *br = from_timer(br, t, ip4_own_query.timer);
+	struct bridge_mcast_own_query *query = from_timer(query, t, timer);
+	struct net_bridge *br = query->br;
 
-	br_multicast_query_expired(br, &br->ip4_own_query, &br->ip4_querier);
+	br_multicast_query_expired(br, query, &br->ip4_querier);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -3237,7 +3445,6 @@ void br_multicast_init(struct net_bridge *br)
 	br->multicast_querier_interval = 255 * HZ;
 	br->multicast_membership_interval = 260 * HZ;
 
-	br->ip4_other_query.delay_time = 0;
 	br->ip4_querier.port = NULL;
 	br->multicast_igmp_version = 2;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -3251,10 +3458,8 @@ void br_multicast_init(struct net_bridge *br)
 	spin_lock_init(&br->multicast_lock);
 	timer_setup(&br->multicast_router_timer,
 		    br_multicast_local_router_expired, 0);
-	timer_setup(&br->ip4_other_query.timer,
-		    br_ip4_multicast_querier_expired, 0);
-	timer_setup(&br->ip4_own_query.timer,
-		    br_ip4_multicast_query_expired, 0);
+	INIT_LIST_HEAD(&br->ip4_other_queries);
+	INIT_LIST_HEAD(&br->ip4_own_queries);
 #if IS_ENABLED(CONFIG_IPV6)
 	timer_setup(&br->ip6_other_query.timer,
 		    br_ip6_multicast_querier_expired, 0);
@@ -3341,7 +3546,10 @@ static void __br_multicast_open(struct net_bridge *br,
 
 void br_multicast_open(struct net_bridge *br)
 {
-	__br_multicast_open(br, &br->ip4_own_query);
+	struct bridge_mcast_own_query *query;
+
+	list_for_each_entry(query, &br->ip4_own_queries, list)
+		__br_multicast_open(br, query);
 #if IS_ENABLED(CONFIG_IPV6)
 	__br_multicast_open(br, &br->ip6_own_query);
 #endif
@@ -3349,9 +3557,14 @@ void br_multicast_open(struct net_bridge *br)
 
 void br_multicast_stop(struct net_bridge *br)
 {
+	struct bridge_mcast_other_query *other_query;
+	struct bridge_mcast_own_query *query;
+
 	del_timer_sync(&br->multicast_router_timer);
-	del_timer_sync(&br->ip4_other_query.timer);
-	del_timer_sync(&br->ip4_own_query.timer);
+	list_for_each_entry(other_query, &br->ip4_other_queries, list)
+		del_timer_sync(&other_query->timer);
+	list_for_each_entry(query, &br->ip4_own_queries, list)
+		del_timer_sync(&query->timer);
 #if IS_ENABLED(CONFIG_IPV6)
 	del_timer_sync(&br->ip6_other_query.timer);
 	del_timer_sync(&br->ip6_own_query.timer);
@@ -3461,11 +3674,20 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 }
 
 static void br_multicast_start_querier(struct net_bridge *br,
-				       struct bridge_mcast_own_query *query)
+				       struct bridge_mcast_own_query *query,
+				       u16 vid)
 {
+	struct bridge_mcast_own_query *port_query;
+	struct net_bridge_vlan_group *vg;
 	struct net_bridge_port *port;
 
-	__br_multicast_open(br, query);
+	if (br_vlan_enabled(br->dev)) {
+		vg = br_vlan_group(br);
+		if (vg && br_vlan_find(vg, vid))
+			__br_multicast_open(br, query);
+	} else {
+		__br_multicast_open(br, query);
+	}
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &br->port_list, list) {
@@ -3473,11 +3695,66 @@ static void br_multicast_start_querier(struct net_bridge *br,
 		    port->state == BR_STATE_BLOCKING)
 			continue;
 
-		if (query == &br->ip4_own_query)
-			br_multicast_enable(&port->ip4_own_query);
+		if (br_vlan_enabled(br->dev)) {
+			vg = nbp_vlan_group(port);
+			if (!vg || (vg && !br_vlan_find(vg, vid)))
+				continue;
+		}
+
+		port_query = br_mcast_find_own_query(&port->ip4_own_queries,
+						     vid);
+		if (!port_query)
+			continue;
+
+		port_query->enabled = true;
+
+		if (query->ip4) {
+			port_query->ip4 = true;
+			br_multicast_enable(port_query);
+		}
 #if IS_ENABLED(CONFIG_IPV6)
-		else
+		else {
 			br_multicast_enable(&port->ip6_own_query);
+		}
+#endif
+	}
+	rcu_read_unlock();
+}
+
+static void br_multicast_stop_querier(struct net_bridge *br,
+				      struct bridge_mcast_own_query *query,
+				      u16 vid)
+{
+	struct bridge_mcast_own_query *port_query;
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_port *port;
+
+	query->enabled = false;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(port, &br->port_list, list) {
+		if (port->state == BR_STATE_DISABLED ||
+		    port->state == BR_STATE_BLOCKING)
+			continue;
+
+		if (br_vlan_enabled(br->dev)) {
+			vg = nbp_vlan_group(port);
+			if (!vg || (vg && !br_vlan_find(vg, vid)))
+				continue;
+		}
+
+		port_query = br_mcast_find_own_query(&port->ip4_own_queries,
+						     vid);
+		if (!port_query)
+			continue;
+
+		port_query->enabled = false;
+
+		if (query->ip4)
+			br_multicast_disable(port_query);
+#if IS_ENABLED(CONFIG_IPV6)
+		else
+			br_multicast_disable(&port->ip6_own_query);
 #endif
 	}
 	rcu_read_unlock();
@@ -3553,32 +3830,55 @@ bool br_multicast_router(const struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(br_multicast_router);
 
-int br_multicast_set_querier(struct net_bridge *br, unsigned long val)
+int br_multicast_set_querier(struct net_bridge *br, unsigned long val, u16 vid)
 {
+	struct bridge_mcast_other_query *other_query;
+	struct bridge_mcast_own_query *query;
+	struct net_bridge_vlan_group *vg;
 	unsigned long max_delay;
 
 	val = !!val;
 
+	if (vid == 0) {
+		vg = br_vlan_group(br);
+		if (vg)
+			vid = vg->pvid;
+	}
+
 	spin_lock_bh(&br->multicast_lock);
-	if (br_opt_get(br, BROPT_MULTICAST_QUERIER) == val)
+	query = br_mcast_find_own_query(&br->ip4_own_queries, vid);
+	if (!query) {
+		if (br_vlan_enabled(br->dev))
+			goto unlock;
+
+		br_mcast_add_queries(br, vid);
+	}
+
+	other_query = br_mcast_find_other_query(&br->ip4_other_queries, vid);
+	if (!other_query)
 		goto unlock;
 
-	br_opt_toggle(br, BROPT_MULTICAST_QUERIER, !!val);
-	if (!val)
+	if (!val && query) {
+		br_multicast_stop_querier(br, query, vid);
 		goto unlock;
+	}
 
-	max_delay = br->multicast_query_response_interval;
+	if (val & query->enabled)
+		goto unlock;
 
-	if (!timer_pending(&br->ip4_other_query.timer))
-		br->ip4_other_query.delay_time = jiffies + max_delay;
+	query->enabled = true;
 
-	br_multicast_start_querier(br, &br->ip4_own_query);
+	max_delay = br->multicast_query_response_interval;
+	if (!timer_pending(&other_query->timer))
+		other_query->delay_time = jiffies + max_delay;
+
+	br_multicast_start_querier(br, query, vid);
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (!timer_pending(&br->ip6_other_query.timer))
 		br->ip6_other_query.delay_time = jiffies + max_delay;
 
-	br_multicast_start_querier(br, &br->ip6_own_query);
+	br_multicast_start_querier(br, &br->ip6_own_query, vid);
 #endif
 
 unlock:
@@ -3587,6 +3887,79 @@ int br_multicast_set_querier(struct net_bridge *br, unsigned long val)
 	return 0;
 }
 
+void br_multicast_vlan_add(struct net_bridge_vlan *v)
+{
+	struct bridge_mcast_own_query *query, *port_query;
+	struct net_bridge_port *p;
+	struct net_bridge *br;
+
+	if (br_vlan_is_master(v)) {
+		br_mcast_add_queries(v->br, v->vid);
+		return;
+	}
+
+	p = v->port;
+	br = p->br;
+
+	query = br_mcast_find_own_query(&br->ip4_own_queries, v->vid);
+
+	port_query = br_mcast_add_own_query(&p->ip4_own_queries,
+					    v->vid,
+					    br_ip4_multicast_port_query_expired);
+	if (!port_query)
+		return;
+
+	port_query->port = p;
+	port_query->ip4 = true;
+
+	if (query->enabled) {
+		port_query->enabled = true;
+		br_multicast_enable(port_query);
+	}
+}
+
+void br_multicast_vlan_del(struct net_bridge_vlan *v)
+{
+	struct bridge_mcast_other_query *other_query, *other_tmp;
+	struct bridge_mcast_own_query *query, *tmp;
+	struct net_bridge_port *p;
+	struct net_bridge *br;
+
+	if (br_vlan_is_master(v)) {
+		br = v->br;
+
+		list_for_each_entry_safe(other_query, other_tmp,
+					 &br->ip4_other_queries, list)
+			if (other_query->vid == v->vid)
+				br_mcast_del_other_query(other_query);
+
+		list_for_each_entry_safe(query, tmp, &br->ip4_own_queries, list)
+			if (query->vid == v->vid)
+				br_mcast_del_own_query(query);
+
+		return;
+	}
+
+	p = v->port;
+
+	list_for_each_entry_safe(query, tmp, &p->ip4_own_queries, list) {
+		if (query->vid == v->vid)
+			br_mcast_del_own_query(query);
+	}
+}
+
+void br_multicast_vlan_toggle(struct net_bridge *br, bool on)
+{
+	struct bridge_mcast_own_query *query;
+
+	list_for_each_entry(query, &br->ip4_own_queries, list) {
+		if (!on)
+			br_multicast_stop_querier(br, query, query->vid);
+		else
+			br_multicast_start_querier(br, query, query->vid);
+	}
+}
+
 int br_multicast_set_igmp_version(struct net_bridge *br, unsigned long val)
 {
 	/* Currently we support only version 2 and 3 */
@@ -3711,7 +4084,7 @@ bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto)
 	memset(&eth, 0, sizeof(eth));
 	eth.h_proto = htons(proto);
 
-	ret = br_multicast_querier_exists(br, &eth, NULL);
+	ret = br_multicast_any_querier_exists(br, &eth);
 
 unlock:
 	rcu_read_unlock();
@@ -3746,7 +4119,7 @@ bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto)
 
 	switch (proto) {
 	case ETH_P_IP:
-		if (!timer_pending(&br->ip4_other_query.timer) ||
+		if (!br_multicast_any_querier_adjacent(br) ||
 		    rcu_dereference(br->ip4_querier.port) == port)
 			goto unlock;
 		break;
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 49700ce0e919..d32f4c185364 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1186,6 +1186,7 @@ static const struct nla_policy br_policy[IFLA_BR_MAX + 1] = {
 	[IFLA_BR_VLAN_STATS_PER_PORT] = { .type = NLA_U8 },
 	[IFLA_BR_MULTI_BOOLOPT] =
 		NLA_POLICY_EXACT_LEN(sizeof(struct br_boolopt_multi)),
+	[IFLA_BR_MCAST_QUERIER_VID] = { .type = NLA_U16 },
 };
 
 static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
@@ -1193,6 +1194,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 			 struct netlink_ext_ack *extack)
 {
 	struct net_bridge *br = netdev_priv(brdev);
+	u16 vid = 0;
 	int err;
 
 	if (!data)
@@ -1204,6 +1206,9 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 			return err;
 	}
 
+	if (data[IFLA_BR_MCAST_QUERIER_VID])
+		vid = nla_get_u16(data[IFLA_BR_MCAST_QUERIER_VID]);
+
 	if (data[IFLA_BR_HELLO_TIME]) {
 		err = br_set_hello_time(br, nla_get_u32(data[IFLA_BR_HELLO_TIME]));
 		if (err)
@@ -1333,7 +1338,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_MCAST_QUERIER]) {
 		u8 mcast_querier = nla_get_u8(data[IFLA_BR_MCAST_QUERIER]);
 
-		err = br_multicast_set_querier(br, mcast_querier);
+		err = br_multicast_set_querier(br, mcast_querier, vid);
 		if (err)
 			return err;
 	}
@@ -1596,7 +1601,7 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
 	    nla_put_u8(skb, IFLA_BR_MCAST_QUERY_USE_IFADDR,
 		       br_opt_get(br, BROPT_MULTICAST_QUERY_USE_IFADDR)) ||
 	    nla_put_u8(skb, IFLA_BR_MCAST_QUERIER,
-		       br_opt_get(br, BROPT_MULTICAST_QUERIER)) ||
+		       br_mcast_exist_own_query(br)) ||
 	    nla_put_u8(skb, IFLA_BR_MCAST_STATS_ENABLED,
 		       br_opt_get(br, BROPT_MULTICAST_STATS_ENABLED)) ||
 	    nla_put_u32(skb, IFLA_BR_MCAST_HASH_ELASTICITY, RHT_ELASTICITY) ||
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d62c6e1af64a..84f597f542b1 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -66,14 +66,24 @@ struct mac_addr {
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 /* our own querier */
 struct bridge_mcast_own_query {
+	struct list_head	list;
 	struct timer_list	timer;
 	u32			startup_sent;
+	struct net_bridge_port	*port;
+	struct net_bridge	*br;
+	bool			ip4;
+	u16			vid;
+	bool			enabled;
 };
 
 /* other querier */
 struct bridge_mcast_other_query {
+	struct list_head		list;
 	struct timer_list		timer;
 	unsigned long			delay_time;
+	struct net_bridge		*br;
+	bool				ip4;
+	u16				vid;
 };
 
 /* selected querier */
@@ -304,7 +314,7 @@ struct net_bridge_port {
 	struct rcu_head			rcu;
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
-	struct bridge_mcast_own_query	ip4_own_query;
+	struct list_head		ip4_own_queries;
 #if IS_ENABLED(CONFIG_IPV6)
 	struct bridge_mcast_own_query	ip6_own_query;
 #endif /* IS_ENABLED(CONFIG_IPV6) */
@@ -448,8 +458,8 @@ struct net_bridge {
 	struct hlist_head		router_list;
 
 	struct timer_list		multicast_router_timer;
-	struct bridge_mcast_other_query	ip4_other_query;
-	struct bridge_mcast_own_query	ip4_own_query;
+	struct list_head		ip4_other_queries;
+	struct list_head		ip4_own_queries;
 	struct bridge_mcast_querier	ip4_querier;
 	struct bridge_mcast_stats	__percpu *mcast_stats;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -788,6 +798,9 @@ int br_ioctl_deviceless_stub(struct net *net, unsigned int cmd,
 
 /* br_multicast.c */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+void br_multicast_vlan_add(struct net_bridge_vlan *v);
+void br_multicast_vlan_del(struct net_bridge_vlan *v);
+void br_multicast_vlan_toggle(struct net_bridge *br, bool on);
 int br_multicast_rcv(struct net_bridge *br, struct net_bridge_port *port,
 		     struct sk_buff *skb, u16 vid);
 struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
@@ -807,7 +820,7 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 int br_multicast_set_router(struct net_bridge *br, unsigned long val);
 int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val);
 int br_multicast_toggle(struct net_bridge *br, unsigned long val);
-int br_multicast_set_querier(struct net_bridge *br, unsigned long val);
+int br_multicast_set_querier(struct net_bridge *br, unsigned long val, u16 vid);
 int br_multicast_set_hash_max(struct net_bridge *br, unsigned long val);
 int br_multicast_set_igmp_version(struct net_bridge *br, unsigned long val);
 #if IS_ENABLED(CONFIG_IPV6)
@@ -846,6 +859,11 @@ void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
 				     u8 filter_mode);
 void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 				       struct net_bridge_port_group *sg);
+struct bridge_mcast_other_query *
+br_mcast_find_other_query(struct list_head *list, u16 vid);
+struct bridge_mcast_own_query *
+br_mcast_find_own_query(struct list_head *list, u16 vid);
+bool br_mcast_exist_own_query(struct net_bridge *br);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
@@ -865,11 +883,15 @@ static inline bool br_multicast_is_router(struct net_bridge *br)
 static inline bool
 __br_multicast_querier_exists(struct net_bridge *br,
 				struct bridge_mcast_other_query *querier,
-				const bool is_ipv6)
+				const bool is_ipv6,
+				u16 vid)
 {
+	struct bridge_mcast_own_query *query;
 	bool own_querier_enabled;
 
-	if (br_opt_get(br, BROPT_MULTICAST_QUERIER)) {
+	query = br_mcast_find_own_query(&br->ip4_own_queries, vid);
+
+	if (query && query->enabled) {
 		if (is_ipv6 && !br_opt_get(br, BROPT_HAS_IPV6_ADDR))
 			own_querier_enabled = false;
 		else
@@ -878,28 +900,62 @@ __br_multicast_querier_exists(struct net_bridge *br,
 		own_querier_enabled = false;
 	}
 
+	if (!querier)
+		return own_querier_enabled;
+
 	return time_is_before_jiffies(querier->delay_time) &&
 	       (own_querier_enabled || timer_pending(&querier->timer));
 }
 
 static inline bool br_multicast_querier_exists(struct net_bridge *br,
 					       struct ethhdr *eth,
-					       const struct net_bridge_mdb_entry *mdb)
+					       const struct net_bridge_mdb_entry *mdb,
+					       u16 vid)
 {
+	struct bridge_mcast_other_query *query =
+		br_mcast_find_other_query(&br->ip4_other_queries, vid);
+
 	switch (eth->h_proto) {
 	case (htons(ETH_P_IP)):
-		return __br_multicast_querier_exists(br,
-			&br->ip4_other_query, false);
+		return __br_multicast_querier_exists(br, query, false, vid);
 #if IS_ENABLED(CONFIG_IPV6)
 	case (htons(ETH_P_IPV6)):
 		return __br_multicast_querier_exists(br,
-			&br->ip6_other_query, true);
+			&br->ip6_other_query, true, vid);
 #endif
 	default:
 		return !!mdb && br_group_is_l2(&mdb->addr);
 	}
 }
 
+static inline bool br_multicast_any_querier_exists(struct net_bridge *br,
+						   struct ethhdr *eth)
+{
+	struct bridge_mcast_other_query *query;
+
+	list_for_each_entry(query, &br->ip4_other_queries, list) {
+		if (!timer_pending(&query->timer))
+			continue;
+
+		if (br_multicast_querier_exists(br, eth, NULL, query->vid))
+			return true;
+	}
+
+	return false;
+}
+
+static inline bool br_multicast_any_querier_adjacent(struct net_bridge *br)
+{
+	struct bridge_mcast_other_query *query;
+
+	list_for_each_entry(query, &br->ip4_other_queries, list) {
+		if (timer_pending(&query->timer))
+			return true;
+	}
+
+	return false;
+}
+
 static inline bool br_multicast_is_star_g(const struct br_ip *ip)
 {
 	switch (ip->proto) {
@@ -1015,7 +1071,19 @@ static inline bool br_multicast_is_router(struct net_bridge *br)
 
 static inline bool br_multicast_querier_exists(struct net_bridge *br,
 					       struct ethhdr *eth,
-					       const struct net_bridge_mdb_entry *mdb)
+					       const struct net_bridge_mdb_entry *mdb,
+					       u16 vid)
+{
+	return false;
+}
+
+static inline bool br_multicast_any_querier_exists(struct net_bridge *br,
+						   struct ethhdr *eth)
+{
+	return false;
+}
+
+static inline bool br_multicast_any_querier_adjacent(struct net_bridge *br)
 {
 	return false;
 }
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 7db06e3f642a..23bf6a065d78 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -51,6 +51,33 @@ static ssize_t store_bridge_parm(struct device *d,
 	return err ? err : len;
 }
 
+static ssize_t store_bridge_parm2(struct device *d,
+				  const char *buf, size_t len,
+				  int (*set)(struct net_bridge *, unsigned long, u16))
+{
+	struct net_bridge *br = to_bridge(d);
+	char *endp;
+	unsigned long val;
+	int err;
+
+	if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+
+	val = simple_strtoul(buf, &endp, 0);
+	if (endp == buf)
+		return -EINVAL;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	err = (*set)(br, val, 0);
+	if (!err)
+		netdev_state_change(br->dev);
+	rtnl_unlock();
+
+	return err ? err : len;
+}
+
 
 static ssize_t forward_delay_show(struct device *d,
 				  struct device_attribute *attr, char *buf)
@@ -404,14 +431,14 @@ static ssize_t multicast_querier_show(struct device *d,
 				      char *buf)
 {
 	struct net_bridge *br = to_bridge(d);
-	return sprintf(buf, "%d\n", br_opt_get(br, BROPT_MULTICAST_QUERIER));
+	return sprintf(buf, "%d\n", br_mcast_exist_own_query(br));
 }
 
 static ssize_t multicast_querier_store(struct device *d,
 				       struct device_attribute *attr,
 				       const char *buf, size_t len)
 {
-	return store_bridge_parm(d, buf, len, br_multicast_set_querier);
+	return store_bridge_parm2(d, buf, len, br_multicast_set_querier);
 }
 static DEVICE_ATTR_RW(multicast_querier);
 
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 701cad646b20..2e0b544a3560 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -308,6 +308,7 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 
 	__vlan_add_list(v);
 	__vlan_add_flags(v, flags);
+	br_multicast_vlan_add(v);
 
 	if (p)
 		nbp_vlan_set_vlan_dev_state(p, v->vid);
@@ -353,6 +354,7 @@ static int __vlan_del(struct net_bridge_vlan *v)
 		masterv = v->brvlan;
 	}
 
+	br_multicast_vlan_del(v);
 	__vlan_delete_pvid(vg, v->vid);
 	if (p) {
 		err = __vlan_vid_del(p->dev, p->br, v);
@@ -827,6 +829,7 @@ int __br_vlan_filter_toggle(struct net_bridge *br, unsigned long val)
 	br_manage_promisc(br);
 	recalculate_group_addr(br);
 	br_recalculate_fwd_mask(br);
+	br_multicast_vlan_toggle(br, !!val);
 
 	return 0;
 }
-- 
2.27.0

