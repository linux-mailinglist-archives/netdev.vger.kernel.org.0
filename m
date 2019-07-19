Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9209E6E49C
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 13:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfGSLAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 07:00:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33962 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfGSLAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 07:00:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so23469483wmd.1
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 04:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p99w0BBTMUDKLq7M+PHtpd6CWrdpcjy1bhE6Hexmt70=;
        b=yGhgmnLLK7i/q6mVfSd31W6I2cqSjSyrXTEGJLOj6lvi+fRBRA0NiFIIP5FsFyaF8O
         3u9YIyl58Cf1JFR5aNHD3FIxPRdSU5Wn/PtzkHPNTrF6gnpBJwqNyUJ3Z+MUMM1Uqok0
         3IxJvBm5o9gJ6apRKGPBSH079Le2+pzThj4rZf25ZRX9BxE6ArasSLIOR0XlWMLPQ8bC
         WUCc395IdumA7pGOpX+I2FInffTxUapc8dYKt9MF6MQjrZ+0RfGPDUzvrXU9IxQ6Jj5f
         ELgj/vy6V58gxmf7PwYA2rdCl7ZEolS/g8mM0fTmIJjZhlwHcy5ObxILBCx5epNHefIt
         P/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p99w0BBTMUDKLq7M+PHtpd6CWrdpcjy1bhE6Hexmt70=;
        b=sALs2cG1WVVQSNB0xhoqZGKCOKEoZf+XLl58+YGkgWbx9OnwtuJ9wTbh4TTl+zWJHi
         +wpgZ/sxc4oFqu0U9fkhsPBpg+2sPhJVlIEDVLFYG1luOnSL27py9Zi7tHoISw1WaUOW
         r01lJkmAzk3btsKfHs87QsmZcSgVe+mHyZOUJ9tCgyjWrdv2fJPByk2DKoE38QGcLZjf
         pVJ+44PhKUHB+P30jrO9qjeoDIxo5VHF3usI//Ppjf7pd30Clu4/JLRGAtoham4HI0XD
         zQqXbaW7et1jFmaw6C5kTF7bVA4FV/iS5+317ALdeHo7Iew3NW9OiE80n7r5bwfn2MJx
         k9Wg==
X-Gm-Message-State: APjAAAUZNPFfiyPb5bklPnJbEDGMZJX7WoW8hklljVqzljYdrtLWXOpM
        dzjwUjJc/PONcNEIYgkB+P4RtIea
X-Google-Smtp-Source: APXvYqyiIwNh8q9W+X09J0tViNi3MbJODK14FPhhJ7sQF67lSpwTbZLuh5L81bm8YRhlAgI7zj27EQ==
X-Received: by 2002:a05:600c:1008:: with SMTP id c8mr48196518wmc.133.1563534032614;
        Fri, 19 Jul 2019 04:00:32 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id t1sm41873450wra.74.2019.07.19.04.00.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 04:00:32 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next rfc 2/7] net: introduce name_node struct to be used in hashlist
Date:   Fri, 19 Jul 2019 13:00:24 +0200
Message-Id: <20190719110029.29466-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719110029.29466-1-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/linux/netdevice.h | 10 +++-
 net/core/dev.c            | 96 +++++++++++++++++++++++++++++++--------
 2 files changed, 86 insertions(+), 20 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 88292953aa6f..74f99f127b0e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -918,6 +918,12 @@ struct dev_ifalias {
 struct devlink;
 struct tlsdev_ops;
 
+struct netdev_name_node {
+	struct hlist_node hlist;
+	struct net_device *dev;
+	char *name;
+};
+
 /*
  * This structure defines the management hooks for network devices.
  * The following hooks can be defined; unless noted otherwise, they are
@@ -1551,7 +1557,7 @@ enum netdev_priv_flags {
  *		(i.e. as seen by users in the "Space.c" file).  It is the name
  *		of the interface.
  *
- *	@name_hlist: 	Device name hash chain, please keep it close to name[]
+ *	@name_node:	Name hashlist node
  *	@ifalias:	SNMP alias
  *	@mem_end:	Shared memory end
  *	@mem_start:	Shared memory start
@@ -1761,7 +1767,7 @@ enum netdev_priv_flags {
 
 struct net_device {
 	char			name[IFNAMSIZ];
-	struct hlist_node	name_hlist;
+	struct netdev_name_node	*name_node;
 	struct dev_ifalias	__rcu *ifalias;
 	/*
 	 *	I/O specific fields
diff --git a/net/core/dev.c b/net/core/dev.c
index fc676b2610e3..ad0d42fbdeee 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -228,6 +228,66 @@ static inline void rps_unlock(struct softnet_data *sd)
 #endif
 }
 
+static struct netdev_name_node *netdev_name_node_alloc(struct net_device *dev,
+						       char *name)
+{
+	struct netdev_name_node *name_node;
+
+	name_node = kzalloc(sizeof(*name_node), GFP_KERNEL);
+	if (!name_node)
+		return NULL;
+	name_node->dev = dev;
+	name_node->name = name;
+	return name_node;
+}
+
+static struct netdev_name_node *
+netdev_name_node_head_alloc(struct net_device *dev)
+{
+	return netdev_name_node_alloc(dev, dev->name);
+}
+
+static void netdev_name_node_free(struct netdev_name_node *name_node)
+{
+	kfree(name_node);
+}
+
+static void netdev_name_node_add(struct net *net,
+				 struct netdev_name_node *name_node)
+{
+	hlist_add_head_rcu(&name_node->hlist,
+			   dev_name_hash(net, name_node->name));
+}
+
+static void netdev_name_node_del(struct netdev_name_node *name_node)
+{
+	hlist_del_rcu(&name_node->hlist);
+}
+
+static struct netdev_name_node *netdev_name_node_lookup(struct net *net,
+							const char *name)
+{
+	struct hlist_head *head = dev_name_hash(net, name);
+	struct netdev_name_node *name_node;
+
+	hlist_for_each_entry(name_node, head, hlist)
+		if (!strcmp(name_node->name, name))
+			return name_node;
+	return NULL;
+}
+
+static struct netdev_name_node *netdev_name_node_lookup_rcu(struct net *net,
+							    const char *name)
+{
+	struct hlist_head *head = dev_name_hash(net, name);
+	struct netdev_name_node *name_node;
+
+	hlist_for_each_entry_rcu(name_node, head, hlist)
+		if (!strcmp(name_node->name, name))
+			return name_node;
+	return NULL;
+}
+
 /* Device list insertion */
 static void list_netdevice(struct net_device *dev)
 {
@@ -237,7 +297,7 @@ static void list_netdevice(struct net_device *dev)
 
 	write_lock_bh(&dev_base_lock);
 	list_add_tail_rcu(&dev->dev_list, &net->dev_base_head);
-	hlist_add_head_rcu(&dev->name_hlist, dev_name_hash(net, dev->name));
+	netdev_name_node_add(net, dev->name_node);
 	hlist_add_head_rcu(&dev->index_hlist,
 			   dev_index_hash(net, dev->ifindex));
 	write_unlock_bh(&dev_base_lock);
@@ -255,7 +315,7 @@ static void unlist_netdevice(struct net_device *dev)
 	/* Unlink dev from the device chain */
 	write_lock_bh(&dev_base_lock);
 	list_del_rcu(&dev->dev_list);
-	hlist_del_rcu(&dev->name_hlist);
+	netdev_name_node_del(dev->name_node);
 	hlist_del_rcu(&dev->index_hlist);
 	write_unlock_bh(&dev_base_lock);
 
@@ -733,14 +793,10 @@ EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
 
 struct net_device *__dev_get_by_name(struct net *net, const char *name)
 {
-	struct net_device *dev;
-	struct hlist_head *head = dev_name_hash(net, name);
+	struct netdev_name_node *node_name;
 
-	hlist_for_each_entry(dev, head, name_hlist)
-		if (!strncmp(dev->name, name, IFNAMSIZ))
-			return dev;
-
-	return NULL;
+	node_name = netdev_name_node_lookup(net, name);
+	return node_name ? node_name->dev : NULL;
 }
 EXPORT_SYMBOL(__dev_get_by_name);
 
@@ -758,14 +814,10 @@ EXPORT_SYMBOL(__dev_get_by_name);
 
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name)
 {
-	struct net_device *dev;
-	struct hlist_head *head = dev_name_hash(net, name);
-
-	hlist_for_each_entry_rcu(dev, head, name_hlist)
-		if (!strncmp(dev->name, name, IFNAMSIZ))
-			return dev;
+	struct netdev_name_node *node_name;
 
-	return NULL;
+	node_name = netdev_name_node_lookup_rcu(net, name);
+	return node_name ? node_name->dev : NULL;
 }
 EXPORT_SYMBOL(dev_get_by_name_rcu);
 
@@ -1232,13 +1284,13 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	netdev_adjacent_rename_links(dev, oldname);
 
 	write_lock_bh(&dev_base_lock);
-	hlist_del_rcu(&dev->name_hlist);
+	netdev_name_node_del(dev->name_node);
 	write_unlock_bh(&dev_base_lock);
 
 	synchronize_rcu();
 
 	write_lock_bh(&dev_base_lock);
-	hlist_add_head_rcu(&dev->name_hlist, dev_name_hash(net, dev->name));
+	netdev_name_node_add(net, dev->name_node);
 	write_unlock_bh(&dev_base_lock);
 
 	ret = call_netdevice_notifiers(NETDEV_CHANGENAME, dev);
@@ -8206,6 +8258,8 @@ static void rollback_registered_many(struct list_head *head)
 		dev_uc_flush(dev);
 		dev_mc_flush(dev);
 
+		netdev_name_node_free(dev->name_node);
+
 		if (dev->netdev_ops->ndo_uninit)
 			dev->netdev_ops->ndo_uninit(dev);
 
@@ -8648,6 +8702,10 @@ int register_netdevice(struct net_device *dev)
 	if (ret < 0)
 		goto out;
 
+	dev->name_node = netdev_name_node_head_alloc(dev);
+	if (!dev->name_node)
+		goto out;
+
 	/* Init, if this function is available */
 	if (dev->netdev_ops->ndo_init) {
 		ret = dev->netdev_ops->ndo_init(dev);
@@ -8767,6 +8825,8 @@ int register_netdevice(struct net_device *dev)
 	return ret;
 
 err_uninit:
+	if (dev->name_node)
+		netdev_name_node_free(dev->name_node);
 	if (dev->netdev_ops->ndo_uninit)
 		dev->netdev_ops->ndo_uninit(dev);
 	if (dev->priv_destructor)
-- 
2.21.0

