Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB183EDF3C
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbhHPVT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233498AbhHPVTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70C76610A0;
        Mon, 16 Aug 2021 21:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629148745;
        bh=ys5Wtbj38INzieqlL2VNhAo4y3ZFMXqPO7sh/GqZMYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBmbXwLt1ZSKSE6Mg3vkuSKcg1cjItP4FIDJNLKhclcGqN4OpFKKmvvoCxhoqdB1v
         A3gD4Ul5sXSwjbJr+RrxQVJByPDH0oY8reDksHQ/sIt+LsmAuYwvX1HbFjfGvQvB7d
         tUPe/ux4fPTy23ujbnjfLstvmkWhhO0R5VTvn8zSPM61KaviDaRpE/RXO2c7D3EBmX
         qG0ehpKbmhypfrEHJ01+rVNnmzfCCff1f0sGty2S2I9/5jzmbjtYkst+kdgakq57Ss
         2VHZMwnsgv9FMNWXe5ROC+eO+YRI4yGStCu8Mghx91ohOiN29KrAvUeKF/A6QvOPZi
         oDVFrCtvyEO+w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/17] net/mlx5e: Maintain MQPRIO mode parameter
Date:   Mon, 16 Aug 2021 14:18:39 -0700
Message-Id: <20210816211847.526937-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816211847.526937-1-saeed@kernel.org>
References: <20210816211847.526937-1-saeed@kernel.org>
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

