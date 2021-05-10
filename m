Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBE7378D58
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348184AbhEJMka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 08:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346893AbhEJMcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 08:32:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F2BC061760
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 05:25:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lg4yK-0006PI-Q0; Mon, 10 May 2021 14:25:16 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:80ab:77d5:ac71:3f91])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AEB03621482;
        Mon, 10 May 2021 12:25:13 +0000 (UTC)
Date:   Mon, 10 May 2021 14:25:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] can: c_can: cache frames to operate as a true FIFO
Message-ID: <20210510122512.5lcvvvwzk6ujamzb@pengutronix.de>
References: <20210509124309.30024-1-dariobin@libero.it>
 <20210509124309.30024-4-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2ih2q34cstztikmf"
Content-Disposition: inline
In-Reply-To: <20210509124309.30024-4-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2ih2q34cstztikmf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.05.2021 14:43:09, Dario Binacchi wrote:
> As reported by a comment in the c_can_start_xmit() this was not a FIFO.
> C/D_CAN controller sends out the buffers prioritized so that the lowest
> buffer number wins.
>=20
> What did c_can_start_xmit() do if it found tx_active =3D 0x80000000 ? It
> waited until the only frame of the FIFO was actually transmitted by the
> controller. Only one message in the FIFO but we had to wait for it to
> empty completely to ensure that the messages were transmitted in the
> order in which they were loaded.
>=20
> By storing the frames in the FIFO without requiring its transmission, we
> will be able to use the full size of the FIFO even in cases such as the
> one described above. The transmission interrupt will trigger their
> transmission only when all the messages previously loaded but stored in
> less priority positions of the buffers have been transmitted.

The algorithm you implemented looks a bit too complicated to me. Let me
sketch the algorithm that's implemented by several other drivers.

- have a power of two number of TX objects
- add a number of objects to struct priv (tx_num)
  (or make it a define, if the number of tx objects is compile time fixed)
- add two "unsigned int" variables to your struct priv,
  one "tx_head", one "tx_tail"
- the hard_start_xmit() writes to priv->tx_head & (priv->tx_num - 1)
- increment tx_head
- stop the tx_queue if there is no space or if the object with the
  lowest prio has been written
- in TX complete IRQ, handle priv->tx_tail object
- increment tx_tail
- wake queue if there is space but don't wake if we wait for the lowest
  prio object to be TX completed.

Special care needs to be taken to implement that lock-less and race
free. I suggest to look the the mcp251xfd driver.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2ih2q34cstztikmf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCZJiYACgkQqclaivrt
76n85Qf+IT0CNwHgyifNTN8tBzEVWhYReBtoqj7LAtMvAsdAwLBdWxwfZYmV/W2Z
j4qm4tSAVx8HXltmly0GfUgCcGAaPKLg83sGd29Azlgmj+6R4/rWB5ygDyjvLPgc
TByJLVMRF5Tlur1rvIr9gMPi18DFa3GtvG9eT3lN2yl1CLCjltae1oXDO084S559
uU9bU2WS+cjjljWqN60AHG/KaZMT7+Iw6bqkgi6NYcDHXEl0mSJU1j7jXw8tNvPY
WHypzcF2Svg1rxdo1JDNRwgMMFPGzGwrI+R4OrsPzTKI6VuV8IE5noRTWziEx2R/
k0Bw3cXlQcvx78nTGXPv25iBlvCVyQ==
=cxQ0
-----END PGP SIGNATURE-----

--2ih2q34cstztikmf--
