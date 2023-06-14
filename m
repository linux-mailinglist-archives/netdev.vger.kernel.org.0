Return-Path: <netdev+bounces-10690-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E47F72FD2E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69ADF1C20C5D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72A2D847B;
	Wed, 14 Jun 2023 11:42:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6778A79E1
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:42:46 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7951BEF;
	Wed, 14 Jun 2023 04:42:32 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Qh3PY2cclztQnW;
	Wed, 14 Jun 2023 19:40:01 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 14 Jun
 2023 19:42:30 +0800
Subject: Re: [PATCH net-next v4 1/5] page_pool: frag API support for 32-bit
 arch with 64-bit DMA
To: Jakub Kicinski <kuba@kernel.org>
CC: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Alexander Duyck <alexander.duyck@gmail.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Eric Dumazet
	<edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, <linux-rdma@vger.kernel.org>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-2-linyunsheng@huawei.com>
 <20230613210906.42ea393e@kernel.org>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <99233a68-882f-51cd-bf7c-c2b83652ae09@huawei.com>
Date: Wed, 14 Jun 2023 19:42:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230613210906.42ea393e@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/14 12:09, Jakub Kicinski wrote:
> On Mon, 12 Jun 2023 21:02:52 +0800 Yunsheng Lin wrote:
>> Currently page_pool_alloc_frag() is not supported in 32-bit
>> arch with 64-bit DMA, which seems to be quite common, see
>> [1], which means driver may need to handle it when using
>> page_pool_alloc_frag() API.
>>
>> In order to simplify the driver's work for supporting page
>> frag, this patch allows page_pool_alloc_frag() to call
>> page_pool_alloc_pages() to return a big page frag without
> 
> it returns an entire (potentially compound) page, not a frag.
> AFAICT

As driver calls page_pool_alloc_frag(), and page_pool_alloc_frag()
calls page_pool_alloc_pages(), page_pool_alloc_pages() is hidden
inside page_pool_alloc_frag(), so it is a big page frag from driver's
point of view:)

> 
>> page splitting because of overlap issue between pp_frag_count
>> and dma_addr_upper in 'struct page' for those arches.
> 
> These two lines seem to belong in the first paragraph,
> 
>> As page_pool_create() with PP_FLAG_PAGE_FRAG is supported in
> 
> "is" -> "will now be"
> 
>> 32-bit arch with 64-bit DMA now, mlx5 calls page_pool_create()
>> with PP_FLAG_PAGE_FRAG and manipulate the page->pp_frag_count
>> directly using the page_pool_defrag_page(), so add a checking
>> for it to aoivd writing to page->pp_frag_count that may not
>> exist in some arch.
> 
> This paragraph needs some proof reading :(

Perhaps something like below?
mlx5 calls page_pool_create() with PP_FLAG_PAGE_FRAG and is
not using the frag API, as PP_FLAG_PAGE_FRAG checking for arch
with PAGE_POOL_DMA_USE_PP_FRAG_COUNT being true will now be
removed in this patch, so add back the checking of
PAGE_POOL_DMA_USE_PP_FRAG_COUNT for mlx5 driver to retain the
old behavior, which is to avoid mlx5e_page_release_fragmented()
calling page_pool_defrag_page() to write to page->pp_frag_count.

> 
>> Note that it may aggravate truesize underestimate problem for
>> skb as there is no page splitting for those pages, if driver
>> need a accuate truesize, it may calculate that according to
> 
> accurate
> 
>> frag size, page order and PAGE_POOL_DMA_USE_PP_FRAG_COUNT
>> being true or not. And we may provide a helper for that if it
>> turns out to be helpful.
>>
>> 1. https://lore.kernel.org/all/20211117075652.58299-1-linyunsheng@huawei.com/
> 
>> +		/* Return error here to avoid writing to page->pp_frag_count in
>> +		 * mlx5e_page_release_fragmented() for page->pp_frag_count is
> 
> I don't see any direct access to pp_frag_count anywhere outside of
> page_pool.h in net-next. PAGE_POOL_DMA_USE_PP_FRAG_COUNT sounds like 
> an internal flag, drivers shouldn't be looking at it, IMO.

mlx5e_page_release_fragmented() calls page_pool_defrag_page(), maybe
below is more correct:

/* Return error here to avoid mlx5e_page_release_fragmented() calling
 * page_pool_defrag_page() to write to page->pp_frag_count which is
 * not usable for arch with PAGE_POOL_DMA_USE_PP_FRAG_COUNT being true.
*/

I am agree with you about that drivers shouldn't be looking at it. But
adding PAGE_POOL_DMA_USE_PP_FRAG_COUNT checking back to mlx5 seems to be
the simplest way I can think of because of the reason mentioned above.

And it seems that it is hard to change mlx5 to use frag API according to
the below disscusion with Alexander:

https://lore.kernel.org/all/CAKgT0UeD=sboWNUsP33_UsKEKyqTBfeOqNO5NCdFaxh9KXEG3w@mail.gmail.com/

> 
> .
> 

