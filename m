Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A9EF342E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389315AbfKGQI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:08:59 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53453 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389278AbfKGQI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:08:58 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:08:55 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4D007213;
        Thu, 7 Nov 2019 18:08:50 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 03/19] net/mlx5: Introduce SF table framework
Date:   Thu,  7 Nov 2019 10:08:18 -0600
Message-Id: <20191107160834.21087-3-parav@mellanox.com>
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

Introduce a SF table for SF life cycle for a device which supports SF
capability.
This SF table framework is used in subsequent patches.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  4 ++
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  2 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  5 ++
 .../ethernet/mellanox/mlx5/core/meddev/sf.c   | 62 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/meddev/sf.h   | 15 +++++
 5 files changed, 88 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index a6f390fdb971..b13a0c91662b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -74,3 +74,7 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_ste.o steering/dr_send.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o
+#
+# Mdev basic
+#
+mlx5_core-$(CONFIG_MLX5_MDEV) += meddev/sf.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index ea934cd02448..e9a326939f5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -448,6 +448,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_ALLOC_MEMIC:
 	case MLX5_CMD_OP_MODIFY_XRQ:
 	case MLX5_CMD_OP_RELEASE_XRQ_ERROR:
+	case MLX5_CMD_OP_QUERY_SF_PARTITION:
 		*status = MLX5_DRIVER_STATUS_ABORTED;
 		*synd = MLX5_DRIVER_SYND;
 		return -EIO;
@@ -474,6 +475,7 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(QUERY_ISSI);
 	MLX5_COMMAND_STR_CASE(SET_ISSI);
 	MLX5_COMMAND_STR_CASE(SET_DRIVER_VERSION);
+	MLX5_COMMAND_STR_CASE(QUERY_SF_PARTITION);
 	MLX5_COMMAND_STR_CASE(CREATE_MKEY);
 	MLX5_COMMAND_STR_CASE(QUERY_MKEY);
 	MLX5_COMMAND_STR_CASE(DESTROY_MKEY);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c9a091d3226c..174ade250f62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -577,6 +577,11 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
 			 num_vhca_ports,
 			 MLX5_CAP_GEN_MAX(dev, num_vhca_ports));
 
+#ifdef CONFIG_MLX5_MDEV
+	if (MLX5_CAP_GEN_MAX(dev, sf))
+		MLX5_SET(cmd_hca_cap, set_hca_cap, sf, 1);
+#endif
+
 	err = set_caps(dev, set_ctx, set_sz,
 		       MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
new file mode 100644
index 000000000000..3324cc53efe3
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2018-19 Mellanox Technologies
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include "sf.h"
+#include "mlx5_core.h"
+
+static int
+mlx5_cmd_query_sf_partitions(struct mlx5_core_dev *mdev, u32 *out, int outlen)
+{
+	u32 in[MLX5_ST_SZ_DW(query_sf_partitions_in)] = {};
+
+	/* Query sf partitions */
+	MLX5_SET(query_sf_partitions_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_SF_PARTITION);
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, outlen);
+}
+
+int mlx5_sf_table_init(struct mlx5_core_dev *dev,
+		       struct mlx5_sf_table *sf_table)
+{
+	void *sf_parts;
+	int n_support;
+	int outlen;
+	u32 *out;
+	int err;
+
+	outlen = MLX5_ST_SZ_BYTES(query_sf_partitions_out) + MLX5_ST_SZ_BYTES(sf_partition);
+	out = kvzalloc(outlen, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	mutex_init(&sf_table->lock);
+	/* SFs BAR is implemented in PCI BAR2 */
+	sf_table->base_address = pci_resource_start(dev->pdev, 2);
+
+	/* Query first partition */
+	err = mlx5_cmd_query_sf_partitions(dev, out, outlen);
+	if (err)
+		goto free_outmem;
+
+	n_support = MLX5_GET(query_sf_partitions_out, out, num_sf_partitions);
+	sf_parts = MLX5_ADDR_OF(query_sf_partitions_out, out, sf_partition);
+	sf_table->max_sfs = 1 << MLX5_GET(sf_partition, sf_parts, log_num_sf);
+	sf_table->log_sf_bar_size =
+		MLX5_GET(sf_partition, sf_parts, log_sf_bar_size);
+
+	mlx5_core_dbg(dev, "supported partitions(%d)\n", n_support);
+	mlx5_core_dbg(dev, "SF_part(0) log_num_sf(%d) log_sf_bar_size(%d)\n",
+		      sf_table->max_sfs, sf_table->log_sf_bar_size);
+
+free_outmem:
+	kvfree(out);
+	return err;
+}
+
+void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev,
+			   struct mlx5_sf_table *sf_table)
+{
+	mutex_destroy(&sf_table->lock);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
index 0cd28506e339..434c193a06d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
@@ -7,6 +7,14 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/eswitch.h>
 
+struct mlx5_sf_table {
+	phys_addr_t base_address;
+	/* Protects sfs life cycle and sf enable/disable flows */
+	struct mutex lock;
+	u16 max_sfs;
+	u16 log_sf_bar_size;
+};
+
 static inline bool mlx5_core_is_sf_supported(const struct mlx5_core_dev *dev)
 {
 	return MLX5_ESWITCH_MANAGER(dev) &&
@@ -14,4 +22,11 @@ static inline bool mlx5_core_is_sf_supported(const struct mlx5_core_dev *dev)
 	       MLX5_CAP_GEN(dev, sf);
 }
 
+#ifdef CONFIG_MLX5_MDEV
+int mlx5_sf_table_init(struct mlx5_core_dev *dev,
+		       struct mlx5_sf_table *sf_table);
+void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev,
+			   struct mlx5_sf_table *sf_table);
+#endif
+
 #endif
-- 
2.19.2

