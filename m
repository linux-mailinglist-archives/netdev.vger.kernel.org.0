Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E298439EF3
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhJYTJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbhJYTJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:09:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F07AC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 12:06:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mf5J8-0001dM-6j; Mon, 25 Oct 2021 21:06:54 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-e094-d8e8-b5aa-4a00.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:e094:d8e8:b5aa:4a00])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3C9A169DAE8;
        Mon, 25 Oct 2021 19:06:53 +0000 (UTC)
Date:   Mon, 25 Oct 2021 21:06:51 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] can: dev: replace can_priv::ctrlmode_static by
 can_get_static_ctrlmode()
Message-ID: <20211025190651.p4ivcrqinknmwuu5@pengutronix.de>
References: <20211009131304.19729-1-mailhol.vincent@wanadoo.fr>
 <20211009131304.19729-2-mailhol.vincent@wanadoo.fr>
 <20211024183007.u5pvfnlawhf36lfn@pengutronix.de>
 <CAMZ6RqLw+B8ZioOyMFzha67Om3c8eKEK4P53U9xHiVxB4NBhkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hdl3z2qryohrhhie"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLw+B8ZioOyMFzha67Om3c8eKEK4P53U9xHiVxB4NBhkA@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hdl3z2qryohrhhie
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.10.2021 02:22:36, Vincent MAILHOL wrote:
> Welcome back on the mailing list, hope you had some nice
> holidays!

Thanks was really nice, good weather, 1000km of cycling and hanging
around in Vienna. :D

> And also thanks a lot for your support over the last
> few months on my other series to introduce the TDC netlink
> interface :)

The pleasure is on my side, working with you!

> Le lun. 25 oct. 2021 =C3=A0 03:30, Marc Kleine-Budde <mkl@pengutronix.de>=
 a =C3=A9crit :
> >
> > On 09.10.2021 22:13:02, Vincent Mailhol wrote:
> > > The statically enabled features of a CAN controller can be retrieved
> > > using below formula:
> > >
> > > | u32 ctrlmode_static =3D priv->ctrlmode & ~priv->ctrlmode_supported;
> > >
> > > As such, there is no need to store this information. This patch remove
> > > the field ctrlmode_static of struct can_priv and provides, in
> > > replacement, the inline function can_get_static_ctrlmode() which
> > > returns the same value.
> > >
> > > A condition sine qua non for this to work is that the controller
> > > static modes should never be set in can_priv::ctrlmode_supported. This
> > > is already the case for existing drivers, however, we added a warning
> > > message in can_set_static_ctrlmode() to check that.
> >
> > Please make the can_set_static_ctrlmode to return an error in case of a
> > problem. Adjust the drivers using the function is this patch, too.
>=20
> I didn't do so initially because this is more a static
> configuration issue that should only occur during
> development. Nonetheless, what you suggest is really simple.
>=20
> I will just split the patch in two: one of the setter and one for
> the getter and address your comments.

Fine with me. Most important thing is, that the kernel compiles after
each patch.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hdl3z2qryohrhhie
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF3AEkACgkQqclaivrt
76lZQwf/aUFiJLjCo3hbPXGkOXwuXKQNKDV4YgEBk31+pHC3hCFuL9sdnwizXIGd
xjccJ0e4gCK5rFvKjKv3GVpemP6gKEZxEo9MAPWjOsqSPxCy3B65yUJTQGfFrv9H
jDvVr2dMfYTTWw8pg1//7PfCpc5FjBR/oR3UZfkcmUbP17FF5ktYErF+86CakuyG
5mIdzZDwmcod3F2u8nbE60kYeCueYBq1t6VsP0n6HMBJBqd/OdnrraAloDvYHb87
pehrAx87/YTnr3/aCoBQXPVBzCUvtgUNLsZzTQskbNJRVaYJ8SgqyGXHVw4RyadI
fPjJNHcsMbCQpbW4t4NNwYnAbMMokA==
=PK3o
-----END PGP SIGNATURE-----

--hdl3z2qryohrhhie--
