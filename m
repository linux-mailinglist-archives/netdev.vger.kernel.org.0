Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57763464744
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346993AbhLAGlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:41:01 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37306 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346964AbhLAGkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6174ACE1D6E
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0F9C53FD3;
        Wed,  1 Dec 2021 06:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340648;
        bh=vw91kYrPvx8ZpavVGleVnEnRQZUr9+lTemVip7Pu2Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ge3eHwVKgcsVEAgajIhz3Po77hn+xecVAFYm1bSV5H2S92jR9koAhT/pSVQ8xZ64g
         90F2xF4ldvGrbhsCtDKN+oKamkbauz3kyGjQ2/qSmB164ccf6VtduW4iShNkQywY08
         sAdNlgfU0XnGg2Zx6VwgWCHSbK4ywElLORkDfWoSG11iJGpkvLK227sIk7xgE50HXx
         wvHXYfXSk0Z27LjgkhfWbOGvD9EoXpTrmu6eNLKDsPKJWg+HhgCCDM1RySpE/jDayu
         NY1D7a6P95f3dt3RyRuru2dQlbfNAU8D3RFN00J5QniEbfBM8jKPXYuFNuiyIHXNHB
         T2MZn/r70Ln4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ben Ben-Ishay <benishay@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 13/13] net/mlx5e: SHAMPO, Fix constant expression result
Date:   Tue, 30 Nov 2021 22:37:09 -0800
Message-Id: <20211201063709.229103-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

mlx5e_build_shampo_hd_umr uses counters i and index incorrectly
as unsigned, thus the err state err_unmap could stuck in endless loop.
Change i to int to solve the first issue.
Reduce index check to solve the second issue, the caller function
validates that index could not rotate.

Fixes: 64509b052525 ("net/mlx5e: Add data path for SHAMPO feature")
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 96967b0a2441..793511d5ee4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -543,13 +543,13 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 				     u16 klm_entries, u16 index)
 {
 	struct mlx5e_shampo_hd *shampo = rq->mpwqe.shampo;
-	u16 entries, pi, i, header_offset, err, wqe_bbs, new_entries;
+	u16 entries, pi, header_offset, err, wqe_bbs, new_entries;
 	u32 lkey = rq->mdev->mlx5e_res.hw_objs.mkey;
 	struct page *page = shampo->last_page;
 	u64 addr = shampo->last_addr;
 	struct mlx5e_dma_info *dma_info;
 	struct mlx5e_umr_wqe *umr_wqe;
-	int headroom;
+	int headroom, i;
 
 	headroom = rq->buff.headroom;
 	new_entries = klm_entries - (shampo->pi & (MLX5_UMR_KLM_ALIGNMENT - 1));
@@ -601,9 +601,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 
 err_unmap:
 	while (--i >= 0) {
-		if (--index < 0)
-			index = shampo->hd_per_wq - 1;
-		dma_info = &shampo->info[index];
+		dma_info = &shampo->info[--index];
 		if (!(i & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1))) {
 			dma_info->addr = ALIGN_DOWN(dma_info->addr, PAGE_SIZE);
 			mlx5e_page_release(rq, dma_info, true);
-- 
2.31.1

