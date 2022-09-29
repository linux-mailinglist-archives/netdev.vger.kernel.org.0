Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328C85EEED5
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiI2HXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbiI2HWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBAF1176D0
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30371B8232C
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF16AC43470;
        Thu, 29 Sep 2022 07:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436161;
        bh=3DpKZcuz7iAiZ1DUREIQpRHyJBiVLrsybJbYMp0hRzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdEzGgjDA/82zw7xzVwPWzz7ljW94e96KIZyFoyhDiTHVygGaOGeEscet+PDXyHid
         md+p2EDjYaAw/sTcRmgk4SrNouB4sXzH97HVmsNQqOJ+laIy/zzPQ9A+Xkb+87wetG
         uk9SQ9n7ihM7EO2E59clp9nKTF8pX3+d8GVxnPva/2XzXxP3MezWjZWRY3N5/LJ5rQ
         35PwmnRLDtQJt+GCy+d/lYQgRCJM9Nb+UDdA8cHn7qZcfzr3MgkcLOzhtnBBkXeDNY
         kZWjXCZg9rlNw3u9IKkI3oI5agTbOoCoypKuP/h6vkP9/f5ansjfa/H17NefHKb58g
         +eojWM5O/FkPw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 04/16] net/mlx5e: Keep a separate MKey for striding RQ
Date:   Thu, 29 Sep 2022 00:21:44 -0700
Message-Id: <20220929072156.93299-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
References: <20220929072156.93299-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Currently, rq->mkey_be keeps a big-endian value of either the PA MKey
(for legacy RQ, no address translation) or MTT MKey (for striding RQ,
direct address translation). Striding RQ stores the same value in
rq->umr_mkey in the native endianness.

The next commit will make striding RQ use KSM MKey (indirect address
translation) for the unaligned mode of XSK, which will require storing
both KSM MKey and PA MKey in the RQ struct. This commit optimizes fields
of mlx5e_rq: umr_mkey is removed (it's redundant), mkey_be always points
to the PA MKey, and mpwqe.umr_mkey_be points to the MTT MKey (or to the
KSM MKey, starting from the next commit).

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 21 +++++++++++--------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 7e56a45d0c24..308ef06df0d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -696,6 +696,7 @@ struct mlx5e_rq {
 			struct mlx5e_umr_wqe   umr_wqe;
 			struct mlx5e_mpw_info *info;
 			mlx5e_fp_skb_from_cqe_mpwrq skb_from_cqe_mpwrq;
+			__be32                 umr_mkey_be;
 			u16                    num_strides;
 			u16                    actual_wq_head;
 			u8                     log_stride_sz;
@@ -757,7 +758,6 @@ struct mlx5e_rq {
 	u32                    rqn;
 	struct mlx5_core_dev  *mdev;
 	struct mlx5e_channel  *channel;
-	u32  umr_mkey;
 	struct mlx5e_dma_info  wqe_overflow;
 
 	/* XDP read-mostly */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 733451de1664..a4edbb85706e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -215,7 +215,7 @@ static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
 
 	cseg->qpn_ds    = cpu_to_be32((sq->sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 				      ds_cnt);
-	cseg->umr_mkey  = rq->mkey_be;
+	cseg->umr_mkey  = rq->mpwqe.umr_mkey_be;
 
 	ucseg->flags = MLX5_UMR_TRANSLATION_OFFSET_EN | MLX5_UMR_INLINE;
 	ucseg->xlt_octowords =
@@ -365,9 +365,13 @@ static int mlx5e_create_umr_klm_mkey(struct mlx5_core_dev *mdev,
 static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq *rq)
 {
 	u64 num_mtts = mlx5_wq_ll_get_size(&rq->mpwqe.wq) * rq->mpwqe.mtts_per_wqe;
+	u32 umr_mkey;
+	int err;
 
-	return mlx5e_create_umr_mtt_mkey(mdev, num_mtts, rq->mpwqe.page_shift,
-					 &rq->umr_mkey, rq->wqe_overflow.addr);
+	err = mlx5e_create_umr_mtt_mkey(mdev, num_mtts, rq->mpwqe.page_shift,
+					&umr_mkey, rq->wqe_overflow.addr);
+	rq->mpwqe.umr_mkey_be = cpu_to_be32(umr_mkey);
+	return err;
 }
 
 static int mlx5e_create_rq_hd_umr_mkey(struct mlx5_core_dev *mdev,
@@ -575,6 +579,8 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 	rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params, xsk);
 	pool_size = 1 << params->log_rq_mtu_frames;
 
+	rq->mkey_be = cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey);
+
 	switch (rq->wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		err = mlx5_wq_ll_create(mdev, &rqp->wq, rqc_wq, &rq->mpwqe.wq,
@@ -611,7 +617,6 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		err = mlx5e_create_rq_umr_mkey(mdev, rq);
 		if (err)
 			goto err_rq_drop_page;
-		rq->mkey_be = cpu_to_be32(rq->umr_mkey);
 
 		err = mlx5e_rq_alloc_mpwqe_info(rq, node);
 		if (err)
@@ -647,8 +652,6 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		err = mlx5e_init_di_list(rq, wq_sz, node);
 		if (err)
 			goto err_rq_frags;
-
-		rq->mkey_be = cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey);
 	}
 
 	if (xsk) {
@@ -695,7 +698,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 
 			wqe->data[0].addr = cpu_to_be64(dma_offset + headroom);
 			wqe->data[0].byte_count = cpu_to_be32(byte_count);
-			wqe->data[0].lkey = rq->mkey_be;
+			wqe->data[0].lkey = rq->mpwqe.umr_mkey_be;
 		} else {
 			struct mlx5e_rx_wqe_cyc *wqe =
 				mlx5_wq_cyc_get_wqe(&rq->wqe.wq, i);
@@ -740,7 +743,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		kvfree(rq->mpwqe.info);
 err_rq_mkey:
-		mlx5_core_destroy_mkey(mdev, rq->umr_mkey);
+		mlx5_core_destroy_mkey(mdev, be32_to_cpu(rq->mpwqe.umr_mkey_be));
 err_rq_drop_page:
 		mlx5e_free_mpwqe_rq_drop_page(rq);
 		break;
@@ -773,7 +776,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 	switch (rq->wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		kvfree(rq->mpwqe.info);
-		mlx5_core_destroy_mkey(rq->mdev, rq->umr_mkey);
+		mlx5_core_destroy_mkey(rq->mdev, be32_to_cpu(rq->mpwqe.umr_mkey_be));
 		mlx5e_free_mpwqe_rq_drop_page(rq);
 		mlx5e_rq_free_shampo(rq);
 		break;
-- 
2.37.3

