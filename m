Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070DD25E67F
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgIEIYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728355AbgIEIYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 04:24:50 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857A9C061247
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 01:24:49 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o5so9612510wrn.13
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 01:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DeNavSBVgHmEUxUmBQUr68dzvVd/ZWitTRA5Beang5U=;
        b=CgpeVJyQwgLFfN6RQQaz70tZ7kfPjEB4FoC8dRJtuS32f756EWMg1TvodTK2W4FrhY
         kyx0qfJ3S+2LhRmYKQb5vBYZCqEllKzN+52WA3JITh0ZPRxLSkm/ITyePoA9qHCwg9U7
         Ce95w5ZQnxtxKpz+sR0CLXd6syVdh3ApIWWh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DeNavSBVgHmEUxUmBQUr68dzvVd/ZWitTRA5Beang5U=;
        b=jtHvOum69Adc+6NFawcyZm5LIg8czrvI4M1uKXjKwKz+HCkZ+yiggAKMbayVJy95m2
         1eWFXVAeh5naC0S0rzy4KrXCT+Kt3h6od/19CUYrXkgBZJMXOG1z2QUpnu1pxeBrtRC/
         p/sWJUPlZbpqmE5w7b1szjKUvokkFwb9widyODpVZZiyNjWNMzek84FbWEiq8uuh/w71
         X8mpR+Xg4Cf6RZWh6V3xSQZDzKUEBcdCCGu8lAjUzsd2EVbbuWNK2VjCv4ZQ2Zq1dck2
         EvVtePOk2jpb9W5nEVcFxnfS8W9FB75AUO6z3v0UPAK3e8V0FGy8vGDZH+klfiypPwjL
         o7iA==
X-Gm-Message-State: AOAM533t1Etu8OsWwAouzPDTjJ+dxO7SoDTE53BHiZr9pCWzoFvO6LgO
        ydbvRvo5vMwuyAmXg9DT1nKXOsFjxS5dM3nZ
X-Google-Smtp-Source: ABdhPJzh2qxCzMyAnIh2TcEQ2/NXRKOGR2MHkzOYY3DiPTvLQLJzLgitEo45htm6+4EPdBCh44FM2w==
X-Received: by 2002:adf:e8c3:: with SMTP id k3mr11487416wrn.228.1599294287716;
        Sat, 05 Sep 2020 01:24:47 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m185sm17169296wmf.5.2020.09.05.01.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 01:24:46 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 05/15] net: bridge: mcast: factor out port group del
Date:   Sat,  5 Sep 2020 11:24:00 +0300
Message-Id: <20200905082410.2230253-6-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
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
index 76fce1dac4a5..9dc12ce61018 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -843,24 +843,11 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
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
index 4fdc1a7ba627..72b32398e279 100644
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
@@ -615,7 +621,7 @@ static void br_multicast_group_src_expired(struct timer_list *t)
 		br_multicast_del_group_src(src);
 		if (!hlist_empty(&pg->src_list))
 			goto out;
-		br_multicast_del_pg(br, pg);
+		br_multicast_find_del_pg(br, pg);
 	}
 out:
 	spin_unlock(&br->multicast_lock);
@@ -1086,7 +1092,7 @@ void br_multicast_del_port(struct net_bridge_port *port)
 	/* Take care of the remaining groups, only perm ones should be left */
 	spin_lock_bh(&br->multicast_lock);
 	hlist_for_each_entry_safe(pg, n, &port->mglist, mglist)
-		br_multicast_del_pg(br, pg);
+		br_multicast_find_del_pg(br, pg);
 	spin_unlock_bh(&br->multicast_lock);
 	del_timer_sync(&port->multicast_router_timer);
 	free_percpu(port->mcast_stats);
@@ -1135,7 +1141,7 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 	spin_lock(&br->multicast_lock);
 	hlist_for_each_entry_safe(pg, n, &port->mglist, mglist)
 		if (!(pg->flags & MDB_PG_FLAGS_PERMANENT))
-			br_multicast_del_pg(br, pg);
+			br_multicast_find_del_pg(br, pg);
 
 	__del_port_router(port);
 
@@ -1641,16 +1647,7 @@ br_multicast_leave_group(struct net_bridge *br,
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
index 45038b5c4ecd..e0632721b1ef 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -802,6 +802,9 @@ void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
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

