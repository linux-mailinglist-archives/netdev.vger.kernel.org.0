Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417E9486ED0
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344228AbiAGAab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344223AbiAGAaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4385AC0611FD
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D855861D00
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000AAC36AE0;
        Fri,  7 Jan 2022 00:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515414;
        bh=Ok8+wc0VBWk8OTMltN7+7ugd6v1lNLzWwzqYp73VLQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1AnT7EfGxdOLb8+lQA8x7VNasfqETIuiNG1KMFpG43LD/NnD7lmL039AbLBkVfxE
         UmE/U2gUpiDIl/YWeSze6mc29sqRYM2Z8eyspi4N7xhN/SjzjSycjO9j3f2aVn67/G
         d7D4+RsQIzcPiP2QSu5kxjwxNEbQThzLmYA0MKjOfXpP0GwJgHTONYwGQWiLlO93af
         SnBwpcWUWJRGqZpnmvc9KKbaUoV4Wr6C+zTSbighlbakkYyu+mzHkcnjaKRk+2CFgX
         S4EpmYBFZ75vjCOa40qFMUn6oi/1L7PKTQCrIUlJj3OSVmVUKxJBlYlvxLNdW7O7Ay
         gK9lmBwYZzuyw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Lama Kayal <lkayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 08/15] net/mlx5e: Expose FEC counters via ethtool
Date:   Thu,  6 Jan 2022 16:29:49 -0800
Message-Id: <20220107002956.74849-9-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Add FEC counters' statistics of corrected_blocks and
uncorrectable_blocks, along with their lanes via ethtool.

HW supports corrected_blocks and uncorrectable_blocks counters both for
RS-FEC mode and FC-FEC mode. In FC mode these counters are accumulated
per lane, while in RS mode the correction method crosses lanes, thus
only total corrected_blocks and uncorrectable_blocks are reported in
this mode.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 101 +++++++++++++++++-
 1 file changed, 98 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 73fcd9fb17dd..7e7c0c1019f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -35,6 +35,7 @@
 #include "en_accel/tls.h"
 #include "en_accel/en_accel.h"
 #include "en/ptp.h"
+#include "en/port.h"
 
 static unsigned int stats_grps_num(struct mlx5e_priv *priv)
 {
@@ -1158,12 +1159,99 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(phy)
 	mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT, 0, 0);
 }
 
-void mlx5e_stats_fec_get(struct mlx5e_priv *priv,
-			 struct ethtool_fec_stats *fec_stats)
+static int fec_num_lanes(struct mlx5_core_dev *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(pmlp_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(pmlp_reg)] = {};
+	int err;
+
+	MLX5_SET(pmlp_reg, in, local_port, 1);
+	err = mlx5_core_access_reg(dev, in, sizeof(in), out, sizeof(out),
+				   MLX5_REG_PMLP, 0, 0);
+	if (err)
+		return 0;
+
+	return MLX5_GET(pmlp_reg, out, width);
+}
+
+static int fec_active_mode(struct mlx5_core_dev *mdev)
+{
+	unsigned long fec_active_long;
+	u32 fec_active;
+
+	if (mlx5e_get_fec_mode(mdev, &fec_active, NULL))
+		return MLX5E_FEC_NOFEC;
+
+	fec_active_long = fec_active;
+	return find_first_bit(&fec_active_long, sizeof(unsigned long) * BITS_PER_BYTE);
+}
+
+#define MLX5E_STATS_SET_FEC_BLOCK(idx) ({ \
+	fec_stats->corrected_blocks.lanes[(idx)] = \
+		MLX5E_READ_CTR64_BE_F(ppcnt, phys_layer_cntrs, \
+				      fc_fec_corrected_blocks_lane##idx); \
+	fec_stats->uncorrectable_blocks.lanes[(idx)] = \
+		MLX5E_READ_CTR64_BE_F(ppcnt, phys_layer_cntrs, \
+				      fc_fec_uncorrectable_blocks_lane##idx); \
+})
+
+static void fec_set_fc_stats(struct ethtool_fec_stats *fec_stats,
+			     u32 *ppcnt, u8 lanes)
+{
+	if (lanes > 3) { /* 4 lanes */
+		MLX5E_STATS_SET_FEC_BLOCK(3);
+		MLX5E_STATS_SET_FEC_BLOCK(2);
+	}
+	if (lanes > 1) /* 2 lanes */
+		MLX5E_STATS_SET_FEC_BLOCK(1);
+	if (lanes > 0) /* 1 lane */
+		MLX5E_STATS_SET_FEC_BLOCK(0);
+}
+
+static void fec_set_rs_stats(struct ethtool_fec_stats *fec_stats, u32 *ppcnt)
+{
+	fec_stats->corrected_blocks.total =
+		MLX5E_READ_CTR64_BE_F(ppcnt, phys_layer_cntrs,
+				      rs_fec_corrected_blocks);
+	fec_stats->uncorrectable_blocks.total =
+		MLX5E_READ_CTR64_BE_F(ppcnt, phys_layer_cntrs,
+				      rs_fec_uncorrectable_blocks);
+}
+
+static void fec_set_block_stats(struct mlx5e_priv *priv,
+				struct ethtool_fec_stats *fec_stats)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	u32 out[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
+	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
+	int mode = fec_active_mode(mdev);
+
+	if (mode == MLX5E_FEC_NOFEC)
+		return;
+
+	MLX5_SET(ppcnt_reg, in, local_port, 1);
+	MLX5_SET(ppcnt_reg, in, grp, MLX5_PHYSICAL_LAYER_COUNTERS_GROUP);
+	if (mlx5_core_access_reg(mdev, in, sz, outl, sz, MLX5_REG_PPCNT, 0, 0))
+		return;
+
+	switch (mode) {
+	case MLX5E_FEC_RS_528_514:
+	case MLX5E_FEC_RS_544_514:
+	case MLX5E_FEC_LLRS_272_257_1:
+		fec_set_rs_stats(fec_stats, out);
+		return;
+	case MLX5E_FEC_FIRECODE:
+		fec_set_fc_stats(fec_stats, out, fec_num_lanes(mdev));
+	}
+}
+
+static void fec_set_corrected_bits_total(struct mlx5e_priv *priv,
+					 struct ethtool_fec_stats *fec_stats)
 {
 	u32 ppcnt_phy_statistical[MLX5_ST_SZ_DW(ppcnt_reg)];
 	struct mlx5_core_dev *mdev = priv->mdev;
-	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {0};
+	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
 
 	if (!MLX5_CAP_PCAM_FEATURE(mdev, ppcnt_statistical_group))
@@ -1181,6 +1269,13 @@ void mlx5e_stats_fec_get(struct mlx5e_priv *priv,
 				      phy_corrected_bits);
 }
 
+void mlx5e_stats_fec_get(struct mlx5e_priv *priv,
+			 struct ethtool_fec_stats *fec_stats)
+{
+	fec_set_corrected_bits_total(priv, fec_stats);
+	fec_set_block_stats(priv, fec_stats);
+}
+
 #define PPORT_ETH_EXT_OFF(c) \
 	MLX5_BYTE_OFF(ppcnt_reg, \
 		      counter_set.eth_extended_cntrs_grp_data_layout.c##_high)
-- 
2.33.1

