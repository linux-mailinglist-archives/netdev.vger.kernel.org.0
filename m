Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC2927219E
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgIUK47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgIUK4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:24 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1F5C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:23 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l9so12139906wme.3
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ssYfGnyDOQ3YSeKyz9kCpEKCQyG6t2mIaagcn1H4wQs=;
        b=EycxlAX2S0unzaIb4TYPDfU2Z/zw6YRpSN6JPR7SWpB+d7puHrrtecvI8OXPVVpoRI
         uMJwQPno2IwTA0iaftzz0VG4BrFvsHxobw7Idy266rdwWHP3i8VuphHPyB+jxuux31Jc
         YEaaU1mDO5LP6dc2msljdsOLHLjrRNNceg6DYRY+JUzXHjYbigmA1Fofl2b5BQcArsUL
         urDcWuPy+6uVb53AHQjaHYmT9Qaxqme8z2Ooq4OhMAmbdDd24YKQXcP2WY8ETGMwBgom
         ofD8mq5eICbtsRft68Oo/WGMwkmqNz+RSP+gFX9zkBNJ9tdK0lyJjtTJZfJss8D4GOQx
         0yOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ssYfGnyDOQ3YSeKyz9kCpEKCQyG6t2mIaagcn1H4wQs=;
        b=oq19UoLXB7ecuOgsJRFNrboiOrmbxDvZ3RMZTEiE5uJ05iwm2y8Ij0KbOFYG+gktoe
         AsBbCcZjn5ibCRfC2D3jCOSwgDF+td5fPSH68cd3mhfXt/ej9zjXMjwdEh1bNCn0pwNN
         08pOeLbYAQZrwfzQpfz3benlgTgQhT8afwxz1WDmQ9uQD2Gm/UeJPpLdnucGoLknXa+T
         CytESmGEQpRUQOjCeI4WjQlH9Vc2iYeeP6wNwWMKY07FldPtTCOJWLgwev9LiBawq6ll
         68pvebi1hp8YPJavu+OkXtYvaII12EImTLCfwRGr3jWa5V96u3AnteSsWpienwc2WAKn
         ZYKA==
X-Gm-Message-State: AOAM530JYlmPD4aVTON+bt7lvxEIAlP8m4nbHhWi4w0rkS8/NfIF1Zkk
        keilGKileXTm3UcxI1zPqShQNHw/oTmTpmmJBEDt5Q==
X-Google-Smtp-Source: ABdhPJy9Km2CAmYqqLa2D6YOFcfn3TCqVM+kjhWmu0mcDFBFC9hHGlWEjTbUdgsdYeIHCNgJ5W+Sjw==
X-Received: by 2002:a1c:2903:: with SMTP id p3mr30506856wmp.170.1600685781489;
        Mon, 21 Sep 2020 03:56:21 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:21 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 11/16] net: bridge: mcast: add sg_port rhashtable
Date:   Mon, 21 Sep 2020 13:55:21 +0300
Message-Id: <20200921105526.1056983-12-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

To speedup S,G forward handling we need to be able to quickly find out
if a port is a member of an S,G group. To do that add a global S,G port
rhashtable with key: source addr, group addr, protocol, vid (all br_ip
fields) and port pointer.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_forward.c   |   2 +-
 net/bridge/br_mdb.c       |  34 +++++-----
 net/bridge/br_multicast.c | 130 +++++++++++++++++++++++++-------------
 net/bridge/br_private.h   |  10 ++-
 4 files changed, 111 insertions(+), 65 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 7629b63f6f30..4d12999e4576 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -281,7 +281,7 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 	while (p || rp) {
 		struct net_bridge_port *port, *lport, *rport;
 
-		lport = p ? p->port : NULL;
+		lport = p ? p->key.port : NULL;
 		rport = hlist_entry_safe(rp, struct net_bridge_port, rlist);
 
 		if ((unsigned long)lport > (unsigned long)rport) {
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index b386a5e07698..4e3a5cefc626 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -101,7 +101,7 @@ static int __mdb_fill_srcs(struct sk_buff *skb,
 		return -EMSGSIZE;
 
 	hlist_for_each_entry_rcu(ent, &p->src_list, node,
-				 lockdep_is_held(&p->port->br->multicast_lock)) {
+				 lockdep_is_held(&p->key.port->br->multicast_lock)) {
 		nest_ent = nla_nest_start(skb, MDBA_MDB_SRCLIST_ENTRY);
 		if (!nest_ent)
 			goto out_cancel_err;
@@ -156,7 +156,7 @@ static int __mdb_fill_info(struct sk_buff *skb,
 
 	memset(&e, 0, sizeof(e));
 	if (p) {
-		ifindex = p->port->dev->ifindex;
+		ifindex = p->key.port->dev->ifindex;
 		mtimer = &p->timer;
 		flags = p->flags;
 	} else {
@@ -263,7 +263,7 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 
 		for (pp = &mp->ports; (p = rcu_dereference(*pp)) != NULL;
 		      pp = &p->next) {
-			if (!p->port)
+			if (!p->key.port)
 				continue;
 			if (pidx < s_pidx)
 				goto skip_pg;
@@ -423,21 +423,21 @@ static size_t rtnl_mdb_nlmsg_size(struct net_bridge_port_group *pg)
 	/* MDBA_MDB_EATTR_RTPROT */
 	nlmsg_size += nla_total_size(sizeof(u8));
 
-	switch (pg->addr.proto) {
+	switch (pg->key.addr.proto) {
 	case htons(ETH_P_IP):
 		/* MDBA_MDB_EATTR_SOURCE */
-		if (pg->addr.src.ip4)
+		if (pg->key.addr.src.ip4)
 			nlmsg_size += nla_total_size(sizeof(__be32));
-		if (pg->port->br->multicast_igmp_version == 2)
+		if (pg->key.port->br->multicast_igmp_version == 2)
 			goto out;
 		addr_size = sizeof(__be32);
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
 		/* MDBA_MDB_EATTR_SOURCE */
-		if (!ipv6_addr_any(&pg->addr.src.ip6))
+		if (!ipv6_addr_any(&pg->key.addr.src.ip6))
 			nlmsg_size += nla_total_size(sizeof(struct in6_addr));
-		if (pg->port->br->multicast_mld_version == 1)
+		if (pg->key.port->br->multicast_mld_version == 1)
 			goto out;
 		addr_size = sizeof(struct in6_addr);
 		break;
@@ -486,7 +486,7 @@ static void br_mdb_complete(struct net_device *dev, int err, void *priv)
 		goto out;
 	for (pp = &mp->ports; (p = mlock_dereference(*pp, br)) != NULL;
 	     pp = &p->next) {
-		if (p->port != port)
+		if (p->key.port != port)
 			continue;
 		p->flags |= MDB_PG_FLAGS_OFFLOAD;
 	}
@@ -561,21 +561,21 @@ void br_mdb_notify(struct net_device *dev,
 		else
 			ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
 #endif
-		mdb.obj.orig_dev = pg->port->dev;
+		mdb.obj.orig_dev = pg->key.port->dev;
 		switch (type) {
 		case RTM_NEWMDB:
 			complete_info = kmalloc(sizeof(*complete_info), GFP_ATOMIC);
 			if (!complete_info)
 				break;
-			complete_info->port = pg->port;
+			complete_info->port = pg->key.port;
 			complete_info->ip = mp->addr;
 			mdb.obj.complete_priv = complete_info;
 			mdb.obj.complete = br_mdb_complete;
-			if (switchdev_port_obj_add(pg->port->dev, &mdb.obj, NULL))
+			if (switchdev_port_obj_add(pg->key.port->dev, &mdb.obj, NULL))
 				kfree(complete_info);
 			break;
 		case RTM_DELMDB:
-			switchdev_port_obj_del(pg->port->dev, &mdb.obj);
+			switchdev_port_obj_del(pg->key.port->dev, &mdb.obj);
 			break;
 		}
 	} else {
@@ -869,11 +869,11 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	for (pp = &mp->ports;
 	     (p = mlock_dereference(*pp, br)) != NULL;
 	     pp = &p->next) {
-		if (p->port == port) {
+		if (p->key.port == port) {
 			NL_SET_ERR_MSG_MOD(extack, "Group is already joined by port");
 			return -EEXIST;
 		}
-		if ((unsigned long)p->port < (unsigned long)port)
+		if ((unsigned long)p->key.port < (unsigned long)port)
 			break;
 	}
 
@@ -1013,10 +1013,10 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry,
 	for (pp = &mp->ports;
 	     (p = mlock_dereference(*pp, br)) != NULL;
 	     pp = &p->next) {
-		if (!p->port || p->port->dev->ifindex != entry->ifindex)
+		if (!p->key.port || p->key.port->dev->ifindex != entry->ifindex)
 			continue;
 
-		if (p->port->state == BR_STATE_DISABLED)
+		if (p->key.port->state == BR_STATE_DISABLED)
 			goto unlock;
 
 		br_multicast_del_pg(mp, p, pp);
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b6e7b0ece422..0fec9f38787c 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -41,6 +41,13 @@ static const struct rhashtable_params br_mdb_rht_params = {
 	.automatic_shrinking = true,
 };
 
+static const struct rhashtable_params br_sg_port_rht_params = {
+	.head_offset = offsetof(struct net_bridge_port_group, rhnode),
+	.key_offset = offsetof(struct net_bridge_port_group, key),
+	.key_len = sizeof(struct net_bridge_port_group_sg_key),
+	.automatic_shrinking = true,
+};
+
 static void br_multicast_start_querier(struct net_bridge *br,
 				       struct bridge_mcast_own_query *query);
 static void br_multicast_add_router(struct net_bridge *br,
@@ -60,6 +67,16 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
 					 __u16 vid, const unsigned char *src);
 #endif
 
+static struct net_bridge_port_group *
+br_sg_port_find(struct net_bridge *br,
+		struct net_bridge_port_group_sg_key *sg_p)
+{
+	lockdep_assert_held_once(&br->multicast_lock);
+
+	return rhashtable_lookup_fast(&br->sg_port_tbl, sg_p,
+				      br_sg_port_rht_params);
+}
+
 static struct net_bridge_mdb_entry *br_mdb_ip_get_rcu(struct net_bridge *br,
 						      struct br_ip *dst)
 {
@@ -212,7 +229,7 @@ static void br_multicast_destroy_group_src(struct net_bridge_mcast_gc *gc)
 
 static void br_multicast_del_group_src(struct net_bridge_group_src *src)
 {
-	struct net_bridge *br = src->pg->port->br;
+	struct net_bridge *br = src->pg->key.port->br;
 
 	hlist_del_init_rcu(&src->node);
 	src->pg->src_ents--;
@@ -237,10 +254,12 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 			 struct net_bridge_port_group *pg,
 			 struct net_bridge_port_group __rcu **pp)
 {
-	struct net_bridge *br = pg->port->br;
+	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_group_src *ent;
 	struct hlist_node *tmp;
 
+	rhashtable_remove_fast(&br->sg_port_tbl, &pg->rhnode,
+			       br_sg_port_rht_params);
 	rcu_assign_pointer(*pp, pg->next);
 	hlist_del_init(&pg->mglist);
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
@@ -260,7 +279,7 @@ static void br_multicast_find_del_pg(struct net_bridge *br,
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
 
-	mp = br_mdb_ip_get(br, &pg->addr);
+	mp = br_mdb_ip_get(br, &pg->key.addr);
 	if (WARN_ON(!mp))
 		return;
 
@@ -281,7 +300,7 @@ static void br_multicast_port_group_expired(struct timer_list *t)
 {
 	struct net_bridge_port_group *pg = from_timer(pg, t, timer);
 	struct net_bridge_group_src *src_ent;
-	struct net_bridge *br = pg->port->br;
+	struct net_bridge *br = pg->key.port->br;
 	struct hlist_node *tmp;
 	bool changed;
 
@@ -302,7 +321,7 @@ static void br_multicast_port_group_expired(struct timer_list *t)
 	if (hlist_empty(&pg->src_list)) {
 		br_multicast_find_del_pg(br, pg);
 	} else if (changed) {
-		struct net_bridge_mdb_entry *mp = br_mdb_ip_get(br, &pg->addr);
+		struct net_bridge_mdb_entry *mp = br_mdb_ip_get(br, &pg->key.addr);
 
 		if (WARN_ON(!mp))
 			goto out;
@@ -330,7 +349,7 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 						    u8 sflag, u8 *igmp_type,
 						    bool *need_rexmit)
 {
-	struct net_bridge_port *p = pg ? pg->port : NULL;
+	struct net_bridge_port *p = pg ? pg->key.port : NULL;
 	struct net_bridge_group_src *ent;
 	size_t pkt_size, igmp_hdr_size;
 	unsigned long now = jiffies;
@@ -476,7 +495,7 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 						    u8 sflag, u8 *igmp_type,
 						    bool *need_rexmit)
 {
-	struct net_bridge_port *p = pg ? pg->port : NULL;
+	struct net_bridge_port *p = pg ? pg->key.port : NULL;
 	struct net_bridge_group_src *ent;
 	size_t pkt_size, mld_hdr_size;
 	unsigned long now = jiffies;
@@ -778,7 +797,7 @@ br_multicast_new_group_src(struct net_bridge_port_group *pg, struct br_ip *src_i
 		return NULL;
 
 	grp_src->pg = pg;
-	grp_src->br = pg->port->br;
+	grp_src->br = pg->key.port->br;
 	grp_src->addr = *src_ip;
 	grp_src->mcast_gc.destroy = br_multicast_destroy_group_src;
 	timer_setup(&grp_src->timer, br_multicast_group_src_expired, 0);
@@ -804,13 +823,21 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	if (unlikely(!p))
 		return NULL;
 
-	p->addr = *group;
-	p->port = port;
+	p->key.addr = *group;
+	p->key.port = port;
 	p->flags = flags;
 	p->filter_mode = filter_mode;
 	p->rt_protocol = rt_protocol;
 	p->mcast_gc.destroy = br_multicast_destroy_port_group;
 	INIT_HLIST_HEAD(&p->src_list);
+
+	if (!br_multicast_is_star_g(group) &&
+	    rhashtable_lookup_insert_fast(&port->br->sg_port_tbl, &p->rhnode,
+					  br_sg_port_rht_params)) {
+		kfree(p);
+		return NULL;
+	}
+
 	rcu_assign_pointer(p->next, next);
 	timer_setup(&p->timer, br_multicast_port_group_expired, 0);
 	timer_setup(&p->rexmit_timer, br_multicast_port_group_rexmit, 0);
@@ -828,7 +855,7 @@ static bool br_port_group_equal(struct net_bridge_port_group *p,
 				struct net_bridge_port *port,
 				const unsigned char *src)
 {
-	if (p->port != port)
+	if (p->key.port != port)
 		return false;
 
 	if (!(port->flags & BR_MULTICAST_TO_UNICAST))
@@ -890,7 +917,7 @@ static int br_multicast_add_group(struct net_bridge *br,
 	     pp = &p->next) {
 		if (br_port_group_equal(p, port, src))
 			goto found;
-		if ((unsigned long)p->port < (unsigned long)port)
+		if ((unsigned long)p->key.port < (unsigned long)port)
 			break;
 	}
 
@@ -1166,7 +1193,7 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 {
 	struct net_bridge_port_group *pg = from_timer(pg, t, rexmit_timer);
 	struct bridge_mcast_other_query *other_query = NULL;
-	struct net_bridge *br = pg->port->br;
+	struct net_bridge *br = pg->key.port->br;
 	bool need_rexmit = false;
 
 	spin_lock(&br->multicast_lock);
@@ -1175,7 +1202,7 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 	    !br_opt_get(br, BROPT_MULTICAST_QUERIER))
 		goto out;
 
-	if (pg->addr.proto == htons(ETH_P_IP))
+	if (pg->key.addr.proto == htons(ETH_P_IP))
 		other_query = &br->ip4_other_query;
 #if IS_ENABLED(CONFIG_IPV6)
 	else
@@ -1187,11 +1214,11 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 
 	if (pg->grp_query_rexmit_cnt) {
 		pg->grp_query_rexmit_cnt--;
-		__br_multicast_send_query(br, pg->port, pg, &pg->addr,
-					  &pg->addr, false, 1, NULL);
+		__br_multicast_send_query(br, pg->key.port, pg, &pg->key.addr,
+					  &pg->key.addr, false, 1, NULL);
 	}
-	__br_multicast_send_query(br, pg->port, pg, &pg->addr,
-				  &pg->addr, true, 0, &need_rexmit);
+	__br_multicast_send_query(br, pg->key.port, pg, &pg->key.addr,
+				  &pg->key.addr, true, 0, &need_rexmit);
 
 	if (pg->grp_query_rexmit_cnt || need_rexmit)
 		mod_timer(&pg->rexmit_timer, jiffies +
@@ -1325,7 +1352,7 @@ static int __grp_src_delete_marked(struct net_bridge_port_group *pg)
 static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
-	struct net_bridge *br = pg->port->br;
+	struct net_bridge *br = pg->key.port->br;
 	u32 lmqc = br->multicast_last_member_count;
 	unsigned long lmqt, lmi, now = jiffies;
 	struct net_bridge_group_src *ent;
@@ -1334,7 +1361,7 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 	    !br_opt_get(br, BROPT_MULTICAST_ENABLED))
 		return;
 
-	if (pg->addr.proto == htons(ETH_P_IP))
+	if (pg->key.addr.proto == htons(ETH_P_IP))
 		other_query = &br->ip4_other_query;
 #if IS_ENABLED(CONFIG_IPV6)
 	else
@@ -1359,8 +1386,8 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 	    !other_query || timer_pending(&other_query->timer))
 		return;
 
-	__br_multicast_send_query(br, pg->port, pg, &pg->addr,
-				  &pg->addr, true, 1, NULL);
+	__br_multicast_send_query(br, pg->key.port, pg, &pg->key.addr,
+				  &pg->key.addr, true, 1, NULL);
 
 	lmi = now + br->multicast_last_member_interval;
 	if (!timer_pending(&pg->rexmit_timer) ||
@@ -1371,14 +1398,14 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
-	struct net_bridge *br = pg->port->br;
+	struct net_bridge *br = pg->key.port->br;
 	unsigned long now = jiffies, lmi;
 
 	if (!netif_running(br->dev) ||
 	    !br_opt_get(br, BROPT_MULTICAST_ENABLED))
 		return;
 
-	if (pg->addr.proto == htons(ETH_P_IP))
+	if (pg->key.addr.proto == htons(ETH_P_IP))
 		other_query = &br->ip4_other_query;
 #if IS_ENABLED(CONFIG_IPV6)
 	else
@@ -1389,8 +1416,8 @@ static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
 	    other_query && !timer_pending(&other_query->timer)) {
 		lmi = now + br->multicast_last_member_interval;
 		pg->grp_query_rexmit_cnt = br->multicast_last_member_count - 1;
-		__br_multicast_send_query(br, pg->port, pg, &pg->addr,
-					  &pg->addr, false, 0, NULL);
+		__br_multicast_send_query(br, pg->key.port, pg, &pg->key.addr,
+					  &pg->key.addr, false, 0, NULL);
 		if (!timer_pending(&pg->rexmit_timer) ||
 		    time_after(pg->rexmit_timer.expires, lmi))
 			mod_timer(&pg->rexmit_timer, lmi);
@@ -1410,7 +1437,7 @@ static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
 static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg,
 				     void *srcs, u32 nsrcs, size_t src_size)
 {
-	struct net_bridge *br = pg->port->br;
+	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_group_src *ent;
 	unsigned long now = jiffies;
 	bool changed = false;
@@ -1418,7 +1445,7 @@ static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg,
 	u32 src_idx;
 
 	memset(&src_ip, 0, sizeof(src_ip));
-	src_ip.proto = pg->addr.proto;
+	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
@@ -1452,7 +1479,7 @@ static void __grp_src_isexc_incl(struct net_bridge_port_group *pg,
 		ent->flags |= BR_SGRP_F_DELETE;
 
 	memset(&src_ip, 0, sizeof(src_ip));
-	src_ip.proto = pg->addr.proto;
+	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
@@ -1475,7 +1502,7 @@ static void __grp_src_isexc_incl(struct net_bridge_port_group *pg,
 static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg,
 				 void *srcs, u32 nsrcs, size_t src_size)
 {
-	struct net_bridge *br = pg->port->br;
+	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_group_src *ent;
 	unsigned long now = jiffies;
 	bool changed = false;
@@ -1486,7 +1513,7 @@ static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg,
 		ent->flags |= BR_SGRP_F_DELETE;
 
 	memset(&src_ip, 0, sizeof(src_ip));
-	src_ip.proto = pg->addr.proto;
+	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
@@ -1512,7 +1539,7 @@ static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg,
 static bool br_multicast_isexc(struct net_bridge_port_group *pg,
 			       void *srcs, u32 nsrcs, size_t src_size)
 {
-	struct net_bridge *br = pg->port->br;
+	struct net_bridge *br = pg->key.port->br;
 	bool changed = false;
 
 	switch (pg->filter_mode) {
@@ -1538,7 +1565,7 @@ static bool br_multicast_isexc(struct net_bridge_port_group *pg,
 static bool __grp_src_toin_incl(struct net_bridge_port_group *pg,
 				void *srcs, u32 nsrcs, size_t src_size)
 {
-	struct net_bridge *br = pg->port->br;
+	struct net_bridge *br = pg->key.port->br;
 	u32 src_idx, to_send = pg->src_ents;
 	struct net_bridge_group_src *ent;
 	unsigned long now = jiffies;
@@ -1549,7 +1576,7 @@ static bool __grp_src_toin_incl(struct net_bridge_port_group *pg,
 		ent->flags |= BR_SGRP_F_SEND;
 
 	memset(&src_ip, 0, sizeof(src_ip));
-	src_ip.proto = pg->addr.proto;
+	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
@@ -1580,7 +1607,7 @@ static bool __grp_src_toin_incl(struct net_bridge_port_group *pg,
 static bool __grp_src_toin_excl(struct net_bridge_port_group *pg,
 				void *srcs, u32 nsrcs, size_t src_size)
 {
-	struct net_bridge *br = pg->port->br;
+	struct net_bridge *br = pg->key.port->br;
 	u32 src_idx, to_send = pg->src_ents;
 	struct net_bridge_group_src *ent;
 	unsigned long now = jiffies;
@@ -1592,7 +1619,7 @@ static bool __grp_src_toin_excl(struct net_bridge_port_group *pg,
 			ent->flags |= BR_SGRP_F_SEND;
 
 	memset(&src_ip, 0, sizeof(src_ip));
-	src_ip.proto = pg->addr.proto;
+	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
@@ -1653,7 +1680,7 @@ static void __grp_src_toex_incl(struct net_bridge_port_group *pg,
 		ent->flags = (ent->flags & ~BR_SGRP_F_SEND) | BR_SGRP_F_DELETE;
 
 	memset(&src_ip, 0, sizeof(src_ip));
-	src_ip.proto = pg->addr.proto;
+	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
@@ -1691,7 +1718,7 @@ static bool __grp_src_toex_excl(struct net_bridge_port_group *pg,
 		ent->flags = (ent->flags & ~BR_SGRP_F_SEND) | BR_SGRP_F_DELETE;
 
 	memset(&src_ip, 0, sizeof(src_ip));
-	src_ip.proto = pg->addr.proto;
+	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
@@ -1722,7 +1749,7 @@ static bool __grp_src_toex_excl(struct net_bridge_port_group *pg,
 static bool br_multicast_toex(struct net_bridge_port_group *pg,
 			      void *srcs, u32 nsrcs, size_t src_size)
 {
-	struct net_bridge *br = pg->port->br;
+	struct net_bridge *br = pg->key.port->br;
 	bool changed = false;
 
 	switch (pg->filter_mode) {
@@ -1755,7 +1782,7 @@ static void __grp_src_block_incl(struct net_bridge_port_group *pg,
 		ent->flags &= ~BR_SGRP_F_SEND;
 
 	memset(&src_ip, 0, sizeof(src_ip));
-	src_ip.proto = pg->addr.proto;
+	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
@@ -1770,7 +1797,7 @@ static void __grp_src_block_incl(struct net_bridge_port_group *pg,
 		__grp_src_query_marked_and_rexmit(pg);
 
 	if (pg->filter_mode == MCAST_INCLUDE && hlist_empty(&pg->src_list))
-		br_multicast_find_del_pg(pg->port->br, pg);
+		br_multicast_find_del_pg(pg->key.port->br, pg);
 }
 
 /* State          Msg type      New state                Actions
@@ -1789,7 +1816,7 @@ static bool __grp_src_block_excl(struct net_bridge_port_group *pg,
 		ent->flags &= ~BR_SGRP_F_SEND;
 
 	memset(&src_ip, 0, sizeof(src_ip));
-	src_ip.proto = pg->addr.proto;
+	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
@@ -2496,7 +2523,7 @@ br_multicast_leave_group(struct net_bridge *br,
 	for (p = mlock_dereference(mp->ports, br);
 	     p != NULL;
 	     p = mlock_dereference(p->next, br)) {
-		if (p->port != port)
+		if (p->key.port != port)
 			continue;
 
 		if (!hlist_unhashed(&p->mglist) &&
@@ -3256,7 +3283,7 @@ int br_multicast_list_adjacent(struct net_device *dev,
 			if (!entry)
 				goto unlock;
 
-			entry->addr = group->addr;
+			entry->addr = group->key.addr;
 			list_add(&entry->list, br_ip_list);
 			count++;
 		}
@@ -3513,10 +3540,23 @@ void br_multicast_get_stats(const struct net_bridge *br,
 
 int br_mdb_hash_init(struct net_bridge *br)
 {
-	return rhashtable_init(&br->mdb_hash_tbl, &br_mdb_rht_params);
+	int err;
+
+	err = rhashtable_init(&br->sg_port_tbl, &br_sg_port_rht_params);
+	if (err)
+		return err;
+
+	err = rhashtable_init(&br->mdb_hash_tbl, &br_mdb_rht_params);
+	if (err) {
+		rhashtable_destroy(&br->sg_port_tbl);
+		return err;
+	}
+
+	return 0;
 }
 
 void br_mdb_hash_fini(struct net_bridge *br)
 {
+	rhashtable_destroy(&br->sg_port_tbl);
 	rhashtable_destroy(&br->mdb_hash_tbl);
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index dae7e3526fc7..55486b4956d3 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -238,10 +238,14 @@ struct net_bridge_group_src {
 	struct rcu_head			rcu;
 };
 
-struct net_bridge_port_group {
+struct net_bridge_port_group_sg_key {
 	struct net_bridge_port		*port;
-	struct net_bridge_port_group __rcu *next;
 	struct br_ip			addr;
+};
+
+struct net_bridge_port_group {
+	struct net_bridge_port_group __rcu *next;
+	struct net_bridge_port_group_sg_key key;
 	unsigned char			eth_addr[ETH_ALEN] __aligned(2);
 	unsigned char			flags;
 	unsigned char			filter_mode;
@@ -254,6 +258,7 @@ struct net_bridge_port_group {
 	struct timer_list		rexmit_timer;
 	struct hlist_node		mglist;
 
+	struct rhash_head		rhnode;
 	struct net_bridge_mcast_gc	mcast_gc;
 	struct rcu_head			rcu;
 };
@@ -441,6 +446,7 @@ struct net_bridge {
 	unsigned long			multicast_startup_query_interval;
 
 	struct rhashtable		mdb_hash_tbl;
+	struct rhashtable		sg_port_tbl;
 
 	struct hlist_head		mcast_gc_list;
 	struct hlist_head		mdb_list;
-- 
2.25.4

