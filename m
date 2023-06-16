Return-Path: <netdev+bounces-11570-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 145A0733A45
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:02:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C377728184F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588141F160;
	Fri, 16 Jun 2023 20:01:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE05B1ED3E
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D363EC433CA;
	Fri, 16 Jun 2023 20:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945684;
	bh=1HIIeTk+QM2niRS7zhIp/sSW9TaEXNKjVYVaAdCTICs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIgJa7kbEGdDlADgYg4Cv6/MgH1P8Wsxu69uIgolqAioOsMOF6uAJ+cZk9n0NuZ6b
	 GNUIqOTUGZ5MK1lLeBmiJw2d6IKlVMkdNx7cM+fAd1o+oap4yHyL7IkOAUkT2IZ3c5
	 Mpgfravn7Jrgo1vBEczTQmh8BbaSlOsVaOOUk01MOVxG5kYIW48rBti+X7d6h0DDij
	 ewHluK0qAF/+dAizcfb3ahXkAk7PoFqdMk6vb4TaXnqkFWE7tUttgu9e0L3O62jSDU
	 lubQXeKZYjBOfCF2yHT/klsx3m9uK7UzHCQ6PVNEWxB8gaGAbg/+yA+N83L1+Mbdet
	 l2u8Ov444lK2w==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [net 01/12] net/mlx5e: XDP, Allow growing tail for XDP multi buffer
Date: Fri, 16 Jun 2023 13:01:08 -0700
Message-Id: <20230616200119.44163-2-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616200119.44163-1-saeed@kernel.org>
References: <20230616200119.44163-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Maxim Mikityanskiy <maxtram95@gmail.com>

The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
is required by bpf_xdp_adjust_tail to support growing the tail pointer
in fragmented packets. Pass the missing parameter when the current RQ
mode allows XDP multi buffer.

Fixes: ea5d49bdae8b ("net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ")
Fixes: 9cb9482ef10e ("net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 8 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 7 ++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 9c94807097cb..5ce28ff7685f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -732,7 +732,8 @@ static void mlx5e_rx_compute_wqe_bulk_params(struct mlx5e_params *params,
 static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 				     struct mlx5e_params *params,
 				     struct mlx5e_xsk_param *xsk,
-				     struct mlx5e_rq_frags_info *info)
+				     struct mlx5e_rq_frags_info *info,
+				     u32 *xdp_frag_size)
 {
 	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	int frag_size_max = DEFAULT_FRAG_SIZE;
@@ -845,6 +846,8 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 
 	info->log_num_frags = order_base_2(info->num_frags);
 
+	*xdp_frag_size = info->num_frags > 1 && params->xdp_prog ? PAGE_SIZE : 0;
+
 	return 0;
 }
 
@@ -989,7 +992,8 @@ int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
 	}
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		MLX5_SET(wq, wq, log_wq_sz, params->log_rq_mtu_frames);
-		err = mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info);
+		err = mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info,
+						&param->xdp_frag_size);
 		if (err)
 			return err;
 		ndsegs = param->frags_info.num_frags;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index a5d20f6d6d9c..6800949dafbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -24,6 +24,7 @@ struct mlx5e_rq_param {
 	u32                        rqc[MLX5_ST_SZ_DW(rqc)];
 	struct mlx5_wq_param       wq;
 	struct mlx5e_rq_frags_info frags_info;
+	u32                        xdp_frag_size;
 };
 
 struct mlx5e_sq_param {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a7c526ee5024..a5bdf78955d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -641,7 +641,7 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
 }
 
 static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-			     struct mlx5e_rq *rq)
+			     u32 xdp_frag_size, struct mlx5e_rq *rq)
 {
 	struct mlx5_core_dev *mdev = c->mdev;
 	int err;
@@ -665,7 +665,8 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	if (err)
 		return err;
 
-	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id);
+	return __xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id,
+				  xdp_frag_size);
 }
 
 static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
@@ -2240,7 +2241,7 @@ static int mlx5e_open_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 {
 	int err;
 
-	err = mlx5e_init_rxq_rq(c, params, &c->rq);
+	err = mlx5e_init_rxq_rq(c, params, rq_params->xdp_frag_size, &c->rq);
 	if (err)
 		return err;
 
-- 
2.40.1


