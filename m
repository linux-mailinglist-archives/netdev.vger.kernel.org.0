Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9838F52C09B
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240311AbiERQ3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240357AbiERQ3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:29:46 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167241F90EB;
        Wed, 18 May 2022 09:29:22 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 35CD3100005;
        Wed, 18 May 2022 16:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652891361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f2YX2eCJtpcllO5djYtewYQqwQlZHUUNrFfYk/j2enc=;
        b=KZxA2EwxxWA7NnH0RgYMOZdGMZYJ29lPDs2eSHB/aHC6akBp1XoQ78Tu0ho+0TujFt+Hlh
        PA5kdbFnYZU5nuRsSlWrFOeYYUWYUvq2kY7Be9ymKWmf8yyNpN7ByNR5nhoHpjiINEadgM
        voRAl1M1alRBedv+oeKlermcLTe/XsXXg1jryQLBCiX3vLQg9l5Io+Po04UF0R9VV6is+C
        A1/6WhsyRQtPWgBYB03BPFh47X9xL8e148N/ZyZBHZlcKJZFgqrUbltozP5tLxwFWUEJwr
        vFVRKxYWPEw20IT1r38MfHcpagfjHyK3ijGoWqi86nGAGASSW2a05J0/uIkN9g==
Date:   Wed, 18 May 2022 18:29:17 +0200
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
Message-ID: <20220518182917.10323dea@xps-13>
In-Reply-To: <CAK-6q+j-EgoO-mWx_zRrORmA9-75h_=_fh22KMxySdSgeLsJEA@mail.gmail.com>
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
        <20220517163450.240299-11-miquel.raynal@bootlin.com>
        <CAK-6q+g=9_aqTOmMYxCn6p=Z=uPNyifjVXe4hzC82ZF1QPpLMg@mail.gmail.com>
        <20220518105543.54cda82f@xps-13>
        <CAK-6q+j-EgoO-mWx_zRrORmA9-75h_=_fh22KMxySdSgeLsJEA@mail.gmail.com>
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


aahringo@redhat.com wrote on Wed, 18 May 2022 10:31:55 -0400:

> Hi,
>=20
> On Wed, May 18, 2022 at 4:55 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> >
> > aahringo@redhat.com wrote on Tue, 17 May 2022 20:58:19 -0400:
> > =20
> > > Hi,
> > >
> > > On Tue, May 17, 2022 at 12:35 PM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote: =20
> > > >
> > > > We should never start a transmission after the queue has been stopp=
ed.
> > > >
> > > > But because it might work we don't kill the function here but rather
> > > > warn loudly the user that something is wrong.
> > > >
> > > > Set an atomic when the queue will remain stopped. Reset this atomic=
 when
> > > > the queue actually gets restarded. Just check this atomic to know i=
f the
> > > > transmission is legitimate, warn if it is not.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  include/net/cfg802154.h |  1 +
> > > >  net/mac802154/tx.c      | 16 +++++++++++++++-
> > > >  net/mac802154/util.c    |  1 +
> > > >  3 files changed, 17 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > > index 8881b6126b58..f4e7b3fe7cf0 100644
> > > > --- a/include/net/cfg802154.h
> > > > +++ b/include/net/cfg802154.h
> > > > @@ -218,6 +218,7 @@ struct wpan_phy {
> > > >         spinlock_t queue_lock;
> > > >         atomic_t ongoing_txs;
> > > >         atomic_t hold_txs;
> > > > +       unsigned long queue_stopped; =20
> > >
> > > Can we name it something like state_flags (as phy state flags)? Pretty
> > > sure there will be more coming, or internal_flags, no idea...
> > > something_flags... =20
> >
> > 'phy_flags'? Just 'flags', maybe? =20
>=20
> make it so.

Oh, there is already a flags entry in wpan_phy. I've adjusted the
naming to what existed (keeping the _STATE_ prefix) and kept that
"flags" entry instead of creating a new one.

Thanks,
Miqu=C3=A8l
