Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2541517784A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbgCCOIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:08:46 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34448 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728882AbgCCOIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 09:08:46 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Mar 2020 16:08:44 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 023E8fBi019613;
        Tue, 3 Mar 2020 16:08:42 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     parav@mellanox.com, jiri@mellanox.com, moshe@mellanox.com,
        vladyslavt@mellanox.com, saeedm@mellanox.com, leon@kernel.org
Subject: [PATCH] IB/mlx5: Add np_min_time_between_cnps and rp_max_rate debug params
Date:   Tue,  3 Mar 2020 08:08:30 -0600
Message-Id: <20200303140834.7501-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two debugfs parameters described below.

np_min_time_between_cnps - Minimum time between sending CNPs from the
                           port.
                           Unit = microseconds.
                           Default = 0.

rp_max_rate - Maximum rate at which reaction point node can transmit.
              Once this limit is reached, RP is no longer rate limited.
              Unit = Mbits/sec
              Default = 0 (full speed)

issue: 961226
Change-Id: I14544168ed115acaeb8ff900ac092fad2f1bb68f
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cong.c    | 20 ++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index 8ba439fabf7f..de4da92b81a6 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -47,6 +47,7 @@ static const char * const mlx5_ib_dbg_cc_name[] = {
 	"rp_byte_reset",
 	"rp_threshold",
 	"rp_ai_rate",
+	"rp_max_rate",
 	"rp_hai_rate",
 	"rp_min_dec_fac",
 	"rp_min_rate",
@@ -56,6 +57,7 @@ static const char * const mlx5_ib_dbg_cc_name[] = {
 	"rp_rate_reduce_monitor_period",
 	"rp_initial_alpha_value",
 	"rp_gd",
+	"np_min_time_between_cnps",
 	"np_cnp_dscp",
 	"np_cnp_prio_mode",
 	"np_cnp_prio",
@@ -66,6 +68,7 @@ static const char * const mlx5_ib_dbg_cc_name[] = {
 #define MLX5_IB_RP_TIME_RESET_ATTR			BIT(3)
 #define MLX5_IB_RP_BYTE_RESET_ATTR			BIT(4)
 #define MLX5_IB_RP_THRESHOLD_ATTR			BIT(5)
+#define MLX5_IB_RP_MAX_RATE_ATTR			BIT(6)
 #define MLX5_IB_RP_AI_RATE_ATTR				BIT(7)
 #define MLX5_IB_RP_HAI_RATE_ATTR			BIT(8)
 #define MLX5_IB_RP_MIN_DEC_FAC_ATTR			BIT(9)
@@ -77,6 +80,7 @@ static const char * const mlx5_ib_dbg_cc_name[] = {
 #define MLX5_IB_RP_INITIAL_ALPHA_VALUE_ATTR		BIT(15)
 #define MLX5_IB_RP_GD_ATTR				BIT(16)
 
+#define MLX5_IB_NP_MIN_TIME_BETWEEN_CNPS_ATTR		BIT(2)
 #define MLX5_IB_NP_CNP_DSCP_ATTR			BIT(3)
 #define MLX5_IB_NP_CNP_PRIO_MODE_ATTR			BIT(4)
 
@@ -111,6 +115,9 @@ static u32 mlx5_get_cc_param_val(void *field, int offset)
 	case MLX5_IB_DBG_CC_RP_AI_RATE:
 		return MLX5_GET(cong_control_r_roce_ecn_rp, field,
 				rpg_ai_rate);
+	case MLX5_IB_DBG_CC_RP_MAX_RATE:
+		return MLX5_GET(cong_control_r_roce_ecn_rp, field,
+				rpg_max_rate);
 	case MLX5_IB_DBG_CC_RP_HAI_RATE:
 		return MLX5_GET(cong_control_r_roce_ecn_rp, field,
 				rpg_hai_rate);
@@ -138,6 +145,9 @@ static u32 mlx5_get_cc_param_val(void *field, int offset)
 	case MLX5_IB_DBG_CC_RP_GD:
 		return MLX5_GET(cong_control_r_roce_ecn_rp, field,
 				rpg_gd);
+	case MLX5_IB_DBG_CC_NP_MIN_TIME_BETWEEN_CNPS:
+		return MLX5_GET(cong_control_r_roce_ecn_np, field,
+				min_time_between_cnps);
 	case MLX5_IB_DBG_CC_NP_CNP_DSCP:
 		return MLX5_GET(cong_control_r_roce_ecn_np, field,
 				cnp_dscp);
@@ -186,6 +196,11 @@ static void mlx5_ib_set_cc_param_mask_val(void *field, int offset,
 		MLX5_SET(cong_control_r_roce_ecn_rp, field,
 			 rpg_ai_rate, var);
 		break;
+	case MLX5_IB_DBG_CC_RP_MAX_RATE:
+		*attr_mask |= MLX5_IB_RP_MAX_RATE_ATTR;
+		MLX5_SET(cong_control_r_roce_ecn_rp, field,
+			 rpg_max_rate, var);
+		break;
 	case MLX5_IB_DBG_CC_RP_HAI_RATE:
 		*attr_mask |= MLX5_IB_RP_HAI_RATE_ATTR;
 		MLX5_SET(cong_control_r_roce_ecn_rp, field,
@@ -231,6 +246,11 @@ static void mlx5_ib_set_cc_param_mask_val(void *field, int offset,
 		MLX5_SET(cong_control_r_roce_ecn_rp, field,
 			 rpg_gd, var);
 		break;
+	case MLX5_IB_DBG_CC_NP_MIN_TIME_BETWEEN_CNPS:
+		*attr_mask |= MLX5_IB_NP_MIN_TIME_BETWEEN_CNPS_ATTR;
+		MLX5_SET(cong_control_r_roce_ecn_np, field,
+			 min_time_between_cnps, var);
+		break;
 	case MLX5_IB_DBG_CC_NP_CNP_DSCP:
 		*attr_mask |= MLX5_IB_NP_CNP_DSCP_ATTR;
 		MLX5_SET(cong_control_r_roce_ecn_np, field, cnp_dscp, var);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index d9bffcc93587..4cbc87c79951 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -792,6 +792,7 @@ enum mlx5_ib_dbg_cc_types {
 	MLX5_IB_DBG_CC_RP_BYTE_RESET,
 	MLX5_IB_DBG_CC_RP_THRESHOLD,
 	MLX5_IB_DBG_CC_RP_AI_RATE,
+	MLX5_IB_DBG_CC_RP_MAX_RATE,
 	MLX5_IB_DBG_CC_RP_HAI_RATE,
 	MLX5_IB_DBG_CC_RP_MIN_DEC_FAC,
 	MLX5_IB_DBG_CC_RP_MIN_RATE,
@@ -801,6 +802,7 @@ enum mlx5_ib_dbg_cc_types {
 	MLX5_IB_DBG_CC_RP_RATE_REDUCE_MONITOR_PERIOD,
 	MLX5_IB_DBG_CC_RP_INITIAL_ALPHA_VALUE,
 	MLX5_IB_DBG_CC_RP_GD,
+	MLX5_IB_DBG_CC_NP_MIN_TIME_BETWEEN_CNPS,
 	MLX5_IB_DBG_CC_NP_CNP_DSCP,
 	MLX5_IB_DBG_CC_NP_CNP_PRIO_MODE,
 	MLX5_IB_DBG_CC_NP_CNP_PRIO,
-- 
2.19.2

