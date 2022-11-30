Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9EC63DBD6
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiK3RVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiK3RVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:21:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DCA3B0
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 09:21:07 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0Qla-0000Ln-7M; Wed, 30 Nov 2022 18:21:02 +0100
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:cf48:5678:3bb0:eeda])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5F64112E2F6;
        Wed, 30 Nov 2022 17:21:01 +0000 (UTC)
Date:   Wed, 30 Nov 2022 18:21:00 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Message-ID: <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-3-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ywc2a6fjnuomftcw"
Content-Disposition: inline
In-Reply-To: <20221116205308.2996556-3-msp@baylibre.com>
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


--ywc2a6fjnuomftcw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.11.2022 21:52:55, Markus Schneider-Pargmann wrote:
> Currently the driver waits to wakeup the queue until the interrupt for
> the transmit event is received and acknowledged. If we want to use the
> hardware FIFO, this is too late.
>=20
> Instead release the queue as soon as the transmit was transferred into
> the hardware FIFO. We are then ready for the next transmit to be
> transferred.

If you want to really speed up the TX path, remove the worker and use
the spi_async() API from the xmit callback, see mcp251xfd_start_xmit().

Extra bonus if you implement xmit_more() and transfer more than 1 skb
per SPI transfer.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ywc2a6fjnuomftcw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOHkPoACgkQrX5LkNig
011ZaQf/T1Ml8VqPmN3bD3/UOmPiK48QEwmTT3LsUIiKljMGDhar4ApPMhBCtJH4
GL/SYMkFpB/PmS+I80sL4FtCRoqqsP5wURI4BsWvrfboZU4ZyT7507fwP4bNFT7g
ikyy9j7HWuU/kbyWPpkpK70LPWEC3EHzR9c/g6S0EwFzbHWAJNmyV87BUu2KRSUB
ohMgWjno+q/b/3p0bus+Cus5P0aDv4Q7kz6H8qulESQq9Yx+am1MkxeB+7xyDY9e
u9MnFnZuVNJ4FUiZEfky9e/rk1CbY2YPm3tpJvYlXx+zfgTm0ApwvYgeQ57u0irT
0lyiUXHvhMej67pscPNrxTcEQRc5fg==
=QDMo
-----END PGP SIGNATURE-----

--ywc2a6fjnuomftcw--
