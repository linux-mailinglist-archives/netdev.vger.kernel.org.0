Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C503F3EE053
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhHPXXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233956AbhHPXXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 19:23:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A36360F38;
        Mon, 16 Aug 2021 23:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629156149;
        bh=+5g4pSeZu8dFHEFyOFMCQxMfQBOVj7J4EAMtRl9ojII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GE+mh0t2IuW8Aj48heBKaJB9VQNEPAq7738kldJH5ecEPIvPo29wi01w/2lzsKEtB
         cj8ujMbFwjeKAMsuOHGTp5w7wI3ByCnzK8hTiEELlHGl+dKhvkZiXwFAzSWqQ0hSTc
         hMBa1tUMvXrwC6ZY9eqMhq4kArazEBtDyvf2Z2JNF7Cpg+M3dEh9pXsVu6v3fxoI4u
         OazmOZ5s50N9inee4d+YXwrW03EeZWzAdnH7qR5qoKcj2KQfoSRHIgAVl7qd1vqR8+
         X6N8FN/MsAxUFM3UtuX02a+ldI3GGygYvy9hMzUFpVhewROj0XZjmwrdlxoiafESEu
         cbzdTRVCe1MuA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 01/17] net/mlx5e: Do not try enable RSS when resetting indir table
Date:   Mon, 16 Aug 2021 16:22:03 -0700
Message-Id: <20210816232219.557083-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816232219.557083-1-saeed@kernel.org>
References: <20210816232219.557083-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

All calls to mlx5e_rx_res_rss_set_indir_uniform() occur while the RSS
state is inactive, i.e. the RQT is pointing to the drop RQ, not to the
channels' RQs.
It means that the "apply" part of the function is not called.
Remove this part from the function, and document the change. It will be
useful for next patches in the series, allows code simplifications when
multiple RSS contexts are introduced.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
index e2a8fe13f29d..2d0e8c809936 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
@@ -617,14 +617,11 @@ mlx5e_rx_res_rss_get_current_tt_config(struct mlx5e_rx_res *res, enum mlx5_traff
 	return rss_tt;
 }
 
+/* Updates the indirection table SW shadow, does not update the HW resources yet */
 void mlx5e_rx_res_rss_set_indir_uniform(struct mlx5e_rx_res *res, unsigned int nch)
 {
+	WARN_ON_ONCE(res->rss_active);
 	mlx5e_rss_params_indir_init_uniform(&res->rss_params.indir, nch);
-
-	if (!res->rss_active)
-		return;
-
-	mlx5e_rx_res_rss_enable(res);
 }
 
 void mlx5e_rx_res_rss_get_rxfh(struct mlx5e_rx_res *res, u32 *indir, u8 *key, u8 *hfunc)
-- 
2.31.1

