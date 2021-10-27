Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E7D43BFF7
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbhJ0ChN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238408AbhJ0ChH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 22:37:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3AAD6103C;
        Wed, 27 Oct 2021 02:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635302083;
        bh=YsPLfaeMAFkqJtTDrew1YgdDRlgfr8dsrBV8gyDC10Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7vdBBzT25YkcmO5rx37f5Ih122R0snxlOnH6yr1pNBNc+e6n2hyFTDE2MdVUqsju
         7DDG2m++K3c3DuBxHU70rchAGW1NGMoDoyCBXPZ7EcLKrgTln1i003h07CxOhWtLXu
         YBdYTvrEnPQK7t1m9yHc/VVokM1vzSOwMFyjRwwHwIwRRnEccc10XyNoJyeMFft+wX
         rf9ZCQRG5RYAK+hk54le5ia7vb80UM2KUB9cjxxoeKzmzVcuOXvD4RcGUOTrEbqVIn
         EzRzXl4thZtbhv5po1mK7h+iQKYquxtH5ewiznCz0xzAKR0zDOrWoPIxA0fYDa3wtd
         PPkEqweEvaRfA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/14] net/mlx5: Add SHAMPO caps, HW bits and enumerations
Date:   Tue, 26 Oct 2021 19:33:37 -0700
Message-Id: <20211027023347.699076-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027023347.699076-1-saeed@kernel.org>
References: <20211027023347.699076-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

This commit adds SHAMPO bit to hca_cap and SHAMPO capabilities structure,
SHAMPO related HW spec hardware fields and enumerations.
SHAMPO stands for: split headers and merge payload offload.
SHAMPO new fields:
WQ:
 - headers_mkey: mkey that represents the headers buffer, where the packets
   headers will be written by the HW.

 - shampo_enable: flag to verify if the WQ supports SHAMPO feature.

 - log_reservation_size: the log of the reservation size where the data of
   the packet will be written by the HW.

 - log_max_num_of_packets_per_reservation: log of the maximum number of
   packets that can be written to the same reservation.

 - log_headers_entry_size: log of the header entry size of the headers buffer.

 - log_headers_buffer_entry_num: log of the entries number of the headers buffer.

RQ:
 - shampo_no_match_alignment_granularity: the HW alignment granularity
   in case the received packet doesn't match the current session.

 - shampo_match_criteria_type: the type of match criteria.

 - reservation_timeout: the maximum time that the HW will hold the
   reservation.

mlx5_ifc_shampo_cap_bits, the capabilities of the SHAMPO feature:
 - shampo_log_max_reservation_size: the maximum allowed value of the field
   WQ.log_reservation_size.

 - log_reservation_size: the minimum allowed value of the field
   WQ.log_reservation_size.

 - shampo_min_mss_size: the minimum payload size of packet that can open
   a new session or be merged to a session.

 - shampo_max_log_headers_entry_size: the maximum allowed value of the field
   WQ.log_headers_entry_size

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |  6 ++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  1 +
 include/linux/mlx5/device.h                   |  4 ++
 include/linux/mlx5/mlx5_ifc.h                 | 56 ++++++++++++++++++-
 4 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 1037e3629e7e..2d8406fab844 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -269,6 +269,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN(dev, shampo)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_DEV_SHAMPO);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f8446395163a..a92a92a52346 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1417,6 +1417,7 @@ static const int types[] = {
 	MLX5_CAP_VDPA_EMULATION,
 	MLX5_CAP_IPSEC,
 	MLX5_CAP_PORT_SELECTION,
+	MLX5_CAP_DEV_SHAMPO,
 };
 
 static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index f8a0bbb42c3b..0d30a6184e1d 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1186,6 +1186,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_VDPA_EMULATION = 0x13,
 	MLX5_CAP_DEV_EVENT = 0x14,
 	MLX5_CAP_IPSEC,
+	MLX5_CAP_DEV_SHAMPO = 0x1d,
 	MLX5_CAP_GENERAL_2 = 0x20,
 	MLX5_CAP_PORT_SELECTION = 0x25,
 	/* NUM OF CAP Types */
@@ -1431,6 +1432,9 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_IPSEC(mdev, cap)\
 	MLX5_GET(ipsec_cap, (mdev)->caps.hca[MLX5_CAP_IPSEC]->cur, cap)
 
+#define MLX5_CAP_DEV_SHAMPO(mdev, cap)\
+	MLX5_GET(shampo_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_SHAMPO], cap)
+
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
 	MLX5_CMD_STAT_INT_ERR			= 0x1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 21c0fd478afa..f1c134af5fcf 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1350,7 +1350,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_b0[0x1];
 	u8         uplink_follow[0x1];
 	u8         ts_cqe_to_dest_cqn[0x1];
-	u8         reserved_at_b3[0xd];
+	u8         reserved_at_b3[0x7];
+	u8         shampo[0x1];
+	u8         reserved_at_bb[0x5];
 
 	u8         max_sgl_for_optimized_performance[0x8];
 	u8         log_max_cq_sz[0x8];
@@ -1893,7 +1895,21 @@ struct mlx5_ifc_wq_bits {
 	u8         reserved_at_139[0x4];
 	u8         log_wqe_stride_size[0x3];
 
-	u8         reserved_at_140[0x4c0];
+	u8         reserved_at_140[0x80];
+
+	u8         headers_mkey[0x20];
+
+	u8         shampo_enable[0x1];
+	u8         reserved_at_1e1[0x4];
+	u8         log_reservation_size[0x3];
+	u8         reserved_at_1e8[0x5];
+	u8         log_max_num_of_packets_per_reservation[0x3];
+	u8         reserved_at_1f0[0x6];
+	u8         log_headers_entry_size[0x2];
+	u8         reserved_at_1f8[0x4];
+	u8         log_headers_buffer_entry_num[0x4];
+
+	u8         reserved_at_200[0x400];
 
 	struct mlx5_ifc_cmd_pas_bits pas[];
 };
@@ -3169,6 +3185,20 @@ struct mlx5_ifc_roce_addr_layout_bits {
 	u8         reserved_at_e0[0x20];
 };
 
+struct mlx5_ifc_shampo_cap_bits {
+	u8    reserved_at_0[0x3];
+	u8    shampo_log_max_reservation_size[0x5];
+	u8    reserved_at_8[0x3];
+	u8    shampo_log_min_reservation_size[0x5];
+	u8    shampo_min_mss_size[0x10];
+
+	u8    reserved_at_20[0x3];
+	u8    shampo_max_log_headers_entry_size[0x5];
+	u8    reserved_at_28[0x18];
+
+	u8    reserved_at_40[0x7c0];
+};
+
 union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_cmd_hca_cap_bits cmd_hca_cap;
 	struct mlx5_ifc_cmd_hca_cap_2_bits cmd_hca_cap_2;
@@ -3187,6 +3217,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_tls_cap_bits tls_cap;
 	struct mlx5_ifc_device_mem_cap_bits device_mem_cap;
 	struct mlx5_ifc_virtio_emulation_cap_bits virtio_emulation_cap;
+	struct mlx5_ifc_shampo_cap_bits shampo_cap;
 	u8         reserved_at_0[0x8000];
 };
 
@@ -3363,6 +3394,7 @@ enum {
 enum {
 	MLX5_TIRC_PACKET_MERGE_MASK_IPV4_LRO  = BIT(0),
 	MLX5_TIRC_PACKET_MERGE_MASK_IPV6_LRO  = BIT(1),
+	MLX5_TIRC_PACKET_MERGE_MASK_SHAMPO    = BIT(2),
 };
 
 enum {
@@ -3569,6 +3601,18 @@ enum {
 	MLX5_RQC_STATE_ERR  = 0x3,
 };
 
+enum {
+	MLX5_RQC_SHAMPO_NO_MATCH_ALIGNMENT_GRANULARITY_BYTE    = 0x0,
+	MLX5_RQC_SHAMPO_NO_MATCH_ALIGNMENT_GRANULARITY_STRIDE  = 0x1,
+	MLX5_RQC_SHAMPO_NO_MATCH_ALIGNMENT_GRANULARITY_PAGE    = 0x2,
+};
+
+enum {
+	MLX5_RQC_SHAMPO_MATCH_CRITERIA_TYPE_NO_MATCH    = 0x0,
+	MLX5_RQC_SHAMPO_MATCH_CRITERIA_TYPE_EXTENDED    = 0x1,
+	MLX5_RQC_SHAMPO_MATCH_CRITERIA_TYPE_FIVE_TUPLE  = 0x2,
+};
+
 struct mlx5_ifc_rqc_bits {
 	u8         rlky[0x1];
 	u8	   delay_drop_en[0x1];
@@ -3601,7 +3645,13 @@ struct mlx5_ifc_rqc_bits {
 	u8         reserved_at_c0[0x10];
 	u8         hairpin_peer_vhca[0x10];
 
-	u8         reserved_at_e0[0xa0];
+	u8         reserved_at_e0[0x46];
+	u8         shampo_no_match_alignment_granularity[0x2];
+	u8         reserved_at_128[0x6];
+	u8         shampo_match_criteria_type[0x2];
+	u8         reservation_timeout[0x10];
+
+	u8         reserved_at_140[0x40];
 
 	struct mlx5_ifc_wq_bits wq;
 };
-- 
2.31.1

