Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C34449A4A
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbhKHQva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231330AbhKHQva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 11:51:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B653610A3;
        Mon,  8 Nov 2021 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636390125;
        bh=O2kvEdbaEtHMwFnvPTppO4ra6nMHq0KjSKGtW5owMLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fEbYHQFBjZpsQgCGCmLcw6QepoK+qbU0s0vT85B5kkyR6W28tkac5XMj62oyotEUd
         SUbaGGoS0NjBretzYrTVlvXahkiM2NqjOEaI9grElFeGQGV/HhmFlH5mplqajs6DpW
         V7m4C3ZoADB08yjG8Bl9/CW3o9kxYLUUcz2je0keaUEyiDv12RUc+Pv4ZGt7jaWvq6
         IEWPdhsgphlf3/2Knjps0zY/1qNvL5vANnyp12qG2TjfHlC0KwmgY+rSRmteicb4Qy
         EY0SCnwQyk5IjAmn9UedkTZSag2i95/I7YDDtR/Ocb4wDk3tplhk9SPlZCsFLv6A59
         RTftkGfJ+mVEA==
Date:   Mon, 8 Nov 2021 17:48:42 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v17 bpf-next 20/23] net: xdp: introduce bpf_xdp_pointer
 utility routine
Message-ID: <YYlU6nuZu7aUFLQT@lore-desk>
References: <cover.1636044387.git.lorenzo@kernel.org>
 <273cc085c8cbe5913defe302800fc69da650e7b1.1636044387.git.lorenzo@kernel.org>
 <20211105162944.5f58487e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AsmBTGevGnjm9UDq"
Content-Disposition: inline
In-Reply-To: <20211105162944.5f58487e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--AsmBTGevGnjm9UDq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu,  4 Nov 2021 18:35:40 +0100 Lorenzo Bianconi wrote:
> > Similar to skb_header_pointer, introduce bpf_xdp_pointer utility routine
> > to return a pointer to a given position in the xdp_buff if the requested
> > area (offset + len) is contained in a contiguous memory area otherwise =
it
> > will be copied in a bounce buffer provided by the caller.
> > Similar to the tc counterpart, introduce the two following xdp helpers:
> > - bpf_xdp_load_bytes
> > - bpf_xdp_store_bytes
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 386dd2fffded..534305037ad7 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3840,6 +3840,135 @@ static const struct bpf_func_proto bpf_xdp_adju=
st_head_proto =3D {
> >  	.arg2_type	=3D ARG_ANYTHING,
> >  };
> > =20
> > +static void bpf_xdp_copy_buf(struct xdp_buff *xdp, u32 offset,
> > +			     u32 len, void *buf, bool flush)
> > +{
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	u32 headsize =3D xdp->data_end - xdp->data;
> > +	u32 count =3D 0, frame_offset =3D headsize;
> > +	int i =3D 0;
> > +
> > +	if (offset < headsize) {
> > +		int size =3D min_t(int, headsize - offset, len);
> > +		void *src =3D flush ? buf : xdp->data + offset;
> > +		void *dst =3D flush ? xdp->data + offset : buf;
> > +
> > +		memcpy(dst, src, size);
> > +		count =3D size;
> > +		offset =3D 0;
> > +	}
> > +
> > +	while (count < len && i < sinfo->nr_frags) {
>=20
> nit: for (i =3D 0; ...; i++) ?

ack, I will fix it in v18

>=20
> > +		skb_frag_t *frag =3D &sinfo->frags[i++];
> > +		u32 frag_size =3D skb_frag_size(frag);
> > +
> > +		if  (offset < frame_offset + frag_size) {
>=20
> nit: double space after if

ack, I will fix it in v18
>=20
> > +			int size =3D min_t(int, frag_size - offset, len - count);
> > +			void *addr =3D skb_frag_address(frag);
> > +			void *src =3D flush ? buf + count : addr + offset;
> > +			void *dst =3D flush ? addr + offset : buf + count;
> > +
> > +			memcpy(dst, src, size);
> > +			count +=3D size;
> > +			offset =3D 0;
> > +		}
> > +		frame_offset +=3D frag_size;
> > +	}
> > +}
> > +
> > +static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset,
> > +			     u32 len, void *buf)
> > +{
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	u32 size =3D xdp->data_end - xdp->data;
> > +	void *addr =3D xdp->data;
> > +	int i;
> > +
> > +	if (unlikely(offset > 0xffff))
> > +		return ERR_PTR(-EFAULT);
> > +
> > +	if (offset + len > xdp_get_buff_len(xdp))
> > +		return ERR_PTR(-EINVAL);
>=20
> I don't think it breaks anything but should we sanity check len?
> Maybe make the test above (offset | len) > 0xffff -> EFAULT?

ack, I will add it in v18

>=20
> > +	if (offset < size) /* linear area */
> > +		goto out;
> > +
> > +	offset -=3D size;
> > +	for (i =3D 0; i < sinfo->nr_frags; i++) { /* paged area */
> > +		u32 frag_size =3D skb_frag_size(&sinfo->frags[i]);
> > +
> > +		if  (offset < frag_size) {
> > +			addr =3D skb_frag_address(&sinfo->frags[i]);
> > +			size =3D frag_size;
> > +			break;
> > +		}
> > +		offset -=3D frag_size;
> > +	}
> > +
> > +out:
> > +	if (offset + len < size)
> > +		return addr + offset; /* fast path - no need to copy */
> > +
> > +	if (!buf) /* no copy to the bounce buffer */
> > +		return NULL;
> > +
> > +	/* slow path - we need to copy data into the bounce buffer */
> > +	bpf_xdp_copy_buf(xdp, offset, len, buf, false);
> > +	return buf;
> > +}
> > +
> > +BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
> > +	   void *, buf, u32, len)
> > +{
> > +	void *ptr;
> > +
> > +	ptr =3D bpf_xdp_pointer(xdp, offset, len, buf);
> > +	if (IS_ERR(ptr))
> > +		return PTR_ERR(ptr);
> > +
> > +	if (ptr !=3D buf)
> > +		memcpy(buf, ptr, len);
>=20
> Maybe we should just call out to bpf_xdp_copy_buf() like store does
> instead of putting one but not the other inside bpf_xdp_pointer().
>=20
> We'll have to refactor this later for the real bpf_xdp_pointer,
> I'd lean on the side of keeping things symmetric for now.

ack, I agree. I will move bpf_xdp_copy_buf out of bpf_xdp_pointer so
bpf_xdp_load_bytes and bpf_xdp_store_bytes are symmetric

Regards,
Lorenzo

>=20
> > +	return 0;
> > +}
>=20
> > +BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
> > +	   void *, buf, u32, len)
> > +{
> > +	void *ptr;
> > +
> > +	ptr =3D bpf_xdp_pointer(xdp, offset, len, NULL);
> > +	if (IS_ERR(ptr))
> > +		return PTR_ERR(ptr);
> > +
> > +	if (!ptr)
> > +		bpf_xdp_copy_buf(xdp, offset, len, buf, true);
> > +	else
> > +		memcpy(ptr, buf, len);
> > +
> > +	return 0;
> > +}

--AsmBTGevGnjm9UDq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYYlU6QAKCRA6cBh0uS2t
rFAMAP92t9LG0vTYodP+rXQUqVeJAeMc9n6cpaGDoC66nP+upgEA7eyee7VN6s1W
BrLDuyz08ws7DZ2BJQ01vtAs0uDx6g4=
=+z/b
-----END PGP SIGNATURE-----

--AsmBTGevGnjm9UDq--
