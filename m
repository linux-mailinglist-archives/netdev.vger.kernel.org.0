Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028C824C64B
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 21:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgHTTec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 15:34:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:45598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgHTTeb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 15:34:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6EE0BAC4C;
        Thu, 20 Aug 2020 19:34:56 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A05366073E; Thu, 20 Aug 2020 21:34:26 +0200 (CEST)
Date:   Thu, 20 Aug 2020 21:34:26 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Vishal Kulkarni <vishal@chelsio.com>, davem@davemloft.net,
        rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net-next] ethtool: allow flow-type ether without IP
 protocol field
Message-ID: <20200820193426.f2k3kw7t6t66ehvj@lion.mk-sys.cz>
References: <20200818185503.664-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="si3pbal6jvwa2r4l"
Content-Disposition: inline
In-Reply-To: <20200818185503.664-1-vishal@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--si3pbal6jvwa2r4l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2020 at 12:25:03AM +0530, Vishal Kulkarni wrote:
> Set IP protocol mask only when IP protocol field is set.
> This will allow flow-type ether with vlan rule which don't have
> protocol field to apply.
>=20
> ethtool -N ens5f4 flow-type ether proto 0x8100 vlan 0x600\
> m 0x1FFF action 3 loc 16
>=20
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
> ---
>  net/ethtool/ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 441794e0034f..e6f5cf52023c 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -3025,13 +3025,14 @@ ethtool_rx_flow_rule_create(const struct ethtool_=
rx_flow_spec_input *input)
>  	case TCP_V4_FLOW:
>  	case TCP_V6_FLOW:
>  		match->key.basic.ip_proto =3D IPPROTO_TCP;
> +		match->mask.basic.ip_proto =3D 0xff;
>  		break;
>  	case UDP_V4_FLOW:
>  	case UDP_V6_FLOW:
>  		match->key.basic.ip_proto =3D IPPROTO_UDP;
> +		match->mask.basic.ip_proto =3D 0xff;
>  		break;
>  	}
> -	match->mask.basic.ip_proto =3D 0xff;
> =20
>  	match->dissector.used_keys |=3D BIT(FLOW_DISSECTOR_KEY_BASIC);
>  	match->dissector.offset[FLOW_DISSECTOR_KEY_BASIC] =3D
> --=20
> 2.21.1
>=20

This is certainly correct. We should also handle SCTP_V4_FLOW and
SCTP_V6_FLOW in the same way as {TCP,UDP}_V{4,6}_FLOW but that is an
unrelated problem which should be handled separately (and also needs to
be addressed in the switch statement above this one).

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>


--si3pbal6jvwa2r4l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8+0D0ACgkQ538sG/LR
dpWUGgf/WNuwvQXD/5rTb9bLDbgfiBDcZXuit8zOEMw3iswgY09I+LdsFVLsuUNN
PAO29kH6nfT0WrQT+D5zhV8UF6ZLFFvXZX6Y94jYm/7NcJGIB3WgjwnwLqz3t3Kd
Jhci3Jueaowo3SsQoSXteu6Z+7m4h4cHcSR51PfV1UBa2GYzcU65Fbtc6DC5uNAg
ZVu6+tsI43wbCUCE35t/s5uHPDM+SCTRV5C9UN7Ds77x0PGlO4J81q2vsRKkKnLc
q2LXJTXI8+TfoD1qWO5MX5zPabOCHehFPz0ZJkGUa0db8ng5XfT6hQ1VoUac3iPi
hSr3J6vhcF7srfEB+HUc7MDZ+J92Lw==
=JsYk
-----END PGP SIGNATURE-----

--si3pbal6jvwa2r4l--
