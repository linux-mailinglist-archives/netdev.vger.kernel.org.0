Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C58B103AA9
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbfKTNFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:25 -0500
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:19220
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728584AbfKTNFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0WQIXacX8u+WEvUDSld7ASmOZoByeucpShKNV4khQDwx1wFoA4LgeJJki5P3akQGYLgJ+EXxH+CoPoDXxwUE3m+5Xwwjf8Yueqd9RH4L9K7LT30bMWAaPBCOIMqiCVML6AyaSxY0d0ia4nFAB33w9b2VJnqwQKMYSCHEH9MR1S3Iq2hZZGWbN3DD5R57HrRTzE5XzNb4AE6eIfxONu+n9cxXS/PGiaI4U59XwWq09VcecQESxd8czHVLcZ5hwspswctoE5fQ0zbS7ATGD1YtqrwZOjP6LJdyeIxm2ctuFNh8uKFyv5pfNJ7KSrgiJ2MPN20WV0m+y0varAsWJFwYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awvKKj7Bwg77PP83h2qPFZXchKWK0rxOIhSG41aG+lY=;
 b=cQEMU6DmlBK7yJ6brLX3FitsVEw3pmoVSaQ1IcKxgXNfkUpT1C/eMpGnKUCUlok6cUBt6BEhbR4YUmh574NC7kJpuMnm1s3jm7TCEudzWl9XNGHX2V7qr9gwtisgNiLMXz3/kobDSK6kR2zrM0vCtxm3ilTpgQtAIgah1a9Rb2NGgopfe720i9pili7EMXtgArUGOQDCL0MCQ/kkAqE5mvU894tyic9scMWtrVxtBhdQo+kur+LRYkT7DYdItQyVQVCvtr4SCNRAOxNaEtiiSWb2+74lRMDDvszsQ9wFMMtjYtN6wz+HvFzveHZ/9AuXoArAESgi1osWUrA+TDE3iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awvKKj7Bwg77PP83h2qPFZXchKWK0rxOIhSG41aG+lY=;
 b=TL9Zt5af7BTs/B5xu2uAh4JrsSwHTLWvBE75CflMkuYt3usvrC8g3JUznWn6dryvMQKpsS8/HPMOOrEfilaDT25cr0EM6m2yPR4/M7Nyb/nCQsVxPhf+1V4XWlplJXEtKDGIaAyPpLNL2pjG9/v4r9jDZgKHBq/MEjqNDBrS6n4=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2982.eurprd05.prod.outlook.com (10.172.246.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 13:05:13 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:13 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 04/10] net: sch_ets: Add a new Qdisc
Thread-Topic: [RFC PATCH 04/10] net: sch_ets: Add a new Qdisc
Thread-Index: AQHVn6MlYEWaQcYtpUmaxcEdHFwHEA==
Date:   Wed, 20 Nov 2019 13:05:12 +0000
Message-ID: <202d6653aef041b11c9e730e7bfa78314fdb8c0b.1574253236.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: cd5f5201-423f-4fb4-311f-08d76dba475d
x-ms-traffictypediagnostic: DB6PR0502MB2982:|DB6PR0502MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB29828FD8219722F40A8241E1DB4F0@DB6PR0502MB2982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(102836004)(1730700003)(6436002)(2616005)(446003)(50226002)(81156014)(81166006)(478600001)(66556008)(8936002)(66476007)(66946007)(14454004)(5640700003)(6506007)(2906002)(386003)(36756003)(66446008)(66066001)(8676002)(6486002)(26005)(186003)(54906003)(7736002)(316002)(6512007)(305945005)(76176011)(71190400001)(71200400001)(2351001)(256004)(64756008)(30864003)(2501003)(52116002)(86362001)(14444005)(486006)(6116002)(11346002)(3846002)(5660300002)(25786009)(99286004)(476003)(6916009)(4326008)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2982;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I57XrU51xxNTfAWGPop/oCIIC6irObuBVSB7CKiy0okCF+HbhPmeDh9jYP+8E+/BHdE1k5W8CudDaKiPpUIDDHXHKJE531JJsSm9pTvNXLZ6ZJwPqVq3rSGLlGanaloxP8zPfKEDoupR/VXsEEtR2YMXXhab5ugA/8Bgdm7nz0oFfmOjAezgw74bHiTiHLv1SBNCiClmlPldXZxlOF1zr3nNlCgcZeg5Qf7vYvSNhS8G9i4ruDoC99/FYsZ1BsbBYN2cWr3Ztb7Jsr10AB+o8+oNUXDlJNymB4IuJ8+cZSNf5SOwLMKQXyL4shEUWKWM1xP4g8FxkekpsFSoZ2IVETk2rS/i7oibw+Gij6hv1QES5Eq1jw6K+G+bntEH6i5dtHFCXmNWq4VU/yy7EF2UGSErUtlDSuftYu5iQnBqQjWQsmnZPhe0aINSG5KhzpU0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd5f5201-423f-4fb4-311f-08d76dba475d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:12.8667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F9ossGdzoytjc/Sm8kF8lmmXKqxu1QIZ/KtCVD/gNlyrxu+Dgcy3tuZ7SSyuC6HN1HXCw8XqfPnwo4fYFW8p4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduces a new Qdisc, which is based on 802.1Q-2014 wording. It is
PRIO-like in how it is configured, meaning one needs to specify how many
bands there are, how many are strict and how many are dwrr, quanta for the
latter, and priomap.

The new Qdisc operates like the PRIO / DRR combo would when configured as
per the standard. The strict classes, if any, are tried for traffic first.
When there's no traffic in any of the strict queues, the ETS ones (if any)
are treated in the same way as in DRR.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/uapi/linux/pkt_sched.h |  29 ++
 net/sched/Kconfig              |  11 +
 net/sched/Makefile             |   1 +
 net/sched/sch_ets.c            | 701 +++++++++++++++++++++++++++++++++
 4 files changed, 742 insertions(+)
 create mode 100644 net/sched/sch_ets.c

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.=
h
index 5011259b8f67..d7f1bd8fd136 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1181,4 +1181,33 @@ enum {
=20
 #define TCA_TAPRIO_ATTR_MAX (__TCA_TAPRIO_ATTR_MAX - 1)
=20
+/* ETS */
+
+#define TCQ_ETS_MAX_BANDS 16
+
+enum {
+	TCA_ETS_UNSPEC,
+	TCA_ETS_BANDS,	/* u8 */
+	TCA_ETS_STRICT,	/* u8 */
+	TCA_ETS_QUANTA,	/* nested TCA_ETS_BAND_QUANTUM */
+	TCA_ETS_PRIOMAP,	/* nested TCA_ETS_PMAP_BAND */
+	__TCA_ETS_MAX,
+};
+
+#define TCA_ETS_MAX (__TCA_ETS_MAX - 1)
+
+enum {
+	TCA_ETS_BAND_UNSPEC,
+	TCA_ETS_BAND_QUANTUM,	/* u32 */
+	__TCA_ETS_BAND_MAX,
+};
+#define TCA_ETS_BAND_MAX (__TCA_ETS_BAND_MAX - 1)
+
+enum {
+	TCA_ETS_PMAP_UNSPEC,
+	TCA_ETS_PMAP_BAND,	/* u8 */
+	__TCA_ETS_PMAP_MAX,
+};
+#define TCA_ETS_PMAP_MAX (__TCA_ETS_PMAP_MAX - 1)
+
 #endif
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 2985509147a2..192878a1095e 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -409,6 +409,17 @@ config NET_SCH_PLUG
 	  To compile this code as a module, choose M here: the
 	  module will be called sch_plug.
=20
+config NET_SCH_ETS
+	tristate "Enhanced transmission selection scheduler (ETS)"
+	help
+	  Say Y here if you want to use the 802.1Qaz-compliant "enhanced
+	  transmission selection" packet scheduling algorithm.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sch_drr.
+
+	  If unsure, say N.
+
 menuconfig NET_SCH_DEFAULT
 	bool "Allow override default queue discipline"
 	---help---
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 415d1e1f237e..bc8856b865ff 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_NET_SCH_ATM)	+=3D sch_atm.o
 obj-$(CONFIG_NET_SCH_NETEM)	+=3D sch_netem.o
 obj-$(CONFIG_NET_SCH_DRR)	+=3D sch_drr.o
 obj-$(CONFIG_NET_SCH_PLUG)	+=3D sch_plug.o
+obj-$(CONFIG_NET_SCH_ETS)	+=3D sch_ets.o
 obj-$(CONFIG_NET_SCH_MQPRIO)	+=3D sch_mqprio.o
 obj-$(CONFIG_NET_SCH_SKBPRIO)	+=3D sch_skbprio.o
 obj-$(CONFIG_NET_SCH_CHOKE)	+=3D sch_choke.o
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
new file mode 100644
index 000000000000..6a1751564c4b
--- /dev/null
+++ b/net/sched/sch_ets.c
@@ -0,0 +1,701 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * net/sched/sch_ets.c         Enhanced Transmission Selection scheduler
+ */
+
+#include <linux/module.h>
+#include <net/gen_stats.h>
+#include <net/netlink.h>
+#include <net/pkt_sched.h>
+#include <net/pkt_cls.h>
+#include <net/sch_generic.h>
+
+struct ets_class {
+	struct list_head alist; /* In struct ets_sched.active. */
+	struct Qdisc *qdisc;
+	u32 quantum;
+	u32 deficit;
+	struct gnet_stats_basic_packed bstats;
+	struct gnet_stats_queue qstats;
+};
+
+struct ets_sched {
+	struct list_head active;
+	struct tcf_proto __rcu *filter_list;
+	struct tcf_block *block;
+	unsigned int nbands;
+	unsigned int nstrict;
+	u8 prio2band[TC_PRIO_MAX + 1];
+	struct ets_class classes[TCQ_ETS_MAX_BANDS];
+};
+
+static const struct nla_policy ets_policy[TCA_ETS_MAX + 1] =3D {
+	[TCA_ETS_BANDS] =3D { .type =3D NLA_U8 },
+	[TCA_ETS_STRICT] =3D { .type =3D NLA_U8 },
+	[TCA_ETS_QUANTA] =3D { .type =3D NLA_NESTED },
+	[TCA_ETS_PRIOMAP] =3D { .type =3D NLA_NESTED },
+};
+
+static const struct nla_policy ets_pmap_policy[TCA_ETS_PMAP_MAX + 1] =3D {
+	[TCA_ETS_PMAP_BAND] =3D { .type =3D NLA_U8 },
+};
+
+static const struct nla_policy ets_band_policy[TCA_ETS_BAND_MAX + 1] =3D {
+	[TCA_ETS_BAND_QUANTUM]	=3D { .type =3D NLA_U32 },
+};
+
+static int ets_quantum_parse(struct Qdisc *sch, const struct nlattr *attr,
+			     unsigned int *pquantum,
+			     struct netlink_ext_ack *extack)
+{
+	unsigned int quantum;
+
+	if (attr) {
+		quantum =3D nla_get_u32(attr);
+		if (!quantum) {
+			NL_SET_ERR_MSG(extack, "ETS quantum cannot be zero");
+			return -EINVAL;
+		}
+	} else {
+		quantum =3D psched_mtu(qdisc_dev(sch));
+	}
+
+	*pquantum =3D quantum;
+	return 0;
+}
+
+static struct ets_class *
+ets_class_from_arg(struct Qdisc *sch, unsigned long arg)
+{
+	struct ets_sched *q =3D qdisc_priv(sch);
+
+	return &q->classes[arg - 1];
+}
+
+static u32 ets_class_id(struct Qdisc *sch, struct ets_class *cl)
+{
+	struct ets_sched *q =3D qdisc_priv(sch);
+	int band =3D cl - q->classes;
+
+	return TC_H_MAKE(sch->handle, band + 1);
+}
+
+static bool ets_class_is_strict(struct ets_sched *q, struct ets_class *cl)
+{
+	unsigned int band =3D cl - q->classes;
+
+	return band < q->nstrict;
+}
+
+static int ets_class_change(struct Qdisc *sch, u32 classid, u32 parentid,
+			    struct nlattr **tca, unsigned long *arg,
+			    struct netlink_ext_ack *extack)
+{
+	struct ets_class *cl =3D ets_class_from_arg(sch, *arg);
+	struct ets_sched *q =3D qdisc_priv(sch);
+	struct nlattr *opt =3D tca[TCA_OPTIONS];
+	struct nlattr *tb[TCA_ETS_MAX + 1];
+	unsigned int quantum;
+	int err;
+
+	/* Classes can be added and removed only through Qdisc_ops.change
+	 * interface.
+	 */
+	if (!cl) {
+		NL_SET_ERR_MSG(extack, "Fine-grained class addition and removal is not s=
upported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!opt) {
+		NL_SET_ERR_MSG(extack, "ETS options are required for this operation");
+		return -EINVAL;
+	}
+
+	err =3D nla_parse_nested(tb, TCA_ETS_BAND_MAX, opt, ets_band_policy,
+			       extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_ETS_BAND_QUANTUM])
+		/* Nothing to configure. */
+		return 0;
+
+	if (ets_class_is_strict(q, cl)) {
+		NL_SET_ERR_MSG(extack, "Strict bands do not have a configurable quantum"=
);
+		return -EINVAL;
+	}
+
+	err =3D ets_quantum_parse(sch, tb[TCA_ETS_BAND_QUANTUM], &quantum,
+				extack);
+	if (err)
+		return err;
+
+	sch_tree_lock(sch);
+	cl->quantum =3D quantum;
+	sch_tree_unlock(sch);
+	return 0;
+}
+
+static int ets_class_graft(struct Qdisc *sch, unsigned long arg,
+			   struct Qdisc *new, struct Qdisc **old,
+			   struct netlink_ext_ack *extack)
+{
+	struct ets_class *cl =3D ets_class_from_arg(sch, arg);
+
+	if (!new) {
+		new =3D qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
+					ets_class_id(sch, cl), NULL);
+		if (!new)
+			new =3D &noop_qdisc;
+	}
+
+	*old =3D qdisc_replace(sch, new, &cl->qdisc);
+	return 0;
+}
+
+static struct Qdisc *ets_class_leaf(struct Qdisc *sch, unsigned long arg)
+{
+	struct ets_class *cl =3D ets_class_from_arg(sch, arg);
+
+	return cl->qdisc;
+}
+
+static unsigned long ets_class_find(struct Qdisc *sch, u32 classid)
+{
+	struct ets_sched *q =3D qdisc_priv(sch);
+	unsigned long band =3D TC_H_MIN(classid);
+
+	if (band - 1 >=3D q->nbands)
+		return 0;
+	return band;
+}
+
+static void ets_class_qlen_notify(struct Qdisc *sch, unsigned long arg)
+{
+	struct ets_class *cl =3D ets_class_from_arg(sch, arg);
+	struct ets_sched *q =3D qdisc_priv(sch);
+
+	if (!ets_class_is_strict(q, cl))
+		list_del(&cl->alist);
+}
+
+static int ets_class_dump(struct Qdisc *sch, unsigned long arg,
+			  struct sk_buff *skb, struct tcmsg *tcm)
+{
+	struct ets_class *cl =3D ets_class_from_arg(sch, arg);
+	struct ets_sched *q =3D qdisc_priv(sch);
+	struct nlattr *nest;
+
+	tcm->tcm_parent =3D TC_H_ROOT;
+	tcm->tcm_handle =3D ets_class_id(sch, cl);
+	tcm->tcm_info =3D cl->qdisc->handle;
+
+	nest =3D nla_nest_start_noflag(skb, TCA_OPTIONS);
+	if (!nest)
+		goto nla_put_failure;
+	if (!ets_class_is_strict(q, cl)) {
+		if (nla_put_u32(skb, TCA_ETS_BAND_QUANTUM, cl->quantum))
+			goto nla_put_failure;
+	}
+	return nla_nest_end(skb, nest);
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int ets_class_dump_stats(struct Qdisc *sch, unsigned long arg,
+				struct gnet_dump *d)
+{
+	struct ets_class *cl =3D ets_class_from_arg(sch, arg);
+	struct Qdisc *cl_q =3D cl->qdisc;
+
+	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
+				  d, NULL, &cl_q->bstats) < 0 ||
+	    qdisc_qstats_copy(d, cl_q) < 0)
+		return -1;
+
+	return 0;
+}
+
+static void ets_qdisc_walk(struct Qdisc *sch, struct qdisc_walker *arg)
+{
+	struct ets_sched *q =3D qdisc_priv(sch);
+	int i;
+
+	if (arg->stop)
+		return;
+
+	for (i =3D 0; i < q->nbands; i++) {
+		if (arg->count < arg->skip) {
+			arg->count++;
+			continue;
+		}
+		if (arg->fn(sch, i + 1, arg) < 0) {
+			arg->stop =3D 1;
+			break;
+		}
+		arg->count++;
+	}
+}
+
+static struct tcf_block *
+ets_qdisc_tcf_block(struct Qdisc *sch, unsigned long cl,
+		    struct netlink_ext_ack *extack)
+{
+	struct ets_sched *q =3D qdisc_priv(sch);
+
+	if (cl) {
+		NL_SET_ERR_MSG(extack, "ETS classid must be zero");
+		return NULL;
+	}
+
+	return q->block;
+}
+
+static unsigned long ets_qdisc_bind_tcf(struct Qdisc *sch, unsigned long p=
arent,
+					u32 classid)
+{
+	return ets_class_find(sch, classid);
+}
+
+static void ets_qdisc_unbind_tcf(struct Qdisc *sch, unsigned long arg)
+{
+}
+
+static struct ets_class *ets_classify(struct sk_buff *skb, struct Qdisc *s=
ch,
+				      int *qerr)
+{
+	struct ets_sched *q =3D qdisc_priv(sch);
+	u32 band =3D skb->priority;
+	struct tcf_result res;
+	struct tcf_proto *fl;
+	int err;
+
+	*qerr =3D NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
+	if (TC_H_MAJ(skb->priority) !=3D sch->handle) {
+		fl =3D rcu_dereference_bh(q->filter_list);
+		err =3D tcf_classify(skb, fl, &res, false);
+#ifdef CONFIG_NET_CLS_ACT
+		switch (err) {
+		case TC_ACT_STOLEN:
+		case TC_ACT_QUEUED:
+		case TC_ACT_TRAP:
+			*qerr =3D NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
+			/* fall through */
+		case TC_ACT_SHOT:
+			return NULL;
+		}
+#endif
+		if (!fl || err < 0) {
+			if (TC_H_MAJ(band))
+				band =3D 0;
+			return &q->classes[q->prio2band[band & TC_PRIO_MAX]];
+		}
+		band =3D res.classid;
+	}
+	band =3D TC_H_MIN(band) - 1;
+	if (band >=3D q->nbands)
+		return &q->classes[q->prio2band[0]];
+	return &q->classes[band];
+}
+
+static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+			     struct sk_buff **to_free)
+{
+	unsigned int len =3D qdisc_pkt_len(skb);
+	struct ets_sched *q =3D qdisc_priv(sch);
+	struct ets_class *cl;
+	int err =3D 0;
+	bool first;
+
+	cl =3D ets_classify(skb, sch, &err);
+	if (!cl) {
+		if (err & __NET_XMIT_BYPASS)
+			qdisc_qstats_drop(sch);
+		__qdisc_drop(skb, to_free);
+		return err;
+	}
+
+	first =3D !cl->qdisc->q.qlen;
+	err =3D qdisc_enqueue(skb, cl->qdisc, to_free);
+	if (unlikely(err !=3D NET_XMIT_SUCCESS)) {
+		if (net_xmit_drop_count(err)) {
+			cl->qstats.drops++;
+			qdisc_qstats_drop(sch);
+		}
+		return err;
+	}
+
+	if (first && !ets_class_is_strict(q, cl)) {
+		list_add_tail(&cl->alist, &q->active);
+		cl->deficit =3D cl->quantum;
+	}
+
+	sch->qstats.backlog +=3D len;
+	sch->q.qlen++;
+	return err;
+}
+
+static struct sk_buff *
+ets_qdisc_dequeue_skb(struct Qdisc *sch, struct sk_buff *skb)
+{
+	qdisc_bstats_update(sch, skb);
+	qdisc_qstats_backlog_dec(sch, skb);
+	sch->q.qlen--;
+	return skb;
+}
+
+static struct sk_buff *ets_qdisc_dequeue(struct Qdisc *sch)
+{
+	struct ets_sched *q =3D qdisc_priv(sch);
+	struct ets_class *cl;
+	struct sk_buff *skb;
+	unsigned int band;
+	unsigned int len;
+
+	while (1) {
+		for (band =3D 0; band < q->nstrict; band++) {
+			cl =3D &q->classes[band];
+			skb =3D qdisc_dequeue_peeked(cl->qdisc);
+			if (skb)
+				return ets_qdisc_dequeue_skb(sch, skb);
+		}
+
+		if (list_empty(&q->active))
+			goto out;
+
+		cl =3D list_first_entry(&q->active, struct ets_class, alist);
+		skb =3D cl->qdisc->ops->peek(cl->qdisc);
+		if (!skb) {
+			qdisc_warn_nonwc(__func__, cl->qdisc);
+			goto out;
+		}
+
+		len =3D qdisc_pkt_len(skb);
+		if (len <=3D cl->deficit) {
+			cl->deficit -=3D len;
+			skb =3D qdisc_dequeue_peeked(cl->qdisc);
+			if (unlikely(!skb))
+				goto out;
+			if (cl->qdisc->q.qlen =3D=3D 0)
+				list_del(&cl->alist);
+			return ets_qdisc_dequeue_skb(sch, skb);
+		}
+
+		cl->deficit +=3D cl->quantum;
+		list_move_tail(&cl->alist, &q->active);
+	}
+out:
+	return NULL;
+}
+
+static int ets_qdisc_priomap_parse(struct nlattr *priomap_attr,
+				   unsigned int nbands,
+				   u8 priomap[TCA_ETS_MAX + 1],
+				   struct netlink_ext_ack *extack)
+{
+	const struct nlattr *attr;
+	int prio =3D 0;
+	u8 band;
+	int rem;
+	int err;
+
+	err =3D nl80211_validate_nested(priomap_attr, TCA_ETS_PMAP_MAX,
+				      ets_pmap_policy, extack);
+	if (err)
+		return err;
+
+	nla_for_each_nested(attr, priomap_attr, rem) {
+		switch (nla_type(attr)) {
+		case TCA_ETS_PMAP_BAND:
+			if (prio > TC_PRIO_MAX) {
+				NL_SET_ERR_MSG_MOD(extack, "Too many priorities in ETS priomap");
+				return -EINVAL;
+			}
+			band =3D nla_get_u8(attr);
+			if (band >=3D nbands) {
+				NL_SET_ERR_MSG_MOD(extack, "Invalid band number in ETS priomap");
+				return -EINVAL;
+			}
+			priomap[prio++] =3D band;
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(extack, "ETS priomap can contain only ETS_PMAP_BAND =
attributes");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int ets_qdisc_quanta_parse(struct Qdisc *sch, struct nlattr *quanta=
_attr,
+				  unsigned int nbands,
+				  unsigned int nstrict,
+				  unsigned int quanta[TCQ_ETS_MAX_BANDS],
+				  struct netlink_ext_ack *extack)
+{
+	const struct nlattr *attr;
+	int band =3D nstrict;
+	int rem;
+	int err;
+
+	err =3D nl80211_validate_nested(quanta_attr, TCA_ETS_BAND_MAX,
+				      ets_band_policy, extack);
+	if (err < 0)
+		return err;
+
+	nla_for_each_nested(attr, quanta_attr, rem) {
+		switch (nla_type(attr)) {
+		case TCA_ETS_BAND_QUANTUM:
+			if (band >=3D nbands) {
+				NL_SET_ERR_MSG_MOD(extack, "ETS quanta has more values than bands");
+				return -EINVAL;
+			}
+			err =3D ets_quantum_parse(sch, attr, &quanta[band++],
+						extack);
+			if (err)
+				return err;
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(extack, "ETS quanta can contain only ETS_BAND_QUANTU=
M attributes");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
+			    struct netlink_ext_ack *extack)
+{
+	unsigned int quanta[TCQ_ETS_MAX_BANDS] =3D {0};
+	struct Qdisc *queues[TCQ_ETS_MAX_BANDS];
+	struct ets_sched *q =3D qdisc_priv(sch);
+	struct nlattr *tb[TCA_ETS_MAX + 1];
+	u8 priomap[TC_PRIO_MAX + 1] =3D {0};
+	unsigned int oldbands =3D q->nbands;
+	unsigned int nstrict =3D 0;
+	unsigned int nbands;
+	unsigned int i;
+	int err;
+
+	if (!opt) {
+		NL_SET_ERR_MSG(extack, "ETS options are required for this operation");
+		return -EINVAL;
+	}
+
+	err =3D nla_parse_nested(tb, TCA_ETS_MAX, opt, ets_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_ETS_BANDS]) {
+		NL_SET_ERR_MSG_MOD(extack, "Number of bands is a required argument");
+		return -EINVAL;
+	}
+	nbands =3D nla_get_u8(tb[TCA_ETS_BANDS]);
+	if (nbands < 1 || nbands > TCQ_ETS_MAX_BANDS) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid number of bands");
+		return -EINVAL;
+	}
+
+	if (tb[TCA_ETS_STRICT]) {
+		nstrict =3D nla_get_u8(tb[TCA_ETS_STRICT]);
+		if (nstrict > nbands) {
+			NL_SET_ERR_MSG_MOD(extack, "Invalid number of strict bands");
+			return -EINVAL;
+		}
+	}
+
+	if (tb[TCA_ETS_PRIOMAP]) {
+		err =3D ets_qdisc_priomap_parse(tb[TCA_ETS_PRIOMAP],
+					      nbands, priomap, extack);
+		if (err)
+			return err;
+	}
+
+	if (tb[TCA_ETS_QUANTA]) {
+		err =3D ets_qdisc_quanta_parse(sch, tb[TCA_ETS_QUANTA],
+					     nbands, nstrict, quanta, extack);
+		if (err)
+			return err;
+	}
+	for (i =3D nstrict; i < nbands; i++) {
+		if (!quanta[i])
+			ets_quantum_parse(sch, NULL, &quanta[i], extack);
+	}
+
+	/* Before commit, make sure we can allocate all new qdiscs */
+	for (i =3D oldbands; i < nbands; i++) {
+		queues[i] =3D qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
+					      ets_class_id(sch, &q->classes[i]),
+					      extack);
+		if (!queues[i]) {
+			while (i > oldbands)
+				qdisc_put(queues[--i]);
+			return -ENOMEM;
+		}
+	}
+
+	sch_tree_lock(sch);
+
+	q->nbands =3D nbands;
+	q->nstrict =3D nstrict;
+	memcpy(q->prio2band, priomap, sizeof(priomap));
+
+	for (i =3D q->nbands; i < oldbands; i++)
+		qdisc_tree_flush_backlog(q->classes[i].qdisc);
+
+	for (i =3D 0; i < q->nbands; i++)
+		q->classes[i].quantum =3D quanta[i];
+
+	for (i =3D oldbands; i < q->nbands; i++) {
+		q->classes[i].qdisc =3D queues[i];
+		if (q->classes[i].qdisc !=3D &noop_qdisc)
+			qdisc_hash_add(q->classes[i].qdisc, true);
+	}
+
+	sch_tree_unlock(sch);
+
+	for (i =3D q->nbands; i < oldbands; i++) {
+		qdisc_put(q->classes[i].qdisc);
+		memset(&q->classes[i], 0, sizeof(q->classes[i]));
+	}
+	return 0;
+}
+
+static int ets_qdisc_init(struct Qdisc *sch, struct nlattr *opt,
+			  struct netlink_ext_ack *extack)
+{
+	struct ets_sched *q =3D qdisc_priv(sch);
+	int err;
+
+	if (!opt)
+		return -EINVAL;
+
+	err =3D tcf_block_get(&q->block, &q->filter_list, sch, extack);
+	if (err)
+		return err;
+
+	INIT_LIST_HEAD(&q->active);
+	return ets_qdisc_change(sch, opt, extack);
+}
+
+static void ets_qdisc_reset(struct Qdisc *sch)
+{
+	struct ets_sched *q =3D qdisc_priv(sch);
+	int band;
+
+	for (band =3D q->nstrict; band < q->nbands; band++) {
+		if (q->classes[band].qdisc->q.qlen)
+			list_del(&q->classes[band].alist);
+	}
+	for (band =3D 0; band < q->nbands; band++)
+		qdisc_reset(q->classes[band].qdisc);
+	sch->qstats.backlog =3D 0;
+	sch->q.qlen =3D 0;
+}
+
+static void ets_qdisc_destroy(struct Qdisc *sch)
+{
+	struct ets_sched *q =3D qdisc_priv(sch);
+	int band;
+
+	tcf_block_put(q->block);
+	for (band =3D 0; band < q->nbands; band++)
+		qdisc_put(q->classes[band].qdisc);
+}
+
+static int ets_qdisc_dump(struct Qdisc *sch, struct sk_buff *skb)
+{
+	struct ets_sched *q =3D qdisc_priv(sch);
+	struct nlattr *opts;
+	struct nlattr *nest;
+	int band;
+	int prio;
+
+	opts =3D nla_nest_start_noflag(skb, TCA_OPTIONS);
+	if (!opts)
+		goto nla_err;
+
+	if (nla_put_u8(skb, TCA_ETS_BANDS, q->nbands))
+		goto nla_err;
+
+	if (q->nstrict &&
+	    nla_put_u8(skb, TCA_ETS_STRICT, q->nstrict))
+		goto nla_err;
+
+	if (q->nbands > q->nstrict) {
+		nest =3D nla_nest_start(skb, TCA_ETS_QUANTA);
+		if (!nest)
+			goto nla_err;
+
+		for (band =3D q->nstrict; band < q->nbands; band++) {
+			if (nla_put_u32(skb, TCA_ETS_BAND_QUANTUM,
+					q->classes[band].quantum))
+				goto nla_err;
+		}
+
+		nla_nest_end(skb, nest);
+	}
+
+	nest =3D nla_nest_start(skb, TCA_ETS_PRIOMAP);
+	if (!nest)
+		goto nla_err;
+
+	for (prio =3D 0; prio <=3D TC_PRIO_MAX; prio++) {
+		if (nla_put_u8(skb, TCA_ETS_PMAP_BAND, q->prio2band[prio]))
+			goto nla_err;
+	}
+
+	nla_nest_end(skb, nest);
+
+	return nla_nest_end(skb, opts);
+
+nla_err:
+	nla_nest_cancel(skb, opts);
+	return -EMSGSIZE;
+}
+
+static const struct Qdisc_class_ops ets_class_ops =3D {
+	.change		=3D ets_class_change,
+	.graft		=3D ets_class_graft,
+	.leaf		=3D ets_class_leaf,
+	.find		=3D ets_class_find,
+	.qlen_notify	=3D ets_class_qlen_notify,
+	.dump		=3D ets_class_dump,
+	.dump_stats	=3D ets_class_dump_stats,
+	.walk		=3D ets_qdisc_walk,
+	.tcf_block	=3D ets_qdisc_tcf_block,
+	.bind_tcf	=3D ets_qdisc_bind_tcf,
+	.unbind_tcf	=3D ets_qdisc_unbind_tcf,
+};
+
+static struct Qdisc_ops ets_qdisc_ops __read_mostly =3D {
+	.cl_ops		=3D &ets_class_ops,
+	.id		=3D "ets",
+	.priv_size	=3D sizeof(struct ets_sched),
+	.enqueue	=3D ets_qdisc_enqueue,
+	.dequeue	=3D ets_qdisc_dequeue,
+	.peek		=3D qdisc_peek_dequeued,
+	.change		=3D ets_qdisc_change,
+	.init		=3D ets_qdisc_init,
+	.reset		=3D ets_qdisc_reset,
+	.destroy	=3D ets_qdisc_destroy,
+	.dump		=3D ets_qdisc_dump,
+	.owner		=3D THIS_MODULE,
+};
+
+static int __init ets_init(void)
+{
+	return register_qdisc(&ets_qdisc_ops);
+}
+
+static void __exit ets_exit(void)
+{
+	unregister_qdisc(&ets_qdisc_ops);
+}
+
+module_init(ets_init);
+module_exit(ets_exit);
+MODULE_LICENSE("GPL");
--=20
2.20.1

