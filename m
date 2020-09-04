Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0464525D568
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbgIDJsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgIDJsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 05:48:05 -0400
Received: from localhost (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B095A205CB;
        Fri,  4 Sep 2020 09:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599212884;
        bh=UxtsNCTGV9LM9SYs+5UCasbtdRIZ31+B+J0jaRcmsvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Aiq303Naf5QaWqyb+A49cQgYjREBgl0TTXZw0XdWQj5jfwF2EN8Iv64j/6g4YqPzD
         +K5oLfoZVJLIPGjNPGTzAF1dhcFNC9pG+a7CQPHkPQYuc9+ww+NKCSMKbld5qnUPQd
         /KHUV+QMk9w9ZvGMLPZYTr3T8BzyeVY1eeK44mQs=
Date:   Fri, 4 Sep 2020 11:47:59 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: Re: [PATCH v2 net-next 7/9] bpf: helpers: add multibuffer support
Message-ID: <20200904094759.GG2884@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <e7da15edf4c152e1803b76638373527c292ee04b.1599165031.git.lorenzo@kernel.org>
 <20200903212409.GA14273@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="df+09Je9rNq3P+GE"
Content-Disposition: inline
In-Reply-To: <20200903212409.GA14273@ranger.igk.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Sep 03, 2020 at 10:58:51PM +0200, Lorenzo Bianconi wrote:
> > From: Sameeh Jubran <sameehj@amazon.com>
> >=20
> > The implementation is based on this [0] draft by Jesper D. Brouer.
> >=20
> > Provided two new helpers:
> >=20
> > * bpf_xdp_get_frag_count()
> > * bpf_xdp_get_frags_total_size()
> >=20
> > [0] xdp mb design - https://github.com/xdp-project/xdp-project/blob/mas=
ter/areas/core/xdp-multi-buffer01-design.org
> > Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/uapi/linux/bpf.h       | 14 ++++++++++++
> >  net/core/filter.c              | 39 ++++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h | 14 ++++++++++++
> >  3 files changed, 67 insertions(+)
> >=20
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index c4a6d245619c..53db75095306 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3590,6 +3590,18 @@ union bpf_attr {
> >   *
> >   *	Return
> >   *		0 on success, or a negative error in case of failure.

[...]

> > +
>=20
> I only quickly jumped through series and IMHO this helper should be
> rewritten/optimized in a way that we bail out as early as possible if
> !xdp->mb as the rest of the code on that condition will do nothing and i'm
> not sure if compiler would optimize it.
>=20
>=20
> 	struct skb_shared_info *sinfo;
> 	int nfrags, i;
> 	int size =3D 0;
>=20
> 	if (!xdp->mb)
> 		return 0;
>=20
> 	sinfo =3D xdp_get_shared_info_from_buff(xdp);
>=20
> 	nfrags =3D min(sinfo->nr_frags, MAX_SKB_FRAGS);
>=20
> 	for (i =3D 0; i < nfrags; i++)
> 		size +=3D skb_frag_size(&sinfo->frags[i]);
>=20
> 	return size;
>=20
> Thoughts?

I agree.

Regards,
Lorenzo

>=20
>=20
> > +	return size;
> > +}
> > +
> > +const struct bpf_func_proto bpf_xdp_get_frags_total_size_proto =3D {
> > +	.func		=3D bpf_xdp_get_frags_total_size,
> > +	.gpl_only	=3D false,
> > +	.ret_type	=3D RET_INTEGER,
> > +	.arg1_type	=3D ARG_PTR_TO_CTX,
> > +};
> > +
> >  BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
> >  {
> >  	void *data_hard_end =3D xdp_data_hard_end(xdp); /* use xdp->frame_sz =
*/
> > @@ -6889,6 +6924,10 @@ xdp_func_proto(enum bpf_func_id func_id, const s=
truct bpf_prog *prog)
> >  		return &bpf_xdp_adjust_tail_proto;
> >  	case BPF_FUNC_xdp_adjust_mb_header:
> >  		return &bpf_xdp_adjust_mb_header_proto;
> > +	case BPF_FUNC_xdp_get_frag_count:
> > +		return &bpf_xdp_get_frag_count_proto;
> > +	case BPF_FUNC_xdp_get_frags_total_size:
> > +		return &bpf_xdp_get_frags_total_size_proto;
> >  	case BPF_FUNC_fib_lookup:
> >  		return &bpf_xdp_fib_lookup_proto;
> >  #ifdef CONFIG_INET
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/=
bpf.h
> > index 392d52a2ecef..dd4669096cbb 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -3591,6 +3591,18 @@ union bpf_attr {
> >   *
> >   *	Return
> >   *		0 on success, or a negative error in case of failure.
> > + *
> > + * int bpf_xdp_get_frag_count(struct xdp_buff *xdp_md)
> > + *	Description
> > + *		Get the total number of frags for a given packet.
> > + *	Return
> > + *		The number of frags
> > + *
> > + * int bpf_xdp_get_frags_total_size(struct xdp_buff *xdp_md)
> > + *	Description
> > + *		Get the total size of frags for a given packet.
> > + *	Return
> > + *		The total size of frags for a given packet.
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)		\
> >  	FN(unspec),			\
> > @@ -3743,6 +3755,8 @@ union bpf_attr {
> >  	FN(d_path),			\
> >  	FN(copy_from_user),		\
> >  	FN(xdp_adjust_mb_header),	\
> > +	FN(xdp_get_frag_count),		\
> > +	FN(xdp_get_frags_total_size),	\
> >  	/* */
> > =20
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which =
helper
> > --=20
> > 2.26.2
> >=20

--df+09Je9rNq3P+GE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX1INTQAKCRA6cBh0uS2t
rHVjAP97WAiKfNSRihipCxtzlGTYWjC18+xo04yjbI/bai0swgEAjUbis8dAFtIn
iwwFA2s5UwQp004/iE5OxM+kcwRZwQE=
=bcjl
-----END PGP SIGNATURE-----

--df+09Je9rNq3P+GE--
