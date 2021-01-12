Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A0E2F28C2
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391942AbhALHPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:15:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:37720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391912AbhALHPG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:15:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3180B22D58;
        Tue, 12 Jan 2021 07:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435629;
        bh=eVmEEl5IUzxV3I5seYOrjoQkTz0LoW+wRp276OxEuQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHtRdVowJrxnkkLf+5m/ZpAojeJJjEQN/2rChhRSfcbf8G6t81z6ac//JylTmm8Bl
         xqmIa//N+4SZXQiUEDQiAGGewLvf5PxqM+UJ/ZeAR6KZC4LBzD6Iucg1dqYDBHerMT
         Xcjeznfc7R3eLJEM6WisRCVzCl1rNopFti1dsq548Q3DVlwLkcUBl2gc3K5EBQE5mH
         G8+xrWdZR5Yf0ZZSqufhKpMtNNLT6zhKwGykxF5yVtEZQLhMN9SNF7Igw2Y7X6xU3g
         BieXAsOZIV75M0eiITIcDWwCnhCMgSUFqym+6WQBSAo/22kfXbqO/HmfYdid0r40Ap
         1XOx/3iJBa0gg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Huy Nguyen <huyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 11/11] net/mlx5e: IPsec, Remove unnecessary config flag usage
Date:   Mon, 11 Jan 2021 23:05:34 -0800
Message-Id: <20210112070534.136841-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

MLX5_IPSEC_DEV() is always defined, no need to protect it under config
flag CONFIG_MLX5_EN_IPSEC, especially in slow path.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ee86b2b57f4d..f33c38629886 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2068,10 +2068,8 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	u32 buf_size = 0;
 	int i;
 
-#ifdef CONFIG_MLX5_EN_IPSEC
 	if (MLX5_IPSEC_DEV(mdev))
 		byte_count += MLX5E_METADATA_ETHER_LEN;
-#endif
 
 	if (mlx5e_rx_is_linear_skb(params, xsk)) {
 		int frag_stride;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7f5851c61218..cb8e3d2b4750 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1786,12 +1786,10 @@ int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params, bool
 		rq->dealloc_wqe = mlx5e_dealloc_rx_mpwqe;
 
 		rq->handle_rx_cqe = priv->profile->rx_handlers->handle_rx_cqe_mpwqe;
-#ifdef CONFIG_MLX5_EN_IPSEC
 		if (MLX5_IPSEC_DEV(mdev)) {
 			netdev_err(netdev, "MPWQE RQ with IPSec offload not supported\n");
 			return -EINVAL;
 		}
-#endif
 		if (!rq->handle_rx_cqe) {
 			netdev_err(netdev, "RX handler of MPWQE RQ is not set\n");
 			return -EINVAL;
-- 
2.26.2

