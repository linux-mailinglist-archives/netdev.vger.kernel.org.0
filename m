Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AED54259F9
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243384AbhJGRxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:53:14 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38530 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243399AbhJGRxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 13:53:06 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633629069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MtuwQ+KIKiQM3yaQjSCUzwcZYRlc2d3zt5xqYnLecpM=;
        b=fEY12/sM7fkkKWyZL21o5bXo1sd1ulKOO4JA3MDd4/uKfMrQIikjUfKgLG9CTovz3OvfUZ
        T5nX1yN8KHkQO6Q3lgNVltPNeSYftIUzfcY5zNxEeDgxAU+t2466vfHS5uWu5QRLnB8lmk
        Q7PpL0LC/96ZQXpg8ZsSvzM7G6DFy6jpaYUS8u1z8hebneTtElcAVFWN7LBCtg5PDjzWAw
        JnunEqASfhe266hG/sdAshm4rTNLVhSEPaoFQ/W+hJwbnBgD5CLGb5bru3dHOLV/6vVPFP
        qLmkaUpsqyZhF+4VP6woe9xeYRFeQc7LuuXL+wWVGepXhsG8S2bP+++jNyPY9A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633629069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MtuwQ+KIKiQM3yaQjSCUzwcZYRlc2d3zt5xqYnLecpM=;
        b=9UNiyPdvvKuTk/i9fgFRnTp7AB73AtGro2IEijXUleLKNrp4u7dNcrfmIQdl5+telz3Cu8
        YyH+ULjUyfBH5qBw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 4/4] mq, mqprio: Simplify stats copy.
Date:   Thu,  7 Oct 2021 19:50:00 +0200
Message-Id: <20211007175000.2334713-5-bigeasy@linutronix.de>
In-Reply-To: <20211007175000.2334713-1-bigeasy@linutronix.de>
References: <20211007175000.2334713-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__gnet_stats_copy_basic() and __gnet_stats_copy_queue() update the
statistics and don't overwritte them for both: global and per-CPU
statistics.

Simplify the code by removing the else case.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

Could someone please double check if the qdisc_qlen_sum() for
!qdisc_is_percpu_stats() is correct here? I would lke not break it again
in another way ;)

 net/sched/sch_mq.c     | 27 ++++++---------------
 net/sched/sch_mqprio.c | 55 +++++++++++++-----------------------------
 2 files changed, 25 insertions(+), 57 deletions(-)

diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index e79f1afe0cfd6..9aa9534f62ff5 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -145,26 +145,15 @@ static int mq_dump(struct Qdisc *sch, struct sk_buff =
*skb)
 		qdisc =3D netdev_get_tx_queue(dev, ntx)->qdisc_sleeping;
 		spin_lock_bh(qdisc_lock(qdisc));
=20
-		if (qdisc_is_percpu_stats(qdisc)) {
-			qlen =3D qdisc_qlen_sum(qdisc);
-			__gnet_stats_copy_basic(NULL, &sch->bstats,
-						qdisc->cpu_bstats,
-						&qdisc->bstats);
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
+		qlen =3D qdisc_qlen_sum(qdisc);
=20
+		__gnet_stats_copy_basic(NULL, &sch->bstats,
+					qdisc->cpu_bstats,
+					&qdisc->bstats);
+		__gnet_stats_copy_queue(&sch->qstats,
+					qdisc->cpu_qstats,
+					&qdisc->qstats, qlen);
+		sch->q.qlen		+=3D qlen;
 		spin_unlock_bh(qdisc_lock(qdisc));
 	}
=20
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 5eb3b1b7ae5e7..8e57c4a3545ee 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -399,28 +399,18 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_b=
uff *skb)
 	 * qdisc totals are added at end.
 	 */
 	for (ntx =3D 0; ntx < dev->num_tx_queues; ntx++) {
+		u32 qlen =3D qdisc_qlen_sum(qdisc);
+
 		qdisc =3D netdev_get_tx_queue(dev, ntx)->qdisc_sleeping;
 		spin_lock_bh(qdisc_lock(qdisc));
=20
-		if (qdisc_is_percpu_stats(qdisc)) {
-			__u32 qlen =3D qdisc_qlen_sum(qdisc);
-
-			__gnet_stats_copy_basic(NULL, &sch->bstats,
-						qdisc->cpu_bstats,
-						&qdisc->bstats);
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
+		__gnet_stats_copy_basic(NULL, &sch->bstats,
+					qdisc->cpu_bstats,
+					&qdisc->bstats);
+		__gnet_stats_copy_queue(&sch->qstats,
+					qdisc->cpu_qstats,
+					&qdisc->qstats, qlen);
+		sch->q.qlen		+=3D qlen;
=20
 		spin_unlock_bh(qdisc_lock(qdisc));
 	}
@@ -532,25 +522,14 @@ static int mqprio_dump_class_stats(struct Qdisc *sch,=
 unsigned long cl,
=20
 			spin_lock_bh(qdisc_lock(qdisc));
=20
-			if (qdisc_is_percpu_stats(qdisc)) {
-				qlen =3D qdisc_qlen_sum(qdisc);
-
-				__gnet_stats_copy_basic(NULL, &bstats,
-							qdisc->cpu_bstats,
-							&qdisc->bstats);
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
+			qlen =3D qdisc_qlen_sum(qdisc);
+			__gnet_stats_copy_basic(NULL, &bstats,
+						qdisc->cpu_bstats,
+						&qdisc->bstats);
+			__gnet_stats_copy_queue(&qstats,
+						qdisc->cpu_qstats,
+						&qdisc->qstats,
+						qlen);
 			spin_unlock_bh(qdisc_lock(qdisc));
 		}
=20
--=20
2.33.0

