Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E477752B577
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiERI4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbiERIzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:55:55 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B142D13C36B;
        Wed, 18 May 2022 01:55:48 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F26A120003;
        Wed, 18 May 2022 08:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652864146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/gfHyiUzOTzbBNy4xST8DUvMnLL6yDQXGjn5F6f04c=;
        b=BGqiHNms1uYk9EB3ktGlYz5VOLOOl0f1Ae42CpwVsLl6GnrmTdEP13S6yjge562yoeP/+H
        V0hor9tSlfVntxiO1aDLqF+WBKJlxLRy9MYGmdThqehzTHRlBMvlFWrprU2erXK9r7Zas/
        JQ+ymb87LEKIruyLtXqorAtvk1lyGM0R3ISLFL6KE35eFZe9ZC5HiSX5/DLh9HsEZSNNZE
        Fd2qRQ7LEbuuL3GwkTshLAAGeETgicigsQ0JKvCkfUCleuAj5P3/x5u/3T9shJHvFvsnCA
        jidZdgCUsCL1jNXwgs4B8c6kVqjo0F31O0G/JYl9TVOOGruATA9rBNuGZJyXMQ==
Date:   Wed, 18 May 2022 10:55:43 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH wpan-next v3 10/11] net: mac802154: Add a warning in the
 hot path
Message-ID: <20220518105543.54cda82f@xps-13>
In-Reply-To: <CAK-6q+g=9_aqTOmMYxCn6p=Z=uPNyifjVXe4hzC82ZF1QPpLMg@mail.gmail.com>
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
        <20220517163450.240299-11-miquel.raynal@bootlin.com>
        <CAK-6q+g=9_aqTOmMYxCn6p=Z=uPNyifjVXe4hzC82ZF1QPpLMg@mail.gmail.com>
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


aahringo@redhat.com wrote on Tue, 17 May 2022 20:58:19 -0400:

> Hi,
>=20
> On Tue, May 17, 2022 at 12:35 PM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > We should never start a transmission after the queue has been stopped.
> >
> > But because it might work we don't kill the function here but rather
> > warn loudly the user that something is wrong.
> >
> > Set an atomic when the queue will remain stopped. Reset this atomic when
> > the queue actually gets restarded. Just check this atomic to know if the
> > transmission is legitimate, warn if it is not.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/cfg802154.h |  1 +
> >  net/mac802154/tx.c      | 16 +++++++++++++++-
> >  net/mac802154/util.c    |  1 +
> >  3 files changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index 8881b6126b58..f4e7b3fe7cf0 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -218,6 +218,7 @@ struct wpan_phy {
> >         spinlock_t queue_lock;
> >         atomic_t ongoing_txs;
> >         atomic_t hold_txs;
> > +       unsigned long queue_stopped; =20
>=20
> Can we name it something like state_flags (as phy state flags)? Pretty
> sure there will be more coming, or internal_flags, no idea...
> something_flags...

'phy_flags'? Just 'flags', maybe?

state_flags seems a bit too specific, but if it's your favorite I don't
mind using it.

>=20
> >         wait_queue_head_t sync_txq;
> >
> >         char priv[] __aligned(NETDEV_ALIGN);
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index 6cc4e5c7ba94..e36aca788ea2 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -123,9 +123,13 @@ static int ieee802154_sync_queue(struct ieee802154=
_local *local)
> >
> >  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
> >  {
> > +       int ret;
> > +
> >         ieee802154_hold_queue(local);
> > +       ret =3D ieee802154_sync_queue(local);
> > +       set_bit(0, &local->phy->queue_stopped);
> > =20
>=20
> Define the 0 as WPAN_PHY_STATE_QUEUE_STOPPED_BIT or something like
> that, above wpan_phy.

Sure.

Thanks,
Miqu=C3=A8l
