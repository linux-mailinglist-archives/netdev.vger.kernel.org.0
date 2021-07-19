Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A720A3CE83D
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354977AbhGSQj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355622AbhGSQg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:27 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B79AC04F96B
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:47 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h8so25012258eds.4
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d5WfUxiu3wUTfpLu8xCFiHnRwiszQuYf+ZkVtEOg5n0=;
        b=hRIKgrnSl9aT+0VxkaCzdv0ZAbLvjy0UoszHK01x3cNB7wBopy36yRxUVhLTtjG3C9
         1vdHw7WvCCS2CoogwQazt4mZVjBoJ18JuQ3d/mhzQF9SPTdnAE75jl9iHOhQAMGmUmud
         ZAGw8Sc+h4mZn4G3oYMAJsmpKTMmOfllQms7ZSRfjSri/0QvAPm3j841wkjzDnEQwt3H
         E3X3eUdyHuZighJBVU7ydRPl9T/3+DZkvaD1kuXAS2iKt9JOSkRDmxONiw4RC+1d7gJz
         7u6JD0luUoHaGbz03enYJrJOJp/LuorBlrYB4Pe7fbd8rrFMtcrGu+ETLl/DJZvpxaZa
         fqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d5WfUxiu3wUTfpLu8xCFiHnRwiszQuYf+ZkVtEOg5n0=;
        b=Xq7GwpeRJWcZvSZAfgvnLSdXZqyRwpmIuvVSr1aEnt7s1/mL6I6aVeFLNDB98rJsYv
         0xh11Zz3fA936jrFajKKmMBcTaL3R1kdnkePWEdqD2PNCNAZuNyXRpbV8CBwjJS2/AtB
         k5/Q+d9ihJQefza8XTHnOfKz5cXMsC1lfPrFOXclHQ6HGSWOyVsLY2mrp4BQjw0Yob61
         36R4t6HwaJo2u4Agf8ixR28R/QY/qFl9ivjPS5F1zv1xUe8+BMQkI9b3nlNYw8rx6woG
         KI6dZD3kohzUwNBTg13FzM3j3/z6vqWlg0Kb7ozGsfTq6ZX0rrd5rLHIsrN6EGr4iGl8
         XCQw==
X-Gm-Message-State: AOAM530IdpsKZh5XH6m8xxIyBNgIb4oNLHEsqBOeF8QYvPcJsrN4Ozu0
        S6wPHHndyvhqvcdbq2tikztofYR3S/d0fiAnr5g=
X-Google-Smtp-Source: ABdhPJwvt4rL/k0XkiPRDbJyuHTov0m9SN1RhN4fyOAZSEX/5f7H1/4Dp7ijwCilQqB7izAJzJT1ug==
X-Received: by 2002:a05:6402:26ca:: with SMTP id x10mr35602056edd.319.1626714599619;
        Mon, 19 Jul 2021 10:09:59 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:09:58 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 03/15] net: bridge: multicast: use multicast contexts instead of bridge or port
Date:   Mon, 19 Jul 2021 20:06:25 +0300
Message-Id: <20210719170637.435541-4-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Pass multicast context pointers to multicast functions instead of bridge/port.
This would make it easier later to switch these contexts to their per-vlan
versions. The patch is basically search and replace, no functional changes.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_device.c            |   9 +-
 net/bridge/br_forward.c           |   7 +-
 net/bridge/br_input.c             |  14 +-
 net/bridge/br_mdb.c               |   2 +-
 net/bridge/br_multicast.c         | 889 ++++++++++++++++--------------
 net/bridge/br_multicast_eht.c     |  92 ++--
 net/bridge/br_private.h           |  74 +--
 net/bridge/br_private_mcast_eht.h |   3 +-
 8 files changed, 575 insertions(+), 515 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index e8b626cc6bfd..e815bf4f9f24 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -28,6 +28,7 @@ EXPORT_SYMBOL_GPL(nf_br_ops);
 netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct net_bridge *br = netdev_priv(dev);
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	struct net_bridge_fdb_entry *dst;
 	struct net_bridge_mdb_entry *mdst;
 	const struct nf_br_ops *nf_ops;
@@ -82,15 +83,15 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
 			goto out;
 		}
-		if (br_multicast_rcv(br, NULL, skb, vid)) {
+		if (br_multicast_rcv(brmctx, NULL, skb, vid)) {
 			kfree_skb(skb);
 			goto out;
 		}
 
-		mdst = br_mdb_get(br, skb, vid);
+		mdst = br_mdb_get(brmctx, skb, vid);
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb), mdst))
-			br_multicast_flood(mdst, skb, false, true);
+		    br_multicast_querier_exists(brmctx, eth_hdr(skb), mdst))
+			br_multicast_flood(mdst, skb, brmctx, false, true);
 		else
 			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
 	} else if ((dst = br_fdb_find_rcu(br, dest, vid)) != NULL) {
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 07856362538f..bfdbaf3015b9 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -267,20 +267,19 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
 /* called with rcu_read_lock */
 void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 			struct sk_buff *skb,
+			struct net_bridge_mcast *brmctx,
 			bool local_rcv, bool local_orig)
 {
-	struct net_device *dev = BR_INPUT_SKB_CB(skb)->brdev;
-	struct net_bridge *br = netdev_priv(dev);
 	struct net_bridge_port *prev = NULL;
 	struct net_bridge_port_group *p;
 	bool allow_mode_include = true;
 	struct hlist_node *rp;
 
-	rp = br_multicast_get_first_rport_node(br, skb);
+	rp = br_multicast_get_first_rport_node(brmctx, skb);
 
 	if (mdst) {
 		p = rcu_dereference(mdst->ports);
-		if (br_multicast_should_handle_mode(br, mdst->addr.proto) &&
+		if (br_multicast_should_handle_mode(brmctx, mdst->addr.proto) &&
 		    br_multicast_is_star_g(&mdst->addr))
 			allow_mode_include = false;
 	} else {
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 1f506309efa8..bb2036dd4934 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -69,8 +69,10 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
 	enum br_pkt_type pkt_type = BR_PKT_UNICAST;
 	struct net_bridge_fdb_entry *dst = NULL;
+	struct net_bridge_mcast_port *pmctx;
 	struct net_bridge_mdb_entry *mdst;
 	bool local_rcv, mcast_hit = false;
+	struct net_bridge_mcast *brmctx;
 	struct net_bridge *br;
 	u16 vid = 0;
 	u8 state;
@@ -78,6 +80,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	if (!p || p->state == BR_STATE_DISABLED)
 		goto drop;
 
+	brmctx = &p->br->multicast_ctx;
+	pmctx = &p->multicast_ctx;
 	state = p->state;
 	if (!br_allowed_ingress(p->br, nbp_vlan_group_rcu(p), skb, &vid,
 				&state))
@@ -98,7 +102,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 			local_rcv = true;
 		} else {
 			pkt_type = BR_PKT_MULTICAST;
-			if (br_multicast_rcv(br, p, skb, vid))
+			if (br_multicast_rcv(brmctx, pmctx, skb, vid))
 				goto drop;
 		}
 	}
@@ -128,11 +132,11 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 
 	switch (pkt_type) {
 	case BR_PKT_MULTICAST:
-		mdst = br_mdb_get(br, skb, vid);
+		mdst = br_mdb_get(brmctx, skb, vid);
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb), mdst)) {
+		    br_multicast_querier_exists(brmctx, eth_hdr(skb), mdst)) {
 			if ((mdst && mdst->host_joined) ||
-			    br_multicast_is_router(br, skb)) {
+			    br_multicast_is_router(brmctx, skb)) {
 				local_rcv = true;
 				br->dev->stats.multicast++;
 			}
@@ -162,7 +166,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		if (!mcast_hit)
 			br_flood(br, skb, pkt_type, local_rcv, false);
 		else
-			br_multicast_flood(mdst, skb, local_rcv, false);
+			br_multicast_flood(mdst, skb, brmctx, local_rcv, false);
 	}
 
 	if (local_rcv)
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index effe03c08038..5319587198eb 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1092,7 +1092,7 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	 * a new INCLUDE port (S,G) then all of *,G EXCLUDE ports need to be
 	 * added to it for proper replication
 	 */
-	if (br_multicast_should_handle_mode(br, group.proto)) {
+	if (br_multicast_should_handle_mode(&br->multicast_ctx, group.proto)) {
 		switch (filter_mode) {
 		case MCAST_EXCLUDE:
 			br_multicast_star_g_handle_mode(p, MCAST_EXCLUDE);
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 92bfc1d95cd5..64145e48a0a5 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -49,30 +49,30 @@ static const struct rhashtable_params br_sg_port_rht_params = {
 	.automatic_shrinking = true,
 };
 
-static void br_multicast_start_querier(struct net_bridge *br,
+static void br_multicast_start_querier(struct net_bridge_mcast *brmctx,
 				       struct bridge_mcast_own_query *query);
-static void br_ip4_multicast_add_router(struct net_bridge *br,
-					struct net_bridge_port *port);
-static void br_ip4_multicast_leave_group(struct net_bridge *br,
-					 struct net_bridge_port *port,
+static void br_ip4_multicast_add_router(struct net_bridge_mcast *brmctx,
+					struct net_bridge_mcast_port *pmctx);
+static void br_ip4_multicast_leave_group(struct net_bridge_mcast *brmctx,
+					 struct net_bridge_mcast_port *pmctx,
 					 __be32 group,
 					 __u16 vid,
 					 const unsigned char *src);
 static void br_multicast_port_group_rexmit(struct timer_list *t);
 
 static void
-br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted);
-static void br_ip6_multicast_add_router(struct net_bridge *br,
-					struct net_bridge_port *port);
+br_multicast_rport_del_notify(struct net_bridge_mcast_port *pmctx, bool deleted);
+static void br_ip6_multicast_add_router(struct net_bridge_mcast *brmctx,
+					struct net_bridge_mcast_port *pmctx);
 #if IS_ENABLED(CONFIG_IPV6)
-static void br_ip6_multicast_leave_group(struct net_bridge *br,
-					 struct net_bridge_port *port,
+static void br_ip6_multicast_leave_group(struct net_bridge_mcast *brmctx,
+					 struct net_bridge_mcast_port *pmctx,
 					 const struct in6_addr *group,
 					 __u16 vid, const unsigned char *src);
 #endif
 static struct net_bridge_port_group *
-__br_multicast_add_group(struct net_bridge *br,
-			 struct net_bridge_port *port,
+__br_multicast_add_group(struct net_bridge_mcast *brmctx,
+			 struct net_bridge_mcast_port *pmctx,
 			 struct br_ip *group,
 			 const unsigned char *src,
 			 u8 filter_mode,
@@ -140,9 +140,10 @@ static struct net_bridge_mdb_entry *br_mdb_ip6_get(struct net_bridge *br,
 }
 #endif
 
-struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
+struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge_mcast *brmctx,
 					struct sk_buff *skb, u16 vid)
 {
+	struct net_bridge *br = brmctx->br;
 	struct br_ip ip;
 
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
@@ -158,7 +159,7 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		ip.dst.ip4 = ip_hdr(skb)->daddr;
-		if (br->multicast_ctx.multicast_igmp_version == 3) {
+		if (brmctx->multicast_igmp_version == 3) {
 			struct net_bridge_mdb_entry *mdb;
 
 			ip.src.ip4 = ip_hdr(skb)->saddr;
@@ -171,7 +172,7 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
 		ip.dst.ip6 = ipv6_hdr(skb)->daddr;
-		if (br->multicast_ctx.multicast_mld_version == 2) {
+		if (brmctx->multicast_mld_version == 2) {
 			struct net_bridge_mdb_entry *mdb;
 
 			ip.src.ip6 = ipv6_hdr(skb)->saddr;
@@ -203,20 +204,23 @@ static bool br_port_group_equal(struct net_bridge_port_group *p,
 	return ether_addr_equal(src, p->eth_addr);
 }
 
-static void __fwd_add_star_excl(struct net_bridge_port_group *pg,
+static void __fwd_add_star_excl(struct net_bridge_mcast_port *pmctx,
+				struct net_bridge_port_group *pg,
 				struct br_ip *sg_ip)
 {
 	struct net_bridge_port_group_sg_key sg_key;
-	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_port_group *src_pg;
+	struct net_bridge_mcast *brmctx;
 
 	memset(&sg_key, 0, sizeof(sg_key));
+	brmctx = &pg->key.port->br->multicast_ctx;
 	sg_key.port = pg->key.port;
 	sg_key.addr = *sg_ip;
-	if (br_sg_port_find(br, &sg_key))
+	if (br_sg_port_find(brmctx->br, &sg_key))
 		return;
 
-	src_pg = __br_multicast_add_group(br, pg->key.port, sg_ip, pg->eth_addr,
+	src_pg = __br_multicast_add_group(brmctx, pmctx,
+					  sg_ip, pg->eth_addr,
 					  MCAST_INCLUDE, false, false);
 	if (IS_ERR_OR_NULL(src_pg) ||
 	    src_pg->rt_protocol != RTPROT_KERNEL)
@@ -256,6 +260,7 @@ void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
 {
 	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_port_group *pg_lst;
+	struct net_bridge_mcast_port *pmctx;
 	struct net_bridge_mdb_entry *mp;
 	struct br_ip sg_ip;
 
@@ -265,6 +270,7 @@ void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
 	mp = br_mdb_ip_get(br, &pg->key.addr);
 	if (!mp)
 		return;
+	pmctx = &pg->key.port->multicast_ctx;
 
 	memset(&sg_ip, 0, sizeof(sg_ip));
 	sg_ip = pg->key.addr;
@@ -284,7 +290,7 @@ void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
 				__fwd_del_star_excl(pg, &sg_ip);
 				break;
 			case MCAST_EXCLUDE:
-				__fwd_add_star_excl(pg, &sg_ip);
+				__fwd_add_star_excl(pmctx, pg, &sg_ip);
 				break;
 			}
 		}
@@ -377,7 +383,9 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 {
 	struct net_bridge_port_group_sg_key sg_key;
 	struct net_bridge *br = star_mp->br;
+	struct net_bridge_mcast_port *pmctx;
 	struct net_bridge_port_group *pg;
+	struct net_bridge_mcast *brmctx;
 
 	if (WARN_ON(br_multicast_is_star_g(&sg->key.addr)))
 		return;
@@ -387,6 +395,7 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 	br_multicast_sg_host_state(star_mp, sg);
 	memset(&sg_key, 0, sizeof(sg_key));
 	sg_key.addr = sg->key.addr;
+	brmctx = &br->multicast_ctx;
 	/* we need to add all exclude ports to the S,G */
 	for (pg = mlock_dereference(star_mp->ports, br);
 	     pg;
@@ -400,7 +409,8 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 		if (br_sg_port_find(br, &sg_key))
 			continue;
 
-		src_pg = __br_multicast_add_group(br, pg->key.port,
+		pmctx = &pg->key.port->multicast_ctx;
+		src_pg = __br_multicast_add_group(brmctx, pmctx,
 						  &sg->key.addr,
 						  sg->eth_addr,
 						  MCAST_INCLUDE, false, false);
@@ -414,16 +424,21 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 static void br_multicast_fwd_src_add(struct net_bridge_group_src *src)
 {
 	struct net_bridge_mdb_entry *star_mp;
+	struct net_bridge_mcast_port *pmctx;
 	struct net_bridge_port_group *sg;
+	struct net_bridge_mcast *brmctx;
 	struct br_ip sg_ip;
 
 	if (src->flags & BR_SGRP_F_INSTALLED)
 		return;
 
 	memset(&sg_ip, 0, sizeof(sg_ip));
+	pmctx = &src->pg->key.port->multicast_ctx;
+	brmctx = &src->br->multicast_ctx;
 	sg_ip = src->pg->key.addr;
 	sg_ip.src = src->addr.src;
-	sg = __br_multicast_add_group(src->br, src->pg->key.port, &sg_ip,
+
+	sg = __br_multicast_add_group(brmctx, pmctx, &sg_ip,
 				      src->pg->eth_addr, MCAST_INCLUDE, false,
 				      !timer_pending(&src->timer));
 	if (IS_ERR_OR_NULL(sg))
@@ -692,14 +707,13 @@ static void br_multicast_gc(struct hlist_head *head)
 	}
 }
 
-static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
+static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge_mcast *brmctx,
 						    struct net_bridge_port_group *pg,
 						    __be32 ip_dst, __be32 group,
 						    bool with_srcs, bool over_lmqt,
 						    u8 sflag, u8 *igmp_type,
 						    bool *need_rexmit)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	struct net_bridge_port *p = pg ? pg->key.port : NULL;
 	struct net_bridge_group_src *ent;
 	size_t pkt_size, igmp_hdr_size;
@@ -735,10 +749,10 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 
 	pkt_size = sizeof(*eth) + sizeof(*iph) + 4 + igmp_hdr_size;
 	if ((p && pkt_size > p->dev->mtu) ||
-	    pkt_size > br->dev->mtu)
+	    pkt_size > brmctx->br->dev->mtu)
 		return NULL;
 
-	skb = netdev_alloc_skb_ip_align(br->dev, pkt_size);
+	skb = netdev_alloc_skb_ip_align(brmctx->br->dev, pkt_size);
 	if (!skb)
 		goto out;
 
@@ -747,7 +761,7 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 	skb_reset_mac_header(skb);
 	eth = eth_hdr(skb);
 
-	ether_addr_copy(eth->h_source, br->dev->dev_addr);
+	ether_addr_copy(eth->h_source, brmctx->br->dev->dev_addr);
 	ip_eth_mc_map(ip_dst, eth->h_dest);
 	eth->h_proto = htons(ETH_P_IP);
 	skb_put(skb, sizeof(*eth));
@@ -763,8 +777,8 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 	iph->frag_off = htons(IP_DF);
 	iph->ttl = 1;
 	iph->protocol = IPPROTO_IGMP;
-	iph->saddr = br_opt_get(br, BROPT_MULTICAST_QUERY_USE_IFADDR) ?
-		     inet_select_addr(br->dev, 0, RT_SCOPE_LINK) : 0;
+	iph->saddr = br_opt_get(brmctx->br, BROPT_MULTICAST_QUERY_USE_IFADDR) ?
+		     inet_select_addr(brmctx->br->dev, 0, RT_SCOPE_LINK) : 0;
 	iph->daddr = ip_dst;
 	((u8 *)&iph[1])[0] = IPOPT_RA;
 	((u8 *)&iph[1])[1] = 4;
@@ -838,7 +852,7 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
+static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge_mcast *brmctx,
 						    struct net_bridge_port_group *pg,
 						    const struct in6_addr *ip6_dst,
 						    const struct in6_addr *group,
@@ -846,7 +860,6 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 						    u8 sflag, u8 *igmp_type,
 						    bool *need_rexmit)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	struct net_bridge_port *p = pg ? pg->key.port : NULL;
 	struct net_bridge_group_src *ent;
 	size_t pkt_size, mld_hdr_size;
@@ -884,10 +897,10 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 
 	pkt_size = sizeof(*eth) + sizeof(*ip6h) + 8 + mld_hdr_size;
 	if ((p && pkt_size > p->dev->mtu) ||
-	    pkt_size > br->dev->mtu)
+	    pkt_size > brmctx->br->dev->mtu)
 		return NULL;
 
-	skb = netdev_alloc_skb_ip_align(br->dev, pkt_size);
+	skb = netdev_alloc_skb_ip_align(brmctx->br->dev, pkt_size);
 	if (!skb)
 		goto out;
 
@@ -897,7 +910,7 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 	skb_reset_mac_header(skb);
 	eth = eth_hdr(skb);
 
-	ether_addr_copy(eth->h_source, br->dev->dev_addr);
+	ether_addr_copy(eth->h_source, brmctx->br->dev->dev_addr);
 	eth->h_proto = htons(ETH_P_IPV6);
 	skb_put(skb, sizeof(*eth));
 
@@ -910,14 +923,14 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 	ip6h->nexthdr = IPPROTO_HOPOPTS;
 	ip6h->hop_limit = 1;
 	ip6h->daddr = *ip6_dst;
-	if (ipv6_dev_get_saddr(dev_net(br->dev), br->dev, &ip6h->daddr, 0,
-			       &ip6h->saddr)) {
+	if (ipv6_dev_get_saddr(dev_net(brmctx->br->dev), brmctx->br->dev,
+			       &ip6h->daddr, 0, &ip6h->saddr)) {
 		kfree_skb(skb);
-		br_opt_toggle(br, BROPT_HAS_IPV6_ADDR, false);
+		br_opt_toggle(brmctx->br, BROPT_HAS_IPV6_ADDR, false);
 		return NULL;
 	}
 
-	br_opt_toggle(br, BROPT_HAS_IPV6_ADDR, true);
+	br_opt_toggle(brmctx->br, BROPT_HAS_IPV6_ADDR, true);
 	ipv6_eth_mc_map(&ip6h->daddr, eth->h_dest);
 
 	hopopt = (u8 *)(ip6h + 1);
@@ -1002,7 +1015,7 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 }
 #endif
 
-static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
+static struct sk_buff *br_multicast_alloc_query(struct net_bridge_mcast *brmctx,
 						struct net_bridge_port_group *pg,
 						struct br_ip *ip_dst,
 						struct br_ip *group,
@@ -1015,7 +1028,7 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 	switch (group->proto) {
 	case htons(ETH_P_IP):
 		ip4_dst = ip_dst ? ip_dst->dst.ip4 : htonl(INADDR_ALLHOSTS_GROUP);
-		return br_ip4_multicast_alloc_query(br, pg,
+		return br_ip4_multicast_alloc_query(brmctx, pg,
 						    ip4_dst, group->dst.ip4,
 						    with_srcs, over_lmqt,
 						    sflag, igmp_type,
@@ -1030,7 +1043,7 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 			ipv6_addr_set(&ip6_dst, htonl(0xff020000), 0, 0,
 				      htonl(1));
 
-		return br_ip6_multicast_alloc_query(br, pg,
+		return br_ip6_multicast_alloc_query(brmctx, pg,
 						    &ip6_dst, &group->dst.ip6,
 						    with_srcs, over_lmqt,
 						    sflag, igmp_type,
@@ -1238,8 +1251,8 @@ void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify)
 }
 
 static struct net_bridge_port_group *
-__br_multicast_add_group(struct net_bridge *br,
-			 struct net_bridge_port *port,
+__br_multicast_add_group(struct net_bridge_mcast *brmctx,
+			 struct net_bridge_mcast_port *pmctx,
 			 struct br_ip *group,
 			 const unsigned char *src,
 			 u8 filter_mode,
@@ -1251,29 +1264,29 @@ __br_multicast_add_group(struct net_bridge *br,
 	struct net_bridge_mdb_entry *mp;
 	unsigned long now = jiffies;
 
-	if (!netif_running(br->dev) ||
-	    (port && port->state == BR_STATE_DISABLED))
+	if (!netif_running(brmctx->br->dev) ||
+	    (pmctx && pmctx->port->state == BR_STATE_DISABLED))
 		goto out;
 
-	mp = br_multicast_new_group(br, group);
+	mp = br_multicast_new_group(brmctx->br, group);
 	if (IS_ERR(mp))
 		return ERR_CAST(mp);
 
-	if (!port) {
+	if (!pmctx) {
 		br_multicast_host_join(mp, true);
 		goto out;
 	}
 
 	for (pp = &mp->ports;
-	     (p = mlock_dereference(*pp, br)) != NULL;
+	     (p = mlock_dereference(*pp, brmctx->br)) != NULL;
 	     pp = &p->next) {
-		if (br_port_group_equal(p, port, src))
+		if (br_port_group_equal(p, pmctx->port, src))
 			goto found;
-		if ((unsigned long)p->key.port < (unsigned long)port)
+		if ((unsigned long)p->key.port < (unsigned long)pmctx->port)
 			break;
 	}
 
-	p = br_multicast_new_port_group(port, group, *pp, 0, src,
+	p = br_multicast_new_port_group(pmctx->port, group, *pp, 0, src,
 					filter_mode, RTPROT_KERNEL);
 	if (unlikely(!p)) {
 		p = ERR_PTR(-ENOMEM);
@@ -1282,19 +1295,19 @@ __br_multicast_add_group(struct net_bridge *br,
 	rcu_assign_pointer(*pp, p);
 	if (blocked)
 		p->flags |= MDB_PG_FLAGS_BLOCKED;
-	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
+	br_mdb_notify(brmctx->br->dev, mp, p, RTM_NEWMDB);
 
 found:
 	if (igmpv2_mldv1)
 		mod_timer(&p->timer,
-			  now + br->multicast_ctx.multicast_membership_interval);
+			  now + brmctx->multicast_membership_interval);
 
 out:
 	return p;
 }
 
-static int br_multicast_add_group(struct net_bridge *br,
-				  struct net_bridge_port *port,
+static int br_multicast_add_group(struct net_bridge_mcast *brmctx,
+				  struct net_bridge_mcast_port *pmctx,
 				  struct br_ip *group,
 				  const unsigned char *src,
 				  u8 filter_mode,
@@ -1303,18 +1316,18 @@ static int br_multicast_add_group(struct net_bridge *br,
 	struct net_bridge_port_group *pg;
 	int err;
 
-	spin_lock(&br->multicast_lock);
-	pg = __br_multicast_add_group(br, port, group, src, filter_mode,
+	spin_lock(&brmctx->br->multicast_lock);
+	pg = __br_multicast_add_group(brmctx, pmctx, group, src, filter_mode,
 				      igmpv2_mldv1, false);
 	/* NULL is considered valid for host joined groups */
 	err = PTR_ERR_OR_ZERO(pg);
-	spin_unlock(&br->multicast_lock);
+	spin_unlock(&brmctx->br->multicast_lock);
 
 	return err;
 }
 
-static int br_ip4_multicast_add_group(struct net_bridge *br,
-				      struct net_bridge_port *port,
+static int br_ip4_multicast_add_group(struct net_bridge_mcast *brmctx,
+				      struct net_bridge_mcast_port *pmctx,
 				      __be32 group,
 				      __u16 vid,
 				      const unsigned char *src,
@@ -1332,13 +1345,13 @@ static int br_ip4_multicast_add_group(struct net_bridge *br,
 	br_group.vid = vid;
 	filter_mode = igmpv2 ? MCAST_EXCLUDE : MCAST_INCLUDE;
 
-	return br_multicast_add_group(br, port, &br_group, src, filter_mode,
-				      igmpv2);
+	return br_multicast_add_group(brmctx, pmctx, &br_group, src,
+				      filter_mode, igmpv2);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int br_ip6_multicast_add_group(struct net_bridge *br,
-				      struct net_bridge_port *port,
+static int br_ip6_multicast_add_group(struct net_bridge_mcast *brmctx,
+				      struct net_bridge_mcast_port *pmctx,
 				      const struct in6_addr *group,
 				      __u16 vid,
 				      const unsigned char *src,
@@ -1356,8 +1369,8 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 	br_group.vid = vid;
 	filter_mode = mldv1 ? MCAST_EXCLUDE : MCAST_INCLUDE;
 
-	return br_multicast_add_group(br, port, &br_group, src, filter_mode,
-				      mldv1);
+	return br_multicast_add_group(brmctx, pmctx, &br_group, src,
+				      filter_mode, mldv1);
 }
 #endif
 
@@ -1370,15 +1383,15 @@ static bool br_multicast_rport_del(struct hlist_node *rlist)
 	return true;
 }
 
-static bool br_ip4_multicast_rport_del(struct net_bridge_port *p)
+static bool br_ip4_multicast_rport_del(struct net_bridge_mcast_port *pmctx)
 {
-	return br_multicast_rport_del(&p->multicast_ctx.ip4_rlist);
+	return br_multicast_rport_del(&pmctx->ip4_rlist);
 }
 
-static bool br_ip6_multicast_rport_del(struct net_bridge_port *p)
+static bool br_ip6_multicast_rport_del(struct net_bridge_mcast_port *pmctx)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	return br_multicast_rport_del(&p->multicast_ctx.ip6_rlist);
+	return br_multicast_rport_del(&pmctx->ip6_rlist);
 #else
 	return false;
 #endif
@@ -1398,7 +1411,7 @@ static void br_multicast_router_expired(struct net_bridge_mcast_port *pmctx,
 		goto out;
 
 	del = br_multicast_rport_del(rlist);
-	br_multicast_rport_del_notify(pmctx->port, del);
+	br_multicast_rport_del_notify(pmctx, del);
 out:
 	spin_unlock(&br->multicast_lock);
 }
@@ -1475,7 +1488,7 @@ static void br_multicast_querier_expired(struct net_bridge_mcast *brmctx,
 	    !br_opt_get(brmctx->br, BROPT_MULTICAST_ENABLED))
 		goto out;
 
-	br_multicast_start_querier(brmctx->br, query);
+	br_multicast_start_querier(brmctx, query);
 
 out:
 	spin_unlock(&brmctx->br->multicast_lock);
@@ -1499,12 +1512,10 @@ static void br_ip6_multicast_querier_expired(struct timer_list *t)
 }
 #endif
 
-static void br_multicast_select_own_querier(struct net_bridge *br,
+static void br_multicast_select_own_querier(struct net_bridge_mcast *brmctx,
 					    struct br_ip *ip,
 					    struct sk_buff *skb)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
-
 	if (ip->proto == htons(ETH_P_IP))
 		brmctx->ip4_querier.addr.src.ip4 = ip_hdr(skb)->saddr;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1513,8 +1524,8 @@ static void br_multicast_select_own_querier(struct net_bridge *br,
 #endif
 }
 
-static void __br_multicast_send_query(struct net_bridge *br,
-				      struct net_bridge_port *port,
+static void __br_multicast_send_query(struct net_bridge_mcast *brmctx,
+				      struct net_bridge_mcast_port *pmctx,
 				      struct net_bridge_port_group *pg,
 				      struct br_ip *ip_dst,
 				      struct br_ip *group,
@@ -1527,18 +1538,18 @@ static void __br_multicast_send_query(struct net_bridge *br,
 	u8 igmp_type;
 
 again_under_lmqt:
-	skb = br_multicast_alloc_query(br, pg, ip_dst, group, with_srcs,
+	skb = br_multicast_alloc_query(brmctx, pg, ip_dst, group, with_srcs,
 				       over_lmqt, sflag, &igmp_type,
 				       need_rexmit);
 	if (!skb)
 		return;
 
-	if (port) {
-		skb->dev = port->dev;
-		br_multicast_count(br, port, skb, igmp_type,
+	if (pmctx) {
+		skb->dev = pmctx->port->dev;
+		br_multicast_count(brmctx->br, pmctx->port, skb, igmp_type,
 				   BR_MCAST_DIR_TX);
 		NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT,
-			dev_net(port->dev), NULL, skb, NULL, skb->dev,
+			dev_net(pmctx->port->dev), NULL, skb, NULL, skb->dev,
 			br_dev_queue_push_xmit);
 
 		if (over_lmqt && with_srcs && sflag) {
@@ -1546,31 +1557,30 @@ static void __br_multicast_send_query(struct net_bridge *br,
 			goto again_under_lmqt;
 		}
 	} else {
-		br_multicast_select_own_querier(br, group, skb);
-		br_multicast_count(br, port, skb, igmp_type,
+		br_multicast_select_own_querier(brmctx, group, skb);
+		br_multicast_count(brmctx->br, NULL, skb, igmp_type,
 				   BR_MCAST_DIR_RX);
 		netif_rx(skb);
 	}
 }
 
-static void br_multicast_send_query(struct net_bridge *br,
-				    struct net_bridge_port *port,
+static void br_multicast_send_query(struct net_bridge_mcast *brmctx,
+				    struct net_bridge_mcast_port *pmctx,
 				    struct bridge_mcast_own_query *own_query)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	struct bridge_mcast_other_query *other_query = NULL;
 	struct br_ip br_group;
 	unsigned long time;
 
-	if (!netif_running(br->dev) ||
-	    !br_opt_get(br, BROPT_MULTICAST_ENABLED) ||
-	    !br_opt_get(br, BROPT_MULTICAST_QUERIER))
+	if (!netif_running(brmctx->br->dev) ||
+	    !br_opt_get(brmctx->br, BROPT_MULTICAST_ENABLED) ||
+	    !br_opt_get(brmctx->br, BROPT_MULTICAST_QUERIER))
 		return;
 
 	memset(&br_group.dst, 0, sizeof(br_group.dst));
 
-	if (port ? (own_query == &port->multicast_ctx.ip4_own_query) :
-		   (own_query == &brmctx->ip4_own_query)) {
+	if (pmctx ? (own_query == &pmctx->ip4_own_query) :
+		    (own_query == &brmctx->ip4_own_query)) {
 		other_query = &brmctx->ip4_other_query;
 		br_group.proto = htons(ETH_P_IP);
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1583,8 +1593,8 @@ static void br_multicast_send_query(struct net_bridge *br,
 	if (!other_query || timer_pending(&other_query->timer))
 		return;
 
-	__br_multicast_send_query(br, port, NULL, NULL, &br_group, false, 0,
-				  NULL);
+	__br_multicast_send_query(brmctx, pmctx, NULL, NULL, &br_group, false,
+				  0, NULL);
 
 	time = jiffies;
 	time += own_query->startup_sent < brmctx->multicast_startup_query_count ?
@@ -1607,7 +1617,7 @@ br_multicast_port_query_expired(struct net_bridge_mcast_port *pmctx,
 	if (query->startup_sent < br->multicast_ctx.multicast_startup_query_count)
 		query->startup_sent++;
 
-	br_multicast_send_query(pmctx->port->br, pmctx->port, query);
+	br_multicast_send_query(&br->multicast_ctx, pmctx, query);
 
 out:
 	spin_unlock(&br->multicast_lock);
@@ -1636,7 +1646,8 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 	struct net_bridge_port_group *pg = from_timer(pg, t, rexmit_timer);
 	struct bridge_mcast_other_query *other_query = NULL;
 	struct net_bridge *br = pg->key.port->br;
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
+	struct net_bridge_mcast_port *pmctx;
+	struct net_bridge_mcast *brmctx;
 	bool need_rexmit = false;
 
 	spin_lock(&br->multicast_lock);
@@ -1645,6 +1656,8 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 	    !br_opt_get(br, BROPT_MULTICAST_QUERIER))
 		goto out;
 
+	brmctx = &br->multicast_ctx;
+	pmctx = &pg->key.port->multicast_ctx;
 	if (pg->key.addr.proto == htons(ETH_P_IP))
 		other_query = &brmctx->ip4_other_query;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1657,10 +1670,10 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 
 	if (pg->grp_query_rexmit_cnt) {
 		pg->grp_query_rexmit_cnt--;
-		__br_multicast_send_query(br, pg->key.port, pg, &pg->key.addr,
+		__br_multicast_send_query(brmctx, pmctx, pg, &pg->key.addr,
 					  &pg->key.addr, false, 1, NULL);
 	}
-	__br_multicast_send_query(br, pg->key.port, pg, &pg->key.addr,
+	__br_multicast_send_query(brmctx, pmctx, pg, &pg->key.addr,
 				  &pg->key.addr, true, 0, &need_rexmit);
 
 	if (pg->grp_query_rexmit_cnt || need_rexmit)
@@ -1756,20 +1769,21 @@ static void br_multicast_enable(struct bridge_mcast_own_query *query)
 		mod_timer(&query->timer, jiffies);
 }
 
-static void __br_multicast_enable_port(struct net_bridge_port *port)
+static void __br_multicast_enable_port_ctx(struct net_bridge_mcast_port *pmctx)
 {
-	struct net_bridge *br = port->br;
+	struct net_bridge *br = pmctx->port->br;
+	struct net_bridge_mcast *brmctx = &pmctx->port->br->multicast_ctx;
 
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED) || !netif_running(br->dev))
 		return;
 
-	br_multicast_enable(&port->multicast_ctx.ip4_own_query);
+	br_multicast_enable(&pmctx->ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
-	br_multicast_enable(&port->multicast_ctx.ip6_own_query);
+	br_multicast_enable(&pmctx->ip6_own_query);
 #endif
-	if (port->multicast_ctx.multicast_router == MDB_RTR_TYPE_PERM) {
-		br_ip4_multicast_add_router(br, port);
-		br_ip6_multicast_add_router(br, port);
+	if (pmctx->multicast_router == MDB_RTR_TYPE_PERM) {
+		br_ip4_multicast_add_router(brmctx, pmctx);
+		br_ip6_multicast_add_router(brmctx, pmctx);
 	}
 }
 
@@ -1778,12 +1792,13 @@ void br_multicast_enable_port(struct net_bridge_port *port)
 	struct net_bridge *br = port->br;
 
 	spin_lock(&br->multicast_lock);
-	__br_multicast_enable_port(port);
+	__br_multicast_enable_port_ctx(&port->multicast_ctx);
 	spin_unlock(&br->multicast_lock);
 }
 
 void br_multicast_disable_port(struct net_bridge_port *port)
 {
+	struct net_bridge_mcast_port *pmctx = &port->multicast_ctx;
 	struct net_bridge *br = port->br;
 	struct net_bridge_port_group *pg;
 	struct hlist_node *n;
@@ -1794,15 +1809,15 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 		if (!(pg->flags & MDB_PG_FLAGS_PERMANENT))
 			br_multicast_find_del_pg(br, pg);
 
-	del |= br_ip4_multicast_rport_del(port);
-	del_timer(&port->multicast_ctx.ip4_mc_router_timer);
-	del_timer(&port->multicast_ctx.ip4_own_query.timer);
-	del |= br_ip6_multicast_rport_del(port);
+	del |= br_ip4_multicast_rport_del(pmctx);
+	del_timer(&pmctx->ip4_mc_router_timer);
+	del_timer(&pmctx->ip4_own_query.timer);
+	del |= br_ip6_multicast_rport_del(pmctx);
 #if IS_ENABLED(CONFIG_IPV6)
-	del_timer(&port->multicast_ctx.ip6_mc_router_timer);
-	del_timer(&port->multicast_ctx.ip6_own_query.timer);
+	del_timer(&pmctx->ip6_mc_router_timer);
+	del_timer(&pmctx->ip6_own_query.timer);
 #endif
-	br_multicast_rport_del_notify(port, del);
+	br_multicast_rport_del_notify(pmctx, del);
 	spin_unlock(&br->multicast_lock);
 }
 
@@ -1828,17 +1843,17 @@ static void __grp_src_mod_timer(struct net_bridge_group_src *src,
 	br_multicast_fwd_src_handle(src);
 }
 
-static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
+static void __grp_src_query_marked_and_rexmit(struct net_bridge_mcast *brmctx,
+					      struct net_bridge_mcast_port *pmctx,
+					      struct net_bridge_port_group *pg)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
-	struct net_bridge *br = pg->key.port->br;
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	u32 lmqc = brmctx->multicast_last_member_count;
 	unsigned long lmqt, lmi, now = jiffies;
 	struct net_bridge_group_src *ent;
 
-	if (!netif_running(br->dev) ||
-	    !br_opt_get(br, BROPT_MULTICAST_ENABLED))
+	if (!netif_running(brmctx->br->dev) ||
+	    !br_opt_get(brmctx->br, BROPT_MULTICAST_ENABLED))
 		return;
 
 	if (pg->key.addr.proto == htons(ETH_P_IP))
@@ -1848,12 +1863,13 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 		other_query = &brmctx->ip6_other_query;
 #endif
 
-	lmqt = now + br_multicast_lmqt(br);
+	lmqt = now + br_multicast_lmqt(brmctx);
 	hlist_for_each_entry(ent, &pg->src_list, node) {
 		if (ent->flags & BR_SGRP_F_SEND) {
 			ent->flags &= ~BR_SGRP_F_SEND;
 			if (ent->timer.expires > lmqt) {
-				if (br_opt_get(br, BROPT_MULTICAST_QUERIER) &&
+				if (br_opt_get(brmctx->br,
+					       BROPT_MULTICAST_QUERIER) &&
 				    other_query &&
 				    !timer_pending(&other_query->timer))
 					ent->src_query_rexmit_cnt = lmqc;
@@ -1862,11 +1878,11 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 		}
 	}
 
-	if (!br_opt_get(br, BROPT_MULTICAST_QUERIER) ||
+	if (!br_opt_get(brmctx->br, BROPT_MULTICAST_QUERIER) ||
 	    !other_query || timer_pending(&other_query->timer))
 		return;
 
-	__br_multicast_send_query(br, pg->key.port, pg, &pg->key.addr,
+	__br_multicast_send_query(brmctx, pmctx, pg, &pg->key.addr,
 				  &pg->key.addr, true, 1, NULL);
 
 	lmi = now + brmctx->multicast_last_member_interval;
@@ -1875,15 +1891,15 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 		mod_timer(&pg->rexmit_timer, lmi);
 }
 
-static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
+static void __grp_send_query_and_rexmit(struct net_bridge_mcast *brmctx,
+					struct net_bridge_mcast_port *pmctx,
+					struct net_bridge_port_group *pg)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
-	struct net_bridge *br = pg->key.port->br;
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	unsigned long now = jiffies, lmi;
 
-	if (!netif_running(br->dev) ||
-	    !br_opt_get(br, BROPT_MULTICAST_ENABLED))
+	if (!netif_running(brmctx->br->dev) ||
+	    !br_opt_get(brmctx->br, BROPT_MULTICAST_ENABLED))
 		return;
 
 	if (pg->key.addr.proto == htons(ETH_P_IP))
@@ -1893,11 +1909,11 @@ static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
 		other_query = &brmctx->ip6_other_query;
 #endif
 
-	if (br_opt_get(br, BROPT_MULTICAST_QUERIER) &&
+	if (br_opt_get(brmctx->br, BROPT_MULTICAST_QUERIER) &&
 	    other_query && !timer_pending(&other_query->timer)) {
 		lmi = now + brmctx->multicast_last_member_interval;
 		pg->grp_query_rexmit_cnt = brmctx->multicast_last_member_count - 1;
-		__br_multicast_send_query(br, pg->key.port, pg, &pg->key.addr,
+		__br_multicast_send_query(brmctx, pmctx, pg, &pg->key.addr,
 					  &pg->key.addr, false, 0, NULL);
 		if (!timer_pending(&pg->rexmit_timer) ||
 		    time_after(pg->rexmit_timer.expires, lmi))
@@ -1906,8 +1922,8 @@ static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
 
 	if (pg->filter_mode == MCAST_EXCLUDE &&
 	    (!timer_pending(&pg->timer) ||
-	     time_after(pg->timer.expires, now + br_multicast_lmqt(br))))
-		mod_timer(&pg->timer, now + br_multicast_lmqt(br));
+	     time_after(pg->timer.expires, now + br_multicast_lmqt(brmctx))))
+		mod_timer(&pg->timer, now + br_multicast_lmqt(brmctx));
 }
 
 /* State          Msg type      New state                Actions
@@ -1915,11 +1931,11 @@ static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
  * INCLUDE (A)    ALLOW (B)     INCLUDE (A+B)            (B)=GMI
  * EXCLUDE (X,Y)  ALLOW (A)     EXCLUDE (X+A,Y-A)        (A)=GMI
  */
-static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg, void *h_addr,
+static bool br_multicast_isinc_allow(const struct net_bridge_mcast *brmctx,
+				     struct net_bridge_port_group *pg, void *h_addr,
 				     void *srcs, u32 nsrcs, size_t addr_size,
 				     int grec_type)
 {
-	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_group_src *ent;
 	unsigned long now = jiffies;
 	bool changed = false;
@@ -1938,10 +1954,11 @@ static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg, void *h_a
 		}
 
 		if (ent)
-			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
+			__grp_src_mod_timer(ent, now + br_multicast_gmi(brmctx));
 	}
 
-	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+	if (br_multicast_eht_handle(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
+				    grec_type))
 		changed = true;
 
 	return changed;
@@ -1952,7 +1969,8 @@ static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg, void *h_a
  *                                                       Delete (A-B)
  *                                                       Group Timer=GMI
  */
-static void __grp_src_isexc_incl(struct net_bridge_port_group *pg, void *h_addr,
+static void __grp_src_isexc_incl(const struct net_bridge_mcast *brmctx,
+				 struct net_bridge_port_group *pg, void *h_addr,
 				 void *srcs, u32 nsrcs, size_t addr_size,
 				 int grec_type)
 {
@@ -1976,7 +1994,8 @@ static void __grp_src_isexc_incl(struct net_bridge_port_group *pg, void *h_addr,
 			br_multicast_fwd_src_handle(ent);
 	}
 
-	br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type);
+	br_multicast_eht_handle(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
+				grec_type);
 
 	__grp_src_delete_marked(pg);
 }
@@ -1987,11 +2006,11 @@ static void __grp_src_isexc_incl(struct net_bridge_port_group *pg, void *h_addr,
  *                                                       Delete (Y-A)
  *                                                       Group Timer=GMI
  */
-static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg, void *h_addr,
+static bool __grp_src_isexc_excl(const struct net_bridge_mcast *brmctx,
+				 struct net_bridge_port_group *pg, void *h_addr,
 				 void *srcs, u32 nsrcs, size_t addr_size,
 				 int grec_type)
 {
-	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_group_src *ent;
 	unsigned long now = jiffies;
 	bool changed = false;
@@ -2012,13 +2031,14 @@ static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg, void *h_addr,
 			ent = br_multicast_new_group_src(pg, &src_ip);
 			if (ent) {
 				__grp_src_mod_timer(ent,
-						    now + br_multicast_gmi(br));
+						    now + br_multicast_gmi(brmctx));
 				changed = true;
 			}
 		}
 	}
 
-	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+	if (br_multicast_eht_handle(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
+				    grec_type))
 		changed = true;
 
 	if (__grp_src_delete_marked(pg))
@@ -2027,28 +2047,28 @@ static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg, void *h_addr,
 	return changed;
 }
 
-static bool br_multicast_isexc(struct net_bridge_port_group *pg, void *h_addr,
+static bool br_multicast_isexc(const struct net_bridge_mcast *brmctx,
+			       struct net_bridge_port_group *pg, void *h_addr,
 			       void *srcs, u32 nsrcs, size_t addr_size,
 			       int grec_type)
 {
-	struct net_bridge *br = pg->key.port->br;
 	bool changed = false;
 
 	switch (pg->filter_mode) {
 	case MCAST_INCLUDE:
-		__grp_src_isexc_incl(pg, h_addr, srcs, nsrcs, addr_size,
+		__grp_src_isexc_incl(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
 				     grec_type);
 		br_multicast_star_g_handle_mode(pg, MCAST_EXCLUDE);
 		changed = true;
 		break;
 	case MCAST_EXCLUDE:
-		changed = __grp_src_isexc_excl(pg, h_addr, srcs, nsrcs, addr_size,
-					       grec_type);
+		changed = __grp_src_isexc_excl(brmctx, pg, h_addr, srcs, nsrcs,
+					       addr_size, grec_type);
 		break;
 	}
 
 	pg->filter_mode = MCAST_EXCLUDE;
-	mod_timer(&pg->timer, jiffies + br_multicast_gmi(br));
+	mod_timer(&pg->timer, jiffies + br_multicast_gmi(brmctx));
 
 	return changed;
 }
@@ -2057,11 +2077,12 @@ static bool br_multicast_isexc(struct net_bridge_port_group *pg, void *h_addr,
  * INCLUDE (A)    TO_IN (B)     INCLUDE (A+B)            (B)=GMI
  *                                                       Send Q(G,A-B)
  */
-static bool __grp_src_toin_incl(struct net_bridge_port_group *pg, void *h_addr,
+static bool __grp_src_toin_incl(struct net_bridge_mcast *brmctx,
+				struct net_bridge_mcast_port *pmctx,
+				struct net_bridge_port_group *pg, void *h_addr,
 				void *srcs, u32 nsrcs, size_t addr_size,
 				int grec_type)
 {
-	struct net_bridge *br = pg->key.port->br;
 	u32 src_idx, to_send = pg->src_ents;
 	struct net_bridge_group_src *ent;
 	unsigned long now = jiffies;
@@ -2085,14 +2106,15 @@ static bool __grp_src_toin_incl(struct net_bridge_port_group *pg, void *h_addr,
 				changed = true;
 		}
 		if (ent)
-			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
+			__grp_src_mod_timer(ent, now + br_multicast_gmi(brmctx));
 	}
 
-	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+	if (br_multicast_eht_handle(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
+				    grec_type))
 		changed = true;
 
 	if (to_send)
-		__grp_src_query_marked_and_rexmit(pg);
+		__grp_src_query_marked_and_rexmit(brmctx, pmctx, pg);
 
 	return changed;
 }
@@ -2102,11 +2124,12 @@ static bool __grp_src_toin_incl(struct net_bridge_port_group *pg, void *h_addr,
  *                                                       Send Q(G,X-A)
  *                                                       Send Q(G)
  */
-static bool __grp_src_toin_excl(struct net_bridge_port_group *pg, void *h_addr,
+static bool __grp_src_toin_excl(struct net_bridge_mcast *brmctx,
+				struct net_bridge_mcast_port *pmctx,
+				struct net_bridge_port_group *pg, void *h_addr,
 				void *srcs, u32 nsrcs, size_t addr_size,
 				int grec_type)
 {
-	struct net_bridge *br = pg->key.port->br;
 	u32 src_idx, to_send = pg->src_ents;
 	struct net_bridge_group_src *ent;
 	unsigned long now = jiffies;
@@ -2133,21 +2156,24 @@ static bool __grp_src_toin_excl(struct net_bridge_port_group *pg, void *h_addr,
 				changed = true;
 		}
 		if (ent)
-			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
+			__grp_src_mod_timer(ent, now + br_multicast_gmi(brmctx));
 	}
 
-	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+	if (br_multicast_eht_handle(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
+				    grec_type))
 		changed = true;
 
 	if (to_send)
-		__grp_src_query_marked_and_rexmit(pg);
+		__grp_src_query_marked_and_rexmit(brmctx, pmctx, pg);
 
-	__grp_send_query_and_rexmit(pg);
+	__grp_send_query_and_rexmit(brmctx, pmctx, pg);
 
 	return changed;
 }
 
-static bool br_multicast_toin(struct net_bridge_port_group *pg, void *h_addr,
+static bool br_multicast_toin(struct net_bridge_mcast *brmctx,
+			      struct net_bridge_mcast_port *pmctx,
+			      struct net_bridge_port_group *pg, void *h_addr,
 			      void *srcs, u32 nsrcs, size_t addr_size,
 			      int grec_type)
 {
@@ -2155,12 +2181,12 @@ static bool br_multicast_toin(struct net_bridge_port_group *pg, void *h_addr,
 
 	switch (pg->filter_mode) {
 	case MCAST_INCLUDE:
-		changed = __grp_src_toin_incl(pg, h_addr, srcs, nsrcs, addr_size,
-					      grec_type);
+		changed = __grp_src_toin_incl(brmctx, pmctx, pg, h_addr, srcs,
+					      nsrcs, addr_size, grec_type);
 		break;
 	case MCAST_EXCLUDE:
-		changed = __grp_src_toin_excl(pg, h_addr, srcs, nsrcs, addr_size,
-					      grec_type);
+		changed = __grp_src_toin_excl(brmctx, pmctx, pg, h_addr, srcs,
+					      nsrcs, addr_size, grec_type);
 		break;
 	}
 
@@ -2182,7 +2208,9 @@ static bool br_multicast_toin(struct net_bridge_port_group *pg, void *h_addr,
  *                                                       Send Q(G,A*B)
  *                                                       Group Timer=GMI
  */
-static void __grp_src_toex_incl(struct net_bridge_port_group *pg, void *h_addr,
+static void __grp_src_toex_incl(struct net_bridge_mcast *brmctx,
+				struct net_bridge_mcast_port *pmctx,
+				struct net_bridge_port_group *pg, void *h_addr,
 				void *srcs, u32 nsrcs, size_t addr_size,
 				int grec_type)
 {
@@ -2209,11 +2237,12 @@ static void __grp_src_toex_incl(struct net_bridge_port_group *pg, void *h_addr,
 			br_multicast_fwd_src_handle(ent);
 	}
 
-	br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type);
+	br_multicast_eht_handle(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
+				grec_type);
 
 	__grp_src_delete_marked(pg);
 	if (to_send)
-		__grp_src_query_marked_and_rexmit(pg);
+		__grp_src_query_marked_and_rexmit(brmctx, pmctx, pg);
 }
 
 /* State          Msg type      New state                Actions
@@ -2223,7 +2252,9 @@ static void __grp_src_toex_incl(struct net_bridge_port_group *pg, void *h_addr,
  *                                                       Send Q(G,A-Y)
  *                                                       Group Timer=GMI
  */
-static bool __grp_src_toex_excl(struct net_bridge_port_group *pg, void *h_addr,
+static bool __grp_src_toex_excl(struct net_bridge_mcast *brmctx,
+				struct net_bridge_mcast_port *pmctx,
+				struct net_bridge_port_group *pg, void *h_addr,
 				void *srcs, u32 nsrcs, size_t addr_size,
 				int grec_type)
 {
@@ -2255,39 +2286,41 @@ static bool __grp_src_toex_excl(struct net_bridge_port_group *pg, void *h_addr,
 		}
 	}
 
-	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+	if (br_multicast_eht_handle(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
+				    grec_type))
 		changed = true;
 
 	if (__grp_src_delete_marked(pg))
 		changed = true;
 	if (to_send)
-		__grp_src_query_marked_and_rexmit(pg);
+		__grp_src_query_marked_and_rexmit(brmctx, pmctx, pg);
 
 	return changed;
 }
 
-static bool br_multicast_toex(struct net_bridge_port_group *pg, void *h_addr,
+static bool br_multicast_toex(struct net_bridge_mcast *brmctx,
+			      struct net_bridge_mcast_port *pmctx,
+			      struct net_bridge_port_group *pg, void *h_addr,
 			      void *srcs, u32 nsrcs, size_t addr_size,
 			      int grec_type)
 {
-	struct net_bridge *br = pg->key.port->br;
 	bool changed = false;
 
 	switch (pg->filter_mode) {
 	case MCAST_INCLUDE:
-		__grp_src_toex_incl(pg, h_addr, srcs, nsrcs, addr_size,
-				    grec_type);
+		__grp_src_toex_incl(brmctx, pmctx, pg, h_addr, srcs, nsrcs,
+				    addr_size, grec_type);
 		br_multicast_star_g_handle_mode(pg, MCAST_EXCLUDE);
 		changed = true;
 		break;
 	case MCAST_EXCLUDE:
-		changed = __grp_src_toex_excl(pg, h_addr, srcs, nsrcs, addr_size,
-					      grec_type);
+		changed = __grp_src_toex_excl(brmctx, pmctx, pg, h_addr, srcs,
+					      nsrcs, addr_size, grec_type);
 		break;
 	}
 
 	pg->filter_mode = MCAST_EXCLUDE;
-	mod_timer(&pg->timer, jiffies + br_multicast_gmi(br));
+	mod_timer(&pg->timer, jiffies + br_multicast_gmi(brmctx));
 
 	return changed;
 }
@@ -2295,7 +2328,9 @@ static bool br_multicast_toex(struct net_bridge_port_group *pg, void *h_addr,
 /* State          Msg type      New state                Actions
  * INCLUDE (A)    BLOCK (B)     INCLUDE (A)              Send Q(G,A*B)
  */
-static bool __grp_src_block_incl(struct net_bridge_port_group *pg, void *h_addr,
+static bool __grp_src_block_incl(struct net_bridge_mcast *brmctx,
+				 struct net_bridge_mcast_port *pmctx,
+				 struct net_bridge_port_group *pg, void *h_addr,
 				 void *srcs, u32 nsrcs, size_t addr_size, int grec_type)
 {
 	struct net_bridge_group_src *ent;
@@ -2317,11 +2352,12 @@ static bool __grp_src_block_incl(struct net_bridge_port_group *pg, void *h_addr,
 		}
 	}
 
-	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+	if (br_multicast_eht_handle(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
+				    grec_type))
 		changed = true;
 
 	if (to_send)
-		__grp_src_query_marked_and_rexmit(pg);
+		__grp_src_query_marked_and_rexmit(brmctx, pmctx, pg);
 
 	return changed;
 }
@@ -2330,7 +2366,9 @@ static bool __grp_src_block_incl(struct net_bridge_port_group *pg, void *h_addr,
  * EXCLUDE (X,Y)  BLOCK (A)     EXCLUDE (X+(A-Y),Y)      (A-X-Y)=Group Timer
  *                                                       Send Q(G,A-Y)
  */
-static bool __grp_src_block_excl(struct net_bridge_port_group *pg, void *h_addr,
+static bool __grp_src_block_excl(struct net_bridge_mcast *brmctx,
+				 struct net_bridge_mcast_port *pmctx,
+				 struct net_bridge_port_group *pg, void *h_addr,
 				 void *srcs, u32 nsrcs, size_t addr_size, int grec_type)
 {
 	struct net_bridge_group_src *ent;
@@ -2359,28 +2397,31 @@ static bool __grp_src_block_excl(struct net_bridge_port_group *pg, void *h_addr,
 		}
 	}
 
-	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+	if (br_multicast_eht_handle(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
+				    grec_type))
 		changed = true;
 
 	if (to_send)
-		__grp_src_query_marked_and_rexmit(pg);
+		__grp_src_query_marked_and_rexmit(brmctx, pmctx, pg);
 
 	return changed;
 }
 
-static bool br_multicast_block(struct net_bridge_port_group *pg, void *h_addr,
+static bool br_multicast_block(struct net_bridge_mcast *brmctx,
+			       struct net_bridge_mcast_port *pmctx,
+			       struct net_bridge_port_group *pg, void *h_addr,
 			       void *srcs, u32 nsrcs, size_t addr_size, int grec_type)
 {
 	bool changed = false;
 
 	switch (pg->filter_mode) {
 	case MCAST_INCLUDE:
-		changed = __grp_src_block_incl(pg, h_addr, srcs, nsrcs, addr_size,
-					       grec_type);
+		changed = __grp_src_block_incl(brmctx, pmctx, pg, h_addr, srcs,
+					       nsrcs, addr_size, grec_type);
 		break;
 	case MCAST_EXCLUDE:
-		changed = __grp_src_block_excl(pg, h_addr, srcs, nsrcs, addr_size,
-					       grec_type);
+		changed = __grp_src_block_excl(brmctx, pmctx, pg, h_addr, srcs,
+					       nsrcs, addr_size, grec_type);
 		break;
 	}
 
@@ -2415,12 +2456,12 @@ br_multicast_find_port(struct net_bridge_mdb_entry *mp,
 	return NULL;
 }
 
-static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
-					 struct net_bridge_port *port,
+static int br_ip4_multicast_igmp3_report(struct net_bridge_mcast *brmctx,
+					 struct net_bridge_mcast_port *pmctx,
 					 struct sk_buff *skb,
 					 u16 vid)
 {
-	bool igmpv2 = br->multicast_ctx.multicast_igmp_version == 2;
+	bool igmpv2 = brmctx->multicast_igmp_version == 2;
 	struct net_bridge_mdb_entry *mdst;
 	struct net_bridge_port_group *pg;
 	const unsigned char *src;
@@ -2467,25 +2508,26 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		if (nsrcs == 0 &&
 		    (type == IGMPV3_CHANGE_TO_INCLUDE ||
 		     type == IGMPV3_MODE_IS_INCLUDE)) {
-			if (!port || igmpv2) {
-				br_ip4_multicast_leave_group(br, port, group, vid, src);
+			if (!pmctx || igmpv2) {
+				br_ip4_multicast_leave_group(brmctx, pmctx,
+							     group, vid, src);
 				continue;
 			}
 		} else {
-			err = br_ip4_multicast_add_group(br, port, group, vid,
-							 src, igmpv2);
+			err = br_ip4_multicast_add_group(brmctx, pmctx, group,
+							 vid, src, igmpv2);
 			if (err)
 				break;
 		}
 
-		if (!port || igmpv2)
+		if (!pmctx || igmpv2)
 			continue;
 
-		spin_lock_bh(&br->multicast_lock);
-		mdst = br_mdb_ip4_get(br, group, vid);
+		spin_lock_bh(&brmctx->br->multicast_lock);
+		mdst = br_mdb_ip4_get(brmctx->br, group, vid);
 		if (!mdst)
 			goto unlock_continue;
-		pg = br_multicast_find_port(mdst, port, src);
+		pg = br_multicast_find_port(mdst, pmctx->port, src);
 		if (!pg || (pg->flags & MDB_PG_FLAGS_PERMANENT))
 			goto unlock_continue;
 		/* reload grec and host addr */
@@ -2493,46 +2535,52 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		h_addr = &ip_hdr(skb)->saddr;
 		switch (type) {
 		case IGMPV3_ALLOW_NEW_SOURCES:
-			changed = br_multicast_isinc_allow(pg, h_addr, grec->grec_src,
+			changed = br_multicast_isinc_allow(brmctx, pg, h_addr,
+							   grec->grec_src,
 							   nsrcs, sizeof(__be32), type);
 			break;
 		case IGMPV3_MODE_IS_INCLUDE:
-			changed = br_multicast_isinc_allow(pg, h_addr, grec->grec_src,
+			changed = br_multicast_isinc_allow(brmctx, pg, h_addr,
+							   grec->grec_src,
 							   nsrcs, sizeof(__be32), type);
 			break;
 		case IGMPV3_MODE_IS_EXCLUDE:
-			changed = br_multicast_isexc(pg, h_addr, grec->grec_src,
+			changed = br_multicast_isexc(brmctx, pg, h_addr,
+						     grec->grec_src,
 						     nsrcs, sizeof(__be32), type);
 			break;
 		case IGMPV3_CHANGE_TO_INCLUDE:
-			changed = br_multicast_toin(pg, h_addr, grec->grec_src,
+			changed = br_multicast_toin(brmctx, pmctx, pg, h_addr,
+						    grec->grec_src,
 						    nsrcs, sizeof(__be32), type);
 			break;
 		case IGMPV3_CHANGE_TO_EXCLUDE:
-			changed = br_multicast_toex(pg, h_addr, grec->grec_src,
+			changed = br_multicast_toex(brmctx, pmctx, pg, h_addr,
+						    grec->grec_src,
 						    nsrcs, sizeof(__be32), type);
 			break;
 		case IGMPV3_BLOCK_OLD_SOURCES:
-			changed = br_multicast_block(pg, h_addr, grec->grec_src,
+			changed = br_multicast_block(brmctx, pmctx, pg, h_addr,
+						     grec->grec_src,
 						     nsrcs, sizeof(__be32), type);
 			break;
 		}
 		if (changed)
-			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
+			br_mdb_notify(brmctx->br->dev, mdst, pg, RTM_NEWMDB);
 unlock_continue:
-		spin_unlock_bh(&br->multicast_lock);
+		spin_unlock_bh(&brmctx->br->multicast_lock);
 	}
 
 	return err;
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int br_ip6_multicast_mld2_report(struct net_bridge *br,
-					struct net_bridge_port *port,
+static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
+					struct net_bridge_mcast_port *pmctx,
 					struct sk_buff *skb,
 					u16 vid)
 {
-	bool mldv1 = br->multicast_ctx.multicast_mld_version == 1;
+	bool mldv1 = brmctx->multicast_mld_version == 1;
 	struct net_bridge_mdb_entry *mdst;
 	struct net_bridge_port_group *pg;
 	unsigned int nsrcs_offset;
@@ -2593,85 +2641,83 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 		if ((grec->grec_type == MLD2_CHANGE_TO_INCLUDE ||
 		     grec->grec_type == MLD2_MODE_IS_INCLUDE) &&
 		    nsrcs == 0) {
-			if (!port || mldv1) {
-				br_ip6_multicast_leave_group(br, port,
+			if (!pmctx || mldv1) {
+				br_ip6_multicast_leave_group(brmctx, pmctx,
 							     &grec->grec_mca,
 							     vid, src);
 				continue;
 			}
 		} else {
-			err = br_ip6_multicast_add_group(br, port,
+			err = br_ip6_multicast_add_group(brmctx, pmctx,
 							 &grec->grec_mca, vid,
 							 src, mldv1);
 			if (err)
 				break;
 		}
 
-		if (!port || mldv1)
+		if (!pmctx || mldv1)
 			continue;
 
-		spin_lock_bh(&br->multicast_lock);
-		mdst = br_mdb_ip6_get(br, &grec->grec_mca, vid);
+		spin_lock_bh(&brmctx->br->multicast_lock);
+		mdst = br_mdb_ip6_get(brmctx->br, &grec->grec_mca, vid);
 		if (!mdst)
 			goto unlock_continue;
-		pg = br_multicast_find_port(mdst, port, src);
+		pg = br_multicast_find_port(mdst, pmctx->port, src);
 		if (!pg || (pg->flags & MDB_PG_FLAGS_PERMANENT))
 			goto unlock_continue;
 		h_addr = &ipv6_hdr(skb)->saddr;
 		switch (grec->grec_type) {
 		case MLD2_ALLOW_NEW_SOURCES:
-			changed = br_multicast_isinc_allow(pg, h_addr,
+			changed = br_multicast_isinc_allow(brmctx, pg, h_addr,
 							   grec->grec_src, nsrcs,
 							   sizeof(struct in6_addr),
 							   grec->grec_type);
 			break;
 		case MLD2_MODE_IS_INCLUDE:
-			changed = br_multicast_isinc_allow(pg, h_addr,
+			changed = br_multicast_isinc_allow(brmctx, pg, h_addr,
 							   grec->grec_src, nsrcs,
 							   sizeof(struct in6_addr),
 							   grec->grec_type);
 			break;
 		case MLD2_MODE_IS_EXCLUDE:
-			changed = br_multicast_isexc(pg, h_addr,
+			changed = br_multicast_isexc(brmctx, pg, h_addr,
 						     grec->grec_src, nsrcs,
 						     sizeof(struct in6_addr),
 						     grec->grec_type);
 			break;
 		case MLD2_CHANGE_TO_INCLUDE:
-			changed = br_multicast_toin(pg, h_addr,
+			changed = br_multicast_toin(brmctx, pmctx, pg, h_addr,
 						    grec->grec_src, nsrcs,
 						    sizeof(struct in6_addr),
 						    grec->grec_type);
 			break;
 		case MLD2_CHANGE_TO_EXCLUDE:
-			changed = br_multicast_toex(pg, h_addr,
+			changed = br_multicast_toex(brmctx, pmctx, pg, h_addr,
 						    grec->grec_src, nsrcs,
 						    sizeof(struct in6_addr),
 						    grec->grec_type);
 			break;
 		case MLD2_BLOCK_OLD_SOURCES:
-			changed = br_multicast_block(pg, h_addr,
+			changed = br_multicast_block(brmctx, pmctx, pg, h_addr,
 						     grec->grec_src, nsrcs,
 						     sizeof(struct in6_addr),
 						     grec->grec_type);
 			break;
 		}
 		if (changed)
-			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
+			br_mdb_notify(brmctx->br->dev, mdst, pg, RTM_NEWMDB);
 unlock_continue:
-		spin_unlock_bh(&br->multicast_lock);
+		spin_unlock_bh(&brmctx->br->multicast_lock);
 	}
 
 	return err;
 }
 #endif
 
-static bool br_ip4_multicast_select_querier(struct net_bridge *br,
+static bool br_ip4_multicast_select_querier(struct net_bridge_mcast *brmctx,
 					    struct net_bridge_port *port,
 					    __be32 saddr)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
-
 	if (!timer_pending(&brmctx->ip4_own_query.timer) &&
 	    !timer_pending(&brmctx->ip4_other_query.timer))
 		goto update;
@@ -2694,12 +2740,10 @@ static bool br_ip4_multicast_select_querier(struct net_bridge *br,
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static bool br_ip6_multicast_select_querier(struct net_bridge *br,
+static bool br_ip6_multicast_select_querier(struct net_bridge_mcast *brmctx,
 					    struct net_bridge_port *port,
 					    struct in6_addr *saddr)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
-
 	if (!timer_pending(&brmctx->ip6_own_query.timer) &&
 	    !timer_pending(&brmctx->ip6_other_query.timer))
 		goto update;
@@ -2720,15 +2764,14 @@ static bool br_ip6_multicast_select_querier(struct net_bridge *br,
 #endif
 
 static void
-br_multicast_update_query_timer(struct net_bridge *br,
+br_multicast_update_query_timer(struct net_bridge_mcast *brmctx,
 				struct bridge_mcast_other_query *query,
 				unsigned long max_delay)
 {
 	if (!timer_pending(&query->timer))
 		query->delay_time = jiffies + max_delay;
 
-	mod_timer(&query->timer, jiffies +
-				 br->multicast_ctx.multicast_querier_interval);
+	mod_timer(&query->timer, jiffies + brmctx->multicast_querier_interval);
 }
 
 static void br_port_mc_router_state_change(struct net_bridge_port *p,
@@ -2785,14 +2828,14 @@ br_multicast_get_rport_slot(struct net_bridge_mcast *brmctx,
 	return slot;
 }
 
-static bool br_multicast_no_router_otherpf(struct net_bridge_port *port,
+static bool br_multicast_no_router_otherpf(struct net_bridge_mcast_port *pmctx,
 					   struct hlist_node *rnode)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	if (rnode != &port->multicast_ctx.ip6_rlist)
-		return hlist_unhashed(&port->multicast_ctx.ip6_rlist);
+	if (rnode != &pmctx->ip6_rlist)
+		return hlist_unhashed(&pmctx->ip6_rlist);
 	else
-		return hlist_unhashed(&port->multicast_ctx.ip4_rlist);
+		return hlist_unhashed(&pmctx->ip4_rlist);
 #else
 	return true;
 #endif
@@ -2803,7 +2846,7 @@ static bool br_multicast_no_router_otherpf(struct net_bridge_port *port,
  *  and locked by br->multicast_lock and RCU
  */
 static void br_multicast_add_router(struct net_bridge_mcast *brmctx,
-				    struct net_bridge_port *port,
+				    struct net_bridge_mcast_port *pmctx,
 				    struct hlist_node *rlist,
 				    struct hlist_head *mc_router_list)
 {
@@ -2812,7 +2855,7 @@ static void br_multicast_add_router(struct net_bridge_mcast *brmctx,
 	if (!hlist_unhashed(rlist))
 		return;
 
-	slot = br_multicast_get_rport_slot(brmctx, port, mc_router_list);
+	slot = br_multicast_get_rport_slot(brmctx, pmctx->port, mc_router_list);
 
 	if (slot)
 		hlist_add_behind_rcu(rlist, slot);
@@ -2823,9 +2866,9 @@ static void br_multicast_add_router(struct net_bridge_mcast *brmctx,
 	 * switched from no IPv4/IPv6 multicast router to a new
 	 * IPv4 or IPv6 multicast router.
 	 */
-	if (br_multicast_no_router_otherpf(port, rlist)) {
-		br_rtr_notify(port->br->dev, port, RTM_NEWMDB);
-		br_port_mc_router_state_change(port, true);
+	if (br_multicast_no_router_otherpf(pmctx, rlist)) {
+		br_rtr_notify(pmctx->port->br->dev, pmctx->port, RTM_NEWMDB);
+		br_port_mc_router_state_change(pmctx->port, true);
 	}
 }
 
@@ -2833,123 +2876,119 @@ static void br_multicast_add_router(struct net_bridge_mcast *brmctx,
  *  list is maintained ordered by pointer value
  *  and locked by br->multicast_lock and RCU
  */
-static void br_ip4_multicast_add_router(struct net_bridge *br,
-					struct net_bridge_port *port)
+static void br_ip4_multicast_add_router(struct net_bridge_mcast *brmctx,
+					struct net_bridge_mcast_port *pmctx)
 {
-	br_multicast_add_router(&br->multicast_ctx, port,
-				&port->multicast_ctx.ip4_rlist,
-				&br->multicast_ctx.ip4_mc_router_list);
+	br_multicast_add_router(brmctx, pmctx, &pmctx->ip4_rlist,
+				&brmctx->ip4_mc_router_list);
 }
 
 /* Add port to router_list
  *  list is maintained ordered by pointer value
  *  and locked by br->multicast_lock and RCU
  */
-static void br_ip6_multicast_add_router(struct net_bridge *br,
-					struct net_bridge_port *port)
+static void br_ip6_multicast_add_router(struct net_bridge_mcast *brmctx,
+					struct net_bridge_mcast_port *pmctx)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	br_multicast_add_router(&br->multicast_ctx, port,
-				&port->multicast_ctx.ip6_rlist,
-				&br->multicast_ctx.ip6_mc_router_list);
+	br_multicast_add_router(brmctx, pmctx, &pmctx->ip6_rlist,
+				&brmctx->ip6_mc_router_list);
 #endif
 }
 
-static void br_multicast_mark_router(struct net_bridge *br,
-				     struct net_bridge_port *port,
+static void br_multicast_mark_router(struct net_bridge_mcast *brmctx,
+				     struct net_bridge_mcast_port *pmctx,
 				     struct timer_list *timer,
 				     struct hlist_node *rlist,
 				     struct hlist_head *mc_router_list)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	unsigned long now = jiffies;
 
-	if (!port) {
+	if (!pmctx) {
 		if (brmctx->multicast_router == MDB_RTR_TYPE_TEMP_QUERY) {
 			if (!br_ip4_multicast_is_router(brmctx) &&
 			    !br_ip6_multicast_is_router(brmctx))
-				br_mc_router_state_change(br, true);
+				br_mc_router_state_change(brmctx->br, true);
 			mod_timer(timer, now + brmctx->multicast_querier_interval);
 		}
 		return;
 	}
 
-	if (port->multicast_ctx.multicast_router == MDB_RTR_TYPE_DISABLED ||
-	    port->multicast_ctx.multicast_router == MDB_RTR_TYPE_PERM)
+	if (pmctx->multicast_router == MDB_RTR_TYPE_DISABLED ||
+	    pmctx->multicast_router == MDB_RTR_TYPE_PERM)
 		return;
 
-	br_multicast_add_router(brmctx, port, rlist, mc_router_list);
+	br_multicast_add_router(brmctx, pmctx, rlist, mc_router_list);
 	mod_timer(timer, now + brmctx->multicast_querier_interval);
 }
 
-static void br_ip4_multicast_mark_router(struct net_bridge *br,
-					 struct net_bridge_port *port)
+static void br_ip4_multicast_mark_router(struct net_bridge_mcast *brmctx,
+					 struct net_bridge_mcast_port *pmctx)
 {
-	struct timer_list *timer = &br->multicast_ctx.ip4_mc_router_timer;
+	struct timer_list *timer = &brmctx->ip4_mc_router_timer;
 	struct hlist_node *rlist = NULL;
 
-	if (port) {
-		timer = &port->multicast_ctx.ip4_mc_router_timer;
-		rlist = &port->multicast_ctx.ip4_rlist;
+	if (pmctx) {
+		timer = &pmctx->ip4_mc_router_timer;
+		rlist = &pmctx->ip4_rlist;
 	}
 
-	br_multicast_mark_router(br, port, timer, rlist,
-				 &br->multicast_ctx.ip4_mc_router_list);
+	br_multicast_mark_router(brmctx, pmctx, timer, rlist,
+				 &brmctx->ip4_mc_router_list);
 }
 
-static void br_ip6_multicast_mark_router(struct net_bridge *br,
-					 struct net_bridge_port *port)
+static void br_ip6_multicast_mark_router(struct net_bridge_mcast *brmctx,
+					 struct net_bridge_mcast_port *pmctx)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	struct timer_list *timer = &br->multicast_ctx.ip6_mc_router_timer;
+	struct timer_list *timer = &brmctx->ip6_mc_router_timer;
 	struct hlist_node *rlist = NULL;
 
-	if (port) {
-		timer = &port->multicast_ctx.ip6_mc_router_timer;
-		rlist = &port->multicast_ctx.ip6_rlist;
+	if (pmctx) {
+		timer = &pmctx->ip6_mc_router_timer;
+		rlist = &pmctx->ip6_rlist;
 	}
 
-	br_multicast_mark_router(br, port, timer, rlist,
-				 &br->multicast_ctx.ip6_mc_router_list);
+	br_multicast_mark_router(brmctx, pmctx, timer, rlist,
+				 &brmctx->ip6_mc_router_list);
 #endif
 }
 
 static void
-br_ip4_multicast_query_received(struct net_bridge *br,
-				struct net_bridge_port *port,
+br_ip4_multicast_query_received(struct net_bridge_mcast *brmctx,
+				struct net_bridge_mcast_port *pmctx,
 				struct bridge_mcast_other_query *query,
 				struct br_ip *saddr,
 				unsigned long max_delay)
 {
-	if (!br_ip4_multicast_select_querier(br, port, saddr->src.ip4))
+	if (!br_ip4_multicast_select_querier(brmctx, pmctx->port, saddr->src.ip4))
 		return;
 
-	br_multicast_update_query_timer(br, query, max_delay);
-	br_ip4_multicast_mark_router(br, port);
+	br_multicast_update_query_timer(brmctx, query, max_delay);
+	br_ip4_multicast_mark_router(brmctx, pmctx);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
 static void
-br_ip6_multicast_query_received(struct net_bridge *br,
-				struct net_bridge_port *port,
+br_ip6_multicast_query_received(struct net_bridge_mcast *brmctx,
+				struct net_bridge_mcast_port *pmctx,
 				struct bridge_mcast_other_query *query,
 				struct br_ip *saddr,
 				unsigned long max_delay)
 {
-	if (!br_ip6_multicast_select_querier(br, port, &saddr->src.ip6))
+	if (!br_ip6_multicast_select_querier(brmctx, pmctx->port, &saddr->src.ip6))
 		return;
 
-	br_multicast_update_query_timer(br, query, max_delay);
-	br_ip6_multicast_mark_router(br, port);
+	br_multicast_update_query_timer(brmctx, query, max_delay);
+	br_ip6_multicast_mark_router(brmctx, pmctx);
 }
 #endif
 
-static void br_ip4_multicast_query(struct net_bridge *br,
-				   struct net_bridge_port *port,
+static void br_ip4_multicast_query(struct net_bridge_mcast *brmctx,
+				   struct net_bridge_mcast_port *pmctx,
 				   struct sk_buff *skb,
 				   u16 vid)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	unsigned int transport_len = ip_transport_len(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 	struct igmphdr *ih = igmp_hdr(skb);
@@ -2962,9 +3001,9 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 	unsigned long now = jiffies;
 	__be32 group;
 
-	spin_lock(&br->multicast_lock);
-	if (!netif_running(br->dev) ||
-	    (port && port->state == BR_STATE_DISABLED))
+	spin_lock(&brmctx->br->multicast_lock);
+	if (!netif_running(brmctx->br->dev) ||
+	    (pmctx && pmctx->port->state == BR_STATE_DISABLED))
 		goto out;
 
 	group = ih->group;
@@ -2993,13 +3032,13 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 		saddr.proto = htons(ETH_P_IP);
 		saddr.src.ip4 = iph->saddr;
 
-		br_ip4_multicast_query_received(br, port,
+		br_ip4_multicast_query_received(brmctx, pmctx,
 						&brmctx->ip4_other_query,
 						&saddr, max_delay);
 		goto out;
 	}
 
-	mp = br_mdb_ip4_get(br, group, vid);
+	mp = br_mdb_ip4_get(brmctx->br, group, vid);
 	if (!mp)
 		goto out;
 
@@ -3012,7 +3051,7 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 		mod_timer(&mp->timer, now + max_delay);
 
 	for (pp = &mp->ports;
-	     (p = mlock_dereference(*pp, br)) != NULL;
+	     (p = mlock_dereference(*pp, brmctx->br)) != NULL;
 	     pp = &p->next) {
 		if (timer_pending(&p->timer) ?
 		    time_after(p->timer.expires, now + max_delay) :
@@ -3023,16 +3062,15 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 	}
 
 out:
-	spin_unlock(&br->multicast_lock);
+	spin_unlock(&brmctx->br->multicast_lock);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int br_ip6_multicast_query(struct net_bridge *br,
-				  struct net_bridge_port *port,
+static int br_ip6_multicast_query(struct net_bridge_mcast *brmctx,
+				  struct net_bridge_mcast_port *pmctx,
 				  struct sk_buff *skb,
 				  u16 vid)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	unsigned int transport_len = ipv6_transport_len(skb);
 	struct mld_msg *mld;
 	struct net_bridge_mdb_entry *mp;
@@ -3047,9 +3085,9 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 	bool is_general_query;
 	int err = 0;
 
-	spin_lock(&br->multicast_lock);
-	if (!netif_running(br->dev) ||
-	    (port && port->state == BR_STATE_DISABLED))
+	spin_lock(&brmctx->br->multicast_lock);
+	if (!netif_running(brmctx->br->dev) ||
+	    (pmctx && pmctx->port->state == BR_STATE_DISABLED))
 		goto out;
 
 	if (transport_len == sizeof(*mld)) {
@@ -3083,7 +3121,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		saddr.proto = htons(ETH_P_IPV6);
 		saddr.src.ip6 = ipv6_hdr(skb)->saddr;
 
-		br_ip6_multicast_query_received(br, port,
+		br_ip6_multicast_query_received(brmctx, pmctx,
 						&brmctx->ip6_other_query,
 						&saddr, max_delay);
 		goto out;
@@ -3091,7 +3129,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		goto out;
 	}
 
-	mp = br_mdb_ip6_get(br, group, vid);
+	mp = br_mdb_ip6_get(brmctx->br, group, vid);
 	if (!mp)
 		goto out;
 
@@ -3103,7 +3141,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		mod_timer(&mp->timer, now + max_delay);
 
 	for (pp = &mp->ports;
-	     (p = mlock_dereference(*pp, br)) != NULL;
+	     (p = mlock_dereference(*pp, brmctx->br)) != NULL;
 	     pp = &p->next) {
 		if (timer_pending(&p->timer) ?
 		    time_after(p->timer.expires, now + max_delay) :
@@ -3114,41 +3152,40 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 	}
 
 out:
-	spin_unlock(&br->multicast_lock);
+	spin_unlock(&brmctx->br->multicast_lock);
 	return err;
 }
 #endif
 
 static void
-br_multicast_leave_group(struct net_bridge *br,
-			 struct net_bridge_port *port,
+br_multicast_leave_group(struct net_bridge_mcast *brmctx,
+			 struct net_bridge_mcast_port *pmctx,
 			 struct br_ip *group,
 			 struct bridge_mcast_other_query *other_query,
 			 struct bridge_mcast_own_query *own_query,
 			 const unsigned char *src)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
 	unsigned long now;
 	unsigned long time;
 
-	spin_lock(&br->multicast_lock);
-	if (!netif_running(br->dev) ||
-	    (port && port->state == BR_STATE_DISABLED))
+	spin_lock(&brmctx->br->multicast_lock);
+	if (!netif_running(brmctx->br->dev) ||
+	    (pmctx && pmctx->port->state == BR_STATE_DISABLED))
 		goto out;
 
-	mp = br_mdb_ip_get(br, group);
+	mp = br_mdb_ip_get(brmctx->br, group);
 	if (!mp)
 		goto out;
 
-	if (port && (port->flags & BR_MULTICAST_FAST_LEAVE)) {
+	if (pmctx && (pmctx->port->flags & BR_MULTICAST_FAST_LEAVE)) {
 		struct net_bridge_port_group __rcu **pp;
 
 		for (pp = &mp->ports;
-		     (p = mlock_dereference(*pp, br)) != NULL;
+		     (p = mlock_dereference(*pp, brmctx->br)) != NULL;
 		     pp = &p->next) {
-			if (!br_port_group_equal(p, port, src))
+			if (!br_port_group_equal(p, pmctx->port, src))
 				continue;
 
 			if (p->flags & MDB_PG_FLAGS_PERMANENT)
@@ -3163,8 +3200,8 @@ br_multicast_leave_group(struct net_bridge *br,
 	if (timer_pending(&other_query->timer))
 		goto out;
 
-	if (br_opt_get(br, BROPT_MULTICAST_QUERIER)) {
-		__br_multicast_send_query(br, port, NULL, NULL, &mp->addr,
+	if (br_opt_get(brmctx->br, BROPT_MULTICAST_QUERIER)) {
+		__br_multicast_send_query(brmctx, pmctx, NULL, NULL, &mp->addr,
 					  false, 0, NULL);
 
 		time = jiffies + brmctx->multicast_last_member_count *
@@ -3172,10 +3209,10 @@ br_multicast_leave_group(struct net_bridge *br,
 
 		mod_timer(&own_query->timer, time);
 
-		for (p = mlock_dereference(mp->ports, br);
+		for (p = mlock_dereference(mp->ports, brmctx->br);
 		     p != NULL;
-		     p = mlock_dereference(p->next, br)) {
-			if (!br_port_group_equal(p, port, src))
+		     p = mlock_dereference(p->next, brmctx->br)) {
+			if (!br_port_group_equal(p, pmctx->port, src))
 				continue;
 
 			if (!hlist_unhashed(&p->mglist) &&
@@ -3193,7 +3230,7 @@ br_multicast_leave_group(struct net_bridge *br,
 	time = now + brmctx->multicast_last_member_count *
 		     brmctx->multicast_last_member_interval;
 
-	if (!port) {
+	if (!pmctx) {
 		if (mp->host_joined &&
 		    (timer_pending(&mp->timer) ?
 		     time_after(mp->timer.expires, time) :
@@ -3204,10 +3241,10 @@ br_multicast_leave_group(struct net_bridge *br,
 		goto out;
 	}
 
-	for (p = mlock_dereference(mp->ports, br);
+	for (p = mlock_dereference(mp->ports, brmctx->br);
 	     p != NULL;
-	     p = mlock_dereference(p->next, br)) {
-		if (p->key.port != port)
+	     p = mlock_dereference(p->next, brmctx->br)) {
+		if (p->key.port != pmctx->port)
 			continue;
 
 		if (!hlist_unhashed(&p->mglist) &&
@@ -3220,11 +3257,11 @@ br_multicast_leave_group(struct net_bridge *br,
 		break;
 	}
 out:
-	spin_unlock(&br->multicast_lock);
+	spin_unlock(&brmctx->br->multicast_lock);
 }
 
-static void br_ip4_multicast_leave_group(struct net_bridge *br,
-					 struct net_bridge_port *port,
+static void br_ip4_multicast_leave_group(struct net_bridge_mcast *brmctx,
+					 struct net_bridge_mcast_port *pmctx,
 					 __be32 group,
 					 __u16 vid,
 					 const unsigned char *src)
@@ -3235,22 +3272,21 @@ static void br_ip4_multicast_leave_group(struct net_bridge *br,
 	if (ipv4_is_local_multicast(group))
 		return;
 
-	own_query = port ? &port->multicast_ctx.ip4_own_query :
-			   &br->multicast_ctx.ip4_own_query;
+	own_query = pmctx ? &pmctx->ip4_own_query : &brmctx->ip4_own_query;
 
 	memset(&br_group, 0, sizeof(br_group));
 	br_group.dst.ip4 = group;
 	br_group.proto = htons(ETH_P_IP);
 	br_group.vid = vid;
 
-	br_multicast_leave_group(br, port, &br_group,
-				 &br->multicast_ctx.ip4_other_query,
+	br_multicast_leave_group(brmctx, pmctx, &br_group,
+				 &brmctx->ip4_other_query,
 				 own_query, src);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static void br_ip6_multicast_leave_group(struct net_bridge *br,
-					 struct net_bridge_port *port,
+static void br_ip6_multicast_leave_group(struct net_bridge_mcast *brmctx,
+					 struct net_bridge_mcast_port *pmctx,
 					 const struct in6_addr *group,
 					 __u16 vid,
 					 const unsigned char *src)
@@ -3261,16 +3297,15 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
 	if (ipv6_addr_is_ll_all_nodes(group))
 		return;
 
-	own_query = port ? &port->multicast_ctx.ip6_own_query :
-			   &br->multicast_ctx.ip6_own_query;
+	own_query = pmctx ? &pmctx->ip6_own_query : &brmctx->ip6_own_query;
 
 	memset(&br_group, 0, sizeof(br_group));
 	br_group.dst.ip6 = *group;
 	br_group.proto = htons(ETH_P_IPV6);
 	br_group.vid = vid;
 
-	br_multicast_leave_group(br, port, &br_group,
-				 &br->multicast_ctx.ip6_other_query,
+	br_multicast_leave_group(brmctx, pmctx, &br_group,
+				 &brmctx->ip6_other_query,
 				 own_query, src);
 }
 #endif
@@ -3308,8 +3343,8 @@ static void br_multicast_err_count(const struct net_bridge *br,
 	u64_stats_update_end(&pstats->syncp);
 }
 
-static void br_multicast_pim(struct net_bridge *br,
-			     struct net_bridge_port *port,
+static void br_multicast_pim(struct net_bridge_mcast *brmctx,
+			     struct net_bridge_mcast_port *pmctx,
 			     const struct sk_buff *skb)
 {
 	unsigned int offset = skb_transport_offset(skb);
@@ -3320,31 +3355,32 @@ static void br_multicast_pim(struct net_bridge *br,
 	    pim_hdr_type(pimhdr) != PIM_TYPE_HELLO)
 		return;
 
-	spin_lock(&br->multicast_lock);
-	br_ip4_multicast_mark_router(br, port);
-	spin_unlock(&br->multicast_lock);
+	spin_lock(&brmctx->br->multicast_lock);
+	br_ip4_multicast_mark_router(brmctx, pmctx);
+	spin_unlock(&brmctx->br->multicast_lock);
 }
 
-static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,
-				    struct net_bridge_port *port,
+static int br_ip4_multicast_mrd_rcv(struct net_bridge_mcast *brmctx,
+				    struct net_bridge_mcast_port *pmctx,
 				    struct sk_buff *skb)
 {
 	if (ip_hdr(skb)->protocol != IPPROTO_IGMP ||
 	    igmp_hdr(skb)->type != IGMP_MRDISC_ADV)
 		return -ENOMSG;
 
-	spin_lock(&br->multicast_lock);
-	br_ip4_multicast_mark_router(br, port);
-	spin_unlock(&br->multicast_lock);
+	spin_lock(&brmctx->br->multicast_lock);
+	br_ip4_multicast_mark_router(brmctx, pmctx);
+	spin_unlock(&brmctx->br->multicast_lock);
 
 	return 0;
 }
 
-static int br_multicast_ipv4_rcv(struct net_bridge *br,
-				 struct net_bridge_port *port,
+static int br_multicast_ipv4_rcv(struct net_bridge_mcast *brmctx,
+				 struct net_bridge_mcast_port *pmctx,
 				 struct sk_buff *skb,
 				 u16 vid)
 {
+	struct net_bridge_port *p = pmctx ? pmctx->port : NULL;
 	const unsigned char *src;
 	struct igmphdr *ih;
 	int err;
@@ -3356,14 +3392,14 @@ static int br_multicast_ipv4_rcv(struct net_bridge *br,
 			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
 		} else if (pim_ipv4_all_pim_routers(ip_hdr(skb)->daddr)) {
 			if (ip_hdr(skb)->protocol == IPPROTO_PIM)
-				br_multicast_pim(br, port, skb);
+				br_multicast_pim(brmctx, pmctx, skb);
 		} else if (ipv4_is_all_snoopers(ip_hdr(skb)->daddr)) {
-			br_ip4_multicast_mrd_rcv(br, port, skb);
+			br_ip4_multicast_mrd_rcv(brmctx, pmctx, skb);
 		}
 
 		return 0;
 	} else if (err < 0) {
-		br_multicast_err_count(br, port, skb->protocol);
+		br_multicast_err_count(brmctx->br, p, skb->protocol);
 		return err;
 	}
 
@@ -3375,44 +3411,45 @@ static int br_multicast_ipv4_rcv(struct net_bridge *br,
 	case IGMP_HOST_MEMBERSHIP_REPORT:
 	case IGMPV2_HOST_MEMBERSHIP_REPORT:
 		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
-		err = br_ip4_multicast_add_group(br, port, ih->group, vid, src,
-						 true);
+		err = br_ip4_multicast_add_group(brmctx, pmctx, ih->group, vid,
+						 src, true);
 		break;
 	case IGMPV3_HOST_MEMBERSHIP_REPORT:
-		err = br_ip4_multicast_igmp3_report(br, port, skb, vid);
+		err = br_ip4_multicast_igmp3_report(brmctx, pmctx, skb, vid);
 		break;
 	case IGMP_HOST_MEMBERSHIP_QUERY:
-		br_ip4_multicast_query(br, port, skb, vid);
+		br_ip4_multicast_query(brmctx, pmctx, skb, vid);
 		break;
 	case IGMP_HOST_LEAVE_MESSAGE:
-		br_ip4_multicast_leave_group(br, port, ih->group, vid, src);
+		br_ip4_multicast_leave_group(brmctx, pmctx, ih->group, vid, src);
 		break;
 	}
 
-	br_multicast_count(br, port, skb, BR_INPUT_SKB_CB(skb)->igmp,
+	br_multicast_count(brmctx->br, p, skb, BR_INPUT_SKB_CB(skb)->igmp,
 			   BR_MCAST_DIR_RX);
 
 	return err;
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static void br_ip6_multicast_mrd_rcv(struct net_bridge *br,
-				     struct net_bridge_port *port,
+static void br_ip6_multicast_mrd_rcv(struct net_bridge_mcast *brmctx,
+				     struct net_bridge_mcast_port *pmctx,
 				     struct sk_buff *skb)
 {
 	if (icmp6_hdr(skb)->icmp6_type != ICMPV6_MRDISC_ADV)
 		return;
 
-	spin_lock(&br->multicast_lock);
-	br_ip6_multicast_mark_router(br, port);
-	spin_unlock(&br->multicast_lock);
+	spin_lock(&brmctx->br->multicast_lock);
+	br_ip6_multicast_mark_router(brmctx, pmctx);
+	spin_unlock(&brmctx->br->multicast_lock);
 }
 
-static int br_multicast_ipv6_rcv(struct net_bridge *br,
-				 struct net_bridge_port *port,
+static int br_multicast_ipv6_rcv(struct net_bridge_mcast *brmctx,
+				 struct net_bridge_mcast_port *pmctx,
 				 struct sk_buff *skb,
 				 u16 vid)
 {
+	struct net_bridge_port *p = pmctx ? pmctx->port : NULL;
 	const unsigned char *src;
 	struct mld_msg *mld;
 	int err;
@@ -3424,11 +3461,11 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
 		if (err == -ENODATA &&
 		    ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr))
-			br_ip6_multicast_mrd_rcv(br, port, skb);
+			br_ip6_multicast_mrd_rcv(brmctx, pmctx, skb);
 
 		return 0;
 	} else if (err < 0) {
-		br_multicast_err_count(br, port, skb->protocol);
+		br_multicast_err_count(brmctx->br, p, skb->protocol);
 		return err;
 	}
 
@@ -3439,29 +3476,31 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 	case ICMPV6_MGM_REPORT:
 		src = eth_hdr(skb)->h_source;
 		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
-		err = br_ip6_multicast_add_group(br, port, &mld->mld_mca, vid,
-						 src, true);
+		err = br_ip6_multicast_add_group(brmctx, pmctx, &mld->mld_mca,
+						 vid, src, true);
 		break;
 	case ICMPV6_MLD2_REPORT:
-		err = br_ip6_multicast_mld2_report(br, port, skb, vid);
+		err = br_ip6_multicast_mld2_report(brmctx, pmctx, skb, vid);
 		break;
 	case ICMPV6_MGM_QUERY:
-		err = br_ip6_multicast_query(br, port, skb, vid);
+		err = br_ip6_multicast_query(brmctx, pmctx, skb, vid);
 		break;
 	case ICMPV6_MGM_REDUCTION:
 		src = eth_hdr(skb)->h_source;
-		br_ip6_multicast_leave_group(br, port, &mld->mld_mca, vid, src);
+		br_ip6_multicast_leave_group(brmctx, pmctx, &mld->mld_mca, vid,
+					     src);
 		break;
 	}
 
-	br_multicast_count(br, port, skb, BR_INPUT_SKB_CB(skb)->igmp,
+	br_multicast_count(brmctx->br, p, skb, BR_INPUT_SKB_CB(skb)->igmp,
 			   BR_MCAST_DIR_RX);
 
 	return err;
 }
 #endif
 
-int br_multicast_rcv(struct net_bridge *br, struct net_bridge_port *port,
+int br_multicast_rcv(struct net_bridge_mcast *brmctx,
+		     struct net_bridge_mcast_port *pmctx,
 		     struct sk_buff *skb, u16 vid)
 {
 	int ret = 0;
@@ -3469,16 +3508,16 @@ int br_multicast_rcv(struct net_bridge *br, struct net_bridge_port *port,
 	BR_INPUT_SKB_CB(skb)->igmp = 0;
 	BR_INPUT_SKB_CB(skb)->mrouters_only = 0;
 
-	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
+	if (!br_opt_get(brmctx->br, BROPT_MULTICAST_ENABLED))
 		return 0;
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		ret = br_multicast_ipv4_rcv(br, port, skb, vid);
+		ret = br_multicast_ipv4_rcv(brmctx, pmctx, skb, vid);
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		ret = br_multicast_ipv6_rcv(br, port, skb, vid);
+		ret = br_multicast_ipv6_rcv(brmctx, pmctx, skb, vid);
 		break;
 #endif
 	}
@@ -3486,17 +3525,17 @@ int br_multicast_rcv(struct net_bridge *br, struct net_bridge_port *port,
 	return ret;
 }
 
-static void br_multicast_query_expired(struct net_bridge *br,
+static void br_multicast_query_expired(struct net_bridge_mcast *brmctx,
 				       struct bridge_mcast_own_query *query,
 				       struct bridge_mcast_querier *querier)
 {
-	spin_lock(&br->multicast_lock);
-	if (query->startup_sent < br->multicast_ctx.multicast_startup_query_count)
+	spin_lock(&brmctx->br->multicast_lock);
+	if (query->startup_sent < brmctx->multicast_startup_query_count)
 		query->startup_sent++;
 
 	RCU_INIT_POINTER(querier->port, NULL);
-	br_multicast_send_query(br, NULL, query);
-	spin_unlock(&br->multicast_lock);
+	br_multicast_send_query(brmctx, NULL, query);
+	spin_unlock(&brmctx->br->multicast_lock);
 }
 
 static void br_ip4_multicast_query_expired(struct timer_list *t)
@@ -3504,7 +3543,7 @@ static void br_ip4_multicast_query_expired(struct timer_list *t)
 	struct net_bridge_mcast *brmctx = from_timer(brmctx, t,
 						     ip4_own_query.timer);
 
-	br_multicast_query_expired(brmctx->br, &brmctx->ip4_own_query,
+	br_multicast_query_expired(brmctx, &brmctx->ip4_own_query,
 				   &brmctx->ip4_querier);
 }
 
@@ -3514,7 +3553,7 @@ static void br_ip6_multicast_query_expired(struct timer_list *t)
 	struct net_bridge_mcast *brmctx = from_timer(brmctx, t,
 						     ip6_own_query.timer);
 
-	br_multicast_query_expired(brmctx->br, &brmctx->ip6_own_query,
+	br_multicast_query_expired(brmctx, &brmctx->ip6_own_query,
 				   &brmctx->ip6_querier);
 }
 #endif
@@ -3722,7 +3761,7 @@ int br_multicast_set_router(struct net_bridge *br, unsigned long val)
 }
 
 static void
-br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted)
+br_multicast_rport_del_notify(struct net_bridge_mcast_port *pmctx, bool deleted)
 {
 	if (!deleted)
 		return;
@@ -3730,36 +3769,37 @@ br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted)
 	/* For backwards compatibility for now, only notify if there is
 	 * no multicast router anymore for both IPv4 and IPv6.
 	 */
-	if (!hlist_unhashed(&p->multicast_ctx.ip4_rlist))
+	if (!hlist_unhashed(&pmctx->ip4_rlist))
 		return;
 #if IS_ENABLED(CONFIG_IPV6)
-	if (!hlist_unhashed(&p->multicast_ctx.ip6_rlist))
+	if (!hlist_unhashed(&pmctx->ip6_rlist))
 		return;
 #endif
 
-	br_rtr_notify(p->br->dev, p, RTM_DELMDB);
-	br_port_mc_router_state_change(p, false);
+	br_rtr_notify(pmctx->port->br->dev, pmctx->port, RTM_DELMDB);
+	br_port_mc_router_state_change(pmctx->port, false);
 
 	/* don't allow timer refresh */
-	if (p->multicast_ctx.multicast_router == MDB_RTR_TYPE_TEMP)
-		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
+	if (pmctx->multicast_router == MDB_RTR_TYPE_TEMP)
+		pmctx->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
 }
 
 int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 {
 	struct net_bridge_mcast *brmctx = &p->br->multicast_ctx;
+	struct net_bridge_mcast_port *pmctx = &p->multicast_ctx;
 	unsigned long now = jiffies;
 	int err = -EINVAL;
 	bool del = false;
 
 	spin_lock(&p->br->multicast_lock);
-	if (p->multicast_ctx.multicast_router == val) {
+	if (pmctx->multicast_router == val) {
 		/* Refresh the temp router port timer */
-		if (p->multicast_ctx.multicast_router == MDB_RTR_TYPE_TEMP) {
-			mod_timer(&p->multicast_ctx.ip4_mc_router_timer,
+		if (pmctx->multicast_router == MDB_RTR_TYPE_TEMP) {
+			mod_timer(&pmctx->ip4_mc_router_timer,
 				  now + brmctx->multicast_querier_interval);
 #if IS_ENABLED(CONFIG_IPV6)
-			mod_timer(&p->multicast_ctx.ip6_mc_router_timer,
+			mod_timer(&pmctx->ip6_mc_router_timer,
 				  now + brmctx->multicast_querier_interval);
 #endif
 		}
@@ -3768,34 +3808,34 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	}
 	switch (val) {
 	case MDB_RTR_TYPE_DISABLED:
-		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_DISABLED;
-		del |= br_ip4_multicast_rport_del(p);
-		del_timer(&p->multicast_ctx.ip4_mc_router_timer);
-		del |= br_ip6_multicast_rport_del(p);
+		pmctx->multicast_router = MDB_RTR_TYPE_DISABLED;
+		del |= br_ip4_multicast_rport_del(pmctx);
+		del_timer(&pmctx->ip4_mc_router_timer);
+		del |= br_ip6_multicast_rport_del(pmctx);
 #if IS_ENABLED(CONFIG_IPV6)
-		del_timer(&p->multicast_ctx.ip6_mc_router_timer);
+		del_timer(&pmctx->ip6_mc_router_timer);
 #endif
-		br_multicast_rport_del_notify(p, del);
+		br_multicast_rport_del_notify(pmctx, del);
 		break;
 	case MDB_RTR_TYPE_TEMP_QUERY:
-		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
-		del |= br_ip4_multicast_rport_del(p);
-		del |= br_ip6_multicast_rport_del(p);
-		br_multicast_rport_del_notify(p, del);
+		pmctx->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
+		del |= br_ip4_multicast_rport_del(pmctx);
+		del |= br_ip6_multicast_rport_del(pmctx);
+		br_multicast_rport_del_notify(pmctx, del);
 		break;
 	case MDB_RTR_TYPE_PERM:
-		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_PERM;
-		del_timer(&p->multicast_ctx.ip4_mc_router_timer);
-		br_ip4_multicast_add_router(p->br, p);
+		pmctx->multicast_router = MDB_RTR_TYPE_PERM;
+		del_timer(&pmctx->ip4_mc_router_timer);
+		br_ip4_multicast_add_router(brmctx, pmctx);
 #if IS_ENABLED(CONFIG_IPV6)
-		del_timer(&p->multicast_ctx.ip6_mc_router_timer);
+		del_timer(&pmctx->ip6_mc_router_timer);
 #endif
-		br_ip6_multicast_add_router(p->br, p);
+		br_ip6_multicast_add_router(brmctx, pmctx);
 		break;
 	case MDB_RTR_TYPE_TEMP:
-		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_TEMP;
-		br_ip4_multicast_mark_router(p->br, p);
-		br_ip6_multicast_mark_router(p->br, p);
+		pmctx->multicast_router = MDB_RTR_TYPE_TEMP;
+		br_ip4_multicast_mark_router(brmctx, pmctx);
+		br_ip6_multicast_mark_router(brmctx, pmctx);
 		break;
 	default:
 		goto unlock;
@@ -3807,20 +3847,20 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	return err;
 }
 
-static void br_multicast_start_querier(struct net_bridge *br,
+static void br_multicast_start_querier(struct net_bridge_mcast *brmctx,
 				       struct bridge_mcast_own_query *query)
 {
 	struct net_bridge_port *port;
 
-	__br_multicast_open(br, query);
+	__br_multicast_open(brmctx->br, query);
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(port, &br->port_list, list) {
+	list_for_each_entry_rcu(port, &brmctx->br->port_list, list) {
 		if (port->state == BR_STATE_DISABLED ||
 		    port->state == BR_STATE_BLOCKING)
 			continue;
 
-		if (query == &br->multicast_ctx.ip4_own_query)
+		if (query == &brmctx->ip4_own_query)
 			br_multicast_enable(&port->multicast_ctx.ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
 		else
@@ -3858,7 +3898,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 
 	br_multicast_open(br);
 	list_for_each_entry(port, &br->port_list, list)
-		__br_multicast_enable_port(port);
+		__br_multicast_enable_port_ctx(&port->multicast_ctx);
 
 	change_snoopers = true;
 
@@ -3901,7 +3941,7 @@ bool br_multicast_router(const struct net_device *dev)
 	bool is_router;
 
 	spin_lock_bh(&br->multicast_lock);
-	is_router = br_multicast_is_router(br, NULL);
+	is_router = br_multicast_is_router(&br->multicast_ctx, NULL);
 	spin_unlock_bh(&br->multicast_lock);
 	return is_router;
 }
@@ -3927,13 +3967,13 @@ int br_multicast_set_querier(struct net_bridge *br, unsigned long val)
 	if (!timer_pending(&brmctx->ip4_other_query.timer))
 		brmctx->ip4_other_query.delay_time = jiffies + max_delay;
 
-	br_multicast_start_querier(br, &brmctx->ip4_own_query);
+	br_multicast_start_querier(brmctx, &brmctx->ip4_own_query);
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (!timer_pending(&brmctx->ip6_other_query.timer))
 		brmctx->ip6_other_query.delay_time = jiffies + max_delay;
 
-	br_multicast_start_querier(br, &brmctx->ip6_own_query);
+	br_multicast_start_querier(brmctx, &brmctx->ip6_own_query);
 #endif
 
 unlock:
@@ -4066,7 +4106,7 @@ bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto)
 	memset(&eth, 0, sizeof(eth));
 	eth.h_proto = htons(proto);
 
-	ret = br_multicast_querier_exists(br, &eth, NULL);
+	ret = br_multicast_querier_exists(&br->multicast_ctx, &eth, NULL);
 
 unlock:
 	rcu_read_unlock();
@@ -4254,7 +4294,8 @@ static void br_mcast_stats_add(struct bridge_mcast_stats __percpu *stats,
 	u64_stats_update_end(&pstats->syncp);
 }
 
-void br_multicast_count(struct net_bridge *br, const struct net_bridge_port *p,
+void br_multicast_count(struct net_bridge *br,
+			const struct net_bridge_port *p,
 			const struct sk_buff *skb, u8 type, u8 dir)
 {
 	struct bridge_mcast_stats __percpu *stats;
diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index 13290a749d09..f91c071d1608 100644
--- a/net/bridge/br_multicast_eht.c
+++ b/net/bridge/br_multicast_eht.c
@@ -33,7 +33,8 @@
 static bool br_multicast_del_eht_set_entry(struct net_bridge_port_group *pg,
 					   union net_bridge_eht_addr *src_addr,
 					   union net_bridge_eht_addr *h_addr);
-static void br_multicast_create_eht_set_entry(struct net_bridge_port_group *pg,
+static void br_multicast_create_eht_set_entry(const struct net_bridge_mcast *brmctx,
+					      struct net_bridge_port_group *pg,
 					      union net_bridge_eht_addr *src_addr,
 					      union net_bridge_eht_addr *h_addr,
 					      int filter_mode,
@@ -388,7 +389,8 @@ static void br_multicast_ip_src_to_eht_addr(const struct br_ip *src,
 	}
 }
 
-static void br_eht_convert_host_filter_mode(struct net_bridge_port_group *pg,
+static void br_eht_convert_host_filter_mode(const struct net_bridge_mcast *brmctx,
+					    struct net_bridge_port_group *pg,
 					    union net_bridge_eht_addr *h_addr,
 					    int filter_mode)
 {
@@ -405,14 +407,15 @@ static void br_eht_convert_host_filter_mode(struct net_bridge_port_group *pg,
 		br_multicast_del_eht_set_entry(pg, &zero_addr, h_addr);
 		break;
 	case MCAST_EXCLUDE:
-		br_multicast_create_eht_set_entry(pg, &zero_addr, h_addr,
-						  MCAST_EXCLUDE,
+		br_multicast_create_eht_set_entry(brmctx, pg, &zero_addr,
+						  h_addr, MCAST_EXCLUDE,
 						  true);
 		break;
 	}
 }
 
-static void br_multicast_create_eht_set_entry(struct net_bridge_port_group *pg,
+static void br_multicast_create_eht_set_entry(const struct net_bridge_mcast *brmctx,
+					      struct net_bridge_port_group *pg,
 					      union net_bridge_eht_addr *src_addr,
 					      union net_bridge_eht_addr *h_addr,
 					      int filter_mode,
@@ -441,8 +444,8 @@ static void br_multicast_create_eht_set_entry(struct net_bridge_port_group *pg,
 	if (!set_h)
 		goto fail_set_entry;
 
-	mod_timer(&set_h->timer, jiffies + br_multicast_gmi(br));
-	mod_timer(&eht_set->timer, jiffies + br_multicast_gmi(br));
+	mod_timer(&set_h->timer, jiffies + br_multicast_gmi(brmctx));
+	mod_timer(&eht_set->timer, jiffies + br_multicast_gmi(brmctx));
 
 	return;
 
@@ -499,7 +502,8 @@ static void br_multicast_del_eht_host(struct net_bridge_port_group *pg,
 }
 
 /* create new set entries from reports */
-static void __eht_create_set_entries(struct net_bridge_port_group *pg,
+static void __eht_create_set_entries(const struct net_bridge_mcast *brmctx,
+				     struct net_bridge_port_group *pg,
 				     union net_bridge_eht_addr *h_addr,
 				     void *srcs,
 				     u32 nsrcs,
@@ -512,8 +516,8 @@ static void __eht_create_set_entries(struct net_bridge_port_group *pg,
 	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
-		br_multicast_create_eht_set_entry(pg, &eht_src_addr, h_addr,
-						  filter_mode,
+		br_multicast_create_eht_set_entry(brmctx, pg, &eht_src_addr,
+						  h_addr, filter_mode,
 						  false);
 	}
 }
@@ -549,7 +553,8 @@ static bool __eht_del_set_entries(struct net_bridge_port_group *pg,
 	return changed;
 }
 
-static bool br_multicast_eht_allow(struct net_bridge_port_group *pg,
+static bool br_multicast_eht_allow(const struct net_bridge_mcast *brmctx,
+				   struct net_bridge_port_group *pg,
 				   union net_bridge_eht_addr *h_addr,
 				   void *srcs,
 				   u32 nsrcs,
@@ -559,8 +564,8 @@ static bool br_multicast_eht_allow(struct net_bridge_port_group *pg,
 
 	switch (br_multicast_eht_host_filter_mode(pg, h_addr)) {
 	case MCAST_INCLUDE:
-		__eht_create_set_entries(pg, h_addr, srcs, nsrcs, addr_size,
-					 MCAST_INCLUDE);
+		__eht_create_set_entries(brmctx, pg, h_addr, srcs, nsrcs,
+					 addr_size, MCAST_INCLUDE);
 		break;
 	case MCAST_EXCLUDE:
 		changed = __eht_del_set_entries(pg, h_addr, srcs, nsrcs,
@@ -571,7 +576,8 @@ static bool br_multicast_eht_allow(struct net_bridge_port_group *pg,
 	return changed;
 }
 
-static bool br_multicast_eht_block(struct net_bridge_port_group *pg,
+static bool br_multicast_eht_block(const struct net_bridge_mcast *brmctx,
+				   struct net_bridge_port_group *pg,
 				   union net_bridge_eht_addr *h_addr,
 				   void *srcs,
 				   u32 nsrcs,
@@ -585,7 +591,7 @@ static bool br_multicast_eht_block(struct net_bridge_port_group *pg,
 						addr_size);
 		break;
 	case MCAST_EXCLUDE:
-		__eht_create_set_entries(pg, h_addr, srcs, nsrcs, addr_size,
+		__eht_create_set_entries(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
 					 MCAST_EXCLUDE);
 		break;
 	}
@@ -594,7 +600,8 @@ static bool br_multicast_eht_block(struct net_bridge_port_group *pg,
 }
 
 /* flush_entries is true when changing mode */
-static bool __eht_inc_exc(struct net_bridge_port_group *pg,
+static bool __eht_inc_exc(const struct net_bridge_mcast *brmctx,
+			  struct net_bridge_port_group *pg,
 			  union net_bridge_eht_addr *h_addr,
 			  void *srcs,
 			  u32 nsrcs,
@@ -612,11 +619,10 @@ static bool __eht_inc_exc(struct net_bridge_port_group *pg,
 	/* if we're changing mode del host and its entries */
 	if (flush_entries)
 		br_multicast_del_eht_host(pg, h_addr);
-	__eht_create_set_entries(pg, h_addr, srcs, nsrcs, addr_size,
+	__eht_create_set_entries(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
 				 filter_mode);
 	/* we can be missing sets only if we've deleted some entries */
 	if (flush_entries) {
-		struct net_bridge *br = pg->key.port->br;
 		struct net_bridge_group_eht_set *eht_set;
 		struct net_bridge_group_src *src_ent;
 		struct hlist_node *tmp;
@@ -647,14 +653,15 @@ static bool __eht_inc_exc(struct net_bridge_port_group *pg,
 							      &eht_src_addr);
 			if (!eht_set)
 				continue;
-			mod_timer(&eht_set->timer, jiffies + br_multicast_lmqt(br));
+			mod_timer(&eht_set->timer, jiffies + br_multicast_lmqt(brmctx));
 		}
 	}
 
 	return changed;
 }
 
-static bool br_multicast_eht_inc(struct net_bridge_port_group *pg,
+static bool br_multicast_eht_inc(const struct net_bridge_mcast *brmctx,
+				 struct net_bridge_port_group *pg,
 				 union net_bridge_eht_addr *h_addr,
 				 void *srcs,
 				 u32 nsrcs,
@@ -663,14 +670,15 @@ static bool br_multicast_eht_inc(struct net_bridge_port_group *pg,
 {
 	bool changed;
 
-	changed = __eht_inc_exc(pg, h_addr, srcs, nsrcs, addr_size,
+	changed = __eht_inc_exc(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
 				MCAST_INCLUDE, to_report);
-	br_eht_convert_host_filter_mode(pg, h_addr, MCAST_INCLUDE);
+	br_eht_convert_host_filter_mode(brmctx, pg, h_addr, MCAST_INCLUDE);
 
 	return changed;
 }
 
-static bool br_multicast_eht_exc(struct net_bridge_port_group *pg,
+static bool br_multicast_eht_exc(const struct net_bridge_mcast *brmctx,
+				 struct net_bridge_port_group *pg,
 				 union net_bridge_eht_addr *h_addr,
 				 void *srcs,
 				 u32 nsrcs,
@@ -679,14 +687,15 @@ static bool br_multicast_eht_exc(struct net_bridge_port_group *pg,
 {
 	bool changed;
 
-	changed = __eht_inc_exc(pg, h_addr, srcs, nsrcs, addr_size,
+	changed = __eht_inc_exc(brmctx, pg, h_addr, srcs, nsrcs, addr_size,
 				MCAST_EXCLUDE, to_report);
-	br_eht_convert_host_filter_mode(pg, h_addr, MCAST_EXCLUDE);
+	br_eht_convert_host_filter_mode(brmctx, pg, h_addr, MCAST_EXCLUDE);
 
 	return changed;
 }
 
-static bool __eht_ip4_handle(struct net_bridge_port_group *pg,
+static bool __eht_ip4_handle(const struct net_bridge_mcast *brmctx,
+			     struct net_bridge_port_group *pg,
 			     union net_bridge_eht_addr *h_addr,
 			     void *srcs,
 			     u32 nsrcs,
@@ -696,24 +705,25 @@ static bool __eht_ip4_handle(struct net_bridge_port_group *pg,
 
 	switch (grec_type) {
 	case IGMPV3_ALLOW_NEW_SOURCES:
-		br_multicast_eht_allow(pg, h_addr, srcs, nsrcs, sizeof(__be32));
+		br_multicast_eht_allow(brmctx, pg, h_addr, srcs, nsrcs,
+				       sizeof(__be32));
 		break;
 	case IGMPV3_BLOCK_OLD_SOURCES:
-		changed = br_multicast_eht_block(pg, h_addr, srcs, nsrcs,
+		changed = br_multicast_eht_block(brmctx, pg, h_addr, srcs, nsrcs,
 						 sizeof(__be32));
 		break;
 	case IGMPV3_CHANGE_TO_INCLUDE:
 		to_report = true;
 		fallthrough;
 	case IGMPV3_MODE_IS_INCLUDE:
-		changed = br_multicast_eht_inc(pg, h_addr, srcs, nsrcs,
+		changed = br_multicast_eht_inc(brmctx, pg, h_addr, srcs, nsrcs,
 					       sizeof(__be32), to_report);
 		break;
 	case IGMPV3_CHANGE_TO_EXCLUDE:
 		to_report = true;
 		fallthrough;
 	case IGMPV3_MODE_IS_EXCLUDE:
-		changed = br_multicast_eht_exc(pg, h_addr, srcs, nsrcs,
+		changed = br_multicast_eht_exc(brmctx, pg, h_addr, srcs, nsrcs,
 					       sizeof(__be32), to_report);
 		break;
 	}
@@ -722,7 +732,8 @@ static bool __eht_ip4_handle(struct net_bridge_port_group *pg,
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static bool __eht_ip6_handle(struct net_bridge_port_group *pg,
+static bool __eht_ip6_handle(const struct net_bridge_mcast *brmctx,
+			     struct net_bridge_port_group *pg,
 			     union net_bridge_eht_addr *h_addr,
 			     void *srcs,
 			     u32 nsrcs,
@@ -732,18 +743,18 @@ static bool __eht_ip6_handle(struct net_bridge_port_group *pg,
 
 	switch (grec_type) {
 	case MLD2_ALLOW_NEW_SOURCES:
-		br_multicast_eht_allow(pg, h_addr, srcs, nsrcs,
+		br_multicast_eht_allow(brmctx, pg, h_addr, srcs, nsrcs,
 				       sizeof(struct in6_addr));
 		break;
 	case MLD2_BLOCK_OLD_SOURCES:
-		changed = br_multicast_eht_block(pg, h_addr, srcs, nsrcs,
+		changed = br_multicast_eht_block(brmctx, pg, h_addr, srcs, nsrcs,
 						 sizeof(struct in6_addr));
 		break;
 	case MLD2_CHANGE_TO_INCLUDE:
 		to_report = true;
 		fallthrough;
 	case MLD2_MODE_IS_INCLUDE:
-		changed = br_multicast_eht_inc(pg, h_addr, srcs, nsrcs,
+		changed = br_multicast_eht_inc(brmctx, pg, h_addr, srcs, nsrcs,
 					       sizeof(struct in6_addr),
 					       to_report);
 		break;
@@ -751,7 +762,7 @@ static bool __eht_ip6_handle(struct net_bridge_port_group *pg,
 		to_report = true;
 		fallthrough;
 	case MLD2_MODE_IS_EXCLUDE:
-		changed = br_multicast_eht_exc(pg, h_addr, srcs, nsrcs,
+		changed = br_multicast_eht_exc(brmctx, pg, h_addr, srcs, nsrcs,
 					       sizeof(struct in6_addr),
 					       to_report);
 		break;
@@ -762,7 +773,8 @@ static bool __eht_ip6_handle(struct net_bridge_port_group *pg,
 #endif
 
 /* true means an entry was deleted */
-bool br_multicast_eht_handle(struct net_bridge_port_group *pg,
+bool br_multicast_eht_handle(const struct net_bridge_mcast *brmctx,
+			     struct net_bridge_port_group *pg,
 			     void *h_addr,
 			     void *srcs,
 			     u32 nsrcs,
@@ -779,12 +791,12 @@ bool br_multicast_eht_handle(struct net_bridge_port_group *pg,
 	memset(&eht_host_addr, 0, sizeof(eht_host_addr));
 	memcpy(&eht_host_addr, h_addr, addr_size);
 	if (addr_size == sizeof(__be32))
-		changed = __eht_ip4_handle(pg, &eht_host_addr, srcs, nsrcs,
-					   grec_type);
+		changed = __eht_ip4_handle(brmctx, pg, &eht_host_addr, srcs,
+					   nsrcs, grec_type);
 #if IS_ENABLED(CONFIG_IPV6)
 	else
-		changed = __eht_ip6_handle(pg, &eht_host_addr, srcs, nsrcs,
-					   grec_type);
+		changed = __eht_ip6_handle(brmctx, pg, &eht_host_addr, srcs,
+					   nsrcs, grec_type);
 #endif
 
 out:
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index badd490fce7a..89e942789b12 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -830,9 +830,10 @@ int br_ioctl_deviceless_stub(struct net *net, unsigned int cmd,
 
 /* br_multicast.c */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
-int br_multicast_rcv(struct net_bridge *br, struct net_bridge_port *port,
+int br_multicast_rcv(struct net_bridge_mcast *brmctx,
+		     struct net_bridge_mcast_port *pmctx,
 		     struct sk_buff *skb, u16 vid);
-struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
+struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge_mcast *brmctx,
 					struct sk_buff *skb, u16 vid);
 int br_multicast_add_port(struct net_bridge_port *port);
 void br_multicast_del_port(struct net_bridge_port *port);
@@ -844,8 +845,9 @@ void br_multicast_leave_snoopers(struct net_bridge *br);
 void br_multicast_open(struct net_bridge *br);
 void br_multicast_stop(struct net_bridge *br);
 void br_multicast_dev_del(struct net_bridge *br);
-void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
-			struct sk_buff *skb, bool local_rcv, bool local_orig);
+void br_multicast_flood(struct net_bridge_mdb_entry *mdst, struct sk_buff *skb,
+			struct net_bridge_mcast *brmctx,
+			bool local_rcv, bool local_orig);
 int br_multicast_set_router(struct net_bridge *br, unsigned long val);
 int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val);
 int br_multicast_toggle(struct net_bridge *br, unsigned long val,
@@ -874,7 +876,8 @@ void br_rtr_notify(struct net_device *dev, struct net_bridge_port *port,
 void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 			 struct net_bridge_port_group *pg,
 			 struct net_bridge_port_group __rcu **pp);
-void br_multicast_count(struct net_bridge *br, const struct net_bridge_port *p,
+void br_multicast_count(struct net_bridge *br,
+			const struct net_bridge_port *p,
 			const struct sk_buff *skb, u8 type, u8 dir);
 int br_multicast_init_stats(struct net_bridge *br);
 void br_multicast_uninit_stats(struct net_bridge *br);
@@ -903,10 +906,9 @@ static inline bool br_group_is_l2(const struct br_ip *group)
 	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))
 
 static inline struct hlist_node *
-br_multicast_get_first_rport_node(struct net_bridge *br, struct sk_buff *skb)
+br_multicast_get_first_rport_node(struct net_bridge_mcast *brmctx,
+				  struct sk_buff *skb)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
-
 #if IS_ENABLED(CONFIG_IPV6)
 	if (skb->protocol == htons(ETH_P_IPV6))
 		return rcu_dereference(hlist_first_rcu(&brmctx->ip6_mc_router_list));
@@ -949,10 +951,8 @@ static inline bool br_ip6_multicast_is_router(struct net_bridge_mcast *brmctx)
 }
 
 static inline bool
-br_multicast_is_router(struct net_bridge *br, struct sk_buff *skb)
+br_multicast_is_router(struct net_bridge_mcast *brmctx, struct sk_buff *skb)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
-
 	switch (brmctx->multicast_router) {
 	case MDB_RTR_TYPE_PERM:
 		return true;
@@ -973,14 +973,14 @@ br_multicast_is_router(struct net_bridge *br, struct sk_buff *skb)
 }
 
 static inline bool
-__br_multicast_querier_exists(struct net_bridge *br,
-				struct bridge_mcast_other_query *querier,
-				const bool is_ipv6)
+__br_multicast_querier_exists(struct net_bridge_mcast *brmctx,
+			      struct bridge_mcast_other_query *querier,
+			      const bool is_ipv6)
 {
 	bool own_querier_enabled;
 
-	if (br_opt_get(br, BROPT_MULTICAST_QUERIER)) {
-		if (is_ipv6 && !br_opt_get(br, BROPT_HAS_IPV6_ADDR))
+	if (br_opt_get(brmctx->br, BROPT_MULTICAST_QUERIER)) {
+		if (is_ipv6 && !br_opt_get(brmctx->br, BROPT_HAS_IPV6_ADDR))
 			own_querier_enabled = false;
 		else
 			own_querier_enabled = true;
@@ -992,18 +992,18 @@ __br_multicast_querier_exists(struct net_bridge *br,
 	       (own_querier_enabled || timer_pending(&querier->timer));
 }
 
-static inline bool br_multicast_querier_exists(struct net_bridge *br,
+static inline bool br_multicast_querier_exists(struct net_bridge_mcast *brmctx,
 					       struct ethhdr *eth,
 					       const struct net_bridge_mdb_entry *mdb)
 {
 	switch (eth->h_proto) {
 	case (htons(ETH_P_IP)):
-		return __br_multicast_querier_exists(br,
-			&br->multicast_ctx.ip4_other_query, false);
+		return __br_multicast_querier_exists(brmctx,
+			&brmctx->ip4_other_query, false);
 #if IS_ENABLED(CONFIG_IPV6)
 	case (htons(ETH_P_IPV6)):
-		return __br_multicast_querier_exists(br,
-			&br->multicast_ctx.ip6_other_query, true);
+		return __br_multicast_querier_exists(brmctx,
+			&brmctx->ip6_other_query, true);
 #endif
 	default:
 		return !!mdb && br_group_is_l2(&mdb->addr);
@@ -1024,15 +1024,16 @@ static inline bool br_multicast_is_star_g(const struct br_ip *ip)
 	}
 }
 
-static inline bool br_multicast_should_handle_mode(const struct net_bridge *br,
-						   __be16 proto)
+static inline bool
+br_multicast_should_handle_mode(const struct net_bridge_mcast *brmctx,
+				__be16 proto)
 {
 	switch (proto) {
 	case htons(ETH_P_IP):
-		return !!(br->multicast_ctx.multicast_igmp_version == 3);
+		return !!(brmctx->multicast_igmp_version == 3);
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		return !!(br->multicast_ctx.multicast_mld_version == 2);
+		return !!(brmctx->multicast_mld_version == 2);
 #endif
 	default:
 		return false;
@@ -1044,28 +1045,28 @@ static inline int br_multicast_igmp_type(const struct sk_buff *skb)
 	return BR_INPUT_SKB_CB(skb)->igmp;
 }
 
-static inline unsigned long br_multicast_lmqt(const struct net_bridge *br)
+static inline unsigned long br_multicast_lmqt(const struct net_bridge_mcast *brmctx)
 {
-	return br->multicast_ctx.multicast_last_member_interval *
-	       br->multicast_ctx.multicast_last_member_count;
+	return brmctx->multicast_last_member_interval *
+	       brmctx->multicast_last_member_count;
 }
 
-static inline unsigned long br_multicast_gmi(const struct net_bridge *br)
+static inline unsigned long br_multicast_gmi(const struct net_bridge_mcast *brmctx)
 {
 	/* use the RFC default of 2 for QRV */
-	return 2 * br->multicast_ctx.multicast_query_interval +
-	       br->multicast_ctx.multicast_query_response_interval;
+	return 2 * brmctx->multicast_query_interval +
+	       brmctx->multicast_query_response_interval;
 }
 #else
-static inline int br_multicast_rcv(struct net_bridge *br,
-				   struct net_bridge_port *port,
+static inline int br_multicast_rcv(struct net_bridge_mcast *brmctx,
+				   struct net_bridge_mcast_port *pmctx,
 				   struct sk_buff *skb,
 				   u16 vid)
 {
 	return 0;
 }
 
-static inline struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
+static inline struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge_mcast *brmctx,
 						      struct sk_buff *skb, u16 vid)
 {
 	return NULL;
@@ -1114,17 +1115,18 @@ static inline void br_multicast_dev_del(struct net_bridge *br)
 
 static inline void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 				      struct sk_buff *skb,
+				      struct net_bridge_mcast *brmctx,
 				      bool local_rcv, bool local_orig)
 {
 }
 
-static inline bool br_multicast_is_router(struct net_bridge *br,
+static inline bool br_multicast_is_router(struct net_bridge_mcast *brmctx,
 					  struct sk_buff *skb)
 {
 	return false;
 }
 
-static inline bool br_multicast_querier_exists(struct net_bridge *br,
+static inline bool br_multicast_querier_exists(struct net_bridge_mcast *brmctx,
 					       struct ethhdr *eth,
 					       const struct net_bridge_mdb_entry *mdb)
 {
diff --git a/net/bridge/br_private_mcast_eht.h b/net/bridge/br_private_mcast_eht.h
index f89049f4892c..adf82a05515a 100644
--- a/net/bridge/br_private_mcast_eht.h
+++ b/net/bridge/br_private_mcast_eht.h
@@ -51,7 +51,8 @@ struct net_bridge_group_eht_set {
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 void br_multicast_eht_clean_sets(struct net_bridge_port_group *pg);
-bool br_multicast_eht_handle(struct net_bridge_port_group *pg,
+bool br_multicast_eht_handle(const struct net_bridge_mcast *brmctx,
+			     struct net_bridge_port_group *pg,
 			     void *h_addr,
 			     void *srcs,
 			     u32 nsrcs,
-- 
2.31.1

