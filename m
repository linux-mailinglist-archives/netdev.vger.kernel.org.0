Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F1525AA5A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgIBLbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIBL3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:29:23 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1A6C061251
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:29:22 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id a65so4022752wme.5
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SI/CpXlFQ7+5EWD3QL4KtZZw/p3is0KCLqq/AGio+PE=;
        b=LXw+OSfzeSqGm1c1zUhvmHElOpxCvsj+MXlezmJETVamECG0VNJtasWL8BrC1hobsd
         SiGa34pv6dcFIsL50LdTOKixKDIsdJRIafWQYFtbqFSKOvNNxfdt0tZVwWZzr6cDJ4oU
         7kyiEOar1Sh7a5B5Hdi6093d7IjSOZ5WPf/kk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SI/CpXlFQ7+5EWD3QL4KtZZw/p3is0KCLqq/AGio+PE=;
        b=kpzRK5JEV56MrzDEMUD8wIGmIxsouJwmM6tdL0R2pXQ2zUSku5/uKjZ5uErpKxyWkb
         VuV4Ugpo31EFLQiCZoun5SSGt0oTX+LyhTmbBJ/jcmGtfVwFeAJSEFnfPNCpFYfUQVed
         eOBXN9UIWdD36QLt0CudHMm8Y0hPVx5XK5/3OfdycFYUEYig36vnbEVLk584thGbGXXI
         Ar5Ubl6ky2LBDVRWEdt9gQWSCZOQRiR6SA6wpl92CicKrDVpZEYKBUGr7/EmoRm7Ag/l
         uV+VQtmPiHztG9K99VZc7ItUSmWcWuZS6gp1sCI16ON7H9lOQsF74GoG8zlbBOe+4AD/
         92gA==
X-Gm-Message-State: AOAM5327LgxlOXtqlR9nzXFk8KUqgSzqQ/zMq9Mruncl5pshNMXU/2k5
        G5F4eO0CLOGSN4ZORw1YHpdQ+LOctygJtmFZ
X-Google-Smtp-Source: ABdhPJwM+osvJBbu+Y7kCNjinlUsW2K0wBQMewe8pEHrmJjmwKC3Cu6h5P6M9ItfmqC+qIiaelfBfA==
X-Received: by 2002:a7b:cb4e:: with SMTP id v14mr222424wmj.140.1599046159842;
        Wed, 02 Sep 2020 04:29:19 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm5985172wmz.22.2020.09.02.04.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:29:19 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 08/15] net: bridge: mdb: use mdb and port entries in notifications
Date:   Wed,  2 Sep 2020 14:25:22 +0300
Message-Id: <20200902112529.1570040-9-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have to use mdb and port entries when sending mdb notifications in
order to fill in all group attributes properly. Before this change we
would've used a fake br_mdb_entry struct to fill in only partial
information about the mdb. Now we can also reuse the mdb dump fill
function and thus have only a single central place which fills the mdb
attributes.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_mdb.c       | 131 ++++++++++++++++++++------------------
 net/bridge/br_multicast.c |  10 +--
 net/bridge/br_private.h   |   4 +-
 3 files changed, 77 insertions(+), 68 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index f5290021310a..33236c2a14a3 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -326,14 +326,15 @@ static int br_mdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 static int nlmsg_populate_mdb_fill(struct sk_buff *skb,
 				   struct net_device *dev,
-				   struct br_mdb_entry *entry, u32 pid,
-				   u32 seq, int type, unsigned int flags)
+				   struct net_bridge_mdb_entry *mp,
+				   struct net_bridge_port_group *pg,
+				   int type)
 {
 	struct nlmsghdr *nlh;
 	struct br_port_msg *bpm;
 	struct nlattr *nest, *nest2;
 
-	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*bpm), 0);
+	nlh = nlmsg_put(skb, 0, 0, type, sizeof(*bpm), 0);
 	if (!nlh)
 		return -EMSGSIZE;
 
@@ -348,7 +349,7 @@ static int nlmsg_populate_mdb_fill(struct sk_buff *skb,
 	if (nest2 == NULL)
 		goto end;
 
-	if (nla_put(skb, MDBA_MDB_ENTRY_INFO, sizeof(*entry), entry))
+	if (__mdb_fill_info(skb, mp, pg))
 		goto end;
 
 	nla_nest_end(skb, nest2);
@@ -363,10 +364,34 @@ static int nlmsg_populate_mdb_fill(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
-static inline size_t rtnl_mdb_nlmsg_size(void)
+static size_t rtnl_mdb_nlmsg_size(struct net_bridge_port_group *pg)
 {
-	return NLMSG_ALIGN(sizeof(struct br_port_msg))
-		+ nla_total_size(sizeof(struct br_mdb_entry));
+	size_t nlmsg_size = NLMSG_ALIGN(sizeof(struct br_port_msg)) +
+			    nla_total_size(sizeof(struct br_mdb_entry)) +
+			    nla_total_size(sizeof(u32));
+
+	if (pg && pg->port->br->multicast_igmp_version == 3 &&
+	    pg->addr.proto == htons(ETH_P_IP)) {
+		struct net_bridge_group_src *ent;
+
+		/* MDBA_MDB_EATTR_GROUP_MODE */
+		nlmsg_size += nla_total_size(sizeof(u8));
+
+		/* MDBA_MDB_EATTR_SRC_LIST nested attr */
+		if (!hlist_empty(&pg->src_list))
+			nlmsg_size += nla_total_size(0);
+
+		hlist_for_each_entry(ent, &pg->src_list, node) {
+			/* MDBA_MDB_SRCLIST_ENTRY nested attr +
+			 * MDBA_MDB_SRCATTR_ADDRESS + MDBA_MDB_SRCATTR_TIMER
+			 */
+			nlmsg_size += nla_total_size(0) +
+				      nla_total_size(sizeof(__be32)) +
+				      nla_total_size(sizeof(u32));
+		}
+	}
+
+	return nlmsg_size;
 }
 
 struct br_mdb_complete_info {
@@ -404,21 +429,22 @@ static void br_mdb_complete(struct net_device *dev, int err, void *priv)
 
 static void br_mdb_switchdev_host_port(struct net_device *dev,
 				       struct net_device *lower_dev,
-				       struct br_mdb_entry *entry, int type)
+				       struct net_bridge_mdb_entry *mp,
+				       int type)
 {
 	struct switchdev_obj_port_mdb mdb = {
 		.obj = {
 			.id = SWITCHDEV_OBJ_ID_HOST_MDB,
 			.flags = SWITCHDEV_F_DEFER,
 		},
-		.vid = entry->vid,
+		.vid = mp->addr.vid,
 	};
 
-	if (entry->addr.proto == htons(ETH_P_IP))
-		ip_eth_mc_map(entry->addr.u.ip4, mdb.addr);
+	if (mp->addr.proto == htons(ETH_P_IP))
+		ip_eth_mc_map(mp->addr.u.ip4, mdb.addr);
 #if IS_ENABLED(CONFIG_IPV6)
 	else
-		ipv6_eth_mc_map(&entry->addr.u.ip6, mdb.addr);
+		ipv6_eth_mc_map(&mp->addr.u.ip6, mdb.addr);
 #endif
 
 	mdb.obj.orig_dev = dev;
@@ -433,17 +459,19 @@ static void br_mdb_switchdev_host_port(struct net_device *dev,
 }
 
 static void br_mdb_switchdev_host(struct net_device *dev,
-				  struct br_mdb_entry *entry, int type)
+				  struct net_bridge_mdb_entry *mp, int type)
 {
 	struct net_device *lower_dev;
 	struct list_head *iter;
 
 	netdev_for_each_lower_dev(dev, lower_dev, iter)
-		br_mdb_switchdev_host_port(dev, lower_dev, entry, type);
+		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
 }
 
-static void __br_mdb_notify(struct net_device *dev, struct net_bridge_port *p,
-			    struct br_mdb_entry *entry, int type)
+void br_mdb_notify(struct net_device *dev,
+		   struct net_bridge_mdb_entry *mp,
+		   struct net_bridge_port_group *pg,
+		   int type)
 {
 	struct br_mdb_complete_info *complete_info;
 	struct switchdev_obj_port_mdb mdb = {
@@ -451,44 +479,45 @@ static void __br_mdb_notify(struct net_device *dev, struct net_bridge_port *p,
 			.id = SWITCHDEV_OBJ_ID_PORT_MDB,
 			.flags = SWITCHDEV_F_DEFER,
 		},
-		.vid = entry->vid,
+		.vid = mp->addr.vid,
 	};
-	struct net_device *port_dev;
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	port_dev = __dev_get_by_index(net, entry->ifindex);
-	if (entry->addr.proto == htons(ETH_P_IP))
-		ip_eth_mc_map(entry->addr.u.ip4, mdb.addr);
+	if (pg) {
+		if (mp->addr.proto == htons(ETH_P_IP))
+			ip_eth_mc_map(mp->addr.u.ip4, mdb.addr);
 #if IS_ENABLED(CONFIG_IPV6)
-	else
-		ipv6_eth_mc_map(&entry->addr.u.ip6, mdb.addr);
+		else
+			ipv6_eth_mc_map(&mp->addr.u.ip6, mdb.addr);
 #endif
-
-	mdb.obj.orig_dev = port_dev;
-	if (p && port_dev && type == RTM_NEWMDB) {
-		complete_info = kmalloc(sizeof(*complete_info), GFP_ATOMIC);
-		if (complete_info) {
-			complete_info->port = p;
-			__mdb_entry_to_br_ip(entry, &complete_info->ip);
+		mdb.obj.orig_dev = pg->port->dev;
+		switch (type) {
+		case RTM_NEWMDB:
+			complete_info = kmalloc(sizeof(*complete_info), GFP_ATOMIC);
+			if (!complete_info)
+				break;
+			complete_info->port = pg->port;
+			complete_info->ip = mp->addr;
 			mdb.obj.complete_priv = complete_info;
 			mdb.obj.complete = br_mdb_complete;
-			if (switchdev_port_obj_add(port_dev, &mdb.obj, NULL))
+			if (switchdev_port_obj_add(pg->port->dev, &mdb.obj, NULL))
 				kfree(complete_info);
+			break;
+		case RTM_DELMDB:
+			switchdev_port_obj_del(pg->port->dev, &mdb.obj);
+			break;
 		}
-	} else if (p && port_dev && type == RTM_DELMDB) {
-		switchdev_port_obj_del(port_dev, &mdb.obj);
+	} else {
+		br_mdb_switchdev_host(dev, mp, type);
 	}
 
-	if (!p)
-		br_mdb_switchdev_host(dev, entry, type);
-
-	skb = nlmsg_new(rtnl_mdb_nlmsg_size(), GFP_ATOMIC);
+	skb = nlmsg_new(rtnl_mdb_nlmsg_size(pg), GFP_ATOMIC);
 	if (!skb)
 		goto errout;
 
-	err = nlmsg_populate_mdb_fill(skb, dev, entry, 0, 0, type, NTF_SELF);
+	err = nlmsg_populate_mdb_fill(skb, dev, mp, pg, type);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto errout;
@@ -500,26 +529,6 @@ static void __br_mdb_notify(struct net_device *dev, struct net_bridge_port *p,
 	rtnl_set_sk_err(net, RTNLGRP_MDB, err);
 }
 
-void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
-		   struct br_ip *group, int type, u8 flags)
-{
-	struct br_mdb_entry entry;
-
-	memset(&entry, 0, sizeof(entry));
-	if (port)
-		entry.ifindex = port->dev->ifindex;
-	else
-		entry.ifindex = dev->ifindex;
-	entry.addr.proto = group->proto;
-	entry.addr.u.ip4 = group->u.ip4;
-#if IS_ENABLED(CONFIG_IPV6)
-	entry.addr.u.ip6 = group->u.ip6;
-#endif
-	entry.vid = group->vid;
-	__mdb_entry_fill_flags(&entry, flags);
-	__br_mdb_notify(dev, port, &entry, type);
-}
-
 static int nlmsg_populate_rtr_fill(struct sk_buff *skb,
 				   struct net_device *dev,
 				   int ifindex, u32 pid,
@@ -688,7 +697,7 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			return -EEXIST;
 
 		br_multicast_host_join(mp, false);
-		__br_mdb_notify(br->dev, NULL, entry, RTM_NEWMDB);
+		br_mdb_notify(br->dev, mp, NULL, RTM_NEWMDB);
 
 		return 0;
 	}
@@ -709,7 +718,7 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	rcu_assign_pointer(*pp, p);
 	if (entry->state == MDB_TEMPORARY)
 		mod_timer(&p->timer, now + br->multicast_membership_interval);
-	__br_mdb_notify(br->dev, port, entry, RTM_NEWMDB);
+	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
 
 	return 0;
 }
@@ -813,7 +822,7 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
 	if (entry->ifindex == mp->br->dev->ifindex && mp->host_joined) {
 		br_multicast_host_leave(mp, false);
 		err = 0;
-		__br_mdb_notify(br->dev, NULL, entry, RTM_DELMDB);
+		br_mdb_notify(br->dev, mp, NULL, RTM_DELMDB);
 		if (!mp->ports && netif_running(br->dev))
 			mod_timer(&mp->timer, jiffies);
 		goto unlock;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 1a910f139ee2..0ec43d549137 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -188,7 +188,7 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 	del_timer(&pg->rexmit_timer);
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
 		br_multicast_del_group_src(ent);
-	br_mdb_notify(br->dev, pg->port, &pg->addr, RTM_DELMDB, pg->flags);
+	br_mdb_notify(br->dev, mp, pg, RTM_DELMDB);
 	kfree_rcu(pg, rcu);
 
 	if (!mp->ports && !mp->host_joined && netif_running(br->dev))
@@ -684,8 +684,7 @@ void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify)
 	if (!mp->host_joined) {
 		mp->host_joined = true;
 		if (notify)
-			br_mdb_notify(mp->br->dev, NULL, &mp->addr,
-				      RTM_NEWMDB, 0);
+			br_mdb_notify(mp->br->dev, mp, NULL, RTM_NEWMDB);
 	}
 	mod_timer(&mp->timer, jiffies + mp->br->multicast_membership_interval);
 }
@@ -697,7 +696,7 @@ void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify)
 
 	mp->host_joined = false;
 	if (notify)
-		br_mdb_notify(mp->br->dev, NULL, &mp->addr, RTM_DELMDB, 0);
+		br_mdb_notify(mp->br->dev, mp, NULL, RTM_DELMDB);
 }
 
 static int br_multicast_add_group(struct net_bridge *br,
@@ -739,10 +738,11 @@ static int br_multicast_add_group(struct net_bridge *br,
 	if (unlikely(!p))
 		goto err;
 	rcu_assign_pointer(*pp, p);
-	br_mdb_notify(br->dev, port, group, RTM_NEWMDB, 0);
+	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
 
 found:
 	mod_timer(&p->timer, now + br->multicast_membership_interval);
+
 out:
 	err = 0;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 34acad4a455a..78822d3a3b7c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -799,8 +799,8 @@ br_multicast_new_port_group(struct net_bridge_port *port, struct br_ip *group,
 			    unsigned char flags, const unsigned char *src);
 int br_mdb_hash_init(struct net_bridge *br);
 void br_mdb_hash_fini(struct net_bridge *br);
-void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
-		   struct br_ip *group, int type, u8 flags);
+void br_mdb_notify(struct net_device *dev, struct net_bridge_mdb_entry *mp,
+		   struct net_bridge_port_group *pg, int type);
 void br_rtr_notify(struct net_device *dev, struct net_bridge_port *port,
 		   int type);
 void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
-- 
2.25.4

