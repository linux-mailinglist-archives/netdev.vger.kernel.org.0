Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3197652B726
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbiERJht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiERJhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:37:34 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C999CC8BD4;
        Wed, 18 May 2022 02:37:31 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EDDBFC0005;
        Wed, 18 May 2022 09:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652866650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZWvwRcNiLo+2tnHRVcavxMuPKBnYvD4fOtedtcIWA/w=;
        b=aE7d2agwFlZZXHsCux/fP7i0fe6XwsIdxGgeMI8L3BQsWZVQFJ9msPBozCC1OY72ZKUt3m
        budCHKF5wIFogVDlitcIMvLZbRm/z/0RCnLWjrmRxEFSvMdZUZmxWfdcrQ4/1eZ9DX+pQ7
        WpwMAXIuH5C76jD2NPnKvHVpbGaLOBY5nUgtEzB/YPyS/ymp3n+IC8BNCCGx1gXtoMnA8k
        +/p2MYuwfQotkv84K+Gd64dZZHHuhSqsiveThNZk+bzuJhnrISiZ3bCwdoy4nwH6tshpkL
        wdYNLuFmQ0f3Ia2lYXPCeElGY49qx4KbNQTgJF7dD0tMJl2eJr0m5rsvwZLj8A==
Date:   Wed, 18 May 2022 11:37:26 +0200
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
Subject: Re: [PATCH wpan-next v3 11/11] net: mac802154: Add a warning in the
 slow path
Message-ID: <20220518113726.3cfb9d99@xps-13>
In-Reply-To: <CAK-6q+hPWRUobMATaxD6rZ1zfQUnS_6pMacr+rKVHRAWe1xzSQ@mail.gmail.com>
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
        <20220517163450.240299-12-miquel.raynal@bootlin.com>
        <CAK-6q+hPWRUobMATaxD6rZ1zfQUnS_6pMacr+rKVHRAWe1xzSQ@mail.gmail.com>
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

Hi Alex,

aahringo@redhat.com wrote on Tue, 17 May 2022 20:52:35 -0400:

> Hi,
>=20
> On Tue, May 17, 2022 at 12:35 PM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > In order to be able to detect possible conflicts between the net
> > interface core and the ieee802154 core, let's add a warning in the slow
> > path: we want to be sure that whenever we start an asynchronous MLME
> > transmission (which can be fully asynchronous) the net core somehow
> > agrees that this transmission is possible, ie. the device was not
> > stopped. Warning in this case would allow us to track down more easily
> > possible issues with the MLME logic if we ever get reports.
> >
> > Unlike in the hot path, such a situation cannot be handled.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/mac802154/tx.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index e36aca788ea2..53a8be822e33 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -132,6 +132,25 @@ int ieee802154_sync_and_hold_queue(struct ieee8021=
54_local *local)
> >         return ret;
> >  }
> >
> > +static bool ieee802154_netif_is_down(struct ieee802154_local *local)
> > +{
> > +       struct ieee802154_sub_if_data *sdata;
> > +       bool is_down =3D true;
> > +
> > +       rcu_read_lock();
> > +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > +               if (!sdata->dev)
> > +                       continue;
> > +
> > +               is_down =3D !(sdata->dev->flags & IFF_UP);
> > +               if (is_down)
> > +                       break; =20
>=20
> I thought that the helper would be "netif_running()". It seems there
> are multiple ways to check if an interface is up.

Looking at net/core/dev.c shows that netif_running() may indicate a
transitory state (the interface was requested to be up or down) while
the IFF_UP flag really tells when the operation is done and the
interface actually is up or down.

Anyway they are both updated atomically wrt the rtnl lock. The sooner
the better, so let's check the interface state with netif_running().


[...]

> >
> > +       /* Warn if the ieee802154 core thinks MLME frames can be sent w=
hile the
> > +        * net interface expects this cannot happen.
> > +        */
> > +       if (WARN_ON_ONCE(ieee802154_netif_is_down(local)))
> > +               return -EHOSTDOWN; =20
>=20
> maybe also ENETDOWN?

Sure

> Also there is a missing rtnl_unlock().

Duly noted.

Thanks,
Miqu=C3=A8l
