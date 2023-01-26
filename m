Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16ADF67CA40
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 12:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237367AbjAZLt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 06:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbjAZLt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 06:49:28 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E98D3FF21;
        Thu, 26 Jan 2023 03:49:26 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5E8441FF3F;
        Thu, 26 Jan 2023 11:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674733765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XxsY7YJivcVXv/JzbSrqly22j3+hrQ/gP/mZJ85hOmM=;
        b=PFl31VywpTHBZGWIgd9uRk3v2XHk0OLkw48lxQB/Gf3mKcK58iqtZ3FZUImQd8Nyga0fYC
        I05ylbJXSO1YY7P958zJ2LoobK/Eawt+RRMwuU1lwWEjpe2OrTfaHDDtPazu5rH1A6XY3E
        N8Jrtmby4uUXUY6wJs3SPw1ZmNSAW9g=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3A4912C141;
        Thu, 26 Jan 2023 11:49:25 +0000 (UTC)
Date:   Thu, 26 Jan 2023 12:49:24 +0100
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
Message-ID: <Y9JoxAHLplZoVPea@alley>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <20230120-vhost-klp-switching-v1-2-7c2b65519c43@kernel.org>
 <Y8/ohzRGcOiqsh69@alley>
 <Y9ATo5FukOhphwqT@do-x1extreme>
 <Y9ETwsT4LTXyH/0m@alley>
 <Y9FfenH/p3qzRlar@do-x1extreme>
 <Y9JhEJXFRDZjONAH@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9JhEJXFRDZjONAH@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 2023-01-26 12:16:36, Petr Mladek wrote:
> On Wed 2023-01-25 10:57:30, Seth Forshee wrote:
> > On Wed, Jan 25, 2023 at 12:34:26PM +0100, Petr Mladek wrote:
> > > On Tue 2023-01-24 11:21:39, Seth Forshee wrote:
> > > > On Tue, Jan 24, 2023 at 03:17:43PM +0100, Petr Mladek wrote:
> > > > > On Fri 2023-01-20 16:12:22, Seth Forshee (DigitalOcean) wrote:
> > > > > > Livepatch relies on stack checking of sleeping tasks to switch kthreads,
> > > > > > so a busy kthread can block a livepatch transition indefinitely. We've
> > > > > > seen this happen fairly often with busy vhost kthreads.
> > > > > 
> > > > > > --- a/drivers/vhost/vhost.c
> > > > > > +++ b/drivers/vhost/vhost.c
> > > > > > @@ -366,6 +367,9 @@ static int vhost_worker(void *data)
> > > > > >  			if (need_resched())
> > > > > >  				schedule();
> > > > > >  		}
> > > > > > +
> > > > > > +		if (unlikely(klp_patch_pending(current)))
> > > > > > +			klp_switch_current();
> > > > > 
> > > > > I suggest to use the following intead:
> > > > > 
> > > > > 		if (unlikely(klp_patch_pending(current)))
> > > > > 			klp_update_patch_state(current);
> > > > > 
> > > > > We already use this in do_idle(). The reason is basically the same.
> > > > > It is almost impossible to livepatch the idle task when a CPU is
> > > > > very idle.
> > > > > 
> > > > Let's say that a livepatch is loaded which replaces vhost_worker(). New
> > > > vhost worker threads are started which use the replacement function. Now
> > > > if the patch is disabled, these new worker threads would be switched
> > > > despite still running the code from the patch module, correct? Could the
> > > > module then be unloaded, freeing the memory containing the code these
> > > > kthreads are executing?
> > > 
> > > Hmm, the same problem might be when we livepatch a function that calls
> > > another function that calls klp_update_patch_state(). But in this case
> > > it would be kthread() from kernel/kthread.c. It would affect any
> > > running kthread. I doubt that anyone would seriously think about
> > > livepatching this function.

And I missed something. klp_update_patch_state_safe(), proposed below,
would not cover the above scenario.

It might be possible to add something similar to kthread()
function. I think that it is the only "livepatchable" function
that might call vhost_worker(). We could block
klp_update_patch_state() for the entire kthread when the kthread()
function is called from a livepatch.

Well, it is all just the best effort. The reference counting in
the ftrace handler would be more reliable. But it would require
adding the trampoline on the return.

> /**
>  * klp_update_patch_state_safe() - do not update the path state when
>  *	called from a livepatch.
>  * @task: task_struct to be updated
>  * @calller_addr: address of the function which  calls this one
>  *
>  * Do not update the patch set when called from a livepatch.
>  * It would allow to remove the livepatch module even when
>  * the code still might be in use.
>  */
> void klp_update_patch_state_safe(struct task_struct *task, void *caller_addr)
> {
> 	static bool checked;
> 	static bool safe;
> 
> 	if (unlikely(!checked)) {
> 		struct module *mod;
> 
> 		preempt_disable();
> 		mod = __module_address(caller_addr);
> 		if (!mod || !is_livepatch_module(mod))
> 			safe = true;
> 		checked = true;
> 		preempt_enable();
> 	}
> 
> 	if (safe)
> 		klp_update_patch_state(task);
> }
> 
> and use in vhost_worker()
> 
> 		if (unlikely(klp_patch_pending(current)))
> 			klp_update_patch_state_safe(current, vhost_worker);
> 
> Even better might be to get the caller address using some compiler
> macro. I guess that it should be possible.
> 
> And even better would be to detect this at the compile time. But
> I do not know how to do so.
> 
> > Okay, I can send a v2 which does this, so long as it's okay to export
> > klp_update_patch_state() to modules.
> 
> It would be acceptable for me if we added a warning above the function
> definition and into the livepatch documentation.

I would probably go this way after all. Still thinking...

Best Regards,
Petr
