Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2212931A7C7
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhBLWfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:35:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230494AbhBLWb3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:31:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20E9A64E9D;
        Fri, 12 Feb 2021 22:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613169048;
        bh=o0AveBi/o25MjbDARUrqewOjtfg6rRZehFZQeQ/Mc2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlgWyYU9c0V7msJvIdR4LXE8p4WjXl2A8ttUOSNLv6L5V8y8W1b2jkdBRsWTREP/J
         AWSQuXLa/uqy6PkoRn12XxbQL780xr4b28O/LDDb8pyFqfRMacuid5DW08wcfL+ZDv
         kaL9Q4lPSS1PQIW5NniR2HFJhN5eOEkhvdvBhekftljwI9CpAtYWN9WREJ26vjzlCs
         I0oa/oD57q6XKnip76aDfzb9BY1S/Cw2l1GpJuygSaz8qmvS0LWBXzFvHg+fEb+Q44
         SU0X9JMv+a70f4C4l1THDY+HTImcC9giy2Yk9TVZfV4lDTuYi1mbLtk/zSgIoyNHa+
         oDOJ5fOKrgeGg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH mlx5-next 2/6] net/mlx5: Add register layout to support real-time time-stamp
Date:   Fri, 12 Feb 2021 14:30:38 -0800
Message-Id: <20210212223042.449816-3-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212223042.449816-1-saeed@kernel.org>
References: <20210212223042.449816-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Add needed structure layouts and defines for MTUTC (Management UTC)
register. MTUTC will be used for cyc2time HW translation.

In addition, add cyc2time modify capability bit and init segment HCA
real time address.

Finally, add capability bits indicating which time-stamping format is
supported per SQ and RQ. Add ts_format in the queue's context layout to
allow configuration.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/device.h   |  5 ++++-
 include/linux/mlx5/driver.h   |  1 +
 include/linux/mlx5/mlx5_ifc.h | 30 ++++++++++++++++++++++++++++--
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index f1de49d64a98..fd694add6ff0 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -578,7 +578,10 @@ struct mlx5_init_seg {
 	__be32			internal_timer_l;
 	__be32			rsvd3[2];
 	__be32			health_counter;
-	__be32			rsvd4[1019];
+	__be32			rsvd4[11];
+	__be32			real_time_h;
+	__be32			real_time_l;
+	__be32			rsvd5[1006];
 	__be64			ieee1588_clk;
 	__be32			ieee1588_clk_type;
 	__be32			clr_intx;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f93bfe7473aa..2eb7755143d7 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -143,6 +143,7 @@ enum {
 	MLX5_REG_MPCNT		 = 0x9051,
 	MLX5_REG_MTPPS		 = 0x9053,
 	MLX5_REG_MTPPSE		 = 0x9054,
+	MLX5_REG_MTUTC		 = 0x9055,
 	MLX5_REG_MPEGC		 = 0x9056,
 	MLX5_REG_MCQS		 = 0x9060,
 	MLX5_REG_MCQI		 = 0x9061,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 436d6f421dfd..7059fcdf54a3 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9150,6 +9150,28 @@ struct mlx5_ifc_mpegc_reg_bits {
 	u8         reserved_at_60[0x100];
 };
 
+enum {
+	MLX5_MTUTC_OPERATION_SET_TIME_IMMEDIATE   = 0x1,
+	MLX5_MTUTC_OPERATION_ADJUST_TIME          = 0x2,
+	MLX5_MTUTC_OPERATION_ADJUST_FREQ_UTC      = 0x3,
+};
+
+struct mlx5_ifc_mtutc_reg_bits {
+	u8         reserved_at_0[0x1c];
+	u8         operation[0x4];
+
+	u8         freq_adjustment[0x20];
+
+	u8         reserved_at_40[0x40];
+
+	u8         utc_sec[0x20];
+
+	u8         reserved_at_a0[0x2];
+	u8         utc_nsec[0x1e];
+
+	u8         time_adjustment[0x20];
+};
+
 struct mlx5_ifc_pcam_enhanced_features_bits {
 	u8         reserved_at_0[0x68];
 	u8         fec_50G_per_lane_in_pplm[0x1];
@@ -9208,7 +9230,9 @@ struct mlx5_ifc_pcam_reg_bits {
 };
 
 struct mlx5_ifc_mcam_enhanced_features_bits {
-	u8         reserved_at_0[0x6e];
+	u8         reserved_at_0[0x6b];
+	u8         ptpcyc2realtime_modify[0x1];
+	u8         reserved_at_6c[0x2];
 	u8         pci_status_and_power[0x1];
 	u8         reserved_at_6f[0x5];
 	u8         mark_tx_action_cnp[0x1];
@@ -9231,7 +9255,8 @@ struct mlx5_ifc_mcam_access_reg_bits {
 
 	u8         regs_95_to_87[0x9];
 	u8         mpegc[0x1];
-	u8         regs_85_to_68[0x12];
+	u8         mtutc[0x1];
+	u8         regs_84_to_68[0x11];
 	u8         tracer_registers[0x4];
 
 	u8         regs_63_to_32[0x20];
@@ -9964,6 +9989,7 @@ union mlx5_ifc_ports_control_registers_document_bits {
 	struct mlx5_ifc_mcda_reg_bits mcda_reg;
 	struct mlx5_ifc_mirc_reg_bits mirc_reg;
 	struct mlx5_ifc_mfrl_reg_bits mfrl_reg;
+	struct mlx5_ifc_mtutc_reg_bits mtutc_reg;
 	u8         reserved_at_0[0x60e0];
 };
 
-- 
2.29.2

