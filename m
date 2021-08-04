Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3525C3DFE11
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbhHDJev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236707AbhHDJeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 05:34:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF99C0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 02:34:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBDID-0006j4-5Z; Wed, 04 Aug 2021 11:34:29 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:e44:2d7c:bf4a:7b36])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 283A6660717;
        Wed,  4 Aug 2021 09:34:25 +0000 (UTC)
Date:   Wed, 4 Aug 2021 11:34:23 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH 4/4] can: c_can: cache frames to operate as a true
 FIFO
Message-ID: <20210804093423.ms2p245f5oiw4xn4@pengutronix.de>
References: <20210725161150.11801-1-dariobin@libero.it>
 <20210725161150.11801-5-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pxwz6jh2a7zdpnhc"
Content-Disposition: inline
In-Reply-To: <20210725161150.11801-5-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pxwz6jh2a7zdpnhc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.07.2021 18:11:50, Dario Binacchi wrote:
> As reported by a comment in the c_can_start_xmit() this was not a FIFO.
> C/D_CAN controller sends out the buffers prioritized so that the lowest
> buffer number wins.
>=20
> What did c_can_start_xmit() do if head was less tail in the tx ring ? It
> waited until all the frames queued in the FIFO was actually transmitted
> by the controller before accepting a new CAN frame to transmit, even if
> the FIFO was not full, to ensure that the messages were transmitted in
> the order in which they were loaded.
>=20
> By storing the frames in the FIFO without requiring its transmission, we
> will be able to use the full size of the FIFO even in cases such as the
> one described above. The transmission interrupt will trigger their
> transmission only when all the messages previously loaded but stored in
> less priority positions of the buffers have been transmitted.
>=20
> Suggested-by: Gianluca Falavigna <gianluca.falavigna@inwind.it>
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
>=20
> ---
>=20
>  drivers/net/can/c_can/c_can.h      |  6 +++++
>  drivers/net/can/c_can/c_can_main.c | 42 +++++++++++++++++-------------
>  2 files changed, 30 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
> index 8fe7e2138620..fc499a70b797 100644
> --- a/drivers/net/can/c_can/c_can.h
> +++ b/drivers/net/can/c_can/c_can.h
> +static inline u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
> +{
> +	return ring->obj_num - (ring->head - ring->tail);
> +}
> +
>  #endif /* C_CAN_H */
> diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c=
_can_main.c
> index 451ac9a9586a..4c061fef002c 100644
> --- a/drivers/net/can/c_can/c_can_main.c
> +++ b/drivers/net/can/c_can/c_can_main.c
> @@ -427,20 +427,6 @@ static void c_can_setup_receive_object(struct net_de=
vice *dev, int iface,
>  	c_can_object_put(dev, iface, obj, IF_COMM_RCV_SETUP);
>  }
> =20
> -static u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
> -{
> -	u8 head =3D c_can_get_tx_head(ring);
> -	u8 tail =3D c_can_get_tx_tail(ring);
> -
> -	/* This is not a FIFO. C/D_CAN sends out the buffers
> -	 * prioritized. The lowest buffer number wins.
> -	 */
> -	if (head < tail)
> -		return 0;
> -
> -	return ring->obj_num - head;
> -}
> -

Can you move that change into patch 3?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pxwz6jh2a7zdpnhc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEKXx0ACgkQqclaivrt
76k37QgAr+vV8YOvoijVLiT5qq1Pt64OZi1pA16Mi3jynCoJsZJGuxab020/NlzE
ZgPSdb7HHaffJP3Hmk8EEH0+fPWjKsTQe7oG+yQEMhMlbyH/54MWNILWvYDbUb1Y
j4ckQpTooAgVImOns7Z3URO07NNg0RVxVGkLHossONe/CmGKC8aFlnOE11HLRs8O
CwRsjyGjjgfixvFgN8AAEfaaMsy751whPjHEIDQuifIcEj1O5mJ/cnyj4l2YCPFe
mYnIzazmih43RdgMbabEbRLnGmb/xldL/IyPqQPe1f/Opw3k1F1zNqPggqK8Vyd7
GMDOLz9mqBIlPQZlqM5LQFY+DdpZWw==
=H0i1
-----END PGP SIGNATURE-----

--pxwz6jh2a7zdpnhc--
