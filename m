Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A634259F7
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243422AbhJGRxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:53:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38518 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243388AbhJGRxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 13:53:06 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633629068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xv5MVdotlTKmY5ii8/4CGxbMZHJ1EOvwZ6cVVhxlQxg=;
        b=Fy0oijd5wFoLlD3TSiIf4IcZWkYup5fViSvjdwxQ818WmIWIY10De9I+xtYEemqE65dUAF
        oK01wujjxu+w509eqksizzWWW2gGiIInnzHNdPrG4goqNtylV4Xc1qg+rQZbWeZfF47P1k
        bH13L6XCoNNcD1MrdFYnFUQInoJQVrsMztzg9H+/6oR8SnOSbGtXc3sIilPRD/6jXlREeu
        x6TtaLzUNc+EEofrsD2tnjHb15DW0CCdUIBX7txCTaB+MnN8rw3UFEEofIQLQ3BrGKzZCa
        ZOtlc2Dw67M/swh4sN/e0bhepBIJCOO9J20j6npihkwfOB3K8FtmwKHB/HoWxQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633629068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xv5MVdotlTKmY5ii8/4CGxbMZHJ1EOvwZ6cVVhxlQxg=;
        b=sJQzeu0+b2AORl75b5ZifL8WCEzhTaEIw3LuygHBOlfKIacCLR3J8MoDn5tGWn2ECVcvBf
        KvBxAEsafi3TCXBA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 3/4] gen_stats: Add instead Set the value in __gnet_stats_copy_queue().
Date:   Thu,  7 Oct 2021 19:49:59 +0200
Message-Id: <20211007175000.2334713-4-bigeasy@linutronix.de>
In-Reply-To: <20211007175000.2334713-1-bigeasy@linutronix.de>
References: <20211007175000.2334713-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on review there are five users of __gnet_stats_copy_queue as of
today:
- qdisc_qstats_qlen_backlog(), gnet_stats_copy_queue(),
  memsets() bstats to zero, single invocation.

- mq_dump(), mqprio_dump(), mqprio_dump_class_stats(),
  memsets() bstats to zero, multiple invocation but does not use the
  function due to !qdisc_is_percpu_stats().

It will probably simplify in percpu stats case if the value would be
added and not just stored.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/gen_stats.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index e12e544a7ab0f..76dbae98c83fd 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -312,14 +312,14 @@ void __gnet_stats_copy_queue(struct gnet_stats_queue =
*qstats,
 	if (cpu) {
 		__gnet_stats_copy_queue_cpu(qstats, cpu);
 	} else {
-		qstats->qlen =3D q->qlen;
-		qstats->backlog =3D q->backlog;
-		qstats->drops =3D q->drops;
-		qstats->requeues =3D q->requeues;
-		qstats->overlimits =3D q->overlimits;
+		qstats->qlen +=3D q->qlen;
+		qstats->backlog +=3D q->backlog;
+		qstats->drops +=3D q->drops;
+		qstats->requeues +=3D q->requeues;
+		qstats->overlimits +=3D q->overlimits;
 	}
=20
-	qstats->qlen =3D qlen;
+	qstats->qlen +=3D qlen;
 }
 EXPORT_SYMBOL(__gnet_stats_copy_queue);
=20
--=20
2.33.0

