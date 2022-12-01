Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C3463EBF3
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLAJGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiLAJFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:05:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD108931F
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:05:17 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0fVH-0002bz-9P; Thu, 01 Dec 2022 10:05:11 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:dc5e:59bf:44a8:4077])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D80D612EC7E;
        Thu,  1 Dec 2022 09:05:09 +0000 (UTC)
Date:   Thu, 1 Dec 2022 10:05:08 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] can: m_can: Use transmit event FIFO watermark
 level interrupt
Message-ID: <20221201090508.jh5iymwmhs3orb2v@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-5-msp@baylibre.com>
 <20221130171715.nujptzwnut7silbm@pengutronix.de>
 <20221201082521.3tqevaygz4nhw52u@blmsp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="76e2vv7xqav4dg7p"
Content-Disposition: inline
In-Reply-To: <20221201082521.3tqevaygz4nhw52u@blmsp>
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


--76e2vv7xqav4dg7p
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.12.2022 09:25:21, Markus Schneider-Pargmann wrote:
> Hi Marc,
>=20
> Thanks for reviewing.
>=20
> On Wed, Nov 30, 2022 at 06:17:15PM +0100, Marc Kleine-Budde wrote:
> > On 16.11.2022 21:52:57, Markus Schneider-Pargmann wrote:
> > > Currently the only mode of operation is an interrupt for every transm=
it
> > > event. This is inefficient for peripheral chips. Use the transmit FIFO
> > > event watermark interrupt instead if the FIFO size is more than 2. Use
> > > FIFOsize - 1 for the watermark so the interrupt is triggered early
> > > enough to not stop transmitting.
> > >=20
> > > Note that if the number of transmits is less than the watermark level,
> > > the transmit events will not be processed until there is any other
> > > interrupt. This will only affect statistic counters. Also there is an
> > > interrupt every time the timestamp wraps around.
> > >=20
> > > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> >=20
> > Please make this configurable with the ethtool TX IRQ coalescing
> > parameter. Please setup an hwtimer to enable the regular interrupt after
> > some configurable time to avoid starving of the TX complete events.
>=20
> I guess hwtimer=3D=3Dhrtimer?

Sorry, yes!

> I thought about setting up a timer but decided against it as the TX
> completion events are only used to update statistics of the interface,
> as far as I can tell. I can implement a timer as well.

It's not only statistics, the sending socket can opt in to receive the
sent CAN frame on successful transmission. Other sockets will (by
default) receive successful sent CAN frames. The idea is that the other
sockets see the same CAN bus, doesn't matter if they are on a different
system receiving the CAN frame via the bus or on the same system
receiving the CAN frame as soon it has been sent to the bus.

> For the upcoming receive side patch I already added a hrtimer. I may try
> to use the same timer for both directions as it is going to do the exact
> same thing in both cases (call the interrupt routine). Of course that
> depends on the details of the coalescing support. Any objections on
> that?

For the mcp251xfd I implemented the RX and TX coalescing independent of
each other and made it configurable via ethtool's IRQ coalescing
options.

The hardware doesn't support any timeouts and only FIFO not empty, FIFO
half full and FIFO full IRQs and the on chip RAM for mailboxes is rather
limited. I think the mcan core has the same limitations.

The configuration for the mcp251xfd looks like this:

- First decide for classical CAN or CAN-FD mode
- configure RX and TX ring size
  9263c2e92be9 ("can: mcp251xfd: ring: add support for runtime configurable=
 RX/TX ring parameters")
  For TX only a single FIFO is used.
  For RX up to 3 FIFOs (up to a depth of 32 each).
  FIFO depth is limited to power of 2.
  On the mcan cores this is currently done with a DT property.
  Runtime configurable ring size is optional but gives more flexibility
  for our use-cases due to limited RAM size.
- configure RX and TX coalescing via ethtools
  Set a timeout and the max CAN frames to coalesce.
  The max frames are limited to half or full FIFO.

How does coalescing work?

If coalescing is activated during reading of the RX'ed frames the FIFO
not empty IRQ is disabled (the half or full IRQ stays enabled). After
handling the RX'ed frames a hrtimer is started. In the hrtimer's
functions the FIFO not empty IRQ is enabled again.

I decided not to call the IRQ handler from the hrtimer to avoid
concurrency, but enable the FIFO not empty IRQ.

> > I've implemented this for the mcp251xfd driver, see:
> >=20
> > 656fc12ddaf8 ("can: mcp251xfd: add TX IRQ coalescing ethtool support")
> > 169d00a25658 ("can: mcp251xfd: add TX IRQ coalescing support")
> > 846990e0ed82 ("can: mcp251xfd: add RX IRQ coalescing ethtool support")
> > 60a848c50d2d ("can: mcp251xfd: add RX IRQ coalescing support")
> > 9263c2e92be9 ("can: mcp251xfd: ring: add support for runtime configurab=
le RX/TX ring parameters")
>=20
> Thanks for the pointers. I will have a look and try to implement it
> similarly.

If you want to implement runtime configurable ring size, I created a
function to help in the calculation of the ring sizes:

a1439a5add62 ("can: mcp251xfd: ram: add helper function for runtime ring si=
ze calculation")

The code is part of the mcp251xfd driver, but is prepared to become a
generic helper function. The HW parameters are described with struct
can_ram_config and use you can_ram_get_layout() to get a valid RAM
layout based on CAN/CAN-FD ring size and coalescing parameters.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--76e2vv7xqav4dg7p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOIbkEACgkQrX5LkNig
012oYAf/a+KUcifNesQiHqFnEzD66u05tdKZTWgG7XUoR7dO3htMvva3WILrusi7
8+X8A7Z/LQ7Xqwt5THmhibSS9gVf1lJikk2FLQSdk0P0sT0y1QP7akAmj37eZpeF
yCnKXICaGSSJJcNJEaEmepeI5vPttObukGpJMxhwUxli0JJHh9j3MYvdAzpxD8af
yrX9OLn06rOO18Dy5kZC7Y2zeN1UYz4FDinLOudHJ2juPGUNhrnLRTAdEWaQ+Nwd
82zB8OdGla8BSqIXuTwccPEYchyIukoHEY0U4EXaZJn4dhAVn1wPg7ZXkku/09xp
cBFiwvRdLtIKiMKE7+1ut29HxPXUUQ==
=qQ9M
-----END PGP SIGNATURE-----

--76e2vv7xqav4dg7p--
