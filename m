Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8984680A34
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbjA3J4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbjA3J4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:56:20 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163ED30B3F;
        Mon, 30 Jan 2023 01:55:49 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8ADDD21A3B;
        Mon, 30 Jan 2023 09:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675072531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wW8PYSjbj1fhy1DHl5je08VWFBPjfFkiep3fm9ftfHQ=;
        b=eHUFE3dP4kCVW2OfnU8v4jOJkOWrkHxqxK4gFtlKv2icSzUiJyeFQ3OYS3ZIadLRUXWOEv
        rhCRsRIRAD5eh6Q3o+nbnyNl1fzrHwsBfh5gSz04qjRP7dmEWwXd2KbY8HwVDLgJIUGlhh
        vWP8AVHea583RzvUzoRGge0KMOU5ntg=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 64E7E2C141;
        Mon, 30 Jan 2023 09:55:31 +0000 (UTC)
Date:   Mon, 30 Jan 2023 10:55:28 +0100
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
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <Y9eUEGu+wC5dm0JI@alley>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <Y9OzJzHIASUeIrzO@alley>
 <Y9PmZFBEwUBwV3s/@do-x1extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9PmZFBEwUBwV3s/@do-x1extreme>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 2023-01-27 08:57:40, Seth Forshee wrote:
> On Fri, Jan 27, 2023 at 12:19:03PM +0100, Petr Mladek wrote:
> > Could you please provide some more details about the test system?
> > Is there anything important to make it reproducible?
> > 
> > The following aspects come to my mind. It might require:
> > 
> >    + more workers running on the same system
> >    + have a dedicated CPU for the worker
> >    + livepatching the function called by work->fn()
> >    + running the same work again and again
> >    + huge and overloaded system
> 
> I'm isolating a CPU, starting a KVM guest with a virtio-net device, and
> setting the affinity of the vhost worker thread to only the isolated
> CPU. Thus the vhost-worker thread has a dedicated CPU, as you say. (I'll
> note that in real-world cases the systems have many CPUs, and while the
> vhost threads aren't each given a dedicated CPU, if the system load is
> light enough a thread can end up with exlusive use of a CPU).
> 
> Then all I do is run iperf between the guest and the host with several
> parallel streams. I seem to be hitting the limits of the guest vCPUs
> before the vhost thread is fully saturated, as this gets it to about 90%
> CPU utilization by the vhost thread.

Thanks for the info!

> > > > Honestly, kpatch's timeout 1 minute looks incredible low to me. Note
> > > > that the transition is tried only once per minute. It means that there
> > > > are "only" 60 attempts.
> > > > 
> > > > Just by chance, does it help you to increase the timeout, please?
> > > 
> > > To be honest my test setup reproduces the problem well enough to make
> > > KLP wait significant time due to vhost threads, but it seldom causes it
> > > to hit kpatch's timeout.
> > > 
> > > Our system management software will try to load a patch tens of times in
> > > a day, and we've seen real-world cases where patches couldn't load
> > > within kpatch's timeout for multiple days. But I don't have such an
> > > environment readily accessible for my own testing. I can try to refine
> > > my test case and see if I can get it to that point.
> > 
> > My understanding is that you try to load the patch repeatedly but
> > it always fails after the 1 minute timeout. It means that it always
> > starts from the beginning (no livepatched process).
> > 
> > Is there any chance to try it with a longer timeout, for example, one
> > hour? It should increase the chance if there are more problematic kthreads.
> 
> Yes, I can try it. But I think I already mentioned that we are somewhat
> limited by our system management software and how livepatch loading is
> currently implemented there. I'd need to consult with others about how
> long we could make the timeout, but 1 hour is definitely too long under
> our current system.

Another possibility is to do not wait at all. SUSE livepatch packages load
the livepatch module, remove not longer used livepatch modules and are
done with it.

Note that the module is loaded quickly. The transition is finished
asynchronously using workqueues.

Of course, there is a risk that the transition will never finish.
It would prevent loading any newer livepatch. But it might be handled
when the the newer livepatch is loaded. It might revert the pending
transition, ...

Of course, it would be great to make the transition more reliable.
It would be nice to add the hook into the scheduler as discussed
in another branch of this thread. But it might bring another problems,
for example, affect the system performance. Well, it probably can
be optimized or ratelimited.

Anyway, I wanted to say that there is a way to get rid of the timeout
completely.

Best Regards,
Petr
