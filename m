Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB20257BDB
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgHaPLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728329AbgHaPKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:10:19 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5728C0619C6
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:14 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e17so5606490wme.0
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=azSAih3zOvEyH3wRNMHhDe96mbXk7n191aNOtVT5oPg=;
        b=WL+obqmP2eSLBN5CbGOqjZEvHiKgQIx+o187aUGVsNyqBxNW9xRPIvfDIWikdjVdTt
         eGMHAAsgM4VZqFm2rWrf2D5cvmCWoj8XjoLSn1bSwa6xEK0XyYbgQk0s3vLldKJmdXTl
         Qu1ROlYHoOrMFb+SevV4fKakD5MOpAQ0TTguw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=azSAih3zOvEyH3wRNMHhDe96mbXk7n191aNOtVT5oPg=;
        b=baQ2c+v8gmng8xNkIK7JEXfHkKVkR6mRvnDQF0M8FnZ99G5fdGHzsKMNU0wkRM2h3+
         +sztSUUfmAnheh6/kHfRQLhVQeSGbK7vfbT1yJxzwfpXvs3uI5CmQANfTdE0EcsbY90h
         SXZ5VINI9m/mwmgPDCOtEAFqWIosMxbKuVLcOYfPCHOxa6PwHigEZv0zu7cKZDebq3p0
         G6NmNCjoa05BEszMew4f5ggrPCUXX2zKVwyF95SGfvbhRAgtDQXPl9ykiF80TQBSCYO0
         d4Eof3aMnd4hG2ahpbB+GBZ+Psj9dZvvy60xv4DHQB1bNb9I1kYXKFPADQt3WBnMqjFg
         4djQ==
X-Gm-Message-State: AOAM530cnF27krGYDJc3Ood6ddsxWO06TSSXoHTjMskV3G9Pt2I1Xucb
        qxVR098d9Lev101Ut3BNIVI4yis7kEhROyJl
X-Google-Smtp-Source: ABdhPJyxYe+cqsP66Fpp39cOY47lzzXYp26KSOF3Wbr3TH2W2ivKR5I9wvxyUWnaiOn89smoyYzzvw==
X-Received: by 2002:a1c:ab55:: with SMTP id u82mr1757067wme.139.1598886612908;
        Mon, 31 Aug 2020 08:10:12 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f6sm14181636wme.32.2020.08.31.08.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:10:12 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 15/15] net: bridge: mcast: destroy all entries via gc
Date:   Mon, 31 Aug 2020 18:08:45 +0300
Message-Id: <20200831150845.1062447-16-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
References: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since each entry type has timers that can be running simultaneously we need
to make sure that entries are not freed before their timers have finished.
In order to do that generalize the src gc work to mcast gc work and use a
callback to free the entries (mdb, port group or src).

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 103 ++++++++++++++++++++++++++------------
 net/bridge/br_private.h   |  13 +++--
 2 files changed, 80 insertions(+), 36 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3b1d9ef25723..92b206167f4f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -140,6 +140,29 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 	return br_mdb_ip_get_rcu(br, &ip);
 }
 
+static void br_multicast_destroy_mdb_entry(struct net_bridge_mcast_gc *gc)
+{
+	struct net_bridge_mdb_entry *mp;
+
+	mp = container_of(gc, struct net_bridge_mdb_entry, mcast_gc);
+	WARN_ON(!hlist_unhashed(&mp->mdb_node));
+	WARN_ON(mp->ports);
+
+	del_timer_sync(&mp->timer);
+	kfree_rcu(mp, rcu);
+}
+
+static void br_multicast_del_mdb_entry(struct net_bridge_mdb_entry *mp)
+{
+	struct net_bridge *br = mp->br;
+
+	rhashtable_remove_fast(&br->mdb_hash_tbl, &mp->rhnode,
+			       br_mdb_rht_params);
+	hlist_del_init_rcu(&mp->mdb_node);
+	hlist_add_head(&mp->mcast_gc.gc_node, &br->mcast_gc_list);
+	queue_work(system_long_wq, &br->mcast_gc_work);
+}
+
 static void br_multicast_group_expired(struct timer_list *t)
 {
 	struct net_bridge_mdb_entry *mp = from_timer(mp, t, timer);
@@ -153,15 +176,20 @@ static void br_multicast_group_expired(struct timer_list *t)
 
 	if (mp->ports)
 		goto out;
+	br_multicast_del_mdb_entry(mp);
+out:
+	spin_unlock(&br->multicast_lock);
+}
 
-	rhashtable_remove_fast(&br->mdb_hash_tbl, &mp->rhnode,
-			       br_mdb_rht_params);
-	hlist_del_rcu(&mp->mdb_node);
+static void br_multicast_destroy_group_src(struct net_bridge_mcast_gc *gc)
+{
+	struct net_bridge_group_src *src;
 
-	kfree_rcu(mp, rcu);
+	src = container_of(gc, struct net_bridge_group_src, mcast_gc);
+	WARN_ON(!hlist_unhashed(&src->node));
 
-out:
-	spin_unlock(&br->multicast_lock);
+	del_timer_sync(&src->timer);
+	kfree(src);
 }
 
 static void br_multicast_del_group_src(struct net_bridge_group_src *src)
@@ -170,8 +198,21 @@ static void br_multicast_del_group_src(struct net_bridge_group_src *src)
 
 	hlist_del_init(&src->node);
 	src->pg->src_ents--;
-	hlist_add_head(&src->del_node, &br->src_gc_list);
-	queue_work(system_long_wq, &br->src_gc_work);
+	hlist_add_head(&src->mcast_gc.gc_node, &br->mcast_gc_list);
+	queue_work(system_long_wq, &br->mcast_gc_work);
+}
+
+static void br_multicast_destroy_port_group(struct net_bridge_mcast_gc *gc)
+{
+	struct net_bridge_port_group *pg;
+
+	pg = container_of(gc, struct net_bridge_port_group, mcast_gc);
+	WARN_ON(!hlist_unhashed(&pg->mglist));
+	WARN_ON(!hlist_empty(&pg->src_list));
+
+	del_timer_sync(&pg->rexmit_timer);
+	del_timer_sync(&pg->timer);
+	kfree_rcu(pg, rcu);
 }
 
 void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
@@ -184,12 +225,11 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 
 	rcu_assign_pointer(*pp, pg->next);
 	hlist_del_init(&pg->mglist);
-	del_timer(&pg->timer);
-	del_timer(&pg->rexmit_timer);
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
 		br_multicast_del_group_src(ent);
 	br_mdb_notify(br->dev, mp, pg, RTM_DELMDB);
-	kfree_rcu(pg, rcu);
+	hlist_add_head(&pg->mcast_gc.gc_node, &br->mcast_gc_list);
+	queue_work(system_long_wq, &br->mcast_gc_work);
 
 	if (!mp->ports && !mp->host_joined && netif_running(br->dev))
 		mod_timer(&mp->timer, jiffies);
@@ -560,6 +600,7 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 
 	mp->br = br;
 	mp->addr = *group;
+	mp->mcast_gc.destroy = br_multicast_destroy_mdb_entry;
 	timer_setup(&mp->timer, br_multicast_group_expired, 0);
 	err = rhashtable_lookup_insert_fast(&br->mdb_hash_tbl, &mp->rhnode,
 					    br_mdb_rht_params);
@@ -642,6 +683,7 @@ br_multicast_new_group_src(struct net_bridge_port_group *pg, struct br_ip *src_i
 	grp_src->pg = pg;
 	grp_src->br = pg->port->br;
 	grp_src->addr = *src_ip;
+	grp_src->mcast_gc.destroy = br_multicast_destroy_group_src;
 	timer_setup(&grp_src->timer, br_multicast_group_src_expired, 0);
 
 	hlist_add_head(&grp_src->node, &pg->src_list);
@@ -671,6 +713,7 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 		p->filter_mode = MCAST_INCLUDE;
 	else
 		p->filter_mode = MCAST_EXCLUDE;
+	p->mcast_gc.destroy = br_multicast_destroy_port_group;
 	INIT_HLIST_HEAD(&p->src_list);
 	rcu_assign_pointer(p->next, next);
 	timer_setup(&p->timer, br_multicast_port_group_expired, 0);
@@ -2584,29 +2627,28 @@ static void br_ip6_multicast_query_expired(struct timer_list *t)
 }
 #endif
 
-static void __grp_src_gc(struct hlist_head *head)
+static void br_multicast_do_gc(struct hlist_head *head)
 {
-	struct net_bridge_group_src *ent;
+	struct net_bridge_mcast_gc *gcent;
 	struct hlist_node *tmp;
 
-	hlist_for_each_entry_safe(ent, tmp, head, del_node) {
-		hlist_del_init(&ent->del_node);
-		del_timer_sync(&ent->timer);
-		kfree(ent);
+	hlist_for_each_entry_safe(gcent, tmp, head, gc_node) {
+		hlist_del_init(&gcent->gc_node);
+		gcent->destroy(gcent);
 	}
 }
 
-static void br_multicast_src_gc(struct work_struct *work)
+static void br_multicast_gc(struct work_struct *work)
 {
 	struct net_bridge *br = container_of(work, struct net_bridge,
-					     src_gc_work);
+					     mcast_gc_work);
 	HLIST_HEAD(deleted_head);
 
 	spin_lock_bh(&br->multicast_lock);
-	hlist_move_list(&br->src_gc_list, &deleted_head);
+	hlist_move_list(&br->mcast_gc_list, &deleted_head);
 	spin_unlock_bh(&br->multicast_lock);
 
-	__grp_src_gc(&deleted_head);
+	br_multicast_do_gc(&deleted_head);
 }
 
 void br_multicast_init(struct net_bridge *br)
@@ -2649,8 +2691,8 @@ void br_multicast_init(struct net_bridge *br)
 		    br_ip6_multicast_query_expired, 0);
 #endif
 	INIT_HLIST_HEAD(&br->mdb_list);
-	INIT_HLIST_HEAD(&br->src_gc_list);
-	INIT_WORK(&br->src_gc_work, br_multicast_src_gc);
+	INIT_HLIST_HEAD(&br->mcast_gc_list);
+	INIT_WORK(&br->mcast_gc_work, br_multicast_gc);
 }
 
 static void br_ip4_multicast_join_snoopers(struct net_bridge *br)
@@ -2758,18 +2800,13 @@ void br_multicast_dev_del(struct net_bridge *br)
 	struct hlist_node *tmp;
 
 	spin_lock_bh(&br->multicast_lock);
-	hlist_for_each_entry_safe(mp, tmp, &br->mdb_list, mdb_node) {
-		del_timer(&mp->timer);
-		rhashtable_remove_fast(&br->mdb_hash_tbl, &mp->rhnode,
-				       br_mdb_rht_params);
-		hlist_del_rcu(&mp->mdb_node);
-		kfree_rcu(mp, rcu);
-	}
-	hlist_move_list(&br->src_gc_list, &deleted_head);
+	hlist_for_each_entry_safe(mp, tmp, &br->mdb_list, mdb_node)
+		br_multicast_del_mdb_entry(mp);
+	hlist_move_list(&br->mcast_gc_list, &deleted_head);
 	spin_unlock_bh(&br->multicast_lock);
 
-	__grp_src_gc(&deleted_head);
-	cancel_work_sync(&br->src_gc_work);
+	br_multicast_do_gc(&deleted_head);
+	cancel_work_sync(&br->mcast_gc_work);
 
 	rcu_barrier();
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index cbcec3bf28ea..4225c72cec8b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -219,6 +219,11 @@ struct net_bridge_fdb_entry {
 #define BR_SGRP_F_DELETE	BIT(0)
 #define BR_SGRP_F_SEND		BIT(1)
 
+struct net_bridge_mcast_gc {
+	struct hlist_node		gc_node;
+	void				(*destroy)(struct net_bridge_mcast_gc *gc);
+};
+
 struct net_bridge_group_src {
 	struct hlist_node		node;
 
@@ -229,7 +234,7 @@ struct net_bridge_group_src {
 	struct timer_list		timer;
 
 	struct net_bridge		*br;
-	struct hlist_node		del_node;
+	struct net_bridge_mcast_gc	mcast_gc;
 };
 
 struct net_bridge_port_group {
@@ -247,6 +252,7 @@ struct net_bridge_port_group {
 	struct timer_list		rexmit_timer;
 	struct hlist_node		mglist;
 
+	struct net_bridge_mcast_gc	mcast_gc;
 	struct rcu_head			rcu;
 };
 
@@ -260,6 +266,7 @@ struct net_bridge_mdb_entry {
 	struct timer_list		timer;
 	struct hlist_node		mdb_node;
 
+	struct net_bridge_mcast_gc	mcast_gc;
 	struct rcu_head			rcu;
 };
 
@@ -433,7 +440,7 @@ struct net_bridge {
 
 	struct rhashtable		mdb_hash_tbl;
 
-	struct hlist_head		src_gc_list;
+	struct hlist_head		mcast_gc_list;
 	struct hlist_head		mdb_list;
 	struct hlist_head		router_list;
 
@@ -447,7 +454,7 @@ struct net_bridge {
 	struct bridge_mcast_own_query	ip6_own_query;
 	struct bridge_mcast_querier	ip6_querier;
 #endif /* IS_ENABLED(CONFIG_IPV6) */
-	struct work_struct		src_gc_work;
+	struct work_struct		mcast_gc_work;
 #endif
 
 	struct timer_list		hello_timer;
-- 
2.25.4

