Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229F267E319
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 12:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbjA0LUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 06:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbjA0LU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 06:20:28 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3C714222;
        Fri, 27 Jan 2023 03:19:13 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2A3AD21889;
        Fri, 27 Jan 2023 11:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674818344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jg6tAtljWkLOtzvKkDNIoiHHgxanNXV1iXTx9cL+UQU=;
        b=utmF3gy7DItB+OI2ZalxyBwjhN8ryT8raie78QEcmelb6Gaa27V6jEgklx42rzficIjadI
        nu+HqyEOKtdYizLCOtQkNWx4S2VvGWugKipxH2r9HOc4bA9hB+YRcYXTY/zW8bW0QlDX7r
        g41e96/5ttY1iEwr1MNKmU14WzKGC0w=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A46122C141;
        Fri, 27 Jan 2023 11:19:03 +0000 (UTC)
Date:   Fri, 27 Jan 2023 12:19:03 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>
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
Message-ID: <Y9OzJzHIASUeIrzO@alley>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9LswwnPAf+nOVFG@do-x1extreme>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 2023-01-26 15:12:35, Seth Forshee (DigitalOcean) wrote:
> On Thu, Jan 26, 2023 at 06:03:16PM +0100, Petr Mladek wrote:
> > On Fri 2023-01-20 16:12:20, Seth Forshee (DigitalOcean) wrote:
> > > We've fairly regularaly seen liveptches which cannot transition within kpatch's
> > > timeout period due to busy vhost worker kthreads.
> > 
> > I have missed this detail. Miroslav told me that we have solved
> > something similar some time ago, see
> > https://lore.kernel.org/all/20220507174628.2086373-1-song@kernel.org/
> 
> Interesting thread. I had thought about something along the lines of the
> original patch, but there are some ideas in there that I hadn't
> considered.

Could you please provide some more details about the test system?
Is there anything important to make it reproducible?

The following aspects come to my mind. It might require:

   + more workers running on the same system
   + have a dedicated CPU for the worker
   + livepatching the function called by work->fn()
   + running the same work again and again
   + huge and overloaded system


> > Honestly, kpatch's timeout 1 minute looks incredible low to me. Note
> > that the transition is tried only once per minute. It means that there
> > are "only" 60 attempts.
> > 
> > Just by chance, does it help you to increase the timeout, please?
> 
> To be honest my test setup reproduces the problem well enough to make
> KLP wait significant time due to vhost threads, but it seldom causes it
> to hit kpatch's timeout.
> 
> Our system management software will try to load a patch tens of times in
> a day, and we've seen real-world cases where patches couldn't load
> within kpatch's timeout for multiple days. But I don't have such an
> environment readily accessible for my own testing. I can try to refine
> my test case and see if I can get it to that point.

My understanding is that you try to load the patch repeatedly but
it always fails after the 1 minute timeout. It means that it always
starts from the beginning (no livepatched process).

Is there any chance to try it with a longer timeout, for example, one
hour? It should increase the chance if there are more problematic kthreads.

> > This low timeout might be useful for testing. But in practice, it does
> > not matter when the transition is lasting one hour or even longer.
> > It takes much longer time to prepare the livepatch.
> 
> Agreed. And to be clear, we cope with the fact that patches may take
> hours or even days to get applied in some cases. The patches I sent are
> just about improving the only case I've identified which has lead to
> kpatch failing to load a patch for a day or longer.

If it is acceptable to wait hours or even days then the 1 minute
timeout is quite contra-productive. We actually do not use any timeout
at all in livepatches provided by SUSE.

Best Regards,
Petr
