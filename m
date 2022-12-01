Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F56D63EEA9
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiLALBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiLALBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:01:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1906EAD98A
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 03:00:42 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0hIy-0003CQ-O1; Thu, 01 Dec 2022 12:00:36 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:dc5e:59bf:44a8:4077])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 59FFD12F517;
        Thu,  1 Dec 2022 11:00:35 +0000 (UTC)
Date:   Thu, 1 Dec 2022 12:00:33 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] can: m_can: Use transmit event FIFO watermark
 level interrupt
Message-ID: <20221201110033.r7hnvpw6fp2fquni@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-5-msp@baylibre.com>
 <20221130171715.nujptzwnut7silbm@pengutronix.de>
 <20221201082521.3tqevaygz4nhw52u@blmsp>
 <20221201090508.jh5iymwmhs3orb2v@pengutronix.de>
 <20221201101220.r63fvussavailwh5@blmsp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="edcoqv646ihy76od"
Content-Disposition: inline
In-Reply-To: <20221201101220.r63fvussavailwh5@blmsp>
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


--edcoqv646ihy76od
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.12.2022 11:12:20, Markus Schneider-Pargmann wrote:
> > > For the upcoming receive side patch I already added a hrtimer. I may =
try
> > > to use the same timer for both directions as it is going to do the ex=
act
> > > same thing in both cases (call the interrupt routine). Of course that
> > > depends on the details of the coalescing support. Any objections on
> > > that?
> >=20
> > For the mcp251xfd I implemented the RX and TX coalescing independent of
> > each other and made it configurable via ethtool's IRQ coalescing
> > options.
> >=20
> > The hardware doesn't support any timeouts and only FIFO not empty, FIFO
> > half full and FIFO full IRQs and the on chip RAM for mailboxes is rather
> > limited. I think the mcan core has the same limitations.
>=20
> Yes and no, the mcan core provides watermark levels so it has more
> options, but there is no hardware timer as well (at least I didn't see
> anything usable).

Are there any limitations to the water mark level?

> > The configuration for the mcp251xfd looks like this:
> >=20
> > - First decide for classical CAN or CAN-FD mode
> > - configure RX and TX ring size
> >   9263c2e92be9 ("can: mcp251xfd: ring: add support for runtime configur=
able RX/TX ring parameters")
> >   For TX only a single FIFO is used.
> >   For RX up to 3 FIFOs (up to a depth of 32 each).
> >   FIFO depth is limited to power of 2.
> >   On the mcan cores this is currently done with a DT property.
> >   Runtime configurable ring size is optional but gives more flexibility
> >   for our use-cases due to limited RAM size.
> > - configure RX and TX coalescing via ethtools
> >   Set a timeout and the max CAN frames to coalesce.
> >   The max frames are limited to half or full FIFO.
>=20
> mcan can offer more options for the max frames limit fortunately.
>=20
> >=20
> > How does coalescing work?
> >=20
> > If coalescing is activated during reading of the RX'ed frames the FIFO
> > not empty IRQ is disabled (the half or full IRQ stays enabled). After
> > handling the RX'ed frames a hrtimer is started. In the hrtimer's
> > functions the FIFO not empty IRQ is enabled again.
>=20
> My rx path patches are working similarly though not 100% the same. I
> will adopt everything and add it to the next version of this series.
>=20
> >=20
> > I decided not to call the IRQ handler from the hrtimer to avoid
> > concurrency, but enable the FIFO not empty IRQ.
>=20
> mcan uses a threaded irq and I found this nice helper function I am
> currently using for the receive path.
> 	irq_wake_thread()
>=20
> It is not widely used so I hope this is fine. But this hopefully avoids
> the concurrency issue. Also I don't need to artificially create an IRQ
> as you do.

I think it's Ok to use the function. Which IRQs are enabled after you
leave the RX handler? The mcp251xfd driver enables only a high watermark
IRQ and sets up the hrtimer. Then we have 3 scenarios:
- high watermark IRQ triggers -> IRQ is handled,
- FIFO level between 0 and high water mark -> no IRQ triggered, but
  hrtimer will run, irq_wake_thread() is called, IRQ is handled
- FIFO level 0 -> no IRQ triggered, hrtimer will run. What do you do in
  the IRQ handler? Check if FIFO is empty and enable the FIFO not empty
  IRQ?

The mcp251xfd unconditionally enables the FIFO not empty IRQ in the
hrtimer. This avoids reading of the FIFO fill level.

[...]

> > If you want to implement runtime configurable ring size, I created a
> > function to help in the calculation of the ring sizes:
> >=20
> > a1439a5add62 ("can: mcp251xfd: ram: add helper function for runtime rin=
g size calculation")
> >=20
> > The code is part of the mcp251xfd driver, but is prepared to become a
> > generic helper function. The HW parameters are described with struct
> > can_ram_config and use you can_ram_get_layout() to get a valid RAM
> > layout based on CAN/CAN-FD ring size and coalescing parameters.
>=20
> Thank you. I think configurable ring sizes are currently out of scope
> for me as I only have limited time for this.

Ok.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--edcoqv646ihy76od
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOIiUgACgkQrX5LkNig
012m7wf+Jkt4dPHkK/5FDYm3DG5+UmIraPvosBGc3TpNPpIiQJoA4XYiPfhu9W76
NiUKMYjg+dNabhQYBLEc3Nn2eQpeJ6ZSQlVqxkphlwe2LTgfJgt3emb9n4AssZYY
8CW/iXBfT8XW7U+Ju565zGtajtcHaoELpXXxTVaXn/U8NGrla4XGeJEVSBQbnQNN
Zknw0IqzBgrsAHcU+DZJ2aMtbqGeYNdMWBro1Gftr65pYDLV5Q/ktOlJPNw7WYUp
pIqYCkHqBqAG/BsUPfJl0DdD9x7+pndiDoY9VnlViN46v/x+Ovh1dKi3tcM3Xzkb
eiKkOWDsd7+pcqQdWhQZK8ZndXqJ0w==
=7fy5
-----END PGP SIGNATURE-----

--edcoqv646ihy76od--
