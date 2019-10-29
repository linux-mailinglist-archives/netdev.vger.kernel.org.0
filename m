Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F001EE93E2
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfJ2XqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:46:10 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:58441
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726273AbfJ2XqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:46:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMutoN3TMPMehDafE1jaYA4qFMolHyBe8jaiT+jPsCXWn4j85rBeuhO3zpmJrFkewGzUUr58Qp/gFk0MhICMv/trpMeclSykX9ts/JJ/XJlr8uPqs+7I5xHSSJra5zXv8pmr3QP3BDO12FavJsYtHdBkdcmln3sxdsxjbCfWOs/5ziEBjav6czRiSLfny4KN4nm5j4YajXljg4azMaP4AFknYVXXCYq2yEt43FbfrubvMY/Dj6A1glinJ3E6gaaknuNCVLuRivEuEjUkNhigz6gDc4B3/lPFzVIHOSoqtyg5ZOdOmAW2qh+iQp2BQA+s69oFoTajb5dJ+NoXrsdxAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gEnkdy6hoGumI7fXtARHMo7Wu1sus6zxdjwXW4mRN0=;
 b=G9CCWgutXYYrT2H89fHZ7GJRcejs0vS/tot5qCMhc/tf58SR3rSHTcncapfWiita4nN2LITaGCWXz9ucmwi/fWVnFgV/WeAx5coieVQh5h6jC7yxCF+97bVFDHCshSewi9kheELYkPmJXIDLwJwTyKV7UsZgqyl+gws3xM/ZMvkyuTiHDN/w4rzEo/owsAYmwXSW9oqSesomnlT78z5EQn6lQ1ltIS97E58R1m+my+l9IXI/Es09EDexNtTXFKGVJl8vvIFWAFc2YYLzz6Vt5VGMfmQyv+9ajlWk0LberUUbfSuLzylyRMA7Q2Mqrb9Ft3hqVZQDeGvEU5O1QqUBCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gEnkdy6hoGumI7fXtARHMo7Wu1sus6zxdjwXW4mRN0=;
 b=JqqxXTWssUxMYwkxKtSqU7NKhuzro8yEIVBKMahE/+R2BHa+3NrWdTWtaao69QwATW7YxRPvsx0zejW47MO3fYq8DzyH2d+Cpbsvc59gWfj3wH2dFLtlBMUqQgMQ7+Ta/WTDKzx+de8jvAnhLTzrAhQ5YYiH+r4LFj6G+0E+vNM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6157.eurprd05.prod.outlook.com (20.178.123.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 23:45:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:45:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 02/11] net/mlx5e: Determine source port properly for vlan
 push action
Thread-Topic: [net V2 02/11] net/mlx5e: Determine source port properly for
 vlan push action
Thread-Index: AQHVjrMBkkUw2qNyO0aR4PA9PhVokQ==
Date:   Tue, 29 Oct 2019 23:45:55 +0000
Message-ID: <20191029234526.3145-3-saeedm@mellanox.com>
References: <20191029234526.3145-1-saeedm@mellanox.com>
In-Reply-To: <20191029234526.3145-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR08CA0050.namprd08.prod.outlook.com
 (2603:10b6:a03:117::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d6a6153a-7118-4582-9764-08d75cca23cb
x-ms-traffictypediagnostic: VI1PR05MB6157:|VI1PR05MB6157:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6157138950582AD39535417CBE610@VI1PR05MB6157.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(6486002)(486006)(4326008)(2616005)(476003)(6512007)(66556008)(71200400001)(66446008)(66066001)(11346002)(6116002)(8676002)(54906003)(2906002)(7736002)(316002)(6916009)(81166006)(81156014)(478600001)(107886003)(8936002)(50226002)(6436002)(1076003)(446003)(25786009)(36756003)(3846002)(14454004)(71190400001)(86362001)(305945005)(14444005)(99286004)(256004)(26005)(6506007)(386003)(66476007)(76176011)(52116002)(66946007)(102836004)(186003)(64756008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6157;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0qgHN/iTpOaO8uXo6rZD5ab3dMn5HJSs/Fl3BQTvLBD3dV7vYPJCYXChCO3qSYRI+j+vB6hJhAaJRiJUDlXVpXdYOKHdxSwCIeuhxQyLKUd7WWE+mEXzlwuU7Cis662jA2RViADsaatz6Xf52aC5Qvz/BlcMqmxJzgz7Kdr0MFPuf//gbaQzTH5EqMKR2fl8BlPzlTa9YwDIKp7Oap5yjdhz3saVmha/TrB4opxiGXuzV88Gqt5221BWmu6A7HFLSiK8rIcxhOrtZR8bQzwdXdvIbhtBWyIqKbIW0ROYayx6+YLcgzCKLj4PQXH/KoOpm9/k5v/7Xs3e5y9mexW61/f3mvlVyJVpYj2jpjZJmCu9rxno5m5XUA1HpErLqf44aKzE7EMfr9aRXaY4ffAOglrsAnA8meJxSwQhGmdM3RmPbgt0PBO8xvj53JLM29Ks
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a6153a-7118-4582-9764-08d75cca23cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:45:55.3676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jUsR2y3TwOVPDB/MtT59al9OmTpAnshbx10WEcVG4CitepBmZ9TZV2cgTcB1IGHqe345dIGWXGkXCWoGzlctUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

Termination tables are used for vlan push actions on uplink ports.
To support RoCE dual port the source port value was placed in a register.
Fix the code to use an API method returning the source port according to
the FW capabilities.

Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push action=
s")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mlx5/core/eswitch_offloads_termtbl.c      | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termt=
bl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 1d55a324a17e..7879e1746297 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -177,22 +177,32 @@ mlx5_eswitch_termtbl_actions_move(struct mlx5_flow_ac=
t *src,
 	memset(&src->vlan[1], 0, sizeof(src->vlan[1]));
 }
=20
+static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch =
*esw,
+						const struct mlx5_flow_spec *spec)
+{
+	u32 port_mask, port_value;
+
+	if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source))
+		return spec->flow_context.flow_source =3D=3D MLX5_VPORT_UPLINK;
+
+	port_mask =3D MLX5_GET(fte_match_param, spec->match_criteria,
+			     misc_parameters.source_port);
+	port_value =3D MLX5_GET(fte_match_param, spec->match_value,
+			      misc_parameters.source_port);
+	return (port_mask & port_value & 0xffff) =3D=3D MLX5_VPORT_UPLINK;
+}
+
 bool
 mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 			      struct mlx5_flow_act *flow_act,
 			      struct mlx5_flow_spec *spec)
 {
-	u32 port_mask =3D MLX5_GET(fte_match_param, spec->match_criteria,
-				 misc_parameters.source_port);
-	u32 port_value =3D MLX5_GET(fte_match_param, spec->match_value,
-				  misc_parameters.source_port);
-
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table))
 		return false;
=20
 	/* push vlan on RX */
 	return (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) &&
-		((port_mask & port_value) =3D=3D MLX5_VPORT_UPLINK);
+		mlx5_eswitch_offload_is_uplink_port(esw, spec);
 }
=20
 struct mlx5_flow_handle *
--=20
2.21.0

