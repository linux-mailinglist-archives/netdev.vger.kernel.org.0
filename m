Return-Path: <netdev+bounces-8842-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3094E725FD3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:46:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 788471C20E32
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3708F57;
	Wed,  7 Jun 2023 12:46:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1076C139F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:46:39 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCF310C6;
	Wed,  7 Jun 2023 05:46:35 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QbnC7557jzTkH5;
	Wed,  7 Jun 2023 20:46:11 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 7 Jun
 2023 20:46:32 +0800
Subject: Re: [PATCH net-next v2 1/3] page_pool: unify frag page and non-frag
 page handling
To: Alexander Duyck <alexander.duyck@gmail.com>
CC: Yunsheng Lin <yunshenglin0825@gmail.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>, Jesper
 Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>, Dragos
 Tatulea <dtatulea@nvidia.com>, Saeed Mahameed <saeedm@mellanox.com>
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-2-linyunsheng@huawei.com>
 <e8db47e3fe99349a998ded1ce4f8da88ea9cc660.camel@gmail.com>
 <5d728f88-2bd0-7e78-90d5-499e85dc6fdf@huawei.com>
 <160fea176559526b38a4080cc0f52666634a7a4f.camel@gmail.com>
 <21f2fe04-8674-cc73-7a6c-cb0765c84dba@gmail.com>
 <CAKgT0Ueoq9WgSPz1anWdCH1mkRt9cKmRz+wNJSZfdo-YwLjXCQ@mail.gmail.com>
 <1486a84f-14fa-0121-15a2-d3c6fd8f76c2@huawei.com>
 <CAKgT0Udmk4K=aOKC9k2M5WcBKremveqGo_YQy=7+VWdNP3DiKw@mail.gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1af7a553-14ce-f74c-9493-859b7492d487@huawei.com>
Date: Wed, 7 Jun 2023 20:46:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKgT0Udmk4K=aOKC9k2M5WcBKremveqGo_YQy=7+VWdNP3DiKw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/6 23:33, Alexander Duyck wrote:
>> Do you mean doing something like below? isn't it dirtying the cache line
>> of 'struct page' whenever a page is recycled, which means we may not be
>> able to the maintain current performance for non-fragmented or mono-frag
>> case?
>>
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -583,6 +583,10 @@ static __always_inline struct page *
>>  __page_pool_put_page(struct page_pool *pool, struct page *page,
>>                      unsigned int dma_sync_size, bool allow_direct)
>>  {
>> +
>> +       if (!page_pool_defrag_page(page, 1))
>> +               return NULL;
>> +
> 
> Yes, that is pretty much it. This would be your standard case page
> pool put path. Basically it allows us to start getting rid of a bunch
> of noise in the fragmented path.
> 
>>         /* This allocator is optimized for the XDP mode that uses
>>          * one-frame-per-page, but have fallbacks that act like the
>>          * regular page allocator APIs.
>> @@ -594,6 +598,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>>          */
>>         if (likely(page_ref_count(page) == 1 && !page_is_pfmemalloc(page))) {
>>                 /* Read barrier done in page_ref_count / READ_ONCE */
>> +               page_pool_fragment_page(page, 1);
> 
> I wouldn't bother resetting this to 1 until after you have recycled it
> and pulled it back out again as an allocation. Basically when the
> pages are sitting in the pool the frag_count should be 0. That way it
> makes it easier to track and is similar to how the memory allocator
> actually deals with the page reference count. Basically if the page is
> sitting in the pool the frag_count is 0, once it comes out it should
> be 1 or more indicating it is in use.

Let's be more specific about what we want to do here：

For a specific page without splitting, the journey that it will go
through is as below before this patch:
1. It is allocated from the page allocator.
2. It is initialized in page_pool_set_pp_info().
3. It is passed to driver by page pool.
4. It is passed to stack by the driver.
5. It is passed back to the page pool by the stack, depending on the
   page_ref_count() checking:
   5.1 page_ref_count() being one, the page is now owned by the page
       pool, and may be passed to the driver by going to step 3.
   5.2 page_ref_count() not being one, the page is released by page
       pool doing resoure cleaning like dma mapping and put_page().

So a page may go through step 3 ~ 5.1 many times without dirtying
the cache line of  'struct page' as my understanding.


If I follow your suggestion here, It seems for a specific page without
splitting, it may go through:
1. It is allocated from the page allocator.
2. It is initialized in page_pool_set_pp_info().
3. It's pp_frag_count is set to one.
4. It is passed to driver by page pool.
5. It is passed to stack by the driver.
6. It is passed back to the page pool by the stack, depending on the
   pp_frag_count and page_ref_count() checking:
   6.1 pp_frag_count and page_ref_count() being one, the page is now
       owned by the page pool, and may be passed to the driver by
       going to step 3.
   6.2 otherwise the page is released by page pool doing resoure
       cleaning like dma mapping and put_page().

Aren't we dirtying the cache line of  'struct page' everytime the page
is recycled? Or did I miss something obvious here?

For my implementation, for a specific page without splitting, it may
go through:
1. It is allocated from the page allocator.
2. It is initialized in page_pool_set_pp_info() and it's pp_frag_count
   set to one.
3. It is passed to driver by page pool.
4. It is passed to stack by the driver.
5. It is passed back to the page pool by the stack, depending on the
   page_ref_count() checking:
   5.1 pp_frag_count and page_ref_count() being one, the page is now
       owned by the page pool, and as the optimization by not updating
       page->pp_frag_count in page_pool_defrag_page() for the last
       frag user, it can be passed to the driver by going to step 3
       without resetting the pp_frag_count to 1, which may dirty
       the cache line of  'struct page'.
   5.2 otherwise the page is released by page pool doing resoure
       cleaning like dma mapping and put_page().

Does it make any sense, or it doesn't really matter we are dirtying
the cache line of  'struct page' whenever a page without splitted is
recycled?


>>
>> Does 'defragging a fragmented page' mean doing decrementing pp_frag_count?
>> "freeing it" mean calling put_page()? What does 'combined' really means
>> here?
> 
> The change is that the code would do the subtraction and if it hit 0
> it was freeing the page. That is the one piece that gets more
> complicated because we really should be hitting 1. So we may be adding
> a few more operations to that case.
> 
>>>

I am not sure I understand it. Does 'gets more complicated' means doing
some optimization like page_pool_defrag_page() does?
https://elixir.bootlin.com/linux/v6.4-rc5/source/include/net/page_pool.h#L314

> 
>>>
>>> With that you could then let drivers like the Mellanox one handle its
>>> own fragmenting knowing it has to return things to a mono-frag in
>>> order for it to be working correctly.
>>
>> I still really don't how it will be better for mlx5 to handle its
>> own fragmenting yet?
>>
>> +cc Dragos & Saeed to share some info here, so that we can see
>> if page pool learn from it.
> 
> It has more to do with the fact that the driver knows what it is going
> to do beforehand. In many cases it can look at the page and know that
> it isn't going to reuse it again so it can just report the truesize
> being the length from the current pointer to the end of the page.
> 
> You can think of it as the performance advantage of a purpose built
> ASIC versus a general purpose CPU. The fact is we are able to cut out
> much of the unnecessary overhead if we know exactly how we are going
> to use the memory in the driver versus having to guess at it in the
> page pool API.

In general, I would agree with that.
But for the specific case with mlx5, I am not sure about that, that's
why I am curious about what is the exact reason about it doing the
complicated frag_count handing in the driver instead of improving
the page pool to support it's usecase, if it is about the last frag
truesize problem here, we can do something like virtio_net do in the
page pool too.

> 
> .
> 

