Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BB02B0DF4
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgKLTZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:25:15 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11882 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgKLTYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c010000>; Thu, 12 Nov 2020 11:24:49 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:53 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Subject: [PATCH net-next 07/13] net/mlx5: SF, Add auxiliary device support
Date:   Thu, 12 Nov 2020 21:24:17 +0200
Message-ID: <20201112192424.2742-8-parav@nvidia.com>
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
        t=1605209089; bh=XkRd9aq6/G3DKokOFC93KLRgF4gaeOp5YmQLYKMRFu0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Lvx7sg6osG76sqP2wNoIt2Kpa2a5aQmfvt6wVxk3yH9l30z5PhAaaND/1VX21GqTN
         eMuPxnIdi5aObmkrtZsyXNYwa3Fe4PznzHiADdNwcI0ffjsuh6jd+Y1047KWLv9KNJ
         8ENQY4zUHjObyipcexWEUSf8iKAxQ9nD96FWT6FZHp9KYrpgSZqek9GDItovINlhrH
         TQrPgxGru8VJM62cwzEDbHfj2CNHoqae6Xf+lzcwPqBl5xZNL+d8bic3Vcq4ZplbO4
         RjM5FhMe5qYrhbHK5RUSecDmmsoQ8ivGa3ZzvlRog9bi7FIFPIyIxND3vP7HcWm7IG
         UZxyE2UZii0sw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce API to add and delete an auxiliary device for an SF.
Each SF has its own dedicated window in the PCI BAR 2.

SF device is similar to PCI PF and VF that supports multiple class of
devices such as net, rdma and vdpa.

SF device will be added or removed in subsequent patch during SF
devlink port function state change command.

A subfunction device exposes user supplied subfunction number which will
be further used by systemd/udev to have deterministic name for its
netdevice and rdma device.

An mlx5 subfunction auxiliary device example:

$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 s=
plittable false

$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88

$ devlink port show ens2f0npf0sf88
pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf contro=
ller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:88:88 state inactive opstate detached

$ devlink port function set ens2f0npf0sf88 hw_addr 00:00:00:00:88:88 state =
active

On activation,

$ ls -l /sys/bus/auxiliary/devices/
mlx5_core.sf.0 -> ../../../devices/pci0000:00/0000:00:03.0/0000:06:00.0/mlx=
5_core.sf.0

$ cat /sys/bus/auxiliary/devices/mlx5_core.sf.0/sfnum
88

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   9 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   4 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  12 +
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 213 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.h  |  55 +++++
 include/linux/mlx5/driver.h                   |   4 +
 6 files changed, 297 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/=
ethernet/mellanox/mlx5/core/Kconfig
index 485478979b1a..10dfaf671c90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -202,3 +202,12 @@ config MLX5_SW_STEERING
 	default y
 	help
 	Build support for software-managed steering in the NIC.
+
+config MLX5_SF
+	bool "Mellanox Technologies subfunction device support using auxiliary de=
vice"
+	depends on MLX5_CORE && MLX5_CORE_EN
+	default n
+	help
+	Build support for subfuction device in the NIC. A Mellanox subfunction
+	device can support RDMA, netdevice and vdpa device.
+	It is similar to a SRIOV VF but it doesn't require SRIOV support.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index 2d477f9a8cb7..ee866da1d9ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -85,3 +85,7 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) +=3D steering/dr_dom=
ain.o steering/dr_table.o
 					steering/dr_ste.o steering/dr_send.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o
+#
+# SF device
+#
+mlx5_core-$(CONFIG_MLX5_SF) +=3D sf/dev/dev.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index 37fa56904235..a1ba6056952b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -73,6 +73,7 @@
 #include "ecpf.h"
 #include "lib/hv_vhca.h"
 #include "diag/rsc_dump.h"
+#include "sf/dev/dev.h"
=20
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
 MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX ser=
ies) core driver");
@@ -884,6 +885,12 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 		goto err_eswitch_cleanup;
 	}
=20
+	err =3D mlx5_sf_dev_table_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to init SF device table %d\n", err);
+		goto err_sf_dev_cleanup;
+	}
+
 	dev->dm =3D mlx5_dm_create(dev);
 	if (IS_ERR(dev->dm))
 		mlx5_core_warn(dev, "Failed to init device memory%d\n", err);
@@ -894,6 +901,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
=20
 	return 0;
=20
+err_sf_dev_cleanup:
+	mlx5_fpga_cleanup(dev);
 err_eswitch_cleanup:
 	mlx5_eswitch_cleanup(dev->priv.eswitch);
 err_sriov_cleanup:
@@ -925,6 +934,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev=
)
 	mlx5_hv_vhca_destroy(dev->hv_vhca);
 	mlx5_fw_tracer_destroy(dev->tracer);
 	mlx5_dm_cleanup(dev);
+	mlx5_sf_dev_table_cleanup(dev);
 	mlx5_fpga_cleanup(dev);
 	mlx5_eswitch_cleanup(dev->priv.eswitch);
 	mlx5_sriov_cleanup(dev);
@@ -1141,6 +1151,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 		goto err_ec;
 	}
=20
+	mlx5_sf_dev_table_create(dev);
 	return 0;
=20
 err_ec:
@@ -1171,6 +1182,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
=20
 static void mlx5_unload(struct mlx5_core_dev *dev)
 {
+	mlx5_sf_dev_table_destroy(dev);
 	mlx5_ec_cleanup(dev);
 	mlx5_sriov_detach(dev);
 	mlx5_cleanup_fs(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers=
/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
new file mode 100644
index 000000000000..a25f6027b7cd
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -0,0 +1,213 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/device.h>
+#include "mlx5_core.h"
+#include "dev.h"
+
+struct mlx5_sf_dev_table {
+	/* Serializes table access between driver unload context and
+	 * device add/remove user command context.
+	 */
+	struct mutex table_lock;
+	struct xarray devices;
+	unsigned int max_sfs;
+	phys_addr_t base_address;
+	u64 sf_bar_length;
+};
+
+static bool mlx5_sf_dev_supported(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN(dev, sf);
+}
+
+static ssize_t sfnum_show(struct device *dev, struct device_attribute *att=
r, char *buf)
+{
+	struct auxiliary_device *adev =3D container_of(dev, struct auxiliary_devi=
ce, dev);
+	struct mlx5_sf_dev *sf_dev =3D container_of(adev, struct mlx5_sf_dev, ade=
v);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", sf_dev->sfnum);
+}
+static DEVICE_ATTR_RO(sfnum);
+
+static struct attribute *sf_device_attrs[] =3D {
+	&dev_attr_sfnum.attr,
+	NULL,
+};
+
+static const struct attribute_group sf_attr_group =3D {
+	.attrs =3D sf_device_attrs,
+};
+
+static const struct attribute_group *sf_attr_groups[2] =3D {
+	&sf_attr_group,
+	NULL
+};
+
+static void mlx5_sf_dev_release(struct device *device)
+{
+	struct auxiliary_device *adev =3D container_of(device, struct auxiliary_d=
evice, dev);
+	struct mlx5_sf_dev *sf_dev =3D container_of(adev, struct mlx5_sf_dev, ade=
v);
+
+	mlx5_adev_idx_free(sf_dev->adev.id);
+	kfree(sf_dev);
+}
+
+static void mlx5_sf_dev_remove(struct mlx5_sf_dev *sf_dev)
+{
+	auxiliary_device_delete(&sf_dev->adev);
+	auxiliary_device_uninit(&sf_dev->adev);
+}
+
+int mlx5_sf_dev_add(struct mlx5_core_dev *dev, u16 sf_index, u32 sfnum)
+{
+	struct mlx5_sf_dev_table *table =3D dev->priv.sf_dev_table;
+	struct mlx5_sf_dev *sf_dev;
+	struct pci_dev *pdev;
+	int id;
+	int err;
+
+	id =3D mlx5_adev_idx_alloc();
+	if (id < 0)
+		return id;
+
+	sf_dev =3D kzalloc(sizeof(*sf_dev), GFP_KERNEL);
+	if (!sf_dev) {
+		mlx5_adev_idx_free(id);
+		return -ENOMEM;
+	}
+	pdev =3D dev->pdev;
+	sf_dev->adev.id =3D id;
+	sf_dev->adev.name =3D MLX5_SF_DEV_ID_NAME;
+	sf_dev->adev.dev.release =3D mlx5_sf_dev_release;
+	sf_dev->adev.dev.parent =3D &pdev->dev;
+	sf_dev->adev.dev.groups =3D sf_attr_groups;
+	sf_dev->sfnum =3D sfnum;
+	sf_dev->parent_mdev =3D dev;
+
+	/* Serialize with unloading the driver. */
+	mutex_lock(&table->table_lock);
+	if (!table->max_sfs) {
+		mlx5_adev_idx_free(id);
+		kfree(sf_dev);
+		err =3D -EOPNOTSUPP;
+		goto add_err;
+	}
+	sf_dev->bar_base_addr =3D table->base_address + (sf_index * table->sf_bar=
_length);
+
+	err =3D auxiliary_device_init(&sf_dev->adev);
+	if (err) {
+		mlx5_adev_idx_free(id);
+		kfree(sf_dev);
+		goto add_err;
+	}
+
+	err =3D auxiliary_device_add(&sf_dev->adev);
+	if (err) {
+		put_device(&sf_dev->adev.dev);
+		goto add_err;
+	}
+
+	err =3D xa_insert(&table->devices, sf_index, sf_dev, GFP_KERNEL);
+	if (err)
+		goto xa_err;
+	mutex_unlock(&table->table_lock);
+	return 0;
+
+xa_err:
+	mlx5_sf_dev_remove(sf_dev);
+add_err:
+	mutex_unlock(&table->table_lock);
+	return err;
+}
+
+void mlx5_sf_dev_del(struct mlx5_core_dev *dev, u16 sf_index)
+{
+	struct mlx5_sf_dev_table *table =3D dev->priv.sf_dev_table;
+	struct mlx5_sf_dev *sf_dev;
+
+	mutex_lock(&table->table_lock);
+	sf_dev =3D xa_load(&table->devices, sf_index);
+	if (!sf_dev)
+		goto done;
+
+	xa_erase(&table->devices, sf_index);
+	mlx5_sf_dev_remove(sf_dev);
+done:
+	mutex_unlock(&table->table_lock);
+}
+
+int mlx5_sf_dev_table_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_dev_table *table;
+
+	if (!mlx5_sf_dev_supported(dev))
+		return 0;
+
+	table =3D kzalloc(sizeof(*table), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	mutex_init(&table->table_lock);
+	xa_init(&table->devices);
+	dev->priv.sf_dev_table =3D table;
+	return 0;
+}
+
+void mlx5_sf_dev_table_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_dev_table *table =3D dev->priv.sf_dev_table;
+
+	if (!table)
+		return;
+
+	WARN_ON(!xa_empty(&table->devices));
+	mutex_destroy(&table->table_lock);
+	kfree(table);
+	dev->priv.sf_dev_table =3D NULL;
+}
+
+void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_dev_table *table =3D dev->priv.sf_dev_table;
+	unsigned int max_sfs;
+
+	if (!table)
+		return;
+
+	/* Honor the caps changed during reload */
+	if (!mlx5_sf_dev_supported(dev))
+		return;
+
+	max_sfs =3D 1 << MLX5_CAP_GEN(dev, log_max_sf);
+	table->base_address =3D pci_resource_start(dev->pdev, 2);
+	table->sf_bar_length =3D 1 << (MLX5_CAP_GEN(dev, log_min_sf_size) + 12);
+	mutex_lock(&table->table_lock);
+	table->max_sfs =3D max_sfs;
+	mutex_unlock(&table->table_lock);
+}
+
+static void mlx5_sf_dev_destroy_all(struct mlx5_sf_dev_table *table)
+{
+	struct mlx5_sf_dev *sf_dev;
+	unsigned long index;
+
+	xa_for_each(&table->devices, index, sf_dev) {
+		xa_erase(&table->devices, index);
+		mlx5_sf_dev_remove(sf_dev);
+	}
+}
+
+void mlx5_sf_dev_table_destroy(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_dev_table *table =3D dev->priv.sf_dev_table;
+
+	if (!table)
+		return;
+
+	mutex_lock(&table->table_lock);
+	table->max_sfs =3D 0;
+	mlx5_sf_dev_destroy_all(table);
+	mutex_unlock(&table->table_lock);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h b/drivers=
/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
new file mode 100644
index 000000000000..d81612122a45
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#ifndef __MLX5_SF_DEV_H__
+#define __MLX5_SF_DEV_H__
+
+#ifdef CONFIG_MLX5_SF
+
+#include <linux/auxiliary_bus.h>
+
+#define MLX5_SF_DEV_ID_NAME "sf"
+
+struct mlx5_sf_dev {
+	struct auxiliary_device adev;
+	struct mlx5_core_dev *parent_mdev;
+	phys_addr_t bar_base_addr;
+	u32 sfnum;
+};
+
+void __exit mlx5_sf_dev_exit(void);
+int mlx5_sf_dev_table_init(struct mlx5_core_dev *dev);
+void mlx5_sf_dev_table_cleanup(struct mlx5_core_dev *dev);
+void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev);
+void mlx5_sf_dev_table_destroy(struct mlx5_core_dev *dev);
+
+int mlx5_sf_dev_add(struct mlx5_core_dev *dev, u16 sf_index, u32 sfnum);
+void mlx5_sf_dev_del(struct mlx5_core_dev *dev, u16 sf_index);
+
+#else
+
+static inline void __exit mlx5_sf_dev_exit(void)
+{
+}
+
+static inline int mlx5_sf_dev_table_init(struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
+static inline void mlx5_sf_dev_table_cleanup(struct mlx5_core_dev *dev)
+{
+}
+
+static inline int mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
+static inline void mlx5_sf_dev_table_destroy(struct mlx5_core_dev *dev)
+{
+}
+
+#endif
+
+#endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 28e9b2f17eb9..151cacab07db 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -507,6 +507,7 @@ struct mlx5_devcom;
 struct mlx5_fw_reset;
 struct mlx5_eq_table;
 struct mlx5_irq_table;
+struct mlx5_sf_dev_table;
=20
 struct mlx5_rate_limit {
 	u32			rate;
@@ -603,6 +604,9 @@ struct mlx5_priv {
=20
 	struct mlx5_bfreg_data		bfregs;
 	struct mlx5_uars_page	       *uar;
+#ifdef CONFIG_MLX5_SF
+	struct mlx5_sf_dev_table *sf_dev_table;
+#endif
 };
=20
 enum mlx5_device_state {
--=20
2.26.2

