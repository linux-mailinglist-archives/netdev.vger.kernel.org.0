Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B155B832A
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 10:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiINIi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 04:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiINIi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 04:38:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3725F6BCE6
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 01:38:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYNuZ-000867-N9; Wed, 14 Sep 2022 10:38:23 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:956:4247:55d:c7ae])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1F845E2B21;
        Wed, 14 Sep 2022 08:38:17 +0000 (UTC)
Date:   Wed, 14 Sep 2022 10:38:11 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     =?utf-8?B?Q3PDs2vDoXM=?= Bence <Csokas.Bence@prolan.hu>
Cc:     Bence =?utf-8?B?Q3PDs2vDoXM=?= <bence98@sch.bme.hu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guenter Roeck <linux@roeck-us.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] Revert "net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`"
Message-ID: <20220914083811.rjb2epj5icgvo62y@pengutronix.de>
References: <20220912073106.2544207-1-bence98@sch.bme.hu>
 <20220912103818.j2u6afz66tcxvnr6@pengutronix.de>
 <3f2824bc776f4383b84e4137f6c740de@prolan.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hpsd3nm6cgsavjs2"
Content-Disposition: inline
In-Reply-To: <3f2824bc776f4383b84e4137f6c740de@prolan.hu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hpsd3nm6cgsavjs2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.09.2022 19:04:56, Cs=C3=B3k=C3=A1s Bence wrote:
> > This is not a 100% revert.
> >=20
> > In b353b241f1eb ("net: fec: Use a spinlock to guard `fep->ptp_clk_on`")
> > the "struct fec_enet_private *fep" was renamed to "struct
> > fec_enet_private *adapter" for no apparent reason. The driver uses "fep"
> > everywhere else. This revert doesn't restore the original state.
>=20
> You got that backwards. b353b241f1eb renamed `adapter` to `fep` to align
> it with the rest of the driver.

Doh! You're right - sorry about that.

> I decided to amend the revert to keep this renaming.
> `adapter` was introduced in 6605b73 when `fec_ptp.c` was created.
>=20
> > This leads to the following diff against a 100% revert.
> >=20
> > diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/eth=
ernet/freescale/fec_ptp.c
> > index c99dff3c3422..c74d04f4b2fd 100644
> > --- a/drivers/net/ethernet/freescale/fec_ptp.c
> > +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> > @@ -365,21 +365,21 @@ static int fec_ptp_adjtime(struct ptp_clock_info =
*ptp, s64 delta)
> > =C2=A0 */
> > =C2=A0static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct tim=
espec64 *ts)
> > =C2=A0{
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct fec_enet_private *fep =3D
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct fec_enet_private *adapter =
=3D
>=20
> Here you can clearly see the nature of my amend.=20

Please don't mix fixes and especially reverts with cleanups.

> I thought I added this to the commit message,
> but it seems I have forgot.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hpsd3nm6cgsavjs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMhkvEACgkQrX5LkNig
010tfQf+MW4jVkjbvCVIqj9i4HCU5ajU2CEu0+Nh5/PZyseZPdZS4vz/dTb520kQ
dQ7/NI3xCafRL3xSkeXbJ3xWUqZLmO+v/39W0vZsXdJPbGkDH5BN/KyQonK9bPWV
vkmF0zO697fEmaxlrAjqhIfqGi1ricF5ofh3b9jbBJgdSNhnH+N94K4Kn2k7qSiD
6fYAPeP7F0NmYtV7M0RkJbH8nvzpxeISj4D11qXKosWCDKn3hRR2V2XUVuEayXgT
18EiNFTPdmD0J7p/vL1MuI20IhzY7PBefHJOSmcqcTXjWVRy1c54HkoB5Kkz5PwD
82guEXs2ZZb94qEsHnC4jO8JVbFGMg==
=FjwR
-----END PGP SIGNATURE-----

--hpsd3nm6cgsavjs2--
