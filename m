Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5443DE7CFB
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731862AbfJ1XfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:24 -0400
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:57509
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731755AbfJ1XfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiahWmeOmAcrZmpk7Tn6C/bfb8jP1ykYwuJndGhYSe9A7OkpWf6Q6tLZ1HxzX6SfdzM2O0kCbidoM++C2aVylx3OWNoJvYEvekfvGDYwG9rmznKwrEtfyTur2yMW0H7ZurfgdHoA5UG+sYgj5MbX+dQ2Dev3rqsBvqvqAcAFk/7UdcOmr2wEt1549cDFvknJ9hSsH4J0GoT6fOe1JFkNdsnDLq/rP+5qheCGlUH9xf6BeA11dOhMFf6fO1WI5ao56/+8HwMSnvmfQxEez2OR557HzSuqRcIrpldN0x0qcGGT7LSpDEPcOJakEKDxJNBJvZra5ZhQVJcPcll98YVCAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khCMg9yYIjLsJTnjSRiZTZtvhajoGUuQF28bIu7p+8c=;
 b=iAoFno0KJG/NUpW81SpouAmjq3MNhsNhIbx2lKqYUrjHAcGFX7ullw5OJaElpg7yuvx/RIUTbUJGUrMTo+zfDNR5Nu0RF7rJVLuLkiBW1jn7tKyGE6wfiobVY7XrfugU4hphbptqrzrwtG3gKdeJewIDE9bEcUR+CDPHELbg4qhFESotigIiCZm2/ZGdYtkD4CFh69gWc24ES5T/ZYJFtJMKH/gJnAPWB5BLj9NNIsV/GS8h4xbrdu/aMnZJq19fy/KLJfTtZJ5dZgjrFyfxeYDe4rqqWg/4E/bzEbasutWG8Q7QPoNW/UMHOsmm9IJ73W5yHdGYfIMB446EZiPSlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khCMg9yYIjLsJTnjSRiZTZtvhajoGUuQF28bIu7p+8c=;
 b=YYgk2JouYFrszX4LDjccurr5h4B2lz0xfLjdhkCxMeEjO+E1Uw97A+2Pj0f8vP5SD7XN73OdBT8D9flBPxCyJDTnVBmLBSOxbBIr6dPDc7WUaANITdhKD6TXSrYNVPkCsBA1HD2GZ7UHq62UWczbo73e4JmMAk8cAUwUHhRrP6s=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6413.eurprd05.prod.outlook.com (20.179.27.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 12/18] net/mlx5: Move ACL drop counters life cycle
 close to ACL lifecycle
Thread-Topic: [PATCH mlx5-next 12/18] net/mlx5: Move ACL drop counters life
 cycle close to ACL lifecycle
Thread-Index: AQHVjehb0ONm88IT7ECkG9Cw/zzCGw==
Date:   Mon, 28 Oct 2019 23:35:19 +0000
Message-ID: <20191028233440.5564-13-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 474baa18-86e3-4f28-5e37-08d75bff7e60
x-ms-traffictypediagnostic: VI1PR05MB6413:|VI1PR05MB6413:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB64137B3EC3B4875D5146C4C4BE660@VI1PR05MB6413.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(199004)(189003)(71200400001)(256004)(316002)(6636002)(14444005)(2906002)(6436002)(446003)(8936002)(50226002)(11346002)(6486002)(8676002)(486006)(14454004)(110136005)(36756003)(81166006)(6116002)(81156014)(54906003)(3846002)(86362001)(7736002)(66066001)(99286004)(450100002)(102836004)(6512007)(1076003)(5660300002)(6506007)(4326008)(478600001)(386003)(476003)(186003)(26005)(66476007)(66556008)(64756008)(66946007)(66446008)(305945005)(76176011)(71190400001)(52116002)(107886003)(25786009)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6413;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IhuKlgi4q50hyY3hrnU72ErLWPNxYok5vz0jL03Y88pALdEULck0VFNB0h97TWtTBiyKtzlkffPo5vH8SLco60R/mLFznaYEVHzzXThlW35b0Mwk89C8pck8PY/hl4VLLKWCVuz1X90EK9dN1taVh+D88k24eXT+kF+z2AEJ7zW4ZIniNSuBZrH43hPmKvkzI5RCL2MUMc78oV/IaXc1vV/ax2Jqu+5yZCyBEq3NDdh53JdQPc5PUO9viySDMMoCZ4jero/uSU66C1XuokdQINAWr6umZO94OkhuTjNN4yXk4ycqaXD7ZZX1Np4IiV7Uk1aErDMpuZ9VtSwhR21bv/jwofFhxTPWQpWQlI+59xiUueM/vVNr+LRI1RRYpXs53N3CsC1lvQIiz/xjzWAGaLtn5Tvs3FnBbKb7sLq/kFb8cUHzudOcE7F/Nb6dtL/F
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 474baa18-86e3-4f28-5e37-08d75bff7e60
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:19.2916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dxCs2I5PalejYL6RvzNuJWpJwrw/9qE0mLReuVimb9fu+8RkFFTbAiJMkM5zQlY7eZOyPX3IB/STV81OTRrHzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6413
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

It is better to create/destroy ACL related drop counters where the actual
drop rule ACLs are created/destroyed, so that ACL configuration is self
contained for ingress and egress.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 74 +++++++++----------
 1 file changed, 35 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 47555e272dda..0e5113167739 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1665,58 +1665,55 @@ static void esw_apply_vport_conf(struct mlx5_eswitc=
h *esw,
 			       flags);
 }
=20
-static void esw_legacy_vport_create_drop_counters(struct mlx5_vport *vport=
)
+static int esw_vport_create_legacy_acl_tables(struct mlx5_eswitch *esw,
+					      struct mlx5_vport *vport)
 {
-	struct mlx5_core_dev *dev =3D vport->dev;
+	int ret;
=20
-	if (MLX5_CAP_ESW_INGRESS_ACL(dev, flow_counter)) {
-		vport->ingress.legacy.drop_counter =3D mlx5_fc_create(dev, false);
+	/* Only non manager vports need ACL in legacy mode */
+	if (mlx5_esw_is_manager_vport(esw, vport->vport))
+		return 0;
+
+	if (!mlx5_esw_is_manager_vport(esw, vport->vport) &&
+	    MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
+		vport->ingress.legacy.drop_counter =3D mlx5_fc_create(esw->dev, false);
 		if (IS_ERR(vport->ingress.legacy.drop_counter)) {
-			esw_warn(dev,
+			esw_warn(esw->dev,
 				 "vport[%d] configure ingress drop rule counter failed\n",
 				 vport->vport);
 			vport->ingress.legacy.drop_counter =3D NULL;
 		}
 	}
=20
-	if (MLX5_CAP_ESW_EGRESS_ACL(dev, flow_counter)) {
-		vport->egress.legacy.drop_counter =3D mlx5_fc_create(dev, false);
+	ret =3D esw_vport_ingress_config(esw, vport);
+	if (ret)
+		goto ingress_err;
+
+	if (!mlx5_esw_is_manager_vport(esw, vport->vport) &&
+	    MLX5_CAP_ESW_EGRESS_ACL(esw->dev, flow_counter)) {
+		vport->egress.legacy.drop_counter =3D mlx5_fc_create(esw->dev, false);
 		if (IS_ERR(vport->egress.legacy.drop_counter)) {
-			esw_warn(dev,
+			esw_warn(esw->dev,
 				 "vport[%d] configure egress drop rule counter failed\n",
 				 vport->vport);
 			vport->egress.legacy.drop_counter =3D NULL;
 		}
 	}
-}
-
-static void esw_legacy_vport_destroy_drop_counters(struct mlx5_vport *vpor=
t)
-{
-	struct mlx5_core_dev *dev =3D vport->dev;
-
-	if (vport->ingress.legacy.drop_counter)
-		mlx5_fc_destroy(dev, vport->ingress.legacy.drop_counter);
-	if (vport->egress.legacy.drop_counter)
-		mlx5_fc_destroy(dev, vport->egress.legacy.drop_counter);
-}
-
-static int esw_vport_create_legacy_acl_tables(struct mlx5_eswitch *esw,
-					      struct mlx5_vport *vport)
-{
-	int ret;
-
-	/* Only non manager vports need ACL in legacy mode */
-	if (mlx5_esw_is_manager_vport(esw, vport->vport))
-		return 0;
-
-	ret =3D esw_vport_ingress_config(esw, vport);
-	if (ret)
-		return ret;
=20
 	ret =3D esw_vport_egress_config(esw, vport);
 	if (ret)
-		esw_vport_disable_ingress_acl(esw, vport);
+		goto egress_err;
+
+	return 0;
=20
+egress_err:
+	esw_vport_disable_ingress_acl(esw, vport);
+	mlx5_fc_destroy(esw->dev, vport->egress.legacy.drop_counter);
+	vport->egress.legacy.drop_counter =3D NULL;
+
+ingress_err:
+	mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
+	vport->ingress.legacy.drop_counter =3D NULL;
 	return ret;
 }
=20
@@ -1737,8 +1734,12 @@ static void esw_vport_destroy_legacy_acl_tables(stru=
ct mlx5_eswitch *esw,
 		return;
=20
 	esw_vport_disable_egress_acl(esw, vport);
+	mlx5_fc_destroy(esw->dev, vport->egress.legacy.drop_counter);
+	vport->egress.legacy.drop_counter =3D NULL;
+
 	esw_vport_disable_ingress_acl(esw, vport);
-	esw_legacy_vport_destroy_drop_counters(vport);
+	mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
+	vport->ingress.legacy.drop_counter =3D NULL;
 }
=20
 static void esw_vport_cleanup_acl(struct mlx5_eswitch *esw,
@@ -1759,11 +1760,6 @@ static int esw_enable_vport(struct mlx5_eswitch *esw=
, struct mlx5_vport *vport,
=20
 	esw_debug(esw->dev, "Enabling VPORT(%d)\n", vport_num);
=20
-	/* Create steering drop counters for ingress and egress ACLs */
-	if (!mlx5_esw_is_manager_vport(esw, vport_num) &&
-	    esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
-		esw_legacy_vport_create_drop_counters(vport);
-
 	/* Restore old vport configuration */
 	esw_apply_vport_conf(esw, vport);
=20
--=20
2.21.0

