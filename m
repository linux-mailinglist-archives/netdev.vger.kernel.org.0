Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FBA334760
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhCJTES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233716AbhCJTDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26F6A64EAE;
        Wed, 10 Mar 2021 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403033;
        bh=/KsyP+Bu4Lck/Np5Pwam/Vf14xeuEIVtTTXur+QCLRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhRKr2DzgvT239YxGDbwFgNWogE9537yUt5Xc7azo0NDT6CyQ9+ENBs5xFUVtEKa3
         xWeDx/mvPAWzaMTqZPfG8XUu8pY/gA7hAhsy/VbBBJkY69qxZc92nEIYx38I1HFwxS
         KqmQqUh4IEXwquHtaXDcccikww++ARGn1lMSXHQMKM0DEr9uuBrw5+IdrZePchZ4ss
         N2yupKnvgsUX/3/XDSP8xKVTcURo8XKeCrvshj1gHEXc8D504M/bX9jrxR60MASEIQ
         1YAh+uvluy4zOjTCUagJuMcyhOpLH/MbVZI7SwGeDr4QIyBJsiYCVOp6JtMXVQmRQH
         DWuAfgAU9AUWg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/18] net/mlx5e: Enforce minimum value check for ICOSQ size
Date:   Wed, 10 Mar 2021 11:03:25 -0800
Message-Id: <20210310190342.238957-2-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

The ICOSQ size should not go below MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE.
Enforce this where it's missing.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ec2fcb2a2977..5c8ffa8da6f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2368,8 +2368,9 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5e_params *params,
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
2.29.2

