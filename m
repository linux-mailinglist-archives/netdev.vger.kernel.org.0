Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BBE1ED273
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 16:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgFCOuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 10:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgFCOuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 10:50:19 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E962C08C5C2;
        Wed,  3 Jun 2020 07:50:17 -0700 (PDT)
Received: from [5.158.153.53] (helo=debian-buster-darwi.lab.linutronix.de.)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <a.darwish@linutronix.de>)
        id 1jgUiT-0001xi-Uy; Wed, 03 Jun 2020 16:50:06 +0200
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2 3/6] u64_stats: Document writer non-preemptibility requirement
Date:   Wed,  3 Jun 2020 16:49:46 +0200
Message-Id: <20200603144949.1122421-4-a.darwish@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200603144949.1122421-1-a.darwish@linutronix.de>
References: <20200603144949.1122421-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The u64_stats mechanism uses sequence counters to protect against 64-bit
values tearing on 32-bit architectures. Updating such statistics is a
sequence counter write side critical section.

Preemption must be disabled before entering this seqcount write critical
section.  Failing to do so, the seqcount read side can preempt the write
side section and spin for the entire scheduler tick.  If that reader
belongs to a real-time scheduling class, it can spin forever and the
kernel will livelock.

Document this statistics update side non-preemptibility requirement.

Reword the introductory paragraph to highlight u64_stats raison d'être:
64-bit values tearing protection on 32-bit architectures. Divide
documentation on a basis of internal design vs. usage constraints.

Reword the u64_stats header file top comment to always mention "Reader"
or "Writer" at the start of each bullet point, making it easier to
follow which side each point is actually for.

Clarify the statement "whole thing is a NOOP on 64bit arches or UP
kernels".  For 32-bit UP kernels, preemption is always disabled for the
statistics read side section.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/u64_stats_sync.h | 43 ++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 9de5c10293f5..c6abb79501b3 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -3,33 +3,36 @@
 #define _LINUX_U64_STATS_SYNC_H
 
 /*
- * To properly implement 64bits network statistics on 32bit and 64bit hosts,
- * we provide a synchronization point, that is a noop on 64bit or UP kernels.
+ * Protect against 64-bit values tearing on 32-bit architectures. This is
+ * typically used for statistics read/update in different subsystems.
  *
  * Key points :
- * 1) Use a seqcount on SMP 32bits, with low overhead.
- * 2) Whole thing is a noop on 64bit arches or UP kernels.
- * 3) Write side must ensure mutual exclusion or one seqcount update could
+ *
+ * -  Use a seqcount on 32-bit SMP, only disable preemption for 32-bit UP.
+ * -  The whole thing is a no-op on 64-bit architectures.
+ *
+ * Usage constraints:
+ *
+ * 1) Write side must ensure mutual exclusion, or one seqcount update could
  *    be lost, thus blocking readers forever.
- *    If this synchronization point is not a mutex, but a spinlock or
- *    spinlock_bh() or disable_bh() :
- * 3.1) Write side should not sleep.
- * 3.2) Write side should not allow preemption.
- * 3.3) If applicable, interrupts should be disabled.
+ *
+ * 2) Write side must disable preemption, or a seqcount reader can preempt the
+ *    writer and also spin forever.
+ *
+ * 3) Write side must use the _irqsave() variant if other writers, or a reader,
+ *    can be invoked from an IRQ context.
  *
  * 4) If reader fetches several counters, there is no guarantee the whole values
- *    are consistent (remember point 1) : this is a noop on 64bit arches anyway)
+ *    are consistent w.r.t. each other (remember point #2: seqcounts are not
+ *    used for 64bit architectures).
  *
- * 5) readers are allowed to sleep or be preempted/interrupted : They perform
- *    pure reads. But if they have to fetch many values, it's better to not allow
- *    preemptions/interruptions to avoid many retries.
+ * 5) Readers are allowed to sleep or be preempted/interrupted: they perform
+ *    pure reads.
  *
- * 6) If counter might be written by an interrupt, readers should block interrupts.
- *    (On UP, there is no seqcount_t protection, a reader allowing interrupts could
- *     read partial values)
- *
- * 7) For irq and softirq uses, readers can use u64_stats_fetch_begin_irq() and
- *    u64_stats_fetch_retry_irq() helpers
+ * 6) Readers must use both u64_stats_fetch_{begin,retry}_irq() if the stats
+ *    might be updated from a hardirq or softirq context (remember point #1:
+ *    seqcounts are not used for UP kernels). 32-bit UP stat readers could read
+ *    corrupted 64-bit values otherwise.
  *
  * Usage :
  *
-- 
2.20.1

