Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A141CB4F7
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 18:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgEHQ1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 12:27:13 -0400
Received: from lists.nic.cz ([217.31.204.67]:37406 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgEHQ1M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 12:27:12 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 5C1ED13FB54;
        Fri,  8 May 2020 18:27:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1588955227; bh=suGhchY1ulLQY4RmZQ2UnoGzrm4wLfhZyj9JhNM/N+U=;
        h=Date:From:To;
        b=qvenYKtuXZXy/Q8B6XFT3pX7s1Hw3ctTE4+kniO0mW3jyDV/9e1oC6TrWXfMEl/G0
         bQRXi00s6vrdFiDRrpi0jYNoZK/ESoh5RBTQtTW7CpYB8wbwQPJ1a+GdeAn2J4zJ96
         /RYXdyR2QON/9SENASmnODd1rU5W+eEgDn/HXlrM=
Date:   Fri, 8 May 2020 18:27:06 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: add some quirks for FreeTel direct
 attach modules
Message-ID: <20200508182706.06394c88@nic.cz>
In-Reply-To: <20200508152844.GV1551@shell.armlinux.org.uk>
References: <20200507132135.316-1-marek.behun@nic.cz>
        <20200508152844.GV1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 16:28:44 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Thu, May 07, 2020 at 03:21:35PM +0200, Marek Beh=C3=BAn wrote:
> > FreeTel P.C30.2 and P.C30.3 may fail to report anything useful from
> > their EEPROM. They report correct nominal bitrate of 10300 MBd, but do
> > not report sfp_ct_passive nor sfp_ct_active in their ERPROM.
> >=20
> > These modules can also operate at 1000baseX and 2500baseX.
> >=20
> > Signed-off-by: Marek Beh=C3=BAn <marek.behun@nic.cz>
> > Cc: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/phy/sfp-bus.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >=20
> > diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> > index 6900c68260e0..f021709bedcc 100644
> > --- a/drivers/net/phy/sfp-bus.c
> > +++ b/drivers/net/phy/sfp-bus.c
> > @@ -44,6 +44,14 @@ static void sfp_quirk_2500basex(const struct sfp_eep=
rom_id *id,
> >  	phylink_set(modes, 2500baseX_Full);
> >  }
> > =20
> > +static void sfp_quirk_direct_attach_10g(const struct sfp_eeprom_id *id,
> > +					unsigned long *modes)
> > +{
> > +	phylink_set(modes, 10000baseCR_Full);
> > +	phylink_set(modes, 2500baseX_Full);
> > +	phylink_set(modes, 1000baseX_Full);
> > +}
> > +
> >  static const struct sfp_quirk sfp_quirks[] =3D {
> >  	{
> >  		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
> > @@ -63,6 +71,18 @@ static const struct sfp_quirk sfp_quirks[] =3D {
> >  		.vendor =3D "HUAWEI",
> >  		.part =3D "MA5671A",
> >  		.modes =3D sfp_quirk_2500basex,
> > +	}, {
> > +		// FreeTel P.C30.2 is a SFP+ direct attach that can operate at
> > +		// at 1000baseX, 2500baseX and 10000baseCR, but may report none
> > +		// of these in their EEPROM
> > +		.vendor =3D "FreeTel",
> > +		.part =3D "P.C30.2",
> > +		.modes =3D sfp_quirk_direct_attach_10g,
> > +	}, {
> > +		// same as previous
> > +		.vendor =3D "FreeTel",
> > +		.part =3D "P.C30.3",
> > +		.modes =3D sfp_quirk_direct_attach_10g, =20
>=20
> Looking at the EEPROM capabilities, it seems that these modules give
> either:
>=20
> Transceiver codes     : 0x01 0x00 0x00 0x00 0x00 0x04 0x80 0x00 0x00
> Transceiver type      : Infiniband: 1X Copper Passive
> Transceiver type      : Passive Cable
> Transceiver type      : FC: Twin Axial Pair (TW)
> Encoding              : 0x06 (64B/66B)
> BR, Nominal           : 10300MBd
> Passive Cu cmplnce.   : 0x01 (SFF-8431 appendix E) [SFF-8472 rev10.4 only]
> BR margin, max        : 0%
> BR margin, min        : 0%
>=20
> or:
>=20
> Transceiver codes     : 0x00 0x00 0x00 0x00 0x00 0x04 0x80 0x00 0x00
> Transceiver type      : Passive Cable
> Transceiver type      : FC: Twin Axial Pair (TW)
> Encoding              : 0x06 (64B/66B)
> BR, Nominal           : 10300MBd
> Passive Cu cmplnce.   : 0x01 (SFF-8431 appendix E) [SFF-8472 rev10.4 only]
> BR margin, max        : 0%
> BR margin, min        : 0%
>=20
> These give ethtool capability mask of 000,00000600,0000e040, which
> is:
>=20
> 	2500baseX (bit 15)
> 	1000baseX (bit 41)
> 	10000baseCR (bit 42)
>=20
> 10000baseCR, 2500baseX and 1000baseX comes from:
>=20
>         if ((id->base.sfp_ct_passive || id->base.sfp_ct_active) && br_nom=
) {
>                 /* This may look odd, but some manufacturers use 12000MBd=
 */
>                 if (br_min <=3D 12000 && br_max >=3D 10300)
>                         phylink_set(modes, 10000baseCR_Full);
>                 if (br_min <=3D 3200 && br_max >=3D 3100)
>                         phylink_set(modes, 2500baseX_Full);
>                 if (br_min <=3D 1300 && br_max >=3D 1200)
>                         phylink_set(modes, 1000baseX_Full);
>=20
> since id->base.sfp_ct_passive is true, and br_nom =3D br_max =3D 10300 and
> br_min =3D 0.
>=20
> 10000baseCR will also come from:
>=20
>         if (id->base.sfp_ct_passive) {
>                 if (id->base.passive.sff8431_app_e)
>                         phylink_set(modes, 10000baseCR_Full);
>         }
>=20
> You claimed in your patch description that sfp_ct_passive is not set,
> but the EEPROM dumps contain:
>=20
> 	Transceiver type      : Passive Cable
>=20
> which is correctly parsed by the kernel.
>=20
> So, I'm rather confused, and I don't see why this patch is needed.
>=20

Russell,

something is wrong here, and it is my bad. I hope I didn't mix
the EEPROM images from when I was playing with the contents, but it
seems possible now :( I probably sent you modified images and lost the
original ones.

The thing I know for sure is that it did not work when I got the
cables and also that they had different contents inside - ie at least
one side of one cable did not report ct_passive nor ct_active. And I
think that they reported different things on each side.

I will try to get another such cable and return to this.

Marek
