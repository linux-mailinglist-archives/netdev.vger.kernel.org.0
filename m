Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69100348831
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCYFFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:05:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229693AbhCYFEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCE0C619BA;
        Thu, 25 Mar 2021 05:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648689;
        bh=P7AQjvy1CBSl8v21G/SQRv8ZSDinZRk3GoiqM3aDxwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXMkWeEgeO49MNTVhznX9vLkiA1M7UGli8UtWW5hMViIZrSYV1dktPehUxv/iHuzk
         3VLQ3Py6OaGcsJy6xoZZIIh+E8n4ha/4+kdWYZzceiGHd+za1rUiTgyOXyU/QNzSEt
         8CSHE2avc98wr9oogtjCzzkpPqZtxAvFlWvVwn/SkyiAgs5rg79UB1PbbxnDag0J0v
         TyDEoRvBaSnlFZP7LYCKZShpJQQ2nmqYRJ8TDsEHHyJghFtmzVRDsdeJR686y3skbe
         mTv+TKvvP8WnXTKDzKUXDJNhXpCX0Clx54WzDyv5VVh20/aYlOXat9zmRidZNJMqNc
         aP0pjTEULIKMw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Generalize close RQ
Date:   Wed, 24 Mar 2021 22:04:34 -0700
Message-Id: <20210325050438.261511-12-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Allow different flavours of RQ to use the same close flow. Add validity
checks to support different RQ types which not necessarily initialize
all the RQ's functionality.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c | 12 +-----------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 13 ++++++++-----
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index d6e6641e9288..86ab4e864fe6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -30,14 +30,6 @@ static int mlx5e_trap_napi_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static void mlx5e_free_trap_rq(struct mlx5e_rq *rq)
-{
-	page_pool_destroy(rq->page_pool);
-	mlx5e_free_di_list(rq);
-	kvfree(rq->wqe.frags);
-	mlx5_wq_destroy(&rq->wq_ctrl);
-}
-
 static void mlx5e_init_trap_rq(struct mlx5e_trap *t, struct mlx5e_params *params,
 			       struct mlx5e_rq *rq)
 {
@@ -93,9 +85,7 @@ static int mlx5e_open_trap_rq(struct mlx5e_priv *priv, struct mlx5e_trap *t)
 
 static void mlx5e_close_trap_rq(struct mlx5e_rq *rq)
 {
-	mlx5e_destroy_rq(rq);
-	mlx5e_free_rx_descs(rq);
-	mlx5e_free_trap_rq(rq);
+	mlx5e_close_rq(rq);
 	mlx5e_close_cq(&rq->cq);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b25e1501e236..eda30bc80a51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -592,10 +592,12 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 	struct bpf_prog *old_prog;
 	int i;
 
-	old_prog = rcu_dereference_protected(rq->xdp_prog,
-					     lockdep_is_held(&rq->priv->state_lock));
-	if (old_prog)
-		bpf_prog_put(old_prog);
+	if (xdp_rxq_info_is_reg(&rq->xdp_rxq)) {
+		old_prog = rcu_dereference_protected(rq->xdp_prog,
+						     lockdep_is_held(&rq->priv->state_lock));
+		if (old_prog)
+			bpf_prog_put(old_prog);
+	}
 
 	switch (rq->wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
@@ -901,7 +903,8 @@ void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 void mlx5e_close_rq(struct mlx5e_rq *rq)
 {
 	cancel_work_sync(&rq->dim.work);
-	cancel_work_sync(&rq->icosq->recover_work);
+	if (rq->icosq)
+		cancel_work_sync(&rq->icosq->recover_work);
 	cancel_work_sync(&rq->recover_work);
 	mlx5e_destroy_rq(rq);
 	mlx5e_free_rx_descs(rq);
-- 
2.30.2

