Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802C4348834
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCYFFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhCYFEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 468F461A1F;
        Thu, 25 Mar 2021 05:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648689;
        bh=5U9a+BeSLAvJuIVXkuFm5oZFKhAHwtbWo07PsXv8t+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QolL6RvrbGowVbPCB57lBosggsVYf4LQW0Q4GY/yNcOkTEoimDgDU2SYUQsW5fwA9
         2wNizibl1sqNKNxROXUZHaPYcooev4ij1PwMXsA6mPrG22rWZcVVmRabjl99oP//fI
         lqKXMzezWu9AkAPoUmcfjCfY/ka9sno/OMfOImjgXPpz9KO/NLL1QfFQyS3Jsg5n3s
         5jKp8F4OoOTGI2GWboHPFl9J3YDjalcsrlWKJN55cawIRKQcQzZHmZoRfOefVlWFmd
         YJF/cKjlhfVzmGNEGAkbFoo9i/Rp4lOb0eZ/8HM0YGzgQMlUenFm5XHFwFTbwi/fqV
         gtVo/zEEmZ0Gw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: Generalize direct-TIRs and direct-RQTs API
Date:   Wed, 24 Mar 2021 22:04:35 -0700
Message-Id: <20210325050438.261511-13-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add input parameter indicating the size of direct-TIRs/direct-RQTs array
to be created/destroyed. This allows next patches in the patch-set to
handle a single direct-TIR pointing to a direct-RQT with a single entry.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  8 ++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 43 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 15 ++++---
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 15 ++++---
 4 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 3051b653bef7..1ff8b79606f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1079,10 +1079,10 @@ int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv);
 int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc);
 void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv);
 
-int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
-void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
-int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
-void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
+int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n);
+void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n);
+int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n);
+void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n);
 void mlx5e_destroy_rqt(struct mlx5e_priv *priv, struct mlx5e_rqt *rqt);
 
 int mlx5e_create_tis(struct mlx5_core_dev *mdev, void *in, u32 *tisn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index eda30bc80a51..9096a7e6f4d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2221,12 +2221,12 @@ int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv)
 	return err;
 }
 
-int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
+int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n)
 {
 	int err;
 	int ix;
 
-	for (ix = 0; ix < priv->max_nch; ix++) {
+	for (ix = 0; ix < n; ix++) {
 		err = mlx5e_create_rqt(priv, 1 /*size */, &tirs[ix].rqt);
 		if (unlikely(err))
 			goto err_destroy_rqts;
@@ -2242,11 +2242,11 @@ int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
 	return err;
 }
 
-void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
+void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n)
 {
 	int i;
 
-	for (i = 0; i < priv->max_nch; i++)
+	for (i = 0; i < n; i++)
 		mlx5e_destroy_rqt(priv, &tirs[i].rqt);
 }
 
@@ -3247,7 +3247,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 	return err;
 }
 
-int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
+int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n)
 {
 	struct mlx5e_tir *tir;
 	void *tirc;
@@ -3261,7 +3261,7 @@ int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
 	if (!in)
 		return -ENOMEM;
 
-	for (ix = 0; ix < priv->max_nch; ix++) {
+	for (ix = 0; ix < n; ix++) {
 		memset(in, 0, inlen);
 		tir = &tirs[ix];
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
@@ -3299,11 +3299,11 @@ void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv)
 		mlx5e_destroy_tir(priv->mdev, &priv->inner_indir_tir[i]);
 }
 
-void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
+void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n)
 {
 	int i;
 
-	for (i = 0; i < priv->max_nch; i++)
+	for (i = 0; i < n; i++)
 		mlx5e_destroy_tir(priv->mdev, &tirs[i]);
 }
 
@@ -4876,6 +4876,7 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	u16 max_nch = priv->max_nch;
 	int err;
 
 	mlx5e_create_q_counters(priv);
@@ -4890,7 +4891,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv, priv->direct_tir);
+	err = mlx5e_create_direct_rqts(priv, priv->direct_tir, max_nch);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -4898,15 +4899,15 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv, priv->direct_tir);
+	err = mlx5e_create_direct_tirs(priv, priv->direct_tir, max_nch);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
-	err = mlx5e_create_direct_rqts(priv, priv->xsk_tir);
+	err = mlx5e_create_direct_rqts(priv, priv->xsk_tir, max_nch);
 	if (unlikely(err))
 		goto err_destroy_direct_tirs;
 
-	err = mlx5e_create_direct_tirs(priv, priv->xsk_tir);
+	err = mlx5e_create_direct_tirs(priv, priv->xsk_tir, max_nch);
 	if (unlikely(err))
 		goto err_destroy_xsk_rqts;
 
@@ -4935,15 +4936,15 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 err_destroy_flow_steering:
 	mlx5e_destroy_flow_steering(priv);
 err_destroy_xsk_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir);
+	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir, max_nch);
 err_destroy_xsk_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir);
+	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir, max_nch);
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
 err_destroy_indirect_rqts:
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 err_close_drop_rq:
@@ -4955,14 +4956,16 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 {
+	u16 max_nch = priv->max_nch;
+
 	mlx5e_accel_cleanup_rx(priv);
 	mlx5e_tc_nic_cleanup(priv);
 	mlx5e_destroy_flow_steering(priv);
-	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir);
-	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir);
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
+	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir, max_nch);
+	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir, max_nch);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
 	mlx5e_destroy_indirect_tirs(priv);
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_destroy_q_counters(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index e5123e9182c0..b597fc3b192b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -753,6 +753,7 @@ int mlx5e_rep_bond_update(struct mlx5e_priv *priv, bool cleanup)
 static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	u16 max_nch = priv->max_nch;
 	int err;
 
 	mlx5e_init_l2_addr(priv);
@@ -767,7 +768,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv, priv->direct_tir);
+	err = mlx5e_create_direct_rqts(priv, priv->direct_tir, max_nch);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -775,7 +776,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv, priv->direct_tir);
+	err = mlx5e_create_direct_tirs(priv, priv->direct_tir, max_nch);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
@@ -800,11 +801,11 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 err_destroy_ttc_table:
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
 err_destroy_indirect_rqts:
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 err_close_drop_rq:
@@ -814,13 +815,15 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 {
+	u16 max_nch = priv->max_nch;
+
 	mlx5e_ethtool_cleanup_steering(priv);
 	rep_vport_rx_rule_destroy(priv);
 	mlx5e_destroy_rep_root_ft(priv);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
 	mlx5e_destroy_indirect_tirs(priv);
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 7eeeb02a78c9..cfdef4211b77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -372,6 +372,7 @@ static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 static int mlx5i_init_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	u16 max_nch = priv->max_nch;
 	int err;
 
 	mlx5e_create_q_counters(priv);
@@ -386,7 +387,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv, priv->direct_tir);
+	err = mlx5e_create_direct_rqts(priv, priv->direct_tir, max_nch);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -394,7 +395,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv, priv->direct_tir);
+	err = mlx5e_create_direct_tirs(priv, priv->direct_tir, max_nch);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
@@ -405,11 +406,11 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	return 0;
 
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
 err_destroy_indirect_rqts:
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 err_close_drop_rq:
@@ -421,10 +422,12 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 
 static void mlx5i_cleanup_rx(struct mlx5e_priv *priv)
 {
+	u16 max_nch = priv->max_nch;
+
 	mlx5i_destroy_flow_steering(priv);
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
 	mlx5e_destroy_indirect_tirs(priv);
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_destroy_q_counters(priv);
-- 
2.30.2

