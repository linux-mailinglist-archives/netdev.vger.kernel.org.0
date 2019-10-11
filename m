Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B686ED4660
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbfJKRPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:15:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33381 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbfJKRPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 13:15:32 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iIyVj-0007Wx-0B; Fri, 11 Oct 2019 19:15:27 +0200
Date:   Fri, 11 Oct 2019 19:15:26 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>, tglx@linutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] net: sched: Avoid using yield() in a busy waiting
 loop
Message-ID: <20191011171526.fon5npsxnarpn3qp@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: NeoMutt/20180716
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

Avoid the problem by using by sleeping for a jiffy giving other tasks,
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

The old thread also pointed anoth yield() loop which was resolved by
commit
   845704a535e9b ("tcp: avoid looping in tcp_send_fin()")

 net/sched/sch_generic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 17bd8f539bc7f..b27574f2c6b47 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1217,8 +1217,13 @@ void dev_deactivate_many(struct list_head *head)
 
 	/* Wait for outstanding qdisc_run calls. */
 	list_for_each_entry(dev, head, close_list) {
-		while (some_qdisc_is_busy(dev))
-			yield();
+		while (some_qdisc_is_busy(dev)) {
+			/* wait_event() would avoid this sleep-loop but would
+			 * require expesive checks in the fast paths of packet
+			 * processing which isn't worth it.
+			 */
+			schedule_timeout_uninterruptible(1);
+		}
 		/* The new qdisc is assigned at this point so we can safely
 		 * unwind stale skb lists and qdisc statistics
 		 */
-- 
2.23.0

