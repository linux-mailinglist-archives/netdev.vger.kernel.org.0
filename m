Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971BB31986E
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhBLC67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhBLC6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A72E564E76;
        Fri, 12 Feb 2021 02:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098642;
        bh=Vuu/PIaf1BK6EJup5aPXGLpOUw5Yb+BfB6bucNn0p3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZTf47vzOnnEyq0sYPf5CaEkIOoqwqbKj/mHQ6J+yvqXtHWudQd9yy1nccm2azbJx
         3YY8U5CXCMh2mIx6mCc5RIQxmVtb0UEh8Z+jXShLda0637TUf1WQXYFIKHTx+xcbSU
         RlOxykDc7E8hbXtti2vbfamPmwSkyN2TQz9MKAJ1icbJK3HjTseZFZMWm0PJe9QO6b
         rcfpUI/0GsKCkPCoxfnV77zWnhnD4Kj6I+t8jzYf2TyUW4A6b1lV2Mt7pP9nzxtlWk
         XolKKHyT2Bxzlb7kTlsvdk084mhGBAA11SnWqJqdIqfPtJryqD/0lOO7e5qxCpDpzA
         4l6zRl2CiJ3Hw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/15] net/mlx5e: Change interrupt moderation channel params also when channels are closed
Date:   Thu, 11 Feb 2021 18:56:31 -0800
Message-Id: <20210212025641.323844-6-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

struct mlx5e_params contains fields ({rx,tx}_cq_moderation) that depend
on two things: whether DIM is enabled and the state of a private flag
(MLX5E_PFLAG_{RX,TX}_CQE_BASED_MODER). Whenever the DIM state changes,
mlx5e_reset_{rx,tx}_moderation is called to update the fields, however,
only if the channels are open. The flow where the channels are closed
misses the required update of the fields. This commit moves the calls of
mlx5e_reset_{rx,tx}_moderation, so that they run in both flows.

Fixes: ebeaf084ad5c ("net/mlx5e: Properly set default values when disabling adaptive moderation")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 29 +++++++++----------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d7ff5fa45cb7..8612c388db7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -597,24 +597,9 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 	tx_moder->pkts    = coal->tx_max_coalesced_frames;
 	new_channels.params.tx_dim_enabled = !!coal->use_adaptive_tx_coalesce;
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params = new_channels.params;
-		goto out;
-	}
-	/* we are opened */
-
 	reset_rx = !!coal->use_adaptive_rx_coalesce != priv->channels.params.rx_dim_enabled;
 	reset_tx = !!coal->use_adaptive_tx_coalesce != priv->channels.params.tx_dim_enabled;
 
-	if (!reset_rx && !reset_tx) {
-		if (!coal->use_adaptive_rx_coalesce)
-			mlx5e_set_priv_channels_rx_coalesce(priv, coal);
-		if (!coal->use_adaptive_tx_coalesce)
-			mlx5e_set_priv_channels_tx_coalesce(priv, coal);
-		priv->channels.params = new_channels.params;
-		goto out;
-	}
-
 	if (reset_rx) {
 		u8 mode = MLX5E_GET_PFLAG(&new_channels.params,
 					  MLX5E_PFLAG_RX_CQE_BASED_MODER);
@@ -628,6 +613,20 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 		mlx5e_reset_tx_moderation(&new_channels.params, mode);
 	}
 
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		priv->channels.params = new_channels.params;
+		goto out;
+	}
+
+	if (!reset_rx && !reset_tx) {
+		if (!coal->use_adaptive_rx_coalesce)
+			mlx5e_set_priv_channels_rx_coalesce(priv, coal);
+		if (!coal->use_adaptive_tx_coalesce)
+			mlx5e_set_priv_channels_tx_coalesce(priv, coal);
+		priv->channels.params = new_channels.params;
+		goto out;
+	}
+
 	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 
 out:
-- 
2.29.2

