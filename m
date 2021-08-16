Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24FE3EDF31
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhHPVTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232114AbhHPVTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCEF661052;
        Mon, 16 Aug 2021 21:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629148741;
        bh=+5g4pSeZu8dFHEFyOFMCQxMfQBOVj7J4EAMtRl9ojII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WM34zIHf5H+rS7XOnSNOKoz+ynPBHqix4qExbyZfkyes3OdCIGE4kd0C4Ik4fNEU1
         LQN/IAfKl5sRcWS5SB5uLzJIlkAQpNLOQ+FVyfAkcoA4kSMX1FyqKnXFMjePH3mJ19
         KzkTvgAoIeIf8YfEiLHNZSqKL1BIkrabiUwBBt0WsK+EZt8hYptxS4FDbNOkkNWWqr
         Wqo+jX29ZkFXJRpOAlGtHI0edpPeNRV6T9i2SyoBXeK+mbGreAm7yo77Anx8GKuJTR
         m/2ef4VFNREKCBYUK5JUEfEi0b+UzJv4qSIZTL70AKy231oZb7GwYUeRjOcEB0+PCj
         8K+HMZvkWpedA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/17] net/mlx5e: Do not try enable RSS when resetting indir table
Date:   Mon, 16 Aug 2021 14:18:31 -0700
Message-Id: <20210816211847.526937-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816211847.526937-1-saeed@kernel.org>
References: <20210816211847.526937-1-saeed@kernel.org>
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

