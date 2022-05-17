Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606BC52A360
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 15:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347828AbiEQN27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 09:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347736AbiEQN25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 09:28:57 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1E745053;
        Tue, 17 May 2022 06:28:46 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 43348C000D;
        Tue, 17 May 2022 13:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652794125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y2TIGkHU/bgb24C6NMMMB7WfUQCEG4G7d+XAQKLwIqw=;
        b=cpI1zQpBVX0RhYaZxjeB/3YZpPtXaDxmRl1lYTqpURgRWied/8EIo2bSAruXxLDAEca9rl
        HdPR/6JAQap//U7wAgWA3boXRgA8ujFKau1xiF7EvP9CC9EeT5E/jCzyOXifE/iCBffu/A
        Qt77rxjBfHWuT34sKt1mzMsUeGtV11DB5LsKQYnkLNcbly6PJnoiRuByw9HwOp/5VYi0ct
        gJmTQrddaaFpq4RKRnb+BUPw2PKBpDTZu5qlfDfhgqe6ifgXWzsOA8M8vuAE+yfsVLU1K1
        qkf/9nvkoG8+Hwx8kgDdjFjMz217JhYOj3Q7R4huGSHtTNCdXRAZVniyCCxk9g==
Date:   Tue, 17 May 2022 15:28:40 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 05/11] net: mac802154: Bring the hability
 to hold the transmit queue
Message-ID: <20220517152840.5a01037b@xps-13>
In-Reply-To: <CAK-6q+ihfOSBjpw1Q-2qesd4nkrAfw_rBCd0QcWzXk0PP9Prtg@mail.gmail.com>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
        <20220512143314.235604-6-miquel.raynal@bootlin.com>
        <CAB_54W605SGbkNHhOLG5WEKsvccUvJ=rBnHErcyrte8_H=rY+g@mail.gmail.com>
        <20220517112726.4b89e907@xps-13>
        <CAK-6q+ihfOSBjpw1Q-2qesd4nkrAfw_rBCd0QcWzXk0PP9Prtg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
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


aahringo@redhat.com wrote on Tue, 17 May 2022 09:19:29 -0400:

> Hi,
>=20
> On Tue, May 17, 2022 at 5:28 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alex,
> > =20
> > > > @@ -84,7 +118,7 @@ void ieee802154_xmit_complete(struct ieee802154_=
hw *hw, struct sk_buff *skb,
> > > >                                       hw->phy->sifs_period * NSEC_P=
ER_USEC,
> > > >                                       HRTIMER_MODE_REL);
> > > >         } else {
> > > > -               ieee802154_wake_queue(hw);
> > > > +               ieee802154_release_queue(local);
> > > >         }
> > > >
> > > >         dev_consume_skb_any(skb);
> > > > @@ -98,7 +132,7 @@ void ieee802154_xmit_error(struct ieee802154_hw =
*hw, struct sk_buff *skb,
> > > >         struct ieee802154_local *local =3D hw_to_local(hw);
> > > >
> > > >         local->tx_result =3D reason;
> > > > -       ieee802154_wake_queue(hw);
> > > > +       ieee802154_release_queue(local);
> > > >         dev_kfree_skb_any(skb);
> > > >         atomic_dec(&hw->phy->ongoing_txs); =20
> > >
> > > I am pretty sure that will end in a scheduling while atomic warning
> > > with hwsim. If you don't hit it you have the wrong config, you need to
> > > enable such warnings and have the right preemption model setting. =20
> >
> > I was using the "desktop" kernel preemption model (voluntary), I've
> > switched to CONFIG_PREEMPT ("Preemptible kernel (Low-latency)"),
> > and enabled CONFIG_DEBUG_ATOMIC_SLEEP. You are right that we should use
> > a spinlock instead of a mutex here. However I don't think disabling
> > IRQs is necessary, so I'll switch to spin_(un)lock() calls.
> > =20
>=20
> In my opinion it's necessary for the ifs hrtimer. Normal
> spin_lock/unlock is not the right fit here.

You're right, I forgot about hrtimers.

Thanks,
Miqu=C3=A8l
