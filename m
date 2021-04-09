Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD9435A5A6
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhDISTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233332AbhDISTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:19:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 323036115B;
        Fri,  9 Apr 2021 18:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617992380;
        bh=q5xrbwzv8KsNj0U1kR3Lt3iT3TxopA21t3yocKUUo7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Exqcw/LLWE5dwCzrJlmL3b3z9kl85pjsOQ1d5G9+2rHuSm7ghc/hJUgRvSGa5n1Vp
         IFPA5XebVUu7+/qXAH0OY31RpblJ0o9fMyxYemKxmIvkRT/rO/E4S7XePb6DaKicjR
         ywq2X8l2k8m7scmdPvPBYGbwkH8J09Ime6ZcvEsbd3fCs3T55LwIKeIPDB93TX+ohY
         QJMjpkBFSgN8BqRCu7oWi+u4H2yzWNaIST2i55jKnrXN/VsbD1nu+ll+VRyTg9lepM
         Yk6fuVf2VLxPVTzn6IVoNUr5vdUm/P7Xx+d8JAQzS/olGa8HDpGO21CVQSXrGFxYN9
         yT/cbfWRR7ylA==
Date:   Fri, 9 Apr 2021 20:19:35 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 09/14] bpd: add multi-buffer support to xdp
 copy helpers
Message-ID: <YHCat5EXRwJZHdZT@lore-desk>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <cc517a20ac0908fa070ee6ba019936a8037a6d8c.1617885385.git.lorenzo@kernel.org>
 <20210408205709.w6sy5rklphoyl5on@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+1QjoRuISrnp9K0k"
Content-Disposition: inline
In-Reply-To: <20210408205709.w6sy5rklphoyl5on@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+1QjoRuISrnp9K0k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Apr 08, 2021 at 02:51:01PM +0200, Lorenzo Bianconi wrote:
> > From: Eelco Chaudron <echaudro@redhat.com>
> >=20
> > This patch adds support for multi-buffer for the following helpers:
> >   - bpf_xdp_output()
> >   - bpf_perf_event_output()
> >=20
> > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/too=
ls/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> > index a038e827f850..d5a5f603d252 100644
> > --- a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> > +++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> > @@ -27,6 +27,7 @@ struct xdp_buff {
> >  	void *data_hard_start;
> >  	unsigned long handle;
> >  	struct xdp_rxq_info *rxq;
> > +	__u32 frame_length;
>=20
> This patch will not work without patch 10, so could you change the order?

ack, I will fix it in v9

Regards,
Lorenzo

>=20
> >  } __attribute__((preserve_access_index));
> > =20
> >  struct meta {
> > @@ -49,7 +50,7 @@ int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
> >  	void *data =3D (void *)(long)xdp->data;
> > =20
> >  	meta.ifindex =3D xdp->rxq->dev->ifindex;
> > -	meta.pkt_len =3D data_end - data;
> > +	meta.pkt_len =3D xdp->frame_length;
> >  	bpf_xdp_output(xdp, &perf_buf_map,
> >  		       ((__u64) meta.pkt_len << 32) |
> >  		       BPF_F_CURRENT_CPU,
> > --=20
> > 2.30.2
> >=20

--+1QjoRuISrnp9K0k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYHCatQAKCRA6cBh0uS2t
rH8YAP0Ujl4J2t8wlFTqocXNOAxZKmHlxcQXE204PzCdDvuMcgEAmFqj6PIzHAkd
uSg5C4JimG1tBTfIUp5uJNA2TbdMWwk=
=5Dn6
-----END PGP SIGNATURE-----

--+1QjoRuISrnp9K0k--
