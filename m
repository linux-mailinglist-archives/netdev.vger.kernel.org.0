Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E105EEEE1
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiI2HYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiI2HXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:23:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD0F1176F9
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E6B58CE20D3
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3C2C433D6;
        Thu, 29 Sep 2022 07:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436174;
        bh=5H62pWWTbMXELDAIcpxMO2VeUMXRVUOgenPdG0v4k6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFLptN6t9rYWYjnHTzchaGbDkJf2ywSPScskxHH3PNXT6L5YDvz/kdPzvokH6wFLo
         x44zdmZyFMKQKHCWhOMQtCEyrK6Vf9WvL0zq77ZnzEfsCugk+g2NN5yipso7evZIzf
         BILrH+tscEfjaEapHEBtu3ICo7LnwzzrqXwnjysEhPiqICH7qv3WFHu71MK1Boksxn
         WPHm6+Rh0rBqE7JCZEVBdxORMNcjJ9yfWDpGRtx2fUSB6HggFxVEYWCTD8WAeiXb5W
         YaGzIWjxG+XS6NsZ6deKc9rKrRPdsSOB2RvBWTph4Lrk1AmSA4iA7WT3BMfcVYNfod
         2knGZE1V+OMyg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 16/16] net/mlx5e: Clean up and fix error flows in mlx5e_alloc_rq
Date:   Thu, 29 Sep 2022 00:21:56 -0700
Message-Id: <20220929072156.93299-17-saeed@kernel.org>
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

Although mlx5e_rq_free_shampo can be called unconditionally, it belongs
to case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ. Move it there to allow to
add more init/cleanup actions to the striding RQ case.

If xdp_rxq_info_reg_mem_model fails, don't forget to destroy the page
pool.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b9591f902760..2719247b18db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -668,7 +668,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 
 		err = mlx5_rq_shampo_alloc(mdev, params, rqp, rq, &pool_size, node);
 		if (err)
-			goto err_free_by_rq_type;
+			goto err_free_mpwqe_info;
 
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
@@ -720,14 +720,14 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		if (IS_ERR(rq->page_pool)) {
 			err = PTR_ERR(rq->page_pool);
 			rq->page_pool = NULL;
-			goto err_free_shampo;
+			goto err_free_by_rq_type;
 		}
 		if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
 			err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
 							 MEM_TYPE_PAGE_POOL, rq->page_pool);
 	}
 	if (err)
-		goto err_free_shampo;
+		goto err_destroy_page_pool;
 
 	for (i = 0; i < wq_sz; i++) {
 		if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
@@ -780,11 +780,13 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 
 	return 0;
 
-err_free_shampo:
-	mlx5e_rq_free_shampo(rq);
+err_destroy_page_pool:
+	page_pool_destroy(rq->page_pool);
 err_free_by_rq_type:
 	switch (rq->wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		mlx5e_rq_free_shampo(rq);
+err_free_mpwqe_info:
 		kvfree(rq->mpwqe.info);
 err_rq_mkey:
 		mlx5_core_destroy_mkey(mdev, be32_to_cpu(rq->mpwqe.umr_mkey_be));
-- 
2.37.3

