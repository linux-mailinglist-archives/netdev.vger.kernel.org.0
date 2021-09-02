Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4113FF3D7
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347334AbhIBTHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347347AbhIBTHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD56E60238;
        Thu,  2 Sep 2021 19:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609571;
        bh=BkgWIu62ixRa/ZiMqjXjBGjnLG37/+DE7YB9f9HyuAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jxw5mt/5ZRMl/qAs3csL0teruY8zuGdwZcu9rPRKfmMbiyIw6yj054g03fp+Sc95Q
         vSr/e4SbksmwtZRNweSLB8UKk7Lt8YMbjZqPLyeq0EmVzCW8zg58ST2nulz1u4Kjv0
         2o5FtrfvfNTfHyE90t9AFtXsF1k7JQ0+sojINGqqaBsJV/OwmB5PW7PSciH9smOukJ
         HqTDYQjlV74Q4+BRN1cPnSd0C5wxk5vbcOc7mfjlFwh+Fku3XRsEPHJZ+Rk/L0Skim
         5xCKcRHgTsTbCj6+f6+ZPp2e5FC9YwAkglh32hOk3m+3zvVLlfktvPOj+SCBhOnhBH
         cq+gKnog1LsnQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: Allow specifying SQ stats struct for mlx5e_open_txqsq()
Date:   Thu,  2 Sep 2021 12:05:53 -0700
Message-Id: <20210902190554.211497-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902190554.211497-1-saeed@kernel.org>
References: <20210902190554.211497-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Let the caller of mlx5e_open_txqsq() directly pass the SQ stats
structure pointer when needed. Use it for HTB QoS SQs.
This replaces logic involving the qos_queue_group_id parameter,
and helps generalizing its role in the next patch.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c  | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 9 +++++----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4ff84832fb45..a8178656da9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1002,7 +1002,8 @@ int mlx5e_modify_sq(struct mlx5_core_dev *mdev, u32 sqn,
 		    struct mlx5e_modify_sq_param *p);
 int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 		     struct mlx5e_params *params, struct mlx5e_sq_param *param,
-		     struct mlx5e_txqsq *sq, int tc, u16 qos_queue_group_id, u16 qos_qid);
+		     struct mlx5e_txqsq *sq, int tc, u16 qos_queue_group_id,
+		     struct mlx5e_sq_stats *sq_stats);
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_free_txqsq(struct mlx5e_txqsq *sq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index e8a8d78e3e4d..17a607541af6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -238,7 +238,8 @@ static int mlx5e_open_qos_sq(struct mlx5e_priv *priv, struct mlx5e_channels *chs
 	if (err)
 		goto err_free_sq;
 	err = mlx5e_open_txqsq(c, priv->tisn[c->lag_port][0], txq_ix, params,
-			       &param_sq, sq, 0, node->hw_id, node->qid);
+			       &param_sq, sq, 0, node->hw_id,
+			       priv->htb.qos_sq_stats[node->qid]);
 	if (err)
 		goto err_close_cq;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ae223fc46df7..ca7a5e932c2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1298,7 +1298,8 @@ static int mlx5e_set_sq_maxrate(struct net_device *dev,
 
 int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 		     struct mlx5e_params *params, struct mlx5e_sq_param *param,
-		     struct mlx5e_txqsq *sq, int tc, u16 qos_queue_group_id, u16 qos_qid)
+		     struct mlx5e_txqsq *sq, int tc, u16 qos_queue_group_id,
+		     struct mlx5e_sq_stats *sq_stats)
 {
 	struct mlx5e_create_sq_param csp = {};
 	u32 tx_rate;
@@ -1308,8 +1309,8 @@ int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 	if (err)
 		return err;
 
-	if (qos_queue_group_id)
-		sq->stats = c->priv->htb.qos_sq_stats[qos_qid];
+	if (sq_stats)
+		sq->stats = sq_stats;
 	else
 		sq->stats = &c->priv->channel_stats[c->ix].sq[tc];
 
@@ -1715,7 +1716,7 @@ static int mlx5e_open_sqs(struct mlx5e_channel *c,
 		int txq_ix = c->ix + tc * params->num_channels;
 
 		err = mlx5e_open_txqsq(c, c->priv->tisn[c->lag_port][tc], txq_ix,
-				       params, &cparam->txq_sq, &c->sq[tc], tc, 0, 0);
+				       params, &cparam->txq_sq, &c->sq[tc], tc, 0, NULL);
 		if (err)
 			goto err_close_sqs;
 	}
-- 
2.31.1

