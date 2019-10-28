Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A74DE7D06
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732232AbfJ1Xfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:40 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:38254
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732001AbfJ1Xfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uf3PnM7m1c8EPX0tZ67J99LMXvud1h9431wDbnZwO1OTLY+h+uITGodi+m142gdF0w8FlZ6X+rjq4Py7AJNKt7r9QCgmbsXLVPgM1H+AAwDHJqMz0e+3jTnENh2JX1ITXImkjWSZgPX0zb5X+skUEZ7ih1VqWOVfLeAe2Pq8zkVeIYlRLQr/3CPYcPoSdyC2M2NPZIPQuw4dMxPn4QrNQHSknRFWdH23o4uXn+YEBC5At4XkEUnmRkkiC/9zmbSmLRtjxKPr7lFuTFhkgbphnOU2sE6YKA9dY6I3c79vZuFQtGEeAERguMDRZKoWqIaQo5G5qeITxYgTrLUMNtnkrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TB0pQF++iq6Dx+Q0Sx8hjfG7DiWa+CIwbZ1UcIjQyQ=;
 b=XibxWiCIjYMY4xnAmblxkdUWiV6MnpjSiZAwIra9P/XzE/uP+NscWN4BfVxjCwMTkIyj6717arPz/SljF9JuCzmoC/lHhC8cmT5KG8QDyTGthro2CINFQc4L+bcKaMkoYxKGRhArAmIxTbZyTVmaCCsqNtHoRNrvypgwFHanx59kzXBx4f8ktdnQcI9o6YBRbv/waFSjP8Dc9Bk8Omyp7N2EMe680cxkpnW8E8fWB9FsQGLqrLXv/z3dLmhJ4GOkqD7kGceVPBlRcTbrnTXvwff4iijZo440OdyVKAN0Bv3lypqfcTvLCgdZzMMzSMG0qI58L9WjVDokwRi/8h74VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TB0pQF++iq6Dx+Q0Sx8hjfG7DiWa+CIwbZ1UcIjQyQ=;
 b=IzbrwwqU3SBIhdszRx/mkiTDj11CvdjyEDB3lDgq2QHIPPQzXajZfkQAz/9LGrrftAobCLiJv1UC0tvgleoQRDLakQv+9Pw375gXC3JS5EOtplV46V+e8gTlCEXpB36/QISlKp2Jk9RkxcY/p3fnSjgA3CKL46ZJvL3P58Sv4X0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4768.eurprd05.prod.outlook.com (20.176.7.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Mon, 28 Oct 2019 23:35:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 16/18] net/mlx5: Refactor ingress acl configuration
Thread-Topic: [PATCH mlx5-next 16/18] net/mlx5: Refactor ingress acl
 configuration
Thread-Index: AQHVjehgUs2viunmUUaM/8V/gxDocQ==
Date:   Mon, 28 Oct 2019 23:35:26 +0000
Message-ID: <20191028233440.5564-17-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: e360fd9f-b53f-48eb-e740-08d75bff82ab
x-ms-traffictypediagnostic: VI1PR05MB4768:|VI1PR05MB4768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4768FB212D2D3F595BC89D24BE660@VI1PR05MB4768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(189003)(199004)(186003)(2616005)(81166006)(446003)(476003)(1076003)(25786009)(14454004)(386003)(478600001)(6506007)(76176011)(52116002)(99286004)(102836004)(26005)(6636002)(11346002)(66446008)(36756003)(30864003)(14444005)(256004)(305945005)(66066001)(8676002)(7736002)(107886003)(50226002)(4326008)(71200400001)(86362001)(8936002)(6486002)(71190400001)(6512007)(450100002)(6436002)(3846002)(6116002)(316002)(486006)(110136005)(54906003)(66946007)(5660300002)(66476007)(64756008)(66556008)(2906002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4768;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vI78/tGJYrQPqzT3EdnSHVLRrkWRMUw45BV7TDYwxKzeMF3Hyxbc4SiMy5nYALtZiRUTRSlImorgFju+xCcuPlqH5Q6WQGqwueWJASJ1te1aGYZGkvCzofRZcsmCb1xvqmksJoCzXLHE0bQpMzAAI+vhxvA5vo5vLwtm+depxfBB/wzOC4iCgGLRyfWfQHiJtP2IhaD1fNI2Xz/rmksSCvJTv1W+oWHhDwLdl+U2zBXPD/4wi1spf/fttMNYDwSEu0Kc11kVKufDv1cOejwz+3cATxKAMTk5dmdCM7lUWJIwR/zcjjHj4HJD6NArBSP6FcJkkUoAIeSViJ28WAgfoIBGRRoWxQmHeBN8Xd1GN14epHt1OREB9hP2XF3v85+58VLk7g1H9p6xX5YKGtWyGpbeH/EQ9tCIsy55W55j404SpHOUZ9ICEdFwgxTCL5DI
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e360fd9f-b53f-48eb-e740-08d75bff82ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:26.6484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AKnMUbZYt9bzmDxBmU9gD5MHsTVKMB08Cc0UultgAYzBo3MgE/LdT21owjCNgs3Nq6jY+KHjl3sm5SujUezGTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Drop, untagged, spoof check and untagged spoof check flow groups are
limited to legacy mode only.

Therefore, following refactoring is done to
(a) improve code readability
(b) have better code split between legacy and offloads mode

1. Move legacy flow groups under legacy structure
2. Add validity check for group deletion
3. Restrict scope of esw_vport_disable_ingress_acl to legacy mode
4. Rename esw_vport_enable_ingress_acl() to
esw_vport_create_ingress_acl_table() and limit its scope to
table creation
5. Introduce legacy flow groups creation helper
esw_legacy_create_ingress_acl_groups() and keep its scope to legacy mode
6. Reduce offloads ingress groups from 4 to just 1 metadata group
per vport
7. Removed redundant IS_ERR_OR_NULL as entries are marked NULL on free.
8. Shortern error message to remove redundant 'E-switch'

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 228 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  19 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  67 ++++-
 3 files changed, 200 insertions(+), 114 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 61459c06f56c..cc8d43d8c469 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1070,57 +1070,21 @@ void esw_vport_disable_egress_acl(struct mlx5_eswit=
ch *esw,
 	vport->egress.acl =3D NULL;
 }
=20
-int esw_vport_enable_ingress_acl(struct mlx5_eswitch *esw,
-				 struct mlx5_vport *vport)
+static int
+esw_vport_create_legacy_ingress_acl_groups(struct mlx5_eswitch *esw,
+					   struct mlx5_vport *vport)
 {
 	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_core_dev *dev =3D esw->dev;
-	struct mlx5_flow_namespace *root_ns;
-	struct mlx5_flow_table *acl;
 	struct mlx5_flow_group *g;
 	void *match_criteria;
 	u32 *flow_group_in;
-	/* The ingress acl table contains 4 groups
-	 * (2 active rules at the same time -
-	 *      1 allow rule from one of the first 3 groups.
-	 *      1 drop rule from the last group):
-	 * 1)Allow untagged traffic with smac=3Doriginal mac.
-	 * 2)Allow untagged traffic.
-	 * 3)Allow traffic with smac=3Doriginal mac.
-	 * 4)Drop all other traffic.
-	 */
-	int table_size =3D 4;
-	int err =3D 0;
-
-	if (!MLX5_CAP_ESW_INGRESS_ACL(dev, ft_support))
-		return -EOPNOTSUPP;
-
-	if (!IS_ERR_OR_NULL(vport->ingress.acl))
-		return 0;
-
-	esw_debug(dev, "Create vport[%d] ingress ACL log_max_size(%d)\n",
-		  vport->vport, MLX5_CAP_ESW_INGRESS_ACL(dev, log_max_ft_size));
-
-	root_ns =3D mlx5_get_flow_vport_acl_namespace(dev, MLX5_FLOW_NAMESPACE_ES=
W_INGRESS,
-			mlx5_eswitch_vport_num_to_index(esw, vport->vport));
-	if (!root_ns) {
-		esw_warn(dev, "Failed to get E-Switch ingress flow namespace for vport (=
%d)\n", vport->vport);
-		return -EOPNOTSUPP;
-	}
+	int err;
=20
 	flow_group_in =3D kvzalloc(inlen, GFP_KERNEL);
 	if (!flow_group_in)
 		return -ENOMEM;
=20
-	acl =3D mlx5_create_vport_flow_table(root_ns, 0, table_size, 0, vport->vp=
ort);
-	if (IS_ERR(acl)) {
-		err =3D PTR_ERR(acl);
-		esw_warn(dev, "Failed to create E-Switch vport[%d] ingress flow Table, e=
rr(%d)\n",
-			 vport->vport, err);
-		goto out;
-	}
-	vport->ingress.acl =3D acl;
-
 	match_criteria =3D MLX5_ADDR_OF(create_flow_group_in, flow_group_in, matc=
h_criteria);
=20
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable, MLX5=
_MATCH_OUTER_HEADERS);
@@ -1130,14 +1094,14 @@ int esw_vport_enable_ingress_acl(struct mlx5_eswitc=
h *esw,
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
=20
-	g =3D mlx5_create_flow_group(acl, flow_group_in);
+	g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
 	if (IS_ERR(g)) {
 		err =3D PTR_ERR(g);
-		esw_warn(dev, "Failed to create E-Switch vport[%d] ingress untagged spoo=
fchk flow group, err(%d)\n",
+		esw_warn(dev, "vport[%d] ingress create untagged spoofchk flow group, er=
r(%d)\n",
 			 vport->vport, err);
-		goto out;
+		goto spoof_err;
 	}
-	vport->ingress.allow_untagged_spoofchk_grp =3D g;
+	vport->ingress.legacy.allow_untagged_spoofchk_grp =3D g;
=20
 	memset(flow_group_in, 0, inlen);
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable, MLX5=
_MATCH_OUTER_HEADERS);
@@ -1145,14 +1109,14 @@ int esw_vport_enable_ingress_acl(struct mlx5_eswitc=
h *esw,
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
=20
-	g =3D mlx5_create_flow_group(acl, flow_group_in);
+	g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
 	if (IS_ERR(g)) {
 		err =3D PTR_ERR(g);
-		esw_warn(dev, "Failed to create E-Switch vport[%d] ingress untagged flow=
 group, err(%d)\n",
+		esw_warn(dev, "vport[%d] ingress create untagged flow group, err(%d)\n",
 			 vport->vport, err);
-		goto out;
+		goto untagged_err;
 	}
-	vport->ingress.allow_untagged_only_grp =3D g;
+	vport->ingress.legacy.allow_untagged_only_grp =3D g;
=20
 	memset(flow_group_in, 0, inlen);
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable, MLX5=
_MATCH_OUTER_HEADERS);
@@ -1161,80 +1125,134 @@ int esw_vport_enable_ingress_acl(struct mlx5_eswit=
ch *esw,
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 2);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 2);
=20
-	g =3D mlx5_create_flow_group(acl, flow_group_in);
+	g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
 	if (IS_ERR(g)) {
 		err =3D PTR_ERR(g);
-		esw_warn(dev, "Failed to create E-Switch vport[%d] ingress spoofchk flow=
 group, err(%d)\n",
+		esw_warn(dev, "vport[%d] ingress create spoofchk flow group, err(%d)\n",
 			 vport->vport, err);
-		goto out;
+		goto allow_spoof_err;
 	}
-	vport->ingress.allow_spoofchk_only_grp =3D g;
+	vport->ingress.legacy.allow_spoofchk_only_grp =3D g;
=20
 	memset(flow_group_in, 0, inlen);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 3);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 3);
=20
-	g =3D mlx5_create_flow_group(acl, flow_group_in);
+	g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
 	if (IS_ERR(g)) {
 		err =3D PTR_ERR(g);
-		esw_warn(dev, "Failed to create E-Switch vport[%d] ingress drop flow gro=
up, err(%d)\n",
+		esw_warn(dev, "vport[%d] ingress create drop flow group, err(%d)\n",
 			 vport->vport, err);
-		goto out;
+		goto drop_err;
 	}
-	vport->ingress.drop_grp =3D g;
+	vport->ingress.legacy.drop_grp =3D g;
+	kvfree(flow_group_in);
+	return 0;
=20
-out:
-	if (err) {
-		if (!IS_ERR_OR_NULL(vport->ingress.allow_spoofchk_only_grp))
-			mlx5_destroy_flow_group(
-					vport->ingress.allow_spoofchk_only_grp);
-		if (!IS_ERR_OR_NULL(vport->ingress.allow_untagged_only_grp))
-			mlx5_destroy_flow_group(
-					vport->ingress.allow_untagged_only_grp);
-		if (!IS_ERR_OR_NULL(vport->ingress.allow_untagged_spoofchk_grp))
-			mlx5_destroy_flow_group(
-				vport->ingress.allow_untagged_spoofchk_grp);
-		if (!IS_ERR_OR_NULL(vport->ingress.acl))
-			mlx5_destroy_flow_table(vport->ingress.acl);
+drop_err:
+	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_spoofchk_only_grp)) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_spoofchk_only_grp);
+		vport->ingress.legacy.allow_spoofchk_only_grp =3D NULL;
 	}
-
+allow_spoof_err:
+	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_untagged_only_grp)) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_only_grp);
+		vport->ingress.legacy.allow_untagged_only_grp =3D NULL;
+	}
+untagged_err:
+	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_untagged_spoofchk_grp)) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_spoofchk_gr=
p);
+		vport->ingress.legacy.allow_untagged_spoofchk_grp =3D NULL;
+	}
+spoof_err:
 	kvfree(flow_group_in);
 	return err;
 }
=20
+int esw_vport_create_ingress_acl_table(struct mlx5_eswitch *esw,
+				       struct mlx5_vport *vport, int table_size)
+{
+	struct mlx5_core_dev *dev =3D esw->dev;
+	struct mlx5_flow_namespace *root_ns;
+	struct mlx5_flow_table *acl;
+	int vport_index;
+	int err;
+
+	if (!MLX5_CAP_ESW_INGRESS_ACL(dev, ft_support))
+		return -EOPNOTSUPP;
+
+	esw_debug(dev, "Create vport[%d] ingress ACL log_max_size(%d)\n",
+		  vport->vport, MLX5_CAP_ESW_INGRESS_ACL(dev, log_max_ft_size));
+
+	vport_index =3D mlx5_eswitch_vport_num_to_index(esw, vport->vport);
+	root_ns =3D mlx5_get_flow_vport_acl_namespace(dev, MLX5_FLOW_NAMESPACE_ES=
W_INGRESS,
+						    vport_index);
+	if (!root_ns) {
+		esw_warn(dev, "Failed to get E-Switch ingress flow namespace for vport (=
%d)\n",
+			 vport->vport);
+		return -EOPNOTSUPP;
+	}
+
+	acl =3D mlx5_create_vport_flow_table(root_ns, 0, table_size, 0, vport->vp=
ort);
+	if (IS_ERR(acl)) {
+		err =3D PTR_ERR(acl);
+		esw_warn(dev, "vport[%d] ingress create flow Table, err(%d)\n",
+			 vport->vport, err);
+		return err;
+	}
+	vport->ingress.acl =3D acl;
+	return 0;
+}
+
+void esw_vport_destroy_ingress_acl_table(struct mlx5_vport *vport)
+{
+	if (!vport->ingress.acl)
+		return;
+
+	mlx5_destroy_flow_table(vport->ingress.acl);
+	vport->ingress.acl =3D NULL;
+}
+
 void esw_vport_cleanup_ingress_rules(struct mlx5_eswitch *esw,
 				     struct mlx5_vport *vport)
 {
-	if (!IS_ERR_OR_NULL(vport->ingress.legacy.drop_rule)) {
+	if (vport->ingress.legacy.drop_rule) {
 		mlx5_del_flow_rules(vport->ingress.legacy.drop_rule);
 		vport->ingress.legacy.drop_rule =3D NULL;
 	}
=20
-	if (!IS_ERR_OR_NULL(vport->ingress.allow_rule)) {
+	if (vport->ingress.allow_rule) {
 		mlx5_del_flow_rules(vport->ingress.allow_rule);
 		vport->ingress.allow_rule =3D NULL;
 	}
 }
=20
-void esw_vport_disable_ingress_acl(struct mlx5_eswitch *esw,
-				   struct mlx5_vport *vport)
+static void esw_vport_disable_legacy_ingress_acl(struct mlx5_eswitch *esw,
+						 struct mlx5_vport *vport)
 {
-	if (IS_ERR_OR_NULL(vport->ingress.acl))
+	if (!vport->ingress.acl)
 		return;
=20
 	esw_debug(esw->dev, "Destroy vport[%d] E-Switch ingress ACL\n", vport->vp=
ort);
=20
 	esw_vport_cleanup_ingress_rules(esw, vport);
-	mlx5_destroy_flow_group(vport->ingress.allow_spoofchk_only_grp);
-	mlx5_destroy_flow_group(vport->ingress.allow_untagged_only_grp);
-	mlx5_destroy_flow_group(vport->ingress.allow_untagged_spoofchk_grp);
-	mlx5_destroy_flow_group(vport->ingress.drop_grp);
-	mlx5_destroy_flow_table(vport->ingress.acl);
-	vport->ingress.acl =3D NULL;
-	vport->ingress.drop_grp =3D NULL;
-	vport->ingress.allow_spoofchk_only_grp =3D NULL;
-	vport->ingress.allow_untagged_only_grp =3D NULL;
-	vport->ingress.allow_untagged_spoofchk_grp =3D NULL;
+	if (vport->ingress.legacy.allow_spoofchk_only_grp) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_spoofchk_only_grp);
+		vport->ingress.legacy.allow_spoofchk_only_grp =3D NULL;
+	}
+	if (vport->ingress.legacy.allow_untagged_only_grp) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_only_grp);
+		vport->ingress.legacy.allow_untagged_only_grp =3D NULL;
+	}
+	if (vport->ingress.legacy.allow_untagged_spoofchk_grp) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_spoofchk_gr=
p);
+		vport->ingress.legacy.allow_untagged_spoofchk_grp =3D NULL;
+	}
+	if (vport->ingress.legacy.drop_grp) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.drop_grp);
+		vport->ingress.legacy.drop_grp =3D NULL;
+	}
+	esw_vport_destroy_ingress_acl_table(vport);
 }
=20
 static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
@@ -1249,19 +1267,36 @@ static int esw_vport_ingress_config(struct mlx5_esw=
itch *esw,
 	int err =3D 0;
 	u8 *smac_v;
=20
+	/* The ingress acl table contains 4 groups
+	 * (2 active rules at the same time -
+	 *      1 allow rule from one of the first 3 groups.
+	 *      1 drop rule from the last group):
+	 * 1)Allow untagged traffic with smac=3Doriginal mac.
+	 * 2)Allow untagged traffic.
+	 * 3)Allow traffic with smac=3Doriginal mac.
+	 * 4)Drop all other traffic.
+	 */
+	int table_size =3D 4;
+
 	esw_vport_cleanup_ingress_rules(esw, vport);
=20
 	if (!vport->info.vlan && !vport->info.qos && !vport->info.spoofchk) {
-		esw_vport_disable_ingress_acl(esw, vport);
+		esw_vport_disable_legacy_ingress_acl(esw, vport);
 		return 0;
 	}
=20
-	err =3D esw_vport_enable_ingress_acl(esw, vport);
-	if (err) {
-		mlx5_core_warn(esw->dev,
-			       "failed to enable ingress acl (%d) on vport[%d]\n",
-			       err, vport->vport);
-		return err;
+	if (!vport->ingress.acl) {
+		err =3D esw_vport_create_ingress_acl_table(esw, vport, table_size);
+		if (err) {
+			esw_warn(esw->dev,
+				 "vport[%d] enable ingress acl err (%d)\n",
+				 err, vport->vport);
+			return err;
+		}
+
+		err =3D esw_vport_create_legacy_ingress_acl_groups(esw, vport);
+		if (err)
+			goto out;
 	}
=20
 	esw_debug(esw->dev,
@@ -1322,10 +1357,11 @@ static int esw_vport_ingress_config(struct mlx5_esw=
itch *esw,
 		vport->ingress.legacy.drop_rule =3D NULL;
 		goto out;
 	}
+	kvfree(spec);
+	return 0;
=20
 out:
-	if (err)
-		esw_vport_cleanup_ingress_rules(esw, vport);
+	esw_vport_disable_legacy_ingress_acl(esw, vport);
 	kvfree(spec);
 	return err;
 }
@@ -1705,7 +1741,7 @@ static int esw_vport_create_legacy_acl_tables(struct =
mlx5_eswitch *esw,
 	return 0;
=20
 egress_err:
-	esw_vport_disable_ingress_acl(esw, vport);
+	esw_vport_disable_legacy_ingress_acl(esw, vport);
 	mlx5_fc_destroy(esw->dev, vport->egress.legacy.drop_counter);
 	vport->egress.legacy.drop_counter =3D NULL;
=20
@@ -1735,7 +1771,7 @@ static void esw_vport_destroy_legacy_acl_tables(struc=
t mlx5_eswitch *esw,
 	mlx5_fc_destroy(esw->dev, vport->egress.legacy.drop_counter);
 	vport->egress.legacy.drop_counter =3D NULL;
=20
-	esw_vport_disable_ingress_acl(esw, vport);
+	esw_vport_disable_legacy_ingress_acl(esw, vport);
 	mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
 	vport->ingress.legacy.drop_counter =3D NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index aa3588446cba..5e91735726b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -65,16 +65,17 @@
=20
 struct vport_ingress {
 	struct mlx5_flow_table *acl;
-	struct mlx5_flow_group *allow_untagged_spoofchk_grp;
-	struct mlx5_flow_group *allow_spoofchk_only_grp;
-	struct mlx5_flow_group *allow_untagged_only_grp;
-	struct mlx5_flow_group *drop_grp;
-	struct mlx5_flow_handle  *allow_rule;
+	struct mlx5_flow_handle *allow_rule;
 	struct {
+		struct mlx5_flow_group *allow_spoofchk_only_grp;
+		struct mlx5_flow_group *allow_untagged_spoofchk_grp;
+		struct mlx5_flow_group *allow_untagged_only_grp;
+		struct mlx5_flow_group *drop_grp;
 		struct mlx5_flow_handle *drop_rule;
 		struct mlx5_fc *drop_counter;
 	} legacy;
 	struct {
+		struct mlx5_flow_group *metadata_grp;
 		struct mlx5_modify_hdr *modify_metadata;
 		struct mlx5_flow_handle *modify_metadata_rule;
 	} offloads;
@@ -257,16 +258,16 @@ void esw_offloads_cleanup_reps(struct mlx5_eswitch *e=
sw);
 int esw_offloads_init_reps(struct mlx5_eswitch *esw);
 void esw_vport_cleanup_ingress_rules(struct mlx5_eswitch *esw,
 				     struct mlx5_vport *vport);
-int esw_vport_enable_ingress_acl(struct mlx5_eswitch *esw,
-				 struct mlx5_vport *vport);
+int esw_vport_create_ingress_acl_table(struct mlx5_eswitch *esw,
+				       struct mlx5_vport *vport,
+				       int table_size);
+void esw_vport_destroy_ingress_acl_table(struct mlx5_vport *vport);
 void esw_vport_cleanup_egress_rules(struct mlx5_eswitch *esw,
 				    struct mlx5_vport *vport);
 int esw_vport_enable_egress_acl(struct mlx5_eswitch *esw,
 				struct mlx5_vport *vport);
 void esw_vport_disable_egress_acl(struct mlx5_eswitch *esw,
 				  struct mlx5_vport *vport);
-void esw_vport_disable_ingress_acl(struct mlx5_eswitch *esw,
-				   struct mlx5_vport *vport);
 int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
 			       u32 rate_mbps);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b536c8fa0061..807372a7211b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1858,6 +1858,44 @@ static void esw_vport_del_ingress_acl_modify_metadat=
a(struct mlx5_eswitch *esw,
 	}
 }
=20
+static int esw_vport_create_ingress_acl_group(struct mlx5_eswitch *esw,
+					      struct mlx5_vport *vport)
+{
+	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *g;
+	u32 *flow_group_in;
+	int ret =3D 0;
+
+	flow_group_in =3D kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in)
+		return -ENOMEM;
+
+	memset(flow_group_in, 0, inlen);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
+
+	g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
+	if (IS_ERR(g)) {
+		ret =3D PTR_ERR(g);
+		esw_warn(esw->dev,
+			 "Failed to create vport[%d] ingress metdata group, err(%d)\n",
+			 vport->vport, ret);
+		goto grp_err;
+	}
+	vport->ingress.offloads.metadata_grp =3D g;
+grp_err:
+	kvfree(flow_group_in);
+	return ret;
+}
+
+static void esw_vport_destroy_ingress_acl_group(struct mlx5_vport *vport)
+{
+	if (vport->ingress.offloads.metadata_grp) {
+		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_grp);
+		vport->ingress.offloads.metadata_grp =3D NULL;
+	}
+}
+
 static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
 				    struct mlx5_vport *vport)
 {
@@ -1868,8 +1906,7 @@ static int esw_vport_ingress_config(struct mlx5_eswit=
ch *esw,
 		return 0;
=20
 	esw_vport_cleanup_ingress_rules(esw, vport);
-
-	err =3D esw_vport_enable_ingress_acl(esw, vport);
+	err =3D esw_vport_create_ingress_acl_table(esw, vport, 1);
 	if (err) {
 		esw_warn(esw->dev,
 			 "failed to enable ingress acl (%d) on vport[%d]\n",
@@ -1877,25 +1914,34 @@ static int esw_vport_ingress_config(struct mlx5_esw=
itch *esw,
 		return err;
 	}
=20
+	err =3D esw_vport_create_ingress_acl_group(esw, vport);
+	if (err)
+		goto group_err;
+
 	esw_debug(esw->dev,
 		  "vport[%d] configure ingress rules\n", vport->vport);
=20
 	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
 		err =3D esw_vport_add_ingress_acl_modify_metadata(esw, vport);
 		if (err)
-			goto out;
+			goto metadata_err;
 	}
=20
 	if (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
 	    mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
 		err =3D esw_vport_ingress_prio_tag_config(esw, vport);
 		if (err)
-			goto out;
+			goto prio_tag_err;
 	}
+	return 0;
=20
-out:
-	if (err)
-		esw_vport_disable_ingress_acl(esw, vport);
+prio_tag_err:
+	esw_vport_del_ingress_acl_modify_metadata(esw, vport);
+metadata_err:
+	esw_vport_cleanup_ingress_rules(esw, vport);
+	esw_vport_destroy_ingress_acl_group(vport);
+group_err:
+	esw_vport_destroy_ingress_acl_table(vport);
 	return err;
 }
=20
@@ -1964,7 +2010,8 @@ esw_vport_create_offloads_acl_tables(struct mlx5_eswi=
tch *esw,
 		err =3D esw_vport_egress_config(esw, vport);
 		if (err) {
 			esw_vport_del_ingress_acl_modify_metadata(esw, vport);
-			esw_vport_disable_ingress_acl(esw, vport);
+			esw_vport_cleanup_ingress_rules(esw, vport);
+			esw_vport_destroy_ingress_acl_table(vport);
 		}
 	}
 	return err;
@@ -1976,7 +2023,9 @@ esw_vport_destroy_offloads_acl_tables(struct mlx5_esw=
itch *esw,
 {
 	esw_vport_disable_egress_acl(esw, vport);
 	esw_vport_del_ingress_acl_modify_metadata(esw, vport);
-	esw_vport_disable_ingress_acl(esw, vport);
+	esw_vport_cleanup_ingress_rules(esw, vport);
+	esw_vport_destroy_ingress_acl_group(vport);
+	esw_vport_destroy_ingress_acl_table(vport);
 }
=20
 static int esw_create_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
--=20
2.21.0

