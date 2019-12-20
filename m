Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAF7127B23
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 13:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfLTMfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 07:35:51 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38194 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbfLTMft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 07:35:49 -0500
Received: by mail-wm1-f65.google.com with SMTP id u2so9067366wmc.3
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 04:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=erNEewc8qlUNJVuhRmSA4cJLKXHwB1yz6PHvJQZj8fs=;
        b=FpDBN2OG/jFeZsOGHVyXMPK1K7A1xTfFtfKglXrp50i2JDqWboAi5ua5Aq1G7kguEh
         K+xSQF5YSTQVYpYqpu2l0rDkrUhcTbdhWyBH5m8/g8bHI4OhMXCRNYsSaRt6kGUXsraI
         qdFj0SLQgXNJ2neNgoex0RjzNFPCPclLtX0rd9riXYtN/EDk8KVEB7PYEOT82GJuS7zA
         6tiXIFokjaWAUo4AYOC7oqh/DwFDIO2c3H8fa8Epm1oupKvkznbz4ViurXyplz+Xn+a7
         Wm6o5jGN4+DoH8bBpRyXfRoVBktEJYbZgWCmWTRLF23QoPVNXhrjh4XkrKU0nShhajWp
         8LNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=erNEewc8qlUNJVuhRmSA4cJLKXHwB1yz6PHvJQZj8fs=;
        b=uNsgDNJHBasY8FNU00TmOxqqI8HAOQMA5WN4A8WYjiYD+EzNUKxh4XsKQowwHHcrP1
         4DZROI/HMhTqU6TvR37BEVP8Ko2zyixvnp9L96tbvWU6Tc85zJtsmtG6J0AnXX5RNHJR
         OYj0EMxALf6pY//0qNsHNKFOzmib8IWLx/GwHIYSFFY/DY4BDgoTVEliZmGw9ctJhAz2
         55xvjKxhMQrcEKkjZO6sbIryFhraoRYIzYhin1V5hGL5xayCtq9+OnyGLHccKT7+If0o
         if5p9XD6//db5p32BVF2FP2nYL2i5hI9b100brbOg/KFBEesX9zPhDisx3rHYyEQroW4
         vxuQ==
X-Gm-Message-State: APjAAAWXW1bNZYf6MWEkDuSiG+lNB0QZO0ZHTzSSv++5h3860BihCgRv
        KqrWF7scGb4g9jQuG7Cz8WNuLlV7HSU=
X-Google-Smtp-Source: APXvYqx462XrXYOUbS/uIMGv2ShOCXR4TFbV3EQxmu4+h6JhEBM1vsemTeJydoAHVgJK0mLxg1bUaA==
X-Received: by 2002:a1c:a406:: with SMTP id n6mr16086143wme.40.1576845346954;
        Fri, 20 Dec 2019 04:35:46 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id s1sm9656076wmc.23.2019.12.20.04.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 04:35:46 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next 3/4] net: introduce dev_net notifier register/unregister variants
Date:   Fri, 20 Dec 2019 13:35:41 +0100
Message-Id: <20191220123542.26315-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220123542.26315-1-jiri@resnulli.us>
References: <20191220123542.26315-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce dev_net variants of netdev notifier register/unregister functions
and allow per-net notifier to follow the netdevice into the namespace it is
moved to.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/linux/netdevice.h | 17 +++++++++++++++
 net/core/dev.c            | 46 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7a8ed11f5d45..89ccd4c8d9ea 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -937,6 +937,11 @@ struct netdev_name_node {
 int netdev_name_node_alt_create(struct net_device *dev, const char *name);
 int netdev_name_node_alt_destroy(struct net_device *dev, const char *name);
 
+struct netdev_net_notifier {
+	struct list_head list;
+	struct notifier_block *nb;
+};
+
 /*
  * This structure defines the management hooks for network devices.
  * The following hooks can be defined; unless noted otherwise, they are
@@ -1790,6 +1795,10 @@ enum netdev_priv_flags {
  *
  *	@wol_enabled:	Wake-on-LAN is enabled
  *
+ *	@net_notifier_list:	List of per-net netdev notifier block
+ *				that follow this device when it is moved
+ *				to another network namespace.
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
@@ -2080,6 +2089,8 @@ struct net_device {
 	struct lock_class_key	addr_list_lock_key;
 	bool			proto_down;
 	unsigned		wol_enabled:1;
+
+	struct list_head	net_notifier_list;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -2523,6 +2534,12 @@ int unregister_netdevice_notifier(struct notifier_block *nb);
 int register_netdevice_notifier_net(struct net *net, struct notifier_block *nb);
 int unregister_netdevice_notifier_net(struct net *net,
 				      struct notifier_block *nb);
+int register_netdevice_notifier_dev_net(struct net_device *dev,
+					struct notifier_block *nb,
+					struct netdev_net_notifier *nn);
+int unregister_netdevice_notifier_dev_net(struct net_device *dev,
+					  struct notifier_block *nb,
+					  struct netdev_net_notifier *nn);
 
 struct netdev_notifier_info {
 	struct net_device	*dev;
diff --git a/net/core/dev.c b/net/core/dev.c
index 932ee131c8c9..f59d2116db8d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1874,6 +1874,48 @@ int unregister_netdevice_notifier_net(struct net *net,
 }
 EXPORT_SYMBOL(unregister_netdevice_notifier_net);
 
+int register_netdevice_notifier_dev_net(struct net_device *dev,
+					struct notifier_block *nb,
+					struct netdev_net_notifier *nn)
+{
+	int err;
+
+	rtnl_lock();
+	err = __register_netdevice_notifier_net(dev_net(dev), nb, false);
+	if (!err) {
+		nn->nb = nb;
+		list_add(&nn->list, &dev->net_notifier_list);
+	}
+	rtnl_unlock();
+	return err;
+}
+EXPORT_SYMBOL(register_netdevice_notifier_dev_net);
+
+int unregister_netdevice_notifier_dev_net(struct net_device *dev,
+					  struct notifier_block *nb,
+					  struct netdev_net_notifier *nn)
+{
+	int err;
+
+	rtnl_lock();
+	list_del(&nn->list);
+	err = __unregister_netdevice_notifier_net(dev_net(dev), nb);
+	rtnl_unlock();
+	return err;
+}
+EXPORT_SYMBOL(unregister_netdevice_notifier_dev_net);
+
+static void move_netdevice_notifiers_dev_net(struct net_device *dev,
+					     struct net *net)
+{
+	struct netdev_net_notifier *nn;
+
+	list_for_each_entry(nn, &dev->net_notifier_list, list) {
+		__unregister_netdevice_notifier_net(dev_net(dev), nn->nb);
+		__register_netdevice_notifier_net(net, nn->nb, true);
+	}
+}
+
 /**
  *	call_netdevice_notifiers_info - call all network notifier blocks
  *	@val: value passed unmodified to notifier function
@@ -9770,6 +9812,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	INIT_LIST_HEAD(&dev->adj_list.lower);
 	INIT_LIST_HEAD(&dev->ptype_all);
 	INIT_LIST_HEAD(&dev->ptype_specific);
+	INIT_LIST_HEAD(&dev->net_notifier_list);
 #ifdef CONFIG_NET_SCHED
 	hash_init(dev->qdisc_hash);
 #endif
@@ -10031,6 +10074,9 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	kobject_uevent(&dev->dev.kobj, KOBJ_REMOVE);
 	netdev_adjacent_del_links(dev);
 
+	/* Move per-net netdevice notifiers that are following the netdevice */
+	move_netdevice_notifiers_dev_net(dev, net);
+
 	/* Actually switch the network namespace */
 	dev_net_set(dev, net);
 	dev->ifindex = new_ifindex;
-- 
2.21.0

