Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 843FBF343B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389475AbfKGQJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:10 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53489 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389345AbfKGQJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:09 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:03 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4G007213;
        Thu, 7 Nov 2019 18:09:01 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 06/19] net/mlx5: Add support for mediated devices in switchdev mode
Date:   Thu,  7 Nov 2019 10:08:21 -0600
Message-Id: <20191107160834.21087-6-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Implement mdev hooks to create mediated devices using mdev driver.
Actual mlx5_core driver in the host is expected to bind to these devices
using standard device driver model.

Mdev devices are supported only when eswitch mode is OFFLOADS mode.

Mdev devices are created using sysfs file as below example.

$ uuidgen
49d0e9ac-61b8-4c91-957e-6f6dbc42557d

$ echo 49d0e9ac-61b8-4c91-957e-6f6dbc42557d > \
/sys/bus/pci/devices/0000:05:00.0/mdev_supported_types/mlx5_core-local/create

$ echo 49d0e9ac-61b8-4c91-957e-6f6dbc42557d > \
/sys/bus/mdev/drivers/vfio_mdev/unbind

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  17 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   5 +
 .../mellanox/mlx5/core/eswitch_offloads.c     |  14 ++
 .../ethernet/mellanox/mlx5/core/meddev/mdev.c | 203 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/meddev/sf.c   |  22 ++
 .../ethernet/mellanox/mlx5/core/meddev/sf.h   |  18 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  32 +++
 9 files changed, 314 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index b13a0c91662b..34c2c39cc0c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -77,4 +77,4 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 #
 # Mdev basic
 #
-mlx5_core-$(CONFIG_MLX5_MDEV) += meddev/sf.o
+mlx5_core-$(CONFIG_MLX5_MDEV) += meddev/sf.o meddev/mdev.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 50862275544e..2c710fb252f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -334,6 +334,23 @@ struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
 	return res;
 }
 
+struct mlx5_core_dev *mlx5_get_core_dev(const struct device *dev)
+{
+	struct mlx5_core_dev *found = NULL;
+	struct mlx5_core_dev *tmp_dev;
+	struct mlx5_priv *priv;
+
+	mutex_lock(&mlx5_intf_mutex);
+	list_for_each_entry(priv, &mlx5_dev_list, dev_list) {
+		tmp_dev = container_of(priv, struct mlx5_core_dev, priv);
+		if (tmp_dev->device == dev) {
+			found = tmp_dev;
+			break;
+		}
+	}
+	mutex_unlock(&mlx5_intf_mutex);
+	return found;
+}
 
 void mlx5_dev_list_lock(void)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 1c763a5c955c..3cd28dccee12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2153,6 +2153,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	esw->offloads.inline_mode = MLX5_INLINE_MODE_NONE;
 
 	dev->priv.eswitch = esw;
+	mlx5_meddev_init(esw);
 	return 0;
 abort:
 	if (esw->work_queue)
@@ -2170,6 +2171,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 
 	esw_info(esw->dev, "cleanup\n");
 
+	mlx5_meddev_cleanup(esw);
 	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
 	esw_offloads_cleanup_reps(esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 6c2ea3bb39cb..ca7bf362a192 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -224,6 +224,8 @@ enum {
 	MLX5_ESWITCH_VPORT_MATCH_METADATA = BIT(0),
 };
 
+struct mlx5_mdev_table;
+
 struct mlx5_eswitch {
 	struct mlx5_core_dev    *dev;
 	struct mlx5_nb          nb;
@@ -253,6 +255,9 @@ struct mlx5_eswitch {
 	u16                     manager_vport;
 	u16                     first_host_vport;
 	struct mlx5_esw_functions esw_funcs;
+#ifdef CONFIG_MLX5_MDEV
+	struct mlx5_mdev_table *mdev_table;
+#endif
 };
 
 void esw_offloads_disable(struct mlx5_eswitch *esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a6906bff37a3..503cefac300b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2325,8 +2325,15 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	esw_offloads_devcom_init(esw);
 	mutex_init(&esw->offloads.termtbl_mutex);
 
+	err = mlx5_meddev_register(esw);
+	if (err)
+		goto err_meddev;
 	return 0;
 
+err_meddev:
+	mutex_destroy(&esw->offloads.termtbl_mutex);
+	esw_offloads_devcom_cleanup(esw);
+	esw_offloads_unload_all_reps(esw);
 err_reps:
 	mlx5_eswitch_disable_pf_vf_vports(esw);
 err_vports:
@@ -2341,9 +2348,15 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 static int esw_offloads_stop(struct mlx5_eswitch *esw,
 			     struct netlink_ext_ack *extack)
 {
+	bool can_cleanup;
 	int err, err1;
 
+	can_cleanup = mlx5_meddev_can_and_mark_cleanup(esw);
+	if (!can_cleanup)
+		return -EBUSY;
+
 	mlx5_eswitch_disable(esw, false);
+
 	err = mlx5_eswitch_enable(esw, MLX5_ESWITCH_LEGACY);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");
@@ -2359,6 +2372,7 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 
 void esw_offloads_disable(struct mlx5_eswitch *esw)
 {
+	mlx5_meddev_unregister(esw);
 	esw_offloads_devcom_cleanup(esw);
 	esw_offloads_unload_all_reps(esw);
 	mlx5_eswitch_disable_pf_vf_vports(esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev.c b/drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev.c
new file mode 100644
index 000000000000..295932110eff
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Mellanox Technologies
+
+#include <net/devlink.h>
+#include <linux/mdev.h>
+#include <linux/refcount.h>
+
+#include "mlx5_core.h"
+#include "meddev/sf.h"
+#include "eswitch.h"
+
+struct mlx5_mdev_table {
+	struct mlx5_sf_table sf_table;
+	/* Synchronizes with mdev table cleanup check and mdev creation. */
+	struct srcu_struct offloads_srcu;
+	struct mlx5_core_dev *dev;
+};
+
+static ssize_t
+max_mdevs_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct mlx5_core_dev *coredev;
+	struct mlx5_mdev_table *table;
+	u16 max_sfs;
+
+	coredev = pci_get_drvdata(pdev);
+	table = coredev->priv.eswitch->mdev_table;
+	max_sfs = mlx5_core_max_sfs(coredev, &table->sf_table);
+
+	return sprintf(buf, "%d\n", max_sfs);
+}
+static MDEV_TYPE_ATTR_RO(max_mdevs);
+
+static ssize_t
+available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct mlx5_core_dev *coredev;
+	struct mlx5_mdev_table *table;
+	u16 free_sfs;
+
+	coredev = pci_get_drvdata(pdev);
+	table = coredev->priv.eswitch->mdev_table;
+	free_sfs = mlx5_get_free_sfs(coredev, &table->sf_table);
+	return sprintf(buf, "%d\n", free_sfs);
+}
+static MDEV_TYPE_ATTR_RO(available_instances);
+
+static struct attribute *mdev_dev_attrs[] = {
+	&mdev_type_attr_max_mdevs.attr,
+	&mdev_type_attr_available_instances.attr,
+	NULL,
+};
+
+static struct attribute_group mdev_mgmt_group = {
+	.name  = "local",
+	.attrs = mdev_dev_attrs,
+};
+
+static struct attribute_group *mlx5_meddev_groups[] = {
+	&mdev_mgmt_group,
+	NULL,
+};
+
+static int mlx5_meddev_create(struct kobject *kobj, struct mdev_device *meddev)
+{
+	struct mlx5_core_dev *parent_coredev;
+	struct mlx5_mdev_table *table;
+	struct device *parent_dev;
+	struct mlx5_sf *sf;
+	int srcu_key;
+	int ret = 0;
+
+	parent_dev = mdev_parent_dev(meddev);
+	parent_coredev = mlx5_get_core_dev(parent_dev);
+	if (!parent_coredev)
+		return -ENODEV;
+
+	table = parent_coredev->priv.eswitch->mdev_table;
+	/* Publish that mdev creation is in progress, hence wait for it
+	 * to complete, while changing eswitch mode.
+	 */
+	srcu_key = srcu_read_lock(&table->offloads_srcu);
+	if (!srcu_dereference(table->dev, &table->offloads_srcu)) {
+		srcu_read_unlock(&table->offloads_srcu, srcu_key);
+		return -ENODEV;
+	}
+
+	sf = mlx5_sf_alloc(parent_coredev, &table->sf_table, mdev_dev(meddev));
+	if (IS_ERR(sf)) {
+		ret = PTR_ERR(sf);
+		goto sf_err;
+	}
+
+	mdev_set_drvdata(meddev, sf);
+sf_err:
+	srcu_read_unlock(&table->offloads_srcu, srcu_key);
+	return ret;
+}
+
+static int mlx5_meddev_remove(struct mdev_device *meddev)
+{
+	struct mlx5_sf *sf = mdev_get_drvdata(meddev);
+	struct mlx5_core_dev *parent_coredev;
+	struct mlx5_mdev_table *table;
+
+	parent_coredev = pci_get_drvdata(to_pci_dev(mdev_parent_dev(meddev)));
+	table = parent_coredev->priv.eswitch->mdev_table;
+	mlx5_sf_free(parent_coredev, &table->sf_table, sf);
+	return 0;
+}
+
+static const struct mdev_parent_ops mlx5_meddev_ops = {
+	.create = mlx5_meddev_create,
+	.remove = mlx5_meddev_remove,
+	.supported_type_groups = mlx5_meddev_groups,
+};
+
+void mlx5_meddev_init(struct mlx5_eswitch *esw)
+{
+	struct mlx5_mdev_table *table;
+	int ret;
+
+	if (!mlx5_core_is_sf_supported(esw->dev))
+		return;
+
+	table = kzalloc(sizeof(*table), GFP_KERNEL);
+	if (!table)
+		return;
+
+	ret = mlx5_sf_table_init(esw->dev, &table->sf_table);
+	if (ret) {
+		kfree(table);
+		return;
+	}
+
+	init_srcu_struct(&table->offloads_srcu);
+	esw->mdev_table = table;
+}
+
+void mlx5_meddev_cleanup(struct mlx5_eswitch *esw)
+{
+	struct mlx5_mdev_table *table;
+
+	if (!mlx5_core_is_sf_supported(esw->dev))
+		return;
+
+	table = esw->mdev_table;
+	cleanup_srcu_struct(&table->offloads_srcu);
+	mlx5_sf_table_cleanup(esw->dev, &table->sf_table);
+	kfree(table);
+}
+
+int mlx5_meddev_register(struct mlx5_eswitch *esw)
+{
+	if (!esw->mdev_table)
+		return 0;
+
+	rcu_assign_pointer(esw->mdev_table->dev, esw->dev);
+	return mdev_register_device(esw->dev->device, &mlx5_meddev_ops);
+}
+
+void mlx5_meddev_unregister(struct mlx5_eswitch *esw)
+{
+	if (!esw->mdev_table)
+		return;
+
+	rcu_assign_pointer(esw->mdev_table->dev, NULL);
+	synchronize_srcu(&esw->mdev_table->offloads_srcu);
+	/* At this point no new creation can begin, so it is safe to
+	 * unergister with mdev.
+	 */
+	mdev_unregister_device(esw->dev->device);
+}
+
+/* Check if meddev cleanup can be done or not.
+ * If possible to cleanup, mark that cleanup will be in progress
+ * so that no new creation can happen.
+ */
+bool mlx5_meddev_can_and_mark_cleanup(struct mlx5_eswitch *esw)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	struct mlx5_mdev_table *table;
+
+	if (!mlx5_core_is_sf_supported(dev) || !esw->mdev_table)
+		return true;
+
+	table = esw->mdev_table;
+
+	rcu_assign_pointer(esw->mdev_table->dev, NULL);
+	synchronize_srcu(&esw->mdev_table->offloads_srcu);
+
+	if (mlx5_get_free_sfs(esw->dev, &table->sf_table) !=
+	    mlx5_core_max_sfs(esw->dev, &table->sf_table)) {
+		/* There are active SFs for the mdev, so
+		 * revert back.
+		 */
+		rcu_assign_pointer(esw->mdev_table->dev, dev);
+		return false;
+	}
+	return true;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
index fb4ba7be0051..99eb54d345a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
@@ -182,3 +182,25 @@ void mlx5_sf_free(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
 	free_sf_id(sf_table, sf->idx);
 	kfree(sf);
 }
+
+u16 mlx5_get_free_sfs(struct mlx5_core_dev *dev, struct mlx5_sf_table *sf_table)
+{
+	u16 free_sfs = 0;
+
+	if (!mlx5_core_is_sf_supported(dev))
+		return 0;
+
+	mutex_lock(&sf_table->lock);
+	if (sf_table->sf_id_bitmap)
+		free_sfs = sf_table->max_sfs -
+				bitmap_weight(sf_table->sf_id_bitmap,
+					      sf_table->max_sfs);
+	mutex_unlock(&sf_table->lock);
+	return free_sfs;
+}
+
+u16 mlx5_core_max_sfs(const struct mlx5_core_dev *dev,
+		      const struct mlx5_sf_table *sf_table)
+{
+	return mlx5_core_is_sf_supported(dev) ? sf_table->max_sfs : 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
index 1e1ba388504c..526a6795e984 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
@@ -45,6 +45,24 @@ mlx5_sf_alloc(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
 	      struct device *dev);
 void mlx5_sf_free(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
 		  struct mlx5_sf *sf);
+u16 mlx5_core_max_sfs(const struct mlx5_core_dev *dev,
+		      const struct mlx5_sf_table *sf_table);
+u16 mlx5_get_free_sfs(struct mlx5_core_dev *dev,
+		      struct mlx5_sf_table *sf_table);
+
+#else
+static inline u16 mlx5_core_max_sfs(const struct mlx5_core_dev *dev,
+				    const struct mlx5_sf_table *sf_table)
+{
+	return 0;
+}
+
+static inline u16 mlx5_get_free_sfs(struct mlx5_core_dev *dev,
+				    struct mlx5_sf_table *sf_table)
+{
+	return 0;
+}
+
 #endif
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 4e6bdae3ebfa..12e8c2409ee4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -245,4 +245,36 @@ enum {
 
 u8 mlx5_get_nic_state(struct mlx5_core_dev *dev);
 void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state);
+
+#ifdef CONFIG_MLX5_MDEV
+void mlx5_meddev_init(struct mlx5_eswitch *esw);
+void mlx5_meddev_cleanup(struct mlx5_eswitch *esw);
+int mlx5_meddev_register(struct mlx5_eswitch *esw);
+void mlx5_meddev_unregister(struct mlx5_eswitch *esw);
+bool mlx5_meddev_can_and_mark_cleanup(struct mlx5_eswitch *esw);
+#else
+static inline void mlx5_meddev_init(struct mlx5_core_dev *dev)
+{
+}
+
+static inline void mlx5_meddev_cleanup(struct mlx5_core_dev *dev)
+{
+}
+
+static inline int mlx5_meddev_register(struct mlx5_eswitch *esw)
+{
+	return 0;
+}
+
+void mlx5_meddev_unregister(struct mlx5_eswitch *esw)
+{
+}
+
+static inline bool mlx5_meddev_can_and_mark_cleanup(struct mlx5_eswitch *esw)
+{
+	return true;
+}
+#endif
+
+struct mlx5_core_dev *mlx5_get_core_dev(const struct device *dev);
 #endif /* __MLX5_CORE_H__ */
-- 
2.19.2

