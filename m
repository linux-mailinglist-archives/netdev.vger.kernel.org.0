Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C27486B5B
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404769AbfHHUWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:07 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404281AbfHHUWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aw2aFOEkR5P8GnrlKufn1itdhQBPvUEmw24mti3jJiniMuNJQCAB6qdwoe81rHvJVQfShyzVhj66T86oUFbjg+0ETnaKXi3rz/IxCyBAYRvyTWlE74e6MlaD+kzceB8D3UWwwqlrdK2MuPCECMpEqrX4iQlSaOkTnDD9gkfT9Nhiu7lT/S/SzU1Bf9UkbsR/NvtpAuTjhZ9JK54jJ/aGjhWDsSQgouM0Rmxn0LIyZRv4Rt6AGaNo4EuFwGyDgs5vr81xIxp2om/ZtMlEGe+sUNsBpJssJktgDZelOQ+f8Ykc7qSExeVYmMvTXvfE0+Ygj5mkVfF12G5shPjL2F7QoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sUYbGbjDm6CYsBHmEBsd9jwNWkGlPlgHhZwhushVq8=;
 b=I2har7blJc6wHUxDpryTjXgELveQbwGMx7FizlOxhdwPLgC1abEHgmFDxft9KpceuKzXCQtUUCjVc+lasAAKVfXlGayETf+gpP8Ek0dtEGgcWf67+RyRiHESvXwN2m539SQ0aQlETx+z2iQhp5bP0LdbJ9WrNpNyvquY+WdfbwtOH0JVittkuuo73GJPRh+ysQSNmwXcBOBa9yEU2QuUGXlN15+2oWOIERqQlC/Wiie/E+dCJ2Rus7r8QAwmklum1w/+cCCYpjAKbgocm6yV05eCb/+Sf6QGfWIqObnKCdQv15JFy1Ohx7qBJiR3sCuHC5wbhpdMFVaffD/P8Meqjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sUYbGbjDm6CYsBHmEBsd9jwNWkGlPlgHhZwhushVq8=;
 b=JT7U/pvVhTW9szCfSQkCP3AOWKtO3Jmyl859S/i2bA/su0r06W4t7we+H4Ns4HYPeogoR3t/jFVxD2Vw4jMtkmMqVHtbIoMvQLOPkqDacnlWo+GjNYrPr3KtIrl8acNNEr5+IAFI8EcuzhkqQi2iYchYJEnu0DbGF02liBeiM8M=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:02 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Huy Nguyen <huyn@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 02/12] net/mlx5: Support inner header match criteria for non
 decap flow action
Thread-Topic: [net 02/12] net/mlx5: Support inner header match criteria for
 non decap flow action
Thread-Index: AQHVTibwnclfLz4LwEaV4YO+zybwEg==
Date:   Thu, 8 Aug 2019 20:22:02 +0000
Message-ID: <20190808202025.11303-3-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
In-Reply-To: <20190808202025.11303-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acad2a02-c3c7-4b19-6730-08d71c3e127d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2257E149C22E36CC92359C47BED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(14444005)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /y9BAcnU8EZbu2w30PKAN1m19UURgw55wYCJ//1nwXdiGdNiUzO5CwLdj8UBxWTalE5JV/KZi6NGgBJGZ6afCP2DRpyifqhluO7q9YXu/Y7QrCNSArrTd2b5STmHK8k2aNwEZOehSCdlvyhgxV22Uxe5UVvWXN+p/sWJVpSUjyj+LaADXfBF81oI4L6BthaNqPIhiAbakgb9HDRrAkqr6o+wYEMdVfVUnchkA32whbwPOfbRrdVF3aGRXPHbR8UhVBhLBpVKh1OgAOyLy+sPFEzQhpCnqi3jH/AZxBX10/fUl3IO2B3/BGv8gA1i8KRMnYw47E0FnsyO/TmsDVBA4KB0e6XBw6Bhazq7iA1CNUmdmc2nrr5uNspQ2ABqIRFxmxbIZABlxUg2cBSIRTyMR95255iCT6QOiZVCZJnTgJE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acad2a02-c3c7-4b19-6730-08d71c3e127d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:02.2951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QU+u4k0h1uCBXdggexdics7iO25QeA+C9J/2tmFIBKry2CY+ER2eX50BD1Izz7C7QMysw/gyYu6xv8hXhn9a7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

We have an issue that OVS application creates an offloaded drop rule
that drops VXLAN traffic with both inner and outer header match
criteria. mlx5_core driver detects correctly the inner and outer
header match criteria but does not enable the inner header match criteria
due to an incorrect assumption in mlx5_eswitch_add_offloaded_rule that
only decap rule needs inner header criteria.

Solution:
Remove mlx5_esw_flow_attr's match_level and tunnel_match_level and add
two new members: inner_match_level and outer_match_level.
inner/outer_match_level is set to NONE if the inner/outer match criteria
is not specified in the tc rule creation request. The decap assumption is
removed and the code just needs to check for inner/outer_match_level to
enable the corresponding bit in firmware's match_criteria_enable value.

Fixes: 6363651d6dd7 ("net/mlx5e: Properly set steering match levels for off=
loaded TC decap rules")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 31 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  4 +--
 .../mellanox/mlx5/core/eswitch_offloads.c     | 12 +++----
 3 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 7ecfc53cf5f6..deeb65da99f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1480,7 +1480,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv=
,
 			      struct mlx5_flow_spec *spec,
 			      struct flow_cls_offload *f,
 			      struct net_device *filter_dev,
-			      u8 *match_level, u8 *tunnel_match_level)
+			      u8 *inner_match_level, u8 *outer_match_level)
 {
 	struct netlink_ext_ack *extack =3D f->common.extack;
 	void *headers_c =3D MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
@@ -1495,8 +1495,9 @@ static int __parse_cls_flower(struct mlx5e_priv *priv=
,
 	struct flow_dissector *dissector =3D rule->match.dissector;
 	u16 addr_type =3D 0;
 	u8 ip_proto =3D 0;
+	u8 *match_level;
=20
-	*match_level =3D MLX5_MATCH_NONE;
+	match_level =3D outer_match_level;
=20
 	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_META) |
@@ -1524,12 +1525,14 @@ static int __parse_cls_flower(struct mlx5e_priv *pr=
iv,
 	}
=20
 	if (mlx5e_get_tc_tun(filter_dev)) {
-		if (parse_tunnel_attr(priv, spec, f, filter_dev, tunnel_match_level))
+		if (parse_tunnel_attr(priv, spec, f, filter_dev,
+				      outer_match_level))
 			return -EOPNOTSUPP;
=20
-		/* In decap flow, header pointers should point to the inner
+		/* At this point, header pointers should point to the inner
 		 * headers, outer header were already set by parse_tunnel_attr
 		 */
+		match_level =3D inner_match_level;
 		headers_c =3D get_match_headers_criteria(MLX5_FLOW_CONTEXT_ACTION_DECAP,
 						       spec);
 		headers_v =3D get_match_headers_value(MLX5_FLOW_CONTEXT_ACTION_DECAP,
@@ -1831,35 +1834,41 @@ static int parse_cls_flower(struct mlx5e_priv *priv=
,
 			    struct flow_cls_offload *f,
 			    struct net_device *filter_dev)
 {
+	u8 inner_match_level, outer_match_level, non_tunnel_match_level;
 	struct netlink_ext_ack *extack =3D f->common.extack;
 	struct mlx5_core_dev *dev =3D priv->mdev;
 	struct mlx5_eswitch *esw =3D dev->priv.eswitch;
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
-	u8 match_level, tunnel_match_level =3D MLX5_MATCH_NONE;
 	struct mlx5_eswitch_rep *rep;
 	int err;
=20
-	err =3D __parse_cls_flower(priv, spec, f, filter_dev, &match_level, &tunn=
el_match_level);
+	inner_match_level =3D MLX5_MATCH_NONE;
+	outer_match_level =3D MLX5_MATCH_NONE;
+
+	err =3D __parse_cls_flower(priv, spec, f, filter_dev, &inner_match_level,
+				 &outer_match_level);
+	non_tunnel_match_level =3D (inner_match_level =3D=3D MLX5_MATCH_NONE) ?
+				 outer_match_level : inner_match_level;
=20
 	if (!err && (flow->flags & MLX5E_TC_FLOW_ESWITCH)) {
 		rep =3D rpriv->rep;
 		if (rep->vport !=3D MLX5_VPORT_UPLINK &&
 		    (esw->offloads.inline_mode !=3D MLX5_INLINE_MODE_NONE &&
-		    esw->offloads.inline_mode < match_level)) {
+		    esw->offloads.inline_mode < non_tunnel_match_level)) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Flow is not offloaded due to min inline setting");
 			netdev_warn(priv->netdev,
 				    "Flow is not offloaded due to min inline setting, required %d actu=
al %d\n",
-				    match_level, esw->offloads.inline_mode);
+				    non_tunnel_match_level, esw->offloads.inline_mode);
 			return -EOPNOTSUPP;
 		}
 	}
=20
 	if (flow->flags & MLX5E_TC_FLOW_ESWITCH) {
-		flow->esw_attr->match_level =3D match_level;
-		flow->esw_attr->tunnel_match_level =3D tunnel_match_level;
+		flow->esw_attr->inner_match_level =3D inner_match_level;
+		flow->esw_attr->outer_match_level =3D outer_match_level;
 	} else {
-		flow->nic_attr->match_level =3D match_level;
+		flow->nic_attr->match_level =3D non_tunnel_match_level;
 	}
=20
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index a38e8a3c7c9a..04685dbb280c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -377,8 +377,8 @@ struct mlx5_esw_flow_attr {
 		struct mlx5_termtbl_handle *termtbl;
 	} dests[MLX5_MAX_FLOW_FWD_VPORTS];
 	u32	mod_hdr_id;
-	u8	match_level;
-	u8	tunnel_match_level;
+	u8	inner_match_level;
+	u8	outer_match_level;
 	struct mlx5_fc *counter;
 	u32	chain;
 	u16	prio;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 089ae4d48a82..0323fd078271 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -207,14 +207,10 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *=
esw,
=20
 	mlx5_eswitch_set_rule_source_port(esw, spec, attr);
=20
-	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_DECAP) {
-		if (attr->tunnel_match_level !=3D MLX5_MATCH_NONE)
-			spec->match_criteria_enable |=3D MLX5_MATCH_OUTER_HEADERS;
-		if (attr->match_level !=3D MLX5_MATCH_NONE)
-			spec->match_criteria_enable |=3D MLX5_MATCH_INNER_HEADERS;
-	} else if (attr->match_level !=3D MLX5_MATCH_NONE) {
+	if (attr->outer_match_level !=3D MLX5_MATCH_NONE)
 		spec->match_criteria_enable |=3D MLX5_MATCH_OUTER_HEADERS;
-	}
+	if (attr->inner_match_level !=3D MLX5_MATCH_NONE)
+		spec->match_criteria_enable |=3D MLX5_MATCH_INNER_HEADERS;
=20
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		flow_act.modify_id =3D attr->mod_hdr_id;
@@ -290,7 +286,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	mlx5_eswitch_set_rule_source_port(esw, spec, attr);
=20
 	spec->match_criteria_enable |=3D MLX5_MATCH_MISC_PARAMETERS;
-	if (attr->match_level !=3D MLX5_MATCH_NONE)
+	if (attr->outer_match_level !=3D MLX5_MATCH_NONE)
 		spec->match_criteria_enable |=3D MLX5_MATCH_OUTER_HEADERS;
=20
 	rule =3D mlx5_add_flow_rules(fast_fdb, spec, &flow_act, dest, i);
--=20
2.21.0

