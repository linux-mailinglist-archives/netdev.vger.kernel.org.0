Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D290224EE0C
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 18:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHWQDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 12:03:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:36382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgHWQDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 12:03:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0BF81AB3E;
        Sun, 23 Aug 2020 16:03:50 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 7CF426030D; Sun, 23 Aug 2020 18:03:20 +0200 (CEST)
Date:   Sun, 23 Aug 2020 18:03:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 2/2] netlink: Print and return an error when
 features weren't changed
Message-ID: <20200823160320.onkv4kqgye7u6b2c@lion.mk-sys.cz>
References: <20200814131745.32215-1-maximmi@mellanox.com>
 <20200814131745.32215-3-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ewf662okiwmsuvqa"
Content-Disposition: inline
In-Reply-To: <20200814131745.32215-3-maximmi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ewf662okiwmsuvqa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2020 at 04:17:45PM +0300, Maxim Mikityanskiy wrote:
> The legacy ethtool prints an error message and returns 1 if no features
> were changed as requested. Port this behavior to ethtool-netlink.
> req_mask is compared to wanted_mask to detect if any feature was
> changed. If these masks are equal, it means that the kernel hasn't
> changed anything, and all bits got to wanted.
>=20
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> ---
>  netlink/features.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>=20
> diff --git a/netlink/features.c b/netlink/features.c
> index 133529d..4f63fa2 100644
> --- a/netlink/features.c
> +++ b/netlink/features.c
[...]
> @@ -471,8 +480,10 @@ int sfeatures_reply_cb(const struct nlmsghdr *nlhdr,=
 void *data)
>  		return MNL_CB_OK;
>  	}
> =20
> -	show_feature_changes(nlctx, tb);
> -	return MNL_CB_OK;
> +	if (show_feature_changes(nlctx, tb))
> +		return MNL_CB_OK;
> +	else
> +		return MNL_CB_ERROR;

I agree with the general change and the code aboved detecting the
condition but this kind of error is IMHO not so critical that it would
justify bailing out and completely ignoring the final NLMSG_ERROR with
kernel return code and possible extack (error/warning message).

I would rather suggest to set a flag (e.g. in sfctx) when "no requested
change performed" result is detected and leave displaying the error
message and setting the exit code after the whole message queue is
processed. What do you think?

Michal

>  }
> =20
>  int nl_sfeatures(struct cmd_context *ctx)
> --=20
> 2.21.0
>=20

--ewf662okiwmsuvqa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9Ck0MACgkQ538sG/LR
dpWTigf/TIfZ+JTdubGAqa8VuVlgoMW6TGhrBlr1BSwoSvrSIWQE/meB5Vk/I69U
EXwGcMSrNUKU6bX2XGTpRbr2ecECMy7FF1MeLShew+mzo0n+OKKLYK6GuNxt8fJ8
fwon3HwLaJDbYCZchXudnpSRb4pdweCy15ZD4Fjh0jLR3W2lNzg9ckYEOKlLp7Zc
eWF5pGjSO4n26jCqXpiCuMkx2rrNHiQKGerHCVqn6EuWjISxTP3PAnLW4VrIaqIU
EBs5+lmPPifSyKMsDtrwfFSX7wRo7ZCYLDJqAT9YLYYq91BvfxuNaee/CfX7+fAi
2ZAMY9lf5boT/v0sqle63+wjJSli3g==
=/yZM
-----END PGP SIGNATURE-----

--ewf662okiwmsuvqa--
