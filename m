Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF6025EDFC
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 15:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgIFNkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 09:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbgIFNgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 09:36:45 -0400
Received: from localhost (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC06620760;
        Sun,  6 Sep 2020 13:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599399382;
        bh=nEloTPaT/0aLose1iS1izcHESMbU05uQXq7UpdamaLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QSGkBpuNAOXNwJvavRTSq38wxv4gy20ysVePUfpZlJ1/y5fETDNbEIH0M9lgVMRYm
         gBDHZJDtj2b8sr6mTZjY95aA1P4YquXbz+F8yUYNkg3oLdUiH0xNZvSyuG0RfU0dPI
         lwGmfo/M/9uD8xRSNk+M+hBphwKUGN+A7o2PveXY=
Date:   Sun, 6 Sep 2020 15:36:17 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        edumazet@google.com
Subject: Re: [PATCH v2 net-next 6/9] bpf: helpers: add
 bpf_xdp_adjust_mb_header helper
Message-ID: <20200906133617.GC2785@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
 <5f51e2f2eb22_3eceb20837@john-XPS-13-9370.notmuch>
 <20200904094511.GF2884@lore-desk>
 <5f525be3da548_1932208b6@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
Content-Disposition: inline
In-Reply-To: <5f525be3da548_1932208b6@john-XPS-13-9370.notmuch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > > Lorenzo Bianconi wrote:

[...]

> > > > + *	Description
> > > > + *		Adjust frame headers moving *offset* bytes from/to the second
> > > > + *		buffer to/from the first one. This helper can be used to move
> > > > + *		headers when the hw DMA SG does not copy all the headers in
> > > > + *		the first fragment.
> >=20
> > + Eric to the discussion
> >=20
> > >=20
> > > This is confusing to read. Does this mean I can "move bytes to the se=
cond
> > > buffer from the first one" or "move bytes from the second buffer to t=
he first
> > > one" And what are frame headers? I'm sure I can read below code and w=
ork
> > > it out, but users reading the header file should be able to parse thi=
s.
> >=20
> > Our main goal with this helper is to fix the use-case where we request =
the hw
> > to put L2/L3/L4 headers (and all the TCP options) in the first fragment=
 and TCP
> > data starting from the second fragment (headers split) but for some rea=
sons
> > the hw puts the TCP options in the second fragment (if we understood co=
rrectly
> > this issue has been introduced by Eric @ NetDevConf 0x14).
> > bpf_xdp_adjust_mb_header() can fix this use-case moving bytes from the =
second fragment
> > to the first one (offset > 0) or from the first buffer to the second on=
e (offset < 0).
>=20
> Ah OK, so the description needs the information about how to use offset t=
hen it
> would have been clear I think. Something like that last line "moving byte=
s from
> the second fragment ...."

ack, right. I will do in v3.

>=20
> So this is to fixup header-spit for RX zerocopy? Add that to the commit
> message then.

Right. I will improve comments in v3.

>=20
> >=20
> > >=20
> > > Also we want to be able to read all data not just headers. Reading the
> > > payload of a TCP packet is equally important for many l7 load balance=
rs.
> > >=20
> >=20
> > In order to avoid to slow down performances we require that eBPF sandbo=
x can
> > read/write only buff0 in a xdp multi-buffer. The xdp program can only
> > perform some restricted changes to buff<n> (n >=3D 1) (e.g. what we did=
 in
> > bpf_xdp_adjust_mb_header()).
> > You can find the xdp multi-buff design principles here [0][1]
> >=20
> > [0] https://github.com/xdp-project/xdp-project/blob/master/areas/core/x=
dp-multi-buffer01-design.org
> > [1] http://people.redhat.com/lbiancon/conference/NetDevConf2020-0x14/ad=
d-xdp-on-driver.html - XDP multi-buffers section (slide 40)
> >=20
> > > > + *
> > > > + *		A call to this helper is susceptible to change the underlying
> > > > + *		packet buffer. Therefore, at load time, all checks on pointers
> > > > + *		previously done by the verifier are invalidated and must be
> > > > + *		performed again, if the helper is used in combination with
> > > > + *		direct packet access.
> > > > + *
> > > > + *	Return
> > > > + *		0 on success, or a negative error in case of failure.
> > > >   */
> > > >  #define __BPF_FUNC_MAPPER(FN)		\
> > > >  	FN(unspec),			\
> > > > @@ -3727,6 +3741,7 @@ union bpf_attr {
> > > >  	FN(inode_storage_delete),	\
> > > >  	FN(d_path),			\
> > > >  	FN(copy_from_user),		\
> > > > +	FN(xdp_adjust_mb_header),	\
> > > >  	/* */
> > > > =20
> > > >  /* integer value in 'imm' field of BPF_CALL instruction selects wh=
ich helper
> > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > index 47eef9a0be6a..ae6b10cf062d 100644
> > > > --- a/net/core/filter.c
> > > > +++ b/net/core/filter.c
> > > > @@ -3475,6 +3475,57 @@ static const struct bpf_func_proto bpf_xdp_a=
djust_head_proto =3D {
> > > >  	.arg2_type	=3D ARG_ANYTHING,
> > > >  };
> > > > =20
> > > > +BPF_CALL_2(bpf_xdp_adjust_mb_header, struct  xdp_buff *, xdp,
> > > > +	   int, offset)
> > > > +{
> > > > +	void *data_hard_end, *data_end;
> > > > +	struct skb_shared_info *sinfo;
> > > > +	int frag_offset, frag_len;
> > > > +	u8 *addr;
> > > > +
> > > > +	if (!xdp->mb)
> > > > +		return -EOPNOTSUPP;
>=20
> Not required for this patch necessarily but I think it would be better us=
er
> experience if instead of EOPNOTSUPP here we did the header split. This
> would allocate a frag and copy the bytes around as needed. Yes it might
> be slow if you don't have a frag free in the driver, but if user wants to
> do header split and their hardware can't do it we would have a way out.
>=20
> I guess it could be an improvement for later though.

I have no a strong opinion on this, I did it in this way to respect the rul=
e "we
do not allocate memory for XDP".

@Jesper, David: thoughts?

>=20
>=20
> > > > +
> > > > +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > > > +
> > > > +	frag_len =3D skb_frag_size(&sinfo->frags[0]);
> > > > +	if (offset > frag_len)
> > > > +		return -EINVAL;
> > >=20
> > > What if we want data in frags[1] and so on.
> > >=20
> > > > +
> > > > +	frag_offset =3D skb_frag_off(&sinfo->frags[0]);
> > > > +	data_end =3D xdp->data_end + offset;
> > > > +
> > > > +	if (offset < 0 && (-offset > frag_offset ||
> > > > +			   data_end < xdp->data + ETH_HLEN))
> > > > +		return -EINVAL;
> > > > +
> > > > +	data_hard_end =3D xdp_data_hard_end(xdp); /* use xdp->frame_sz */
> > > > +	if (data_end > data_hard_end)
> > > > +		return -EINVAL;
> > > > +
> > > > +	addr =3D page_address(skb_frag_page(&sinfo->frags[0])) + frag_off=
set;
> > > > +	if (offset > 0) {
> > > > +		memcpy(xdp->data_end, addr, offset);
> > >=20
> > > But this could get expensive for large amount of data? And also
> > > limiting because we require the room to do the copy. Presumably
> > > the reason we have fargs[1] is because the normal page or half
> > > page is in use?
> > >=20
> > > > +	} else {
> > > > +		memcpy(addr + offset, xdp->data_end + offset, -offset);
> > > > +		memset(xdp->data_end + offset, 0, -offset);
> > > > +	}
> > > > +
> > > > +	skb_frag_size_sub(&sinfo->frags[0], offset);
> > > > +	skb_frag_off_add(&sinfo->frags[0], offset);
> > > > +	xdp->data_end =3D data_end;
> > > > +
> > > > +	return 0;
> > > > +}
> > >=20
> > > So overall I don't see the point of copying bytes from one frag to
> > > another. Create an API that adjusts the data pointers and then
> > > copies are avoided and manipulating frags is not needed.
> >=20
> > please see above.
>=20
> OK it makes more sense with the context. It doesn't have much if anything
> to do about making data visible to the BPF program. This is about
> changing the layout of the frags list.

correct.

>=20
> How/when does the header split go wrong on the mvneta device? I guess
> this is to fix a real bug/issue not some theoritical one? An example
> in the commit message would make this concrete. Soemthing like,
> "When using RX zerocopy to mmap data into userspace application if
> a packet with [all these wild headers] is received rx zerocopy breaks
> because header split puts headers X in the data frag confusing apps".

This issue does not occur with mvneta since the driver is not capable of
performing header split AFAIK. The helper has been introduced to cover the
"issue" reported by Eric in his NetDevConf presentation. In order to test t=
he
helper I modified the mventa rx napi loop in a controlled way (this patch c=
an't
be sent upstream, it is for testing only :))
I will improve commit message in v3.

>=20
> >=20
> > >=20
> > > Also and even more concerning I think this API requires the
> > > driver to populate shinfo. If we use TX_REDIRECT a lot or TX_XMIT
> > > this means we need to populate shinfo when its probably not ever
> > > used. If our driver is smart L2/L3 headers are in the readable
> > > data and prefetched. Writing frags into the end of a page is likely
> > > not free.
> >=20
> > Sorry I did not get what you mean with "populate shinfo" here. We need =
to
> > properly set shared_info in order to create the xdp multi-buff.
> > Apart of header splits, please consider the main uses-cases for
> > xdp multi-buff are XDP with TSO and Jumbo frames.
>=20
> The use case I have in mind is a XDP_TX or XDP_REDIRECT load balancer.
> I wont know this at the driver level and now I'll have to write into
> the back of every page with this shinfo just in case. If header
> split is working I should never need to even touch the page outside
> the first N bytes that were DMAd and in cache with DDIO. So its extra
> overhead for something that is unlikely to happen in the LB case.

So far the skb_shared_info in constructed in mvneta only if the hw splits
the received data in multiple buffers (so if the MTU is greater than 1 PAGE,
please see comments below). Moreover the shared_info is present only in the
first buffer.

>=20
> If you take the simplest possible program that just returns XDP_TX
> and run a pkt generator against it. I believe (haven't run any
> tests) that you will see overhead now just from populating this
> shinfo. I think it needs to only be done when its needed e.g. when
> user makes this helper call or we need to build the skb and populate
> the frags there.

sure, I will carry out some tests.

>=20
> I think a smart driver will just keep the frags list in whatever
> form it has them (rx descriptors?) and push them over to the
> tx descriptors without having to do extra work with frag lists.

I think there are many use-cases where we want to have this info available =
in
xdp_buff/xdp_frame. E.g: let's consider the following Jumbo frame example:
- MTU > 1 PAGE (so we the driver will split the received data in multiple rx
  descriptors)
- the driver performs a XDP_REDIRECT to a veth or cpumap

Relying on the proposed architecture we could enable GRO in veth or cpumap I
guess since we can build a non-linear skb from the xdp multi-buff, right?

>=20
> >=20
> > >=20
> > > Did you benchmark this?
> >=20
> > will do, I need to understand if we can use tiny buffers in mvneta.
>=20
> Why tiny buffers? How does mvneta layout the frags when doing
> header split? Can we just benchmark what mvneta is doing at the
> end of this patch series?

for the moment mvneta can split the received data when the previous buffer =
is
full (e.g. when we the first page is completely written). I want to explore=
 if
I can set a tiny buffer (e.g. 128B) as max received buffer to run some perf=
ormance
tests and have some "comparable" results respect to the ones I got when I a=
dded XDP
support to mvneta.

>=20
> Also can you try the basic XDP_TX case mentioned above.
> I don't want this to degrade existing use cases if at all
> possible.

sure, will do.

>=20
> >=20
> > >=20
> > > In general users of this API should know the bytes they want
> > > to fetch. Use an API like this,
> > >=20
> > >   bpf_xdp_adjust_bytes(xdp, start, end)
> > >=20
> > > Where xdp is the frame, start is the first byte the user wants
> > > and end is the last byte. Then usually you can skip the entire
> > > copy part and just move the xdp pointesr around. The ugly case
> > > is if the user puts start/end across a frag boundary and a copy
> > > is needed. In that case maybe we use end as a hint and not a
> > > hard requirement.
> > >=20
> > > The use case I see is I read L2/L3/L4 headers and I need the
> > > first N bytes of the payload. I know where the payload starts
> > > and I know how many bytes I need so,
> > >=20
> > >   bpf_xdp_adjust_bytes(xdp, payload_offset, bytes_needed);
> > >=20
> > > Then hopefully that is all in one frag. If its not I'll need
> > > to do a second helper call. Still nicer than forcing drivers
> > > to populate this shinfo I think. If you think I'm wrong try
> > > a benchmark. Benchmarks aside I get stuck when data_end and
> > > data_hard_end are too close together.
> >=20
> > IIUC what you mean here is to expose L2/L3/L4 headers + some data to
> > the ebpf program to perform like L7 load-balancing, right?
>=20
> Correct, but with extra context I see in this patch you are trying
> to build an XDP controlled header split. This seems like a different
> use case from mine.

I agree.

>=20
> > Let's consider the Jumbo frames use-case (so the data are split in mult=
iple
> > buffers). I can see to issues here:
> > - since in XDP we can't linearize the buffer if start and end are on the
> >   different pages (like we do in bpf_msg_pull_data()), are we ending up
> >   in the case where requested data are all in buff0?=20
>=20
> In this case I would expect either the helper returns how many bytes
> were pulled in, maybe just (start, end_of_frag) or user can find
> it from data_end pointer. Here end is just a hint.
>=20
> > - if  start and end are in buff<2>, we should report the fragment numbe=
r to the
> >   ebpf program to "fetch" the data. Are we exposing too low-level detai=
ls to
> >   user-space?
>=20
> Why do you need the frag number? Just say I want bytes (X,Y) if that
> happens to be on buff<2> let the helper find it.
>=20
> I think having a helper to read/write any bytes is important and
> necessary, but the helper implemented in this patch is something
> else. I get naming is hard what if we called it xdp_header_split().

ack, sure. I will fix it in v3.

Regards,
Lorenzo

>=20
> >=20
> > Regards,
> > Lorenzo
> >=20
> > >=20
> > > Thanks,
> > > John
>=20
>=20

--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX1TlzgAKCRA6cBh0uS2t
rEQGAP4gsJGAQc0wkLn/ke+OHX7pBPvlFAnbpAZIhWPX+5PrqQEA5KtGjrK+zopP
DIpLGx2zyK9LI8dsUbS3EtmYZP451A8=
=Bngg
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--
