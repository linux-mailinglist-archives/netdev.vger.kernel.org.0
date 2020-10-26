Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4064A298BAB
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 12:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773344AbgJZLTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 07:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773329AbgJZLTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 07:19:16 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAE342223C;
        Mon, 26 Oct 2020 11:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603711154;
        bh=bGZX91H8HjCW9EqMer/tb8UcE5qjrvcbvMBsRM8A+qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmRgoIIYR84MtaqGe/IJ0v/U1zuajI2TUKk+kWTAysMws3EC6R24Lcfrq+Qcrd52e
         d684xvGF2+531ZVWu+orrhLFo/G+ZDsusiRm5B0ngHFaJ7VGvSg7lQoRZ+vEqLiqxT
         gJHPsM85DnMLGWFU/1Ok7tTPMuxLsQlm2yx+In2M=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        shiraz.saleem@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH mlx5-next 05/11] net/mlx5: Register mlx5 devices to auxiliary virtual bus
Date:   Mon, 26 Oct 2020 13:18:43 +0200
Message-Id: <20201026111849.1035786-6-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026111849.1035786-1-leon@kernel.org>
References: <20201026111849.1035786-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Create auxiliary devices under new virtual bus. This will replace
the custom-made mlx5 ->add()/->remove() interfaces and next patches
will fill the missing callback and remove the old interface logic.

The attachment of auxiliary drivers to the devices is possible in
1-to-1 manner only and it requires us to create device for every protocol,
so that device (module) will be able to connect to it.

System with 2 IB and 1 RoCE cards:
[leonro@vm ~]$ lspci |grep nox
00:09.0 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5]
00:0a.0 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6]
00:0b.0 Ethernet controller: Mellanox Technologies MT2910 Family [ConnectX-7]
[leonro@vm ~]$ ls -l /sys/bus/auxiliary/devices/
 mlx5_core.eth.2 -> ../../../devices/pci0000:00/0000:00:0b.0/mlx5_core.eth.2
 mlx5_core.rdma.0 -> ../../../devices/pci0000:00/0000:00:09.0/mlx5_core.rdma.0
 mlx5_core.rdma.1 -> ../../../devices/pci0000:00/0000:00:0a.0/mlx5_core.rdma.1
 mlx5_core.rdma.2 -> ../../../devices/pci0000:00/0000:00:0b.0/mlx5_core.rdma.2
[leonro@vm ~]$ rdma dev
0: ibp0s9: node_type ca fw 4.6.9999 node_guid 5254:00c0:fe12:3455 sys_image_guid 5254:00c0:fe12:3455
1: ibp0s10: node_type ca fw 4.6.9999 node_guid 5254:00c0:fe12:3456 sys_image_guid 5254:00c0:fe12:3456
2: rdmap0s11: node_type ca fw 4.6.9999 node_guid 5254:00c0:fe12:3457 sys_image_guid 5254:00c0:fe12:3457

System with RoCE SR-IOV card with 4 VFs:
[leonro@vm ~]$ lspci |grep nox
01:00.0 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6]
01:00.1 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6 Virtual Function]
01:00.2 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6 Virtual Function]
01:00.3 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6 Virtual Function]
01:00.4 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6 Virtual Function]
[leonro@vm ~]$ ls -l /sys/bus/auxiliary/devices/
 mlx5_core.eth.0 -> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.0/mlx5_core.eth.0
 mlx5_core.eth.1 -> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.1/mlx5_core.eth.1
 mlx5_core.eth.2 -> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.2/mlx5_core.eth.2
 mlx5_core.eth.3 -> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.3/mlx5_core.eth.3
 mlx5_core.eth.4 -> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.4/mlx5_core.eth.4
 mlx5_core.rdma.0 -> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.0/mlx5_core.rdma.0
 mlx5_core.rdma.1 -> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.1/mlx5_core.rdma.1
 mlx5_core.rdma.2 -> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.2/mlx5_core.rdma.2
 mlx5_core.rdma.3 -> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.3/mlx5_core.rdma.3
 mlx5_core.rdma.4 -> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.4/mlx5_core.rdma.4
[leonro@vm ~]$ rdma dev
0: rocep1s0f0: node_type ca fw 4.6.9999 node_guid 5254:00c0:fe12:3455 sys_image_guid 5254:00c0:fe12:3455
1: rocep1s0f0v0: node_type ca fw 4.6.9999 node_guid 0000:0000:0000:0000 sys_image_guid 5254:00c0:fe12:3456
2: rocep1s0f0v1: node_type ca fw 4.6.9999 node_guid 0000:0000:0000:0000 sys_image_guid 5254:00c0:fe12:3457
3: rocep1s0f0v2: node_type ca fw 4.6.9999 node_guid 0000:0000:0000:0000 sys_image_guid 5254:00c0:fe12:3458
4: rocep1s0f0v3: node_type ca fw 4.6.9999 node_guid 0000:0000:0000:0000 sys_image_guid 5254:00c0:fe12:3459

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 193 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  13 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  13 +-
 include/linux/mlx5/driver.h                   |  28 ++-
 5 files changed, 239 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 99f1ec3b2575..485478979b1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -6,6 +6,7 @@
 config MLX5_CORE
 	tristate "Mellanox 5th generation network adapters (ConnectX series) core driver"
 	depends on PCI
+	select AUXILIARY_BUS
 	select NET_DEVLINK
 	depends on VXLAN || !VXLAN
 	depends on MLXFW || !MLXFW
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 1972ddd12704..d57b549a358c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -37,6 +37,7 @@ static LIST_HEAD(intf_list);
 static LIST_HEAD(mlx5_dev_list);
 /* intf dev list mutex */
 static DEFINE_MUTEX(mlx5_intf_mutex);
+static DEFINE_IDA(mlx5_adev_ida);

 struct mlx5_device_context {
 	struct list_head	list;
@@ -50,6 +51,36 @@ enum {
 	MLX5_INTERFACE_ATTACHED,
 };

+static const struct mlx5_adev_device {
+	const char *suffix;
+	bool (*is_supported)(struct mlx5_core_dev *dev);
+} mlx5_adev_devices[1] = {};
+
+int mlx5_adev_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_priv *priv = &dev->priv;
+
+	priv->adev = kcalloc(ARRAY_SIZE(mlx5_adev_devices),
+			     sizeof(struct mlx5_adev *), GFP_KERNEL);
+	if (!priv->adev)
+		return -ENOMEM;
+
+	dev->priv.adev_idx = ida_alloc(&mlx5_adev_ida, GFP_KERNEL);
+	if (dev->priv.adev_idx < 0) {
+		kfree(priv->adev);
+		return dev->priv.adev_idx;
+	}
+
+	return 0;
+}
+
+void mlx5_adev_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_priv *priv = &dev->priv;
+
+	ida_free(&mlx5_adev_ida, priv->adev_idx);
+	kfree(priv->adev);
+}

 void mlx5_add_device(struct mlx5_interface *intf, struct mlx5_priv *priv)
 {
@@ -193,16 +224,80 @@ bool mlx5_device_registered(struct mlx5_core_dev *dev)
 	return found;
 }

-void mlx5_register_device(struct mlx5_core_dev *dev)
+static void adev_release(struct device *dev)
+{
+	struct mlx5_adev *mlx5_adev =
+		container_of(dev, struct mlx5_adev, adev.dev);
+	struct mlx5_priv *priv = &mlx5_adev->mdev->priv;
+	int idx = mlx5_adev->idx;
+
+	kfree(mlx5_adev);
+	priv->adev[idx] = NULL;
+}
+
+static struct mlx5_adev *add_adev(struct mlx5_core_dev *dev, int idx)
+{
+	const char *suffix = mlx5_adev_devices[idx].suffix;
+	struct auxiliary_device *adev;
+	struct mlx5_adev *madev;
+	int ret;
+
+	madev = kzalloc(sizeof(*madev), GFP_KERNEL);
+	if (!madev)
+		return ERR_PTR(-ENOMEM);
+
+	adev = &madev->adev;
+	adev->id = dev->priv.adev_idx;
+	adev->name = suffix;
+	adev->dev.parent = dev->device;
+	adev->dev.release = adev_release;
+	madev->mdev = dev;
+	madev->idx = idx;
+
+	ret = auxiliary_device_init(adev);
+	if (ret) {
+		kfree(madev);
+		return ERR_PTR(ret);
+	}
+
+	ret = auxiliary_device_add(adev);
+	if (ret) {
+		auxiliary_device_uninit(adev);
+		return ERR_PTR(ret);
+	}
+	return madev;
+}
+
+static void del_adev(struct auxiliary_device *adev)
+{
+	auxiliary_device_delete(adev);
+	auxiliary_device_uninit(adev);
+}
+
+int mlx5_register_device(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
 	struct mlx5_interface *intf;
+	int ret;
+
+	mutex_lock(&mlx5_intf_mutex);
+	dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
+	ret = _mlx5_rescan_drivers(dev);
+	mutex_unlock(&mlx5_intf_mutex);
+	if (ret)
+		goto add_err;

 	mutex_lock(&mlx5_intf_mutex);
 	list_add_tail(&priv->dev_list, &mlx5_dev_list);
 	list_for_each_entry(intf, &intf_list, list)
 		mlx5_add_device(intf, priv);
 	mutex_unlock(&mlx5_intf_mutex);
+
+	return 0;
+
+add_err:
+	mlx5_unregister_device(dev);
+	return ret;
 }

 void mlx5_unregister_device(struct mlx5_core_dev *dev)
@@ -214,6 +309,9 @@ void mlx5_unregister_device(struct mlx5_core_dev *dev)
 	list_for_each_entry_reverse(intf, &intf_list, list)
 		mlx5_remove_device(intf, priv);
 	list_del(&priv->dev_list);
+
+	dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
+	_mlx5_rescan_drivers(dev);
 	mutex_unlock(&mlx5_intf_mutex);
 }

@@ -246,6 +344,63 @@ void mlx5_unregister_interface(struct mlx5_interface *intf)
 }
 EXPORT_SYMBOL(mlx5_unregister_interface);

+/* This function is used after mlx5_core_dev is reconfigured.
+ */
+int _mlx5_rescan_drivers(struct mlx5_core_dev *dev)
+{
+	struct mlx5_priv *priv = &dev->priv;
+	bool delete_all;
+	int i, ret = 0;
+
+	lockdep_assert_held(&mlx5_intf_mutex);
+
+	delete_all = priv->flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
+
+	for (i = ARRAY_SIZE(mlx5_adev_devices) - 1; i >= 0; i--) {
+		bool is_supported = false;
+
+		if (!priv->adev[i])
+			continue;
+
+		if (mlx5_adev_devices[i].is_supported && !delete_all)
+			is_supported = mlx5_adev_devices[i].is_supported(dev);
+
+		if (is_supported)
+			continue;
+
+		del_adev(&priv->adev[i]->adev);
+		priv->adev[i] = NULL;
+	}
+
+	if (delete_all)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(mlx5_adev_devices); i++) {
+		bool is_supported = false;
+
+		if (priv->adev[i])
+			continue;
+
+		if (mlx5_adev_devices[i].is_supported)
+			is_supported = mlx5_adev_devices[i].is_supported(dev);
+
+		if (!is_supported)
+			continue;
+
+		priv->adev[i] = add_adev(dev, i);
+		if (IS_ERR(priv->adev[i])) {
+			mlx5_core_warn(dev, "Device[%d] (%s) failed to load\n",
+				       i, mlx5_adev_devices[i].suffix);
+			/* We continue to rescan drivers and leave to the caller
+			 * to make decision if to release everything or continue.
+			 */
+			ret = PTR_ERR(priv->adev[i]);
+			priv->adev[i] = NULL;
+		}
+	}
+	return ret;
+}
+
 /* Must be called with intf_mutex held */
 static bool mlx5_has_added_dev_by_protocol(struct mlx5_core_dev *mdev, int protocol)
 {
@@ -299,24 +454,55 @@ void mlx5_remove_dev_by_protocol(struct mlx5_core_dev *dev, int protocol)
 		}
 }

-static u32 mlx5_gen_pci_id(struct mlx5_core_dev *dev)
+static u32 mlx5_gen_pci_id(const struct mlx5_core_dev *dev)
 {
 	return (u32)((pci_domain_nr(dev->pdev->bus) << 16) |
 		     (dev->pdev->bus->number << 8) |
 		     PCI_SLOT(dev->pdev->devfn));
 }

-/* Must be called with intf_mutex held */
+static int next_phys_dev(struct device *dev, const void *data)
+{
+	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
+	struct mlx5_core_dev *mdev = madev->mdev;
+	const struct mlx5_core_dev *curr = data;
+
+	if (!mlx5_core_is_pf(mdev))
+		return 0;
+
+	if (mdev == curr)
+		return 0;
+
+	if (mlx5_gen_pci_id(mdev) != mlx5_gen_pci_id(curr))
+		return 0;
+
+	return 1;
+}
+
+/* This function is called with two flows:
+ * 1. During initialization of mlx5_core_dev and we don't need to lock it.
+ * 2. During LAG configure stage and caller holds &mlx5_intf_mutex.
+ */
 struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_dev *res = NULL;
 	struct mlx5_core_dev *tmp_dev;
+	struct auxiliary_device *adev;
+	struct mlx5_adev *madev;
 	struct mlx5_priv *priv;
 	u32 pci_id;

 	if (!mlx5_core_is_pf(dev))
 		return NULL;

+	adev = auxiliary_find_device(NULL, dev, &next_phys_dev);
+	if (adev) {
+		madev = container_of(adev, struct mlx5_adev, adev);
+
+		put_device(&adev->dev);
+		return madev->mdev;
+	}
+
 	pci_id = mlx5_gen_pci_id(dev);
 	list_for_each_entry(priv, &mlx5_dev_list, dev_list) {
 		tmp_dev = container_of(priv, struct mlx5_core_dev, priv);
@@ -332,7 +518,6 @@ struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
 	return res;
 }

-
 void mlx5_dev_list_lock(void)
 {
 	mutex_lock(&mlx5_intf_mutex);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 9827127cb674..b56a3c956283 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1222,7 +1222,9 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 		err = mlx5_devlink_register(priv_to_devlink(dev), dev->device);
 		if (err)
 			goto err_devlink_reg;
-		mlx5_register_device(dev);
+		err = mlx5_register_device(dev);
+		if (err)
+			goto err_register;
 	} else {
 		mlx5_attach_device(dev);
 	}
@@ -1230,6 +1232,8 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 	mutex_unlock(&dev->intf_state_mutex);
 	return 0;

+err_register:
+	mlx5_devlink_unregister(priv_to_devlink(dev));
 err_devlink_reg:
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
@@ -1306,8 +1310,14 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	if (err)
 		goto err_pagealloc_init;

+	err = mlx5_adev_init(dev);
+	if (err)
+		goto err_adev_init;
+
 	return 0;

+err_adev_init:
+	mlx5_pagealloc_cleanup(dev);
 err_pagealloc_init:
 	mlx5_health_cleanup(dev);
 err_health_init:
@@ -1324,6 +1334,7 @@ static void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;

+	mlx5_adev_cleanup(dev);
 	mlx5_pagealloc_cleanup(dev);
 	mlx5_health_cleanup(dev);
 	debugfs_remove_recursive(dev->priv.dbg_root);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index b285f1515e4e..3bb7e5606d75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -183,7 +183,7 @@ void mlx5_remove_device(struct mlx5_interface *intf, struct mlx5_priv *priv);
 void mlx5_attach_device(struct mlx5_core_dev *dev);
 void mlx5_detach_device(struct mlx5_core_dev *dev);
 bool mlx5_device_registered(struct mlx5_core_dev *dev);
-void mlx5_register_device(struct mlx5_core_dev *dev);
+int mlx5_register_device(struct mlx5_core_dev *dev);
 void mlx5_unregister_device(struct mlx5_core_dev *dev);
 void mlx5_add_dev_by_protocol(struct mlx5_core_dev *dev, int protocol);
 void mlx5_remove_dev_by_protocol(struct mlx5_core_dev *dev, int protocol);
@@ -232,6 +232,17 @@ static inline int mlx5_lag_is_lacp_owner(struct mlx5_core_dev *dev)
 		    MLX5_CAP_GEN(dev, lag_master);
 }

+int _mlx5_rescan_drivers(struct mlx5_core_dev *dev);
+static inline int mlx5_rescan_drivers(struct mlx5_core_dev *dev)
+{
+	int ret;
+
+	mlx5_dev_list_lock();
+	ret = _mlx5_rescan_drivers(dev);
+	mlx5_dev_list_unlock();
+	return ret;
+}
+
 void mlx5_reload_interface(struct mlx5_core_dev *mdev, int protocol);
 void mlx5_lag_update(struct mlx5_core_dev *dev);

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index ed1d030658d2..b113023d242e 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -48,6 +48,7 @@
 #include <linux/idr.h>
 #include <linux/notifier.h>
 #include <linux/refcount.h>
+#include <linux/auxiliary_bus.h>

 #include <linux/mlx5/device.h>
 #include <linux/mlx5/doorbell.h>
@@ -536,6 +537,17 @@ struct mlx5_core_roce {
 	struct mlx5_flow_handle *allow_rule;
 };

+enum {
+	MLX5_PRIV_FLAGS_DISABLE_IB_ADEV = 1 << 0,
+	MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV = 1 << 1,
+};
+
+struct mlx5_adev {
+	struct auxiliary_device adev;
+	struct mlx5_core_dev *mdev;
+	int idx;
+};
+
 struct mlx5_priv {
 	/* IRQ table valid only for real pci devices PF or VF */
 	struct mlx5_irq_table   *irq_table;
@@ -573,6 +585,8 @@ struct mlx5_priv {
 	struct list_head        dev_list;
 	struct list_head        ctx_list;
 	spinlock_t              ctx_lock;
+	struct mlx5_adev       **adev;
+	int			adev_idx;
 	struct mlx5_events      *events;

 	struct mlx5_flow_steering *steering;
@@ -580,6 +594,7 @@ struct mlx5_priv {
 	struct mlx5_eswitch     *eswitch;
 	struct mlx5_core_sriov	sriov;
 	struct mlx5_lag		*lag;
+	u32			flags;
 	struct mlx5_devcom	*devcom;
 	struct mlx5_fw_reset	*fw_reset;
 	struct mlx5_core_roce	roce;
@@ -947,6 +962,8 @@ int mlx5_cmd_free_uar(struct mlx5_core_dev *dev, u32 uarn);
 void mlx5_health_flush(struct mlx5_core_dev *dev);
 void mlx5_health_cleanup(struct mlx5_core_dev *dev);
 int mlx5_health_init(struct mlx5_core_dev *dev);
+void mlx5_adev_cleanup(struct mlx5_core_dev *dev);
+int mlx5_adev_init(struct mlx5_core_dev *dev);
 void mlx5_start_health_poll(struct mlx5_core_dev *dev);
 void mlx5_stop_health_poll(struct mlx5_core_dev *dev, bool disable_health);
 void mlx5_drain_health_wq(struct mlx5_core_dev *dev);
@@ -1063,9 +1080,14 @@ enum {
 };

 enum {
-	MLX5_INTERFACE_PROTOCOL_IB  = 0,
-	MLX5_INTERFACE_PROTOCOL_ETH = 1,
-	MLX5_INTERFACE_PROTOCOL_VDPA = 2,
+	MLX5_INTERFACE_PROTOCOL_ETH_REP,
+	MLX5_INTERFACE_PROTOCOL_ETH,
+
+	MLX5_INTERFACE_PROTOCOL_IB_REP,
+	MLX5_INTERFACE_PROTOCOL_MPIB,
+	MLX5_INTERFACE_PROTOCOL_IB,
+
+	MLX5_INTERFACE_PROTOCOL_VDPA,
 };

 struct mlx5_interface {
--
2.26.2

