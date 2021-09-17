Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABC540F585
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 12:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343713AbhIQKE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 06:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343775AbhIQKEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 06:04:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBE1160FBF;
        Fri, 17 Sep 2021 10:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631872971;
        bh=5sLxRurihRn4wZfhRLJfHuISHZqq102C4j63c2g5rkw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fvYagyWG8448T0w1FK0YsO8GDrNziK3gGsJKI39RUHxvKvEZm7vF/UfIPwj7gyhcW
         qI0FR6O8XK1AeE1X+ooXNxyYqH7JmCpIV9oyPl3PwvvMQeSrWdKO2rEBthpNGA5l1r
         ZgNqhPspJeiV6LmcXpz+PVw0HPXoPRqRoi9YLUZrPb55hGPmzjz08ednwetR3Ad/31
         D9Xrq9dEaLBWBoNl5M8JCs7/cMUYHYd5zMyBbosN/evvHs7f4Y4+K/rmm8GRkR1FU3
         QYoFA1Sulz1ExH1EHQAmvPySLzADaEKAU866do9xNO0/x1DPGTHCm6B64U7HUS+KI/
         2asU3sjul0nWw==
Date:   Fri, 17 Sep 2021 12:02:46 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v14 bpf-next 10/18] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <YURnxr89pcasiplc@lore-desk>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <e07aa987d148c168f1ac95a315d45e24e58c54f5.1631289870.git.lorenzo@kernel.org>
 <20210916095544.50978cd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="veF2hyD5+HZx7haZ"
Content-Disposition: inline
In-Reply-To: <20210916095544.50978cd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--veF2hyD5+HZx7haZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sep 16, Jakub Kicinski wrote:
> On Fri, 10 Sep 2021 18:14:16 +0200 Lorenzo Bianconi wrote:
> > From: Eelco Chaudron <echaudro@redhat.com>
> >=20
> > This change adds support for tail growing and shrinking for XDP multi-b=
uff.
> >=20
> > When called on a multi-buffer packet with a grow request, it will always
> > work on the last fragment of the packet. So the maximum grow size is the
> > last fragments tailroom, i.e. no new buffer will be allocated.
> >=20
> > When shrinking, it will work from the last fragment, all the way down to
> > the base buffer depending on the shrinking size. It's important to ment=
ion
> > that once you shrink down the fragment(s) are freed, so you can not grow
> > again to the original size.
> >=20
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>=20
> > +static inline unsigned int xdp_get_frag_tailroom(const skb_frag_t *fra=
g)
> > +{
> > +	struct page *page =3D skb_frag_page(frag);
> > +
> > +	return page_size(page) - skb_frag_size(frag) - skb_frag_off(frag);
> > +}
>=20
> How do we deal with NICs which can pack multiple skbs into a page frag?
> skb_shared_info field to mark the end of last fragment? Just want to make=
=20
> sure there is a path to supporting such designs.

I guess here, intead of using page_size(page) we can rely on xdp_buff->fram=
e_sz
or even on skb_shared_info()->xdp_frag_truesize (assuming all fragments fro=
m a
given hw have the same truesize, but I think this is something we can rely =
on)

static inline unsigned int xdp_get_frag_tailroom(struct xdp_buff *xdp,
						 const skb_frag_t *frag)
{
	return xdp->frame_sz - skb_frag_size(frag) - skb_frag_off(frag);
}

what do you think?

>=20
> > +static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
> > +{
> > +	struct skb_shared_info *sinfo;
> > +
> > +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	if (offset >=3D 0) {
> > +		skb_frag_t *frag =3D &sinfo->frags[sinfo->nr_frags - 1];
> > +		int size;
> > +
> > +		if (unlikely(offset > xdp_get_frag_tailroom(frag)))
> > +			return -EINVAL;
> > +
> > +		size =3D skb_frag_size(frag);
> > +		memset(skb_frag_address(frag) + size, 0, offset);
> > +		skb_frag_size_set(frag, size + offset);
> > +		sinfo->xdp_frags_size +=3D offset;
> > +	} else {
> > +		int i, n_frags_free =3D 0, len_free =3D 0, tlen_free =3D 0;
> > +
> > +		offset =3D abs(offset);
> > +		if (unlikely(offset > ((int)(xdp->data_end - xdp->data) +
> > +				       sinfo->xdp_frags_size - ETH_HLEN)))
> > +			return -EINVAL;
> > +
> > +		for (i =3D sinfo->nr_frags - 1; i >=3D 0 && offset > 0; i--) {
> > +			skb_frag_t *frag =3D &sinfo->frags[i];
> > +			int size =3D skb_frag_size(frag);
> > +			int shrink =3D min_t(int, offset, size);
> > +
> > +			len_free +=3D shrink;
> > +			offset -=3D shrink;
> > +
> > +			if (unlikely(size =3D=3D shrink)) {
> > +				struct page *page =3D skb_frag_page(frag);
> > +
> > +				__xdp_return(page_address(page), &xdp->rxq->mem,
> > +					     false, NULL);
> > +				tlen_free +=3D page_size(page);
> > +				n_frags_free++;
> > +			} else {
> > +				skb_frag_size_set(frag, size - shrink);
> > +				break;
> > +			}
> > +		}
> > +		sinfo->nr_frags -=3D n_frags_free;
> > +		sinfo->xdp_frags_size -=3D len_free;
> > +		sinfo->xdp_frags_truesize -=3D tlen_free;
> > +
> > +		if (unlikely(offset > 0)) {
> > +			xdp_buff_clear_mb(xdp);
> > +			xdp->data_end -=3D offset;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
>=20
> nit: most of this function is indented, situation is ripe for splitting
>      it into two

sure, I will fix it.

Regards,
Lorenzo


--veF2hyD5+HZx7haZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYURnxAAKCRA6cBh0uS2t
rL9KAP0Wu+XtmjENblm+6bkRnaYTKt/mqTvcrJiTpIw1pgxGsQEAmMQin0qag3az
WPxj4Q2wbD3qMcGLAw1dE7rV8/9wVA0=
=zG+C
-----END PGP SIGNATURE-----

--veF2hyD5+HZx7haZ--
