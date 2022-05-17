Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD28529DA9
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244452AbiEQJPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244693AbiEQJOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:14:21 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AA54249D;
        Tue, 17 May 2022 02:13:33 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 77DD860007;
        Tue, 17 May 2022 09:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652778812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=khwAh0BEehBqIojqv0kYs1TT2aLcqTaNywyfpltJ9Vo=;
        b=OI7+rIr8p+qEjv8U+c/yglasGsfDw8P+QVGKI7KnWlrOC5a56gIKqvAExrCNx1738ozMtF
        UqYNuqw4XfFkuojxZhIX9DrJiGI/CR/UawL5Kh5JrJZLYEKVHYiJuUnMYeeUIabZFacq4f
        hLQqpxK6e5s3yjRvEJm/jMBtNolTKpGrv2gOY4NZTKgku+4UlgHBlwtDUDD76UHqxU9vp3
        fime6AqVXjTSb5Z4fukKA2lm8FYh+00nnJcz57j6Vo41PSDi9uL4kumnre6kZxupIbYhS9
        Xsfl3bC8LCSLYFLgS1XtLeEzBQ0q5L5/QJrpgGc767wZp/HBxEXVzNt3EwyZZQ==
Date:   Tue, 17 May 2022 11:13:29 +0200
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
Message-ID: <20220517111329.6623d513@xps-13>
In-Reply-To: <CAK-6q+h07LM1-Cu_mkxAZWN2kG9LLxoKvXxUiQ5DPSYwRkbXZw@mail.gmail.com>
References: <20220427164659.106447-1-miquel.raynal@bootlin.com>
        <20220427164659.106447-7-miquel.raynal@bootlin.com>
        <CAK-6q+jCYDQ-rtyawz1m2Yt+ti=3d6PrhZebB=-PjcX-6L-Kdg@mail.gmail.com>
        <20220510165237.43382f42@xps13>
        <CAK-6q+jeubhGah2gG1JJxfmOW=sNdMrLf+mk_a3X_r+Na=tHXg@mail.gmail.com>
        <20220512163307.540d635d@xps13>
        <CAK-6q+h07LM1-Cu_mkxAZWN2kG9LLxoKvXxUiQ5DPSYwRkbXZw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

aahringo@redhat.com wrote on Thu, 12 May 2022 10:44:35 -0400:

> Hi,
>=20
> On Thu, May 12, 2022 at 10:33 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Wed, 11 May 2022 09:09:40 -0400:
> > =20
> > > Hi,
> > >
> > > On Tue, May 10, 2022 at 10:52 AM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote: =20
> > > >
> > > > Hi Alex,
> > > > =20
> > > > > > --- a/net/mac802154/tx.c
> > > > > > +++ b/net/mac802154/tx.c
> > > > > > @@ -106,6 +106,21 @@ ieee802154_tx(struct ieee802154_local *loc=
al, struct sk_buff *skb)
> > > > > >         return NETDEV_TX_OK;
> > > > > >  }
> > > > > >
> > > > > > +void ieee802154_hold_queue(struct ieee802154_local *local)
> > > > > > +{
> > > > > > +       atomic_inc(&local->phy->hold_txs);
> > > > > > +}
> > > > > > +
> > > > > > +void ieee802154_release_queue(struct ieee802154_local *local)
> > > > > > +{
> > > > > > +       atomic_dec(&local->phy->hold_txs);
> > > > > > +}
> > > > > > +
> > > > > > +bool ieee802154_queue_is_held(struct ieee802154_local *local)
> > > > > > +{
> > > > > > +       return atomic_read(&local->phy->hold_txs);
> > > > > > +} =20
> > > > >
> > > > > I am not getting this, should the release_queue() function not do
> > > > > something like:
> > > > >
> > > > > if (atomic_dec_and_test(hold_txs))
> > > > >       ieee802154_wake_queue(local);
> > > > >
> > > > > I think we don't need the test of "ieee802154_queue_is_held()" he=
re,
> > > > > then we need to replace all stop_queue/wake_queue with hold and
> > > > > release? =20
> > > >
> > > > That's actually a good idea. I've implemented it and it looks nice =
too.
> > > > I'll clean this up and share a new version with:
> > > > - The wake call checked everytime hold_txs gets decremented
> > > > - The removal of the _queue_is_held() helper
> > > > - _wake/stop_queue() turned static
> > > > - _hold/release_queue() used everywhere
> > > > =20
> > >
> > > I think there is also a lock necessary for atomic inc/dec hitting zero
> > > and the stop/wake call afterwards... =20
> >
> > Mmmh that is true, it can race. I've introduced a mutex (I think it's
> > safe but it can be turned into a spinlock if proven necessary) to
> > secure these increment/decrement+wakeup operations.
> > =20
>=20
> be aware that you might call these functions from different contexts,
> test your patches with PROVE_LOCKING enabled.

Right, I've added it to my .config, let's see what it tells me.

> > > ,there are also a lot of
> > > optimization techniques to only hold the lock for hitting zero cases
> > > in such areas. However we will see... =20
> >
> > I am not aware of technical solutions to avoid the locking in these
> > cases, what do you have in mind? Otherwise I propose just to come up
> > with a working and hopefully solid solution and then we'll see how to
> > optimize. =20
>=20
> Yes, it's not so important...
>=20
> - Alex
>=20

Thanks,
Miqu=C3=A8l
