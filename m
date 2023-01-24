Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC02A67A007
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbjAXRVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbjAXRVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:21:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667134A20D;
        Tue, 24 Jan 2023 09:21:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 164B3B81603;
        Tue, 24 Jan 2023 17:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD47C433D2;
        Tue, 24 Jan 2023 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674580900;
        bh=5u0HAqsMO32meB1+2hDlQk/3mQeAC0aecbaZTWGuo+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QjXkTZ0idK5z1Ix6m1yf2oBxsdcJq94aU7EsrAkDisp/SxGulfBdNMOHDckBQCvRz
         W6llnTDs0JyFfXUOfVaSTrQzHB06mjALwb4j+Phm8EDITPUQVpWD5IHsXkZkuoBPtv
         RURIQy6zUHAvCnxo+xVec0gIbsGD27+BhiB5s6a+NXA37TUYzDYw69k0Ue/1GNZ5pA
         e7XeoQuYn4y8JHNQWOTkXCt0qA/tsceHAidqLU0n+M/uxducs+tOJXNBbPy0iCuj6y
         N0r2//PY2LaeDxixTQGxip8Sr7ZhPU0erQFPtHhNXN68HP/JMuxcj/3DvEDYW4dGN9
         YTPE1btkwci6w==
Date:   Tue, 24 Jan 2023 11:21:39 -0600
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
Message-ID: <Y9ATo5FukOhphwqT@do-x1extreme>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <20230120-vhost-klp-switching-v1-2-7c2b65519c43@kernel.org>
 <Y8/ohzRGcOiqsh69@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8/ohzRGcOiqsh69@alley>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 03:17:43PM +0100, Petr Mladek wrote:
> On Fri 2023-01-20 16:12:22, Seth Forshee (DigitalOcean) wrote:
> > Livepatch relies on stack checking of sleeping tasks to switch kthreads,
> > so a busy kthread can block a livepatch transition indefinitely. We've
> > seen this happen fairly often with busy vhost kthreads.
> 
> To be precise, it would be "indefinitely" only when the kthread never
> sleeps.
> 
> But yes. I believe that the problem is real. It might be almost
> impossible to livepatch some busy kthreads, especially when they
> have a dedicated CPU.
> 
> 
> > Add a check to call klp_switch_current() from vhost_worker() when a
> > livepatch is pending. In testing this allowed vhost kthreads to switch
> > immediately when they had previously blocked livepatch transitions for
> > long periods of time.
> > 
> > Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> > ---
> >  drivers/vhost/vhost.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index cbe72bfd2f1f..d8624f1f2d64 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -366,6 +367,9 @@ static int vhost_worker(void *data)
> >  			if (need_resched())
> >  				schedule();
> >  		}
> > +
> > +		if (unlikely(klp_patch_pending(current)))
> > +			klp_switch_current();
> 
> I suggest to use the following intead:
> 
> 		if (unlikely(klp_patch_pending(current)))
> 			klp_update_patch_state(current);
> 
> We already use this in do_idle(). The reason is basically the same.
> It is almost impossible to livepatch the idle task when a CPU is
> very idle.
> 
> klp_update_patch_state(current) does not check the stack.
> It switches the task immediately.
> 
> It should be safe because the kthread never leaves vhost_worker().
> It means that the same kthread could never re-enter this function
> and use the new code.

My knowledge of livepatching internals is fairly limited, so I'll accept
it if you say that it's safe to do it this way. But let me ask about one
scenario.

Let's say that a livepatch is loaded which replaces vhost_worker(). New
vhost worker threads are started which use the replacement function. Now
if the patch is disabled, these new worker threads would be switched
despite still running the code from the patch module, correct? Could the
module then be unloaded, freeing the memory containing the code these
kthreads are executing?

Thanks,
Seth
