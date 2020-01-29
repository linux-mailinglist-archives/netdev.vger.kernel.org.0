Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB6614CDB8
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 16:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgA2PmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 10:42:11 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57309 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgA2PmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 10:42:11 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iwpTk-000389-Uy; Wed, 29 Jan 2020 16:42:08 +0100
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1iwpTe-0003Xa-19; Wed, 29 Jan 2020 16:42:02 +0100
Date:   Wed, 29 Jan 2020 16:42:01 +0100
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH] mdio-bitbang: add support for lowlevel mdio read/write
Message-ID: <20200129154201.oaxjbqkkyifvf5gg@pengutronix.de>
References: <20191107154201.GF7344@lunn.ch>
 <20191218162919.5293-1-m.grzeschik@pengutronix.de>
 <20191221164110.GL30801@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="awfu57qckk76lrid"
Content-Disposition: inline
In-Reply-To: <20191221164110.GL30801@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:38:07 up 205 days, 21:48, 93 users,  load average: 0.23, 0.23,
 0.19
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--awfu57qckk76lrid
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew!

I tested your patch. But it works only partially. For the case that
the upper driver is directly communicating in SMI mode with the phy,
this works fine. But the regular MDIO connection does not work anymore
afterwards.

The normals MDIO communication still needs to work, as mdio-gpio is
calling of_mdiobus_register that on the other end calls get_phy_device
and tries to communicate via regular MDIO to the device.

Fixing the whole bus to the SMI opcode breaks the regular commands.

Do you have any ideas how to fix that?

Regards,
Michael

On Sat, Dec 21, 2019 at 05:41:10PM +0100, Andrew Lunn wrote:
> Hi Michael
>=20
> In your V1 patch, you had this diagram.
>=20
> +/* Serial Management Interface (SMI) uses the following frame format:
> + *
> + *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits     =
 | Idle
> + *               |frame| OP code  |address |address|  |                 =
 |
> + * read | 32x1=C2=B4s | 01  |    00    | 1xRRR  | RRRRR |Z0| 00000000DDD=
DDDDD |  Z
> + * write| 32x1=C2=B4s | 01  |    00    | 0xRRR  | RRRRR |10| xxxxxxxxDDD=
DDDDD |  Z
> + *
> + */
>=20
> I just compared this to plain MDIO:
>=20
> + *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits     =
 | Idle
> + *               |frame| OP code  |address |address|  |                 =
 |
> + * read | 32x1=C2=B4s | 01  |    10    | AAAA   | RRRRR |Z0| DDDDDDDDDDD=
DDDDD |  Z
> + * write| 32x1=C2=B4s | 01  |    01    | AAAA   | RRRRR |10| DDDDDDDDDDD=
DDDDD |  Z
>=20
> So the only real issue here is the OP code? The rest you can do with a
> layer on top of the standard API.
>=20
> How about something like this. Totally untested, probably does not
> even compile.....
>=20
>      Andrew
>=20
> From 6051479b218fd19942d702e3e051c6355fe2a11f Mon Sep 17 00:00:00 2001
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Sat, 21 Dec 2019 10:31:19 -0600
> Subject: [PATCH] net: phy: Add support for microchip SMI0 MDIO bus.
>=20
> SMI0 is a mangled version of MDIO. The main low level difference is
> the MDIO C22 OP code is always 0, not 0x2 or 0x1 for Read/Write. The
> read/write information is instead encoded in the PHY address.
>=20
> Extend the bit-bang code to allow the op code to be overridden, but
> default to normal C22 values. Add an extra compatible to the mdio-gpio
> driver, and when this compatible is present, set the op codes to 0.
>=20
> A higher level driver, sitting on top of the basic MDIO bus driver can
> then implement the rest of the microchip SMI0 odderties.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/mdio-bitbang.c | 7 +++++--
>  drivers/net/phy/mdio-gpio.c    | 7 +++++++
>  include/linux/mdio-bitbang.h   | 2 ++
>  3 files changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitban=
g.c
> index 5136275c8e73..01f620889c78 100644
> --- a/drivers/net/phy/mdio-bitbang.c
> +++ b/drivers/net/phy/mdio-bitbang.c
> @@ -158,7 +158,7 @@ static int mdiobb_read(struct mii_bus *bus, int phy, =
int reg)
>  		reg =3D mdiobb_cmd_addr(ctrl, phy, reg);
>  		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
>  	} else
> -		mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
> +		mdiobb_cmd(ctrl, ctrl->op_c22_read, phy, reg);
> =20
>  	ctrl->ops->set_mdio_dir(ctrl, 0);
> =20
> @@ -189,7 +189,7 @@ static int mdiobb_write(struct mii_bus *bus, int phy,=
 int reg, u16 val)
>  		reg =3D mdiobb_cmd_addr(ctrl, phy, reg);
>  		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
>  	} else
> -		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
> +		mdiobb_cmd(ctrl, ctrl->op_c22_write, phy, reg);
> =20
>  	/* send the turnaround (10) */
>  	mdiobb_send_bit(ctrl, 1);
> @@ -216,6 +216,9 @@ struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl=
 *ctrl)
>  	bus->write =3D mdiobb_write;
>  	bus->priv =3D ctrl;
> =20
> +	ctrl->op_c22_read =3D MDIO_READ;
> +	ctrl->op_c22_write =3D MDIO_WRITE;
> +
>  	return bus;
>  }
>  EXPORT_SYMBOL(alloc_mdio_bitbang);
> diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
> index 1b00235d7dc5..282bc38331d7 100644
> --- a/drivers/net/phy/mdio-gpio.c
> +++ b/drivers/net/phy/mdio-gpio.c
> @@ -132,6 +132,12 @@ static struct mii_bus *mdio_gpio_bus_init(struct dev=
ice *dev,
>  		new_bus->phy_ignore_ta_mask =3D pdata->phy_ignore_ta_mask;
>  	}
> =20
> +	if (dev->of_node &&
> +	    of_device_is_compatible(dev->of_node, "microchip,mdio-smi0")) {
> +		bitbang->ctrl->op_c22_read =3D 0;
> +		bitbang->ctrl->op_c22_write =3D 0;
> +	}
> +
>  	dev_set_drvdata(dev, new_bus);
> =20
>  	return new_bus;
> @@ -196,6 +202,7 @@ static int mdio_gpio_remove(struct platform_device *p=
dev)
> =20
>  static const struct of_device_id mdio_gpio_of_match[] =3D {
>  	{ .compatible =3D "virtual,mdio-gpio", },
> +	{ .compatible =3D "microchip,mdio-smi0" },
>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, mdio_gpio_of_match);
> diff --git a/include/linux/mdio-bitbang.h b/include/linux/mdio-bitbang.h
> index 5d71e8a8500f..8ae0b3835233 100644
> --- a/include/linux/mdio-bitbang.h
> +++ b/include/linux/mdio-bitbang.h
> @@ -33,6 +33,8 @@ struct mdiobb_ops {
> =20
>  struct mdiobb_ctrl {
>  	const struct mdiobb_ops *ops;
> +	u8 op_c22_read;
> +	u8 op_c22_write;
>  };
> =20
>  /* The returned bus is not yet registered with the phy layer. */
> --=20
> 2.24.0
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--awfu57qckk76lrid
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl4xp8cACgkQC+njFXoe
LGTFJQ//fFmgTs8r2k5PJy0uxh1szu2S+gUjZPkIHq7UwAHF1ujT+r/CMqvYhKYc
p59Lbw2F925a/URNJaeAWzIq3QwbQhD+U45uGSkDtOsSFhjVru/OlnXb4nG3kAQ7
RmbV9cYrlbhqVl60nf00sxz75UP+GNGrWy768xVUfix6Y787opqjuoWj5FDspsJ0
tHdWT8stju1sof3KOO+Wie09fhyXKJyjymRyeoonCOa8oKa4sGsUbWQyLlBb0SHI
niI41TAWne44DxCTGlCuFKrGVin77aV13D2QrPZeYgSADHPuON38FoEa7Qt0e5/+
LW0enFrOXtBXXGpWLUr8H13ljMTVQbOrl+SPPBNvmwaNmrkX0VvWvYFkFbW3U4cw
5DxUdBifc71Y3pngUSNDVnAEE+s6hRYSJ5Rvt/n620L3ARY2Mi93lMHtILYVIq9q
oZREprwUKogbMFxO0PJWnlIoVDAgb0fo4uPlPvm0AgYAqOvunDH7LwFlNbLW5lVv
I4flgO/nr+I6uXvDCH83qU1ntmKcIrz2R1YAzatJ0lZ/jMTW9bDHee8Kvk0BJ6TI
BP0r1hlRORMqZ1YqfQXyA2qlpaWn6ZQ8TUa/xa/BA1Mt+3bvf1TuUL4VyvN4Og2Z
VedbNWGg38zn5wrGukkf4YC/SUazfX39azmixVb2soHzn++PfDo=
=9p46
-----END PGP SIGNATURE-----

--awfu57qckk76lrid--
