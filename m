Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255CD60956
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfGEPay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:30:54 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52448 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727910AbfGEPaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:30:52 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Jul 2019 18:30:42 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x65FUfOj029656;
        Fri, 5 Jul 2019 18:30:41 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        moshe@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 10/12] net/mlx5e: Re-work TIS creation functions
Date:   Fri,  5 Jul 2019 18:30:20 +0300
Message-Id: <1562340622-4423-11-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the EN TIS creation function (mlx5e_create_tis) be responsible
for applying common mdev related fields.
Other specific fields must be set by the caller and passed within
the inbox.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h            |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c       | 17 ++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c   | 14 +++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h   |  2 ++
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c  |  2 +-
 5 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 09c43c9f3b4a..d3d2733917ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1053,8 +1053,7 @@ int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
 void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
 void mlx5e_destroy_rqt(struct mlx5e_priv *priv, struct mlx5e_rqt *rqt);
 
-int mlx5e_create_tis(struct mlx5_core_dev *mdev, int tc,
-		     u32 underlay_qpn, u32 *tisn);
+int mlx5e_create_tis(struct mlx5_core_dev *mdev, void *in, u32 *tisn);
 void mlx5e_destroy_tis(struct mlx5_core_dev *mdev, u32 tisn);
 
 int mlx5e_create_tises(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index edbedb1c85f8..075496de00e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3150,20 +3150,16 @@ void mlx5e_close_drop_rq(struct mlx5e_rq *drop_rq)
 	mlx5e_free_cq(&drop_rq->cq);
 }
 
-int mlx5e_create_tis(struct mlx5_core_dev *mdev, int tc,
-		     u32 underlay_qpn, u32 *tisn)
+int mlx5e_create_tis(struct mlx5_core_dev *mdev, void *in, u32 *tisn)
 {
-	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {0};
 	void *tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
 
-	MLX5_SET(tisc, tisc, prio, tc << 1);
-	MLX5_SET(tisc, tisc, underlay_qpn, underlay_qpn);
 	MLX5_SET(tisc, tisc, transport_domain, mdev->mlx5e_res.td.tdn);
 
 	if (mlx5_lag_is_lacp_owner(mdev))
 		MLX5_SET(tisc, tisc, strict_lag_tx_port_affinity, 1);
 
-	return mlx5_core_create_tis(mdev, in, sizeof(in), tisn);
+	return mlx5_core_create_tis(mdev, in, MLX5_ST_SZ_BYTES(create_tis_in), tisn);
 }
 
 void mlx5e_destroy_tis(struct mlx5_core_dev *mdev, u32 tisn)
@@ -3177,7 +3173,14 @@ int mlx5e_create_tises(struct mlx5e_priv *priv)
 	int tc;
 
 	for (tc = 0; tc < priv->profile->max_tc; tc++) {
-		err = mlx5e_create_tis(priv->mdev, tc, 0, &priv->tisn[tc]);
+		u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
+		void *tisc;
+
+		tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
+
+		MLX5_SET(tisc, tisc, prio, tc << 1);
+
+		err = mlx5e_create_tis(priv->mdev, in, &priv->tisn[tc]);
 		if (err)
 			goto err_close_tises;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 00e66c3772cc..faf197d53743 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -258,6 +258,18 @@ void mlx5i_destroy_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *
 	mlx5_core_destroy_qp(mdev, qp);
 }
 
+int mlx5i_create_tis(struct mlx5_core_dev *mdev, u32 underlay_qpn, u32 *tisn)
+{
+	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
+	void *tisc;
+
+	tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
+
+	MLX5_SET(tisc, tisc, underlay_qpn, underlay_qpn);
+
+	return mlx5e_create_tis(mdev, in, tisn);
+}
+
 static int mlx5i_init_tx(struct mlx5e_priv *priv)
 {
 	struct mlx5i_priv *ipriv = priv->ppriv;
@@ -269,7 +281,7 @@ static int mlx5i_init_tx(struct mlx5e_priv *priv)
 		return err;
 	}
 
-	err = mlx5e_create_tis(priv->mdev, 0 /* tc */, ipriv->qp.qpn, &priv->tisn[0]);
+	err = mlx5i_create_tis(priv->mdev, ipriv->qp.qpn, &priv->tisn[0]);
 	if (err) {
 		mlx5_core_warn(priv->mdev, "create tis failed, %d\n", err);
 		goto err_destroy_underlay_qp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index e19ba3fcd1b7..c87962cab921 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -59,6 +59,8 @@ struct mlx5i_priv {
 	char  *mlx5e_priv[0];
 };
 
+int mlx5i_create_tis(struct mlx5_core_dev *mdev, u32 underlay_qpn, u32 *tisn);
+
 /* Underlay QP create/destroy functions */
 int mlx5i_create_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp);
 void mlx5i_destroy_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index e05186ada721..6e56fa769d2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -210,7 +210,7 @@ static int mlx5i_pkey_open(struct net_device *netdev)
 		goto err_unint_underlay_qp;
 	}
 
-	err = mlx5e_create_tis(mdev, 0 /* tc */, ipriv->qp.qpn, &epriv->tisn[0]);
+	err = mlx5i_create_tis(mdev, ipriv->qp.qpn, &epriv->tisn[0]);
 	if (err) {
 		mlx5_core_warn(mdev, "create child tis failed, %d\n", err);
 		goto err_remove_rx_uderlay_qp;
-- 
1.8.3.1

