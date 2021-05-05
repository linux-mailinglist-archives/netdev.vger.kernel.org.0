Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98863374017
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhEEQcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234125AbhEEQcj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:32:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C065D613C4;
        Wed,  5 May 2021 16:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232302;
        bh=D1HnKk3qKfabMQLP5TPQQ+NW7JOqOCi7mRF2YovF1OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=InwEnx0olsgucrDinW5D1EWDBz4V41z6zldPsbphK7EEXGFFXnD94UL2QMMuOhU7n
         7qG4265Rs4EngdYEmpgZVs4nUu+mxsEAZXpoigJvxvCwsTgVsONCh64GJnxDCey2Ob
         np/pcXgWNl2izGtFFWfLqkA9G9HRWOF/Q1olgtTxhDkOz2A1fvYaRJfMVhzjVheKDh
         V3YJQK6fX36kS1NUxfC/CrvQm4BHDGbpZh/wdS3Hx8APrIG8QrUm5US1p98Jz3vAXD
         JQh6OaMp0Qq5qK63/is0yMjPREoQBj969V+NoN1gi9rNZw8fiaAp4x/HBrmLuCUE5i
         HMt9JGyj6su3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 013/116] net/mlx5e: Use net_prefetchw instead of prefetchw in MPWQE TX datapath
Date:   Wed,  5 May 2021 12:29:41 -0400
Message-Id: <20210505163125.3460440-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index bdbffe484fce..d2efe2455955 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -576,7 +576,7 @@ static void mlx5e_tx_mpwqe_session_start(struct mlx5e_txqsq *sq,
 
 	pi = mlx5e_txqsq_get_next_pi(sq, MLX5E_TX_MPW_MAX_WQEBBS);
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
-	prefetchw(wqe->data);
+	net_prefetchw(wqe->data);
 
 	*session = (struct mlx5e_tx_mpwqe) {
 		.wqe = wqe,
-- 
2.30.2

