Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD943245A5
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 22:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhBXVPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 16:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbhBXVPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 16:15:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82E0C061756
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 13:14:34 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lF1UE-00078Y-RH; Wed, 24 Feb 2021 22:14:22 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:55fd:a17b:b4ca:d5fb])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C3D555E8908;
        Wed, 24 Feb 2021 21:14:19 +0000 (UTC)
Date:   Wed, 24 Feb 2021 22:14:18 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Robin van der Gracht <robin@protonic.nl>,
        Andre Naujoks <nautsch2@gmail.com>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3 1/1] can: can_skb_set_owner(): fix ref counting if
 socket was closed before setting skb ownership
Message-ID: <20210224211418.74dltgabq2rpfuf2@pengutronix.de>
References: <20210224075932.20234-1-o.rempel@pengutronix.de>
 <CANn89iLEHpCphH8vKd=0BS7pgdP1YZDGqQfQPeGBkD09RoHtzg@mail.gmail.com>
 <76ec5c10-c051-7a52-9ae7-04af79a0e9e5@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dnjabxnrhdo3b7pb"
Content-Disposition: inline
In-Reply-To: <76ec5c10-c051-7a52-9ae7-04af79a0e9e5@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dnjabxnrhdo3b7pb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.02.2021 21:32:29, Oliver Hartkopp wrote:
> > > To fix this problem, only set skb ownership to sockets which have sti=
ll
> > > a ref count > 0.
> > >=20
> > > Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> > > Cc: Andre Naujoks <nautsch2@gmail.com>
> > > Suggested-by: Eric Dumazet <edumazet@google.com>
> > > Fixes: 0ae89beb283a ("can: add destructor for self generated skbs")
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> >=20
> > SGTM
> >=20
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> >=20
> > > ---
> > >   include/linux/can/skb.h | 3 +--
> > >   1 file changed, 1 insertion(+), 2 deletions(-)
> > >=20
> > > diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
> > > index 685f34cfba20..655f33aa99e3 100644
> > > --- a/include/linux/can/skb.h
> > > +++ b/include/linux/can/skb.h
> > > @@ -65,8 +65,7 @@ static inline void can_skb_reserve(struct sk_buff *=
skb)
> > >=20
> > >   static inline void can_skb_set_owner(struct sk_buff *skb, struct so=
ck *sk)
> > >   {
> > > -       if (sk) {
> > > -               sock_hold(sk);
>=20
> Although the commit message gives a comprehensive reason for this patch: =
Can
> you please add some comment here as I do not think the use of
> refcount_inc_not_zero() makes clear what is checked here.

Good point. What about:

If the socket has already been closed by user space, the refcount may
already be 0 (and the socket will be freed after the last TX skb has
been freed). So only increase socket refcount if the refcount is > 0.

regards
Marc

P.S.: Have you had time to look at my ISOTOP RFC patch?

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dnjabxnrhdo3b7pb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA2waYACgkQqclaivrt
76nYUAf/RrC5ym0WGkJahDL9D9tdBge7At8Sl8OywoWTczF1RKFmTf+rYh+QZryN
4/8Oyu+FNUIsKueWAukyE9cEzuja9K7RjGHD8j8JlUKxDZtfei9PrXEZh2QqRrAk
A9rt1Uy9KaHPDAmn9O79gpgbd7/Zaopyz4X8u4lzusibVJD0PoQcAOgC3E7MERZK
7/FvUYNzePRSGydOFEKCrcwIcxl7zWHIyQGLeioTCWwzqdLGyBn3wTY44fuhuBYE
uMYY59ePaZk8OIG7YXhgJMtwstiXCEhSUnFINivQcg9va3FnsvBKSxYnInje5S2W
O0EO83ZMmDTs8XIJZQL55MScMZKtHg==
=qiPV
-----END PGP SIGNATURE-----

--dnjabxnrhdo3b7pb--
