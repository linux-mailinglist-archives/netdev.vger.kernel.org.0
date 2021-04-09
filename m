Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470D435A32B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbhDIQZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234330AbhDIQZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:25:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D43F76103E;
        Fri,  9 Apr 2021 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617985496;
        bh=1I9bScnOyLvJ83T0qEAguJ1dktfatEjvCVMDfYDNpdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E6N02hx3tx6qyuu8+BjuOLRJAwSPuoelG+9wGzt1N6WM4unuY8fvu9BjHL7HUf6s/
         UWiwd/6WFIk+VR0xIEJPI0Q/rJ5IUARhRo+/UDWsjDwtIC37IzrQCGl/kHcDcgDrCs
         Rcnj1qvGT7MNF9QIXCr6XTdzCeXiTJ7EJyqKAOg1l3tv+wApPUnKWIeA83sVRNVxvG
         qJK+vPqfsYDxR6I5unb/u0jvGVAshHjgOQ663E0MM5oBgXhpl4Itqz2Ys3Czqrpr/1
         7XAIvKvXMrLklu85J3vAcEjq8D+1wuSB6qF1vJoZRbr60i5r/WN/lkpQ4/Rr90fdYW
         7YiwEm8JwF7PQ==
Date:   Fri, 9 Apr 2021 18:24:51 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 03/14] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
Message-ID: <YHB/078gnE/wcvNw@lore-desk>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <7a56776d5e2053755854dd668bb08a5e369ef722.1617885385.git.lorenzo@kernel.org>
 <20210408181935.hrouvsh6hroof4jl@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DaDbQeGnh54LyJSO"
Content-Disposition: inline
In-Reply-To: <20210408181935.hrouvsh6hroof4jl@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DaDbQeGnh54LyJSO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Apr 08, 2021 at 02:50:55PM +0200, Lorenzo Bianconi wrote:
> > Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> > XDP remote drivers if this is a "non-linear" XDP buffer. Access
> > xdp_shared_info only if xdp_buff mb is set.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 26 ++++++++++++++++++++------
> >  1 file changed, 20 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index a52e132fd2cf..94e29cce693a 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -2041,12 +2041,16 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, str=
uct mvneta_rx_queue *rxq,
> >  {
> >  	int i;
> > =20
> > +	if (likely(!xdp->mb))
> > +		goto out;
> > +
>=20
> Is there any particular reason for this extra check?

xdp_sinfo->frags[] is initialized just if xdp->mb is set.

Regards,
Lorenzo

>=20
> >  	for (i =3D 0; i < xdp_sinfo->nr_frags; i++) {
> >  		skb_frag_t *frag =3D &xdp_sinfo->frags[i];
> > =20
> >  		page_pool_put_full_page(rxq->page_pool,
> >  					xdp_get_frag_page(frag), true);
> >  	}
> > +out:
> >  	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
> >  			   sync_len, true);
> >  }
> > @@ -2246,7 +2250,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >  {
> >  	unsigned char *data =3D page_address(page);
> >  	int data_len =3D -MVNETA_MH_SIZE, len;
> > -	struct xdp_shared_info *xdp_sinfo;
> >  	struct net_device *dev =3D pp->dev;
> >  	enum dma_data_direction dma_dir;
> > =20
> > @@ -2270,9 +2273,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >  	prefetch(data);
> >  	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
> >  			 data_len, false);
> > -
> > -	xdp_sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > -	xdp_sinfo->nr_frags =3D 0;
> >  }
> > =20
> >  static void
> > @@ -2307,12 +2307,18 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port =
*pp,
> >  		xdp_set_frag_size(frag, data_len);
> >  		xdp_set_frag_page(frag, page);
> > =20
> > +		if (!xdp->mb) {
> > +			xdp_sinfo->data_length =3D *size;
> > +			xdp->mb =3D 1;
> > +		}
> >  		/* last fragment */
> >  		if (len =3D=3D *size) {
> >  			struct xdp_shared_info *sinfo;
> > =20
> >  			sinfo =3D xdp_get_shared_info_from_buff(xdp);
> >  			sinfo->nr_frags =3D xdp_sinfo->nr_frags;
> > +			sinfo->data_length =3D xdp_sinfo->data_length;
> > +
> >  			memcpy(sinfo->frags, xdp_sinfo->frags,
> >  			       sinfo->nr_frags * sizeof(skb_frag_t));
> >  		}
> > @@ -2327,11 +2333,15 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, s=
truct mvneta_rx_queue *rxq,
> >  		      struct xdp_buff *xdp, u32 desc_status)
> >  {
> >  	struct xdp_shared_info *xdp_sinfo =3D xdp_get_shared_info_from_buff(x=
dp);
> > -	int i, num_frags =3D xdp_sinfo->nr_frags;
> >  	skb_frag_t frag_list[MAX_SKB_FRAGS];
> > +	int i, num_frags =3D 0;
> >  	struct sk_buff *skb;
> > =20
> > -	memcpy(frag_list, xdp_sinfo->frags, sizeof(skb_frag_t) * num_frags);
> > +	if (unlikely(xdp->mb)) {
> > +		num_frags =3D xdp_sinfo->nr_frags;
> > +		memcpy(frag_list, xdp_sinfo->frags,
> > +		       sizeof(skb_frag_t) * num_frags);
> > +	}
> > =20
> >  	skb =3D build_skb(xdp->data_hard_start, PAGE_SIZE);
> >  	if (!skb)
> > @@ -2343,6 +2353,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, str=
uct mvneta_rx_queue *rxq,
> >  	skb_put(skb, xdp->data_end - xdp->data);
> >  	mvneta_rx_csum(pp, desc_status, skb);
> > =20
> > +	if (likely(!xdp->mb))
> > +		return skb;
> > +
> >  	for (i =3D 0; i < num_frags; i++) {
> >  		struct page *page =3D xdp_get_frag_page(&frag_list[i]);
> > =20
> > @@ -2404,6 +2417,7 @@ static int mvneta_rx_swbm(struct napi_struct *nap=
i,
> >  			frame_sz =3D size - ETH_FCS_LEN;
> >  			desc_status =3D rx_status;
> > =20
> > +			xdp_buf.mb =3D 0;
> >  			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
> >  					     &size, page);
> >  		} else {
> > --=20
> > 2.30.2
> >=20
>=20

--DaDbQeGnh54LyJSO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYHB/0AAKCRA6cBh0uS2t
rIn6AP4j0Y5kcCrLUdgz8noICfBLoEx3AXp6q8ZoQwLiSTJuTAEAn+Ebpe1mR5VO
yWMU766AiArFPOREdjQ5v22NZJNxDg0=
=ozMp
-----END PGP SIGNATURE-----

--DaDbQeGnh54LyJSO--
