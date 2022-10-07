Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42EA75F74CF
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 09:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiJGHpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 03:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiJGHpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 03:45:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4176B2D1DF
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 00:45:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ogi2V-0006ix-KW; Fri, 07 Oct 2022 09:44:59 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B4EEEF6BBA;
        Fri,  7 Oct 2022 07:44:58 +0000 (UTC)
Date:   Fri, 7 Oct 2022 09:44:56 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH iproute2-next 5.16 v6 3/5] iplink_can: use PRINT_ANY to
 factorize code and fix signedness
Message-ID: <20221007074456.l2sh3s2siuv2a74m@pengutronix.de>
References: <20211103164428.692722-1-mailhol.vincent@wanadoo.fr>
 <20211103164428.692722-4-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a6xg66tp3ixk7cut"
Content-Disposition: inline
In-Reply-To: <20211103164428.692722-4-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--a6xg66tp3ixk7cut
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.11.2021 01:44:26, Vincent Mailhol wrote:
> Current implementation heavily relies on some "if (is_json_context())"
> switches to decide the context and then does some print_*(PRINT_JSON,
> ...) when in json context and some fprintf(...) else.
>=20
> Furthermore, current implementation uses either print_int() or the
> conversion specifier %d to print unsigned integers.
>=20
> This patch factorizes each pairs of print_*(PRINT_JSON, ...) and
> fprintf() into a single print_*(PRINT_ANY, ...) call. While doing this
> replacement, it uses proper unsigned function print_uint() as well as
> the conversion specifier %u when the parameter is an unsigned integer.
>=20
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[...]

>  	if (tb[IFLA_CAN_TERMINATION_CONST] && tb[IFLA_CAN_TERMINATION]) {
> @@ -538,29 +483,21 @@ static void can_print_opt(struct link_util *lu, FIL=
E *f, struct rtattr *tb[])
>  			sizeof(*trm_const);
>  		int i;
> =20
> -		if (is_json_context()) {
> -			print_hu(PRINT_JSON, "termination", NULL, *trm);
> -			open_json_array(PRINT_JSON, "termination_const");
> -			for (i =3D 0; i < trm_cnt; ++i)
> -				print_hu(PRINT_JSON, NULL, NULL, trm_const[i]);
> -			close_json_array(PRINT_JSON, NULL);
> -		} else {
> -			fprintf(f, "\n	  termination %hu [ ", *trm);
> -
> -			for (i =3D 0; i < trm_cnt - 1; ++i)
> -				fprintf(f, "%hu, ", trm_const[i]);
> -
> -			fprintf(f, "%hu ]", trm_const[i]);
                                        ^
> -		}
> +		can_print_nl_indent();
> +		print_hu(PRINT_ANY, "termination", " termination %hu [ ", *trm);

Always '['

> +		open_json_array(PRINT_JSON, "termination_const");
> +		for (i =3D 0; i < trm_cnt; ++i)
> +			print_hu(PRINT_ANY, NULL,
> +				 i < trm_cnt - 1 ? "%hu, " : "%hu",
> +				 trm_const[i]);
> +		close_json_array(PRINT_JSON, " ]");

']' only for JSON.

>  	}

I just noticed that the non JSON output for termination is missing the
closing ']'. See the output in the documentation update by Daniel:

| https://lore.kernel.org/all/4514353.LvFx2qVVIh@daniel6430

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--a6xg66tp3ixk7cut
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmM/2PMACgkQrX5LkNig
01034Af5AVKOyaxYkCGegKQUGgCk5BKGa8M0HJhRZWjoS1PWq5VQB/4tR2he1oH4
Ko2QhicOfPNyh4dlyR+SBR2IFSPZK31kIwGmF9IB2rfYQzwj7hyIgj9NzEOxnXzJ
2oqSj3se3F9wZLSQsk8pO7gFJHjB6B+1z4u0bUiGnr+tmtYceQ/QwEFk3F6wMlYj
faEAur1v/fMcZ/WogjLLJNt8NMdqY1gyYv2kZLKLmbLGOpm56QoxWosBUbgFTliV
OnBl0DANLKm/Lg2JZGA7EOrzB3DkvREaFT73pRqQoWvDMRD2/jmhoO+Z9rIpzC5Z
oph7uhqPz/VkcxsvCtjMJZfv5q/S7A==
=j7Bh
-----END PGP SIGNATURE-----

--a6xg66tp3ixk7cut--
