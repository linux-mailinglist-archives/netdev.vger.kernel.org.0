Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21738348828
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhCYFE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:04:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhCYFEn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 669B761A1E;
        Thu, 25 Mar 2021 05:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648682;
        bh=+oXYI8YfqBdWLv7Ez8Kvq2TXo91gb1fS5BSoR47LKwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cG4yDoDAcyjKSCTGWCzIvjL/qvZR8iU3V0+KjxrhJKddorp5ADExm5aZ3sS64n8X1
         gjThLnBmID4w1DSh872PFODwTib7kuD2LE0Vwcf3w6xSp/ZtwWdmNfBjnSsxH4koL/
         9a4FIKQCfu1sBlQAjtw7hNaJzK3hAl06/xkvx9haq+X6Xy/NDbhFVnaRRn1+7v6qRl
         RzxWc0qcXK4Ufn800jTmU/x52BxeEyyJLtLd1nIA+QYVXmvjVAF0twlMlyntRC0Jf5
         I4l+JroKS4ywmdQnN3nat6D/qiu0AhM6gg/vaR3eudUasj+dztpo/87u15OpWhuqI6
         xGNvClFqHof6g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Enforce minimum value check for ICOSQ size
Date:   Wed, 24 Mar 2021 22:04:24 -0700
Message-Id: <20210325050438.261511-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
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
index 9c08f0bd1fcc..bf966178d0e6 100644
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
2.30.2

