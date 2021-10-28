Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918BA43DDB5
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 11:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhJ1J2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 05:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhJ1J2b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 05:28:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E48F1610CB;
        Thu, 28 Oct 2021 09:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635413164;
        bh=qPMj5+ibTS+mDVdAFv5psLuDLcC2AQaOow2YgmTIKRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m1fj1TEote5YsyoBOJ+yp+JTs+WCMJTeZ5SNQgyrseZ/uej9Ziss1iZzYTgwNPYT7
         lkhI8v18TPHBjOiCW/zrKQmQQNod4yacX08IpcbqhwY8gC/C7zJ6gvMph/jAAp0u/M
         RgZUsrYSYN2GyXZRgG8cmg2MDyHqcyIU2atxMeeHZrDZbgzksdayXp2SWN68aL4WGS
         +YYN5qIiO0i2Z3OPgauf6IWWUUBT31w3HwIqQ3J0iIgWqTyHuCUImsLNxAOO4clS7F
         nGP/A1CQMK93A7f4Dc81kGp+2kxaM/Y1ItV5YoWdk/jCJQKyhRK51Bi2XDAz/sH7tV
         tWHpRJwkODjdA==
Date:   Thu, 28 Oct 2021 11:26:00 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v16 bpf-next 19/20] net: xdp: introduce bpf_xdp_pointer
 utility routine
Message-ID: <YXpsqMZ1PYwtO+2W@lore-desk>
References: <cover.1634301224.git.lorenzo@kernel.org>
 <98e60294b7ba81ca647cffd4d7b87617e9b1e9d9.1634301224.git.lorenzo@kernel.org>
 <3d196d1d-69f3-0ff2-1752-f318defbbf33@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lhclgtT3vdc2tvZp"
Content-Disposition: inline
In-Reply-To: <3d196d1d-69f3-0ff2-1752-f318defbbf33@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lhclgtT3vdc2tvZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 10/15/21 3:08 PM, Lorenzo Bianconi wrote:
> [...]
> > +static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset,
> > +			     u32 len, void *buf)
> > +{
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	u32 size =3D xdp->data_end - xdp->data;
> > +	void *addr =3D xdp->data;
> > +	u32 frame_sz =3D size;
> > +	int i;
> > +
> > +	if (xdp_buff_is_mb(xdp))
> > +		frame_sz +=3D sinfo->xdp_frags_size;
> > +
> > +	if (offset + len > frame_sz)
> > +		return ERR_PTR(-EINVAL);
>=20
> Given offset is ARG_ANYTHING, the above could overflow. In bpf_skb_*_byte=
s() we
> guard with offset > 0xffff.

ack, I will fix it in v17

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
> > +	if (ptr =3D=3D ERR_PTR(-EINVAL))
> > +		return -EINVAL;
>=20
> nit + same below in *_store_bytes(): IS_ERR(ptr) return PTR_ERR(ptr); ? (=
Or
> should we just return -EFAULT to make it analog to bpf_skb_{load,store}_b=
ytes()?
> Either is okay, imho.)

ack, I will fix it in v17

>=20
> > +	if (ptr !=3D buf)
> > +		memcpy(buf, ptr, len);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct bpf_func_proto bpf_xdp_load_bytes_proto =3D {
> > +	.func		=3D bpf_xdp_load_bytes,
> > +	.gpl_only	=3D false,
> > +	.ret_type	=3D RET_INTEGER,
> > +	.arg1_type	=3D ARG_PTR_TO_CTX,
> > +	.arg2_type	=3D ARG_ANYTHING,
> > +	.arg3_type	=3D ARG_PTR_TO_MEM,
>=20
> ARG_PTR_TO_UNINIT_MEM, or do you need the dst buffer to be initialized?

no, I think it is ok, I will fix it in v17.

>=20
> > +	.arg4_type	=3D ARG_CONST_SIZE_OR_ZERO,
>=20
> ARG_CONST_SIZE

ack, I will fix it in v17

>=20
> > +};
> > +
> > +BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
> > +	   void *, buf, u32, len)
> > +{
> > +	void *ptr;
> > +
> > +	ptr =3D bpf_xdp_pointer(xdp, offset, len, NULL);
> > +	if (ptr =3D=3D ERR_PTR(-EINVAL))
> > +		return -EINVAL;
> > +
> > +	if (!ptr)
> > +		bpf_xdp_copy_buf(xdp, offset, len, buf, true);
> > +	else
> > +		memcpy(ptr, buf, len);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct bpf_func_proto bpf_xdp_store_bytes_proto =3D {
> > +	.func		=3D bpf_xdp_store_bytes,
> > +	.gpl_only	=3D false,
> > +	.ret_type	=3D RET_INTEGER,
> > +	.arg1_type	=3D ARG_PTR_TO_CTX,
> > +	.arg2_type	=3D ARG_ANYTHING,
> > +	.arg3_type	=3D ARG_PTR_TO_MEM,
> > +	.arg4_type	=3D ARG_CONST_SIZE_OR_ZERO,
>=20
> ARG_CONST_SIZE, or do you have a use case for bpf_xdp_store_bytes(..., bu=
f, 0)?

ack, I think we do not need it. I will fix it in v17

Regards,
Lorenzo

>=20
> > +};
> > +
> >   static int bpf_xdp_mb_increase_tail(struct xdp_buff *xdp, int offset)
> >   {
> >   	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > @@ -7619,6 +7749,10 @@ xdp_func_proto(enum bpf_func_id func_id, const s=
truct bpf_prog *prog)
> >   		return &bpf_xdp_adjust_tail_proto;
> >   	case BPF_FUNC_xdp_get_buff_len:
> >   		return &bpf_xdp_get_buff_len_proto;
> > +	case BPF_FUNC_xdp_load_bytes:
> > +		return &bpf_xdp_load_bytes_proto;
> > +	case BPF_FUNC_xdp_store_bytes:
> > +		return &bpf_xdp_store_bytes_proto;
> >   	case BPF_FUNC_fib_lookup:
> >   		return &bpf_xdp_fib_lookup_proto;
> >   	case BPF_FUNC_check_mtu:
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/=
bpf.h
> > index 1cb992ec0cc8..dad1d8c3a4c1 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -4920,6 +4920,22 @@ union bpf_attr {
> >    *		Get the total size of a given xdp buff (linear and paged area)
> >    *	Return
> >    *		The total size of a given xdp buffer.
> > + *
> > + * long bpf_xdp_load_bytes(struct xdp_buff *xdp_md, u32 offset, void *=
buf, u32 len)
> > + *	Description
> > + *		This helper is provided as an easy way to load data from a
> > + *		xdp buffer. It can be used to load *len* bytes from *offset* from
> > + *		the frame associated to *xdp_md*, into the buffer pointed by
> > + *		*buf*.
> > + *	Return
> > + *		0 on success, or a negative error in case of failure.
> > + *
> > + * long bpf_xdp_store_bytes(struct xdp_buff *xdp_md, u32 offset, void =
*buf, u32 len)
> > + *	Description
> > + *		Store *len* bytes from buffer *buf* into the frame
> > + *		associated to *xdp_md*, at *offset*.
> > + *	Return
> > + *		0 on success, or a negative error in case of failure.
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)		\
> >   	FN(unspec),			\
> > @@ -5101,6 +5117,8 @@ union bpf_attr {
> >   	FN(get_branch_snapshot),	\
> >   	FN(trace_vprintk),		\
> >   	FN(xdp_get_buff_len),		\
> > +	FN(xdp_load_bytes),		\
> > +	FN(xdp_store_bytes),		\
> >   	/* */
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which=
 helper
> >=20
>=20

--lhclgtT3vdc2tvZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYXpsqAAKCRA6cBh0uS2t
rFNxAQCWMR3y/DKVXXA5OQIg7irvdEP9cZvCKYj3TIgfzZOXBgD/b7gp7qX0ytfq
Yrco9KcQzQdOZwJm+lVZHmZA6j08TAQ=
=tY3A
-----END PGP SIGNATURE-----

--lhclgtT3vdc2tvZp--
