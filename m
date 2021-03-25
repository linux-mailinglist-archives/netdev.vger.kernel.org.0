Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC5C348836
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhCYFF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhCYFEu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43AC161A1B;
        Thu, 25 Mar 2021 05:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648690;
        bh=Nuakzp023r3pLQojgt1xDMYQzGb2tTdiHz1z1Je3Gzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dx4+UgJz2JCZDaiuQ8h7rjC+JgJGtan53o2KB/ifjOmmMj0Wft9CqqVCpgACjfVnF
         yVkNLY9em1HV7q5G42VXPwmGFOx/s+WCr+wtaFnTQv/6qmtF5GEEPKGCEfRMDXP0Rt
         JNJ+Tibo+m6MzKtdxeuo5PTXv8AWjyr+CyzYojLKjbv0PS57rZAwa9ZuX94I0rDXpG
         9y/hGqHrnV0mRIsoXHXCvhN7GEClW37aP8OD/Jhxkt9RHqqYmsQqJ5stKI89abMttj
         hzSdE25nGRB2Jwjvj7wB9REsdyqvjD96+H0dYRzguKs8AJJhXpp/l3N6X9lH5O4UPL
         iJLR3Szpsr5Dg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: Cleanup PTP
Date:   Wed, 24 Mar 2021 22:04:37 -0700
Message-Id: <20210325050438.261511-15-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Reduce scope of mlx5e_ptp_params, move to its c file. Remove unneeded
variables from mlx5e_ptp_open and state bitmap from PTP channel. In
addition, remove channel index from PTP channel since it is set to a
hard coded value, use define instead.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c   | 18 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h   |  8 --------
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 2bc6d4362670..92a41b1bcdb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -3,6 +3,14 @@
 
 #include "en/ptp.h"
 #include "en/txrx.h"
+#include "en/params.h"
+
+#define MLX5E_PTP_CHANNEL_IX 0
+
+struct mlx5e_ptp_params {
+	struct mlx5e_params params;
+	struct mlx5e_sq_param txq_sq_param;
+};
 
 struct mlx5e_skb_cb_hwtstamp {
 	ktime_t cqe_hwtstamp;
@@ -171,7 +179,7 @@ static int mlx5e_ptp_alloc_txqsq(struct mlx5e_ptp *c, int txq_ix,
 	sq->netdev    = c->netdev;
 	sq->priv      = c->priv;
 	sq->mdev      = mdev;
-	sq->ch_ix     = c->ix;
+	sq->ch_ix     = MLX5E_PTP_CHANNEL_IX;
 	sq->txq_ix    = txq_ix;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
@@ -339,7 +347,7 @@ static int mlx5e_ptp_open_cqs(struct mlx5e_ptp *c,
 	ccp.node     = dev_to_node(mlx5_core_dma_dev(c->mdev));
 	ccp.ch_stats = c->stats;
 	ccp.napi     = &c->napi;
-	ccp.ix       = c->ix;
+	ccp.ix       = MLX5E_PTP_CHANNEL_IX;
 
 	cq_param = &cparams->txq_sq_param.cqp;
 
@@ -453,13 +461,8 @@ int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_ptp_params *cparams;
 	struct mlx5e_ptp *c;
-	unsigned int irq;
 	int err;
-	int eqn;
 
-	err = mlx5_vector2eqn(priv->mdev, 0, &eqn, &irq);
-	if (err)
-		return err;
 
 	c = kvzalloc_node(sizeof(*c), GFP_KERNEL, dev_to_node(mlx5_core_dma_dev(mdev)));
 	cparams = kvzalloc(sizeof(*cparams), GFP_KERNEL);
@@ -469,7 +472,6 @@ int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	c->priv     = priv;
 	c->mdev     = priv->mdev;
 	c->tstamp   = &priv->tstamp;
-	c->ix       = 0;
 	c->pdev     = mlx5_core_dma_dev(priv->mdev);
 	c->netdev   = priv->netdev;
 	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey.key);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index 4cae06f2c312..937530afaf14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -5,7 +5,6 @@
 #define __MLX5_EN_PTP_H__
 
 #include "en.h"
-#include "en/params.h"
 #include "en_stats.h"
 
 struct mlx5e_ptpsq {
@@ -34,13 +33,6 @@ struct mlx5e_ptp {
 	struct mlx5e_priv         *priv;
 	struct mlx5_core_dev      *mdev;
 	struct hwtstamp_config    *tstamp;
-	DECLARE_BITMAP(state, MLX5E_CHANNEL_NUM_STATES);
-	int                        ix;
-};
-
-struct mlx5e_ptp_params {
-	struct mlx5e_params        params;
-	struct mlx5e_sq_param      txq_sq_param;
 };
 
 int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
-- 
2.30.2

