Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F0C2FAB49
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437978AbhARUQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:16:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394273AbhARUOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 15:14:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FA69230FA;
        Mon, 18 Jan 2021 20:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611000772;
        bh=6zzHwhx2gA99CSu4CUOlz7dq+/h5z8gCbSLJ1mCXi9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WL585bDjzDT/el+WY/l+B21MxStRXN4FY7JV7ov/x0unXfgjlamE0+kxtmSRXEzOB
         IcKvL47m8IAETx/amTOIp8u8WzVAAy+k7v/lXCnX+U87l/YwwwT6MW9UldnNejM9Qy
         Poa5GUYwyAktm3DEBNAPpxn0wJjddSKXqPY9ABG6TXPriees3gMGnKPSfabzUrMP2T
         fae+fizDO0edILXbqIAbD1UXrjBm/rJZ/8eb3wgoCKKEC+2p5X+CmNMulAh3HQB6J8
         7nBeWMKScvAWYRoplDxly4Xp0C4iSjit8J+mRaro8GVhoUxn62AutbmjccA8PzzObF
         AomyTgC7pCEVw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V7 06/14] net/mlx5: SF, Add auxiliary device support
Date:   Mon, 18 Jan 2021 12:12:23 -0800
Message-Id: <20210118201231.363126-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210118201231.363126-1-saeed@kernel.org>
References: <20210118201231.363126-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

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
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 splittable false

$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

$ devlink port show ens2f0npf0sf88
pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
  function:
    hw_addr 00:00:00:00:88:88 state inactive opstate detached

$ devlink port function set ens2f0npf0sf88 hw_addr 00:00:00:00:88:88 state active

On activation,

$ ls -l /sys/bus/auxiliary/devices/
mlx5_core.sf.4 -> ../../../devices/pci0000:00/0000:00:03.0/0000:06:00.0/mlx5_core.sf.4

$ cat /sys/bus/auxiliary/devices/mlx5_core.sf.4/sfnum
88

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |   5 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   4 +
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 265 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.h  |  35 +++
 include/linux/mlx5/driver.h                   |   2 +
 6 files changed, 312 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index e9b65035cd47..a5eb22793bb9 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -97,6 +97,11 @@ Enabling the driver and kconfig options
 
 |   Provides low-level InfiniBand/RDMA and `RoCE <https://community.mellanox.com/s/article/recommended-network-configuration-examples-for-roce-deployment>`_ support.
 
+**CONFIG_MLX5_SF=(y/n)**
+
+|   Build support for subfunction.
+|   Subfunctons are more light weight than PCI SRIOV VFs. Choosing this option
+|   will enable support for creating subfunction devices.
 
 **External options** ( Choose if the corresponding mlx5 feature is required )
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 22ef2ebbee96..f5b2e9101348 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -89,4 +89,4 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 #
 # SF device
 #
-mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o
+mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o sf/dev/dev.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index b16f57befe52..26b5502712a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -74,6 +74,7 @@
 #include "lib/hv_vhca.h"
 #include "diag/rsc_dump.h"
 #include "sf/vhca_event.h"
+#include "sf/dev/dev.h"
 
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
 MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX series) core driver");
@@ -1155,6 +1156,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 		goto err_sriov;
 	}
 
+	mlx5_sf_dev_table_create(dev);
+
 	return 0;
 
 err_sriov:
@@ -1186,6 +1189,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 static void mlx5_unload(struct mlx5_core_dev *dev)
 {
+	mlx5_sf_dev_table_destroy(dev);
 	mlx5_sriov_detach(dev);
 	mlx5_ec_cleanup(dev);
 	mlx5_vhca_event_stop(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
new file mode 100644
index 000000000000..4a8eeb7c853e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -0,0 +1,265 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/device.h>
+#include "mlx5_core.h"
+#include "dev.h"
+#include "sf/vhca_event.h"
+#include "sf/sf.h"
+#include "sf/mlx5_ifc_vhca_event.h"
+#include "ecpf.h"
+
+struct mlx5_sf_dev_table {
+	struct xarray devices;
+	unsigned int max_sfs;
+	phys_addr_t base_address;
+	u64 sf_bar_length;
+	struct notifier_block nb;
+	struct mlx5_core_dev *dev;
+};
+
+static bool mlx5_sf_dev_supported(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN(dev, sf) && mlx5_vhca_event_supported(dev);
+}
+
+static ssize_t sfnum_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct auxiliary_device *adev = container_of(dev, struct auxiliary_device, dev);
+	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", sf_dev->sfnum);
+}
+static DEVICE_ATTR_RO(sfnum);
+
+static struct attribute *sf_device_attrs[] = {
+	&dev_attr_sfnum.attr,
+	NULL,
+};
+
+static const struct attribute_group sf_attr_group = {
+	.attrs = sf_device_attrs,
+};
+
+static const struct attribute_group *sf_attr_groups[2] = {
+	&sf_attr_group,
+	NULL
+};
+
+static void mlx5_sf_dev_release(struct device *device)
+{
+	struct auxiliary_device *adev = container_of(device, struct auxiliary_device, dev);
+	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
+
+	mlx5_adev_idx_free(adev->id);
+	kfree(sf_dev);
+}
+
+static void mlx5_sf_dev_remove(struct mlx5_sf_dev *sf_dev)
+{
+	auxiliary_device_delete(&sf_dev->adev);
+	auxiliary_device_uninit(&sf_dev->adev);
+}
+
+static void mlx5_sf_dev_add(struct mlx5_core_dev *dev, u16 sf_index, u32 sfnum)
+{
+	struct mlx5_sf_dev_table *table = dev->priv.sf_dev_table;
+	struct mlx5_sf_dev *sf_dev;
+	struct pci_dev *pdev;
+	int err;
+	int id;
+
+	id = mlx5_adev_idx_alloc();
+	if (id < 0) {
+		err = id;
+		goto add_err;
+	}
+
+	sf_dev = kzalloc(sizeof(*sf_dev), GFP_KERNEL);
+	if (!sf_dev) {
+		mlx5_adev_idx_free(id);
+		err = -ENOMEM;
+		goto add_err;
+	}
+	pdev = dev->pdev;
+	sf_dev->adev.id = id;
+	sf_dev->adev.name = MLX5_SF_DEV_ID_NAME;
+	sf_dev->adev.dev.release = mlx5_sf_dev_release;
+	sf_dev->adev.dev.parent = &pdev->dev;
+	sf_dev->adev.dev.groups = sf_attr_groups;
+	sf_dev->sfnum = sfnum;
+	sf_dev->parent_mdev = dev;
+
+	if (!table->max_sfs) {
+		mlx5_adev_idx_free(id);
+		kfree(sf_dev);
+		err = -EOPNOTSUPP;
+		goto add_err;
+	}
+	sf_dev->bar_base_addr = table->base_address + (sf_index * table->sf_bar_length);
+
+	err = auxiliary_device_init(&sf_dev->adev);
+	if (err) {
+		mlx5_adev_idx_free(id);
+		kfree(sf_dev);
+		goto add_err;
+	}
+
+	err = auxiliary_device_add(&sf_dev->adev);
+	if (err) {
+		put_device(&sf_dev->adev.dev);
+		goto add_err;
+	}
+
+	err = xa_insert(&table->devices, sf_index, sf_dev, GFP_KERNEL);
+	if (err)
+		goto xa_err;
+	return;
+
+xa_err:
+	mlx5_sf_dev_remove(sf_dev);
+add_err:
+	mlx5_core_err(dev, "SF DEV: fail device add for index=%d sfnum=%d err=%d\n",
+		      sf_index, sfnum, err);
+}
+
+static void mlx5_sf_dev_del(struct mlx5_core_dev *dev, struct mlx5_sf_dev *sf_dev, u16 sf_index)
+{
+	struct mlx5_sf_dev_table *table = dev->priv.sf_dev_table;
+
+	xa_erase(&table->devices, sf_index);
+	mlx5_sf_dev_remove(sf_dev);
+}
+
+static int
+mlx5_sf_dev_state_change_handler(struct notifier_block *nb, unsigned long event_code, void *data)
+{
+	struct mlx5_sf_dev_table *table = container_of(nb, struct mlx5_sf_dev_table, nb);
+	const struct mlx5_vhca_state_event *event = data;
+	struct mlx5_sf_dev *sf_dev;
+	u16 sf_index;
+
+	sf_index = event->function_id - MLX5_CAP_GEN(table->dev, sf_base_id);
+	sf_dev = xa_load(&table->devices, sf_index);
+	switch (event->new_vhca_state) {
+	case MLX5_VHCA_STATE_ALLOCATED:
+		if (sf_dev)
+			mlx5_sf_dev_del(table->dev, sf_dev, sf_index);
+		break;
+	case MLX5_VHCA_STATE_TEARDOWN_REQUEST:
+		if (sf_dev)
+			mlx5_sf_dev_del(table->dev, sf_dev, sf_index);
+		else
+			mlx5_core_err(table->dev,
+				      "SF DEV: teardown state for invalid dev index=%d fn_id=0x%x\n",
+				      sf_index, event->sw_function_id);
+		break;
+	case MLX5_VHCA_STATE_ACTIVE:
+		if (!sf_dev)
+			mlx5_sf_dev_add(table->dev, sf_index, event->sw_function_id);
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static int mlx5_sf_dev_vhca_arm_all(struct mlx5_sf_dev_table *table)
+{
+	struct mlx5_core_dev *dev = table->dev;
+	u16 max_functions;
+	u16 function_id;
+	int err = 0;
+	bool ecpu;
+	int i;
+
+	max_functions = mlx5_sf_max_functions(dev);
+	function_id = MLX5_CAP_GEN(dev, sf_base_id);
+	ecpu = mlx5_read_embedded_cpu(dev);
+	/* Arm the vhca context as the vhca event notifier */
+	for (i = 0; i < max_functions; i++) {
+		err = mlx5_vhca_event_arm(dev, function_id, ecpu);
+		if (err)
+			return err;
+
+		function_id++;
+	}
+	return 0;
+}
+
+void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
+{
+	struct mlx5_sf_dev_table *table;
+	unsigned int max_sfs;
+	int err;
+
+	if (!mlx5_sf_dev_supported(dev) || !mlx5_vhca_event_supported(dev))
+		return;
+
+	table = kzalloc(sizeof(*table), GFP_KERNEL);
+	if (!table) {
+		err = -ENOMEM;
+		goto table_err;
+	}
+
+	table->nb.notifier_call = mlx5_sf_dev_state_change_handler;
+	table->dev = dev;
+	if (MLX5_CAP_GEN(dev, max_num_sf))
+		max_sfs = MLX5_CAP_GEN(dev, max_num_sf);
+	else
+		max_sfs = 1 << MLX5_CAP_GEN(dev, log_max_sf);
+	table->sf_bar_length = 1 << (MLX5_CAP_GEN(dev, log_min_sf_size) + 12);
+	table->base_address = pci_resource_start(dev->pdev, 2);
+	table->max_sfs = max_sfs;
+	xa_init(&table->devices);
+	dev->priv.sf_dev_table = table;
+
+	err = mlx5_vhca_event_notifier_register(dev, &table->nb);
+	if (err)
+		goto vhca_err;
+	err = mlx5_sf_dev_vhca_arm_all(table);
+	if (err)
+		goto arm_err;
+	mlx5_core_dbg(dev, "SF DEV: max sf devices=%d\n", max_sfs);
+	return;
+
+arm_err:
+	mlx5_vhca_event_notifier_unregister(dev, &table->nb);
+vhca_err:
+	table->max_sfs = 0;
+	kfree(table);
+	dev->priv.sf_dev_table = NULL;
+table_err:
+	mlx5_core_err(dev, "SF DEV table create err = %d\n", err);
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
+	struct mlx5_sf_dev_table *table = dev->priv.sf_dev_table;
+
+	if (!table)
+		return;
+
+	mlx5_vhca_event_notifier_unregister(dev, &table->nb);
+
+	/* Now that event handler is not running, it is safe to destroy
+	 * the sf device without race.
+	 */
+	mlx5_sf_dev_destroy_all(table);
+
+	WARN_ON(!xa_empty(&table->devices));
+	kfree(table);
+	dev->priv.sf_dev_table = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
new file mode 100644
index 000000000000..a6fb7289ba2c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
@@ -0,0 +1,35 @@
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
+void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev);
+void mlx5_sf_dev_table_destroy(struct mlx5_core_dev *dev);
+
+#else
+
+static inline void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
+{
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
index ffba0786051e..08e5fbe97df0 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -508,6 +508,7 @@ struct mlx5_fw_reset;
 struct mlx5_eq_table;
 struct mlx5_irq_table;
 struct mlx5_vhca_state_notifier;
+struct mlx5_sf_dev_table;
 
 struct mlx5_rate_limit {
 	u32			rate;
@@ -606,6 +607,7 @@ struct mlx5_priv {
 	struct mlx5_uars_page	       *uar;
 #ifdef CONFIG_MLX5_SF
 	struct mlx5_vhca_state_notifier *vhca_state_notifier;
+	struct mlx5_sf_dev_table *sf_dev_table;
 #endif
 };
 
-- 
2.26.2

