Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8667351395A
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349403AbiD1QH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346708AbiD1QH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:07:56 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5F85BD09;
        Thu, 28 Apr 2022 09:04:40 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7C06520009;
        Thu, 28 Apr 2022 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651161879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lxFmNpqk2RReBdJAh1Riszy37bFtVX+4636PmJz4Myg=;
        b=h/3sdb1kE5CMx8+o4AY5/CyWmoi9pwVXplDWTeKKwqzKCwNFmM9JNcMef/nzwG3DJLNBad
        gV/lCpQHTpNG9Go8vRmDbcf7kHf155VRby8yONB5Nx2VH9bAnX6VrclRjuntidWcqs7U3V
        pfGDisvEPq4AZrdCfXwouEPaPGGMjKjBcBjSyXBlLSUvHtNNDKVZVEi4fC2KsH7slYGcoW
        KY/p3hptfMmzqgViL6QPIa6XebbxFrQgANRm2jFmPnH9ltRmHIPzkSPX4RtbLUlsRqjdMr
        cwH6zFkyAa+3Lxt7CFpoLhoKVH6M6vUsYr9L/v78cOtcvFhCAxXL39zUOhQMHw==
Date:   Thu, 28 Apr 2022 18:04:35 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v3 3/4] net: mac802154: Set durations
 automatically
Message-ID: <20220428180435.2c3b7c34@xps13>
In-Reply-To: <20220428175838.08bb7717@xps13>
References: <20220201180629.93410-1-miquel.raynal@bootlin.com>
        <20220201180629.93410-4-miquel.raynal@bootlin.com>
        <20220428175838.08bb7717@xps13>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


miquel.raynal@bootlin.com wrote on Thu, 28 Apr 2022 17:58:38 +0200:

> Hi Stefan,
>=20
> miquel.raynal@bootlin.com wrote on Tue,  1 Feb 2022 19:06:28 +0100:
>=20
> > As depicted in the IEEE 802.15.4 specification, modulation/bands are
> > tight to a number of page/channels so we can for most of them derive the
> > durations automatically.
> >=20
> > The two locations that must call this new helper to set the variou
> > symbol durations are:
> > - when manually requesting a channel change though the netlink interface
> > - at PHY creation, once the device driver has set the default
> >   page/channel
> >=20
> > If an information is missing, the symbol duration is not touched, a
> > debug message is eventually printed. This keeps the compatibility with
> > the unconverted drivers for which it was too complicated for me to find
> > their precise information. If they initially provided a symbol duration,
> > it would be kept. If they don't, the symbol duration value is left
> > untouched.
> >=20
> > Once the symbol duration derived, the lifs and sifs durations are
> > updated as well.
> >=20
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/cfg802154.h |  2 ++
> >  net/mac802154/cfg.c     |  1 +
> >  net/mac802154/main.c    | 46 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 49 insertions(+)
> >=20
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index 8a4b6a50452f..49b4bcc24032 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -405,4 +405,6 @@ static inline const char *wpan_phy_name(struct wpan=
_phy *phy)
> >  	return dev_name(&phy->dev);
> >  }
> > =20
> > +void ieee802154_configure_durations(struct wpan_phy *phy);
> > +
> >  #endif /* __NET_CFG802154_H */
> > diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> > index fbeebe3bc31d..1e4a9f74ed43 100644
> > --- a/net/mac802154/cfg.c
> > +++ b/net/mac802154/cfg.c
> > @@ -118,6 +118,7 @@ ieee802154_set_channel(struct wpan_phy *wpan_phy, u=
8 page, u8 channel)
> >  	if (!ret) {
> >  		wpan_phy->current_page =3D page;
> >  		wpan_phy->current_channel =3D channel;
> > +		ieee802154_configure_durations(wpan_phy);
> >  	}
> > =20
> >  	return ret;
> > diff --git a/net/mac802154/main.c b/net/mac802154/main.c
> > index 53153367f9d0..5546ef86e231 100644
> > --- a/net/mac802154/main.c
> > +++ b/net/mac802154/main.c
> > @@ -113,6 +113,50 @@ ieee802154_alloc_hw(size_t priv_data_len, const st=
ruct ieee802154_ops *ops)
> >  }
> >  EXPORT_SYMBOL(ieee802154_alloc_hw);
> > =20
> > +void ieee802154_configure_durations(struct wpan_phy *phy)
> > +{
> > +	u32 duration =3D 0;
> > +
> > +	switch (phy->current_page) {
> > +	case 0:
> > +		if (BIT(phy->current_page) & 0x1) =20
>=20
> I am very sorry to spot this only now but this is wrong.=20
>=20
> all the conditions from here and below should be:
>=20
> 		if (BIT(phy->current_channel & <mask>))
>=20
> The masks look good, the durations as well, but the conditions are
> wrong.
>=20
> > +			/* 868 MHz BPSK 802.15.4-2003: 20 ksym/s */
> > +			duration =3D 50 * NSEC_PER_USEC;
> > +		else if (phy->current_page & 0x7FE) =20
>=20
> Ditto
>=20
> > +			/* 915 MHz BPSK	802.15.4-2003: 40 ksym/s */
> > +			duration =3D 25 * NSEC_PER_USEC;
> > +		else if (phy->current_page & 0x7FFF800) =20
>=20
> Ditto
>=20
> > +			/* 2400 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
> > +			duration =3D 16 * NSEC_PER_USEC;
> > +		break;
> > +	case 2:
> > +		if (BIT(phy->current_page) & 0x1) =20
>=20
> Ditto
>=20
> > +			/* 868 MHz O-QPSK 802.15.4-2006: 25 ksym/s */
> > +			duration =3D 40 * NSEC_PER_USEC;
> > +		else if (phy->current_page & 0x7FE) =20
>=20
> Ditto
>=20
> > +			/* 915 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
> > +			duration =3D 16 * NSEC_PER_USEC;
> > +		break;
> > +	case 3:
> > +		if (BIT(phy->current_page) & 0x3FFF) =20
>=20
> Ditto
>=20
> > +			/* 2.4 GHz CSS 802.15.4a-2007: 1/6 Msym/s */
> > +			duration =3D 6 * NSEC_PER_USEC;
> > +		break; =20
>=20
> I see it's "only" in wpan-next (781830c800dd "net: mac802154: Set
> durations automatically") and was not yet pulled in the net-next
> tree so please let me know what you prefer: I can either provide a
> proper patch to fit it (without upstream Fixes reference), or you can
> just apply this diff below and push -f the branch. Let me know what you
> prefer.
>=20
> Again, sorry to only see this now.
>=20
> Thanks,
> Miqu=C3=A8l
>=20
> commit 4122765e5f982ed8f0ccea5fd813ef4d53d20a90 (HEAD)
> Author: Miquel Raynal <miquel.raynal@bootlin.com>
> Date:   Thu Apr 28 17:57:59 2022 +0200
>=20
>     fixup! net: mac802154: Set durations automatically

And I keep having it wrong. Here is the right fixup!...

commit 676aa77f1c279a90f521c1c05757c702e1538472 (HEAD)
Author: Miquel Raynal <miquel.raynal@bootlin.com>
Date:   Thu Apr 28 17:57:59 2022 +0200

    fixup! net: mac802154: Set durations automatically

diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 5546ef86e231..bd7bdb1219dd 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -119,26 +119,26 @@ void ieee802154_configure_durations(struct wpan_phy *=
phy)
=20
        switch (phy->current_page) {
        case 0:
-               if (BIT(phy->current_page) & 0x1)
+               if (BIT(phy->current_channel) & 0x1)
                        /* 868 MHz BPSK 802.15.4-2003: 20 ksym/s */
                        duration =3D 50 * NSEC_PER_USEC;
-               else if (phy->current_page & 0x7FE)
+               else if (BIT(phy->current_channel) & 0x7FE)
                        /* 915 MHz BPSK 802.15.4-2003: 40 ksym/s */
                        duration =3D 25 * NSEC_PER_USEC;
-               else if (phy->current_page & 0x7FFF800)
+               else if (BIT(phy->current_channel) & 0x7FFF800)
                        /* 2400 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
                        duration =3D 16 * NSEC_PER_USEC;
                break;
        case 2:
-               if (BIT(phy->current_page) & 0x1)
+               if (BIT(phy->current_channel) & 0x1)
                        /* 868 MHz O-QPSK 802.15.4-2006: 25 ksym/s */
                        duration =3D 40 * NSEC_PER_USEC;
-               else if (phy->current_page & 0x7FE)
+               else if (BIT(phy->current_channel) & 0x7FE)
                        /* 915 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
                        duration =3D 16 * NSEC_PER_USEC;
                break;
        case 3:
-               if (BIT(phy->current_page) & 0x3FFF)
+               if (BIT(phy->current_channel) & 0x3FFF)
                        /* 2.4 GHz CSS 802.15.4a-2007: 1/6 Msym/s */
                        duration =3D 6 * NSEC_PER_USEC;
                break;
