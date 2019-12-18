Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48079124A72
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfLROzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:55:41 -0500
Received: from mail-eopbgr20040.outbound.protection.outlook.com ([40.107.2.40]:9171
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727114AbfLROzk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:55:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVG42PNGXVw5qQ2aJiPgxWrngzNBJXjU9xc88vjQcoX2468vWjbW3WWLM1ZFYsGb67tkVwFs1yAgxIa/DeAKl62n+3/6t0gCVK5+2Vbqrb46RXIPHfWeTzH0WQSiCkdf1yH5mCLQgfffu6JjuTA7zazJsunp998ojNoF5Y4vJnVfzj2o7ygnFJMM3mogqkN98MSbruW/HuAHgNa86PKREeqXAJc8c15WMqOjg/t5MXHMqmTMPiMOrmJAh22H2/9zioD2kw+xXn5nsD5qVuU3hKpXahvXokvxjb4rSYFAJw3y2xf6+lW25wAdkV1jkxHF4PLMlodgfLz4gbcWM5Ym2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4t+bfxyFhO247q7zRwSA301Ndo+mWju1L3Sc9S6V+o=;
 b=jro8/POyoIqvBIl5uBiyezpW6WL7YPm5nZ/1dTE1ddoGCFW9GzytOEnBpTtXlSJg2mNbMrTPOYiB5dGnPnrgP2ToAsINvXrDTqwTnkKdHJN9XJIAr/7uZk057HjCTwQvFz2YhKi4wcHyJ7E0clRwhjqrh9g8VUv9neZk17uq12erXbJpVCj89Puu5esYoWSvDMalFvmVlWkwN3Z+7Lt42dc8k+G/GeNvgBnW21kEGrH3l9huOxjbqg1pc4Ee8o5rO67rYBSnfOBGRY+IMus6epZ1cjz8jZ9IvNS2PtFVDVrxE5ceRsM14psTcMjbJj4P9Y7shvIxoCDrPSJodNQcwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4t+bfxyFhO247q7zRwSA301Ndo+mWju1L3Sc9S6V+o=;
 b=MJ6YQMEySAQyL4thkR9NPHILjlr1cEJqMRzvAHdU4BOC2nOA4sHY5KJXuGCJ+I+w/9upwk8TGchZNU41a+hSc05n6f7vZ5pXsuCnFew6ciDfuZdMCV1H+TOx+7m59aUCQOSTYNvrMDaHc473Zkij6xzV3U2VKF/2E1IKDUUxKm4=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3048.eurprd05.prod.outlook.com (10.172.250.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 14:55:17 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 14:55:17 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v2 06/10] mlxsw: spectrum_qdisc: Generalize
 PRIO offload to support ETS
Thread-Topic: [PATCH net-next mlxsw v2 06/10] mlxsw: spectrum_qdisc:
 Generalize PRIO offload to support ETS
Thread-Index: AQHVtbMpZP0tCkXfZ0CPfUoUtJQnPA==
Date:   Wed, 18 Dec 2019 14:55:17 +0000
Message-ID: <5ea5cb74b5066fed65f3ffbc3edb8401209acae0.1576679651.git.petrm@mellanox.com>
References: <cover.1576679650.git.petrm@mellanox.com>
In-Reply-To: <cover.1576679650.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR2P264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::19) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f6a95326-f364-470e-2bda-08d783ca4b82
x-ms-traffictypediagnostic: DB6PR0502MB3048:|DB6PR0502MB3048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB30483E717581CD96F77EB56CDB530@DB6PR0502MB3048.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(2906002)(478600001)(6512007)(8936002)(81166006)(4326008)(316002)(107886003)(8676002)(71200400001)(26005)(186003)(81156014)(86362001)(2616005)(6916009)(66946007)(66446008)(64756008)(66556008)(66476007)(36756003)(6486002)(5660300002)(54906003)(52116002)(6506007)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3048;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hHZTm3L0KHwMT0lR2GrhnN3xQXYGGzB1U35WGq0OKW53YtNLbxjfbcMme6F5Vv04KIBEy4k+KXg8wwN6lx/OGMIbosYp4FJlPuVsuTZqAoPX6XSHgXg6Qa55uLkEeUwmoyt4LKKbnMJNe3wiEDLdXeM9ia6UjP9mJqfF30SuSdnhcXhmY2U34dk2peaDV9PlBsUac9sSEZuwHtCpmVL3swmI/eukCuMUsjK3SAKD3SeSQRxcBPAf0kl8xcnN8zZ/atpi0LgC6HnUxldnGX3KGVPrRtTdXCcu1679/WfKOV4OS/K5ss2sN3MP1w4IG3vXjg8p74kKanTOhXACcUnkMxdPbUbeY6O62HMXc+uSFmuYud1Bd9xFNGjdQz8bh7Oj9Dr+SKisDjMgLUAyCvHz8MM8o+Vf6mfKSv/96KdeVmnepAHDnR9PTl3SFKa5a29M479wbrj4lA/TaG6pJYKNbjfngYTK4qjNabawEmyeNC17dummJUH2dmqqDDYfvW3i
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6a95326-f364-470e-2bda-08d783ca4b82
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 14:55:17.4417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cLr1bAk7xMEHlzorkxu6bMIluZWfVrGyUMb7IAi1GAEMm40oRn9nvnmk98iKrHAoRLNwfjseOuInLUvdxZaauA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3048
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
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---

Notes:
    v3 (internal):
    - __mlxsw_sp_qdisc_ets_replace(): Pass the weights argument to this
      function in this patch already. Drop the weight computation.
    - mlxsw_sp_qdisc_prio_replace(): Rename "quanta" to "zeroes" and
      pass for the abovementioned "weights".
    - mlxsw_sp_qdisc_prio_graft(): Convert to a wrapper around
      __mlxsw_sp_qdisc_ets_graft(), instead of invoking the latter
      directly from mlxsw_sp_setup_tc_prio().
    - Update to follow the _HIERARCHY_ -> _HR_ renaming.
   =20
    v1 (internal):
    - __mlxsw_sp_qdisc_ets_replace(): Convert syntax of function arguments
      "quanta" and "priomap" from arrays to pointers.

 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 104 ++++++++++++++----
 1 file changed, 81 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers=
/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 135fef6c54b1..d513af49c0a8 100644
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
+				      MLXSW_REG_QEEC_HR_SUBGROUP,
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
@@ -494,30 +512,36 @@ mlxsw_sp_qdisc_prio_check_params(struct mlxsw_sp_port=
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
+			     const unsigned int *quanta,
+			     const unsigned int *weights,
+			     const u8 *priomap)
 {
-	struct tc_prio_qopt_offload_params *p =3D params;
 	struct mlxsw_sp_qdisc *child_qdisc;
 	int tclass, i, band, backlog;
 	u8 old_priomap;
 	int err;
=20
-	for (band =3D 0; band < p->bands; band++) {
+	for (band =3D 0; band < nbands; band++) {
 		tclass =3D MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
 		child_qdisc =3D &mlxsw_sp_port->tclass_qdiscs[tclass];
 		old_priomap =3D child_qdisc->prio_bitmap;
 		child_qdisc->prio_bitmap =3D 0;
+
+		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
+					    MLXSW_REG_QEEC_HR_SUBGROUP,
+					    tclass, 0, !!quanta[band],
+					    weights[band]);
+		if (err)
+			return err;
+
 		for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-			if (p->priomap[i] =3D=3D band) {
+			if (priomap[i] =3D=3D band) {
 				child_qdisc->prio_bitmap |=3D BIT(i);
 				if (BIT(i) & old_priomap)
 					continue;
@@ -540,21 +564,46 @@ mlxsw_sp_qdisc_prio_replace(struct mlxsw_sp_port *mlx=
sw_sp_port,
 		child_qdisc =3D &mlxsw_sp_port->tclass_qdiscs[tclass];
 		child_qdisc->prio_bitmap =3D 0;
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, child_qdisc);
+		mlxsw_sp_port_ets_set(mlxsw_sp_port,
+				      MLXSW_REG_QEEC_HR_SUBGROUP,
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
+	unsigned int zeroes[TCQ_ETS_MAX_BANDS] =3D {0};
+
+	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, p->bands,
+					    zeroes, zeroes, p->priomap);
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
@@ -657,22 +706,22 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_p=
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
@@ -681,6 +730,15 @@ mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_=
sp_port,
 	return -EOPNOTSUPP;
 }
=20
+static int
+mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			  struct tc_prio_qopt_offload_graft_params *p)
+{
+	return __mlxsw_sp_qdisc_ets_graft(mlxsw_sp_port, mlxsw_sp_qdisc,
+					  p->band, p->child_handle);
+}
+
 int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct tc_prio_qopt_offload *p)
 {
--=20
2.20.1

