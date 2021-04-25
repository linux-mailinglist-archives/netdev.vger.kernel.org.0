Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE6C36A732
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 14:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhDYM1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 08:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhDYM1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 08:27:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27571C061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 05:27:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ladqp-0005Oh-2f; Sun, 25 Apr 2021 14:27:03 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:c28e:7dee:2502:6631])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C60F8616A06;
        Sun, 25 Apr 2021 12:27:01 +0000 (UTC)
Date:   Sun, 25 Apr 2021 14:27:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Erik Flodin <erik@flodin.me>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] can: proc: fix rcvlist_* header alignment on 64-bit
 system
Message-ID: <20210425122701.qbalhfsbybip2fci@pengutronix.de>
References: <20210425095249.177588-1-erik@flodin.me>
 <20210425122222.223839-1-erik@flodin.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eylayemx5lnooqb5"
Content-Disposition: inline
In-Reply-To: <20210425122222.223839-1-erik@flodin.me>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eylayemx5lnooqb5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.04.2021 14:22:12, Erik Flodin wrote:
> Before this fix, the function and userdata columns weren't aligned:
>   device   can_id   can_mask  function  userdata   matches  ident
>    vcan0  92345678  9fffffff  0000000000000000  0000000000000000         =
0  raw
>    vcan0     123    00000123  0000000000000000  0000000000000000         =
0  raw
>=20
> After the fix they are:
>   device   can_id   can_mask      function          userdata       matche=
s  ident
>    vcan0  92345678  9fffffff  0000000000000000  0000000000000000         =
0  raw
>    vcan0     123    00000123  0000000000000000  0000000000000000         =
0  raw
>=20
> Signed-off-by: Erik Flodin <erik@flodin.me>
> ---
>  net/can/proc.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/can/proc.c b/net/can/proc.c
> index 5ea8695f507e..35b6c7512785 100644
> --- a/net/can/proc.c
> +++ b/net/can/proc.c
> @@ -205,8 +205,11 @@ static void can_print_recv_banner(struct seq_file *m)
>  	 *                  can1.  00000000  00000000  00000000
>  	 *                 .......          0  tp20
>  	 */
> -	seq_puts(m, "  device   can_id   can_mask  function"
> -			"  userdata   matches  ident\n");
> +#ifdef CONFIG_64BIT
> +	seq_puts(m, "  device   can_id   can_mask      function          userda=
ta       matches  ident\n");
> +#else
> +	seq_puts(m, "  device   can_id   can_mask  function  userdata   matches=
  ident\n");
> +#endif

Please use "if (IS_ENABLED(CONFIG_64BIT))" as in your example in your
previous mail.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--eylayemx5lnooqb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCFYBIACgkQqclaivrt
76n+IwgArH+NoIerBVRpihiHzwkmq/YQwICNE2BCNRbM8MOdqcuRa3d1+DkG8+br
3x6oyfJ0aA+k9xO3CUdAp/X35ESxDPmVtVOfPLQYKq9fFOfxJ2wwektlJ9a93eXY
9PAAPkmLFUnxGDeDENvMYmXauHH83s1dsfuH2wGwTCL3ZDIOid5yPwkaGJXzn4NB
06T5yCHTPMHjoDyD7esV+lX4BRrFY+1eUa6fotQsa3kEc51rcNRvBrq50+Iwa96W
tytRjh0wzqBrMilRX+yyKbM04TZkdXHsGRZ5httnkARds654pnzL/9R9mLxZ1Rys
WUrFbQMb3bpzlad/HxAstJnSXI+9Kg==
=B2E4
-----END PGP SIGNATURE-----

--eylayemx5lnooqb5--
