Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81828436DDA
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 01:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhJUXF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 19:05:29 -0400
Received: from dehost.average.org ([88.198.2.197]:44924 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhJUXF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 19:05:28 -0400
Received: from [IPV6:2a02:8106:1:6800:b28f:d925:44bd:a2e0] (unknown [IPv6:2a02:8106:1:6800:b28f:d925:44bd:a2e0])
        by dehost.average.org (Postfix) with ESMTPSA id D62743905EBB;
        Fri, 22 Oct 2021 01:03:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1634857391; bh=/AUw//g3acKdZxzMDB1qZkZK989pfClq/5Fhu40WngQ=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=J3WZeNUsG/cvhEAM/ViiMuVT4Sy7o4th4iSKxAakz3Ni6pPct5fKMticUCdPTnXFb
         Cf53Q8nWoDk4AWU/yk8ZlXhY3Ivyns4inIeGvq+tGUJalNMMQzk1sqxbK1vVfIoKTt
         VFIRUvFLsOV56IWNNJctc+Rfr4wxUBN3djq0WB2Q=
Message-ID: <dbbc274e-cf69-5207-6ddd-00c435d5a689@average.org>
Date:   Fri, 22 Oct 2021 01:03:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, dsahern@kernel.org,
        pablo@netfilter.org, lschlesinger@drivenets.com
References: <20211021144857.29714-1-fw@strlen.de>
 <20211021144857.29714-3-fw@strlen.de>
From:   Eugene Crosser <crosser@average.org>
Subject: Re: [PATCH net-next 2/2] vrf: run conntrack only in context of
 lower/physdev for locally generated packets
In-Reply-To: <20211021144857.29714-3-fw@strlen.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lxE90kbalv12INv0G0ebVxdC"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lxE90kbalv12INv0G0ebVxdC
Content-Type: multipart/mixed; boundary="------------2GN31wGSndP20FIs0dGcmjOe";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, dsahern@kernel.org, pablo@netfilter.org,
 lschlesinger@drivenets.com
Message-ID: <dbbc274e-cf69-5207-6ddd-00c435d5a689@average.org>
Subject: Re: [PATCH net-next 2/2] vrf: run conntrack only in context of
 lower/physdev for locally generated packets
References: <20211021144857.29714-1-fw@strlen.de>
 <20211021144857.29714-3-fw@strlen.de>
In-Reply-To: <20211021144857.29714-3-fw@strlen.de>

--------------2GN31wGSndP20FIs0dGcmjOe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 21/10/2021 16:48, Florian Westphal wrote:
> The VRF driver invokes netfilter for output+postrouting hooks so that u=
sers
> can create rules that check for 'oif $vrf' rather than lower device nam=
e.
>=20
> This is a problem when NAT rules are configured.
>=20
> To avoid any conntrack involvement in round 1, tag skbs as 'untracked'
> to prevent conntrack from picking them up.
>=20
> This gets cleared before the packet gets handed to the ip stack so
> conntrack will be active on the second iteration.
>=20
> For ingress, conntrack has already been done before the packet makes it=

> to the vrf driver, with this patch egress does connection tracking with=

> lower/physical device as well.
>=20
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  drivers/net/vrf.c | 28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
> index bf2fac913942..c813d03159bf 100644
> --- a/drivers/net/vrf.c
> +++ b/drivers/net/vrf.c
> @@ -35,6 +35,7 @@
>  #include <net/l3mdev.h>
>  #include <net/fib_rules.h>
>  #include <net/netns/generic.h>
> +#include <net/netfilter/nf_conntrack.h>
> =20
>  #define DRV_NAME	"vrf"
>  #define DRV_VERSION	"1.1"
> @@ -424,12 +425,26 @@ static int vrf_local_xmit(struct sk_buff *skb, st=
ruct net_device *dev,
>  	return NETDEV_TX_OK;
>  }
> =20
> +static void vrf_nf_set_untracked(struct sk_buff *skb)
> +{
> +	if (skb_get_nfct(skb) =3D=3D 0)
> +		nf_ct_set(skb, 0, IP_CT_UNTRACKED);
> +}
> +
> +static void vrf_nf_reset_ct(struct sk_buff *skb)
> +{
> +	if (skb_get_nfct(skb) =3D=3D IP_CT_UNTRACKED)
> +		nf_reset_ct(skb);
> +}
> +

Isn't it possible that skb was marked UNTRACKED before entering this path=
, by a
rule? In such case 'set_untrackd' will do nothing, but 'reset_ct' will cl=
ear
UNTRACKED status that was set elswhere. It seems wrong, am I missing some=
thing?

>  #if IS_ENABLED(CONFIG_IPV6)
>  static int vrf_ip6_local_out(struct net *net, struct sock *sk,
>  			     struct sk_buff *skb)
>  {
>  	int err;
> =20
> +	vrf_nf_reset_ct(skb);
> +
>  	err =3D nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net,
>  		      sk, skb, NULL, skb_dst(skb)->dev, dst_output);
> =20
> @@ -508,6 +523,8 @@ static int vrf_ip_local_out(struct net *net, struct=
 sock *sk,
>  {
>  	int err;
> =20
> +	vrf_nf_reset_ct(skb);
> +
>  	err =3D nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT, net, sk,
>  		      skb, NULL, skb_dst(skb)->dev, dst_output);
>  	if (likely(err =3D=3D 1))
> @@ -626,8 +643,7 @@ static void vrf_finish_direct(struct sk_buff *skb)
>  		skb_pull(skb, ETH_HLEN);
>  	}
> =20
> -	/* reset skb device */
> -	nf_reset_ct(skb);
> +	vrf_nf_reset_ct(skb);
>  }
> =20
>  #if IS_ENABLED(CONFIG_IPV6)
> @@ -641,7 +657,7 @@ static int vrf_finish_output6(struct net *net, stru=
ct sock *sk,
>  	struct neighbour *neigh;
>  	int ret;
> =20
> -	nf_reset_ct(skb);
> +	vrf_nf_reset_ct(skb);
> =20
>  	skb->protocol =3D htons(ETH_P_IPV6);
>  	skb->dev =3D dev;
> @@ -752,6 +768,8 @@ static struct sk_buff *vrf_ip6_out_direct(struct ne=
t_device *vrf_dev,
> =20
>  	skb->dev =3D vrf_dev;
> =20
> +	vrf_nf_set_untracked(skb);
> +
>  	err =3D nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk,
>  		      skb, NULL, vrf_dev, vrf_ip6_out_direct_finish);
> =20
> @@ -858,7 +876,7 @@ static int vrf_finish_output(struct net *net, struc=
t sock *sk, struct sk_buff *s
>  	struct neighbour *neigh;
>  	bool is_v6gw =3D false;
> =20
> -	nf_reset_ct(skb);
> +	vrf_nf_reset_ct(skb);
> =20
>  	/* Be paranoid, rather than too clever. */
>  	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
> @@ -980,6 +998,8 @@ static struct sk_buff *vrf_ip_out_direct(struct net=
_device *vrf_dev,
> =20
>  	skb->dev =3D vrf_dev;
> =20
> +	vrf_nf_set_untracked(skb);
> +
>  	err =3D nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT, net, sk,
>  		      skb, NULL, vrf_dev, vrf_ip_out_direct_finish);
> =20
>=20


--------------2GN31wGSndP20FIs0dGcmjOe--

--------------lxE90kbalv12INv0G0ebVxdC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmFx8akACgkQfKQHw5Gd
RYxYzwf/ZTmXz/nzHgNxnPO1jDNxqqTbR3lOIxDOBdi0ha+REaph1rMTPFTIwAJA
0QZHEgKi+8sdyzai/5x8peOn2unStJAyglIp6OnkZ8/DFs32+bm1ksRYLrlk4AL3
RryEWyxtXOo2zetJOc+KO2SthSoJQTH704ERkcg6+GYd+yHB2sDWtIVBXA4Guser
2JKMa53XuUQ246i9e+ElnezhcwJvb+TVD1ffXr37cSIMNNHrFx04qjRbDsZA0a+g
oNLLvyVpM927+pVBAYM6o4hGMk2dlGiQr6nx+0qbAm9yWqR9QPVc1cLmQe2pxf7M
PsMPgtQv0wAwfFV4LAOSB5KvpaI6ig==
=ZssE
-----END PGP SIGNATURE-----

--------------lxE90kbalv12INv0G0ebVxdC--
