Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCF231072E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhBEIz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:55:26 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38755 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhBEIzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 03:55:20 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l7wqh-0006EF-6p; Fri, 05 Feb 2021 09:52:19 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:8f9f:ac65:660b:ab5f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id F246C5D72D6;
        Fri,  5 Feb 2021 08:52:15 +0000 (UTC)
Date:   Fri, 5 Feb 2021 09:52:15 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Xulin Sun <xulin.sun@windriver.com>
Cc:     wg@grandegger.com, dmurphy@ti.com, sriram.dash@samsung.com,
        kuba@kernel.org, davem@davemloft.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xulinsun@gmail.com
Subject: Re: [PATCH 2/2] can: m_can: m_can_class_allocate_dev(): remove
 impossible error return judgment
Message-ID: <20210205085215.sgsvtys5z4gm3ict@hardanger.blackshift.org>
References: <20210205072559.13241-1-xulin.sun@windriver.com>
 <20210205072559.13241-2-xulin.sun@windriver.com>
 <20210205081911.4xvabbzdtkvkpplq@hardanger.blackshift.org>
 <9cae961a-881d-8678-6ec3-0fd00c74c8ad@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5ixmah6qra6ivpgj"
Content-Disposition: inline
In-Reply-To: <9cae961a-881d-8678-6ec3-0fd00c74c8ad@windriver.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5ixmah6qra6ivpgj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.02.2021 16:46:16, Xulin Sun wrote:
> On 2021/2/5 =E4=B8=8B=E5=8D=884:19, Marc Kleine-Budde wrote:
> > On 05.02.2021 15:25:59, Xulin Sun wrote:
> > > If the previous can_net device has been successfully allocated, its
> > > private data structure is impossible to be empty, remove this redunda=
nt
> > > error return judgment. Otherwise, memory leaks for alloc_candev() will
> > > be triggered.
> > Your analysis is correct, the netdev_priv() will never fail. But how
> > will this trigger a mem leak on alloc_candev()? I've removed that
>=20
> The previous code judges the netdev_priv is empty, and then goto out. The
> correct approach should add free_candev(net_dev) before goto.
>=20
> The code Like:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 class_dev =3D netdev_priv(net_=
dev);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!class_dev) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 dev_err(dev, "Failed to init netdev cdevate");
> +=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 free_candev(net_dev);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 goto out;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> Otherwise, memory leaks for alloc_candev() will be triggered.

No - as you said in the original patch description. The return value
of netdev_priv() cannot be NULL, as net_dev is not NULL.

> Now directly remove the impossible error return judgment to resolve
> the above possible issue.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5ixmah6qra6ivpgj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAdBzwACgkQqclaivrt
76m8Wwf/XrNhbJ9LzHFhjVk8mBwZETNanYtNEHxJ7lZWEjMqjblzlefUvetmmfUA
ft2uXaKHgJK5iWQiE8e8RFUzgKO/8Ff/whcfw7/YRtdQsGYQCIDhZ5L8xrIN1fr+
1MocCKg08DuPBTa2hdRLn2zz3M1hOILVd6EcBolFHjWZ2obXuT6gT34AZ4tOXRwD
07w31mfqQ6tYwBCv8SmhiZ8TSTDyGajv+Kqb2lhatTEMT5QfZC40OO5meCJhSyDi
LcRmnitxcpbxlZuxP1ymadM6Nb7/urHYW/YCIhmYAJE1Jca4EtJYjb2TQ84RGxnJ
r/9unNZqAMepkLnGB+N7aXSGx9kAyg==
=LRzj
-----END PGP SIGNATURE-----

--5ixmah6qra6ivpgj--
