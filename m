Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5279827B11B
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgI1Po5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 11:44:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:38526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgI1Po5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 11:44:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7A477AD5F;
        Mon, 28 Sep 2020 15:44:55 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3EC23603A9; Mon, 28 Sep 2020 17:44:55 +0200 (CEST)
Date:   Mon, 28 Sep 2020 17:44:55 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 1/2] netlink: return -ENOMEM when calloc fails
Message-ID: <20200928154455.hi6767brao7p4ac5@lion.mk-sys.cz>
References: <20200924192758.577595-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wtmlx5ccf5jdqeqe"
Content-Disposition: inline
In-Reply-To: <20200924192758.577595-1-ivecera@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wtmlx5ccf5jdqeqe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2020 at 09:27:57PM +0200, Ivan Vecera wrote:
> Fixes: f2c17e107900 ("netlink: add netlink handler for gfeatures (-k)")
>=20
> Cc: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  netlink/features.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/netlink/features.c b/netlink/features.c
> index 3f1240437350..b2cf57eea660 100644
> --- a/netlink/features.c
> +++ b/netlink/features.c
> @@ -112,16 +112,17 @@ int dump_features(const struct nlattr *const *tb,
>  	unsigned int *feature_flags =3D NULL;
>  	struct feature_results results;
>  	unsigned int i, j;
> -	int ret;
> +	int ret =3D 0;
> =20
>  	ret =3D prepare_feature_results(tb, &results);
>  	if (ret < 0)
>  		return -EFAULT;
> =20
> -	ret =3D -ENOMEM;
>  	feature_flags =3D calloc(results.count, sizeof(feature_flags[0]));
> -	if (!feature_flags)
> +	if (!feature_flags) {
> +		ret =3D -ENOMEM;
>  		goto out_free;
> +	}
> =20
>  	/* map netdev features to legacy flags */
>  	for (i =3D 0; i < results.count; i++) {
> @@ -184,7 +185,7 @@ int dump_features(const struct nlattr *const *tb,
> =20
>  out_free:
>  	free(feature_flags);
> -	return 0;
> +	return ret;
>  }
> =20
>  int features_reply_cb(const struct nlmsghdr *nlhdr, void *data)
> --=20
> 2.26.2

The patch is correct but relying on ret staying zero through the whole
function is rather fragile (it could break when adding more checks in
the future) and it also isn't consistent with the way this is done in
other functions.

AFAICS you could omit the first hunk and just add "ret =3D 0" above the
out_free label.

Michal

--wtmlx5ccf5jdqeqe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9yBPIACgkQ538sG/LR
dpWjRggAoNQ8OSBbHcTW/hAPe+NQxuSwlpCXXHNZT1bKMl/P6SevINusMAYy+CQC
M1w4DXbeTutyJvntvFy/Ianw3KYpyl+wmkk5gUvHjT+GkTTabkRFpgU9G6wVHggO
9erElxXsuHQMDVPMgsKNwjbOnuAjUDFoWXhxSR93Sh40dqPatRJ5Ab0uApLGFtkv
zKA5gJrXk9IBceELYKgsXrd3oxVKsltz8xAYrq4d84va/Nt9oYDYXw568fwbHzYN
/gRdEWW/9KrOe1T5KJ5FaUIdjEQiu4PTCjiBNVFOu7KundwLwQ99hMFAfOzn8Txg
0T7IPKvexPHzERFhgiYqmPz7JyCAMw==
=pBTp
-----END PGP SIGNATURE-----

--wtmlx5ccf5jdqeqe--
