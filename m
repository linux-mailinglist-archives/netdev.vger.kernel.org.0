Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9843A226F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhFJDAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhFJDAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA38C6141D;
        Thu, 10 Jun 2021 02:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293899;
        bh=ufyKlj6t71WpS6cyX3c5aQ7cB/rV5mE7Yue9VYPm/S4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KG5M29+huj7bZQfJnNBBKzU0VTZsfP4voBn5X3RxmXc5EXYwJXY1wCAXf7EwLuLg/
         digW0XNBK2D8bQEEZLIu+0h/9TmyCYA2l3QKVV5EYkvkhr7IyZSBs6Puqxv5ULCls6
         /fatF4/TWdNVWatwhxRQA/Hg/O77pE7MmEZwdwSaIP9BkvWakq+45CqmXn2qpyZKFP
         j7iltfNbmQyXvN4i8B8qlZ45xf39ZUSYnPHMLEkxUHa0jddTwJOgZ4ZLKVpZLUn0fB
         XdysLirjGS7EKk3mC9BvDSQnwUzkmX4i+BhtofwB9I7y2p3GKVX7XN6S1nlmNTmRWC
         oqK6Di9XkY15w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/16] net/mlx5: mlx5_ifc support for header insert/remove
Date:   Wed,  9 Jun 2021 19:57:59 -0700
Message-Id: <20210610025814.274607-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add support for HCA caps 2 that contains capabilities for the new
insert/remove header actions.

Added the required definitions for supporting the new reformat type:
added packet reformat parameters, reformat anchors and definitions
to allow copy/set into the inserted EMD (Embedded MetaData) tag.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c |  6 +++
 include/linux/mlx5/device.h                  | 10 +++++
 include/linux/mlx5/mlx5_ifc.h                | 40 +++++++++++++++++---
 3 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 02558ac2ace6..016d26f809a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -148,6 +148,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 	if (err)
 		return err;
 
+	if (MLX5_CAP_GEN(dev, hca_cap_2)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL_2);
+		if (err)
+			return err;
+	}
+
 	if (MLX5_CAP_GEN(dev, eth_net_offloads)) {
 		err = mlx5_core_get_caps(dev, MLX5_CAP_ETHERNET_OFFLOADS);
 		if (err)
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 578c4ccae91c..0025913505ab 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1179,6 +1179,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_VDPA_EMULATION = 0x13,
 	MLX5_CAP_DEV_EVENT = 0x14,
 	MLX5_CAP_IPSEC,
+	MLX5_CAP_GENERAL_2 = 0x20,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
 };
@@ -1220,6 +1221,15 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_GEN_MAX(mdev, cap) \
 	MLX5_GET(cmd_hca_cap, mdev->caps.hca_max[MLX5_CAP_GENERAL], cap)
 
+#define MLX5_CAP_GEN_2(mdev, cap) \
+	MLX5_GET(cmd_hca_cap_2, mdev->caps.hca_cur[MLX5_CAP_GENERAL_2], cap)
+
+#define MLX5_CAP_GEN_2_64(mdev, cap) \
+	MLX5_GET64(cmd_hca_cap_2, mdev->caps.hca_cur[MLX5_CAP_GENERAL_2], cap)
+
+#define MLX5_CAP_GEN_2_MAX(mdev, cap) \
+	MLX5_GET(cmd_hca_cap_2, mdev->caps.hca_max[MLX5_CAP_GENERAL_2], cap)
+
 #define MLX5_CAP_ETH(mdev, cap) \
 	MLX5_GET(per_protocol_networking_offload_caps,\
 		 mdev->caps.hca_cur[MLX5_CAP_ETHERNET_OFFLOADS], cap)
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index eb86e80e4643..057db0eaf195 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -435,7 +435,10 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 
 	u8         reserved_at_40[0x20];
 
-	u8         reserved_at_60[0x18];
+	u8         reserved_at_60[0x2];
+	u8         reformat_insert[0x1];
+	u8         reformat_remove[0x1];
+	u8         reserver_at_64[0x14];
 	u8         log_max_ft_num[0x8];
 
 	u8         reserved_at_80[0x10];
@@ -1312,7 +1315,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_0[0x1f];
 	u8         vhca_resource_manager[0x1];
 
-	u8         reserved_at_20[0x3];
+	u8         hca_cap_2[0x1];
+	u8         reserved_at_21[0x2];
 	u8         event_on_vhca_state_teardown_request[0x1];
 	u8         event_on_vhca_state_in_use[0x1];
 	u8         event_on_vhca_state_active[0x1];
@@ -1732,6 +1736,17 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   reserved_at_7c0[0x40];
 };
 
+struct mlx5_ifc_cmd_hca_cap_2_bits {
+	u8	   reserved_at_0[0xa0];
+
+	u8	   max_reformat_insert_size[0x8];
+	u8	   max_reformat_insert_offset[0x8];
+	u8	   max_reformat_remove_size[0x8];
+	u8	   max_reformat_remove_offset[0x8];
+
+	u8	   reserved_at_c0[0x740];
+};
+
 enum mlx5_flow_destination_type {
 	MLX5_FLOW_DESTINATION_TYPE_VPORT        = 0x0,
 	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE   = 0x1,
@@ -3105,6 +3120,7 @@ struct mlx5_ifc_roce_addr_layout_bits {
 
 union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_cmd_hca_cap_bits cmd_hca_cap;
+	struct mlx5_ifc_cmd_hca_cap_2_bits cmd_hca_cap_2;
 	struct mlx5_ifc_odp_cap_bits odp_cap;
 	struct mlx5_ifc_atomic_caps_bits atomic_caps;
 	struct mlx5_ifc_roce_cap_bits roce_cap;
@@ -5785,12 +5801,14 @@ struct mlx5_ifc_query_eq_in_bits {
 };
 
 struct mlx5_ifc_packet_reformat_context_in_bits {
-	u8         reserved_at_0[0x5];
-	u8         reformat_type[0x3];
-	u8         reserved_at_8[0xe];
+	u8         reformat_type[0x8];
+	u8         reserved_at_8[0x4];
+	u8         reformat_param_0[0x4];
+	u8         reserved_at_10[0x6];
 	u8         reformat_data_size[0xa];
 
-	u8         reserved_at_20[0x10];
+	u8         reformat_param_1[0x8];
+	u8         reserved_at_28[0x8];
 	u8         reformat_data[2][0x8];
 
 	u8         more_reformat_data[][0x8];
@@ -5830,12 +5848,20 @@ struct mlx5_ifc_alloc_packet_reformat_context_out_bits {
 	u8         reserved_at_60[0x20];
 };
 
+enum {
+	MLX5_REFORMAT_CONTEXT_ANCHOR_MAC_START = 0x1,
+	MLX5_REFORMAT_CONTEXT_ANCHOR_IP_START = 0x7,
+	MLX5_REFORMAT_CONTEXT_ANCHOR_TCP_UDP_START = 0x9,
+};
+
 enum mlx5_reformat_ctx_type {
 	MLX5_REFORMAT_TYPE_L2_TO_VXLAN = 0x0,
 	MLX5_REFORMAT_TYPE_L2_TO_NVGRE = 0x1,
 	MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL = 0x2,
 	MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2 = 0x3,
 	MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL = 0x4,
+	MLX5_REFORMAT_TYPE_INSERT_HDR = 0xf,
+	MLX5_REFORMAT_TYPE_REMOVE_HDR = 0x10,
 };
 
 struct mlx5_ifc_alloc_packet_reformat_context_in_bits {
@@ -5956,6 +5982,8 @@ enum {
 	MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM   = 0x59,
 	MLX5_ACTION_IN_FIELD_OUT_TCP_ACK_NUM   = 0x5B,
 	MLX5_ACTION_IN_FIELD_IPSEC_SYNDROME    = 0x5D,
+	MLX5_ACTION_IN_FIELD_OUT_EMD_47_32     = 0x6F,
+	MLX5_ACTION_IN_FIELD_OUT_EMD_31_0      = 0x70,
 };
 
 struct mlx5_ifc_alloc_modify_header_context_out_bits {
-- 
2.31.1

