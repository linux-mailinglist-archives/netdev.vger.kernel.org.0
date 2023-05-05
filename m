Return-Path: <netdev+bounces-556-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F10C6F81AF
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:26:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 596631C217D2
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43786FA6;
	Fri,  5 May 2023 11:24:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DA4C2D1
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 11:24:37 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A1C1A4AF;
	Fri,  5 May 2023 04:24:35 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QCSsT1Qglz18KCs;
	Fri,  5 May 2023 19:20:29 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 5 May
 2023 19:24:32 +0800
From: Liu Jian <liujian56@huawei.com>
To: <corbet@lwn.net>, <paulmck@kernel.org>, <frederic@kernel.org>,
	<quic_neeraju@quicinc.com>, <joel@joelfernandes.org>,
	<josh@joshtriplett.org>, <boqun.feng@gmail.com>, <rostedt@goodmis.org>,
	<mathieu.desnoyers@efficios.com>, <jiangshanlai@gmail.com>,
	<qiang1.zhang@intel.com>, <jstultz@google.com>, <tglx@linutronix.de>,
	<sboyd@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <peterz@infradead.org>,
	<frankwoo@google.com>, <Rhinewuwu@google.com>
CC: <liujian56@huawei.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rcu@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: [PATCH 8/9] softirq,rcu: Use softirq_needs_break()
Date: Fri, 5 May 2023 19:33:14 +0800
Message-ID: <20230505113315.3307723-9-liujian56@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230505113315.3307723-1-liujian56@huawei.com>
References: <20230505113315.3307723-1-liujian56@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Peter Zijlstra <peterz@infradead.org>

SoftIRQs provide their own timeout/break code now, use that.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 kernel/rcu/tree.c      | 29 +++++++----------------------
 kernel/rcu/tree_nocb.h |  2 +-
 2 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f52ff7241041..1942e3db4145 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -397,10 +397,6 @@ static bool rcu_kick_kthreads;
 static int rcu_divisor = 7;
 module_param(rcu_divisor, int, 0644);
 
-/* Force an exit from rcu_do_batch() after 3 milliseconds. */
-static long rcu_resched_ns = 3 * NSEC_PER_MSEC;
-module_param(rcu_resched_ns, long, 0644);
-
 /*
  * How long the grace period must be before we start recruiting
  * quiescent-state help from rcu_note_context_switch().
@@ -2050,7 +2046,7 @@ rcu_check_quiescent_state(struct rcu_data *rdp)
  * Invoke any RCU callbacks that have made it to the end of their grace
  * period.  Throttle as specified by rdp->blimit.
  */
-static void rcu_do_batch(struct rcu_data *rdp)
+static void rcu_do_batch(struct softirq_action *h, struct rcu_data *rdp)
 {
 	int div;
 	bool __maybe_unused empty;
@@ -2058,7 +2054,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	struct rcu_head *rhp;
 	struct rcu_cblist rcl = RCU_CBLIST_INITIALIZER(rcl);
 	long bl, count = 0;
-	long pending, tlimit = 0;
+	long pending;
 
 	/* If no callbacks are ready, just return. */
 	if (!rcu_segcblist_ready_cbs(&rdp->cblist)) {
@@ -2082,12 +2078,6 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	div = READ_ONCE(rcu_divisor);
 	div = div < 0 ? 7 : div > sizeof(long) * 8 - 2 ? sizeof(long) * 8 - 2 : div;
 	bl = max(rdp->blimit, pending >> div);
-	if (in_serving_softirq() && unlikely(bl > 100)) {
-		long rrn = READ_ONCE(rcu_resched_ns);
-
-		rrn = rrn < NSEC_PER_MSEC ? NSEC_PER_MSEC : rrn > NSEC_PER_SEC ? NSEC_PER_SEC : rrn;
-		tlimit = local_clock() + rrn;
-	}
 	trace_rcu_batch_start(rcu_state.name,
 			      rcu_segcblist_n_cbs(&rdp->cblist), bl);
 	rcu_segcblist_extract_done_cbs(&rdp->cblist, &rcl);
@@ -2126,13 +2116,8 @@ static void rcu_do_batch(struct rcu_data *rdp)
 			 * Make sure we don't spend too much time here and deprive other
 			 * softirq vectors of CPU cycles.
 			 */
-			if (unlikely(tlimit)) {
-				/* only call local_clock() every 32 callbacks */
-				if (likely((count & 31) || local_clock() < tlimit))
-					continue;
-				/* Exceeded the time limit, so leave. */
+			if (unlikely(!(count & 31)) && softirq_needs_break(h))
 				break;
-			}
 		} else {
 			// In rcuoc context, so no worries about depriving
 			// other softirq vectors of CPU cycles.
@@ -2320,7 +2305,7 @@ static void strict_work_handler(struct work_struct *work)
 }
 
 /* Perform RCU core processing work for the current CPU.  */
-static __latent_entropy void rcu_core(void)
+static __latent_entropy void rcu_core(struct softirq_action *h)
 {
 	unsigned long flags;
 	struct rcu_data *rdp = raw_cpu_ptr(&rcu_data);
@@ -2374,7 +2359,7 @@ static __latent_entropy void rcu_core(void)
 	/* If there are callbacks ready, invoke them. */
 	if (do_batch && rcu_segcblist_ready_cbs(&rdp->cblist) &&
 	    likely(READ_ONCE(rcu_scheduler_fully_active))) {
-		rcu_do_batch(rdp);
+		rcu_do_batch(h, rdp);
 		/* Re-invoke RCU core processing if there are callbacks remaining. */
 		if (rcu_segcblist_ready_cbs(&rdp->cblist))
 			invoke_rcu_core();
@@ -2391,7 +2376,7 @@ static __latent_entropy void rcu_core(void)
 
 static void rcu_core_si(struct softirq_action *h)
 {
-	rcu_core();
+	rcu_core(h);
 }
 
 static void rcu_wake_cond(struct task_struct *t, int status)
@@ -2462,7 +2447,7 @@ static void rcu_cpu_kthread(unsigned int cpu)
 		*workp = 0;
 		local_irq_enable();
 		if (work)
-			rcu_core();
+			rcu_core(NULL);
 		local_bh_enable();
 		if (*workp == 0) {
 			trace_rcu_utilization(TPS("End CPU kthread@rcu_wait"));
diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index f2280616f9d5..44fc907fdb5e 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -951,7 +951,7 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 	 * instances of this callback would execute concurrently.
 	 */
 	local_bh_disable();
-	rcu_do_batch(rdp);
+	rcu_do_batch(NULL, rdp);
 	local_bh_enable();
 	lockdep_assert_irqs_enabled();
 	rcu_nocb_lock_irqsave(rdp, flags);
-- 
2.34.1


