Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F9C421B90
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhJEBQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230087AbhJEBQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF21B61407;
        Tue,  5 Oct 2021 01:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396483;
        bh=r3CH9VbfxHujXwijg/spu7Y7dvbhpPsb9w0sjFIv67c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuJGQTJ3Iw7QF0wMzruFWgIY/5UPOiwk6Cy3NsXC0oj0X/mm96TfqIB1Ou0OkKMGl
         ZqauceO0pEsRtYsyT/cFF+ilmqdHapVoV3MPm7IkU89cXAb31hvD0smIcmAxvFVHLR
         3EuckQQpWrtaee/uXz1JRHyzLRvRTBt3QXkvXzsavnfqojFZk3XrypcDj7tCA6cn5O
         i8u9Vyu/+7mDaRoZfxXGl3Wx5XyYKI0+0F624kc0AfgnD3vAogfuE6xa39JEYC8uID
         z0q41Nv7YzDzsiub3U6Numu4vHtTN5qjvg8LZ4ggwWJsYtlTWGDXPftEj2EA/S6FS8
         JbtVj/lEz9/sw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Specify SQ stats struct for mlx5e_open_txqsq()
Date:   Mon,  4 Oct 2021 18:12:48 -0700
Message-Id: <20211005011302.41793-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Let the caller of mlx5e_open_txqsq() directly pass the SQ stats
structure pointer.
This replaces logic involving the qos_queue_group_id parameter,
and helps generalizing its role in the next patch.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c  |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 +++++------
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 038b5c285730..e06c8b816a32 100644
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
index 005eb3c92506..9f6685d3b17b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1300,7 +1300,8 @@ static int mlx5e_set_sq_maxrate(struct net_device *dev,
 
 int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 		     struct mlx5e_params *params, struct mlx5e_sq_param *param,
-		     struct mlx5e_txqsq *sq, int tc, u16 qos_queue_group_id, u16 qos_qid)
+		     struct mlx5e_txqsq *sq, int tc, u16 qos_queue_group_id,
+		     struct mlx5e_sq_stats *sq_stats)
 {
 	struct mlx5e_create_sq_param csp = {};
 	u32 tx_rate;
@@ -1310,10 +1311,7 @@ int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 	if (err)
 		return err;
 
-	if (qos_queue_group_id)
-		sq->stats = c->priv->htb.qos_sq_stats[qos_qid];
-	else
-		sq->stats = &c->priv->channel_stats[c->ix].sq[tc];
+	sq->stats = sq_stats;
 
 	csp.tisn            = tisn;
 	csp.tis_lst_sz      = 1;
@@ -1717,7 +1715,8 @@ static int mlx5e_open_sqs(struct mlx5e_channel *c,
 		int txq_ix = c->ix + tc * params->num_channels;
 
 		err = mlx5e_open_txqsq(c, c->priv->tisn[c->lag_port][tc], txq_ix,
-				       params, &cparam->txq_sq, &c->sq[tc], tc, 0, 0);
+				       params, &cparam->txq_sq, &c->sq[tc], tc, 0,
+				       &c->priv->channel_stats[c->ix].sq[tc]);
 		if (err)
 			goto err_close_sqs;
 	}
-- 
2.31.1

