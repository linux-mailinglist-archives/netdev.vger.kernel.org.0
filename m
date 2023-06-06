Return-Path: <netdev+bounces-8458-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B91F172427B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:41:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 128101C20EFD
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF74837B6F;
	Tue,  6 Jun 2023 12:41:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59EF37B63
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:41:53 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF9210F5;
	Tue,  6 Jun 2023 05:41:42 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Qb92s2MgVzqTPh;
	Tue,  6 Jun 2023 20:36:53 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 6 Jun
 2023 20:41:40 +0800
Subject: Re: [PATCH net-next v2 1/3] page_pool: unify frag page and non-frag
 page handling
To: Alexander Duyck <alexander.duyck@gmail.com>, Yunsheng Lin
	<yunshenglin0825@gmail.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Saeed Mahameed <saeedm@mellanox.com>
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-2-linyunsheng@huawei.com>
 <e8db47e3fe99349a998ded1ce4f8da88ea9cc660.camel@gmail.com>
 <5d728f88-2bd0-7e78-90d5-499e85dc6fdf@huawei.com>
 <160fea176559526b38a4080cc0f52666634a7a4f.camel@gmail.com>
 <21f2fe04-8674-cc73-7a6c-cb0765c84dba@gmail.com>
 <CAKgT0Ueoq9WgSPz1anWdCH1mkRt9cKmRz+wNJSZfdo-YwLjXCQ@mail.gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1486a84f-14fa-0121-15a2-d3c6fd8f76c2@huawei.com>
Date: Tue, 6 Jun 2023 20:41:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKgT0Ueoq9WgSPz1anWdCH1mkRt9cKmRz+wNJSZfdo-YwLjXCQ@mail.gmail.com>
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

On 2023/6/5 22:58, Alexander Duyck wrote:

...

>>
>> I am not sure I understand what do you mean by 'non-fragmented ',
>> 'mono-frags', 'page pool freeing paths' and 'non-fragmented case'
>> here. maybe describe it more detailed with something like the
>> pseudocode?
> 
> What you are attempting to generate are "mono-frags" where a page pool
> page has a frag count of 1. I refer to "non-fragmented pages" as the
> legacy page pool page without pp_frags set.
> 
> The "page-pool freeing paths" are the ones outside of the fragmented
> bits here. Basically __page_pool_put_page and the like. What you
> should be doing is pushing the reference counting code down deeper
> into the page pool logic. Currently it is more of a surface setup.
> 
> The whole point I am getting at with this is that we should see the
> number of layers reduced for the fragmented pages, and by converting
> the non-fragmented pages to mono-frags we should see that maintain its
> current performance and total number of layers instead of having more
> layers added to it.

Do you mean reducing the number of layers for the fragmented pages by
moving the page->pp_frag_count handling from page_pool_defrag_page()
to __page_pool_put_page() where page->_refcount is checked?

Or merge page->pp_frag_count into page->_refcount so that we don't
need page->pp_frag_count anymore?

As my understanding, when a page from page pool is passed to the stack
to be processed, the stack may hold onto that page by taking
page->_refcount too, which means page pool has no control over who will
hold onto and when that taken will be released, that is why page pool
do the "page_ref_count(page) == 1" checking in __page_pool_put_page(),
if it is not true, the page pool can't recycle the page, so pp_frag_count
and _refcount have different meaning and serve different purpose, merging
them doesn't work, and moving them to one place doesn't make much sense
too?

Or is there other obvious consideration that I missed?

>>>
>> I am not sure what you meant above.
>> But I will describe what is this patch trying to do again:
>> When PP_FLAG_PAGE_FRAG is set and that flag is per page pool, not per
>> page, so page_pool_alloc_pages() is not allowed to be called as the
>> page->pp_frag_count is not setup correctly for the case.
>>
>> So in order to allow calling page_pool_alloc_pages(), as best as I
>> can think of, either we need a per page flag/bit to decide whether
>> to do something like dec_and_test for page->pp_frag_count in
>> page_pool_is_last_frag(), or we unify the page->pp_frag_count handling
>> in page_pool_is_last_frag() so that we don't need a per page flag/bit.
>>
>> This patch utilizes the optimization you mentioned above to unify the
>> page->pp_frag_count handling.
> 
> Basically what should be happening if all page-pool pages are to be
> considered "fragmented" is that we should be folding this into the
> freeing logic. What we now have a 2 stage setup where we are dropping
> the count to 0, then rebounding it and setting it back to 1. If we are
> going to have all page pool pages fragmented then the freeing path for
> page pool pages should just be handling frag count directly instead of
> hacking on it here and ignoring it in the actual freeing paths.

Do you mean doing something like below? isn't it dirtying the cache line
of 'struct page' whenever a page is recycled, which means we may not be
able to the maintain current performance for non-fragmented or mono-frag
case?

--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -583,6 +583,10 @@ static __always_inline struct page *
 __page_pool_put_page(struct page_pool *pool, struct page *page,
                     unsigned int dma_sync_size, bool allow_direct)
 {
+
+       if (!page_pool_defrag_page(page, 1))
+               return NULL;
+
        /* This allocator is optimized for the XDP mode that uses
         * one-frame-per-page, but have fallbacks that act like the
         * regular page allocator APIs.
@@ -594,6 +598,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
         */
        if (likely(page_ref_count(page) == 1 && !page_is_pfmemalloc(page))) {
                /* Read barrier done in page_ref_count / READ_ONCE */
+               page_pool_fragment_page(page, 1);

                if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
                        page_pool_dma_sync_for_device(pool, page,



> 
>>>
>>>>>>    ret = atomic_long_sub_return(nr, &page->pp_frag_count);
>>>>>>    WARN_ON(ret < 0);
>>>>>> +
>>>>>> +  /* Reset frag count back to 1, this should be the rare case when
>>>>>> +   * two users call page_pool_defrag_page() currently.
>>>>>> +   */
>>>>>> +  if (!ret)
>>>>>> +          atomic_long_set(&page->pp_frag_count, 1);
>>>>>> +
>>>>>>    return ret;
>>>>>>  }
>>>>>>
>>
>> ...
>>
>>>> As above, it is about unifying handling for frag and non-frag page in
>>>> page_pool_is_last_frag(). please let me know if there is any better way
>>>> to do it without adding statements here.
>>>
>>> I get what you are trying to get at but I feel like the implementation
>>> is going to cause more problems than it helps. The problem is it is
>>> going to hurt base page pool performance and it just makes the
>>> fragmented pages that much more confusing to deal with.
>>
>> For base page pool performance, as I mentioned before:
>> It remove PP_FLAG_PAGE_FRAG checking and only add the cost of
>> page_pool_fragment_page() in page_pool_set_pp_info(), which I
>> think it is negligible as we are already dirtying the same cache
>> line in page_pool_set_pp_info().
> 
> I have no problem with getting rid of the flag.
> 
>> For the confusing, sometimes it is about personal taste, so I am
>> not going to argue with it:) But it would be good to provide a
>> non-confusing way to do that with minimal overhead. I feel like
>> you have provided it in the begin, but I am not able to understand
>> it yet.
> 
> The problem here is that instead of treating all page pool pages as
> fragmented, what the patch set has done is added a shim layer so that
> you are layering fragmentation on top of page pool pages which was
> already the case.
> 
> That is why I have suggested make page pool pages a "mono-frag" as
> your first patch. Basically it is going to force you to have to set
> the pp_frag value for these pages, and verify it is 1 when you are
> freeing it.

It seems it is bascially what this patch do with minimal
overhead to the previous users.

Let me try again with what this patch mainly do:

Currently when page_pool_create() is called with
PP_FLAG_PAGE_FRAG flag, page_pool_alloc_pages() is only
allowed to be called under the below constraints:
1. page_pool_fragment_page() need to be called to setup
   page->pp_frag_count immediately.
2. page_pool_defrag_page() often need to be called to
   drain the page->pp_frag_count when there is no more
   user will be holding on to that page.

Those constraints exist in order to support a page to
be splitted into multi frags.

And those constraints have some overhead because of the
cache line dirtying/bouncing and atomic update.

Those constraints are unavoidable for case when we need
a page to be splitted into more than one frag, but there
is also case that we want to avoid the above constraints
and their overhead when a page can't be splitted as it
can only hold a big frag as requested by user, depending
on different use cases:
use case 1: allocate page without page splitting.
use case 2: allocate page with page splitting.
use case 3: allocate page with or without page splitting
            depending on the frag size.

Currently page pool only provide page_pool_alloc_pages()
and page_pool_alloc_frag() API to enable the above 1 & 2
separately, so we can not use a combination of 1 & 2 to
enable 3, it is not possible yet because of the per
page_pool flag PP_FLAG_PAGE_FRAG.

So in order to allow allocating unsplitted page without
the overhead of splitted page while still allow allocating
splitted page, we need to remove the per page_pool flag
in page_pool_is_last_frag(), as best as I can think of, it
seems there are two methods as below:
1. Add per page flag/bit to indicate a page is splitted or
   not, which means we might need to update that flag/bit
   everytime the page is recycled, dirtying the cache line
   of 'struct page' for use case 1.
2. Unify the page->pp_frag_count handling for both splitted
   and unsplitted page by assuming all pages in the page
   pool is splitted into a big frag initially.

Because we want to support the above use case 3 with minimal
overhead, especially not adding any noticable overhead for
use case 1, and we are already doing an optimization by not
updating pp_frag_count in page_pool_defrag_page() for the
last frag user, this patch chooses to unify the pp_frag_count
handling to support the above use case 3.

Let me know if it is making any sense here.

> 
> Then you are going to have to modify the fragmented cases to make use
> of lower level calls because now instead of us defragging a fragmented
> page, and then freeing it the two operations essentially have to be
> combined into one operation.

Does 'defragging a fragmented page' mean doing decrementing pp_frag_count?
"freeing it" mean calling put_page()? What does 'combined' really means
here?

> 
>>>
>>> My advice as a first step would be to look at first solving how to
>>> enable the PP_FLAG_PAGE_FRAG mode when you have
>>> PAGE_POOL_DMA_USE_PP_FRAG_COUNT as true. That should be creating mono-
>>> frags as we are calling them, and we should have a way to get the
>>> truesize for those so we know when we are consuming significant amount
>>> of memory.
>>
>> Does the way to get the truesize in the below RFC make sense to you?
>> https://patchwork.kernel.org/project/netdevbpf/patch/20230516124801.2465-4-linyunsheng@huawei.com/
> 
> It doesn't add any value. All you are doing is passing the "size"
> value as "truesize". The whole point of the "truesize" would be to
> report the actual size. So a step in that direction would be to bump
> truesize to include the remainder that isn't used when you decide it
> is time to allocate a new page. The problem is that it requires some
> fore-knowledge of what the next requested size is going to be. That is
> why it is better to just have the drivers manage this since they know
> what size they typically request and when they are going to close
> pages.
> 
> Like I said, if you are wanting to go down this path you are better
> off starting with page pool and making all regular page pool pages
> into mono-frags. Then from there we can start building things out.

'mono-frag' means page with pp_frag_count being one. If yes, then I
feel like we have the same goal here, but may have different opinion
on how to implement it.

> 
> With that you could then let drivers like the Mellanox one handle its
> own fragmenting knowing it has to return things to a mono-frag in
> order for it to be working correctly.

I still really don't how it will be better for mlx5 to handle its
own fragmenting yet?

+cc Dragos & Saeed to share some info here, so that we can see
if page pool learn from it.

> 
> .
> 

