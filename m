Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0BE25D55D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgIDJpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgIDJpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 05:45:17 -0400
Received: from localhost (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 646B3205CB;
        Fri,  4 Sep 2020 09:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599212715;
        bh=eV8Ipkwk3+4mbuzfq3gBkEaHg5C2oCXHr3qcDkPPmr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W+dVRa4vunSw1HFs83Lbi5bK4Rlf0A37Dj2m72BHN5zy4Fok3eLcHLus8jY8H7zT/
         /eXZPOYyhTTkPNfoxs4UT9nWAhllInKcNVBmH1XxSzYinOmRJj8jgSosJbKpTiWAAt
         caP6kh7uV0Z6VFT8jQ3uV3Av+3rS8vG5jgt+uaYg=
Date:   Fri, 4 Sep 2020 11:45:11 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        edumazet@google.com
Subject: Re: [PATCH v2 net-next 6/9] bpf: helpers: add
 bpf_xdp_adjust_mb_header helper
Message-ID: <20200904094511.GF2884@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
 <5f51e2f2eb22_3eceb20837@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dWYAkE0V1FpFQHQ3"
Content-Disposition: inline
In-Reply-To: <5f51e2f2eb22_3eceb20837@john-XPS-13-9370.notmuch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dWYAkE0V1FpFQHQ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > Introduce bpf_xdp_adjust_mb_header helper in order to adjust frame
> > headers moving *offset* bytes from/to the second buffer to/from the
> > first one.
> > This helper can be used to move headers when the hw DMA SG is not able
> > to copy all the headers in the first fragment and split header and data
> > pages.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/uapi/linux/bpf.h       | 25 ++++++++++++----
> >  net/core/filter.c              | 54 ++++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h | 26 ++++++++++++----
> >  3 files changed, 95 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 8dda13880957..c4a6d245619c 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3571,11 +3571,25 @@ union bpf_attr {
> >   *		value.
> >   *
> >   * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
> > - * 	Description
> > - * 		Read *size* bytes from user space address *user_ptr* and store
> > - * 		the data in *dst*. This is a wrapper of copy_from_user().
> > - * 	Return
> > - * 		0 on success, or a negative error in case of failure.
> > + *	Description
> > + *		Read *size* bytes from user space address *user_ptr* and store
> > + *		the data in *dst*. This is a wrapper of copy_from_user().
> > + *
> > + * long bpf_xdp_adjust_mb_header(struct xdp_buff *xdp_md, int offset)
> > + *	Description
> > + *		Adjust frame headers moving *offset* bytes from/to the second
> > + *		buffer to/from the first one. This helper can be used to move
> > + *		headers when the hw DMA SG does not copy all the headers in
> > + *		the first fragment.

+ Eric to the discussion

>=20
> This is confusing to read. Does this mean I can "move bytes to the second
> buffer from the first one" or "move bytes from the second buffer to the f=
irst
> one" And what are frame headers? I'm sure I can read below code and work
> it out, but users reading the header file should be able to parse this.

Our main goal with this helper is to fix the use-case where we request the =
hw
to put L2/L3/L4 headers (and all the TCP options) in the first fragment and=
 TCP
data starting from the second fragment (headers split) but for some reasons
the hw puts the TCP options in the second fragment (if we understood correc=
tly
this issue has been introduced by Eric @ NetDevConf 0x14).
bpf_xdp_adjust_mb_header() can fix this use-case moving bytes from the seco=
nd fragment
to the first one (offset > 0) or from the first buffer to the second one (o=
ffset < 0).

>=20
> Also we want to be able to read all data not just headers. Reading the
> payload of a TCP packet is equally important for many l7 load balancers.
>=20

In order to avoid to slow down performances we require that eBPF sandbox can
read/write only buff0 in a xdp multi-buffer. The xdp program can only
perform some restricted changes to buff<n> (n >=3D 1) (e.g. what we did in
bpf_xdp_adjust_mb_header()).
You can find the xdp multi-buff design principles here [0][1]

[0] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-m=
ulti-buffer01-design.org
[1] http://people.redhat.com/lbiancon/conference/NetDevConf2020-0x14/add-xd=
p-on-driver.html - XDP multi-buffers section (slide 40)

> > + *
> > + *		A call to this helper is susceptible to change the underlying
> > + *		packet buffer. Therefore, at load time, all checks on pointers
> > + *		previously done by the verifier are invalidated and must be
> > + *		performed again, if the helper is used in combination with
> > + *		direct packet access.
> > + *
> > + *	Return
> > + *		0 on success, or a negative error in case of failure.
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)		\
> >  	FN(unspec),			\
> > @@ -3727,6 +3741,7 @@ union bpf_attr {
> >  	FN(inode_storage_delete),	\
> >  	FN(d_path),			\
> >  	FN(copy_from_user),		\
> > +	FN(xdp_adjust_mb_header),	\
> >  	/* */
> > =20
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which =
helper
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 47eef9a0be6a..ae6b10cf062d 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3475,6 +3475,57 @@ static const struct bpf_func_proto bpf_xdp_adjus=
t_head_proto =3D {
> >  	.arg2_type	=3D ARG_ANYTHING,
> >  };
> > =20
> > +BPF_CALL_2(bpf_xdp_adjust_mb_header, struct  xdp_buff *, xdp,
> > +	   int, offset)
> > +{
> > +	void *data_hard_end, *data_end;
> > +	struct skb_shared_info *sinfo;
> > +	int frag_offset, frag_len;
> > +	u8 *addr;
> > +
> > +	if (!xdp->mb)
> > +		return -EOPNOTSUPP;
> > +
> > +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +
> > +	frag_len =3D skb_frag_size(&sinfo->frags[0]);
> > +	if (offset > frag_len)
> > +		return -EINVAL;
>=20
> What if we want data in frags[1] and so on.
>=20
> > +
> > +	frag_offset =3D skb_frag_off(&sinfo->frags[0]);
> > +	data_end =3D xdp->data_end + offset;
> > +
> > +	if (offset < 0 && (-offset > frag_offset ||
> > +			   data_end < xdp->data + ETH_HLEN))
> > +		return -EINVAL;
> > +
> > +	data_hard_end =3D xdp_data_hard_end(xdp); /* use xdp->frame_sz */
> > +	if (data_end > data_hard_end)
> > +		return -EINVAL;
> > +
> > +	addr =3D page_address(skb_frag_page(&sinfo->frags[0])) + frag_offset;
> > +	if (offset > 0) {
> > +		memcpy(xdp->data_end, addr, offset);
>=20
> But this could get expensive for large amount of data? And also
> limiting because we require the room to do the copy. Presumably
> the reason we have fargs[1] is because the normal page or half
> page is in use?
>=20
> > +	} else {
> > +		memcpy(addr + offset, xdp->data_end + offset, -offset);
> > +		memset(xdp->data_end + offset, 0, -offset);
> > +	}
> > +
> > +	skb_frag_size_sub(&sinfo->frags[0], offset);
> > +	skb_frag_off_add(&sinfo->frags[0], offset);
> > +	xdp->data_end =3D data_end;
> > +
> > +	return 0;
> > +}
>=20
> So overall I don't see the point of copying bytes from one frag to
> another. Create an API that adjusts the data pointers and then
> copies are avoided and manipulating frags is not needed.

please see above.

>=20
> Also and even more concerning I think this API requires the
> driver to populate shinfo. If we use TX_REDIRECT a lot or TX_XMIT
> this means we need to populate shinfo when its probably not ever
> used. If our driver is smart L2/L3 headers are in the readable
> data and prefetched. Writing frags into the end of a page is likely
> not free.

Sorry I did not get what you mean with "populate shinfo" here. We need to
properly set shared_info in order to create the xdp multi-buff.
Apart of header splits, please consider the main uses-cases for
xdp multi-buff are XDP with TSO and Jumbo frames.

>=20
> Did you benchmark this?

will do, I need to understand if we can use tiny buffers in mvneta.

>=20
> In general users of this API should know the bytes they want
> to fetch. Use an API like this,
>=20
>   bpf_xdp_adjust_bytes(xdp, start, end)
>=20
> Where xdp is the frame, start is the first byte the user wants
> and end is the last byte. Then usually you can skip the entire
> copy part and just move the xdp pointesr around. The ugly case
> is if the user puts start/end across a frag boundary and a copy
> is needed. In that case maybe we use end as a hint and not a
> hard requirement.
>=20
> The use case I see is I read L2/L3/L4 headers and I need the
> first N bytes of the payload. I know where the payload starts
> and I know how many bytes I need so,
>=20
>   bpf_xdp_adjust_bytes(xdp, payload_offset, bytes_needed);
>=20
> Then hopefully that is all in one frag. If its not I'll need
> to do a second helper call. Still nicer than forcing drivers
> to populate this shinfo I think. If you think I'm wrong try
> a benchmark. Benchmarks aside I get stuck when data_end and
> data_hard_end are too close together.

IIUC what you mean here is to expose L2/L3/L4 headers + some data to
the ebpf program to perform like L7 load-balancing, right?
Let's consider the Jumbo frames use-case (so the data are split in multiple
buffers). I can see to issues here:
- since in XDP we can't linearize the buffer if start and end are on the
  different pages (like we do in bpf_msg_pull_data()), are we ending up
  in the case where requested data are all in buff0?=20
- if  start and end are in buff<2>, we should report the fragment number to=
 the
  ebpf program to "fetch" the data. Are we exposing too low-level details to
  user-space?

Regards,
Lorenzo

>=20
> Thanks,
> John

--dWYAkE0V1FpFQHQ3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX1IMowAKCRA6cBh0uS2t
rF2/AQCiU4TwSomsa7PoMTx8H+zjYUkyJ9QchZqPdn4NA4dYdQEA43nXUwz2Tcm0
5yfO2mWAmom240NI3L+zjmCgnTeRlA4=
=sZ+T
-----END PGP SIGNATURE-----

--dWYAkE0V1FpFQHQ3--
