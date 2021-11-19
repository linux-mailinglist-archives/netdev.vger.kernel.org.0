Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4338F45777E
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbhKSUBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:01:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234827AbhKSUB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8FE861B1E;
        Fri, 19 Nov 2021 19:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351902;
        bh=RsH5Qjff6qIquxi6AO4XStxneP2kn/e8r7t1O6jRTd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbeSazixjwI0kgAvijGcdYolOi1mme1Cy7aJiS9a/gtnJdKJwB4j9Upydk4VtUm4J
         b+1AM8cz6fpbgSpDVOKb6EQKDE6Vgm8pcd/9nATZAegrvSNH4l3qzlR+43jfKzitFw
         SbIudt/yxWagCJJVHTgWRMakbvuxM0zgpNoe13jYXqdSrAaE2HuB/fcax+aE37pWJA
         D+mh1JlG0zuTsSfGzrwnCqZ6rb3GRSU/JNnCRub4EZOjpjrhnlBtrnuO9xH2T8xqO+
         9+IiB+bRrcMp4mpbax0JnAa2YXZnWNtxRXTuWcHoNTyLFfmgm+yCNqRlYJKzit7sud
         jVaa0W0AiWYkw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/10] net/mlx5e: Add activate/deactivate stage to XDPSQ
Date:   Fri, 19 Nov 2021 11:58:11 -0800
Message-Id: <20211119195813.739586-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119195813.739586-1-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Normally, the lifecycle of a queue in mlx5e has four transitions: open,
activate, deactivate and close. However, XDPSQs combine open with
activate and close with deactivate. This patch cleans it up by properly
separating these stages in order to make it possible to move
synchronize_net in the following fix.

Fixes: 0a06382fa406 ("net/mlx5e: Encapsulate open/close queues into a function"
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 ++
 .../mellanox/mlx5/core/en/xsk/setup.c         |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 +++++++++++++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f0ac6b0d9653..a0a5d6321098 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1020,6 +1020,8 @@ void mlx5e_close_icosq(struct mlx5e_icosq *sq);
 int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 		     struct mlx5e_sq_param *param, struct xsk_buff_pool *xsk_pool,
 		     struct mlx5e_xdpsq *sq, bool is_redirect);
+void mlx5e_activate_xdpsq(struct mlx5e_xdpsq *sq);
+void mlx5e_deactivate_xdpsq(struct mlx5e_xdpsq *sq);
 void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq);
 
 struct mlx5e_create_cq_param {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 538bc2419bd8..39873e834766 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -171,7 +171,7 @@ void mlx5e_close_xsk(struct mlx5e_channel *c)
 void mlx5e_activate_xsk(struct mlx5e_channel *c)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
-	/* TX queue is created active. */
+	mlx5e_activate_xdpsq(&c->xsksq);
 
 	spin_lock_bh(&c->async_icosq_lock);
 	mlx5e_trigger_irq(&c->async_icosq);
@@ -180,6 +180,6 @@ void mlx5e_activate_xsk(struct mlx5e_channel *c)
 
 void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
 {
+	mlx5e_deactivate_xdpsq(&c->xsksq);
 	mlx5e_deactivate_rq(&c->xskrq);
-	/* TX queue is disabled on close. */
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 65571593ec5c..6914fc17277a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1647,7 +1647,6 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	csp.cqn             = sq->cq.mcq.cqn;
 	csp.wq_ctrl         = &sq->wq_ctrl;
 	csp.min_inline_mode = sq->min_inline_mode;
-	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	err = mlx5e_create_sq_rdy(c->mdev, param, &csp, 0, &sq->sqn);
 	if (err)
 		goto err_free_xdpsq;
@@ -1687,18 +1686,25 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	return 0;
 
 err_free_xdpsq:
-	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	mlx5e_free_xdpsq(sq);
 
 	return err;
 }
 
-void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
+void mlx5e_activate_xdpsq(struct mlx5e_xdpsq *sq)
 {
-	struct mlx5e_channel *c = sq->channel;
+	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
+}
 
+void mlx5e_deactivate_xdpsq(struct mlx5e_xdpsq *sq)
+{
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	synchronize_net(); /* Sync with NAPI. */
+}
+
+void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
+{
+	struct mlx5e_channel *c = sq->channel;
 
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
 	mlx5e_free_xdpsq_descs(sq);
@@ -2249,7 +2255,10 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 		mlx5e_activate_txqsq(&c->sq[tc]);
 	mlx5e_activate_icosq(&c->icosq);
 	mlx5e_activate_icosq(&c->async_icosq);
+	if (c->xdp)
+		mlx5e_activate_xdpsq(&c->rq_xdpsq);
 	mlx5e_activate_rq(&c->rq);
+	mlx5e_activate_xdpsq(&c->xdpsq);
 
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_activate_xsk(c);
@@ -2262,7 +2271,10 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_deactivate_xsk(c);
 
+	mlx5e_deactivate_xdpsq(&c->xdpsq);
 	mlx5e_deactivate_rq(&c->rq);
+	if (c->xdp)
+		mlx5e_deactivate_xdpsq(&c->rq_xdpsq);
 	mlx5e_deactivate_icosq(&c->async_icosq);
 	mlx5e_deactivate_icosq(&c->icosq);
 	for (tc = 0; tc < c->num_tc; tc++)
-- 
2.31.1

