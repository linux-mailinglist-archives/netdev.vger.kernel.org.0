Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7D92B0DE2
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgKLTY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:24:58 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11355 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgKLTY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c0f0002>; Thu, 12 Nov 2020 11:25:03 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:54 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Subject: [PATCH net-next 08/13] net/mlx5: SF, Add auxiliary device driver
Date:   Thu, 12 Nov 2020 21:24:18 +0200
Message-ID: <20201112192424.2742-9-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112192424.2742-1-parav@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605209103; bh=4apZ+3wx5/uPC2lt0e8tLLWW3EG/y8PJM2AUoOTcS60=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lTsBIkX9b4UYHK0eFpYitFTaRq3+echhP3CpJgplILl9W8z1BmT0is3ZIaMToYu67
         9pPR7GpfPrCmL24eFy5lBEM6xPmtUnLJf/gdQP7OKk+dYwYR9VlWgdnHJW1NIeIjg8
         8D6KxPBPFSriaawM5Q4O4w+5kD1VMvTKlhfe3/n0s/lV5t/QZxgCcOaUl+sb70Lxxs
         eb1SdRdrPW37srgATfpriR68YllQzlicS3xh5xNJnDNDjaWODJl1Wj+Jtdzh6MukMM
         yuRoBeBNZS7kpV7eCodMW6Mn3bOHllkTqBPp13zWJ0EzSXpJNVH2+5QWdsuQQt0oFh
         XTSkrM+mHExLw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add auxiliary device driver for mlx5 subfunction auxiliary device.

A mlx5 subfunction is similar to PCI PF and VF. For a subfunction
an auxiliary device is created.

As a result, when mlx5 SF auxiliary device binds to the driver,
its netdev and rdma device are created, they appear as

$ ls -l /sys/bus/auxiliary/devices/
mlx5_core.sf.0 -> ../../../devices/pci0000:00/0000:00:03.0/0000:06:00.0/mlx=
5_core.sf.0

$ ls -l /sys/class/net/eth1/device
/sys/class/net/eth1/device -> ../../../mlx5_core.sf.0

$ cat /sys/bus/auxiliary/devices/mlx5_core.sf.0/sfnum
88

$ devlink dev show
pci/0000:06:00.0
auxiliary/mlx5_core.sf.0

$ devlink port show auxiliary/mlx5_core.sf.0/1
auxiliary/mlx5_core.sf.0/1: type eth netdev p0sf88 flavour virtual port 0 s=
plittable false

$ rdma link show mlx5_0/1
link mlx5_0/1 state ACTIVE physical_state LINK_UP netdev p0sf88

$ rdma dev show
8: rocep6s0f1: node_type ca fw 16.27.1017 node_guid 248a:0703:00b3:d113 sys=
_image_guid 248a:0703:00b3:d112
13: mlx5_0: node_type ca fw 16.27.1017 node_guid 0000:00ff:fe00:8888 sys_im=
age_guid 248a:0703:00b3:d112

In future, devlink device instance name will adapt to have sfnum
annotation using either an alias or as devlink instance name described
in RFC [1].

[1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  22 ++--
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  10 ++
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  20 ++++
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.h  |  13 +++
 .../mellanox/mlx5/core/sf/dev/driver.c        | 105 ++++++++++++++++++
 include/linux/mlx5/driver.h                   |   4 +-
 8 files changed, 168 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index ee866da1d9ba..7dd5be49fb9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -88,4 +88,4 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) +=3D steering/dr_dom=
ain.o steering/dr_table.o
 #
 # SF device
 #
-mlx5_core-$(CONFIG_MLX5_SF) +=3D sf/dev/dev.o
+mlx5_core-$(CONFIG_MLX5_SF) +=3D sf/dev/dev.o sf/dev/driver.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/eq.c
index 8ebfe782f95e..50c235e54c86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -465,7 +465,7 @@ int mlx5_eq_table_init(struct mlx5_core_dev *dev)
 	for (i =3D 0; i < MLX5_EVENT_TYPE_MAX; i++)
 		ATOMIC_INIT_NOTIFIER_HEAD(&eq_table->nh[i]);
=20
-	eq_table->irq_table =3D dev->priv.irq_table;
+	eq_table->irq_table =3D mlx5_irq_table_get(dev);
 	return 0;
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index a1ba6056952b..adfa21de938e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -83,7 +83,6 @@ unsigned int mlx5_core_debug_mask;
 module_param_named(debug_mask, mlx5_core_debug_mask, uint, 0644);
 MODULE_PARM_DESC(debug_mask, "debug mask: 1 =3D dump cmd data, 2 =3D dump =
cmd exec time, 3 =3D both. Default=3D0");
=20
-#define MLX5_DEFAULT_PROF	2
 static unsigned int prof_sel =3D MLX5_DEFAULT_PROF;
 module_param_named(prof_sel, prof_sel, uint, 0444);
 MODULE_PARM_DESC(prof_sel, "profile selector. Valid range 0 - 2");
@@ -1295,7 +1294,7 @@ void mlx5_unload_one(struct mlx5_core_dev *dev, bool =
cleanup)
 	mutex_unlock(&dev->intf_state_mutex);
 }
=20
-static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
+int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 {
 	struct mlx5_priv *priv =3D &dev->priv;
 	int err;
@@ -1345,7 +1344,7 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, =
int profile_idx)
 	return err;
 }
=20
-static void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
+void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv =3D &dev->priv;
=20
@@ -1684,16 +1683,24 @@ static int __init init(void)
 	if (err)
 		goto err_debug;
=20
+	err =3D mlx5_sf_driver_register();
+	if (err)
+		goto err_sf;
+
 #ifdef CONFIG_MLX5_CORE_EN
 	err =3D mlx5e_init();
-	if (err) {
-		pci_unregister_driver(&mlx5_core_driver);
-		goto err_debug;
-	}
+	if (err)
+		goto err_eth;
 #endif
=20
 	return 0;
=20
+#ifdef CONFIG_MLX5_CORE_EN
+err_eth:
+	mlx5_sf_driver_unregister();
+#endif
+err_sf:
+	pci_unregister_driver(&mlx5_core_driver);
 err_debug:
 	mlx5_unregister_debugfs();
 	return err;
@@ -1704,6 +1711,7 @@ static void __exit cleanup(void)
 #ifdef CONFIG_MLX5_CORE_EN
 	mlx5e_cleanup();
 #endif
+	mlx5_sf_driver_unregister();
 	pci_unregister_driver(&mlx5_core_driver);
 	mlx5_unregister_debugfs();
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/=
net/ethernet/mellanox/mlx5/core/mlx5_core.h
index dd7312621d0d..499aa76bf8d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -117,6 +117,8 @@ enum mlx5_semaphore_space_address {
 	MLX5_SEMAPHORE_SW_RESET         =3D 0x20,
 };
=20
+#define MLX5_DEFAULT_PROF       2
+
 int mlx5_query_hca_caps(struct mlx5_core_dev *dev);
 int mlx5_query_board_id(struct mlx5_core_dev *dev);
 int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id);
@@ -172,6 +174,7 @@ struct cpumask *
 mlx5_irq_get_affinity_mask(struct mlx5_irq_table *irq_table, int vecidx);
 struct cpu_rmap *mlx5_irq_get_rmap(struct mlx5_irq_table *table);
 int mlx5_irq_get_num_comp(struct mlx5_irq_table *table);
+struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev);
=20
 int mlx5_events_init(struct mlx5_core_dev *dev);
 void mlx5_events_cleanup(struct mlx5_core_dev *dev);
@@ -253,6 +256,13 @@ enum {
 u8 mlx5_get_nic_state(struct mlx5_core_dev *dev);
 void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state);
=20
+static inline bool mlx5_core_is_sf(const struct mlx5_core_dev *dev)
+{
+	return dev->coredev_type =3D=3D MLX5_COREDEV_SF;
+}
+
+int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx);
+void mlx5_mdev_uninit(struct mlx5_core_dev *dev);
 void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool boot);
 #endif /* __MLX5_CORE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/pci_irq.c
index 6fd974920394..a61e09aff152 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -30,6 +30,9 @@ int mlx5_irq_table_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_irq_table *irq_table;
=20
+	if (mlx5_core_is_sf(dev))
+		return 0;
+
 	irq_table =3D kvzalloc(sizeof(*irq_table), GFP_KERNEL);
 	if (!irq_table)
 		return -ENOMEM;
@@ -40,6 +43,9 @@ int mlx5_irq_table_init(struct mlx5_core_dev *dev)
=20
 void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev)
 {
+	if (mlx5_core_is_sf(dev))
+		return;
+
 	kvfree(dev->priv.irq_table);
 }
=20
@@ -268,6 +274,9 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	int nvec;
 	int err;
=20
+	if (mlx5_core_is_sf(dev))
+		return 0;
+
 	nvec =3D MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
 	       MLX5_IRQ_VEC_COMP_BASE;
 	nvec =3D min_t(int, nvec, num_eqs);
@@ -319,6 +328,9 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	struct mlx5_irq_table *table =3D dev->priv.irq_table;
 	int i;
=20
+	if (mlx5_core_is_sf(dev))
+		return;
+
 	/* free_irq requires that affinity and rmap will be cleared
 	 * before calling it. This is why there is asymmetry with set_rmap
 	 * which should be called after alloc_irq but before request_irq.
@@ -332,3 +344,11 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	kfree(table->irq);
 }
=20
+struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev)
+{
+#ifdef CONFIG_MLX5_SF
+	if (mlx5_core_is_sf(dev))
+		return dev->priv.parent_mdev->priv.irq_table;
+#endif
+	return dev->priv.irq_table;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h b/drivers=
/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
index d81612122a45..37634e3dedb5 100644
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
@@ -26,6 +27,9 @@ void mlx5_sf_dev_table_destroy(struct mlx5_core_dev *dev)=
;
 int mlx5_sf_dev_add(struct mlx5_core_dev *dev, u16 sf_index, u32 sfnum);
 void mlx5_sf_dev_del(struct mlx5_core_dev *dev, u16 sf_index);
=20
+int mlx5_sf_driver_register(void);
+void mlx5_sf_driver_unregister(void);
+
 #else
=20
 static inline void __exit mlx5_sf_dev_exit(void)
@@ -50,6 +54,15 @@ static inline void mlx5_sf_dev_table_destroy(struct mlx5=
_core_dev *dev)
 {
 }
=20
+static inline int mlx5_sf_driver_register(void)
+{
+	return 0;
+}
+
+static inline void mlx5_sf_driver_unregister(void)
+{
+}
+
 #endif
=20
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
new file mode 100644
index 000000000000..10fe41c13a4a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/device.h>
+#include "mlx5_core.h"
+#include "dev.h"
+#include "devlink.h"
+
+static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct a=
uxiliary_device_id *id)
+{
+	struct mlx5_sf_dev *sf_dev =3D container_of(adev, struct mlx5_sf_dev, ade=
v);
+	struct mlx5_core_dev *mdev;
+	struct devlink *devlink;
+	int err;
+
+	devlink =3D mlx5_devlink_alloc();
+	if (!devlink)
+		return -ENOMEM;
+
+	mdev =3D devlink_priv(devlink);
+	mdev->device =3D &adev->dev;
+	mdev->pdev =3D sf_dev->parent_mdev->pdev;
+	mdev->bar_addr =3D sf_dev->bar_base_addr;
+	mdev->iseg_base =3D sf_dev->bar_base_addr;
+	mdev->coredev_type =3D MLX5_COREDEV_SF;
+	mdev->priv.parent_mdev =3D sf_dev->parent_mdev;
+	mdev->priv.adev_idx =3D sf_dev->adev.id;
+	sf_dev->mdev =3D mdev;
+
+	err =3D mlx5_mdev_init(mdev, MLX5_DEFAULT_PROF);
+	if (err) {
+		mlx5_core_warn(mdev, "mlx5_mdev_init on err=3D%d\n", err);
+		goto mdev_err;
+	}
+
+	mdev->iseg =3D ioremap(mdev->iseg_base, sizeof(*mdev->iseg));
+	if (!mdev->iseg) {
+		mlx5_core_warn(mdev, "remap error\n");
+		goto remap_err;
+	}
+
+	err =3D mlx5_load_one(mdev, true);
+	if (err) {
+		mlx5_core_warn(mdev, "mlx5_load_one err=3D%d\n", err);
+		goto load_one_err;
+	}
+	devlink_reload_enable(devlink);
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
+static int mlx5_sf_dev_remove(struct auxiliary_device *adev)
+{
+	struct mlx5_sf_dev *sf_dev =3D container_of(adev, struct mlx5_sf_dev, ade=
v);
+	struct devlink *devlink;
+
+	devlink =3D priv_to_devlink(sf_dev->mdev);
+	devlink_reload_disable(devlink);
+	mlx5_unload_one(sf_dev->mdev, true);
+	iounmap(sf_dev->mdev->iseg);
+	mlx5_mdev_uninit(sf_dev->mdev);
+	mlx5_devlink_free(devlink);
+	return 0;
+}
+
+static void mlx5_sf_dev_shutdown(struct auxiliary_device *adev)
+{
+	struct mlx5_sf_dev *sf_dev =3D container_of(adev, struct mlx5_sf_dev, ade=
v);
+
+	mlx5_unload_one(sf_dev->mdev, false);
+}
+
+static const struct auxiliary_device_id mlx5_sf_dev_id_table[] =3D {
+	{ .name =3D KBUILD_MODNAME "." MLX5_SF_DEV_ID_NAME, },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(auxiliary, mlx5_sf_dev_id_table);
+
+static struct auxiliary_driver mlx5_sf_driver =3D {
+	.name =3D MLX5_SF_DEV_ID_NAME,
+	.probe =3D mlx5_sf_dev_probe,
+	.remove =3D mlx5_sf_dev_remove,
+	.shutdown =3D mlx5_sf_dev_shutdown,
+	.id_table =3D mlx5_sf_dev_id_table,
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
+
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 151cacab07db..f3104b50ade5 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -193,7 +193,8 @@ enum port_state_policy {
=20
 enum mlx5_coredev_type {
 	MLX5_COREDEV_PF,
-	MLX5_COREDEV_VF
+	MLX5_COREDEV_VF,
+	MLX5_COREDEV_SF,
 };
=20
 struct mlx5_field_desc {
@@ -606,6 +607,7 @@ struct mlx5_priv {
 	struct mlx5_uars_page	       *uar;
 #ifdef CONFIG_MLX5_SF
 	struct mlx5_sf_dev_table *sf_dev_table;
+	struct mlx5_core_dev *parent_mdev;
 #endif
 };
=20
--=20
2.26.2

