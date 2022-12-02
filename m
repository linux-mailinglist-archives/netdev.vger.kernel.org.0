Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9AC6408B0
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 15:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiLBOqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 09:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbiLBOqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 09:46:47 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63D8DFB64
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 06:46:46 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p17JJ-0002Ij-Ga; Fri, 02 Dec 2022 15:46:41 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6A01413172B;
        Fri,  2 Dec 2022 14:46:39 +0000 (UTC)
Date:   Fri, 2 Dec 2022 15:46:30 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] can: m_can: Cache tx putidx and transmits in flight
Message-ID: <20221202144630.l4jil6spb4er5vzk@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-4-msp@baylibre.com>
 <20221201111450.fpadmwscjyhefs2u@pengutronix.de>
 <20221202083740.moa7whqd52oasbar@blmsp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ixaicbn435jko43j"
Content-Disposition: inline
In-Reply-To: <20221202083740.moa7whqd52oasbar@blmsp>
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


--ixaicbn435jko43j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.12.2022 09:37:40, Markus Schneider-Pargmann wrote:
> Hi Marc,
>=20
> On Thu, Dec 01, 2022 at 12:14:50PM +0100, Marc Kleine-Budde wrote:
> > On 16.11.2022 21:52:56, Markus Schneider-Pargmann wrote:
> > > On peripheral chips every read/write can be costly. Avoid reading eas=
ily
> > > trackable information and cache them internally. This saves multiple
> > > reads.
> > >=20
> > > Transmit FIFO put index is cached, this is increased for every time we
> > > enqueue a transmit request.
> > >=20
> > > The transmits in flight is cached as well. With each transmit request=
 it
> > > is increased when reading the finished transmit event it is decreased.
> > >=20
> > > A submit limit is cached to avoid submitting too many transmits at on=
ce,
> > > either because the TX FIFO or the TXE FIFO is limited. This is curren=
tly
> > > done very conservatively as the minimum of the fifo sizes. This means=
 we
> > > can reach FIFO full events but won't drop anything.
> >=20
> > You have a dedicated in_flight variable, which is read-modify-write in 2
> > different code path, i.e. this looks racy.
>=20
> True, of course, thank you. Yes I have to redesign this a bit for
> concurrency.
>=20
> > If you allow only power-of-two FIFO size, you can use 2 unsigned
> > variables, i.e. a head and a tail pointer. You can apply a mask to get
> > the index to the FIFO. The difference between head and tail is the fill
> > level of the FIFO. See mcp251xfd driver for this.
>=20
> Maybe that is a trivial question but what's wrong with using atomics
> instead?

I think it's Ok to use an atomic for the fill level. The put index
doesn't need to be. No need to cache the get index, as it's in the same
register as the fill level.

As the mcp251xfd benefits from caching both indexes, a head and tail
pointer felt like the right choice. As both are only written in 1
location, no need for atomics or locking.

> The tcan mram size is limited to 2048 so I would like to avoid limiting
> the possible sizes of the tx fifos.

What FIFO sizes are you using currently?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ixaicbn435jko43j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOKD8QACgkQrX5LkNig
011nRggApqQ6QLzpNnhi7K+OdMn/p9UPZnTesrpUao+VEKOrPhAeHqJKnNqbxQAx
SZBcx39+DMalId+KYY93FB5Y7TxqBAGafQjIhK+DIezdKPybIXsBapR5HmHzmchk
0oDptBDm/fxWa4akqiGOkucBXXPufVFZqWp3JDhvZkm+cN5PtwAxOJXjt5a77Op8
FBkIjiH3xt35Qbj7wjGl7XiH59QJJNakBkwiBRTXAcbzUEVgeqE9grhHJK8lmXuT
8FMXWHzOmVgpxU+LzuzrJrwjEGom6itXWzGrwTMq/y2Qw/xNXxDS1/na4ovFtNJD
i2JW1ba6cSM0WYYBtDJOaFoa6AqgiQ==
=mbq6
-----END PGP SIGNATURE-----

--ixaicbn435jko43j--
