Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E9D9A3E0
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfHVXf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:35:59 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:39558
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726595AbfHVXf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 19:35:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuliYDfeFp2tdIfboCMZzewpxM3kcWPR6Tf2a4upXYNzi61vv1eOHhTFNKYMr9HzjGzxqZnfLIhrrCIzquzQQDlybdreUX7j8vgmeCQoF2qKaGj/wnas6MVloI2/3UFkcQbTwrMSTAMjIjZk0JiyGDXjipQRL0MwGwx1hNvsM/45e8CfazAirUGeRMoh+DvsfutXEaa8sGJVuWvwQ+TrD/rBcMK5VCLDSR4a+BlKW1t5bjZf25Q14GF5UkKAvkm77fJ6RYR9pk2enbv2QUHg/AwO1o73lH7AMMGMnpWeHprX92t21x7UjmnZCPkqJQ+BlMXpH5G9evxpPAWIDNwcZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgEdk8pW8EWGCIhSRp2s2uWGqVA8Qcrslyx10g3lLXs=;
 b=LRuOolza8d72FAWKieIOD6YLCMWx0Pv2fMqh0ECQS/LwYFTJ5bih0UPi8ASU1e+fwpCDxH5wmdAhSl+lKebPun0E52l+NA2AHT28Ow9AzJBaDTSo3NzE4GN9Akv0mNZT/4ZqzMk0KtRXudwGeGz2ewdh48qB9CEq5PUIEHGK5b6g+gpIs+ilzdIBHmE9FI2KNuEzZnlHKkbROCym/N6hDBZAjE+Q/rNXfKynUO+l9yp7kroFNcq4lSmudYOGtjfHVOL1WUQ2rtUoJ0Zho57dQejKtwQNyVN7n6/R/YWW5sOYekWMovQf7kl9E9xLnsGAK8EoYCL5rkals/bAwpKUVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgEdk8pW8EWGCIhSRp2s2uWGqVA8Qcrslyx10g3lLXs=;
 b=JYMip6zGIxeBB1JeSNuI0n6JVhVIV+3gfEKVSNvEGwIf0mpP9r/XDqSNej/bnlgc9mkrZEDHE0aSoTvO6Mv9F7t/3TXT8GMmGVWungjDJa1+3FmfQ/E3ZYopzqxHIvRPdFVumsBv1fBdl5y0/uF1u0GQ3f5mZDgLww84Hv5XGqw=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2817.eurprd05.prod.outlook.com (10.172.215.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 23:35:50 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 23:35:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 3/8] net/mlx5e: Support LAG TX port affinity distribution
Thread-Topic: [net-next 3/8] net/mlx5e: Support LAG TX port affinity
 distribution
Thread-Index: AQHVWUJUFStyAoQ500qvtpRDRgjZ3Q==
Date:   Thu, 22 Aug 2019 23:35:50 +0000
Message-ID: <20190822233514.31252-4-saeedm@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
In-Reply-To: <20190822233514.31252-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8839a29-baba-43b4-5d9c-08d72759772f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2817;
x-ms-traffictypediagnostic: AM4PR0501MB2817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB281721C96D1F3A383EAD3B33BEA50@AM4PR0501MB2817.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(189003)(199004)(256004)(14444005)(53936002)(14454004)(107886003)(6436002)(4326008)(8676002)(8936002)(81166006)(99286004)(81156014)(50226002)(25786009)(76176011)(316002)(54906003)(52116002)(5660300002)(71190400001)(71200400001)(186003)(386003)(66066001)(6506007)(476003)(102836004)(305945005)(1076003)(486006)(446003)(11346002)(66446008)(64756008)(66556008)(66476007)(66946007)(36756003)(6916009)(6512007)(2906002)(2616005)(26005)(3846002)(86362001)(7736002)(478600001)(6486002)(5024004)(6116002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2817;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EiLJj/62M2oxrGtg23kx6uMdOKSUXOfCYgjl5ZuxV2SY6Gt07iJmnUG5KDIT+jwDS70ly9kxwyd6PaKQZn8MfZWLt+iGQUzLRAG4u6uAh8Pi7foJCTtIUms613td8XZaWBPAiD3jXl6HbgO7URLmvTiWV8Wkq7a9SOD2OHE0P+TAIj/QDAU5EgyMlIGBinom2YufMUveT4WlS/YbkJiw1y7QqUowpo2t9NwVXBc6asZh6QdOnpGuwXZS6n8I6HXwzxYLRm28GZ03ijZrw88e1Dsgq/8b3+sl547fMmLpYuu3E+qCH6GUwSSlysRA1K0XE/LT/36aWajyltfTB6OpSbugPjPA5GeEPE/e70DXzMfijNkKoqwGQ/XBN3qEtDxOzZYqJ7khDCvhvbzGrVxXzJnmcPdfmrmyiv6fRZDqskA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8839a29-baba-43b4-5d9c-08d72759772f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 23:35:50.5448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /9rEw+Y0eszZrE7/E6ZmcabkXnH8S4aA/ryRAwgx21SIaEVWJ0LUyfUw7Z4yBiwzps0XUemexwwbZNVuQY2EBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2817
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
index d0cda5181ab4..b1bc0e601cc2 100644
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

