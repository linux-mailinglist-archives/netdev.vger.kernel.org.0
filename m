Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6609249126
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgHRWqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:46:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:41912 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbgHRWqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 18:46:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EAC57AC1C;
        Tue, 18 Aug 2020 22:46:58 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C18826073E; Wed, 19 Aug 2020 00:46:32 +0200 (CEST)
Date:   Wed, 19 Aug 2020 00:46:32 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net v2 3/3] ethtool: Don't omit the netlink reply if no
 features were changed
Message-ID: <20200818224632.bczm5f6ih5bbhreu@lion.mk-sys.cz>
References: <20200817133407.22687-1-maximmi@mellanox.com>
 <20200817133407.22687-4-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2vwp4cafmdull3zt"
Content-Disposition: inline
In-Reply-To: <20200817133407.22687-4-maximmi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2vwp4cafmdull3zt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 17, 2020 at 04:34:07PM +0300, Maxim Mikityanskiy wrote:
> The legacy ethtool userspace tool shows an error when no features could
> be changed. It's useful to have a netlink reply to be able to show this
> error when __netdev_update_features wasn't called, for example:
>=20
> 1. ethtool -k eth0
>    large-receive-offload: off
> 2. ethtool -K eth0 rx-fcs on
> 3. ethtool -K eth0 lro on
>    Could not change any device features
>    rx-lro: off [requested on]
> 4. ethtool -K eth0 lro on
>    # The output should be the same, but without this patch the kernel
>    # doesn't send the reply, and ethtool is unable to detect the error.
>=20
> This commit makes ethtool-netlink always return a reply when requested,
> and it still avoids unnecessary calls to __netdev_update_features if the
> wanted features haven't changed.
>=20
> Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET requ=
est")
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  net/ethtool/features.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>=20
> diff --git a/net/ethtool/features.c b/net/ethtool/features.c
> index 6b288bfd7678..495635f152ba 100644
> --- a/net/ethtool/features.c
> +++ b/net/ethtool/features.c
> @@ -268,14 +268,11 @@ int ethnl_set_features(struct sk_buff *skb, struct =
genl_info *info)
>  	bitmap_and(req_wanted, req_wanted, req_mask, NETDEV_FEATURE_COUNT);
>  	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
>  	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
> -	if (bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
> -		ret =3D 0;
> -		goto out_rtnl;
> +	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
> +		dev->wanted_features &=3D ~dev->hw_features;
> +		dev->wanted_features |=3D ethnl_bitmap_to_features(req_wanted) & dev->=
hw_features;
> +		__netdev_update_features(dev);
>  	}
> -
> -	dev->wanted_features &=3D ~dev->hw_features;
> -	dev->wanted_features |=3D ethnl_bitmap_to_features(req_wanted) & dev->h=
w_features;
> -	__netdev_update_features(dev);
>  	ethnl_features_to_bitmap(new_active, dev->features);
>  	mod =3D !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);

We could also move these last two lines to the branch where
__netdev_update_features() is actually called and replace them with

	bitmap_copy(new_active, old_active, NETDEV_FEATURE_COUNT);
	mod =3D false;

otherwise. But it's probably not worth complicating the code.

Michal

--2vwp4cafmdull3zt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl88WkMACgkQ538sG/LR
dpU14QgAnwDR+N14rxGbAol5CcEcn4F6OmVYWOcmldhjCtnZtbgHJqjN9Ohqssss
QbknedtM06w52lo7nLb1rNtIqbr2q3LATTLius74pUBDagVe8lFxLQMuqXKjk41O
xPE0cNJIOiu9kUhQ0/dB94c9uTUiA35/JEeENQbd7BHGrVN+iYCzkl5Ore6mXAYz
esK/FlcZd9vdeV6gLmF/hnkdHcxAwt0hQ9keaghO94nS2ZvoyoEwmcpZz9whKw4S
7KNMvTaMxgygy3PpW6D+AloRj5QbhAtg/AM+SVq3wNjuK1d/Nu4nMItkuJvJi82q
fVkyZA+v7vaffT5yyJw8nnfbwYbh+g==
=Iguz
-----END PGP SIGNATURE-----

--2vwp4cafmdull3zt--
