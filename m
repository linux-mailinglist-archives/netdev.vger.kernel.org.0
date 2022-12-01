Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F7A63EF42
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiLALSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiLALRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:17:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1188F42196
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 03:14:59 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0hWn-00068H-9A; Thu, 01 Dec 2022 12:14:53 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:dc5e:59bf:44a8:4077])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D242412F557;
        Thu,  1 Dec 2022 11:14:51 +0000 (UTC)
Date:   Thu, 1 Dec 2022 12:14:50 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] can: m_can: Cache tx putidx and transmits in flight
Message-ID: <20221201111450.fpadmwscjyhefs2u@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-4-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ysvt4sh7xyxarrpp"
Content-Disposition: inline
In-Reply-To: <20221116205308.2996556-4-msp@baylibre.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ysvt4sh7xyxarrpp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.11.2022 21:52:56, Markus Schneider-Pargmann wrote:
> On peripheral chips every read/write can be costly. Avoid reading easily
> trackable information and cache them internally. This saves multiple
> reads.
>=20
> Transmit FIFO put index is cached, this is increased for every time we
> enqueue a transmit request.
>=20
> The transmits in flight is cached as well. With each transmit request it
> is increased when reading the finished transmit event it is decreased.
>=20
> A submit limit is cached to avoid submitting too many transmits at once,
> either because the TX FIFO or the TXE FIFO is limited. This is currently
> done very conservatively as the minimum of the fifo sizes. This means we
> can reach FIFO full events but won't drop anything.

You have a dedicated in_flight variable, which is read-modify-write in 2
different code path, i.e. this looks racy.

If you allow only power-of-two FIFO size, you can use 2 unsigned
variables, i.e. a head and a tail pointer. You can apply a mask to get
the index to the FIFO. The difference between head and tail is the fill
level of the FIFO. See mcp251xfd driver for this.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ysvt4sh7xyxarrpp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOIjKcACgkQrX5LkNig
0106Pgf/c+3LyxVEAyWReUSMy4S25PKscNC/HC7FSIfZv/T4pUhUfhjoNHFsdOKD
mxJS60E0hXNuER/oOjUzN/hQYCf8eLDmo7lY1ABkwUMqt03s6ouIeo2nUIxfYBHM
Cxiju541PilmMvIhydL/j0YMPfexOvvVV6XJHGHPTPAfoRF/adHphiIMHg34IVbv
R/mZtnutVHNwnjaZLmM0ffiXHxyRexca5ptziY6cqzT5S11ktYPPyqcx4NPxbZeF
iVCKBICb2Yu4vqFF93shAflWPnfLrgIHewju/lSYA3yGFOgzATIRF/iawTdmK/8K
e3WT//xQtxnLxJG7bZ33s8AvIWkwvg==
=k8r2
-----END PGP SIGNATURE-----

--ysvt4sh7xyxarrpp--
