Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3592F35A34E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhDIQ2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhDIQ2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:28:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95A8A6054E;
        Fri,  9 Apr 2021 16:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617985711;
        bh=5a0B3KIdMudwnUUZZzl1z2sU8Povxcp2gl7S+Psldmg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GNzfnF9h3dnVptD1LHok5SShMKG1J62HEByBumcXFN60cREXFh1F66Q30hylwcrjz
         0zA25Fud64ZXkrdcPQGSB3rJVdZl9bkS8eK9XmWz7Zf1MzKLw1tPzJg+wX7fYQtNCx
         C/1jDgK19I8I54YWNMhGkbQW1oLZxAPFm7Q2CyJLmNJk/IbBTHluiJQu7017ka59k9
         Kff8LnaJlxLyxcAT/Wjb0OMUhAGx6ApLPeDLwclpi2a/Mmi6bCv5WNUZNd8Jg7jUfF
         CK9DhwHxC2QYRVfQYJUS9ob63xlvVa2HYJUkiDswI39yDaujQQZpWT790LzuwaSBPS
         Q3YCzQuIXsqPQ==
Date:   Fri, 9 Apr 2021 18:28:26 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 04/14] xdp: add multi-buff support to
 xdp_return_{buff/frame}
Message-ID: <YHCAqo3w/J+ngb9P@lore-desk>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <d616c727e8890c43f3e2c93bfd62b396292a7378.1617885385.git.lorenzo@kernel.org>
 <20210408183038.yacxn575nl7omcol@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ac/b02FXHW4CpRC2"
Content-Disposition: inline
In-Reply-To: <20210408183038.yacxn575nl7omcol@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Ac/b02FXHW4CpRC2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Apr 08, 2021 at 02:50:56PM +0200, Lorenzo Bianconi wrote:
> > Take into account if the received xdp_buff/xdp_frame is non-linear
> > recycling/returning the frame memory to the allocator or into
> > xdp_frame_bulk.
> > Introduce xdp_return_num_frags_from_buff to return a given number of
> > fragments from a xdp multi-buff starting from the tail.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/net/xdp.h | 19 ++++++++++--
> >  net/core/xdp.c    | 76 ++++++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 92 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 02aea7696d15..c8eb7cf4ebed 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -289,6 +289,7 @@ void xdp_return_buff(struct xdp_buff *xdp);
> >  void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
> >  void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> >  			   struct xdp_frame_bulk *bq);
> > +void xdp_return_num_frags_from_buff(struct xdp_buff *xdp, u16 num_frag=
s);
> > =20
> >  /* When sending xdp_frame into the network stack, then there is no
> >   * return point callback, which is needed to release e.g. DMA-mapping
> > @@ -299,10 +300,24 @@ void __xdp_release_frame(void *data, struct xdp_m=
em_info *mem);
> >  static inline void xdp_release_frame(struct xdp_frame *xdpf)
> >  {
> >  	struct xdp_mem_info *mem =3D &xdpf->mem;
> > +	struct xdp_shared_info *xdp_sinfo;
> > +	int i;
> > =20
> >  	/* Curr only page_pool needs this */
> > -	if (mem->type =3D=3D MEM_TYPE_PAGE_POOL)
> > -		__xdp_release_frame(xdpf->data, mem);
> > +	if (mem->type !=3D MEM_TYPE_PAGE_POOL)
> > +		return;
> > +
> > +	if (likely(!xdpf->mb))
> > +		goto out;
> > +
> > +	xdp_sinfo =3D xdp_get_shared_info_from_frame(xdpf);
> > +	for (i =3D 0; i < xdp_sinfo->nr_frags; i++) {
> > +		struct page *page =3D xdp_get_frag_page(&xdp_sinfo->frags[i]);
> > +
> > +		__xdp_release_frame(page_address(page), mem);
> > +	}
> > +out:
> > +	__xdp_release_frame(xdpf->data, mem);
> >  }
> > =20
> >  int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 05354976c1fc..430f516259d9 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -374,12 +374,38 @@ static void __xdp_return(void *data, struct xdp_m=
em_info *mem, bool napi_direct,
> > =20
> >  void xdp_return_frame(struct xdp_frame *xdpf)
> >  {
> > +	struct xdp_shared_info *xdp_sinfo;
> > +	int i;
> > +
> > +	if (likely(!xdpf->mb))
> > +		goto out;
> > +
> > +	xdp_sinfo =3D xdp_get_shared_info_from_frame(xdpf);
> > +	for (i =3D 0; i < xdp_sinfo->nr_frags; i++) {
> > +		struct page *page =3D xdp_get_frag_page(&xdp_sinfo->frags[i]);
> > +
> > +		__xdp_return(page_address(page), &xdpf->mem, false, NULL);
> > +	}
> > +out:
> >  	__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
> >  }
> >  EXPORT_SYMBOL_GPL(xdp_return_frame);
> > =20
> >  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
> >  {
> > +	struct xdp_shared_info *xdp_sinfo;
> > +	int i;
> > +
> > +	if (likely(!xdpf->mb))
> > +		goto out;
> > +
> > +	xdp_sinfo =3D xdp_get_shared_info_from_frame(xdpf);
> > +	for (i =3D 0; i < xdp_sinfo->nr_frags; i++) {
> > +		struct page *page =3D xdp_get_frag_page(&xdp_sinfo->frags[i]);
> > +
> > +		__xdp_return(page_address(page), &xdpf->mem, true, NULL);
> > +	}
> > +out:
> >  	__xdp_return(xdpf->data, &xdpf->mem, true, NULL);
> >  }
> >  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
> > @@ -415,7 +441,7 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> >  	struct xdp_mem_allocator *xa;
> > =20
> >  	if (mem->type !=3D MEM_TYPE_PAGE_POOL) {
> > -		__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
> > +		xdp_return_frame(xdpf);
> >  		return;
> >  	}
> > =20
> > @@ -434,15 +460,63 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> >  		bq->xa =3D rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> >  	}
> > =20
> > +	if (unlikely(xdpf->mb)) {
> > +		struct xdp_shared_info *xdp_sinfo;
> > +		int i;
> > +
> > +		xdp_sinfo =3D xdp_get_shared_info_from_frame(xdpf);
> > +		for (i =3D 0; i < xdp_sinfo->nr_frags; i++) {
> > +			skb_frag_t *frag =3D &xdp_sinfo->frags[i];
> > +
> > +			bq->q[bq->count++] =3D xdp_get_frag_address(frag);
> > +			if (bq->count =3D=3D XDP_BULK_QUEUE_SIZE)
> > +				xdp_flush_frame_bulk(bq);
> > +		}
> > +	}
> >  	bq->q[bq->count++] =3D xdpf->data;
> >  }
> >  EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
> > =20
> >  void xdp_return_buff(struct xdp_buff *xdp)
> >  {
> > +	struct xdp_shared_info *xdp_sinfo;
> > +	int i;
> > +
> > +	if (likely(!xdp->mb))
> > +		goto out;
> > +
> > +	xdp_sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	for (i =3D 0; i < xdp_sinfo->nr_frags; i++) {
> > +		struct page *page =3D xdp_get_frag_page(&xdp_sinfo->frags[i]);
> > +
> > +		__xdp_return(page_address(page), &xdp->rxq->mem, true, xdp);
> > +	}
> > +out:
> >  	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp);
> >  }
> > =20
> > +void xdp_return_num_frags_from_buff(struct xdp_buff *xdp, u16 num_frag=
s)
> > +{
> > +	struct xdp_shared_info *xdp_sinfo;
> > +	int i;
> > +
> > +	if (unlikely(!xdp->mb))
> > +		return;
> > +
> > +	xdp_sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	num_frags =3D min_t(u16, num_frags, xdp_sinfo->nr_frags);
> > +	for (i =3D 1; i <=3D num_frags; i++) {
> > +		skb_frag_t *frag =3D &xdp_sinfo->frags[xdp_sinfo->nr_frags - i];
> > +		struct page *page =3D xdp_get_frag_page(frag);
> > +
> > +		xdp_sinfo->data_length -=3D xdp_get_frag_size(frag);
> > +		__xdp_return(page_address(page), &xdp->rxq->mem, false, NULL);
> > +	}
> > +	xdp_sinfo->nr_frags -=3D num_frags;
> > +	xdp->mb =3D !!xdp_sinfo->nr_frags;
> > +}
> > +EXPORT_SYMBOL_GPL(xdp_return_num_frags_from_buff);
> > +
> >  /* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
> >  void __xdp_release_frame(void *data, struct xdp_mem_info *mem)
> >  {
>=20
> None of this really benefits in any way from having the extra "mb" bit,
> does it? I get the impression it would work just the same way without it.

paged xdp_buff part is initialized only if xdp->mb is set. The reason is no=
t hit
performances in the most common single buffer use case. We always need to c=
heck
xdp->mb or xdf->mb before accessing paged area.

Regards,
Lorenzo

--Ac/b02FXHW4CpRC2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYHCAqAAKCRA6cBh0uS2t
rLz7AP9oySycQa00F8dhCLS6hD+dbseikCtABP9EHqXtEbUVuAEAhsnmwmUC4n1j
SW6AHfzIOZQi9YwBeGDCUfa8FL4TXQ0=
=ZpuQ
-----END PGP SIGNATURE-----

--Ac/b02FXHW4CpRC2--
