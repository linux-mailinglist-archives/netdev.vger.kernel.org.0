Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA52430144
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243887AbhJPIvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243868AbhJPIvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 04:51:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC18C061765;
        Sat, 16 Oct 2021 01:49:22 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634374160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gM2yDvLyY+7aL4gq9i8mFvY0dtpO2LCsdg3qEmboh1I=;
        b=gwGl8xtoaj9f1/PTr+fZp4ve9lsP5WoJ6LcnLXhGG0Rh55YMN78Rzxu96kC4qnJ0N8La7F
        J+OYtPIXpjoqh9gNPzPDw4Jn+9dOlkNAfIroEZjtmi0ALFZjwqj7mumv/ME1r0jlOrsi7f
        ODfX9LOqz2PMlBgK3bWLKdAPJmHlfXUHbGZcmekBbqgiYKDzU0xGAntlqcovoFoMrj+Fgz
        s3M8gv5qY/oaw1nnmqv3c6Oe6mrcZPJJlO8Mk6atZ1CH0fnAJgVwulMzR6vLnjsllbqv61
        BVq9LaHnJ56ykrEE6Q1+tuG2bRXNmkSBMcVnko/BVBhrRThyvfSuW2k7MqHvVw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634374160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gM2yDvLyY+7aL4gq9i8mFvY0dtpO2LCsdg3qEmboh1I=;
        b=Vk2nl3xOOgKp9BOWFvV81QQsra0P9OGOmGbuB5vUPyvk21PHdfLVLplAcGg+zteJDKN3dZ
        prW5vOyZoFRsjnCg==
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
Subject: [PATCH net-next 3/9] mq, mqprio: Use gnet_stats_add_queue().
Date:   Sat, 16 Oct 2021 10:49:04 +0200
Message-Id: <20211016084910.4029084-4-bigeasy@linutronix.de>
In-Reply-To: <20211016084910.4029084-1-bigeasy@linutronix.de>
References: <20211016084910.4029084-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gnet_stats_add_basic() and gnet_stats_add_queue() add up the statistics
so they can be used directly for both the per-CPU and global case.

gnet_stats_add_queue() copies either Qdisc's per-CPU
gnet_stats_queue::qlen or the global member. The global
gnet_stats_queue::qlen isn't touched in the per-CPU case so there is no
need to consider it in the global-case.

In the per-CPU case, the sum of global gnet_stats_queue::qlen and
the per-CPU gnet_stats_queue::qlen was assigned to sch->q.qlen and
sch->qstats.qlen. Now both fields are copied individually.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/sched/sch_mq.c     | 24 +++++----------------
 net/sched/sch_mqprio.c | 49 +++++++++++-------------------------------
 2 files changed, 17 insertions(+), 56 deletions(-)

diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index 1edd98a50e33d..9d58ecb4e80c6 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -130,7 +130,6 @@ static int mq_dump(struct Qdisc *sch, struct sk_buff *s=
kb)
 	struct net_device *dev =3D qdisc_dev(sch);
 	struct Qdisc *qdisc;
 	unsigned int ntx;
-	__u32 qlen =3D 0;
=20
 	sch->q.qlen =3D 0;
 	memset(&sch->bstats, 0, sizeof(sch->bstats));
@@ -145,24 +144,11 @@ static int mq_dump(struct Qdisc *sch, struct sk_buff =
*skb)
 		qdisc =3D netdev_get_tx_queue(dev, ntx)->qdisc_sleeping;
 		spin_lock_bh(qdisc_lock(qdisc));
=20
-		if (qdisc_is_percpu_stats(qdisc)) {
-			qlen =3D qdisc_qlen_sum(qdisc);
-			gnet_stats_add_basic(NULL, &sch->bstats,
-					     qdisc->cpu_bstats, &qdisc->bstats);
-			__gnet_stats_copy_queue(&sch->qstats,
-						qdisc->cpu_qstats,
-						&qdisc->qstats, qlen);
-			sch->q.qlen		+=3D qlen;
-		} else {
-			sch->q.qlen		+=3D qdisc->q.qlen;
-			sch->bstats.bytes	+=3D qdisc->bstats.bytes;
-			sch->bstats.packets	+=3D qdisc->bstats.packets;
-			sch->qstats.qlen	+=3D qdisc->qstats.qlen;
-			sch->qstats.backlog	+=3D qdisc->qstats.backlog;
-			sch->qstats.drops	+=3D qdisc->qstats.drops;
-			sch->qstats.requeues	+=3D qdisc->qstats.requeues;
-			sch->qstats.overlimits	+=3D qdisc->qstats.overlimits;
-		}
+		gnet_stats_add_basic(NULL, &sch->bstats, qdisc->cpu_bstats,
+				     &qdisc->bstats);
+		gnet_stats_add_queue(&sch->qstats, qdisc->cpu_qstats,
+				     &qdisc->qstats);
+		sch->q.qlen +=3D qdisc_qlen(qdisc);
=20
 		spin_unlock_bh(qdisc_lock(qdisc));
 	}
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 4bae601e15e1e..57427b40f0d2e 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -402,24 +402,11 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_b=
uff *skb)
 		qdisc =3D netdev_get_tx_queue(dev, ntx)->qdisc_sleeping;
 		spin_lock_bh(qdisc_lock(qdisc));
=20
-		if (qdisc_is_percpu_stats(qdisc)) {
-			__u32 qlen =3D qdisc_qlen_sum(qdisc);
-
-			gnet_stats_add_basic(NULL, &sch->bstats,
-					     qdisc->cpu_bstats, &qdisc->bstats);
-			__gnet_stats_copy_queue(&sch->qstats,
-						qdisc->cpu_qstats,
-						&qdisc->qstats, qlen);
-			sch->q.qlen		+=3D qlen;
-		} else {
-			sch->q.qlen		+=3D qdisc->q.qlen;
-			sch->bstats.bytes	+=3D qdisc->bstats.bytes;
-			sch->bstats.packets	+=3D qdisc->bstats.packets;
-			sch->qstats.backlog	+=3D qdisc->qstats.backlog;
-			sch->qstats.drops	+=3D qdisc->qstats.drops;
-			sch->qstats.requeues	+=3D qdisc->qstats.requeues;
-			sch->qstats.overlimits	+=3D qdisc->qstats.overlimits;
-		}
+		gnet_stats_add_basic(NULL, &sch->bstats, qdisc->cpu_bstats,
+				     &qdisc->bstats);
+		gnet_stats_add_queue(&sch->qstats, qdisc->cpu_qstats,
+				     &qdisc->qstats);
+		sch->q.qlen +=3D qdisc_qlen(qdisc);
=20
 		spin_unlock_bh(qdisc_lock(qdisc));
 	}
@@ -511,7 +498,7 @@ static int mqprio_dump_class_stats(struct Qdisc *sch, u=
nsigned long cl,
 {
 	if (cl >=3D TC_H_MIN_PRIORITY) {
 		int i;
-		__u32 qlen =3D 0;
+		__u32 qlen;
 		struct gnet_stats_queue qstats =3D {0};
 		struct gnet_stats_basic_packed bstats =3D {0};
 		struct net_device *dev =3D qdisc_dev(sch);
@@ -531,27 +518,15 @@ static int mqprio_dump_class_stats(struct Qdisc *sch,=
 unsigned long cl,
=20
 			spin_lock_bh(qdisc_lock(qdisc));
=20
-			if (qdisc_is_percpu_stats(qdisc)) {
-				qlen =3D qdisc_qlen_sum(qdisc);
+			gnet_stats_add_basic(NULL, &bstats, qdisc->cpu_bstats,
+					     &qdisc->bstats);
+			gnet_stats_add_queue(&qstats, qdisc->cpu_qstats,
+					     &qdisc->qstats);
+			sch->q.qlen +=3D qdisc_qlen(qdisc);
=20
-				gnet_stats_add_basic(NULL, &bstats,
-						     qdisc->cpu_bstats,
-						     &qdisc->bstats);
-				__gnet_stats_copy_queue(&qstats,
-							qdisc->cpu_qstats,
-							&qdisc->qstats,
-							qlen);
-			} else {
-				qlen		+=3D qdisc->q.qlen;
-				bstats.bytes	+=3D qdisc->bstats.bytes;
-				bstats.packets	+=3D qdisc->bstats.packets;
-				qstats.backlog	+=3D qdisc->qstats.backlog;
-				qstats.drops	+=3D qdisc->qstats.drops;
-				qstats.requeues	+=3D qdisc->qstats.requeues;
-				qstats.overlimits +=3D qdisc->qstats.overlimits;
-			}
 			spin_unlock_bh(qdisc_lock(qdisc));
 		}
+		qlen =3D qdisc_qlen(sch) + qstats.qlen;
=20
 		/* Reclaim root sleeping lock before completing stats */
 		if (d->lock)
--=20
2.33.0

