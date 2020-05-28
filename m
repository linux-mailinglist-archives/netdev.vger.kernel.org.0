Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CCE1E6013
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389172AbgE1MHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388520AbgE1L4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:56:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1623921532;
        Thu, 28 May 2020 11:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667004;
        bh=xiWSpWI4U3uOahzhPeFLZ8As7MvVhSzS0uPYinYb56g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGaPZU5MY3pDlY0Pm2h85Tz0bzeH6Pg+OtTvLU7HfEitUaGKCicYGNN2Zhq6++szx
         Uv5D1odfD/AJnre+y6z6UwRGmTjcYeYLda8q5C1YoOadCy9GFAESsboMijjNbBcSeL
         pYyUYama04bxErnIhh4tnoyssyY6u3ZZiqeFqP+0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roi Dayan <roid@mellanox.com>, Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 39/47] net/mlx5e: Fix inner tirs handling
Date:   Thu, 28 May 2020 07:55:52 -0400
Message-Id: <20200528115600.1405808-39-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

[ Upstream commit a16b8e0dcf7043bee46174bed0553cc9e36b63a5 ]

In the cited commit inner_tirs argument was added to create and destroy
inner tirs, and no indication was added to mlx5e_modify_tirs_hash()
function. In order to have a consistent handling, use
inner_indir_tir[0].tirn in tirs destroy/modify function as an indication
to whether inner tirs are created.
Inner tirs are not created for representors and before this commit,
a call to mlx5e_modify_tirs_hash() was sending HW commands to
modify non-existent inner tirs.

Fixes: 46dc933cee82 ("net/mlx5e: Provide explicit directive if to create inner indirect tirs")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 12 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c    |  4 ++--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 5a5e6a21c6e1..80c579948152 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1104,7 +1104,7 @@ void mlx5e_close_drop_rq(struct mlx5e_rq *drop_rq);
 int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv);
 
 int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc);
-void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc);
+void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv);
 
 int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
 void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d02db5aebac4..4fef7587165c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2747,7 +2747,8 @@ void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in, int inlen)
 		mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in, inlen);
 	}
 
-	if (!mlx5e_tunnel_inner_ft_supported(priv->mdev))
+	/* Verify inner tirs resources allocated */
+	if (!priv->inner_indir_tir[0].tirn)
 		return;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
@@ -3394,14 +3395,15 @@ out:
 	return err;
 }
 
-void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
+void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv)
 {
 	int i;
 
 	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++)
 		mlx5e_destroy_tir(priv->mdev, &priv->indir_tir[i]);
 
-	if (!inner_ttc || !mlx5e_tunnel_inner_ft_supported(priv->mdev))
+	/* Verify inner tirs resources allocated */
+	if (!priv->inner_indir_tir[0].tirn)
 		return;
 
 	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++)
@@ -5107,7 +5109,7 @@ err_destroy_xsk_rqts:
 err_destroy_direct_tirs:
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 err_destroy_indirect_tirs:
-	mlx5e_destroy_indirect_tirs(priv, true);
+	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 err_destroy_indirect_rqts:
@@ -5126,7 +5128,7 @@ static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir);
 	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir);
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
-	mlx5e_destroy_indirect_tirs(priv, true);
+	mlx5e_destroy_indirect_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 2ad0d09cc9bd..c3c3d89d9153 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1667,7 +1667,7 @@ err_destroy_ttc_table:
 err_destroy_direct_tirs:
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 err_destroy_indirect_tirs:
-	mlx5e_destroy_indirect_tirs(priv, false);
+	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 err_destroy_indirect_rqts:
@@ -1684,7 +1684,7 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 	mlx5_del_flow_rules(rpriv->vport_rx_rule);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
-	mlx5e_destroy_indirect_tirs(priv, false);
+	mlx5e_destroy_indirect_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 56078b23f1a0..0a334ceba7b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -396,7 +396,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 err_destroy_direct_tirs:
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 err_destroy_indirect_tirs:
-	mlx5e_destroy_indirect_tirs(priv, true);
+	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 err_destroy_indirect_rqts:
@@ -412,7 +412,7 @@ static void mlx5i_cleanup_rx(struct mlx5e_priv *priv)
 {
 	mlx5i_destroy_flow_steering(priv);
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
-	mlx5e_destroy_indirect_tirs(priv, true);
+	mlx5e_destroy_indirect_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
-- 
2.25.1

