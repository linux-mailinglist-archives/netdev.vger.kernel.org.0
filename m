Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E5C11487C
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbfLEVMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:12:17 -0500
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:34533
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729875AbfLEVMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 16:12:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Esh9Z16tDxcMzsUpDMeeazEpN/Zt8DHPbHYfCOX2C6nDBYSbjQoiO88TSh6Xkh51+wtgG8fM5+ESoC7gO/QRacM4PzA+PAPnyNafXy+gcgI8qcCY4D8Sapwu0sqc7HaFvUJudHVOLpOpocFcJNb2Jf7n7NUjnZRA+Ml9HfjujqZpWyNc6OpfEHjYETmFjZz3ju5byFSlMx5/ktH75TEo2960M/Lz47ZKcfttH9xMTmdnJl9Ny8Vp5RGIHzixzm+HC9OnWmd7lUcZjmYOlNGCC9doYmkVDKcg4CmuP1ytW9Xg20Z7Ff9o7bfLor2HxGJQFzCwEuYLp2gFUXiZ1aVH/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdCCNXTntQo0owAeKU13wm2k6WysicQ0t16PNyVRZdQ=;
 b=nmaEBqlWgYTGXo57zXCGfpd3GomK1fqAZVNo1yNv4grBsDXAfYUmqQYKX5YCVWhcV+9KEXglYFpIOz8YLvlmdjVbv6KPXyFIPHzsQd1R2m7HsXzpOKs49Q4nbfg//vSC4719qJ/jgw0vfj7648KmvGfvJrIy4UF9nGOf9QQf59XJWraFrAhzueXSwqOIlt7iQrLZh8mXCzatONm6aURWMzrwdqKkwLL71m6+de7yb+gQxSWafJKJNHX/Jk8OF23u1QTm5MbvYbPIvOovbKONd7hFZwtglQlt/V9KT9MrHbz2CiduWdbcozSlkYgcSMBHYltLzzqoOL6v381d3h6amg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdCCNXTntQo0owAeKU13wm2k6WysicQ0t16PNyVRZdQ=;
 b=OpSSSJ5A/BoDHwtUadfjYvY4XvgG++pcaqQilwDDXlVXRtXg6iVH19yF5cJzV1jM1ncj3lqkUfjlUAScKHwRydh81MLBAFdwd7iH1yhgdfxbWS5vAzPk3tt6mnpakIYjqGvQgEKdeojJpesUI/7fBZ3M6OnK96MfWsKTb+Pv4NQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3326.eurprd05.prod.outlook.com (10.175.244.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 21:12:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2495.014; Thu, 5 Dec 2019
 21:12:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/8] net/mlx5e: Fix TXQ indices to be sequential
Thread-Topic: [net 1/8] net/mlx5e: Fix TXQ indices to be sequential
Thread-Index: AQHVq7ClXnV5ztWRxUS8FkA9alfxJQ==
Date:   Thu, 5 Dec 2019 21:12:06 +0000
Message-ID: <20191205211052.14584-2-saeedm@mellanox.com>
References: <20191205211052.14584-1-saeedm@mellanox.com>
In-Reply-To: <20191205211052.14584-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f127924d-c981-4632-afc2-08d779c7c839
x-ms-traffictypediagnostic: VI1PR05MB3326:|VI1PR05MB3326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB332685B6679AF3FE80E0C1B9BE5C0@VI1PR05MB3326.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(107886003)(478600001)(25786009)(102836004)(6512007)(86362001)(6486002)(14454004)(6506007)(54906003)(2616005)(316002)(64756008)(11346002)(26005)(186003)(5660300002)(14444005)(76176011)(8676002)(4326008)(50226002)(305945005)(99286004)(66446008)(81166006)(52116002)(81156014)(1076003)(71190400001)(71200400001)(6916009)(8936002)(2906002)(66476007)(66946007)(66556008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3326;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8GzUgAbJvfWPs1xDylrhuS0+n04X/+L4/4C8rcwHxNwbVG8Z7YhCncnJPNkXl8WSuiOnVOs94a80t7WjgCpgKaVZBMh2ZhG5Hcv58GNmDQgRZr2NAMmMwYeK3Qf/dA5pAIzWH7c1IxZ1ZBc92f70U30+J92/VrUwMCBudtkFwAmf0vMSsr7Mg3QtHESsASrZcCqgBx5hALi9Mx1ledYta9VQGv0FOEsGRUR0Nzs+caG+S8XV9BgThEiDBlORdMgSyea24JvNoE2w5ZiAx2P0ahy1SDer6mCKTvx2duT3dj8G40WTIYhNmUrB2nQ55BFiR2mmaGkacSRKJsMokbR4wdKYENOvHk8feX0uvx9DlMm4rrqVmJRJYgA3SrOet3Mdiv49qhRkTZ5QhASit+YuT8d9Pghd1/GqgMuWAWcSxK/Ipb22P4cseD04v9JnxLkb
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f127924d-c981-4632-afc2-08d779c7c839
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 21:12:06.3489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oGwAAZEpEdxTqzciQAa0tKTV2/aQZt/0eoyishQRs6hHOGDhixLmuKQC8VBfd6IH4md1xK1Vwkzjg6fliC6yYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Cited patch changed (channel index, tc) =3D> (TXQ index) mapping to be a
static one, in order to keep indices consistent when changing number of
channels or TCs.

For 32 channels (OOB) and 8 TCs, real num of TXQs is 256.
When reducing the amount of channels to 8, the real num of TXQs will be
changed to 64.
This indices method is buggy:
- Channel #0, TC 3, the TXQ index is 96.
- Index 8 is not valid, as there is no such TXQ from driver perspective
  (As it represents channel #8, TC 0, which is not valid with the above
  configuration).

As part of driver's select queue, it calls netdev_pick_tx which returns an
index in the range of real number of TXQs. Depends on the return value,
with the examples above, driver could have returned index larger than the
real number of tx queues, or crash the kernel as it tries to read invalid
address of SQ which was not allocated.

Fix that by allocating sequential TXQ indices, and hold a new mapping
between (channel index, tc) =3D> (real TXQ index). This mapping will be
updated as part of priv channels activation, and is used in
mlx5e_select_queue to find the selected queue index.

The existing indices mapping (channel_tc2txq) is no longer needed, as it
is used only for statistics structures and can be calculated on run time.
Delete its definintion and updates.

Fixes: 8bfaf07f7806 ("net/mlx5e: Present SW stats when state is not opened"=
)
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 31 +++++++------------
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
 4 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index f1a7bc46f1c0..2c16add0b642 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -816,7 +816,7 @@ struct mlx5e_xsk {
 struct mlx5e_priv {
 	/* priv data path fields - start */
 	struct mlx5e_txqsq *txq2sq[MLX5E_MAX_NUM_CHANNELS * MLX5E_MAX_NUM_TC];
-	int channel_tc2txq[MLX5E_MAX_NUM_CHANNELS][MLX5E_MAX_NUM_TC];
+	int channel_tc2realtxq[MLX5E_MAX_NUM_CHANNELS][MLX5E_MAX_NUM_TC];
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	struct mlx5e_dcbx_dp       dcbx_dp;
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 09ed7f5f688b..4980e80a5e85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1691,11 +1691,10 @@ static int mlx5e_open_sqs(struct mlx5e_channel *c,
 			  struct mlx5e_params *params,
 			  struct mlx5e_channel_param *cparam)
 {
-	struct mlx5e_priv *priv =3D c->priv;
 	int err, tc;
=20
 	for (tc =3D 0; tc < params->num_tc; tc++) {
-		int txq_ix =3D c->ix + tc * priv->max_nch;
+		int txq_ix =3D c->ix + tc * params->num_channels;
=20
 		err =3D mlx5e_open_txqsq(c, c->priv->tisn[c->lag_port][tc], txq_ix,
 				       params, &cparam->sq, &c->sq[tc], tc);
@@ -2876,26 +2875,21 @@ static void mlx5e_netdev_set_tcs(struct net_device =
*netdev)
 		netdev_set_tc_queue(netdev, tc, nch, 0);
 }
=20
-static void mlx5e_build_tc2txq_maps(struct mlx5e_priv *priv)
+static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 {
-	int i, tc;
+	int i, ch;
=20
-	for (i =3D 0; i < priv->max_nch; i++)
-		for (tc =3D 0; tc < priv->profile->max_tc; tc++)
-			priv->channel_tc2txq[i][tc] =3D i + tc * priv->max_nch;
-}
+	ch =3D priv->channels.num;
=20
-static void mlx5e_build_tx2sq_maps(struct mlx5e_priv *priv)
-{
-	struct mlx5e_channel *c;
-	struct mlx5e_txqsq *sq;
-	int i, tc;
+	for (i =3D 0; i < ch; i++) {
+		int tc;
+
+		for (tc =3D 0; tc < priv->channels.params.num_tc; tc++) {
+			struct mlx5e_channel *c =3D priv->channels.c[i];
+			struct mlx5e_txqsq *sq =3D &c->sq[tc];
=20
-	for (i =3D 0; i < priv->channels.num; i++) {
-		c =3D priv->channels.c[i];
-		for (tc =3D 0; tc < c->num_tc; tc++) {
-			sq =3D &c->sq[tc];
 			priv->txq2sq[sq->txq_ix] =3D sq;
+			priv->channel_tc2realtxq[i][tc] =3D i + tc * ch;
 		}
 	}
 }
@@ -2910,7 +2904,7 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *=
priv)
 	netif_set_real_num_tx_queues(netdev, num_txqs);
 	netif_set_real_num_rx_queues(netdev, num_rxqs);
=20
-	mlx5e_build_tx2sq_maps(priv);
+	mlx5e_build_txq_maps(priv);
 	mlx5e_activate_channels(&priv->channels);
 	mlx5e_xdp_tx_enable(priv);
 	netif_tx_start_all_queues(priv->netdev);
@@ -5021,7 +5015,6 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 	mlx5e_build_nic_netdev(netdev);
-	mlx5e_build_tc2txq_maps(priv);
 	mlx5e_health_create_reporters(priv);
=20
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 7e6ebd0505cc..9f09253f9f46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1601,7 +1601,7 @@ static int mlx5e_grp_channels_fill_strings(struct mlx=
5e_priv *priv, u8 *data,
 			for (j =3D 0; j < NUM_SQ_STATS; j++)
 				sprintf(data + (idx++) * ETH_GSTRING_LEN,
 					sq_stats_desc[j].format,
-					priv->channel_tc2txq[i][tc]);
+					i + tc * max_nch);
=20
 	for (i =3D 0; i < max_nch; i++) {
 		for (j =3D 0; j < NUM_XSKSQ_STATS * is_xsk; j++)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 66951ff975f4..2565ba8692d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -93,7 +93,7 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_=
buff *skb,
 	if (txq_ix >=3D num_channels)
 		txq_ix =3D priv->txq2sq[txq_ix]->ch_ix;
=20
-	return priv->channel_tc2txq[txq_ix][up];
+	return priv->channel_tc2realtxq[txq_ix][up];
 }
=20
 static inline int mlx5e_skb_l2_header_offset(struct sk_buff *skb)
--=20
2.21.0

