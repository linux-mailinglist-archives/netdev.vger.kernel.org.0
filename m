Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E2C43014D
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243896AbhJPIvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239880AbhJPIvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 04:51:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5E9C061768;
        Sat, 16 Oct 2021 01:49:23 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634374162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yw/PhGeTHnOd+fdoKLTbDscvuD9GVSalzgauUykgFwA=;
        b=lr+1dO9eYQcb9dq46hRDvaWXO6s4E64QXrAnZE8etSizT2R/ikbPaH5gpU4rryHbYOqFi7
        XiqwAETj+hqDIR34NDX8mlWr5lrY9wNhf4500bPEioqe8cTsT4MAivLhNlhIMzWBX21aW8
        JXdA25EHsoYNalfAgCKc8sdivR1E+UXbmypcFMnf9Htp8zNSGzN06XYiTro1utxKQLU0s8
        xkvOfvksBspxPsheTVEZ3LD0xKTHT/X+a3pikM5VC3h0raxRYnQ8tHRupAxoNBM1B18Kyh
        o82vmDGqJ5h6Cl5R2un2QbDRRHP9dtmPqyEwQ93oXQBfIvrWrdZhMFOUF/rIaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634374162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yw/PhGeTHnOd+fdoKLTbDscvuD9GVSalzgauUykgFwA=;
        b=XjPeUxU60EspJ14f58VBSM2jnxhCAca6+E1txrb/b5egSdqUsPrATTGXXOpHlh69E4mpho
        8g0fvfvNV/T9VKDg==
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 6/9] net: sched: Protect Qdisc::bstats with u64_stats
Date:   Sat, 16 Oct 2021 10:49:07 +0200
Message-Id: <20211016084910.4029084-7-bigeasy@linutronix.de>
In-Reply-To: <20211016084910.4029084-1-bigeasy@linutronix.de>
References: <20211016084910.4029084-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

The not-per-CPU variant of qdisc tc (traffic control) statistics,
Qdisc::gnet_stats_basic_packed bstats, is protected with Qdisc::running
sequence counter.

This sequence counter is used for reliably protecting bstats reads from
parallel writes. Meanwhile, the seqcount's write section covers a much
wider area than bstats update: qdisc_run_begin() =3D> qdisc_run_end().

That read/write section asymmetry can lead to needless retries of the
read section. To prepare for removing the Qdisc::running sequence
counter altogether, introduce a u64_stats sync point inside bstats
instead.

Modify _bstats_update() to start/end the bstats u64_stats write
section.

For bisectability, and finer commits granularity, the bstats read
section is still protected with a Qdisc::running read/retry loop and
qdisc_run_begin/end() still starts/ends that seqcount write section.
Once all call sites are modified to use _bstats_update(), the
Qdisc::running seqcount will be removed and bstats read/retry loop will
be modified to utilize the internal u64_stats sync point.

Note, using u64_stats implies no sequence counter protection for 64-bit
architectures. This can lead to the statistics "packets" vs. "bytes"
values getting out of sync on rare occasions. The individual values will
still be valid.

[bigeasy: Minor commit message edits, init all gnet_stats_basic_packed.]

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/net/gen_stats.h    |  2 ++
 include/net/sch_generic.h  |  2 ++
 net/core/gen_estimator.c   |  2 +-
 net/core/gen_stats.c       | 14 ++++++++++++--
 net/netfilter/xt_RATEEST.c |  1 +
 net/sched/act_api.c        |  2 ++
 net/sched/sch_atm.c        |  1 +
 net/sched/sch_cbq.c        |  1 +
 net/sched/sch_drr.c        |  1 +
 net/sched/sch_ets.c        |  2 +-
 net/sched/sch_generic.c    |  1 +
 net/sched/sch_gred.c       |  4 +++-
 net/sched/sch_hfsc.c       |  1 +
 net/sched/sch_htb.c        |  7 +++++--
 net/sched/sch_mq.c         |  2 +-
 net/sched/sch_mqprio.c     |  5 +++--
 net/sched/sch_qfq.c        |  1 +
 17 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/include/net/gen_stats.h b/include/net/gen_stats.h
index d47155f5db5d7..304d792f79776 100644
--- a/include/net/gen_stats.h
+++ b/include/net/gen_stats.h
@@ -11,6 +11,7 @@
 struct gnet_stats_basic_packed {
 	__u64	bytes;
 	__u64	packets;
+	struct u64_stats_sync syncp;
 };
=20
 struct gnet_stats_basic_cpu {
@@ -34,6 +35,7 @@ struct gnet_dump {
 	struct tc_stats   tc_stats;
 };
=20
+void gnet_stats_basic_packed_init(struct gnet_stats_basic_packed *b);
 int gnet_stats_start_copy(struct sk_buff *skb, int type, spinlock_t *lock,
 			  struct gnet_dump *d, int padattr);
=20
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 7bc2d30b5c067..d7746aea3cecf 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -852,8 +852,10 @@ static inline int qdisc_enqueue(struct sk_buff *skb, s=
truct Qdisc *sch,
 static inline void _bstats_update(struct gnet_stats_basic_packed *bstats,
 				  __u64 bytes, __u32 packets)
 {
+	u64_stats_update_begin(&bstats->syncp);
 	bstats->bytes +=3D bytes;
 	bstats->packets +=3D packets;
+	u64_stats_update_end(&bstats->syncp);
 }
=20
 static inline void bstats_update(struct gnet_stats_basic_packed *bstats,
diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 205df8b5116e5..64978e77368f4 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -62,7 +62,7 @@ struct net_rate_estimator {
 static void est_fetch_counters(struct net_rate_estimator *e,
 			       struct gnet_stats_basic_packed *b)
 {
-	memset(b, 0, sizeof(*b));
+	gnet_stats_basic_packed_init(b);
 	if (e->stats_lock)
 		spin_lock(e->stats_lock);
=20
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 6ec11289140b6..f2e12fe7112b1 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -18,7 +18,7 @@
 #include <linux/gen_stats.h>
 #include <net/netlink.h>
 #include <net/gen_stats.h>
-
+#include <net/sch_generic.h>
=20
 static inline int
 gnet_stats_copy(struct gnet_dump *d, int type, void *buf, int size, int pa=
dattr)
@@ -114,6 +114,15 @@ gnet_stats_start_copy(struct sk_buff *skb, int type, s=
pinlock_t *lock,
 }
 EXPORT_SYMBOL(gnet_stats_start_copy);
=20
+/* Must not be inlined, due to u64_stats seqcount_t lockdep key */
+void gnet_stats_basic_packed_init(struct gnet_stats_basic_packed *b)
+{
+	b->bytes =3D 0;
+	b->packets =3D 0;
+	u64_stats_init(&b->syncp);
+}
+EXPORT_SYMBOL(gnet_stats_basic_packed_init);
+
 static void gnet_stats_add_basic_cpu(struct gnet_stats_basic_packed *bstat=
s,
 				     struct gnet_stats_basic_cpu __percpu *cpu)
 {
@@ -167,8 +176,9 @@ ___gnet_stats_copy_basic(const seqcount_t *running,
 			 struct gnet_stats_basic_packed *b,
 			 int type)
 {
-	struct gnet_stats_basic_packed bstats =3D {0};
+	struct gnet_stats_basic_packed bstats;
=20
+	gnet_stats_basic_packed_init(&bstats);
 	gnet_stats_add_basic(running, &bstats, cpu, b);
=20
 	if (d->compat_tc_stats && type =3D=3D TCA_STATS_BASIC) {
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 0d5c422f87452..d5200725ca62c 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -143,6 +143,7 @@ static int xt_rateest_tg_checkentry(const struct xt_tgc=
hk_param *par)
 	if (!est)
 		goto err1;
=20
+	gnet_stats_basic_packed_init(&est->bstats);
 	strlcpy(est->name, info->name, sizeof(est->name));
 	spin_lock_init(&est->lock);
 	est->refcnt		=3D 1;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 7dd3a2dc5fa40..0302dad42df14 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -490,6 +490,8 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index,=
 struct nlattr *est,
 		if (!p->cpu_qstats)
 			goto err3;
 	}
+	gnet_stats_basic_packed_init(&p->tcfa_bstats);
+	gnet_stats_basic_packed_init(&p->tcfa_bstats_hw);
 	spin_lock_init(&p->tcfa_lock);
 	p->tcfa_index =3D index;
 	p->tcfa_tm.install =3D jiffies;
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 7d8518176b45a..c8e1771383f9a 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -548,6 +548,7 @@ static int atm_tc_init(struct Qdisc *sch, struct nlattr=
 *opt,
 	pr_debug("atm_tc_init(sch %p,[qdisc %p],opt %p)\n", sch, p, opt);
 	INIT_LIST_HEAD(&p->flows);
 	INIT_LIST_HEAD(&p->link.list);
+	gnet_stats_basic_packed_init(&p->link.bstats);
 	list_add(&p->link.list, &p->flows);
 	p->link.q =3D qdisc_create_dflt(sch->dev_queue,
 				      &pfifo_qdisc_ops, sch->handle, extack);
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index e0da15530f0e9..d01f6ec315f87 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1611,6 +1611,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 =
parentid, struct nlattr **t
 	if (cl =3D=3D NULL)
 		goto failure;
=20
+	gnet_stats_basic_packed_init(&cl->bstats);
 	err =3D tcf_block_get(&cl->block, &cl->filter_list, sch, extack);
 	if (err) {
 		kfree(cl);
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 642cd179b7a75..319906e19a6ba 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -106,6 +106,7 @@ static int drr_change_class(struct Qdisc *sch, u32 clas=
sid, u32 parentid,
 	if (cl =3D=3D NULL)
 		return -ENOBUFS;
=20
+	gnet_stats_basic_packed_init(&cl->bstats);
 	cl->common.classid =3D classid;
 	cl->quantum	   =3D quantum;
 	cl->qdisc	   =3D qdisc_create_dflt(sch->dev_queue,
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index ed86b7021f6d0..83693107371f9 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -689,7 +689,7 @@ static int ets_qdisc_change(struct Qdisc *sch, struct n=
lattr *opt,
 		q->classes[i].qdisc =3D NULL;
 		q->classes[i].quantum =3D 0;
 		q->classes[i].deficit =3D 0;
-		memset(&q->classes[i].bstats, 0, sizeof(q->classes[i].bstats));
+		gnet_stats_basic_packed_init(&q->classes[i].bstats);
 		memset(&q->classes[i].qstats, 0, sizeof(q->classes[i].qstats));
 	}
 	return 0;
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 8c64a552a64fe..ef27ff3ddee4f 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -892,6 +892,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queu=
e,
 	__skb_queue_head_init(&sch->gso_skb);
 	__skb_queue_head_init(&sch->skb_bad_txq);
 	qdisc_skb_head_init(&sch->q);
+	gnet_stats_basic_packed_init(&sch->bstats);
 	spin_lock_init(&sch->q.lock);
=20
 	if (ops->static_flags & TCQ_F_CPUSTATS) {
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 621dc6afde8f3..2ddcbb2efdbbc 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -364,9 +364,11 @@ static int gred_offload_dump_stats(struct Qdisc *sch)
 	hw_stats->handle =3D sch->handle;
 	hw_stats->parent =3D sch->parent;
=20
-	for (i =3D 0; i < MAX_DPs; i++)
+	for (i =3D 0; i < MAX_DPs; i++) {
+		gnet_stats_basic_packed_init(&hw_stats->stats.bstats[i]);
 		if (table->tab[i])
 			hw_stats->stats.xstats[i] =3D &table->tab[i]->stats;
+	}
=20
 	ret =3D qdisc_offload_dump_helper(sch, TC_SETUP_QDISC_GRED, hw_stats);
 	/* Even if driver returns failure adjust the stats - in case offload
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index b7ac30cca035d..ff6ff54806fcd 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1406,6 +1406,7 @@ hfsc_init_qdisc(struct Qdisc *sch, struct nlattr *opt,
 	if (err)
 		return err;
=20
+	gnet_stats_basic_packed_init(&q->root.bstats);
 	q->root.cl_common.classid =3D sch->handle;
 	q->root.sched   =3D q;
 	q->root.qdisc =3D qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 5067a6e5d4fde..2e805b17efcf9 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1311,7 +1311,7 @@ static void htb_offload_aggregate_stats(struct htb_sc=
hed *q,
 	struct htb_class *c;
 	unsigned int i;
=20
-	memset(&cl->bstats, 0, sizeof(cl->bstats));
+	gnet_stats_basic_packed_init(&cl->bstats);
=20
 	for (i =3D 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry(c, &q->clhash.hash[i], common.hnode) {
@@ -1357,7 +1357,7 @@ htb_dump_class_stats(struct Qdisc *sch, unsigned long=
 arg, struct gnet_dump *d)
 			if (cl->leaf.q)
 				cl->bstats =3D cl->leaf.q->bstats;
 			else
-				memset(&cl->bstats, 0, sizeof(cl->bstats));
+				gnet_stats_basic_packed_init(&cl->bstats);
 			cl->bstats.bytes +=3D cl->bstats_bias.bytes;
 			cl->bstats.packets +=3D cl->bstats_bias.packets;
 		} else {
@@ -1849,6 +1849,9 @@ static int htb_change_class(struct Qdisc *sch, u32 cl=
assid,
 		if (!cl)
 			goto failure;
=20
+		gnet_stats_basic_packed_init(&cl->bstats);
+		gnet_stats_basic_packed_init(&cl->bstats_bias);
+
 		err =3D tcf_block_get(&cl->block, &cl->filter_list, sch, extack);
 		if (err) {
 			kfree(cl);
diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index 9d58ecb4e80c6..704e14a58f09d 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -132,7 +132,7 @@ static int mq_dump(struct Qdisc *sch, struct sk_buff *s=
kb)
 	unsigned int ntx;
=20
 	sch->q.qlen =3D 0;
-	memset(&sch->bstats, 0, sizeof(sch->bstats));
+	gnet_stats_basic_packed_init(&sch->bstats);
 	memset(&sch->qstats, 0, sizeof(sch->qstats));
=20
 	/* MQ supports lockless qdiscs. However, statistics accounting needs
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 57427b40f0d2e..fe6b4a178fc9f 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -390,7 +390,7 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buf=
f *skb)
 	unsigned int ntx, tc;
=20
 	sch->q.qlen =3D 0;
-	memset(&sch->bstats, 0, sizeof(sch->bstats));
+	gnet_stats_basic_packed_init(&sch->bstats);
 	memset(&sch->qstats, 0, sizeof(sch->qstats));
=20
 	/* MQ supports lockless qdiscs. However, statistics accounting needs
@@ -500,10 +500,11 @@ static int mqprio_dump_class_stats(struct Qdisc *sch,=
 unsigned long cl,
 		int i;
 		__u32 qlen;
 		struct gnet_stats_queue qstats =3D {0};
-		struct gnet_stats_basic_packed bstats =3D {0};
+		struct gnet_stats_basic_packed bstats;
 		struct net_device *dev =3D qdisc_dev(sch);
 		struct netdev_tc_txq tc =3D dev->tc_to_txq[cl & TC_BITMASK];
=20
+		gnet_stats_basic_packed_init(&bstats);
 		/* Drop lock here it will be reclaimed before touching
 		 * statistics this is required because the d->lock we
 		 * hold here is the look on dev_queue->qdisc_sleeping
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 58a9d42b52b8f..b6d989b69324d 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -465,6 +465,7 @@ static int qfq_change_class(struct Qdisc *sch, u32 clas=
sid, u32 parentid,
 	if (cl =3D=3D NULL)
 		return -ENOBUFS;
=20
+	gnet_stats_basic_packed_init(&cl->bstats);
 	cl->common.classid =3D classid;
 	cl->deficit =3D lmax;
=20
--=20
2.33.0

