Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BA42D333E
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731345AbgLHUQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731127AbgLHUO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:14:26 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 15/15] net/mlx5e: Fill mlx5e_create_cq_param in a function
Date:   Tue,  8 Dec 2020 11:35:55 -0800
Message-Id: <20201208193555.674504-16-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Create a function to fill the fields of struct mlx5e_create_cq_param
based on a channel. The purpose is code reuse between normal CQs, XSK
CQs and the upcoming QoS CQs.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/params.h |  1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/setup.c  |  7 ++-----
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 17 ++++++++++++-----
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 3959254d4181..807147d97a0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -111,6 +111,7 @@ u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
 
 /* Build queue parameters */
 
+void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct mlx5e_channel *c);
 void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 7703e6553da6..d87c345878d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -48,14 +48,11 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   struct mlx5e_xsk_param *xsk, struct xsk_buff_pool *pool,
 		   struct mlx5e_channel *c)
 {
-	struct mlx5e_create_cq_param ccp = {};
 	struct mlx5e_channel_param *cparam;
+	struct mlx5e_create_cq_param ccp;
 	int err;
 
-	ccp.napi = &c->napi;
-	ccp.ch_stats = c->stats;
-	ccp.node = cpu_to_node(c->cpu);
-	ccp.ix = c->ix;
+	mlx5e_build_create_cq_param(&ccp, c);
 
 	if (!mlx5e_validate_xsk_param(params, xsk, priv->mdev))
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2490d68cbd32..03831650f655 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1806,18 +1806,25 @@ static int mlx5e_set_tx_maxrate(struct net_device *dev, int index, u32 rate)
 	return err;
 }
 
+void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct mlx5e_channel *c)
+{
+	*ccp = (struct mlx5e_create_cq_param) {
+		.napi = &c->napi,
+		.ch_stats = c->stats,
+		.node = cpu_to_node(c->cpu),
+		.ix = c->ix,
+	};
+}
+
 static int mlx5e_open_queues(struct mlx5e_channel *c,
 			     struct mlx5e_params *params,
 			     struct mlx5e_channel_param *cparam)
 {
 	struct dim_cq_moder icocq_moder = {0, 0};
-	struct mlx5e_create_cq_param ccp = {};
+	struct mlx5e_create_cq_param ccp;
 	int err;
 
-	ccp.napi = &c->napi;
-	ccp.ch_stats = c->stats;
-	ccp.node = cpu_to_node(c->cpu);
-	ccp.ix = c->ix;
+	mlx5e_build_create_cq_param(&ccp, c);
 
 	err = mlx5e_open_cq(c->priv, icocq_moder, &cparam->icosq.cqp, &ccp,
 			    &c->async_icosq.cq);
-- 
2.26.2

