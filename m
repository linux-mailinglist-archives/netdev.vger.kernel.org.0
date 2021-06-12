Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796433A4D7A
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 10:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhFLINh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 04:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFLINg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 04:13:36 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E00AC061574
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 01:11:24 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id c9so8416209wrt.5
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 01:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LpDw1ywlkqO/sA3iexzsm4a1dAIYNK1Yt9SF1X9NPZk=;
        b=cKLKpg+pZVwdUi+c4vNgpj84hvDXk1G3iakF8HMDZHv1K+paYCK92WQdCP3dMc1ZzW
         fPk7mMY4RAK1EufgY2W2HqTIftNVYUkLgVZx4l+ezUEt9L1B6UoFhkYBqrggF19GnSjp
         ZHv3/O2HMT9AvRr3+L8sulld/zVvdhyoye0/1nE9olEA9uMkvHIAsLLK1ygCdDbWbfof
         FQANp2xvk7qmT0GCNcze4QR76IF1RECxTVQ0de3U4FvsLPS/cMPYWO4nsKlxY1433qyy
         j0zUvIl5cdhp/sh95/ie97kUKIzjxwgExPlWwuvgwau/T8KGaq0gMu6jSBOMP/8GnyBq
         gW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LpDw1ywlkqO/sA3iexzsm4a1dAIYNK1Yt9SF1X9NPZk=;
        b=oSLh92oW1XXtdt5R2pf7BUWEpfJr0gejBjODT+L0CVj31R2AGl6AOsnxYB+0ldgMoT
         fGwQIDsM4ALXGHZDE/46DvELOAxdCmjj62YJIucojIelKfIn43AiGkW7L4n4xivtnizr
         PoUHSamNvhpMR6mrZaoGIJIOhjsxhQ9g9Qx744vMBY/nM1yAsYzqstbdRdijcLJ9PgU0
         LuN4yPiAwUtrv33YPkzGUGPHSkc6pkD+cvxFvzO9uPn/TMnhVkd1LAMm/nASzZXw+bW3
         4cNrborG6m61momEilAO4PRdAuSRG40hwq14RFvDBJ5m8feEKD4J9pkmET3KwGzOxDvC
         PlQQ==
X-Gm-Message-State: AOAM533oyO070Ti1qHGK8BAjzUUaDM1yi4sukkeau8NGo6elsBj835SW
        MLJYCMUC1I7PYr6VM+bnHK0b8Q==
X-Google-Smtp-Source: ABdhPJyKVDHv8v8ZqUjTjrLdTeLo1G72HE0ApWf6DZWe1RphLQgLXO6/tH4mo272E32BJNe44SLwmw==
X-Received: by 2002:adf:e48c:: with SMTP id i12mr1843306wrm.186.1623485482446;
        Sat, 12 Jun 2021 01:11:22 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id w13sm10619313wrc.31.2021.06.12.01.11.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Jun 2021 01:11:21 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, m.chetan.kumar@intel.com,
        johannes.berg@intel.com, leon@kernel.org, ryazanov.s.a@gmail.com,
        parav@nvidia.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 3/4] wwan: add interface creation support
Date:   Sat, 12 Jun 2021 10:20:56 +0200
Message-Id: <1623486057-13075-4-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623486057-13075-1-git-send-email-loic.poulain@linaro.org>
References: <1623486057-13075-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add support to create (and destroy) interfaces via a new
rtnetlink kind "wwan". The responsible driver has to use
the new wwan_register_ops() to make this possible.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/wwan_core.c | 245 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/wwan.h         |  24 +++++
 include/uapi/linux/wwan.h    |  16 +++
 net/core/rtnetlink.c         |   1 +
 4 files changed, 279 insertions(+), 7 deletions(-)
 create mode 100644 include/uapi/linux/wwan.h

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 45a41ae..7e72804 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -14,6 +14,8 @@
 #include <linux/types.h>
 #include <linux/termios.h>
 #include <linux/wwan.h>
+#include <net/rtnetlink.h>
+#include <uapi/linux/wwan.h>
 
 /* Maximum number of minors in use */
 #define WWAN_MAX_MINORS		(1 << MINORBITS)
@@ -35,10 +37,16 @@ static int wwan_major;
  *
  * @id: WWAN device unique ID.
  * @dev: Underlying device.
+ * @port_id: Current available port ID to pick.
+ * @ops: wwan device ops
+ * @ops_ctxt: context to pass to ops
  */
 struct wwan_device {
 	unsigned int id;
 	struct device dev;
+	atomic_t port_id;
+	const struct wwan_ops *ops;
+	void *ops_ctxt;
 };
 
 /**
@@ -102,7 +110,8 @@ static const struct device_type wwan_dev_type = {
 
 static int wwan_dev_parent_match(struct device *dev, const void *parent)
 {
-	return (dev->type == &wwan_dev_type && dev->parent == parent);
+	return (dev->type == &wwan_dev_type &&
+		(dev->parent == parent || dev == parent));
 }
 
 static struct wwan_device *wwan_dev_get_by_parent(struct device *parent)
@@ -116,6 +125,23 @@ static struct wwan_device *wwan_dev_get_by_parent(struct device *parent)
 	return to_wwan_dev(dev);
 }
 
+static int wwan_dev_name_match(struct device *dev, const void *name)
+{
+	return dev->type == &wwan_dev_type &&
+	       strcmp(dev_name(dev), name) == 0;
+}
+
+static struct wwan_device *wwan_dev_get_by_name(const char *name)
+{
+	struct device *dev;
+
+	dev = class_find_device(wwan_class, NULL, name, wwan_dev_name_match);
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	return to_wwan_dev(dev);
+}
+
 /* This function allocates and registers a new WWAN device OR if a WWAN device
  * already exist for the given parent, it gets a reference and return it.
  * This function is not exported (for now), it is called indirectly via
@@ -180,9 +206,14 @@ static void wwan_remove_dev(struct wwan_device *wwandev)
 	/* WWAN device is created and registered (get+add) along with its first
 	 * child port, and subsequent port registrations only grab a reference
 	 * (get). The WWAN device must then be unregistered (del+put) along with
-	 * its latest port, and reference simply dropped (put) otherwise.
+	 * its last port, and reference simply dropped (put) otherwise. In the
+	 * same fashion, we must not unregister it when the ops are still there.
 	 */
-	ret = device_for_each_child(&wwandev->dev, NULL, is_wwan_child);
+	if (wwandev->ops)
+		ret = 1;
+	else
+		ret = device_for_each_child(&wwandev->dev, NULL, is_wwan_child);
+
 	if (!ret)
 		device_unregister(&wwandev->dev);
 	else
@@ -750,26 +781,226 @@ static const struct file_operations wwan_port_fops = {
 	.llseek = noop_llseek,
 };
 
+/**
+ * wwan_register_ops - register WWAN device ops
+ * @parent: Device to use as parent and shared by all WWAN ports and
+ *	created netdevs
+ * @ops: operations to register
+ * @ctxt: context to pass to operations
+ *
+ * Returns: 0 on success, a negative error code on failure
+ */
+int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
+		      void *ctxt)
+{
+	struct wwan_device *wwandev;
+
+	if (WARN_ON(!parent || !ops))
+		return -EINVAL;
+
+	wwandev = wwan_create_dev(parent);
+	if (!wwandev)
+		return -ENOMEM;
+
+	if (WARN_ON(wwandev->ops)) {
+		wwan_remove_dev(wwandev);
+		return -EBUSY;
+	}
+
+	if (!try_module_get(ops->owner)) {
+		wwan_remove_dev(wwandev);
+		return -ENODEV;
+	}
+
+	wwandev->ops = ops;
+	wwandev->ops_ctxt = ctxt;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(wwan_register_ops);
+
+/**
+ * wwan_unregister_ops - remove WWAN device ops
+ * @parent: Device to use as parent and shared by all WWAN ports and
+ *	created netdevs
+ */
+void wwan_unregister_ops(struct device *parent)
+{
+	struct wwan_device *wwandev = wwan_dev_get_by_parent(parent);
+	bool has_ops;
+
+	if (WARN_ON(IS_ERR(wwandev)))
+		return;
+
+	has_ops = wwandev->ops;
+
+	/* put the reference obtained by wwan_dev_get_by_parent(),
+	 * we should still have one (that the owner is giving back
+	 * now) due to the ops being assigned, check that below
+	 * and return if not.
+	 */
+	put_device(&wwandev->dev);
+
+	if (WARN_ON(!has_ops))
+		return;
+
+	module_put(wwandev->ops->owner);
+
+	wwandev->ops = NULL;
+	wwandev->ops_ctxt = NULL;
+	wwan_remove_dev(wwandev);
+}
+EXPORT_SYMBOL_GPL(wwan_unregister_ops);
+
+static int wwan_rtnl_validate(struct nlattr *tb[], struct nlattr *data[],
+			      struct netlink_ext_ack *extack)
+{
+	if (!data)
+		return -EINVAL;
+
+	if (!tb[IFLA_PARENT_DEV_NAME])
+		return -EINVAL;
+
+	if (!data[IFLA_WWAN_LINK_ID])
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct device_type wwan_type = { .name = "wwan" };
+
+static struct net_device *wwan_rtnl_alloc(struct nlattr *tb[],
+					  const char *ifname,
+					  unsigned char name_assign_type,
+					  unsigned int num_tx_queues,
+					  unsigned int num_rx_queues)
+{
+	const char *devname = nla_data(tb[IFLA_PARENT_DEV_NAME]);
+	struct wwan_device *wwandev = wwan_dev_get_by_name(devname);
+	struct net_device *dev;
+
+	if (IS_ERR(wwandev))
+		return ERR_CAST(wwandev);
+
+	/* only supported if ops were registered (not just ports) */
+	if (!wwandev->ops) {
+		dev = ERR_PTR(-EOPNOTSUPP);
+		goto out;
+	}
+
+	dev = alloc_netdev_mqs(wwandev->ops->priv_size, ifname, name_assign_type,
+			       wwandev->ops->setup, num_tx_queues, num_rx_queues);
+
+	if (dev) {
+		SET_NETDEV_DEV(dev, &wwandev->dev);
+		SET_NETDEV_DEVTYPE(dev, &wwan_type);
+	}
+
+out:
+	/* release the reference */
+	put_device(&wwandev->dev);
+	return dev;
+}
+
+static int wwan_rtnl_newlink(struct net *src_net, struct net_device *dev,
+			     struct nlattr *tb[], struct nlattr *data[],
+			     struct netlink_ext_ack *extack)
+{
+	struct wwan_device *wwandev = wwan_dev_get_by_parent(dev->dev.parent);
+	u32 link_id = nla_get_u32(data[IFLA_WWAN_LINK_ID]);
+	int ret;
+
+	if (IS_ERR(wwandev))
+		return PTR_ERR(wwandev);
+
+	/* shouldn't have a netdev (left) with us as parent so WARN */
+	if (WARN_ON(!wwandev->ops)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (wwandev->ops->newlink)
+		ret = wwandev->ops->newlink(wwandev->ops_ctxt, dev,
+					    link_id, extack);
+	else
+		ret = register_netdevice(dev);
+
+out:
+	/* release the reference */
+	put_device(&wwandev->dev);
+	return ret;
+}
+
+static void wwan_rtnl_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct wwan_device *wwandev = wwan_dev_get_by_parent(dev->dev.parent);
+
+	if (IS_ERR(wwandev))
+		return;
+
+	/* shouldn't have a netdev (left) with us as parent so WARN */
+	if (WARN_ON(!wwandev->ops))
+		goto out;
+
+	if (wwandev->ops->dellink)
+		wwandev->ops->dellink(wwandev->ops_ctxt, dev, head);
+	else
+		unregister_netdevice(dev);
+
+out:
+	/* release the reference */
+	put_device(&wwandev->dev);
+}
+
+static const struct nla_policy wwan_rtnl_policy[IFLA_WWAN_MAX + 1] = {
+	[IFLA_WWAN_LINK_ID] = { .type = NLA_U32 },
+};
+
+static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
+	.kind = "wwan",
+	.maxtype = __IFLA_WWAN_MAX,
+	.alloc = wwan_rtnl_alloc,
+	.validate = wwan_rtnl_validate,
+	.newlink = wwan_rtnl_newlink,
+	.dellink = wwan_rtnl_dellink,
+	.policy = wwan_rtnl_policy,
+};
+
 static int __init wwan_init(void)
 {
+	int err;
+
+	err = rtnl_link_register(&wwan_rtnl_link_ops);
+	if (err)
+		return err;
+
 	wwan_class = class_create(THIS_MODULE, "wwan");
-	if (IS_ERR(wwan_class))
-		return PTR_ERR(wwan_class);
+	if (IS_ERR(wwan_class)) {
+		err = PTR_ERR(wwan_class);
+		goto unregister;
+	}
 
 	/* chrdev used for wwan ports */
 	wwan_major = __register_chrdev(0, 0, WWAN_MAX_MINORS, "wwan_port",
 				       &wwan_port_fops);
 	if (wwan_major < 0) {
-		class_destroy(wwan_class);
-		return wwan_major;
+		err = wwan_major;
+		goto destroy;
 	}
 
 	return 0;
+
+destroy:
+	class_destroy(wwan_class);
+unregister:
+	rtnl_link_unregister(&wwan_rtnl_link_ops);
+	return err;
 }
 
 static void __exit wwan_exit(void)
 {
 	__unregister_chrdev(wwan_major, 0, WWAN_MAX_MINORS, "wwan_port");
+	rtnl_link_unregister(&wwan_rtnl_link_ops);
 	class_destroy(wwan_class);
 }
 
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index fa33cc1..430a3a0 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -7,6 +7,7 @@
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
+#include <linux/netlink.h>
 
 /**
  * enum wwan_port_type - WWAN port types
@@ -116,4 +117,27 @@ void wwan_port_txon(struct wwan_port *port);
  */
 void *wwan_port_get_drvdata(struct wwan_port *port);
 
+/**
+ * struct wwan_ops - WWAN device ops
+ * @owner: module owner of the WWAN ops
+ * @priv_size: size of private netdev data area
+ * @setup: set up a new netdev
+ * @newlink: register the new netdev
+ * @dellink: remove the given netdev
+ */
+struct wwan_ops {
+	struct module *owner;
+	unsigned int priv_size;
+	void (*setup)(struct net_device *dev);
+	int (*newlink)(void *ctxt, struct net_device *dev,
+		       u32 if_id, struct netlink_ext_ack *extack);
+	void (*dellink)(void *ctxt, struct net_device *dev,
+			struct list_head *head);
+};
+
+int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
+		      void *ctxt);
+
+void wwan_unregister_ops(struct device *parent);
+
 #endif /* __WWAN_H */
diff --git a/include/uapi/linux/wwan.h b/include/uapi/linux/wwan.h
new file mode 100644
index 0000000..32a2720
--- /dev/null
+++ b/include/uapi/linux/wwan.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2021 Intel Corporation.
+ */
+#ifndef _UAPI_WWAN_H_
+#define _UAPI_WWAN_H_
+
+enum {
+	IFLA_WWAN_UNSPEC,
+	IFLA_WWAN_LINK_ID, /* u32 */
+
+	__IFLA_WWAN_MAX
+};
+#define IFLA_WWAN_MAX (__IFLA_WWAN_MAX - 1)
+
+#endif /* _UAPI_WWAN_H_ */
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 170e97f..5baa86b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1890,6 +1890,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
+	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
-- 
2.7.4

