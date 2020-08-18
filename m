Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC592490BE
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgHRWZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:25:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:35238 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbgHRWZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 18:25:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 36FCCAC48;
        Tue, 18 Aug 2020 22:26:00 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 0AC5B6073E; Wed, 19 Aug 2020 00:25:34 +0200 (CEST)
Date:   Wed, 19 Aug 2020 00:25:34 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net v2 2/3] ethtool: Account for hw_features in netlink
 interface
Message-ID: <20200818222534.7ojntjmryqjtv2in@lion.mk-sys.cz>
References: <20200817133407.22687-1-maximmi@mellanox.com>
 <20200817133407.22687-3-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u3nnx2sfua2hcypk"
Content-Disposition: inline
In-Reply-To: <20200817133407.22687-3-maximmi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--u3nnx2sfua2hcypk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 17, 2020 at 04:34:06PM +0300, Maxim Mikityanskiy wrote:
> ethtool-netlink ignores dev->hw_features and may confuse the drivers by
> asking them to enable features not in the hw_features bitmask. For
> example:
>=20
> 1. ethtool -k eth0
>    tls-hw-tx-offload: off [fixed]
> 2. ethtool -K eth0 tls-hw-tx-offload on
>    tls-hw-tx-offload: on
> 3. ethtool -k eth0
>    tls-hw-tx-offload: on [fixed]
>=20
> Fitler out dev->hw_features from req_wanted to fix it and to resemble
> the legacy ethtool behavior.
>=20
> Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET requ=
est")
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  net/ethtool/features.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/ethtool/features.c b/net/ethtool/features.c
> index ec196f0fddc9..6b288bfd7678 100644
> --- a/net/ethtool/features.c
> +++ b/net/ethtool/features.c
> @@ -273,7 +273,8 @@ int ethnl_set_features(struct sk_buff *skb, struct ge=
nl_info *info)
>  		goto out_rtnl;
>  	}
> =20
> -	dev->wanted_features =3D ethnl_bitmap_to_features(req_wanted);
> +	dev->wanted_features &=3D ~dev->hw_features;
> +	dev->wanted_features |=3D ethnl_bitmap_to_features(req_wanted) & dev->h=
w_features;
>  	__netdev_update_features(dev);
>  	ethnl_features_to_bitmap(new_active, dev->features);
>  	mod =3D !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);
> --=20
> 2.25.1
>=20

--u3nnx2sfua2hcypk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl88VVgACgkQ538sG/LR
dpWS5ggAzJPJQuVMXXRB5txH0RmfBj5Y+ZtrzMPtHwuDvpaFwXdSUTLXfnoegjia
riIyqAl4b3/3r1MMVlCRXEF/zMdt2aBuF9Nd4cffjIVp4h1w2QpZxLpwu3h6LgS9
ZTzkn/942DvKdGGkgvOWu34sSp1cvyFf+xP5FahpCYEibiF/m5QM2wbFVIA0Qex+
/JEegW+hO6nH+Ibg4rMI6Xp7Cwl9iM5UgQ6Caib0HGHFiIWou8DNLbxYAkalpQUq
g4pecxvoyrYy9WOgr2jMAhiRe38kNnTvJLRfRPoVrTZvTsyQNncxYVuVs/UwK8d8
g8EaG+Yaf+MB008lkjISfbxUhF1J1A==
=JiI6
-----END PGP SIGNATURE-----

--u3nnx2sfua2hcypk--
