Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA8B43013F
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243871AbhJPIve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243869AbhJPIvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 04:51:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DBBC061764;
        Sat, 16 Oct 2021 01:49:22 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634374161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nylge2ysyawK3RZDKJCu6TFbxbyYVgjE3PFOak94j4Q=;
        b=BCK3T2Jtg3Lrc+hr1XSFHr033ATYVbWZbP4Jl28H54WmT3m90dcYJu95T6R41cZebpvhSw
        vpTLMRx45M1WmFfSTg6xFJfoxuGWE0YGFYuKOSii6lrJY8JlEGiiC/FyJfoSblTwCb2G70
        RAbIOR+8Cadmaz08mZ1eHu4Qc1lC3FZTZhSHnEQpnQAij5MCex5FqPb4ibLvwDsogui62n
        N/nsDRrc1DVDYSZJeLL59c0Bp579qz6bvRuT7EWzXNOvo5FtRJYsoXkXt/gMEAQdbsumLl
        qrY0Iv9C2fDlbdMlDEMiJDqpncHVQkxrTSJ3Uh/0SAYdn1oa1AjZcmJQmlADSQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634374161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nylge2ysyawK3RZDKJCu6TFbxbyYVgjE3PFOak94j4Q=;
        b=3F5nOFB87eMZ2dsQr+9wCEd4Pn/3pDFLHZs4FL2x8e9e6EDzeGkuULQ8kZBSqBctNCL4LR
        wgrR93yIGEgiPSBQ==
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
Subject: [PATCH net-next 4/9] gen_stats: Move remaining users to gnet_stats_add_queue().
Date:   Sat, 16 Oct 2021 10:49:05 +0200
Message-Id: <20211016084910.4029084-5-bigeasy@linutronix.de>
In-Reply-To: <20211016084910.4029084-1-bigeasy@linutronix.de>
References: <20211016084910.4029084-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The gnet_stats_queue::qlen member is only used in the SMP-case.

qdisc_qstats_qlen_backlog() needs to add qdisc_qlen() to qstats.qlen to
have the same value as that provided by qdisc_qlen_sum().

gnet_stats_copy_queue() needs to overwritte the resulting qstats.qlen
field whith the caller submitted qlen value. It might be differ from the
submitted value.

Let both functions use gnet_stats_add_queue() and remove unused
__gnet_stats_copy_queue().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/net/gen_stats.h   |  3 ---
 include/net/sch_generic.h |  5 ++---
 net/core/gen_stats.c      | 39 ++-------------------------------------
 3 files changed, 4 insertions(+), 43 deletions(-)

diff --git a/include/net/gen_stats.h b/include/net/gen_stats.h
index 148f0ba85f25a..d47155f5db5d7 100644
--- a/include/net/gen_stats.h
+++ b/include/net/gen_stats.h
@@ -59,9 +59,6 @@ int gnet_stats_copy_rate_est(struct gnet_dump *d,
 int gnet_stats_copy_queue(struct gnet_dump *d,
 			  struct gnet_stats_queue __percpu *cpu_q,
 			  struct gnet_stats_queue *q, __u32 qlen);
-void __gnet_stats_copy_queue(struct gnet_stats_queue *qstats,
-			     const struct gnet_stats_queue __percpu *cpu_q,
-			     const struct gnet_stats_queue *q, __u32 qlen);
 void gnet_stats_add_queue(struct gnet_stats_queue *qstats,
 			  const struct gnet_stats_queue __percpu *cpu_q,
 			  const struct gnet_stats_queue *q);
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 5a011f8d394ea..7bc2d30b5c067 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -972,10 +972,9 @@ static inline void qdisc_qstats_qlen_backlog(struct Qd=
isc *sch,  __u32 *qlen,
 					     __u32 *backlog)
 {
 	struct gnet_stats_queue qstats =3D { 0 };
-	__u32 len =3D qdisc_qlen_sum(sch);
=20
-	__gnet_stats_copy_queue(&qstats, sch->cpu_qstats, &sch->qstats, len);
-	*qlen =3D qstats.qlen;
+	gnet_stats_add_queue(&qstats, sch->cpu_qstats, &sch->qstats);
+	*qlen =3D qstats.qlen + qdisc_qlen(sch);
 	*backlog =3D qstats.backlog;
 }
=20
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 26c020a7ead49..6ec11289140b6 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -285,42 +285,6 @@ gnet_stats_copy_rate_est(struct gnet_dump *d,
 }
 EXPORT_SYMBOL(gnet_stats_copy_rate_est);
=20
-static void
-__gnet_stats_copy_queue_cpu(struct gnet_stats_queue *qstats,
-			    const struct gnet_stats_queue __percpu *q)
-{
-	int i;
-
-	for_each_possible_cpu(i) {
-		const struct gnet_stats_queue *qcpu =3D per_cpu_ptr(q, i);
-
-		qstats->qlen =3D 0;
-		qstats->backlog +=3D qcpu->backlog;
-		qstats->drops +=3D qcpu->drops;
-		qstats->requeues +=3D qcpu->requeues;
-		qstats->overlimits +=3D qcpu->overlimits;
-	}
-}
-
-void __gnet_stats_copy_queue(struct gnet_stats_queue *qstats,
-			     const struct gnet_stats_queue __percpu *cpu,
-			     const struct gnet_stats_queue *q,
-			     __u32 qlen)
-{
-	if (cpu) {
-		__gnet_stats_copy_queue_cpu(qstats, cpu);
-	} else {
-		qstats->qlen =3D q->qlen;
-		qstats->backlog =3D q->backlog;
-		qstats->drops =3D q->drops;
-		qstats->requeues =3D q->requeues;
-		qstats->overlimits =3D q->overlimits;
-	}
-
-	qstats->qlen =3D qlen;
-}
-EXPORT_SYMBOL(__gnet_stats_copy_queue);
-
 static void gnet_stats_add_queue_cpu(struct gnet_stats_queue *qstats,
 				     const struct gnet_stats_queue __percpu *q)
 {
@@ -374,7 +338,8 @@ gnet_stats_copy_queue(struct gnet_dump *d,
 {
 	struct gnet_stats_queue qstats =3D {0};
=20
-	__gnet_stats_copy_queue(&qstats, cpu_q, q, qlen);
+	gnet_stats_add_queue(&qstats, cpu_q, q);
+	qstats.qlen =3D qlen;
=20
 	if (d->compat_tc_stats) {
 		d->tc_stats.drops =3D qstats.drops;
--=20
2.33.0

