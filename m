Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB9552BF3F
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbiERQMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239761AbiERQMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:12:22 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8FE1E0104;
        Wed, 18 May 2022 09:12:19 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 65F2D240005;
        Wed, 18 May 2022 16:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652890338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=in9VKgjCNsK+vgtnnH9Hn0Mhq/SOQO2uHRRnoWXBAZ4=;
        b=GnWxyv5/C1ZPoshrUFoFgBsLhbViy10z/XsvjdvxalNa0ERbWaydH6XkWCjiX9MaMZABL9
        v1VVCCYRETUhoD+O1J3ldmqQd+7EYWnuhE9zSlWrA4kT0wgmWcOwu/ZwxxnUBgSeV6XLcP
        I7wDEN2LJSRW/4gISmDO0rPbLXOa63odCqgRxwFp7ROX1TGvVFC6Z7Ovo/d/elblTXcSh5
        r6ULXUK3D4gyI8lV14GGWnWAf/5UL8HhUN7wc9hcvtCDgo4sk8kMvIMjHm9o0+VF10PdPW
        V3QroH/5sM5vyWWOZoS8DztpmNiXIoCy1WZBRoTUCWmFkaq6h8fNMw2wnx0JLw==
Date:   Wed, 18 May 2022 18:12:14 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 09/11] net: mac802154: Introduce a
 synchronous API for MLME commands
Message-ID: <20220518181214.34a34ed6@xps-13>
In-Reply-To: <CAK-6q+g07ficTc-h_ks8GPpv880goHuGNXTD2fqbfbR7LDPZWQ@mail.gmail.com>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
        <20220512143314.235604-10-miquel.raynal@bootlin.com>
        <CAK-6q+ipHdD=NJB2N7SHQ0TUvNpc0GQXZ7dWM9nDxqyqNgxdSA@mail.gmail.com>
        <CAK-6q+i_T+FaK0tX6tF38VjyEfSzDi-QC85MTU2=4soepAag8g@mail.gmail.com>
        <20220517153045.73fda4ee@xps-13>
        <CAK-6q+h1fmJZobmUG5bUL3uXuQLv0kvHUv=7dW+fOCcgbrdPiA@mail.gmail.com>
        <20220518121200.2f08a6b1@xps-13>
        <CAB_54W6XN4kytUMgMveVF7n7TPh+w75-ew25rVt-eUQiCgNuGw@mail.gmail.com>
        <20220518143702.48cb9c66@xps-13>
        <CAK-6q+g07ficTc-h_ks8GPpv880goHuGNXTD2fqbfbR7LDPZWQ@mail.gmail.com>
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

Hi Alexander,

> > > > > > > > > +int ieee802154_mlme_tx(struct ieee802154_local *local, s=
truct sk_buff *skb)
> > > > > > > > > +{
> > > > > > > > > +       int ret;
> > > > > > > > > +
> > > > > > > > > +       /* Avoid possible calls to ->ndo_stop() when we a=
synchronously perform
> > > > > > > > > +        * MLME transmissions.
> > > > > > > > > +        */
> > > > > > > > > +       rtnl_lock(); =20
> > > > > > > >
> > > > > > > > I think we should make an ASSERT_RTNL() here, the lock need=
s to be
> > > > > > > > earlier than that over the whole MLME op. MLME can trigger =
more than =20
> > > > > > >
> > > > > > > not over the whole MLME_op, that's terrible to hold the rtnl =
lock so
> > > > > > > long... so I think this is fine that some netdev call will in=
terfere
> > > > > > > with this transmission.
> > > > > > > So forget about the ASSERT_RTNL() here, it's fine (I hope).
> > > > > > > =20
> > > > > > > > one message, the whole sync_hold/release queue should be ea=
rlier than
> > > > > > > > that... in my opinion is it not right to allow other messag=
es so far
> > > > > > > > an MLME op is going on? I am not sure what the standard say=
s to this,
> > > > > > > > but I think it should be stopped the whole time? All those =
sequence =20
> > > > > > >
> > > > > > > Whereas the stop of the netdev queue makes sense for the whol=
e mlme-op
> > > > > > > (in my opinion). =20
> > > > > >
> > > > > > I might still implement an MLME pre/post helper and do the queue
> > > > > > hold/release calls there, while only taking the rtnl from the _=
tx.
> > > > > >
> > > > > > And I might create an mlme_tx_one() which does the pre/post cal=
ls as
> > > > > > well.
> > > > > >
> > > > > > Would something like this fit? =20
> > > > >
> > > > > I think so, I've heard for some transceiver types a scan operatio=
n can
> > > > > take hours... but I guess whoever triggers that scan in such an
> > > > > environment knows that it has some "side-effects"... =20
> > > >
> > > > Yeah, a scan requires the data queue to be stopped and all incoming
> > > > packets to be dropped (others than beacons, ofc), so users must be
> > > > aware of this limitation. =20
> > >
> > > I think there is a real problem about how the user can synchronize the
> > > start of a scan and be sure that at this point everything was
> > > transmitted, we might need to real "flush" the queue. Your naming
> > > "flush" is also wrong, It will flush the framebuffer(s) of the
> > > transceivers but not the netdev queue... and we probably should flush
> > > the netdev queue before starting mlme-op... this is something to add
> > > in the mlme_op_pre() function. =20
> >
> > Is it even possible? This requires waiting for the netdev queue to be
> > empty before stopping it, but if users constantly flood the transceiver
> > with data packets this might "never" happen.
> > =20
>=20
> Nothing is impossible, just maybe nobody thought about that. Sure
> putting more into the queue should be forbidden but what's inside
> should be "flushed". Currently we make a hard cut, there is no way
> that the user knows what's sent or not BUT that is the case for
> xmit_do() anyway, it's not reliable... people need to have the right
> upper layer protocol. However I think we could run into problems if we
> especially have features like waiting for the socket error queue to
> know if e.g. an ack was received or not.

Looking at net/core/dev.c I don't see the issue anymore, let me try to
explain: as far as I understand the net device queue is a very
conceptual "queue" which only has a reality if the underlying layer
really implements the concept of a queue. To be more precise, at the
netdev level itself, there is a HARD_TX_LOCK() call which serializes
the ->ndo_start_xmit() calls, but whatever entered the
->ndo_start_xmit() hook _will_ be handled by the lower layer and is not
in any "waiting" state at the net core level.

In practice, the IEEE 802.15.4 core treats all packets immediately and
do not really bother "queuing" them like if there was a "waiting"
state. So all messages that the userspace expected to be send (which
did not return NETDEV_TX_BUSY) at the moment where we decide to stop
data transmissions will be processed.

If several frames had to be transmitted to the IEEE 802.15.4 core and
they all passed the netdev "queuing" mechanism, then they will be
forwarded to the tranceivers thanks to the wait_event(!ongoing_txs) and
only after we declare the queue sync'ed.

For me there is no hard cut.

> > And event thought we might accept this situation, I don't know how to
> > check the emptiness of the netif queue. Any inputs? =20
>=20
> Don't think about it, I see a practical issue here which I keep in my min=
d.
>=20
> - Alex
>=20


Thanks,
Miqu=C3=A8l
