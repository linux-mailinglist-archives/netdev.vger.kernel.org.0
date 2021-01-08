Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205912EED17
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbhAHFce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:32:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbhAHFcd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:32:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EC5923435;
        Fri,  8 Jan 2021 05:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083863;
        bh=xfJYrAsNZVw0yeAgwqXIgmL8mQA4xtx+Jcljb4OuLxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfTAOnl8Uex8/5RNaTEmmaiyz28atRtcqitv7J0XXwp8+Dh6fiix4nDA/nK+5cPgD
         3OrUhOnqk4bKusOmOQiPsRicZJ6d9oNt+Hy4hOCe3f+BoB4x4xhB2+m2Q0n0oCbNuy
         mycoDYZDCDJUqpYpcybxGBpRyF9EByav0Ii6gbhBJZ9SbF43nUBGWrzbUK2suZfkr0
         +FYCC/Py5H2EpLjzSoEc6fCsB0SkH4RyT9GZFUm60T2WaN6XrvCxlwAnqM14ZHiaQn
         5mHk2QbNSaQItFiFNwD+30Ul+wNj9HjA7qKHi19PQEGTWadY+m1FVALLvJkY9cw/LL
         T3lBnM/AFSWFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Huy Nguyen <huyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: IPsec, Remove unnecessary config flag usage
Date:   Thu,  7 Jan 2021 21:30:54 -0800
Message-Id: <20210108053054.660499-16-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
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
index c00eef14ee6c..5309bc9f3197 100644
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

