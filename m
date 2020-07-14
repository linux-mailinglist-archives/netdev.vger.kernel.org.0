Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6133121F773
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgGNQgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:36:00 -0400
Received: from mail-vi1eur05on2042.outbound.protection.outlook.com ([40.107.21.42]:26057
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725931AbgGNQf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 12:35:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4PKL2OR4zutxs4UraFDd8GQpjYYQNA/uwi0CMJslUbx/mqFiRuUpTZKt8Uw1kqFD5OTEUHw6HKXMDfo4iMRMq9hZ3lSY70l0W9W+0c1f6UBWEmvozcDzIOHSfQh9Dh4eXuZWFqh8JSPMvhPZKf+jn1+8/fX9UDHgUeDb2mxmiCUKzHJm0wVoF2o03LeDgs6qy6qskdJL4Fz4pMxQQKdG8O/DN7JhdPXlIzIYmlpvXTQ9L4CftKWKOADaDEzT6Mi9GUsqcyS2F1BiBQqRdgzRU0d+Lt3ii18kibLqrySlcKL1vsFK77TG742U6oFoav0VH+ta7eQRhFI58ytXFPvRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cY7FwUxiWPedOqKgCugMOOBGPwRyuBPr2ZfC3MxvEoU=;
 b=XAdSL8Z+Vtv5vQqG92vKk/BP5pAVtxMtqMLb/R+Nb0C9eBlF9cABKtzQ5ZHnJgOl84hfcwNXZSdkuQdQ66JnsfIN5dIujEv/PVhuUbgv1Zs9QPE5a3gzO6xYV5MGrMscS5TIXnXSEMugMKITpVGwCQmuOLVtMLNQUdEZ7lqGr392m4CBwzT0xI4Ilr0ns2p875qk2Zjp+AUXNU3HfeOKyULeHIipi3xJUbBDFwtNTxD2ALMhCohOjL7dMLI0eMyKRkGatcyhUg5/go5Ck6I31yeVowhZ7csEMVnVywl6UI8bSobW2Wj3ao2tqL6DZtknynrPmJpXmGtCcn54r3iepA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cY7FwUxiWPedOqKgCugMOOBGPwRyuBPr2ZfC3MxvEoU=;
 b=OkhhWVTFzm9/clVFXEYj41mAlbRDsSX6Dmgl2G5BSGdwU1pQmxTHUcd3pstO9KVorFesrcwUzk/FPRdYhcfcn0R2e3sxjQj5GfFnRgnZD10VSKkL/xHch/N4wVJGajcMw9C4ZDs1u2pvUePIDKqRKwIYyLhQWivirYWol0BaPgE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4524.eurprd05.prod.outlook.com (2603:10a6:7:96::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Tue, 14 Jul 2020 16:34:37 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 16:34:37 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next v2 2/2] Revert "net: sched: Pass root lock to Qdisc_ops.enqueue"
Date:   Tue, 14 Jul 2020 19:34:02 +0300
Message-Id: <32c55df4e3926b646ae2e818ed741b1b130d3b43.1594743981.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594743981.git.petrm@mellanox.com>
References: <cover.1594743981.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0033.eurprd03.prod.outlook.com
 (2603:10a6:205:2::46) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4PR0302CA0033.eurprd03.prod.outlook.com (2603:10a6:205:2::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Tue, 14 Jul 2020 16:34:36 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3a966e77-0570-4740-4ded-08d82813cc75
X-MS-TrafficTypeDiagnostic: HE1PR05MB4524:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB45241DA34D706CB07FAD942BDB610@HE1PR05MB4524.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:12;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: duoqsThXUA696OiFlEF9K9LrlWgCtTsIWuhQeywZMHj5ENsdbYhwcXYtQv5nLSuXjcgDU65ZcCZxA+OVRNq0zXvwrhGSnhW+pj3nF99OivwKeGCmGR7IcpN87JRV5/rnVlWwMHzAbV4SUzjg23/s3MT9EQS/bkko7uS/tA9JkPzxv4FA7uNkbU6AVl2tVfnaNoW4vcbbmfz1j96HIEImlIZHFy1QZF+vjDEu/6mul/1yscyTm+3SnxyPWRhu0BUSNxAbfIlONMUJu0Kk37Nc/IJ7EHYso3kpXkxQODLp+InOHE613mRwJ2qokRXcEUfkQanXcHwI+Y9croFbAX8y/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(136003)(39850400004)(366004)(186003)(30864003)(2906002)(66476007)(16526019)(66946007)(66556008)(52116002)(107886003)(83380400001)(6506007)(4326008)(26005)(956004)(5660300002)(6512007)(2616005)(54906003)(6916009)(36756003)(86362001)(8676002)(6486002)(6666004)(8936002)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vkCc6xKRsketAqKSWaC13kxQiKoSm/XdkcwVuLDssNUa5thrRCDDhN40ooOmj8rLIMA+38CuKYHiR/8gV76vqbGaPWYXUXztJqXfleA2T1wILI77Mr3gQmqz3JTL5Ag5CN8FvhhSP7d6OOm3h9PvKiW26FXU9NZ7Dnng4nDs7ozUXruEQzl3JMMHdl8+Lqs0+/Ojm+1aMhGMwhm1/EvsEO/ZPJInv7cGngGKYDRwhLhA8JvWh0oyjZb1TLO0ycKMt20ExCRq9/4/pe8k/2Wz/TgHcKlWMQIymirFs+N2DvPp3o8faWMGkPFB+nOjftizoZcWyy7E9lYpQQbbAdHO0MSjthgYLlllpufEekuffSHDbpc9CXs8iCXZFg+xaRExERf82rLA3PwBs6hmaJcWc77RsMKVbk1ZzMdgja1o2E/ZDvFTT/J8uG2HLlf3s5K9G14763JPgCvPFFTAxZs0BPOd3aOef7GEYTpCzhG63d7qqgdvLI6XoM10+O5YFOlE
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a966e77-0570-4740-4ded-08d82813cc75
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 16:34:37.6512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +t9miz7+/g6gBbdCeofHBs1lBwDLDcyDc7Agg7ASnLLxrzHAx6MTn5k4N4cMhndSKMshWRXHIRbxHYt17yvmew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4524
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit aebe4426ccaa4838f36ea805cdf7d76503e65117.
---

Notes:
    v2:
    - Turn this into a proper revert. No actual changes.

 include/net/sch_generic.h |  6 ++----
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
 35 files changed, 71 insertions(+), 73 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index fceb3d63c925..c510b03b9751 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -57,7 +57,6 @@ struct qdisc_skb_head {
 struct Qdisc {
 	int 			(*enqueue)(struct sk_buff *skb,
 					   struct Qdisc *sch,
-					   spinlock_t *root_lock,
 					   struct sk_buff **to_free);
 	struct sk_buff *	(*dequeue)(struct Qdisc *sch);
 	unsigned int		flags;
@@ -242,7 +241,6 @@ struct Qdisc_ops {
 
 	int 			(*enqueue)(struct sk_buff *skb,
 					   struct Qdisc *sch,
-					   spinlock_t *root_lock,
 					   struct sk_buff **to_free);
 	struct sk_buff *	(*dequeue)(struct Qdisc *);
 	struct sk_buff *	(*peek)(struct Qdisc *);
@@ -790,11 +788,11 @@ static inline void qdisc_calculate_pkt_len(struct sk_buff *skb,
 #endif
 }
 
-static inline int qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static inline int qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 				struct sk_buff **to_free)
 {
 	qdisc_calculate_pkt_len(skb, sch);
-	return sch->enqueue(skb, sch, root_lock, to_free);
+	return sch->enqueue(skb, sch, to_free);
 }
 
 static inline void _bstats_update(struct gnet_stats_basic_packed *bstats,
diff --git a/net/core/dev.c b/net/core/dev.c
index b61075828358..062a00fdca9b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3749,7 +3749,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
-		rc = q->enqueue(skb, q, NULL, &to_free) & NET_XMIT_MASK;
+		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
 		qdisc_run(q);
 
 		if (unlikely(to_free))
@@ -3792,7 +3792,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		qdisc_run_end(q);
 		rc = NET_XMIT_SUCCESS;
 	} else {
-		rc = q->enqueue(skb, q, root_lock, &to_free) & NET_XMIT_MASK;
+		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
 		if (qdisc_run_begin(q)) {
 			if (unlikely(contended)) {
 				spin_unlock(&q->busylock);
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 1d5e422d9be2..1c281cc81f57 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -374,7 +374,7 @@ static struct tcf_block *atm_tc_tcf_block(struct Qdisc *sch, unsigned long cl,
 
 /* --------------------------- Qdisc operations ---------------------------- */
 
-static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
 	struct atm_qdisc_data *p = qdisc_priv(sch);
@@ -432,7 +432,7 @@ static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *ro
 #endif
 	}
 
-	ret = qdisc_enqueue(skb, flow->q, root_lock, to_free);
+	ret = qdisc_enqueue(skb, flow->q, to_free);
 	if (ret != NET_XMIT_SUCCESS) {
 drop: __maybe_unused
 		if (net_xmit_drop_count(ret)) {
diff --git a/net/sched/sch_blackhole.c b/net/sched/sch_blackhole.c
index 187644657c4f..a7f7667ae984 100644
--- a/net/sched/sch_blackhole.c
+++ b/net/sched/sch_blackhole.c
@@ -13,7 +13,7 @@
 #include <linux/skbuff.h>
 #include <net/pkt_sched.h>
 
-static int blackhole_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int blackhole_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			     struct sk_buff **to_free)
 {
 	qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index b3cdcd86cbfd..561d20c9adca 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1687,7 +1687,7 @@ static u32 cake_classify(struct Qdisc *sch, struct cake_tin_data **t,
 
 static void cake_reconfigure(struct Qdisc *sch);
 
-static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			struct sk_buff **to_free)
 {
 	struct cake_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 9e16fdf47fe7..b2130df933a7 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -356,7 +356,7 @@ cbq_mark_toplevel(struct cbq_sched_data *q, struct cbq_class *cl)
 }
 
 static int
-cbq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+cbq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	    struct sk_buff **to_free)
 {
 	struct cbq_sched_data *q = qdisc_priv(sch);
@@ -373,7 +373,7 @@ cbq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 		return ret;
 	}
 
-	ret = qdisc_enqueue(skb, cl->q, root_lock, to_free);
+	ret = qdisc_enqueue(skb, cl->q, to_free);
 	if (ret == NET_XMIT_SUCCESS) {
 		sch->q.qlen++;
 		cbq_mark_toplevel(q, cl);
diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 7af15ebe07f7..2eaac2ff380f 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -77,7 +77,7 @@ struct cbs_sched_data {
 	s64 sendslope; /* in bytes/s */
 	s64 idleslope; /* in bytes/s */
 	struct qdisc_watchdog watchdog;
-	int (*enqueue)(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+	int (*enqueue)(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free);
 	struct sk_buff *(*dequeue)(struct Qdisc *sch);
 	struct Qdisc *qdisc;
@@ -85,13 +85,13 @@ struct cbs_sched_data {
 };
 
 static int cbs_child_enqueue(struct sk_buff *skb, struct Qdisc *sch,
-			     struct Qdisc *child, spinlock_t *root_lock,
+			     struct Qdisc *child,
 			     struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
 	int err;
 
-	err = child->ops->enqueue(skb, child, root_lock, to_free);
+	err = child->ops->enqueue(skb, child, to_free);
 	if (err != NET_XMIT_SUCCESS)
 		return err;
 
@@ -101,16 +101,16 @@ static int cbs_child_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return NET_XMIT_SUCCESS;
 }
 
-static int cbs_enqueue_offload(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int cbs_enqueue_offload(struct sk_buff *skb, struct Qdisc *sch,
 			       struct sk_buff **to_free)
 {
 	struct cbs_sched_data *q = qdisc_priv(sch);
 	struct Qdisc *qdisc = q->qdisc;
 
-	return cbs_child_enqueue(skb, sch, qdisc, root_lock, to_free);
+	return cbs_child_enqueue(skb, sch, qdisc, to_free);
 }
 
-static int cbs_enqueue_soft(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int cbs_enqueue_soft(struct sk_buff *skb, struct Qdisc *sch,
 			    struct sk_buff **to_free)
 {
 	struct cbs_sched_data *q = qdisc_priv(sch);
@@ -124,15 +124,15 @@ static int cbs_enqueue_soft(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *
 		q->last = ktime_get_ns();
 	}
 
-	return cbs_child_enqueue(skb, sch, qdisc, root_lock, to_free);
+	return cbs_child_enqueue(skb, sch, qdisc, to_free);
 }
 
-static int cbs_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int cbs_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
 	struct cbs_sched_data *q = qdisc_priv(sch);
 
-	return q->enqueue(skb, sch, root_lock, to_free);
+	return q->enqueue(skb, sch, to_free);
 }
 
 /* timediff is in ns, slope is in bytes/s */
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index baf3faee31aa..bd618b00d319 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -210,7 +210,7 @@ static bool choke_match_random(const struct choke_sched_data *q,
 	return choke_match_flow(oskb, nskb);
 }
 
-static int choke_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int choke_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			 struct sk_buff **to_free)
 {
 	struct choke_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 1d94837abdd8..30169b3adbbb 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -108,7 +108,7 @@ static struct sk_buff *codel_qdisc_dequeue(struct Qdisc *sch)
 	return skb;
 }
 
-static int codel_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int codel_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			       struct sk_buff **to_free)
 {
 	struct codel_sched_data *q;
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index ad14df2ecf3a..dde564670ad8 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -337,7 +337,7 @@ static struct drr_class *drr_classify(struct sk_buff *skb, struct Qdisc *sch,
 	return NULL;
 }
 
-static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
@@ -355,7 +355,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 	}
 
 	first = !cl->qdisc->q.qlen;
-	err = qdisc_enqueue(skb, cl->qdisc, root_lock, to_free);
+	err = qdisc_enqueue(skb, cl->qdisc, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		if (net_xmit_drop_count(err)) {
 			cl->qstats.drops++;
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 76a9c4f277f2..2b88710994d7 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -198,7 +198,7 @@ static struct tcf_block *dsmark_tcf_block(struct Qdisc *sch, unsigned long cl,
 
 /* --------------------------- Qdisc operations ---------------------------- */
 
-static int dsmark_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int dsmark_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
@@ -267,7 +267,7 @@ static int dsmark_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *ro
 		}
 	}
 
-	err = qdisc_enqueue(skb, p->q, root_lock, to_free);
+	err = qdisc_enqueue(skb, p->q, to_free);
 	if (err != NET_XMIT_SUCCESS) {
 		if (net_xmit_drop_count(err))
 			qdisc_qstats_drop(sch);
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index 7a7c50a68115..c48f91075b5c 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -160,7 +160,7 @@ static void report_sock_error(struct sk_buff *skb, u32 err, u8 code)
 }
 
 static int etf_enqueue_timesortedlist(struct sk_buff *nskb, struct Qdisc *sch,
-				      spinlock_t *root_lock, struct sk_buff **to_free)
+				      struct sk_buff **to_free)
 {
 	struct etf_sched_data *q = qdisc_priv(sch);
 	struct rb_node **p = &q->head.rb_root.rb_node, *parent = NULL;
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 1af86f30b18e..c1e84d1eeaba 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -415,7 +415,7 @@ static struct ets_class *ets_classify(struct sk_buff *skb, struct Qdisc *sch,
 	return &q->classes[band];
 }
 
-static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			     struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
@@ -433,7 +433,7 @@ static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t
 	}
 
 	first = !cl->qdisc->q.qlen;
-	err = qdisc_enqueue(skb, cl->qdisc, root_lock, to_free);
+	err = qdisc_enqueue(skb, cl->qdisc, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		if (net_xmit_drop_count(err)) {
 			cl->qstats.drops++;
diff --git a/net/sched/sch_fifo.c b/net/sched/sch_fifo.c
index b4da5b624ad8..a579a4131d22 100644
--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -16,7 +16,7 @@
 
 /* 1 band FIFO pseudo-"scheduler" */
 
-static int bfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int bfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			 struct sk_buff **to_free)
 {
 	if (likely(sch->qstats.backlog + qdisc_pkt_len(skb) <= sch->limit))
@@ -25,7 +25,7 @@ static int bfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *roo
 	return qdisc_drop(skb, sch, to_free);
 }
 
-static int pfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int pfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			 struct sk_buff **to_free)
 {
 	if (likely(sch->q.qlen < sch->limit))
@@ -34,7 +34,7 @@ static int pfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *roo
 	return qdisc_drop(skb, sch, to_free);
 }
 
-static int pfifo_tail_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int pfifo_tail_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			      struct sk_buff **to_free)
 {
 	unsigned int prev_backlog;
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index a90d745c41e0..2fb76fc0cc31 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -439,7 +439,7 @@ static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
 	return unlikely((s64)skb->tstamp > (s64)(q->ktime_cache + q->horizon));
 }
 
-static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		      struct sk_buff **to_free)
 {
 	struct fq_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index bca016ffc069..3106653c17f3 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -181,7 +181,7 @@ static unsigned int fq_codel_drop(struct Qdisc *sch, unsigned int max_packets,
 	return idx;
 }
 
-static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			    struct sk_buff **to_free)
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index 741840b9994f..f98c74018805 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -125,7 +125,7 @@ static inline void flow_queue_add(struct fq_pie_flow *flow,
 	skb->next = NULL;
 }
 
-static int fq_pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int fq_pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 				struct sk_buff **to_free)
 {
 	struct fq_pie_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 715cde1df9e4..265a61d011df 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -520,7 +520,7 @@ EXPORT_SYMBOL(netif_carrier_off);
    cheaper.
  */
 
-static int noop_enqueue(struct sk_buff *skb, struct Qdisc *qdisc, spinlock_t *root_lock,
+static int noop_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
 			struct sk_buff **to_free)
 {
 	__qdisc_drop(skb, to_free);
@@ -614,7 +614,7 @@ static inline struct skb_array *band2list(struct pfifo_fast_priv *priv,
 	return &priv->q[band];
 }
 
-static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc, spinlock_t *root_lock,
+static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
 			      struct sk_buff **to_free)
 {
 	int band = prio2band[skb->priority & TC_PRIO_MAX];
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 7d67c6cd6605..8599c6f31b05 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -161,7 +161,7 @@ static bool gred_per_vq_red_flags_used(struct gred_sched *table)
 	return false;
 }
 
-static int gred_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int gred_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			struct sk_buff **to_free)
 {
 	struct gred_sched_data *q = NULL;
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 13ba8648bb63..0f5f121404f3 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1528,8 +1528,8 @@ hfsc_dump_qdisc(struct Qdisc *sch, struct sk_buff *skb)
 	return -1;
 }
 
-static int hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
-			struct sk_buff **to_free)
+static int
+hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
 	struct hfsc_class *cl;
@@ -1545,7 +1545,7 @@ static int hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root
 	}
 
 	first = !cl->qdisc->q.qlen;
-	err = qdisc_enqueue(skb, cl->qdisc, root_lock, to_free);
+	err = qdisc_enqueue(skb, cl->qdisc, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		if (net_xmit_drop_count(err)) {
 			cl->qstats.drops++;
diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index ddc6bf1d85d0..420ede875322 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -368,7 +368,7 @@ static unsigned int hhf_drop(struct Qdisc *sch, struct sk_buff **to_free)
 	return bucket - q->buckets;
 }
 
-static int hhf_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int hhf_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
 	struct hhf_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index b07f29059f47..ba37defaca7a 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -576,7 +576,7 @@ static inline void htb_deactivate(struct htb_sched *q, struct htb_class *cl)
 	cl->prio_activity = 0;
 }
 
-static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
 	int uninitialized_var(ret);
@@ -599,7 +599,7 @@ static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 		__qdisc_drop(skb, to_free);
 		return ret;
 #endif
-	} else if ((ret = qdisc_enqueue(skb, cl->leaf.q, root_lock,
+	} else if ((ret = qdisc_enqueue(skb, cl->leaf.q,
 					to_free)) != NET_XMIT_SUCCESS) {
 		if (net_xmit_drop_count(ret)) {
 			qdisc_qstats_drop(sch);
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index 56bdc4bcdc63..5c27b4270b90 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -57,7 +57,7 @@ multiq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 }
 
 static int
-multiq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+multiq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	       struct sk_buff **to_free)
 {
 	struct Qdisc *qdisc;
@@ -74,7 +74,7 @@ multiq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
 	}
 #endif
 
-	ret = qdisc_enqueue(skb, qdisc, root_lock, to_free);
+	ret = qdisc_enqueue(skb, qdisc, to_free);
 	if (ret == NET_XMIT_SUCCESS) {
 		sch->q.qlen++;
 		return NET_XMIT_SUCCESS;
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 8fb17483a34f..84f82771cdf5 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -431,7 +431,7 @@ static struct sk_buff *netem_segment(struct sk_buff *skb, struct Qdisc *sch,
  * 	NET_XMIT_DROP: queue length didn't change.
  *      NET_XMIT_SUCCESS: one skb was queued.
  */
-static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			 struct sk_buff **to_free)
 {
 	struct netem_sched_data *q = qdisc_priv(sch);
@@ -480,7 +480,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *roo
 		u32 dupsave = q->duplicate; /* prevent duplicating a dup... */
 
 		q->duplicate = 0;
-		rootq->enqueue(skb2, rootq, root_lock, to_free);
+		rootq->enqueue(skb2, rootq, to_free);
 		q->duplicate = dupsave;
 		rc_drop = NET_XMIT_SUCCESS;
 	}
@@ -604,7 +604,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *roo
 			skb_mark_not_on_list(segs);
 			qdisc_skb_cb(segs)->pkt_len = segs->len;
 			last_len = segs->len;
-			rc = qdisc_enqueue(segs, sch, root_lock, to_free);
+			rc = qdisc_enqueue(segs, sch, to_free);
 			if (rc != NET_XMIT_SUCCESS) {
 				if (net_xmit_drop_count(rc))
 					qdisc_qstats_drop(sch);
@@ -720,7 +720,7 @@ static struct sk_buff *netem_dequeue(struct Qdisc *sch)
 				struct sk_buff *to_free = NULL;
 				int err;
 
-				err = qdisc_enqueue(skb, q->qdisc, NULL, &to_free);
+				err = qdisc_enqueue(skb, q->qdisc, &to_free);
 				kfree_skb_list(to_free);
 				if (err != NET_XMIT_SUCCESS &&
 				    net_xmit_drop_count(err)) {
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index b305313b64e3..c65077f0c0f3 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -82,7 +82,7 @@ bool pie_drop_early(struct Qdisc *sch, struct pie_params *params,
 }
 EXPORT_SYMBOL_GPL(pie_drop_early);
 
-static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			     struct sk_buff **to_free)
 {
 	struct pie_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_plug.c b/net/sched/sch_plug.c
index e5f8b4769b4d..cbc2ebca4548 100644
--- a/net/sched/sch_plug.c
+++ b/net/sched/sch_plug.c
@@ -84,7 +84,7 @@ struct plug_sched_data {
 	u32 pkts_to_release;
 };
 
-static int plug_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int plug_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			struct sk_buff **to_free)
 {
 	struct plug_sched_data *q = qdisc_priv(sch);
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 46b7ce81c6e3..3eabb871a1d5 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -65,8 +65,8 @@ prio_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	return q->queues[band];
 }
 
-static int prio_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
-			struct sk_buff **to_free)
+static int
+prio_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb);
 	struct Qdisc *qdisc;
@@ -83,7 +83,7 @@ static int prio_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root
 	}
 #endif
 
-	ret = qdisc_enqueue(skb, qdisc, root_lock, to_free);
+	ret = qdisc_enqueue(skb, qdisc, to_free);
 	if (ret == NET_XMIT_SUCCESS) {
 		sch->qstats.backlog += len;
 		sch->q.qlen++;
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 3cfe6262eb00..6335230a971e 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1194,7 +1194,7 @@ static struct qfq_aggregate *qfq_choose_next_agg(struct qfq_sched *q)
 	return agg;
 }
 
-static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
 	unsigned int len = qdisc_pkt_len(skb), gso_segs;
@@ -1225,7 +1225,7 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 
 	gso_segs = skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
 	first = !cl->qdisc->q.qlen;
-	err = qdisc_enqueue(skb, cl->qdisc, root_lock, to_free);
+	err = qdisc_enqueue(skb, cl->qdisc, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		pr_debug("qfq_enqueue: enqueue failed %d\n", err);
 		if (net_xmit_drop_count(err)) {
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index a79602f7fab8..4cc0ad0b1189 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -67,7 +67,7 @@ static int red_use_nodrop(struct red_sched_data *q)
 	return q->flags & TC_RED_NODROP;
 }
 
-static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
 	struct red_sched_data *q = qdisc_priv(sch);
@@ -126,7 +126,7 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 		break;
 	}
 
-	ret = qdisc_enqueue(skb, child, root_lock, to_free);
+	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
 		qdisc_qstats_backlog_inc(sch, skb);
 		sch->q.qlen++;
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 356f6d1d30db..da047a37a3bf 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -276,7 +276,7 @@ static bool sfb_classify(struct sk_buff *skb, struct tcf_proto *fl,
 	return false;
 }
 
-static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
 
@@ -399,7 +399,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 	}
 
 enqueue:
-	ret = qdisc_enqueue(skb, child, root_lock, to_free);
+	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
 		qdisc_qstats_backlog_inc(sch, skb);
 		sch->q.qlen++;
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index a1314510dc69..cae5dbbadc1c 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -343,7 +343,7 @@ static int sfq_headdrop(const struct sfq_sched_data *q)
 }
 
 static int
-sfq_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock, struct sk_buff **to_free)
+sfq_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 {
 	struct sfq_sched_data *q = qdisc_priv(sch);
 	unsigned int hash, dropped;
diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
index f75f237c4436..7a5e4c454715 100644
--- a/net/sched/sch_skbprio.c
+++ b/net/sched/sch_skbprio.c
@@ -65,7 +65,7 @@ static u16 calc_new_low_prio(const struct skbprio_sched_data *q)
 	return SKBPRIO_MAX_PRIORITY - 1;
 }
 
-static int skbprio_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int skbprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
 	const unsigned int max_priority = SKBPRIO_MAX_PRIORITY - 1;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index daef2ff60a98..e981992634dd 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -410,7 +410,7 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
 	return txtime;
 }
 
-static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -435,7 +435,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *ro
 	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 
-	return qdisc_enqueue(skb, child, root_lock, to_free);
+	return qdisc_enqueue(skb, child, to_free);
 }
 
 static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index c3eb5cdb83a8..78e79029dc63 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -187,7 +187,7 @@ static int tbf_offload_dump(struct Qdisc *sch)
 /* GSO packet is too big, segment it so that tbf can transmit
  * each segment in time
  */
-static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
 	struct tbf_sched_data *q = qdisc_priv(sch);
@@ -206,7 +206,7 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 		skb_mark_not_on_list(segs);
 		qdisc_skb_cb(segs)->pkt_len = segs->len;
 		len += segs->len;
-		ret = qdisc_enqueue(segs, q->qdisc, root_lock, to_free);
+		ret = qdisc_enqueue(segs, q->qdisc, to_free);
 		if (ret != NET_XMIT_SUCCESS) {
 			if (net_xmit_drop_count(ret))
 				qdisc_qstats_drop(sch);
@@ -221,7 +221,7 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 	return nb > 0 ? NET_XMIT_SUCCESS : NET_XMIT_DROP;
 }
 
-static int tbf_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
+static int tbf_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
 	struct tbf_sched_data *q = qdisc_priv(sch);
@@ -231,10 +231,10 @@ static int tbf_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 	if (qdisc_pkt_len(skb) > q->max_size) {
 		if (skb_is_gso(skb) &&
 		    skb_gso_validate_mac_len(skb, q->max_size))
-			return tbf_segment(skb, sch, root_lock, to_free);
+			return tbf_segment(skb, sch, to_free);
 		return qdisc_drop(skb, sch, to_free);
 	}
-	ret = qdisc_enqueue(skb, q->qdisc, root_lock, to_free);
+	ret = qdisc_enqueue(skb, q->qdisc, to_free);
 	if (ret != NET_XMIT_SUCCESS) {
 		if (net_xmit_drop_count(ret))
 			qdisc_qstats_drop(sch);
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index b586eec2eaeb..2f1f0a378408 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -72,8 +72,8 @@ struct teql_sched_data {
 
 /* "teql*" qdisc routines */
 
-static int teql_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
-			struct sk_buff **to_free)
+static int
+teql_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 {
 	struct net_device *dev = qdisc_dev(sch);
 	struct teql_sched_data *q = qdisc_priv(sch);
-- 
2.20.1

