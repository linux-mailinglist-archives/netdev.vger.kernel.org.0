Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792083D64FF
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhGZQS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241828AbhGZQQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F19060EB2;
        Mon, 26 Jul 2021 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318555;
        bh=OItQrAQKENvGosN/Oz8yYSV8HLm4+K8gfXiSH9YzfVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICsJKHgO03wU/5I8zSHDsXJJ3CoXaP3uFBefTpLuLq1r48+fIVbWS8NMNr8Q2PQet
         bjidWwmxKHBKhh9v25Hsf6AaJsceCCk9uAzxLtoDKHZZJpf4DFnFbdyn7HadLuJYGc
         ya/+2ROg64LaSTz9o9IioWv5KrnllM8UhlkTc6JTSDmUAxSc/G89GNx12eRwxHIb5o
         bB3rqFVBy3FuLhoN1TLbciARJ7F9ws8JaatoAX5FShSI4QU3bSPnwVyTU9stHDUv8H
         urmFWdxyg4An/ae0ASZhBKwPqiptYxLOW3yTXgdoy7R7GuSYXdFIeX6hOYrCR7FENj
         96LoRUXbKmBUg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/16] net/mlx5e: Move mlx5e_build_rss_params() call to init_rx
Date:   Mon, 26 Jul 2021 09:55:34 -0700
Message-Id: <20210726165544.389143-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

RSS params belong to the RX side initialization. Move them from
profile->init to profile->init_rx stage to allow the next commit to move
rss_params out of priv to a dynamically-allocated struct.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     | 8 +++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c      | 5 ++---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 2 ++
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ccc78cafbbb0..6c495eee82d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4538,7 +4538,6 @@ void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 
 void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16 mtu)
 {
-	struct mlx5e_rss_params *rss_params = &priv->rss_params;
 	struct mlx5e_params *params = &priv->channels.params;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 rx_cq_period_mode;
@@ -4598,10 +4597,7 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	/* TX inline */
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
 
-	/* RSS */
-	mlx5e_build_rss_params(rss_params, params->num_channels);
-	params->tunneled_offload_en =
-		mlx5e_tunnel_inner_ft_supported(mdev);
+	params->tunneled_offload_en = mlx5e_tunnel_inner_ft_supported(mdev);
 
 	/* AF_XDP */
 	params->xsk = xsk;
@@ -4873,6 +4869,8 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	u16 max_nch = priv->max_nch;
 	int err;
 
+	mlx5e_build_rss_params(&priv->rss_params, priv->channels.params.num_channels);
+
 	mlx5e_create_q_counters(priv);
 
 	err = mlx5e_open_drop_rq(priv, &priv->drop_rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index e998422405aa..0df6c6f99820 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -585,9 +585,6 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 	params->tunneled_offload_en = false;
 
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
-
-	/* RSS */
-	mlx5e_build_rss_params(&priv->rss_params, params->num_channels);
 }
 
 static void mlx5e_build_rep_netdev(struct net_device *netdev,
@@ -763,6 +760,8 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	u16 max_nch = priv->max_nch;
 	int err;
 
+	mlx5e_build_rss_params(&priv->rss_params, priv->channels.params.num_channels);
+
 	mlx5e_init_l2_addr(priv);
 
 	err = mlx5e_open_drop_rq(priv, &priv->drop_rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 1c865458e5c1..87c713179c28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -362,6 +362,8 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	u16 max_nch = priv->max_nch;
 	int err;
 
+	mlx5e_build_rss_params(&priv->rss_params, priv->channels.params.num_channels);
+
 	mlx5e_create_q_counters(priv);
 
 	err = mlx5e_open_drop_rq(priv, &priv->drop_rq);
-- 
2.31.1

