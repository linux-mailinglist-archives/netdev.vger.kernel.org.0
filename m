Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE751DF39F
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgEWAoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:44:09 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:1415
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387489AbgEWAoJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:44:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLx7WMT86W0+UaEYcQUr0QYRxVIloeigu9a8yjaXt2ncMx0//qp+BNEkZWTV6LILuo6yxicyVo6CMbLTLzzqonXkIc/Yj6aksMm23MPlxzjz1NTfnVhj0siZJJ9he8owlfndHgj6qT0TkCQ2SyoLWUT3BbeKWuB/pzg4oufdx8tiabnWM3dqj7hG/+LlK49ePpVsUHGXpzLaP8wEOL/agO43gTN8OpjOqd1Z9rhRc4IMiskJfPAwzytO25w2yP3sChyzOJD9AxW5DALIrB5H8oqKAiqFtZcH6dFzODX6Tvld5pKZkqQoMD68SSHOIwy7PUAZeZiYElNfulCAWhdgKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oz6IXNQVTcqzXnhTpzSD99Yd2zaIQVtHPxCmJQPedxg=;
 b=Kql+qiK2Qk77tVgSE4+t6YRjkCZV4zpNEz0j9krA3niMTaKQCBZDoyiBvZhM4wLi9v/3rLH7w/f9vus970KaEjeA+n6w27r5J/VXLKRqYdh1XBkeCeTJMM4ja8k3FmqjI7TuoNCBFN503IwzLmiKaKhJAfMkYM3At5Gl9Vm4QQWl+E+x61PwLPxKCbAeiXPw/qfcu0HseSuyNaGAfnDaZq+qZu8qD+h5eHI+lN7pRu75x86xpj3WF4I61PMzmH1V3jNwqSRZ0diAmQHR1va78qqU6e5QCloZLYirh+E3RLaW3lhQX/HhI580pH140paJXwQcA4I7BafTbDmeTPMnFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oz6IXNQVTcqzXnhTpzSD99Yd2zaIQVtHPxCmJQPedxg=;
 b=UZ3YX9WYD8Bgegx04+OCe8yrI/AVibgzbazkNDG8Whk6kMVvm0FFkOv0GeTXWdt3qqTrrPYrRgokgjUMlym6oZRFXjkFERJsI+aFTbmB+YJkcHLRhJF5jQyE5KrCdodUZRxUffped4DMehO66knDm4eiJzvp/vjFC19jgpFLkCQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 06/13] net/mlx5e: Fix inner tirs handling
Date:   Fri, 22 May 2020 17:40:42 -0700
Message-Id: <20200523004049.34832-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200523004049.34832-1-saeedm@mellanox.com>
References: <20200523004049.34832-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:18 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d57b2083-1d81-42b4-15c1-08d7feb202a3
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5391590B04FCD6DEA5D09277BEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:172;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4uIrpLxjZMu4ZvcewA3ERl27XbBHeczoO9dg9OuUN/94J45w03+Tj/EojgpAlY2iamkzP4jg4cpArnW5pBrGsGlXGiQyIx7QcDKT3pLhWLAWNmpk2324sTU1V33I7+Jeb6U3IH6tp2VhCUtWNczJAFY6ib9XYeirvgWziQe01bSb3wHPa2nj/QYpSeYxQKcuK0snBeYJBZ/a6YELG9137YFwn/XR4g5gXk4L8m5PqzvVG2yerdjxHar2svR5zxUAjrTS3XWSdNfECLufsRcYI0+maOrmHgcKbfNrg4AsRK9rMWiQHuu0yqVDD9ezGFgGqJ0b7Zr4U9i8a0A+CiQvFDZoJS2Ygdp9YnIcz19ng0S7slb6g2McD4AQ2L/ahMnT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ttc2FubxIP/fWwtK0ZVzkeUvM8Kp+k6XkkhmhFU0ccisaGvm0t2Rvwvzhrboyaqg/eUsU3iledP/f9cSBZIaoutKh5Y41X9SzDkQuEV5IdTXAmnzuIXgvxCbSS5NVOhcZzTE8pGFO1Fws8yFcschzZz8ETL9SwXf/tr3DiXcFzaVm+kiq+lGpp0Tg14K1crLQcRd//HNldJK8+l/5aEtvOeF8zKmiGAqkxGSoFTyloEXJZEiRVeoKE2q/OCTeaf1YbniGQr3FzgtR56v39NkojdhTRhBRA6vkgNptbSs9hUuDVKBmf/zWVrl34MiWyWA5ek7XIv/56FgeekJB/XhKGr6eyshoO+ojystyq51raycao0d3Df6W4BvUCgx7VzsC5nPqjKMdcg79cdF8OFYhsHElFY0/5dPOy07c46ZOkyQaNM2FemHh6PwV2OysA47EHRZpV2EpKyihLqH16uao6eMqCKskTY0FFizJsb7cAg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d57b2083-1d81-42b4-15c1-08d7feb202a3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:20.1098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/9CqqNNZeRSoL3wuJDw8AjbHqpw65pI/GH5qePq+Qqle4tLbQC1l6G8fP7C2Jp96gykyfuESPrhichfO5QWHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

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
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 12 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c    |  4 ++--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 23701c0e36ec..59745402747b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1121,7 +1121,7 @@ void mlx5e_close_drop_rq(struct mlx5e_rq *drop_rq);
 int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv);
 
 int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc);
-void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc);
+void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv);
 
 int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
 void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b314adf438da..c6b83042d431 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2717,7 +2717,8 @@ void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in, int inlen)
 		mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in, inlen);
 	}
 
-	if (!mlx5e_tunnel_inner_ft_supported(priv->mdev))
+	/* Verify inner tirs resources allocated */
+	if (!priv->inner_indir_tir[0].tirn)
 		return;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
@@ -3408,14 +3409,15 @@ int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
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
@@ -5123,7 +5125,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 err_destroy_direct_tirs:
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 err_destroy_indirect_tirs:
-	mlx5e_destroy_indirect_tirs(priv, true);
+	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 err_destroy_indirect_rqts:
@@ -5142,7 +5144,7 @@ static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir);
 	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir);
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
-	mlx5e_destroy_indirect_tirs(priv, true);
+	mlx5e_destroy_indirect_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index cdecf4280e86..4a8e0dfdc5f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1743,7 +1743,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 err_destroy_direct_tirs:
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 err_destroy_indirect_tirs:
-	mlx5e_destroy_indirect_tirs(priv, false);
+	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 err_destroy_indirect_rqts:
@@ -1761,7 +1761,7 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 	mlx5e_destroy_rep_root_ft(priv);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
-	mlx5e_destroy_indirect_tirs(priv, false);
+	mlx5e_destroy_indirect_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 673aaa815f57..505cf6eeae25 100644
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
2.25.4

