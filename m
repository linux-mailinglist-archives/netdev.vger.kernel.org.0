Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7173DFE49
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbhHDJpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237141AbhHDJph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 05:45:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87391C0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 02:45:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBDSg-000866-Ng; Wed, 04 Aug 2021 11:45:18 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:e44:2d7c:bf4a:7b36])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A5FE5660744;
        Wed,  4 Aug 2021 09:45:16 +0000 (UTC)
Date:   Wed, 4 Aug 2021 11:45:15 +0200
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
Message-ID: <20210804094515.ariv7d24t2i4hic5@pengutronix.de>
References: <20210725161150.11801-1-dariobin@libero.it>
 <20210725161150.11801-5-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vdeu2tms3hj5egqq"
Content-Disposition: inline
In-Reply-To: <20210725161150.11801-5-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vdeu2tms3hj5egqq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.07.2021 18:11:50, Dario Binacchi wrote:
> diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
> index 8fe7e2138620..fc499a70b797 100644
> --- a/drivers/net/can/c_can/c_can.h
> +++ b/drivers/net/can/c_can/c_can.h
> @@ -200,6 +200,7 @@ struct c_can_priv {
>  	atomic_t sie_pending;
>  	unsigned long tx_dir;
>  	int last_status;
> +	spinlock_t tx_lock;

What does the spin lock protect?

>  	struct c_can_tx_ring tx;
>  	u16 (*read_reg)(const struct c_can_priv *priv, enum reg index);
>  	void (*write_reg)(const struct c_can_priv *priv, enum reg index, u16 va=
l);
> @@ -236,4 +237,9 @@ static inline u8 c_can_get_tx_tail(const struct c_can=
_tx_ring *ring)
>  	return ring->tail & (ring->obj_num - 1);
>  }
> =20
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
>  static bool c_can_tx_busy(const struct c_can_priv *priv,
>  			  const struct c_can_tx_ring *tx_ring)
>  {
> @@ -470,7 +456,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *s=
kb,
>  	struct can_frame *frame =3D (struct can_frame *)skb->data;
>  	struct c_can_priv *priv =3D netdev_priv(dev);
>  	struct c_can_tx_ring *tx_ring =3D &priv->tx;
> -	u32 idx, obj;
> +	u32 idx, obj, cmd =3D IF_COMM_TX;
> =20
>  	if (can_dropped_invalid_skb(dev, skb))
>  		return NETDEV_TX_OK;
> @@ -483,7 +469,11 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *=
skb,
>  	if (c_can_get_tx_free(tx_ring) =3D=3D 0)
>  		netif_stop_queue(dev);
> =20
> -	obj =3D idx + priv->msg_obj_tx_first;
> +	spin_lock_bh(&priv->tx_lock);

What does the spin_lock protect? The ndo_start_xmit function is properly
serialized by the networking core.

Otherwise the patch looks good!

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vdeu2tms3hj5egqq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEKYagACgkQqclaivrt
76koYwf/VB746DM0v/+iyR3r8TdJsKJEJp5x3d/t6SQf6kHjdOnXF/v3espWwPKF
44FFrD/LkOx51pxxCV753LtpgGn34eQPcVCLSm8QItkFyB1Am5/wZ9E1hIkQ4cnw
hREw9ClpB5bDlKIHYfAo6qTFCqokuZFz+1gSdmRA6oPTQBAeVWCU7OzmJjMFeVau
mKAp5GcNz5YO3x/QEOEfqCemWFT9WYDzxaS7c3w2Mzu9yesGfzJRSjRQ6gGcP5hE
3TVcQdyegZEKWhHrehL7YxtHF8Y6HYxvZypTDt78gvQx2eFQiME3bHIIM2s5wdFP
wGBfVGU/Uipg753+1k/9SgEUj9/ZUQ==
=N0WF
-----END PGP SIGNATURE-----

--vdeu2tms3hj5egqq--
