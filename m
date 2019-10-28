Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E56E7CFD
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731927AbfJ1Xf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:26 -0400
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:57509
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731587AbfJ1XfY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5b19dtD5A3VJBj3qiKuNAOaHaiTtUXP/6afU/9lqb34duwYqkLRxMTahnzPAgAb1uDGcQklH2n7mRFSH+bbg2SbTxfyiEVaNSFWirIjqg+CilSlcr/JZ8QsX9GsxX4gv7zLrX+cOu5dWpmSmfxz/KWbxHqCdn6W2cDNQhUUzR52QmwsI9VsyWTyh5gwhNAYp7Ug8g+eIT0KxAJwHeTjbZ/4g4X9+lnkNraijD5raanRCsTb+BiIWT7wZf5hmwzRcvN1lbM1G6eqx0cywL84DzEPNZBsgJEIq2A80NKFi4yqqyqC8Lk5t/nFAu2FbkUhiN69P97QyULoOFBgoPgerQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAoBx6yP/c2kozxrmBWYSFG8897Mv3TohadV+GiG93o=;
 b=S8GXxC4Q5v/D+xEMFnuFxLkVDRpFB6TLYWScsQQ3ndwLz97d5qzs3TAaKRRP01FNXMvMD8fZ+r1nb0mLuZQMtU5KQOPujQObjqLNCxUm51U+gwLRAkSiJxmfwi+JCAoghl51UHsj/e+3/2Ie7FhtU3XoLe+nVkymbMBTkXFUUDan+TF00EFLXne5s2UJO/lTHeZJ+1NpXvBkAtq0BBH0f4S78OQE646xPOwviY3AFfqV1hOv08QO+JkTHyhsMvv9ZTOpvfKf6z/AOR4IaGHfuPwsySyHUovGt1SowZ56iuzbQik5tj8X4h9n8+CFgSXHKNm7QJ1uz/RE9x8rFLb9ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAoBx6yP/c2kozxrmBWYSFG8897Mv3TohadV+GiG93o=;
 b=Hib6R2YMwwApXNX4/dJ/0WdqwJ7I9B4tZUnhqZmHguxkQ0DN1TSHeKh/eWvQoJVWtELm8qCx9i/L5OovGa9kym46uHzGllEXNR2v7jlVaW9TuS0G/yr15qH5YYRF9bVC7ea1gHBmXn2pJnnj/fav7Rc5SC0+IIDsyvD5vYza7pw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6413.eurprd05.prod.outlook.com (20.179.27.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 13/18] net/mlx5: E-switch, Offloads introduce and
 use per vport acl tables APIs
Thread-Topic: [PATCH mlx5-next 13/18] net/mlx5: E-switch, Offloads introduce
 and use per vport acl tables APIs
Thread-Index: AQHVjehclrpTKlyG4U69a3oszO1Q5A==
Date:   Mon, 28 Oct 2019 23:35:20 +0000
Message-ID: <20191028233440.5564-14-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: fbac82cc-6786-4a0e-929d-08d75bff7f57
x-ms-traffictypediagnostic: VI1PR05MB6413:|VI1PR05MB6413:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB64139B571E41F66F97600405BE660@VI1PR05MB6413.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:79;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(199004)(189003)(71200400001)(256004)(316002)(6636002)(2906002)(6436002)(446003)(8936002)(50226002)(11346002)(6486002)(8676002)(486006)(14454004)(110136005)(36756003)(81166006)(6116002)(81156014)(54906003)(3846002)(86362001)(7736002)(66066001)(99286004)(450100002)(102836004)(6512007)(1076003)(5660300002)(6506007)(4326008)(478600001)(386003)(476003)(186003)(26005)(66476007)(66556008)(64756008)(66946007)(66446008)(305945005)(76176011)(71190400001)(52116002)(107886003)(25786009)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6413;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yT4dQBvkl5oLgG7otZv8LN1kQd3gdygJnxYuneiMumHpYeTDKYOiV/5W/J5E/I2cbksq7CP0VXMp5PBpubBZekIORnm1UVfYi0YRKIUeyxfnxR9vpBXdtdcc0s8kB3JZWjCwBh3tcTrEP13N7b9a9KVLceGbqpHHxP6yQC9yNqXwfUrXH2gG4IziQqL3PiEzXQN8WiGf7r5xbDY4CtHui7eKlgmd7q6t0jRi82tgANzaXS4vUHRpybMBOW+2RVkt+jUhknBgc3IdXxNUcZntzs0e/kc80NrMsqBsdT7f7HVVSIIvWaug17A/1WJ6t+P5W4L+lVkViq5wIBmYVA2WZFopzhYWNZcH9GHZYuB3jdp9/XsSF6bfckqOZcmlbXyNqAF/5QNn+kMWcDpKAP+uHHiVnEgSAvLc5XNa5uEhRgmhrF6xhWJvATy9dzi1CWnf
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbac82cc-6786-4a0e-929d-08d75bff7f57
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:20.8967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YnwItN7ney8ZKjK82Wa8FKniEuPetqgS1wIOT8yZCHXUquA+VjcdBiUpCYiLAwsTQ+av4pqYRsD47Szvjmfu3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6413
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Introduce and use per vport ACL tables creation and destroy APIs, so that
subsequently patch can use them during enabling/disabling a vport.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 49 ++++++++++++-------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 98df1eeee873..94eb18ae33a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1950,6 +1950,32 @@ esw_check_vport_match_metadata_supported(const struc=
t mlx5_eswitch *esw)
 	return true;
 }
=20
+static int
+esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
+				     struct mlx5_vport *vport)
+{
+	int err;
+
+	err =3D esw_vport_ingress_config(esw, vport);
+	if (err)
+		return err;
+
+	if (mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
+		err =3D esw_vport_egress_config(esw, vport);
+		if (err)
+			esw_vport_disable_ingress_acl(esw, vport);
+	}
+	return err;
+}
+
+static void
+esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
+				      struct mlx5_vport *vport)
+{
+	esw_vport_disable_egress_acl(esw, vport);
+	esw_vport_disable_ingress_acl(esw, vport);
+}
+
 static int esw_create_offloads_acl_tables(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
@@ -1960,15 +1986,9 @@ static int esw_create_offloads_acl_tables(struct mlx=
5_eswitch *esw)
 		esw->flags |=3D MLX5_ESWITCH_VPORT_MATCH_METADATA;
=20
 	mlx5_esw_for_all_vports(esw, i, vport) {
-		err =3D esw_vport_ingress_config(esw, vport);
+		err =3D esw_vport_create_offloads_acl_tables(esw, vport);
 		if (err)
-			goto err_ingress;
-
-		if (mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
-			err =3D esw_vport_egress_config(esw, vport);
-			if (err)
-				goto err_egress;
-		}
+			goto err_acl_table;
 	}
=20
 	if (mlx5_eswitch_vport_match_metadata_enabled(esw))
@@ -1976,13 +1996,10 @@ static int esw_create_offloads_acl_tables(struct ml=
x5_eswitch *esw)
=20
 	return 0;
=20
-err_egress:
-	esw_vport_disable_ingress_acl(esw, vport);
-err_ingress:
+err_acl_table:
 	for (j =3D MLX5_VPORT_PF; j < i; j++) {
 		vport =3D &esw->vports[j];
-		esw_vport_disable_egress_acl(esw, vport);
-		esw_vport_disable_ingress_acl(esw, vport);
+		esw_vport_destroy_offloads_acl_tables(esw, vport);
 	}
=20
 	return err;
@@ -1993,10 +2010,8 @@ static void esw_destroy_offloads_acl_tables(struct m=
lx5_eswitch *esw)
 	struct mlx5_vport *vport;
 	int i;
=20
-	mlx5_esw_for_all_vports(esw, i, vport) {
-		esw_vport_disable_egress_acl(esw, vport);
-		esw_vport_disable_ingress_acl(esw, vport);
-	}
+	mlx5_esw_for_all_vports(esw, i, vport)
+		esw_vport_destroy_offloads_acl_tables(esw, vport);
=20
 	esw->flags &=3D ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
 }
--=20
2.21.0

