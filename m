Return-Path: <netdev+bounces-550-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B1866F8199
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:24:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44F6C1C21758
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C9179FA;
	Fri,  5 May 2023 11:24:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A6E79CA
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 11:24:29 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15D51A1C9;
	Fri,  5 May 2023 04:24:27 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QCSvy37N9zsR6B;
	Fri,  5 May 2023 19:22:38 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 5 May
 2023 19:24:24 +0800
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
Subject: [PATCH 1/9] softirq: Rewrite softirq processing loop
Date: Fri, 5 May 2023 19:33:07 +0800
Message-ID: <20230505113315.3307723-2-liujian56@huawei.com>
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

Simplify the softirq processing loop by using the bitmap APIs

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 kernel/softirq.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 1b725510dd0f..bff5debf6ce6 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -531,9 +531,9 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 	unsigned long old_flags = current->flags;
 	int max_restart = MAX_SOFTIRQ_RESTART;
 	struct softirq_action *h;
+	unsigned long pending;
+	unsigned int vec_nr;
 	bool in_hardirq;
-	__u32 pending;
-	int softirq_bit;
 
 	/*
 	 * Mask out PF_MEMALLOC as the current task context is borrowed for the
@@ -554,15 +554,13 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 
 	local_irq_enable();
 
-	h = softirq_vec;
+	for_each_set_bit(vec_nr, &pending, NR_SOFTIRQS) {
+		unsigned int prev_count;
 
-	while ((softirq_bit = ffs(pending))) {
-		unsigned int vec_nr;
-		int prev_count;
+		__clear_bit(vec_nr, &pending);
 
-		h += softirq_bit - 1;
+		h = softirq_vec + vec_nr;
 
-		vec_nr = h - softirq_vec;
 		prev_count = preempt_count();
 
 		kstat_incr_softirqs_this_cpu(vec_nr);
@@ -576,8 +574,6 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 			       prev_count, preempt_count());
 			preempt_count_set(prev_count);
 		}
-		h++;
-		pending >>= softirq_bit;
 	}
 
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
-- 
2.34.1


