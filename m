Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA4119059B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 07:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgCXGOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 02:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgCXGOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 02:14:47 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F18820663;
        Tue, 24 Mar 2020 06:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585030485;
        bh=PwehbjPFxFg6oARedxUeqvmwwvnwrP3n7iRYc5qAdOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nY6Cd/2QMg/jX7GSvF9tTcK92EY08Nig0s82ZWN/LWd4K3AltyvUqaSMKw1hC05rM
         75g8XXXTC5U1hYfAQjzc4rWJtYQV7B4JOiV28Vti0maDk7hD36wNgL629ZPga6R3B2
         DwMGZiR7rasLuP2YcVnPS+z3Zst37Abl+mrsj2GI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Michael Guralnik <michaelgur@mellanox.com>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Add support for RDMA TX steering
Date:   Tue, 24 Mar 2020 08:14:24 +0200
Message-Id: <20200324061425.1570190-2-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324061425.1570190-1-leon@kernel.org>
References: <20200324061425.1570190-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Add new RDMA TX flow steering namespace. Flow steering rules in
this namespace are used to filter transmitted RDMA traffic.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  1 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 53 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  7 ++-
 include/linux/mlx5/device.h                   |  6 +++
 include/linux/mlx5/fs.h                       |  1 +
 include/linux/mlx5/mlx5_ifc.h                 |  2 +-
 6 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index b25465d9e030..90048697b2ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -904,6 +904,7 @@ const struct mlx5_flow_cmds *mlx5_fs_cmd_get_default(enum fs_flow_table_type typ
 	case FS_FT_SNIFFER_TX:
 	case FS_FT_NIC_TX:
 	case FS_FT_RDMA_RX:
+	case FS_FT_RDMA_TX:
 		return mlx5_fs_cmd_get_fw_cmds();
 	default:
 		return mlx5_fs_cmd_get_stub_cmds();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 9dc24241dc91..98c74a867ef4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -87,6 +87,15 @@
 			       .identified_miss_table_mode),                   \
 		FS_CAP(flow_table_properties_nic_transmit.flow_table_modify))
 
+#define FS_CHAINING_CAPS_RDMA_TX                                                \
+	FS_REQUIRED_CAPS(                                                       \
+		FS_CAP(flow_table_properties_nic_transmit_rdma.flow_modify_en), \
+		FS_CAP(flow_table_properties_nic_transmit_rdma.modify_root),    \
+		FS_CAP(flow_table_properties_nic_transmit_rdma                  \
+			       .identified_miss_table_mode),                    \
+		FS_CAP(flow_table_properties_nic_transmit_rdma                  \
+			       .flow_table_modify))
+
 #define LEFTOVERS_NUM_LEVELS 1
 #define LEFTOVERS_NUM_PRIOS 1
 
@@ -202,6 +211,18 @@ static struct init_tree_node rdma_rx_root_fs = {
 	}
 };
 
+static struct init_tree_node rdma_tx_root_fs = {
+	.type = FS_TYPE_NAMESPACE,
+	.ar_size = 1,
+	.children = (struct init_tree_node[]) {
+		ADD_PRIO(0, MLX5_BY_PASS_NUM_PRIOS, 0,
+			 FS_CHAINING_CAPS_RDMA_TX,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
+						  BY_PASS_PRIO_NUM_LEVELS))),
+	}
+};
+
 enum fs_i_lock_class {
 	FS_LOCK_GRANDPARENT,
 	FS_LOCK_PARENT,
@@ -2132,6 +2153,8 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL) {
 		root_ns = steering->rdma_rx_root_ns;
 		prio = RDMA_RX_KERNEL_PRIO;
+	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX) {
+		root_ns = steering->rdma_tx_root_ns;
 	} else { /* Must be NIC RX */
 		root_ns = steering->root_ns;
 		prio = type;
@@ -2535,6 +2558,7 @@ void mlx5_cleanup_fs(struct mlx5_core_dev *dev)
 	cleanup_root_ns(steering->sniffer_rx_root_ns);
 	cleanup_root_ns(steering->sniffer_tx_root_ns);
 	cleanup_root_ns(steering->rdma_rx_root_ns);
+	cleanup_root_ns(steering->rdma_tx_root_ns);
 	cleanup_root_ns(steering->egress_root_ns);
 	mlx5_cleanup_fc_stats(dev);
 	kmem_cache_destroy(steering->ftes_cache);
@@ -2591,6 +2615,29 @@ static int init_rdma_rx_root_ns(struct mlx5_flow_steering *steering)
 	return err;
 }
 
+static int init_rdma_tx_root_ns(struct mlx5_flow_steering *steering)
+{
+	int err;
+
+	steering->rdma_tx_root_ns = create_root_ns(steering, FS_FT_RDMA_TX);
+	if (!steering->rdma_tx_root_ns)
+		return -ENOMEM;
+
+	err = init_root_tree(steering, &rdma_tx_root_fs,
+			     &steering->rdma_tx_root_ns->ns.node);
+	if (err)
+		goto out_err;
+
+	set_prio_attrs(steering->rdma_tx_root_ns);
+
+	return 0;
+
+out_err:
+	cleanup_root_ns(steering->rdma_tx_root_ns);
+	steering->rdma_tx_root_ns = NULL;
+	return err;
+}
+
 /* FT and tc chains are stored in the same array so we can re-use the
  * mlx5_get_fdb_sub_ns() and tc api for FT chains.
  * When creating a new ns for each chain store it in the first available slot.
@@ -2890,6 +2937,12 @@ int mlx5_init_fs(struct mlx5_core_dev *dev)
 			goto err;
 	}
 
+	if (MLX5_CAP_FLOWTABLE_RDMA_TX(dev, ft_support)) {
+		err = init_rdma_tx_root_ns(steering);
+		if (err)
+			goto err;
+	}
+
 	if (MLX5_IPSEC_DEV(dev) || MLX5_CAP_FLOWTABLE_NIC_TX(dev, ft_support)) {
 		err = init_egress_root_ns(steering);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index be5f5e32c1e8..508108c58dae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -86,7 +86,8 @@ enum fs_flow_table_type {
 	FS_FT_SNIFFER_RX	= 0X5,
 	FS_FT_SNIFFER_TX	= 0X6,
 	FS_FT_RDMA_RX		= 0X7,
-	FS_FT_MAX_TYPE = FS_FT_RDMA_RX,
+	FS_FT_RDMA_TX		= 0X8,
+	FS_FT_MAX_TYPE = FS_FT_RDMA_TX,
 };
 
 enum fs_flow_table_op_mod {
@@ -116,6 +117,7 @@ struct mlx5_flow_steering {
 	struct mlx5_flow_root_namespace	*sniffer_tx_root_ns;
 	struct mlx5_flow_root_namespace	*sniffer_rx_root_ns;
 	struct mlx5_flow_root_namespace	*rdma_rx_root_ns;
+	struct mlx5_flow_root_namespace	*rdma_tx_root_ns;
 	struct mlx5_flow_root_namespace	*egress_root_ns;
 };
 
@@ -316,7 +318,8 @@ void mlx5_cleanup_fs(struct mlx5_core_dev *dev);
 	(type == FS_FT_SNIFFER_RX) ? MLX5_CAP_FLOWTABLE_SNIFFER_RX(mdev, cap) :		\
 	(type == FS_FT_SNIFFER_TX) ? MLX5_CAP_FLOWTABLE_SNIFFER_TX(mdev, cap) :		\
 	(type == FS_FT_RDMA_RX) ? MLX5_CAP_FLOWTABLE_RDMA_RX(mdev, cap) :		\
-	(BUILD_BUG_ON_ZERO(FS_FT_RDMA_RX != FS_FT_MAX_TYPE))\
+	(type == FS_FT_RDMA_TX) ? MLX5_CAP_FLOWTABLE_RDMA_TX(mdev, cap) :      \
+	(BUILD_BUG_ON_ZERO(FS_FT_RDMA_TX != FS_FT_MAX_TYPE))\
 	)
 
 #endif
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 0e62c3db45e5..2b90097a6cf9 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1211,6 +1211,12 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_FLOWTABLE_RDMA_RX_MAX(mdev, cap) \
 	MLX5_CAP_FLOWTABLE_MAX(mdev, flow_table_properties_nic_receive_rdma.cap)
 
+#define MLX5_CAP_FLOWTABLE_RDMA_TX(mdev, cap) \
+	MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_transmit_rdma.cap)
+
+#define MLX5_CAP_FLOWTABLE_RDMA_TX_MAX(mdev, cap) \
+	MLX5_CAP_FLOWTABLE_MAX(mdev, flow_table_properties_nic_transmit_rdma.cap)
+
 #define MLX5_CAP_ESW_FLOWTABLE(mdev, cap) \
 	MLX5_GET(flow_table_eswitch_cap, \
 		 mdev->caps.hca_cur[MLX5_CAP_ESWITCH_FLOW_TABLE], cap)
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 4cae16016b2b..44c9fe792fc4 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -77,6 +77,7 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_EGRESS,
 	MLX5_FLOW_NAMESPACE_RDMA_RX,
 	MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL,
+	MLX5_FLOW_NAMESPACE_RDMA_TX,
 };
 
 enum {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index bb217c3f30da..0345d7af4e84 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -709,7 +709,7 @@ struct mlx5_ifc_flow_table_nic_cap_bits {
 
 	struct mlx5_ifc_flow_table_prop_layout_bits flow_table_properties_nic_transmit;
 
-	u8         reserved_at_a00[0x200];
+	struct mlx5_ifc_flow_table_prop_layout_bits flow_table_properties_nic_transmit_rdma;
 
 	struct mlx5_ifc_flow_table_prop_layout_bits flow_table_properties_nic_transmit_sniffer;
 
-- 
2.24.1

