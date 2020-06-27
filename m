Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDBE20C43F
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgF0VSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:18:51 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbgF0VSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:18:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fo3v8kBB0BnGl3i8gjg9ajhBfbh90uJu6ffVZa2YlWYlUF693tG1JIwXr4LaGMhWgrWVoYmwEDCxJYu6A8NpxhUbOfSOGq7/nmsK1/JKq/YBngOqILhMAGO/wm9B86CWD2GOVYF0R6rAQxqx9vb8OCuN6yUMZ5Vnn5R/jrYYH8cIV/IkhBpPR5cqjPAZ2DYUheTMlYP2rTnENDRUTTpmQ2F8ZvYDeg4oIPjf9RJe6TbtHDRuz72EuZPdLFx9waVALjOh4MztoaY7uI0aJg7ArmcEcVYE9yvNWIEj+0jFEP2BxzXpwf2zuKHLfR1I8LdMFF/aLSTtxtQx2kUcZsQbRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcTKo9GB/DW4Frmyq26xfVP4s5H3QDZUecc8m679fYk=;
 b=LnKFj05jSK80llnTmloGChOnHOAoeVcUyeKcT+GHy388akjtygvz4sT0WXpWjIU0qUw3rJ1Pqo1j08CjgcEgGPVMsFtovIAjO4C6AU0dNnxJUq6ZpI+asTfF5oJ4hxwxRVE4CO1c6FZxUNp0g0rqTDqEYFh7BGO1bEsQxbmqQhkoCvcdc7Yh/ORfnkHi8ZrXej7O38N196QkcVBXkdI+Eaxi9Hkct3BrPYbjHIa0ZeY1S4EUo7kP9/NaK97Oom1ZDQK6HLNhl2qzsKgDmz8b5w3tVcG28OKWY0opyisLx++g80v0W0tB1TPyGkwqFVeN9QZGo3J1Efgv8uS/LJXung==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcTKo9GB/DW4Frmyq26xfVP4s5H3QDZUecc8m679fYk=;
 b=UNM+fr7CbTRQnOpsd4cCN4rG+zLiLKVGd+ElAL6FEjNhKef33E7v8ZfVJh9n2pPPN/Q86jkJaaQztugf1gqoQ8qolYC+lulpmC2e6DYZjKZCwT08Dux3/2nI0oHlKol3Jy1/bg2VyWajTv68xL4iPqRPV56k0kgx2tau5vdT1fU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:18:39 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:18:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/15] net/mlx5e: Refactor build channel params
Date:   Sat, 27 Jun 2020 14:17:14 -0700
Message-Id: <20200627211727.259569-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:18:37 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 927642dc-6938-42e9-dd1a-08d81adfa957
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5134AE66A4F5335BE4D30B85BE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kAVfQF0CCILXpJrAqoKok8f1agjQ0a3nINjY+6o7DOh70K3+wJqzYWudiPnBDtIC0niXkZmx3pIl3xJn+TPs04JcM8uh6q3USOuOw7/InNOtTTH7o4ePmYIhSylBkKx3r2WtZbhqJtn7IZDHOttQf+wCBbmE080bM8/gGycI04udoIDBGxVRj+RLAw5WASOU3kzEmC7c7P1UDbjfUofEFRG8AJ6f/kt24W/ikcGpRehZCt8gRmRvt2xd3DQauIE1m1NudkgB6CzsVOL4/18tZDPGohdQUMU2Z9x+dVNjMAHOI6bOevkd5e50rgG5ioC5w7Pu7SBmMLvxJ8VBXxGZZs2UVkSc4+In/RORDy0l+f03JrIx8N57YcNPm8YC5XKQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5U5VBsi/ryGxA/Z5w4IeVvRTsGZvwB1qAVCkKkevwXleKRcp9yN6wNXPn0qHstuc3Kq4hOzHiq7ZY3pv5132Vmq8J5i471Go6yucOLWq+ODrzPYTjy5/8YyPOMkYOY4tnj6SrWhO/auUoMfkOohA1WPGAItUjNPM6ktZENmw70W/8cNOHgPBderqEnWMAWERDxIIRdOlWjjizqzb7khkWIPn6zEEtG9eiOghFd6bxkLyyaolhCtR12mkoT5hLFsC8d4RsUvJDcc6tI73iyMTwPGVU6eK1VpLDJBmJ4mjPATaa0yyvpNQzCoaITSPlF1l74xzD2dXCeuWQseawYj8yOXfpQhZ+DgNns/PGumqy8R+hks+CtU3vtATccEhtMvE+pWIdfZgwmPettH5OynYO3uspjU9CQ4PNQ/VzxYMQj0gdOnWcKj96MRtD5SujmBsV1cM8UMSVCXEbiPlUMZpqfPIzjIcD/5dz/twzWQy62w=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 927642dc-6938-42e9-dd1a-08d81adfa957
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:18:39.6031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+oOOwpjBJykLOgjuV2b17OIgjMxMkW9w3wDsED8Lz5wH4aa9pV9k9VyKEG7SFuzydfX0c3osTQQwXRt2321Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Take the CQ params into their respective RQ/SQ params.
Split the params build of the different ICOSQs (sync and async),
as they require different init values.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.h   | 22 +++++++-------
 .../mellanox/mlx5/core/en/xsk/setup.c         |  6 ++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 30 ++++++++++---------
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 989d8f429438..a87273e801b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -11,33 +11,33 @@ struct mlx5e_xsk_param {
 	u16 chunk_size;
 };
 
+struct mlx5e_cq_param {
+	u32                        cqc[MLX5_ST_SZ_DW(cqc)];
+	struct mlx5_wq_param       wq;
+	u16                        eq_ix;
+	u8                         cq_period_mode;
+};
+
 struct mlx5e_rq_param {
+	struct mlx5e_cq_param      cqp;
 	u32                        rqc[MLX5_ST_SZ_DW(rqc)];
 	struct mlx5_wq_param       wq;
 	struct mlx5e_rq_frags_info frags_info;
 };
 
 struct mlx5e_sq_param {
+	struct mlx5e_cq_param      cqp;
 	u32                        sqc[MLX5_ST_SZ_DW(sqc)];
 	struct mlx5_wq_param       wq;
 	bool                       is_mpw;
 };
 
-struct mlx5e_cq_param {
-	u32                        cqc[MLX5_ST_SZ_DW(cqc)];
-	struct mlx5_wq_param       wq;
-	u16                        eq_ix;
-	u8                         cq_period_mode;
-};
-
 struct mlx5e_channel_param {
 	struct mlx5e_rq_param      rq;
-	struct mlx5e_sq_param      sq;
+	struct mlx5e_sq_param      txq_sq;
 	struct mlx5e_sq_param      xdp_sq;
 	struct mlx5e_sq_param      icosq;
-	struct mlx5e_cq_param      rx_cq;
-	struct mlx5e_cq_param      tx_cq;
-	struct mlx5e_cq_param      icosq_cq;
+	struct mlx5e_sq_param      async_icosq;
 };
 
 static inline bool mlx5e_qid_get_ch_if_in_group(struct mlx5e_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 1eb817e62830..cc46414773b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -41,8 +41,6 @@ static void mlx5e_build_xsk_cparam(struct mlx5e_priv *priv,
 {
 	mlx5e_build_rq_param(priv, params, xsk, &cparam->rq);
 	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
-	mlx5e_build_rx_cq_param(priv, params, xsk, &cparam->rx_cq);
-	mlx5e_build_tx_cq_param(priv, params, &cparam->tx_cq);
 }
 
 int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
@@ -61,7 +59,7 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 
 	mlx5e_build_xsk_cparam(priv, params, xsk, cparam);
 
-	err = mlx5e_open_cq(c, params->rx_cq_moderation, &cparam->rx_cq, &c->xskrq.cq);
+	err = mlx5e_open_cq(c, params->rx_cq_moderation, &cparam->rq.cqp, &c->xskrq.cq);
 	if (unlikely(err))
 		goto err_free_cparam;
 
@@ -69,7 +67,7 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	if (unlikely(err))
 		goto err_close_rx_cq;
 
-	err = mlx5e_open_cq(c, params->tx_cq_moderation, &cparam->tx_cq, &c->xsksq.cq);
+	err = mlx5e_open_cq(c, params->tx_cq_moderation, &cparam->xdp_sq.cqp, &c->xsksq.cq);
 	if (unlikely(err))
 		goto err_close_rq;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 72ce5808d583..11997c23dfb5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1675,7 +1675,7 @@ static int mlx5e_open_tx_cqs(struct mlx5e_channel *c,
 
 	for (tc = 0; tc < c->num_tc; tc++) {
 		err = mlx5e_open_cq(c, params->tx_cq_moderation,
-				    &cparam->tx_cq, &c->sq[tc].cq);
+				    &cparam->txq_sq.cqp, &c->sq[tc].cq);
 		if (err)
 			goto err_close_tx_cqs;
 	}
@@ -1707,7 +1707,7 @@ static int mlx5e_open_sqs(struct mlx5e_channel *c,
 		int txq_ix = c->ix + tc * params->num_channels;
 
 		err = mlx5e_open_txqsq(c, c->priv->tisn[c->lag_port][tc], txq_ix,
-				       params, &cparam->sq, &c->sq[tc], tc);
+				       params, &cparam->txq_sq, &c->sq[tc], tc);
 		if (err)
 			goto err_close_sqs;
 	}
@@ -1817,11 +1817,11 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 	struct dim_cq_moder icocq_moder = {0, 0};
 	int err;
 
-	err = mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->async_icosq.cq);
+	err = mlx5e_open_cq(c, icocq_moder, &cparam->icosq.cqp, &c->async_icosq.cq);
 	if (err)
 		return err;
 
-	err = mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->icosq.cq);
+	err = mlx5e_open_cq(c, icocq_moder, &cparam->async_icosq.cqp, &c->icosq.cq);
 	if (err)
 		goto err_close_async_icosq_cq;
 
@@ -1829,17 +1829,16 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 	if (err)
 		goto err_close_icosq_cq;
 
-	err = mlx5e_open_cq(c, params->tx_cq_moderation, &cparam->tx_cq, &c->xdpsq.cq);
+	err = mlx5e_open_cq(c, params->tx_cq_moderation, &cparam->xdp_sq.cqp, &c->xdpsq.cq);
 	if (err)
 		goto err_close_tx_cqs;
 
-	err = mlx5e_open_cq(c, params->rx_cq_moderation, &cparam->rx_cq, &c->rq.cq);
+	err = mlx5e_open_cq(c, params->rx_cq_moderation, &cparam->rq.cqp, &c->rq.cq);
 	if (err)
 		goto err_close_xdp_tx_cqs;
 
-	/* XDP SQ CQ params are same as normal TXQ sq CQ params */
 	err = c->xdp ? mlx5e_open_cq(c, params->tx_cq_moderation,
-				     &cparam->tx_cq, &c->rq_xdpsq.cq) : 0;
+				     &cparam->xdp_sq.cqp, &c->rq_xdpsq.cq) : 0;
 	if (err)
 		goto err_close_rx_cq;
 
@@ -1847,7 +1846,7 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 
 	spin_lock_init(&c->async_icosq_lock);
 
-	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->async_icosq);
+	err = mlx5e_open_icosq(c, params, &cparam->async_icosq, &c->async_icosq);
 	if (err)
 		goto err_disable_napi;
 
@@ -2158,6 +2157,7 @@ void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 	MLX5_SET(rqc, rqc, scatter_fcs,    params->scatter_fcs_en);
 
 	param->wq.buf_numa_node = dev_to_node(mdev->device);
+	mlx5e_build_rx_cq_param(priv, params, xsk, &param->cqp);
 }
 
 static void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
@@ -2200,6 +2200,7 @@ static void mlx5e_build_sq_param(struct mlx5e_priv *priv,
 	mlx5e_build_sq_param_common(priv, param);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
+	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
 }
 
 static void mlx5e_build_common_cq_param(struct mlx5e_priv *priv,
@@ -2276,6 +2277,7 @@ void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
 
 	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
 	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(priv->mdev, reg_umr_sq));
+	mlx5e_build_ico_cq_param(priv, log_wq_size, &param->cqp);
 }
 
 void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
@@ -2288,6 +2290,7 @@ void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
 	mlx5e_build_sq_param_common(priv, param);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_XDP_TX_MPWQE);
+	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
 }
 
 static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5e_params *params,
@@ -2306,18 +2309,17 @@ static void mlx5e_build_channel_param(struct mlx5e_priv *priv,
 				      struct mlx5e_params *params,
 				      struct mlx5e_channel_param *cparam)
 {
-	u8 icosq_log_wq_sz;
+	u8 icosq_log_wq_sz, async_icosq_log_wq_sz;
 
 	mlx5e_build_rq_param(priv, params, NULL, &cparam->rq);
 
 	icosq_log_wq_sz = mlx5e_build_icosq_log_wq_sz(params, &cparam->rq);
+	async_icosq_log_wq_sz = MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
 
-	mlx5e_build_sq_param(priv, params, &cparam->sq);
+	mlx5e_build_sq_param(priv, params, &cparam->txq_sq);
 	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
 	mlx5e_build_icosq_param(priv, icosq_log_wq_sz, &cparam->icosq);
-	mlx5e_build_rx_cq_param(priv, params, NULL, &cparam->rx_cq);
-	mlx5e_build_tx_cq_param(priv, params, &cparam->tx_cq);
-	mlx5e_build_ico_cq_param(priv, icosq_log_wq_sz, &cparam->icosq_cq);
+	mlx5e_build_icosq_param(priv, async_icosq_log_wq_sz, &cparam->async_icosq);
 }
 
 int mlx5e_open_channels(struct mlx5e_priv *priv,
-- 
2.26.2

