Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A565E349FFD
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhCZCyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231142AbhCZCxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:53:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E802761A45;
        Fri, 26 Mar 2021 02:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616727233;
        bh=pbg8da6bLgTfkimXOj/3CVfClTFfzQg54tRlOcGDd8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqLzDBZcSHNc5OzjQkQLZ3macV3KGltEX+scMz1amwrzQW6Tv3cNn5n/9UV+//zJx
         LAOoAQQtcuuk39LTInH1mgBa82Rd46BEN+5k/Bg1ynl1u6N/1MmygaHPFFEk8MUv3n
         hvE5ypnSoomCHyiVoxAxYcZO4gVjlQX5g7aq6ejvWeXjLM7vEGmZzLIJOvMzOV/HN3
         0fZgtWhpae15tQzweVSQUgla3d4IBY0Dpl6YBxR366OEjZ6u/Et7uWkNcIolljzT/2
         tMj3hqRL3IRRQR6wGE/mhYGml94vpJN7LQYwUT6gsfckakG3otO0K/QVCAbGNCdmmz
         vZFuu3I1+xIcw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 09/13] net/mlx5e: Generalize close RQ
Date:   Thu, 25 Mar 2021 19:53:41 -0700
Message-Id: <20210326025345.456475-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326025345.456475-1-saeed@kernel.org>
References: <20210326025345.456475-1-saeed@kernel.org>
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
index 06df647b2beb..f2884edd4b61 100644
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

