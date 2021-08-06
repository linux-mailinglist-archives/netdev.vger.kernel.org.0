Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079F13E248F
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241468AbhHFHwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240780AbhHFHwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 03:52:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E416BC061799
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 00:52:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBueZ-00069C-1x; Fri, 06 Aug 2021 09:52:27 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:66f0:974b:98ab:a2fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 505C9661C36;
        Fri,  6 Aug 2021 07:52:22 +0000 (UTC)
Date:   Fri, 6 Aug 2021 09:52:20 +0200
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
Message-ID: <20210806075220.2psgtigcy3quyzrw@pengutronix.de>
References: <20210725161150.11801-1-dariobin@libero.it>
 <20210725161150.11801-5-dariobin@libero.it>
 <20210804093423.ms2p245f5oiw4xn4@pengutronix.de>
 <1172393027.218339.1628194339000@mail1.libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ytec7r7yzkahyzfg"
Content-Disposition: inline
In-Reply-To: <1172393027.218339.1628194339000@mail1.libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ytec7r7yzkahyzfg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.08.2021 22:12:18, Dario Binacchi wrote:
> > > diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_=
can.h
> > > index 8fe7e2138620..fc499a70b797 100644
> > > --- a/drivers/net/can/c_can/c_can.h
> > > +++ b/drivers/net/can/c_can/c_can.h
> > > +static inline u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
> > > +{
> > > +	return ring->obj_num - (ring->head - ring->tail);
> > > +}
> > > +
> > >  #endif /* C_CAN_H */
> > > diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_c=
an/c_can_main.c
> > > index 451ac9a9586a..4c061fef002c 100644
> > > --- a/drivers/net/can/c_can/c_can_main.c
> > > +++ b/drivers/net/can/c_can/c_can_main.c
> > > @@ -427,20 +427,6 @@ static void c_can_setup_receive_object(struct ne=
t_device *dev, int iface,
> > >  	c_can_object_put(dev, iface, obj, IF_COMM_RCV_SETUP);
> > >  }
> > > =20
> > > -static u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
> > > -{
> > > -	u8 head =3D c_can_get_tx_head(ring);
> > > -	u8 tail =3D c_can_get_tx_tail(ring);
> > > -
> > > -	/* This is not a FIFO. C/D_CAN sends out the buffers
> > > -	 * prioritized. The lowest buffer number wins.
> > > -	 */
> > > -	if (head < tail)
> > > -		return 0;
> > > -
> > > -	return ring->obj_num - head;
> > > -}
> > > -
> >=20
> > Can you move that change into patch 3?
>=20
> Patch 3 adds the ring transmission algorithm without compromising the
> message transmission order. This is not a FIFO.

Right, thanks!

> C/D_CAN controller sends out the buffers prioritized. The lowest
> buffer number wins, so moving the change into patch 3 may not
> guarantee the transmission order. In patch 3, however, I will move
> c_can_get_tx_free() from c_can_main.c to c_can.h, so that in patch 4
> it will be clearer how the routine has changed.

The updated patch looks much nicer now, thanks!

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ytec7r7yzkahyzfg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEM6jIACgkQqclaivrt
76mJTQf+LOmiuG/ukL5ndwOZWfIUKOjv3Zeu0AN9oksXoiX65pkqa4Vb+NJydIi/
hxd6qqOx7Sf7V81++0IV2fCIp3uCBLg+4dtvXewHhYfQcfnRhWXvcHYIE/RBYXBY
Qb6jn1uBybhQQPX/SpkAj/1wXMniIIPwsl15ewUMkaNTL3gZgVwoanTpYgLX9h9J
mdkmTZBb3pHm+uT0q3oAVSkzX4QN//mXwKQ2wdI/qjkBA2Y3zSFakLZca4/Z3qMK
U2r47AAkeZGzqv4nTg7UdF7AQ9Fi0NJYGxqKahdTuObNVZbq7mqhdlNSUUHtakQK
aVkDXxw8suuxsLXyn9HKAeh/PZXt/A==
=m0gP
-----END PGP SIGNATURE-----

--ytec7r7yzkahyzfg--
