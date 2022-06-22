Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7541455473F
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbiFVITw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 04:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235471AbiFVITv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 04:19:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BC437BFD
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 01:19:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o3vaP-00056G-Lx; Wed, 22 Jun 2022 10:19:41 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-0ddb-1bbb-e3fd-3cee.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:ddb:1bbb:e3fd:3cee])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CDAE39C0DF;
        Wed, 22 Jun 2022 08:19:39 +0000 (UTC)
Date:   Wed, 22 Jun 2022 10:19:39 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Thomas.Kopp@microchip.com
Cc:     pavel.modilaynen@volvocars.com, drew@beagleboard.org,
        linux-can@vger.kernel.org, menschel.p@posteo.de,
        netdev@vger.kernel.org, will@macchina.cc
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Message-ID: <20220622081939.b4ev2k4b3i3fo6an@pengutronix.de>
References: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
 <PR3P174MB01124C085C0E0A0220F2B11584709@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB53901D49578FE265B239E55AFB7C9@DM4PR11MB5390.namprd11.prod.outlook.com>
 <20220621142515.4xgxhj6oxo5kuepn@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="t3plp2cuyqmshzvy"
Content-Disposition: inline
In-Reply-To: <20220621142515.4xgxhj6oxo5kuepn@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--t3plp2cuyqmshzvy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.06.2022 16:25:15, Marc Kleine-Budde wrote:
> > Thanks for the data. I've looked into this and it seems that the
> > second bit being set in your case does not depend on the SPI-Rate (or
> > the quirks for that matter) but it seems to be hardware setup related.
> >=20
> > I'm fine with changing the driver so that it ignores set LSBs but
> > would limit it to 2 or 3 bits:
> >=20
> > (buf_rx->data[0] =3D=3D 0x0 || buf_rx->data[0] =3D=3D 0x80))
> > becomes
> > ((buf_rx->data[0] & 0xf8) =3D=3D 0x0 || (buf_rx->data[0] & 0xf8) =3D=3D=
 0x80)) {
> >=20
> > The action also needs to be changed and the flip back of the bit
> > needs to be removed. In this case the flipped databit that produces
> > a matching CRC is actually correct (i.e. consistent with the 7 LSBs
> > in that byte.)

The mcp2517fd errata says the transmitted data is okay, but the CRC is
calculated on wrong data:

| It is possible that there is a mismatch between the transmitted CRC
| and the actual CRC for the transmitted data when data are updated at a
| specific time during the SPI READ_CRC command. In these cases, the
| transmitted CRC is wrong. The data transmitted are correct.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--t3plp2cuyqmshzvy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKy0JYACgkQrX5LkNig
013R/QgAqOI8My5DUrkLSb+7/BnXvLYA3VyATjMZHD6feI/8zSpq5Sqc6NTtBiQa
gs4ok4w0WTN5mu2Ib3Ons1TIQRROR4/WjcdY9PKJ1HqdznaUL9XkAnXIV5V0U3CA
jV64873QB/+pGmRUPG+2nNRIebCSP+MSLMqz/9XAn198B0+SaORZKwIruKKKw8sv
Hn9Uh3I3MH/SvDS/EsKeidnT7YSwl8AHBV4W6ES4dvQ48GhLD69mVMlKeBz7DtTj
zIug2IIBW5WSlTpHMvvzDBpIBR9KYmgt9TpDDjcy1K2xpQ9uZQvKFjgldozEAPg7
nPAVeZYoGf+G1O4wpc0EXHvkzRL9Wg==
=QqDn
-----END PGP SIGNATURE-----

--t3plp2cuyqmshzvy--
