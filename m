Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4B4124A71
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLROzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:55:38 -0500
Received: from mail-eopbgr20040.outbound.protection.outlook.com ([40.107.2.40]:9171
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727171AbfLROzh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:55:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ES3Y+G7/3nSfWO0jRR0Yokp2nK1RwsMOOM+7xqAackYaOnfYzPWUxdHchTJ5K/MM83UC0/bFhNIAg8Hzy7WSdnS9O57zHs4tAYiqkezKPbxhepEAdwtarrnxRp9sZGyqzGOu+tRtkxSyIASHxRBJbErHXd7BDw/Q9Mr5A71Tpnt2OBPepW1cqs7r1dXFNUI8P++XIOC7GcQQohVduaYL73cFm4bznDX5HxgoshWUQ7lM5loT6S2IvY7L/uD5nTMVx1mjrQso2MSO6IUVQM1N2qXl+zeQZxH88PLXaEt2sDPiA3c60Qt6Y8yNm6VHT9J2VlPUp9zF15yU0PbvrcshTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63/Lk+W9yCMEas9P9e30EX+C+5I2teniLyS1wrJKtIs=;
 b=cA9UtZs6xetVA2U+eSrlOkwBcSy17cNJBjq7UmxvtOonpdjKqCtYPvJalhjbdh430Li57j/NP9Q5SlBH0lQRyeQy44uIKbMT/XylgQlE9reu9MtpxOoFZsAv1bb76FMaSf5TEVo96fOhuWGXNTQjFD+VoRJ0NFPh4yXW/YRnqMVxdueGSaYOVk3Yxnu9RyPnMPvh0azo2EPc5Q2cgxsj8VTXTtzd7h2FInDGnLpsbrIezp5sa+dpjNaPA58DX51ngnM/AAoJhBaCwmZARPZVm8tmJidc0YYJkG2u+LOnx3x2q6DkfhNPKOFRYVD/Y/0eTBOpANZ4d89PjBuip40QFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63/Lk+W9yCMEas9P9e30EX+C+5I2teniLyS1wrJKtIs=;
 b=MqNMqUWlWI+KtWMdSJ9CUNlZr6VRX0lhZkv3LFimghZvUQd6LIWXtoYTCizcUILAfi7ElAl+1KHeq5/kejg3+1kgYHMwBVZNRgOlDc5R5HwKsReRdlP3P6w2QVvipYjlXbMe+tIBYHttAzvdWM18oi5K9b+wCoCn1mMDrFCnXW8=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3048.eurprd05.prod.outlook.com (10.172.250.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 14:55:15 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 14:55:15 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v2 05/10] net: sch_ets: Make the ETS qdisc
 offloadable
Thread-Topic: [PATCH net-next mlxsw v2 05/10] net: sch_ets: Make the ETS qdisc
 offloadable
Thread-Index: AQHVtbMo2co9/3Zz4EyAxpCVMYTzPw==
Date:   Wed, 18 Dec 2019 14:55:15 +0000
Message-ID: <049bd6a880be8e3725392434e922e16e24720a38.1576679651.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: df4881ab-827f-40e7-6560-08d783ca4a67
x-ms-traffictypediagnostic: DB6PR0502MB3048:|DB6PR0502MB3048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB30480EEFEB6BFDDA231DC270DB530@DB6PR0502MB3048.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(2906002)(478600001)(6512007)(8936002)(81166006)(4326008)(316002)(107886003)(8676002)(71200400001)(26005)(186003)(81156014)(86362001)(2616005)(6916009)(66946007)(66446008)(64756008)(66556008)(66476007)(36756003)(6486002)(5660300002)(54906003)(52116002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3048;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EFKGFHkuylKeUCnit4cKR/ydKdmz7sM63UgKipl53WNDHPMi0qMb/OLlx9CPo+WUW6jjFr8z9xNN8T/fHq2t51hXD0a8pIofx7aX8X5T3uS9iuztru3j92gmVGqCuDv0s8OJwb2DmNYFm5T+i3WT5ZsJeApDdsOKMuR6eBw8bUEK/j/STVU99cKlhx0meFdFUMrIEIk/fLF70mL7eoJfoqD32RiUeVUnbxZ1XaP46U7+kBjDWf9cXOz7cDZXINwddsV+ic44xJTwxaoqkDhGw14gx1QszKrjz5sngReKeTK6p9CXy3AmwIqGt8ZX1gE6/ZNKXtWgUflrnn08LXQSf+hJenOv6XbapA+VnzlIy0vmbMMkvxPAx3LBeJotqx99CnN9EoAbEgsExv2lBhZTv5Znv/aVjFKR3Z2SxRFTuwT29YVLn5K9GoXSNID21VRY
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df4881ab-827f-40e7-6560-08d783ca4a67
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 14:55:15.4825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /5/xM1Lsk3R1VjhRfytuU9QTTvVdRx8W3AiQoA0epfL7m7iTk+ytRQAmvTR43Dv/Wuq/WHeI5fcxsvrgMhc9LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3048
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
index e6194b23e9b0..a87e9159338c 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -102,6 +102,91 @@ static u32 ets_class_id(struct Qdisc *sch, const struc=
t ets_class *cl)
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
@@ -154,6 +239,8 @@ static int ets_class_change(struct Qdisc *sch, u32 clas=
sid, u32 parentid,
 	sch_tree_lock(sch);
 	cl->quantum =3D quantum;
 	sch_tree_unlock(sch);
+
+	ets_offload_change(sch);
 	return 0;
 }
=20
@@ -173,6 +260,7 @@ static int ets_class_graft(struct Qdisc *sch, unsigned =
long arg,
 	}
=20
 	*old =3D qdisc_replace(sch, new, &cl->qdisc);
+	ets_offload_graft(sch, new, *old, arg, extack);
 	return 0;
 }
=20
@@ -589,6 +677,7 @@ static int ets_qdisc_change(struct Qdisc *sch, struct n=
lattr *opt,
=20
 	sch_tree_unlock(sch);
=20
+	ets_offload_change(sch);
 	for (i =3D q->nbands; i < oldbands; i++) {
 		qdisc_put(q->classes[i].qdisc);
 		memset(&q->classes[i], 0, sizeof(q->classes[i]));
@@ -633,6 +722,7 @@ static void ets_qdisc_destroy(struct Qdisc *sch)
 	struct ets_sched *q =3D qdisc_priv(sch);
 	int band;
=20
+	ets_offload_destroy(sch);
 	tcf_block_put(q->block);
 	for (band =3D 0; band < q->nbands; band++)
 		qdisc_put(q->classes[band].qdisc);
@@ -645,6 +735,11 @@ static int ets_qdisc_dump(struct Qdisc *sch, struct sk=
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

