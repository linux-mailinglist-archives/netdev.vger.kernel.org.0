Return-Path: <netdev+bounces-807-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F061D6F9FC7
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97976280F7B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D6D1549F;
	Mon,  8 May 2023 06:18:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB97A1548C
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:18:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183ED1FEA
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 23:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683526685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W0c+VSR17kVnx+dGxdbRQxPAsnMKfT7yhIv2KO3Qcns=;
	b=eZadGpezd6zVhtVE2L21j5sBql9lhb44bZWqk5phTb5gR7uPZqxQPL9XYH1aBmtJlMf9VQ
	DYpLCAUviBTgfivhauSwQieqcmtl3R6USb0RaEBx5PiEGPJuNC3zTMTAE0370DqlbstXQ8
	50wvgwNntqJ1K5dyBNIf94uc1St9mHM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-67wtD5P8MEaxF9DVAmIAzg-1; Mon, 08 May 2023 02:18:01 -0400
X-MC-Unique: 67wtD5P8MEaxF9DVAmIAzg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3686038005FD;
	Mon,  8 May 2023 06:18:01 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.142])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 93060492C13;
	Mon,  8 May 2023 06:17:59 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	peterz@infradead.org,
	netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@google.com>
Subject: [PATCH] revert: "softirq: Let ksoftirqd do its job"
Date: Mon,  8 May 2023 08:17:44 +0200
Message-Id: <57e66b364f1b6f09c9bc0316742c3b14f4ce83bd.1683526542.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Due to the mentioned commit, when the ksoftirqd processes take charge
of softirq processing, the system can experience high latencies.

In the past a few workarounds have been implemented for specific
side-effects of the above:

commit 1ff688209e2e ("watchdog: core: make sure the watchdog_worker is not deferred")
commit 8d5755b3f77b ("watchdog: softdog: fire watchdog even if softirqs do not get to run")
commit 217f69743681 ("net: busy-poll: allow preemption in sk_busy_loop()")
commit 3c53776e29f8 ("Mark HI and TASKLET softirq synchronous")

but the latency problem still exists in real-life workloads, see the
link below.

The reverted commit intended to solve a live-lock scenario that can now
be addressed with the NAPI threaded mode, introduced with commit
29863d41bb6e ("net: implement threaded-able napi poll loop support"),
and nowadays in a pretty stable status.

While a complete solution to put softirq processing under nice resource
control would be preferable, that has proven to be a very hard task. In
the short term, remove the main pain point, and also simplify a bit the
current softirq implementation.

Note that this change also reverts commit 3c53776e29f8 ("Mark HI and
TASKLET softirq synchronous") and commit 1342d8080f61 ("softirq: Don't
skip softirq execution when softirq thread is parking"), which are
direct follow-ups of the feature commit. A single change is preferred to
avoid known bad intermediate states introduced by a patch series
reverting them individually.

Link: https://lore.kernel.org/netdev/305d7742212cbe98621b16be782b0562f1012cb6.camel@redhat.com/
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Jason Xing <kerneljasonxing@gmail.com>
---
 kernel/softirq.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 1b725510dd0f..807b34ccd797 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -80,21 +80,6 @@ static void wakeup_softirqd(void)
 		wake_up_process(tsk);
 }
 
-/*
- * If ksoftirqd is scheduled, we do not want to process pending softirqs
- * right now. Let ksoftirqd handle this at its own rate, to get fairness,
- * unless we're doing some of the synchronous softirqs.
- */
-#define SOFTIRQ_NOW_MASK ((1 << HI_SOFTIRQ) | (1 << TASKLET_SOFTIRQ))
-static bool ksoftirqd_running(unsigned long pending)
-{
-	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
-
-	if (pending & SOFTIRQ_NOW_MASK)
-		return false;
-	return tsk && task_is_running(tsk) && !__kthread_should_park(tsk);
-}
-
 #ifdef CONFIG_TRACE_IRQFLAGS
 DEFINE_PER_CPU(int, hardirqs_enabled);
 DEFINE_PER_CPU(int, hardirq_context);
@@ -236,7 +221,7 @@ void __local_bh_enable_ip(unsigned long ip, unsigned int cnt)
 		goto out;
 
 	pending = local_softirq_pending();
-	if (!pending || ksoftirqd_running(pending))
+	if (!pending)
 		goto out;
 
 	/*
@@ -432,9 +417,6 @@ static inline bool should_wake_ksoftirqd(void)
 
 static inline void invoke_softirq(void)
 {
-	if (ksoftirqd_running(local_softirq_pending()))
-		return;
-
 	if (!force_irqthreads() || !__this_cpu_read(ksoftirqd)) {
 #ifdef CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK
 		/*
@@ -468,7 +450,7 @@ asmlinkage __visible void do_softirq(void)
 
 	pending = local_softirq_pending();
 
-	if (pending && !ksoftirqd_running(pending))
+	if (pending)
 		do_softirq_own_stack();
 
 	local_irq_restore(flags);
-- 
2.40.0


