Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F123C43014B
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243905AbhJPIvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:51:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55188 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243866AbhJPIvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 04:51:31 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634374162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PGJmNaprBZGVY4XCOftHAbuu1qxZkcuFQ1xDrNBueU8=;
        b=RTQEdd8iF6mmoWCvRSJBq38a1xdO8SiD68gCDQsw2xF0i7cIX5fV1zJdIAhisGu5JR3+Y+
        PtjyaKbgHC2561LW07zGIOYqAdeNS44tjNlWnCxD3M7Qe4EyeDPhos8astGXFi9D3qmPBI
        P7J6c7kIanw8UrBtB6WY/An4PR3iBbUWk/xMk8uSTYv2VdSbkIYgAixSFyaApo7G1r73Yz
        BoG2sCQJOy0Tp1L/Vq3qcPCBIqDmCb4Y6MLb6qKZXp7w2f2zmH+vTnQdZtGndkOliqRNxF
        KMnfE9+Wue8HFTZ7kPimW8l6F84bfT4fTFR5UJ6cDxmpa6LuCV+gdb7aeTipwg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634374162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PGJmNaprBZGVY4XCOftHAbuu1qxZkcuFQ1xDrNBueU8=;
        b=w75BJ+tjLGmH8K7oL35i049MfRXaIJrYAMJggFfEY90RcaRzpCy9tVfTy1Tt0zT33bDf7r
        Ay9SQ7m43WEBdhDQ==
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
Subject: [PATCH net-next 8/9] net: sched: Merge Qdisc::bstats and Qdisc::cpu_bstats data types
Date:   Sat, 16 Oct 2021 10:49:09 +0200
Message-Id: <20211016084910.4029084-9-bigeasy@linutronix.de>
In-Reply-To: <20211016084910.4029084-1-bigeasy@linutronix.de>
References: <20211016084910.4029084-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

The only factor differentiating per-CPU bstats data type (struct
gnet_stats_basic_cpu) from the packed non-per-CPU one (struct
gnet_stats_basic_packed) was a u64_stats sync point inside the former.
The two data types are now equivalent: earlier commits added a u64_stats
sync point to the latter.

Combine both data types into "struct gnet_stats_basic_sync". This
eliminates redundancy and simplifies the bstats read/write APIs.

Use u64_stats_t for bstats "packets" and "bytes" data types. On 64-bit
architectures, u64_stats sync points do not use sequence counter
protection.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 .../net/ethernet/netronome/nfp/abm/qdisc.c    |  2 +-
 include/net/act_api.h                         | 10 +--
 include/net/gen_stats.h                       | 44 ++++++-------
 include/net/netfilter/xt_rateest.h            |  2 +-
 include/net/pkt_cls.h                         |  4 +-
 include/net/sch_generic.h                     | 34 +++-------
 net/core/gen_estimator.c                      | 36 ++++++-----
 net/core/gen_stats.c                          | 62 ++++++++++---------
 net/netfilter/xt_RATEEST.c                    |  8 +--
 net/sched/act_api.c                           | 14 ++---
 net/sched/act_bpf.c                           |  2 +-
 net/sched/act_ife.c                           |  4 +-
 net/sched/act_mpls.c                          |  2 +-
 net/sched/act_police.c                        |  2 +-
 net/sched/act_sample.c                        |  2 +-
 net/sched/act_simple.c                        |  3 +-
 net/sched/act_skbedit.c                       |  2 +-
 net/sched/act_skbmod.c                        |  2 +-
 net/sched/sch_api.c                           |  2 +-
 net/sched/sch_atm.c                           |  4 +-
 net/sched/sch_cbq.c                           |  4 +-
 net/sched/sch_drr.c                           |  4 +-
 net/sched/sch_ets.c                           |  4 +-
 net/sched/sch_generic.c                       |  4 +-
 net/sched/sch_gred.c                          | 10 +--
 net/sched/sch_hfsc.c                          |  4 +-
 net/sched/sch_htb.c                           | 32 +++++-----
 net/sched/sch_mq.c                            |  2 +-
 net/sched/sch_mqprio.c                        |  6 +-
 net/sched/sch_qfq.c                           |  4 +-
 30 files changed, 155 insertions(+), 160 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/qdisc.c b/drivers/net/e=
thernet/netronome/nfp/abm/qdisc.c
index 2473fb5f75e5e..2a5cc64227e9f 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/qdisc.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/qdisc.c
@@ -458,7 +458,7 @@ nfp_abm_qdisc_graft(struct nfp_abm_link *alink, u32 han=
dle, u32 child_handle,
 static void
 nfp_abm_stats_calculate(struct nfp_alink_stats *new,
 			struct nfp_alink_stats *old,
-			struct gnet_stats_basic_packed *bstats,
+			struct gnet_stats_basic_sync *bstats,
 			struct gnet_stats_queue *qstats)
 {
 	_bstats_update(bstats, new->tx_bytes - old->tx_bytes,
diff --git a/include/net/act_api.h b/include/net/act_api.h
index f19f7f4a463cd..b5b624c7e4888 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -30,13 +30,13 @@ struct tc_action {
 	atomic_t			tcfa_bindcnt;
 	int				tcfa_action;
 	struct tcf_t			tcfa_tm;
-	struct gnet_stats_basic_packed	tcfa_bstats;
-	struct gnet_stats_basic_packed	tcfa_bstats_hw;
+	struct gnet_stats_basic_sync	tcfa_bstats;
+	struct gnet_stats_basic_sync	tcfa_bstats_hw;
 	struct gnet_stats_queue		tcfa_qstats;
 	struct net_rate_estimator __rcu *tcfa_rate_est;
 	spinlock_t			tcfa_lock;
-	struct gnet_stats_basic_cpu __percpu *cpu_bstats;
-	struct gnet_stats_basic_cpu __percpu *cpu_bstats_hw;
+	struct gnet_stats_basic_sync __percpu *cpu_bstats;
+	struct gnet_stats_basic_sync __percpu *cpu_bstats_hw;
 	struct gnet_stats_queue __percpu *cpu_qstats;
 	struct tc_cookie	__rcu *act_cookie;
 	struct tcf_chain	__rcu *goto_chain;
@@ -206,7 +206,7 @@ static inline void tcf_action_update_bstats(struct tc_a=
ction *a,
 					    struct sk_buff *skb)
 {
 	if (likely(a->cpu_bstats)) {
-		bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), skb);
+		bstats_update(this_cpu_ptr(a->cpu_bstats), skb);
 		return;
 	}
 	spin_lock(&a->tcfa_lock);
diff --git a/include/net/gen_stats.h b/include/net/gen_stats.h
index 304d792f79776..52b87588f467b 100644
--- a/include/net/gen_stats.h
+++ b/include/net/gen_stats.h
@@ -7,15 +7,17 @@
 #include <linux/rtnetlink.h>
 #include <linux/pkt_sched.h>
=20
-/* Note: this used to be in include/uapi/linux/gen_stats.h */
-struct gnet_stats_basic_packed {
-	__u64	bytes;
-	__u64	packets;
-	struct u64_stats_sync syncp;
-};
-
-struct gnet_stats_basic_cpu {
-	struct gnet_stats_basic_packed bstats;
+/* Throughput stats.
+ * Must be initialized beforehand with gnet_stats_basic_sync_init().
+ *
+ * If no reads can ever occur parallel to writes (e.g. stack-allocated
+ * bstats), then the internal stat values can be written to and read
+ * from directly. Otherwise, use _bstats_set/update() for writes and
+ * gnet_stats_add_basic() for reads.
+ */
+struct gnet_stats_basic_sync {
+	u64_stats_t bytes;
+	u64_stats_t packets;
 	struct u64_stats_sync syncp;
 } __aligned(2 * sizeof(u64));
=20
@@ -35,7 +37,7 @@ struct gnet_dump {
 	struct tc_stats   tc_stats;
 };
=20
-void gnet_stats_basic_packed_init(struct gnet_stats_basic_packed *b);
+void gnet_stats_basic_sync_init(struct gnet_stats_basic_sync *b);
 int gnet_stats_start_copy(struct sk_buff *skb, int type, spinlock_t *lock,
 			  struct gnet_dump *d, int padattr);
=20
@@ -46,16 +48,16 @@ int gnet_stats_start_copy_compat(struct sk_buff *skb, i=
nt type,
=20
 int gnet_stats_copy_basic(const seqcount_t *running,
 			  struct gnet_dump *d,
-			  struct gnet_stats_basic_cpu __percpu *cpu,
-			  struct gnet_stats_basic_packed *b);
+			  struct gnet_stats_basic_sync __percpu *cpu,
+			  struct gnet_stats_basic_sync *b);
 void gnet_stats_add_basic(const seqcount_t *running,
-			  struct gnet_stats_basic_packed *bstats,
-			  struct gnet_stats_basic_cpu __percpu *cpu,
-			  struct gnet_stats_basic_packed *b);
+			  struct gnet_stats_basic_sync *bstats,
+			  struct gnet_stats_basic_sync __percpu *cpu,
+			  struct gnet_stats_basic_sync *b);
 int gnet_stats_copy_basic_hw(const seqcount_t *running,
 			     struct gnet_dump *d,
-			     struct gnet_stats_basic_cpu __percpu *cpu,
-			     struct gnet_stats_basic_packed *b);
+			     struct gnet_stats_basic_sync __percpu *cpu,
+			     struct gnet_stats_basic_sync *b);
 int gnet_stats_copy_rate_est(struct gnet_dump *d,
 			     struct net_rate_estimator __rcu **ptr);
 int gnet_stats_copy_queue(struct gnet_dump *d,
@@ -68,14 +70,14 @@ int gnet_stats_copy_app(struct gnet_dump *d, void *st, =
int len);
=20
 int gnet_stats_finish_copy(struct gnet_dump *d);
=20
-int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
-		      struct gnet_stats_basic_cpu __percpu *cpu_bstats,
+int gen_new_estimator(struct gnet_stats_basic_sync *bstats,
+		      struct gnet_stats_basic_sync __percpu *cpu_bstats,
 		      struct net_rate_estimator __rcu **rate_est,
 		      spinlock_t *lock,
 		      seqcount_t *running, struct nlattr *opt);
 void gen_kill_estimator(struct net_rate_estimator __rcu **ptr);
-int gen_replace_estimator(struct gnet_stats_basic_packed *bstats,
-			  struct gnet_stats_basic_cpu __percpu *cpu_bstats,
+int gen_replace_estimator(struct gnet_stats_basic_sync *bstats,
+			  struct gnet_stats_basic_sync __percpu *cpu_bstats,
 			  struct net_rate_estimator __rcu **ptr,
 			  spinlock_t *lock,
 			  seqcount_t *running, struct nlattr *opt);
diff --git a/include/net/netfilter/xt_rateest.h b/include/net/netfilter/xt_=
rateest.h
index 832ab69efda57..4c3809e141f4f 100644
--- a/include/net/netfilter/xt_rateest.h
+++ b/include/net/netfilter/xt_rateest.h
@@ -6,7 +6,7 @@
=20
 struct xt_rateest {
 	/* keep lock and bstats on same cache line to speedup xt_rateest_tg() */
-	struct gnet_stats_basic_packed	bstats;
+	struct gnet_stats_basic_sync	bstats;
 	spinlock_t			lock;
=20
=20
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 83a6d07921806..4a5833108083f 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -765,7 +765,7 @@ struct tc_cookie {
 };
=20
 struct tc_qopt_offload_stats {
-	struct gnet_stats_basic_packed *bstats;
+	struct gnet_stats_basic_sync *bstats;
 	struct gnet_stats_queue *qstats;
 };
=20
@@ -885,7 +885,7 @@ struct tc_gred_qopt_offload_params {
 };
=20
 struct tc_gred_qopt_offload_stats {
-	struct gnet_stats_basic_packed bstats[MAX_DPs];
+	struct gnet_stats_basic_sync bstats[MAX_DPs];
 	struct gnet_stats_queue qstats[MAX_DPs];
 	struct red_stats *xstats[MAX_DPs];
 };
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d7746aea3cecf..7882e3aa64482 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -97,7 +97,7 @@ struct Qdisc {
 	struct netdev_queue	*dev_queue;
=20
 	struct net_rate_estimator __rcu *rate_est;
-	struct gnet_stats_basic_cpu __percpu *cpu_bstats;
+	struct gnet_stats_basic_sync __percpu *cpu_bstats;
 	struct gnet_stats_queue	__percpu *cpu_qstats;
 	int			pad;
 	refcount_t		refcnt;
@@ -107,7 +107,7 @@ struct Qdisc {
 	 */
 	struct sk_buff_head	gso_skb ____cacheline_aligned_in_smp;
 	struct qdisc_skb_head	q;
-	struct gnet_stats_basic_packed bstats;
+	struct gnet_stats_basic_sync bstats;
 	seqcount_t		running;
 	struct gnet_stats_queue	qstats;
 	unsigned long		state;
@@ -849,16 +849,16 @@ static inline int qdisc_enqueue(struct sk_buff *skb, =
struct Qdisc *sch,
 	return sch->enqueue(skb, sch, to_free);
 }
=20
-static inline void _bstats_update(struct gnet_stats_basic_packed *bstats,
+static inline void _bstats_update(struct gnet_stats_basic_sync *bstats,
 				  __u64 bytes, __u32 packets)
 {
 	u64_stats_update_begin(&bstats->syncp);
-	bstats->bytes +=3D bytes;
-	bstats->packets +=3D packets;
+	u64_stats_add(&bstats->bytes, bytes);
+	u64_stats_add(&bstats->packets, packets);
 	u64_stats_update_end(&bstats->syncp);
 }
=20
-static inline void bstats_update(struct gnet_stats_basic_packed *bstats,
+static inline void bstats_update(struct gnet_stats_basic_sync *bstats,
 				 const struct sk_buff *skb)
 {
 	_bstats_update(bstats,
@@ -866,26 +866,10 @@ static inline void bstats_update(struct gnet_stats_ba=
sic_packed *bstats,
 		       skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1);
 }
=20
-static inline void _bstats_cpu_update(struct gnet_stats_basic_cpu *bstats,
-				      __u64 bytes, __u32 packets)
-{
-	u64_stats_update_begin(&bstats->syncp);
-	_bstats_update(&bstats->bstats, bytes, packets);
-	u64_stats_update_end(&bstats->syncp);
-}
-
-static inline void bstats_cpu_update(struct gnet_stats_basic_cpu *bstats,
-				     const struct sk_buff *skb)
-{
-	u64_stats_update_begin(&bstats->syncp);
-	bstats_update(&bstats->bstats, skb);
-	u64_stats_update_end(&bstats->syncp);
-}
-
 static inline void qdisc_bstats_cpu_update(struct Qdisc *sch,
 					   const struct sk_buff *skb)
 {
-	bstats_cpu_update(this_cpu_ptr(sch->cpu_bstats), skb);
+	bstats_update(this_cpu_ptr(sch->cpu_bstats), skb);
 }
=20
 static inline void qdisc_bstats_update(struct Qdisc *sch,
@@ -1317,7 +1301,7 @@ void psched_ppscfg_precompute(struct psched_pktrate *=
r, u64 pktrate64);
 struct mini_Qdisc {
 	struct tcf_proto *filter_list;
 	struct tcf_block *block;
-	struct gnet_stats_basic_cpu __percpu *cpu_bstats;
+	struct gnet_stats_basic_sync __percpu *cpu_bstats;
 	struct gnet_stats_queue	__percpu *cpu_qstats;
 	struct rcu_head rcu;
 };
@@ -1325,7 +1309,7 @@ struct mini_Qdisc {
 static inline void mini_qdisc_bstats_cpu_update(struct mini_Qdisc *miniq,
 						const struct sk_buff *skb)
 {
-	bstats_cpu_update(this_cpu_ptr(miniq->cpu_bstats), skb);
+	bstats_update(this_cpu_ptr(miniq->cpu_bstats), skb);
 }
=20
 static inline void mini_qdisc_qstats_cpu_drop(struct mini_Qdisc *miniq)
diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 64978e77368f4..a73ad0bf324c4 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -40,10 +40,10 @@
  */
=20
 struct net_rate_estimator {
-	struct gnet_stats_basic_packed	*bstats;
+	struct gnet_stats_basic_sync	*bstats;
 	spinlock_t		*stats_lock;
 	seqcount_t		*running;
-	struct gnet_stats_basic_cpu __percpu *cpu_bstats;
+	struct gnet_stats_basic_sync __percpu *cpu_bstats;
 	u8			ewma_log;
 	u8			intvl_log; /* period : (250ms << intvl_log) */
=20
@@ -60,9 +60,9 @@ struct net_rate_estimator {
 };
=20
 static void est_fetch_counters(struct net_rate_estimator *e,
-			       struct gnet_stats_basic_packed *b)
+			       struct gnet_stats_basic_sync *b)
 {
-	gnet_stats_basic_packed_init(b);
+	gnet_stats_basic_sync_init(b);
 	if (e->stats_lock)
 		spin_lock(e->stats_lock);
=20
@@ -76,14 +76,18 @@ static void est_fetch_counters(struct net_rate_estimato=
r *e,
 static void est_timer(struct timer_list *t)
 {
 	struct net_rate_estimator *est =3D from_timer(est, t, timer);
-	struct gnet_stats_basic_packed b;
+	struct gnet_stats_basic_sync b;
+	u64 b_bytes, b_packets;
 	u64 rate, brate;
=20
 	est_fetch_counters(est, &b);
-	brate =3D (b.bytes - est->last_bytes) << (10 - est->intvl_log);
+	b_bytes =3D u64_stats_read(&b.bytes);
+	b_packets =3D u64_stats_read(&b.packets);
+
+	brate =3D (b_bytes - est->last_bytes) << (10 - est->intvl_log);
 	brate =3D (brate >> est->ewma_log) - (est->avbps >> est->ewma_log);
=20
-	rate =3D (b.packets - est->last_packets) << (10 - est->intvl_log);
+	rate =3D (b_packets - est->last_packets) << (10 - est->intvl_log);
 	rate =3D (rate >> est->ewma_log) - (est->avpps >> est->ewma_log);
=20
 	write_seqcount_begin(&est->seq);
@@ -91,8 +95,8 @@ static void est_timer(struct timer_list *t)
 	est->avpps +=3D rate;
 	write_seqcount_end(&est->seq);
=20
-	est->last_bytes =3D b.bytes;
-	est->last_packets =3D b.packets;
+	est->last_bytes =3D b_bytes;
+	est->last_packets =3D b_packets;
=20
 	est->next_jiffies +=3D ((HZ/4) << est->intvl_log);
=20
@@ -121,8 +125,8 @@ static void est_timer(struct timer_list *t)
  * Returns 0 on success or a negative error code.
  *
  */
-int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
-		      struct gnet_stats_basic_cpu __percpu *cpu_bstats,
+int gen_new_estimator(struct gnet_stats_basic_sync *bstats,
+		      struct gnet_stats_basic_sync __percpu *cpu_bstats,
 		      struct net_rate_estimator __rcu **rate_est,
 		      spinlock_t *lock,
 		      seqcount_t *running,
@@ -130,7 +134,7 @@ int gen_new_estimator(struct gnet_stats_basic_packed *b=
stats,
 {
 	struct gnet_estimator *parm =3D nla_data(opt);
 	struct net_rate_estimator *old, *est;
-	struct gnet_stats_basic_packed b;
+	struct gnet_stats_basic_sync b;
 	int intvl_log;
=20
 	if (nla_len(opt) < sizeof(*parm))
@@ -164,8 +168,8 @@ int gen_new_estimator(struct gnet_stats_basic_packed *b=
stats,
 	est_fetch_counters(est, &b);
 	if (lock)
 		local_bh_enable();
-	est->last_bytes =3D b.bytes;
-	est->last_packets =3D b.packets;
+	est->last_bytes =3D u64_stats_read(&b.bytes);
+	est->last_packets =3D u64_stats_read(&b.packets);
=20
 	if (lock)
 		spin_lock_bh(lock);
@@ -222,8 +226,8 @@ EXPORT_SYMBOL(gen_kill_estimator);
  *
  * Returns 0 on success or a negative error code.
  */
-int gen_replace_estimator(struct gnet_stats_basic_packed *bstats,
-			  struct gnet_stats_basic_cpu __percpu *cpu_bstats,
+int gen_replace_estimator(struct gnet_stats_basic_sync *bstats,
+			  struct gnet_stats_basic_sync __percpu *cpu_bstats,
 			  struct net_rate_estimator __rcu **rate_est,
 			  spinlock_t *lock,
 			  seqcount_t *running, struct nlattr *opt)
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 69576972a25f0..5f57f761def69 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -115,29 +115,29 @@ gnet_stats_start_copy(struct sk_buff *skb, int type, =
spinlock_t *lock,
 EXPORT_SYMBOL(gnet_stats_start_copy);
=20
 /* Must not be inlined, due to u64_stats seqcount_t lockdep key */
-void gnet_stats_basic_packed_init(struct gnet_stats_basic_packed *b)
+void gnet_stats_basic_sync_init(struct gnet_stats_basic_sync *b)
 {
-	b->bytes =3D 0;
-	b->packets =3D 0;
+	u64_stats_set(&b->bytes, 0);
+	u64_stats_set(&b->packets, 0);
 	u64_stats_init(&b->syncp);
 }
-EXPORT_SYMBOL(gnet_stats_basic_packed_init);
+EXPORT_SYMBOL(gnet_stats_basic_sync_init);
=20
-static void gnet_stats_add_basic_cpu(struct gnet_stats_basic_packed *bstat=
s,
-				     struct gnet_stats_basic_cpu __percpu *cpu)
+static void gnet_stats_add_basic_cpu(struct gnet_stats_basic_sync *bstats,
+				     struct gnet_stats_basic_sync __percpu *cpu)
 {
 	u64 t_bytes =3D 0, t_packets =3D 0;
 	int i;
=20
 	for_each_possible_cpu(i) {
-		struct gnet_stats_basic_cpu *bcpu =3D per_cpu_ptr(cpu, i);
+		struct gnet_stats_basic_sync *bcpu =3D per_cpu_ptr(cpu, i);
 		unsigned int start;
 		u64 bytes, packets;
=20
 		do {
 			start =3D u64_stats_fetch_begin_irq(&bcpu->syncp);
-			bytes =3D bcpu->bstats.bytes;
-			packets =3D bcpu->bstats.packets;
+			bytes =3D u64_stats_read(&bcpu->bytes);
+			packets =3D u64_stats_read(&bcpu->packets);
 		} while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));
=20
 		t_bytes +=3D bytes;
@@ -147,9 +147,9 @@ static void gnet_stats_add_basic_cpu(struct gnet_stats_=
basic_packed *bstats,
 }
=20
 void gnet_stats_add_basic(const seqcount_t *running,
-			  struct gnet_stats_basic_packed *bstats,
-			  struct gnet_stats_basic_cpu __percpu *cpu,
-			  struct gnet_stats_basic_packed *b)
+			  struct gnet_stats_basic_sync *bstats,
+			  struct gnet_stats_basic_sync __percpu *cpu,
+			  struct gnet_stats_basic_sync *b)
 {
 	unsigned int seq;
 	u64 bytes =3D 0;
@@ -162,8 +162,8 @@ void gnet_stats_add_basic(const seqcount_t *running,
 	do {
 		if (running)
 			seq =3D read_seqcount_begin(running);
-		bytes =3D b->bytes;
-		packets =3D b->packets;
+		bytes =3D u64_stats_read(&b->bytes);
+		packets =3D u64_stats_read(&b->packets);
 	} while (running && read_seqcount_retry(running, seq));
=20
 	_bstats_update(bstats, bytes, packets);
@@ -173,18 +173,22 @@ EXPORT_SYMBOL(gnet_stats_add_basic);
 static int
 ___gnet_stats_copy_basic(const seqcount_t *running,
 			 struct gnet_dump *d,
-			 struct gnet_stats_basic_cpu __percpu *cpu,
-			 struct gnet_stats_basic_packed *b,
+			 struct gnet_stats_basic_sync __percpu *cpu,
+			 struct gnet_stats_basic_sync *b,
 			 int type)
 {
-	struct gnet_stats_basic_packed bstats;
+	struct gnet_stats_basic_sync bstats;
+	u64 bstats_bytes, bstats_packets;
=20
-	gnet_stats_basic_packed_init(&bstats);
+	gnet_stats_basic_sync_init(&bstats);
 	gnet_stats_add_basic(running, &bstats, cpu, b);
=20
+	bstats_bytes =3D u64_stats_read(&bstats.bytes);
+	bstats_packets =3D u64_stats_read(&bstats.packets);
+
 	if (d->compat_tc_stats && type =3D=3D TCA_STATS_BASIC) {
-		d->tc_stats.bytes =3D bstats.bytes;
-		d->tc_stats.packets =3D bstats.packets;
+		d->tc_stats.bytes =3D bstats_bytes;
+		d->tc_stats.packets =3D bstats_packets;
 	}
=20
 	if (d->tail) {
@@ -192,14 +196,14 @@ ___gnet_stats_copy_basic(const seqcount_t *running,
 		int res;
=20
 		memset(&sb, 0, sizeof(sb));
-		sb.bytes =3D bstats.bytes;
-		sb.packets =3D bstats.packets;
+		sb.bytes =3D bstats_bytes;
+		sb.packets =3D bstats_packets;
 		res =3D gnet_stats_copy(d, type, &sb, sizeof(sb), TCA_STATS_PAD);
-		if (res < 0 || sb.packets =3D=3D bstats.packets)
+		if (res < 0 || sb.packets =3D=3D bstats_packets)
 			return res;
 		/* emit 64bit stats only if needed */
-		return gnet_stats_copy(d, TCA_STATS_PKT64, &bstats.packets,
-				       sizeof(bstats.packets), TCA_STATS_PAD);
+		return gnet_stats_copy(d, TCA_STATS_PKT64, &bstats_packets,
+				       sizeof(bstats_packets), TCA_STATS_PAD);
 	}
 	return 0;
 }
@@ -220,8 +224,8 @@ ___gnet_stats_copy_basic(const seqcount_t *running,
 int
 gnet_stats_copy_basic(const seqcount_t *running,
 		      struct gnet_dump *d,
-		      struct gnet_stats_basic_cpu __percpu *cpu,
-		      struct gnet_stats_basic_packed *b)
+		      struct gnet_stats_basic_sync __percpu *cpu,
+		      struct gnet_stats_basic_sync *b)
 {
 	return ___gnet_stats_copy_basic(running, d, cpu, b,
 					TCA_STATS_BASIC);
@@ -244,8 +248,8 @@ EXPORT_SYMBOL(gnet_stats_copy_basic);
 int
 gnet_stats_copy_basic_hw(const seqcount_t *running,
 			 struct gnet_dump *d,
-			 struct gnet_stats_basic_cpu __percpu *cpu,
-			 struct gnet_stats_basic_packed *b)
+			 struct gnet_stats_basic_sync __percpu *cpu,
+			 struct gnet_stats_basic_sync *b)
 {
 	return ___gnet_stats_copy_basic(running, d, cpu, b,
 					TCA_STATS_BASIC_HW);
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index d5200725ca62c..8aec1b529364a 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -94,11 +94,11 @@ static unsigned int
 xt_rateest_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_rateest_target_info *info =3D par->targinfo;
-	struct gnet_stats_basic_packed *stats =3D &info->est->bstats;
+	struct gnet_stats_basic_sync *stats =3D &info->est->bstats;
=20
 	spin_lock_bh(&info->est->lock);
-	stats->bytes +=3D skb->len;
-	stats->packets++;
+	u64_stats_add(&stats->bytes, skb->len);
+	u64_stats_inc(&stats->packets);
 	spin_unlock_bh(&info->est->lock);
=20
 	return XT_CONTINUE;
@@ -143,7 +143,7 @@ static int xt_rateest_tg_checkentry(const struct xt_tgc=
hk_param *par)
 	if (!est)
 		goto err1;
=20
-	gnet_stats_basic_packed_init(&est->bstats);
+	gnet_stats_basic_sync_init(&est->bstats);
 	strlcpy(est->name, info->name, sizeof(est->name));
 	spin_lock_init(&est->lock);
 	est->refcnt		=3D 1;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 0302dad42df14..585829ffa0c4c 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -480,18 +480,18 @@ int tcf_idr_create(struct tc_action_net *tn, u32 inde=
x, struct nlattr *est,
 		atomic_set(&p->tcfa_bindcnt, 1);
=20
 	if (cpustats) {
-		p->cpu_bstats =3D netdev_alloc_pcpu_stats(struct gnet_stats_basic_cpu);
+		p->cpu_bstats =3D netdev_alloc_pcpu_stats(struct gnet_stats_basic_sync);
 		if (!p->cpu_bstats)
 			goto err1;
-		p->cpu_bstats_hw =3D netdev_alloc_pcpu_stats(struct gnet_stats_basic_cpu=
);
+		p->cpu_bstats_hw =3D netdev_alloc_pcpu_stats(struct gnet_stats_basic_syn=
c);
 		if (!p->cpu_bstats_hw)
 			goto err2;
 		p->cpu_qstats =3D alloc_percpu(struct gnet_stats_queue);
 		if (!p->cpu_qstats)
 			goto err3;
 	}
-	gnet_stats_basic_packed_init(&p->tcfa_bstats);
-	gnet_stats_basic_packed_init(&p->tcfa_bstats_hw);
+	gnet_stats_basic_sync_init(&p->tcfa_bstats);
+	gnet_stats_basic_sync_init(&p->tcfa_bstats_hw);
 	spin_lock_init(&p->tcfa_lock);
 	p->tcfa_index =3D index;
 	p->tcfa_tm.install =3D jiffies;
@@ -1128,13 +1128,13 @@ void tcf_action_update_stats(struct tc_action *a, u=
64 bytes, u64 packets,
 			     u64 drops, bool hw)
 {
 	if (a->cpu_bstats) {
-		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
+		_bstats_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
=20
 		this_cpu_ptr(a->cpu_qstats)->drops +=3D drops;
=20
 		if (hw)
-			_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
-					   bytes, packets);
+			_bstats_update(this_cpu_ptr(a->cpu_bstats_hw),
+				       bytes, packets);
 		return;
 	}
=20
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 5c36013339e11..f2bf896331a59 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -41,7 +41,7 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct =
tc_action *act,
 	int action, filter_res;
=20
 	tcf_lastuse_update(&prog->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(prog->common.cpu_bstats), skb);
+	bstats_update(this_cpu_ptr(prog->common.cpu_bstats), skb);
=20
 	filter =3D rcu_dereference(prog->filter);
 	if (at_ingress) {
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 7064a365a1a98..b757f90a2d589 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -718,7 +718,7 @@ static int tcf_ife_decode(struct sk_buff *skb, const st=
ruct tc_action *a,
 	u8 *tlv_data;
 	u16 metalen;
=20
-	bstats_cpu_update(this_cpu_ptr(ife->common.cpu_bstats), skb);
+	bstats_update(this_cpu_ptr(ife->common.cpu_bstats), skb);
 	tcf_lastuse_update(&ife->tcf_tm);
=20
 	if (skb_at_tc_ingress(skb))
@@ -806,7 +806,7 @@ static int tcf_ife_encode(struct sk_buff *skb, const st=
ruct tc_action *a,
 			exceed_mtu =3D true;
 	}
=20
-	bstats_cpu_update(this_cpu_ptr(ife->common.cpu_bstats), skb);
+	bstats_update(this_cpu_ptr(ife->common.cpu_bstats), skb);
 	tcf_lastuse_update(&ife->tcf_tm);
=20
 	if (!metalen) {		/* no metadata to send */
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index e4529b428cf44..8faa4c58305e3 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -59,7 +59,7 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct=
 tc_action *a,
 	int ret, mac_len;
=20
 	tcf_lastuse_update(&m->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(m->common.cpu_bstats), skb);
+	bstats_update(this_cpu_ptr(m->common.cpu_bstats), skb);
=20
 	/* Ensure 'data' points at mac_header prior calling mpls manipulating
 	 * functions.
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 832157a840fc3..c9383805222df 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -248,7 +248,7 @@ static int tcf_police_act(struct sk_buff *skb, const st=
ruct tc_action *a,
 	int ret;
=20
 	tcf_lastuse_update(&police->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(police->common.cpu_bstats), skb);
+	bstats_update(this_cpu_ptr(police->common.cpu_bstats), skb);
=20
 	ret =3D READ_ONCE(police->tcf_action);
 	p =3D rcu_dereference_bh(police->params);
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 230501eb9e069..ce859b0e0deb9 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -163,7 +163,7 @@ static int tcf_sample_act(struct sk_buff *skb, const st=
ruct tc_action *a,
 	int retval;
=20
 	tcf_lastuse_update(&s->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(s->common.cpu_bstats), skb);
+	bstats_update(this_cpu_ptr(s->common.cpu_bstats), skb);
 	retval =3D READ_ONCE(s->tcf_action);
=20
 	psample_group =3D rcu_dereference_bh(s->psample_group);
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index cbbe1861d3a20..e617ab4505ca4 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -36,7 +36,8 @@ static int tcf_simp_act(struct sk_buff *skb, const struct=
 tc_action *a,
 	 * then it would look like "hello_3" (without quotes)
 	 */
 	pr_info("simple: %s_%llu\n",
-	       (char *)d->tcfd_defdata, d->tcf_bstats.packets);
+		(char *)d->tcfd_defdata,
+		u64_stats_read(&d->tcf_bstats.packets));
 	spin_unlock(&d->tcf_lock);
 	return d->tcf_action;
 }
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 6054185383474..d30ecbfc8f846 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -31,7 +31,7 @@ static int tcf_skbedit_act(struct sk_buff *skb, const str=
uct tc_action *a,
 	int action;
=20
 	tcf_lastuse_update(&d->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(d->common.cpu_bstats), skb);
+	bstats_update(this_cpu_ptr(d->common.cpu_bstats), skb);
=20
 	params =3D rcu_dereference_bh(d->params);
 	action =3D READ_ONCE(d->tcf_action);
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index ecb9ee6660954..9b6b52c5e24ec 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -31,7 +31,7 @@ static int tcf_skbmod_act(struct sk_buff *skb, const stru=
ct tc_action *a,
 	u64 flags;
=20
 	tcf_lastuse_update(&d->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(d->common.cpu_bstats), skb);
+	bstats_update(this_cpu_ptr(d->common.cpu_bstats), skb);
=20
 	action =3D READ_ONCE(d->tcf_action);
 	if (unlikely(action =3D=3D TC_ACT_SHOT))
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 91820f67275c7..70f006cbf2126 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -885,7 +885,7 @@ static void qdisc_offload_graft_root(struct net_device =
*dev,
 static int tc_fill_qdisc(struct sk_buff *skb, struct Qdisc *q, u32 clid,
 			 u32 portid, u32 seq, u16 flags, int event)
 {
-	struct gnet_stats_basic_cpu __percpu *cpu_bstats =3D NULL;
+	struct gnet_stats_basic_sync __percpu *cpu_bstats =3D NULL;
 	struct gnet_stats_queue __percpu *cpu_qstats =3D NULL;
 	struct tcmsg *tcm;
 	struct nlmsghdr  *nlh;
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index c8e1771383f9a..fbfe4ce9497b5 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -52,7 +52,7 @@ struct atm_flow_data {
 	struct atm_qdisc_data	*parent;	/* parent qdisc */
 	struct socket		*sock;		/* for closing */
 	int			ref;		/* reference count */
-	struct gnet_stats_basic_packed	bstats;
+	struct gnet_stats_basic_sync	bstats;
 	struct gnet_stats_queue	qstats;
 	struct list_head	list;
 	struct atm_flow_data	*excess;	/* flow for excess traffic;
@@ -548,7 +548,7 @@ static int atm_tc_init(struct Qdisc *sch, struct nlattr=
 *opt,
 	pr_debug("atm_tc_init(sch %p,[qdisc %p],opt %p)\n", sch, p, opt);
 	INIT_LIST_HEAD(&p->flows);
 	INIT_LIST_HEAD(&p->link.list);
-	gnet_stats_basic_packed_init(&p->link.bstats);
+	gnet_stats_basic_sync_init(&p->link.bstats);
 	list_add(&p->link.list, &p->flows);
 	p->link.q =3D qdisc_create_dflt(sch->dev_queue,
 				      &pfifo_qdisc_ops, sch->handle, extack);
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index ef9e87175d35c..f0b1282fae111 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -116,7 +116,7 @@ struct cbq_class {
 	long			avgidle;
 	long			deficit;	/* Saved deficit for WRR */
 	psched_time_t		penalized;
-	struct gnet_stats_basic_packed bstats;
+	struct gnet_stats_basic_sync bstats;
 	struct gnet_stats_queue qstats;
 	struct net_rate_estimator __rcu *rate_est;
 	struct tc_cbq_xstats	xstats;
@@ -1610,7 +1610,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 =
parentid, struct nlattr **t
 	if (cl =3D=3D NULL)
 		goto failure;
=20
-	gnet_stats_basic_packed_init(&cl->bstats);
+	gnet_stats_basic_sync_init(&cl->bstats);
 	err =3D tcf_block_get(&cl->block, &cl->filter_list, sch, extack);
 	if (err) {
 		kfree(cl);
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 319906e19a6ba..7243617a3595f 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -19,7 +19,7 @@ struct drr_class {
 	struct Qdisc_class_common	common;
 	unsigned int			filter_cnt;
=20
-	struct gnet_stats_basic_packed		bstats;
+	struct gnet_stats_basic_sync		bstats;
 	struct gnet_stats_queue		qstats;
 	struct net_rate_estimator __rcu *rate_est;
 	struct list_head		alist;
@@ -106,7 +106,7 @@ static int drr_change_class(struct Qdisc *sch, u32 clas=
sid, u32 parentid,
 	if (cl =3D=3D NULL)
 		return -ENOBUFS;
=20
-	gnet_stats_basic_packed_init(&cl->bstats);
+	gnet_stats_basic_sync_init(&cl->bstats);
 	cl->common.classid =3D classid;
 	cl->quantum	   =3D quantum;
 	cl->qdisc	   =3D qdisc_create_dflt(sch->dev_queue,
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 83693107371f9..af56d155e7fca 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -41,7 +41,7 @@ struct ets_class {
 	struct Qdisc *qdisc;
 	u32 quantum;
 	u32 deficit;
-	struct gnet_stats_basic_packed bstats;
+	struct gnet_stats_basic_sync bstats;
 	struct gnet_stats_queue qstats;
 };
=20
@@ -689,7 +689,7 @@ static int ets_qdisc_change(struct Qdisc *sch, struct n=
lattr *opt,
 		q->classes[i].qdisc =3D NULL;
 		q->classes[i].quantum =3D 0;
 		q->classes[i].deficit =3D 0;
-		gnet_stats_basic_packed_init(&q->classes[i].bstats);
+		gnet_stats_basic_sync_init(&q->classes[i].bstats);
 		memset(&q->classes[i].qstats, 0, sizeof(q->classes[i].qstats));
 	}
 	return 0;
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index ef27ff3ddee4f..989186e7f1a02 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -892,12 +892,12 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_qu=
eue,
 	__skb_queue_head_init(&sch->gso_skb);
 	__skb_queue_head_init(&sch->skb_bad_txq);
 	qdisc_skb_head_init(&sch->q);
-	gnet_stats_basic_packed_init(&sch->bstats);
+	gnet_stats_basic_sync_init(&sch->bstats);
 	spin_lock_init(&sch->q.lock);
=20
 	if (ops->static_flags & TCQ_F_CPUSTATS) {
 		sch->cpu_bstats =3D
-			netdev_alloc_pcpu_stats(struct gnet_stats_basic_cpu);
+			netdev_alloc_pcpu_stats(struct gnet_stats_basic_sync);
 		if (!sch->cpu_bstats)
 			goto errout1;
=20
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 02b03d6d24ea4..72de08ef8335e 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -366,7 +366,7 @@ static int gred_offload_dump_stats(struct Qdisc *sch)
 	hw_stats->parent =3D sch->parent;
=20
 	for (i =3D 0; i < MAX_DPs; i++) {
-		gnet_stats_basic_packed_init(&hw_stats->stats.bstats[i]);
+		gnet_stats_basic_sync_init(&hw_stats->stats.bstats[i]);
 		if (table->tab[i])
 			hw_stats->stats.xstats[i] =3D &table->tab[i]->stats;
 	}
@@ -378,12 +378,12 @@ static int gred_offload_dump_stats(struct Qdisc *sch)
 	for (i =3D 0; i < MAX_DPs; i++) {
 		if (!table->tab[i])
 			continue;
-		table->tab[i]->packetsin +=3D hw_stats->stats.bstats[i].packets;
-		table->tab[i]->bytesin +=3D hw_stats->stats.bstats[i].bytes;
+		table->tab[i]->packetsin +=3D u64_stats_read(&hw_stats->stats.bstats[i].=
packets);
+		table->tab[i]->bytesin +=3D u64_stats_read(&hw_stats->stats.bstats[i].by=
tes);
 		table->tab[i]->backlog +=3D hw_stats->stats.qstats[i].backlog;
=20
-		bytes +=3D hw_stats->stats.bstats[i].bytes;
-		packets +=3D hw_stats->stats.bstats[i].packets;
+		bytes +=3D u64_stats_read(&hw_stats->stats.bstats[i].bytes);
+		packets +=3D u64_stats_read(&hw_stats->stats.bstats[i].packets);
 		sch->qstats.qlen +=3D hw_stats->stats.qstats[i].qlen;
 		sch->qstats.backlog +=3D hw_stats->stats.qstats[i].backlog;
 		sch->qstats.drops +=3D hw_stats->stats.qstats[i].drops;
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index ff6ff54806fcd..181c2905ff983 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -111,7 +111,7 @@ enum hfsc_class_flags {
 struct hfsc_class {
 	struct Qdisc_class_common cl_common;
=20
-	struct gnet_stats_basic_packed bstats;
+	struct gnet_stats_basic_sync bstats;
 	struct gnet_stats_queue qstats;
 	struct net_rate_estimator __rcu *rate_est;
 	struct tcf_proto __rcu *filter_list; /* filter list */
@@ -1406,7 +1406,7 @@ hfsc_init_qdisc(struct Qdisc *sch, struct nlattr *opt,
 	if (err)
 		return err;
=20
-	gnet_stats_basic_packed_init(&q->root.bstats);
+	gnet_stats_basic_sync_init(&q->root.bstats);
 	q->root.cl_common.classid =3D sch->handle;
 	q->root.sched   =3D q;
 	q->root.qdisc =3D qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 324ecfdf842a3..adceb9e210f61 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -113,8 +113,8 @@ struct htb_class {
 	/*
 	 * Written often fields
 	 */
-	struct gnet_stats_basic_packed bstats;
-	struct gnet_stats_basic_packed bstats_bias;
+	struct gnet_stats_basic_sync bstats;
+	struct gnet_stats_basic_sync bstats_bias;
 	struct tc_htb_xstats	xstats;	/* our special stats */
=20
 	/* token bucket parameters */
@@ -1312,7 +1312,7 @@ static void htb_offload_aggregate_stats(struct htb_sc=
hed *q,
 	struct htb_class *c;
 	unsigned int i;
=20
-	gnet_stats_basic_packed_init(&cl->bstats);
+	gnet_stats_basic_sync_init(&cl->bstats);
=20
 	for (i =3D 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry(c, &q->clhash.hash[i], common.hnode) {
@@ -1324,11 +1324,11 @@ static void htb_offload_aggregate_stats(struct htb_=
sched *q,
 			if (p !=3D cl)
 				continue;
=20
-			bytes +=3D c->bstats_bias.bytes;
-			packets +=3D c->bstats_bias.packets;
+			bytes +=3D u64_stats_read(&c->bstats_bias.bytes);
+			packets +=3D u64_stats_read(&c->bstats_bias.packets);
 			if (c->level =3D=3D 0) {
-				bytes +=3D c->leaf.q->bstats.bytes;
-				packets +=3D c->leaf.q->bstats.packets;
+				bytes +=3D u64_stats_read(&c->leaf.q->bstats.bytes);
+				packets +=3D u64_stats_read(&c->leaf.q->bstats.packets);
 			}
 		}
 	}
@@ -1359,10 +1359,10 @@ htb_dump_class_stats(struct Qdisc *sch, unsigned lo=
ng arg, struct gnet_dump *d)
 			if (cl->leaf.q)
 				cl->bstats =3D cl->leaf.q->bstats;
 			else
-				gnet_stats_basic_packed_init(&cl->bstats);
+				gnet_stats_basic_sync_init(&cl->bstats);
 			_bstats_update(&cl->bstats,
-				       cl->bstats_bias.bytes,
-				       cl->bstats_bias.packets);
+				       u64_stats_read(&cl->bstats_bias.bytes),
+				       u64_stats_read(&cl->bstats_bias.packets));
 		} else {
 			htb_offload_aggregate_stats(q, cl);
 		}
@@ -1582,8 +1582,8 @@ static int htb_destroy_class_offload(struct Qdisc *sc=
h, struct htb_class *cl,
=20
 	if (cl->parent) {
 		_bstats_update(&cl->parent->bstats_bias,
-			       q->bstats.bytes,
-			       q->bstats.packets);
+			       u64_stats_read(&q->bstats.bytes),
+			       u64_stats_read(&q->bstats.packets));
 	}
=20
 	offload_opt =3D (struct tc_htb_qopt_offload) {
@@ -1853,8 +1853,8 @@ static int htb_change_class(struct Qdisc *sch, u32 cl=
assid,
 		if (!cl)
 			goto failure;
=20
-		gnet_stats_basic_packed_init(&cl->bstats);
-		gnet_stats_basic_packed_init(&cl->bstats_bias);
+		gnet_stats_basic_sync_init(&cl->bstats);
+		gnet_stats_basic_sync_init(&cl->bstats_bias);
=20
 		err =3D tcf_block_get(&cl->block, &cl->filter_list, sch, extack);
 		if (err) {
@@ -1930,8 +1930,8 @@ static int htb_change_class(struct Qdisc *sch, u32 cl=
assid,
 				goto err_kill_estimator;
 			}
 			_bstats_update(&parent->bstats_bias,
-				       old_q->bstats.bytes,
-				       old_q->bstats.packets);
+				       u64_stats_read(&old_q->bstats.bytes),
+				       u64_stats_read(&old_q->bstats.packets));
 			qdisc_put(old_q);
 		}
 		new_q =3D qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index 704e14a58f09d..cedd0b3ef9cfb 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -132,7 +132,7 @@ static int mq_dump(struct Qdisc *sch, struct sk_buff *s=
kb)
 	unsigned int ntx;
=20
 	sch->q.qlen =3D 0;
-	gnet_stats_basic_packed_init(&sch->bstats);
+	gnet_stats_basic_sync_init(&sch->bstats);
 	memset(&sch->qstats, 0, sizeof(sch->qstats));
=20
 	/* MQ supports lockless qdiscs. However, statistics accounting needs
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index fe6b4a178fc9f..3f7f756f92ca3 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -390,7 +390,7 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buf=
f *skb)
 	unsigned int ntx, tc;
=20
 	sch->q.qlen =3D 0;
-	gnet_stats_basic_packed_init(&sch->bstats);
+	gnet_stats_basic_sync_init(&sch->bstats);
 	memset(&sch->qstats, 0, sizeof(sch->qstats));
=20
 	/* MQ supports lockless qdiscs. However, statistics accounting needs
@@ -500,11 +500,11 @@ static int mqprio_dump_class_stats(struct Qdisc *sch,=
 unsigned long cl,
 		int i;
 		__u32 qlen;
 		struct gnet_stats_queue qstats =3D {0};
-		struct gnet_stats_basic_packed bstats;
+		struct gnet_stats_basic_sync bstats;
 		struct net_device *dev =3D qdisc_dev(sch);
 		struct netdev_tc_txq tc =3D dev->tc_to_txq[cl & TC_BITMASK];
=20
-		gnet_stats_basic_packed_init(&bstats);
+		gnet_stats_basic_sync_init(&bstats);
 		/* Drop lock here it will be reclaimed before touching
 		 * statistics this is required because the d->lock we
 		 * hold here is the look on dev_queue->qdisc_sleeping
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index bea68c91027a3..a35200f591a2d 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -131,7 +131,7 @@ struct qfq_class {
=20
 	unsigned int filter_cnt;
=20
-	struct gnet_stats_basic_packed bstats;
+	struct gnet_stats_basic_sync bstats;
 	struct gnet_stats_queue qstats;
 	struct net_rate_estimator __rcu *rate_est;
 	struct Qdisc *qdisc;
@@ -465,7 +465,7 @@ static int qfq_change_class(struct Qdisc *sch, u32 clas=
sid, u32 parentid,
 	if (cl =3D=3D NULL)
 		return -ENOBUFS;
=20
-	gnet_stats_basic_packed_init(&cl->bstats);
+	gnet_stats_basic_sync_init(&cl->bstats);
 	cl->common.classid =3D classid;
 	cl->deficit =3D lmax;
=20
--=20
2.33.0

