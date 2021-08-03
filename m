Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEB03DE45A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbhHCC3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233300AbhHCC3J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9887761038;
        Tue,  3 Aug 2021 02:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957738;
        bh=kGmcbdjy5bUjaQyfPl3Kku+wKv+I5QOr+5yoSn4MtFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lX93nS0VbEl16aKC/0whaVfJsx3LCQni89kZrVQsxmRj5WoMwSbRYbfkm5xRdpgMZ
         Ov/uSqf+9jz/VtX3JSpEIzawTxJ9KDDIgohkSvx4Ug/9MU8LFBK05G93xJ3U/8l84n
         oEq3fJcbJG/b3Mz4AdUoRjY/O2eHbFDI796O+yeREYBcKPjwjstfWBzWmlR+G7SCR2
         JqKmrLPT/FhXj4ij4HbA/nz6/oUdzz5w28iWNp5vg0UC7Rza6XT9vR/jDj1HQP+x9y
         daGKsr+OTD2ELgOG/YyTGYF8Tti4tqlywsYIoH/QzKekmUpRKLslgVvXHncVIKExVW
         wq3PIPM/2xWWQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/16] net/mlx5e: Use a new initializer to build uniform indir table
Date:   Mon,  2 Aug 2021 19:28:38 -0700
Message-Id: <20210803022853.106973-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Replace mlx5e_build_default_indir_rqt with a new initializer of struct
mlx5e_rss_params_indir that works directly with the struct, rather than
its internals.

The new initializer is called mlx5e_rss_params_indir_init_uniform, which
also reflects the purpose (uniform spreading) better.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     |  3 ---
 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c |  9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h |  3 +++
 .../net/ethernet/mellanox/mlx5/core/en_main.c    | 16 +++-------------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  |  4 ++--
 5 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 35668986878a..87dabb8b8ac4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -984,9 +984,6 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx);
 
-void mlx5e_build_default_indir_rqt(u32 *indirection_rqt, int len,
-				   int num_channels);
-
 int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state);
 void mlx5e_activate_rq(struct mlx5e_rq *rq);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
index 38d0e9dbd6bd..b915fb29dd2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
@@ -4,6 +4,15 @@
 #include "rqt.h"
 #include <linux/mlx5/transobj.h>
 
+void mlx5e_rss_params_indir_init_uniform(struct mlx5e_rss_params_indir *indir,
+					 unsigned int num_channels)
+{
+	unsigned int i;
+
+	for (i = 0; i < MLX5E_INDIR_RQT_SIZE; i++)
+		indir->table[i] = i % num_channels;
+}
+
 static int mlx5e_rqt_init(struct mlx5e_rqt *rqt, struct mlx5_core_dev *mdev,
 			  u16 max_size, u32 *init_rqns, u16 init_size)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h
index d2c76649efb0..60c985a12f24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h
@@ -14,6 +14,9 @@ struct mlx5e_rss_params_indir {
 	u32 table[MLX5E_INDIR_RQT_SIZE];
 };
 
+void mlx5e_rss_params_indir_init_uniform(struct mlx5e_rss_params_indir *indir,
+					 unsigned int num_channels);
+
 struct mlx5e_rqt {
 	struct mlx5_core_dev *mdev;
 	u32 rqtn;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3e644d3955a8..68be4e0e77bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2572,8 +2572,8 @@ int mlx5e_num_channels_changed(struct mlx5e_priv *priv)
 
 	/* This function may be called on attach, before priv->rx_res is created. */
 	if (!netif_is_rxfh_configured(priv->netdev) && priv->rx_res)
-		mlx5e_build_default_indir_rqt(priv->rx_res->rss_params.indir.table,
-					      MLX5E_INDIR_RQT_SIZE, count);
+		mlx5e_rss_params_indir_init_uniform(&priv->rx_res->rss_params.indir,
+						    count);
 
 	return 0;
 }
@@ -4459,15 +4459,6 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_get_devlink_port    = mlx5e_get_devlink_port,
 };
 
-void mlx5e_build_default_indir_rqt(u32 *indirection_rqt, int len,
-				   int num_channels)
-{
-	int i;
-
-	for (i = 0; i < len; i++)
-		indirection_rqt[i] = i % num_channels;
-}
-
 static u32 mlx5e_choose_lro_timeout(struct mlx5_core_dev *mdev, u32 wanted_timeout)
 {
 	int i;
@@ -4488,8 +4479,7 @@ void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 	rss_params->hash.hfunc = ETH_RSS_HASH_TOP;
 	netdev_rss_key_fill(rss_params->hash.toeplitz_hash_key,
 			    sizeof(rss_params->hash.toeplitz_hash_key));
-	mlx5e_build_default_indir_rqt(rss_params->indir.table,
-				      MLX5E_INDIR_RQT_SIZE, num_channels);
+	mlx5e_rss_params_indir_init_uniform(&rss_params->indir, num_channels);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
 		rss_params->rx_hash_fields[tt] =
 			mlx5e_rss_get_default_tt_config(tt).rx_hash_fields;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2ef02fea119a..4d7ed24ae13c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -525,9 +525,9 @@ static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
 	if (!indir)
 		return -ENOMEM;
 
-	mlx5e_build_default_indir_rqt(indir->table, MLX5E_INDIR_RQT_SIZE, hp->num_channels);
+	mlx5e_rss_params_indir_init_uniform(indir, hp->num_channels);
 	err = mlx5e_rqt_init_indir(&hp->indir_rqt, mdev, hp->pair->rqn, hp->num_channels,
-				    priv->rx_res->rss_params.hash.hfunc, indir);
+				   priv->rx_res->rss_params.hash.hfunc, indir);
 
 	kvfree(indir);
 	return err;
-- 
2.31.1

