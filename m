Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6608934882D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCYFFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhCYFEr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4ED361A1E;
        Thu, 25 Mar 2021 05:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648687;
        bh=JvnHkIqf8yw/zcQeNF8UMe7zyspDqGOvxepq4rgTegk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hb2YQfQmoX8fT+OvCle4iV7ukxBBHvCk143OIyszq7+9eD8VhuwlXN9HThUUflxcn
         nVvEe5utdTstluHR0eIssl9RQfUYlSdnQ7MSShlUDvZHIorhvfXR3axpshM/uysyXs
         Hb4XrcJVFBhnK21/EnpRb9cyiUTlEt27jTK4wj8runSsVZLqClQrfRtbxMIrIMEIBq
         VKcWCupTXg2Sinxa98y+xiTGbZPnPOPkx9OvSzPH8kvoF54V9THrAcothTLXZEHhIu
         e3yHgeSS6vvfOS6ou2xr+0Hdv42folPHYBk3sgI0RMzWITFyrqkHRvFtPJEgcM1hCZ
         Da+OFVDM0MxTw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Allow creating mpwqe info without channel
Date:   Wed, 24 Mar 2021 22:04:30 -0700
Message-Id: <20210325050438.261511-8-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Change the signature of mlx5e_rq_alloc_mpwqe_info from receiving channel
pointer to receive the NUMA node. This allows creating mpwqe_info in
context of different channels types.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fe98f7d7921f..4ffe42641a2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -214,18 +214,17 @@ static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
 	ucseg->mkey_mask     = cpu_to_be64(MLX5_MKEY_MASK_FREE);
 }
 
-static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq,
-				     struct mlx5e_channel *c)
+static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq, int node)
 {
 	int wq_sz = mlx5_wq_ll_get_size(&rq->mpwqe.wq);
 
 	rq->mpwqe.info = kvzalloc_node(array_size(wq_sz,
 						  sizeof(*rq->mpwqe.info)),
-				       GFP_KERNEL, cpu_to_node(c->cpu));
+				       GFP_KERNEL, node);
 	if (!rq->mpwqe.info)
 		return -ENOMEM;
 
-	mlx5e_build_umr_wqe(rq, &c->icosq, &rq->mpwqe.umr_wqe);
+	mlx5e_build_umr_wqe(rq, rq->icosq, &rq->mpwqe.umr_wqe);
 
 	return 0;
 }
@@ -459,7 +458,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			goto err_rq_drop_page;
 		rq->mkey_be = cpu_to_be32(rq->umr_mkey.key);
 
-		err = mlx5e_rq_alloc_mpwqe_info(rq, c);
+		err = mlx5e_rq_alloc_mpwqe_info(rq, cpu_to_node(c->cpu));
 		if (err)
 			goto err_rq_mkey;
 		break;
-- 
2.30.2

