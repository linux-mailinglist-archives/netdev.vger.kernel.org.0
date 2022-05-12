Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6478525022
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355327AbiELOdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355323AbiELOdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:33:15 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFDE5D658;
        Thu, 12 May 2022 07:33:12 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 17689200007;
        Thu, 12 May 2022 14:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652365991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kQGf/pfnwu+I0vrdR7hix++6edQt9UhWICINb5ti9Q=;
        b=IRXcT8Af6A+WM4wxGrOoXZLCowEaYxEpBw3YHhqLZcl8uayCPNKL0skfZWPsTKx9P2SHXs
        m84xzfCko/4r4X8QVsgMFgkdTYY0nJE1ecd1bqS9EhPAN1PEce6KZRBBBPMEEyRrb4KSS5
        AxNcoo+TK2DI/OKAKwUBiykwjHfAYafpx9p0nL8bvOY2S9jQ6PygeplzGQPEQKkhchL34n
        hy1A0Ym/3837cKVSdZTstjnujOm9d+UD+BDb2qBdLcBTPAdWPq22GFmzftm0i3ZXzgjPBm
        w33iz3n/fxBI+2l6d7HTCItGBr1yZhEtn2FRG0HwKpwr8A4Wx4TehkHvLmAhhg==
Date:   Thu, 12 May 2022 16:33:07 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 06/11] net: mac802154: Hold the transmit queue
 when relevant
Message-ID: <20220512163307.540d635d@xps13>
In-Reply-To: <CAK-6q+jeubhGah2gG1JJxfmOW=sNdMrLf+mk_a3X_r+Na=tHXg@mail.gmail.com>
References: <20220427164659.106447-1-miquel.raynal@bootlin.com>
        <20220427164659.106447-7-miquel.raynal@bootlin.com>
        <CAK-6q+jCYDQ-rtyawz1m2Yt+ti=3d6PrhZebB=-PjcX-6L-Kdg@mail.gmail.com>
        <20220510165237.43382f42@xps13>
        <CAK-6q+jeubhGah2gG1JJxfmOW=sNdMrLf+mk_a3X_r+Na=tHXg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Wed, 11 May 2022 09:09:40 -0400:

> Hi,
>=20
> On Tue, May 10, 2022 at 10:52 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alex,
> > =20
> > > > --- a/net/mac802154/tx.c
> > > > +++ b/net/mac802154/tx.c
> > > > @@ -106,6 +106,21 @@ ieee802154_tx(struct ieee802154_local *local, =
struct sk_buff *skb)
> > > >         return NETDEV_TX_OK;
> > > >  }
> > > >
> > > > +void ieee802154_hold_queue(struct ieee802154_local *local)
> > > > +{
> > > > +       atomic_inc(&local->phy->hold_txs);
> > > > +}
> > > > +
> > > > +void ieee802154_release_queue(struct ieee802154_local *local)
> > > > +{
> > > > +       atomic_dec(&local->phy->hold_txs);
> > > > +}
> > > > +
> > > > +bool ieee802154_queue_is_held(struct ieee802154_local *local)
> > > > +{
> > > > +       return atomic_read(&local->phy->hold_txs);
> > > > +} =20
> > >
> > > I am not getting this, should the release_queue() function not do
> > > something like:
> > >
> > > if (atomic_dec_and_test(hold_txs))
> > >       ieee802154_wake_queue(local);
> > >
> > > I think we don't need the test of "ieee802154_queue_is_held()" here,
> > > then we need to replace all stop_queue/wake_queue with hold and
> > > release? =20
> >
> > That's actually a good idea. I've implemented it and it looks nice too.
> > I'll clean this up and share a new version with:
> > - The wake call checked everytime hold_txs gets decremented
> > - The removal of the _queue_is_held() helper
> > - _wake/stop_queue() turned static
> > - _hold/release_queue() used everywhere
> > =20
>=20
> I think there is also a lock necessary for atomic inc/dec hitting zero
> and the stop/wake call afterwards...

Mmmh that is true, it can race. I've introduced a mutex (I think it's
safe but it can be turned into a spinlock if proven necessary) to
secure these increment/decrement+wakeup operations.

> ,there are also a lot of
> optimization techniques to only hold the lock for hitting zero cases
> in such areas. However we will see...

I am not aware of technical solutions to avoid the locking in these
cases, what do you have in mind? Otherwise I propose just to come up
with a working and hopefully solid solution and then we'll see how to
optimize.

Thanks,
Miqu=C3=A8l
