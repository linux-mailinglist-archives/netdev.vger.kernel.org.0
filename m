Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A80424909F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgHRWQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:16:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:33070 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgHRWQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 18:16:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 68396ABF4;
        Tue, 18 Aug 2020 22:16:25 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 113EB6073E; Wed, 19 Aug 2020 00:15:59 +0200 (CEST)
Date:   Wed, 19 Aug 2020 00:15:59 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] ethtool: Fix preserving of wanted feature
 bits in netlink interface
Message-ID: <20200818221559.2iyoukyo5jlkkd4p@lion.mk-sys.cz>
References: <20200817133407.22687-1-maximmi@mellanox.com>
 <20200817133407.22687-2-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="szfacdwtkgc3xld6"
Content-Disposition: inline
In-Reply-To: <20200817133407.22687-2-maximmi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--szfacdwtkgc3xld6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 17, 2020 at 04:34:05PM +0300, Maxim Mikityanskiy wrote:
> Currently, ethtool-netlink calculates new wanted bits as:
> (req_wanted & req_mask) | (old_active & ~req_mask)
>=20
> It completely discards the old wanted bits, so they are forgotten with
> the next ethtool command. Sample steps to reproduce:
>=20
> 1. ethtool -k eth0
>    tx-tcp-segmentation: on # TSO is on from the beginning
> 2. ethtool -K eth0 tx off
>    tx-tcp-segmentation: off [not requested]
> 3. ethtool -k eth0
>    tx-tcp-segmentation: off [requested on]
> 4. ethtool -K eth0 rx off # Some change unrelated to TSO
> 5. ethtool -k eth0
>    tx-tcp-segmentation: off # "Wanted on" is forgotten
>=20
> This commit fixes it by changing the formula to:
> (req_wanted & req_mask) | (old_wanted & ~req_mask),
> where old_active was replaced by old_wanted to account for the wanted
> bits.
>=20
> The shortcut condition for the case where nothing was changed now
> compares wanted bitmasks, instead of wanted to active.
>=20
> Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET requ=
est")
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> ---

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

>  net/ethtool/features.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/ethtool/features.c b/net/ethtool/features.c
> index 4e632dc987d8..ec196f0fddc9 100644
> --- a/net/ethtool/features.c
> +++ b/net/ethtool/features.c
> @@ -224,7 +224,9 @@ int ethnl_set_features(struct sk_buff *skb, struct ge=
nl_info *info)
>  	DECLARE_BITMAP(wanted_diff_mask, NETDEV_FEATURE_COUNT);
>  	DECLARE_BITMAP(active_diff_mask, NETDEV_FEATURE_COUNT);
>  	DECLARE_BITMAP(old_active, NETDEV_FEATURE_COUNT);
> +	DECLARE_BITMAP(old_wanted, NETDEV_FEATURE_COUNT);
>  	DECLARE_BITMAP(new_active, NETDEV_FEATURE_COUNT);
> +	DECLARE_BITMAP(new_wanted, NETDEV_FEATURE_COUNT);
>  	DECLARE_BITMAP(req_wanted, NETDEV_FEATURE_COUNT);
>  	DECLARE_BITMAP(req_mask, NETDEV_FEATURE_COUNT);
>  	struct nlattr *tb[ETHTOOL_A_FEATURES_MAX + 1];
> @@ -250,6 +252,7 @@ int ethnl_set_features(struct sk_buff *skb, struct ge=
nl_info *info)
> =20
>  	rtnl_lock();
>  	ethnl_features_to_bitmap(old_active, dev->features);
> +	ethnl_features_to_bitmap(old_wanted, dev->wanted_features);
>  	ret =3D ethnl_parse_bitset(req_wanted, req_mask, NETDEV_FEATURE_COUNT,
>  				 tb[ETHTOOL_A_FEATURES_WANTED],
>  				 netdev_features_strings, info->extack);
> @@ -261,11 +264,11 @@ int ethnl_set_features(struct sk_buff *skb, struct =
genl_info *info)
>  		goto out_rtnl;
>  	}
> =20
> -	/* set req_wanted bits not in req_mask from old_active */
> +	/* set req_wanted bits not in req_mask from old_wanted */
>  	bitmap_and(req_wanted, req_wanted, req_mask, NETDEV_FEATURE_COUNT);
> -	bitmap_andnot(new_active, old_active, req_mask, NETDEV_FEATURE_COUNT);
> -	bitmap_or(req_wanted, new_active, req_wanted, NETDEV_FEATURE_COUNT);
> -	if (bitmap_equal(req_wanted, old_active, NETDEV_FEATURE_COUNT)) {
> +	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
> +	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
> +	if (bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
>  		ret =3D 0;
>  		goto out_rtnl;
>  	}
> --=20
> 2.25.1
>=20

--szfacdwtkgc3xld6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl88UxkACgkQ538sG/LR
dpVeBwf/YQWSPfEOXxqXLQAVL4vBXOL2fcuof9CKKw6yvUyKsEPqQZxBTVCVYc9e
gDM21ucD/tgvAFZNln2vxk8e1/nd3Ezpzs2mdXsKyjrRlu4Ro5XfKBH9+LCTVBzX
g5f5/rKbj5UG8fbGUEUv+laiSrHaZunt8Y+3FyEuye+HI7eyUhKXxSBUhtpsDQc5
8YyLhB1e0Y5qZJ3KPUVLHYP6JEz2tcZny22gxXeDLEqKGn73k5X12UdCyCaHUQE/
r9cQjZBikZHMSuYZtDcZX7L8+IIG42qgsxhTT4ORRwxofzy/9ohWQbG7biNhCGfd
sE7ARx38X7JSANtZnaFSYYf++qjx0A==
=//5R
-----END PGP SIGNATURE-----

--szfacdwtkgc3xld6--
