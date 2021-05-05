Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4FD3743CC
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbhEEQwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234614AbhEEQru (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:47:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E624361954;
        Wed,  5 May 2021 16:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232621;
        bh=EYWBTJda0F6zMNnuHeE7/4rKHkgRRO3h1/YDuq1xrtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLklRGjsU4pMeTfUue6CFAkXFNhoKiFe8xBo1D1t+M74ltVHfRWqMpLbNnN/yCWeL
         0BKs1bMOj76U9xxJfJj5qlTr7Wr21pHIQy493M64+2+SAta46/eRyTw536zyj2uDOp
         xNItLBCwLnj0Jk8uDfSjuaWVbWYp5VPI1fnnd/Rlw8rqtcUH3OWHcppwZIOEI+fTL2
         uh448gLP2FBPDzUMPIzjCBe+Wwk+T3CEALs53jssH2rVlB/+xQGvEj11Z4XcHWnjEx
         Nm+DoAeP8GW7tZh2QYbDs2oQh9Tce12J62ImPuyAErRIRhrL0YL874LNi+tHrZklw5
         zExrjqZZxLMzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/85] net/mlx5e: Use net_prefetchw instead of prefetchw in MPWQE TX datapath
Date:   Wed,  5 May 2021 12:35:31 -0400
Message-Id: <20210505163648.3462507-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 991b2654605b455a94dac73e14b23480e7e20991 ]

Commit e20f0dbf204f ("net/mlx5e: RX, Add a prefetch command for small
L1_CACHE_BYTES") switched to using net_prefetchw at all places in mlx5e.
In the same time frame, commit 5af75c747e2a ("net/mlx5e: Enhanced TX
MPWQE for SKBs") added one more usage of prefetchw. When these two
changes were merged, this new occurrence of prefetchw wasn't replaced
with net_prefetchw.

This commit fixes this last occurrence of prefetchw in
mlx5e_tx_mpwqe_session_start, making the same change that was done in
mlx5e_xdp_mpwqe_session_start.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 38a23d209b33..373668068071 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -486,7 +486,7 @@ static void mlx5e_tx_mpwqe_session_start(struct mlx5e_txqsq *sq,
 
 	pi = mlx5e_txqsq_get_next_pi(sq, MLX5E_TX_MPW_MAX_WQEBBS);
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
-	prefetchw(wqe->data);
+	net_prefetchw(wqe->data);
 
 	*session = (struct mlx5e_tx_mpwqe) {
 		.wqe = wqe,
-- 
2.30.2

