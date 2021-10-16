Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C95943013D
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243876AbhJPIvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:51:33 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55088 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239889AbhJPIv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 04:51:29 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634374160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yT4LQKypoYY1sKemdKiMLaN9Yxk5PY1d95laAk6+74s=;
        b=Nu5M/lYslGw85Rlp494Tt9RkoyPGRMu9cDop2q1Tyu6j1Cq+LWe7CnPr6det+3QQ0eU9yr
        Y/pUZ4wnG8PQVgrE825N3bTvvJzPe7rzP1Q5iRATNXRhWYIhARsMxtAdPLAhxNt1amwlmM
        399Acv6vyjOHAYfDD18rB6H96QTl3iJWBUL/d45a7dyp/Qk3cYykef4VS6Jbb5tsRPpEMi
        y/tF7RpZRmpttO1uARXmEs0uQOMjnpnbPp7a/+tFoL47ymg0ntZcEqwMYbG6bB3QcC5UHN
        JnxZuIlRUjdeQ0XEX6+9aTELkVQpOT01VsZdwLRhiHE9y35sU9V+ni87+0Lgrw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634374160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yT4LQKypoYY1sKemdKiMLaN9Yxk5PY1d95laAk6+74s=;
        b=KvhTIr4+QrrRqMSqTwhLHGzEATCgIXRAze5TwSIaaTnO826tvg3n/k4BhcSdZjFalI/Ogi
        fwI7jsqnunEtcJBw==
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
Subject: [PATCH net-next 2/9] gen_stats: Add gnet_stats_add_queue().
Date:   Sat, 16 Oct 2021 10:49:03 +0200
Message-Id: <20211016084910.4029084-3-bigeasy@linutronix.de>
In-Reply-To: <20211016084910.4029084-1-bigeasy@linutronix.de>
References: <20211016084910.4029084-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function will replace __gnet_stats_copy_queue(). It reads all
arguments and adds them into the passed gnet_stats_queue argument.
In contrast to __gnet_stats_copy_queue() it also copies the qlen member.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/net/gen_stats.h |  3 +++
 net/core/gen_stats.c    | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/net/gen_stats.h b/include/net/gen_stats.h
index 25740d004bdb0..148f0ba85f25a 100644
--- a/include/net/gen_stats.h
+++ b/include/net/gen_stats.h
@@ -62,6 +62,9 @@ int gnet_stats_copy_queue(struct gnet_dump *d,
 void __gnet_stats_copy_queue(struct gnet_stats_queue *qstats,
 			     const struct gnet_stats_queue __percpu *cpu_q,
 			     const struct gnet_stats_queue *q, __u32 qlen);
+void gnet_stats_add_queue(struct gnet_stats_queue *qstats,
+			  const struct gnet_stats_queue __percpu *cpu_q,
+			  const struct gnet_stats_queue *q);
 int gnet_stats_copy_app(struct gnet_dump *d, void *st, int len);
=20
 int gnet_stats_finish_copy(struct gnet_dump *d);
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 25d7c0989b83f..26c020a7ead49 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -321,6 +321,38 @@ void __gnet_stats_copy_queue(struct gnet_stats_queue *=
qstats,
 }
 EXPORT_SYMBOL(__gnet_stats_copy_queue);
=20
+static void gnet_stats_add_queue_cpu(struct gnet_stats_queue *qstats,
+				     const struct gnet_stats_queue __percpu *q)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		const struct gnet_stats_queue *qcpu =3D per_cpu_ptr(q, i);
+
+		qstats->qlen +=3D qcpu->backlog;
+		qstats->backlog +=3D qcpu->backlog;
+		qstats->drops +=3D qcpu->drops;
+		qstats->requeues +=3D qcpu->requeues;
+		qstats->overlimits +=3D qcpu->overlimits;
+	}
+}
+
+void gnet_stats_add_queue(struct gnet_stats_queue *qstats,
+			  const struct gnet_stats_queue __percpu *cpu,
+			  const struct gnet_stats_queue *q)
+{
+	if (cpu) {
+		gnet_stats_add_queue_cpu(qstats, cpu);
+	} else {
+		qstats->qlen +=3D q->qlen;
+		qstats->backlog +=3D q->backlog;
+		qstats->drops +=3D q->drops;
+		qstats->requeues +=3D q->requeues;
+		qstats->overlimits +=3D q->overlimits;
+	}
+}
+EXPORT_SYMBOL(gnet_stats_add_queue);
+
 /**
  * gnet_stats_copy_queue - copy queue statistics into statistics TLV
  * @d: dumping handle
--=20
2.33.0

