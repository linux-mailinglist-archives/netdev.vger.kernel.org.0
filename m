Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133583ED3DF
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhHPM0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhHPMZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 08:25:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B953CC061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 05:25:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mFbgA-0000AU-Rp; Mon, 16 Aug 2021 14:25:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:3272:cc96:80a9:1a01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EFFB46682BB;
        Mon, 16 Aug 2021 12:25:20 +0000 (UTC)
Date:   Mon, 16 Aug 2021 14:25:19 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add
 can_tdc_const::tdc{v,o,f}_min
Message-ID: <20210816122519.mme272z6tqrkyc6x@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr>
 <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4wa7afvud7rocqox"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4wa7afvud7rocqox
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.08.2021 19:24:43, Vincent MAILHOL wrote:
> On Mon. 16 Aug 2021 at 17:42, Marc Kleine-Budde <mkl@pengutronix.de> wrot=
e:
> > On 15.08.2021 12:32:43, Vincent Mailhol wrote:
> > > ISO 11898-1 specifies in section 11.3.3 "Transmitter delay
> > > compensation" that "the configuration range for [the] SSP position
> > > shall be at least 0 to 63 minimum time quanta."
> > >
> > > Because SSP =3D TDCV + TDCO, it means that we should allow both TDCV =
and
> > > TDCO to hold zero value in order to honor SSP's minimum possible
> > > value.
> > >
> > > However, current implementation assigned special meaning to TDCV and
> > > TDCO's zero values:
> > >   * TDCV =3D 0 -> TDCV is automatically measured by the transceiver.
> > >   * TDCO =3D 0 -> TDC is off.
> > >
> > > In order to allow for those values to really be zero and to maintain
> > > current features, we introduce two new flags:
> > >   * CAN_CTRLMODE_TDC_AUTO indicates that the controller support
> > >     automatic measurement of TDCV.
> > >   * CAN_CTRLMODE_TDC_MANUAL indicates that the controller support
> > >     manual configuration of TDCV. N.B.: current implementation failed
> > >     to provide an option for the driver to indicate that only manual
> > >     mode was supported.
> > >
> > > TDC is disabled if both CAN_CTRLMODE_TDC_AUTO and
> > > CAN_CTRLMODE_TDC_MANUAL flags are off, c.f. the helper function
> > > can_tdc_is_enabled() which is also introduced in this patch.
> >
> > Nitpick: We can only say that TDC is disabled, if the driver supports
> > the TDC interface at all, which is the case if tdc_const is set.
>=20
> I would argue that saying that a device does not support TDC is
> equivalent to saying that TDC is always disabled for that device.
> Especially, the function can_tdc_is_enabled() can be used even if
> the device does not support TDC (even if there is no benefit
> doing so).
>=20
> Do you still want me to rephrase this part?
>=20
> > > Also, this patch adds three fields: tdcv_min, tdco_min and tdcf_min to
> > > struct can_tdc_const. While we are not convinced that those three
> > > fields could be anything else than zero, we can imagine that some
> > > controllers might specify a lower bound on these. Thus, those minimums
> > > are really added "just in case".
> >
> > I'm not sure, if we talked about the mcp251xfd's tcdo, valid values are
> > -64...63.
>=20
> Yes! Stefan shed some light on this. The mcp251xfd uses a tdco
> value which is relative to the sample point.

I don't read the documentation this way....

> | SSP =3D TDCV + absolute TDCO
> |     =3D TDCV + SP + relative TDCO
>=20
> Consequently:
> | relative TDCO =3D absolute TDCO - SP

In the mcp15xxfd family manual
(http://ww1.microchip.com/downloads/en/DeviceDoc/MCP251XXFD-CAN-FD-Controll=
er-Module-Family-Reference-Manual-20005678B.pdf)
in the 2mbit/s data bit rate example in table 3-5 (page 21) it says:

| DTSEG1  15 DTQ
| DTSEG2   4 DTQ
| TDCO    15 DTQ

The mcp251xfd driver uses 15, the framework calculates 16 (=3D=3D Sync Seg+
tseg1, which is correct), and relative tdco would be 0:

| mcp251xfd_set_bittiming: tdco=3D15, priv->tdc.tdc=3D16, relative_tdco=3D0

Here the output with the patched ip tool:

| 4: mcp251xfd0: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP =
mode DEFAULT group default qlen 10
|     link/can  promiscuity 0 minmtu 0 maxmtu 0=20
|     can <FD,TDC_AUTO> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart=
-ms 100=20
|           bitrate 500000 sample-point 0.875
|           tq 25 prop-seg 34 phase-seg1 35 phase-seg2 10 sjw 1 brp 1
|           mcp251xfd: tseg1 2..256 tseg2 1..128 sjw 1..128 brp 1..256 brp_=
inc 1
|           dbitrate 2000000 dsample-point 0.750
|           dtq 25 dprop-seg 7 dphase-seg1 7 dphase-seg2 5 dsjw 1 dbrp 1
|           tdco 15
|           mcp251xfd: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbr=
p_inc 1
|           tdco 0..127
|           clock 40000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 g=
so_max_segs 65535 parentbus spi parentdev spi0.0


> Which is also why TDCO can be negative.
>=20
> I added an helper function can_tdc_get_relative_tdco() in the
> fourth path of this series:
> https://lore.kernel.org/linux-can/20210814091750.73931-5-mailhol.vincent@=
wanadoo.fr/T/#u
>=20
> Devices which use the absolute TDCO can directly use
> can_priv->tdc.tdco. Devices which use the relative TDCO such as
> the mcp251xfd should use this helper function instead.

Don't think so....

> However, you will still need to convert the TDCO valid range from
> relative values to absolute ones. In your case 0..127.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--4wa7afvud7rocqox
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEaWSwACgkQqclaivrt
76m+zwf/VM6/1EJp9c/l13XNadBgkcOD6qDCfY8Al859da3SYXfk4G3/Ff1yhlIy
EFByvLU+oJ1jiSZw+BN09Z0Ylr3+YdKePxDezJG0Sg/+RjI2f4/TkcVg85KJiYgm
9qfhQ8jWZxn3lRL74j1ZRuJ2cA3mzhDRgfudSh2yJeFuaUiRJz80lj1KFTRAYXaU
ZmWYMnjN8YZ1Amnicadrp3U5/auPgrzEMR2+at9th9ZT5fXqmCBCNAwz2SAIFamq
gJI48KJDZySrq+Ml7edlHKGq5pVPyQ/3I9gufRVKqqZ0Kci8KThKMGqnDexuNU6f
YcbnGGA+VA6EDKNKZnEP5YDINPPPQg==
=0b7z
-----END PGP SIGNATURE-----

--4wa7afvud7rocqox--
