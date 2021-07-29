Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825C43DA2A7
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbhG2L6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 07:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234231AbhG2L6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 07:58:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7303AC0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 04:58:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m94fd-00060L-LG; Thu, 29 Jul 2021 13:57:49 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:f664:c769:c9a5:5ced])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 80EE165AE04;
        Thu, 29 Jul 2021 11:57:45 +0000 (UTC)
Date:   Thu, 29 Jul 2021 13:57:44 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        angelo@kernel-space.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] can: flexcan: Fix an uninitialized variable issue
Message-ID: <20210729115744.ta5lo42d4metzxtf@pengutronix.de>
References: <a55780a2f4c8f1895b6bcbac4d3f8312b2731079.1627557857.git.christophe.jaillet@wanadoo.fr>
 <20210729113101.n5aucrwu56lyqhg7@pengutronix.de>
 <20210729114442.GT1931@kadam>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="73tosamqqeac4x5o"
Content-Disposition: inline
In-Reply-To: <20210729114442.GT1931@kadam>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--73tosamqqeac4x5o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.07.2021 14:44:42, Dan Carpenter wrote:
> On Thu, Jul 29, 2021 at 01:31:01PM +0200, Marc Kleine-Budde wrote:
> > On 29.07.2021 13:27:42, Christophe JAILLET wrote:
> > > If both 'clk_ipg' and 'clk_per' are NULL, we return an un-init value.
> > > So set 'err' to 0, to return success in such a case.
> >=20
> > Thanks for the patch, a similar one has been posted before:
> > https://lore.kernel.org/linux-can/20210728075428.1493568-1-mkl@pengutro=
nix.de/
> >=20
> > > Fixes: d9cead75b1c6 ("can: flexcan: add mcf5441x support")
> > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > > ---
> > > Another way to fix it is to remove the NULL checks for 'clk_ipg' and
> > > 'clk_per' that been added in commit d9cead75b1c6.
> > >=20
> > > They look useless to me because 'clk_prepare_enable()' returns 0 if i=
t is
> > > passed a NULL pointer.
> >=20
> > ACK, while the common clock framework's clk_prepare_enable() can handle
> > NULL pointers, the clock framework used on the mcf5441x doesn't.
>=20
> Huh?  It looks like it just uses the regular stuff?

https://lore.kernel.org/linux-can/CAMuHMdUeeH2BWgVRoVX7yfckY=3Dwi8X3qkaH0TH=
hVF_3FpZsbqg@mail.gmail.com/
Geert Uytterhoeven said:

>> Except that the non-CCF implementation of clk_enable() in
>> arch/m68k/coldfire/clk.c still returns -EINVAL instead of NULL.
>> Any plans to move to CCF? Or at least fix legacy clk_enable().

https://lore.kernel.org/linux-can/7c1151fc-cc28-cbc0-c385-313428b32dd7@kern=
el-space.org/
Angelo Dureghello said:
>> as Geert pointed out, right now without this protection
>> (that shouldn't anyway harm), probe fails:
>>=20
>> [    1.680000] flexcan: probe of flexcan.0 failed with error -22

Maybe it's time to fix the mcf5441x's clk_enable() as Geert pointed out.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--73tosamqqeac4x5o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmECl7YACgkQqclaivrt
76k7Hwf8CPDPauuzqcjQbON/KZXOqa6NlC4gzaGfi769N9cePz2abzU5lSugGuYR
J8nIAU8rnksLWHn7KkxPBF4wSfrbFHv/oWpy5V420b0X9dHHP57dGREZVSqbhGg6
TL8Kb+Guud/L+Z9W1yEkis9Y7e0E3NJNsg56fnOwec9MeFPHSWdkSVve3ng8Te5N
o72z+HcEgN8YdJXZA7v4TX6FdJMevFVhvTH31Oj3SnugmgiHR9UEXGhBSNYhqP2R
isXmNfo1wXJ4itD+5CGHyRZzrJN4iH8acpLwbsdJ6pESCv6XXMxIbHsGaCEe38mh
uo7VfTlr+PLoNIqLsLv0eCAQHZVZYg==
=hCb4
-----END PGP SIGNATURE-----

--73tosamqqeac4x5o--
