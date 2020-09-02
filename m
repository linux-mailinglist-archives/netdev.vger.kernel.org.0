Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE14325AA50
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgIBLav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgIBL3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:29:19 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3FFC061249
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:29:17 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c18so4828173wrm.9
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2iclW78xK5wy/jYYYTgbMHWLGP+hCzvvFTm6EyYG9yU=;
        b=g7V5t0d+kk6TB3jlvbfNikV4B1FGIJVc1sQAKlAyQ5W6g3pKwIUXoWHLMxjd3+ea5N
         s80i0zzq+gsPcHIrlqHPIX/3G8wfmJkgTPnXiKZ2ZNr3StUiqZYF4fDc9qakf9SF6waY
         uL5vdEjS66edy8Er+ZPQ0kmbx7nzx9jI358Is=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2iclW78xK5wy/jYYYTgbMHWLGP+hCzvvFTm6EyYG9yU=;
        b=oTB7vHaAM9+auOSfdHY50wFm4zuQQ+VhLELb0vhr+0VDyEQO21fqoT5foSPqW+ektS
         760iuGh/V1IzxesGRnOcYCACyqr3ZF+/X8SqkVJ+0JGgE5YrxGDY6lArMTmNh6nvVK94
         fg95eghSBH5ftrAYk29ZCKtlBC5iXe0LqFAFf2dfF4pUWF5uK+CQBSbM/dCElMznsq/U
         Q6DIiCt/rPAmaMXQzv/x7kjMwpgX8flro7lt/d+W2CR6F+1LCq0dmaWm4EItLH5RUJLd
         DIuhOJQKpPV8aOk4+O/HKGcull9qhMfWna3qCDjURwGCPLNHjcS/STLBoaK0hn0gtQhG
         Wriw==
X-Gm-Message-State: AOAM532OL3EeEP5IG1JW4iUS+6E281GlmGMyy1G613NFPn7m07/+Rm+9
        Bci5VjAiOHhUepzVfvzSjLPtDbIaU/IDctMn
X-Google-Smtp-Source: ABdhPJyDWZIaBSYuPz9DtNVDSgtugI9YKCsBueZYid8ZHC+yQYzgs2nX8bp/lJGENY92WulXzTu/aA==
X-Received: by 2002:adf:e8c5:: with SMTP id k5mr6798968wrn.352.1599046155443;
        Wed, 02 Sep 2020 04:29:15 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm5985172wmz.22.2020.09.02.04.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:29:14 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 05/15] net: bridge: mcast: factor out port group del
Date:   Wed,  2 Sep 2020 14:25:19 +0300
Message-Id: <20200902112529.1570040-6-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to avoid future errors and reduce code duplication we should
factor out the port group del sequence. This allows us to have one
function which takes care of all details when removing a port group.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_mdb.c       | 15 +---------
 net/bridge/br_multicast.c | 59 +++++++++++++++++++--------------------
 net/bridge/br_private.h   |  3 ++
 3 files changed, 32 insertions(+), 45 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 7d4d064a49e3..7625db4b7fb9 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -825,24 +825,11 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
 		if (!p->port || p->port->dev->ifindex != entry->ifindex)
 			continue;
 
-		if (!hlist_empty(&p->src_list)) {
-			err = -EINVAL;
-			goto unlock;
-		}
-
 		if (p->port->state == BR_STATE_DISABLED)
 			goto unlock;
 
-		__mdb_entry_fill_flags(entry, p->flags);
-		rcu_assign_pointer(*pp, p->next);
-		hlist_del_init(&p->mglist);
-		del_timer(&p->timer);
-		kfree_rcu(p, rcu);
+		br_multicast_del_pg(mp, p, pp);
 		err = 0;
-
-		if (!mp->ports && !mp->host_joined &&
-		    netif_running(br->dev))
-			mod_timer(&mp->timer, jiffies);
 		break;
 	}
 
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 8a415672764a..ff73d1760b2f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -173,14 +173,32 @@ static void br_multicast_del_group_src(struct net_bridge_group_src *src)
 	queue_work(system_long_wq, &br->src_gc_work);
 }
 
-static void br_multicast_del_pg(struct net_bridge *br,
-				struct net_bridge_port_group *pg)
+void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+			 struct net_bridge_port_group *pg,
+			 struct net_bridge_port_group __rcu **pp)
+{
+	struct net_bridge *br = pg->port->br;
+	struct net_bridge_group_src *ent;
+	struct hlist_node *tmp;
+
+	rcu_assign_pointer(*pp, pg->next);
+	hlist_del_init(&pg->mglist);
+	del_timer(&pg->timer);
+	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
+		br_multicast_del_group_src(ent);
+	br_mdb_notify(br->dev, pg->port, &pg->addr, RTM_DELMDB, pg->flags);
+	kfree_rcu(pg, rcu);
+
+	if (!mp->ports && !mp->host_joined && netif_running(br->dev))
+		mod_timer(&mp->timer, jiffies);
+}
+
+static void br_multicast_find_del_pg(struct net_bridge *br,
+				     struct net_bridge_port_group *pg)
 {
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
 	struct net_bridge_port_group __rcu **pp;
-	struct net_bridge_group_src *ent;
-	struct hlist_node *tmp;
 
 	mp = br_mdb_ip_get(br, &pg->addr);
 	if (WARN_ON(!mp))
@@ -192,19 +210,7 @@ static void br_multicast_del_pg(struct net_bridge *br,
 		if (p != pg)
 			continue;
 
-		rcu_assign_pointer(*pp, p->next);
-		hlist_del_init(&p->mglist);
-		del_timer(&p->timer);
-		hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
-			br_multicast_del_group_src(ent);
-		br_mdb_notify(br->dev, p->port, &pg->addr, RTM_DELMDB,
-			      p->flags);
-		kfree_rcu(p, rcu);
-
-		if (!mp->ports && !mp->host_joined &&
-		    netif_running(br->dev))
-			mod_timer(&mp->timer, jiffies);
-
+		br_multicast_del_pg(mp, pg, pp);
 		return;
 	}
 
@@ -221,7 +227,7 @@ static void br_multicast_port_group_expired(struct timer_list *t)
 	    hlist_unhashed(&pg->mglist) || pg->flags & MDB_PG_FLAGS_PERMANENT)
 		goto out;
 
-	br_multicast_del_pg(br, pg);
+	br_multicast_find_del_pg(br, pg);
 
 out:
 	spin_unlock(&br->multicast_lock);
@@ -561,7 +567,7 @@ static void br_multicast_group_src_expired(struct timer_list *t)
 		br_multicast_del_group_src(src);
 		if (!hlist_empty(&pg->src_list))
 			goto out;
-		br_multicast_del_pg(br, pg);
+		br_multicast_find_del_pg(br, pg);
 	}
 out:
 	spin_unlock(&br->multicast_lock);
@@ -1018,7 +1024,7 @@ void br_multicast_del_port(struct net_bridge_port *port)
 	/* Take care of the remaining groups, only perm ones should be left */
 	spin_lock_bh(&br->multicast_lock);
 	hlist_for_each_entry_safe(pg, n, &port->mglist, mglist)
-		br_multicast_del_pg(br, pg);
+		br_multicast_find_del_pg(br, pg);
 	spin_unlock_bh(&br->multicast_lock);
 	del_timer_sync(&port->multicast_router_timer);
 	free_percpu(port->mcast_stats);
@@ -1067,7 +1073,7 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 	spin_lock(&br->multicast_lock);
 	hlist_for_each_entry_safe(pg, n, &port->mglist, mglist)
 		if (!(pg->flags & MDB_PG_FLAGS_PERMANENT))
-			br_multicast_del_pg(br, pg);
+			br_multicast_find_del_pg(br, pg);
 
 	__del_port_router(port);
 
@@ -1573,16 +1579,7 @@ br_multicast_leave_group(struct net_bridge *br,
 			if (p->flags & MDB_PG_FLAGS_PERMANENT)
 				break;
 
-			rcu_assign_pointer(*pp, p->next);
-			hlist_del_init(&p->mglist);
-			del_timer(&p->timer);
-			kfree_rcu(p, rcu);
-			br_mdb_notify(br->dev, port, group, RTM_DELMDB,
-				      p->flags | MDB_PG_FLAGS_FAST_LEAVE);
-
-			if (!mp->ports && !mp->host_joined &&
-			    netif_running(br->dev))
-				mod_timer(&mp->timer, jiffies);
+			br_multicast_del_pg(mp, p, pp);
 		}
 		goto out;
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 87610d6c0b3f..e363b508db92 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -801,6 +801,9 @@ void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
 		   struct br_ip *group, int type, u8 flags);
 void br_rtr_notify(struct net_device *dev, struct net_bridge_port *port,
 		   int type);
+void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+			 struct net_bridge_port_group *pg,
+			 struct net_bridge_port_group __rcu **pp);
 void br_multicast_count(struct net_bridge *br, const struct net_bridge_port *p,
 			const struct sk_buff *skb, u8 type, u8 dir);
 int br_multicast_init_stats(struct net_bridge *br);
-- 
2.25.4

