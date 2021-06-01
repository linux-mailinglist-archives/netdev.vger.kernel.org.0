Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99C3396E86
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhFAIHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbhFAIH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:07:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECE8C06175F;
        Tue,  1 Jun 2021 01:05:46 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnzPE-000V6C-7j; Tue, 01 Jun 2021 10:05:44 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     m.chetan.kumar@intel.com, loic.poulain@linaro.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 3/4] wwan: add interface creation support
Date:   Tue,  1 Jun 2021 10:05:37 +0200
Message-Id: <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210601080538.71036-1-johannes@sipsolutions.net>
References: <20210601080538.71036-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add support to create (and destroy) interfaces via a new
rtnetlink kind "wwan". The responsible driver has to use
the new wwan_register_ops() to make this possible.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wwan/wwan_core.c | 219 ++++++++++++++++++++++++++++++++++-
 include/linux/wwan.h         |  36 ++++++
 include/uapi/linux/wwan.h    |  17 +++
 3 files changed, 267 insertions(+), 5 deletions(-)
 create mode 100644 include/uapi/linux/wwan.h

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index cff04e532c1e..b1ad78f386bc 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -13,6 +13,8 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/wwan.h>
+#include <net/rtnetlink.h>
+#include <uapi/linux/wwan.h>
 
 #define WWAN_MAX_MINORS 256 /* 256 minors allowed with register_chrdev() */
 
@@ -524,24 +526,231 @@ static const struct file_operations wwan_port_fops = {
 	.llseek = noop_llseek,
 };
 
+struct wwan_dev_reg {
+	struct list_head list;
+	struct device *dev;
+	const struct wwan_ops *ops;
+	void *ctxt;
+};
+
+static DEFINE_MUTEX(wwan_mtx);
+static LIST_HEAD(wwan_devs);
+
+int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
+		      void *ctxt)
+{
+	struct wwan_dev_reg *reg;
+	int ret;
+
+	if (WARN_ON(!parent || !ops))
+		return -EINVAL;
+
+	mutex_lock(&wwan_mtx);
+	list_for_each_entry(reg, &wwan_devs, list) {
+		if (WARN_ON(reg->dev == parent)) {
+			ret = -EBUSY;
+			goto out;
+		}
+	}
+
+	reg = kzalloc(sizeof(*reg), GFP_KERNEL);
+	if (!reg) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	reg->dev = parent;
+	reg->ops = ops;
+	reg->ctxt = ctxt;
+	list_add_tail(&reg->list, &wwan_devs);
+
+	ret = 0;
+
+out:
+	mutex_unlock(&wwan_mtx);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wwan_register_ops);
+
+void wwan_unregister_ops(struct device *parent)
+{
+	struct wwan_dev_reg *tmp;
+
+	mutex_lock(&wwan_mtx);
+	list_for_each_entry(tmp, &wwan_devs, list) {
+		if (tmp->dev == parent) {
+			list_del(&tmp->list);
+			break;
+		}
+	}
+	mutex_unlock(&wwan_mtx);
+}
+EXPORT_SYMBOL_GPL(wwan_unregister_ops);
+
+static struct wwan_dev_reg *wwan_find_by_name(const char *name)
+{
+	struct wwan_dev_reg *tmp;
+
+	lockdep_assert_held(&wwan_mtx);
+
+	list_for_each_entry(tmp, &wwan_devs, list) {
+		if (strcmp(name, dev_name(tmp->dev)) == 0)
+			return tmp;
+	}
+
+	return NULL;
+}
+
+static struct wwan_dev_reg *wwan_find_by_dev(struct device *dev)
+{
+	struct wwan_dev_reg *tmp;
+
+	lockdep_assert_held(&wwan_mtx);
+
+	list_for_each_entry(tmp, &wwan_devs, list) {
+		if (tmp->dev == dev)
+			return tmp;
+	}
+
+	return NULL;
+}
+
+static int wwan_rtnl_validate(struct nlattr *tb[], struct nlattr *data[],
+			      struct netlink_ext_ack *extack)
+{
+	if (!data)
+		return -EINVAL;
+
+	if (!data[IFLA_WWAN_LINK_ID] || !data[IFLA_WWAN_DEV_NAME])
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct device_type wwan_type = { .name = "wwan" };
+
+static struct net_device *wwan_rtnl_alloc(struct nlattr *tb[],
+					  struct nlattr *data[],
+					  const char *ifname,
+					  unsigned char name_assign_type,
+					  unsigned int num_tx_queues,
+					  unsigned int num_rx_queues)
+{
+	const char *devname = nla_data(data[IFLA_WWAN_DEV_NAME]);
+	struct wwan_dev_reg *reg;
+	struct net_device *dev;
+
+	mutex_lock(&wwan_mtx);
+	reg = wwan_find_by_name(devname);
+	if (!reg) {
+		mutex_unlock(&wwan_mtx);
+		return ERR_PTR(-EINVAL);
+	}
+
+	dev = alloc_netdev_mqs(reg->ops->priv_size, ifname, name_assign_type,
+			       reg->ops->setup, num_tx_queues, num_rx_queues);
+
+	mutex_unlock(&wwan_mtx);
+
+	if (dev) {
+		SET_NETDEV_DEV(dev, reg->dev);
+		SET_NETDEV_DEVTYPE(dev, &wwan_type);
+	}
+
+	return dev;
+}
+
+static int wwan_rtnl_newlink(struct net *src_net, struct net_device *dev,
+			     struct nlattr *tb[], struct nlattr *data[],
+			     struct netlink_ext_ack *extack)
+{
+	struct wwan_dev_reg *reg;
+	u32 link_id = nla_get_u32(data[IFLA_WWAN_LINK_ID]);
+	int ret;
+
+	mutex_lock(&wwan_mtx);
+	reg = wwan_find_by_dev(dev->dev.parent);
+	if (!reg) {
+		mutex_unlock(&wwan_mtx);
+		return -EINVAL;
+	}
+
+	if (reg->ops->newlink)
+		ret = reg->ops->newlink(reg->ctxt, dev, link_id, extack);
+	else
+		ret = register_netdevice(dev);
+
+	mutex_unlock(&wwan_mtx);
+
+	return ret;
+}
+
+static void wwan_rtnl_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct wwan_dev_reg *reg;
+
+	mutex_lock(&wwan_mtx);
+	reg = wwan_find_by_dev(dev->dev.parent);
+	if (!reg) {
+		mutex_unlock(&wwan_mtx);
+		return;
+	}
+
+	if (reg->ops->dellink)
+		reg->ops->dellink(reg->ctxt, dev, head);
+	else
+		unregister_netdevice(dev);
+
+	mutex_unlock(&wwan_mtx);
+}
+
+static const struct nla_policy wwan_rtnl_policy[IFLA_WWAN_MAX + 1] = {
+	[IFLA_WWAN_DEV_NAME] = { .type = NLA_NUL_STRING },
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
 	wwan_major = register_chrdev(0, "wwan_port", &wwan_port_fops);
 	if (wwan_major < 0) {
-		class_destroy(wwan_class);
-		return wwan_major;
+		err = wwan_major;
+		goto destroy;
 	}
 
-	return 0;
+	err = 0;
+destroy:
+	class_destroy(wwan_class);
+unregister:
+	rtnl_link_unregister(&wwan_rtnl_link_ops);
+	return err;
 }
 
 static void __exit wwan_exit(void)
 {
+	rtnl_link_unregister(&wwan_rtnl_link_ops);
 	unregister_chrdev(wwan_major, "wwan_port");
 	class_destroy(wwan_class);
 }
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index aa05a253dcf9..d07301962ff7 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -7,6 +7,7 @@
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
+#include <linux/netlink.h>
 
 /**
  * enum wwan_port_type - WWAN port types
@@ -108,4 +109,39 @@ void wwan_port_txon(struct wwan_port *port);
  */
 void *wwan_port_get_drvdata(struct wwan_port *port);
 
+/**
+ * struct wwan_ops - WWAN device ops
+ * @priv_size: size of private netdev data area
+ * @setup: set up a new netdev
+ * @newlink: register the new netdev
+ * @dellink: remove the given netdev
+ */
+struct wwan_ops {
+	unsigned int priv_size;
+	void (*setup)(struct net_device *dev);
+	int (*newlink)(void *ctxt, struct net_device *dev,
+		       u32 if_id, struct netlink_ext_ack *extack);
+	void (*dellink)(void *ctxt, struct net_device *dev,
+			struct list_head *head);
+};
+
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
+		      void *ctxt);
+
+/**
+ * wwan_unregister_ops - remove WWAN device ops
+ * @parent: Device to use as parent and shared by all WWAN ports and
+ *	created netdevs
+ */
+void wwan_unregister_ops(struct device *parent);
+
 #endif /* __WWAN_H */
diff --git a/include/uapi/linux/wwan.h b/include/uapi/linux/wwan.h
new file mode 100644
index 000000000000..a134c823cfbd
--- /dev/null
+++ b/include/uapi/linux/wwan.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2021 Intel Corporation.
+ */
+#ifndef _UAPI_WWAN_H_
+#define _UAPI_WWAN_H_
+
+enum {
+	IFLA_WWAN_UNSPEC,
+	IFLA_WWAN_DEV_NAME, /* nul-string */
+	IFLA_WWAN_LINK_ID, /* u32 */
+
+	__IFLA_WWAN_MAX
+};
+#define IFLA_WWAN_MAX (__IFLA_WWAN_MAX - 1)
+
+#endif /* _UAPI_WWAN_H_ */
-- 
2.31.1

