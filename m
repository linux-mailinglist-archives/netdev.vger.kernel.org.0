Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6954947E7E7
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349946AbhLWTE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:04:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37710 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349928AbhLWTEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:04:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 678D661F6A
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73302C36AEE;
        Thu, 23 Dec 2021 19:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640286291;
        bh=ZX5ig/sz6xKVywTXwD8nxiIjT3lbjHdLWIlS4xPmsYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErijaeDuUCXHS1IQE9vS9tvennbE+y34qizZMTtEXNUIGssnvmQsKM1mtd+0bGXu0
         ybACocMjolLT/ehftu/t7zwVUdHUPRiqDhYWGARPeycsVYsBQ7WqLjsQdUsD67oTXf
         Yvza2AcKd9IT2xbHVpGByTS2zIFmshojs6BHruN1tNUxmTcHDhVpG1HqpN1LP574hl
         k87L1qgr66szct+o5vIOF1Ep+tFl4Mm2yVkM+mu550urRhSzpK6M5KbUKjCHU6kbIe
         mmld1/p9JQgQTpAHLVRXOHnb8xyYIrF2/MWzz8pUn4+KpAGHY8D2H4T9ay0e696ruY
         0szLU+0Ii7Yug==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 10/12] net/mlx5e: Fix ICOSQ recovery flow for XSK
Date:   Thu, 23 Dec 2021 11:04:39 -0800
Message-Id: <20211223190441.153012-11-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223190441.153012-1-saeed@kernel.org>
References: <20211223190441.153012-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

There are two ICOSQs per channel: one is needed for RX, and the other
for async operations (XSK TX, kTLS offload). Currently, the recovery
flow for both is the same, and async ICOSQ is mistakenly treated like
the regular ICOSQ.

This patch prevents running the regular ICOSQ recovery on async ICOSQ.
The purpose of async ICOSQ is to handle XSK wakeup requests and post
kTLS offload RX parameters, it has nothing to do with RQ and XSKRQ UMRs,
so the regular recovery sequence is not applicable here.

Fixes: be5323c8379f ("net/mlx5e: Report and recover from CQE error on ICOSQ")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 --
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 30 ++++++++++++++-----
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f42067adc79d..b47a0d3ef22f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1016,9 +1016,6 @@ int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param *param);
 void mlx5e_destroy_rq(struct mlx5e_rq *rq);
 
 struct mlx5e_sq_param;
-int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
-		     struct mlx5e_sq_param *param, struct mlx5e_icosq *sq);
-void mlx5e_close_icosq(struct mlx5e_icosq *sq);
 int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 		     struct mlx5e_sq_param *param, struct xsk_buff_pool *xsk_pool,
 		     struct mlx5e_xdpsq *sq, bool is_redirect);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a572fc9690ed..3b0f3a831216 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1214,9 +1214,20 @@ static void mlx5e_icosq_err_cqe_work(struct work_struct *recover_work)
 	mlx5e_reporter_icosq_cqe_err(sq);
 }
 
+static void mlx5e_async_icosq_err_cqe_work(struct work_struct *recover_work)
+{
+	struct mlx5e_icosq *sq = container_of(recover_work, struct mlx5e_icosq,
+					      recover_work);
+
+	/* Not implemented yet. */
+
+	netdev_warn(sq->channel->netdev, "async_icosq recovery is not implemented\n");
+}
+
 static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 			     struct mlx5e_sq_param *param,
-			     struct mlx5e_icosq *sq)
+			     struct mlx5e_icosq *sq,
+			     work_func_t recover_work_func)
 {
 	void *sqc_wq               = MLX5_ADDR_OF(sqc, param->sqc, wq);
 	struct mlx5_core_dev *mdev = c->mdev;
@@ -1237,7 +1248,7 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 	if (err)
 		goto err_sq_wq_destroy;
 
-	INIT_WORK(&sq->recover_work, mlx5e_icosq_err_cqe_work);
+	INIT_WORK(&sq->recover_work, recover_work_func);
 
 	return 0;
 
@@ -1573,13 +1584,14 @@ void mlx5e_tx_err_cqe_work(struct work_struct *recover_work)
 	mlx5e_reporter_tx_err_cqe(sq);
 }
 
-int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
-		     struct mlx5e_sq_param *param, struct mlx5e_icosq *sq)
+static int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
+			    struct mlx5e_sq_param *param, struct mlx5e_icosq *sq,
+			    work_func_t recover_work_func)
 {
 	struct mlx5e_create_sq_param csp = {};
 	int err;
 
-	err = mlx5e_alloc_icosq(c, param, sq);
+	err = mlx5e_alloc_icosq(c, param, sq, recover_work_func);
 	if (err)
 		return err;
 
@@ -1618,7 +1630,7 @@ void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 	synchronize_net(); /* Sync with NAPI. */
 }
 
-void mlx5e_close_icosq(struct mlx5e_icosq *sq)
+static void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 {
 	struct mlx5e_channel *c = sq->channel;
 
@@ -2082,13 +2094,15 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 
 	spin_lock_init(&c->async_icosq_lock);
 
-	err = mlx5e_open_icosq(c, params, &cparam->async_icosq, &c->async_icosq);
+	err = mlx5e_open_icosq(c, params, &cparam->async_icosq, &c->async_icosq,
+			       mlx5e_async_icosq_err_cqe_work);
 	if (err)
 		goto err_close_xdpsq_cq;
 
 	mutex_init(&c->icosq_recovery_lock);
 
-	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->icosq);
+	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->icosq,
+			       mlx5e_icosq_err_cqe_work);
 	if (err)
 		goto err_close_async_icosq;
 
-- 
2.33.1

