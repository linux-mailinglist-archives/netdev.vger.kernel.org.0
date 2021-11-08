Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94B8449C2E
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 20:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbhKHTJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 14:09:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236573AbhKHTJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 14:09:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B41461181;
        Mon,  8 Nov 2021 19:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636398403;
        bh=pd0VCkggWE2iPh69ltI+nfP+BwOWPf0TnwVTYOnczxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mriAKXRtWZh1jXLC2uP+eja0pXUzB9G5zjA5vLhVJ8SyqzH1IjeDtTsBSxwOR2+jp
         AZfhTfbmhCagYiki6W4AF45i1uwsWpBIg9WepFU3GuBIJAImdADV2mjcCEgTW3IfPO
         0xYbjh7tWWwbE1LsHhAoiKm7Gzh8U7x9UM5HVgP6SgIpwj/YYtnk8d8urzF85Sw9bm
         8wOKEGFIaD2DkAY3QUG5gzpa9o7t0xbtxA86CQA/Kj2nP/vRCmQkeROlIdBVYiawJf
         fsIXeX6bPwy8GxV71G7tzQ5salX7DwYS/YzzOme/jO0qO4Bm+4e2p0bFRz9c5Ht2Bm
         NFEJXFpEiIrvw==
Date:   Mon, 8 Nov 2021 20:06:39 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v17 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <YYl1P+nPSuMjI+e6@lore-desk>
References: <cover.1636044387.git.lorenzo@kernel.org>
 <fd0400802295a87a921ba95d880ad27b9f9b8636.1636044387.git.lorenzo@kernel.org>
 <20211105162941.46b807e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlWcuUwcKGYtWAR@lore-desk>
 <87fss6r058.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="p3KXfLdNpNEkKsaf"
Content-Disposition: inline
In-Reply-To: <87fss6r058.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--p3KXfLdNpNEkKsaf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20
> >> On Thu,  4 Nov 2021 18:35:32 +0100 Lorenzo Bianconi wrote:
> >> > This change adds support for tail growing and shrinking for XDP mult=
i-buff.
> >> >=20
> >> > When called on a multi-buffer packet with a grow request, it will al=
ways
> >> > work on the last fragment of the packet. So the maximum grow size is=
 the
> >> > last fragments tailroom, i.e. no new buffer will be allocated.
> >> >=20
> >> > When shrinking, it will work from the last fragment, all the way dow=
n to
> >> > the base buffer depending on the shrinking size. It's important to m=
ention
> >> > that once you shrink down the fragment(s) are freed, so you can not =
grow
> >> > again to the original size.
> >>=20
> >> > +static int bpf_xdp_mb_increase_tail(struct xdp_buff *xdp, int offse=
t)
> >> > +{
> >> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xd=
p);
> >> > +	skb_frag_t *frag =3D &sinfo->frags[sinfo->nr_frags - 1];
> >> > +	int size, tailroom;
> >> > +
> >> > +	tailroom =3D xdp->frame_sz - skb_frag_size(frag) - skb_frag_off(fr=
ag);
> >>=20
> >> I know I complained about this before but the assumption that we can
> >> use all the space up to xdp->frame_sz makes me uneasy.
> >>=20
> >> Drivers may not expect the idea that core may decide to extend the=20
> >> last frag.. I don't think the skb path would ever do this.
> >>=20
> >> How do you feel about any of these options:=20
> >>  - dropping this part for now (return an error for increase)
> >>  - making this an rxq flag or reading the "reserved frag size"
> >>    from rxq (so that drivers explicitly opt-in)
> >>  - adding a test that can be run on real NICs
> >> ?
> >
> > I think this has been added to be symmetric with bpf_xdp_adjust_tail().
> > I do think there is a real use-case for it so far so I am fine to just
> > support the shrink part.
> >
> > @Eelco, Jesper, Toke: any comments on it?
>=20
> Well, tail adjust is useful for things like encapsulations that need to
> add a trailer. Don't see why that wouldn't be something people would
> want to do for jumboframes as well?
>=20

I agree this would be useful for protocols that add a trailer.

> Not sure I get what the issue is with this either? But having a test
> that can be run to validate this on hardware would be great in any case,
> I suppose - we've been discussing more general "compliance tests" for
> XDP before...

what about option 2? We can add a frag_size field to rxq [0] that is set by
the driver initializing the xdp_buff. frag_size set to 0 means we can use
all the buffer.

Regards,
Lorenzo

[0] pahole -C xdp_rxq_info vmlinux
struct xdp_rxq_info {
	struct net_device *        dev;                  /*     0     8 */
	u32                        queue_index;          /*     8     4 */
	u32                        reg_state;            /*    12     4 */
	struct xdp_mem_info        mem;                  /*    16     8 */
	unsigned int               napi_id;              /*    24     4 */

	/* size: 64, cachelines: 1, members: 5 */
	/* padding: 36 */
} __attribute__((__aligned__(64)));

>=20
> -Toke
>=20

--p3KXfLdNpNEkKsaf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYYl1PwAKCRA6cBh0uS2t
rGnqAQD1pTkY4LULPI8QwzvwJAcHV6GwG9GDqOYZk2vVxzPFNwD+NbfDdSShTSro
XXRWopIZmeepdZVp7zdj/qOZEGkFtAU=
=Kfff
-----END PGP SIGNATURE-----

--p3KXfLdNpNEkKsaf--
