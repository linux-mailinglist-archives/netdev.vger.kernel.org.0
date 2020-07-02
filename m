Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D72211E32
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgGBIW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:22:57 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:55256 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728436AbgGBIWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:22:54 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628Mf2X042283;
        Thu, 2 Jul 2020 03:22:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678161;
        bh=1qzLaSMoiyDzc/yo3NiznOfrfn9/79kRBidf51KJ/xI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=AoUMUelOmFc5FPX9IU+fY6fjWX3sgrqH1xuDnj8KojzU6hdjZidfBzI6cD5FkVdjU
         Ke05qNugUzId+5+HcudcK8PJh8VDYAmJBW4JE+Xuz7Xq/L2kSgdfSUGjGB1F6TDFQn
         FwGXsclS9ET5atdfPLjYMPSlVCutKefYklblq5R0=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628Mfc5065436
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:22:41 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:22:41 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:22:41 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYL006145;
        Thu, 2 Jul 2020 03:22:36 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 09/22] rpmsg: Introduce configfs entry for configuring rpmsg
Date:   Thu, 2 Jul 2020 13:51:30 +0530
Message-ID: <20200702082143.25259-10-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a configfs entry for each "struct rpmsg_device_id" populated
in rpmsg client driver and create a configfs entry for each rpmsg
device. This will be used to bind a rpmsg client driver to a rpmsg
device in order to create a new rpmsg channel.

This is used for creating channel for VHOST based rpmsg bus (channels
are created in VIRTIO based bus during namespace announcement).

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/rpmsg/Makefile         |   2 +-
 drivers/rpmsg/rpmsg_cfs.c      | 394 +++++++++++++++++++++++++++++++++
 drivers/rpmsg/rpmsg_core.c     |   7 +
 drivers/rpmsg/rpmsg_internal.h |  16 ++
 include/linux/rpmsg.h          |   5 +
 5 files changed, 423 insertions(+), 1 deletion(-)
 create mode 100644 drivers/rpmsg/rpmsg_cfs.c

diff --git a/drivers/rpmsg/Makefile b/drivers/rpmsg/Makefile
index ae92a7fb08f6..047acfda518a 100644
--- a/drivers/rpmsg/Makefile
+++ b/drivers/rpmsg/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_RPMSG)		+= rpmsg_core.o
+obj-$(CONFIG_RPMSG)		+= rpmsg_core.o rpmsg_cfs.o
 obj-$(CONFIG_RPMSG_CHAR)	+= rpmsg_char.o
 obj-$(CONFIG_RPMSG_MTK_SCP)	+= mtk_rpmsg.o
 obj-$(CONFIG_RPMSG_QCOM_GLINK_RPM) += qcom_glink_rpm.o
diff --git a/drivers/rpmsg/rpmsg_cfs.c b/drivers/rpmsg/rpmsg_cfs.c
new file mode 100644
index 000000000000..a5c77aba00ee
--- /dev/null
+++ b/drivers/rpmsg/rpmsg_cfs.c
@@ -0,0 +1,394 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * configfs to configure RPMSG
+ *
+ * Copyright (C) 2020 Texas Instruments
+ * Author: Kishon Vijay Abraham I <kishon@ti.com>
+ */
+
+#include <linux/configfs.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/idr.h>
+#include <linux/slab.h>
+
+#include "rpmsg_internal.h"
+
+static struct config_group *channel_group;
+static struct config_group *virtproc_group;
+
+enum rpmsg_channel_status {
+	STATUS_FREE,
+	STATUS_BUSY,
+};
+
+struct rpmsg_channel {
+	struct config_item item;
+	struct device *dev;
+	enum rpmsg_channel_status status;
+};
+
+struct rpmsg_channel_group {
+	struct config_group group;
+};
+
+struct rpmsg_virtproc_group {
+	struct config_group group;
+	struct device *dev;
+	const struct rpmsg_virtproc_ops *ops;
+};
+
+static inline
+struct rpmsg_channel *to_rpmsg_channel(struct config_item *channel_item)
+{
+	return container_of(channel_item, struct rpmsg_channel, item);
+}
+
+static inline struct rpmsg_channel_group
+*to_rpmsg_channel_group(struct config_group *channel_group)
+{
+	return container_of(channel_group, struct rpmsg_channel_group, group);
+}
+
+static inline
+struct rpmsg_virtproc_group *to_rpmsg_virtproc_group(struct config_item *item)
+{
+	return container_of(to_config_group(item), struct rpmsg_virtproc_group,
+			    group);
+}
+
+/**
+ * rpmsg_virtproc_channel_link() - Create softlink of rpmsg client device
+ *   directory to virtproc configfs directory
+ * @virtproc_item: Config item representing configfs entry of virtual remote
+ *   processor
+ * @channel_item: Config item representing configfs entry of rpmsg client
+ *   driver
+ *
+ * Bind rpmsg client device to virtual remote processor by creating softlink
+ * between rpmsg client device directory to virtproc configfs directory
+ * in order to create a new rpmsg channel.
+ */
+static int rpmsg_virtproc_channel_link(struct config_item *virtproc_item,
+				       struct config_item *channel_item)
+{
+	struct rpmsg_virtproc_group *vgroup;
+	struct rpmsg_channel *channel;
+	struct config_group *cgroup;
+	struct device *dev;
+
+	vgroup = to_rpmsg_virtproc_group(virtproc_item);
+	channel = to_rpmsg_channel(channel_item);
+
+	if (channel->status == STATUS_BUSY)
+		return -EBUSY;
+
+	cgroup = channel_item->ci_group;
+
+	if (vgroup->ops && vgroup->ops->create_channel) {
+		dev = vgroup->ops->create_channel(vgroup->dev,
+						  cgroup->cg_item.ci_name);
+		if (IS_ERR_OR_NULL(dev))
+			return PTR_ERR(dev);
+	}
+
+	channel->dev = dev;
+	channel->status = STATUS_BUSY;
+
+	return 0;
+}
+
+/**
+ * rpmsg_virtproc_channel_unlink() - Remove softlink of rpmsg client device
+ *   directory from virtproc configfs directory
+ * @virtproc_item: Config item representing configfs entry of virtual remote
+ *   processor
+ * @channel_item: Config item representing configfs entry of rpmsg client
+ *   driver
+ *
+ * Unbind rpmsg client device from virtual remote processor by removing softlink
+ * of rpmsg client device directory from virtproc configfs directory which
+ * deletes the rpmsg channel.
+ */
+static void rpmsg_virtproc_channel_unlink(struct config_item *virtproc_item,
+					  struct config_item *channel_item)
+{
+	struct rpmsg_virtproc_group *vgroup;
+	struct rpmsg_channel *channel;
+
+	channel = to_rpmsg_channel(channel_item);
+	vgroup = to_rpmsg_virtproc_group(virtproc_item);
+
+	if (vgroup->ops && vgroup->ops->delete_channel)
+		vgroup->ops->delete_channel(channel->dev);
+
+	channel->status = STATUS_FREE;
+}
+
+static struct configfs_item_operations rpmsg_virtproc_item_ops = {
+	.allow_link	= rpmsg_virtproc_channel_link,
+	.drop_link	= rpmsg_virtproc_channel_unlink,
+};
+
+static const struct config_item_type rpmsg_virtproc_item_type = {
+	.ct_item_ops	= &rpmsg_virtproc_item_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+/**
+ * rpmsg_cfs_add_virtproc_group() - Add new configfs directory for virtproc
+ *   device
+ * @dev: Device representing the virtual remote processor
+ * @ops: rpmsg_virtproc_ops to create or delete rpmsg channel
+ *
+ * Add new configfs directory for virtproc device. The rpmsg client driver's
+ * configfs entry can be linked with this directory for creating a new
+ * rpmsg channel and the link can be removed for deleting the rpmsg channel.
+ */
+struct config_group *
+rpmsg_cfs_add_virtproc_group(struct device *dev,
+			     const struct rpmsg_virtproc_ops *ops)
+{
+	struct rpmsg_virtproc_group *vgroup;
+	struct config_group *group;
+	struct device *vdev;
+	int ret;
+
+	vgroup = kzalloc(sizeof(*vgroup), GFP_KERNEL);
+	if (!vgroup)
+		return ERR_PTR(-ENOMEM);
+
+	group = &vgroup->group;
+	config_group_init_type_name(group, dev_name(dev),
+				    &rpmsg_virtproc_item_type);
+	ret = configfs_register_group(virtproc_group, group);
+	if (ret)
+		goto err_register_group;
+
+	if (!try_module_get(ops->owner)) {
+		ret = -EPROBE_DEFER;
+		goto err_module_get;
+	}
+
+	vdev = get_device(dev);
+	vgroup->dev = vdev;
+	vgroup->ops = ops;
+
+	return group;
+
+err_module_get:
+	configfs_unregister_group(group);
+
+err_register_group:
+	kfree(vgroup);
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(rpmsg_cfs_add_virtproc_group);
+
+/**
+ * rpmsg_cfs_remove_virtproc_group() - Remove the configfs directory for
+ *   virtproc device
+ * @group: config_group of the virtproc device
+ *
+ * Remove the configfs directory for virtproc device.
+ */
+void rpmsg_cfs_remove_virtproc_group(struct config_group *group)
+{
+	struct rpmsg_virtproc_group *vgroup;
+
+	if (!group)
+		return;
+
+	vgroup = container_of(group, struct rpmsg_virtproc_group, group);
+	put_device(vgroup->dev);
+	module_put(vgroup->ops->owner);
+	configfs_unregister_group(&vgroup->group);
+	kfree(vgroup);
+}
+EXPORT_SYMBOL(rpmsg_cfs_remove_virtproc_group);
+
+static const struct config_item_type rpmsg_channel_item_type = {
+	.ct_owner	= THIS_MODULE,
+};
+
+/**
+ * rpmsg_channel_make() - Allow user to create sub-directory of rpmsg client
+ *   driver
+ * @name: Name of the sub-directory created by the user.
+ *
+ * Invoked when user creates a sub-directory to the configfs directory
+ * representing the rpmsg client driver. This can be linked with the virtproc
+ * directory for creating a new rpmsg channel.
+ */
+static struct config_item *
+rpmsg_channel_make(struct config_group *group, const char *name)
+{
+	struct rpmsg_channel *channel;
+
+	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
+	if (!channel)
+		return ERR_PTR(-ENOMEM);
+
+	channel->status = STATUS_FREE;
+
+	config_item_init_type_name(&channel->item, name, &rpmsg_channel_item_type);
+	return &channel->item;
+}
+
+/**
+ * rpmsg_channel_drop() - Allow user to delete sub-directory of rpmsg client
+ *   driver
+ * @item: Config item representing the sub-directory the user created returned
+ *   by rpmsg_channel_make()
+ *
+ * Invoked when user creates a sub-directory to the configfs directory
+ * representing the rpmsg client driver. This can be linked with the virtproc
+ * directory for creating a new rpmsg channel.
+ */
+static void rpmsg_channel_drop(struct config_group *group, struct config_item *item)
+{
+	struct rpmsg_channel *channel;
+
+	channel = to_rpmsg_channel(item);
+	kfree(channel);
+}
+
+static struct configfs_group_operations rpmsg_channel_group_ops = {
+	.make_item     = &rpmsg_channel_make,
+	.drop_item      = &rpmsg_channel_drop,
+};
+
+static const struct config_item_type rpmsg_channel_group_type = {
+	.ct_group_ops	= &rpmsg_channel_group_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+/**
+ * rpmsg_cfs_add_channel_group() - Create a configfs directory for each
+ *   registered rpmsg client driver
+ * @name: The name of the rpmsg client driver
+ *
+ * Create a configfs directory for each registered rpmsg client driver. The
+ * user can create sub-directory within this directory for creating
+ * rpmsg channels to be used by the rpmsg client driver.
+ */
+struct config_group *rpmsg_cfs_add_channel_group(const char *name)
+{
+	struct rpmsg_channel_group *cgroup;
+	struct config_group *group;
+	int ret;
+
+	cgroup = kzalloc(sizeof(*cgroup), GFP_KERNEL);
+	if (!cgroup)
+		return ERR_PTR(-ENOMEM);
+
+	group = &cgroup->group;
+	config_group_init_type_name(group, name, &rpmsg_channel_group_type);
+	ret = configfs_register_group(channel_group, group);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return group;
+}
+EXPORT_SYMBOL(rpmsg_cfs_add_channel_group);
+
+/**
+ * rpmsg_cfs_remove_channel_group() - Remove the configfs directory associated
+ *   with the rpmsg client driver
+ * @group: Config group representing the rpmsg client driver
+ *
+ * Remove the configfs directory associated with the rpmsg client driver.
+ */
+void rpmsg_cfs_remove_channel_group(struct config_group *group)
+{
+	struct rpmsg_channel_group *cgroup;
+
+	if (IS_ERR_OR_NULL(group))
+		return;
+
+	cgroup = to_rpmsg_channel_group(group);
+	configfs_unregister_default_group(group);
+	kfree(cgroup);
+}
+EXPORT_SYMBOL(rpmsg_cfs_remove_channel_group);
+
+static const struct config_item_type rpmsg_channel_type = {
+	.ct_owner	= THIS_MODULE,
+};
+
+static const struct config_item_type rpmsg_virtproc_type = {
+	.ct_owner	= THIS_MODULE,
+};
+
+static const struct config_item_type rpmsg_type = {
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct configfs_subsystem rpmsg_cfs_subsys = {
+	.su_group = {
+		.cg_item = {
+			.ci_namebuf = "rpmsg",
+			.ci_type = &rpmsg_type,
+		},
+	},
+	.su_mutex = __MUTEX_INITIALIZER(rpmsg_cfs_subsys.su_mutex),
+};
+
+static int __init rpmsg_cfs_init(void)
+{
+	int ret;
+	struct config_group *root = &rpmsg_cfs_subsys.su_group;
+
+	config_group_init(root);
+
+	ret = configfs_register_subsystem(&rpmsg_cfs_subsys);
+	if (ret) {
+		pr_err("Error %d while registering subsystem %s\n",
+		       ret, root->cg_item.ci_namebuf);
+		goto err;
+	}
+
+	channel_group = configfs_register_default_group(root, "channel",
+							&rpmsg_channel_type);
+	if (IS_ERR(channel_group)) {
+		ret = PTR_ERR(channel_group);
+		pr_err("Error %d while registering channel group\n",
+		       ret);
+		goto err_channel_group;
+	}
+
+	virtproc_group =
+		configfs_register_default_group(root, "virtproc",
+						&rpmsg_virtproc_type);
+	if (IS_ERR(virtproc_group)) {
+		ret = PTR_ERR(virtproc_group);
+		pr_err("Error %d while registering virtproc group\n",
+		       ret);
+		goto err_virtproc_group;
+	}
+
+	return 0;
+
+err_virtproc_group:
+	configfs_unregister_default_group(channel_group);
+
+err_channel_group:
+	configfs_unregister_subsystem(&rpmsg_cfs_subsys);
+
+err:
+	return ret;
+}
+module_init(rpmsg_cfs_init);
+
+static void __exit rpmsg_cfs_exit(void)
+{
+	configfs_unregister_default_group(virtproc_group);
+	configfs_unregister_default_group(channel_group);
+	configfs_unregister_subsystem(&rpmsg_cfs_subsys);
+}
+module_exit(rpmsg_cfs_exit);
+
+MODULE_DESCRIPTION("PCI RPMSG CONFIGFS");
+MODULE_AUTHOR("Kishon Vijay Abraham I <kishon@ti.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
index e330ec4dfc33..68569fec03e2 100644
--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -563,8 +563,15 @@ EXPORT_SYMBOL(rpmsg_unregister_device);
  */
 int __register_rpmsg_driver(struct rpmsg_driver *rpdrv, struct module *owner)
 {
+	const struct rpmsg_device_id *ids = rpdrv->id_table;
 	rpdrv->drv.bus = &rpmsg_bus;
 	rpdrv->drv.owner = owner;
+
+	while (ids && ids->name[0]) {
+		rpmsg_cfs_add_channel_group(ids->name);
+		ids++;
+	}
+
 	return driver_register(&rpdrv->drv);
 }
 EXPORT_SYMBOL(__register_rpmsg_driver);
diff --git a/drivers/rpmsg/rpmsg_internal.h b/drivers/rpmsg/rpmsg_internal.h
index 3fc83cd50e98..39b3a5caf242 100644
--- a/drivers/rpmsg/rpmsg_internal.h
+++ b/drivers/rpmsg/rpmsg_internal.h
@@ -68,6 +68,18 @@ struct rpmsg_endpoint_ops {
 			     poll_table *wait);
 };
 
+/**
+ * struct rpmsg_virtproc_ops - indirection table for rpmsg_virtproc operations
+ * @create_channel: Create a new rpdev channel
+ * @delete_channel: Delete the rpdev channel
+ * @owner: Owner of the module holding the ops
+ */
+struct rpmsg_virtproc_ops {
+	struct device *(*create_channel)(struct device *dev, const char *name);
+	void (*delete_channel)(struct device *dev);
+	struct module *owner;
+};
+
 int rpmsg_register_device(struct rpmsg_device *rpdev);
 int rpmsg_unregister_device(struct device *parent,
 			    struct rpmsg_channel_info *chinfo);
@@ -75,6 +87,10 @@ int rpmsg_unregister_device(struct device *parent,
 struct device *rpmsg_find_device(struct device *parent,
 				 struct rpmsg_channel_info *chinfo);
 
+struct config_group *
+rpmsg_cfs_add_virtproc_group(struct device *dev,
+			     const struct rpmsg_virtproc_ops *ops);
+
 /**
  * rpmsg_chrdev_register_device() - register chrdev device based on rpdev
  * @rpdev:	prepared rpdev to be used for creating endpoints
diff --git a/include/linux/rpmsg.h b/include/linux/rpmsg.h
index 9fe156d1c018..b9d9283b46ac 100644
--- a/include/linux/rpmsg.h
+++ b/include/linux/rpmsg.h
@@ -135,6 +135,7 @@ int rpmsg_trysend_offchannel(struct rpmsg_endpoint *ept, u32 src, u32 dst,
 __poll_t rpmsg_poll(struct rpmsg_endpoint *ept, struct file *filp,
 			poll_table *wait);
 
+struct config_group *rpmsg_cfs_add_channel_group(const char *name);
 #else
 
 static inline int register_rpmsg_device(struct rpmsg_device *dev)
@@ -242,6 +243,10 @@ static inline __poll_t rpmsg_poll(struct rpmsg_endpoint *ept,
 	return 0;
 }
 
+static inline struct config_group *rpmsg_cfs_add_channel_group(const char *name)
+{
+	return NULL;
+}
 #endif /* IS_ENABLED(CONFIG_RPMSG) */
 
 /* use a macro to avoid include chaining to get THIS_MODULE */
-- 
2.17.1

