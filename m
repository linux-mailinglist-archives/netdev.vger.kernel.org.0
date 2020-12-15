Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECBA2DA8BA
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 08:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgLOHnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 02:43:51 -0500
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:14901
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726588AbgLOHnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 02:43:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1oXuEfvCVk5oGTW9H52NIzFZFfPKQByhFBlDkynn2JFTr1fHGhTKcFky/IP0kvgHt5MJoJ7FIvkPMUewYC2S5txKG8pOUOiVxZWeoz5jJ+b+yDshl08gsT04sxR/xzemEUiXDzLToUuGOsuuqJ0VOyeJ7Oc8uprP7d1mVIMeg4FVXjiMtk8+/f2zryhYk0dr4ztXbLPs9sSGm9lXMoA7ZyTOGfLuYbsQ0BsGRuE7RGuiYN5nbDJkdVxBI/GDX2X+XCYzL5AV8Bead2Ri9ZzVimBxbc5yFXJkgAtgKzZ/ah6vcl1qzcQYd//jeDKje+MqLWZAVU1z6YRhYqa8sPqZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iwissr9LdJVxkoYfmVA6482G4/+TJ4JqjrPrPwHGJWc=;
 b=WabS1iWXo32gr+cAWpieJTnn1NDAsPDMKTYNGZtzC4Lq1s/XJK+ahNVX6mCVYJZzCjFO1yJONA2BmQDbS5R/8nIafWW0H35QgnvvJAopOnYZR73jYiW93dT5tdPOlTdUSrGEtIG1jhWG1JTtELF4bl0L8UOs80jU5HRUHZrmvdhl24jYlGpbdPlVI7BDbG1Tl2/salBI0+u3VAWf342uMVV66px3PaPvqKzAmP2mLvpEAr6430hJxf/GEvMYWISH2eb1Ym0ftpuGKR3gE7wVXmsq0KAYJWq0sHCCGnSMNQojJvHS9nUGCc4qHn1HerCLtaKyoKQRTiDVZhCBGgjBAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iwissr9LdJVxkoYfmVA6482G4/+TJ4JqjrPrPwHGJWc=;
 b=J6J7zdod+/xPrlicitbM0VUkgL/gkdxlLTpP5nubPer44/BpGm0p82hcCvQ5zs4shGj88K6Wh3Pf2N8/UGxMdenje05BtTPY2+8fyj7eqB44mDupfDyzOkj+hIToCP0+K0iqdgeOwas/x5WAmar2FamLBntPhryb5zjuouVbNOk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5982.eurprd05.prod.outlook.com (2603:10a6:803:e4::28)
 by VI1PR0501MB2335.eurprd05.prod.outlook.com (2603:10a6:800:2e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Tue, 15 Dec
 2020 07:42:09 +0000
Received: from VI1PR05MB5982.eurprd05.prod.outlook.com
 ([fe80::ddc9:9ef:5ece:9fd2]) by VI1PR05MB5982.eurprd05.prod.outlook.com
 ([fe80::ddc9:9ef:5ece:9fd2%5]) with mapi id 15.20.3654.015; Tue, 15 Dec 2020
 07:42:09 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net-next v3 3/4] sch_htb: Stats for offloaded HTB
Date:   Tue, 15 Dec 2020 09:42:12 +0200
Message-Id: <20201215074213.32652-5-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201215074213.32652-1-maximmi@mellanox.com>
References: <20201215074213.32652-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [94.188.199.18]
X-ClientProxiedBy: AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38)
 To VI1PR05MB5982.eurprd05.prod.outlook.com (2603:10a6:803:e4::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 07:42:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4319bcb0-6cc6-42c7-809a-08d8a0cceddc
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2335:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0501MB23357FB8DAA721773EFAE4D7D1C60@VI1PR0501MB2335.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:12;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9MHGI/zZHFsNANe7fPjlcTI5+qVc89nvzKiCXkR4wKZdvD4YqAJd4QG+xRYGzU/bg8R7rxjzeSLWMkHFJSA7z8Xsqk1s1Fi58RwRmxHQ8Mkyfcn8tfHITSzRt86uUVnXrcvEo3gqt3OkTOn6uQJSR0B/UoLIoYBMsDEUE7ZedhXWtMXaT252/jDyQLBh0nHszRPHmwsfl+FWDxZaFPB1X58sBPLMVo171M87XXX/vjQqPfB9BaDFj7BrDKaLGa9ZihfcpuRHFiqvR802vMvge0VxBnHj6K8V7d/oAWYREU2wmWzR/SLbZMd/exmPhgJR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5982.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(8676002)(52116002)(186003)(6486002)(16526019)(2906002)(66476007)(7416002)(66946007)(110136005)(6506007)(316002)(36756003)(5660300002)(66556008)(8936002)(6666004)(54906003)(83380400001)(26005)(107886003)(1076003)(2616005)(86362001)(478600001)(6512007)(4326008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gzFS7/f6EPDUOMmLzAugfAS/H4gLOuOseCLWtZvi4bWjbu/fd8A38giW3TS9?=
 =?us-ascii?Q?OhGfT2MydM5g6Vj+d63Thtx/PO5bchUomyZawdYDdxJLJzbp/AgK/64olBzs?=
 =?us-ascii?Q?2y22I3u15dVytDGFlMFjPzJihfjyOwXQaoOSMh0Eo20kLy7mSDJK6G+3kzBG?=
 =?us-ascii?Q?IUlIIDs4YSi3qqpHYkXhyn1n5UNsWH+qx8SN+U7Ccdb9/LwFyMy28MSycezJ?=
 =?us-ascii?Q?LVri3IKUm7R5oZClu6jbTsuAo0LOpft/h0ew9TF2+cbsA4xB81Zo4NNybOA9?=
 =?us-ascii?Q?sYxYWmjwW2wBcrXm95bTVT6wxJ/H4Hhrwn9hzFlvgBl372h6yJ/AJ6LN+aVD?=
 =?us-ascii?Q?Ecd6XpNmtmquZLBtW6iKDNSI5zVjIs9UoTNuHoI/bdCcOfHPQorFOYJKZkSq?=
 =?us-ascii?Q?xvSZiHwrY1M0PDjaunX3L2hCI9WoLKPdaywDXYdW37R9ljqk/IRUOlbtJHLJ?=
 =?us-ascii?Q?sJc39NlrW7wAB2AHRSkTcCMIr2qqMPCbgnnIhBQz8GmVCOqjZLShgj4YJ4Jt?=
 =?us-ascii?Q?isRBoRmdYLs0RxcOVRilyN7gBIJw16dFJMv5yDINlGkDpkAZV+Ddig5oP0pq?=
 =?us-ascii?Q?WccZ7BoHhEvx83uTgvJkQ+TTTyaB56Nc50WO75ip5yibjOt5csKl2r1GXRbv?=
 =?us-ascii?Q?hvSNPZ+4djfbXjnFZh9YWkMIeEXSEPuAry1O1+OdOTHG71qfiZ6KG5sC8XVc?=
 =?us-ascii?Q?lb5a90CEaJPBCKtq+BKab6iCGT9dZXfy/h0r7uJysDg5bHAboVVd5+R0e5DJ?=
 =?us-ascii?Q?o3Sob6C+oChRDCVTEPar+IbgPO1HxYZgK0IXWhEwy3RJ0TzZhzsVrNt+DtGK?=
 =?us-ascii?Q?TdjPJh0Mme5jN/sEVzrHfvmEgBseI14zBxCZnj3acBZoPRg5zZd88PixRe1B?=
 =?us-ascii?Q?1eQMM+lE2PIQAjKgtsBJMGfygunqrg2qSdAKzT/C9gjE1PqAvMAbiAS+X3aX?=
 =?us-ascii?Q?YbjR4IVbkcB9j12aeHdWdobWStDo906K75/nYTivpzViR13w7lOYJQEUeuNC?=
 =?us-ascii?Q?gOi7?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5982.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 07:42:09.5879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 4319bcb0-6cc6-42c7-809a-08d8a0cceddc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p0jcXM+fpDAWvd63RnJadkMy6UExKw76VewESGORsWQ9pE8hPOUVqk0wd2qZQdKkimhVtQk4eGag+GUXT8qj6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for statistics of offloaded HTB. Bytes and
packets counters for leaf and inner nodes are supported, the values are
taken from per-queue qdiscs, and the numbers that the user sees should
have the same behavior as the software (non-offloaded) HTB.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/sched/sch_htb.c | 53 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index fccdce591104..8fbcfff625aa 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -114,6 +114,7 @@ struct htb_class {
 	 * Written often fields
 	 */
 	struct gnet_stats_basic_packed bstats;
+	struct gnet_stats_basic_packed bstats_bias;
 	struct tc_htb_xstats	xstats;	/* our special stats */
 
 	/* token bucket parameters */
@@ -1216,6 +1217,7 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 			  struct sk_buff *skb, struct tcmsg *tcm)
 {
 	struct htb_class *cl = (struct htb_class *)arg;
+	struct htb_sched *q = qdisc_priv(sch);
 	struct nlattr *nest;
 	struct tc_htb_opt opt;
 
@@ -1242,6 +1244,8 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 	opt.level = cl->level;
 	if (nla_put(skb, TCA_HTB_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
+	if (q->offload && nla_put_flag(skb, TCA_HTB_OFFLOAD))
+		goto nla_put_failure;
 	if ((cl->rate.rate_bytes_ps >= (1ULL << 32)) &&
 	    nla_put_u64_64bit(skb, TCA_HTB_RATE64, cl->rate.rate_bytes_ps,
 			      TCA_HTB_PAD))
@@ -1258,10 +1262,39 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 	return -1;
 }
 
+static void htb_offload_aggregate_stats(struct htb_sched *q,
+					struct htb_class *cl)
+{
+	struct htb_class *c;
+	unsigned int i;
+
+	memset(&cl->bstats, 0, sizeof(cl->bstats));
+
+	for (i = 0; i < q->clhash.hashsize; i++) {
+		hlist_for_each_entry(c, &q->clhash.hash[i], common.hnode) {
+			struct htb_class *p = c;
+
+			while (p && p->level < cl->level)
+				p = p->parent;
+
+			if (p != cl)
+				continue;
+
+			cl->bstats.bytes += c->bstats_bias.bytes;
+			cl->bstats.packets += c->bstats_bias.packets;
+			if (c->level == 0) {
+				cl->bstats.bytes += c->leaf.q->bstats.bytes;
+				cl->bstats.packets += c->leaf.q->bstats.packets;
+			}
+		}
+	}
+}
+
 static int
 htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
 {
 	struct htb_class *cl = (struct htb_class *)arg;
+	struct htb_sched *q = qdisc_priv(sch);
 	struct gnet_stats_queue qs = {
 		.drops = cl->drops,
 		.overlimits = cl->overlimits,
@@ -1276,6 +1309,19 @@ htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
 	cl->xstats.ctokens = clamp_t(s64, PSCHED_NS2TICKS(cl->ctokens),
 				     INT_MIN, INT_MAX);
 
+	if (q->offload) {
+		if (!cl->level) {
+			if (cl->leaf.q)
+				cl->bstats = cl->leaf.q->bstats;
+			else
+				memset(&cl->bstats, 0, sizeof(cl->bstats));
+			cl->bstats.bytes += cl->bstats_bias.bytes;
+			cl->bstats.packets += cl->bstats_bias.packets;
+		} else {
+			htb_offload_aggregate_stats(q, cl);
+		}
+	}
+
 	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
 				  d, NULL, &cl->bstats) < 0 ||
 	    gnet_stats_copy_rate_est(d, &cl->rate_est) < 0 ||
@@ -1458,6 +1504,11 @@ static void htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 		WARN_ON(old != q);
 	}
 
+	if (cl->parent) {
+		cl->parent->bstats_bias.bytes += q->bstats.bytes;
+		cl->parent->bstats_bias.packets += q->bstats.packets;
+	}
+
 	offload_opt = (struct tc_htb_qopt_offload) {
 		.command = last_child ? TC_HTB_LEAF_DEL_LAST : TC_HTB_LEAF_DEL,
 		.classid = cl->common.classid,
@@ -1781,6 +1832,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 				htb_graft_helper(dev_queue, old_q);
 				goto err_kill_estimator;
 			}
+			parent->bstats_bias.bytes += old_q->bstats.bytes;
+			parent->bstats_bias.packets += old_q->bstats.packets;
 			qdisc_put(old_q);
 		}
 		new_q = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
-- 
2.20.1

