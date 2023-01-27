Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69DA67E8BC
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbjA0O5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjA0O5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:57:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D174487;
        Fri, 27 Jan 2023 06:57:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7069AB80AEB;
        Fri, 27 Jan 2023 14:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE60C433EF;
        Fri, 27 Jan 2023 14:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674831461;
        bh=9oICS0asxu5pqOGAnTqYWCY4ccjHnFUSU4M1Tn50WgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nN+vviyBqLV/jR3XG1JSM2Cx4QFTyz+9OW/bDim9RT92HgOJYEH3IutWkLN6sbXeS
         Hgd5D5xaniSuHsKg4XJYmUni90Pgj+f8ZnDpKsojX0xRTbyAMmMQoZRJci/33N4WuU
         fX2NkOFdOzQ2qWybwwAFPCUTS3/Ufa1O2bSTbewTSV4/OFpNAwkfxjv6pmwuRUKqpc
         Z/GOPE7yc/+/hcCC7QY9d47lcnpkIqB+FofcmoVFkG6Xn+lPaeDfatQMC1AXbLTT8d
         q+o5GU18cAvSLfBDODTfwZ1W5oYNrFe2UWjMUrFkb4YBAu5iFahxPjYPDjumhTUvJl
         zodV1RBIyz5nw==
Date:   Fri, 27 Jan 2023 08:57:40 -0600
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
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <Y9PmZFBEwUBwV3s/@do-x1extreme>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <Y9OzJzHIASUeIrzO@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9OzJzHIASUeIrzO@alley>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 12:19:03PM +0100, Petr Mladek wrote:
> On Thu 2023-01-26 15:12:35, Seth Forshee (DigitalOcean) wrote:
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
> Could you please provide some more details about the test system?
> Is there anything important to make it reproducible?
> 
> The following aspects come to my mind. It might require:
> 
>    + more workers running on the same system
>    + have a dedicated CPU for the worker
>    + livepatching the function called by work->fn()
>    + running the same work again and again
>    + huge and overloaded system

I'm isolating a CPU, starting a KVM guest with a virtio-net device, and
setting the affinity of the vhost worker thread to only the isolated
CPU. Thus the vhost-worker thread has a dedicated CPU, as you say. (I'll
note that in real-world cases the systems have many CPUs, and while the
vhost threads aren't each given a dedicated CPU, if the system load is
light enough a thread can end up with exlusive use of a CPU).

Then all I do is run iperf between the guest and the host with several
parallel streams. I seem to be hitting the limits of the guest vCPUs
before the vhost thread is fully saturated, as this gets it to about 90%
CPU utilization by the vhost thread.

> > > Honestly, kpatch's timeout 1 minute looks incredible low to me. Note
> > > that the transition is tried only once per minute. It means that there
> > > are "only" 60 attempts.
> > > 
> > > Just by chance, does it help you to increase the timeout, please?
> > 
> > To be honest my test setup reproduces the problem well enough to make
> > KLP wait significant time due to vhost threads, but it seldom causes it
> > to hit kpatch's timeout.
> > 
> > Our system management software will try to load a patch tens of times in
> > a day, and we've seen real-world cases where patches couldn't load
> > within kpatch's timeout for multiple days. But I don't have such an
> > environment readily accessible for my own testing. I can try to refine
> > my test case and see if I can get it to that point.
> 
> My understanding is that you try to load the patch repeatedly but
> it always fails after the 1 minute timeout. It means that it always
> starts from the beginning (no livepatched process).
> 
> Is there any chance to try it with a longer timeout, for example, one
> hour? It should increase the chance if there are more problematic kthreads.

Yes, I can try it. But I think I already mentioned that we are somewhat
limited by our system management software and how livepatch loading is
currently implemented there. I'd need to consult with others about how
long we could make the timeout, but 1 hour is definitely too long under
our current system.

> > > This low timeout might be useful for testing. But in practice, it does
> > > not matter when the transition is lasting one hour or even longer.
> > > It takes much longer time to prepare the livepatch.
> > 
> > Agreed. And to be clear, we cope with the fact that patches may take
> > hours or even days to get applied in some cases. The patches I sent are
> > just about improving the only case I've identified which has lead to
> > kpatch failing to load a patch for a day or longer.
> 
> If it is acceptable to wait hours or even days then the 1 minute
> timeout is quite contra-productive. We actually do not use any timeout
> at all in livepatches provided by SUSE.

I agree, though I'd still prefer it didn't take days. Based on this
discussion I do plan to look at changing how we load livepatches to make
this possible, but it will take some time.

Thanks,
Seth
