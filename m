Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F01052500F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355322AbiELOdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355309AbiELOdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:33:11 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17185BD19;
        Thu, 12 May 2022 07:33:08 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E87931C0005;
        Thu, 12 May 2022 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652365987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7+QXvfmY2L7V6ryfuf8dtHNXSazg3KY1Kvc6V0rWEkg=;
        b=C1d+WG1OMUiuDAo7PwniRV3qiXxmFF1GkX1kFvO6hw782+T9IKNBS3MuL0gXa4o4rJR168
        s8Sv34QObHNpeil49gcQO95O9VHz7AJ0W8o7ld9/BJwz4bzzHwv/6yv5qU66LzVgnqJQU5
        SFxeixVIdsbJtHXDm/A+eA3ZgyawiqljB8Z49Xpr0RyTJ6DCyqbQWI7ZbQfEVElnwFCN1h
        HHYEh7KBCDXHZIOXZ7O/+fYofnC85GSzWiq9+imx8+1oz/1Wlybf1Q8VaTyAUfiz/EwXwt
        lH/VNOeXO2XWFLkcx/k0r+Nq4+LGbqJgpiOVsT33TC8eArmnj/Clst/8fkjeOg==
Date:   Thu, 12 May 2022 16:33:04 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 08/11] net: mac802154: Add a warning in the
 hot path
Message-ID: <20220512163304.34fa5c35@xps13>
In-Reply-To: <CAB_54W6nrNaXouN2LkEtzSpYNSmXT+WUbr4Y9rETyATznAbkEg@mail.gmail.com>
References: <20220427164659.106447-1-miquel.raynal@bootlin.com>
        <20220427164659.106447-9-miquel.raynal@bootlin.com>
        <CAB_54W7NWEYgmLfowvyXtKEsKhBaVrPzpkB1kasYpAst98mKNA@mail.gmail.com>
        <20220428095848.34582df4@xps13>
        <CAB_54W6nrNaXouN2LkEtzSpYNSmXT+WUbr4Y9rETyATznAbkEg@mail.gmail.com>
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

alex.aring@gmail.com wrote on Sun, 1 May 2022 20:21:18 -0400:

> Hi,
>=20
> On Thu, Apr 28, 2022 at 3:58 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Wed, 27 Apr 2022 14:01:25 -0400:
> > =20
> > > Hi,
> > >
> > > On Wed, Apr 27, 2022 at 12:47 PM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote: =20
> > > >
> > > > We should never start a transmission after the queue has been stopp=
ed.
> > > >
> > > > But because it might work we don't kill the function here but rather
> > > > warn loudly the user that something is wrong.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > --- =20
> >
> > [...]
> > =20
> > > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > > index a8a83f0167bf..021dddfea542 100644
> > > > --- a/net/mac802154/tx.c
> > > > +++ b/net/mac802154/tx.c
> > > > @@ -124,6 +124,8 @@ bool ieee802154_queue_is_held(struct ieee802154=
_local *local)
> > > >  static netdev_tx_t
> > > >  ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *=
skb)
> > > >  {
> > > > +       WARN_ON_ONCE(ieee802154_queue_is_stopped(local));
> > > > +
> > > >         return ieee802154_tx(local, skb);
> > > >  }
> > > >
> > > > diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> > > > index 847e0864b575..cfd17a7db532 100644
> > > > --- a/net/mac802154/util.c
> > > > +++ b/net/mac802154/util.c
> > > > @@ -44,6 +44,24 @@ void ieee802154_stop_queue(struct ieee802154_loc=
al *local)
> > > >         rcu_read_unlock();
> > > >  }
> > > >
> > > > +bool ieee802154_queue_is_stopped(struct ieee802154_local *local)
> > > > +{
> > > > +       struct ieee802154_sub_if_data *sdata;
> > > > +       bool stopped =3D true;
> > > > +
> > > > +       rcu_read_lock();
> > > > +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > > > +               if (!sdata->dev)
> > > > +                       continue;
> > > > +
> > > > +               if (!netif_queue_stopped(sdata->dev))
> > > > +                       stopped =3D false;
> > > > +       }
> > > > +       rcu_read_unlock();
> > > > +
> > > > +       return stopped;
> > > > +} =20
> > >
> > > sorry this makes no sense, you using net core functionality to check
> > > if a queue is stopped in a net core netif callback. Whereas the sense
> > > here for checking if the queue is really stopped is when 802.15.4
> > > thinks the queue is stopped vs net core netif callback running. It
> > > means for MLME-ops there are points we want to make sure that net core
> > > is not handling any xmit and we should check this point and not
> > > introducing net core functionality checks. =20
> >
> > I think I've mixed two things, your remark makes complete sense. I
> > should instead here just check a 802.15.4 internal variable.
> > =20
>=20
> I am thinking about this patch series... and I think it still has bugs
> or at least it's easy to have bugs when the context is not right
> prepared to call a synchronized transmission. We leave here the netdev
> state machine world for transmit vs e.g. start/stop netif callback...
> We have a warning here if there is a core netif xmit callback running
> when 802.15.4 thinks it shouldn't (because we take control of it) but
> I also think about a kind of the other way around. A warning if
> 802.15.4 transmits something but the netdev core logic "thinks" it
> shouldn't.
>=20
> That requires some checks (probably from netcore functionality) to
> check if we call a 802.15.4 sync xmit but netif core already called
> stop() callback. The last stop() callback - means the driver_ops
> stop() callback was called, we have some "open_count" counter there
> which MUST be incremented before doing any looping of one or several
> sync transmissions. All I can say is if we call xmit() but the driver
> is in stop() state... it will break things.
>=20
> My concern is also here that e.g. calling netif down or device
> suspend() are only two examples I have in my mind right now. I don't
> know all cases which can occur, that's why we should introduce another
> WARN_ON_ONCE() for the case that 802.15.4 transmits something but we
> are in a state where we can't transmit something according to netif
> state (driver ops called stop()).
>=20
> Can you add such a check as well?=20

That is a good idea, I have added such a check: if the interface is
supposed to be down I'll warn and return because I don't think there is
much we can do in this situation besides avoiding trying to transmit
anything.

> And please keep in mind to increment
> the open count when implementing MLME-ops (or at least handle it
> somehow), otherwise I guess it's easy to hit the warning. If another
> user reports warnings and tells us what they did we might know more
> other "cases" to fix.

I don't think incrementing the open_count counter is the right solution
here just because the stop call is not supposed to fail and has no
straightforward ways to be deferred. In particular, just keeping the
open_count incremented will just avoid the actual driver stop operation
to be executed and the core will not notice it.

I came out with another solution: acquiring the rtnl when performing a
MLME Tx operation to serialize these operations. We can easily have a
version which just checks the rtnl was acquired as well for situations
when the MLME operations are called by eg. the nl layer (and thus, with
the rtnl lock taken automatically).

Thanks,
Miqu=C3=A8l
