Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79081149525
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 12:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgAYLRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 06:17:20 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35471 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgAYLRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 06:17:18 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so2059941wmb.0
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 03:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FZQ0DS424drmpPcRc3Q9TceRcYUqRFbSQpx/meAwqfw=;
        b=EviEP0bmA+WeR4kcljIMV9tvCQSqa/ylZ2eOnWIwsi4hiOXcmYeXaZKzXeDZQWk7IF
         EFoyWDEld0Vr9la+fy6lraUK4TozvuaH7YiF+xS+kX8jNLqM4ql10hao5PX2+ec8JQkd
         7O7JGwUVB9hgODj3ZV/N14Vx3sPXJ1PmYPtkAGxOidupcbeMS9K3/L8uSarIKTYp9esX
         gdhy7DvlCD2er1443xCtVRxkc3aVLjn215ASt1u98bwhbaP7++fGs8qJbQRr0nB3xqu1
         pkYl2unr+dZipb4J5wrddHl7HHV6rPsiQ8adGimgIxMtPX0zekqEqNAz3x0Kik3DMueh
         Jy/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FZQ0DS424drmpPcRc3Q9TceRcYUqRFbSQpx/meAwqfw=;
        b=aj+RruHlDILgf3BzeiMBJ+W1ziPMo0vKuxLDZLtyNAo0nfTEpOYkgPUb9arfHya3rd
         C6pYBWeHpeILyoAhGQgjSbQyrrKjdg2JXbBX4MqPgh3iH0YJDnsBxbBDkPMPwxzU9FCb
         IDpzpy3S5V70u8+fJhahC0wRTOaWJYSdqqySUNNvdfXCqEj338u/OTzJAhwTzmMlKSro
         8z5f7YkLxSDD0XF+Od8b8dlUv3qE86M9Rcx56UIpxP/BvBDXILj4RMIqIe8Uwp8AnKgG
         AAS+ktnk0Nhd5/DT3Zuo75De1nRnUkL3cyBYZLU11dXMmlOawqnSj1E9sRe2sk3sGdEa
         R7ug==
X-Gm-Message-State: APjAAAVmFwEqZ9ARutOy1w2+L5E/4eFzgkPvIr7v7+yT5Iu0Q9Sx/HrZ
        vJ1+xeXkxzJfD9xWGDNsDFfWP2XceuA=
X-Google-Smtp-Source: APXvYqzITHMNh/Zhl8o8doX3O5cn2DqjE+bPVwSeVLABhZFvbnDXw1DUvfGTKJn4NWuAnOxQJMLRRg==
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr4046709wme.130.1579951034962;
        Sat, 25 Jan 2020 03:17:14 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r68sm10011416wmr.43.2020.01.25.03.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 03:17:14 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com
Subject: [patch net-next v2 3/4] net: introduce dev_net notifier register/unregister variants
Date:   Sat, 25 Jan 2020 12:17:08 +0100
Message-Id: <20200125111709.14566-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200125111709.14566-1-jiri@resnulli.us>
References: <20200125111709.14566-1-jiri@resnulli.us>
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
index 5ec3537fbdb1..8c09886d1947 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -938,6 +938,11 @@ struct netdev_name_node {
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
@@ -1792,6 +1797,10 @@ enum netdev_priv_flags {
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
@@ -2084,6 +2093,8 @@ struct net_device {
 	struct lock_class_key	addr_list_lock_key;
 	bool			proto_down;
 	unsigned		wol_enabled:1;
+
+	struct list_head	net_notifier_list;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -2527,6 +2538,12 @@ int unregister_netdevice_notifier(struct notifier_block *nb);
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
index 7e5aa58ce1ea..cf44debb2447 100644
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
@@ -9773,6 +9815,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	INIT_LIST_HEAD(&dev->adj_list.lower);
 	INIT_LIST_HEAD(&dev->ptype_all);
 	INIT_LIST_HEAD(&dev->ptype_specific);
+	INIT_LIST_HEAD(&dev->net_notifier_list);
 #ifdef CONFIG_NET_SCHED
 	hash_init(dev->qdisc_hash);
 #endif
@@ -10036,6 +10079,9 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
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

