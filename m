Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673226D4CCF
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjDCP4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbjDCP4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:56:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E9DC4
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A210862097
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA889C433D2;
        Mon,  3 Apr 2023 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680537363;
        bh=8aZGOk7ZBO3qh5apPrreGPjVXq+zfqy0mKWfFuSltU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ELxSjFk/9lILzo/ewKGOvD4vvHfKYN3oRObLxmOVp42Nu59P+2iqRnQF2kCIt4x+v
         hPsFsnNYRBy57W5HE7Uk5GRoPuOPSubuTQ8U8V/qmfhn3lPhmVxNsp3jXaFoZT3mW3
         Qm30QwsPG6Vn9rxvXZvM/wSwrie7Mh52T/k1B0R1VIugEzd6MpJdiNXjMNNaMAqBAd
         s9c0jT6ZGML8j8oR9nDdCIkRcJarP8Ze15/sx+C+uEhVY03ksBkHaDBf2abNWjpHHp
         ZWAwnz2k1ccPfrrGQb55HMi5MqZ9eBO7/ZqTmpsPidJ074JzL2vKAvdYxD4zWNlrLD
         +VQw/RN87DMqQ==
Date:   Mon, 3 Apr 2023 08:56:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230403085601.44f04cd2@kernel.org>
In-Reply-To: <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
References: <20230401051221.3160913-1-kuba@kernel.org>
        <20230401051221.3160913-2-kuba@kernel.org>
        <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com>
        <20230401115854.371a5b4c@kernel.org>
        <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 08:18:04 -0700 Alexander Duyck wrote:
> On Sat, Apr 1, 2023 at 11:58=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> =
wrote:
> > > One more question: Don't we need a read memory barrier here to ensure
> > > get_desc is up-to-date? =20
> >
> > CC: Alex, maybe I should not be posting after 10pm, with the missing v2
> > and sparse CC list.. :|
> >
> > I was thinking about this too yesterday. AFAICT this implementation
> > could indeed result in waking even tho the queue is full on non-x86.
> > That's why the drivers have an extra check at the start of .xmit? :( =20
>=20
> The extra check at the start is more historical than anything else.
> Logic like that has been there since the e1000 days. I think it
> addressed items like pktgen which I think didn't make use of the
> stop/wake flags way back when. I'll add in Herbet who was the original
> author for this code so he can add some additional history if needed.

Thanks for the pointer, you weren't kidding with the 2.6.19, that seems
to be when to code was added to e1000 :) Looks fairly similar to the
current code minus the BQL.

> > I *think* that the right ordering would be:
> >
> > c1. WRITE cons
> > c2. mb()  # A
> > c3. READ stopped
> > c4. rmb() # C
> > c5. READ prod, cons =20
>=20
> What would the extra rmb() get you? The mb() will have already flushed
> out any writes and if stopped is set the tail should have already been
> written before setting it.

I don't think in terms of flushes. Let me add line numbers to the
producer and the consumer.

 c1. WRITE cons
 c2. mb()  # A
 c3. READ stopped
 c4. rmb() # C
 c5. READ prod, cons =20

 p1. WRITE prod
 p2. READ prod, cons
 p3. mb()  # B
 p4. WRITE stopped
 p5. READ prod, cons

The way I think the mb() orders c1 and c3 vs p2 and p4. The rmb()
orders c3 and c5 vs p1 and p4. Let me impenitently add Paul..

> One other thing to keep in mind is that the wake gives itself a pretty
> good runway. We are talking about enough to transmit at least 2
> frames. So if another consumer is stopping it we aren't waking it
> unless there is enough space for yet another frame after the current
> consumer.

Ack, the race is very unlikely, basically the completing CPU would have
to take an expensive IRQ between checking the descriptor count and
checking if stopped -- to let the sending CPU queue multiple frames.

But in theory the race is there, right?

> > And on the producer side (existing):
> >
> > p1. WRITE prod
> > p2. READ prod, cons
> > p3. mb()  # B
> > p4. WRITE stopped
> > p5. READ prod, cons
> >
> > But I'm slightly afraid to change it, it's been working for over
> > a decade :D =20
>=20
> I wouldn't change it. The code has predated BQL in the e1000 driver
> and has been that way since the inception of it I believe in 2.6.19.
>=20
> > One neat thing that I noticed, which we could potentially exploit
> > if we were to touch this code is that BQL already has a smp_mb()
> > on the consumer side. So on any kernel config and driver which support
> > BQL we can use that instead of adding another barrier at #A.
> >
> > It would actually be a neat optimization because right now, AFAICT,
> > completion will fire the # A -like barrier almost every time. =20
>=20
> Yeah, the fact is the barrier in the wake path may actually be
> redundant if BQL is enabled. My advice is if you are wanting to get a
> better idea of how this was setup you could take a look at the e1000
> driver in the 2.6.19 kernel as that was where this code originated and
> I am pretty certain it predates anything in any of the other Intel
> drivers other than maybe e100.

