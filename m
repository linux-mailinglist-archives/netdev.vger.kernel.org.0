Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6A5654832
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 23:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiLVWMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 17:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiLVWMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 17:12:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BF524BCD;
        Thu, 22 Dec 2022 14:12:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFA8461DB1;
        Thu, 22 Dec 2022 22:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AA8C43392;
        Thu, 22 Dec 2022 22:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671747168;
        bh=D5KSQncHbyZRvS0KOGabofpFDBc6Ejaiaupvz+j2wyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/XYYW2GuzaLDUnRG8/SOo/WZrhBXMZ9XxOtpoxV40Qx0lWnlbL4ZRqqyp8pyLo9A
         2YPpejBNuVp0k0bzm826qR9jwXAuAD5Wq/nBU82scAxNYZf2LgXb5bxUivd7Nh33Rr
         Z17UpYi+6RtO4litzdZ2sVIcXTgxM0NCNeiSaI8l7Vitnxx0IWACG1bs99DDV9lgg+
         +1f1zQ5KTTv8zLk5tarwUYsN4pB9TsaSGPfAOIXbq1T5vvA9MjlF6BF8JN69ZL9w3a
         dj1CE0klsCxKDMRIErGSwQzwWdY75b//Q1mmg2ra57QjUUOI9GXCTqLDyDksTLHwmi
         oi+8El0DcWohg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     peterz@infradead.org, tglx@linutronix.de
Cc:     jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
Date:   Thu, 22 Dec 2022 14:12:43 -0800
Message-Id: <20221222221244.1290833-3-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221222221244.1290833-1-kuba@kernel.org>
References: <20221222221244.1290833-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

need_resched() added in commit c10d73671ad3 ("softirq: reduce latencies")
does improve latency for real workloads (for example memcache).
Unfortunately it triggers quite often even for non-network-heavy apps
(~900 times a second on a loaded webserver), and in small fraction of
cases whatever the scheduler decided to run will hold onto the CPU
for the entire time slice.

10ms+ stalls on a machine which is not actually under overload cause
erratic network behavior and spurious TCP retransmits. Typical end-to-end
latency in a datacenter is < 200us so its common to set TCP timeout
to 10ms or less.

The intent of the need_resched() is to let a low latency application
respond quickly and yield (to ksoftirqd). Put a time limit on this dance.
Ignore the fact that ksoftirqd is RUNNING if we were trying to be nice
and the application did not yield quickly.

On a webserver loaded at 90% CPU this change reduces the numer of 8ms+
stalls the network softirq processing sees by around 10x (2/sec -> 0.2/sec).
It also seems to reduce retransmissions by ~10% but the data is quite
noisy.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 kernel/softirq.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 00b838d566c1..ad200d386ec1 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -59,6 +59,7 @@ EXPORT_PER_CPU_SYMBOL(irq_stat);
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
 DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+static DEFINE_PER_CPU(unsigned long, overload_limit);
 
 const char * const softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "IRQ_POLL",
@@ -89,10 +90,15 @@ static void wakeup_softirqd(void)
 static bool ksoftirqd_should_handle(unsigned long pending)
 {
 	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
+	unsigned long ov_limit;
 
 	if (pending & SOFTIRQ_NOW_MASK)
 		return false;
-	return tsk && task_is_running(tsk) && !__kthread_should_park(tsk);
+	if (likely(!tsk || !task_is_running(tsk) || __kthread_should_park(tsk)))
+		return false;
+
+	ov_limit = __this_cpu_read(overload_limit);
+	return time_is_after_jiffies(ov_limit);
 }
 
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -492,6 +498,9 @@ asmlinkage __visible void do_softirq(void)
 #define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
 #define MAX_SOFTIRQ_RESTART 10
 
+#define SOFTIRQ_OVERLOAD_TIME	msecs_to_jiffies(100)
+#define SOFTIRQ_DEFER_TIME	msecs_to_jiffies(2)
+
 #ifdef CONFIG_TRACE_IRQFLAGS
 /*
  * When we run softirqs from irq_exit() and thus on the hardirq stack we need
@@ -588,10 +597,16 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 
 	pending = local_softirq_pending();
 	if (pending) {
-		if (time_before(jiffies, end) && !need_resched() &&
-		    --max_restart)
+		unsigned long limit;
+
+		if (time_is_before_eq_jiffies(end) || !--max_restart)
+			limit = SOFTIRQ_OVERLOAD_TIME;
+		else if (need_resched())
+			limit = SOFTIRQ_DEFER_TIME;
+		else
 			goto restart;
 
+		__this_cpu_write(overload_limit, jiffies + limit);
 		wakeup_softirqd();
 	}
 
-- 
2.38.1

