Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D21B430141
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243880AbhJPIve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243825AbhJPIvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 04:51:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1152DC061570;
        Sat, 16 Oct 2021 01:49:22 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634374159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Q0bVpbX17OLdHyPrhzbxnObPavmd0MWrhQ3Zge4Hp8=;
        b=sguNbqmA2P1esprXSkiaiquwPgJlMpqrtqwwXYRWTUVOyicBSvYr/HWkR+AH+WeeVxKcJG
        zNd34YbMs2NsMSh4+8mGF83vUFxCZhkbjjBXVdWcdWgRJJVVjdXy6vOfPZKxoqe06fiM8q
        5AXirjqvQvSgAX3IYkla8VDjQaHPP+iP3QpBv+YW5B18EhUWHyDod3ixCtx0ff+m6t3WWJ
        0jokE2pU6tyxKqM7FR1PaZJ7VPphv1Nc2M4nc3We4syUDZHyODsJ5pvnf4JM2uXNT0vPIZ
        zg3RUjGLGL8AY0/MZVWTX/RyGiMpvlXEQjwIOfYH37rctkyV14tzvVc4botW2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634374159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Q0bVpbX17OLdHyPrhzbxnObPavmd0MWrhQ3Zge4Hp8=;
        b=l5LbKb+GlkE5r8sPUnroOB/WPpsTd3JCL1z8Dy4FY7CH0wMwtpaNi1Y903bQ1TD9s3tOS3
        0hUvFqwaQK1YhfBQ==
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
Subject: [PATCH net-next 1/9] gen_stats: Add instead Set the value in __gnet_stats_copy_basic().
Date:   Sat, 16 Oct 2021 10:49:02 +0200
Message-Id: <20211016084910.4029084-2-bigeasy@linutronix.de>
In-Reply-To: <20211016084910.4029084-1-bigeasy@linutronix.de>
References: <20211016084910.4029084-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__gnet_stats_copy_basic() always assigns the value to the bstats
argument overwriting the previous value. The later added per-CPU version
always accumulated the values in the returning gnet_stats_basic_packed
argument.

Based on review there are five users of that function as of today:
- est_fetch_counters(), ___gnet_stats_copy_basic()
  memsets() bstats to zero, single invocation.

- mq_dump(), mqprio_dump(), mqprio_dump_class_stats()
  memsets() bstats to zero, multiple invocation but does not use the
  function due to !qdisc_is_percpu_stats().

Add the values in __gnet_stats_copy_basic() instead overwriting. Rename
the function to gnet_stats_add_basic() to make it more obvious.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/net/gen_stats.h  |  8 ++++----
 net/core/gen_estimator.c |  2 +-
 net/core/gen_stats.c     | 29 ++++++++++++++++-------------
 net/sched/sch_mq.c       |  5 ++---
 net/sched/sch_mqprio.c   | 11 +++++------
 5 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/include/net/gen_stats.h b/include/net/gen_stats.h
index 1424e02cef90c..25740d004bdb0 100644
--- a/include/net/gen_stats.h
+++ b/include/net/gen_stats.h
@@ -46,10 +46,10 @@ int gnet_stats_copy_basic(const seqcount_t *running,
 			  struct gnet_dump *d,
 			  struct gnet_stats_basic_cpu __percpu *cpu,
 			  struct gnet_stats_basic_packed *b);
-void __gnet_stats_copy_basic(const seqcount_t *running,
-			     struct gnet_stats_basic_packed *bstats,
-			     struct gnet_stats_basic_cpu __percpu *cpu,
-			     struct gnet_stats_basic_packed *b);
+void gnet_stats_add_basic(const seqcount_t *running,
+			  struct gnet_stats_basic_packed *bstats,
+			  struct gnet_stats_basic_cpu __percpu *cpu,
+			  struct gnet_stats_basic_packed *b);
 int gnet_stats_copy_basic_hw(const seqcount_t *running,
 			     struct gnet_dump *d,
 			     struct gnet_stats_basic_cpu __percpu *cpu,
diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 8e582e29a41e3..205df8b5116e5 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -66,7 +66,7 @@ static void est_fetch_counters(struct net_rate_estimator =
*e,
 	if (e->stats_lock)
 		spin_lock(e->stats_lock);
=20
-	__gnet_stats_copy_basic(e->running, b, e->cpu_bstats, e->bstats);
+	gnet_stats_add_basic(e->running, b, e->cpu_bstats, e->bstats);
=20
 	if (e->stats_lock)
 		spin_unlock(e->stats_lock);
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index e491b083b3485..25d7c0989b83f 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -114,9 +114,8 @@ gnet_stats_start_copy(struct sk_buff *skb, int type, sp=
inlock_t *lock,
 }
 EXPORT_SYMBOL(gnet_stats_start_copy);
=20
-static void
-__gnet_stats_copy_basic_cpu(struct gnet_stats_basic_packed *bstats,
-			    struct gnet_stats_basic_cpu __percpu *cpu)
+static void gnet_stats_add_basic_cpu(struct gnet_stats_basic_packed *bstat=
s,
+				     struct gnet_stats_basic_cpu __percpu *cpu)
 {
 	int i;
=20
@@ -136,26 +135,30 @@ __gnet_stats_copy_basic_cpu(struct gnet_stats_basic_p=
acked *bstats,
 	}
 }
=20
-void
-__gnet_stats_copy_basic(const seqcount_t *running,
-			struct gnet_stats_basic_packed *bstats,
-			struct gnet_stats_basic_cpu __percpu *cpu,
-			struct gnet_stats_basic_packed *b)
+void gnet_stats_add_basic(const seqcount_t *running,
+			  struct gnet_stats_basic_packed *bstats,
+			  struct gnet_stats_basic_cpu __percpu *cpu,
+			  struct gnet_stats_basic_packed *b)
 {
 	unsigned int seq;
+	u64 bytes =3D 0;
+	u64 packets =3D 0;
=20
 	if (cpu) {
-		__gnet_stats_copy_basic_cpu(bstats, cpu);
+		gnet_stats_add_basic_cpu(bstats, cpu);
 		return;
 	}
 	do {
 		if (running)
 			seq =3D read_seqcount_begin(running);
-		bstats->bytes =3D b->bytes;
-		bstats->packets =3D b->packets;
+		bytes =3D b->bytes;
+		packets =3D b->packets;
 	} while (running && read_seqcount_retry(running, seq));
+
+	bstats->bytes +=3D bytes;
+	bstats->packets +=3D packets;
 }
-EXPORT_SYMBOL(__gnet_stats_copy_basic);
+EXPORT_SYMBOL(gnet_stats_add_basic);
=20
 static int
 ___gnet_stats_copy_basic(const seqcount_t *running,
@@ -166,7 +169,7 @@ ___gnet_stats_copy_basic(const seqcount_t *running,
 {
 	struct gnet_stats_basic_packed bstats =3D {0};
=20
-	__gnet_stats_copy_basic(running, &bstats, cpu, b);
+	gnet_stats_add_basic(running, &bstats, cpu, b);
=20
 	if (d->compat_tc_stats && type =3D=3D TCA_STATS_BASIC) {
 		d->tc_stats.bytes =3D bstats.bytes;
diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index e04f1a87642b9..1edd98a50e33d 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -147,9 +147,8 @@ static int mq_dump(struct Qdisc *sch, struct sk_buff *s=
kb)
=20
 		if (qdisc_is_percpu_stats(qdisc)) {
 			qlen =3D qdisc_qlen_sum(qdisc);
-			__gnet_stats_copy_basic(NULL, &sch->bstats,
-						qdisc->cpu_bstats,
-						&qdisc->bstats);
+			gnet_stats_add_basic(NULL, &sch->bstats,
+					     qdisc->cpu_bstats, &qdisc->bstats);
 			__gnet_stats_copy_queue(&sch->qstats,
 						qdisc->cpu_qstats,
 						&qdisc->qstats, qlen);
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index e1904e62425e5..4bae601e15e1e 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -405,9 +405,8 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buf=
f *skb)
 		if (qdisc_is_percpu_stats(qdisc)) {
 			__u32 qlen =3D qdisc_qlen_sum(qdisc);
=20
-			__gnet_stats_copy_basic(NULL, &sch->bstats,
-						qdisc->cpu_bstats,
-						&qdisc->bstats);
+			gnet_stats_add_basic(NULL, &sch->bstats,
+					     qdisc->cpu_bstats, &qdisc->bstats);
 			__gnet_stats_copy_queue(&sch->qstats,
 						qdisc->cpu_qstats,
 						&qdisc->qstats, qlen);
@@ -535,9 +534,9 @@ static int mqprio_dump_class_stats(struct Qdisc *sch, u=
nsigned long cl,
 			if (qdisc_is_percpu_stats(qdisc)) {
 				qlen =3D qdisc_qlen_sum(qdisc);
=20
-				__gnet_stats_copy_basic(NULL, &bstats,
-							qdisc->cpu_bstats,
-							&qdisc->bstats);
+				gnet_stats_add_basic(NULL, &bstats,
+						     qdisc->cpu_bstats,
+						     &qdisc->bstats);
 				__gnet_stats_copy_queue(&qstats,
 							qdisc->cpu_qstats,
 							&qdisc->qstats,
--=20
2.33.0

