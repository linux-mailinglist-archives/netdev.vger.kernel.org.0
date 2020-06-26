Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851C320BCEC
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgFZWrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:47:08 -0400
Received: from mail-eopbgr60081.outbound.protection.outlook.com ([40.107.6.81]:37251
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726015AbgFZWrI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 18:47:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgtQxujPskmMz6OjJfPSj/8//ZuYVyrW221pUEXUBdQmPXMej8ZAjoeV7CaEqwLdPNXxbZhNxhGn0egIKB8pzirLW8eZZE7ijkwya/t22TioEgjQRFdxrTTL334MpVfqo32cE1Hu9EsBjZv2VoFSSB6yARg8Yx3zfj+5kz30D8hSP/ehHGzB7UVjjvJd9l/QyP2BXcGDLDIMenHZXwdBjl0E3QgXYPVDkC5o5A0xoMatCpy0w5XX47qZW7BLo7Vx7QCWQ60GS1a3ibRXfy/cD/bxuli+Mhch4OP/cpQhUBwxsxPw0UYQoDB05kyCUYLyN7SH45SZo64ErMBTSY4IdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHchoXs3erP7ZMi2kXO6e1L5cW90tiasoUmGUmLkyGg=;
 b=f9lWA9Iyuq4xBRm28UXM2czpnGI1tcdCqeJdajTE6GBFpyzaNfH1pw44Eio//E8Db69WdNIBwQBGi0er/FLmk8At8PQSHbpUh1npI9WjJ8Dtc1B1xO47paiR0OWFjJ3yzf6WP5EU8oJklW70agTo8h0I4FWUQYQr/OyBeVYUWqCBeJ/F97NiB2i/PVaIwSjZ5jzh7FWpELoPlzSgIbyZU0zQwITvf8id22VvmiXSCJUa+xn5BtZXFGGwwN6EAAPjushnyc6awwjX/zbgAW57LSlA5gv1QFTeYiTUJftuughAVTrnqx7/u/N/03/ijeZH8i1I7oJAQZQ8y1MoeOGDVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHchoXs3erP7ZMi2kXO6e1L5cW90tiasoUmGUmLkyGg=;
 b=V61u996u+E5Kaf3HQ0MomIztPq8YN8ImV6xcGwrMjf0Z5KdeJClHc169xkI/KFQGTEM225+/Pt4LuwPRNJEhzj5MZcfDbzvmMmGNwZfxts6/TKN17GpQjCUXHm/jxQ6hUlOi1jUk62YxJmWFDulRKujyP9bradrkuajZZLgbSwk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3196.eurprd05.prod.outlook.com (2603:10a6:7:33::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.21; Fri, 26 Jun 2020 22:46:10 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 22:46:10 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com, Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next v1 1/5] net: sched: Pass root lock to Qdisc_ops.enqueue
Date:   Sat, 27 Jun 2020 01:45:25 +0300
Message-Id: <643ef0859371d3bf6280f5014d668fb18b3b6d85.1593209494.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1593209494.git.petrm@mellanox.com>
References: <cover.1593209494.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0139.eurprd05.prod.outlook.com
 (2603:10a6:207:3::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:207:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 22:46:08 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be378b76-f56d-477d-05a2-08d81a22b875
X-MS-TrafficTypeDiagnostic: HE1PR05MB3196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB31960E7911F49C94AFC393C0DB930@HE1PR05MB3196.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hu3wVhuGqXgdXo+29NMPjVQ2nqZEKYIcGtE0ki6EACuIVdyTcLbspVq7wosOLfQ8cOLJX63EILyHTp57Cs/15WrVwUFVTcLAL2G5VHxJACl3JjqwxJHn0pxzy6/GQu1iilO4QT99NJ/8ppL9GwzVJPtcV+PeFrlOjsSep676IH3RkvOL22vX7UCiHNyzZNiH3xP6gXSO3thzDwfq7bFCFDQPn7YMRT2WdGYSxQso/yRXoEjCKyzaLx8+BdZ1aBwNrj9iWoQk8U8v3tIDYXhv8ad+mEkygC2fiUrJV6a/YH0s0xKBwmrHi78Zd6lbIlDHqnT9yTHveNu6e4hh+JTF+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(5660300002)(66476007)(8676002)(956004)(54906003)(52116002)(2616005)(6666004)(83380400001)(30864003)(4326008)(6512007)(2906002)(26005)(8936002)(6916009)(107886003)(66556008)(36756003)(478600001)(86362001)(66946007)(186003)(316002)(6486002)(6506007)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zPCnwuHWXzF1I842/izRkgIlhuMCMDDsUiI1yPyUQMbWDrw/dH3XEKls/wQnXsHLXKisN4dhihiJvVBH2X0TpnYhM3DdgRTRErfQG5PXUevNBXpCP8Iw5ddUpvkKOktUUpvmaAtq4t7am7D9czaqi2ymGXD6skPNLd710hWTQQA4pF8oo4hpJkEwRvaVGhp9GPJcSpT+EUqT7RsDCjlKHDvE/vyo1ZR6gRahsjo5C6VDdQ2+rYYkXYNc4EjC/L+OrnMXI/MJGf2ZZF0MaAdw2+puDMhucaBZashSqkbYN45tKjClHRbZt1LO/uPGpPLymlEyQThR78nhQa16H0Ds5kr4ACCum/j+OLW6Lrt86muW6igytfa6MxvzPiI5Z6iNcl/gQF0AT6lQyCXVqnQLA/iI+nooVHW+b2I1GHzAxo/Gz87Tpm06g0LHjmKRkcwyUVwQn1Sf+1SAXYSid9AWCkQNAybs5pMJzNEUOPZiV7g=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be378b76-f56d-477d-05a2-08d81a22b875
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 22:46:10.2790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dlKGxewWaaecYbEBSeUQthguwcGbFftJQRVr1OSJ9XPbM9f9bsQ6sDYrPzIIzbAHHNg5Go5Ca95hfgNmBZgiog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A following patch introduces qevents, points in qdisc algorithm where
packet can be processed by user-defined filters. Should this processing
lead to a situation where a new packet is to be enqueued on the same port,
holding the root lock would lead to deadlocks. To solve the issue, qevent
handler needs to unlock and relock the root lock when necessary.

To that end, add the root lock argument to the qdisc op enqueue, and
propagate throughout.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/net/sch_generic.h |  6 ++++--
 net/core/dev.c            |  4 ++--
 net/sched/sch_atm.c       |  4 ++--
 net/sched/sch_blackhole.c |  2 +-
 net/sched/sch_cake.c      |  2 +-
 net/sched/sch_cbq.c       |  4 ++--
 net/sched/sch_cbs.c       | 18 +++++++++---------
 net/sched/sch_choke.c     |  2 +-
 net/sched/sch_codel.c     |  2 +-
 net/sched/sch_drr.c       |  4 ++--
 net/sched/sch_dsmark.c    |  4 ++--
 net/sched/sch_etf.c       |  2 +-
 net/sched/sch_ets.c       |  4 ++--
 net/sched/sch_fifo.c      |  6 +++---
 net/sched/sch_fq.c        |  2 +-
 net/sched/sch_fq_codel.c  |  2 +-
 net/sched/sch_fq_pie.c    |  2 +-
 net/sched/sch_generic.c   |  4 ++--
 net/sched/sch_gred.c      |  2 +-
 net/sched/sch_hfsc.c      |  6 +++---
 net/sched/sch_hhf.c       |  2 +-
 net/sched/sch_htb.c       |  4 ++--
 net/sched/sch_multiq.c    |  4 ++--
 net/sched/sch_netem.c     |  8 ++++----
 net/sched/sch_pie.c       |  2 +-
 net/sched/sch_plug.c      |  2 +-
 net/sched/sch_prio.c      |  6 +++---
 net/sched/sch_qfq.c       |  4 ++--
 net/sched/sch_red.c       |  4 ++--
 net/sched/sch_sfb.c       |  4 ++--
 net/sched/sch_sfq.c       |  2 +-
 net/sched/sch_skbprio.c   |  2 +-
 net/sched/sch_taprio.c    |  4 ++--
 net/sched/sch_tbf.c       | 10 +++++-----
 net/sched/sch_teql.c      |  4 ++--
 35 files changed, 73 insertions(+), 71 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index c510b03b9751..fceb3d63c925 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -57,6 +57,7 @@ struct qdisc_skb_head {
 struct Qdisc {
 	int 			(*enqueue)(struct sk_buff *skb,
 					   struct Qdisc *sch,
+					   spinlock_t *root_lock,
 					   struct sk_buff **to_free);
 	struct sk_buff *	(*dequeue)(struct Qdisc *sch);
 	unsigned int		flags;
@@ -241,6 +242,7 @@ struct Qdisc_ops {
 
 	int 			(*enqueue)(struct sk_buff *skb,
 					   struct Qdisc *sch,
+					   spinlock_t *root_lock,
 					   struct sk_buff **to_free);
 	struct sk_buff *	(*dequeue)(struct Qdisc *);
 	struct sk_buff *	(*peek)(struct Qdisc *);
@@ -788,11 +790,11 @@ static inline void qdisc_calculate_pkt_len(struct sk_buff *skb,
 #endif
 }
 
-static inline int qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static inline int qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 				struct sk_buff **to_free)
 {
 	qdisc_calculate_pkt_len(skb, sch);
-	return sch->enqueue(skb, sch, to_free);
+	return sch->enqueue(skb, sch, root_lock, to_free);
 }
 
 static inline void _bstats_update(struct gnet_stats_basic_packed *bstats,
diff --git a/net/core/dev.c b/net/core/dev.c
index 6bc2388141f6..7d45356e1a6f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3743,7 +3743,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
-		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		rc = q->enqueue(skb, q, NULL, &to_free) & NET_XMIT_MASK;
 		qdisc_run(q);
 
 		if (unlikely(to_free))
@@ -3786,7 +3786,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		qdisc_run_end(q);
 		rc = NET_XMIT_SUCCESS;
 	} else {
-		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		rc = q->enqueue(skb, q, root_lock, &to_free) & NET_XMIT_MASK;
 		if (qdisc_run_begin(q)) {
 			if (unlikely(contended)) {
 				spin_unlock(&q->busylock);
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index ee12ca9f55b4..fb6b16c4e46d 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -374,7 +374,7 @@ static struct tcf_block *atm_tc_tcf_block(struct Qdisc *sch, unsigned long cl,
 
 /* --------------------------- Qdisc operations ---------------------------- */
 
-static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			  struct sk_buff **to_free)
 {
 	struct atm_qdisc_data *p = qdisc_priv(sch);
@@ -432,7 +432,7 @@ static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 #endif
 	}
 
-	ret = qdisc_enqueue(skb, flow->q, to_free);
+	ret = qdisc_enqueue(skb, flow->q, root_lock, to_free);
 	if (ret != NET_XMIT_SUCCESS) {
 drop: __maybe_unused
 		if (net_xmit_drop_count(ret)) {
diff --git a/net/sched/sch_blackhole.c b/net/sched/sch_blackhole.c
index a7f7667ae984..187644657c4f 100644
--- a/net/sched/sch_blackhole.c
+++ b/net/sched/sch_blackhole.c
@@ -13,7 +13,7 @@
 #include <linux/skbuff.h>
 #include <net/pkt_sched.h>
 
-static int blackhole_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int blackhole_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			     struct sk_buff **to_free)
 {
 	qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 60f8ae578819..d109cae6eb6a 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1663,7 +1663,7 @@ static u32 cake_classify(struct Qdisc *sch, struct cake_tin_data **t,
 
 static void cake_reconfigure(struct Qdisc *sch);
 
-static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			struct sk_buff **to_free)
 {
 	struct cake_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 39b427dc7512..052d4a1af69a 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -356,7 +356,7 @@ cbq_mark_toplevel(struct cbq_sched_data *q, struct cbq_class *cl)
 }
 
 static int
-cbq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+cbq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 	    struct sk_buff **to_free)
 {
 	struct cbq_sched_data *q = qdisc_priv(sch);
@@ -373,7 +373,7 @@ cbq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		return ret;
 	}
 
-	ret = qdisc_enqueue(skb, cl->q, to_free);
+	ret = qdisc_enqueue(skb, cl->q, root_lock, to_free);
 	if (ret == NET_XMIT_SUCCESS) {
 		sch->q.qlen++;
 		cbq_mark_toplevel(q, cl);
diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 2eaac2ff380f..7af15ebe07f7 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -77,7 +77,7 @@ struct cbs_sched_data {
 	s64 sendslope; /* in bytes/s */
 	s64 idleslope; /* in bytes/s */
 	struct qdisc_watchdog watchdog;
-	int (*enqueue)(struct sk_buff *skb, struct Qdisc *sch,
+	int (*enqueue)(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		       struct sk_buff **to_free);
 	struct sk_buff *(*dequeue)(struct Qdisc *sch);
 	struct Qdisc *qdisc;
@@ -85,13 +85,13 @@ struct cbs_sched_data {
 };
 
 static int cbs_child_enqueue(struct sk_buff *skb, struct Qdisc *sch,
-			     struct Qdisc *child,
+			     struct Qdisc *child, spinlock_t *root_lock,
 			     struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
 	int err;
 
-	err = child->ops->enqueue(skb, child, to_free);
+	err = child->ops->enqueue(skb, child, root_lock, to_free);
 	if (err != NET_XMIT_SUCCESS)
 		return err;
 
@@ -101,16 +101,16 @@ static int cbs_child_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return NET_XMIT_SUCCESS;
 }
 
-static int cbs_enqueue_offload(struct sk_buff *skb, struct Qdisc *sch,
+static int cbs_enqueue_offload(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			       struct sk_buff **to_free)
 {
 	struct cbs_sched_data *q = qdisc_priv(sch);
 	struct Qdisc *qdisc = q->qdisc;
 
-	return cbs_child_enqueue(skb, sch, qdisc, to_free);
+	return cbs_child_enqueue(skb, sch, qdisc, root_lock, to_free);
 }
 
-static int cbs_enqueue_soft(struct sk_buff *skb, struct Qdisc *sch,
+static int cbs_enqueue_soft(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			    struct sk_buff **to_free)
 {
 	struct cbs_sched_data *q = qdisc_priv(sch);
@@ -124,15 +124,15 @@ static int cbs_enqueue_soft(struct sk_buff *skb, struct Qdisc *sch,
 		q->last = ktime_get_ns();
 	}
 
-	return cbs_child_enqueue(skb, sch, qdisc, to_free);
+	return cbs_child_enqueue(skb, sch, qdisc, root_lock, to_free);
 }
 
-static int cbs_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int cbs_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		       struct sk_buff **to_free)
 {
 	struct cbs_sched_data *q = qdisc_priv(sch);
 
-	return q->enqueue(skb, sch, to_free);
+	return q->enqueue(skb, sch, root_lock, to_free);
 }
 
 /* timediff is in ns, slope is in bytes/s */
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index bd618b00d319..baf3faee31aa 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -210,7 +210,7 @@ static bool choke_match_random(const struct choke_sched_data *q,
 	return choke_match_flow(oskb, nskb);
 }
 
-static int choke_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int choke_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			 struct sk_buff **to_free)
 {
 	struct choke_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 30169b3adbbb..1d94837abdd8 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -108,7 +108,7 @@ static struct sk_buff *codel_qdisc_dequeue(struct Qdisc *sch)
 	return skb;
 }
 
-static int codel_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int codel_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			       struct sk_buff **to_free)
 {
 	struct codel_sched_data *q;
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 07a2b0b35495..0d5c9a8ec61d 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -337,7 +337,7 @@ static struct drr_class *drr_classify(struct sk_buff *skb, struct Qdisc *sch,
 	return NULL;
 }
 
-static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		       struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
@@ -355,7 +355,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	first = !cl->qdisc->q.qlen;
-	err = qdisc_enqueue(skb, cl->qdisc, to_free);
+	err = qdisc_enqueue(skb, cl->qdisc, root_lock, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		if (net_xmit_drop_count(err)) {
 			cl->qstats.drops++;
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 05605b30bef3..fbe49fffcdbb 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -198,7 +198,7 @@ static struct tcf_block *dsmark_tcf_block(struct Qdisc *sch, unsigned long cl,
 
 /* --------------------------- Qdisc operations ---------------------------- */
 
-static int dsmark_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int dsmark_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			  struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
@@ -267,7 +267,7 @@ static int dsmark_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		}
 	}
 
-	err = qdisc_enqueue(skb, p->q, to_free);
+	err = qdisc_enqueue(skb, p->q, root_lock, to_free);
 	if (err != NET_XMIT_SUCCESS) {
 		if (net_xmit_drop_count(err))
 			qdisc_qstats_drop(sch);
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index c48f91075b5c..7a7c50a68115 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -160,7 +160,7 @@ static void report_sock_error(struct sk_buff *skb, u32 err, u8 code)
 }
 
 static int etf_enqueue_timesortedlist(struct sk_buff *nskb, struct Qdisc *sch,
-				      struct sk_buff **to_free)
+				      spinlock_t *root_lock, struct sk_buff **to_free)
 {
 	struct etf_sched_data *q = qdisc_priv(sch);
 	struct rb_node **p = &q->head.rb_root.rb_node, *parent = NULL;
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index a87e9159338c..373dc5855d4e 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -415,7 +415,7 @@ static struct ets_class *ets_classify(struct sk_buff *skb, struct Qdisc *sch,
 	return &q->classes[band];
 }
 
-static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			     struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
@@ -433,7 +433,7 @@ static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	first = !cl->qdisc->q.qlen;
-	err = qdisc_enqueue(skb, cl->qdisc, to_free);
+	err = qdisc_enqueue(skb, cl->qdisc, root_lock, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		if (net_xmit_drop_count(err)) {
 			cl->qstats.drops++;
diff --git a/net/sched/sch_fifo.c b/net/sched/sch_fifo.c
index a579a4131d22..b4da5b624ad8 100644
--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -16,7 +16,7 @@
 
 /* 1 band FIFO pseudo-"scheduler" */
 
-static int bfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int bfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			 struct sk_buff **to_free)
 {
 	if (likely(sch->qstats.backlog + qdisc_pkt_len(skb) <= sch->limit))
@@ -25,7 +25,7 @@ static int bfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return qdisc_drop(skb, sch, to_free);
 }
 
-static int pfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int pfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			 struct sk_buff **to_free)
 {
 	if (likely(sch->q.qlen < sch->limit))
@@ -34,7 +34,7 @@ static int pfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return qdisc_drop(skb, sch, to_free);
 }
 
-static int pfifo_tail_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int pfifo_tail_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			      struct sk_buff **to_free)
 {
 	unsigned int prev_backlog;
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 8f06a808c59a..64f5b4ccf3b0 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -439,7 +439,7 @@ static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
 	return unlikely((s64)skb->tstamp > (s64)(q->ktime_cache + q->horizon));
 }
 
-static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		      struct sk_buff **to_free)
 {
 	struct fq_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 436160be9c18..fe044a546e92 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -181,7 +181,7 @@ static unsigned int fq_codel_drop(struct Qdisc *sch, unsigned int max_packets,
 	return idx;
 }
 
-static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			    struct sk_buff **to_free)
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index fb760cee824e..a27a250ab8f9 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -125,7 +125,7 @@ static inline void flow_queue_add(struct fq_pie_flow *flow,
 	skb->next = NULL;
 }
 
-static int fq_pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int fq_pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 				struct sk_buff **to_free)
 {
 	struct fq_pie_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 265a61d011df..715cde1df9e4 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -520,7 +520,7 @@ EXPORT_SYMBOL(netif_carrier_off);
    cheaper.
  */
 
-static int noop_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
+static int noop_enqueue(struct sk_buff *skb, struct Qdisc *qdisc, spinlock_t *root_lock,
 			struct sk_buff **to_free)
 {
 	__qdisc_drop(skb, to_free);
@@ -614,7 +614,7 @@ static inline struct skb_array *band2list(struct pfifo_fast_priv *priv,
 	return &priv->q[band];
 }
 
-static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
+static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc, spinlock_t *root_lock,
 			      struct sk_buff **to_free)
 {
 	int band = prio2band[skb->priority & TC_PRIO_MAX];
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 8599c6f31b05..7d67c6cd6605 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -161,7 +161,7 @@ static bool gred_per_vq_red_flags_used(struct gred_sched *table)
 	return false;
 }
 
-static int gred_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int gred_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			struct sk_buff **to_free)
 {
 	struct gred_sched_data *q = NULL;
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 433f2190960f..7f6670044f0a 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1528,8 +1528,8 @@ hfsc_dump_qdisc(struct Qdisc *sch, struct sk_buff *skb)
 	return -1;
 }
 
-static int
-hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
+static int hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+			struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
 	struct hfsc_class *cl;
@@ -1545,7 +1545,7 @@ hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 	}
 
 	first = !cl->qdisc->q.qlen;
-	err = qdisc_enqueue(skb, cl->qdisc, to_free);
+	err = qdisc_enqueue(skb, cl->qdisc, root_lock, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		if (net_xmit_drop_count(err)) {
 			cl->qstats.drops++;
diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index be35f03b657b..d37e87fdc2a4 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -368,7 +368,7 @@ static unsigned int hhf_drop(struct Qdisc *sch, struct sk_buff **to_free)
 	return bucket - q->buckets;
 }
 
-static int hhf_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int hhf_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		       struct sk_buff **to_free)
 {
 	struct hhf_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 8184c87da8be..52fc513688b1 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -576,7 +576,7 @@ static inline void htb_deactivate(struct htb_sched *q, struct htb_class *cl)
 	cl->prio_activity = 0;
 }
 
-static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		       struct sk_buff **to_free)
 {
 	int uninitialized_var(ret);
@@ -599,7 +599,7 @@ static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		__qdisc_drop(skb, to_free);
 		return ret;
 #endif
-	} else if ((ret = qdisc_enqueue(skb, cl->leaf.q,
+	} else if ((ret = qdisc_enqueue(skb, cl->leaf.q, root_lock,
 					to_free)) != NET_XMIT_SUCCESS) {
 		if (net_xmit_drop_count(ret)) {
 			qdisc_qstats_drop(sch);
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index 1330ad224931..648611f5c105 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -57,7 +57,7 @@ multiq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 }
 
 static int
-multiq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+multiq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 	       struct sk_buff **to_free)
 {
 	struct Qdisc *qdisc;
@@ -74,7 +74,7 @@ multiq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 #endif
 
-	ret = qdisc_enqueue(skb, qdisc, to_free);
+	ret = qdisc_enqueue(skb, qdisc, root_lock, to_free);
 	if (ret == NET_XMIT_SUCCESS) {
 		sch->q.qlen++;
 		return NET_XMIT_SUCCESS;
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 84f82771cdf5..8fb17483a34f 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -431,7 +431,7 @@ static struct sk_buff *netem_segment(struct sk_buff *skb, struct Qdisc *sch,
  * 	NET_XMIT_DROP: queue length didn't change.
  *      NET_XMIT_SUCCESS: one skb was queued.
  */
-static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			 struct sk_buff **to_free)
 {
 	struct netem_sched_data *q = qdisc_priv(sch);
@@ -480,7 +480,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		u32 dupsave = q->duplicate; /* prevent duplicating a dup... */
 
 		q->duplicate = 0;
-		rootq->enqueue(skb2, rootq, to_free);
+		rootq->enqueue(skb2, rootq, root_lock, to_free);
 		q->duplicate = dupsave;
 		rc_drop = NET_XMIT_SUCCESS;
 	}
@@ -604,7 +604,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			skb_mark_not_on_list(segs);
 			qdisc_skb_cb(segs)->pkt_len = segs->len;
 			last_len = segs->len;
-			rc = qdisc_enqueue(segs, sch, to_free);
+			rc = qdisc_enqueue(segs, sch, root_lock, to_free);
 			if (rc != NET_XMIT_SUCCESS) {
 				if (net_xmit_drop_count(rc))
 					qdisc_qstats_drop(sch);
@@ -720,7 +720,7 @@ static struct sk_buff *netem_dequeue(struct Qdisc *sch)
 				struct sk_buff *to_free = NULL;
 				int err;
 
-				err = qdisc_enqueue(skb, q->qdisc, &to_free);
+				err = qdisc_enqueue(skb, q->qdisc, NULL, &to_free);
 				kfree_skb_list(to_free);
 				if (err != NET_XMIT_SUCCESS &&
 				    net_xmit_drop_count(err)) {
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index c65077f0c0f3..b305313b64e3 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -82,7 +82,7 @@ bool pie_drop_early(struct Qdisc *sch, struct pie_params *params,
 }
 EXPORT_SYMBOL_GPL(pie_drop_early);
 
-static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			     struct sk_buff **to_free)
 {
 	struct pie_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_plug.c b/net/sched/sch_plug.c
index cbc2ebca4548..e5f8b4769b4d 100644
--- a/net/sched/sch_plug.c
+++ b/net/sched/sch_plug.c
@@ -84,7 +84,7 @@ struct plug_sched_data {
 	u32 pkts_to_release;
 };
 
-static int plug_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int plug_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			struct sk_buff **to_free)
 {
 	struct plug_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 647941702f9f..a3e187f2603c 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -65,8 +65,8 @@ prio_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	return q->queues[band];
 }
 
-static int
-prio_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
+static int prio_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+			struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
 	struct Qdisc *qdisc;
@@ -83,7 +83,7 @@ prio_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 	}
 #endif
 
-	ret = qdisc_enqueue(skb, qdisc, to_free);
+	ret = qdisc_enqueue(skb, qdisc, root_lock, to_free);
 	if (ret == NET_XMIT_SUCCESS) {
 		sch->qstats.backlog += len;
 		sch->q.qlen++;
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 0b05ac7c848e..ede854516825 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1194,7 +1194,7 @@ static struct qfq_aggregate *qfq_choose_next_agg(struct qfq_sched *q)
 	return agg;
 }
 
-static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		       struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb), gso_segs;
@@ -1225,7 +1225,7 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	gso_segs = skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
 	first = !cl->qdisc->q.qlen;
-	err = qdisc_enqueue(skb, cl->qdisc, to_free);
+	err = qdisc_enqueue(skb, cl->qdisc, root_lock, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		pr_debug("qfq_enqueue: enqueue failed %d\n", err);
 		if (net_xmit_drop_count(err)) {
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 555a1b9e467f..6ace7d757e8b 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -65,7 +65,7 @@ static int red_use_nodrop(struct red_sched_data *q)
 	return q->flags & TC_RED_NODROP;
 }
 
-static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		       struct sk_buff **to_free)
 {
 	struct red_sched_data *q = qdisc_priv(sch);
@@ -118,7 +118,7 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		break;
 	}
 
-	ret = qdisc_enqueue(skb, child, to_free);
+	ret = qdisc_enqueue(skb, child, root_lock, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
 		qdisc_qstats_backlog_inc(sch, skb);
 		sch->q.qlen++;
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 4074c50ac3d7..d2a6e78262bb 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -276,7 +276,7 @@ static bool sfb_classify(struct sk_buff *skb, struct tcf_proto *fl,
 	return false;
 }
 
-static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		       struct sk_buff **to_free)
 {
 
@@ -399,7 +399,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 enqueue:
-	ret = qdisc_enqueue(skb, child, to_free);
+	ret = qdisc_enqueue(skb, child, root_lock, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
 		qdisc_qstats_backlog_inc(sch, skb);
 		sch->q.qlen++;
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 5a6def5e4e6d..46cdefd69e44 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -343,7 +343,7 @@ static int sfq_headdrop(const struct sfq_sched_data *q)
 }
 
 static int
-sfq_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
+sfq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock, struct sk_buff **to_free)
 {
 	struct sfq_sched_data *q = qdisc_priv(sch);
 	unsigned int hash, dropped;
diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
index 7a5e4c454715..f75f237c4436 100644
--- a/net/sched/sch_skbprio.c
+++ b/net/sched/sch_skbprio.c
@@ -65,7 +65,7 @@ static u16 calc_new_low_prio(const struct skbprio_sched_data *q)
 	return SKBPRIO_MAX_PRIORITY - 1;
 }
 
-static int skbprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int skbprio_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			  struct sk_buff **to_free)
 {
 	const unsigned int max_priority = SKBPRIO_MAX_PRIORITY - 1;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b1eb12d33b9a..b6a9480ec3e7 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -410,7 +410,7 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
 	return txtime;
 }
 
-static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 			  struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -435,7 +435,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 
-	return qdisc_enqueue(skb, child, to_free);
+	return qdisc_enqueue(skb, child, root_lock, to_free);
 }
 
 static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 78e79029dc63..c3eb5cdb83a8 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -187,7 +187,7 @@ static int tbf_offload_dump(struct Qdisc *sch)
 /* GSO packet is too big, segment it so that tbf can transmit
  * each segment in time
  */
-static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
+static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		       struct sk_buff **to_free)
 {
 	struct tbf_sched_data *q = qdisc_priv(sch);
@@ -206,7 +206,7 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 		skb_mark_not_on_list(segs);
 		qdisc_skb_cb(segs)->pkt_len = segs->len;
 		len += segs->len;
-		ret = qdisc_enqueue(segs, q->qdisc, to_free);
+		ret = qdisc_enqueue(segs, q->qdisc, root_lock, to_free);
 		if (ret != NET_XMIT_SUCCESS) {
 			if (net_xmit_drop_count(ret))
 				qdisc_qstats_drop(sch);
@@ -221,7 +221,7 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 	return nb > 0 ? NET_XMIT_SUCCESS : NET_XMIT_DROP;
 }
 
-static int tbf_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+static int tbf_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		       struct sk_buff **to_free)
 {
 	struct tbf_sched_data *q = qdisc_priv(sch);
@@ -231,10 +231,10 @@ static int tbf_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (qdisc_pkt_len(skb) > q->max_size) {
 		if (skb_is_gso(skb) &&
 		    skb_gso_validate_mac_len(skb, q->max_size))
-			return tbf_segment(skb, sch, to_free);
+			return tbf_segment(skb, sch, root_lock, to_free);
 		return qdisc_drop(skb, sch, to_free);
 	}
-	ret = qdisc_enqueue(skb, q->qdisc, to_free);
+	ret = qdisc_enqueue(skb, q->qdisc, root_lock, to_free);
 	if (ret != NET_XMIT_SUCCESS) {
 		if (net_xmit_drop_count(ret))
 			qdisc_qstats_drop(sch);
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 689ef6f3ded8..511964653476 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -72,8 +72,8 @@ struct teql_sched_data {
 
 /* "teql*" qdisc routines */
 
-static int
-teql_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
+static int teql_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+			struct sk_buff **to_free)
 {
 	struct net_device *dev = qdisc_dev(sch);
 	struct teql_sched_data *q = qdisc_priv(sch);
-- 
2.20.1

