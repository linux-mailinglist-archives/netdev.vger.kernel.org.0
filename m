Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A85E7CFE
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731972AbfJ1Xf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:27 -0400
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:57509
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731870AbfJ1Xf0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iynKYNullmfPmF6rnZuTnYJJSl/zqrZeNW3tLAMagUpYScX5S/0h+l+ZotxLVLAdRW3x5wtawGLC52GLAkEB/UiANm4LIP+l5cpT/r3XBREy6DQyd/Zmnw52M0NDlj4pvLI81lwqkK7v1P9cyuLa70NMAEeL8RvzMNjuBuSZ9N4ysU7gTU2dhb/bD/qJt/6CBT1dqYvVrj/wfAJheOtR7kygBGZVFRaxTwDAJL4bhT0bGJL9XLd5LfOfBf7biWle7mhZjlaBH/m1GQRn+qqglzuAZnNMcmZf9af/F2qx3YSA0E3VTreEyKlCbme+hN4MtNYi5JZsBouUld98MCf/jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yEWpxCHNCJm+RkIFudQn0nLG3WL8X/sjyUcovextGf8=;
 b=iX/lhis12VSEOwKwwk163/fxJRhoA/FN+8tFUu/I1/vZd0GQHAwWgP+/ZPxRvObNuHgdDBHoX00+8lgNUNZIO3F1XBIvnHVHK5MrzVooNSmGH7Ho/qkkwMbYIBokPZt4SB8FalnRCkcqh9q5v/VsveuD/FK78B1jB36aavNDrXUpX59T6fNKSm/XKK1qeTnJa1PgROe+iTEvNh+zHgDu+tpE6jq+D7/MW2tWhgika1Ma4T3d6SuYmpHck+nxRoTHy1zKkxFsK3v1bMUccpama9/J6j/d7n0a8fJj0OL9iOxRng6cxTK+ABH3Ow8JSpmAvAY+d3dFEeKdUGChFEsHXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yEWpxCHNCJm+RkIFudQn0nLG3WL8X/sjyUcovextGf8=;
 b=fkfqyBkl5UUPvAfeGhC+m11lx7RcIjqbs+mKHc0fyjQ+8BifH+GLuzzNsm7tdCYNePHm5OCsjxEX7GoYJKTIpNHiT0G6viawMbm7PkpK9/Ol3edDis0lS03T5mDEubNG4g4peB945C/ZHszdevZcmZI7JVmMkSXqvcUOGNxpYSE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6413.eurprd05.prod.outlook.com (20.179.27.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 14/18] net/mlx5: E-switch, Offloads shift ACL
 programming during enable/disable vport
Thread-Topic: [PATCH mlx5-next 14/18] net/mlx5: E-switch, Offloads shift ACL
 programming during enable/disable vport
Thread-Index: AQHVjehejG3Sswim10+QjjBP0b6QEA==
Date:   Mon, 28 Oct 2019 23:35:22 +0000
Message-ID: <20191028233440.5564-15-saeedm@mellanox.com>
References: <20191028233440.5564-1-saeedm@mellanox.com>
In-Reply-To: <20191028233440.5564-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:180::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd843df7-af73-4d6d-df74-08d75bff8066
x-ms-traffictypediagnostic: VI1PR05MB6413:|VI1PR05MB6413:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB64135FB51245849C48A0DB85BE660@VI1PR05MB6413.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(199004)(189003)(71200400001)(256004)(316002)(6636002)(14444005)(2906002)(6436002)(446003)(8936002)(50226002)(11346002)(6486002)(8676002)(486006)(14454004)(110136005)(36756003)(81166006)(6116002)(81156014)(54906003)(3846002)(86362001)(7736002)(66066001)(99286004)(450100002)(102836004)(6512007)(1076003)(5660300002)(6506007)(4326008)(478600001)(386003)(476003)(186003)(26005)(66476007)(66556008)(64756008)(66946007)(66446008)(305945005)(76176011)(71190400001)(52116002)(107886003)(25786009)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6413;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: utXtVy4RXKT+HNE2UX2/KfcUiyFeC6Cn7wpE8QDrfRu7lGvVqCD1LCMolgqIsoOwGw40Q57yNHuS4HoQnlM4Eo21qWOACaP5r7rqunenPGvDiifYiMt/rtSWecihPiP/2aC1XOHsRgGnh+LMF5mX4BDmRbNgX/T2NnhnX1M0WAgQv4Hs25d+aoRV53V4RvQzm46WueGqNN/SPPofp6Ub/hwt9PgBMw4IWzDtRLyGE1itbOg6Y9rTExwTlpMWA7ImqMN2S3AvEShoGnDJnoHWmDsR09SUyhq9zM4a4vEdNzmOA15r3cYNpx9vVWYMNfnEBFFGymYzNM8r542O9RhpK/9Yq43evFj5pP3rRKmrtncj0WomK3VfnNIg6eDegmvM6NE/Y394SJYWaNMbsr6kMMo87iAmYZHno2N3C7fcSfin0/r61uAGQqxkkbXtCGUH
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd843df7-af73-4d6d-df74-08d75bff8066
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:22.7027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YzeujPnh3Vbiz08einpe0hdhwSIGmMkr+3a46wny63j0ijE9m2UdhPyd5JZBhg1kMy+/9yGIzEMGeulzeQaYGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6413
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Currently legacy mode enables ACL while enabling vport, while offloads
mode enable ACL when moving to offloads mode.

Bring consistency to both modes by enabling/disabling ACL when
enabling/disabling a vport.

It also eliminates creating ingress ACL table on unused ECPF vport in
offloads mode.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  6 ++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  7 ++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 42 ++++++-------------
 3 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 0e5113167739..1ce6ae1c446e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1722,8 +1722,8 @@ static int esw_vport_setup_acl(struct mlx5_eswitch *e=
sw,
 {
 	if (esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
 		return esw_vport_create_legacy_acl_tables(esw, vport);
-
-	return 0;
+	else
+		return esw_vport_create_offloads_acl_tables(esw, vport);
 }
=20
 static void esw_vport_destroy_legacy_acl_tables(struct mlx5_eswitch *esw,
@@ -1747,6 +1747,8 @@ static void esw_vport_cleanup_acl(struct mlx5_eswitch=
 *esw,
 {
 	if (esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
 		esw_vport_destroy_legacy_acl_tables(esw, vport);
+	else
+		esw_vport_destroy_offloads_acl_tables(esw, vport);
 }
=20
 static int esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *v=
port,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 36edee35f155..d926bdacbdcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -614,6 +614,13 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *=
esw,
 				 enum mlx5_eswitch_vport_event enabled_events);
 void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw);
=20
+int
+esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
+				     struct mlx5_vport *vport);
+void
+esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
+				      struct mlx5_vport *vport);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0=
; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 94eb18ae33a4..ce30ead90617 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1950,7 +1950,7 @@ esw_check_vport_match_metadata_supported(const struct=
 mlx5_eswitch *esw)
 	return true;
 }
=20
-static int
+int
 esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 				     struct mlx5_vport *vport)
 {
@@ -1968,7 +1968,7 @@ esw_vport_create_offloads_acl_tables(struct mlx5_eswi=
tch *esw,
 	return err;
 }
=20
-static void
+void
 esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
 				      struct mlx5_vport *vport)
 {
@@ -1976,43 +1976,27 @@ esw_vport_destroy_offloads_acl_tables(struct mlx5_e=
switch *esw,
 	esw_vport_disable_ingress_acl(esw, vport);
 }
=20
-static int esw_create_offloads_acl_tables(struct mlx5_eswitch *esw)
+static int esw_create_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
-	int i, j;
 	int err;
=20
 	if (esw_check_vport_match_metadata_supported(esw))
 		esw->flags |=3D MLX5_ESWITCH_VPORT_MATCH_METADATA;
=20
-	mlx5_esw_for_all_vports(esw, i, vport) {
-		err =3D esw_vport_create_offloads_acl_tables(esw, vport);
-		if (err)
-			goto err_acl_table;
-	}
-
-	if (mlx5_eswitch_vport_match_metadata_enabled(esw))
-		esw_info(esw->dev, "Use metadata reg_c as source vport to match\n");
-
-	return 0;
-
-err_acl_table:
-	for (j =3D MLX5_VPORT_PF; j < i; j++) {
-		vport =3D &esw->vports[j];
-		esw_vport_destroy_offloads_acl_tables(esw, vport);
-	}
-
+	vport =3D mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
+	err =3D esw_vport_create_offloads_acl_tables(esw, vport);
+	if (err)
+		esw->flags &=3D ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
 	return err;
 }
=20
-static void esw_destroy_offloads_acl_tables(struct mlx5_eswitch *esw)
+static void esw_destroy_uplink_offloads_acl_tables(struct mlx5_eswitch *es=
w)
 {
 	struct mlx5_vport *vport;
-	int i;
-
-	mlx5_esw_for_all_vports(esw, i, vport)
-		esw_vport_destroy_offloads_acl_tables(esw, vport);
=20
+	vport =3D mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
+	esw_vport_destroy_offloads_acl_tables(esw, vport);
 	esw->flags &=3D ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
 }
=20
@@ -2030,7 +2014,7 @@ static int esw_offloads_steering_init(struct mlx5_esw=
itch *esw)
 	memset(&esw->fdb_table.offloads, 0, sizeof(struct offloads_fdb));
 	mutex_init(&esw->fdb_table.offloads.fdb_prio_lock);
=20
-	err =3D esw_create_offloads_acl_tables(esw);
+	err =3D esw_create_uplink_offloads_acl_tables(esw);
 	if (err)
 		return err;
=20
@@ -2055,7 +2039,7 @@ static int esw_offloads_steering_init(struct mlx5_esw=
itch *esw)
 	esw_destroy_offloads_fdb_tables(esw);
=20
 create_fdb_err:
-	esw_destroy_offloads_acl_tables(esw);
+	esw_destroy_uplink_offloads_acl_tables(esw);
=20
 	return err;
 }
@@ -2065,7 +2049,7 @@ static void esw_offloads_steering_cleanup(struct mlx5=
_eswitch *esw)
 	esw_destroy_vport_rx_group(esw);
 	esw_destroy_offloads_table(esw);
 	esw_destroy_offloads_fdb_tables(esw);
-	esw_destroy_offloads_acl_tables(esw);
+	esw_destroy_uplink_offloads_acl_tables(esw);
 }
=20
 static void
--=20
2.21.0

