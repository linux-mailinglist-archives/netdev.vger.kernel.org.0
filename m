Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDAB63EC24
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiLAJQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiLAJQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:16:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E941B442C7
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:16:13 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0ffs-00053K-AF; Thu, 01 Dec 2022 10:16:08 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:dc5e:59bf:44a8:4077])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D433A12ECAC;
        Thu,  1 Dec 2022 09:16:06 +0000 (UTC)
Date:   Thu, 1 Dec 2022 10:16:05 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Message-ID: <20221201091605.jgd7dlswcbxapdy3@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-3-msp@baylibre.com>
 <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de>
 <20221201084302.oodh22xgvwsjmoc3@blmsp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bgbavs7rssx26dyz"
Content-Disposition: inline
In-Reply-To: <20221201084302.oodh22xgvwsjmoc3@blmsp>
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


--bgbavs7rssx26dyz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.12.2022 09:43:02, Markus Schneider-Pargmann wrote:
> Hi Marc,
>=20
> On Wed, Nov 30, 2022 at 06:21:00PM +0100, Marc Kleine-Budde wrote:
> > On 16.11.2022 21:52:55, Markus Schneider-Pargmann wrote:
> > > Currently the driver waits to wakeup the queue until the interrupt for
> > > the transmit event is received and acknowledged. If we want to use the
> > > hardware FIFO, this is too late.
> > >=20
> > > Instead release the queue as soon as the transmit was transferred into
> > > the hardware FIFO. We are then ready for the next transmit to be
> > > transferred.
> >=20
> > If you want to really speed up the TX path, remove the worker and use
> > the spi_async() API from the xmit callback, see mcp251xfd_start_xmit().
>=20
> Good idea. I will check how regmap's async_write works and if it is
> suitable to do the job. I don't want to drop the regmap usage for this
> right now.

IIRC regmap async write still uses mutexes, but sleeping is not allowed
in the xmit handler. The mcp251xfd driver does the endianness conversion
(and the optional CRC) manually for the TX path.

Sending directly from the xmit handler basically eliminates the queuing
between the network stack and the worker. Getting rid of the worker
makes life easier and it's faster anyways.

> > Extra bonus if you implement xmit_more() and transfer more than 1 skb
> > per SPI transfer.
>=20
> That's on my todo list, but I am not sure I will get to it soonish.

I haven't implemented this for the mcp251xfd, yet, but I have some
proof-of-concept code somewhere. However, the mcp251xfd driver already
implemented byte queue limits: 0084e298acfe ("can: mcp251xfd: add BQL
support").

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--bgbavs7rssx26dyz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOIcNIACgkQrX5LkNig
012hAggAlCb40W8MfJXLFvupUYSaOXCTBav4Ad74PpGE+RCHo5V+RVAHB6xNqBUC
Ur3tjLynBaHmla68klZIdl4ZUqRU5cBdJtRiGQpHwZJLqU9xP2FuiUf0I0VHAn/9
Wa/0yS2DY3kd9Ss9cdeAsewED4/0+zjgaFWWVycUX8srrcTi7ub26px0QGCkH+ld
6H2MJOtYzkLD3tAlcAghuRpfp3bsq2ZigzRfkungG8vJOlvkm7AsvLH49Q+ZAAW9
ALcyi61T2MGL6tL4glNVH5nozZif11Oo8SLY+y6cSeiRv1XGH+LLA6W2ff9hJo04
24rseGKCL6TUFzXOWhE1w+CBmE+LKQ==
=p4PT
-----END PGP SIGNATURE-----

--bgbavs7rssx26dyz--
