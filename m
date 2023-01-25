Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A9067B16D
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 12:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbjAYLes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 06:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbjAYLeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 06:34:31 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874088E;
        Wed, 25 Jan 2023 03:34:30 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 26FFB1FD87;
        Wed, 25 Jan 2023 11:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674646469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l49gqrR00YStom+4XbW1P7OXxNNfJs2Zagbrz3cxZDY=;
        b=pTPV48ccsT35BHMOK1sMKdn9C2GwooatjjrH9AG3y4DLkRYKxLgTungIRgVixtSoT/oTI7
        woGGottIqQtagTebAP0C3aYeI+CJUFAZI+E8AKxN9K2BTe+2UjhTJJIVLyw/f4/HVOHl/Y
        BaQIEOw585ptaepsLrRy58308FjTRts=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0223E2C141;
        Wed, 25 Jan 2023 11:34:28 +0000 (UTC)
Date:   Wed, 25 Jan 2023 12:34:26 +0100
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
Message-ID: <Y9ETwsT4LTXyH/0m@alley>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <20230120-vhost-klp-switching-v1-2-7c2b65519c43@kernel.org>
 <Y8/ohzRGcOiqsh69@alley>
 <Y9ATo5FukOhphwqT@do-x1extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9ATo5FukOhphwqT@do-x1extreme>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2023-01-24 11:21:39, Seth Forshee wrote:
> On Tue, Jan 24, 2023 at 03:17:43PM +0100, Petr Mladek wrote:
> > On Fri 2023-01-20 16:12:22, Seth Forshee (DigitalOcean) wrote:
> > > Livepatch relies on stack checking of sleeping tasks to switch kthreads,
> > > so a busy kthread can block a livepatch transition indefinitely. We've
> > > seen this happen fairly often with busy vhost kthreads.
> > 
> > To be precise, it would be "indefinitely" only when the kthread never
> > sleeps.
> > 
> > But yes. I believe that the problem is real. It might be almost
> > impossible to livepatch some busy kthreads, especially when they
> > have a dedicated CPU.
> > 
> > 
> > > Add a check to call klp_switch_current() from vhost_worker() when a
> > > livepatch is pending. In testing this allowed vhost kthreads to switch
> > > immediately when they had previously blocked livepatch transitions for
> > > long periods of time.
> > > 
> > > Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> > > ---
> > >  drivers/vhost/vhost.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index cbe72bfd2f1f..d8624f1f2d64 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -366,6 +367,9 @@ static int vhost_worker(void *data)
> > >  			if (need_resched())
> > >  				schedule();
> > >  		}
> > > +
> > > +		if (unlikely(klp_patch_pending(current)))
> > > +			klp_switch_current();
> > 
> > I suggest to use the following intead:
> > 
> > 		if (unlikely(klp_patch_pending(current)))
> > 			klp_update_patch_state(current);
> > 
> > We already use this in do_idle(). The reason is basically the same.
> > It is almost impossible to livepatch the idle task when a CPU is
> > very idle.
> > 
> > klp_update_patch_state(current) does not check the stack.
> > It switches the task immediately.
> > 
> > It should be safe because the kthread never leaves vhost_worker().
> > It means that the same kthread could never re-enter this function
> > and use the new code.
> 
> My knowledge of livepatching internals is fairly limited, so I'll accept
> it if you say that it's safe to do it this way. But let me ask about one
> scenario.
> 
> Let's say that a livepatch is loaded which replaces vhost_worker(). New
> vhost worker threads are started which use the replacement function. Now
> if the patch is disabled, these new worker threads would be switched
> despite still running the code from the patch module, correct? Could the
> module then be unloaded, freeing the memory containing the code these
> kthreads are executing?

Great catch! Yes, this might theoretically happen.

The above scenario would require calling klp_update_patch_state() from
the code in the livepatch module. It is not possible at the moment because
this function is not exported for modules.

Hmm, the same problem might be when we livepatch a function that calls
another function that calls klp_update_patch_state(). But in this case
it would be kthread() from kernel/kthread.c. It would affect any
running kthread. I doubt that anyone would seriously think about
livepatching this function.

A good enough solution might be to document this. Livepatches could
not be created blindly. There are more situations where the
livepatch is tricky or not possible at all.

Crazy idea. We could prevent this problem even technically. A solution
would be to increment a per-process counter in klp_ftrace_handler() when a
function is redirected(). And klp_update_patch_state() might refuse
the migration when this counter is not zero. But it would require
to use a trampoline on return that would decrement the counter.
I am not sure if this is worth the complexity.

One the other hand, this counter might actually remove the need
of the reliable backtrace. It is possible that I miss something
or that it is not easy/possible to implement the return trampoline.


Back to the original problem. I still consider calling
klp_update_patch_state(current) in vhost_worker() safe.

Best Regards,
Petr
