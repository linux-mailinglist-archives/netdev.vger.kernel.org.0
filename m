Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6535CF50E5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfKHQTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:19:16 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60358 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727178AbfKHQTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:19:15 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Nov 2019 18:19:10 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA8GJ9xt004530;
        Fri, 8 Nov 2019 18:19:09 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id xA8GJ89n030104;
        Fri, 8 Nov 2019 18:19:08 +0200
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id xA8GJ8wH030103;
        Fri, 8 Nov 2019 18:19:08 +0200
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, danielj@mellanox.com, parav@mellanox.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next v2 08/10] netdevsim: Add devlink subdev creation
Date:   Fri,  8 Nov 2019 18:18:44 +0200
Message-Id: <1573229926-30040-9-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink subdev creation to represent VFs, and implement hw_addr
get/set.

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/Makefile    |   2 +-
 drivers/net/netdevsim/dev.c       |   9 ++-
 drivers/net/netdevsim/netdevsim.h |  10 +++
 drivers/net/netdevsim/subdev.c    | 100 ++++++++++++++++++++++++++++++
 4 files changed, 119 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/netdevsim/subdev.c

diff --git a/drivers/net/netdevsim/Makefile b/drivers/net/netdevsim/Makefile
index f4d8f62f28c2..dbbcfb57951e 100644
--- a/drivers/net/netdevsim/Makefile
+++ b/drivers/net/netdevsim/Makefile
@@ -3,7 +3,7 @@
 obj-$(CONFIG_NETDEVSIM) += netdevsim.o
 
 netdevsim-objs := \
-	netdev.o dev.o fib.o bus.o health.o
+	netdev.o dev.o fib.o bus.o health.o subdev.o
 
 ifeq ($(CONFIG_BPF_SYSCALL),y)
 netdevsim-objs += \
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 468e157a7cb1..85fc0d40dda1 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -785,10 +785,14 @@ static struct nsim_dev *nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_fib_destroy;
 
+	err = nsim_dev_subdevs_create(nsim_dev, devlink);
+	if (err)
+		goto err_dl_unregister;
+
 	err = devlink_params_register(devlink, nsim_devlink_params,
 				      ARRAY_SIZE(nsim_devlink_params));
 	if (err)
-		goto err_dl_unregister;
+		goto err_dl_subdevs_destroy;
 	nsim_devlink_set_params_init_values(nsim_dev, devlink);
 
 	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
@@ -831,6 +835,8 @@ static struct nsim_dev *nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 err_params_unregister:
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
+err_dl_subdevs_destroy:
+	nsim_dev_subdevs_destroy(nsim_dev);
 err_dl_unregister:
 	devlink_unregister(devlink);
 err_fib_destroy:
@@ -866,6 +872,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 	nsim_dev_debugfs_exit(nsim_dev);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
+	nsim_dev_subdevs_destroy(nsim_dev);
 	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
 	devlink_free(devlink);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index e2049856add8..9f8b294be826 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -154,6 +154,12 @@ struct nsim_dev_port {
 	struct netdevsim *ns;
 };
 
+struct nsim_subdev {
+	struct devlink_subdev *devlink_subdev;
+	unsigned int subdev_index;
+	struct nsim_bus_dev *nsim_bus_dev;
+};
+
 struct nsim_dev {
 	struct nsim_bus_dev *nsim_bus_dev;
 	struct nsim_fib_data *fib_data;
@@ -177,6 +183,7 @@ struct nsim_dev {
 	bool fail_reload;
 	struct devlink_region *dummy_region;
 	struct nsim_dev_health health;
+	struct nsim_subdev *subdevs;
 };
 
 static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
@@ -245,3 +252,6 @@ struct nsim_bus_dev {
 
 int nsim_bus_init(void);
 void nsim_bus_exit(void);
+
+int nsim_dev_subdevs_create(struct nsim_dev *nsim_dev, struct devlink *devlink);
+void nsim_dev_subdevs_destroy(struct nsim_dev *nsim_dev);
diff --git a/drivers/net/netdevsim/subdev.c b/drivers/net/netdevsim/subdev.c
new file mode 100644
index 000000000000..56899fe8e785
--- /dev/null
+++ b/drivers/net/netdevsim/subdev.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Mellanox Technologies */
+
+#include <linux/device.h>
+#include <linux/etherdevice.h>
+#include <linux/inet.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/rtnetlink.h>
+#include <net/devlink.h>
+#include <uapi/linux/devlink.h>
+
+#include "netdevsim.h"
+
+static int
+nsim_hw_addr_set(struct devlink_subdev *devlink_subdev, u8 *hw_addr,
+		 struct netlink_ext_ack *extack)
+{
+	struct nsim_bus_dev *nsim_bus_dev;
+	struct nsim_subdev *nsim_subdev;
+	int subdev_index;
+
+	nsim_subdev = devlink_subdev_priv(devlink_subdev);
+	nsim_bus_dev = nsim_subdev->nsim_bus_dev;
+	subdev_index = nsim_subdev->subdev_index;
+
+	ether_addr_copy(nsim_bus_dev->vfconfigs[subdev_index].vf_mac,
+			hw_addr);
+	return 0;
+}
+
+static int
+nsim_hw_addr_get(struct devlink_subdev *devlink_subdev, u8 *hw_addr,
+		 struct netlink_ext_ack *extack)
+{
+	struct nsim_bus_dev *nsim_bus_dev;
+	struct nsim_subdev *nsim_subdev;
+	int subdev_index;
+
+	nsim_subdev = devlink_subdev_priv(devlink_subdev);
+	nsim_bus_dev = nsim_subdev->nsim_bus_dev;
+	subdev_index = nsim_subdev->subdev_index;
+
+	ether_addr_copy(hw_addr,
+			nsim_bus_dev->vfconfigs[subdev_index].vf_mac);
+	return 0;
+}
+
+static struct devlink_subdev_ops subdev_ops = {
+	.hw_addr_set = nsim_hw_addr_set,
+	.hw_addr_get = nsim_hw_addr_get,
+	.hw_addr_len = ETH_ALEN,
+};
+
+int nsim_dev_subdevs_create(struct nsim_dev *nsim_dev, struct devlink *devlink)
+{
+	int max_vfs = nsim_dev->nsim_bus_dev->max_vfs;
+	struct devlink_subdev_attrs attrs;
+	int err;
+	int vf;
+
+	nsim_dev->subdevs = kcalloc(max_vfs, sizeof(*nsim_dev->subdevs),
+				    GFP_KERNEL);
+	if (!nsim_dev->subdevs)
+		return -ENOMEM;
+
+	for (vf = 0; vf < max_vfs; vf++) {
+		struct nsim_subdev *nsim_subdev = &nsim_dev->subdevs[vf];
+		struct devlink_subdev *devlink_subdev;
+
+		nsim_subdev->nsim_bus_dev = nsim_dev->nsim_bus_dev;
+		devlink_subdev_attrs_pci_vf_init(&attrs, 0, vf);
+		devlink_subdev = devlink_subdev_create(devlink, vf,
+						       &subdev_ops,
+						       &attrs,
+						       nsim_subdev);
+		if (IS_ERR(devlink_subdev)) {
+			err = PTR_ERR(devlink_subdev);
+			goto err_subdevs_destroy;
+		}
+		nsim_subdev->devlink_subdev = devlink_subdev;
+		nsim_subdev->subdev_index = vf;
+	}
+
+	return 0;
+
+err_subdevs_destroy:
+	for (vf--; vf >= 0; vf--)
+		devlink_subdev_destroy(nsim_dev->subdevs[vf].devlink_subdev);
+	return err;
+}
+
+void nsim_dev_subdevs_destroy(struct nsim_dev *nsim_dev)
+{
+	int vf;
+
+	for (vf = 0; vf < nsim_dev->nsim_bus_dev->max_vfs; vf++)
+		devlink_subdev_destroy(nsim_dev->subdevs[vf].devlink_subdev);
+}
+
-- 
2.17.1

