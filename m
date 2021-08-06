Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D24B3E2730
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244527AbhHFJZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbhHFJZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 05:25:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FC6C061799
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 02:25:35 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBw6b-0000hA-5H; Fri, 06 Aug 2021 11:25:29 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:66f0:974b:98ab:a2fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 58E50661D38;
        Fri,  6 Aug 2021 09:25:25 +0000 (UTC)
Date:   Fri, 6 Aug 2021 11:25:23 +0200
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
Message-ID: <20210806092523.hij5ejjq6wecbgfr@pengutronix.de>
References: <20210725161150.11801-1-dariobin@libero.it>
 <20210725161150.11801-5-dariobin@libero.it>
 <20210804094515.ariv7d24t2i4hic5@pengutronix.de>
 <1485600069.218377.1628194566441@mail1.libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7iqxv4fk64mddgi7"
Content-Disposition: inline
In-Reply-To: <1485600069.218377.1628194566441@mail1.libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7iqxv4fk64mddgi7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.08.2021 22:16:06, Dario Binacchi wrote:
> > > --- a/drivers/net/can/c_can/c_can.h
> > > +++ b/drivers/net/can/c_can/c_can.h
> > > @@ -200,6 +200,7 @@ struct c_can_priv {
> > >  	atomic_t sie_pending;
> > >  	unsigned long tx_dir;
> > >  	int last_status;
> > > +	spinlock_t tx_lock;
> >=20
> > What does the spin lock protect?
[...]
> > > @@ -483,7 +469,11 @@ static netdev_tx_t c_can_start_xmit(struct sk_bu=
ff *skb,
> > >  	if (c_can_get_tx_free(tx_ring) =3D=3D 0)
> > >  		netif_stop_queue(dev);
> > > =20
> > > -	obj =3D idx + priv->msg_obj_tx_first;
> > > +	spin_lock_bh(&priv->tx_lock);
> >=20
> > What does the spin_lock protect? The ndo_start_xmit function is properly
> > serialized by the networking core.
> >=20
>=20
> The spin_lock protects the access to the IF_TX interface.

How? You only use the spin_lock in c_can_start_xmit(), but not anywhere
else.

> Enabling the transmission of cached messages occur inside interrupt

The call chain is c_can_poll() -> c_can_do_tx(), and c_can_poll() is
called from NAPI, which is not the IRQ handler.

> and the use of the IF_RX interface, which would avoid the use of the
> spinlock, has not been validated by the tests.

What do you mean be has not been validated?

The driver already uses IF_RX to avoid concurrent access in
c_can_do_tx() for c_can_inval_tx_object() [1], why not use IF_RX for
c_can_object_put(), too?

[1] https://lore.kernel.org/r/20210302215435.18286-4-dariobin@libero.it

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7iqxv4fk64mddgi7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmENAAEACgkQqclaivrt
76lMMwgAjXgHSoDKSNnaDwB8xLfHIA0i0vgMnwo+f82AnyFrFRJil6i4UyYDEdRP
FUZ6Gvi8/rG838Wf+lklNcdz66bhPI4WF+fwC76xekDUWqG4KJPJZyg17RiZ7ESU
G+bk7aOZB34Je45xLxcuTFncnM48Lb8M5PwXrkO36R2GMo2qrfKN3cAKm8B6Fz+y
7p/5/j/d0D0GB8HbYUY64bccuF/iCr4uDaXD3MSbwTrF/QdckMy6yPmjpFfaMMLz
5ksHn/d7hO30GvAQJmr4nmYiksFBTrUwio1wnYbdiM3A2E+6Syqh8vbWDH3x5m8p
EQJypD3+YjvwpRVb9hR5DRFtLrIIhw==
=lEmb
-----END PGP SIGNATURE-----

--7iqxv4fk64mddgi7--
