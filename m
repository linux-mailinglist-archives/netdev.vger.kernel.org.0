Return-Path: <netdev+bounces-2174-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE5A700A04
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:15:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0CC72817F4
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5281EA62;
	Fri, 12 May 2023 14:14:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F038B1DDDC;
	Fri, 12 May 2023 14:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31363C433EF;
	Fri, 12 May 2023 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683900892;
	bh=I2SLq8jRsoL0+2OXWw2UIOj7p5Mdxwxb3J5ypYpoAUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bPPD+m+P86R0YFQUyAqfdOhufE7rhuL73K31mdpfdpvyOXzO9BDpwYpeVE9TIjMrD
	 jNudwgimrBEKeXWM0l1TQ2IDGVYvNpEqnskCNymGQC/uxmtXz8GsE3zT7Iw5oB9vWI
	 hfkK1iQImPASzdqKQ3hlueSkpeNNFO94/P+ofmj4Ui0mu6WLdhICj4VXcNayd+/jY4
	 zuXtAML12bkIzNx2u3dNuQc8hmAzKEVHlyXgqkF9O63x54KG4JsnzPaBAZjYLSOuuN
	 Rr4j5Lwb9ExHdelWa53gMknazbeNBs6u/FmfPv+Rpcycu+qJQZFCCLGl1urSsdXjVR
	 JZJBmPGs6chZw==
Date: Fri, 12 May 2023 16:14:48 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
	bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
	daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
	linyunsheng@huawei.com
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint
 using half page per-buffer
Message-ID: <ZF5J2B4gS4AE3PHS@lore-desk>
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
 <c65eb429-035e-04a7-51d1-c588ac5053be@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pLSR8tqB7F9tZmtS"
Content-Disposition: inline
In-Reply-To: <c65eb429-035e-04a7-51d1-c588ac5053be@intel.com>


--pLSR8tqB7F9tZmtS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: Lorenzo Bianconi <lorenzo@kernel.org>
> Date: Fri, 12 May 2023 15:08:13 +0200
>=20
> > In order to reduce page_pool memory footprint, rely on
> > page_pool_dev_alloc_frag routine and reduce buffer size
> > (VETH_PAGE_POOL_FRAG_SIZE) to PAGE_SIZE / 2 in order to consume one page
> > for two 1500B frames. Reduce VETH_XDP_PACKET_HEADROOM to 192 from 256
> > (XDP_PACKET_HEADROOM) to fit max_head_size in VETH_PAGE_POOL_FRAG_SIZE.
> > Please note, using default values (CONFIG_MAX_SKB_FRAGS=3D17), maximum
> > supported MTU is now reduced to 36350B.
>=20
> I thought we're stepping away from page splitting bit by bit O_o

do you mean to driver private page_split implementation? AFAIK we are not
stepping away from page_pool page split implementation (or maybe I missed i=
t :))

> Primarily for the reasons you mentioned / worked around here: it creates
> several significant limitations and at least on 64-bit systems it
> doesn't scale anymore. 192 bytes of headroom is less than what XDP
> expects (isn't it? Isn't 256 standard-standard, so that skb XDP path
> reallocates heads only to have 256+ there?), 384 bytes of shinfo can
> change anytime and even now page split simply blocks you from increasing
> MAX_SKB_FRAGS even by one. Not speaking of MTU limitations etc.
> BTW Intel drivers suffer from the very same things due solely to page
> split (and I'm almost done with converting at least some of them to Page
> Pool and 1 page per buffer model), I don't recommend deliberately
> falling into that pit =3D\ :D

I am not sure about the 192 vs 256 bytes of headroom (this is why I sent th=
is
patch as RFC, my main goal is to discuss about this requirement). In the
previous discussion [0] we deferred this implementation since if we do not
reduce requested xdp headroom, we will not be able to fit two 1500B frames
into a single page (for skb_shared_info size [1]) and we introduce a perfor=
mance
penalty.

Regards,
Lorenzo

[0] https://lore.kernel.org/netdev/6298f73f7cc7391c7c4a52a6a89b1ae21488bda1=
=2E1682188837.git.lorenzo@kernel.org/
[1] $ pahole -C skb_shared_info vmlinux.o=20
struct skb_shared_info {
        __u8                       flags;                /*     0     1 */
        __u8                       meta_len;             /*     1     1 */
        __u8                       nr_frags;             /*     2     1 */
        __u8                       tx_flags;             /*     3     1 */
        unsigned short             gso_size;             /*     4     2 */
        unsigned short             gso_segs;             /*     6     2 */
        struct sk_buff *           frag_list;            /*     8     8 */
        struct skb_shared_hwtstamps hwtstamps;           /*    16     8 */
        unsigned int               gso_type;             /*    24     4 */
        u32                        tskey;                /*    28     4 */
        atomic_t                   dataref;              /*    32     4 */
        unsigned int               xdp_frags_size;       /*    36     4 */
        void *                     destructor_arg;       /*    40     8 */
        skb_frag_t                 frags[17];            /*    48   272 */

        /* size: 320, cachelines: 5, members: 14 */
};

>=20
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/veth.c | 39 +++++++++++++++++++++++++--------------
> >  1 file changed, 25 insertions(+), 14 deletions(-)
> [...]
>=20
> Thanks,
> Olek

--pLSR8tqB7F9tZmtS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZF5J2AAKCRA6cBh0uS2t
rCxAAQCSKLWjFxjZqsMfxfjAFqbeYwd4JydyXK1h0pDmtKOCqQD/RsjwdxwHbF7j
/uTV1IUo47JLIqJhGSHB0lIzqD7YIww=
=waNW
-----END PGP SIGNATURE-----

--pLSR8tqB7F9tZmtS--

