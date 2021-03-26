Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973B434A000
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhCZCy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:54:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231146AbhCZCxy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:53:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6810E61A43;
        Fri, 26 Mar 2021 02:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616727233;
        bh=pm6jUCRMc7+Ny2BhLyBuQmH00opdgbAYUCFfMOCTTeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muSkmk8Qx7CeBJjgl0uhouk8MwOm1hs4+OSfIpS3KXE/vZrOToKmT7c13oKxcR1Je
         mKo/1NbwcjHECChN48/j7MLOJWVk5Pl2WoSlvZAzS24F64Upf4J7f+3JyZUcsBvLyO
         GlM6CjNMF0VXwojCZ35171eAeCMkM8kFke1G36c2aHqrwE+QbC+8Z+oDLPqwwUcer7
         xoFZlUGy10+43/L8f5a/RlSgla+Mc8eBR3lFmSujJSlcX5XmhQdTERg9V3TmpvZEIB
         FbZ6yQH2OXFLBlLHETPCWujJBvOOZFa1KjmoVX/ply59/OQMN85WuVHaVNN8LwT8X/
         tJr3UR6mMcDEg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 10/13] net/mlx5e: Generalize direct-TIRs and direct-RQTs API
Date:   Thu, 25 Mar 2021 19:53:42 -0700
Message-Id: <20210326025345.456475-11-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326025345.456475-1-saeed@kernel.org>
References: <20210326025345.456475-1-saeed@kernel.org>
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
index 2a9b40a96b9a..1158d8aefbe2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1080,10 +1080,10 @@ int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv);
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
index f2884edd4b61..df941fe808ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2223,12 +2223,12 @@ int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv)
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
@@ -2244,11 +2244,11 @@ int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
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
 
@@ -3249,7 +3249,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 	return err;
 }
 
-int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
+int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n)
 {
 	struct mlx5e_tir *tir;
 	void *tirc;
@@ -3263,7 +3263,7 @@ int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
 	if (!in)
 		return -ENOMEM;
 
-	for (ix = 0; ix < priv->max_nch; ix++) {
+	for (ix = 0; ix < n; ix++) {
 		memset(in, 0, inlen);
 		tir = &tirs[ix];
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
@@ -3301,11 +3301,11 @@ void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv)
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
 
@@ -4901,6 +4901,7 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	u16 max_nch = priv->max_nch;
 	int err;
 
 	mlx5e_create_q_counters(priv);
@@ -4915,7 +4916,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv, priv->direct_tir);
+	err = mlx5e_create_direct_rqts(priv, priv->direct_tir, max_nch);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -4923,15 +4924,15 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
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
 
@@ -4960,15 +4961,15 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
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
@@ -4980,14 +4981,16 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 
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
index 79f26b56e0a4..63ca73105149 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -373,6 +373,7 @@ static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 static int mlx5i_init_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	u16 max_nch = priv->max_nch;
 	int err;
 
 	mlx5e_create_q_counters(priv);
@@ -387,7 +388,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv, priv->direct_tir);
+	err = mlx5e_create_direct_rqts(priv, priv->direct_tir, max_nch);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -395,7 +396,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv, priv->direct_tir);
+	err = mlx5e_create_direct_tirs(priv, priv->direct_tir, max_nch);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
@@ -406,11 +407,11 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
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
@@ -422,10 +423,12 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 
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

