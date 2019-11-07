Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E426F3433
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389369AbfKGQJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:04 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53464 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389345AbfKGQJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:04 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:08:58 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4E007213;
        Thu, 7 Nov 2019 18:08:55 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH net-next 04/19] net/mlx5: Introduce SF life cycle APIs to allocate/free
Date:   Thu,  7 Nov 2019 10:08:19 -0600
Message-Id: <20191107160834.21087-4-parav@mellanox.com>
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

Introduce SF life cycle APIs to allocate, deallocate it at device
level.
Make use of low level device life cycle APIs and provide higher level
API for a usable SF creation/deletion.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   4 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  43 +++++--
 .../ethernet/mellanox/mlx5/core/meddev/sf.c   | 116 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/meddev/sf.h   |  18 +++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 5 files changed, 172 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index e9a326939f5e..3f1a9a73b25f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -317,6 +317,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_DEALLOC_MEMIC:
 	case MLX5_CMD_OP_PAGE_FAULT_RESUME:
 	case MLX5_CMD_OP_QUERY_ESW_FUNCTIONS:
+	case MLX5_CMD_OP_DEALLOC_SF:
 		return MLX5_CMD_STAT_OK;
 
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
@@ -449,6 +450,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_MODIFY_XRQ:
 	case MLX5_CMD_OP_RELEASE_XRQ_ERROR:
 	case MLX5_CMD_OP_QUERY_SF_PARTITION:
+	case MLX5_CMD_OP_ALLOC_SF:
 		*status = MLX5_DRIVER_STATUS_ABORTED;
 		*synd = MLX5_DRIVER_SYND;
 		return -EIO;
@@ -476,6 +478,8 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(SET_ISSI);
 	MLX5_COMMAND_STR_CASE(SET_DRIVER_VERSION);
 	MLX5_COMMAND_STR_CASE(QUERY_SF_PARTITION);
+	MLX5_COMMAND_STR_CASE(ALLOC_SF);
+	MLX5_COMMAND_STR_CASE(DEALLOC_SF);
 	MLX5_COMMAND_STR_CASE(CREATE_MKEY);
 	MLX5_COMMAND_STR_CASE(QUERY_MKEY);
 	MLX5_COMMAND_STR_CASE(DESTROY_MKEY);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 174ade250f62..092e2c90caf1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -644,30 +644,53 @@ static int mlx5_core_set_hca_defaults(struct mlx5_core_dev *dev)
 	return ret;
 }
 
-int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id)
+static int enable_hca(struct mlx5_core_dev *dev, u16 func_id, bool ecpu)
 {
-	u32 out[MLX5_ST_SZ_DW(enable_hca_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(enable_hca_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(enable_hca_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(enable_hca_in)] = {};
 
 	MLX5_SET(enable_hca_in, in, opcode, MLX5_CMD_OP_ENABLE_HCA);
 	MLX5_SET(enable_hca_in, in, function_id, func_id);
-	MLX5_SET(enable_hca_in, in, embedded_cpu_function,
-		 dev->caps.embedded_cpu);
+	MLX5_SET(enable_hca_in, in, embedded_cpu_function, ecpu);
 	return mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
 }
 
-int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id)
+int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id)
 {
-	u32 out[MLX5_ST_SZ_DW(disable_hca_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(disable_hca_in)]   = {0};
+	return enable_hca(dev, func_id, dev->caps.embedded_cpu);
+}
+
+int mlx5_core_enable_sf_hca(struct mlx5_core_dev *dev, u16 sf_func_id)
+{
+	/* When enabling SF, it doesn't matter if is enabled on ECPF or PF,
+	 * embedded_cpu bit must be cleared as expected by device firmware.
+	 * SF function ids are split between ECPF And PF. A given SF is for
+	 * ECPF or for PF is decided by SF's function id by the firmware.
+	 */
+	return enable_hca(dev, sf_func_id, 0);
+}
+
+static int disable_hca(struct mlx5_core_dev *dev, u16 func_id, bool ecpu)
+{
+	u32 out[MLX5_ST_SZ_DW(disable_hca_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(disable_hca_in)] = {};
 
 	MLX5_SET(disable_hca_in, in, opcode, MLX5_CMD_OP_DISABLE_HCA);
 	MLX5_SET(disable_hca_in, in, function_id, func_id);
-	MLX5_SET(enable_hca_in, in, embedded_cpu_function,
-		 dev->caps.embedded_cpu);
+	MLX5_SET(enable_hca_in, in, embedded_cpu_function, ecpu);
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
+int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id)
+{
+	return disable_hca(dev, func_id, dev->caps.embedded_cpu);
+}
+
+int mlx5_core_disable_sf_hca(struct mlx5_core_dev *dev, u16 sf_func_id)
+{
+	return disable_hca(dev, sf_func_id, 0);
+}
+
 u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev,
 			     struct ptp_system_timestamp *sts)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
index 3324cc53efe3..d57109a9c53b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
@@ -3,6 +3,8 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/io-mapping.h>
+#include <linux/bitmap.h>
 #include "sf.h"
 #include "mlx5_core.h"
 
@@ -31,7 +33,6 @@ int mlx5_sf_table_init(struct mlx5_core_dev *dev,
 	if (!out)
 		return -ENOMEM;
 
-	mutex_init(&sf_table->lock);
 	/* SFs BAR is implemented in PCI BAR2 */
 	sf_table->base_address = pci_resource_start(dev->pdev, 2);
 
@@ -46,6 +47,13 @@ int mlx5_sf_table_init(struct mlx5_core_dev *dev,
 	sf_table->log_sf_bar_size =
 		MLX5_GET(sf_partition, sf_parts, log_sf_bar_size);
 
+	sf_table->sf_id_bitmap = bitmap_zalloc(sf_table->max_sfs, GFP_KERNEL);
+	if (!sf_table->sf_id_bitmap) {
+		err = -ENOMEM;
+		goto free_outmem;
+	}
+	mutex_init(&sf_table->lock);
+
 	mlx5_core_dbg(dev, "supported partitions(%d)\n", n_support);
 	mlx5_core_dbg(dev, "SF_part(0) log_num_sf(%d) log_sf_bar_size(%d)\n",
 		      sf_table->max_sfs, sf_table->log_sf_bar_size);
@@ -59,4 +67,110 @@ void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev,
 			   struct mlx5_sf_table *sf_table)
 {
 	mutex_destroy(&sf_table->lock);
+	bitmap_free(sf_table->sf_id_bitmap);
+}
+
+static int mlx5_cmd_alloc_sf(struct mlx5_core_dev *mdev, u16 function_id)
+{
+	u32 out[MLX5_ST_SZ_DW(alloc_sf_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(alloc_sf_in)] = {};
+
+	MLX5_SET(alloc_sf_in, in, opcode, MLX5_CMD_OP_ALLOC_SF);
+	MLX5_SET(alloc_sf_in, in, function_id, function_id);
+
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+static int mlx5_cmd_dealloc_sf(struct mlx5_core_dev *mdev, u16 function_id)
+{
+	u32 out[MLX5_ST_SZ_DW(dealloc_sf_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(dealloc_sf_in)] = {};
+
+	MLX5_SET(dealloc_sf_in, in, opcode, MLX5_CMD_OP_DEALLOC_SF);
+	MLX5_SET(dealloc_sf_in, in, function_id, function_id);
+
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+static int alloc_sf_id(struct mlx5_sf_table *sf_table, u16 *sf_id)
+{
+	int ret = 0;
+	u16 idx;
+
+	mutex_lock(&sf_table->lock);
+	idx = find_first_zero_bit(sf_table->sf_id_bitmap, sf_table->max_sfs);
+	if (idx == sf_table->max_sfs) {
+		ret = -ENOSPC;
+		goto done;
+	}
+	bitmap_set(sf_table->sf_id_bitmap, idx, 1);
+	*sf_id = idx;
+done:
+	mutex_unlock(&sf_table->lock);
+	return ret;
+}
+
+static void free_sf_id(struct mlx5_sf_table *sf_table, u16 sf_id)
+{
+	mutex_lock(&sf_table->lock);
+	bitmap_clear(sf_table->sf_id_bitmap, sf_id, 1);
+	mutex_unlock(&sf_table->lock);
+}
+
+static u16 mlx5_sf_hw_id(const struct mlx5_core_dev *coredev, u16 sf_id)
+{
+	return mlx5_sf_base_id(coredev) + sf_id;
+}
+
+/* Perform SF allocation using parent device BAR. */
+struct mlx5_sf *
+mlx5_sf_alloc(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
+	      struct device *dev)
+{
+	struct mlx5_sf *sf;
+	u16 hw_function_id;
+	u16 sf_id;
+	int ret;
+
+	sf = kzalloc(sizeof(*sf), GFP_KERNEL);
+	if (!sf)
+		return ERR_PTR(-ENOMEM);
+
+	ret = alloc_sf_id(sf_table, &sf_id);
+	if (ret)
+		goto id_err;
+
+	hw_function_id = mlx5_sf_hw_id(coredev, sf_id);
+	ret = mlx5_cmd_alloc_sf(coredev, hw_function_id);
+	if (ret)
+		goto alloc_sf_err;
+
+	ret = mlx5_core_enable_sf_hca(coredev, hw_function_id);
+	if (ret)
+		goto enable_err;
+
+	sf->idx = sf_id;
+	sf->base_addr = sf_table->base_address +
+				(sf->idx << (sf_table->log_sf_bar_size + 12));
+	return sf;
+
+enable_err:
+	mlx5_cmd_dealloc_sf(coredev, hw_function_id);
+alloc_sf_err:
+	free_sf_id(sf_table, sf_id);
+id_err:
+	kfree(sf);
+	return ERR_PTR(ret);
+}
+
+void mlx5_sf_free(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
+		  struct mlx5_sf *sf)
+{
+	u16 hw_function_id;
+
+	hw_function_id = mlx5_sf_hw_id(coredev, sf->idx);
+	mlx5_core_disable_sf_hca(coredev, hw_function_id);
+	mlx5_cmd_dealloc_sf(coredev, hw_function_id);
+	free_sf_id(sf_table, sf->idx);
+	kfree(sf);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
index 434c193a06d0..1e1ba388504c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
@@ -6,11 +6,18 @@
 
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/eswitch.h>
+#include <linux/idr.h>
+
+struct mlx5_sf {
+	phys_addr_t base_addr;
+	u16 idx;	/* Index allocated by the SF table bitmap */
+};
 
 struct mlx5_sf_table {
 	phys_addr_t base_address;
 	/* Protects sfs life cycle and sf enable/disable flows */
 	struct mutex lock;
+	unsigned long *sf_id_bitmap;
 	u16 max_sfs;
 	u16 log_sf_bar_size;
 };
@@ -22,11 +29,22 @@ static inline bool mlx5_core_is_sf_supported(const struct mlx5_core_dev *dev)
 	       MLX5_CAP_GEN(dev, sf);
 }
 
+static inline u16 mlx5_sf_base_id(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN(dev, sf_base_id);
+}
+
 #ifdef CONFIG_MLX5_MDEV
 int mlx5_sf_table_init(struct mlx5_core_dev *dev,
 		       struct mlx5_sf_table *sf_table);
 void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev,
 			   struct mlx5_sf_table *sf_table);
+
+struct mlx5_sf *
+mlx5_sf_alloc(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
+	      struct device *dev);
+void mlx5_sf_free(struct mlx5_core_dev *coredev, struct mlx5_sf_table *sf_table,
+		  struct mlx5_sf *sf);
 #endif
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index b100489dc85c..4e6bdae3ebfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -133,6 +133,8 @@ void mlx5_sriov_detach(struct mlx5_core_dev *dev);
 int mlx5_core_sriov_configure(struct pci_dev *dev, int num_vfs);
 int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
+int mlx5_core_enable_sf_hca(struct mlx5_core_dev *dev, u16 sf_func_id);
+int mlx5_core_disable_sf_hca(struct mlx5_core_dev *dev, u16 sf_func_id);
 int mlx5_create_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 				       void *context, u32 *element_id);
 int mlx5_modify_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
-- 
2.19.2

