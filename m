Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B55D8AEC
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391521AbfJPI2l convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 04:28:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48958 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfJPI2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 04:28:41 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iKefZ-0000Ib-PI; Wed, 16 Oct 2019 10:28:33 +0200
Date:   Wed, 16 Oct 2019 10:28:33 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>, tglx@linutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v2] net: sched: Avoid using yield() in a busy
 waiting loop
Message-ID: <20191016082833.u4jxbiqg3oo6lyue@linutronix.de>
References: <20191011171526.fon5npsxnarpn3qp@linutronix.de>
 <8c3fad79-369a-403d-89fd-e54ab1b03643@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <8c3fad79-369a-403d-89fd-e54ab1b03643@cogentembedded.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

With threaded interrupts enabled, the interrupt thread runs as SCHED_RR
with priority 50. If a user application with a higher priority preempts
the interrupt thread and tries to shutdown the network interface then it
will loop forever. The kernel will spin in the loop waiting for the
device to become idle and the scheduler will never consider the
interrupt thread because its priority is lower.

Avoid the problem by sleeping for a jiffy giving other tasks,
including the interrupt thread, a chance to run and make progress.

In the original thread it has been suggested to use wait_event() and
properly waiting for the state to occur. DaveM explained that this would
require to add expensive checks in the fast paths of packet processing.

Link: https://lkml.kernel.org/r/1393976987-23555-1-git-send-email-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[bigeasy: Rewrite commit message, add comment, use
          schedule_timeout_uninterruptible()]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1…v2: Typo fixes, noticed by Sergei Shtylyov.

 net/sched/sch_generic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 17bd8f539bc7f..974731b86c20c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1217,8 +1217,13 @@ void dev_deactivate_many(struct list_head *head)
 
 	/* Wait for outstanding qdisc_run calls. */
 	list_for_each_entry(dev, head, close_list) {
-		while (some_qdisc_is_busy(dev))
-			yield();
+		while (some_qdisc_is_busy(dev)) {
+			/* wait_event() would avoid this sleep-loop but would
+			 * require expensive checks in the fast paths of packet
+			 * processing which isn't worth it.
+			 */
+			schedule_timeout_uninterruptible(1);
+		}
 		/* The new qdisc is assigned at this point so we can safely
 		 * unwind stale skb lists and qdisc statistics
 		 */
-- 
2.23.0
