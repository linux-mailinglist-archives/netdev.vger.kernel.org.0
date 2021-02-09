Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90766314FDD
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhBINMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:38664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231236AbhBINL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 08:11:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED46A64ECF;
        Tue,  9 Feb 2021 13:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612876276;
        bh=t2gv9NuHu81/P4lVcg74MmEk30bb5ixvdQv+rUWc8ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzhgLBPhq9ivqWI8NDIA8ee1jHhByjy+DkuvNsXfp4fM2yjegByyKh6NTxDF64r+W
         47JyGagpP+D9vciPyax4iyY2TckMj8jGnd/LPGYKWwobE+zki083NvRewx2spjyIkI
         ScOB1Ve6Hv4yNQvKky77+Yb9NCZnd9keH6H0jKPmYrIwTcq6AKKCi2uFXl3DPfy+ht
         JsDzv+cZ3pMCKUgp2FGi5Bg/ontcmhse6BAOIvPrmiz0ZW22x6TrsKEy+zf6wBu1t4
         rtL2nO4YL8MvmbXw/H9apSjRAMIJ/9KvT84iXR4AUU5jDoo+mwrPQQPyr9xRXAgz5q
         OEdxswiH1dH9g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Add new timestamp mode bits
Date:   Tue,  9 Feb 2021 15:11:06 +0200
Message-Id: <20210209131107.698833-2-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210209131107.698833-1-leon@kernel.org>
References: <20210209131107.698833-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

These fields declare which timestamp mode is supported by the device
per RQ/SQ/QP.

In addiition add the ts_format field to the select the mode for
RQ/SQ/QP.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 54 +++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b96f99f1198e..77051bd5c1cf 100644
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

@@ -1258,6 +1265,18 @@ enum {
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
@@ -1569,7 +1588,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {

 	u8         general_obj_types[0x40];

-	u8         reserved_at_440[0x4];
+	u8         sq_ts_format[0x2];
+	u8         rq_ts_format[0x2];
 	u8         steering_format_version[0x4];
 	u8         create_qp_start_hint[0x18];

@@ -2873,6 +2893,12 @@ enum {
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
@@ -2901,7 +2927,9 @@ struct mlx5_ifc_qpc_bits {
 	u8         log_rq_stride[0x3];
 	u8         no_sq[0x1];
 	u8         log_sq_size[0x4];
-	u8         reserved_at_55[0x6];
+	u8         reserved_at_55[0x3];
+	u8	   ts_format[0x2];
+	u8         reserved_at_5a[0x1];
 	u8         rlky[0x1];
 	u8         ulp_stateless_offload_mode[0x4];

@@ -3317,6 +3345,12 @@ enum {
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
@@ -3328,7 +3362,9 @@ struct mlx5_ifc_sqc_bits {
 	u8         reg_umr[0x1];
 	u8         allow_swp[0x1];
 	u8         hairpin[0x1];
-	u8         reserved_at_f[0x11];
+	u8         reserved_at_f[0xb];
+	u8	   ts_format[0x2];
+	u8	   reserved_at_1c[0x4];

 	u8         reserved_at_20[0x8];
 	u8         user_index[0x18];
@@ -3419,6 +3455,12 @@ enum {
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
@@ -3429,7 +3471,9 @@ struct mlx5_ifc_rqc_bits {
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

