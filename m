Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C6535E268
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242392AbhDMPNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhDMPNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 11:13:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29021613B3;
        Tue, 13 Apr 2021 15:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618326762;
        bh=eAMINRy0iCnq/PGCPbdRVJfTQgHFUZp7G5S/mEDJS/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=frn9yPw9vzDYyPcZp3Ml6R/AF8ouH4eYW7SQYnJe71ZyF9donSMDC76Ur1qTdKg2i
         I7biqNDHKkBH5fUaT0E0HxgGJ9IiM5d0LwVOnsOascHGuYGdMFhwrZc8g3AY0eIoEC
         LPHTDmC30Dq+SYhe9UI2CbplVrzkCk6AoGgqfP2BjkSU5ymR8HKkXkQQPfUzb3v+av
         lt1Obd+UpXPom+sGkYPxlAfXAGONQ9wwjyr7nKlsAm+SS91ux5g8gCFpqpQQwYnJ+h
         aKRkYDbat85ZJdsWy6hGNor3kRzYe9oGoOEm54Hcv3JNa/YRNYjMOfI/eE0enN3viX
         E6iCzwGbDqpSw==
Date:   Tue, 13 Apr 2021 17:12:38 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Subject: Re: [PATCH net-next 2/5] net: phy: marvell: fix HWMON enable
 register for 6390
Message-ID: <20210413171238.1da8c4ce@thinkpad>
In-Reply-To: <YHWp3UToOvq8k3wJ@lunn.ch>
References: <20210413075538.30175-1-kabel@kernel.org>
        <20210413075538.30175-3-kabel@kernel.org>
        <YHWp3UToOvq8k3wJ@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 16:25:33 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Tue, Apr 13, 2021 at 09:55:35AM +0200, Marek Beh=C3=BAn wrote:
> > Register 27_6.15:14 has the following description in 88E6393X
> > documentation:
> >   Temperature Sensor Enable
> >     0x0 - Sample every 1s
> >     0x1 - Sense rate decided by bits 10:8 of this register
> >     0x2 - Use 26_6.5 (One shot Temperature Sample) to enable
> >     0x3 - Disable
> >=20
> > This is compatible with how the 6390 code uses this register currently,
> > but the 6390 code handles it as two 1-bit registers (somewhat), instead
> > of one register with 4 possible values.
> >=20
> > Rename this register and define all 4 values according to 6393X
> > documentation.
> >=20
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > ---
> >  drivers/net/phy/marvell.c | 19 +++++++++----------
> >  1 file changed, 9 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> > index 63788d5c13eb..bae2a225b550 100644
> > --- a/drivers/net/phy/marvell.c
> > +++ b/drivers/net/phy/marvell.c
> > @@ -113,11 +113,11 @@
> >  #define MII_88E1540_COPPER_CTRL3_FAST_LINK_DOWN		BIT(9)
> > =20
> >  #define MII_88E6390_MISC_TEST		0x1b
> > -#define MII_88E6390_MISC_TEST_SAMPLE_1S		0
> > -#define MII_88E6390_MISC_TEST_SAMPLE_10MS	BIT(14)
> > -#define MII_88E6390_MISC_TEST_SAMPLE_DISABLE	BIT(15)
> > -#define MII_88E6390_MISC_TEST_SAMPLE_ENABLE	0
> > -#define MII_88E6390_MISC_TEST_SAMPLE_MASK	(0x3 << 14)
> > +#define MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_SAMPLE_1S	(0x0 << 14)
> > +#define MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE		(0x1 << 14)
> > +#define MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_ONESHOT	(0x2 << 14)
> > +#define MII_88E6390_MISC_TEST_TEMP_SENSOR_DISABLE		(0x3 << 14)
> > +#define MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK			(0x3 << 14)
> > =20
> >  #define MII_88E6390_TEMP_SENSOR		0x1c
> >  #define MII_88E6390_TEMP_SENSOR_MASK	0xff
> > @@ -2352,9 +2352,8 @@ static int m88e6390_get_temp(struct phy_device *p=
hydev, long *temp)
> >  	if (ret < 0)
> >  		goto error;
> > =20
> > -	ret =3D ret & ~MII_88E6390_MISC_TEST_SAMPLE_MASK;
> > -	ret |=3D MII_88E6390_MISC_TEST_SAMPLE_ENABLE |
> > -		MII_88E6390_MISC_TEST_SAMPLE_1S;
> > +	ret =3D ret & ~MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK;
> > +	ret |=3D MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_SAMPLE_1S; =20
>=20
> So this is identical
>=20
> > =20
> >  	ret =3D __phy_write(phydev, MII_88E6390_MISC_TEST, ret);
> >  	if (ret < 0)
> > @@ -2381,8 +2380,8 @@ static int m88e6390_get_temp(struct phy_device *p=
hydev, long *temp)
> >  	if (ret < 0)
> >  		goto error;
> > =20
> > -	ret =3D ret & ~MII_88E6390_MISC_TEST_SAMPLE_MASK;
> > -	ret |=3D MII_88E6390_MISC_TEST_SAMPLE_DISABLE;
> > +	ret =3D ret & ~MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK;
> > +	ret |=3D MII_88E6390_MISC_TEST_TEMP_SENSOR_DISABLE; =20
>=20
> And here we have gone from 0x2 to 0x3?
>=20
> Have you checked the 6390 datasheet for this?
>=20
> I will test these patches later.
>=20
>      Andrew

The 6390 datasheet does not contain specification for temperature
sensor anymore. I will look into older versions.
