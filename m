Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287F435A28B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhDIQDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhDIQDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:03:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FBA1610E5;
        Fri,  9 Apr 2021 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617984216;
        bh=7/81Y+myzymuyO2hy7z8DMdky9J4N0s66QO8qQAh754=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JBMIYY2b2DO1T0+k68Bc9iXc8XTPIveGRdK/m8o1eliNFnGMT/erwLTYKeXCMc/aj
         6Kdy6HaARr5KJNWGh7s81CbAa9/mUxRLi1UIsMQCRplDwJunbABIR/cw2cZd/1zzJZ
         Z88EKLRJkl23J5BpCHgNp8Yb8T2va348u7iWnzPzP2epvqBEkZMuDVny8HHg4P9d9U
         lnLo/piHpAgmhFxLC4bVN4p37TXCOcuf2yx3Igo9HFCDigTRGk6oyCZlc159zrJ9lB
         8XQ2Cqrhz51rwUC6GZAomt+OUkiD0x5bu0hB3paz66CUlIMlKHthfUskUvrTXFmvP8
         z3No+IhApSyIw==
Date:   Fri, 9 Apr 2021 18:03:31 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 01/14] xdp: introduce mb in xdp_buff/xdp_frame
Message-ID: <YHB60776godABPej@lore-desk>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <eef58418ab78408f4a5fbd3d3b0071f30ece2ccd.1617885385.git.lorenzo@kernel.org>
 <20210408181700.vlay72gyxzknfc7m@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r0EKIoESLXm69aJt"
Content-Disposition: inline
In-Reply-To: <20210408181700.vlay72gyxzknfc7m@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--r0EKIoESLXm69aJt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Apr 08, 2021 at 02:50:53PM +0200, Lorenzo Bianconi wrote:
> > Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer data structure
> > in order to specify if this is a linear buffer (mb =3D 0) or a multi-bu=
ffer
> > frame (mb =3D 1). In the latter case the shared_info area at the end of=
 the
> > first buffer will be properly initialized to link together subsequent
> > buffers.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/net/xdp.h | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index a5bc214a49d9..842580a61563 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -73,7 +73,10 @@ struct xdp_buff {
> >  	void *data_hard_start;
> >  	struct xdp_rxq_info *rxq;
> >  	struct xdp_txq_info *txq;
> > -	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom=
*/
> > +	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved
> > +			  * tailroom
> > +			  */
>=20
> This comment would have fit just fine on one line:
>=20
> 	/* frame size to deduce data_hard_end/reserved tailroom */

ack, thx I will fix it in v9

Regards,
Lorenzo

>=20
> > +	u32 mb:1; /* xdp non-linear buffer */
> >  };
> > =20
> >  static __always_inline void
> > @@ -81,6 +84,7 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, str=
uct xdp_rxq_info *rxq)
> >  {
> >  	xdp->frame_sz =3D frame_sz;
> >  	xdp->rxq =3D rxq;
> > +	xdp->mb =3D 0;
> >  }
> > =20
> >  static __always_inline void
> > @@ -116,7 +120,8 @@ struct xdp_frame {
> >  	u16 len;
> >  	u16 headroom;
> >  	u32 metasize:8;
> > -	u32 frame_sz:24;
> > +	u32 frame_sz:23;
> > +	u32 mb:1; /* xdp non-linear frame */
> >  	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
> >  	 * while mem info is valid on remote CPU.
> >  	 */
> > @@ -179,6 +184,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *fr=
ame, struct xdp_buff *xdp)
> >  	xdp->data_end =3D frame->data + frame->len;
> >  	xdp->data_meta =3D frame->data - frame->metasize;
> >  	xdp->frame_sz =3D frame->frame_sz;
> > +	xdp->mb =3D frame->mb;
> >  }
> > =20
> >  static inline
> > @@ -205,6 +211,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
> >  	xdp_frame->headroom =3D headroom - sizeof(*xdp_frame);
> >  	xdp_frame->metasize =3D metasize;
> >  	xdp_frame->frame_sz =3D xdp->frame_sz;
> > +	xdp_frame->mb =3D xdp->mb;
> > =20
> >  	return 0;
> >  }
> > --=20
> > 2.30.2
> >=20

--r0EKIoESLXm69aJt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYHB60QAKCRA6cBh0uS2t
rC2XAPsG70xItN8SfwYYBqOjYqMc7Fl/kPqW/bFsy5ytxLXCrAEApbcEjenpX+Ag
Q46MoI+m8wzDRCdsVyxH5kDVlgMQlQs=
=M0PZ
-----END PGP SIGNATURE-----

--r0EKIoESLXm69aJt--
