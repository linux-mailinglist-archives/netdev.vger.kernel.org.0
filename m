Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A72A3EE05A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhHPXXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234317AbhHPXXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 19:23:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D469660F38;
        Mon, 16 Aug 2021 23:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629156154;
        bh=ys5Wtbj38INzieqlL2VNhAo4y3ZFMXqPO7sh/GqZMYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dn5//JFJaY4kTwEWA27YRTB+3tVPnCuE+2fVTNtGN+3pMh+Fs6UsFJKQfolTE5yZj
         o0Pfnmjeg2CCW9igf6uW8V1DF2NO3obiaKaXbm4/u6Y8rB9zEEAV4wm+ivHUMxE5vN
         hia1bfn0bVmEcBS4mkMhoDnUTs0Hz3nKhAHPaBdtW/V4YhCUFdBYOZwMBQ3imB6Ij9
         JdCU9Mjfiv7JPpY+r3lNJO1eXUCIOZTbDv45UHc6lhsUFxBB+zU82McaJCBfGyfSdu
         o8EZlYRx9GLjlalxgpfHRgCDYZm2cr8FVqLHsLsokYIV/O+wvD05sp84VKnF7s5G99
         /6c0wYeC38h2w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 09/17] net/mlx5e: Maintain MQPRIO mode parameter
Date:   Mon, 16 Aug 2021 16:22:11 -0700
Message-Id: <20210816232219.557083-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816232219.557083-1-saeed@kernel.org>
References: <20210816232219.557083-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

This is in preparation for supporting MQPRIO CHANNEL mode in
downstream patch, in addition to DCB mode that's supported today.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 41 +++++++++++--------
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 1ddf320af831..3dbcb2cf2ff8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -249,6 +249,7 @@ struct mlx5e_params {
 	u8  log_rq_mtu_frames;
 	u16 num_channels;
 	struct {
+		u16 mode;
 		u8 num_tc;
 	} mqprio;
 	bool rx_cqe_compress_def;
@@ -272,7 +273,8 @@ struct mlx5e_params {
 
 static inline u8 mlx5e_get_dcb_num_tc(struct mlx5e_params *params)
 {
-	return params->mqprio.num_tc;
+	return params->mqprio.mode == TC_MQPRIO_MODE_DCB ?
+		params->mqprio.num_tc : 1;
 }
 
 enum {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b2f95cd34622..0d84eb17707e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2847,41 +2847,47 @@ static int mlx5e_modify_channels_vsd(struct mlx5e_channels *chs, bool vsd)
 	return 0;
 }
 
-static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
-				 struct tc_mqprio_qopt *mqprio)
+static int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
+				     struct tc_mqprio_qopt *mqprio)
 {
 	struct mlx5e_params new_params;
 	u8 tc = mqprio->num_tc;
-	int err = 0;
+	int err;
 
 	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
 
 	if (tc && tc != MLX5E_MAX_NUM_TC)
 		return -EINVAL;
 
-	mutex_lock(&priv->state_lock);
-
-	/* MQPRIO is another toplevel qdisc that can't be attached
-	 * simultaneously with the offloaded HTB.
-	 */
-	if (WARN_ON(priv->htb.maj_id)) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	new_params = priv->channels.params;
+	new_params.mqprio.mode = TC_MQPRIO_MODE_DCB;
 	new_params.mqprio.num_tc = tc ? tc : 1;
 
 	err = mlx5e_safe_switch_params(priv, &new_params,
 				       mlx5e_num_channels_changed_ctx, NULL, true);
 
-out:
 	priv->max_opened_tc = max_t(u8, priv->max_opened_tc,
 				    mlx5e_get_dcb_num_tc(&priv->channels.params));
-	mutex_unlock(&priv->state_lock);
 	return err;
 }
 
+static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
+				 struct tc_mqprio_qopt_offload *mqprio)
+{
+	/* MQPRIO is another toplevel qdisc that can't be attached
+	 * simultaneously with the offloaded HTB.
+	 */
+	if (WARN_ON(priv->htb.maj_id))
+		return -EINVAL;
+
+	switch (mqprio->mode) {
+	case TC_MQPRIO_MODE_DCB:
+		return mlx5e_setup_tc_mqprio_dcb(priv, &mqprio->qopt);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int mlx5e_setup_tc_htb(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb)
 {
 	int res;
@@ -2951,7 +2957,10 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 						  priv, priv, true);
 	}
 	case TC_SETUP_QDISC_MQPRIO:
-		return mlx5e_setup_tc_mqprio(priv, type_data);
+		mutex_lock(&priv->state_lock);
+		err = mlx5e_setup_tc_mqprio(priv, type_data);
+		mutex_unlock(&priv->state_lock);
+		return err;
 	case TC_SETUP_QDISC_HTB:
 		mutex_lock(&priv->state_lock);
 		err = mlx5e_setup_tc_htb(priv, type_data);
-- 
2.31.1

