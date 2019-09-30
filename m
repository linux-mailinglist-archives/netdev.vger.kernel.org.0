Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B0CC1E6B
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 11:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbfI3Js3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 05:48:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51947 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730508AbfI3Js2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 05:48:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so12617840wme.1
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 02:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oZuDb5McDLiEf/ynnfag67Rvn7Ia0ArmzZ2CeXeUAqw=;
        b=Isf6OJ9OL8hVGyxB4vAbDevdWjFMOB8rU31W0F72V2S6Rlh9f6fO/LSzFz/GuQCdWs
         9/qxguOOeVCNgc3t+yGOqqAAD5q7BdyZna1AMhcUbovRghW8JW2LeUelM/a33KNU4j4W
         ejeMMxqERkzQ3UyykUsX77tCVejMg7uDM+8PeMk5QK5bSHOcgkDxedgU3oAeSeNSp7MF
         6js27kjV9uBYOdSXzSvVNdqpEehgoxqmlmrZiJIcFDPJ9sNPW+BbpMZ+dV1wQakDm181
         GkWBWnk0BMps1V2vHt7nocF+5udxAatrKVdtnSr/trfE1JbBkmw0bWEltaR1GkW25XNn
         D4Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oZuDb5McDLiEf/ynnfag67Rvn7Ia0ArmzZ2CeXeUAqw=;
        b=NQt4qFHEq6ihWgA5yu4mKq2javGRcW37yKXLkkZoxbcByjHV9/H6Cd/R+nn9uuF03X
         /9x2s913p2rusjNLbdHuGPD7S/MrxsoL1tOIyv7jRpM8F41GbAtISRRT4c4tB5rfCa8h
         AEdWTdU2lmk3LaPnw+tIP1Js6caFCmY0aSnmmvY9IQSx1FNp5oBjjJ8XYfMItNs1lSWc
         8ASIm3NaAqKC35dF5qJboPwWW0VaBYvoRcMDXr+5qWQ7EA+9ttHMNhzCHcPfV/4ab9Rw
         vftelE0hwiVPSYgCQfBH7BHGx/S7nZvj1aJfxWXwiyp0gju8UB3o4uTgiOaDOcJqweJr
         VZeg==
X-Gm-Message-State: APjAAAUkxK2l7ebWTtIxNdhljx6Qw0Up3HvA5Us+Jz/TbU58fKSsi3e9
        6Y1oJ58EA6UuiAy8xVCa0IWirDQ2UZg=
X-Google-Smtp-Source: APXvYqyynO/r8Do0nT615Ftyn3F4GmyuOCrvVTLgGExQ2jBjOrl+lsCsvlTa84AJ1pJDt1XJr9CWKQ==
X-Received: by 2002:a7b:c412:: with SMTP id k18mr16904508wmi.149.1569836903853;
        Mon, 30 Sep 2019 02:48:23 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id q66sm20056519wme.39.2019.09.30.02.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:48:23 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: [patch net-next 2/7] net: introduce name_node struct to be used in hashlist
Date:   Mon, 30 Sep 2019 11:48:15 +0200
Message-Id: <20190930094820.11281-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930094820.11281-1-jiri@resnulli.us>
References: <20190930094820.11281-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce name_node structure to hold name of device and put it into
hashlist instead of putting there struct net_device directly. Add a
necessary infrastructure to manipulate the hashlist. This prepares
the code to use the same hashlist for alternative names introduced
later in this set.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
rfc->v1:
- make char *name const in struct netdev_name_node and in
  netdev_name_node_alloc()
- use INIT_HLIST_NODE in netdev_name_node_alloc() and
  change kzalloc to kmalloc.
- added patch description
---
 include/linux/netdevice.h | 10 +++-
 net/core/dev.c            | 97 +++++++++++++++++++++++++++++++--------
 2 files changed, 87 insertions(+), 20 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9eda1c31d1f7..e92bc5467256 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -925,6 +925,12 @@ struct dev_ifalias {
 struct devlink;
 struct tlsdev_ops;
 
+struct netdev_name_node {
+	struct hlist_node hlist;
+	struct net_device *dev;
+	const char *name;
+};
+
 /*
  * This structure defines the management hooks for network devices.
  * The following hooks can be defined; unless noted otherwise, they are
@@ -1564,7 +1570,7 @@ enum netdev_priv_flags {
  *		(i.e. as seen by users in the "Space.c" file).  It is the name
  *		of the interface.
  *
- *	@name_hlist: 	Device name hash chain, please keep it close to name[]
+ *	@name_node:	Name hashlist node
  *	@ifalias:	SNMP alias
  *	@mem_end:	Shared memory end
  *	@mem_start:	Shared memory start
@@ -1774,7 +1780,7 @@ enum netdev_priv_flags {
 
 struct net_device {
 	char			name[IFNAMSIZ];
-	struct hlist_node	name_hlist;
+	struct netdev_name_node	*name_node;
 	struct dev_ifalias	__rcu *ifalias;
 	/*
 	 *	I/O specific fields
diff --git a/net/core/dev.c b/net/core/dev.c
index bf3ed413abaf..b9088dee0701 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -228,6 +228,67 @@ static inline void rps_unlock(struct softnet_data *sd)
 #endif
 }
 
+static struct netdev_name_node *netdev_name_node_alloc(struct net_device *dev,
+						       const char *name)
+{
+	struct netdev_name_node *name_node;
+
+	name_node = kmalloc(sizeof(*name_node), GFP_KERNEL);
+	if (!name_node)
+		return NULL;
+	INIT_HLIST_NODE(&name_node->hlist);
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
@@ -237,7 +298,7 @@ static void list_netdevice(struct net_device *dev)
 
 	write_lock_bh(&dev_base_lock);
 	list_add_tail_rcu(&dev->dev_list, &net->dev_base_head);
-	hlist_add_head_rcu(&dev->name_hlist, dev_name_hash(net, dev->name));
+	netdev_name_node_add(net, dev->name_node);
 	hlist_add_head_rcu(&dev->index_hlist,
 			   dev_index_hash(net, dev->ifindex));
 	write_unlock_bh(&dev_base_lock);
@@ -255,7 +316,7 @@ static void unlist_netdevice(struct net_device *dev)
 	/* Unlink dev from the device chain */
 	write_lock_bh(&dev_base_lock);
 	list_del_rcu(&dev->dev_list);
-	hlist_del_rcu(&dev->name_hlist);
+	netdev_name_node_del(dev->name_node);
 	hlist_del_rcu(&dev->index_hlist);
 	write_unlock_bh(&dev_base_lock);
 
@@ -733,14 +794,10 @@ EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
 
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
 
@@ -758,14 +815,10 @@ EXPORT_SYMBOL(__dev_get_by_name);
 
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
 
@@ -1232,13 +1285,13 @@ int dev_change_name(struct net_device *dev, const char *newname)
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
@@ -8264,6 +8317,8 @@ static void rollback_registered_many(struct list_head *head)
 		dev_uc_flush(dev);
 		dev_mc_flush(dev);
 
+		netdev_name_node_free(dev->name_node);
+
 		if (dev->netdev_ops->ndo_uninit)
 			dev->netdev_ops->ndo_uninit(dev);
 
@@ -8706,6 +8761,10 @@ int register_netdevice(struct net_device *dev)
 	if (ret < 0)
 		goto out;
 
+	dev->name_node = netdev_name_node_head_alloc(dev);
+	if (!dev->name_node)
+		goto out;
+
 	/* Init, if this function is available */
 	if (dev->netdev_ops->ndo_init) {
 		ret = dev->netdev_ops->ndo_init(dev);
@@ -8827,6 +8886,8 @@ int register_netdevice(struct net_device *dev)
 	return ret;
 
 err_uninit:
+	if (dev->name_node)
+		netdev_name_node_free(dev->name_node);
 	if (dev->netdev_ops->ndo_uninit)
 		dev->netdev_ops->ndo_uninit(dev);
 	if (dev->priv_destructor)
-- 
2.21.0

