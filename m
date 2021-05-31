Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F527395756
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 10:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhEaItb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 04:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbhEaItQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 04:49:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E9BC061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:47:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lndZy-0003CN-NZ; Mon, 31 May 2021 10:47:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:eb0a:85ec:ae31:4631])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CD72F62FB35;
        Mon, 31 May 2021 08:47:20 +0000 (UTC)
Date:   Mon, 31 May 2021 10:47:20 +0200
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
Message-ID: <20210531084720.6xql2r4uhp6ruzl6@pengutronix.de>
References: <20210526193327.70468-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2berr7nn6ppdwg42"
Content-Disposition: inline
In-Reply-To: <20210526193327.70468-1-andriy.shevchenko@linux.intel.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2berr7nn6ppdwg42
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.05.2021 22:33:26, Andy Shevchenko wrote:
> In some configurations, mainly ACPI-based, the clock frequency of the dev=
ice
> is supplied by very well established 'clock-frequency' property. Hence, t=
ry
> to get it from the property at last if no other providers are available.
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> v2: new patch
>  drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net=
/can/spi/mcp251xfd/mcp251xfd-core.c
> index e0ae00e34c7b..e42f87c3f2ec 100644
> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> @@ -2856,7 +2856,7 @@ static int mcp251xfd_probe(struct spi_device *spi)
>  	struct gpio_desc *rx_int;
>  	struct regulator *reg_vdd, *reg_xceiver;
>  	struct clk *clk;
> -	u32 freq;
> +	u32 freq, rate;
>  	int err;
> =20
>  	if (!spi->irq)
> @@ -2883,11 +2883,16 @@ static int mcp251xfd_probe(struct spi_device *spi)
>  		return dev_err_probe(&spi->dev, PTR_ERR(reg_xceiver),
>  				     "Failed to get Transceiver regulator!\n");
> =20
> -	clk =3D devm_clk_get(&spi->dev, NULL);
> +	/* Always ask for fixed clock rate from a property. */
> +	device_property_read_u32(&spi->dev, "clock-frequency", &rate);

what about error handling....?

> +
> +	clk =3D devm_clk_get_optional(&spi->dev, NULL);
>  	if (IS_ERR(clk))
>  		return dev_err_probe(&spi->dev, PTR_ERR(clk),
>  				     "Failed to get Oscillator (clock)!\n");
>  	freq =3D clk_get_rate(clk);
> +	if (freq =3D=3D 0)
> +		freq =3D rate;

=2E.. this means we don't fail if there is neither a clk nor a
clock-frequency property. I've send a v3 to fix this.

> =20
>  	/* Sanity check */
>  	if (freq < MCP251XFD_SYSCLOCK_HZ_MIN ||
> --=20
> 2.30.2
>=20
>

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2berr7nn6ppdwg42
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmC0opUACgkQqclaivrt
76kAVAgAqxbBCmlQAhoPyB073hbARvhTkRMi7Q//Py9WHyiwEPwLFfAvTGN/7sFr
R7B09kzNaahBQ+bX/BclI5UcsGva5QgGouXJDz8MF/ilXskAeqzVhw4GUJbVj2EJ
CYVk1Hu4QebsFgUH0+g8PPd4R6FxK3t+xPmG9KlyHy6DC+zTCl8AK8PbvJcKMdHH
s1mM09kknfCCUVlT8xyUifEYY9OyPj+OHfsxMiRzxqRKx+ep5/wmgy2BJ/C0I4YC
2cU044bLKbcNd21nduqrt8uD9+QBL4J10MNhGZW3J3nonzmXiEJ48vLOLXLZqKAR
AQC/CFipnfIvuy7Ctupd0xLvmMcH7Q==
=58nX
-----END PGP SIGNATURE-----

--2berr7nn6ppdwg42--
