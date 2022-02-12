Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D3C4B3692
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 17:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbiBLQrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 11:47:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237543AbiBLQrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 11:47:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C305F90
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 08:47:36 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nIvYP-0007u5-9e; Sat, 12 Feb 2022 17:47:21 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9561B31D1E;
        Sat, 12 Feb 2022 16:47:16 +0000 (UTC)
Date:   Sat, 12 Feb 2022 17:47:13 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v3 1/4] can: rcar_canfd: Add support for r8a779a0 SoC
Message-ID: <20220212164713.nox3exvugm7awjsu@pengutronix.de>
References: <20220209163806.18618-1-uli+renesas@fpond.eu>
 <20220209163806.18618-2-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vmam5jyc3sbwdq7y"
Content-Disposition: inline
In-Reply-To: <20220209163806.18618-2-uli+renesas@fpond.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vmam5jyc3sbwdq7y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.02.2022 17:38:03, Ulrich Hecht wrote:
> Adds support for the CANFD IP variant in the V3U SoC.
>=20
> Differences to controllers in other SoCs are limited to an increase in
> the number of channels from two to eight, an absence of dedicated
> registers for "classic" CAN mode, and a number of differences in magic
> numbers (register offsets and layouts).
>=20
> Inspired by BSP patch by Kazuya Mizuguchi.
>=20
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 219 ++++++++++++++++++++----------
>  1 file changed, 146 insertions(+), 73 deletions(-)
>=20
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rca=
r_canfd.c
> index b7dc1c32875f..3ad3a6f6a1dd 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -44,6 +44,7 @@
>  enum rcanfd_chip_id {
>  	RENESAS_RCAR_GEN3 =3D 0,
>  	RENESAS_RZG2L,
> +	RENESAS_R8A779A0,
>  };
> =20
>  /* Global register bits */
> @@ -79,6 +80,7 @@ enum rcanfd_chip_id {
>  #define RCANFD_GSTS_GNOPM		(BIT(0) | BIT(1) | BIT(2) | BIT(3))
> =20
>  /* RSCFDnCFDGERFL / RSCFDnGERFL */
> +#define RCANFD_GERFL_EEF0_7		GENMASK(23, 16)
>  #define RCANFD_GERFL_EEF1		BIT(17)
>  #define RCANFD_GERFL_EEF0		BIT(16)
>  #define RCANFD_GERFL_CMPOF		BIT(3)	/* CAN FD only */
> @@ -86,20 +88,24 @@ enum rcanfd_chip_id {
>  #define RCANFD_GERFL_MES		BIT(1)
>  #define RCANFD_GERFL_DEF		BIT(0)
> =20
> -#define RCANFD_GERFL_ERR(gpriv, x)	((x) & (RCANFD_GERFL_EEF1 |\
> -					RCANFD_GERFL_EEF0 | RCANFD_GERFL_MES |\
> -					(gpriv->fdmode ?\
> -					 RCANFD_GERFL_CMPOF : 0)))
> +#define RCANFD_GERFL_ERR(x)		((x) & (reg_v3u(gpriv, RCANFD_GERFL_EEF0_7,=
 \
> +					RCANFD_GERFL_EEF0 | RCANFD_GERFL_EEF1) | \
> +					RCANFD_GERFL_MES | ((gpriv)->fdmode ? \
> +					RCANFD_GERFL_CMPOF : 0)))

The macros are relying on gpriv being in the scope. Please make them
arguments of the macros.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vmam5jyc3sbwdq7y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIH5I4ACgkQrX5LkNig
0139Nwf/S+/pyreEo3AZBPmCozEOWvqAqYSHxcx3dd/RsJGTy4gFCNZBWEKgF1n3
q6iLFOvHnfEOcbywRK2cYpsX7Wfa0jOOzV4bB84p4+WQTObYo26MgSE/WHb181uy
tVkEof3DWIO9NmRXLn68UFuo0aV9bSH8F+LBbCWG+StjQOVb/NAe83M5gUGuAh4A
TuUFA9YK3ShCqSS9Wa69na9G2aDfah6D3gR+Ymp5Zcb9ELNzmD8M5ciQ3tIaoI6m
DXE//DSPGrHj03XWoeFQzasw9IakBQvFQEjkhtHyZAQJ7tGe94sjymofiKpjAgG8
muc08/Iyju/aSFfX4FKKkr4AtsilUQ==
=/4Hy
-----END PGP SIGNATURE-----

--vmam5jyc3sbwdq7y--
