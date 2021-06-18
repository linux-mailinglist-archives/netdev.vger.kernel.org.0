Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD4A3ACB49
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 14:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhFRMrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 08:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhFRMrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 08:47:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8789CC061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 05:44:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1luDrf-00011J-TM; Fri, 18 Jun 2021 14:44:51 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:e7d0:b47e:7728:2b24])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 21C4A63ED9C;
        Fri, 18 Jun 2021 12:44:48 +0000 (UTC)
Date:   Fri, 18 Jun 2021 14:44:47 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Thomas Kopp <thomas.kopp@microchip.com>
Subject: CAN-FD Transmitter Delay Compensation (TDC) on mcp2518fd
Message-ID: <20210618124447.47cy7hyqp53d4tjh@pengutronix.de>
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr>
 <20210618093424.xohvsqaaq5qf2bjn@pengutronix.de>
 <CAMZ6RqJn5z-9PfkcJdiS6aG+qCPnifXDwH26ZEwo8-=id=TXbw@mail.gmail.com>
 <CAMZ6RqKrPQkPy-dAiQjAB4aKnqeaNx+L-cro8F_mc2VPgOD4Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="766oiknfbpl6mq2v"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqKrPQkPy-dAiQjAB4aKnqeaNx+L-cro8F_mc2VPgOD4Jw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--766oiknfbpl6mq2v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.06.2021 20:17:51, Vincent MAILHOL wrote:
> > > I just noticed in the mcp2518fd data sheet:
> > >
> > > | bit 14-8 TDCO[6:0]: Transmitter Delay Compensation Offset bits;
> > > | Secondary Sample Point (SSP) Two=E2=80=99s complement; offset can b=
e positive,
> > > | zero, or negative.
> > > |
> > > | 011 1111 =3D 63 x TSYSCLK
> > > | ...
> > > | 000 0000 =3D 0 x TSYSCLK
> > > | ...
> > > | 111 1111 =3D =E2=80=9364 x TSYSCLK
> > >
> > > Have you takes this into account?
> >
> > I have not. And I fail to understand what would be the physical
> > meaning if TDCO is zero or negative.

The mcp25xxfd family data sheet says:

| SSP =3D TDCV + TDCO

> > TDCV indicates the position of the bit start on the RX pin.

If I understand correctly in automatic mode TDCV is measured by the CAN
controller and reflects the transceiver delay. I don't know why you want
to subtract a time from that....

The rest of the relevant registers:

| TDCMOD[1:0]: Transmitter Delay Compensation Mode bits; Secondary Sample P=
oint (SSP)
| 10-11 =3D Auto; measure delay and add TDCO.
| 01 =3D Manual; Do not measure, use TDCV + TDCO from register
| 00 =3D TDC Disabled
|=20
| TDCO[6:0]: Transmitter Delay Compensation Offset bits; Secondary Sample P=
oint (SSP)
| Two=E2=80=99s complement; offset can be positive, zero, or negative.
| 011 1111 =3D 63 x TSYSCLK
| ...
| 000 0000 =3D 0 x TSYSCLK
| ...
| 111 1111 =3D =E2=80=9364 x TSYSCLK
|=20
| TDCV[5:0]: Transmitter Delay Compensation Value bits; Secondary Sample Po=
int (SSP)
| 11 1111 =3D 63 x TSYSCLK
| ...
| 00 0000 =3D 0 x TSYSCLK

> > If TDCO is zero, the measurement occurs on the bit start when all
> > the ringing occurs. That is a really bad choice to do the
> > measurement. If it is negative, it means that you are measuring the
> > previous bit o_O !?

I don't know...

> > Maybe I am missing something but I just do not get it.
> >
> > I believe you started to implement the mcp2518fd.

No I've just looked into the register description.

> > Can you force a
> > zero and a negative value and tell me if the bus is stable?
>=20
> Actually, ISO 11898-1 specifies that the "SSP position should be
> at least 0 to 63 minimum time quanta". This means that we can
> have SSP =3D TDCV + TDCO =3D 0. In my implementation, I used 0 as a
> reserved value for TDCV and TDCO. To comply with the standard, I
> now need to allow both TDCV and TDCO to be zero and add a new
> field in struct tdc to manage the automatic/manual options.
>=20
> That said, these zero values still make no sense to me. Why would
> someone do the measurement on the bit edge?
>=20
> Concerning the negative values, the ISO standard says nothing
> about it.  If you are using the automatic measurement, a negative
> TDCO is impossible to use. TDCV is measured on every bit. When
> the measurement is done, it is too late to subtract from it (or
> maybe the mcp2518fd has a time machine built in?).

:)

> If you are
> using the manual mode for TDCV, just choose two positive values
> so that TDCV + TDCO =3D SSF.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--766oiknfbpl6mq2v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDMlTwACgkQqclaivrt
76nTuAf9G71nRRfOjnDXw0QblM4XzmXnhCDHhM3gFQAnpWaHVj3V80K2qiL3+NTW
IHFZ24jPkqy5JZAPozQoy621oWUMlYgz5ZFPBxelB6SVEAADen3OTQ062S1gXoAW
cPBkPcCjYvWx+tu/PJYqfl3v1eoFm9rafq/GYm4f5zlk9cF0Yqo1ap1k5AtwVmys
bhhT20phFH4AxSsesj1XCtgIu6HzZiWN5cC6SFSnORNxNYztGEuz5FlHlbt3zmgG
lnNTo02vBv8bW1aLHDsxktidjwYaOHfW9OPjsWHOcYmP9x/xiYdGLeDcyh/F+xtO
tUtbS8kOrWHmP9/V4hVuJHAPs6NeMA==
=F9xC
-----END PGP SIGNATURE-----

--766oiknfbpl6mq2v--
