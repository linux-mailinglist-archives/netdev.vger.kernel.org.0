Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9A3432C2C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhJSDXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhJSDXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2961461355;
        Tue, 19 Oct 2021 03:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613650;
        bh=fTrSumQYr76Nl6QoyupoyqUc6Vq+fL8JImX1XAvLVhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOE1RRRVyN7hCQCw88q5c889mzP/2Gkt9Hu6NTOGi8a9w81qIWJR6hTO32AhYi5Bb
         HcBYl9E/HDze2fGF8/RidQwyKxWL8tFw5zXSdafV36T+NMcLzjyfjvwgmuMn4Cwr1v
         iobfW3zMloRwwyo1vWgxLCOe+cMYPnTdJtdIz0tJ/1Pb8qnzw56LCVvwc2ra40OJfZ
         gjKPQRK9QC+4w1YjbZycDSSdubV2r6jkINKXuC0qyCCcTiQaxinQJumCMa5SHz9XCF
         emLPTXHZJpQFf5ltyMdjd5MmCeHWTc3EZY5ZstPoBo6KTZpgQ/UlSrpNrPzeyJnTXv
         9uVs8NmrFiFdw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/13] net/mlx5: Introduce port selection namespace
Date:   Mon, 18 Oct 2021 20:20:36 -0700
Message-Id: <20211019032047.55660-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Add new port selection flow steering namespace. Flow steering rules in
this namespaceare are used to determine the physical port for egress
packets.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  1 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 26 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  7 +++--
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |  6 +++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  1 +
 include/linux/mlx5/device.h                   | 15 +++++++++++
 include/linux/mlx5/fs.h                       |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 25 ++++++++++++++++--
 8 files changed, 78 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 7db8df64a60e..caefdb7dfefe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -969,6 +969,7 @@ const struct mlx5_flow_cmds *mlx5_fs_cmd_get_default(enum fs_flow_table_type typ
 	case FS_FT_NIC_TX:
 	case FS_FT_RDMA_RX:
 	case FS_FT_RDMA_TX:
+	case FS_FT_PORT_SEL:
 		return mlx5_fs_cmd_get_fw_cmds();
 	default:
 		return mlx5_fs_cmd_get_stub_cmds();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fe501ba88bea..8d8696f7c3f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2191,6 +2191,10 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		if (steering->fdb_root_ns)
 			return &steering->fdb_root_ns->ns;
 		return NULL;
+	case MLX5_FLOW_NAMESPACE_PORT_SEL:
+		if (steering->port_sel_root_ns)
+			return &steering->port_sel_root_ns->ns;
+		return NULL;
 	case MLX5_FLOW_NAMESPACE_SNIFFER_RX:
 		if (steering->sniffer_rx_root_ns)
 			return &steering->sniffer_rx_root_ns->ns;
@@ -2596,6 +2600,7 @@ void mlx5_cleanup_fs(struct mlx5_core_dev *dev)
 	steering->fdb_root_ns = NULL;
 	kfree(steering->fdb_sub_ns);
 	steering->fdb_sub_ns = NULL;
+	cleanup_root_ns(steering->port_sel_root_ns);
 	cleanup_root_ns(steering->sniffer_rx_root_ns);
 	cleanup_root_ns(steering->sniffer_tx_root_ns);
 	cleanup_root_ns(steering->rdma_rx_root_ns);
@@ -2634,6 +2639,21 @@ static int init_sniffer_rx_root_ns(struct mlx5_flow_steering *steering)
 	return PTR_ERR_OR_ZERO(prio);
 }
 
+#define PORT_SEL_NUM_LEVELS 3
+static int init_port_sel_root_ns(struct mlx5_flow_steering *steering)
+{
+	struct fs_prio *prio;
+
+	steering->port_sel_root_ns = create_root_ns(steering, FS_FT_PORT_SEL);
+	if (!steering->port_sel_root_ns)
+		return -ENOMEM;
+
+	/* Create single prio */
+	prio = fs_create_prio(&steering->port_sel_root_ns->ns, 0,
+			      PORT_SEL_NUM_LEVELS);
+	return PTR_ERR_OR_ZERO(prio);
+}
+
 static int init_rdma_rx_root_ns(struct mlx5_flow_steering *steering)
 {
 	int err;
@@ -3020,6 +3040,12 @@ int mlx5_init_fs(struct mlx5_core_dev *dev)
 			goto err;
 	}
 
+	if (MLX5_CAP_FLOWTABLE_PORT_SELECTION(dev, ft_support)) {
+		err = init_port_sel_root_ns(steering);
+		if (err)
+			goto err;
+	}
+
 	if (MLX5_CAP_FLOWTABLE_RDMA_RX(dev, ft_support) &&
 	    MLX5_CAP_FLOWTABLE_RDMA_RX(dev, table_miss_action_domain)) {
 		err = init_rdma_rx_root_ns(steering);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 98240badc342..79d37530afb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -97,7 +97,8 @@ enum fs_flow_table_type {
 	FS_FT_SNIFFER_TX	= 0X6,
 	FS_FT_RDMA_RX		= 0X7,
 	FS_FT_RDMA_TX		= 0X8,
-	FS_FT_MAX_TYPE = FS_FT_RDMA_TX,
+	FS_FT_PORT_SEL		= 0X9,
+	FS_FT_MAX_TYPE = FS_FT_PORT_SEL,
 };
 
 enum fs_flow_table_op_mod {
@@ -129,6 +130,7 @@ struct mlx5_flow_steering {
 	struct mlx5_flow_root_namespace	*rdma_rx_root_ns;
 	struct mlx5_flow_root_namespace	*rdma_tx_root_ns;
 	struct mlx5_flow_root_namespace	*egress_root_ns;
+	struct mlx5_flow_root_namespace	*port_sel_root_ns;
 	int esw_egress_acl_vports;
 	int esw_ingress_acl_vports;
 };
@@ -341,7 +343,8 @@ struct mlx5_flow_root_namespace *find_root(struct fs_node *node);
 	(type == FS_FT_SNIFFER_TX) ? MLX5_CAP_FLOWTABLE_SNIFFER_TX(mdev, cap) :		\
 	(type == FS_FT_RDMA_RX) ? MLX5_CAP_FLOWTABLE_RDMA_RX(mdev, cap) :		\
 	(type == FS_FT_RDMA_TX) ? MLX5_CAP_FLOWTABLE_RDMA_TX(mdev, cap) :      \
-	(BUILD_BUG_ON_ZERO(FS_FT_RDMA_TX != FS_FT_MAX_TYPE))\
+	(type == FS_FT_PORT_SEL) ? MLX5_CAP_FLOWTABLE_PORT_SELECTION(mdev, cap) :      \
+	(BUILD_BUG_ON_ZERO(FS_FT_PORT_SEL != FS_FT_MAX_TYPE))\
 	)
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index f4f8993eac17..1037e3629e7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -149,6 +149,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 	if (err)
 		return err;
 
+	if (MLX5_CAP_GEN(dev, port_selection_cap)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_PORT_SELECTION);
+		if (err)
+			return err;
+	}
+
 	if (MLX5_CAP_GEN(dev, hca_cap_2)) {
 		err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL_2);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 47d92fb459ed..f8446395163a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1416,6 +1416,7 @@ static const int types[] = {
 	MLX5_CAP_TLS,
 	MLX5_CAP_VDPA_EMULATION,
 	MLX5_CAP_IPSEC,
+	MLX5_CAP_PORT_SELECTION,
 };
 
 static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 109cc8106d16..347167c18802 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1185,6 +1185,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_DEV_EVENT = 0x14,
 	MLX5_CAP_IPSEC,
 	MLX5_CAP_GENERAL_2 = 0x20,
+	MLX5_CAP_PORT_SELECTION = 0x25,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
 };
@@ -1342,6 +1343,20 @@ enum mlx5_qcam_feature_groups {
 	MLX5_GET(e_switch_cap, \
 		 mdev->caps.hca[MLX5_CAP_ESWITCH]->max, cap)
 
+#define MLX5_CAP_PORT_SELECTION(mdev, cap) \
+	MLX5_GET(port_selection_cap, \
+		 mdev->caps.hca[MLX5_CAP_PORT_SELECTION]->cur, cap)
+
+#define MLX5_CAP_PORT_SELECTION_MAX(mdev, cap) \
+	MLX5_GET(port_selection_cap, \
+		 mdev->caps.hca[MLX5_CAP_PORT_SELECTION]->max, cap)
+
+#define MLX5_CAP_FLOWTABLE_PORT_SELECTION(mdev, cap) \
+	MLX5_CAP_PORT_SELECTION(mdev, flow_table_properties_port_selection.cap)
+
+#define MLX5_CAP_FLOWTABLE_PORT_SELECTION_MAX(mdev, cap) \
+	MLX5_CAP_PORT_SELECTION_MAX(mdev, flow_table_properties_port_selection.cap)
+
 #define MLX5_CAP_ODP(mdev, cap)\
 	MLX5_GET(odp_cap, mdev->caps.hca[MLX5_CAP_ODP]->cur, cap)
 
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 0106c67e8ccb..259fcc168340 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -83,6 +83,7 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_RDMA_RX,
 	MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL,
 	MLX5_FLOW_NAMESPACE_RDMA_TX,
+	MLX5_FLOW_NAMESPACE_PORT_SEL,
 };
 
 enum {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c614ad1da44d..db1d9c69c1fa 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -767,6 +767,18 @@ struct mlx5_ifc_flow_table_nic_cap_bits {
 	u8         reserved_at_20c0[0x5f40];
 };
 
+struct mlx5_ifc_port_selection_cap_bits {
+	u8         reserved_at_0[0x10];
+	u8         port_select_flow_table[0x1];
+	u8         reserved_at_11[0xf];
+
+	u8         reserved_at_20[0x1e0];
+
+	struct mlx5_ifc_flow_table_prop_layout_bits flow_table_properties_port_selection;
+
+	u8         reserved_at_400[0x7c00];
+};
+
 enum {
 	MLX5_FDB_TO_VPORT_REG_C_0 = 0x01,
 	MLX5_FDB_TO_VPORT_REG_C_1 = 0x02,
@@ -1515,7 +1527,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         uar_4k[0x1];
 	u8         reserved_at_241[0x9];
 	u8         uar_sz[0x6];
-	u8         reserved_at_248[0x2];
+	u8         port_selection_cap[0x1];
+	u8         reserved_at_248[0x1];
 	u8         umem_uid_0[0x1];
 	u8         reserved_at_250[0x5];
 	u8         log_pg_sz[0x8];
@@ -3164,6 +3177,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_flow_table_nic_cap_bits flow_table_nic_cap;
 	struct mlx5_ifc_flow_table_eswitch_cap_bits flow_table_eswitch_cap;
 	struct mlx5_ifc_e_switch_cap_bits e_switch_cap;
+	struct mlx5_ifc_port_selection_cap_bits port_selection_cap;
 	struct mlx5_ifc_vector_calc_cap_bits vector_calc_cap;
 	struct mlx5_ifc_qos_cap_bits qos_cap;
 	struct mlx5_ifc_debug_cap_bits debug_cap;
@@ -10434,9 +10448,16 @@ struct mlx5_ifc_dcbx_param_bits {
 	u8         reserved_at_a0[0x160];
 };
 
+enum {
+	MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY = 0,
+	MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT,
+};
+
 struct mlx5_ifc_lagc_bits {
 	u8         fdb_selection_mode[0x1];
-	u8         reserved_at_1[0x1c];
+	u8         reserved_at_1[0x14];
+	u8         port_select_mode[0x3];
+	u8         reserved_at_18[0x5];
 	u8         lag_state[0x3];
 
 	u8         reserved_at_20[0x14];
-- 
2.31.1

