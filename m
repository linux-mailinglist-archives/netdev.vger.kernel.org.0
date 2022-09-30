Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276F15F1003
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiI3Qad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbiI3QaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:30:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA461277F
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1895B82976
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE10C433B5;
        Fri, 30 Sep 2022 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555378;
        bh=gdDcPiw8dmMFiN6zehUaqIcb+u/k9Fo5WbnhmKvgvCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9C3aZ9MXuI4Xfk7bIoaGJxayv9tLWiZ3I4wr7hLQXnDHnYMiWwkrAI6ewQuJgBla
         qTbehqvhRGADEx0I2UwiNPtbdYFwlSMw426jRuGpX8vuw3shuoVuiOEacmQCz0n1GP
         rMG9wJysK5NumlU/TGNE5uWxzkI4ba+lc6fkOnX67Mf1uuEqBn+Xq0g/fd8owF5moq
         ZSDyMPJh03gbS72qQYjRJ0SehNO1cQ0Fl6v8ThlrEGDe9kTY8LCiYgrWXS6TeCGUa1
         ZDbP2bRIl3wW5WvLRC/z5Xom7n7iDwpkeUS9GOgxa/lkV2Cp66IyZpf7vUDEF/4m7/
         EBgAWtxeY520Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 12/16] net/mlx5e: Call mlx5e_page_release_dynamic directly where possible
Date:   Fri, 30 Sep 2022 09:28:59 -0700
Message-Id: <20220930162903.62262-13-saeed@kernel.org>
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

mlx5e_page_release calls the appropriate deallocator depending on
whether it's an XSK RQ or a regular one. Some flows that call this
function are not compatible with XSK, so they can call the non-XSK
deallocator directly to save a branch.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 20 ++++---------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9d0a5c66c6a9..d0db6a66cb46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -588,12 +588,8 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	while (--i >= 0) {
 		dma_info = &shampo->info[--index];
 		if (!(i & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1))) {
-			union mlx5e_alloc_unit au = {
-				.page = dma_info->page,
-			};
-
 			dma_info->addr = ALIGN_DOWN(dma_info->addr, PAGE_SIZE);
-			mlx5e_page_release(rq, &au, true);
+			mlx5e_page_release_dynamic(rq, dma_info->page, true);
 		}
 	}
 	rq->stats->buff_alloc_err++;
@@ -698,7 +694,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 err_unmap:
 	while (--i >= 0) {
 		au--;
-		mlx5e_page_release(rq, au, true);
+		mlx5e_page_release_dynamic(rq, au->page, true);
 	}
 
 err:
@@ -731,12 +727,8 @@ void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close
 		hd_info = &shampo->info[index];
 		hd_info->addr = ALIGN_DOWN(hd_info->addr, PAGE_SIZE);
 		if (hd_info->page != deleted_page) {
-			union mlx5e_alloc_unit au = {
-				.page = hd_info->page,
-			};
-
 			deleted_page = hd_info->page;
-			mlx5e_page_release(rq, &au, false);
+			mlx5e_page_release_dynamic(rq, hd_info->page, false);
 		}
 	}
 
@@ -2061,12 +2053,8 @@ mlx5e_free_rx_shampo_hd_entry(struct mlx5e_rq *rq, u16 header_index)
 	u64 addr = shampo->info[header_index].addr;
 
 	if (((header_index + 1) & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1)) == 0) {
-		union mlx5e_alloc_unit au = {
-			.page = shampo->info[header_index].page,
-		};
-
 		shampo->info[header_index].addr = ALIGN_DOWN(addr, PAGE_SIZE);
-		mlx5e_page_release(rq, &au, true);
+		mlx5e_page_release_dynamic(rq, shampo->info[header_index].page, true);
 	}
 	bitmap_clear(shampo->bitmap, header_index, 1);
 }
-- 
2.37.3

