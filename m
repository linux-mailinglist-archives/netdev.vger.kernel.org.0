Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041652F5360
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbhAMT3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:29:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728345AbhAMT3K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 14:29:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8B0923343;
        Wed, 13 Jan 2021 19:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610566074;
        bh=y66GmnqfKARoxPL+BTTs09JJ0dr7BTV2PgkmU/7RsN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bq6NiDNW83zaGwQczHv/IVYrk0msqkNc7LMSJh4Hxe0Oi/TKVXb/zmqjSe4FnT2kT
         /4e00iYhi8T38YcXBt/rNrr4H15rP/5FMgqD8m8Si4AWVoyADsMPSPkFiH3UGe746E
         e90Osz+gtXmE306ZJ3F61z9vcM+zjVnl0AIWzS7meJGAiXKRt7zNRl9fDubMi8FwkU
         bLDohGLCASurlPdlIt1F8K9N5Z0rSo806U75/NDeqNapnFLpNDCptmag2/X5X+BwfX
         yAYBLlRJPmzh7CeD2MlxcztEcTpKHm+EFaI4nCVLYQVx1/eSq+65JC7STKkZWINLrN
         26cbqXwk4twkw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V6 07/14] net/mlx5: SF, Add auxiliary device driver
Date:   Wed, 13 Jan 2021 11:27:23 -0800
Message-Id: <20210113192730.280656-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113192730.280656-1-saeed@kernel.org>
References: <20210113192730.280656-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Add auxiliary device driver for mlx5 subfunction auxiliary device.

A mlx5 subfunction is similar to PCI PF and VF. For a subfunction
an auxiliary device is created.

As a result, when mlx5 SF auxiliary device binds to the driver,
its netdev and rdma device are created, they appear as

$ ls -l /sys/bus/auxiliary/devices/
mlx5_core.sf.4 -> ../../../devices/pci0000:00/0000:00:03.0/0000:06:00.0/mlx5_core.sf.4

$ ls -l /sys/class/net/eth1/device
/sys/class/net/eth1/device -> ../../../mlx5_core.sf.4

$ cat /sys/bus/auxiliary/devices/mlx5_core.sf.4/sfnum
88

$ devlink dev show
pci/0000:06:00.0
auxiliary/mlx5_core.sf.4

$ devlink port show auxiliary/mlx5_core.sf.4/1
auxiliary/mlx5_core.sf.4/1: type eth netdev p0sf88 flavour virtual port 0 splittable false

$ rdma link show mlx5_0/1
link mlx5_0/1 state ACTIVE physical_state LINK_UP netdev p0sf88

$ rdma dev show
8: rocep6s0f1: node_type ca fw 16.29.0550 node_guid 248a:0703:00b3:d113 sys_image_guid 248a:0703:00b3:d112
13: mlx5_0: node_type ca fw 16.29.0550 node_guid 0000:00ff:fe00:8888 sys_image_guid 248a:0703:00b3:d112

In future, devlink device instance name will adapt to have sfnum
annotation using either an alias or as devlink instance name described
in RFC [1].

[1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/

changelog:
v5->v6:
 - driver name suffix corrected from 'mlx5_core' to 'sf'
 - using MLX5_ADEV_NAME prefix to match with other mlx5 auxiliary devices
 - fixed sf allocated condition

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  12 +++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  12 ++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  10 ++
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  20 ++++
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  |  10 ++
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.h  |  20 ++++
 .../mellanox/mlx5/core/sf/dev/driver.c        | 101 ++++++++++++++++++
 include/linux/mlx5/driver.h                   |   4 +-
 10 files changed, 187 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index f5b2e9101348..43fa5efd403c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -89,4 +89,4 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 #
 # SF device
 #
-mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o sf/dev/dev.o
+mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o sf/dev/dev.o sf/dev/driver.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 3261d0dc1104..9afe918c5827 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -7,6 +7,7 @@
 #include "fw_reset.h"
 #include "fs_core.h"
 #include "eswitch.h"
+#include "sf/dev/dev.h"
 
 static int mlx5_devlink_flash_update(struct devlink *devlink,
 				     struct devlink_flash_update_params *params,
@@ -127,6 +128,17 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	bool sf_dev_allocated;
+
+	sf_dev_allocated = mlx5_sf_dev_allocated(dev);
+	if (sf_dev_allocated) {
+		/* Reload results in deleting SF device which further results in
+		 * unregistering devlink instance while holding devlink_mutext.
+		 * Hence, do not support reload.
+		 */
+		NL_SET_ERR_MSG_MOD(extack, "reload is unsupported when SFs are allocated\n");
+		return -EOPNOTSUPP;
+	}
 
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 421febebc658..174dfbc996c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -467,7 +467,7 @@ int mlx5_eq_table_init(struct mlx5_core_dev *dev)
 	for (i = 0; i < MLX5_EVENT_TYPE_MAX; i++)
 		ATOMIC_INIT_NOTIFIER_HEAD(&eq_table->nh[i]);
 
-	eq_table->irq_table = dev->priv.irq_table;
+	eq_table->irq_table = mlx5_irq_table_get(dev);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 26b5502712a6..ab68320e5516 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -84,7 +84,6 @@ unsigned int mlx5_core_debug_mask;
 module_param_named(debug_mask, mlx5_core_debug_mask, uint, 0644);
 MODULE_PARM_DESC(debug_mask, "debug mask: 1 = dump cmd data, 2 = dump cmd exec time, 3 = both. Default=0");
 
-#define MLX5_DEFAULT_PROF	2
 static unsigned int prof_sel = MLX5_DEFAULT_PROF;
 module_param_named(prof_sel, prof_sel, uint, 0444);
 MODULE_PARM_DESC(prof_sel, "profile selector. Valid range 0 - 2");
@@ -1303,7 +1302,7 @@ void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 	mutex_unlock(&dev->intf_state_mutex);
 }
 
-static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
+int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 {
 	struct mlx5_priv *priv = &dev->priv;
 	int err;
@@ -1353,7 +1352,7 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	return err;
 }
 
-static void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
+void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
 
@@ -1696,6 +1695,10 @@ static int __init init(void)
 	if (err)
 		goto err_debug;
 
+	err = mlx5_sf_driver_register();
+	if (err)
+		goto err_sf;
+
 #ifdef CONFIG_MLX5_CORE_EN
 	err = mlx5e_init();
 	if (err) {
@@ -1706,6 +1709,8 @@ static int __init init(void)
 
 	return 0;
 
+err_sf:
+	pci_unregister_driver(&mlx5_core_driver);
 err_debug:
 	mlx5_unregister_debugfs();
 	return err;
@@ -1716,6 +1721,7 @@ static void __exit cleanup(void)
 #ifdef CONFIG_MLX5_CORE_EN
 	mlx5e_cleanup();
 #endif
+	mlx5_sf_driver_unregister();
 	pci_unregister_driver(&mlx5_core_driver);
 	mlx5_unregister_debugfs();
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index a33b7496d748..3754ef98554f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -117,6 +117,8 @@ enum mlx5_semaphore_space_address {
 	MLX5_SEMAPHORE_SW_RESET         = 0x20,
 };
 
+#define MLX5_DEFAULT_PROF       2
+
 int mlx5_query_hca_caps(struct mlx5_core_dev *dev);
 int mlx5_query_board_id(struct mlx5_core_dev *dev);
 int mlx5_cmd_init(struct mlx5_core_dev *dev);
@@ -176,6 +178,7 @@ struct cpumask *
 mlx5_irq_get_affinity_mask(struct mlx5_irq_table *irq_table, int vecidx);
 struct cpu_rmap *mlx5_irq_get_rmap(struct mlx5_irq_table *table);
 int mlx5_irq_get_num_comp(struct mlx5_irq_table *table);
+struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev);
 
 int mlx5_events_init(struct mlx5_core_dev *dev);
 void mlx5_events_cleanup(struct mlx5_core_dev *dev);
@@ -257,6 +260,13 @@ enum {
 u8 mlx5_get_nic_state(struct mlx5_core_dev *dev);
 void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state);
 
+static inline bool mlx5_core_is_sf(const struct mlx5_core_dev *dev)
+{
+	return dev->coredev_type == MLX5_COREDEV_SF;
+}
+
+int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx);
+void mlx5_mdev_uninit(struct mlx5_core_dev *dev);
 void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool boot);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 6fd974920394..a61e09aff152 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -30,6 +30,9 @@ int mlx5_irq_table_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_irq_table *irq_table;
 
+	if (mlx5_core_is_sf(dev))
+		return 0;
+
 	irq_table = kvzalloc(sizeof(*irq_table), GFP_KERNEL);
 	if (!irq_table)
 		return -ENOMEM;
@@ -40,6 +43,9 @@ int mlx5_irq_table_init(struct mlx5_core_dev *dev)
 
 void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev)
 {
+	if (mlx5_core_is_sf(dev))
+		return;
+
 	kvfree(dev->priv.irq_table);
 }
 
@@ -268,6 +274,9 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	int nvec;
 	int err;
 
+	if (mlx5_core_is_sf(dev))
+		return 0;
+
 	nvec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
 	       MLX5_IRQ_VEC_COMP_BASE;
 	nvec = min_t(int, nvec, num_eqs);
@@ -319,6 +328,9 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	struct mlx5_irq_table *table = dev->priv.irq_table;
 	int i;
 
+	if (mlx5_core_is_sf(dev))
+		return;
+
 	/* free_irq requires that affinity and rmap will be cleared
 	 * before calling it. This is why there is asymmetry with set_rmap
 	 * which should be called after alloc_irq but before request_irq.
@@ -332,3 +344,11 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	kfree(table->irq);
 }
 
+struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev)
+{
+#ifdef CONFIG_MLX5_SF
+	if (mlx5_core_is_sf(dev))
+		return dev->priv.parent_mdev->priv.irq_table;
+#endif
+	return dev->priv.irq_table;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index 4a8eeb7c853e..b265f27b2166 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -24,6 +24,16 @@ static bool mlx5_sf_dev_supported(const struct mlx5_core_dev *dev)
 	return MLX5_CAP_GEN(dev, sf) && mlx5_vhca_event_supported(dev);
 }
 
+bool mlx5_sf_dev_allocated(const struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_dev_table *table = dev->priv.sf_dev_table;
+
+	if (!mlx5_sf_dev_supported(dev))
+		return false;
+
+	return !xa_empty(&table->devices);
+}
+
 static ssize_t sfnum_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct auxiliary_device *adev = container_of(dev, struct auxiliary_device, dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
index a6fb7289ba2c..4de02902aef1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
@@ -13,6 +13,7 @@
 struct mlx5_sf_dev {
 	struct auxiliary_device adev;
 	struct mlx5_core_dev *parent_mdev;
+	struct mlx5_core_dev *mdev;
 	phys_addr_t bar_base_addr;
 	u32 sfnum;
 };
@@ -20,6 +21,11 @@ struct mlx5_sf_dev {
 void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev);
 void mlx5_sf_dev_table_destroy(struct mlx5_core_dev *dev);
 
+int mlx5_sf_driver_register(void);
+void mlx5_sf_driver_unregister(void);
+
+bool mlx5_sf_dev_allocated(const struct mlx5_core_dev *dev);
+
 #else
 
 static inline void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
@@ -30,6 +36,20 @@ static inline void mlx5_sf_dev_table_destroy(struct mlx5_core_dev *dev)
 {
 }
 
+static inline int mlx5_sf_driver_register(void)
+{
+	return 0;
+}
+
+static inline void mlx5_sf_driver_unregister(void)
+{
+}
+
+static inline bool mlx5_sf_dev_allocated(const struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
 #endif
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
new file mode 100644
index 000000000000..daf63a8115e0
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/device.h>
+#include "mlx5_core.h"
+#include "dev.h"
+#include "devlink.h"
+
+static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxiliary_device_id *id)
+{
+	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
+	struct mlx5_core_dev *mdev;
+	struct devlink *devlink;
+	int err;
+
+	devlink = mlx5_devlink_alloc();
+	if (!devlink)
+		return -ENOMEM;
+
+	mdev = devlink_priv(devlink);
+	mdev->device = &adev->dev;
+	mdev->pdev = sf_dev->parent_mdev->pdev;
+	mdev->bar_addr = sf_dev->bar_base_addr;
+	mdev->iseg_base = sf_dev->bar_base_addr;
+	mdev->coredev_type = MLX5_COREDEV_SF;
+	mdev->priv.parent_mdev = sf_dev->parent_mdev;
+	mdev->priv.adev_idx = adev->id;
+	sf_dev->mdev = mdev;
+
+	err = mlx5_mdev_init(mdev, MLX5_DEFAULT_PROF);
+	if (err) {
+		mlx5_core_warn(mdev, "mlx5_mdev_init on err=%d\n", err);
+		goto mdev_err;
+	}
+
+	mdev->iseg = ioremap(mdev->iseg_base, sizeof(*mdev->iseg));
+	if (!mdev->iseg) {
+		mlx5_core_warn(mdev, "remap error\n");
+		goto remap_err;
+	}
+
+	err = mlx5_load_one(mdev, true);
+	if (err) {
+		mlx5_core_warn(mdev, "mlx5_load_one err=%d\n", err);
+		goto load_one_err;
+	}
+	return 0;
+
+load_one_err:
+	iounmap(mdev->iseg);
+remap_err:
+	mlx5_mdev_uninit(mdev);
+mdev_err:
+	mlx5_devlink_free(devlink);
+	return err;
+}
+
+static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
+{
+	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
+	struct devlink *devlink;
+
+	devlink = priv_to_devlink(sf_dev->mdev);
+	mlx5_unload_one(sf_dev->mdev, true);
+	iounmap(sf_dev->mdev->iseg);
+	mlx5_mdev_uninit(sf_dev->mdev);
+	mlx5_devlink_free(devlink);
+}
+
+static void mlx5_sf_dev_shutdown(struct auxiliary_device *adev)
+{
+	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
+
+	mlx5_unload_one(sf_dev->mdev, false);
+}
+
+static const struct auxiliary_device_id mlx5_sf_dev_id_table[] = {
+	{ .name = MLX5_ADEV_NAME "." MLX5_SF_DEV_ID_NAME, },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(auxiliary, mlx5_sf_dev_id_table);
+
+static struct auxiliary_driver mlx5_sf_driver = {
+	.name = MLX5_SF_DEV_ID_NAME,
+	.probe = mlx5_sf_dev_probe,
+	.remove = mlx5_sf_dev_remove,
+	.shutdown = mlx5_sf_dev_shutdown,
+	.id_table = mlx5_sf_dev_id_table,
+};
+
+int mlx5_sf_driver_register(void)
+{
+	return auxiliary_driver_register(&mlx5_sf_driver);
+}
+
+void mlx5_sf_driver_unregister(void)
+{
+	auxiliary_driver_unregister(&mlx5_sf_driver);
+}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 08e5fbe97df0..48e3638b1185 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -193,7 +193,8 @@ enum port_state_policy {
 
 enum mlx5_coredev_type {
 	MLX5_COREDEV_PF,
-	MLX5_COREDEV_VF
+	MLX5_COREDEV_VF,
+	MLX5_COREDEV_SF,
 };
 
 struct mlx5_field_desc {
@@ -608,6 +609,7 @@ struct mlx5_priv {
 #ifdef CONFIG_MLX5_SF
 	struct mlx5_vhca_state_notifier *vhca_state_notifier;
 	struct mlx5_sf_dev_table *sf_dev_table;
+	struct mlx5_core_dev *parent_mdev;
 #endif
 };
 
-- 
2.26.2

