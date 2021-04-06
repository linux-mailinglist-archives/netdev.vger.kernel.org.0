Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D957B355C0C
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 21:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239254AbhDFTOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 15:14:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:46246 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231701AbhDFTN6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 15:13:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 877B1B322;
        Tue,  6 Apr 2021 19:13:49 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 24EC060441; Tue,  6 Apr 2021 21:13:49 +0200 (CEST)
Date:   Tue, 6 Apr 2021 21:13:49 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v1 1/1] ethtool: fix incorrect datatype in set_eee ops
Message-ID: <20210406191349.zunf27ijfp7hoq33@lion.mk-sys.cz>
References: <20210406131730.25404-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6w7l2v7wakksdekp"
Content-Disposition: inline
In-Reply-To: <20210406131730.25404-1-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6w7l2v7wakksdekp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 06, 2021 at 09:17:30PM +0800, Wong Vee Khee wrote:
> The member 'tx_lpi_timer' is defined with __u32 datatype in the ethtool
> header file. Hence, we should use ethnl_update_u32() in set_eee ops.

To be precise, the correct reason is that unlike .eee_enabled and
=2Etx_lpi_enabled, .tx_lpi_timer value is interpreted as a number, not
a logical value (those two are also __u32). But I don't think it's
necessary to resubmit.

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> Fixes: fd77be7bd43c ("ethtool: set EEE settings with EEE_SET request")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---
>  net/ethtool/eee.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
> index 901b7de941ab..e10bfcc07853 100644
> --- a/net/ethtool/eee.c
> +++ b/net/ethtool/eee.c
> @@ -169,8 +169,8 @@ int ethnl_set_eee(struct sk_buff *skb, struct genl_in=
fo *info)
>  	ethnl_update_bool32(&eee.eee_enabled, tb[ETHTOOL_A_EEE_ENABLED], &mod);
>  	ethnl_update_bool32(&eee.tx_lpi_enabled,
>  			    tb[ETHTOOL_A_EEE_TX_LPI_ENABLED], &mod);
> -	ethnl_update_bool32(&eee.tx_lpi_timer, tb[ETHTOOL_A_EEE_TX_LPI_TIMER],
> -			    &mod);
> +	ethnl_update_u32(&eee.tx_lpi_timer, tb[ETHTOOL_A_EEE_TX_LPI_TIMER],
> +			 &mod);
>  	ret =3D 0;
>  	if (!mod)
>  		goto out_ops;
> --=20
> 2.25.1
>=20

--6w7l2v7wakksdekp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmBssucACgkQ538sG/LR
dpXYfwf/SCDVSaRSk5DvmwdjfFv0Gx5nwwa1jYT3hiuhBsVbksV8+k2yfBnFttFn
bFoDVpFO1JdhncO6+a9X72NMDhA3TptYEk/ybYYurSYu9zn4ueHqBkhbAIEgJQtt
xFoNxO1P2sjZcJsXvCb6oPtYlmm5+emwz3MQhCXZUrn10507vbjxO0Ymtex8vBBZ
P9o/ZGSRxKQpRx1aCwaYNN1ZxQfR+ve9Frj7oTGAC3UZpS9eNdGX6DEOglO0wUah
NWCxBK5rZlj1zEhlvKPTHtAG574fh/5QUJM5q4KOVbYBqOqj+cLpQneXMzZarcW8
boutAigFcwKiWDG49xK48joljd+ABg==
=Pa/l
-----END PGP SIGNATURE-----

--6w7l2v7wakksdekp--
