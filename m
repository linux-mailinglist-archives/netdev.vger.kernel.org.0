Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E5A349FFA
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhCZCyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230516AbhCZCxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E27EF619FC;
        Fri, 26 Mar 2021 02:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616727231;
        bh=Jk3WtYofcG0vzzPnx7kf8xMid9Gzhfc2dlyZ29e+fkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHOrG35GNBPHR+erARm6zyBillQCH5Gr2Ord2Z7mlfmBb6DQwwFu2FTquLyEXGwUJ
         +f1fuje2wRrhZB/kqeg+9SwwunkjpI1YNXb+03TrWW4cFAjLWEGpi1XIwNBoQ8A1Nu
         873vjtlF2ICT9wDLReMRBgPw4UAJfQbci8LSnxX/HtaUaD5c38kqSVoLnK12pwW10P
         nkJmA9zgOMIcRWwFlHJ7a/js/IX29SpMts11T7xa3HMmjSzKvuOWd4kMWXvIb2r6B1
         /eVByqXYEapnnS9SgUKXJww8RllGO54/Hi2Z6lyEqLmdYnBSbVbJPAYmd/s7/ZfHxU
         of5PeT3EApaig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 05/13] net/mlx5e: Allow creating mpwqe info without channel
Date:   Thu, 25 Mar 2021 19:53:37 -0700
Message-Id: <20210326025345.456475-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326025345.456475-1-saeed@kernel.org>
References: <20210326025345.456475-1-saeed@kernel.org>
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
index e3196bba5955..395b44141ca9 100644
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

