Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5483054D0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhA0HjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:39:10 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4569 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317400AbhAZX75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:59:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a9860000>; Tue, 26 Jan 2021 15:45:10 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:45:09 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/12] net/mlx5e: Revert parameters on errors when changing MTU and LRO state without reset
Date:   Tue, 26 Jan 2021 15:43:44 -0800
Message-ID: <20210126234345.202096-12-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126234345.202096-1-saeedm@nvidia.com>
References: <20210126234345.202096-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611704710; bh=kQ46cEHd2ieesMB7j/dbpGzdD34vj8BvujoSHq6NRXc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Kl2My+4UbtvwmzKer67rTzEElYx9G+bEe+afqYoMGktSyMPTymBJ8EFNebbkSp/xA
         pqlEEOUST9wrvybHH4F/to1dZZxNkbo3SYTil2xaGW8wjgCSGkx2qj+RKuEAicEkAY
         wU0Y7YmF6onuqSsMEautRaD9OHuEd14nyVRJTZ7GnYVZXpn+faw5d/kdfS3kDtTmyf
         lSTLKwlRT4Ffo7WxUB09vl/Bne3Crei3Kn/dV8uZ5Ah5Lu+lKv50RwI2WG523kC+s4
         BuZrZ9n96OGajgnM0nmYmxdLkLo6gguoyansj/hHFXClA4iwanPMvVXtlYfFZ4LBFZ
         4W1e+EoUc5Log==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Sometimes, channel params are changed without recreating the channels.
It happens in two basic cases: when the channels are closed, and when
the parameter being changed doesn't affect how channels are configured.
Such changes invoke a hardware command that might fail. The whole
operation should be reverted in such cases, but the code that restores
the parameters' values in the driver was missing. This commit adds this
handling.

Fixes: 2e20a151205b ("net/mlx5e: Fail safe mtu and lro setting")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 30 +++++++++++++------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index ac76d32bad7d..a9d824a9cb05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3764,7 +3764,7 @@ static int set_feature_lro(struct net_device *netdev,=
 bool enable)
 	struct mlx5e_priv *priv =3D netdev_priv(netdev);
 	struct mlx5_core_dev *mdev =3D priv->mdev;
 	struct mlx5e_channels new_channels =3D {};
-	struct mlx5e_params *old_params;
+	struct mlx5e_params *cur_params;
 	int err =3D 0;
 	bool reset;
=20
@@ -3777,8 +3777,8 @@ static int set_feature_lro(struct net_device *netdev,=
 bool enable)
 		goto out;
 	}
=20
-	old_params =3D &priv->channels.params;
-	if (enable && !MLX5E_GET_PFLAG(old_params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
+	cur_params =3D &priv->channels.params;
+	if (enable && !MLX5E_GET_PFLAG(cur_params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
 		netdev_warn(netdev, "can't set LRO with legacy RQ\n");
 		err =3D -EINVAL;
 		goto out;
@@ -3786,18 +3786,23 @@ static int set_feature_lro(struct net_device *netde=
v, bool enable)
=20
 	reset =3D test_bit(MLX5E_STATE_OPENED, &priv->state);
=20
-	new_channels.params =3D *old_params;
+	new_channels.params =3D *cur_params;
 	new_channels.params.lro_en =3D enable;
=20
-	if (old_params->rq_wq_type !=3D MLX5_WQ_TYPE_CYCLIC) {
-		if (mlx5e_rx_mpwqe_is_linear_skb(mdev, old_params, NULL) =3D=3D
+	if (cur_params->rq_wq_type !=3D MLX5_WQ_TYPE_CYCLIC) {
+		if (mlx5e_rx_mpwqe_is_linear_skb(mdev, cur_params, NULL) =3D=3D
 		    mlx5e_rx_mpwqe_is_linear_skb(mdev, &new_channels.params, NULL))
 			reset =3D false;
 	}
=20
 	if (!reset) {
-		*old_params =3D new_channels.params;
+		struct mlx5e_params old_params;
+
+		old_params =3D *cur_params;
+		*cur_params =3D new_channels.params;
 		err =3D mlx5e_modify_tirs_lro(priv);
+		if (err)
+			*cur_params =3D old_params;
 		goto out;
 	}
=20
@@ -4074,9 +4079,16 @@ int mlx5e_change_mtu(struct net_device *netdev, int =
new_mtu,
 	}
=20
 	if (!reset) {
+		unsigned int old_mtu =3D params->sw_mtu;
+
 		params->sw_mtu =3D new_mtu;
-		if (preactivate)
-			preactivate(priv, NULL);
+		if (preactivate) {
+			err =3D preactivate(priv, NULL);
+			if (err) {
+				params->sw_mtu =3D old_mtu;
+				goto out;
+			}
+		}
 		netdev->mtu =3D params->sw_mtu;
 		goto out;
 	}
--=20
2.29.2

