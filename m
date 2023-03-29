Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748F86CCF24
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 02:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjC2A4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 20:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjC2A4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 20:56:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23741BFD
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 17:56:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 235FDCE1FD1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 00:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C2CC433D2;
        Wed, 29 Mar 2023 00:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680051362;
        bh=5gNfhrF4BwBedd244FXPmC5oOZasQ9hsi3SRgbU9SYg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DsRzgoYVgbljomD00N/JzA6n4SreRLZ7Vq2ASOCVzDEIvp6MxPSVBV8PSJdtAYcfw
         UD2l8eLtmwgpG+yOo87sdttralcdn5ryG5aDQL7Y740Nno3APgNAGKyGuJHvJ+Znxo
         0nSVIDLj2ow5axo60PYpo5N+DadVelrD9lReuBGxTdxYKJ2yAPnTeHSMLRBCu+AMYc
         CKWqhW9an35sIzXy1pxcljJnHXthBvKrQjam2g3CyexBqbmKuxLI+E/7ermJRVhW/i
         yAr0drTLmPnIZF+G8wcQaUT6poZXfFlFrn6zm7w+3WRaPnXkS3PWrt+sdxdcjDedWR
         35j1zgL9pa8iw==
Date:   Tue, 28 Mar 2023 17:56:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>, pabeni@redhat.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        willemb@google.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230328175601.76574704@kernel.org>
In-Reply-To: <CAKgT0Ufoy2WM3=aMNOdq2PFYL8AH9QSs=QrP_Xx59uouTnKLJg@mail.gmail.com>
References: <20230322233028.269410-1-kuba@kernel.org>
        <5060c11df10c66f56b5ca7ec2ec92333252b084b.camel@gmail.com>
        <20230323200932.7cf30af5@kernel.org>
        <CAKgT0Ufv5Te668Y_tszQfuH0g_Zsn=oErQ8gAfX6FwHRUm+H3A@mail.gmail.com>
        <20230324142820.61e4f0b6@kernel.org>
        <CAKgT0Ufoy2WM3=aMNOdq2PFYL8AH9QSs=QrP_Xx59uouTnKLJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Mar 2023 14:23:07 -0700 Alexander Duyck wrote:
> > > Except this isn't "stop", this is "maybe stop".  
> >
> > So the return value from try_stop and maybe_stop would be different?
> > try_stop needs to return 0 if it stopped - the same semantics as
> > trylock(), AFAIR. Not that I love those semantics, but it's a fairly
> > strong precedent.  
> 
> The problem is this isn't a lock. Ideally with this we aren't taking
> the action. So if anything this functions in my mind more like the
> inverse where if this does stop we have to abort more like trylock
> failing.

No.. for try_stop we are trying to stop.

> This is why I mentioned that maybe this should be renamed. I view this
> more as a check to verify we are good to proceed. In addition there is
> the problem that there are 3 possible outcomes with maybe_stop versus
> the two from try_stop.

I'm open to other names :S

> > > The thing is in order to make this work for the ixgbe patch you didn't
> > > use the maybe_stop instead you went with the try_stop. If you replaced
> > > the ixgbe_maybe_stop_tx with your maybe stop would have to do
> > > something such as the code above to make it work. That is what I am
> > > getting at. From what I can tell the only real difference between
> > > ixgbe_maybe_stop_tx and your maybe_stop is that you avoided having to
> > > move the restart_queue stat increment out.  
> >
> > I can convert ixgbe further, true, but I needed the try_stop, anyway,
> > because bnxt does:
> >
> > if (/* need to stop */) {
> >         if (xmit_more())
> >                 flush_db_write();
> >         netif_tx_queue_try_stop();
> > }
> >
> > which seems reasonable.  
> 
> I wasn't saying we didn't need try_stop. However the logic here
> doesn't care about the return value. In the ixgbe case we track the
> queue restarts so we would want a 0 on success and a non-zero if we
> have to increment the stat. I would be okay with the 0 (success) / -1
> (queue restarted) in this case.
> 
> > > The general thought is I would prefer to keep it so that 0 is the
> > > default most likely case in both where the queue is enabled and is
> > > still enabled. By moving the "take action" items into the 1/-1 values
> > > then it becomes much easier to sort them out with 1 being a stat
> > > increment and -1 being an indication to stop transmitting and prep for
> > > watchdog hang if we don't clear this in the next watchdog period.  
> >
> > Maybe worth taking a step back - the restart stat which ixgbe
> > maintains made perfect sense when you pioneered this approach but
> > I think we had a decade of use, and have kprobes now, so we don't
> > really need to maintain a statistic for a condition with no impact
> > to the user? New driver should not care 1 vs -1..  
> 
> Actually the restart_queue stat is VERY useful for debugging. It tells
> us we are seeing backlogs develop in the Tx queue. We track it any
> time we wake up the queue, not just in the maybe_stop case.
> 
> WIthout that we are then having to break out kprobes and the like
> which we could only add after-the-fact which makes things much harder
> to debug when issues occur. For example, a common case to use it is to
> monitor it when we see a system with slow Tx connections. With that
> stat we can tell if we are building a backlog in the qdisc or if it is
> something else such as a limited amount of socket memory is limiting
> the transmits.

Oh, I missed that wake uses the same stat. Let me clarify - the
stop/start counter is definitely useful. What I thought the restart
counter is counting is just the race cases. I don't think the race
cases are worth counting in any way.

> > > The thought I had with the enum is to more easily connect the outcomes
> > > with the sources. It would also help to prevent any confusion on what
> > > is what. Having the two stop/wake functions return different values is
> > > a potential source for errors since 0/1 means different things in the
> > > different functions. Basically since we have 3 possible outcomes using
> > > the enum would make it very clear what the mapping is between the two.  
> >
> > IMO only two outcomes matter in practice (as mentioned above).
> > I really like the ability to treat the return value as a bool, if only
> > we had negative zero we would have a perfect compromise :(  
> 
> I think we are just thinking about two different things. I am focusing
> on the "maybe" calls that have 3 outcomes whereas I think you are
> mostly focused on the "try" calls. My thought is to treat it something
> like the msix allocation calls where a negative indicates a failure
> forcing us to stop since the ring is full, 0 is a success, and a value
> indicates that there are resources but they are/were limited.

I don't see a strong analogy to PCI resource allocation :(

I prefer to keep the 0 vs non-0 distinction to indicate whether 
the action was performed.

Paolo, Eric, any opinion? Other than the one likely vs unlikely
flip -- is this good enough to merge for you?
