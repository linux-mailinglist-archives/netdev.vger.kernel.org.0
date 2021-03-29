Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303CB34DB03
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhC2WYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232434AbhC2WXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:23:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C89CB619B4;
        Mon, 29 Mar 2021 22:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056589;
        bh=dW/FEnYEm3JWUcwo0umvqYQf1VrjpyD+saPeoGlJuUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obSF5OixHiFHzHYl6oqE+zTwCb6dyf7vG1wgc9+gxKUUNbs8VVecY6ogljBB3YFt0
         dGZla62U0eXgdD2abn4xOuyj25mFJnjp+pk+sFuPYgO0hxv9TPlG0E6sn6ZFSd2WVL
         sLsKjX58NUMwdHxDptfsj5UZ7gOj9b34gV9tWl3NI3cSEhYRvwZxq/gO6HeOReKfuv
         luT2Ercq2/zj5XqfZh8dATOoARRnw4xaeC8voOWFo9AEw/hc046joGh+J35AAyEPEb
         QjSShm5u4hk+ybFkbuURUdLfweuSJe28fl/C5WU+DrH+S6axT7C7q1x1Aed8t/iizq
         ASvAs7ZCZIB1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/19] net/mlx5e: Enforce minimum value check for ICOSQ size
Date:   Mon, 29 Mar 2021 18:22:48 -0400
Message-Id: <20210329222303.2383319-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222303.2383319-1-sashal@kernel.org>
References: <20210329222303.2383319-1-sashal@kernel.org>
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
index 8b8581f71e79..36b9a364ef26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2365,8 +2365,9 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5e_params *params,
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

