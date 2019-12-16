Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB48121075
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfLPRCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:02:20 -0500
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:35200
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726743AbfLPRCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:02:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkekjoZR5+NKB+VUUoDB2XknOsUHbxiR6TLFktE7Ygg/Rga+eFSYD6tCvpSlWP+j50g559ez20h++w8wkmwpPaCTOzl5DQFRLUgJnMd3YTMh5gpD0/Xa8T0Czgrg9oUTgdmJ/HvFgBbuV4LqwH6YVzZopUUap2MLie1y2woNWWSF9Cl8DU99UujvjahVJW5cQu9I8Kd2tJyHYImmcU2uaMvJl2/+lqHLkrz6Mam6x4EFmpTJU3Fu2/1+UgwXo4lxlhcbIlH2mfNsiFQXJVRjBGja18Fem/jXQr5RTiHCQMdMoGrSaQj/sX+Ug2OBNlZ8NlmEEazn2X+dQF1aN0NgEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MP64AKfMjner+/ANrXLr6yU55AtMNyuPfJeahK+W98c=;
 b=bX+TWpxyCqNTxSZVPwz5Nmz8SX1vlHyDLjKJmC0cautn71rubiJaJywu9QVT8uwOjBLI0En8l/QSoPmDknmUnsns9xw1sCBvZl1WRAngsaJ8pQkrcd0J/g4Mb1h7nXUGLu6/JC/7ErTu8hbKWwk/ouAZvMF622TMY6H0zSYjRmrWPG3VcCOkGhEBJ9VeLPa+yHZJCpOkOVnj950JpGMiB4DcOWYc3K6omf95rq0BdDRPlxQwhuzGmm42KMUD7XNDQF4G/8Q6BlXjOf8EXjPg+NKGQkoTEe4UAlXXSpvQ4SCMN5dd7AJMO5CdsyxfnblIfCiuY3KoQ2MSKfJecKXxDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MP64AKfMjner+/ANrXLr6yU55AtMNyuPfJeahK+W98c=;
 b=hyizOncwqeLHMxCOn4v99FCMs/ekRFaEs+cLDdjSUY1IQIcY312VBiOFtC0Nt/Yh5OxCNJT6f+O9kQSJEXzmxrl0rx82pN8Zc65RWhxJMcxNzTqWJvQpk4mWPTY7LHZTusOucMABfZjL0oZVydSUSmuPfP/QsTd0cEFxRKlw/UA=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3014.eurprd05.prod.outlook.com (10.172.248.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Mon, 16 Dec 2019 17:01:49 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:01:49 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v1 05/10] net: sch_ets: Make the ETS qdisc
 offloadable
Thread-Topic: [PATCH net-next mlxsw v1 05/10] net: sch_ets: Make the ETS qdisc
 offloadable
Thread-Index: AQHVtDKB2+fFvVIgvkO3mYr66kz1Jg==
Date:   Mon, 16 Dec 2019 17:01:49 +0000
Message-ID: <22a2b146c7443d9303c7051a2ac6b2c52c00b74e.1576515562.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 415ebf00-3b91-45f4-18ad-08d78249a3bc
x-ms-traffictypediagnostic: DB6PR0502MB3014:|DB6PR0502MB3014:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB30146764724DA4B2BAE107DEDB510@DB6PR0502MB3014.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(186003)(6512007)(26005)(316002)(107886003)(71200400001)(6486002)(81166006)(6506007)(81156014)(8676002)(8936002)(66556008)(66476007)(66446008)(64756008)(66946007)(2906002)(478600001)(54906003)(6916009)(2616005)(86362001)(36756003)(52116002)(4326008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3014;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EAL+RSGOzgLBUR4J7bDNWCekyKVW8fuMXSmrj0dxDrc7PBK1y/Loag2sSj6WTYDW5l/bJOY/1FJC9ngeTudnP6tTvMUDOAIvhmlIgZhYHR5VOu3NK+zhQlTZ4ZFO6LBiSjV8oHy54/TcTzqTo88v7lfrzXJoGy/hiaJBkLV0G18TMw0+waR+DUmKohqj1LkdilmUbbjpS5HmX7hHBbxdhOuloCrO9gWqzT+290Qpqqvxh1dTn5lUHw6qIYZ6MRSC8VT6x320d2VNC4wHMamPBWr/Pv+2JTSujx2hTeWbtDcvonMp1J8aFkeXQH6g75+I9uSnzEhcXIUYBSkpNhaofKNekEGTwuOtH2yNvOv8zIbXPj1gxqL5xAqy9GFHUaKJb7Ntvb2+KLhID5ZK36BhgLvud8cZpNilUN1ud5GVmodcpPIXPSrMIbXnrGi6iqQV
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 415ebf00-3b91-45f4-18ad-08d78249a3bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:01:49.1859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B5VntxljtmQKOyE1CDYjQTnHS3PmmtOWYP/K+4fgvQjVqb9h+pzl5Te+IJqOilUVXa5iHX96hTAlFsIzF/SO+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3014
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add hooks at appropriate points to make it possible to offload the ETS
Qdisc.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---

Notes:
    v1 (internal):
    - pkt_cls.h: Note that quantum=3D0 signifies a strict band.
    - Fix error path handling when ets_offload_dump() fails.

 include/linux/netdevice.h |  1 +
 include/net/pkt_cls.h     | 31 +++++++++++++
 net/sched/sch_ets.c       | 95 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 127 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 30745068fb39..7a8ed11f5d45 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -849,6 +849,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_GRED,
 	TC_SETUP_QDISC_TAPRIO,
 	TC_SETUP_FT,
+	TC_SETUP_QDISC_ETS,
 };
=20
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index a7c5d492bc04..47b115e2012a 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -823,4 +823,35 @@ struct tc_root_qopt_offload {
 	bool ingress;
 };
=20
+enum tc_ets_command {
+	TC_ETS_REPLACE,
+	TC_ETS_DESTROY,
+	TC_ETS_STATS,
+	TC_ETS_GRAFT,
+};
+
+struct tc_ets_qopt_offload_replace_params {
+	unsigned int bands;
+	u8 priomap[TC_PRIO_MAX + 1];
+	unsigned int quanta[TCQ_ETS_MAX_BANDS];	/* 0 for strict bands. */
+	unsigned int weights[TCQ_ETS_MAX_BANDS];
+	struct gnet_stats_queue *qstats;
+};
+
+struct tc_ets_qopt_offload_graft_params {
+	u8 band;
+	u32 child_handle;
+};
+
+struct tc_ets_qopt_offload {
+	enum tc_ets_command command;
+	u32 handle;
+	u32 parent;
+	union {
+		struct tc_ets_qopt_offload_replace_params replace_params;
+		struct tc_qopt_offload_stats stats;
+		struct tc_ets_qopt_offload_graft_params graft_params;
+	};
+};
+
 #endif
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 3c4fe78af1f9..749c240948ec 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -76,6 +76,91 @@ static u32 ets_class_id(struct Qdisc *sch, const struct =
ets_class *cl)
 	return TC_H_MAKE(sch->handle, band + 1);
 }
=20
+static void ets_offload_change(struct Qdisc *sch)
+{
+	struct net_device *dev =3D qdisc_dev(sch);
+	struct ets_sched *q =3D qdisc_priv(sch);
+	struct tc_ets_qopt_offload qopt;
+	unsigned int w_psum_prev =3D 0;
+	unsigned int q_psum =3D 0;
+	unsigned int q_sum =3D 0;
+	unsigned int quantum;
+	unsigned int w_psum;
+	unsigned int weight;
+	unsigned int i;
+
+	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
+		return;
+
+	qopt.command =3D TC_ETS_REPLACE;
+	qopt.handle =3D sch->handle;
+	qopt.parent =3D sch->parent;
+	qopt.replace_params.bands =3D q->nbands;
+	qopt.replace_params.qstats =3D &sch->qstats;
+	memcpy(&qopt.replace_params.priomap,
+	       q->prio2band, sizeof(q->prio2band));
+
+	for (i =3D 0; i < q->nbands; i++)
+		q_sum +=3D q->classes[i].quantum;
+
+	for (i =3D 0; i < q->nbands; i++) {
+		quantum =3D q->classes[i].quantum;
+		q_psum +=3D quantum;
+		w_psum =3D quantum ? q_psum * 100 / q_sum : 0;
+		weight =3D w_psum - w_psum_prev;
+		w_psum_prev =3D w_psum;
+
+		qopt.replace_params.quanta[i] =3D quantum;
+		qopt.replace_params.weights[i] =3D weight;
+	}
+
+	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_ETS, &qopt);
+}
+
+static void ets_offload_destroy(struct Qdisc *sch)
+{
+	struct net_device *dev =3D qdisc_dev(sch);
+	struct tc_ets_qopt_offload qopt;
+
+	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
+		return;
+
+	qopt.command =3D TC_ETS_DESTROY;
+	qopt.handle =3D sch->handle;
+	qopt.parent =3D sch->parent;
+	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_ETS, &qopt);
+}
+
+static void ets_offload_graft(struct Qdisc *sch, struct Qdisc *new,
+			      struct Qdisc *old, unsigned long arg,
+			      struct netlink_ext_ack *extack)
+{
+	struct net_device *dev =3D qdisc_dev(sch);
+	struct tc_ets_qopt_offload qopt;
+
+	qopt.command =3D TC_ETS_GRAFT;
+	qopt.handle =3D sch->handle;
+	qopt.parent =3D sch->parent;
+	qopt.graft_params.band =3D arg - 1;
+	qopt.graft_params.child_handle =3D new->handle;
+
+	qdisc_offload_graft_helper(dev, sch, new, old, TC_SETUP_QDISC_ETS,
+				   &qopt, extack);
+}
+
+static int ets_offload_dump(struct Qdisc *sch)
+{
+	struct tc_ets_qopt_offload qopt;
+
+	qopt.command =3D TC_ETS_STATS;
+	qopt.handle =3D sch->handle;
+	qopt.parent =3D sch->parent;
+	qopt.stats.bstats =3D &sch->bstats;
+	qopt.stats.qstats =3D &sch->qstats;
+
+	return qdisc_offload_dump_helper(sch, TC_SETUP_QDISC_ETS, &qopt);
+}
+
 static bool ets_class_is_strict(struct ets_sched *q, const struct ets_clas=
s *cl)
 {
 	unsigned int band =3D cl - q->classes;
@@ -128,6 +213,8 @@ static int ets_class_change(struct Qdisc *sch, u32 clas=
sid, u32 parentid,
 	sch_tree_lock(sch);
 	cl->quantum =3D quantum;
 	sch_tree_unlock(sch);
+
+	ets_offload_change(sch);
 	return 0;
 }
=20
@@ -147,6 +234,7 @@ static int ets_class_graft(struct Qdisc *sch, unsigned =
long arg,
 	}
=20
 	*old =3D qdisc_replace(sch, new, &cl->qdisc);
+	ets_offload_graft(sch, new, *old, arg, extack);
 	return 0;
 }
=20
@@ -563,6 +651,7 @@ static int ets_qdisc_change(struct Qdisc *sch, struct n=
lattr *opt,
=20
 	sch_tree_unlock(sch);
=20
+	ets_offload_change(sch);
 	for (i =3D q->nbands; i < oldbands; i++) {
 		qdisc_put(q->classes[i].qdisc);
 		memset(&q->classes[i], 0, sizeof(q->classes[i]));
@@ -607,6 +696,7 @@ static void ets_qdisc_destroy(struct Qdisc *sch)
 	struct ets_sched *q =3D qdisc_priv(sch);
 	int band;
=20
+	ets_offload_destroy(sch);
 	tcf_block_put(q->block);
 	for (band =3D 0; band < q->nbands; band++)
 		qdisc_put(q->classes[band].qdisc);
@@ -619,6 +709,11 @@ static int ets_qdisc_dump(struct Qdisc *sch, struct sk=
_buff *skb)
 	struct nlattr *nest;
 	int band;
 	int prio;
+	int err;
+
+	err =3D ets_offload_dump(sch);
+	if (err)
+		return err;
=20
 	opts =3D nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!opts)
--=20
2.20.1

