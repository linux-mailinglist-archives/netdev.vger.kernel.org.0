Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A37280824
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733064AbgJATx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733002AbgJATxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:15 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82C1821481;
        Thu,  1 Oct 2020 19:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581994;
        bh=ln6/5B6Y0n43IEe4UHqxreVLdNUN+dLGV+5odsOU4m8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Me8yhAIGij3SfgYdRgunD37t18sVscdVfaarhfqwn39kvCjULHmoJtHkDLvA9YP3x
         TlLcmm3vRrDQasga8pvpu0X/tzTiee0+pFsB0lMrsC1A98BzRwoDUDdHJSJMKWC5Cs
         m+I31XXivqXxG3c2x/VIsxjlLsPP/waBXzHNu6TU=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 08/15] net/mlx5e: Fix error path for RQ alloc
Date:   Thu,  1 Oct 2020 12:52:40 -0700
Message-Id: <20201001195247.66636-9-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Increase granularity of the error path to avoid unneeded free/release.
Fix the cleanup to be symmetric to the order of creation.

Fixes: 0ddf543226ac ("xdp/mlx5: setup xdp_rxq_info")
Fixes: 422d4c401edd ("net/mlx5e: RX, Split WQ objects for different RQ types")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 32 ++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b3cda7b6e5e1..1fbd7a0f3ca6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -396,7 +396,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		rq_xdp_ix += params->num_channels * MLX5E_RQ_GROUP_XSK;
 	err = xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix);
 	if (err < 0)
-		goto err_rq_wq_destroy;
+		goto err_rq_xdp_prog;
 
 	rq->buff.map_dir = params->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
 	rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params, xsk);
@@ -407,7 +407,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		err = mlx5_wq_ll_create(mdev, &rqp->wq, rqc_wq, &rq->mpwqe.wq,
 					&rq->wq_ctrl);
 		if (err)
-			goto err_rq_wq_destroy;
+			goto err_rq_xdp;
 
 		rq->mpwqe.wq.db = &rq->mpwqe.wq.db[MLX5_RCV_DBR];
 
@@ -429,13 +429,13 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 		err = mlx5e_rq_alloc_mpwqe_info(rq, c);
 		if (err)
-			goto err_free;
+			goto err_rq_mkey;
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		err = mlx5_wq_cyc_create(mdev, &rqp->wq, rqc_wq, &rq->wqe.wq,
 					 &rq->wq_ctrl);
 		if (err)
-			goto err_rq_wq_destroy;
+			goto err_rq_xdp;
 
 		rq->wqe.wq.db = &rq->wqe.wq.db[MLX5_RCV_DBR];
 
@@ -450,19 +450,19 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 				      GFP_KERNEL, cpu_to_node(c->cpu));
 		if (!rq->wqe.frags) {
 			err = -ENOMEM;
-			goto err_free;
+			goto err_rq_wq_destroy;
 		}
 
 		err = mlx5e_init_di_list(rq, wq_sz, c->cpu);
 		if (err)
-			goto err_free;
+			goto err_rq_frags;
 
 		rq->mkey_be = c->mkey_be;
 	}
 
 	err = mlx5e_rq_set_handlers(rq, params, xsk);
 	if (err)
-		goto err_free;
+		goto err_free_by_rq_type;
 
 	if (xsk) {
 		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
@@ -486,13 +486,13 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		if (IS_ERR(rq->page_pool)) {
 			err = PTR_ERR(rq->page_pool);
 			rq->page_pool = NULL;
-			goto err_free;
+			goto err_free_by_rq_type;
 		}
 		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
 						 MEM_TYPE_PAGE_POOL, rq->page_pool);
 	}
 	if (err)
-		goto err_free;
+		goto err_free_by_rq_type;
 
 	for (i = 0; i < wq_sz; i++) {
 		if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
@@ -542,23 +542,25 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 	return 0;
 
-err_free:
+err_free_by_rq_type:
 	switch (rq->wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		kvfree(rq->mpwqe.info);
+err_rq_mkey:
 		mlx5_core_destroy_mkey(mdev, &rq->umr_mkey);
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
-		kvfree(rq->wqe.frags);
 		mlx5e_free_di_list(rq);
+err_rq_frags:
+		kvfree(rq->wqe.frags);
 	}
-
 err_rq_wq_destroy:
+	mlx5_wq_destroy(&rq->wq_ctrl);
+err_rq_xdp:
+	xdp_rxq_info_unreg(&rq->xdp_rxq);
+err_rq_xdp_prog:
 	if (params->xdp_prog)
 		bpf_prog_put(params->xdp_prog);
-	xdp_rxq_info_unreg(&rq->xdp_rxq);
-	page_pool_destroy(rq->page_pool);
-	mlx5_wq_destroy(&rq->wq_ctrl);
 
 	return err;
 }
-- 
2.26.2

