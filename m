Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666D42CCDE6
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgLCEWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:22:51 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17032 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbgLCEWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:22:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc867d40000>; Wed, 02 Dec 2020 20:21:40 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:21:32 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next V2 15/15] net/mlx5e: Fill mlx5e_create_cq_param in a function
Date:   Wed, 2 Dec 2020 20:21:08 -0800
Message-ID: <20201203042108.232706-16-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201203042108.232706-1-saeedm@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606969300; bh=Whn4lDkPyispat484yBSmN/X2sDSf2l1kOPBRDEDnO8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=ZQg2XskKR6uzoYwyJ/d33GZPUUSZeg1GUeVosoIF89+meD8LyxUXdVTa3ZRWStGRN
         inz1cIRxzEHv8V/ymVbaIDCP20P7pfukVJghsUcV/3hWuAT9pbXJT8wFQIuSXn8051
         Q1dUXrMwfZGpQ2D5ZKy+5tPHw2O6eqPcS3hnExagLc2CYFOETPWeQmRDL7wqqppwf+
         e8vDhbKtVlXe//j+7GVqjOkHwLjt4dbdQhFjVbKcTX1zFs1QlJp6x/6Yu2nL+u2IGt
         9Xq8+e/4eF1a3xbG/1on+RecKUQBvRwmFBXFs7XwAEyh0fgTani5h1xzTSV9WLNsX+
         p1Ot3MhzGyAHw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Create a function to fill the fields of struct mlx5e_create_cq_param
based on a channel. The purpose is code reuse between normal CQs, XSK
CQs and the upcoming QoS CQs.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/params.h |  1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/setup.c  |  7 ++-----
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 17 ++++++++++++-----
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/params.h
index 3959254d4181..807147d97a0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -111,6 +111,7 @@ u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
=20
 /* Build queue parameters */
=20
+void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct=
 mlx5e_channel *c);
 void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 7703e6553da6..d87c345878d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -48,14 +48,11 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5=
e_params *params,
 		   struct mlx5e_xsk_param *xsk, struct xsk_buff_pool *pool,
 		   struct mlx5e_channel *c)
 {
-	struct mlx5e_create_cq_param ccp =3D {};
 	struct mlx5e_channel_param *cparam;
+	struct mlx5e_create_cq_param ccp;
 	int err;
=20
-	ccp.napi =3D &c->napi;
-	ccp.ch_stats =3D c->stats;
-	ccp.node =3D cpu_to_node(c->cpu);
-	ccp.ix =3D c->ix;
+	mlx5e_build_create_cq_param(&ccp, c);
=20
 	if (!mlx5e_validate_xsk_param(params, xsk, priv->mdev))
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 26be6eb44fed..e573a82ce037 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1806,18 +1806,25 @@ static int mlx5e_set_tx_maxrate(struct net_device *=
dev, int index, u32 rate)
 	return err;
 }
=20
+void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct=
 mlx5e_channel *c)
+{
+	*ccp =3D (struct mlx5e_create_cq_param) {
+		.napi =3D &c->napi,
+		.ch_stats =3D c->stats,
+		.node =3D cpu_to_node(c->cpu),
+		.ix =3D c->ix,
+	};
+}
+
 static int mlx5e_open_queues(struct mlx5e_channel *c,
 			     struct mlx5e_params *params,
 			     struct mlx5e_channel_param *cparam)
 {
 	struct dim_cq_moder icocq_moder =3D {0, 0};
-	struct mlx5e_create_cq_param ccp =3D {};
+	struct mlx5e_create_cq_param ccp;
 	int err;
=20
-	ccp.napi =3D &c->napi;
-	ccp.ch_stats =3D c->stats;
-	ccp.node =3D cpu_to_node(c->cpu);
-	ccp.ix =3D c->ix;
+	mlx5e_build_create_cq_param(&ccp, c);
=20
 	err =3D mlx5e_open_cq(c->priv, icocq_moder, &cparam->icosq.cqp, &ccp,
 			    &c->async_icosq.cq);
--=20
2.26.2

