Return-Path: <netdev+bounces-10802-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E74D37305AD
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:07:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B497281216
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52192EC21;
	Wed, 14 Jun 2023 17:07:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454BD7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B688C433C0;
	Wed, 14 Jun 2023 17:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686762434;
	bh=NpWuYNlYc3D2CurfbLM6VpTeKuMXkRNNOdi/NzEeRvY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uYfTxJa7c636B3tmtfqkCgVVLFl8q3p0ygiJjwdCurzKfvOCVKuEn5Gjj1CThyE/+
	 OrYlYh0hwLhQZDDUDteXH5pSatnnTJGFqQ9cdL/BSMO9sqiK3DBWBnv4A3D1RDhzmF
	 w5MZnWR7Z3yChX34JLN5xXIbRdMHumIfX7BQDhrVxtxzdkJQbiw61Ukqc4mCM4q99o
	 /7TiyqVen+Q9WvjbOxd0YWBVPVN//xCOqgp8m0oyE86Rfqb1QfmF9OaqQGmmVc9Xfm
	 4YvS+Ok7A47Kom7aYktETPTmEnAYER3r5MgQ5SSRJznYc1PXWrvrH6l3JldxB0Fj+8
	 NnLOv745VEFWA==
Date: Wed, 14 Jun 2023 10:07:13 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Alexander Duyck <alexander.duyck@gmail.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next v4 1/5] page_pool: frag API support for 32-bit
 arch with 64-bit DMA
Message-ID: <20230614100713.5ee2538f@kernel.org>
In-Reply-To: <99233a68-882f-51cd-bf7c-c2b83652ae09@huawei.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
	<20230612130256.4572-2-linyunsheng@huawei.com>
	<20230613210906.42ea393e@kernel.org>
	<99233a68-882f-51cd-bf7c-c2b83652ae09@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Jun 2023 19:42:29 +0800 Yunsheng Lin wrote:
> On 2023/6/14 12:09, Jakub Kicinski wrote:
> > On Mon, 12 Jun 2023 21:02:52 +0800 Yunsheng Lin wrote: =20
> >> Currently page_pool_alloc_frag() is not supported in 32-bit
> >> arch with 64-bit DMA, which seems to be quite common, see
> >> [1], which means driver may need to handle it when using
> >> page_pool_alloc_frag() API.
> >>
> >> In order to simplify the driver's work for supporting page
> >> frag, this patch allows page_pool_alloc_frag() to call
> >> page_pool_alloc_pages() to return a big page frag without =20
> >=20
> > it returns an entire (potentially compound) page, not a frag.
> > AFAICT =20
>=20
> As driver calls page_pool_alloc_frag(), and page_pool_alloc_frag()
> calls page_pool_alloc_pages(), page_pool_alloc_pages() is hidden
> inside page_pool_alloc_frag(), so it is a big page frag from driver's
> point of view:)

frag=E2=80=8Bment : a part broken off, detached, or incomplete
          a small part broken or separated off something.

"big fragment" is definitely not the whole thing.

> >> page splitting because of overlap issue between pp_frag_count
> >> and dma_addr_upper in 'struct page' for those arches. =20
> >=20
> > These two lines seem to belong in the first paragraph,
> >  =20
> >> As page_pool_create() with PP_FLAG_PAGE_FRAG is supported in =20
> >=20
> > "is" -> "will now be"
> >  =20
> >> 32-bit arch with 64-bit DMA now, mlx5 calls page_pool_create()
> >> with PP_FLAG_PAGE_FRAG and manipulate the page->pp_frag_count
> >> directly using the page_pool_defrag_page(), so add a checking
> >> for it to aoivd writing to page->pp_frag_count that may not
> >> exist in some arch. =20
> >=20
> > This paragraph needs some proof reading :( =20
>=20
> Perhaps something like below?
> mlx5 calls page_pool_create() with PP_FLAG_PAGE_FRAG and is
> not using the frag API, as PP_FLAG_PAGE_FRAG checking for arch
> with PAGE_POOL_DMA_USE_PP_FRAG_COUNT being true will now be
> removed in this patch, so add back the checking of
> PAGE_POOL_DMA_USE_PP_FRAG_COUNT for mlx5 driver to retain the
> old behavior, which is to avoid mlx5e_page_release_fragmented()
> calling page_pool_defrag_page() to write to page->pp_frag_count.

That's a 7-line long, single sentence. Not much better.

> >> Note that it may aggravate truesize underestimate problem for
> >> skb as there is no page splitting for those pages, if driver
> >> need a accuate truesize, it may calculate that according to =20
> >=20
> > accurate
> >  =20
> >> frag size, page order and PAGE_POOL_DMA_USE_PP_FRAG_COUNT
> >> being true or not. And we may provide a helper for that if it
> >> turns out to be helpful.
> >>
> >> 1. https://lore.kernel.org/all/20211117075652.58299-1-linyunsheng@huaw=
ei.com/ =20
> >  =20
> >> +		/* Return error here to avoid writing to page->pp_frag_count in
> >> +		 * mlx5e_page_release_fragmented() for page->pp_frag_count is =20
> >=20
> > I don't see any direct access to pp_frag_count anywhere outside of
> > page_pool.h in net-next. PAGE_POOL_DMA_USE_PP_FRAG_COUNT sounds like=20
> > an internal flag, drivers shouldn't be looking at it, IMO. =20
>=20
> mlx5e_page_release_fragmented() calls page_pool_defrag_page(), maybe
> below is more correct:
>=20
> /* Return error here to avoid mlx5e_page_release_fragmented() calling
>  * page_pool_defrag_page() to write to page->pp_frag_count which is
>  * not usable for arch with PAGE_POOL_DMA_USE_PP_FRAG_COUNT being true.
> */
>=20
> I am agree with you about that drivers shouldn't be looking at it. But
> adding PAGE_POOL_DMA_USE_PP_FRAG_COUNT checking back to mlx5 seems to be
> the simplest way I can think of because of the reason mentioned above.
>=20
> And it seems that it is hard to change mlx5 to use frag API according to
> the below disscusion with Alexander:
>=20
> https://lore.kernel.org/all/CAKgT0UeD=3DsboWNUsP33_UsKEKyqTBfeOqNO5NCdFax=
h9KXEG3w@mail.gmail.com/

It's better to add a flag like PP_FLAG_PAGE_FRAG for this use case and
have pool creation fail than poke at internals in the driver, IMO.

