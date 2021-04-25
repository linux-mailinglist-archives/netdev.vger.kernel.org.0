Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2615636A5FA
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 11:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhDYJIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 05:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhDYJIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 05:08:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350D1C061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 02:08:02 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1laak7-0004FR-9Y; Sun, 25 Apr 2021 11:07:55 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:c28e:7dee:2502:6631])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B055D61683D;
        Sun, 25 Apr 2021 09:07:52 +0000 (UTC)
Date:   Sun, 25 Apr 2021 11:07:51 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Erik Flodin <erik@flodin.me>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: fix proc/can/net/rcvlist_* header alignment on
 64-bit system
Message-ID: <20210425090751.2jqj4yqx5ztyqhvg@pengutronix.de>
References: <20210425084950.171529-1-erik@flodin.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rjbsgmzjagbnrltp"
Content-Disposition: inline
In-Reply-To: <20210425084950.171529-1-erik@flodin.me>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rjbsgmzjagbnrltp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Erik,

the subject is not 100% correct, actually it is /proc/net/can/rcvlist_*

On 25.04.2021 10:49:29, Erik Flodin wrote:
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
> index 5ea8695f507e..97901e56c429 100644
> --- a/net/can/proc.c
> +++ b/net/can/proc.c
> @@ -205,8 +205,11 @@ static void can_print_recv_banner(struct seq_file *m)
>  	 *                  can1.  00000000  00000000  00000000
>  	 *                 .......          0  tp20
>  	 */
> -	seq_puts(m, "  device   can_id   can_mask  function"
> -			"  userdata   matches  ident\n");
> +	const char *pad =3D sizeof(void *) =3D=3D 8 ? "    " : "";

nitpick: please move this to the beginning of the function, even before
the comment.

> +
> +	seq_printf(m, "  device   can_id   can_mask  %sfunction%s"
> +		   "  %suserdata%s   matches  ident\n",

nitpick:
For printed strings it's better to have them in a single line, so that
grepping for them is easier.

> +		   pad, pad, pad, pad);
>  }
> =20
>  static int can_stats_proc_show(struct seq_file *m, void *v)
> --=20
> 2.31.0
>=20
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rjbsgmzjagbnrltp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCFMWUACgkQqclaivrt
76nfpwf/cWOE7JZ/XzLWmDQF8+J8nzEU4xxgH0FXeoT9noHPZh0IbVTVtvCT/Z4K
5VIsenBWH8ga0RB8O/hF7mhWHn6i3cptkiMqgBcNftje4+GkX89S5vTxeuHCgeYk
EPY1lYhUbuTDQ4j/roV9kZsJ39aNofptVXVuLS2LTczRqdZmDVpCyfC85ybwpn+v
8Aof1OiTb5hexwCYskTfX4lR+Eg2SJPb2qVLwKfoR7nqPouUQSGqTCMJFSeduVqZ
ap5fNq7CIMb3akBY2CfJXyCFiOiYF7vb46KL+SlMTBAV1w5jeAMaaW73L8wkmyx+
Qd/YrHjstGWeGUre04i5rhvTeb92ig==
=OxLH
-----END PGP SIGNATURE-----

--rjbsgmzjagbnrltp--
