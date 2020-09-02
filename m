Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D69625AA4B
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgIBLaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIBL3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:29:13 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF0AC061246
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:29:12 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z1so4850984wrt.3
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KnPLirI9bx/JX93C1Mqh9PJa9DSM38HJhHVkqeMWmgU=;
        b=A0g9W14sjywgCbhRZcKGgODjWg1iMNVOt06gt6XtT9dQHeETXJnwa6T/vpag2JgzZ8
         3AIhRt2ZXD9XpoYbzncTYOEIw2Qb4+RvF/7WZ3wraAgzSqd6qwwIwiwt+dOYxGpp2dVe
         3JdzYwa6h7AErbwVcEnHy+JuePpgena28cVBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KnPLirI9bx/JX93C1Mqh9PJa9DSM38HJhHVkqeMWmgU=;
        b=XIr5MUeQBpK9Z6tspcqpoAEHg2CqyAcuDFfqvz+n1WpRYJBxDxn2MeheGJJRFwBphY
         2X38tm8uNPfSGWEv3NaRkIiyIgZDCWnnvlW4pdprp1UplQw9GQEfBpP4Nkh7wDpDBx6V
         6TRa37zFuZraptlx9QTtfZgecYVlzMK0Xjb13ZMej8Zdp6xzzE2tQrraVxz9eD7Q319C
         1Jefeh+zl+nmTbdlY/EJYJ7cBL6dNRvA6N83u3NBZyxIuzZbq6SgfMBqXz8455n20g0z
         A0z+i1jEBKJOb/efCco7kzud/iKXKrDaisQ4FvhDRcTgW2MCUnHxi1uMT1AirzKTp+6j
         fbGQ==
X-Gm-Message-State: AOAM532LamTRy1a94L/1I4kgk3dHGNAOlu3Tf+LoP+PEIJEOSz0/cnZt
        +E7lOCnrmG0ZE4a6VDRfvx3hbXbATKju7ioo
X-Google-Smtp-Source: ABdhPJy+hbqbYUhMVW0rugn0bPh76BfKw3nHPLhk7PrSI1suJHIiF2bkiVxwdqbTSZDfWBhqdNzs5A==
X-Received: by 2002:adf:f544:: with SMTP id j4mr1581808wrp.74.1599046150772;
        Wed, 02 Sep 2020 04:29:10 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm5985172wmz.22.2020.09.02.04.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:29:10 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 02/15] net: bridge: mcast: add support for group source list
Date:   Wed,  2 Sep 2020 14:25:16 +0300
Message-Id: <20200902112529.1570040-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initial functions for group source lists which are needed for IGMPv3
include/exclude lists. Currently only IPv4 sources are supported.
User-added mdb entries are created with exclude filter mode, we can
extend that later to allow user-supplied mode. When group src entries
are deleted, they're freed from a workqueue to make sure their timers
are not still running. Source entries are protected by the multicast_lock
and rcu. The number of src groups per port group is limited to 32.

v2: allow src groups to be traversed under rcu

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_mdb.c       |   6 ++
 net/bridge/br_multicast.c | 129 ++++++++++++++++++++++++++++++++++++++
 net/bridge/br_private.h   |  23 +++++++
 3 files changed, 158 insertions(+)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index da5ed4cf9233..025a5aff2b2f 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -641,6 +641,7 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	p = br_multicast_new_port_group(port, group, *pp, state, NULL);
 	if (unlikely(!p))
 		return -ENOMEM;
+	p->filter_mode = MCAST_EXCLUDE;
 	rcu_assign_pointer(*pp, p);
 	if (state == MDB_TEMPORARY)
 		mod_timer(&p->timer, now + br->multicast_membership_interval);
@@ -761,6 +762,11 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
 		if (!p->port || p->port->dev->ifindex != entry->ifindex)
 			continue;
 
+		if (!hlist_empty(&p->src_list)) {
+			err = -EINVAL;
+			goto unlock;
+		}
+
 		if (p->port->state == BR_STATE_DISABLED)
 			goto unlock;
 
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 4c4a93abde68..9269d62884e5 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -163,12 +163,24 @@ static void br_multicast_group_expired(struct timer_list *t)
 	spin_unlock(&br->multicast_lock);
 }
 
+static void br_multicast_del_group_src(struct net_bridge_group_src *src)
+{
+	struct net_bridge *br = src->pg->port->br;
+
+	hlist_del_init_rcu(&src->node);
+	src->pg->src_ents--;
+	hlist_add_head(&src->del_node, &br->src_gc_list);
+	queue_work(system_long_wq, &br->src_gc_work);
+}
+
 static void br_multicast_del_pg(struct net_bridge *br,
 				struct net_bridge_port_group *pg)
 {
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
 	struct net_bridge_port_group __rcu **pp;
+	struct net_bridge_group_src *ent;
+	struct hlist_node *tmp;
 
 	mp = br_mdb_ip_get(br, &pg->addr);
 	if (WARN_ON(!mp))
@@ -183,6 +195,8 @@ static void br_multicast_del_pg(struct net_bridge *br,
 		rcu_assign_pointer(*pp, p->next);
 		hlist_del_init(&p->mglist);
 		del_timer(&p->timer);
+		hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
+			br_multicast_del_group_src(ent);
 		br_mdb_notify(br->dev, p->port, &pg->addr, RTM_DELMDB,
 			      p->flags);
 		kfree_rcu(p, rcu);
@@ -470,6 +484,83 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 	return mp;
 }
 
+static void br_multicast_group_src_expired(struct timer_list *t)
+{
+	struct net_bridge_group_src *src = from_timer(src, t, timer);
+	struct net_bridge_port_group *pg;
+	struct net_bridge *br = src->br;
+
+	spin_lock(&br->multicast_lock);
+	if (hlist_unhashed(&src->node) || !netif_running(br->dev) ||
+	    timer_pending(&src->timer))
+		goto out;
+
+	pg = src->pg;
+	br_debug(br, "port %s: src %pI4 group %pI4 filter mode %u timer expired\n",
+		 pg->port->dev->name, &src->addr.u.ip4, &src->pg->addr.u.ip4,
+		 src->pg->filter_mode);
+
+	if (pg->filter_mode == MCAST_INCLUDE) {
+		br_multicast_del_group_src(src);
+		if (!hlist_empty(&pg->src_list))
+			goto out;
+		br_multicast_del_pg(br, pg);
+	}
+out:
+	spin_unlock(&br->multicast_lock);
+}
+
+static struct net_bridge_group_src *
+br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip)
+{
+	struct net_bridge_group_src *ent;
+
+	hlist_for_each_entry(ent, &pg->src_list, node) {
+		if (ent->addr.proto != ip->proto)
+			continue;
+
+		switch (ip->proto) {
+		case htons(ETH_P_IP):
+			if (ip->u.ip4 == ent->addr.u.ip4)
+				return ent;
+			break;
+		}
+	}
+
+	return NULL;
+}
+
+static struct net_bridge_group_src *
+br_multicast_new_group_src(struct net_bridge_port_group *pg, struct br_ip *src_ip)
+{
+	struct net_bridge_group_src *grp_src;
+
+	if (unlikely(pg->src_ents >= PG_SRC_ENT_LIMIT))
+		return NULL;
+
+	switch (src_ip->proto) {
+	case htons(ETH_P_IP):
+		if (ipv4_is_zeronet(src_ip->u.ip4) ||
+		    ipv4_is_multicast(src_ip->u.ip4))
+			return NULL;
+		break;
+	}
+
+	grp_src = kzalloc(sizeof(*grp_src), GFP_ATOMIC);
+	if (unlikely(!grp_src))
+		return NULL;
+
+	grp_src->pg = pg;
+	grp_src->br = pg->port->br;
+	grp_src->addr = *src_ip;
+	timer_setup(&grp_src->timer, br_multicast_group_src_expired, 0);
+
+	hlist_add_head_rcu(&grp_src->node, &pg->src_list);
+	pg->src_ents++;
+
+	return grp_src;
+}
+
 struct net_bridge_port_group *br_multicast_new_port_group(
 			struct net_bridge_port *port,
 			struct br_ip *group,
@@ -486,6 +577,12 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	p->addr = *group;
 	p->port = port;
 	p->flags = flags;
+	if (group->proto == htons(ETH_P_IP) &&
+	    port->br->multicast_igmp_version == 3)
+		p->filter_mode = MCAST_INCLUDE;
+	else
+		p->filter_mode = MCAST_EXCLUDE;
+	INIT_HLIST_HEAD(&p->src_list);
 	rcu_assign_pointer(p->next, next);
 	hlist_add_head(&p->mglist, &port->mglist);
 	timer_setup(&p->timer, br_multicast_port_group_expired, 0);
@@ -1781,6 +1878,31 @@ static void br_ip6_multicast_query_expired(struct timer_list *t)
 }
 #endif
 
+static void __grp_src_gc(struct hlist_head *head)
+{
+	struct net_bridge_group_src *ent;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry_safe(ent, tmp, head, del_node) {
+		hlist_del_init(&ent->del_node);
+		del_timer_sync(&ent->timer);
+		kfree_rcu(ent, rcu);
+	}
+}
+
+static void br_multicast_src_gc(struct work_struct *work)
+{
+	struct net_bridge *br = container_of(work, struct net_bridge,
+					     src_gc_work);
+	HLIST_HEAD(deleted_head);
+
+	spin_lock_bh(&br->multicast_lock);
+	hlist_move_list(&br->src_gc_list, &deleted_head);
+	spin_unlock_bh(&br->multicast_lock);
+
+	__grp_src_gc(&deleted_head);
+}
+
 void br_multicast_init(struct net_bridge *br)
 {
 	br->hash_max = BR_MULTICAST_DEFAULT_HASH_MAX;
@@ -1821,6 +1943,8 @@ void br_multicast_init(struct net_bridge *br)
 		    br_ip6_multicast_query_expired, 0);
 #endif
 	INIT_HLIST_HEAD(&br->mdb_list);
+	INIT_HLIST_HEAD(&br->src_gc_list);
+	INIT_WORK(&br->src_gc_work, br_multicast_src_gc);
 }
 
 static void br_ip4_multicast_join_snoopers(struct net_bridge *br)
@@ -1924,6 +2048,7 @@ void br_multicast_stop(struct net_bridge *br)
 void br_multicast_dev_del(struct net_bridge *br)
 {
 	struct net_bridge_mdb_entry *mp;
+	HLIST_HEAD(deleted_head);
 	struct hlist_node *tmp;
 
 	spin_lock_bh(&br->multicast_lock);
@@ -1934,8 +2059,12 @@ void br_multicast_dev_del(struct net_bridge *br)
 		hlist_del_rcu(&mp->mdb_node);
 		kfree_rcu(mp, rcu);
 	}
+	hlist_move_list(&br->src_gc_list, &deleted_head);
 	spin_unlock_bh(&br->multicast_lock);
 
+	__grp_src_gc(&deleted_head);
+	cancel_work_sync(&br->src_gc_work);
+
 	rcu_barrier();
 }
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 357b6905ecef..311ad0e402dc 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -214,13 +214,34 @@ struct net_bridge_fdb_entry {
 #define MDB_PG_FLAGS_OFFLOAD	BIT(1)
 #define MDB_PG_FLAGS_FAST_LEAVE	BIT(2)
 
+#define PG_SRC_ENT_LIMIT	32
+
+#define BR_SGRP_F_DELETE	BIT(0)
+#define BR_SGRP_F_SEND		BIT(1)
+
+struct net_bridge_group_src {
+	struct hlist_node		node;
+
+	struct br_ip			addr;
+	struct net_bridge_port_group	*pg;
+	u8				flags;
+	struct timer_list		timer;
+
+	struct net_bridge		*br;
+	struct hlist_node		del_node;
+	struct rcu_head			rcu;
+};
+
 struct net_bridge_port_group {
 	struct net_bridge_port		*port;
 	struct net_bridge_port_group __rcu *next;
 	struct br_ip			addr;
 	unsigned char			eth_addr[ETH_ALEN] __aligned(2);
 	unsigned char			flags;
+	unsigned char			filter_mode;
 
+	struct hlist_head		src_list;
+	unsigned int			src_ents;
 	struct timer_list		timer;
 	struct hlist_node		mglist;
 
@@ -410,6 +431,7 @@ struct net_bridge {
 
 	struct rhashtable		mdb_hash_tbl;
 
+	struct hlist_head		src_gc_list;
 	struct hlist_head		mdb_list;
 	struct hlist_head		router_list;
 
@@ -423,6 +445,7 @@ struct net_bridge {
 	struct bridge_mcast_own_query	ip6_own_query;
 	struct bridge_mcast_querier	ip6_querier;
 #endif /* IS_ENABLED(CONFIG_IPV6) */
+	struct work_struct		src_gc_work;
 #endif
 
 	struct timer_list		hello_timer;
-- 
2.25.4

