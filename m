Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608E36D8A82
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjDEWUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjDEWUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:20:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFDD198
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 15:20:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E114260BFE
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 22:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2A8C433D2;
        Wed,  5 Apr 2023 22:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680733240;
        bh=8WIKf/lhOSq4UZQnUDxG0ueB9hFQUlHsa6oJ0QOxsbY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=BPBP0y7MeU1+bqslSYDftV6gyy9c0YZIx794GGLhWninG2VmkU6tFljGtU/dlIUlZ
         dHkchLtv8Ln0FRRIPqtvyB+8aXT8aAIypVAQs3/0sd7nEjMNS3WzclWgA4QwMqSJG7
         6hSx9MZByBi1Lprp2eChqjg3R+0wCiK6cZ8dIEGcbiLB7A2C2tzEP394gd8sZUzmhS
         +0g0A0RCKtlZp9gXWG/RDRr720pPMKx1VYW3ZCXKyx+VHiGGQs/vszaECAnEGILvqB
         197glgtBNG5phI/J2+fkUjWKTGqt6Fr9G75pTJJDT+s9ab+mdb4XgNlf/9PqyItigI
         gDOVw7x63ZH9g==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id C872515404B4; Wed,  5 Apr 2023 15:20:39 -0700 (PDT)
Date:   Wed, 5 Apr 2023 15:20:39 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <1e9bbdde-df97-4319-a4b7-e426c4351317@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20230401051221.3160913-1-kuba@kernel.org>
 <20230401051221.3160913-2-kuba@kernel.org>
 <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com>
 <20230401115854.371a5b4c@kernel.org>
 <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
 <20230403085601.44f04cd2@kernel.org>
 <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
 <20230403120345.0c02232c@kernel.org>
 <CAKgT0Ue-hEycSyYvVJt0L5Z=373MyNPbgPjFZMA5j2v0hWg0zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKgT0Ue-hEycSyYvVJt0L5Z=373MyNPbgPjFZMA5j2v0hWg0zg@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 01:27:44PM -0700, Alexander Duyck wrote:
> On Mon, Apr 3, 2023 at 12:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 3 Apr 2023 11:11:35 -0700 Alexander Duyck wrote:
> > > On Mon, Apr 3, 2023 at 8:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > I don't think in terms of flushes. Let me add line numbers to the
> > > > producer and the consumer.
> > > >
> > > >  c1. WRITE cons
> > > >  c2. mb()  # A
> > > >  c3. READ stopped
> > > >  c4. rmb() # C
> > > >  c5. READ prod, cons
> > > >
> > > >  p1. WRITE prod
> > > >  p2. READ prod, cons
> > > >  p3. mb()  # B
> > > >  p4. WRITE stopped
> > > >  p5. READ prod, cons
> > > >
> > > > The way I think the mb() orders c1 and c3 vs p2 and p4. The rmb()
> > > > orders c3 and c5 vs p1 and p4. Let me impenitently add Paul..
> > >
> > > So which function is supposed to be consumer vs producer here?
> >
> > producer is xmit consumer is NAPI
> >
> > > I think your write stopped is on the wrong side of the memory barrier.
> > > It should be writing prod and stopped both before the barrier.
> >
> > Indeed, Paul pointed out over chat that we need two barriers there
> > to be correct :( Should be fine in practice, first one is BQL,
> > second one is on the slow path.
> >
> > > The maybe/try stop should essentially be:
> > > 1. write tail
> > > 2. read prod/cons
> > > 3. if unused >= 1x packet
> > > 3.a return
> > >
> > > 4. set stop
> > > 5. mb()
> > > 6. Re-read prod/cons
> > > 7. if unused >= 1x packet
> > > 7.a. test_and_clear stop
> > >
> > > The maybe/try wake would be:
> > > 1. write head
> > > 2. read prod/cons
> > > 3. if consumed == 0 || unused < 2x packet
> > > 3.a. return
> > >
> > > 4. mb()
> > > 5. test_and_clear stop
> > >
> > > > > One other thing to keep in mind is that the wake gives itself a pretty
> > > > > good runway. We are talking about enough to transmit at least 2
> > > > > frames. So if another consumer is stopping it we aren't waking it
> > > > > unless there is enough space for yet another frame after the current
> > > > > consumer.
> > > >
> > > > Ack, the race is very unlikely, basically the completing CPU would have
> > > > to take an expensive IRQ between checking the descriptor count and
> > > > checking if stopped -- to let the sending CPU queue multiple frames.
> > > >
> > > > But in theory the race is there, right?
> > >
> > > I don't think this is so much a race as a skid. Specifically when we
> > > wake the queue it will only run for one more packet in such a
> > > scenario. I think it is being run more like a flow control threshold
> > > rather than some sort of lock.
> > >
> > > I think I see what you are getting at though. Basically if the xmit
> > > function were to cycle several times between steps 3.a and 4 in the
> > > maybe/try wake it could fill the queue and then trigger the wake even
> > > though the queue is full and the unused space was already consumed.
> >
> > Yup, exactly. So we either need to sprinkle a couple more barriers
> > and tests in, or document that the code is only 99.999999% safe
> > against false positive restarts and drivers need to check for ring
> > full at the beginning of xmit.
> >
> > I'm quite tempted to add the barriers, because on the NAPI/consumer
> > side we could use this as an opportunity to start piggy backing on
> > the BQL barrier.
> 
> The thing is the more barriers we add the more it will hurt
> performance. I'd be tempted to just increase the runway we have as we
> could afford a 1 packet skid if we had a 2 packet runway for the
> start/stop thresholds.
> 
> I suspect that is probably why we haven't seen any issues as the
> DESC_NEEDED is pretty generous since it is assuming worst case
> scenarios.

Mightn't preemption or interrupts cause further issues?  Or are preemption
and/or interrupts disabled across the relevant sections of code?

							Thanx, Paul
