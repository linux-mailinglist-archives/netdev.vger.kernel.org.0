Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D5C34DA4A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhC2WWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231670AbhC2WVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A95D61985;
        Mon, 29 Mar 2021 22:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056501;
        bh=hhqLYmnwN7VXWqqcSPRk7rmwKCvHyRit3D6tFWVwE1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ndc2s5XZesNp6eBpmwwO6e9W8ESl1zNGrGuhsfU9dIEt+en9Dd72RmaKq8AjbyFvK
         plekwwDF2B2IsEx4zfzRZYp7m2g/Y1XSjt6l2bey8mvFEHs8MturERvVwTCp2Phtjm
         2IqbkURh83lMpwgvkfYEnsY730KyBaXyr8tvw/CxhGcMLnEGk9i/aDDgVxzOKTE28C
         XCiOXyo5S/6HCzQ4AeMGTm8WHuEKZ6SJdC4Px0gyaEQufqteWvAqJBUv3LcHJ7Ejdr
         7HdplgPwPpN6v5tbru4nNqVQPoMdVGCnQxiAanqIlLqrzvgO3h6aNZ4dA01d2LwlKS
         xTHRa/MZNWAfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 06/38] net/mlx5e: Enforce minimum value check for ICOSQ size
Date:   Mon, 29 Mar 2021 18:21:01 -0400
Message-Id: <20210329222133.2382393-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 5115daa675ccf70497fe56e8916cf738d8212c10 ]

The ICOSQ size should not go below MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE.
Enforce this where it's missing.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a2e0b548bf57..4ce3aeb3548f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2317,8 +2317,9 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5e_params *params,
 {
 	switch (params->rq_wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		return order_base_2(MLX5E_UMR_WQEBBS) +
-			mlx5e_get_rq_log_wq_sz(rqp->rqc);
+		return max_t(u8, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE,
+			     order_base_2(MLX5E_UMR_WQEBBS) +
+			     mlx5e_get_rq_log_wq_sz(rqp->rqc));
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
 	}
-- 
2.30.1

