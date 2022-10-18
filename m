Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D43C602885
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiJRJjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiJRJjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:39:32 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA29FB;
        Tue, 18 Oct 2022 02:39:24 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7B0FE1C09D9; Tue, 18 Oct 2022 11:39:22 +0200 (CEST)
Date:   Tue, 18 Oct 2022 11:39:21 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, tony0620emma@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 01/34] wifi: rtw88: phy: fix warning of
 possible buffer overflow
Message-ID: <20221018093921.GD1264@duo.ucw.cz>
References: <20221009222129.1218277-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Content-Disposition: inline
In-Reply-To: <20221009222129.1218277-1-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 86331c7e0cd819bf0c1d0dcf895e0c90b0aa9a6f ]
>=20
> reported by smatch
>=20
> phy.c:854 rtw_phy_linear_2_db() error: buffer overflow 'db_invert_table[i=
]'
> 8 <=3D 8 (assuming for loop doesn't break)
>=20
> However, it seems to be a false alarm because we prevent it originally via
>        if (linear >=3D db_invert_table[11][7])
>                return 96; /* maximum 96 dB */
>=20
> Still, we adjust the code to be more readable and avoid smatch warning.

There's no bug, it is just smatch that is confused. We should not take
this to 5.10.

Best regards,
									Pavel

>  drivers/net/wireless/realtek/rtw88/phy.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wirel=
ess/realtek/rtw88/phy.c
> index af8b703d11d4..0fc5a893c395 100644
> --- a/drivers/net/wireless/realtek/rtw88/phy.c
> +++ b/drivers/net/wireless/realtek/rtw88/phy.c
> @@ -604,23 +604,18 @@ static u8 rtw_phy_linear_2_db(u64 linear)
>  	u8 j;
>  	u32 dB;
> =20
> -	if (linear >=3D db_invert_table[11][7])
> -		return 96; /* maximum 96 dB */
> -
>  	for (i =3D 0; i < 12; i++) {
> -		if (i <=3D 2 && (linear << FRAC_BITS) <=3D db_invert_table[i][7])
> -			break;
> -		else if (i > 2 && linear <=3D db_invert_table[i][7])
> -			break;
> +		for (j =3D 0; j < 8; j++) {
> +			if (i <=3D 2 && (linear << FRAC_BITS) <=3D db_invert_table[i][j])
> +				goto cnt;
> +			else if (i > 2 && linear <=3D db_invert_table[i][j])
> +				goto cnt;
> +		}
>  	}
> =20
> -	for (j =3D 0; j < 8; j++) {
> -		if (i <=3D 2 && (linear << FRAC_BITS) <=3D db_invert_table[i][j])
> -			break;
> -		else if (i > 2 && linear <=3D db_invert_table[i][j])
> -			break;
> -	}
> +	return 96; /* maximum 96 dB */
> =20
> +cnt:
>  	if (j =3D=3D 0 && i =3D=3D 0)
>  		goto end;
> =20
> --=20
> 2.35.1

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY050SQAKCRAw5/Bqldv6
8lrCAKCqLZ4CYw9fH/ZQp/IlGS8zEkWo8wCeKeb2tTImRaifOr2l700RqY9l7y4=
=lnek
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--
