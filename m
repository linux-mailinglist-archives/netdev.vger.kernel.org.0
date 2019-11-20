Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A472C103AA8
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbfKTNFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:23 -0500
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:50305
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728787AbfKTNFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0J5yYF6/cw6qtbdUZ8r+Um1idG1vdYVZlMNcftHm4iehLWSUDDlk0ClkQ1V15GOuaTf394PrcHWQXuuNHfgUAivzV9YNtodH4bdXLWyQ/VtKVof5qhO+9E9CAv2TAZszlcE+iOTyJNQn1onBWOd5NKf9GMTRnKRCCb/s40yUNU9bfJmY9Y3+rYkdldvXipKbADS7hbN/7SekIsIRz3nfsIpvnt/EKffY7VWZ0pHPYLNL9/Ursji/FwDsn4/CzeN6YUGIPNUgtqrcZon397sTdBV10SgdXU3M5+wjiY3OlqUVYEnz/Fykxfcq20PHlOVu8G04ImoChp/VwqZoYj5AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUecI/QCNoQjRj/BIm0qZG1/dl49HU7ehOJv/56xZ4s=;
 b=Zjg1pkRXs7kILfx/Am3+NBvWU/+ki9kX2m72A1CZhe6D5MimcdebZzyq3Y4ql0Ap3uGpGn7kgZycRbzHbRu3Dmk9727Q6UrAry3y+vRZT9u78TKDrtf3Ztj3+kahaL44QrOc/Wwf+G/FBmscMpk10ISkRCevvHKvsamtHuBtqOa6qoPa4s2kxQ6nSTj8A+nNrazKuk4/Vn+3qU2z8ghkZqQahxBlMDwEoMPJRknDR6ZMcXsIAbEo+pdw917kZ8Z9M01mBX1mr/LSM7FweJgunkGj0jX1a3KERFnl1ZmpmVBi8UnqlD3tzENMITerjG0JV35ZKHqeL8mzG5xqh/JWNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUecI/QCNoQjRj/BIm0qZG1/dl49HU7ehOJv/56xZ4s=;
 b=q1DIlpyUWVb/AfZP8pr9bhdOToxxvqay1HdWEQomaVbf3AnKYCHJBzQVTATGkyMbw7IrSj8nhCNzTwG9nKXNK7lrYeBxk8V28wOMZyrhpJmM7pBo7uZWOP8g2cssCkXkEXcx8rJ2+E4PCjbtU4pZzfjszOMxKvz1Hwt5n8poVeM=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2982.eurprd05.prod.outlook.com (10.172.246.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 13:05:14 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:14 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 05/10] net: sch_ets: Make the ETS qdisc offloadable
Thread-Topic: [RFC PATCH 05/10] net: sch_ets: Make the ETS qdisc offloadable
Thread-Index: AQHVn6MlAQ/pqs/Y7Ui7q1JuzPgb3Q==
Date:   Wed, 20 Nov 2019 13:05:13 +0000
Message-ID: <8cdc6d07168f2ade91c9ae06c536c6009effd050.1574253236.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 46c3f723-2d35-4f05-63df-08d76dba4812
x-ms-traffictypediagnostic: DB6PR0502MB2982:|DB6PR0502MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB29828A9A8563B4BFEA12FC64DB4F0@DB6PR0502MB2982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(102836004)(1730700003)(6436002)(2616005)(446003)(50226002)(81156014)(81166006)(478600001)(66556008)(8936002)(66476007)(66946007)(14454004)(5640700003)(6506007)(2906002)(386003)(36756003)(66446008)(66066001)(8676002)(6486002)(26005)(186003)(54906003)(7736002)(316002)(6512007)(305945005)(76176011)(71190400001)(71200400001)(2351001)(256004)(64756008)(2501003)(52116002)(86362001)(14444005)(486006)(6116002)(11346002)(3846002)(5660300002)(25786009)(99286004)(476003)(6916009)(4326008)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2982;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pfHa5gy5gzBfLMXNYyYMQppzh4TAIXgOhIaAhbdeBLx5meFVNlUJJ93H+ajGzpeCr7THueA3qTyJ0nN75y9i1GZoEVVbLNQUpAQRiX9r9zYz0k5nIgsXbMyxp9/t2RZX/GZ57wYLGfz7gjW+Rb1tHC8FRmxr7SfPYuWAuMoVG4opYswKH4kxp5emMnN6Q+k2/75y658TRNeVABHVVAsgxGVzihJp3Ugd24J1yqKCmKjNrJu8k9fHhk3vXVPIVzwy60cDn5h2q4t9lPSbQm+M71ngqpiQ6sATafviC4j8CF+ENO4BvNEcCFayTCTujr4GvsfOcFaP5/XDjTBafvJFV7FWvHz+JiiKU1fr9LZmUnfzEa30rslSUx9rKMRbtvf9dhqq0Dlsvr1iOles5LZl1Qw+0MitE1j5f3Bf9AgVzhpWS0x7lyK3ljUdKbru9eQa
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46c3f723-2d35-4f05-63df-08d76dba4812
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:13.9202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JlFDRIW8PDRknkdUAPM59Cjkr85e9E++WkAkTKv3kV4Uc/unuL74hudTTLhm+PPfn7gMfd4fhNqzGWqGUvLTnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add hooks at appropriate points to make it possible to offload the ETS
Qdisc.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/linux/netdevice.h |  1 +
 include/net/pkt_cls.h     | 31 ++++++++++++
 net/sched/sch_ets.c       | 99 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9e6fb8524d91..23ffcfcc9bc4 100644
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
index a7c5d492bc04..942edfb3c7a5 100644
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
+	unsigned int quanta[TCQ_ETS_MAX_BANDS];
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
index 6a1751564c4b..7fdccb192a33 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -80,6 +80,90 @@ static u32 ets_class_id(struct Qdisc *sch, struct ets_cl=
ass *cl)
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
 static bool ets_class_is_strict(struct ets_sched *q, struct ets_class *cl)
 {
 	unsigned int band =3D cl - q->classes;
@@ -133,6 +217,8 @@ static int ets_class_change(struct Qdisc *sch, u32 clas=
sid, u32 parentid,
 	sch_tree_lock(sch);
 	cl->quantum =3D quantum;
 	sch_tree_unlock(sch);
+
+	ets_offload_change(sch);
 	return 0;
 }
=20
@@ -150,6 +236,7 @@ static int ets_class_graft(struct Qdisc *sch, unsigned =
long arg,
 	}
=20
 	*old =3D qdisc_replace(sch, new, &cl->qdisc);
+	ets_offload_graft(sch, new, *old, arg, extack);
 	return 0;
 }
=20
@@ -557,6 +644,7 @@ static int ets_qdisc_change(struct Qdisc *sch, struct n=
lattr *opt,
=20
 	sch_tree_unlock(sch);
=20
+	ets_offload_change(sch);
 	for (i =3D q->nbands; i < oldbands; i++) {
 		qdisc_put(q->classes[i].qdisc);
 		memset(&q->classes[i], 0, sizeof(q->classes[i]));
@@ -601,6 +689,7 @@ static void ets_qdisc_destroy(struct Qdisc *sch)
 	struct ets_sched *q =3D qdisc_priv(sch);
 	int band;
=20
+	ets_offload_destroy(sch);
 	tcf_block_put(q->block);
 	for (band =3D 0; band < q->nbands; band++)
 		qdisc_put(q->classes[band].qdisc);
@@ -609,11 +698,17 @@ static void ets_qdisc_destroy(struct Qdisc *sch)
 static int ets_qdisc_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct ets_sched *q =3D qdisc_priv(sch);
-	struct nlattr *opts;
+	struct nlattr *opts =3D NULL;
 	struct nlattr *nest;
 	int band;
 	int prio;
+	int err;
=20
+	err =3D ets_offload_dump(sch);
+	if (err)
+		goto nla_err;
+
+	err =3D -EMSGSIZE;
 	opts =3D nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!opts)
 		goto nla_err;
@@ -654,7 +749,7 @@ static int ets_qdisc_dump(struct Qdisc *sch, struct sk_=
buff *skb)
=20
 nla_err:
 	nla_nest_cancel(skb, opts);
-	return -EMSGSIZE;
+	return err;
 }
=20
 static const struct Qdisc_class_ops ets_class_ops =3D {
--=20
2.20.1

