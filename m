Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5F5A0A1B
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfH1S6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:58:07 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:52486
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726836AbfH1S6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 14:58:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THa1tCJc+fhilOLK1PbzyXsisRnOHSCeTXZuk9sdRXL0t72W7prvOmt6ROrrhcPTplMj0Bc6riAknUZwb5eh/Vk44v5RVECOLgav+lu6j18ErxO4dZDhoY2IDaieALungTQobo+wBJhS7rXbrhp3IuhZBqTqifgmhNF0SLdWuUFh9OTL81hxfxtqxdf3jcy9VD07HdspImJmCbLrnm5JDlbKsMRkXUHTecWDLJ7s9JKXKugAsA03GU1bKRFpD+ImFyLzzL1J2O7pY/+kZZ7VrCZY3CafcVkanM0/AoHi3oBLTKPZz2whXn6DGYG3+5yFiuxLAVbO9RbkczaTcnvyJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATpDfRvHTB5Ze4q//4C/P/Z5Qjfg5ee/yoS3bPbM+Bg=;
 b=LNDcaiIMDf0/6OXWP0rDiFLRWX6OoiqknCEKgge1RKE9tiEMDrMlXEVruQkC/A1xr30o71/bIyTlhiiIyht0Yq+B46Mu1VnNgJoM+pBfCXv/lrD6HbRDnnd6xJJzyiy4NC4GuHDrtLqyG5B9NOtgjhWast2RctIKEKRTORxI9nVxDNm6rKd3YghqGUwJ+mJoyDvzn7tJzv4Bjd+cSI89gIvUbjFZIr8+J2iUNhJx37jePS27tvIyP0swMrmtMtE839h3uRlT74cgUQ/A9ZIUDwnunhg6dnS1L1Gq2cbUcH7wpcmLMzC6frpHL6/7QCxfru5gRrw1iLVWjnQTybXuUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATpDfRvHTB5Ze4q//4C/P/Z5Qjfg5ee/yoS3bPbM+Bg=;
 b=fmUzZmyQ1Gk3/xlHUc9jrPwwnrHOxHeRFGCsvU1Javgqk/C5kGBG+504fTEgOQzzWdCKuESz72KVwNRguqqtNc4aZ70Rp91OF7U+iEGHhHmHPtEg3SsooCtvP4AUX4c5/vHkDN2qLn6n5JkdC3Xk8fBskR+BOs+G2SMw1bMGyGY=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2638.eurprd05.prod.outlook.com (10.172.80.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 18:57:45 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 18:57:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 3/8] net/mlx5e: Support LAG TX port affinity
 distribution
Thread-Topic: [net-next v2 3/8] net/mlx5e: Support LAG TX port affinity
 distribution
Thread-Index: AQHVXdJ6+QSRUrWvkk6U+5RUwV0urA==
Date:   Wed, 28 Aug 2019 18:57:45 +0000
Message-ID: <20190828185720.2300-4-saeedm@mellanox.com>
References: <20190828185720.2300-1-saeedm@mellanox.com>
In-Reply-To: <20190828185720.2300-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0069.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::46) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24f06fa4-db3d-4447-0208-08d72be99cc3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2638;
x-ms-traffictypediagnostic: VI1PR0501MB2638:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2638722BAFD182420935E54EBEA30@VI1PR0501MB2638.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(8676002)(6512007)(107886003)(6486002)(54906003)(1076003)(25786009)(3846002)(316002)(186003)(8936002)(5660300002)(6116002)(53936002)(81156014)(6436002)(478600001)(86362001)(14454004)(2906002)(6916009)(4326008)(81166006)(36756003)(7736002)(50226002)(66446008)(305945005)(5024004)(256004)(66946007)(486006)(476003)(11346002)(2616005)(66066001)(446003)(66556008)(66476007)(71200400001)(52116002)(26005)(6506007)(386003)(102836004)(14444005)(71190400001)(76176011)(64756008)(99286004)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2638;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KyZs+5rcvoOQBYfARGRrWMzr980/6J44aQWbJPfoJFTADbZDsSzk+OCFPFY8wb7Uo2AcBqkHjFyKcyiPt5qh7FljYfSikper10XddHEpXhjXamVmmmVenqZk9ZvLTuC6DWeUBm3LT8/8bMi9w91glTSVR/nkNbV4moig5twAwDvggLXpQnKL1fe2mkXaYRwFQhIuS4BoGY224G7qfvEPI0o+puIm+oc6NkaWTC8MDO7XNPxlvuF9VRHHVekuuRRYiC2pY8Q/fY8Hzj0VPQYJvIIxLRyw8pX1/AeFLSkkefDUKGsSKWaDoNLIcqqk1ZKz3EfiAh+4mzLUVk/bjcGaCuJrk4ggzpX9XqPqT/MyDIKOtqG1A8rkf38ybuUv+3hU/BApB1ceonFQPkkp/1V6FPvjtT0yBfTpkkLPfRoPDyY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f06fa4-db3d-4447-0208-08d72be99cc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 18:57:45.5583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pe7xtY6r0EJNc3EXAHsamaMKtO8w52a1+t2tcCLv0AALYidGfPCwXmXK6yzdRe4i9snRNYPcjYUIebooA81XcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

When the VF LAG is in use, round-robin the TX affinity of channels among
the different ports, if supported by the firmware. Create a set of TISes
per port, while doing round-robin of the channels over the different
sets. Let all SQs of a channel share the same set of TISes.

If lag_tx_port_affinity HCA cap bit is supported, num_lag_ports > 1 and
we aren't the LACP owner (PF in the regular use), assign the affinities,
otherwise use tx_affinity =3D=3D 0 in TIS context to let the FW assign the
affinities itself. The TISes of the LACP owner are mapped only to the
native physical port.

For VFs, the starting port for round-robin is determined by its vhca_id,
because a VF may have only one channel if attached to a single-core VM.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 11 +++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 54 +++++++++++++------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  4 +-
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     |  6 +--
 4 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 491c281416d0..e03f973c962f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -163,6 +163,14 @@ enum mlx5e_rq_group {
 #define MLX5E_NUM_RQ_GROUPS(g) (1 + MLX5E_RQ_GROUP_##g)
 };
=20
+static inline u8 mlx5e_get_num_lag_ports(struct mlx5_core_dev *mdev)
+{
+	if (mlx5_lag_is_lacp_owner(mdev))
+		return 1;
+
+	return clamp_t(u8, MLX5_CAP_GEN(mdev, num_lag_ports), 1, MLX5_MAX_PORTS);
+}
+
 static inline u16 mlx5_min_rx_wqes(int wq_type, u32 wq_size)
 {
 	switch (wq_type) {
@@ -705,6 +713,7 @@ struct mlx5e_channel {
 	struct net_device         *netdev;
 	__be32                     mkey_be;
 	u8                         num_tc;
+	u8                         lag_port;
=20
 	/* XDP_REDIRECT */
 	struct mlx5e_xdpsq         xdpsq;
@@ -818,7 +827,7 @@ struct mlx5e_priv {
 	struct mlx5e_rq            drop_rq;
=20
 	struct mlx5e_channels      channels;
-	u32                        tisn[MLX5E_MAX_NUM_TC];
+	u32                        tisn[MLX5_MAX_PORTS][MLX5E_MAX_NUM_TC];
 	struct mlx5e_rqt           indir_rqt;
 	struct mlx5e_tir           indir_tir[MLX5E_NUM_INDIR_TIRS];
 	struct mlx5e_tir           inner_indir_tir[MLX5E_NUM_INDIR_TIRS];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 390e614ac46e..2786f5b8057d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1442,7 +1442,7 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct =
mlx5e_params *params,
 		return err;
=20
 	csp.tis_lst_sz      =3D 1;
-	csp.tisn            =3D c->priv->tisn[0]; /* tc =3D 0 */
+	csp.tisn            =3D c->priv->tisn[c->lag_port][0]; /* tc =3D 0 */
 	csp.cqn             =3D sq->cq.mcq.cqn;
 	csp.wq_ctrl         =3D &sq->wq_ctrl;
 	csp.min_inline_mode =3D sq->min_inline_mode;
@@ -1692,7 +1692,7 @@ static int mlx5e_open_sqs(struct mlx5e_channel *c,
 	for (tc =3D 0; tc < params->num_tc; tc++) {
 		int txq_ix =3D c->ix + tc * priv->max_nch;
=20
-		err =3D mlx5e_open_txqsq(c, c->priv->tisn[tc], txq_ix,
+		err =3D mlx5e_open_txqsq(c, c->priv->tisn[c->lag_port][tc], txq_ix,
 				       params, &cparam->sq, &c->sq[tc], tc);
 		if (err)
 			goto err_close_sqs;
@@ -1926,6 +1926,13 @@ static void mlx5e_close_queues(struct mlx5e_channel =
*c)
 	mlx5e_close_cq(&c->icosq.cq);
 }
=20
+static u8 mlx5e_enumerate_lag_port(struct mlx5_core_dev *mdev, int ix)
+{
+	u16 port_aff_bias =3D mlx5_core_is_pf(mdev) ? 0 : MLX5_CAP_GEN(mdev, vhca=
_id);
+
+	return (ix + port_aff_bias) % mlx5e_get_num_lag_ports(mdev);
+}
+
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
@@ -1960,6 +1967,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv=
, int ix,
 	c->xdp      =3D !!params->xdp_prog;
 	c->stats    =3D &priv->channel_stats[ix].ch;
 	c->irq_desc =3D irq_to_desc(irq);
+	c->lag_port =3D mlx5e_enumerate_lag_port(priv->mdev, ix);
=20
 	err =3D mlx5e_alloc_xps_cpumask(c, params);
 	if (err)
@@ -3181,35 +3189,49 @@ void mlx5e_destroy_tis(struct mlx5_core_dev *mdev, =
u32 tisn)
=20
 void mlx5e_destroy_tises(struct mlx5e_priv *priv)
 {
-	int tc;
+	int tc, i;
=20
-	for (tc =3D 0; tc < priv->profile->max_tc; tc++)
-		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
+	for (i =3D 0; i < mlx5e_get_num_lag_ports(priv->mdev); i++)
+		for (tc =3D 0; tc < priv->profile->max_tc; tc++)
+			mlx5e_destroy_tis(priv->mdev, priv->tisn[i][tc]);
+}
+
+static bool mlx5e_lag_should_assign_affinity(struct mlx5_core_dev *mdev)
+{
+	return MLX5_CAP_GEN(mdev, lag_tx_port_affinity) && mlx5e_get_num_lag_port=
s(mdev) > 1;
 }
=20
 int mlx5e_create_tises(struct mlx5e_priv *priv)
 {
+	int tc, i;
 	int err;
-	int tc;
=20
-	for (tc =3D 0; tc < priv->profile->max_tc; tc++) {
-		u32 in[MLX5_ST_SZ_DW(create_tis_in)] =3D {};
-		void *tisc;
+	for (i =3D 0; i < mlx5e_get_num_lag_ports(priv->mdev); i++) {
+		for (tc =3D 0; tc < priv->profile->max_tc; tc++) {
+			u32 in[MLX5_ST_SZ_DW(create_tis_in)] =3D {};
+			void *tisc;
=20
-		tisc =3D MLX5_ADDR_OF(create_tis_in, in, ctx);
+			tisc =3D MLX5_ADDR_OF(create_tis_in, in, ctx);
=20
-		MLX5_SET(tisc, tisc, prio, tc << 1);
+			MLX5_SET(tisc, tisc, prio, tc << 1);
=20
-		err =3D mlx5e_create_tis(priv->mdev, in, &priv->tisn[tc]);
-		if (err)
-			goto err_close_tises;
+			if (mlx5e_lag_should_assign_affinity(priv->mdev))
+				MLX5_SET(tisc, tisc, lag_tx_port_affinity, i + 1);
+
+			err =3D mlx5e_create_tis(priv->mdev, in, &priv->tisn[i][tc]);
+			if (err)
+				goto err_close_tises;
+		}
 	}
=20
 	return 0;
=20
 err_close_tises:
-	for (tc--; tc >=3D 0; tc--)
-		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
+	for (; i >=3D 0; i--) {
+		for (tc--; tc >=3D 0; tc--)
+			mlx5e_destroy_tis(priv->mdev, priv->tisn[i][tc]);
+		tc =3D priv->profile->max_tc;
+	}
=20
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/driver=
s/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 1a2560e3bf7c..3ed8ab2d703d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -279,7 +279,7 @@ static int mlx5i_init_tx(struct mlx5e_priv *priv)
 		return err;
 	}
=20
-	err =3D mlx5i_create_tis(priv->mdev, ipriv->qp.qpn, &priv->tisn[0]);
+	err =3D mlx5i_create_tis(priv->mdev, ipriv->qp.qpn, &priv->tisn[0][0]);
 	if (err) {
 		mlx5_core_warn(priv->mdev, "create tis failed, %d\n", err);
 		goto err_destroy_underlay_qp;
@@ -296,7 +296,7 @@ static void mlx5i_cleanup_tx(struct mlx5e_priv *priv)
 {
 	struct mlx5i_priv *ipriv =3D priv->ppriv;
=20
-	mlx5e_destroy_tis(priv->mdev, priv->tisn[0]);
+	mlx5e_destroy_tis(priv->mdev, priv->tisn[0][0]);
 	mlx5i_destroy_underlay_qp(priv->mdev, &ipriv->qp);
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index c5a491e22e55..96e64187c089 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -210,7 +210,7 @@ static int mlx5i_pkey_open(struct net_device *netdev)
 		goto err_unint_underlay_qp;
 	}
=20
-	err =3D mlx5i_create_tis(mdev, ipriv->qp.qpn, &epriv->tisn[0]);
+	err =3D mlx5i_create_tis(mdev, ipriv->qp.qpn, &epriv->tisn[0][0]);
 	if (err) {
 		mlx5_core_warn(mdev, "create child tis failed, %d\n", err);
 		goto err_remove_rx_uderlay_qp;
@@ -228,7 +228,7 @@ static int mlx5i_pkey_open(struct net_device *netdev)
 	return 0;
=20
 err_clear_state_opened_flag:
-	mlx5e_destroy_tis(mdev, epriv->tisn[0]);
+	mlx5e_destroy_tis(mdev, epriv->tisn[0][0]);
 err_remove_rx_uderlay_qp:
 	mlx5_fs_remove_rx_underlay_qpn(mdev, ipriv->qp.qpn);
 err_unint_underlay_qp:
@@ -257,7 +257,7 @@ static int mlx5i_pkey_close(struct net_device *netdev)
 	mlx5i_uninit_underlay_qp(priv);
 	mlx5e_deactivate_priv_channels(priv);
 	mlx5e_close_channels(&priv->channels);
-	mlx5e_destroy_tis(mdev, priv->tisn[0]);
+	mlx5e_destroy_tis(mdev, priv->tisn[0][0]);
 unlock:
 	mutex_unlock(&priv->state_lock);
 	return 0;
--=20
2.21.0

