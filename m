Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD5218332
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 03:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfEIBUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 21:20:44 -0400
Received: from ozlabs.org ([203.11.71.1]:45811 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfEIBUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 21:20:43 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44zwWp2Vddz9s55;
        Thu,  9 May 2019 11:20:38 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1557364839;
        bh=iUNt+AiggzT1LswLDZrrMkDk7hiFd6QDbiaJHCHel9k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JVCBpRtMmfSVIuE0hLDxxYrw/hmSsxE2cm9yP/KNV7nEOpiWK+BZ6g3YLYDBR9Vsl
         hcxdkADpH3po2PQHf+I21b6JFGbTi15qdAlJdYo5WG4wRGMsG0B0vktOwWWvd869gc
         CZR4ql6cR2z8g6X5I4uQnXu3xLbhZ6LNeQKL/YM07UR/Yu7ot4Ohm9KyWGDd5KwQ0F
         nMUazVCXgqftT+2U6YAxDvUrBn7BBGDK9Jj22enqBlvSUEkDoSnQp88Nw+hQBx4N8r
         M8gSZP6IiTZWWATBV5XOvse74rKZ5ECly/ONYjd0H6s/V5vme7JlLkHjr2Xu2R4dw2
         x2rCzqfrBVZEw==
Date:   Thu, 9 May 2019 11:20:37 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: linux-next: manual merge of the ipsec-next tree with the ipsec
 tree
Message-ID: <20190509112037.32468e3d@canb.auug.org.au>
In-Reply-To: <20190501130157.27fb69cd@canb.auug.org.au>
References: <20190426114120.73e906e3@canb.auug.org.au>
        <20190501130157.27fb69cd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8.7tSq7kxA1pH_HRAtOipbq"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8.7tSq7kxA1pH_HRAtOipbq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 1 May 2019 13:01:57 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Fri, 26 Apr 2019 11:41:20 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > Today's linux-next merge of the ipsec-next tree got a conflict in:
> >=20
> >   net/ipv4/xfrm4_policy.c
> >=20
> > between commit:
> >=20
> >   8742dc86d0c7 ("xfrm4: Fix uninitialized memory read in _decode_sessio=
n4")
> >=20
> > from the ipsec tree and commit:
> >=20
> >   c53ac41e3720 ("xfrm: remove decode_session indirection from afinfo_po=
licy")
> >=20
> > from the ipsec-next tree.
> >=20
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Fri, 26 Apr 2019 11:37:41 +1000
> > Subject: [PATCH] xfrm4: fix up for moved _decode_session4
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  net/xfrm/xfrm_policy.c | 24 +++++++++++++-----------
> >  1 file changed, 13 insertions(+), 11 deletions(-)
> >=20
> > diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> > index 410233c5681e..7a43ae6b2a44 100644
> > --- a/net/xfrm/xfrm_policy.c
> > +++ b/net/xfrm/xfrm_policy.c
> > @@ -3264,7 +3264,8 @@ static void
> >  decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
> >  {
> >  	const struct iphdr *iph =3D ip_hdr(skb);
> > -	u8 *xprth =3D skb_network_header(skb) + iph->ihl * 4;
> > +	int ihl =3D iph->ihl;
> > +	u8 *xprth =3D skb_network_header(skb) + ihl * 4;
> >  	struct flowi4 *fl4 =3D &fl->u.ip4;
> >  	int oif =3D 0;
> > =20
> > @@ -3275,6 +3276,11 @@ decode_session4(struct sk_buff *skb, struct flow=
i *fl, bool reverse)
> >  	fl4->flowi4_mark =3D skb->mark;
> >  	fl4->flowi4_oif =3D reverse ? skb->skb_iif : oif;
> > =20
> > +	fl4->flowi4_proto =3D iph->protocol;
> > +	fl4->daddr =3D reverse ? iph->saddr : iph->daddr;
> > +	fl4->saddr =3D reverse ? iph->daddr : iph->saddr;
> > +	fl4->flowi4_tos =3D iph->tos;
> > +
> >  	if (!ip_is_fragment(iph)) {
> >  		switch (iph->protocol) {
> >  		case IPPROTO_UDP:
> > @@ -3286,7 +3292,7 @@ decode_session4(struct sk_buff *skb, struct flowi=
 *fl, bool reverse)
> >  			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
> >  				__be16 *ports;
> > =20
> > -				xprth =3D skb_network_header(skb) + iph->ihl * 4;
> > +				xprth =3D skb_network_header(skb) + ihl * 4;
> >  				ports =3D (__be16 *)xprth;
> > =20
> >  				fl4->fl4_sport =3D ports[!!reverse];
> > @@ -3298,7 +3304,7 @@ decode_session4(struct sk_buff *skb, struct flowi=
 *fl, bool reverse)
> >  			    pskb_may_pull(skb, xprth + 2 - skb->data)) {
> >  				u8 *icmp;
> > =20
> > -				xprth =3D skb_network_header(skb) + iph->ihl * 4;
> > +				xprth =3D skb_network_header(skb) + ihl * 4;
> >  				icmp =3D xprth;
> > =20
> >  				fl4->fl4_icmp_type =3D icmp[0];
> > @@ -3310,7 +3316,7 @@ decode_session4(struct sk_buff *skb, struct flowi=
 *fl, bool reverse)
> >  			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
> >  				__be32 *ehdr;
> > =20
> > -				xprth =3D skb_network_header(skb) + iph->ihl * 4;
> > +				xprth =3D skb_network_header(skb) + ihl * 4;
> >  				ehdr =3D (__be32 *)xprth;
> > =20
> >  				fl4->fl4_ipsec_spi =3D ehdr[0];
> > @@ -3321,7 +3327,7 @@ decode_session4(struct sk_buff *skb, struct flowi=
 *fl, bool reverse)
> >  			    pskb_may_pull(skb, xprth + 8 - skb->data)) {
> >  				__be32 *ah_hdr;
> > =20
> > -				xprth =3D skb_network_header(skb) + iph->ihl * 4;
> > +				xprth =3D skb_network_header(skb) + ihl * 4;
> >  				ah_hdr =3D (__be32 *)xprth;
> > =20
> >  				fl4->fl4_ipsec_spi =3D ah_hdr[1];
> > @@ -3332,7 +3338,7 @@ decode_session4(struct sk_buff *skb, struct flowi=
 *fl, bool reverse)
> >  			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
> >  				__be16 *ipcomp_hdr;
> > =20
> > -				xprth =3D skb_network_header(skb) + iph->ihl * 4;
> > +				xprth =3D skb_network_header(skb) + ihl * 4;
> >  				ipcomp_hdr =3D (__be16 *)xprth;
> > =20
> >  				fl4->fl4_ipsec_spi =3D htonl(ntohs(ipcomp_hdr[1]));
> > @@ -3344,7 +3350,7 @@ decode_session4(struct sk_buff *skb, struct flowi=
 *fl, bool reverse)
> >  				__be16 *greflags;
> >  				__be32 *gre_hdr;
> > =20
> > -				xprth =3D skb_network_header(skb) + iph->ihl * 4;
> > +				xprth =3D skb_network_header(skb) + ihl * 4;
> >  				greflags =3D (__be16 *)xprth;
> >  				gre_hdr =3D (__be32 *)xprth;
> > =20
> > @@ -3360,10 +3366,6 @@ decode_session4(struct sk_buff *skb, struct flow=
i *fl, bool reverse)
> >  			break;
> >  		}
> >  	}
> > -	fl4->flowi4_proto =3D iph->protocol;
> > -	fl4->daddr =3D reverse ? iph->saddr : iph->daddr;
> > -	fl4->saddr =3D reverse ? iph->daddr : iph->saddr;
> > -	fl4->flowi4_tos =3D iph->tos;
> >  }
> > =20
> >  #if IS_ENABLED(CONFIG_IPV6) =20
>=20
> This is now a conflict between the net and net-next trees.

It looks like this fixup has been missed in Linus' merge of the
net-next tree ...

--=20
Cheers,
Stephen Rothwell

--Sig_/8.7tSq7kxA1pH_HRAtOipbq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzTgGUACgkQAVBC80lX
0GzQgwf/aaYmzQSYs0z5lraiYgZFBRsMVA2vmwAANQGZN+mKzP6eHo02D+GFxI93
HTbKgFEcHL2OGF0LHm/v1I7S4jH+2HMUQF2dB/af96/rOIBCIecLYYfOGjjS0mI9
DGNpxCjkXM/CJA4nVdn3lJa7byWVM2Z6QqZDoMqqbyIkny6ZTrnOm8ifLXKrcCdJ
xMNriAbNJD3dTX2wgz1o0ZARdrqf22aGiKpNs/IOlJ5nHZ4wQaRvUfyRQhqkyo/u
IKMa8ZpkRiHVHzzCO3Ok4uG5wQSQVyMuSJLD99swFhpwsRwMVmtSaJ+eol4H5F9m
col98L1Hy595I/mM7UNF0u/9LKpWSg==
=mE28
-----END PGP SIGNATURE-----

--Sig_/8.7tSq7kxA1pH_HRAtOipbq--
