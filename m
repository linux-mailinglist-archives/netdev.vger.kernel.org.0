Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939713958B2
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhEaKFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 06:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhEaKFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 06:05:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F6DC061761
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 03:03:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lnelR-0004st-Tc; Mon, 31 May 2021 12:03:17 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:eb0a:85ec:ae31:4631])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8766762FC76;
        Mon, 31 May 2021 10:03:15 +0000 (UTC)
Date:   Mon, 31 May 2021 12:03:14 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 1/2] can: mcp251xfd: Try to get crystal clock rate
 from property
Message-ID: <20210531100314.w4ydd3ozhbb7k6sv@pengutronix.de>
References: <20210526193327.70468-1-andriy.shevchenko@linux.intel.com>
 <20210531084720.6xql2r4uhp6ruzl6@pengutronix.de>
 <YLSzRdpp9EWsLeFy@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="empwam5wixyaduli"
Content-Disposition: inline
In-Reply-To: <YLSzRdpp9EWsLeFy@smile.fi.intel.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--empwam5wixyaduli
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.05.2021 12:58:29, Andy Shevchenko wrote:
> On Mon, May 31, 2021 at 10:47:20AM +0200, Marc Kleine-Budde wrote:
> > On 26.05.2021 22:33:26, Andy Shevchenko wrote:
> > > In some configurations, mainly ACPI-based, the clock frequency of the=
 device
> > > is supplied by very well established 'clock-frequency' property. Henc=
e, try
> > > to get it from the property at last if no other providers are availab=
le.
>=20
> > >  		return dev_err_probe(&spi->dev, PTR_ERR(reg_xceiver),
> > >  				     "Failed to get Transceiver regulator!\n");
> > > =20
> > > -	clk =3D devm_clk_get(&spi->dev, NULL);
> > > +	/* Always ask for fixed clock rate from a property. */
> > > +	device_property_read_u32(&spi->dev, "clock-frequency", &rate);
> >=20
> > what about error handling....?
>=20
> Not needed, but rate should be assigned to 0, which is missed.
>=20
> > > +	clk =3D devm_clk_get_optional(&spi->dev, NULL);
> > >  	if (IS_ERR(clk))
> > >  		return dev_err_probe(&spi->dev, PTR_ERR(clk),
> > >  				     "Failed to get Oscillator (clock)!\n");
> > >  	freq =3D clk_get_rate(clk);
> > > +	if (freq =3D=3D 0)
> > > +		freq =3D rate;
> >=20
> > ... this means we don't fail if there is neither a clk nor a
> > clock-frequency property.
>=20
> The following will check for it (which is already in the code)
>=20
>   if (freq <=3D MCP251XFD_SYSCLOCK_HZ_MAX / MCP251XFD_OSC_PLL_MULTIPLIER)=
 {

Good point.

> > I've send a v3 to fix this.
>=20
> You mean I have to send v3?
> Sure!

I have send a v3, see:

https://lore.kernel.org/r/20210531084444.1785397-1-mkl@pengutronix.de

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--empwam5wixyaduli
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmC0tGAACgkQqclaivrt
76nmjAf9HvS70rVRdi2fcQ81qkc6xLuLuF8T2LbFeMvO9fXnU78jcz1leWRjFJNB
wkLzxUR93ZJ2OPvULVY4nzQ2wl10253zU2XFX49KcMZv7fsxCFaxmknf07mTmIRt
/Zz0PkQWF38HT1csD1qzoDfPJq/TDnL8f7sIUOCzeQ3E+uT84JMJg+3x3Hndw9U2
fb+E+r2FhF6vj+Qp8Hzux/PdxowFtn8KGGD3c6VfUdUjw4VTw2RPshQoktlVhkAA
2mrFotq2f8zyUvKEMZSaAZivjV09SGq1cLpj1kOH9a1LHp5dVTO4Z7PVXqqgxVJa
O6d81jNFSk2EpNGauXVC9ZAVLvfPOg==
=Ctl7
-----END PGP SIGNATURE-----

--empwam5wixyaduli--
