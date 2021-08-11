Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8582C3E977A
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhHKSSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230271AbhHKSSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B1966105A;
        Wed, 11 Aug 2021 18:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705896;
        bh=sWT+KwbRBoebpbzgRLfC0rU0ZRO5Y3ILQ2cHFDSFlNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEb3bycaLxiLOgONmGYlF0nDm67K/0XjRs4f1USM8m/jAsoIdN6Ez2lfu3Kg9okk0
         +XKOVRcaFWfSqLXJK8JiuhI8VXtu1gqTHqdFZv37Exr1Rfn0offZhn4VJKOqeP35su
         gk3Uk14/AIM9jBjtLFWE+I+Urolit5aVEK/lBPsl/9f9Ty3fnofdxZijwcB/2IEL1N
         HMBbsh2I2pf9Atv3I8blMll/mROCSkMNQNffx17mqa8BNWL3iTp5ijHDSGjxA7usmS
         6sfKCKDzppJDY5jAU/n1NLTjUJQOe9c4k3g+83+bbCwrEu6M8vKaLzyb33whkXiEEu
         QumnZgH7hZttg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/12] net/mlx5: Allocate individual capability
Date:   Wed, 11 Aug 2021 11:16:55 -0700
Message-Id: <20210811181658.492548-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811181658.492548-1-saeed@kernel.org>
References: <20210811181658.492548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Currently mlx5_core_dev contains array of capabilities. It contains 19
valid capabilities of the device, 2 reserved entries and 12 holes.
Due to this for 14 unused entries, mlx5_core_dev allocates 14 * 8K = 112K
bytes of memory which is never used. Due to this mlx5_core_dev structure
size is 270Kbytes odd. This allocation further aligns to next power of 2
to 512Kbytes.

By skipping non-existent entries,
(a) 112Kbyte is saved,
(b) mlx5_core_dev reduces to 8KB with alignment
(c) 350KB saved in alignment

In future individual capability allocation can be used to skip its
allocation when such capability is disabled at the device level. This
patch prepares mlx5_core_dev to hold capability using a pointer instead
of inline array.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 71 +++++++++++++++++--
 include/linux/mlx5/device.h                   | 69 +++++++++---------
 include/linux/mlx5/driver.h                   |  2 +-
 4 files changed, 104 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 813ff8186829..9fe8e3c204d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2343,7 +2343,7 @@ static int create_leaf_prios(struct mlx5_flow_namespace *ns, int prio,
 
 #define FLOW_TABLE_BIT_SZ 1
 #define GET_FLOW_TABLE_CAP(dev, offset) \
-	((be32_to_cpu(*((__be32 *)(dev->caps.hca[MLX5_CAP_FLOW_TABLE].cur) +	\
+	((be32_to_cpu(*((__be32 *)(dev->caps.hca[MLX5_CAP_FLOW_TABLE]->cur) +	\
 			offset / 32)) >>					\
 	  (32 - FLOW_TABLE_BIT_SZ - (offset & 0x1f))) & FLOW_TABLE_BIT_SZ)
 static bool has_required_caps(struct mlx5_core_dev *dev, struct node_caps *caps)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 6cefe2a981c7..20f693cf58cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -389,11 +389,11 @@ static int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev,
 
 	switch (cap_mode) {
 	case HCA_CAP_OPMOD_GET_MAX:
-		memcpy(dev->caps.hca[cap_type].max, hca_caps,
+		memcpy(dev->caps.hca[cap_type]->max, hca_caps,
 		       MLX5_UN_SZ_BYTES(hca_cap_union));
 		break;
 	case HCA_CAP_OPMOD_GET_CUR:
-		memcpy(dev->caps.hca[cap_type].cur, hca_caps,
+		memcpy(dev->caps.hca[cap_type]->cur, hca_caps,
 		       MLX5_UN_SZ_BYTES(hca_cap_union));
 		break;
 	default:
@@ -469,7 +469,7 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
 		return err;
 
 	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
-	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_ODP].cur,
+	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_ODP]->cur,
 	       MLX5_ST_SZ_BYTES(odp_cap));
 
 #define ODP_CAP_SET_MAX(dev, field)                                            \
@@ -514,7 +514,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 
 	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx,
 				   capability);
-	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_GENERAL].cur,
+	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_GENERAL]->cur,
 	       MLX5_ST_SZ_BYTES(cmd_hca_cap));
 
 	mlx5_core_dbg(dev, "Current Pkey table size %d Setting new size %d\n",
@@ -596,7 +596,7 @@ static int handle_hca_cap_roce(struct mlx5_core_dev *dev, void *set_ctx)
 		return 0;
 
 	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
-	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_ROCE].cur,
+	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_ROCE]->cur,
 	       MLX5_ST_SZ_BYTES(roce_cap));
 	MLX5_SET(roce_cap, set_hca_cap, sw_r_roce_src_udp_port, 1);
 
@@ -1375,6 +1375,60 @@ void mlx5_unload_one(struct mlx5_core_dev *dev)
 	mutex_unlock(&dev->intf_state_mutex);
 }
 
+static const int types[] = {
+	MLX5_CAP_GENERAL,
+	MLX5_CAP_GENERAL_2,
+	MLX5_CAP_ETHERNET_OFFLOADS,
+	MLX5_CAP_IPOIB_ENHANCED_OFFLOADS,
+	MLX5_CAP_ODP,
+	MLX5_CAP_ATOMIC,
+	MLX5_CAP_ROCE,
+	MLX5_CAP_IPOIB_OFFLOADS,
+	MLX5_CAP_FLOW_TABLE,
+	MLX5_CAP_ESWITCH_FLOW_TABLE,
+	MLX5_CAP_ESWITCH,
+	MLX5_CAP_VECTOR_CALC,
+	MLX5_CAP_QOS,
+	MLX5_CAP_DEBUG,
+	MLX5_CAP_DEV_MEM,
+	MLX5_CAP_DEV_EVENT,
+	MLX5_CAP_TLS,
+	MLX5_CAP_VDPA_EMULATION,
+	MLX5_CAP_IPSEC,
+};
+
+static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)
+{
+	int type;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(types); i++) {
+		type = types[i];
+		kfree(dev->caps.hca[type]);
+	}
+}
+
+static int mlx5_hca_caps_alloc(struct mlx5_core_dev *dev)
+{
+	struct mlx5_hca_cap *cap;
+	int type;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(types); i++) {
+		cap = kzalloc(sizeof(*cap), GFP_KERNEL);
+		if (!cap)
+			goto err;
+		type = types[i];
+		dev->caps.hca[type] = cap;
+	}
+
+	return 0;
+
+err:
+	mlx5_hca_caps_free(dev);
+	return -ENOMEM;
+}
+
 int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 {
 	struct mlx5_priv *priv = &dev->priv;
@@ -1410,8 +1464,14 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	if (err)
 		goto err_adev_init;
 
+	err = mlx5_hca_caps_alloc(dev);
+	if (err)
+		goto err_hca_caps;
+
 	return 0;
 
+err_hca_caps:
+	mlx5_adev_cleanup(dev);
 err_adev_init:
 	mlx5_pagealloc_cleanup(dev);
 err_pagealloc_init:
@@ -1430,6 +1490,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
 
+	mlx5_hca_caps_free(dev);
 	mlx5_adev_cleanup(dev);
 	mlx5_pagealloc_cleanup(dev);
 	mlx5_health_cleanup(dev);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 2736f12bb57c..66eaf0aa7f69 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1157,6 +1157,9 @@ enum mlx5_cap_mode {
 	HCA_CAP_OPMOD_GET_CUR	= 1,
 };
 
+/* Any new cap addition must update mlx5_hca_caps_alloc() to allocate
+ * capability memory.
+ */
 enum mlx5_cap_type {
 	MLX5_CAP_GENERAL = 0,
 	MLX5_CAP_ETHERNET_OFFLOADS,
@@ -1213,55 +1216,55 @@ enum mlx5_qcam_feature_groups {
 
 /* GET Dev Caps macros */
 #define MLX5_CAP_GEN(mdev, cap) \
-	MLX5_GET(cmd_hca_cap, mdev->caps.hca[MLX5_CAP_GENERAL].cur, cap)
+	MLX5_GET(cmd_hca_cap, mdev->caps.hca[MLX5_CAP_GENERAL]->cur, cap)
 
 #define MLX5_CAP_GEN_64(mdev, cap) \
-	MLX5_GET64(cmd_hca_cap, mdev->caps.hca[MLX5_CAP_GENERAL].cur, cap)
+	MLX5_GET64(cmd_hca_cap, mdev->caps.hca[MLX5_CAP_GENERAL]->cur, cap)
 
 #define MLX5_CAP_GEN_MAX(mdev, cap) \
-	MLX5_GET(cmd_hca_cap, mdev->caps.hca[MLX5_CAP_GENERAL].max, cap)
+	MLX5_GET(cmd_hca_cap, mdev->caps.hca[MLX5_CAP_GENERAL]->max, cap)
 
 #define MLX5_CAP_GEN_2(mdev, cap) \
-	MLX5_GET(cmd_hca_cap_2, mdev->caps.hca[MLX5_CAP_GENERAL_2].cur, cap)
+	MLX5_GET(cmd_hca_cap_2, mdev->caps.hca[MLX5_CAP_GENERAL_2]->cur, cap)
 
 #define MLX5_CAP_GEN_2_64(mdev, cap) \
-	MLX5_GET64(cmd_hca_cap_2, mdev->caps.hca[MLX5_CAP_GENERAL_2].cur, cap)
+	MLX5_GET64(cmd_hca_cap_2, mdev->caps.hca[MLX5_CAP_GENERAL_2]->cur, cap)
 
 #define MLX5_CAP_GEN_2_MAX(mdev, cap) \
-	MLX5_GET(cmd_hca_cap_2, mdev->caps.hca[MLX5_CAP_GENERAL_2].max, cap)
+	MLX5_GET(cmd_hca_cap_2, mdev->caps.hca[MLX5_CAP_GENERAL_2]->max, cap)
 
 #define MLX5_CAP_ETH(mdev, cap) \
 	MLX5_GET(per_protocol_networking_offload_caps,\
-		 mdev->caps.hca[MLX5_CAP_ETHERNET_OFFLOADS].cur, cap)
+		 mdev->caps.hca[MLX5_CAP_ETHERNET_OFFLOADS]->cur, cap)
 
 #define MLX5_CAP_ETH_MAX(mdev, cap) \
 	MLX5_GET(per_protocol_networking_offload_caps,\
-		 mdev->caps.hca[MLX5_CAP_ETHERNET_OFFLOADS].max, cap)
+		 mdev->caps.hca[MLX5_CAP_ETHERNET_OFFLOADS]->max, cap)
 
 #define MLX5_CAP_IPOIB_ENHANCED(mdev, cap) \
 	MLX5_GET(per_protocol_networking_offload_caps,\
-		 mdev->caps.hca[MLX5_CAP_IPOIB_ENHANCED_OFFLOADS].cur, cap)
+		 mdev->caps.hca[MLX5_CAP_IPOIB_ENHANCED_OFFLOADS]->cur, cap)
 
 #define MLX5_CAP_ROCE(mdev, cap) \
-	MLX5_GET(roce_cap, mdev->caps.hca[MLX5_CAP_ROCE].cur, cap)
+	MLX5_GET(roce_cap, mdev->caps.hca[MLX5_CAP_ROCE]->cur, cap)
 
 #define MLX5_CAP_ROCE_MAX(mdev, cap) \
-	MLX5_GET(roce_cap, mdev->caps.hca[MLX5_CAP_ROCE].max, cap)
+	MLX5_GET(roce_cap, mdev->caps.hca[MLX5_CAP_ROCE]->max, cap)
 
 #define MLX5_CAP_ATOMIC(mdev, cap) \
-	MLX5_GET(atomic_caps, mdev->caps.hca[MLX5_CAP_ATOMIC].cur, cap)
+	MLX5_GET(atomic_caps, mdev->caps.hca[MLX5_CAP_ATOMIC]->cur, cap)
 
 #define MLX5_CAP_ATOMIC_MAX(mdev, cap) \
-	MLX5_GET(atomic_caps, mdev->caps.hca[MLX5_CAP_ATOMIC].max, cap)
+	MLX5_GET(atomic_caps, mdev->caps.hca[MLX5_CAP_ATOMIC]->max, cap)
 
 #define MLX5_CAP_FLOWTABLE(mdev, cap) \
-	MLX5_GET(flow_table_nic_cap, mdev->caps.hca[MLX5_CAP_FLOW_TABLE].cur, cap)
+	MLX5_GET(flow_table_nic_cap, mdev->caps.hca[MLX5_CAP_FLOW_TABLE]->cur, cap)
 
 #define MLX5_CAP64_FLOWTABLE(mdev, cap) \
-	MLX5_GET64(flow_table_nic_cap, (mdev)->caps.hca[MLX5_CAP_FLOW_TABLE].cur, cap)
+	MLX5_GET64(flow_table_nic_cap, (mdev)->caps.hca[MLX5_CAP_FLOW_TABLE]->cur, cap)
 
 #define MLX5_CAP_FLOWTABLE_MAX(mdev, cap) \
-	MLX5_GET(flow_table_nic_cap, mdev->caps.hca[MLX5_CAP_FLOW_TABLE].max, cap)
+	MLX5_GET(flow_table_nic_cap, mdev->caps.hca[MLX5_CAP_FLOW_TABLE]->max, cap)
 
 #define MLX5_CAP_FLOWTABLE_NIC_RX(mdev, cap) \
 	MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_receive.cap)
@@ -1301,11 +1304,11 @@ enum mlx5_qcam_feature_groups {
 
 #define MLX5_CAP_ESW_FLOWTABLE(mdev, cap) \
 	MLX5_GET(flow_table_eswitch_cap, \
-		 mdev->caps.hca[MLX5_CAP_ESWITCH_FLOW_TABLE].cur, cap)
+		 mdev->caps.hca[MLX5_CAP_ESWITCH_FLOW_TABLE]->cur, cap)
 
 #define MLX5_CAP_ESW_FLOWTABLE_MAX(mdev, cap) \
 	MLX5_GET(flow_table_eswitch_cap, \
-		 mdev->caps.hca[MLX5_CAP_ESWITCH_FLOW_TABLE].max, cap)
+		 mdev->caps.hca[MLX5_CAP_ESWITCH_FLOW_TABLE]->max, cap)
 
 #define MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, cap) \
 	MLX5_CAP_ESW_FLOWTABLE(mdev, flow_table_properties_nic_esw_fdb.cap)
@@ -1327,31 +1330,31 @@ enum mlx5_qcam_feature_groups {
 
 #define MLX5_CAP_ESW(mdev, cap) \
 	MLX5_GET(e_switch_cap, \
-		 mdev->caps.hca[MLX5_CAP_ESWITCH].cur, cap)
+		 mdev->caps.hca[MLX5_CAP_ESWITCH]->cur, cap)
 
 #define MLX5_CAP64_ESW_FLOWTABLE(mdev, cap) \
 	MLX5_GET64(flow_table_eswitch_cap, \
-		(mdev)->caps.hca[MLX5_CAP_ESWITCH_FLOW_TABLE].cur, cap)
+		(mdev)->caps.hca[MLX5_CAP_ESWITCH_FLOW_TABLE]->cur, cap)
 
 #define MLX5_CAP_ESW_MAX(mdev, cap) \
 	MLX5_GET(e_switch_cap, \
-		 mdev->caps.hca[MLX5_CAP_ESWITCH].max, cap)
+		 mdev->caps.hca[MLX5_CAP_ESWITCH]->max, cap)
 
 #define MLX5_CAP_ODP(mdev, cap)\
-	MLX5_GET(odp_cap, mdev->caps.hca[MLX5_CAP_ODP].cur, cap)
+	MLX5_GET(odp_cap, mdev->caps.hca[MLX5_CAP_ODP]->cur, cap)
 
 #define MLX5_CAP_ODP_MAX(mdev, cap)\
-	MLX5_GET(odp_cap, mdev->caps.hca[MLX5_CAP_ODP].max, cap)
+	MLX5_GET(odp_cap, mdev->caps.hca[MLX5_CAP_ODP]->max, cap)
 
 #define MLX5_CAP_VECTOR_CALC(mdev, cap) \
 	MLX5_GET(vector_calc_cap, \
-		 mdev->caps.hca[MLX5_CAP_VECTOR_CALC].cur, cap)
+		 mdev->caps.hca[MLX5_CAP_VECTOR_CALC]->cur, cap)
 
 #define MLX5_CAP_QOS(mdev, cap)\
-	MLX5_GET(qos_cap, mdev->caps.hca[MLX5_CAP_QOS].cur, cap)
+	MLX5_GET(qos_cap, mdev->caps.hca[MLX5_CAP_QOS]->cur, cap)
 
 #define MLX5_CAP_DEBUG(mdev, cap)\
-	MLX5_GET(debug_cap, mdev->caps.hca[MLX5_CAP_DEBUG].cur, cap)
+	MLX5_GET(debug_cap, mdev->caps.hca[MLX5_CAP_DEBUG]->cur, cap)
 
 #define MLX5_CAP_PCAM_FEATURE(mdev, fld) \
 	MLX5_GET(pcam_reg, (mdev)->caps.pcam, feature_cap_mask.enhanced_features.fld)
@@ -1387,27 +1390,27 @@ enum mlx5_qcam_feature_groups {
 	MLX5_GET64(fpga_cap, (mdev)->caps.fpga, cap)
 
 #define MLX5_CAP_DEV_MEM(mdev, cap)\
-	MLX5_GET(device_mem_cap, mdev->caps.hca[MLX5_CAP_DEV_MEM].cur, cap)
+	MLX5_GET(device_mem_cap, mdev->caps.hca[MLX5_CAP_DEV_MEM]->cur, cap)
 
 #define MLX5_CAP64_DEV_MEM(mdev, cap)\
-	MLX5_GET64(device_mem_cap, mdev->caps.hca[MLX5_CAP_DEV_MEM].cur, cap)
+	MLX5_GET64(device_mem_cap, mdev->caps.hca[MLX5_CAP_DEV_MEM]->cur, cap)
 
 #define MLX5_CAP_TLS(mdev, cap) \
-	MLX5_GET(tls_cap, (mdev)->caps.hca[MLX5_CAP_TLS].cur, cap)
+	MLX5_GET(tls_cap, (mdev)->caps.hca[MLX5_CAP_TLS]->cur, cap)
 
 #define MLX5_CAP_DEV_EVENT(mdev, cap)\
-	MLX5_ADDR_OF(device_event_cap, (mdev)->caps.hca[MLX5_CAP_DEV_EVENT].cur, cap)
+	MLX5_ADDR_OF(device_event_cap, (mdev)->caps.hca[MLX5_CAP_DEV_EVENT]->cur, cap)
 
 #define MLX5_CAP_DEV_VDPA_EMULATION(mdev, cap)\
 	MLX5_GET(virtio_emulation_cap, \
-		(mdev)->caps.hca[MLX5_CAP_VDPA_EMULATION].cur, cap)
+		(mdev)->caps.hca[MLX5_CAP_VDPA_EMULATION]->cur, cap)
 
 #define MLX5_CAP64_DEV_VDPA_EMULATION(mdev, cap)\
 	MLX5_GET64(virtio_emulation_cap, \
-		(mdev)->caps.hca[MLX5_CAP_VDPA_EMULATION].cur, cap)
+		(mdev)->caps.hca[MLX5_CAP_VDPA_EMULATION]->cur, cap)
 
 #define MLX5_CAP_IPSEC(mdev, cap)\
-	MLX5_GET(ipsec_cap, (mdev)->caps.hca[MLX5_CAP_IPSEC].cur, cap)
+	MLX5_GET(ipsec_cap, (mdev)->caps.hca[MLX5_CAP_IPSEC]->cur, cap)
 
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 854443ea812c..90e5f42baa50 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -745,7 +745,7 @@ struct mlx5_core_dev {
 	char			board_id[MLX5_BOARD_ID_LEN];
 	struct mlx5_cmd		cmd;
 	struct {
-		struct mlx5_hca_cap hca[MLX5_CAP_NUM];
+		struct mlx5_hca_cap *hca[MLX5_CAP_NUM];
 		u32 pcam[MLX5_ST_SZ_DW(pcam_reg)];
 		u32 mcam[MLX5_MCAM_REGS_NUM][MLX5_ST_SZ_DW(mcam_reg)];
 		u32 fpga[MLX5_ST_SZ_DW(fpga_cap)];
-- 
2.31.1

