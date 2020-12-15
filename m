Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19D22DAA9F
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 11:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgLOKKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 05:10:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:59016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgLOKKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 05:10:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 287B3AC7F;
        Tue, 15 Dec 2020 10:09:22 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E37C46030D; Tue, 15 Dec 2020 11:09:21 +0100 (CET)
Date:   Tue, 15 Dec 2020 11:09:21 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, LiLiang <liali@redhat.com>
Subject: Re: [PATCH net] ethtool: fix error paths in ethnl_set_channels()
Message-ID: <20201215100921.3qnmqdbhxpniejnw@lion.mk-sys.cz>
References: <20201215090810.801777-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fodxcffs36niqcl3"
Content-Disposition: inline
In-Reply-To: <20201215090810.801777-1-ivecera@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fodxcffs36niqcl3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 15, 2020 at 10:08:10AM +0100, Ivan Vecera wrote:
> Fix two error paths in ethnl_set_channels() to avoid lock-up caused
> but unreleased RTNL.
>=20
> Fixes: e19c591eafad ("ethtool: set device channel counts with CHANNELS_SE=
T request")
> Cc: Michal Kubecek <mkubecek@suse.cz>
> Reported-by: LiLiang <liali@redhat.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  net/ethtool/channels.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
> index 5635604cb9ba..25a9e566ef5c 100644
> --- a/net/ethtool/channels.c
> +++ b/net/ethtool/channels.c
> @@ -194,8 +194,9 @@ int ethnl_set_channels(struct sk_buff *skb, struct ge=
nl_info *info)
>  	if (netif_is_rxfh_configured(dev) &&
>  	    !ethtool_get_max_rxfh_channel(dev, &max_rx_in_use) &&
>  	    (channels.combined_count + channels.rx_count) <=3D max_rx_in_use) {
> +		ret =3D -EINVAL;
>  		GENL_SET_ERR_MSG(info, "requested channel counts are too low for exist=
ing indirection table settings");
> -		return -EINVAL;
> +		goto out_ops;
>  	}
> =20
>  	/* Disabling channels, query zero-copy AF_XDP sockets */
> @@ -203,8 +204,9 @@ int ethnl_set_channels(struct sk_buff *skb, struct ge=
nl_info *info)
>  		       min(channels.rx_count, channels.tx_count);
>  	for (i =3D from_channel; i < old_total; i++)
>  		if (xsk_get_pool_from_qid(dev, i)) {
> +			ret =3D -EINVAL;
>  			GENL_SET_ERR_MSG(info, "requested channel counts are too low for exis=
ting zerocopy AF_XDP sockets");
> -			return -EINVAL;
> +			goto out_ops;
>  		}
> =20
>  	ret =3D dev->ethtool_ops->set_channels(dev, &channels);

Oh, the joys of mindless copy and paste... :-(

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

--fodxcffs36niqcl3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl/Yi0wACgkQ538sG/LR
dpXjzgf+N5rEb4zXwJkH5j9V/SLMzYuVSGurLW/pgXOIZlXp36DZNoF89ObHv7Nh
34VD1v8bLdJ4fidvy0zY/bgYesVxGRQ9dh1CNq0BIbZajZpEZLPus6c0ABCmPFym
pEDPBuKAwwgiHlcA+RRsU/w76imXLzuCC8CE7ETNZodXWlLQ6XBHp0q35NCpCOzv
m/TZgeNqB0p33c4/Zn6ml7v13hCZdnuoQ3kFw7WDZZsLDxlCZ9tJyCv1XdAbROAS
a0UWiBzHC+SEnbH0x7XCU8U2cP199UFdK7rCoRxtD9g9RXGdptVB966kp63y9L3i
bM4cVihXqZyC6T+ne32unFplgKW/xg==
=WCro
-----END PGP SIGNATURE-----

--fodxcffs36niqcl3--
