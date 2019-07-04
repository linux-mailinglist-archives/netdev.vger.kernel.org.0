Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52835FCCC
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfGDSQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:23 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:20736
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727324AbfGDSQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iywrLFE/474cOjoOJzX+GJnLzb2OMUxD+0C8aFOEhIk=;
 b=lSLi0/mF0LS/LPKZf5dfAmB/rbLWJ+sxp29mtGDuRW2xdx+f7NNK6Z/3K98JTSd23dycbt/h1S5puWWTVCh1zCEYYlzg4W44Wo6Rv83WGb4P5J3H/xUq+Pr4PmpgbywIAcepDCUNsPb2HcUil4GC3XJwrkif3HxMEQYTPHrTCMk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:16:10 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:16:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/14] net/mlx5e: Re-work TIS creation functions
Thread-Topic: [net-next 12/14] net/mlx5e: Re-work TIS creation functions
Thread-Index: AQHVMpSOah7SmYx+tkm2ZJrrYiuqPA==
Date:   Thu, 4 Jul 2019 18:16:10 +0000
Message-ID: <20190704181235.8966-13-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
In-Reply-To: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd83e380-786d-4a2f-0a27-08d700abb0b4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB2584CFD2E86F023E5463BBD0BEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:112;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(14444005)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VYlTyX32E8mkt0IvK/CMHi0RvD6xnwX+/yA4Num+sJ3Wn0cJ/px0zBr07dIIoKOmxzrIo4iQU9BdwZxrmYPotzOhUBItRy5MM1bcOPur2jv22ZMMRFxn0ssS0oQqKDJCWE1iQg6+IFM5EoCYKzJ3uginUHAlA3B59+q2RRL0LwX4Zr1x1l1j79w6WO9vSJtV1QkKtEGhgmdAHo9mqTVzSjhLH4NBsMb8IKML7kaXkH6P4YybbunWbYoPLwik+e7EM4JJZVTCGqVp6Mhv/PSGok1F9P2YOUjRZUcIS938M9dAG8AmmIL+b10RKZTeZuQSlWZpCnmNm7mM+28MyZ8VRtnTnoyNvQUgxx/mkY1q9Bf+FzVCKrAkIsGMp5RYlonOVHcB2g5gyq3vuhbLzRDBwG3u9WokdDELQa9PFSjNKyU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd83e380-786d-4a2f-0a27-08d700abb0b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:16:10.5145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Let the EN TIS creation function (mlx5e_create_tis) be responsible
for applying common mdev related fields.
Other specific fields must be set by the caller and passed within
the inbox.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h    |  3 +--
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 17 ++++++++++-------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c   | 14 +++++++++++++-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.h   |  2 ++
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c       |  2 +-
 5 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 6ef1da508588..b66d88f582f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -929,8 +929,7 @@ int mlx5e_create_direct_tirs(struct mlx5e_priv *priv);
 void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv);
 void mlx5e_destroy_rqt(struct mlx5e_priv *priv, struct mlx5e_rqt *rqt);
=20
-int mlx5e_create_tis(struct mlx5_core_dev *mdev, int tc,
-		     u32 underlay_qpn, u32 *tisn);
+int mlx5e_create_tis(struct mlx5_core_dev *mdev, void *in, u32 *tisn);
 void mlx5e_destroy_tis(struct mlx5_core_dev *mdev, u32 tisn);
=20
 int mlx5e_create_tises(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 2d63d4832591..c1b73a548857 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3048,20 +3048,16 @@ void mlx5e_close_drop_rq(struct mlx5e_rq *drop_rq)
 	mlx5e_free_cq(&drop_rq->cq);
 }
=20
-int mlx5e_create_tis(struct mlx5_core_dev *mdev, int tc,
-		     u32 underlay_qpn, u32 *tisn)
+int mlx5e_create_tis(struct mlx5_core_dev *mdev, void *in, u32 *tisn)
 {
-	u32 in[MLX5_ST_SZ_DW(create_tis_in)] =3D {0};
 	void *tisc =3D MLX5_ADDR_OF(create_tis_in, in, ctx);
=20
-	MLX5_SET(tisc, tisc, prio, tc << 1);
-	MLX5_SET(tisc, tisc, underlay_qpn, underlay_qpn);
 	MLX5_SET(tisc, tisc, transport_domain, mdev->mlx5e_res.td.tdn);
=20
 	if (mlx5_lag_is_lacp_owner(mdev))
 		MLX5_SET(tisc, tisc, strict_lag_tx_port_affinity, 1);
=20
-	return mlx5_core_create_tis(mdev, in, sizeof(in), tisn);
+	return mlx5_core_create_tis(mdev, in, MLX5_ST_SZ_BYTES(create_tis_in), ti=
sn);
 }
=20
 void mlx5e_destroy_tis(struct mlx5_core_dev *mdev, u32 tisn)
@@ -3075,7 +3071,14 @@ int mlx5e_create_tises(struct mlx5e_priv *priv)
 	int tc;
=20
 	for (tc =3D 0; tc < priv->profile->max_tc; tc++) {
-		err =3D mlx5e_create_tis(priv->mdev, tc, 0, &priv->tisn[tc]);
+		u32 in[MLX5_ST_SZ_DW(create_tis_in)] =3D {};
+		void *tisc;
+
+		tisc =3D MLX5_ADDR_OF(create_tis_in, in, ctx);
+
+		MLX5_SET(tisc, tisc, prio, tc << 1);
+
+		err =3D mlx5e_create_tis(priv->mdev, in, &priv->tisn[tc]);
 		if (err)
 			goto err_close_tises;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/driver=
s/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index e68d124eb625..f746036a3150 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -258,6 +258,18 @@ void mlx5i_destroy_underlay_qp(struct mlx5_core_dev *m=
dev, struct mlx5_core_qp *
 	mlx5_core_destroy_qp(mdev, qp);
 }
=20
+int mlx5i_create_tis(struct mlx5_core_dev *mdev, u32 underlay_qpn, u32 *ti=
sn)
+{
+	u32 in[MLX5_ST_SZ_DW(create_tis_in)] =3D {};
+	void *tisc;
+
+	tisc =3D MLX5_ADDR_OF(create_tis_in, in, ctx);
+
+	MLX5_SET(tisc, tisc, underlay_qpn, underlay_qpn);
+
+	return mlx5e_create_tis(mdev, in, tisn);
+}
+
 static int mlx5i_init_tx(struct mlx5e_priv *priv)
 {
 	struct mlx5i_priv *ipriv =3D priv->ppriv;
@@ -269,7 +281,7 @@ static int mlx5i_init_tx(struct mlx5e_priv *priv)
 		return err;
 	}
=20
-	err =3D mlx5e_create_tis(priv->mdev, 0 /* tc */, ipriv->qp.qpn, &priv->ti=
sn[0]);
+	err =3D mlx5i_create_tis(priv->mdev, ipriv->qp.qpn, &priv->tisn[0]);
 	if (err) {
 		mlx5_core_warn(priv->mdev, "create tis failed, %d\n", err);
 		goto err_destroy_underlay_qp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/driver=
s/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index e19ba3fcd1b7..c87962cab921 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -59,6 +59,8 @@ struct mlx5i_priv {
 	char  *mlx5e_priv[0];
 };
=20
+int mlx5i_create_tis(struct mlx5_core_dev *mdev, u32 underlay_qpn, u32 *ti=
sn);
+
 /* Underlay QP create/destroy functions */
 int mlx5i_create_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_=
qp *qp);
 void mlx5i_destroy_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_cor=
e_qp *qp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index e05186ada721..6e56fa769d2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -210,7 +210,7 @@ static int mlx5i_pkey_open(struct net_device *netdev)
 		goto err_unint_underlay_qp;
 	}
=20
-	err =3D mlx5e_create_tis(mdev, 0 /* tc */, ipriv->qp.qpn, &epriv->tisn[0]=
);
+	err =3D mlx5i_create_tis(mdev, ipriv->qp.qpn, &epriv->tisn[0]);
 	if (err) {
 		mlx5_core_warn(mdev, "create child tis failed, %d\n", err);
 		goto err_remove_rx_uderlay_qp;
--=20
2.21.0

