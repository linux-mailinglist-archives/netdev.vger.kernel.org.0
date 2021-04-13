Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7DC35E71D
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346463AbhDMTb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346002AbhDMTa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0201A613D0;
        Tue, 13 Apr 2021 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342238;
        bh=wt+7wkvDC8bL/zFbDklOrrRR5rA4EdOW/nZbW+mnVHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAlOskeHpe8k7CWNdXR/n50oB+LcfrkAq1aq4xX48ofQ6fuRdPuGtRDCaPN0r5ATj
         7e+uK0JvcNdtSdN34VTS1ZTCyybAp0oh+OuHwzi/r6oF071qnw8dFUqegwlgq6hF3s
         CmltZXgZ08uGSa7kOHh705jxksV0zi7bJHEIJvWhejVWj3yl7sK0yUYjs2u5e57uux
         bM4sxiosAuU4iD2vHh9mls45fsyEgDZBNW9IfKHgn8Hx4Jv20Q+FbLMPlFtWHE92Aj
         cXl56iebfFDpbAdWnZJ8LKsGz2iOaKB71xN2L6Ru8XFlHndu8xT9dnAeRRbt9IS7wA
         Q98ntA+Wb6Udg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/16] net/mlx5e: Fix RQ creation flow for queues which doesn't support XDP
Date:   Tue, 13 Apr 2021 12:30:06 -0700
Message-Id: <20210413193006.21650-17-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Allow to create an RQ which is not registered as an XDP RQ. For example:
the trap-RQ doesn't register as an XDP RQ.

Fixes: 869c5f926247 ("net/mlx5e: Generalize open RQ")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2f47608bb9b9..6847e7b909a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -510,8 +510,9 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			rq->page_pool = NULL;
 			goto err_free_by_rq_type;
 		}
-		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
-						 MEM_TYPE_PAGE_POOL, rq->page_pool);
+		if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
+			err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
+							 MEM_TYPE_PAGE_POOL, rq->page_pool);
 	}
 	if (err)
 		goto err_free_by_rq_type;
-- 
2.30.2

