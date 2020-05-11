Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4B51CDF40
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbgEKPkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730362AbgEKPks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:40:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1B6C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:40:48 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jYAXu-00065O-UW; Mon, 11 May 2020 17:40:46 +0200
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jYAXu-0006pm-Kb; Mon, 11 May 2020 17:40:46 +0200
Date:   Mon, 11 May 2020 17:40:46 +0200
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH v3 1/5] net: phy: Add support for microchip SMI0 MDIO bus
Message-ID: <20200511154046.GN20451@pengutronix.de>
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
 <20200508154343.6074-2-m.grzeschik@pengutronix.de>
 <08858b46-95f0-24d0-0e11-1eaec292187c@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oIlomvtVtXAVxSKT"
Content-Disposition: inline
In-Reply-To: <08858b46-95f0-24d0-0e11-1eaec292187c@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:40:02 up 81 days, 23:10, 117 users,  load average: 0.09, 0.15,
 0.16
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--oIlomvtVtXAVxSKT
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 09, 2020 at 10:28:05AM -0700, Florian Fainelli wrote:
>
>
>On 5/8/2020 8:43 AM, Michael Grzeschik wrote:
>>From: Andrew Lunn <andrew@lunn.ch>
>>
>>SMI0 is a mangled version of MDIO. The main low level difference is
>>the MDIO C22 OP code is always 0, not 0x2 or 0x1 for Read/Write. The
>>read/write information is instead encoded in the PHY address.
>>
>>Extend the bit-bang code to allow the op code to be overridden, but
>>default to normal C22 values. Add an extra compatible to the mdio-gpio
>>driver, and when this compatible is present, set the op codes to 0.
>>
>>A higher level driver, sitting on top of the basic MDIO bus driver can
>>then implement the rest of the microchip SMI0 odderties.
>>
>>Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>>Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
>>---
>>  drivers/net/phy/mdio-bitbang.c |  7 ++-----
>>  drivers/net/phy/mdio-gpio.c    | 13 +++++++++++++
>>  include/linux/mdio-bitbang.h   |  2 ++
>>  3 files changed, 17 insertions(+), 5 deletions(-)
>>
>>diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitban=
g.c
>>index 5136275c8e7399..11255460ecb933 100644
>>--- a/drivers/net/phy/mdio-bitbang.c
>>+++ b/drivers/net/phy/mdio-bitbang.c
>>@@ -19,9 +19,6 @@
>>  #include <linux/types.h>
>>  #include <linux/delay.h>
>>-#define MDIO_READ 2
>>-#define MDIO_WRITE 1
>>-
>>  #define MDIO_C45 (1<<15)
>>  #define MDIO_C45_ADDR (MDIO_C45 | 0)
>>  #define MDIO_C45_READ (MDIO_C45 | 3)
>>@@ -158,7 +155,7 @@ static int mdiobb_read(struct mii_bus *bus, int phy, =
int reg)
>>  		reg =3D mdiobb_cmd_addr(ctrl, phy, reg);
>>  		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
>>  	} else
>>-		mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
>>+		mdiobb_cmd(ctrl, ctrl->op_c22_read, phy, reg);
>>  	ctrl->ops->set_mdio_dir(ctrl, 0);
>>@@ -189,7 +186,7 @@ static int mdiobb_write(struct mii_bus *bus, int phy,=
 int reg, u16 val)
>>  		reg =3D mdiobb_cmd_addr(ctrl, phy, reg);
>>  		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
>>  	} else
>>-		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
>>+		mdiobb_cmd(ctrl, ctrl->op_c22_write, phy, reg);
>
>There are other users of the mdio-bitbang.c file which I believe you=20
>are going to break here because they will not initialize op_c22_write=20
>or op_c22_read, and thus they will be using 0, instead of MDIO_READ=20
>and MDIO_WRITE. I believe you need something like the patch attached.
>--=20
>Florian

I will add that change to v4.

Michael

>diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang=
=2Ec
>index 11255460ecb9..528e255d1ffe 100644
>--- a/drivers/net/phy/mdio-bitbang.c
>+++ b/drivers/net/phy/mdio-bitbang.c
>@@ -19,6 +19,9 @@
> #include <linux/types.h>
> #include <linux/delay.h>
>
>+#define MDIO_READ 2
>+#define MDIO_WRITE 1
>+
> #define MDIO_C45 (1<<15)
> #define MDIO_C45_ADDR (MDIO_C45 | 0)
> #define MDIO_C45_READ (MDIO_C45 | 3)
>@@ -212,6 +215,10 @@ struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl=
 *ctrl)
> 	bus->read =3D mdiobb_read;
> 	bus->write =3D mdiobb_write;
> 	bus->priv =3D ctrl;
>+	if (!ctrl->override_op_c22) {
>+		ctrl->op_c22_read =3D MDIO_READ;
>+		ctrl->op_c22_write =3D MDIO_WRITE;
>+	}
>
> 	return bus;
> }
>diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
>index d85bc1a98647..13ec31e89e94 100644
>--- a/drivers/net/phy/mdio-gpio.c
>+++ b/drivers/net/phy/mdio-gpio.c
>@@ -27,9 +27,6 @@
> #include <linux/gpio/consumer.h>
> #include <linux/of_mdio.h>
>
>-#define MDIO_READ 2
>-#define MDIO_WRITE 1
>-
> struct mdio_gpio_info {
> 	struct mdiobb_ctrl ctrl;
> 	struct gpio_desc *mdc, *mdio, *mdo;
>@@ -139,9 +136,7 @@ static struct mii_bus *mdio_gpio_bus_init(struct devic=
e *dev,
> 	    of_device_is_compatible(dev->of_node, "microchip,mdio-smi0")) {
> 		bitbang->ctrl.op_c22_read =3D 0;
> 		bitbang->ctrl.op_c22_write =3D 0;
>-	} else {
>-		bitbang->ctrl.op_c22_read =3D MDIO_READ;
>-		bitbang->ctrl.op_c22_write =3D MDIO_WRITE;
>+		bitbang->ctrl.override_op_c22 =3D 1;
> 	}
>
> 	dev_set_drvdata(dev, new_bus);
>diff --git a/include/linux/mdio-bitbang.h b/include/linux/mdio-bitbang.h
>index 8ae0b3835233..5016e6f60de3 100644
>--- a/include/linux/mdio-bitbang.h
>+++ b/include/linux/mdio-bitbang.h
>@@ -33,6 +33,7 @@ struct mdiobb_ops {
>
> struct mdiobb_ctrl {
> 	const struct mdiobb_ops *ops;
>+	unsigned int override_op_c22;
> 	u8 op_c22_read;
> 	u8 op_c22_write;
> };


--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--oIlomvtVtXAVxSKT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl65cf4ACgkQC+njFXoe
LGShEQ/9FgeR0z9BmA0YcvLgnxwtzZTiLD8HEE68xXOoAITgvlt669vihEK+lYdx
IFfGUsR0FOZF858W7x516rN1hCGqad0gY2fjuPqi8aMH83q3ipgorfcIPWsl75zY
DXdAXEqw6YkNvVU+TCkCjVgvN0fUsPalXe8TftHGlZkGoAo5s5HT3hg839H29mx+
qyh0mlyeuNmg6CKBU04NgOw78hLKXRvSLxO79mBitaUna/2w3tagKIcj9Y8q5GKg
FfMnfE6x20vlV21Tf2hYSWDXM0/OjE6JdMa/EV7hzpTfsxHl9r4upflYU7V+syEc
ve23gR8ree+uJnJVbSAtxIHVThtKSm0WDHQZoOCzdGRno/V1/65XJEklQLZQCF/s
7LeUP2oUvjci229D4PK0tA4nKlXt2WDE7A4GmH5h6OuXkPi5r/0sJcun4xV1r+B8
uedgGTCeWbrhFXDRhQi///lQBxB2Qk9EnOeldjtKNI0GqwwCPqiyUlB6uP3M8aYI
QQjEm/dUupD/+SH7qOZ8D28GkA1KeWRZ2JDA87q554kxK4zm5gAlEQtlXtB7X93g
X9zuPsDr0j195alQDTOSJp7pgM2ULY3yFDAQTLnbXhkA7M1ATD7kI9R8HImuceR9
GA0zMNkPudW2B0Guy0mSvjjR1oKFwdvRwRJa9VIwhKzI3FFZgyc=
=FBRK
-----END PGP SIGNATURE-----

--oIlomvtVtXAVxSKT--
