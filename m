Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F53B67B789
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 17:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbjAYQ5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 11:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbjAYQ5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 11:57:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B93A12589;
        Wed, 25 Jan 2023 08:57:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B218FCE20BB;
        Wed, 25 Jan 2023 16:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9590EC433D2;
        Wed, 25 Jan 2023 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674665851;
        bh=RjMnbTbIfoWSxtx16I229CedhH4XH1ufxYZp+NhU/kI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mII9TYLC4I7Bo9OMKdjwOy7BL8aCb8EUXhnH7d/sqJylpcSI0SMWJjnYZI1RENIgQ
         /dIF+IMzGiNKLV8r/n8osTPXtim7NzYn0Uz7N0tbkJcEFziyyrDSm+1zIuHiN7DxQo
         LvZ+KdiGJziorG/TTUYKsV5D+dUTAc8T/ke1x0PmOY9fmNILRQd3Jx4ZpPxftSO/mP
         xe0pmGi0gq2nyvo054mrhaOFfM7di6K6dPJvJAeMaS8E6KBv4ij5kKbwL45Ij6eNIa
         ONOFmxIYmIlvb2kkLBvYPhY3SwwfK3Ej9i4vIp9FI0LGGYVv1aeVBoMpIIfUKL/fwG
         ZNBkXXaCy8wLw==
Date:   Wed, 25 Jan 2023 10:57:30 -0600
From:   Seth Forshee <sforshee@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
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
Message-ID: <Y9FfenH/p3qzRlar@do-x1extreme>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <20230120-vhost-klp-switching-v1-2-7c2b65519c43@kernel.org>
 <Y8/ohzRGcOiqsh69@alley>
 <Y9ATo5FukOhphwqT@do-x1extreme>
 <Y9ETwsT4LTXyH/0m@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9ETwsT4LTXyH/0m@alley>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 12:34:26PM +0100, Petr Mladek wrote:
> On Tue 2023-01-24 11:21:39, Seth Forshee wrote:
> > On Tue, Jan 24, 2023 at 03:17:43PM +0100, Petr Mladek wrote:
> > > On Fri 2023-01-20 16:12:22, Seth Forshee (DigitalOcean) wrote:
> > > > Livepatch relies on stack checking of sleeping tasks to switch kthreads,
> > > > so a busy kthread can block a livepatch transition indefinitely. We've
> > > > seen this happen fairly often with busy vhost kthreads.
> > > 
> > > To be precise, it would be "indefinitely" only when the kthread never
> > > sleeps.
> > > 
> > > But yes. I believe that the problem is real. It might be almost
> > > impossible to livepatch some busy kthreads, especially when they
> > > have a dedicated CPU.
> > > 
> > > 
> > > > Add a check to call klp_switch_current() from vhost_worker() when a
> > > > livepatch is pending. In testing this allowed vhost kthreads to switch
> > > > immediately when they had previously blocked livepatch transitions for
> > > > long periods of time.
> > > > 
> > > > Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> > > > ---
> > > >  drivers/vhost/vhost.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index cbe72bfd2f1f..d8624f1f2d64 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -366,6 +367,9 @@ static int vhost_worker(void *data)
> > > >  			if (need_resched())
> > > >  				schedule();
> > > >  		}
> > > > +
> > > > +		if (unlikely(klp_patch_pending(current)))
> > > > +			klp_switch_current();
> > > 
> > > I suggest to use the following intead:
> > > 
> > > 		if (unlikely(klp_patch_pending(current)))
> > > 			klp_update_patch_state(current);
> > > 
> > > We already use this in do_idle(). The reason is basically the same.
> > > It is almost impossible to livepatch the idle task when a CPU is
> > > very idle.
> > > 
> > > klp_update_patch_state(current) does not check the stack.
> > > It switches the task immediately.
> > > 
> > > It should be safe because the kthread never leaves vhost_worker().
> > > It means that the same kthread could never re-enter this function
> > > and use the new code.
> > 
> > My knowledge of livepatching internals is fairly limited, so I'll accept
> > it if you say that it's safe to do it this way. But let me ask about one
> > scenario.
> > 
> > Let's say that a livepatch is loaded which replaces vhost_worker(). New
> > vhost worker threads are started which use the replacement function. Now
> > if the patch is disabled, these new worker threads would be switched
> > despite still running the code from the patch module, correct? Could the
> > module then be unloaded, freeing the memory containing the code these
> > kthreads are executing?
> 
> Great catch! Yes, this might theoretically happen.
> 
> The above scenario would require calling klp_update_patch_state() from
> the code in the livepatch module. It is not possible at the moment because
> this function is not exported for modules.

vhost can be built as a module, so in order to call
klp_update_patch_state() from vhost_worker() it would have to be
exported to modules.

> Hmm, the same problem might be when we livepatch a function that calls
> another function that calls klp_update_patch_state(). But in this case
> it would be kthread() from kernel/kthread.c. It would affect any
> running kthread. I doubt that anyone would seriously think about
> livepatching this function.

Yes, there are clearly certain functions that are not safe/practical to
patch, and authors need to know what they are doing. Most kthread main()
functions probably qualify as impractical at best, at least without a
strategy to restart relevant kthreads.

But a livepatch transition will normally stall if patching these
functions when a relevant kthread is running (unless the patch is
forced), so a patch author who made a mistake should quickly notice.
vhost_worker() would behave differently.

> A good enough solution might be to document this. Livepatches could
> not be created blindly. There are more situations where the
> livepatch is tricky or not possible at all.

I can add this if you like. Is Documentation/livepatch/livepatch.rst the
right place for this?

> Crazy idea. We could prevent this problem even technically. A solution
> would be to increment a per-process counter in klp_ftrace_handler() when a
> function is redirected(). And klp_update_patch_state() might refuse
> the migration when this counter is not zero. But it would require
> to use a trampoline on return that would decrement the counter.
> I am not sure if this is worth the complexity.
> 
> One the other hand, this counter might actually remove the need
> of the reliable backtrace. It is possible that I miss something
> or that it is not easy/possible to implement the return trampoline.

I agree this should work for unpatching, and even for patching a
function which is already patched.

Maybe I'm misunderstanding, but this would only work for unpatching or
patching an already-patched function, wouldn't it? Because the original
functions would not increment the counter so you would not know if tasks
still had those on their call stacks.

> Back to the original problem. I still consider calling
> klp_update_patch_state(current) in vhost_worker() safe.

Okay, I can send a v2 which does this, so long as it's okay to export
klp_update_patch_state() to modules.

Thanks,
Seth
