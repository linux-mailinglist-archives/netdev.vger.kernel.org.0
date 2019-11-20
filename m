Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB06B103AAE
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbfKTNF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:29 -0500
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:19220
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728787AbfKTNF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1gMBT6Ftbk4dLadUL/iwZL9YpDWEHAgkwqFk6KNdUPVoZV+kn2shzqikP4m38L72VfW917R+xUfv3fXI8xxBsdT2fGXFwGPT5p0rMSTf5GJJqO30bWzqZIQUTH6JJkXZxgFE2fNahXm3Av0pXhR+8mohKDPaTO9dM2vsz5UoROsx8VumR2whIECVEAuJfOccMEhBXxK1uyf7jNGFoHfmPZ/op3ageCorwKa2NQgIOEjrRpegFyNk9EigY8tdFAvDSx8UKWDDCd2jSYMMhdcHICXbndzkEQsObvgYB2pNMb4EeOmZ2V0cC8dmABo56EmmHFkav/Jy/6S/XZMtm5PFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skQUc4DVZHfY0p2tzl4/qMIeRbEMMSZoWDIx+LuetPQ=;
 b=BPq7/8jJp9BVZKIkJseiV+GrqXxH8338dz16znNb93K8HMHwfn55UQkeD7HAe5qPKfkOcCpqWlBNZubexk+i89OZd6/tXCu3MKSkbaHaPb3BXJooe/VDdwP2rs5kU4zTpu68M2tJSn5E8krx3z1dNHFMyCUd3+42UewJKpn14P9ShZ5ljFEQCL8Flnqm8ahNYqHLxDyA6mrEAYAPMN2WXsJTh02Wx/p8BBSX6CHiCvSm03A5hTv43nxgcE0IPn+UjdXMLuizic+n0/3M9SmNqja5/l+Pyjls5ModMqmafLQY8qf62WHcCW/yQoecl3hCU2Jou4vkN/89J10Qsfs6Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skQUc4DVZHfY0p2tzl4/qMIeRbEMMSZoWDIx+LuetPQ=;
 b=Oba+0pdCFndSYD7d8WgXMChjR8vI+kg5G2qZoW5gEKlZww/c0eg21OQUUoH4zLg69jbKkWsyJglqLYAB+QPqpCVLIBoqxklKjAnL603PYMWrwUW7w4paaJVW4lyglx/TvIZFZlpvXWEeOdKAtIsAEI9vUjiokCkfzqF6bFsNYhI=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2982.eurprd05.prod.outlook.com (10.172.246.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 13:05:16 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:16 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 07/10] mlxsw: spectrum_qdisc: Support offloading of ETS
 Qdisc
Thread-Topic: [RFC PATCH 07/10] mlxsw: spectrum_qdisc: Support offloading of
 ETS Qdisc
Thread-Index: AQHVn6MnH8wq7xZW6EuV8qzLDh8v5A==
Date:   Wed, 20 Nov 2019 13:05:16 +0000
Message-ID: <f3d0b42937802d214b781ad40aa5d77183a34481.1574253236.git.petrm@mellanox.com>
References: <cover.1574253236.git.petrm@mellanox.com>
In-Reply-To: <cover.1574253236.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0375.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::27) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9cf29023-b5d8-4591-6652-08d76dba4962
x-ms-traffictypediagnostic: DB6PR0502MB2982:|DB6PR0502MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2982B86B927E75ADCB1F19DCDB4F0@DB6PR0502MB2982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(102836004)(1730700003)(6436002)(2616005)(446003)(50226002)(81156014)(81166006)(478600001)(66556008)(8936002)(66476007)(66946007)(14454004)(5640700003)(6506007)(2906002)(386003)(36756003)(66446008)(66066001)(8676002)(6486002)(26005)(186003)(54906003)(7736002)(316002)(6512007)(305945005)(76176011)(71190400001)(71200400001)(2351001)(256004)(64756008)(2501003)(52116002)(86362001)(486006)(6116002)(11346002)(3846002)(5660300002)(25786009)(99286004)(476003)(6916009)(4326008)(118296001)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2982;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Y8UKamyxW8fzcESfcOVKy3apXwGh8/boA4wtKnAphCqqt5tTSOH/vTAEVJp4wn/CChk6vWaEJvqr+WF3P0wNazNvRG5uLd10rdKQl9kX4MkRAGB6kiKVw69AUTkiuvZmbY/0Xaq0wHKSFHWg8xoj1Y0p0wUh/ms8EZb3j1Ey4v5J+TPgbskbEbZnekMsgMasX/dfbpcqa9PBCtIRXrsvQTEO2Bj43lSURI3FM7f/eq78cL8AIszyE6k075+dgVYGq1L6gB2dK3J7RJbiJA+0TMva//3xdtfxyO2s9+4K+liFhTr9Zde6xbDTfy9j2chZO8+fJZXPH3A/gstO2EmV9lcJK53HVAbEE6Ws0c9djmXctOSQIddNFxy0B2HH8JxcKgmo0yjl/BU6qu1yBELa2BEFy+fggO3upPmQx/h57tAhD4apsTucw0wtDK4jBWx
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf29023-b5d8-4591-6652-08d76dba4962
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:16.1283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mQnrcXoT5vkw2VSsGaLuTdCGN3AS/ARgUALvgnLS858wjcBnomIB47t6MSaY/nagT/8wi7Rwvs2ISiWBlBGAkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle TC_SETUP_QDISC_ETS, add a new ops structure for the ETS Qdisc.
Invoke the extended prio handlers implemented in the previous patch. For
stats ops, invoke directly the prio callbacks, which are not sensitive to
differences between PRIO and ETS.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 108 +++++++++++++++---
 3 files changed, 95 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.c
index cb24807c119d..48f971434eab 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1796,6 +1796,8 @@ static int mlxsw_sp_setup_tc(struct net_device *dev, =
enum tc_setup_type type,
 		return mlxsw_sp_setup_tc_red(mlxsw_sp_port, type_data);
 	case TC_SETUP_QDISC_PRIO:
 		return mlxsw_sp_setup_tc_prio(mlxsw_sp_port, type_data);
+	case TC_SETUP_QDISC_ETS:
+		return mlxsw_sp_setup_tc_ets(mlxsw_sp_port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.h
index 347bec9d1ecf..948ef4720d40 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -852,6 +852,8 @@ int mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw_s=
p_port,
 			  struct tc_red_qopt_offload *p);
 int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct tc_prio_qopt_offload *p);
+int mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct tc_ets_qopt_offload *p);
=20
 /* spectrum_fid.c */
 bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers=
/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 4cd2020bcbe0..a25a94da4995 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -18,6 +18,7 @@ enum mlxsw_sp_qdisc_type {
 	MLXSW_SP_QDISC_NO_QDISC,
 	MLXSW_SP_QDISC_RED,
 	MLXSW_SP_QDISC_PRIO,
+	MLXSW_SP_QDISC_ETS,
 };
=20
 struct mlxsw_sp_qdisc_ops {
@@ -519,36 +520,24 @@ static int
 __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 			     unsigned int nbands,
 			     unsigned int quanta[TCQ_ETS_MAX_BANDS],
+			     unsigned int weights[TCQ_ETS_MAX_BANDS],
 			     u8 priomap[TC_PRIO_MAX + 1])
 {
 	struct mlxsw_sp_qdisc *child_qdisc;
 	int tclass, i, band, backlog;
-	unsigned int w_psum_prev =3D 0;
-	unsigned int q_psum =3D 0;
-	unsigned int w_psum =3D 0;
-	unsigned int weight =3D 0;
-	unsigned int q_sum =3D 0;
-	unsigned int quantum;
 	u8 old_priomap;
 	int err;
=20
-	for (band =3D 0; band < nbands; band++)
-		q_sum +=3D quanta[band];
-
 	for (band =3D 0; band < nbands; band++) {
 		tclass =3D MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
 		child_qdisc =3D &mlxsw_sp_port->tclass_qdiscs[tclass];
 		old_priomap =3D child_qdisc->prio_bitmap;
 		child_qdisc->prio_bitmap =3D 0;
=20
-		quantum =3D quanta[band];
-		q_psum +=3D quantum;
-		w_psum =3D quantum ? q_psum * 100 / q_sum : 0;
-		weight =3D w_psum - w_psum_prev;
-		w_psum_prev =3D w_psum;
 		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
 					    MLXSW_REG_QEEC_HIERARCHY_SUBGROUP,
-					    tclass, 0, !!quantum, weight);
+					    tclass, 0, !!quanta[band],
+					    weights[band]);
 		if (err)
 			return err;
=20
@@ -589,10 +578,10 @@ mlxsw_sp_qdisc_prio_replace(struct mlxsw_sp_port *mlx=
sw_sp_port,
 			    void *params)
 {
 	struct tc_prio_qopt_offload_params *p =3D params;
-	unsigned int quanta[TCQ_ETS_MAX_BANDS] =3D {0};
+	unsigned int zeroes[TCQ_ETS_MAX_BANDS] =3D {0};
=20
 	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, p->bands,
-					    quanta, p->priomap);
+					    zeroes, zeroes, p->priomap);
 }
=20
 static void
@@ -692,6 +681,55 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_pr=
io =3D {
 	.clean_stats =3D mlxsw_sp_setup_tc_qdisc_prio_clean_stats,
 };
=20
+static int
+mlxsw_sp_qdisc_ets_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
+				struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+				void *params)
+{
+	struct tc_ets_qopt_offload_replace_params *p =3D params;
+
+	return __mlxsw_sp_qdisc_ets_check_params(p->bands);
+}
+
+static int
+mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			   void *params)
+{
+	struct tc_ets_qopt_offload_replace_params *p =3D params;
+
+	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, p->bands,
+					    p->quanta, p->weights, p->priomap);
+}
+
+static void
+mlxsw_sp_qdisc_ets_unoffload(struct mlxsw_sp_port *mlxsw_sp_port,
+			     struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			     void *params)
+{
+	struct tc_ets_qopt_offload_replace_params *p =3D params;
+
+	__mlxsw_sp_qdisc_ets_unoffload(mlxsw_sp_port, mlxsw_sp_qdisc,
+				       p->qstats);
+}
+
+static int
+mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+{
+	return __mlxsw_sp_qdisc_ets_destroy(mlxsw_sp_port);
+}
+
+static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_ets =3D {
+	.type =3D MLXSW_SP_QDISC_ETS,
+	.check_params =3D mlxsw_sp_qdisc_ets_check_params,
+	.replace =3D mlxsw_sp_qdisc_ets_replace,
+	.unoffload =3D mlxsw_sp_qdisc_ets_unoffload,
+	.destroy =3D mlxsw_sp_qdisc_ets_destroy,
+	.get_stats =3D mlxsw_sp_qdisc_get_prio_stats,
+	.clean_stats =3D mlxsw_sp_setup_tc_qdisc_prio_clean_stats,
+};
+
 /* Linux allows linking of Qdiscs to arbitrary classes (so long as the res=
ulting
  * graph is free of cycles). These operations do not change the parent han=
dle
  * though, which means it can be incomplete (if there is more than one cla=
ss
@@ -764,6 +802,42 @@ int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw=
_sp_port,
 	}
 }
=20
+int mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct tc_ets_qopt_offload *p)
+{
+	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
+
+	mlxsw_sp_qdisc =3D mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent, true);
+	if (!mlxsw_sp_qdisc)
+		return -EOPNOTSUPP;
+
+	if (p->command =3D=3D TC_ETS_REPLACE)
+		return mlxsw_sp_qdisc_replace(mlxsw_sp_port, p->handle,
+					      mlxsw_sp_qdisc,
+					      &mlxsw_sp_qdisc_ops_ets,
+					      &p->replace_params);
+
+	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle,
+				    MLXSW_SP_QDISC_ETS))
+		return -EOPNOTSUPP;
+
+	switch (p->command) {
+	case TC_ETS_DESTROY:
+		return mlxsw_sp_qdisc_destroy(mlxsw_sp_port, mlxsw_sp_qdisc);
+	case TC_ETS_STATS:
+		return mlxsw_sp_qdisc_get_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
+						&p->stats);
+	case TC_ETS_GRAFT:
+		return __mlxsw_sp_qdisc_ets_graft(mlxsw_sp_port, mlxsw_sp_qdisc,
+						  p->graft_params.band,
+						  p->graft_params.child_handle);
+	case TC_ETS_REPLACE: /* Covered above. */
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
--=20
2.20.1

