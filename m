Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CD367E1CB
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjA0Kh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjA0Kh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:37:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123C2783C4;
        Fri, 27 Jan 2023 02:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PYMi/TarErTQ56/EQtR6VEaKTmJgxRJ5ZbhehxJvDLs=; b=L/qq7559CUAIGrM0xACianESbW
        oKp8PaQUV86AD2w65sfBxeyZ9U5k+h0hXz92WEoTQ1p+fr5w7Ei3D0chC+a1gdRPXW5VRb9PaykvX
        lUTpLhelg9SybB30rCkWBAIxeFmBNpzIy02w5JhhD7zhjOhDYawTiTisrjvNpSY+LljyE0kMLcsSj
        vAkUF/K4pZttFFXnTUFoss9lMbH1S0J3N9u7KFhx/AprHMmz//ef/JpZMNWrbrg+jAcPdD2RrZz5Q
        RZ2RY8+Xgl0k0hiAJWrGdEkvBOiHfa+rn6Cag8/DLn1Q8UPgyAJobMOYeO8WQf7kv3TZS59cQdgFW
        3cUbg2ew==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pLM6T-007cYX-7t; Fri, 27 Jan 2023 10:37:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 26C6C3002BF;
        Fri, 27 Jan 2023 11:37:03 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 099EC20DD8752; Fri, 27 Jan 2023 11:37:03 +0100 (CET)
Date:   Fri, 27 Jan 2023 11:37:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>,
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
Message-ID: <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127044355.frggdswx424kd5dq@treble>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 08:43:55PM -0800, Josh Poimboeuf wrote:
> On Thu, Jan 26, 2023 at 03:12:35PM -0600, Seth Forshee (DigitalOcean) wrote:
> > On Thu, Jan 26, 2023 at 06:03:16PM +0100, Petr Mladek wrote:
> > > On Fri 2023-01-20 16:12:20, Seth Forshee (DigitalOcean) wrote:
> > > > We've fairly regularaly seen liveptches which cannot transition within kpatch's
> > > > timeout period due to busy vhost worker kthreads.
> > > 
> > > I have missed this detail. Miroslav told me that we have solved
> > > something similar some time ago, see
> > > https://lore.kernel.org/all/20220507174628.2086373-1-song@kernel.org/
> > 
> > Interesting thread. I had thought about something along the lines of the
> > original patch, but there are some ideas in there that I hadn't
> > considered.
> 
> Here's another idea, have we considered this?  Have livepatch set
> TIF_NEED_RESCHED on all kthreads to force them into schedule(), and then
> have the scheduler call klp_try_switch_task() if TIF_PATCH_PENDING is
> set.
> 
> Not sure how scheduler folks would feel about that ;-)

So, let me try and page all that back in.... :-)

KLP needs to unwind the stack to see if any of the patched functions are
active, if not, flip task to new set.

Unwinding the stack of a task can be done when:

 - task is inactive (stable reg and stack) -- provided it stays inactive
   while unwinding etc..

 - task is current (guarantees stack doesn't dip below where we started
   due to being busy on top etc..)

Can NOT be done from interrupt context, because can hit in the middle of
setting up stack frames etc..

The issue at hand is that some tasks run for a long time without passing
through an explicit check.

The thread above tried sticking something in cond_resched() which is a
problem for PREEMPT=y since cond_resched() is a no-op.

Preempt notifiers were raised, and those would actually be nice, except
you can only install a notifier on current and you need some memory
allocated per task, which makes it less than ideal. Plus ...

... putting something in finish_task_switch() wouldn't be the end of the
world I suppose, but then you still need to force schedule the task --
imagine it being the only runnable task on the CPU, there's nothing
going to make it actually switch.

Which then leads me to suggest something daft like this.. does that
help?


diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f1b25ec581e0..06746095a724 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -9,6 +9,7 @@
 
 #include <linux/cpu.h>
 #include <linux/stacktrace.h>
+#include <linux/stop_machine.h>
 #include "core.h"
 #include "patch.h"
 #include "transition.h"
@@ -334,6 +335,16 @@ static bool klp_try_switch_task(struct task_struct *task)
 	return !ret;
 }
 
+static int __stop_try_switch(void *arg)
+{
+	return klp_try_switch_task(arg) ? 0 : -EBUSY;
+}
+
+static bool klp_try_switch_task_harder(struct task_struct *task)
+{
+	return !stop_one_cpu(task_cpu(task), __stop_try_switch, task);
+}
+
 /*
  * Sends a fake signal to all non-kthread tasks with TIF_PATCH_PENDING set.
  * Kthreads with TIF_PATCH_PENDING set are woken up.

