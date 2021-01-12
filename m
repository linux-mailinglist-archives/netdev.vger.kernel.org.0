Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA262F34F9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405732AbhALQDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:03:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405692AbhALQDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 11:03:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9007F2168B;
        Tue, 12 Jan 2021 16:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610467351;
        bh=9M2x8SQ461PJrurroZDHKXe/kkvP8IzUQSOzt9zmJA0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jgEyTjJAQyF7yvbknc1VF3h3aAWxx4vqLLa+idNTQVac6DSigQ7bC/Z8A1od+ypFN
         H8kpgy9tVRfkVGFYGgp3WNoUvlcnLIsnjZUQE3VwdIxtxQAVVaju2O3vMAzqrzEP6O
         GTNC7pVs9YMJGogBGKsMq6dRSXT5Rwy2AaknLQTRwP9lhfN9yD1uJjpJcHu7eEjWd+
         /77wJqFsrV+YvobehKx6XBq92OosYgiK3q19AX4Mn/NfGD1j7H+qeAaQfbfoVG9QGU
         cnl6IcVbJh2JvBXjT28f2rXo2zhrvy0jft6uwCKIvuSqbnCQPCdnS7UhYx6rr4eCG+
         S4laG+CfMjEOQ==
Date:   Tue, 12 Jan 2021 17:02:26 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v14 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210112170226.3f2009bd@kernel.org>
In-Reply-To: <20210112111139.hp56x5nzgadqlthw@skbuf>
References: <20210111012156.27799-1-kabel@kernel.org>
        <20210111012156.27799-6-kabel@kernel.org>
        <20210112111139.hp56x5nzgadqlthw@skbuf>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, 12 Jan 2021 13:11:39 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Mon, Jan 11, 2021 at 02:21:55AM +0100, Marek Beh=C3=BAn wrote:
> >   via which serveral more registers can be accessed indirectly =20
>               ~~~~~~~~
>               several

Thanks.

> > +static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, i=
nt port,
> > +					unsigned long *mask,
> > +					struct phylink_link_state *state)
> > +{
> > +	if (port =3D=3D 0 || port =3D=3D 9 || port =3D=3D 10) {
> > +		phylink_set(mask, 10000baseT_Full);
> > +		phylink_set(mask, 10000baseKR_Full); =20
>=20
> I think I understand the reason for declaring 10GBase-KR support in
> phylink_validate, in case the PHY supports that link mode on the media
> side, but...

Hmm, yes, maybe KR shouldn't be here, but then why is it in
mv88e6390x_phylink_validate?

> >  	case PHY_INTERFACE_MODE_2500BASEX:
> >  		cmode =3D MV88E6XXX_PORT_STS_CMODE_2500BASEX;
> >  		break;
> > +	case PHY_INTERFACE_MODE_5GBASER:
> > +		cmode =3D MV88E6393X_PORT_STS_CMODE_5GBASER;
> > +		break;
> >  	case PHY_INTERFACE_MODE_XGMII:
> >  	case PHY_INTERFACE_MODE_XAUI:
> >  		cmode =3D MV88E6XXX_PORT_STS_CMODE_XAUI;
> > @@ -457,6 +569,10 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6x=
xx_chip *chip, int port,
> >  	case PHY_INTERFACE_MODE_RXAUI:
> >  		cmode =3D MV88E6XXX_PORT_STS_CMODE_RXAUI;
> >  		break;
> > +	case PHY_INTERFACE_MODE_10GBASER:
> > +	case PHY_INTERFACE_MODE_10GKR: =20
>=20
> Does the SERDES actually support 10GBase-KR (aka 10GBase-R for copper
> backplanes)? It is different than plain 10GBase-R (abusingly called XFI)
> by the need of a link training procedure to negotiate SERDES eye
> parameters. There have been discussion in the past where it turned out
> that drivers which didn't really support 10GBase-KR incorrectly reported
> that they did.

Yes, PHY_INTERFACE_MODE_10GKR should probably not be here. I think some
other drivers still support it because of old device trees, but this
driver does not need to.

> > +static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, i=
nt port,
> > +					u16 pointer, u8 data)
> > +{
> > +	u16 reg;
> > +
> > +	reg =3D MV88E6393X_PORT_POLICY_MGMT_CTL_UPDATE | pointer | data; =20
>=20
> I think the assignment fits on the same line as the declaration?
>

And I think it read better this way. But even if it was not, this
structure of code was copied from mv88e6390_g1_monitor_write in
global1.c, where it is written this way. I prefer this patch to do a
new thing in the same style. If you want, you can then send a patch
that changes it in all places at once.

> > +static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, =
int lane,
> > +					 bool on)
> > +{
> > +	u8 cmode =3D chip->ports[lane].cmode;
> > +	u16 reg, pcs;
> > +	int err;
> > +
> > +	if (on) { =20
>=20
> And if "on" is false? Nothing? Why even pass it as an argument then? Why
> even call mv88e6393x_serdes_port_config?

You are right, I will change it.

Thanks, Vladimir.
