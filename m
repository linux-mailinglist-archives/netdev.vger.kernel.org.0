Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC9E430148
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243897AbhJPIvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:51:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55186 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243867AbhJPIvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 04:51:31 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634374162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VUbfkNXsieoAqWnFCwB3z3p+DJoZFbJHRG7sYr024AE=;
        b=zG/BDqzOeFlcVFWpSmJ341c8LEmYu2mkeYyE0dIXiR4URz/KHW7m/6lAhi6HA5QPeMYINs
        c9Cf0WhaMSU2xrAfslVKZomUcx5bGErGIMuJEFAPbTaM3jQf452QSfWVN/ey+pdhEVseQ6
        GjbdOQob2UwZGoktEKXto95pWuLeykvvXr+WJfQ9g0FtRgkTDXfMerkIVxPDWMS8Wnncjm
        HFBQKp4CuwwO81oJfq3tgOWsPrGTxuXT/qI2wMCmsGaVqomEleZ/YlhTRduETsdulRhl7x
        1oUFFgyQnSnYupC8xyWuqpmn8KzZ5qCQjLcz9/dpHJNjF81eAOYbCyJ4xXK8QA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634374162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VUbfkNXsieoAqWnFCwB3z3p+DJoZFbJHRG7sYr024AE=;
        b=x7AttUzf2MqgOGC2EmiRFgIPNTojCQuQ/Yn6IDc7T/rU5fRJa+SrTy1zsEXqTLbsTuy138
        rarR1De0t01XLcCg==
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
Subject: [PATCH net-next 7/9] net: sched: Use _bstats_update/set() instead of raw writes
Date:   Sat, 16 Oct 2021 10:49:08 +0200
Message-Id: <20211016084910.4029084-8-bigeasy@linutronix.de>
In-Reply-To: <20211016084910.4029084-1-bigeasy@linutronix.de>
References: <20211016084910.4029084-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

The Qdisc::running sequence counter, used to protect Qdisc::bstats reads
from parallel writes, is in the process of being removed. Qdisc::bstats
read/writes will synchronize using an internal u64_stats sync point
instead.

Modify all bstats writes to use _bstats_update(). This ensures that
the internal u64_stats sync point is always acquired and released as
appropriate.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/gen_stats.c |  9 +++++----
 net/sched/sch_cbq.c  |  3 +--
 net/sched/sch_gred.c |  7 ++++---
 net/sched/sch_htb.c  | 25 +++++++++++++++----------
 net/sched/sch_qfq.c  |  3 +--
 5 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index f2e12fe7112b1..69576972a25f0 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -126,6 +126,7 @@ EXPORT_SYMBOL(gnet_stats_basic_packed_init);
 static void gnet_stats_add_basic_cpu(struct gnet_stats_basic_packed *bstat=
s,
 				     struct gnet_stats_basic_cpu __percpu *cpu)
 {
+	u64 t_bytes =3D 0, t_packets =3D 0;
 	int i;
=20
 	for_each_possible_cpu(i) {
@@ -139,9 +140,10 @@ static void gnet_stats_add_basic_cpu(struct gnet_stats=
_basic_packed *bstats,
 			packets =3D bcpu->bstats.packets;
 		} while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));
=20
-		bstats->bytes +=3D bytes;
-		bstats->packets +=3D packets;
+		t_bytes +=3D bytes;
+		t_packets +=3D packets;
 	}
+	_bstats_update(bstats, t_bytes, t_packets);
 }
=20
 void gnet_stats_add_basic(const seqcount_t *running,
@@ -164,8 +166,7 @@ void gnet_stats_add_basic(const seqcount_t *running,
 		packets =3D b->packets;
 	} while (running && read_seqcount_retry(running, seq));
=20
-	bstats->bytes +=3D bytes;
-	bstats->packets +=3D packets;
+	_bstats_update(bstats, bytes, packets);
 }
 EXPORT_SYMBOL(gnet_stats_add_basic);
=20
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index d01f6ec315f87..ef9e87175d35c 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -565,8 +565,7 @@ cbq_update(struct cbq_sched_data *q)
 		long avgidle =3D cl->avgidle;
 		long idle;
=20
-		cl->bstats.packets++;
-		cl->bstats.bytes +=3D len;
+		_bstats_update(&cl->bstats, len, 1);
=20
 		/*
 		 * (now - last) is total time between packet right edges.
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 2ddcbb2efdbbc..02b03d6d24ea4 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -353,6 +353,7 @@ static int gred_offload_dump_stats(struct Qdisc *sch)
 {
 	struct gred_sched *table =3D qdisc_priv(sch);
 	struct tc_gred_qopt_offload *hw_stats;
+	u64 bytes =3D 0, packets =3D 0;
 	unsigned int i;
 	int ret;
=20
@@ -381,15 +382,15 @@ static int gred_offload_dump_stats(struct Qdisc *sch)
 		table->tab[i]->bytesin +=3D hw_stats->stats.bstats[i].bytes;
 		table->tab[i]->backlog +=3D hw_stats->stats.qstats[i].backlog;
=20
-		_bstats_update(&sch->bstats,
-			       hw_stats->stats.bstats[i].bytes,
-			       hw_stats->stats.bstats[i].packets);
+		bytes +=3D hw_stats->stats.bstats[i].bytes;
+		packets +=3D hw_stats->stats.bstats[i].packets;
 		sch->qstats.qlen +=3D hw_stats->stats.qstats[i].qlen;
 		sch->qstats.backlog +=3D hw_stats->stats.qstats[i].backlog;
 		sch->qstats.drops +=3D hw_stats->stats.qstats[i].drops;
 		sch->qstats.requeues +=3D hw_stats->stats.qstats[i].requeues;
 		sch->qstats.overlimits +=3D hw_stats->stats.qstats[i].overlimits;
 	}
+	_bstats_update(&sch->bstats, bytes, packets);
=20
 	kfree(hw_stats);
 	return ret;
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 2e805b17efcf9..324ecfdf842a3 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1308,6 +1308,7 @@ static int htb_dump_class(struct Qdisc *sch, unsigned=
 long arg,
 static void htb_offload_aggregate_stats(struct htb_sched *q,
 					struct htb_class *cl)
 {
+	u64 bytes =3D 0, packets =3D 0;
 	struct htb_class *c;
 	unsigned int i;
=20
@@ -1323,14 +1324,15 @@ static void htb_offload_aggregate_stats(struct htb_=
sched *q,
 			if (p !=3D cl)
 				continue;
=20
-			cl->bstats.bytes +=3D c->bstats_bias.bytes;
-			cl->bstats.packets +=3D c->bstats_bias.packets;
+			bytes +=3D c->bstats_bias.bytes;
+			packets +=3D c->bstats_bias.packets;
 			if (c->level =3D=3D 0) {
-				cl->bstats.bytes +=3D c->leaf.q->bstats.bytes;
-				cl->bstats.packets +=3D c->leaf.q->bstats.packets;
+				bytes +=3D c->leaf.q->bstats.bytes;
+				packets +=3D c->leaf.q->bstats.packets;
 			}
 		}
 	}
+	_bstats_update(&cl->bstats, bytes, packets);
 }
=20
 static int
@@ -1358,8 +1360,9 @@ htb_dump_class_stats(struct Qdisc *sch, unsigned long=
 arg, struct gnet_dump *d)
 				cl->bstats =3D cl->leaf.q->bstats;
 			else
 				gnet_stats_basic_packed_init(&cl->bstats);
-			cl->bstats.bytes +=3D cl->bstats_bias.bytes;
-			cl->bstats.packets +=3D cl->bstats_bias.packets;
+			_bstats_update(&cl->bstats,
+				       cl->bstats_bias.bytes,
+				       cl->bstats_bias.packets);
 		} else {
 			htb_offload_aggregate_stats(q, cl);
 		}
@@ -1578,8 +1581,9 @@ static int htb_destroy_class_offload(struct Qdisc *sc=
h, struct htb_class *cl,
 		WARN_ON(old !=3D q);
=20
 	if (cl->parent) {
-		cl->parent->bstats_bias.bytes +=3D q->bstats.bytes;
-		cl->parent->bstats_bias.packets +=3D q->bstats.packets;
+		_bstats_update(&cl->parent->bstats_bias,
+			       q->bstats.bytes,
+			       q->bstats.packets);
 	}
=20
 	offload_opt =3D (struct tc_htb_qopt_offload) {
@@ -1925,8 +1929,9 @@ static int htb_change_class(struct Qdisc *sch, u32 cl=
assid,
 				htb_graft_helper(dev_queue, old_q);
 				goto err_kill_estimator;
 			}
-			parent->bstats_bias.bytes +=3D old_q->bstats.bytes;
-			parent->bstats_bias.packets +=3D old_q->bstats.packets;
+			_bstats_update(&parent->bstats_bias,
+				       old_q->bstats.bytes,
+				       old_q->bstats.packets);
 			qdisc_put(old_q);
 		}
 		new_q =3D qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index b6d989b69324d..bea68c91027a3 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1235,8 +1235,7 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qd=
isc *sch,
 		return err;
 	}
=20
-	cl->bstats.bytes +=3D len;
-	cl->bstats.packets +=3D gso_segs;
+	_bstats_update(&cl->bstats, len, gso_segs);
 	sch->qstats.backlog +=3D len;
 	++sch->q.qlen;
=20
--=20
2.33.0

