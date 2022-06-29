Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1735600AC
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiF2NCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiF2NCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:02:04 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7A03B570;
        Wed, 29 Jun 2022 06:02:02 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 738661C0BCB; Wed, 29 Jun 2022 15:02:01 +0200 (CEST)
Date:   Wed, 29 Jun 2022 15:02:01 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, llvm@lists.linux.dev,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, jiri@nvidia.com,
        leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 30/34] hinic: Replace memcpy() with direct
 assignment
Message-ID: <20220629130201.GB13395@duo.ucw.cz>
References: <20220628022241.595835-1-sashal@kernel.org>
 <20220628022241.595835-30-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <20220628022241.595835-30-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Kees Cook <keescook@chromium.org>
>=20
> [ Upstream commit 1e70212e031528918066a631c9fdccda93a1ffaa ]
>=20
> Under CONFIG_FORTIFY_SOURCE=3Dy and CONFIG_UBSAN_BOUNDS=3Dy, Clang is bug=
ged
> here for calculating the size of the destination buffer (0x10 instead of
> 0x14). This copy is a fixed size (sizeof(struct fw_section_info_st)), with
> the source and dest being struct fw_section_info_st, so the memcpy should
> be safe, assuming the index is within bounds, which is UBSAN_BOUNDS's
> responsibility to figure out.
>=20
> Avoid the whole thing and just do a direct assignment. This results in
> no change to the executable code.

This is just a workaround for Clang bug uncovered by 281d0c962752
("fortify: Add Clang support"), and we don't have that in 5.10-stable.

Please drop.

Best regards,
								Pavel
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> @@ -43,9 +43,7 @@ static bool check_image_valid(struct hinic_devlink_priv=
 *priv, const u8 *buf,
> =20
>  	for (i =3D 0; i < fw_image->fw_info.fw_section_cnt; i++) {
>  		len +=3D fw_image->fw_section_info[i].fw_section_len;
> -		memcpy(&host_image->image_section_info[i],
> -		       &fw_image->fw_section_info[i],
> -		       sizeof(struct fw_section_info_st));
> +		host_image->image_section_info[i] =3D fw_image->fw_section_info[i];
>  	}
> =20
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYrxNSQAKCRAw5/Bqldv6
8hZBAKC61OU6j3kK9YHOuyC/wk2g70z80gCgkFZtqUnAGb/6paDKaij40KGND+8=
=w4BR
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
