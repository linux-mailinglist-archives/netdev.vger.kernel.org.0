Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69B26D58D7
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbjDDGja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbjDDGj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:39:29 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D081BF3
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 23:39:25 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pjaJz-00C5Ic-AT; Tue, 04 Apr 2023 14:39:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Apr 2023 14:39:11 +0800
Date:   Tue, 4 Apr 2023 14:39:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <ZCvGDxW+HkcHYaU/@gondor.apana.org.au>
References: <20230401051221.3160913-1-kuba@kernel.org>
 <20230401051221.3160913-2-kuba@kernel.org>
 <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com>
 <20230401115854.371a5b4c@kernel.org>
 <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 08:18:04AM -0700, Alexander Duyck wrote:
>
> > I *think* that the right ordering would be:
> >
> > WRITE cons
> > mb()  # A
> > READ stopped
> > rmb() # C
> > READ prod, cons
> 
> What would the extra rmb() get you? The mb() will have already flushed
> out any writes and if stopped is set the tail should have already been
> written before setting it.
> 
> One other thing to keep in mind is that the wake gives itself a pretty
> good runway. We are talking about enough to transmit at least 2
> frames. So if another consumer is stopping it we aren't waking it
> unless there is enough space for yet another frame after the current
> consumer.
> 
> > And on the producer side (existing):
> >
> > WRITE prod
> > READ prod, cons
> > mb()  # B
> > WRITE stopped
> > READ prod, cons
> >
> > But I'm slightly afraid to change it, it's been working for over
> > a decade :D
> 
> I wouldn't change it. The code has predated BQL in the e1000 driver
> and has been that way since the inception of it I believe in 2.6.19.

Thanks for adding me to this thread as otherwise I would've surely
missed it.

I see where the confusion is coming from.  The key is that we weren't
trying to stop every single race, because not all of them are fatal.

In particular, we tolerate the race where a wake is done when it
shouldn't be because the network stack copes with that by requeueing
the skb onto the qdisc.

So it's a trade-off.  We could make our code water-tight, but then
we would be incurring a penalty for every skb.  With our current
approach, the penalty is only incurred in the unlikely event of a
race which results in the unlucky skb being requeued.

The race that we do want to stop is a queue being stuck in a stopped
state when it shouldn't because that indeed is fatal.

Going back to the proposed helpers, we only need one mb because
that's all we need to fix the stuck/stopped queue race.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
