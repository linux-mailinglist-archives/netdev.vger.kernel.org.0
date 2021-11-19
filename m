Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B63E45777F
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbhKSUBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234482AbhKSUB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A06BD61B5F;
        Fri, 19 Nov 2021 19:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351900;
        bh=vw91kYrPvx8ZpavVGleVnEnRQZUr9+lTemVip7Pu2Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ih1I9OPmluwjUslcU7GvXFhmln43p/YLPCEDNBMyXmiFTRM571UpCvJaW2rhs5Zzh
         8Xrbom9KSMSA8fSTBPtoapvneGQI/FLcp2wDaKHeAC9zPedlLem9y4RiBHo5MBa8TC
         PMG06L8DD1Xr7v9iVFYXLzZldYlj/LwlQIsVM60oqYfsmOW/0XrVoLZM65QByzM2Nu
         VURnCy5DDYbIFlbZaeCR3xlJ8I9tb6bjd2Zwh+sy72+nmLt5pwUFVNdX1RUI+KFf49
         rZMfzcrrr+dXzeVnzG5z45+zQerLk/BJf4iwEfC3QNXm/fxqQbuh5ahkaMHSmHa0Dj
         oZjifaObVdyVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ben Ben-Ishay <benishay@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/10] net/mlx5e: SHAMPO, Fix constant expression result
Date:   Fri, 19 Nov 2021 11:58:08 -0800
Message-Id: <20211119195813.739586-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119195813.739586-1-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
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

