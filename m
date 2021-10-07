Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D224259F5
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243382AbhJGRxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:53:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38494 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243381AbhJGRxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 13:53:06 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633629067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GqAcs6fZNMpt3K2p53zBaOxfCsVsSpzSeje3PIrdYVA=;
        b=U5YGeTkq/3C4SEr5GYJNYV7UArfEoPOIA8cn8MrYw/qYcfVXK08rdaLuiYi8e0Dm3bd7Qu
        QJRHB0C/P5QGqijTjsSJqadvHYRCzW0SwsifopWqW2hVqp/MS9bg4W2sbJ87N7iedaDu4I
        TZztKYWEv4LzWQexFTHliiAKk46nXbbqy8ZRGqFkkx52/NDMUGdic2qO0gjmdlG+62l5Xv
        r6K8PXkh1XiZZc5tPR9fcDLcaPZUu/gOkIcO3jVt/i1ZXh9ma1wYlHJEucgaOKguK4/CJ7
        poLjXEQyk+4usjNd91ItpvqOdGdz293p/aAlpJ++UFpaSZNFOE+wj+sSJBeXgg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633629067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GqAcs6fZNMpt3K2p53zBaOxfCsVsSpzSeje3PIrdYVA=;
        b=RwUQzf70LVcek1YhHvyR0OhmykbexBKB2o4agrrjM7UYISLKIBVDiQ+bvCtgIwQibSHUKl
        OXD2JLVuqxU30eAA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net 1/4] mqprio: Correct stats in mqprio_dump_class_stats().
Date:   Thu,  7 Oct 2021 19:49:57 +0200
Message-Id: <20211007175000.2334713-2-bigeasy@linutronix.de>
In-Reply-To: <20211007175000.2334713-1-bigeasy@linutronix.de>
References: <20211007175000.2334713-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks like with the introduction of subqueus the statics broke.
Before the change `bstats' and `qstats' on stack was fed and later this
was copied over to struct gnet_dump.

After the change the `bstats' and `qstats' are only set to 0 and no
longer updated and that is then fed to gnet_dump. Additionally
qdisc->cpu_bstats and qdisc->cpu_qstats is destroeyd for global
stats. For per-CPU stats both __gnet_stats_copy_basic() and
__gnet_stats_copy_queue() add the values but for global stats the value
set and so the previous value is lost and only the last value from the
loop ends up in sch->[bq]stats.

Use the on-stack [bq]stats variables again and add the stats manually in
the global case.

Fixes: ce679e8df7ed2 ("net: sched: add support for TCQ_F_NOLOCK subqueues t=
o sch_mqprio")
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/sched/sch_mqprio.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 8766ab5b87880..5eb3b1b7ae5e7 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -529,22 +529,28 @@ static int mqprio_dump_class_stats(struct Qdisc *sch,=
 unsigned long cl,
 		for (i =3D tc.offset; i < tc.offset + tc.count; i++) {
 			struct netdev_queue *q =3D netdev_get_tx_queue(dev, i);
 			struct Qdisc *qdisc =3D rtnl_dereference(q->qdisc);
-			struct gnet_stats_basic_cpu __percpu *cpu_bstats =3D NULL;
-			struct gnet_stats_queue __percpu *cpu_qstats =3D NULL;
=20
 			spin_lock_bh(qdisc_lock(qdisc));
-			if (qdisc_is_percpu_stats(qdisc)) {
-				cpu_bstats =3D qdisc->cpu_bstats;
-				cpu_qstats =3D qdisc->cpu_qstats;
-			}
=20
-			qlen =3D qdisc_qlen_sum(qdisc);
-			__gnet_stats_copy_basic(NULL, &sch->bstats,
-						cpu_bstats, &qdisc->bstats);
-			__gnet_stats_copy_queue(&sch->qstats,
-						cpu_qstats,
-						&qdisc->qstats,
-						qlen);
+			if (qdisc_is_percpu_stats(qdisc)) {
+				qlen =3D qdisc_qlen_sum(qdisc);
+
+				__gnet_stats_copy_basic(NULL, &bstats,
+							qdisc->cpu_bstats,
+							&qdisc->bstats);
+				__gnet_stats_copy_queue(&qstats,
+							qdisc->cpu_qstats,
+							&qdisc->qstats,
+							qlen);
+			} else {
+				qlen		+=3D qdisc->q.qlen;
+				bstats.bytes	+=3D qdisc->bstats.bytes;
+				bstats.packets	+=3D qdisc->bstats.packets;
+				qstats.backlog	+=3D qdisc->qstats.backlog;
+				qstats.drops	+=3D qdisc->qstats.drops;
+				qstats.requeues	+=3D qdisc->qstats.requeues;
+				qstats.overlimits +=3D qdisc->qstats.overlimits;
+			}
 			spin_unlock_bh(qdisc_lock(qdisc));
 		}
=20
--=20
2.33.0

