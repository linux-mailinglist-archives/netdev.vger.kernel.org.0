Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A718663DBCA
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiK3RSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiK3RRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:17:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB444B82
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 09:17:23 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0Qhx-0008EY-PB; Wed, 30 Nov 2022 18:17:17 +0100
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:cf48:5678:3bb0:eeda])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 14B1F12E2E6;
        Wed, 30 Nov 2022 17:17:16 +0000 (UTC)
Date:   Wed, 30 Nov 2022 18:17:15 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] can: m_can: Use transmit event FIFO watermark
 level interrupt
Message-ID: <20221130171715.nujptzwnut7silbm@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-5-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="r7p5tzu2udczjqwl"
Content-Disposition: inline
In-Reply-To: <20221116205308.2996556-5-msp@baylibre.com>
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


--r7p5tzu2udczjqwl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.11.2022 21:52:57, Markus Schneider-Pargmann wrote:
> Currently the only mode of operation is an interrupt for every transmit
> event. This is inefficient for peripheral chips. Use the transmit FIFO
> event watermark interrupt instead if the FIFO size is more than 2. Use
> FIFOsize - 1 for the watermark so the interrupt is triggered early
> enough to not stop transmitting.
>=20
> Note that if the number of transmits is less than the watermark level,
> the transmit events will not be processed until there is any other
> interrupt. This will only affect statistic counters. Also there is an
> interrupt every time the timestamp wraps around.
>=20
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Please make this configurable with the ethtool TX IRQ coalescing
parameter. Please setup an hwtimer to enable the regular interrupt after
some configurable time to avoid starving of the TX complete events.

I've implemented this for the mcp251xfd driver, see:

656fc12ddaf8 ("can: mcp251xfd: add TX IRQ coalescing ethtool support")
169d00a25658 ("can: mcp251xfd: add TX IRQ coalescing support")
846990e0ed82 ("can: mcp251xfd: add RX IRQ coalescing ethtool support")
60a848c50d2d ("can: mcp251xfd: add RX IRQ coalescing support")
9263c2e92be9 ("can: mcp251xfd: ring: add support for runtime configurable R=
X/TX ring parameters")

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--r7p5tzu2udczjqwl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOHkBgACgkQrX5LkNig
012n+ggAkjxGu6fzc+XN6IqoY9Yn3LMia/azxxAbbRgcPD1gS4jBaulIPdVAon0D
Veno5UPsOxB4yfraBvUylwROO0bkg9+vJG20XaDrExwMAU5CRfQ9qBjZBpHgj8VU
PE9id632nhB1bJ9wWhqlV2W9vMkehQtRB+4sIqnfgQ1P2t9XgoM51NBDMF+fEkCR
Y7k5p4kH5iCbIarx7R5nLQnnS77BxpSq3BiMd8ddlJGbumtECd0RqkL6JAq0P7D3
Xtkw9hylSQQEIHDxAEOlvDb4IQqXITE7CzjveDcrN+X43JPtLD09va6A3D95DrAR
LzmklmW9y9pIgyz5htSCY0wFTCc96g==
=DbHj
-----END PGP SIGNATURE-----

--r7p5tzu2udczjqwl--
