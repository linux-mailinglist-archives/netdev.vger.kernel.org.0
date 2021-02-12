Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A561531A7C6
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhBLWee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232255AbhBLWb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:31:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E66A64E95;
        Fri, 12 Feb 2021 22:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613169047;
        bh=43iIp8MlKP64CBceILV86YQjhsOYOsL90CaPpAeF5ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6bhVJj/eEHcdknuulJtFCv8oo/1Gw9N7/1bNQ8atsoJK6J6fYw5yxliiTG7RB1De
         NocKHm1Qke+tRfOSKCcIT8I4tpx2FM5QIIFsFB52AzkLTOIiHbpxNv4F5M8CBKrCIy
         bhAB7ge7orLM4TD/JHedMZWygyL6GHwNkox5bR7umFXSM3gggYKixKx3deVKSwRMyB
         bAbGPMjC6gXdHg+va82CRzEzKdyElMd4MSSUlCpVE14eg5D92BnLCTuqNYvB1ScI9K
         BIHrdpGVntAqOkLbMo7PUK6veMPFPZ2+CBho48DzUXzsS7SOoxiIFlPUYCj0rG0zTB
         XcGGWKE7+spUA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Aharon Landau <aharonl@nvidia.com>
Subject: [PATCH mlx5-next 1/6] net/mlx5: Add new timestamp mode bits
Date:   Fri, 12 Feb 2021 14:30:37 -0800
Message-Id: <20210212223042.449816-2-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212223042.449816-1-saeed@kernel.org>
References: <20210212223042.449816-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

These fields declare which timestamp mode is supported by the device
per RQ/SQ/QP.

In addition add the ts_format field to the select the mode for
RQ/SQ/QP.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 54 +++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index cf692fc17f41..436d6f421dfd 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -932,11 +932,18 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {
 	u8         reserved_at_200[0x600];
 };
 
+enum {
+	MLX5_QP_TIMESTAMP_FORMAT_CAP_FREE_RUNNING               = 0x0,
+	MLX5_QP_TIMESTAMP_FORMAT_CAP_REAL_TIME                  = 0x1,
+	MLX5_QP_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME = 0x2,
+};
+
 struct mlx5_ifc_roce_cap_bits {
 	u8         roce_apm[0x1];
 	u8         reserved_at_1[0x3];
 	u8         sw_r_roce_src_udp_port[0x1];
-	u8         reserved_at_5[0x1b];
+	u8         reserved_at_5[0x19];
+	u8	   qp_ts_format[0x2];
 
 	u8         reserved_at_20[0x60];
 
@@ -1253,6 +1260,18 @@ enum {
 	MLX5_STEERING_FORMAT_CONNECTX_6DX = 1,
 };
 
+enum {
+	MLX5_SQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING               = 0x0,
+	MLX5_SQ_TIMESTAMP_FORMAT_CAP_REAL_TIME                  = 0x1,
+	MLX5_SQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME = 0x2,
+};
+
+enum {
+	MLX5_RQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING               = 0x0,
+	MLX5_RQ_TIMESTAMP_FORMAT_CAP_REAL_TIME                  = 0x1,
+	MLX5_RQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME = 0x2,
+};
+
 struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_0[0x1f];
 	u8         vhca_resource_manager[0x1];
@@ -1564,7 +1583,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         general_obj_types[0x40];
 
-	u8         reserved_at_440[0x4];
+	u8         sq_ts_format[0x2];
+	u8         rq_ts_format[0x2];
 	u8         steering_format_version[0x4];
 	u8         create_qp_start_hint[0x18];
 
@@ -2868,6 +2888,12 @@ enum {
 	MLX5_QPC_CS_RES_UP_TO_64B  = 0x2,
 };
 
+enum {
+	MLX5_QPC_TIMESTAMP_FORMAT_FREE_RUNNING = 0x0,
+	MLX5_QPC_TIMESTAMP_FORMAT_DEFAULT      = 0x1,
+	MLX5_QPC_TIMESTAMP_FORMAT_REAL_TIME    = 0x2,
+};
+
 struct mlx5_ifc_qpc_bits {
 	u8         state[0x4];
 	u8         lag_tx_port_affinity[0x4];
@@ -2896,7 +2922,9 @@ struct mlx5_ifc_qpc_bits {
 	u8         log_rq_stride[0x3];
 	u8         no_sq[0x1];
 	u8         log_sq_size[0x4];
-	u8         reserved_at_55[0x6];
+	u8         reserved_at_55[0x3];
+	u8	   ts_format[0x2];
+	u8         reserved_at_5a[0x1];
 	u8         rlky[0x1];
 	u8         ulp_stateless_offload_mode[0x4];
 
@@ -3312,6 +3340,12 @@ enum {
 	MLX5_SQC_STATE_ERR  = 0x3,
 };
 
+enum {
+	MLX5_SQC_TIMESTAMP_FORMAT_FREE_RUNNING = 0x0,
+	MLX5_SQC_TIMESTAMP_FORMAT_DEFAULT      = 0x1,
+	MLX5_SQC_TIMESTAMP_FORMAT_REAL_TIME    = 0x2,
+};
+
 struct mlx5_ifc_sqc_bits {
 	u8         rlky[0x1];
 	u8         cd_master[0x1];
@@ -3323,7 +3357,9 @@ struct mlx5_ifc_sqc_bits {
 	u8         reg_umr[0x1];
 	u8         allow_swp[0x1];
 	u8         hairpin[0x1];
-	u8         reserved_at_f[0x11];
+	u8         reserved_at_f[0xb];
+	u8	   ts_format[0x2];
+	u8	   reserved_at_1c[0x4];
 
 	u8         reserved_at_20[0x8];
 	u8         user_index[0x18];
@@ -3414,6 +3450,12 @@ enum {
 	MLX5_RQC_STATE_ERR  = 0x3,
 };
 
+enum {
+	MLX5_RQC_TIMESTAMP_FORMAT_FREE_RUNNING = 0x0,
+	MLX5_RQC_TIMESTAMP_FORMAT_DEFAULT      = 0x1,
+	MLX5_RQC_TIMESTAMP_FORMAT_REAL_TIME    = 0x2,
+};
+
 struct mlx5_ifc_rqc_bits {
 	u8         rlky[0x1];
 	u8	   delay_drop_en[0x1];
@@ -3424,7 +3466,9 @@ struct mlx5_ifc_rqc_bits {
 	u8         reserved_at_c[0x1];
 	u8         flush_in_error_en[0x1];
 	u8         hairpin[0x1];
-	u8         reserved_at_f[0x11];
+	u8         reserved_at_f[0xb];
+	u8	   ts_format[0x2];
+	u8	   reserved_at_1c[0x4];
 
 	u8         reserved_at_20[0x8];
 	u8         user_index[0x18];
-- 
2.29.2

