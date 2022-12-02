Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D61640367
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiLBJdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbiLBJdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:33:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB64A8FF6
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 01:33:04 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p12Pi-0001p9-OC; Fri, 02 Dec 2022 10:32:58 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1CC8B1312BF;
        Fri,  2 Dec 2022 09:16:36 +0000 (UTC)
Date:   Fri, 2 Dec 2022 10:16:30 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Message-ID: <20221202091630.253elxu66i3nur4n@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-3-msp@baylibre.com>
 <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de>
 <20221201084302.oodh22xgvwsjmoc3@blmsp>
 <20221201091605.jgd7dlswcbxapdy3@pengutronix.de>
 <20221201164902.ipd3ctrtne47jtmv@blmsp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gkatmsqg2kawq7yc"
Content-Disposition: inline
In-Reply-To: <20221201164902.ipd3ctrtne47jtmv@blmsp>
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


--gkatmsqg2kawq7yc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.12.2022 17:49:02, Markus Schneider-Pargmann wrote:
> Hi Marc,
>=20
> On Thu, Dec 01, 2022 at 10:16:05AM +0100, Marc Kleine-Budde wrote:
> > On 01.12.2022 09:43:02, Markus Schneider-Pargmann wrote:
> > > Hi Marc,
> > >=20
> > > On Wed, Nov 30, 2022 at 06:21:00PM +0100, Marc Kleine-Budde wrote:
> > > > On 16.11.2022 21:52:55, Markus Schneider-Pargmann wrote:
> > > > > Currently the driver waits to wakeup the queue until the interrup=
t for
> > > > > the transmit event is received and acknowledged. If we want to us=
e the
> > > > > hardware FIFO, this is too late.
> > > > >=20
> > > > > Instead release the queue as soon as the transmit was transferred=
 into
> > > > > the hardware FIFO. We are then ready for the next transmit to be
> > > > > transferred.
> > > >=20
> > > > If you want to really speed up the TX path, remove the worker and u=
se
> > > > the spi_async() API from the xmit callback, see mcp251xfd_start_xmi=
t().
> > >=20
> > > Good idea. I will check how regmap's async_write works and if it is
> > > suitable to do the job. I don't want to drop the regmap usage for this
> > > right now.
> >=20
> > IIRC regmap async write still uses mutexes, but sleeping is not allowed
> > in the xmit handler. The mcp251xfd driver does the endianness conversion
> > (and the optional CRC) manually for the TX path.
>=20
> I just saw, you can force regmap to use spinlocks as well. But it uses
> the same operation for sync operations as well.

But you cannot use sync SPI api under a spinlock.

> > Sending directly from the xmit handler basically eliminates the queuing
> > between the network stack and the worker. Getting rid of the worker
> > makes life easier and it's faster anyways.
>=20
> The current implementation of the driver doesn't really queue anything
> between the network stack and the worker. It is a queue of size 1 ;).

Ok

> To be honest I would rather focus on the other things than on getting
> rid of the worker completely as this can be done in a separate patch
> later as well. Yes I agree it would be nice to get rid of the worker but
> it is also probably not a major bottleneck for the performance and in
> its current state it works. If I have time left at the end I will be
> more than happy to do that. But for the moment I would just keep the
> worker as it is. Is that OK for you?

Sure.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--gkatmsqg2kawq7yc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOJwmsACgkQrX5LkNig
0126Egf6AoFzKXBy4GROos9DBeL7yECpyQlkoQoOfHsO/WumBEad76Zty8iRt3nI
3G4YxYoBInpvkA2z6hDSkAxGNg7U98GNwME8EwXMClGrCToXyyV0Z4xaFCs00nsy
nJUpS3C/dL29eH1NNhuDhZu0UANYCRkCQwVwCr2I4+AQCQ1FVf+WNfuJfC7IkijE
ISeV6c+hYU/L5pNNsRWRaHmz08p8gAQot2DoFp2miBK3e0hJ9CdgBg82cpvsGh6+
StKjpr1MPnbD6AE34uVKkwFPreCoGRnPSsOlXFcWIXqQHRLm5n4LNg9x6lO5Yqql
kpHTw7s4SCDU0IAAYwa0aoVc7X4NOw==
=RMCq
-----END PGP SIGNATURE-----

--gkatmsqg2kawq7yc--
