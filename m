Return-Path: <netdev+bounces-3127-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB609705AC9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 00:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDEFE1C20D07
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E1E63CA;
	Tue, 16 May 2023 22:52:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02250290F6;
	Tue, 16 May 2023 22:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA1BC433D2;
	Tue, 16 May 2023 22:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684277549;
	bh=HZB52PUbkAvfzfgUWO5ycLGEg/guGyaTy/BQOMoX51U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u+oC3pSm+o+ET19yz6Yl4/80GRbHqM6r4LoXh2Jvo7fW09z0HcRVQlI2XieiqgbB6
	 6jvkMj2HYvn9E9AlG9zxEiAblRJhuyVjAEWPG80zz9vWxy6DYzs8SSbrWcHv8IGxD5
	 md3LbM76jLwvvnrM+ec+Kcm71y2c4/ezKuwHb2u4BSz4t359P0dldlR4RzPgNSwmvH
	 E6na6p7QwLXy3nGpm1+zCrcgLLaS02Farg5TKuJK8mx9YNRhW7c1XLhqk3uQC6g5wd
	 m95JYsUGbajK6yQU02vv90NXQV1pfCmqh8XWE9BLaaHj3XyH+ghLK3QgfCnhEVnduT
	 1hk8KZf6rQl3A==
Date: Wed, 17 May 2023 00:52:25 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
	Yunsheng Lin <linyunsheng@huawei.com>, netdev@vger.kernel.org,
	bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
	daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint
 using half page per-buffer
Message-ID: <ZGQJKRfuf4+av/MD@lore-desk>
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
 <62654fa5-d3a2-4b81-af70-59c9e90db842@huawei.com>
 <ZGIWZHNRvq5DSmeA@lore-desk>
 <ZGIvbfPd46EIVZf/@boxer>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="u1hCd42MhueKAEAX"
Content-Disposition: inline
In-Reply-To: <ZGIvbfPd46EIVZf/@boxer>


--u1hCd42MhueKAEAX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, May 15, 2023 at 01:24:20PM +0200, Lorenzo Bianconi wrote:
> > > On 2023/5/12 21:08, Lorenzo Bianconi wrote:
> > > > In order to reduce page_pool memory footprint, rely on
> > > > page_pool_dev_alloc_frag routine and reduce buffer size
> > > > (VETH_PAGE_POOL_FRAG_SIZE) to PAGE_SIZE / 2 in order to consume one=
 page
> > >=20
> > > Is there any performance improvement beside the memory saving? As it
> > > should reduce TLB miss, I wonder if the TLB miss reducing can even
> > > out the cost of the extra frag reference count handling for the
> > > frag support?
> >=20
> > reducing the requested headroom to 192 (from 256) we have a nice improv=
ement in
> > the 1500B frame case while it is mostly the same in the case of paged s=
kb
> > (e.g. MTU 8000B).
>=20
> Can you define 'nice improvement' ? ;)
> Show us numbers or improvement in %.

I am testing this RFC patch in the scenario reported below:

iperf tcp tx --> veth0 --> veth1 (xdp_pass) --> iperf tcp rx

- 6.4.0-rc1 net-next:
  MTU 1500B: ~ 7.07 Gbps
  MTU 8000B: ~ 14.7 Gbps

- 6.4.0-rc1 net-next + page_pool frag support in veth:
  MTU 1500B: ~ 8.57 Gbps
  MTU 8000B: ~ 14.5 Gbps

side note: it seems there is a regression between 6.2.15 and 6.4.0-rc1 net-=
next
(even without latest veth page_pool patches) in the throughput I can get in=
 the
scenario above, but I have not looked into it yet.

- 6.2.15:
  MTU 1500B: ~ 7.91 Gbps
  MTU 8000B: ~ 14.1 Gbps

- 6.4.0-rc1 net-next w/o commits [0],[1],[2]
  MTU 1500B: ~ 6.38 Gbps
  MTU 8000B: ~ 13.2 Gbps

Regards,
Lorenzo

[0] 0ebab78cbcbf  net: veth: add page_pool for page recycling
[1] 4fc418053ec7  net: veth: add page_pool stats
[2] 9d142ed484a3  net: veth: rely on napi_build_skb in veth_convert_skb_to_=
xdp_buff

>=20
> >=20
> > >=20
> > > > for two 1500B frames. Reduce VETH_XDP_PACKET_HEADROOM to 192 from 2=
56
> > > > (XDP_PACKET_HEADROOM) to fit max_head_size in VETH_PAGE_POOL_FRAG_S=
IZE.
> > > > Please note, using default values (CONFIG_MAX_SKB_FRAGS=3D17), maxi=
mum
> > > > supported MTU is now reduced to 36350B.
> > >=20
> > > Maybe we don't need to limit the frag size to VETH_PAGE_POOL_FRAG_SIZ=
E,
> > > and use different frag size depending on the mtu or packet size?
> > >=20
> > > Perhaps the page_pool_dev_alloc_frag() can be improved to return non-=
frag
> > > page if the requested frag size is larger than a specified size too.
> > > I will try to implement it if the above idea makes sense.
> > >=20
> >=20
> > since there are no significant differences between full page and fragme=
nted page
> > implementation if the MTU is over the page boundary, does it worth to d=
o so?
> > (at least for the veth use-case).
> >=20
> > Regards,
> > Lorenzo
> >=20
>=20
>=20

--u1hCd42MhueKAEAX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZGQJKQAKCRA6cBh0uS2t
rFsSAQCJzJptVc6NYGr+nCWLhmtt+F8l/Y2BbbWIv8HUjcq2ggEAjkJxwKY+CsCU
K1rM8WxWYSkUqnJkDC0whsA2VUCZ8AI=
=GYin
-----END PGP SIGNATURE-----

--u1hCd42MhueKAEAX--

