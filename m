Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAF263CE97
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbiK3FMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiK3FMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4BB7616D
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E1E7B81886
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433C9C433D6;
        Wed, 30 Nov 2022 05:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785125;
        bh=K2fWC3dZZaYIJyw7QjtenRpxwW1AxqFcFFZBeyYWWeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OeoIwSnvQ445NLuQ2YSRMFOD1TiM9Yh2X7d7NzWmmzy/mmNP9tgLIq9dxZNiHgblJ
         TsfnbLbcJJlNeUazi24fFP7Eu74M2NFF2MXjHOGO735lbK7X9J/ekqWV7ww44sIoMq
         EpOPdoy7+t6a0d9yhku3ZImtmd0pyBz7aSovmjU1sSLAQsvieC/4MXtzq7mqI6Yhhs
         4euksQUnJnV+bgAkQXmNJFiEOBRjW7i9nUITp4VrpUN5V0P0QtsQtozDltX9YCHCDj
         GYQPtuAODxrE53pbIj2N6eZ35lAvd+eb0w9rRV+A+8mO6McJiBgLHRgfsGXU7mbsy3
         /VJpId0ukDmfw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Use generic definition for UMR KLM alignment
Date:   Tue, 29 Nov 2022 21:11:44 -0800
Message-Id: <20221130051152.479480-8-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

MLX5_UMR_KLM_ALIGNMENT is in units of number of entries, while
MLX5_UMR_MTT_ALIGNMENT (generalized and renamed to
MLX5_UMR_FLEX_ALIGNMENT) is in byte units. This is misleading and
confusing.
Replace this KLM definition with one based on the generic definition.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 10 +++++-----
 include/linux/mlx5/device.h                     |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 3cad59ac1b48..65790ff58a74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -160,7 +160,7 @@ struct page_pool;
 	(((wqe_size) - sizeof(struct mlx5e_umr_wqe)) / sizeof(struct mlx5_klm))
 
 #define MLX5E_KLM_ENTRIES_PER_WQE(wqe_size)\
-	ALIGN_DOWN(MLX5E_KLM_MAX_ENTRIES_PER_WQE(wqe_size), MLX5_UMR_KLM_ALIGNMENT)
+	ALIGN_DOWN(MLX5E_KLM_MAX_ENTRIES_PER_WQE(wqe_size), MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT)
 
 #define MLX5E_MAX_KLM_PER_WQE(mdev) \
 	MLX5E_KLM_ENTRIES_PER_WQE(MLX5_SEND_WQE_BB * mlx5e_get_max_sq_aligned_wqebbs(mdev))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 8d71736116e0..c8820ab22169 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -593,8 +593,8 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	int headroom, i;
 
 	headroom = rq->buff.headroom;
-	new_entries = klm_entries - (shampo->pi & (MLX5_UMR_KLM_ALIGNMENT - 1));
-	entries = ALIGN(klm_entries, MLX5_UMR_KLM_ALIGNMENT);
+	new_entries = klm_entries - (shampo->pi & (MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT - 1));
+	entries = ALIGN(klm_entries, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT);
 	wqe_bbs = MLX5E_KLM_UMR_WQEBBS(entries);
 	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
 	umr_wqe = mlx5_wq_cyc_get_wqe(&sq->wq, pi);
@@ -603,7 +603,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	for (i = 0; i < entries; i++, index++) {
 		dma_info = &shampo->info[index];
 		if (i >= klm_entries || (index < shampo->pi && shampo->pi - index <
-					 MLX5_UMR_KLM_ALIGNMENT))
+					 MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT))
 			goto update_klm;
 		header_offset = (index & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1)) <<
 			MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE;
@@ -668,8 +668,8 @@ static int mlx5e_alloc_rx_hd_mpwqe(struct mlx5e_rq *rq)
 	if (!klm_entries)
 		return 0;
 
-	klm_entries += (shampo->pi & (MLX5_UMR_KLM_ALIGNMENT - 1));
-	index = ALIGN_DOWN(shampo->pi, MLX5_UMR_KLM_ALIGNMENT);
+	klm_entries += (shampo->pi & (MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT - 1));
+	index = ALIGN_DOWN(shampo->pi, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT);
 	entries_before = shampo->hd_per_wq - index;
 
 	if (unlikely(entries_before < klm_entries))
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index a02f779f5c5b..5fe5d198b57a 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -290,9 +290,9 @@ enum {
 	MLX5_UMR_INLINE			= (1 << 7),
 };
 
-#define MLX5_UMR_KLM_ALIGNMENT 4
 #define MLX5_UMR_FLEX_ALIGNMENT 0x40
 #define MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT (MLX5_UMR_FLEX_ALIGNMENT / sizeof(struct mlx5_mtt))
+#define MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT (MLX5_UMR_FLEX_ALIGNMENT / sizeof(struct mlx5_klm))
 
 #define MLX5_USER_INDEX_LEN (MLX5_FLD_SZ_BYTES(qpc, user_index) * 8)
 
-- 
2.38.1

