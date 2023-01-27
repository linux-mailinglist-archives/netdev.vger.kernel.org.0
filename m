Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E1C67EF21
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 21:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjA0UFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 15:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbjA0UER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 15:04:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6FF1ABEB;
        Fri, 27 Jan 2023 12:02:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F14EB821D3;
        Fri, 27 Jan 2023 20:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A449CC433EF;
        Fri, 27 Jan 2023 20:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674849761;
        bh=ca4jPTCUeRFLCFAPxpZ4gedA/tBamy844ut60yl7Vu0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KoEmrQnaU3o0ETgjT0tTMaPW3aJq0YfRxSse5aoARQu7GzJBPgIt0xWAMnrH0l7nY
         ZHyo2KKDgGA28F+aJSTJ6Pxfl+dq+MsjvF52GUwgXMR0W6IJXrO912Fi8iaXAHU4VN
         Sxx5WAkaD84lkZSGctX1sjJWjxoVsS/P6h71DDEEBaHHgE0BQUXlsOBtdcq4nVKUZ1
         Zp1v0o/32Jbm3Dr5UxD8hRqI0+DcajE+ojat/yxLfWuQ9UfjVq2dcZVk0PCAe8bPvC
         z7RsXQBl1YACHxA0q2ubF3fbQviB/9NveMb1EDCNehwhv8UlzZtc27mfbVg/Fk6SrY
         XNavTv6Ocl5Tg==
Date:   Fri, 27 Jan 2023 14:02:40 -0600
From:   Seth Forshee <sforshee@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <Y9Qt4BT2WXK2dToL@do-x1extreme>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:37:02AM +0100, Peter Zijlstra wrote:
> On Thu, Jan 26, 2023 at 08:43:55PM -0800, Josh Poimboeuf wrote:
> > On Thu, Jan 26, 2023 at 03:12:35PM -0600, Seth Forshee (DigitalOcean) wrote:
> > > On Thu, Jan 26, 2023 at 06:03:16PM +0100, Petr Mladek wrote:
> > > > On Fri 2023-01-20 16:12:20, Seth Forshee (DigitalOcean) wrote:
> > > > > We've fairly regularaly seen liveptches which cannot transition within kpatch's
> > > > > timeout period due to busy vhost worker kthreads.
> > > > 
> > > > I have missed this detail. Miroslav told me that we have solved
> > > > something similar some time ago, see
> > > > https://lore.kernel.org/all/20220507174628.2086373-1-song@kernel.org/
> > > 
> > > Interesting thread. I had thought about something along the lines of the
> > > original patch, but there are some ideas in there that I hadn't
> > > considered.
> > 
> > Here's another idea, have we considered this?  Have livepatch set
> > TIF_NEED_RESCHED on all kthreads to force them into schedule(), and then
> > have the scheduler call klp_try_switch_task() if TIF_PATCH_PENDING is
> > set.
> > 
> > Not sure how scheduler folks would feel about that ;-)
> 
> So, let me try and page all that back in.... :-)
> 
> KLP needs to unwind the stack to see if any of the patched functions are
> active, if not, flip task to new set.
> 
> Unwinding the stack of a task can be done when:
> 
>  - task is inactive (stable reg and stack) -- provided it stays inactive
>    while unwinding etc..
> 
>  - task is current (guarantees stack doesn't dip below where we started
>    due to being busy on top etc..)
> 
> Can NOT be done from interrupt context, because can hit in the middle of
> setting up stack frames etc..
> 
> The issue at hand is that some tasks run for a long time without passing
> through an explicit check.
> 
> The thread above tried sticking something in cond_resched() which is a
> problem for PREEMPT=y since cond_resched() is a no-op.
> 
> Preempt notifiers were raised, and those would actually be nice, except
> you can only install a notifier on current and you need some memory
> allocated per task, which makes it less than ideal. Plus ...
> 
> ... putting something in finish_task_switch() wouldn't be the end of the
> world I suppose, but then you still need to force schedule the task --
> imagine it being the only runnable task on the CPU, there's nothing
> going to make it actually switch.
> 
> Which then leads me to suggest something daft like this.. does that
> help?

The changes below are working well for me. The context has a read lock
on tasklist_lock so it can't sleep, so I'm using stop_one_cpu_nowait()
with per-CPU state.

Based on Josh's comments it sounds like the klp_have_reliable_stack()
check probably isn't quite right, and we might want to add something
else for PREEMPT+!ORC. But I wanted to go ahead and see if this approach
seems reasonable to everyone.

Thanks,
Seth


diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f1b25ec581e0..9f3898f02828 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -9,6 +9,7 @@
 
 #include <linux/cpu.h>
 #include <linux/stacktrace.h>
+#include <linux/stop_machine.h>
 #include "core.h"
 #include "patch.h"
 #include "transition.h"
@@ -334,9 +335,16 @@ static bool klp_try_switch_task(struct task_struct *task)
 	return !ret;
 }
 
+static int __try_switch_kthread(void *arg)
+{
+	return klp_try_switch_task(arg) ? 0 : -EBUSY;
+}
+
+static DEFINE_PER_CPU(struct cpu_stop_work, klp_stop_work);
+
 /*
  * Sends a fake signal to all non-kthread tasks with TIF_PATCH_PENDING set.
- * Kthreads with TIF_PATCH_PENDING set are woken up.
+ * Kthreads with TIF_PATCH_PENDING set are preempted or woken up.
  */
 static void klp_send_signals(void)
 {
@@ -357,11 +365,22 @@ static void klp_send_signals(void)
 		 * would be meaningless. It is not serious though.
 		 */
 		if (task->flags & PF_KTHREAD) {
-			/*
-			 * Wake up a kthread which sleeps interruptedly and
-			 * still has not been migrated.
-			 */
-			wake_up_state(task, TASK_INTERRUPTIBLE);
+			if (task_curr(task) && klp_have_reliable_stack()) {
+				/*
+				 * kthread is currently running on a CPU; try
+				 * to preempt it.
+				 */
+				stop_one_cpu_nowait(task_cpu(task),
+						    __try_switch_kthread,
+						    task,
+						    this_cpu_ptr(&klp_stop_work));
+			} else {
+				/*
+				 * Wake up a kthread which sleeps interruptedly
+				 * and still has not been migrated.
+				 */
+				wake_up_state(task, TASK_INTERRUPTIBLE);
+			}
 		} else {
 			/*
 			 * Send fake signal to all non-kthread tasks which are
