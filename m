Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686B2453D0B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 01:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhKQAPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 19:15:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhKQAPm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 19:15:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BA8261A7D;
        Wed, 17 Nov 2021 00:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637107964;
        bh=bnxLxXhbTIGvV08pkQI2uRDy+1S2Cvb0CnyBspITtFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tqcCwoCqHG81hXrszQlfop41TQ6qJ4jcv9+r/UfjNiDqugsgejMicyxBEj2z55N5Q
         z9+wgTBO/wCnJikknShXCENmCUe+Cyb7wSd/jxEk/6CNOeU1Gvi3HxcNVIa8ZLjO98
         3uDPMDSrEqoR4AaCr1dlcLnelkjAIqPteCWFyfgV0c2M23BC6enHe/aZgOmczT9DuS
         oaU6CzsnFnU1MJdvwWcnnrGSSJ35bqk4KGaL5QreJdcQlNsJ5qB9Dd2s5bJ9UhnpW/
         REfbAvKaWPamQGYGwpvUF4HxVE9Zt4F1Z1F0PB2hn3rw0/caQldpqtJxh9pZGah4kw
         uKdO2zRshCX/g==
Date:   Wed, 17 Nov 2021 01:12:41 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v18 bpf-next 20/23] net: xdp: introduce bpf_xdp_pointer
 utility routine
Message-ID: <YZRI+ac4c0j/eue5@lore-desk>
References: <cover.1637013639.git.lorenzo@kernel.org>
 <ce5ad30af8f9b4d2b8128e7488818449a5c0d833.1637013639.git.lorenzo@kernel.org>
 <20211116071357.36c18edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TrINBws+5W8mkGW0"
Content-Disposition: inline
In-Reply-To: <20211116071357.36c18edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--TrINBws+5W8mkGW0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 15 Nov 2021 23:33:14 +0100 Lorenzo Bianconi wrote:
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	u32 headsize =3D xdp->data_end - xdp->data;
> > +	u32 count =3D 0, frame_offset =3D headsize;
> > +	int i;
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
>=20
> is this missing
> 	else
> 		offset -=3D headsize;
> ?
>=20
> I'm struggling to understand this. Say
> 	headsize =3D 400
> 	frag[0].size =3D 200
>=20
> 	offset =3D 500
> 	len =3D 50
>=20
> we enter the loop having missed the previous if...
>=20
> > +	for (i =3D 0; i < sinfo->nr_frags; i++) {
> > +		skb_frag_t *frag =3D &sinfo->frags[i];
> > +		u32 frag_size =3D skb_frag_size(frag);
> > +
> > +		if (count >=3D len)
> > +			break;
> > +
> > +		if (offset < frame_offset + frag_size) {
>=20
> 		500 < 400 + 200 =3D> true
>=20
> > +			int size =3D min_t(int, frag_size - offset, len - count);
>=20
> 			size =3D min(200 - 500, 50 - 0)
> 			size =3D -300 ??

ack, you are right. Sorry for the issue.
I did not trigger the problem with xdp-mb self-tests since we will not run
bpf_xdp_copy_buf() in this specific case, but just the memcpy()
(but what you reported is a bug and must be fixed). I will add more
self-tests.
Moreover, reviewing the code I guess we can just update bpf_xdp_copy() for =
our case.
Something like:

static void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
			     void *buf, unsigned long len, bool flush)
{
	unsigned long ptr_len, ptr_off =3D 0;
	skb_frag_t *next_frag, *end_frag;
	struct skb_shared_info *sinfo;
	void *src, *dst;
	u8 *ptr_buf;

	if (likely(xdp->data_end - xdp->data >=3D off + len)) {
		src =3D flush ? buf : xdp->data + off;
		dst =3D flush ? xdp->data + off : buf;
		memcpy(dst, src, len);
		return;
	}

	sinfo =3D xdp_get_shared_info_from_buff(xdp);
	end_frag =3D &sinfo->frags[sinfo->nr_frags];
	next_frag =3D &sinfo->frags[0];

	ptr_len =3D xdp->data_end - xdp->data;
	ptr_buf =3D xdp->data;

	while (true) {
		if (off < ptr_off + ptr_len) {
			unsigned long copy_off =3D off - ptr_off;
			unsigned long copy_len =3D min(len, ptr_len - copy_off);

			src =3D flush ? buf : ptr_buf + copy_off;
			dst =3D flush ? ptr_buf + copy_off : buf;
			memcpy(dst, src, copy_len);

			off +=3D copy_len;
			len -=3D copy_len;
			buf +=3D copy_len;
		}

		if (!len || next_frag =3D=3D end_frag)
			break;

		ptr_off +=3D ptr_len;
		ptr_buf =3D skb_frag_address(next_frag);
		ptr_len =3D skb_frag_size(next_frag);
		next_frag++;
	}
}

=2E..

static unsigned long bpf_xdp_copy(void *dst, const void *ctx,
				  unsigned long off, unsigned long len)
{
	struct xdp_buff *xdp =3D (struct xdp_buff *)ctx;

	bpf_xdp_copy_buf(xdp, off, dst, len, false);
	return 0;
}

What do you think?

Regards,
Lorenzo


>=20
> > +			void *addr =3D skb_frag_address(frag);
> > +			void *src =3D flush ? buf + count : addr + offset;
> > +			void *dst =3D flush ? addr + offset : buf + count;
> > +
> > +			memcpy(dst, src, size);
> > +			count +=3D size;
> > +			offset =3D 0;
> > +		}
> > +		frame_offset +=3D frag_size;

--TrINBws+5W8mkGW0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYZRI+QAKCRA6cBh0uS2t
rA1KAQC0qvrK2dx8H1heh+zjVq02R9Jx+GP8qtGLeUrlJs9HCQD/Ze6+i31A7sPZ
Nx3kP6SD6vmetGa7P5aK7WMuNcseFw8=
=lUF4
-----END PGP SIGNATURE-----

--TrINBws+5W8mkGW0--
