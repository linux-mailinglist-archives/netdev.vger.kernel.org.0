Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE3B35FA4B
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352278AbhDNSHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36779 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352192AbhDNSGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 334AE61220;
        Wed, 14 Apr 2021 18:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423580;
        bh=wt+7wkvDC8bL/zFbDklOrrRR5rA4EdOW/nZbW+mnVHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PfQTPKv2UEg54dbGzyzq0LEmyZAtqSvdELCQHfEr4daDzW4//TtT3T4A5duovi2z+
         nvttDRzQCmbAWplCxZdiulw8b3QUe6Fx4bhgymh+Gy3JCpvpu/riX3SEVl8i//w+E6
         PcSVgsPDGyTyp6XI1+Jc3bfUr6GbxoWg4MIQjsPA77C9xHdHNPWnEJqpbpEShE0V/I
         ZI8FJ6JfyQjMDw2f3ixf9pJ5UsaWJROTkz656uoVKPzIB39GAHaWleiLVC+aaKrYnO
         I+G6CDqiIXVP3DBIniMVxy4d1mAWdunKNu8K3p89qxHHrKr703/P94lAYfMFR9VMsy
         smxeSUCgtowxQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 16/16] net/mlx5e: Fix RQ creation flow for queues which doesn't support XDP
Date:   Wed, 14 Apr 2021 11:06:05 -0700
Message-Id: <20210414180605.111070-17-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414180605.111070-1-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
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

