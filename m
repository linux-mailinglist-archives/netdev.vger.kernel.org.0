Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868A36D5110
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 21:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjDCTDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 15:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDCTDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 15:03:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349B01FFB
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 12:03:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98F1762830
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 19:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA24C433EF;
        Mon,  3 Apr 2023 19:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680548627;
        bh=UubKU2zzUXHQZthP7jGnI+njJFtnPLZpAvVHXC4BHAg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tawr6w32mqXRCxojKV6CmlQb67EDQt1P5TTSCAfnTQnikAif56AQldVYmRCSA7PG0
         D2QsCJBfcG7AuzTl5NS46Df/D1Gctzn5K/5lAyc5Kc5UaQtRQrC7ByNAtfJwYvQ7TJ
         U+nfTa/z7VciWn2pEgp3l2CLwTFx/Lxn3INbQCVsUgcT9jPuy8emQ9zAoagZLo6+KY
         pmEjkavuo9vAsJD48BRE5DoGZ003M239chy0Lt0YYfC0Bje3U0oNkrP3diSt+dzDgs
         8VrMh7XNuqfbYhRDG4qabyurBpba0hhRWDuVezb28/Sgvo1/cgJiTBXx1THuBWq9oY
         Tj77LQ3se1E+w==
Date:   Mon, 3 Apr 2023 12:03:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230403120345.0c02232c@kernel.org>
In-Reply-To: <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
References: <20230401051221.3160913-1-kuba@kernel.org>
        <20230401051221.3160913-2-kuba@kernel.org>
        <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com>
        <20230401115854.371a5b4c@kernel.org>
        <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
        <20230403085601.44f04cd2@kernel.org>
        <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
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

On Mon, 3 Apr 2023 11:11:35 -0700 Alexander Duyck wrote:
> On Mon, Apr 3, 2023 at 8:56=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
> > I don't think in terms of flushes. Let me add line numbers to the
> > producer and the consumer.
> >
> >  c1. WRITE cons
> >  c2. mb()  # A
> >  c3. READ stopped
> >  c4. rmb() # C
> >  c5. READ prod, cons
> >
> >  p1. WRITE prod
> >  p2. READ prod, cons
> >  p3. mb()  # B
> >  p4. WRITE stopped
> >  p5. READ prod, cons
> >
> > The way I think the mb() orders c1 and c3 vs p2 and p4. The rmb()
> > orders c3 and c5 vs p1 and p4. Let me impenitently add Paul.. =20
>=20
> So which function is supposed to be consumer vs producer here?=20

producer is xmit consumer is NAPI

> I think your write stopped is on the wrong side of the memory barrier.=20
> It should be writing prod and stopped both before the barrier.

Indeed, Paul pointed out over chat that we need two barriers there=20
to be correct :( Should be fine in practice, first one is BQL,
second one is on the slow path.

> The maybe/try stop should essentially be:
> 1. write tail
> 2. read prod/cons
> 3. if unused >=3D 1x packet
> 3.a return
>=20
> 4. set stop
> 5. mb()
> 6. Re-read prod/cons
> 7. if unused >=3D 1x packet
> 7.a. test_and_clear stop
>=20
> The maybe/try wake would be:
> 1. write head
> 2. read prod/cons
> 3. if consumed =3D=3D 0 || unused < 2x packet
> 3.a. return
>=20
> 4. mb()
> 5. test_and_clear stop
>=20
> > > One other thing to keep in mind is that the wake gives itself a pretty
> > > good runway. We are talking about enough to transmit at least 2
> > > frames. So if another consumer is stopping it we aren't waking it
> > > unless there is enough space for yet another frame after the current
> > > consumer. =20
> >
> > Ack, the race is very unlikely, basically the completing CPU would have
> > to take an expensive IRQ between checking the descriptor count and
> > checking if stopped -- to let the sending CPU queue multiple frames.
> >
> > But in theory the race is there, right? =20
>=20
> I don't think this is so much a race as a skid. Specifically when we
> wake the queue it will only run for one more packet in such a
> scenario. I think it is being run more like a flow control threshold
> rather than some sort of lock.
>=20
> I think I see what you are getting at though. Basically if the xmit
> function were to cycle several times between steps 3.a and 4 in the
> maybe/try wake it could fill the queue and then trigger the wake even
> though the queue is full and the unused space was already consumed.

Yup, exactly. So we either need to sprinkle a couple more barriers=20
and tests in, or document that the code is only 99.999999% safe=20
against false positive restarts and drivers need to check for ring
full at the beginning of xmit.

I'm quite tempted to add the barriers, because on the NAPI/consumer
side we could use this as an opportunity to start piggy backing on
the BQL barrier.
