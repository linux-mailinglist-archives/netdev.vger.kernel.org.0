Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334DC46CF87
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhLHI6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhLHI6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:58:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD47C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 00:54:50 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1musit-0000Ex-Vq; Wed, 08 Dec 2021 09:54:48 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-e45e-c028-b01c-c307.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:e45e:c028:b01c:c307])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B614C6BF96B;
        Wed,  8 Dec 2021 08:54:45 +0000 (UTC)
Date:   Wed, 8 Dec 2021 09:54:44 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Modilaynen, Pavel" <pavel.modilaynen@volvocars.com>
Cc:     "drew@beagleboard.org" <drew@beagleboard.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "menschel.p@posteo.de" <menschel.p@posteo.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "will@macchina.cc" <will@macchina.cc>
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Message-ID: <20211208085444.j47kse2b7vnde2xd@pengutronix.de>
References: <20210510074334.el2yxp3oy2pmbs7d@pengutronix.de>
 <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4lwcklrvy4hwyxiu"
Content-Disposition: inline
In-Reply-To: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4lwcklrvy4hwyxiu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.12.2021 16:53:12, Modilaynen, Pavel wrote:
> Hello Marc,
>=20
> We observe the very similar issue with MCP2517FD.
>=20
> >The CRC errors the patch works around are CRC errors introduced by a
> >chip erratum, not by electromagnetic interference. In my observation
>=20
> Are you referring this errata doc
> https://datasheet.octopart.com/MCP2517FD-H-JHA-Microchip-datasheet-136609=
045.pdf ?

ACK - although there are newer versions available. The newest erratum
for the mcp2517fd is the "C" issue:

| https://ww1.microchip.com/downloads/en/DeviceDoc/MCP2517FD-Silicon-Errata=
-and-Data-Sheet-Clarification-DS80000792C.pdf

The mpc2518fd can be downloaded here:

| https://ww1.microchip.com/downloads/en/DeviceDoc/MCP2518FD-Silicon-Errata=
-and-Data-Sheet-Clarification-DS80000789C.pdf

> We have the similar CRC read errors but
> the lowest byte is not 0x00 and 0x80, it's actually 0x0x or 0x8x, e.g.
>=20
> mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=3D4, data=
=3D82 d1 fa 6c, CRC=3D0xd9c2) retrying.
>=20
> 0xb0 0x10 0x04 0x82 0xd1 0xfa 0x6c =3D> 0x59FD (not matching)
>=20
> but if I flip the first received bit  (highest bit in the lowest byte):
> 0xb0 0x10 0x04 0x02 0xd1 0xfa 0x6c =3D> 0xD9C2 (matching!)
>=20
> So, your fix covers only the case of 0x00 and 0x80,=20
> do you think that the workaround should be extended so check
>      (buf_rx->data[0] =3D=3D 0x0 || buf_rx->data[0] =3D=3D 0x80)) {
> turns into=20
>      ((buf_rx->data[0] & 0xf0) =3D=3D 0x0 || (buf_rx->data[0] & 0xf0) =3D=
=3D 0x80)) {
>=20
> Errata, actually says
> "Only bits 7/15/23/31 of the following registers can be affected:"
>=20
> So, we could basically, in simplest case flip bit 31 and re-check CRC
> without any check of rx->data[0]....

Can you send a patch that updates the workaround and description.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--4lwcklrvy4hwyxiu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmGwctIACgkQqclaivrt
76nEaAgAsPQpUDk019EElxIJvT/tejKNWXdP1as3EyE/qpEQZLZ9gIvnQCEFKA64
ndw02h69iFMZwWbSdqL7Q+jjTHCBjb21dADY0z90zY5P9p3A2hSWtJPu8WWwUZER
fGfiBmUqJ+0hfajoToFTeaxvSHDHsdjs7Lg3fW+oG2Yw9g5EK4m9AEYilQVNuq+B
P3JZZmujeqB/uLL5FHmyEHKl0QJRzWflgSpJ4D0T+9yLFavr8KEHAmqNS+3mShwG
s0SJoa9ou9emt3nCxiyzjcNlzdtMU2rRSZ+5KDUq3nFSbHADqgi04o9yJH45JTzN
eBrkCY/KT7kQIvY2mLIiXa9MyPw7YQ==
=qSKS
-----END PGP SIGNATURE-----

--4lwcklrvy4hwyxiu--
