Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9706A1311
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjBWWxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBWWxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:53:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FDC144B2
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 14:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1E50FCE219D
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 22:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB32C433D2;
        Thu, 23 Feb 2023 22:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677192778;
        bh=3wqZpYXL8EN4/Uc9Hi8Z9ApAnqckqBkpg0DYcy4hayw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FR3mpoDnKjjltpwMJYpB1NlkHnv3qGC1Y79laPFtxIPUYfmCw8x+QKAzI3h0EjuMU
         Trx8NSTS5vz+xVsZNygagV0S4fTwFN9hwNcgo5HBV/Y+x7tcTSRjTHYJF7rDlGRsQU
         LmhufHjuAkIZEqj1QU2kNV/STA6lhLpwJLLAtWwZXOBpZnOSH9j5wl+uggafsCm4OU
         K6tWLcO+IINMtVnAET91P+ECYgGZwAJm8v9648/9TDADEemnC3+SiSfw6W+RUpn9w4
         BX7g+mBXEgIQAsXo+uT9aRgBBePre8Xkwuy1o7u6d8P31UAB8G3AdBLI6mJDyHfZTl
         scOvjBA8cHzYQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [net 03/10] net/mlx5e: XDP, Allow growing tail for XDP multi buffer
Date:   Thu, 23 Feb 2023 14:52:40 -0800
Message-Id: <20230223225247.586552-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230223225247.586552-1-saeed@kernel.org>
References: <20230223225247.586552-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index a21bd1179477..998e31422a0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -672,7 +672,8 @@ static int mlx5e_max_nonlinear_mtu(int first_frag_size, int frag_size, bool xdp)
 static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 				     struct mlx5e_params *params,
 				     struct mlx5e_xsk_param *xsk,
-				     struct mlx5e_rq_frags_info *info)
+				     struct mlx5e_rq_frags_info *info,
+				     u32 *xdp_frag_size)
 {
 	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	int frag_size_max = DEFAULT_FRAG_SIZE;
@@ -782,6 +783,8 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 
 	info->log_num_frags = order_base_2(info->num_frags);
 
+	*xdp_frag_size = info->num_frags > 1 && params->xdp_prog ? PAGE_SIZE : 0;
+
 	return 0;
 }
 
@@ -927,7 +930,8 @@ int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
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
index c9be6eb88012..e5930fe752e5 100644
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
index 53feb0529943..24d4bd44897b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -582,7 +582,7 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
 }
 
 static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-			     struct mlx5e_rq *rq)
+			     u32 xdp_frag_size, struct mlx5e_rq *rq)
 {
 	struct mlx5_core_dev *mdev = c->mdev;
 	int err;
@@ -606,7 +606,8 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	if (err)
 		return err;
 
-	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id);
+	return __xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id,
+				  xdp_frag_size);
 }
 
 static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
@@ -2193,7 +2194,7 @@ static int mlx5e_open_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 {
 	int err;
 
-	err = mlx5e_init_rxq_rq(c, params, &c->rq);
+	err = mlx5e_init_rxq_rq(c, params, rq_params->xdp_frag_size, &c->rq);
 	if (err)
 		return err;
 
-- 
2.39.1

