Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B29C614C9
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfGGLx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:56 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58922 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727017AbfGGLxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:55 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:19 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJM1031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 12/16] net/mlx5e: Split open/close ICOSQ into stages
Date:   Sun,  7 Jul 2019 14:53:04 +0300
Message-Id: <1562500388-16847-13-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Align ICOSQ open/close behaviour with RQ and SQ. Split open flow into
open and activate where open handles creation and activate enables the
queue. Do a symmetric thing in close flow: split into close and
deactivate.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3922905e909f..7e6ac1e7bdd1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1372,7 +1372,6 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	csp.cqn             = sq->cq.mcq.cqn;
 	csp.wq_ctrl         = &sq->wq_ctrl;
 	csp.min_inline_mode = params->tx_min_inline_mode;
-	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	err = mlx5e_create_sq_rdy(c->mdev, param, &csp, &sq->sqn);
 	if (err)
 		goto err_free_icosq;
@@ -1386,12 +1385,22 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	return err;
 }
 
-void mlx5e_close_icosq(struct mlx5e_icosq *sq)
+static void mlx5e_activate_icosq(struct mlx5e_icosq *icosq)
 {
-	struct mlx5e_channel *c = sq->channel;
+	set_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
+}
 
-	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
+static void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
+{
+	struct mlx5e_channel *c = icosq->channel;
+
+	clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
 	napi_synchronize(&c->napi);
+}
+
+void mlx5e_close_icosq(struct mlx5e_icosq *sq)
+{
+	struct mlx5e_channel *c = sq->channel;
 
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
 	mlx5e_free_icosq(sq);
@@ -1968,6 +1977,7 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 
 	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_activate_txqsq(&c->sq[tc]);
+	mlx5e_activate_icosq(&c->icosq);
 	mlx5e_activate_rq(&c->rq);
 	netif_set_xps_queue(c->netdev, c->xps_cpumask, c->ix);
 
@@ -1983,6 +1993,7 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 		mlx5e_deactivate_xsk(c);
 
 	mlx5e_deactivate_rq(&c->rq);
+	mlx5e_deactivate_icosq(&c->icosq);
 	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_deactivate_txqsq(&c->sq[tc]);
 }
-- 
1.8.3.1

