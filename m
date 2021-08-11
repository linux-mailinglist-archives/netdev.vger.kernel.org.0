Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366B63E9776
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhHKSSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230224AbhHKSSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB3FF60FE6;
        Wed, 11 Aug 2021 18:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705896;
        bh=dXLZmAhfEzMCWq59Bke7+xpjZD0JaHza8+TPiXTQifo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKYoYLLO8uKc6LBV731/n/cdudvaPQFxYqMK2PWZ3HWdeDbmQ9kJK3e02NuHGWrbz
         eRYMvnoDfmxgYcDch6/dYzydfpMIXfhilDx40UlLWwrBDDvstLBzdB95VAdgWX8XqR
         diN8Jtz4/QQUP8o4IufoCa/sNiMHEE6rD+NU/XWm2IrIrd15FIfzKSd6XazAOI/KVz
         /YZ8a+rpfEHE/MGjlR4dMl1J/HxmbJ7mxYQHPLe+BVbKfl5quytDlDwfj1YIy2gZh1
         lTGwW6Ip1aQtZAVl93q+iObRdpGgSICKazqyFIkl8hmcqRleu5O7byMZZf79EjbQtP
         HmpZ1b/CRC7hw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/12] net/mlx5: Reorganize current and maximal capabilities to be per-type
Date:   Wed, 11 Aug 2021 11:16:54 -0700
Message-Id: <20210811181658.492548-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811181658.492548-1-saeed@kernel.org>
References: <20210811181658.492548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

In the current code, the current and maximal capabilities are
maintained in separate arrays which are both per type. In order to
allow the creation of such a basic structure as a dynamically
allocated array, we move curr and max fields to a unified
structure so that specific capabilities can be allocated as one unit.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 10 +--
 include/linux/mlx5/device.h                   | 66 +++++++++----------
 include/linux/mlx5/driver.h                   |  8 ++-
 4 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fee51050ed64..813ff8186829 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2343,7 +2343,7 @@ static int create_leaf_prios(struct mlx5_flow_namespace *ns, int prio,
 
 #define FLOW_TABLE_BIT_SZ 1
 #define GET_FLOW_TABLE_CAP(dev, offset) \
-	((be32_to_cpu(*((__be32 *)(dev->caps.hca_cur[MLX5_CAP_FLOW_TABLE]) +	\
+	((be32_to_cpu(*((__be32 *)(dev->caps.hca[MLX5_CAP_FLOW_TABLE].cur) +	\
 			offset / 32)) >>					\
 	  (32 - FLOW_TABLE_BIT_SZ - (offset & 0x1f))) & FLOW_TABLE_BIT_SZ)
 static bool has_required_caps(struct mlx5_core_dev *dev, struct node_caps *caps)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 1a65e744d2e2..6cefe2a981c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -389,11 +389,11 @@ static int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev,
 
 	switch (cap_mode) {
 	case HCA_CAP_OPMOD_GET_MAX:
-		memcpy(dev->caps.hca_max[cap_type], hca_caps,
+		memcpy(dev->caps.hca[cap_type].max, hca_caps,
 		       MLX5_UN_SZ_BYTES(hca_cap_union));
 		break;
 	case HCA_CAP_OPMOD_GET_CUR:
-		memcpy(dev->caps.hca_cur[cap_type], hca_caps,
+		memcpy(dev->caps.hca[cap_type].cur, hca_caps,
 		       MLX5_UN_SZ_BYTES(hca_cap_union));
 		break;
 	default:
@@ -469,7 +469,7 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
 		return err;
 
 	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
-	memcpy(set_hca_cap, dev->caps.hca_cur[MLX5_CAP_ODP],
+	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_ODP].cur,
 	       MLX5_ST_SZ_BYTES(odp_cap));
 
 #define ODP_CAP_SET_MAX(dev, field)                                            \
@@ -514,7 +514,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 
 	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx,
 				   capability);
-	memcpy(set_hca_cap, dev->caps.hca_cur[MLX5_CAP_GENERAL],
+	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_GENERAL].cur,
 	       MLX5_ST_SZ_BYTES(cmd_hca_cap));
 
 	mlx5_core_dbg(dev, "Current Pkey table size %d Setting new size %d\n",
@@ -596,7 +596,7 @@ static int handle_hca_cap_roce(struct mlx5_core_dev *dev, void *set_ctx)
 		return 0;
 
 	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
-	memcpy(set_hca_cap, dev->caps.hca_cur[MLX5_CAP_ROCE],
+	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_ROCE].cur,
 	       MLX5_ST_SZ_BYTES(roce_cap));
 	MLX5_SET(roce_cap, set_hca_cap, sw_r_roce_src_udp_port, 1);
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 1e9d55dc1a9c..2736f12bb57c 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1213,55 +1213,55 @@ enum mlx5_qcam_feature_groups {
 
 /* GET Dev Caps macros */
 #define MLX5_CAP_GEN(mdev, cap) \
-	MLX5_GET(cmd_hca_cap, mdev->caps.hca_cur[MLX5_CAP_GENERAL], cap)
+	MLX5_GET(cmd_hca_cap, mdev->caps.hca[MLX5_CAP_GENERAL].cur, cap)
 
 #define MLX5_CAP_GEN_64(mdev, cap) \
-	MLX5_GET64(cmd_hca_cap, mdev->caps.hca_cur[MLX5_CAP_GENERAL], cap)
+	MLX5_GET64(cmd_hca_cap, mdev->caps.hca[MLX5_CAP_GENERAL].cur, cap)
 
 #define MLX5_CAP_GEN_MAX(mdev, cap) \
-	MLX5_GET(cmd_hca_cap, mdev->caps.hca_max[MLX5_CAP_GENERAL], cap)
+	MLX5_GET(cmd_hca_cap, mdev->caps.hca[MLX5_CAP_GENERAL].max, cap)
 
 #define MLX5_CAP_GEN_2(mdev, cap) \
-	MLX5_GET(cmd_hca_cap_2, mdev->caps.hca_cur[MLX5_CAP_GENERAL_2], cap)
+	MLX5_GET(cmd_hca_cap_2, mdev->caps.hca[MLX5_CAP_GENERAL_2].cur, cap)
 
 #define MLX5_CAP_GEN_2_64(mdev, cap) \
-	MLX5_GET64(cmd_hca_cap_2, mdev->caps.hca_cur[MLX5_CAP_GENERAL_2], cap)
+	MLX5_GET64(cmd_hca_cap_2, mdev->caps.hca[MLX5_CAP_GENERAL_2].cur, cap)
 
 #define MLX5_CAP_GEN_2_MAX(mdev, cap) \
-	MLX5_GET(cmd_hca_cap_2, mdev->caps.hca_max[MLX5_CAP_GENERAL_2], cap)
+	MLX5_GET(cmd_hca_cap_2, mdev->caps.hca[MLX5_CAP_GENERAL_2].max, cap)
 
 #define MLX5_CAP_ETH(mdev, cap) \
 	MLX5_GET(per_protocol_networking_offload_caps,\
-		 mdev->caps.hca_cur[MLX5_CAP_ETHERNET_OFFLOADS], cap)
+		 mdev->caps.hca[MLX5_CAP_ETHERNET_OFFLOADS].cur, cap)
 
 #define MLX5_CAP_ETH_MAX(mdev, cap) \
 	MLX5_GET(per_protocol_networking_offload_caps,\
-		 mdev->caps.hca_max[MLX5_CAP_ETHERNET_OFFLOADS], cap)
+		 mdev->caps.hca[MLX5_CAP_ETHERNET_OFFLOADS].max, cap)
 
 #define MLX5_CAP_IPOIB_ENHANCED(mdev, cap) \
 	MLX5_GET(per_protocol_networking_offload_caps,\
-		 mdev->caps.hca_cur[MLX5_CAP_IPOIB_ENHANCED_OFFLOADS], cap)
+		 mdev->caps.hca[MLX5_CAP_IPOIB_ENHANCED_OFFLOADS].cur, cap)
 
 #define MLX5_CAP_ROCE(mdev, cap) \
-	MLX5_GET(roce_cap, mdev->caps.hca_cur[MLX5_CAP_ROCE], cap)
+	MLX5_GET(roce_cap, mdev->caps.hca[MLX5_CAP_ROCE].cur, cap)
 
 #define MLX5_CAP_ROCE_MAX(mdev, cap) \
-	MLX5_GET(roce_cap, mdev->caps.hca_max[MLX5_CAP_ROCE], cap)
+	MLX5_GET(roce_cap, mdev->caps.hca[MLX5_CAP_ROCE].max, cap)
 
 #define MLX5_CAP_ATOMIC(mdev, cap) \
-	MLX5_GET(atomic_caps, mdev->caps.hca_cur[MLX5_CAP_ATOMIC], cap)
+	MLX5_GET(atomic_caps, mdev->caps.hca[MLX5_CAP_ATOMIC].cur, cap)
 
 #define MLX5_CAP_ATOMIC_MAX(mdev, cap) \
-	MLX5_GET(atomic_caps, mdev->caps.hca_max[MLX5_CAP_ATOMIC], cap)
+	MLX5_GET(atomic_caps, mdev->caps.hca[MLX5_CAP_ATOMIC].max, cap)
 
 #define MLX5_CAP_FLOWTABLE(mdev, cap) \
-	MLX5_GET(flow_table_nic_cap, mdev->caps.hca_cur[MLX5_CAP_FLOW_TABLE], cap)
+	MLX5_GET(flow_table_nic_cap, mdev->caps.hca[MLX5_CAP_FLOW_TABLE].cur, cap)
 
 #define MLX5_CAP64_FLOWTABLE(mdev, cap) \
-	MLX5_GET64(flow_table_nic_cap, (mdev)->caps.hca_cur[MLX5_CAP_FLOW_TABLE], cap)
+	MLX5_GET64(flow_table_nic_cap, (mdev)->caps.hca[MLX5_CAP_FLOW_TABLE].cur, cap)
 
 #define MLX5_CAP_FLOWTABLE_MAX(mdev, cap) \
-	MLX5_GET(flow_table_nic_cap, mdev->caps.hca_max[MLX5_CAP_FLOW_TABLE], cap)
+	MLX5_GET(flow_table_nic_cap, mdev->caps.hca[MLX5_CAP_FLOW_TABLE].max, cap)
 
 #define MLX5_CAP_FLOWTABLE_NIC_RX(mdev, cap) \
 	MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_receive.cap)
@@ -1301,11 +1301,11 @@ enum mlx5_qcam_feature_groups {
 
 #define MLX5_CAP_ESW_FLOWTABLE(mdev, cap) \
 	MLX5_GET(flow_table_eswitch_cap, \
-		 mdev->caps.hca_cur[MLX5_CAP_ESWITCH_FLOW_TABLE], cap)
+		 mdev->caps.hca[MLX5_CAP_ESWITCH_FLOW_TABLE].cur, cap)
 
 #define MLX5_CAP_ESW_FLOWTABLE_MAX(mdev, cap) \
 	MLX5_GET(flow_table_eswitch_cap, \
-		 mdev->caps.hca_max[MLX5_CAP_ESWITCH_FLOW_TABLE], cap)
+		 mdev->caps.hca[MLX5_CAP_ESWITCH_FLOW_TABLE].max, cap)
 
 #define MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, cap) \
 	MLX5_CAP_ESW_FLOWTABLE(mdev, flow_table_properties_nic_esw_fdb.cap)
@@ -1327,31 +1327,31 @@ enum mlx5_qcam_feature_groups {
 
 #define MLX5_CAP_ESW(mdev, cap) \
 	MLX5_GET(e_switch_cap, \
-		 mdev->caps.hca_cur[MLX5_CAP_ESWITCH], cap)
+		 mdev->caps.hca[MLX5_CAP_ESWITCH].cur, cap)
 
 #define MLX5_CAP64_ESW_FLOWTABLE(mdev, cap) \
 	MLX5_GET64(flow_table_eswitch_cap, \
-		(mdev)->caps.hca_cur[MLX5_CAP_ESWITCH_FLOW_TABLE], cap)
+		(mdev)->caps.hca[MLX5_CAP_ESWITCH_FLOW_TABLE].cur, cap)
 
 #define MLX5_CAP_ESW_MAX(mdev, cap) \
 	MLX5_GET(e_switch_cap, \
-		 mdev->caps.hca_max[MLX5_CAP_ESWITCH], cap)
+		 mdev->caps.hca[MLX5_CAP_ESWITCH].max, cap)
 
 #define MLX5_CAP_ODP(mdev, cap)\
-	MLX5_GET(odp_cap, mdev->caps.hca_cur[MLX5_CAP_ODP], cap)
+	MLX5_GET(odp_cap, mdev->caps.hca[MLX5_CAP_ODP].cur, cap)
 
 #define MLX5_CAP_ODP_MAX(mdev, cap)\
-	MLX5_GET(odp_cap, mdev->caps.hca_max[MLX5_CAP_ODP], cap)
+	MLX5_GET(odp_cap, mdev->caps.hca[MLX5_CAP_ODP].max, cap)
 
 #define MLX5_CAP_VECTOR_CALC(mdev, cap) \
 	MLX5_GET(vector_calc_cap, \
-		 mdev->caps.hca_cur[MLX5_CAP_VECTOR_CALC], cap)
+		 mdev->caps.hca[MLX5_CAP_VECTOR_CALC].cur, cap)
 
 #define MLX5_CAP_QOS(mdev, cap)\
-	MLX5_GET(qos_cap, mdev->caps.hca_cur[MLX5_CAP_QOS], cap)
+	MLX5_GET(qos_cap, mdev->caps.hca[MLX5_CAP_QOS].cur, cap)
 
 #define MLX5_CAP_DEBUG(mdev, cap)\
-	MLX5_GET(debug_cap, mdev->caps.hca_cur[MLX5_CAP_DEBUG], cap)
+	MLX5_GET(debug_cap, mdev->caps.hca[MLX5_CAP_DEBUG].cur, cap)
 
 #define MLX5_CAP_PCAM_FEATURE(mdev, fld) \
 	MLX5_GET(pcam_reg, (mdev)->caps.pcam, feature_cap_mask.enhanced_features.fld)
@@ -1387,27 +1387,27 @@ enum mlx5_qcam_feature_groups {
 	MLX5_GET64(fpga_cap, (mdev)->caps.fpga, cap)
 
 #define MLX5_CAP_DEV_MEM(mdev, cap)\
-	MLX5_GET(device_mem_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_MEM], cap)
+	MLX5_GET(device_mem_cap, mdev->caps.hca[MLX5_CAP_DEV_MEM].cur, cap)
 
 #define MLX5_CAP64_DEV_MEM(mdev, cap)\
-	MLX5_GET64(device_mem_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_MEM], cap)
+	MLX5_GET64(device_mem_cap, mdev->caps.hca[MLX5_CAP_DEV_MEM].cur, cap)
 
 #define MLX5_CAP_TLS(mdev, cap) \
-	MLX5_GET(tls_cap, (mdev)->caps.hca_cur[MLX5_CAP_TLS], cap)
+	MLX5_GET(tls_cap, (mdev)->caps.hca[MLX5_CAP_TLS].cur, cap)
 
 #define MLX5_CAP_DEV_EVENT(mdev, cap)\
-	MLX5_ADDR_OF(device_event_cap, (mdev)->caps.hca_cur[MLX5_CAP_DEV_EVENT], cap)
+	MLX5_ADDR_OF(device_event_cap, (mdev)->caps.hca[MLX5_CAP_DEV_EVENT].cur, cap)
 
 #define MLX5_CAP_DEV_VDPA_EMULATION(mdev, cap)\
 	MLX5_GET(virtio_emulation_cap, \
-		(mdev)->caps.hca_cur[MLX5_CAP_VDPA_EMULATION], cap)
+		(mdev)->caps.hca[MLX5_CAP_VDPA_EMULATION].cur, cap)
 
 #define MLX5_CAP64_DEV_VDPA_EMULATION(mdev, cap)\
 	MLX5_GET64(virtio_emulation_cap, \
-		(mdev)->caps.hca_cur[MLX5_CAP_VDPA_EMULATION], cap)
+		(mdev)->caps.hca[MLX5_CAP_VDPA_EMULATION].cur, cap)
 
 #define MLX5_CAP_IPSEC(mdev, cap)\
-	MLX5_GET(ipsec_cap, (mdev)->caps.hca_cur[MLX5_CAP_IPSEC], cap)
+	MLX5_GET(ipsec_cap, (mdev)->caps.hca[MLX5_CAP_IPSEC].cur, cap)
 
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 2b5c5604b091..854443ea812c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -729,6 +729,11 @@ struct mlx5_profile {
 	} mr_cache[MAX_MR_CACHE_ENTRIES];
 };
 
+struct mlx5_hca_cap {
+	u32 cur[MLX5_UN_SZ_DW(hca_cap_union)];
+	u32 max[MLX5_UN_SZ_DW(hca_cap_union)];
+};
+
 struct mlx5_core_dev {
 	struct device *device;
 	enum mlx5_coredev_type coredev_type;
@@ -740,8 +745,7 @@ struct mlx5_core_dev {
 	char			board_id[MLX5_BOARD_ID_LEN];
 	struct mlx5_cmd		cmd;
 	struct {
-		u32 hca_cur[MLX5_CAP_NUM][MLX5_UN_SZ_DW(hca_cap_union)];
-		u32 hca_max[MLX5_CAP_NUM][MLX5_UN_SZ_DW(hca_cap_union)];
+		struct mlx5_hca_cap hca[MLX5_CAP_NUM];
 		u32 pcam[MLX5_ST_SZ_DW(pcam_reg)];
 		u32 mcam[MLX5_MCAM_REGS_NUM][MLX5_ST_SZ_DW(mcam_reg)];
 		u32 fpga[MLX5_ST_SZ_DW(fpga_cap)];
-- 
2.31.1

