Return-Path: <netdev+bounces-552-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E646F81A3
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:25:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E75F81C217E3
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE660BA45;
	Fri,  5 May 2023 11:24:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47B2BA39
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 11:24:31 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068501A12A;
	Fri,  5 May 2023 04:24:30 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QCSwl5bkSzpW4q;
	Fri,  5 May 2023 19:23:19 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 5 May
 2023 19:24:26 +0800
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
Subject: [PATCH 3/9] softirq: Factor loop termination condition
Date: Fri, 5 May 2023 19:33:09 +0800
Message-ID: <20230505113315.3307723-4-liujian56@huawei.com>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Peter Zijlstra <peterz@infradead.org>

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 kernel/softirq.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 59f16a9af5d1..48a81d8ae49a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -477,22 +477,6 @@ asmlinkage __visible void do_softirq(void)
 
 #endif /* !CONFIG_PREEMPT_RT */
 
-/*
- * We restart softirq processing for at most MAX_SOFTIRQ_RESTART times,
- * but break the loop if need_resched() is set or after 2 ms.
- * The MAX_SOFTIRQ_TIME provides a nice upper bound in most cases, but in
- * certain cases, such as stop_machine(), jiffies may cease to
- * increment and so we need the MAX_SOFTIRQ_RESTART limit as
- * well to make sure we eventually return from this method.
- *
- * These limits have been established via experimentation.
- * The two things to balance is latency against fairness -
- * we want to handle softirqs as soon as possible, but they
- * should not be able to lock up the box.
- */
-#define MAX_SOFTIRQ_TIME	(2 * NSEC_PER_MSEC)
-#define MAX_SOFTIRQ_RESTART 10
-
 #ifdef CONFIG_TRACE_IRQFLAGS
 /*
  * When we run softirqs from irq_exit() and thus on the hardirq stack we need
@@ -526,10 +510,33 @@ static inline bool lockdep_softirq_start(void) { return false; }
 static inline void lockdep_softirq_end(bool in_hardirq) { }
 #endif
 
+/*
+ * We restart softirq processing but break the loop if need_resched() is set or
+ * after 2 ms. The MAX_SOFTIRQ_RESTART guarantees a loop termination if
+ * sched_clock() were ever to stall.
+ *
+ * These limits have been established via experimentation.  The two things to
+ * balance is latency against fairness - we want to handle softirqs as soon as
+ * possible, but they should not be able to lock up the box.
+ */
+#define MAX_SOFTIRQ_TIME	(2 * NSEC_PER_MSEC)
+#define MAX_SOFTIRQ_RESTART	10
+
+static inline bool __softirq_needs_break(u64 start)
+{
+	if (need_resched())
+		return true;
+
+	if (sched_clock() - start >= MAX_SOFTIRQ_TIME)
+		return true;
+
+	return false;
+}
+
 asmlinkage __visible void __softirq_entry __do_softirq(void)
 {
+	unsigned int max_restart = MAX_SOFTIRQ_RESTART;
 	unsigned long old_flags = current->flags;
-	int max_restart = MAX_SOFTIRQ_RESTART;
 	u64 start = sched_clock();
 	struct softirq_action *h;
 	unsigned long pending;
@@ -585,8 +592,7 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 
 	pending = local_softirq_pending();
 	if (pending) {
-		if (sched_clock() - start < MAX_SOFTIRQ_TIME && !need_resched() &&
-		    --max_restart)
+		if (!__softirq_needs_break(start) && --max_restart)
 			goto restart;
 
 		wakeup_softirqd();
-- 
2.34.1


