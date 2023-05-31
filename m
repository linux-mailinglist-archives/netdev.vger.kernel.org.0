Return-Path: <netdev+bounces-6780-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 665E5717F42
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB2B22814A5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1691427D;
	Wed, 31 May 2023 11:55:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE53D13AEC
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:55:16 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A912101;
	Wed, 31 May 2023 04:55:13 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QWSJ73lLlzqTNP;
	Wed, 31 May 2023 19:50:31 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 31 May
 2023 19:55:10 +0800
Subject: Re: [PATCH net-next v2 1/3] page_pool: unify frag page and non-frag
 page handling
To: Alexander H Duyck <alexander.duyck@gmail.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-2-linyunsheng@huawei.com>
 <e8db47e3fe99349a998ded1ce4f8da88ea9cc660.camel@gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5d728f88-2bd0-7e78-90d5-499e85dc6fdf@huawei.com>
Date: Wed, 31 May 2023 19:55:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <e8db47e3fe99349a998ded1ce4f8da88ea9cc660.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/30 23:07, Alexander H Duyck wrote:
> On Mon, 2023-05-29 at 17:28 +0800, Yunsheng Lin wrote:
>> Currently page_pool_dev_alloc_pages() can not be called
>> when PP_FLAG_PAGE_FRAG is set, because it does not use
>> the frag reference counting.
>>
>> As we are already doing a optimization by not updating
>> page->pp_frag_count in page_pool_defrag_page() for the
>> last frag user, and non-frag page only have one user,
>> so we utilize that to unify frag page and non-frag page
>> handling, so that page_pool_dev_alloc_pages() can also
>> be called with PP_FLAG_PAGE_FRAG set.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> CC: Lorenzo Bianconi <lorenzo@kernel.org>
>> CC: Alexander Duyck <alexander.duyck@gmail.com>
> 
> I"m not really a huge fan of the approach. Basically it looks like you
> are trying to turn every page pool page into a fragmented page. Why not
> just stick to keeping the fragemented pages and have a special case
> that just generates a mono-frag page for your allocator instead.

Let me try to describe what does this patch try to do and how it
do that in more detailed in order to have more common understanding.

Before this patch:

As we use PP_FLAG_PAGE_FRAG to decide whether to check the frag count
in page_pool_is_last_frag() when page is returned back to page pool,
so:

1. PAGE_POOL_DMA_USE_PP_FRAG_COUNT being true case: page_pool_create()
   fails when it is called with PP_FLAG_PAGE_FRAG set, if user calls
   page_pool_alloc_frag(), then we warn about it and return NULL.

2. PAGE_POOL_DMA_USE_PP_FRAG_COUNT being false case:
   (1). page_pool_create() is called with PP_FLAG_PAGE_FRAG set:
        page_pool_alloc_pages() is not allowed to be called as the
        page->pp_frag_count is not setup correctly for the case.
   (2). page_pool_create() is called without PP_FLAG_PAGE_FRAG set:
        page_pool_alloc_frag() is not allowed to be called as the
        page->pp_frag_count is not checked in page_pool_is_last_frag().

and mlx5 using a mix of the about:
page_pool_create() is called with with PP_FLAG_PAGE_FRAG,
page_pool_dev_alloc_pages() is called to allocate a page and
page_pool_fragment_page() is called to setup the page->pp_frag_count
correctly so the page_pool_is_last_frag() can see the correct
page->pp_frag_count, mlx5 driver handling the frag count is in the
below, it is complicated and I am not sure if there are any added
benefit that can justify the complication yet:
https://www.spinics.net/lists/netdev/msg892893.html

There are usecases for veth and virtio_net to use frag support
in page pool to reduce memory usage, and it may request different
frag size depending on the head/tail room space for xdp_frame/shinfo
and mtu/packet size. When the requested frag size is large enough
that a single page can not be split into more than one frag, using
frag support only have performance penalty because of the extra frag
count handling for frag support.
So to avoid driver handling the page->pp_frag_count directly and driver
calling different page pool API according to memory size, we need to
way to unify the page_pool_is_last_frag() for frag and non-frag page.

1. https://patchwork.kernel.org/project/netdevbpf/patch/d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org/
2. https://patchwork.kernel.org/project/netdevbpf/patch/20230526054621.18371-3-liangchen.linux@gmail.com/

After this patch:
This patch ensure pp_frag_count of page from pool->alloc/pool->ring or
newly allocated from page allocator is one, which means we assume that
all pages have one frag user initially so that we can have a unified
handling for frag and non-frag page in page_pool_is_last_frag().

So the key point in this patch is about unified handling in
page_pool_is_last_frag(), which is the free/put side of page pool,
not the alloc/generate side.

Utilizing the page->pp_frag_count being one initially for every page
is the least costly way to do that as best as I can think of.
As it only add the cost of page_pool_fragment_page() for non-frag page
case as you have mentioned below, which I think it is negligible as we
are already dirtying the same cache line in page_pool_set_pp_info().
And for frag page, we avoid the reseting page->pp_frag_count to one by
utilizing the optimization of not updating page->pp_frag_count in
page_pool_defrag_page() for the last frag user.

Please let me know if the above makes sense, or if misunderstood your
concern here.

> 
> The problem is there are some architectures where we just cannot
> support having pp_frag_count due to the DMA size. So it makes sense to
> leave those with just basic page pool instead of trying to fake that it
> is a fragmented page.

It kind of depend on how you veiw it, this patch view it as only supporting
one frag when we can't support having pp_frag_count, so I would not call it
faking.

> 
>> ---
>>  include/net/page_pool.h | 38 +++++++++++++++++++++++++++++++-------
>>  net/core/page_pool.c    |  1 +
>>  2 files changed, 32 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index c8ec2f34722b..ea7a0c0592a5 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -50,6 +50,9 @@
>>  				 PP_FLAG_DMA_SYNC_DEV |\
>>  				 PP_FLAG_PAGE_FRAG)
>>  
>> +#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT \
>> +		(sizeof(dma_addr_t) > sizeof(unsigned long))
>> +
>>  /*
>>   * Fast allocation side cache array/stack
>>   *
>> @@ -295,13 +298,20 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
>>   */
>>  static inline void page_pool_fragment_page(struct page *page, long nr)
>>  {
>> -	atomic_long_set(&page->pp_frag_count, nr);
>> +	if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
>> +		atomic_long_set(&page->pp_frag_count, nr);
>>  }
>>  
>> +/* We need to reset frag_count back to 1 for the last user to allow
>> + * only one user in case the page is recycled and allocated as non-frag
>> + * page.
>> + */
>>  static inline long page_pool_defrag_page(struct page *page, long nr)
>>  {
>>  	long ret;
>>  
>> +	BUILD_BUG_ON(__builtin_constant_p(nr) && nr != 1);
>> +
> 
> What is the point of this line? It doesn't make much sense to me. Are
> you just trying to force an optiimization? You would be better off just
> taking the BUILD_BUG_ON contents and feeding them into an if statement
> below since the statement will compile out anyway.

if the "if statement" you said refers to the below, then yes.

>> +		if (!__builtin_constant_p(nr))
>> +			atomic_long_set(&page->pp_frag_count, 1);

But it is a *BUILD*_BUG_ON(), isn't it compiled out anywhere we put it?

Will move it down anyway to avoid confusion.

> 
> It seems like what you would want here is:
> 	BUG_ON(!PAGE_POOL_DMA_USE_PP_FRAG_COUNT);
> 
> Otherwise you are potentially writing to a variable that shouldn't
> exist.

Not if the driver use the page_pool_alloc_frag() API instead of manipulating
the page->pp_frag_count directly using the page_pool_defrag_page() like mlx5.
The mlx5 call the page_pool_create() with with PP_FLAG_PAGE_FRAG set, and
it does not seems to have a failback for PAGE_POOL_DMA_USE_PP_FRAG_COUNT
case, and we may need to keep PP_FLAG_PAGE_FRAG for it. That's why we need
to keep the driver from implementation detail(pp_frag_count handling specifically)
of the frag support unless we have a very good reason.

> 
>>  	/* If nr == pp_frag_count then we have cleared all remaining
>>  	 * references to the page. No need to actually overwrite it, instead
>>  	 * we can leave this to be overwritten by the calling function.
>> @@ -311,19 +321,36 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
>>  	 * especially when dealing with a page that may be partitioned
>>  	 * into only 2 or 3 pieces.
>>  	 */
>> -	if (atomic_long_read(&page->pp_frag_count) == nr)
>> +	if (atomic_long_read(&page->pp_frag_count) == nr) {
>> +		/* As we have ensured nr is always one for constant case
>> +		 * using the BUILD_BUG_ON() as above, only need to handle
>> +		 * the non-constant case here for frag count draining.
>> +		 */
>> +		if (!__builtin_constant_p(nr))
>> +			atomic_long_set(&page->pp_frag_count, 1);
>> +
>>  		return 0;
>> +	}
>>  
>>  	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
>>  	WARN_ON(ret < 0);
>> +
>> +	/* Reset frag count back to 1, this should be the rare case when
>> +	 * two users call page_pool_defrag_page() currently.
>> +	 */
>> +	if (!ret)
>> +		atomic_long_set(&page->pp_frag_count, 1);
>> +
>>  	return ret;
>>  }
>>  
>>  static inline bool page_pool_is_last_frag(struct page_pool *pool,
>>  					  struct page *page)
>>  {
>> -	/* If fragments aren't enabled or count is 0 we were the last user */
>> -	return !(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
>> +	/* When dma_addr_upper is overlapped with pp_frag_count
>> +	 * or we were the last page frag user.
>> +	 */
>> +	return PAGE_POOL_DMA_USE_PP_FRAG_COUNT ||
>>  	       (page_pool_defrag_page(page, 1) == 0);
>>  }
>>  
>> @@ -357,9 +384,6 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>>  	page_pool_put_full_page(pool, page, true);
>>  }
>>  
>> -#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
>> -		(sizeof(dma_addr_t) > sizeof(unsigned long))
>> -
>>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>>  {
>>  	dma_addr_t ret = page->dma_addr;
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index e212e9d7edcb..0868aa8f6323 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -334,6 +334,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
>>  {
>>  	page->pp = pool;
>>  	page->pp_magic |= PP_SIGNATURE;
>> +	page_pool_fragment_page(page, 1);
>>  	if (pool->p.init_callback)
>>  		pool->p.init_callback(page, pool->p.init_arg);
>>  }
> 
> Again, you are adding statements here that now have to be stripped out
> under specific circumstances. In my opinion it would be better to not
> modify base page pool pages and instead just have your allocator
> provide a 1 frag page pool page via a special case allocator rather
> then messing with all the other drivers.

As above, it is about unifying handling for frag and non-frag page in
page_pool_is_last_frag(). please let me know if there is any better way
to do it without adding statements here.

> .
> 

