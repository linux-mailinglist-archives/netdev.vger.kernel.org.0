Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48F26407F5
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiLBNx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbiLBNx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:53:56 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5474AF005
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 05:53:55 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p16U9-0004lm-SU; Fri, 02 Dec 2022 14:53:49 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4EC561316AA;
        Fri,  2 Dec 2022 13:53:48 +0000 (UTC)
Date:   Fri, 2 Dec 2022 14:53:39 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Message-ID: <20221202135339.k6355z5pxqikd6rg@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-3-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="on7i6codf732a6cd"
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


--on7i6codf732a6cd
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
>=20
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> ---
>  drivers/net/can/m_can/m_can.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 2c01e3f7b23f..4adf03111782 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1097,10 +1097,9 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
>  			/* New TX FIFO Element arrived */
>  			if (m_can_echo_tx_event(dev) !=3D 0)
>  				goto out_fail;
> -
> -			if (netif_queue_stopped(dev) &&
> -			    !m_can_tx_fifo_full(cdev))
> +			if (!cdev->tx_skb && netif_queue_stopped(dev))
>  				netif_wake_queue(dev);

Please don't start the queue if the FIFO is still full. Is this a
gamble, that it will take long enough until the work queue runs that the
FIFO is not full anymore?

> +

Nitpick: Please don't introduce an extra newline here.

>  		}
>  	}
> =20
> @@ -1705,6 +1704,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_cl=
assdev *cdev)
>  		if (m_can_tx_fifo_full(cdev) ||
>  		    m_can_next_echo_skb_occupied(dev, putidx))
>  			netif_stop_queue(dev);
> +		else if (cdev->is_peripheral && !cdev->tx_skb && netif_queue_stopped(d=
ev))
> +			netif_wake_queue(dev);

Same question as above, what happens if the FIFO is full? e.g. in case
of a slow bus or the first CAN frame in the FIFO has a low prio...

>  	}
> =20
>  	return NETDEV_TX_OK;
> --=20
> 2.38.1
>=20
>

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--on7i6codf732a6cd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOKA2EACgkQrX5LkNig
013afggAl25h6SI6ZmyZSNEWWC4ARZgKc0sczOh/LH9HiWHr5+B7ZiF2WMgDebtS
UvWJoQV6bC9NFGCbtkfIRazuAPV2XGMGZcP6S101NHhmXTBKKipQBe5wPoAQKAkB
WkzkNbGqAGZS0kNnOpeR8QJwUurwwi7VmFVmq81Zf+DYeA2lZtEZpjwjyQE19KsV
lLRpku3WvRG0zgbo3aaGzBqoNFIAn4EPEh5TpM030DqffD+sMbgm8O6GJxSXtpln
eMX0nyK4bQFC1pr0byZWyYzvcnrto+15g8QxPH3/EWA9S17ix99nJaeAG8i1DNmW
Sy5MtpNVd1xuA3sXpJGQ4DBWmZHvPg==
=fRrh
-----END PGP SIGNATURE-----

--on7i6codf732a6cd--
