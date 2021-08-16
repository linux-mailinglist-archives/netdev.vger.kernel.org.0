Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEAB3ED403
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhHPMeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbhHPMdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 08:33:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8066CC061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 05:33:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mFbnl-00010C-3c; Mon, 16 Aug 2021 14:33:13 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:3272:cc96:80a9:1a01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6482F6682CA;
        Mon, 16 Aug 2021 12:33:11 +0000 (UTC)
Date:   Mon, 16 Aug 2021 14:33:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add
 can_tdc_const::tdc{v,o,f}_min
Message-ID: <20210816123309.pfa57tke5hrycqae@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr>
 <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mous7h2ch4x6sr3w"
Content-Disposition: inline
In-Reply-To: <20210816122519.mme272z6tqrkyc6x@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mous7h2ch4x6sr3w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.08.2021 14:25:19, Marc Kleine-Budde wrote:
> > > I'm not sure, if we talked about the mcp251xfd's tcdo, valid values a=
re
> > > -64...63.
> >=20
> > Yes! Stefan shed some light on this. The mcp251xfd uses a tdco
> > value which is relative to the sample point.
>=20
> I don't read the documentation this way....
>=20
> > | SSP =3D TDCV + absolute TDCO
> > |     =3D TDCV + SP + relative TDCO
> >=20
> > Consequently:
> > | relative TDCO =3D absolute TDCO - SP
>=20
> In the mcp15xxfd family manual
> (http://ww1.microchip.com/downloads/en/DeviceDoc/MCP251XXFD-CAN-FD-Contro=
ller-Module-Family-Reference-Manual-20005678B.pdf)
> in the 2mbit/s data bit rate example in table 3-5 (page 21) it says:
>=20
> | DTSEG1  15 DTQ
> | DTSEG2   4 DTQ
> | TDCO    15 DTQ
>=20
> The mcp251xfd driver uses 15, the framework calculates 16 (=3D=3D Sync Se=
g+
> tseg1, which is correct), and relative tdco would be 0:
>=20
> | mcp251xfd_set_bittiming: tdco=3D15, priv->tdc.tdc=3D16, relative_tdco=
=3D0
>=20
> Here the output with the patched ip tool:

Sorry, the previous output was not using the sample points of the
example in the data sheet, this is the fixed output:

| 6: mcp251xfd0: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP =
mode DEFAULT group default qlen 10
|     link/can  promiscuity 0 minmtu 0 maxmtu 0=20
|     can <FD,TDC_AUTO> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart=
-ms 100=20
|           bitrate 500000 sample-point 0.800
|           tq 25 prop-seg 31 phase-seg1 32 phase-seg2 16 sjw 1 brp 1
|           mcp251xfd: tseg1 2..256 tseg2 1..128 sjw 1..128 brp 1..256 brp_=
inc 1
|           dbitrate 2000000 dsample-point 0.800
|           dtq 25 dprop-seg 7 dphase-seg1 8 dphase-seg2 4 dsjw 1 dbrp 1
|           tdco 16
|           mcp251xfd: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbr=
p_inc 1
|           tdco 0..127
|           clock 40000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 g=
so_max_segs 65535 parentbus spi parentdev spi0.0=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mous7h2ch4x6sr3w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEaWwMACgkQqclaivrt
76mIdQf/ZjXMNJovC6gVsk7bpzr0KHJZB1YmUOFDoboV3Ghv/YuNx5X3nPbtM4S4
TrfQOhjkYVV6Xi0ONIygWnlUXQQP5GeemF8tbK1GeO9ZNaOexwjWU5/mR2xJQQki
Ubj+wtI80hde07RVuDhQRTde3ugn5lzDtXFL6xYKJ5Zb9Nz/TUkxgbdluTj2v6lo
VTbBpzJwZwMDtIlg/1MRRD79/DkOLLycAQCK4F6OhU6488hyPIJxLKFes1kq+1zE
VpwuElW386P4g0BBjpP6sXmg9o1V3gSmdhkjYZHMCGBdz0zW4K7hCz6NAEzZGrS9
qH6HZnDStHbg1KECeadK+NwZdF0caw==
=xVXe
-----END PGP SIGNATURE-----

--mous7h2ch4x6sr3w--
