Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665E35F0FFE
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbiI3QaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbiI3Q3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6683BE03D
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CBD1623D3
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D59AC433C1;
        Fri, 30 Sep 2022 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555377;
        bh=1pLJlw1EVwfqT6OZYf1NVmPAkLr2tLtZW/lATty5Zg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfodgP7PF3OTKA9/cEybGzgVvXowmgwjgtK5dsz5emvcaDw7WBY6PxRLyeRwnRHOW
         IZC7cQUxAb8Fc83oqpXyRBboGS2yRFUVAV9K9Yc0jTpxiINCbKLSJMMQU7pvEgStj7
         6s+2TohaOkA+7MI+F3CAZuW6m32yAvdC5thoTndgtknr5ZsMNEQinpGZCsr3XUOvCQ
         DfETjZ6WimHiIcfz+swBQLJNVFKIJpmSD6DHhX2J9e+ZakJTgx92wCo5G8uzLKRP52
         i+hrRuwohqSJVxvREdOT+hyaXR0ImrpWBc25+qj3bWXOytAM6PeG/cG+Mus/2Nx5Fl
         xSx9anX++EDqA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 11/16] net/mlx5e: Use non-XSK page allocator in SHAMPO
Date:   Fri, 30 Sep 2022 09:28:58 -0700
Message-Id: <20220930162903.62262-12-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930162903.62262-1-saeed@kernel.org>
References: <20220930162903.62262-1-saeed@kernel.org>
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

The SHAMPO flow is not compatible with XSK, it can call the page pool
allocator directly to save a branch.

mlx5e_page_alloc is removed, as it's no longer used in any flow.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 329702e185a9..9d0a5c66c6a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -293,16 +293,6 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, union mlx5e_alloc_u
 	return 0;
 }
 
-static inline int mlx5e_page_alloc(struct mlx5e_rq *rq, union mlx5e_alloc_unit *au)
-{
-	if (rq->xsk_pool) {
-		au->xsk = xsk_buff_alloc(rq->xsk_pool);
-		return likely(au->xsk) ? 0 : -ENOMEM;
-	} else {
-		return mlx5e_page_alloc_pool(rq, au);
-	}
-}
-
 void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct page *page)
 {
 	dma_addr_t dma_addr = page_pool_get_dma_addr(page);
@@ -562,7 +552,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 		if (!(header_offset & (PAGE_SIZE - 1))) {
 			union mlx5e_alloc_unit au;
 
-			err = mlx5e_page_alloc(rq, &au);
+			err = mlx5e_page_alloc_pool(rq, &au);
 			if (unlikely(err))
 				goto err_unmap;
 			page = dma_info->page = au.page;
-- 
2.37.3

