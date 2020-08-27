Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EB225415E
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 11:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgH0JAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 05:00:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:42496 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgH0JAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 05:00:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3538FAD29;
        Thu, 27 Aug 2020 09:01:15 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E40C8603FB; Thu, 27 Aug 2020 11:00:42 +0200 (CEST)
Date:   Thu, 27 Aug 2020 11:00:42 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2] netlink: Print and return an error when
 features weren't changed
Message-ID: <20200827090042.jgwp6q6bo7zdnew7@lion.mk-sys.cz>
References: <20200825081138.10855-1-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gzohhcrt3heapi2j"
Content-Disposition: inline
In-Reply-To: <20200825081138.10855-1-maximmi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gzohhcrt3heapi2j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2020 at 11:11:38AM +0300, Maxim Mikityanskiy wrote:
> The legacy ethtool prints an error message and returns 1 if no features
> were changed as requested. Port this behavior to ethtool-netlink.
> req_mask is compared to wanted_mask to detect if any feature was
> changed. If these masks are equal, it means that the kernel hasn't
> changed anything, and all bits got to wanted.
>=20
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Applied, thank you.

Michal

> ---
>  netlink/features.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/netlink/features.c b/netlink/features.c
> index 133529d..7622594 100644
> --- a/netlink/features.c
> +++ b/netlink/features.c
> @@ -243,6 +243,7 @@ int nl_gfeatures(struct cmd_context *ctx)
>  /* FEATURES_SET */
> =20
>  struct sfeatures_context {
> +	bool			nothing_changed;
>  	uint32_t		req_mask[0];
>  };
> =20
> @@ -411,10 +412,14 @@ static void show_feature_changes(struct nl_context =
*nlctx,
>  	if (!wanted_val || !wanted_mask || !active_val || !active_mask)
>  		goto err;
> =20
> +	sfctx->nothing_changed =3D true;
>  	diff =3D false;
> -	for (i =3D 0; i < words; i++)
> +	for (i =3D 0; i < words; i++) {
> +		if (wanted_mask[i] !=3D sfctx->req_mask[i])
> +			sfctx->nothing_changed =3D false;
>  		if (wanted_mask[i] || (active_mask[i] & ~sfctx->req_mask[i]))
>  			diff =3D true;
> +	}
>  	if (!diff)
>  		return;
> =20
> @@ -520,6 +525,10 @@ int nl_sfeatures(struct cmd_context *ctx)
>  	if (ret < 0)
>  		return 92;
>  	ret =3D nlsock_process_reply(nlsk, sfeatures_reply_cb, nlctx);
> +	if (sfctx->nothing_changed) {
> +		fprintf(stderr, "Could not change any device features\n");
> +		return nlctx->exit_code ?: 1;
> +	}
>  	if (ret =3D=3D 0)
>  		return 0;
>  	return nlctx->exit_code ?: 92;
> --=20
> 2.20.1
>=20

--gzohhcrt3heapi2j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9HdjUACgkQ538sG/LR
dpXwmQgAsM9/lMcEf9uFiGhMWCc2vOWnk//AUnJM2BYJcCmcJ1V9/jCOV690IUlV
HWUfPxqJkQ7r9dbo6G/qJRTJyhq6BG/yZ4lIUO5YtAp7scYAE2lqwbaYjm/nbw1l
R4/NjmfKRgNwPasKueaoRdTebf8kLEpyESgJQWTG+u0u3u5x/tXIrIPQc6k7rZAg
NMdWVaY5CyPF/QRAi/HlNPJq7s5mP6Ehza6C91DzLi9DtRG9W8ty4x2SCiO2SdTT
+On9fTj1U+bAkXdlzyVN8rCmq/MJMIQyAsmLUbgPg+dnTJwzdwGsWMiKsmNcaleG
2iEiuRIJxk5wISG52N5hgDDzOlTvSw==
=S9KP
-----END PGP SIGNATURE-----

--gzohhcrt3heapi2j--
