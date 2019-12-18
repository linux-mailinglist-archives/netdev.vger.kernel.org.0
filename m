Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA16124A73
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfLROzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:55:44 -0500
Received: from mail-eopbgr20040.outbound.protection.outlook.com ([40.107.2.40]:9171
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727420AbfLROzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:55:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHi/ChYSPZwSR9V8Jduuj/X4xGnZIR8iBiwkzlIRWHG430sn/F6EtPl1xJAFY7PebYovMlvH+XtcFpV2v6uVrZXyMJXGtA2Clq7gUBYbOnINpCNV49H+Coc5LJZ6GQi/sfEVFgjGPt4ikWLgDA3/BKOVVHaliofixAsjkIHD2r34AZaXmH3dRdJjSQY2raWkUoGAzvEUQhHJvSK9W7t8vVoJcid2uWITrb+XRy07aGm4awafqZmnLY+DkpU4jQUSDEY9lzxnsPDOPDOodgTjkYFeA9pC9ki+ltj5ZHE67O2+Gs7m1EBAU3wHG4FUTHv49bezkT5wNOyBwVMMdpkoQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Q13+Ntg5OXDwCUK+lPTydu7XxN2nrB+j/eyM4jB7lE=;
 b=Mc9XJAa5i71vQ3H4Gk4+MN7luBAStx/H7+eLKYSJg3rqrjOXm3ETFslwdWOGIOl+mkASjnUuOgIzEsdt9Hof769DeXBB244/BGpBkQZhb635FLFKjpNyqMBl1x8wnsOnPY+5fNaT2gdCa1wlP/5yeOgRTyV1QcX6iK9S1ZZu+wZa8/I5w4/dZuyF2Lj1ps7HWY/3tladlOaCHUS8AVL4xIvCTz6gOWnZmIj9h6vtsHBjWsiQhfXOHhJMWk0O6NOld3EcmuJt85V7CQ/wGoPMqY62ZJdRFC8mHbCOOB20H/IdWmrxMiVAP/Vg9ZMwZLTtRt9pYrkW1p74uu1ZwYcnuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Q13+Ntg5OXDwCUK+lPTydu7XxN2nrB+j/eyM4jB7lE=;
 b=VCTcwBS3vJx8AsnuAuclEG/A/RGUcIamYkiIw4ODnbQOpgLA/7xLxqZNYsrDHGUDVCCfVgfLc0ga2eaM6d9pyPI50Cwx45ChmDTKM5gFxkVuKPvl4QCr1MwL5tD4OYAZABZtqr43wHWWskeN7uUeQ7DLXhC1LIepCh6QAFICoCA=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3048.eurprd05.prod.outlook.com (10.172.250.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 14:55:19 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 14:55:19 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v2 07/10] mlxsw: spectrum_qdisc: Support
 offloading of ETS Qdisc
Thread-Topic: [PATCH net-next mlxsw v2 07/10] mlxsw: spectrum_qdisc: Support
 offloading of ETS Qdisc
Thread-Index: AQHVtbMqFuNpxDmm9EGoJElD+VCesA==
Date:   Wed, 18 Dec 2019 14:55:19 +0000
Message-ID: <c934a39c1626eae5f73ec5244f4e33798a4b15f0.1576679651.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 068200c7-5bc6-42e1-32ec-08d783ca4cac
x-ms-traffictypediagnostic: DB6PR0502MB3048:|DB6PR0502MB3048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB30487FD98E814A6C8E003A6FDB530@DB6PR0502MB3048.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(2906002)(478600001)(6512007)(8936002)(81166006)(4326008)(316002)(107886003)(8676002)(71200400001)(26005)(186003)(81156014)(86362001)(2616005)(6916009)(66946007)(66446008)(64756008)(66556008)(66476007)(36756003)(6486002)(5660300002)(54906003)(52116002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3048;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WSt89h9F4VnltJBTQXUOFYoRXMjxbmRsVg1bwq9bCHHwkeRinp6BE9U239DQeszPTlmA6Udr4Jv3xtVXdk15gS3VMlNWMfF/m1fzD83r3+phIXKwoiUqyoK73VEfeNGz7e1HE6e8IBMhtiLBCpCpYsYvCBHRE6RIXhZ+qPZG3bQ7Ui4c161AwYStM4uRfSi983x80dBs01WH+OSkgBjOFNFRh8fupDaY6WZfEp5YrOtMD7Ickz7i+tRXqD7BNOs3unik0JCvBz4JBIPlzVuWnOURDM7cKo2tzan7KT/bMg94xPohWL/U0MK6SU5+lbYMnlkT/QQMc1/ukDs0EnksMUvtQmr6ygy2FRJZmAu2lEtBqvW/4zMJPOq1Dfci39ac2ag5fstNqW/b86IGNKfLqTvhVVpaH97fyKrgW6JYsyKE4SRRYEn9lwgSwsplU8A3
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068200c7-5bc6-42e1-32ec-08d783ca4cac
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 14:55:19.2539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kpkje+s9OACDOUD1VYx5sUPpfdueEOMCqoJK77ngVG26BnnpQjbm+YcyTvYGbjSSLe1BgxNoREeD61vxODcRvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3048
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

