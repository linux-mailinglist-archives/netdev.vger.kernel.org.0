Return-Path: <netdev+bounces-553-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75CF56F81A6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:25:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12695280E69
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BF6BA39;
	Fri,  5 May 2023 11:24:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA790C128
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 11:24:32 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F03F1A498;
	Fri,  5 May 2023 04:24:31 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QCSrt3jlczTjxM;
	Fri,  5 May 2023 19:19:58 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 5 May
 2023 19:24:28 +0800
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
Subject: [PATCH 4/9] softirq: Allow early break
Date: Fri, 5 May 2023 19:33:10 +0800
Message-ID: <20230505113315.3307723-5-liujian56@huawei.com>
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

Allow terminating the softirq processing loop without finishing the
vectors.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 kernel/softirq.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 48a81d8ae49a..e2cad5d108c8 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -582,6 +582,9 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 			       prev_count, preempt_count());
 			preempt_count_set(prev_count);
 		}
+
+		if (pending && __softirq_needs_break(start))
+			break;
 	}
 
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
@@ -590,13 +593,14 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 
 	local_irq_disable();
 
-	pending = local_softirq_pending();
-	if (pending) {
-		if (!__softirq_needs_break(start) && --max_restart)
-			goto restart;
+	if (pending)
+		or_softirq_pending(pending);
+	else if ((pending = local_softirq_pending()) &&
+		 !__softirq_needs_break(start) &&
+		 --max_restart)
+		goto restart;
 
-		wakeup_softirqd();
-	}
+	wakeup_softirqd();
 
 	account_softirq_exit(current);
 	lockdep_softirq_end(in_hardirq);
-- 
2.34.1


