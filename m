Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DB81F0F90
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 22:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgFGUY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 16:24:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:60100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgFGUY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 16:24:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 95E8AAC4A;
        Sun,  7 Jun 2020 20:24:58 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3F05F602EB; Sun,  7 Jun 2020 22:24:52 +0200 (CEST)
Date:   Sun, 7 Jun 2020 22:24:52 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH v2 3/3] netlink: add LINKSTATE SQI support
Message-ID: <20200607202452.md4nnp47cfjetylp@lion.mk-sys.cz>
References: <20200528115414.11516-1-o.rempel@pengutronix.de>
 <20200528115414.11516-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6rexytvx3x3wksna"
Content-Disposition: inline
In-Reply-To: <20200528115414.11516-4-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6rexytvx3x3wksna
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2020 at 01:54:14PM +0200, Oleksij Rempel wrote:
> Some PHYs provide Signal Quality Index (SQI) if the link is in active
> state. This information can help to diagnose cable and system design
> related issues.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  netlink/desc-ethtool.c |  2 ++
>  netlink/settings.c     | 16 ++++++++++++++++
>  2 files changed, 18 insertions(+)
>=20
> diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
> index b0a793c..8f4c36b 100644
> --- a/netlink/desc-ethtool.c
> +++ b/netlink/desc-ethtool.c
> @@ -93,6 +93,8 @@ static const struct pretty_nla_desc __linkstate_desc[] =
=3D {
>  	NLATTR_DESC_INVALID(ETHTOOL_A_LINKSTATE_UNSPEC),
>  	NLATTR_DESC_NESTED(ETHTOOL_A_LINKSTATE_HEADER, header),
>  	NLATTR_DESC_BOOL(ETHTOOL_A_LINKSTATE_LINK),
> +	NLATTR_DESC_U32(ETHTOOL_A_LINKSTATE_SQI),
> +	NLATTR_DESC_U32(ETHTOOL_A_LINKSTATE_SQI_MAX),
>  };
> =20
>  static const struct pretty_nla_desc __debug_desc[] =3D {
> diff --git a/netlink/settings.c b/netlink/settings.c
> index 851de15..cd4b9a7 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -638,6 +638,22 @@ int linkstate_reply_cb(const struct nlmsghdr *nlhdr,=
 void *data)
>  		printf("\tLink detected: %s\n", val ? "yes" : "no");
>  	}
> =20
> +	if (tb[ETHTOOL_A_LINKSTATE_SQI]) {
> +		uint32_t val =3D mnl_attr_get_u32(tb[ETHTOOL_A_LINKSTATE_SQI]);
> +
> +		print_banner(nlctx);
> +		printf("\tSQI: %u", val);
> +
> +		if (tb[ETHTOOL_A_LINKSTATE_SQI_MAX]) {
> +			uint32_t max;
> +
> +			max =3D mnl_attr_get_u32(tb[ETHTOOL_A_LINKSTATE_SQI_MAX]);
> +			printf("/%u\n", max);
> +		} else {
> +			printf("\n");
> +		}
> +	}
> +
>  	return MNL_CB_OK;
>  }
> =20
> --=20
> 2.26.2
>=20

--6rexytvx3x3wksna
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl7dTRQACgkQ538sG/LR
dpXMcgf/aGnDZaDpaT7K8y35E0CVbPgFarkAgkDcEFirAQpugKWj/EUo93DXoMor
5q5vy72IpW4R2tZvGYDQ42hltd2n2Y1vOFs13ElgUTqfk7UGUFpBzKXfuLCGY1yN
rd+BWgWTK02dSqHyF7Vb+2FVfxNfo27n21btYa7iCMAxFWyDm6xrbONPP/lcu/+O
8wRmAG+51q4rbc9pETQ1KwQc9EZ58hQglXPeUQzzQR+aiCVSP7gud6IXiUOVhmah
w/MWl8SRIU1sOjwTkXQha5TDXDq7KxG8Gc4YdmtNQFjW8wz3+msVfjNeeCtFK14u
GVB1itG2veq/GAEcSN4X5imlvEFkFA==
=Qh5H
-----END PGP SIGNATURE-----

--6rexytvx3x3wksna--
