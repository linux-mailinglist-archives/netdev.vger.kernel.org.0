Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5733C65E5
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 00:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhGLWGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 18:06:34 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47198 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhGLWGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 18:06:33 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 97E481C0B7C; Tue, 13 Jul 2021 00:03:43 +0200 (CEST)
Date:   Tue, 13 Jul 2021 00:03:43 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Carl Philipp Klemm <philipp@uvos.xyz>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 082/137] wlcore/wl12xx: Fix wl12xx get_mac
 error if device is in ELP
Message-ID: <20210712220343.GA9766@amd>
References: <20210706112203.2062605-1-sashal@kernel.org>
 <20210706112203.2062605-82-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20210706112203.2062605-82-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Tony Lindgren <tony@atomide.com>
>=20
> [ Upstream commit 11ef6bc846dcdce838f0b00c5f6a562c57e5d43b ]
>=20
> At least on wl12xx, reading the MAC after boot can fail with a warning
> at drivers/net/wireless/ti/wlcore/sdio.c:78 wl12xx_sdio_raw_read.
> The failed call comes from wl12xx_get_mac() that wlcore_nvs_cb() calls
> after request_firmware_work_func().

> +++ b/drivers/net/wireless/ti/wl12xx/main.c
> @@ -1503,6 +1503,13 @@ static int wl12xx_get_fuse_mac(struct wl1271 *wl)
>  	u32 mac1, mac2;
>  	int ret;
> =20
> +	/* Device may be in ELP from the bootloader or kexec */
> +	ret =3D wlcore_write32(wl, WL12XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VA=
L);
> +	if (ret < 0)
> +		goto out;
> +
> +	usleep_range(500000, 700000);
> +

While this probably improves things.... I don't believe delaying boot
by extra 200msec is good idea. This should simply be msleep(500),
AFAICT.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDsvD8ACgkQMOfwapXb+vJPiwCgiYvjMnNc1w8GNzQG94q0TJtI
QmEAmgNMcJxKnmRmIegdv7JldHsIwxpq
=Uehq
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
