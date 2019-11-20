Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A38103AAC
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbfKTNFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:31 -0500
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:50305
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728825AbfKTNFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwSeAExncrHItTTWOzE95k/C8wwbyHWc6ChGe634k6uGdtWIECOSSa0LxejFvbPWSiC0tyYZIq/zhVHb++9T0RvqeiOvP4eTpHDRqpCygtQVwz8UqOHXxzQuMCiED3Rdjw81VDMF1XRFFw/72epfWZJhG5LJB6mDbmhRcp4ZxyMR4J+Cc7vtmA1l+KhHdF2/ncV6tHPpRHReCZS10Fm7jd1Wo5iFpGqdDwfvIADoaik2O3nQn3amHB4RkLGfuS8xcP6i5kuBwL9Fy0xpdPGwr47FV30p/GEe4qJtlIrxYLoqKqoFhX8aByAwakyVpoRkWfPtaKjIhPEA+SbVKKVb2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEKHq8DLGwR6NGLQA4SSSiN5ueREfWjsoA7wJra63Fc=;
 b=hK7URg0cZdfIFYGE0p0ab02NXWmnIbnSLJ6kuh886v/ovz/ucRZKF4tLJ1eEKOjvA5rDj+A4/Dti6udV6iSss+FCMPrBUkveSNd2X++SrOqCdXAJzmnuU8LMg/94ELXiOX7tygpntb6U7V5YMu5jHUODO82JMfhNx2SS0rZ4tw9Bpi9sntimx2FKgYrCgXAbeBJDpFvF3s8WBTEUgksNec57KmQjZR9Tp3FNn14qaeO3l1/K6DRIG3OpjSqEy74M2C9Dofdeb6EDOQaxoeLG/bwTG6ZWExWOYTcOv5g5Tm96I651leJfEFZrYfvgOpzazPlIMDKsp+xZ/JW7OYRxUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEKHq8DLGwR6NGLQA4SSSiN5ueREfWjsoA7wJra63Fc=;
 b=smHneqjDBDX7GyScPLBCzBf1MfRJe4BucYvZWu+26XRHM7ZwNy+Iuz6poZBJyI0P0gL0dE+bbk5DUq9RK9VTUUCIFKu/LMtO1BrgzcPJXWxCUYacCyVwC+dEkCyNNiYadV3OSVyB2Ecafxz/K1zlrixlRjMQ2C5ybFcrspE+SiU=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2982.eurprd05.prod.outlook.com (10.172.246.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 13:05:16 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:15 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 06/10] mlxsw: spectrum_qdisc: Generalize PRIO offload to
 support ETS
Thread-Topic: [RFC PATCH 06/10] mlxsw: spectrum_qdisc: Generalize PRIO offload
 to support ETS
Thread-Index: AQHVn6MmGt23PisCykS0Om4G8MJQmA==
Date:   Wed, 20 Nov 2019 13:05:15 +0000
Message-ID: <1d075c62c7dc5d696e27ffbc809e8118f2083b30.1574253236.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 7a85dd7c-777d-47bb-4cdc-08d76dba48c5
x-ms-traffictypediagnostic: DB6PR0502MB2982:|DB6PR0502MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2982D09FF29EC56E4739B8F8DB4F0@DB6PR0502MB2982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(102836004)(1730700003)(6436002)(2616005)(446003)(50226002)(81156014)(81166006)(478600001)(66556008)(8936002)(66476007)(66946007)(14454004)(5640700003)(6506007)(2906002)(386003)(36756003)(66446008)(66066001)(8676002)(6486002)(26005)(186003)(54906003)(7736002)(316002)(6512007)(305945005)(76176011)(71190400001)(71200400001)(2351001)(256004)(64756008)(2501003)(52116002)(86362001)(486006)(6116002)(11346002)(3846002)(5660300002)(25786009)(99286004)(476003)(6916009)(4326008)(118296001)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2982;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E72UdLadfsmPUkZC+8z4YBsa0UkiJaJCjNXALmcoj2+/UksA6T2YxnHSwSX6Eci3ANemlobEhDkevvG+MxhJUcLOBXk9W8/+fkuALdf/eON6W1UP17yNloPYBKIezpyjAcufB6L9KXsYnJykDLRGq7Ld2FW21B6VPt1FK65gpWxMqO7k4WESw3PNif04LDVcGBlasCwVGsi0N/ytxnN74Yfj+x00X54ADt/LAlJfkfogf0taNgY4ZHvNCPGSiCM7vYoLTx2zGNwTolOlmK4w7rGCqRQHtej226UmyvYlhrnzMLBA9KJzhyi/tepUXf39meVIvHuGs4vyRewM95hMsg6qT/CPLN8L7Ve/zCCF4aa4rfJYL6gG7qHsYRFWMmMafEZSQXJQUSDGnAgLjx1EyWrEybuL34DldOYGOsGrZqmeubaFxizAnKgvDCdGhT0Y
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a85dd7c-777d-47bb-4cdc-08d76dba48c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:15.1177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l7C+aUUKZ7o2cWB1EuCMOTCZIPkcEMKsTumLKK2Oibi/k9UOSm4GjvxRQWyOgkLa0mhvPfeNzM61MQFok5S3aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to the similarity between PRIO and ETS it is possible to simply
reuse most of the code for offloading PRIO Qdisc. Extract the common
functionality into separate functions, making the current PRIO handlers
thin API adapters.

Extend the new functions to pass quanta for individual bands, which allows
configuring a subset of bands as WRR. Invoke mlxsw_sp_port_ets_set() as
appropriate to de/configure WRR-ness and weight of individual bands.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 112 ++++++++++++++----
 1 file changed, 87 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers=
/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 0457ff5f6942..4cd2020bcbe0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -471,14 +471,16 @@ int mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw=
_sp_port,
 }
=20
 static int
-mlxsw_sp_qdisc_prio_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+__mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	int i;
=20
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		mlxsw_sp_port_prio_tc_set(mlxsw_sp_port, i,
 					  MLXSW_SP_PORT_DEFAULT_TCLASS);
+		mlxsw_sp_port_ets_set(mlxsw_sp_port,
+				      MLXSW_REG_QEEC_HIERARCHY_SUBGROUP,
+				      i, 0, false, 0);
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port,
 				       &mlxsw_sp_port->tclass_qdiscs[i]);
 		mlxsw_sp_port->tclass_qdiscs[i].prio_bitmap =3D 0;
@@ -487,6 +489,22 @@ mlxsw_sp_qdisc_prio_destroy(struct mlxsw_sp_port *mlxs=
w_sp_port,
 	return 0;
 }
=20
+static int
+mlxsw_sp_qdisc_prio_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+{
+	return __mlxsw_sp_qdisc_ets_destroy(mlxsw_sp_port);
+}
+
+static int
+__mlxsw_sp_qdisc_ets_check_params(unsigned int nbands)
+{
+	if (nbands > IEEE_8021QAZ_MAX_TCS)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static int
 mlxsw_sp_qdisc_prio_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 				 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
@@ -494,30 +512,48 @@ mlxsw_sp_qdisc_prio_check_params(struct mlxsw_sp_port=
 *mlxsw_sp_port,
 {
 	struct tc_prio_qopt_offload_params *p =3D params;
=20
-	if (p->bands > IEEE_8021QAZ_MAX_TCS)
-		return -EOPNOTSUPP;
-
-	return 0;
+	return __mlxsw_sp_qdisc_ets_check_params(p->bands);
 }
=20
 static int
-mlxsw_sp_qdisc_prio_replace(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
-			    void *params)
+__mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+			     unsigned int nbands,
+			     unsigned int quanta[TCQ_ETS_MAX_BANDS],
+			     u8 priomap[TC_PRIO_MAX + 1])
 {
-	struct tc_prio_qopt_offload_params *p =3D params;
 	struct mlxsw_sp_qdisc *child_qdisc;
 	int tclass, i, band, backlog;
+	unsigned int w_psum_prev =3D 0;
+	unsigned int q_psum =3D 0;
+	unsigned int w_psum =3D 0;
+	unsigned int weight =3D 0;
+	unsigned int q_sum =3D 0;
+	unsigned int quantum;
 	u8 old_priomap;
 	int err;
=20
-	for (band =3D 0; band < p->bands; band++) {
+	for (band =3D 0; band < nbands; band++)
+		q_sum +=3D quanta[band];
+
+	for (band =3D 0; band < nbands; band++) {
 		tclass =3D MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
 		child_qdisc =3D &mlxsw_sp_port->tclass_qdiscs[tclass];
 		old_priomap =3D child_qdisc->prio_bitmap;
 		child_qdisc->prio_bitmap =3D 0;
+
+		quantum =3D quanta[band];
+		q_psum +=3D quantum;
+		w_psum =3D quantum ? q_psum * 100 / q_sum : 0;
+		weight =3D w_psum - w_psum_prev;
+		w_psum_prev =3D w_psum;
+		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
+					    MLXSW_REG_QEEC_HIERARCHY_SUBGROUP,
+					    tclass, 0, !!quantum, weight);
+		if (err)
+			return err;
+
 		for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-			if (p->priomap[i] =3D=3D band) {
+			if (priomap[i] =3D=3D band) {
 				child_qdisc->prio_bitmap |=3D BIT(i);
 				if (BIT(i) & old_priomap)
 					continue;
@@ -540,21 +576,46 @@ mlxsw_sp_qdisc_prio_replace(struct mlxsw_sp_port *mlx=
sw_sp_port,
 		child_qdisc =3D &mlxsw_sp_port->tclass_qdiscs[tclass];
 		child_qdisc->prio_bitmap =3D 0;
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, child_qdisc);
+		mlxsw_sp_port_ets_set(mlxsw_sp_port,
+				      MLXSW_REG_QEEC_HIERARCHY_SUBGROUP,
+				      tclass, 0, false, 0);
 	}
 	return 0;
 }
=20
+static int
+mlxsw_sp_qdisc_prio_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			    void *params)
+{
+	struct tc_prio_qopt_offload_params *p =3D params;
+	unsigned int quanta[TCQ_ETS_MAX_BANDS] =3D {0};
+
+	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, p->bands,
+					    quanta, p->priomap);
+}
+
+static void
+__mlxsw_sp_qdisc_ets_unoffload(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			       struct gnet_stats_queue *qstats)
+{
+	u64 backlog;
+
+	backlog =3D mlxsw_sp_cells_bytes(mlxsw_sp_port->mlxsw_sp,
+				       mlxsw_sp_qdisc->stats_base.backlog);
+	qstats->backlog -=3D backlog;
+}
+
 static void
 mlxsw_sp_qdisc_prio_unoffload(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			      void *params)
 {
 	struct tc_prio_qopt_offload_params *p =3D params;
-	u64 backlog;
=20
-	backlog =3D mlxsw_sp_cells_bytes(mlxsw_sp_port->mlxsw_sp,
-				       mlxsw_sp_qdisc->stats_base.backlog);
-	p->qstats->backlog -=3D backlog;
+	__mlxsw_sp_qdisc_ets_unoffload(mlxsw_sp_port, mlxsw_sp_qdisc,
+				       p->qstats);
 }
=20
 static int
@@ -645,22 +706,22 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_p=
rio =3D {
  * unoffload the child.
  */
 static int
-mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_sp_port,
-			  struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
-			  struct tc_prio_qopt_offload_graft_params *p)
+__mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			   u8 band, u32 child_handle)
 {
-	int tclass_num =3D MLXSW_SP_PRIO_BAND_TO_TCLASS(p->band);
+	int tclass_num =3D MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
 	struct mlxsw_sp_qdisc *old_qdisc;
=20
-	if (p->band < IEEE_8021QAZ_MAX_TCS &&
-	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle =3D=3D p->child_handl=
e)
+	if (band < IEEE_8021QAZ_MAX_TCS &&
+	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle =3D=3D child_handle)
 		return 0;
=20
 	/* See if the grafted qdisc is already offloaded on any tclass. If so,
 	 * unoffload it.
 	 */
 	old_qdisc =3D mlxsw_sp_qdisc_find_by_handle(mlxsw_sp_port,
-						  p->child_handle);
+						  child_handle);
 	if (old_qdisc)
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, old_qdisc);
=20
@@ -695,8 +756,9 @@ int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_=
sp_port,
 		return mlxsw_sp_qdisc_get_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
 						&p->stats);
 	case TC_PRIO_GRAFT:
-		return mlxsw_sp_qdisc_prio_graft(mlxsw_sp_port, mlxsw_sp_qdisc,
-						 &p->graft_params);
+		return __mlxsw_sp_qdisc_ets_graft(mlxsw_sp_port, mlxsw_sp_qdisc,
+						  p->graft_params.band,
+						  p->graft_params.child_handle);
 	default:
 		return -EOPNOTSUPP;
 	}
--=20
2.20.1

