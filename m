Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712AF397E20
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhFBBjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:39:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230049AbhFBBjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 21:39:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC8A6613D2;
        Wed,  2 Jun 2021 01:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622597854;
        bh=M+p/R6oPTC+18S3lZfPjOhyfDQqbdN3cqd1+PVIt1/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mggGwgWpA0SlMyHWwhn8vYHAiwY8P0zQTrXx8tJ/Twl14TxIH2YH6dABFSc4SF2dF
         dThTSY7QNw997jI6IWcwQ1j8L1Nj6fcAxlJVPhinCctO+YbWw7v6d1qIw2nufmW4Qz
         LmuH1TJFq8c0ToK5jHZcYxVfOwp/emTB/Yx5yYQuMVCq0no6GBktAahgQiVavITu0M
         e36ggH2Tw2tYM+SuUmwmop7N+Av+3tDbuh9qoiweo3BLL1vIivo4SrTeyusVJAKe8v
         fxv9XJ3O1/yjE8c9Jnk/FgpAPyzFT8/x6gNMjOAT5vJpyPxB9FjT4f3OLuRq5T3b1T
         fkoY/jlqQz24w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/8] net/mlx5e: Fix adding encap rules to slow path
Date:   Tue,  1 Jun 2021 18:37:20 -0700
Message-Id: <20210602013723.1142650-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602013723.1142650-1-saeed@kernel.org>
References: <20210602013723.1142650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

On some devices the ignore flow level cap is not supported and we
shouldn't use it. Setting the dest ft with mlx5_chains_get_tc_end_ft()
already gives the correct end ft if ignore flow level cap is supported
or not.

Fixes: 39ac237ce009 ("net/mlx5: E-Switch, Refactor chains and priorities")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h    | 5 +++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index db1e74280e57..d18a28a6e9a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -219,7 +219,8 @@ esw_setup_slow_path_dest(struct mlx5_flow_destination *dest,
 			 struct mlx5_fs_chains *chains,
 			 int i)
 {
-	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+	if (mlx5_chains_ignore_flow_level_supported(chains))
+		flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[i].ft = mlx5_chains_get_tc_end_ft(chains);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 00ef10a1a9f8..20a4047f2737 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -107,7 +107,7 @@ bool mlx5_chains_prios_supported(struct mlx5_fs_chains *chains)
 	return chains->flags & MLX5_CHAINS_AND_PRIOS_SUPPORTED;
 }
 
-static bool mlx5_chains_ignore_flow_level_supported(struct mlx5_fs_chains *chains)
+bool mlx5_chains_ignore_flow_level_supported(struct mlx5_fs_chains *chains)
 {
 	return chains->flags & MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
index e96f345e7dae..d50bdb226cef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
@@ -28,6 +28,7 @@ struct mlx5_chains_attr {
 
 bool
 mlx5_chains_prios_supported(struct mlx5_fs_chains *chains);
+bool mlx5_chains_ignore_flow_level_supported(struct mlx5_fs_chains *chains);
 bool
 mlx5_chains_backwards_supported(struct mlx5_fs_chains *chains);
 u32
@@ -70,6 +71,10 @@ mlx5_chains_set_end_ft(struct mlx5_fs_chains *chains,
 
 #else /* CONFIG_MLX5_CLS_ACT */
 
+static inline bool
+mlx5_chains_ignore_flow_level_supported(struct mlx5_fs_chains *chains)
+{ return false; }
+
 static inline struct mlx5_flow_table *
 mlx5_chains_get_table(struct mlx5_fs_chains *chains, u32 chain, u32 prio,
 		      u32 level) { return ERR_PTR(-EOPNOTSUPP); }
-- 
2.31.1

