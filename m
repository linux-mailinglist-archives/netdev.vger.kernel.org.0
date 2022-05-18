Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F4252B564
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbiERIor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbiERIop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:44:45 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875495AA72;
        Wed, 18 May 2022 01:44:40 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3743AE000C;
        Wed, 18 May 2022 08:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652863479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D7N0a8WlPyH5fUAPOA9fiwW1d7yjlVNaA/MdpICq2w4=;
        b=ImapXB86pOCCQb7z9pmiLBvyhgJdFuyUqfoxN480CFyLv1mm4jdFW8qr+ki/KXp39FGWFa
        9AUaYQzSPKtMHh8JFrmNBS4x4DBwwfCRSRyam/rZb+/ybuKceA8pGy58x7zUEOlS2YN4cE
        Z+vgfHSqpWpLHkKk+5p+AoKQORXcPhs3hPfwG13jvRJC8fyYLcnReVZnve/jJzU/oGANZF
        WS7kXgZl9Oi/DkYei7+9WxyyczyLQxiiCpZnljTc1HeV5t8dIeqNlKA0c4Yb5EsNdhFipZ
        An30T3rEE+LzKj6Gaam2mFohNUfqeLRSHRzPy5iGaIp5eaqctH3PfuIa4/6n7A==
Date:   Wed, 18 May 2022 10:44:35 +0200
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
Subject: Re: [PATCH wpan-next v3 09/11] net: mac802154: Introduce a
 synchronous API for MLME commands
Message-ID: <20220518104435.76f5c0d5@xps-13>
In-Reply-To: <CAK-6q+jQL7cFJrL6XjuaJnNDggtO1d_sB+T+GrY9yT+Y+KC0oA@mail.gmail.com>
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
        <20220517163450.240299-10-miquel.raynal@bootlin.com>
        <CAK-6q+jQL7cFJrL6XjuaJnNDggtO1d_sB+T+GrY9yT+Y+KC0oA@mail.gmail.com>
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

Hi Alexander,

aahringo@redhat.com wrote on Tue, 17 May 2022 20:41:41 -0400:

> Hi,
>=20
> On Tue, May 17, 2022 at 12:35 PM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > This is the slow path, we need to wait for each command to be processed
> > before continuing so let's introduce an helper which does the
> > transmission and blocks until it gets notified of its asynchronous
> > completion. This helper is going to be used when introducing scan
> > support.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/mac802154/ieee802154_i.h |  1 +
> >  net/mac802154/tx.c           | 46 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 47 insertions(+)
> >
> > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > index a057827fc48a..b42c6ac789f5 100644
> > --- a/net/mac802154/ieee802154_i.h
> > +++ b/net/mac802154/ieee802154_i.h
> > @@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wp=
an;
> >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb=
);
> >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> >  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> > +int ieee802154_mlme_tx_one(struct ieee802154_local *local, struct sk_b=
uff *skb);
> >  netdev_tx_t
> >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *=
dev);
> >  netdev_tx_t
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index 38f74b8b6740..6cc4e5c7ba94 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -128,6 +128,52 @@ int ieee802154_sync_and_hold_queue(struct ieee8021=
54_local *local)
> >         return ieee802154_sync_queue(local);
> >  }
> >
> > +static int ieee802154_mlme_op_pre(struct ieee802154_local *local)
> > +{
> > +       return ieee802154_sync_and_hold_queue(local);
> > +}
> > +
> > +static int ieee802154_mlme_tx(struct ieee802154_local *local, struct s=
k_buff *skb)
> > +{
> > +       int ret;
> > +
> > +       /* Avoid possible calls to ->ndo_stop() when we asynchronously =
perform
> > +        * MLME transmissions.
> > +        */
> > +       rtnl_lock();
> > +
> > +       /* Ensure the device was not stopped, otherwise error out */
> > +       if (!local->open_count)
> > +               return -EBUSY;
> > + =20
>=20
> No -EBUSY here, use ?-ENETDOWN?.

Isn't it strange to return "Network is down" while we try to stop the
device but fail to do so because, actually, it is still being used?

> You forgot rtnl_unlock() here.

I've blindly added those rtnl calls, I need to go through all of them
once again and ensure all the error path release the lock.

Thanks,
Miqu=C3=A8l
