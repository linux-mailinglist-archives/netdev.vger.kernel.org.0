Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B82121077
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfLPRC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:02:27 -0500
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:35200
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726759AbfLPRC0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:02:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJPb3Rv+pZ/EVovsjTo2LddA2GLStbOnOI0Jj+jAwJ1MnE6DSRXKOJbP4Iha20UTGBxT3DtKPXcXHnk6AEwVQVj1g3PLmwHkbaWEsbtjUI/AmDq6yJuzOUFNehNwRKjnDZ3yvhKKpe3bHqZOpoPkqhqNlG36rvcDQkLXe014sijC699PAolqdIBS/AY8AHKzDQrNtC1OIsyqQu8YYbioni/KCLYIBSknpyxmO9xSv2LD45zO0ebppty42FnUjlTJCMbJW7EWeMNWEdVR/+NlP5iDCa7Ky1qFlUgWSUmNWZNcg5pzi/azApwwOCTtK33j/yqyyo4N99c/le9lyYIMsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Q13+Ntg5OXDwCUK+lPTydu7XxN2nrB+j/eyM4jB7lE=;
 b=n7nvqfoIgzwmuxyqqmXsmd+RIjI9B4WVQPheSn2ZCHi6T3fyqDyM1fMfjn8pqiHMLgyVIocAml0a8fRZ/cRLCzUX/SS9atLR1uY9GlAX0fb4R8ghhH22CTRZ1xLRM9Ri5l/jWtzz3ZJejUaFDLT5zj+LhvOxH6B+enTpEyEUvCcUEi6ivcOOH8KqDikUZo6J1MNpbuwo94DG1BmvFlKSOFc/7Zay5XXD1WtNR37/IXlpYNEZBn3km8Bmt6SGjwH3MpHhSqCy5czDy1YUGvaS54ggA9C+SFaV0vc2L1iINWVQqfwbqQ6YXdl7Rn4uawHclVoWIoYkaEKnVk4K5INoZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Q13+Ntg5OXDwCUK+lPTydu7XxN2nrB+j/eyM4jB7lE=;
 b=oUmFMIFaDgetNmo6YuTN3Y2yyzspxZj3zZNGQRKnAk52lHpGc3JvmJ7b2vz1A29b7SeXceu0KXSOqSa/2MfDhZEXf4b3Pb0cbZZlsrLzkTv1zAPNL2YlJ9ice7IO00IDWDMkdAW6rFD40r/AfB0gBlvQP96cyiuV2+gY9s0nn/k=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3014.eurprd05.prod.outlook.com (10.172.248.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Mon, 16 Dec 2019 17:01:53 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:01:53 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v1 07/10] mlxsw: spectrum_qdisc: Support
 offloading of ETS Qdisc
Thread-Topic: [PATCH net-next mlxsw v1 07/10] mlxsw: spectrum_qdisc: Support
 offloading of ETS Qdisc
Thread-Index: AQHVtDKD3WB/HXoMZ0uOs7OLl25uAw==
Date:   Mon, 16 Dec 2019 17:01:53 +0000
Message-ID: <ded9ad1ea03fe06eeaba900a20a3d72634c5d471.1576515562.git.petrm@mellanox.com>
References: <cover.1576515562.git.petrm@mellanox.com>
In-Reply-To: <cover.1576515562.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR0P264CA0027.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::15) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9ef1739b-d15d-45d1-af63-08d78249a62c
x-ms-traffictypediagnostic: DB6PR0502MB3014:|DB6PR0502MB3014:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB301412E95614FA6E6CA724E5DB510@DB6PR0502MB3014.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(186003)(6512007)(26005)(316002)(107886003)(71200400001)(6486002)(81166006)(6506007)(81156014)(8676002)(8936002)(66556008)(66476007)(66446008)(64756008)(66946007)(2906002)(478600001)(54906003)(6916009)(2616005)(86362001)(36756003)(52116002)(4326008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3014;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +L/q7DTnqSF99CqX5RLSOnBTTAgZyUQvEz0i2JygxuDzoC2ROiEA/qD4dWKTz6g6lJxRTVtIP9edF0KDgEXssh57JQJ2hw7n7IisuEJWSBkt2Q1UlS4pKpxzCxDedP8McZNMXHy+djA7e4wYyo0vJ1YXaWNoKuh4/szqsdZ+3bqha3Aq8eQydc/sVVldty1NldcrhtQbjzlNou+URFUynsXbzOErd9bL+IlsBXvLZ88Xki20M8dt8p6nJQgO7b5alwaGPTouniZytClxCHKM4OiG3OpiBULjRn80Zp4ixOKQygxIT2WbiZYc8NNUzqc8QRUXafMbpV+gw+GFKXgaPidTN9s5Gi1xg7i6RLRgZ0slRGawqry5M2ZcOeNOYx/XrNTeiRasKoGtHiFDWxBzQOu08MyFH9lMbIkoTGGSRZaCjBd8Al4SYWWw4RWr0Y0P
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef1739b-d15d-45d1-af63-08d78249a62c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:01:53.2652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8tkt8wu3XC+6c93Cd166sE5h/ikQqbrZIcKgAItpxa7ZzWsClfd8C+nBcFEdVnebxJUvDnwjRZ8x6/7lXX+7QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3014
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle TC_SETUP_QDISC_ETS, add a new ops structure for the ETS Qdisc.
Invoke the extended prio handlers implemented in the previous patch. For
stats ops, invoke directly the prio callbacks, which are not sensitive to
differences between PRIO and ETS.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---

Notes:
    v3 (internal):
    - __mlxsw_sp_qdisc_ets_replace(): The "weights" argument passing and
      weight computation removal are now done in a previous patch.
    - mlxsw_sp_setup_tc_ets(): Drop case TC_ETS_REPLACE, which is handled
      earlier in the function.
   =20
    v1 (internal):
    - __mlxsw_sp_qdisc_ets_replace(): Convert syntax of function argument
      "weights" from an array to a pointer.

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 84 +++++++++++++++++++
 3 files changed, 88 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.c
index 0d8fce749248..ea632042e609 100644
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
index d513af49c0a8..81a2c087f534 100644
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
@@ -680,6 +681,55 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_pr=
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
@@ -772,6 +822,40 @@ int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw=
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
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
--=20
2.20.1

