Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD1B681AF6
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbjA3T7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236714AbjA3T7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:59:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C38129435;
        Mon, 30 Jan 2023 11:59:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B402D60C2A;
        Mon, 30 Jan 2023 19:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADD6C433EF;
        Mon, 30 Jan 2023 19:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675108772;
        bh=lH8p4PkyNawpDjZbeQEqhqYmi2Mm2kc4lhAa7ikztlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V9zMUXmoWAWar0bWjGZruTjFhzR/Be1nqRA/6p/PXXno60UcNHEiBhaH4hdo3Q9/1
         Kj8jp0eWStmdeCxAlATxTobyzwJY16StTxu9KYxl5MOgLHNHAR5MGWrb+zLyh7HdMW
         hAQdDFFLXAVHVVsDRxe2C0NN9vwyCkKuqI4C3w9bW3xCmMEcvRL5kDYE2Revzv7WaV
         PcNjT23pQ/inqkS2icUELqX2/cTIUBYf/qsAZWg807/z6XMeMxsXrHCRVg06LL9uwQ
         vQu0dNq9lNOAH1VLjuh+A27TF2KA4CLEVCpx4QQ4SjJpHTQrUJf+bUI8cgmT9JUToY
         qFChE3m06OHTA==
Date:   Mon, 30 Jan 2023 11:59:30 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <20230130195930.s5iu76e56j4q5bra@treble>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble>
 <20230127221131.sdneyrlxxhc4h3fa@treble>
 <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 01:40:18PM +0100, Peter Zijlstra wrote:
> Right, I was thinking you'd do something like:
> 
> 	static_call_update(cond_resched, klp_cond_resched);
> 
> With:
> 
> static int klp_cond_resched(void)
> {
> 	klp_try_switch_task(current);
> 	return __cond_resched();
> }

Something like this?

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index cbe72bfd2f1f..424c0c939f57 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -363,8 +363,7 @@ static int vhost_worker(void *data)
 			kcov_remote_start_common(dev->kcov_handle);
 			work->fn(work);
 			kcov_remote_stop();
-			if (need_resched())
-				schedule();
+			cond_resched();
 		}
 	}
 	kthread_unuse_mm(dev->mm);
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 293e29960c6e..937816d0867c 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -14,6 +14,8 @@
 #include <linux/completion.h>
 #include <linux/list.h>
 
+#include <linux/livepatch_sched.h>
+
 #if IS_ENABLED(CONFIG_LIVEPATCH)
 
 /* task patch states */
diff --git a/include/linux/livepatch_sched.h b/include/linux/livepatch_sched.h
new file mode 100644
index 000000000000..3237bc6a5b01
--- /dev/null
+++ b/include/linux/livepatch_sched.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_LIVEPATCH_SCHED_H_
+#define _LINUX_LIVEPATCH_SCHED_H_
+
+#include <linux/static_call_types.h>
+
+#ifdef CONFIG_LIVEPATCH
+
+void __klp_sched_try_switch(void);
+DECLARE_STATIC_CALL(klp_sched_try_switch, __klp_sched_try_switch);
+
+static __always_inline void klp_sched_try_switch(void)
+{
+	//FIXME need static_call_cond_mod() ?
+	static_call_mod(klp_sched_try_switch)();
+}
+
+#else /* !CONFIG_LIVEPATCH */
+static inline void klp_sched_try_switch(void) {}
+#endif /* CONFIG_LIVEPATCH */
+
+#endif /* _LINUX_LIVEPATCH_SCHED_H_ */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4df2b3e76b30..a7acf9ae9b90 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -36,6 +36,7 @@
 #include <linux/seqlock.h>
 #include <linux/kcsan.h>
 #include <linux/rv.h>
+#include <linux/livepatch_sched.h>
 #include <asm/kmap_size.h>
 
 /* task_struct member predeclarations (sorted alphabetically): */
@@ -2077,11 +2078,15 @@ static __always_inline int _cond_resched(void)
 	return static_call_mod(cond_resched)();
 }
 
+void sched_dynamic_klp_enable(void);
+void sched_dynamic_klp_disable(void);
+
 #elif defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_KEY)
 extern int dynamic_cond_resched(void);
 
 static __always_inline int _cond_resched(void)
 {
+	klp_sched_try_switch();
 	return dynamic_cond_resched();
 }
 
@@ -2089,6 +2094,7 @@ static __always_inline int _cond_resched(void)
 
 static inline int _cond_resched(void)
 {
+	klp_sched_try_switch();
 	return __cond_resched();
 }
 
@@ -2096,7 +2102,10 @@ static inline int _cond_resched(void)
 
 #else
 
-static inline int _cond_resched(void) { return 0; }
+static inline int _cond_resched(void) {
+	klp_sched_try_switch();
+	return 0;
+}
 
 #endif /* !defined(CONFIG_PREEMPTION) || defined(CONFIG_PREEMPT_DYNAMIC) */
 
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f1b25ec581e0..3cc4e0a24dc6 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -9,6 +9,7 @@
 
 #include <linux/cpu.h>
 #include <linux/stacktrace.h>
+#include <linux/static_call.h>
 #include "core.h"
 #include "patch.h"
 #include "transition.h"
@@ -24,6 +25,9 @@ static int klp_target_state = KLP_UNDEFINED;
 
 static unsigned int klp_signals_cnt;
 
+DEFINE_STATIC_CALL_NULL(klp_sched_try_switch, __klp_sched_try_switch);
+EXPORT_STATIC_CALL_TRAMP(klp_sched_try_switch);
+
 /*
  * This work can be performed periodically to finish patching or unpatching any
  * "straggler" tasks which failed to transition in the first attempt.
@@ -61,6 +65,28 @@ static void klp_synchronize_transition(void)
 	schedule_on_each_cpu(klp_sync);
 }
 
+/*
+ * Enable the klp hooks in cond_resched() while livepatching is in progress.
+ * This helps CPU-bound kthreads get patched.
+ */
+static void klp_sched_hook_enable(void)
+{
+#if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
+	sched_dynamic_klp_enable();
+#else
+	static_call_update(klp_sched_try_switch, __klp_sched_try_switch);
+#endif
+}
+
+static void klp_sched_hook_disable(void)
+{
+#if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
+	sched_dynamic_klp_disable();
+#else
+	static_call_update(klp_sched_try_switch, NULL);
+#endif
+}
+
 /*
  * The transition to the target patch state is complete.  Clean up the data
  * structures.
@@ -76,6 +102,8 @@ static void klp_complete_transition(void)
 		 klp_transition_patch->mod->name,
 		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
 
+	klp_sched_hook_disable();
+
 	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
 		klp_unpatch_replaced_patches(klp_transition_patch);
 		klp_discard_nops(klp_transition_patch);
@@ -307,7 +335,11 @@ static bool klp_try_switch_task(struct task_struct *task)
 	 * functions.  If all goes well, switch the task to the target patch
 	 * state.
 	 */
-	ret = task_call_func(task, klp_check_and_switch_task, &old_name);
+	if (task == current)
+		ret = klp_check_and_switch_task(current, &old_name);
+	else
+		ret = task_call_func(task, klp_check_and_switch_task, &old_name);
+
 	switch (ret) {
 	case 0:		/* success */
 		break;
@@ -334,6 +366,15 @@ static bool klp_try_switch_task(struct task_struct *task)
 	return !ret;
 }
 
+void __klp_sched_try_switch(void)
+{
+	if (likely(!klp_patch_pending(current)))
+		return;
+
+	//FIXME locking
+	klp_try_switch_task(current);
+}
+
 /*
  * Sends a fake signal to all non-kthread tasks with TIF_PATCH_PENDING set.
  * Kthreads with TIF_PATCH_PENDING set are woken up.
@@ -492,6 +533,8 @@ void klp_start_transition(void)
 			set_tsk_thread_flag(task, TIF_PATCH_PENDING);
 	}
 
+	klp_sched_hook_enable();
+
 	klp_signals_cnt = 0;
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3a0ef2fefbd5..4fbf70b05576 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8648,13 +8648,16 @@ int sched_dynamic_mode(const char *str)
 #error "Unsupported PREEMPT_DYNAMIC mechanism"
 #endif
 
+static bool klp_override;
+
 void sched_dynamic_update(int mode)
 {
 	/*
 	 * Avoid {NONE,VOLUNTARY} -> FULL transitions from ever ending up in
 	 * the ZERO state, which is invalid.
 	 */
-	preempt_dynamic_enable(cond_resched);
+	if (!klp_override)
+		preempt_dynamic_enable(cond_resched);
 	preempt_dynamic_enable(might_resched);
 	preempt_dynamic_enable(preempt_schedule);
 	preempt_dynamic_enable(preempt_schedule_notrace);
@@ -8662,16 +8665,19 @@ void sched_dynamic_update(int mode)
 
 	switch (mode) {
 	case preempt_dynamic_none:
-		preempt_dynamic_enable(cond_resched);
+		if (!klp_override)
+			preempt_dynamic_enable(cond_resched);
 		preempt_dynamic_disable(might_resched);
 		preempt_dynamic_disable(preempt_schedule);
 		preempt_dynamic_disable(preempt_schedule_notrace);
 		preempt_dynamic_disable(irqentry_exit_cond_resched);
+		//FIXME avoid printk for klp restore
 		pr_info("Dynamic Preempt: none\n");
 		break;
 
 	case preempt_dynamic_voluntary:
-		preempt_dynamic_enable(cond_resched);
+		if (!klp_override)
+			preempt_dynamic_enable(cond_resched);
 		preempt_dynamic_enable(might_resched);
 		preempt_dynamic_disable(preempt_schedule);
 		preempt_dynamic_disable(preempt_schedule_notrace);
@@ -8680,7 +8686,8 @@ void sched_dynamic_update(int mode)
 		break;
 
 	case preempt_dynamic_full:
-		preempt_dynamic_disable(cond_resched);
+		if (!klp_override)
+			preempt_dynamic_disable(cond_resched);
 		preempt_dynamic_disable(might_resched);
 		preempt_dynamic_enable(preempt_schedule);
 		preempt_dynamic_enable(preempt_schedule_notrace);
@@ -8692,6 +8699,28 @@ void sched_dynamic_update(int mode)
 	preempt_dynamic_mode = mode;
 }
 
+#ifdef CONFIG_HAVE_PREEMPT_DYNAMIC_CALL
+static int klp_cond_resched(void)
+{
+	__klp_sched_try_switch();
+	return __cond_resched();
+}
+
+void sched_dynamic_klp_enable(void)
+{
+	//FIXME locking
+	klp_override = true;
+	static_call_update(cond_resched, klp_cond_resched);
+}
+
+void sched_dynamic_klp_disable(void)
+{
+	//FIXME locking
+	klp_override = false;
+	sched_dynamic_update(preempt_dynamic_mode);
+}
+#endif /* CONFIG_HAVE_PREEMPT_DYNAMIC_CALL*/
+
 static int __init setup_preempt_mode(char *str)
 {
 	int mode = sched_dynamic_mode(str);
