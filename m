Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32E931986A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBLC6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhBLC6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4014C64E74;
        Fri, 12 Feb 2021 02:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098642;
        bh=jBNBi4KsJibbMAl6X6YPDl/3R+cWDG2Iw3MXWExoQdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdGnaFWdXbeAQYruIeLrHSJzE1fkA5PGgd4e0/o1thk9BIsT4GvBPxuuHE+qvxglk
         sKw+bORUkL+4N8P0o4l2sk0SdSfTFR2pUnn3M5QhTiNN6VIEg2gce8Zh9oLQqqvuNl
         AUzF8K+lFgxNmGywUfkLCeJX3h9hEIAv0l0cqr5z877swVPyZHgbRdvQH5Oi9vLjIC
         O/CuI1WHc+DM4trgQMjp3J8wqV49wih0uE5qkX/9LukQpCwoqspssZUhHqLMkq5AF5
         VMC+z1MNMjSe54IzDX3Z9B7UmRNDTCNevw3wSRalg3OtPcPZwPUryOd9Odjklr9Fse
         ISgSxJ9nPV/HA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/15] net/mlx5e: Don't change interrupt moderation params when DIM is enabled
Date:   Thu, 11 Feb 2021 18:56:30 -0800
Message-Id: <20210212025641.323844-5-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

When mlx5e_ethtool_set_coalesce doesn't change DIM state
(enabled/disabled), it calls mlx5e_set_priv_channels_coalesce
unconditionally, which in turn invokes a firmware command to set
interrupt moderation parameters. It shouldn't happen while DIM manages
those parameters dynamically (it might even be happening at the same
time).

This patch fixes it by splitting mlx5e_set_priv_channels_coalesce into
two functions (for RX and TX) and calling them only when DIM is disabled
(for RX and TX respectively).

Fixes: cb3c7fd4f839 ("net/mlx5e: Support adaptive RX coalescing")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c   | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 302001d6661e..d7ff5fa45cb7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -525,7 +525,7 @@ static int mlx5e_get_coalesce(struct net_device *netdev,
 #define MLX5E_MAX_COAL_FRAMES		MLX5_MAX_CQ_COUNT
 
 static void
-mlx5e_set_priv_channels_coalesce(struct mlx5e_priv *priv, struct ethtool_coalesce *coal)
+mlx5e_set_priv_channels_tx_coalesce(struct mlx5e_priv *priv, struct ethtool_coalesce *coal)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int tc;
@@ -540,6 +540,17 @@ mlx5e_set_priv_channels_coalesce(struct mlx5e_priv *priv, struct ethtool_coalesc
 						coal->tx_coalesce_usecs,
 						coal->tx_max_coalesced_frames);
 		}
+	}
+}
+
+static void
+mlx5e_set_priv_channels_rx_coalesce(struct mlx5e_priv *priv, struct ethtool_coalesce *coal)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	int i;
+
+	for (i = 0; i < priv->channels.num; ++i) {
+		struct mlx5e_channel *c = priv->channels.c[i];
 
 		mlx5_core_modify_cq_moderation(mdev, &c->rq.cq.mcq,
 					       coal->rx_coalesce_usecs,
@@ -596,7 +607,10 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 	reset_tx = !!coal->use_adaptive_tx_coalesce != priv->channels.params.tx_dim_enabled;
 
 	if (!reset_rx && !reset_tx) {
-		mlx5e_set_priv_channels_coalesce(priv, coal);
+		if (!coal->use_adaptive_rx_coalesce)
+			mlx5e_set_priv_channels_rx_coalesce(priv, coal);
+		if (!coal->use_adaptive_tx_coalesce)
+			mlx5e_set_priv_channels_tx_coalesce(priv, coal);
 		priv->channels.params = new_channels.params;
 		goto out;
 	}
-- 
2.29.2

