Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A264E67C990
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 12:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbjAZLQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 06:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbjAZLQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 06:16:39 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A18270B;
        Thu, 26 Jan 2023 03:16:36 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E25A31FF65;
        Thu, 26 Jan 2023 11:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674731794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VqvJ//mtxUzAL+qZwt9BocGJmjBDoQtWDsm6f0RHcJw=;
        b=brCnbvCw0yFj2KB2XLQOvhzBW6Pnv5+JFss008p+DODbsTxFtCHWxo09XShJcZe3aG8Xg8
        BfRTj2syQl/6yCyoMx/mZorf14W6aVLJvmfyfQs/BnHno/9Krlm5Qys3TD57sskrGWFsqp
        n7zaBtnzD4oinqFzvBdPIGyKD4DlvDY=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B2CC52C141;
        Thu, 26 Jan 2023 11:16:34 +0000 (UTC)
Date:   Thu, 26 Jan 2023 12:16:32 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Seth Forshee <sforshee@kernel.org>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost: check for pending livepatches from vhost
 worker kthreads
Message-ID: <Y9JhEJXFRDZjONAH@alley>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <20230120-vhost-klp-switching-v1-2-7c2b65519c43@kernel.org>
 <Y8/ohzRGcOiqsh69@alley>
 <Y9ATo5FukOhphwqT@do-x1extreme>
 <Y9ETwsT4LTXyH/0m@alley>
 <Y9FfenH/p3qzRlar@do-x1extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9FfenH/p3qzRlar@do-x1extreme>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2023-01-25 10:57:30, Seth Forshee wrote:
> On Wed, Jan 25, 2023 at 12:34:26PM +0100, Petr Mladek wrote:
> > On Tue 2023-01-24 11:21:39, Seth Forshee wrote:
> > > On Tue, Jan 24, 2023 at 03:17:43PM +0100, Petr Mladek wrote:
> > > > On Fri 2023-01-20 16:12:22, Seth Forshee (DigitalOcean) wrote:
> > > > > Livepatch relies on stack checking of sleeping tasks to switch kthreads,
> > > > > so a busy kthread can block a livepatch transition indefinitely. We've
> > > > > seen this happen fairly often with busy vhost kthreads.
> > > > 
> > > > > --- a/drivers/vhost/vhost.c
> > > > > +++ b/drivers/vhost/vhost.c
> > > > > @@ -366,6 +367,9 @@ static int vhost_worker(void *data)
> > > > >  			if (need_resched())
> > > > >  				schedule();
> > > > >  		}
> > > > > +
> > > > > +		if (unlikely(klp_patch_pending(current)))
> > > > > +			klp_switch_current();
> > > > 
> > > > I suggest to use the following intead:
> > > > 
> > > > 		if (unlikely(klp_patch_pending(current)))
> > > > 			klp_update_patch_state(current);
> > > > 
> > > > We already use this in do_idle(). The reason is basically the same.
> > > > It is almost impossible to livepatch the idle task when a CPU is
> > > > very idle.
> > > > 
> > > > klp_update_patch_state(current) does not check the stack.
> > > > It switches the task immediately.
> > > > 
> > > > It should be safe because the kthread never leaves vhost_worker().
> > > > It means that the same kthread could never re-enter this function
> > > > and use the new code.
> > > 
> > > My knowledge of livepatching internals is fairly limited, so I'll accept
> > > it if you say that it's safe to do it this way. But let me ask about one
> > > scenario.
> > > 
> > > Let's say that a livepatch is loaded which replaces vhost_worker(). New
> > > vhost worker threads are started which use the replacement function. Now
> > > if the patch is disabled, these new worker threads would be switched
> > > despite still running the code from the patch module, correct? Could the
> > > module then be unloaded, freeing the memory containing the code these
> > > kthreads are executing?
> > 
> > The above scenario would require calling klp_update_patch_state() from
> > the code in the livepatch module. It is not possible at the moment because
> > this function is not exported for modules.
> 
> vhost can be built as a module, so in order to call
> klp_update_patch_state() from vhost_worker() it would have to be
> exported to modules.

I see.

> > Hmm, the same problem might be when we livepatch a function that calls
> > another function that calls klp_update_patch_state(). But in this case
> > it would be kthread() from kernel/kthread.c. It would affect any
> > running kthread. I doubt that anyone would seriously think about
> > livepatching this function.
> 
> Yes, there are clearly certain functions that are not safe/practical to
> patch, and authors need to know what they are doing. Most kthread main()
> functions probably qualify as impractical at best, at least without a
> strategy to restart relevant kthreads.
> 
> But a livepatch transition will normally stall if patching these
> functions when a relevant kthread is running (unless the patch is
> forced), so a patch author who made a mistake should quickly notice.
> vhost_worker() would behave differently.

Another crazy idea:

/**
 * klp_update_patch_state_safe() - do not update the path state when
 *	called from a livepatch.
 * @task: task_struct to be updated
 * @calller_addr: address of the function which  calls this one
 *
 * Do not update the patch set when called from a livepatch.
 * It would allow to remove the livepatch module even when
 * the code still might be in use.
 */
void klp_update_patch_state_safe(struct task_struct *task, void *caller_addr)
{
	static bool checked;
	static bool safe;

	if (unlikely(!checked)) {
		struct module *mod;

		preempt_disable();
		mod = __module_address(caller_addr);
		if (!mod || !is_livepatch_module(mod))
			safe = true;
		checked = true;
		preempt_enable();
	}

	if (safe)
		klp_update_patch_state(task);
}

and use in vhost_worker()

		if (unlikely(klp_patch_pending(current)))
			klp_update_patch_state_safe(current, vhost_worker);

Even better might be to get the caller address using some compiler
macro. I guess that it should be possible.

And even better would be to detect this at the compile time. But
I do not know how to do so.

> > A good enough solution might be to document this. Livepatches could
> > not be created blindly. There are more situations where the
> > livepatch is tricky or not possible at all.
> 
> I can add this if you like. Is Documentation/livepatch/livepatch.rst the
> right place for this?

Yes, the best place probably would be "7. Limitations" section in
Documentation/livepatch/livepatch.rst.

Even better would be to add a document about the best practices.
We have dreamed about it for years ;-)

> > Crazy idea. We could prevent this problem even technically. A solution
> > would be to increment a per-process counter in klp_ftrace_handler() when a
> > function is redirected(). And klp_update_patch_state() might refuse
> > the migration when this counter is not zero. But it would require
> > to use a trampoline on return that would decrement the counter.
> > I am not sure if this is worth the complexity.
> > 
> > One the other hand, this counter might actually remove the need
> > of the reliable backtrace. It is possible that I miss something
> > or that it is not easy/possible to implement the return trampoline.
> 
> I agree this should work for unpatching, and even for patching a
> function which is already patched.
> 
> Maybe I'm misunderstanding, but this would only work for unpatching or
> patching an already-patched function, wouldn't it? Because the original
> functions would not increment the counter so you would not know if tasks
> still had those on their call stacks.

Right. I knew that it could not be that easy. Otherwise, we would have
used it. I just did not spent enough cycles on the idea yesterday.

> > Back to the original problem. I still consider calling
> > klp_update_patch_state(current) in vhost_worker() safe.
> 
> Okay, I can send a v2 which does this, so long as it's okay to export
> klp_update_patch_state() to modules.

It would be acceptable for me if we added a warning above the function
definition and into the livepatch documentation.

But I would prefer klp_update_patch_state_safe() if it worked. It is
possible that I have missed something.

Best Regards,
Petr
