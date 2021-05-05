Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9714D374203
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbhEEQnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235173AbhEEQlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41E8F61404;
        Wed,  5 May 2021 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232472;
        bh=pA65frvz9Je2dhxeBGvonLp1FZJzdusgRI1gUhk9gCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKN48+hSNfxp8sl0V2MrMsD6kKVrrRsct/PCUrI2CqH07TDe2GcTffkgUjeZgjfr0
         IGZG7b21Wn1wNJKI2jgAow0HOFFjtrglJjwYRLccF7CGnUlLREMvAgI5S0uVTtd3E7
         7UMom1VUqm9w62N7UDUKJDUOk4UxYqmqtLIjcmPFRkMRMm/G7Kr4jy/beODVw3dB5t
         zuMe0w9+8XdF3r+ggXZZW8I1dPYpYQilh8EpFyw4hJC/iqjNbQnQ0BMkE1vV+6BYM/
         zUMADg7PhY5v8k9ngSZanCKwtfJ1wbOn9CqWIt+p+BdIfeT8awYvNVsqORnW3DhsiO
         2MmD6ckzu1Z2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 013/104] net/mlx5e: Use net_prefetchw instead of prefetchw in MPWQE TX datapath
Date:   Wed,  5 May 2021 12:32:42 -0400
Message-Id: <20210505163413.3461611-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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
index 61ed671fe741..1b3c93c3fd23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -553,7 +553,7 @@ static void mlx5e_tx_mpwqe_session_start(struct mlx5e_txqsq *sq,
 
 	pi = mlx5e_txqsq_get_next_pi(sq, MLX5E_TX_MPW_MAX_WQEBBS);
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
-	prefetchw(wqe->data);
+	net_prefetchw(wqe->data);
 
 	*session = (struct mlx5e_tx_mpwqe) {
 		.wqe = wqe,
-- 
2.30.2

