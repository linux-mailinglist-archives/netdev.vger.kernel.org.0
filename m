Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DB267F0F5
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 23:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbjA0WLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 17:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbjA0WLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 17:11:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E457F8397D;
        Fri, 27 Jan 2023 14:11:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2687961CC5;
        Fri, 27 Jan 2023 22:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03153C433D2;
        Fri, 27 Jan 2023 22:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674857493;
        bh=ojiv7M0xxOTEFX04LR+WcAaChd8DZ8lK8tjeeTKAH4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qd/CU1Js3do3NfRZf1ZyHpN8xUeIz5TA6eOB94P0vhHiXXY1+bU9Px4T7IcXgnUlo
         4hp1FzMbYYtC5QzvqvrxEqhK2uk9o1Fm3Vw1scme9SGKgRMFVyH1kS0d80BPtpFHYu
         5tyCU1vDuZ02XpC+w417Az8q2r/YYj30fuHKYIGo3FhaHEoFwAM8lZkDgni+DAY2UN
         JjNvP3nFnuyIN6NJyL2l9todhcKnXV0A0Jtbc6dS1toLprDaXAUeS46Gc+Hkfnp+ut
         qoF4TSZM9hQzc8V4LnpjcsA2W2KtuyPnP3uPzXm5OAzX2LbTGIBxojBh8wDAt+ZHxy
         Ct/rUilPRol4w==
Date:   Fri, 27 Jan 2023 14:11:31 -0800
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
Message-ID: <20230127221131.sdneyrlxxhc4h3fa@treble>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230127170946.zey6xbr4sm4kvh3x@treble>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 09:09:48AM -0800, Josh Poimboeuf wrote:
> On Fri, Jan 27, 2023 at 08:52:38AM -0800, Josh Poimboeuf wrote:
> > On Fri, Jan 27, 2023 at 11:37:02AM +0100, Peter Zijlstra wrote:
> > > On Thu, Jan 26, 2023 at 08:43:55PM -0800, Josh Poimboeuf wrote:
> > > > Here's another idea, have we considered this?  Have livepatch set
> > > > TIF_NEED_RESCHED on all kthreads to force them into schedule(), and then
> > > > have the scheduler call klp_try_switch_task() if TIF_PATCH_PENDING is
> > > > set.
> > > > 
> > > > Not sure how scheduler folks would feel about that ;-)
> > 
> > Hmmmm, with preemption I guess the above doesn't work for kthreads
> > calling cond_resched() instead of what vhost_worker() does (explicit
> > need_resched/schedule).
> 
> Though I guess we could hook into cond_resched() too if we make it a
> non-NOP for PREEMPT+LIVEPATCH?

I discussed this idea with Peter on IRC and he didn't immediately shoot
it down.

It compiles...

Thoughts?

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
index 4df2b3e76b30..fbcd3acca25c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -36,6 +36,7 @@
 #include <linux/seqlock.h>
 #include <linux/kcsan.h>
 #include <linux/rv.h>
+#include <linux/livepatch_sched.h>
 #include <asm/kmap_size.h>
 
 /* task_struct member predeclarations (sorted alphabetically): */
@@ -2074,6 +2075,9 @@ DECLARE_STATIC_CALL(cond_resched, __cond_resched);
 
 static __always_inline int _cond_resched(void)
 {
+	//FIXME this is a bit redundant with preemption disabled
+	klp_sched_try_switch();
+
 	return static_call_mod(cond_resched)();
 }
 
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f1b25ec581e0..042e34c9389c 100644
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
@@ -76,6 +80,8 @@ static void klp_complete_transition(void)
 		 klp_transition_patch->mod->name,
 		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
 
+	static_call_update(klp_sched_try_switch, NULL);
+
 	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
 		klp_unpatch_replaced_patches(klp_transition_patch);
 		klp_discard_nops(klp_transition_patch);
@@ -256,7 +262,8 @@ static int klp_check_stack(struct task_struct *task, const char **oldname)
 		klp_for_each_func(obj, func) {
 			ret = klp_check_stack_func(func, entries, nr_entries);
 			if (ret) {
-				*oldname = func->old_name;
+				if (oldname)
+					*oldname = func->old_name;
 				return -EADDRINUSE;
 			}
 		}
@@ -307,7 +314,11 @@ static bool klp_try_switch_task(struct task_struct *task)
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
@@ -334,6 +345,15 @@ static bool klp_try_switch_task(struct task_struct *task)
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
@@ -401,8 +421,10 @@ void klp_try_complete_transition(void)
 	 */
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, task)
-		if (!klp_try_switch_task(task))
+		if (!klp_try_switch_task(task)) {
+			set_tsk_need_resched(task);
 			complete = false;
+		}
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -413,6 +435,7 @@ void klp_try_complete_transition(void)
 		task = idle_task(cpu);
 		if (cpu_online(cpu)) {
 			if (!klp_try_switch_task(task)) {
+				set_tsk_need_resched(task);
 				complete = false;
 				/* Make idle task go through the main loop. */
 				wake_up_if_idle(cpu);
@@ -492,6 +515,8 @@ void klp_start_transition(void)
 			set_tsk_thread_flag(task, TIF_PATCH_PENDING);
 	}
 
+	static_call_update(klp_sched_try_switch, __klp_sched_try_switch);
+
 	klp_signals_cnt = 0;
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3a0ef2fefbd5..01e32d242ef6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6506,6 +6506,8 @@ static void __sched notrace __schedule(unsigned int sched_mode)
 	struct rq *rq;
 	int cpu;
 
+	klp_sched_try_switch();
+
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
 	prev = rq->curr;
@@ -8500,8 +8502,10 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
 static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
 int __sched dynamic_cond_resched(void)
 {
-	if (!static_branch_unlikely(&sk_dynamic_cond_resched))
+	if (!static_branch_unlikely(&sk_dynamic_cond_resched)) {
+		klp_sched_try_switch();
 		return 0;
+	}
 	return __cond_resched();
 }
 EXPORT_SYMBOL(dynamic_cond_resched);
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index e9ef66be2870..27ba93930584 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -308,9 +308,6 @@ static void do_idle(void)
 	 */
 	flush_smp_call_function_queue();
 	schedule_idle();
-
-	if (unlikely(klp_patch_pending(current)))
-		klp_update_patch_state(current);
 }
 
 bool cpu_in_idle(unsigned long pc)
