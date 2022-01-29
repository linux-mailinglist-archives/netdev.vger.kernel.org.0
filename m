Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B7E4A2D54
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 10:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiA2JUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 04:20:41 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:32072 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiA2JUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 04:20:40 -0500
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Jm7xN2N61z1FCrm;
        Sat, 29 Jan 2022 17:16:40 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 29 Jan 2022 17:20:38 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Sat, 29 Jan
 2022 17:20:38 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
Subject: Re: [net-next PATCH v2] page_pool: Refactor page_pool to enable
 fragmenting after allocation
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        <netdev@vger.kernel.org>
CC:     <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <alexanderduyck@fb.com>
References: <164329517024.130462.875087745767169286.stgit@localhost.localdomain>
Message-ID: <eae2e24f-03c7-8e92-9e70-8a50d620c1ca@huawei.com>
Date:   Sat, 29 Jan 2022 17:20:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <164329517024.130462.875087745767169286.stgit@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/1/27 22:57, Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> This change is meant to permit a driver to perform "fragmenting" of the
> page from within the driver instead of the current model which requires
> pre-partitioning the page. The main motivation behind this is to support
> use cases where the page will be split up by the driver after DMA instead
> of before.
> 
> With this change it becomes possible to start using page pool to replace
> some of the existing use cases where multiple references were being used
> for a single page, but the number needed was unknown as the size could be
> dynamic.
> 
> For example, with this code it would be possible to do something like
> the following to handle allocation:
>   page = page_pool_alloc_pages();
>   if (!page)
>     return NULL;
>   page_pool_fragment_page(page, DRIVER_PAGECNT_BIAS_MAX);
>   rx_buf->page = page;
>   rx_buf->pagecnt_bias = DRIVER_PAGECNT_BIAS_MAX;
> 
> Then we would process a received buffer by handling it with:
>   rx_buf->pagecnt_bias--;
> 
> Once the page has been fully consumed we could then flush the remaining
> instances with:
>   if (page_pool_defrag_page(page, rx_buf->pagecnt_bias))
>     continue;
>   page_pool_put_defragged_page(pool, page -1, !!budget);

page_pool_put_defragged_page(pool, page, -1, !!budget);

Also I am not sure exporting the frag count to the driver is a good
idea, as the above example seems a little complex, maybe adding
the fragmenting after allocation support for a existing driver
is a good way to show if the API is really a good one.


> 
> The general idea is that we want to have the ability to allocate a page
> with excess fragment count and then trim off the unneeded fragments.
> 
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
> 
> v2: Added page_pool_is_last_frag
>     Moved comment about CONFIG_PAGE_POOL to page_pool_put_page
>     Wrapped statements for page_pool_is_last_frag in parenthesis
> 
>  include/net/page_pool.h |   82 ++++++++++++++++++++++++++++++-----------------
>  net/core/page_pool.c    |   23 ++++++-------
>  2 files changed, 62 insertions(+), 43 deletions(-)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 79a805542d0f..fbed91469d42 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -201,21 +201,67 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>  }
>  #endif
>  
> -void page_pool_put_page(struct page_pool *pool, struct page *page,
> -			unsigned int dma_sync_size, bool allow_direct);
> +void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
> +				  unsigned int dma_sync_size,
> +				  bool allow_direct);
>  
> -/* Same as above but will try to sync the entire area pool->max_len */
> -static inline void page_pool_put_full_page(struct page_pool *pool,
> -					   struct page *page, bool allow_direct)
> +static inline void page_pool_fragment_page(struct page *page, long nr)
> +{
> +	atomic_long_set(&page->pp_frag_count, nr);
> +}
> +
> +static inline long page_pool_defrag_page(struct page *page, long nr)
> +{
> +	long ret;
> +
> +	/* If nr == pp_frag_count then we are have cleared all remaining
> +	 * references to the page. No need to actually overwrite it, instead
> +	 * we can leave this to be overwritten by the calling function.
> +	 *
> +	 * The main advantage to doing this is that an atomic_read is
> +	 * generally a much cheaper operation than an atomic update,
> +	 * especially when dealing with a page that may be partitioned
> +	 * into only 2 or 3 pieces.
> +	 */
> +	if (atomic_long_read(&page->pp_frag_count) == nr)
> +		return 0;
> +
> +	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> +	WARN_ON(ret < 0);
> +	return ret;
> +}
> +
> +static inline bool page_pool_is_last_frag(struct page_pool *pool,
> +					  struct page *page)
> +{
> +	/* If fragments aren't enabled or count is 0 we were the last user */
> +	return !(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
> +	       (page_pool_defrag_page(page, 1) == 0);
> +}
> +
> +static inline void page_pool_put_page(struct page_pool *pool,
> +				      struct page *page,
> +				      unsigned int dma_sync_size,
> +				      bool allow_direct)
>  {
>  	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
>  	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
>  	 */
>  #ifdef CONFIG_PAGE_POOL
> -	page_pool_put_page(pool, page, -1, allow_direct);
> +	if (!page_pool_is_last_frag(pool, page))
> +		return;
> +
> +	page_pool_put_defragged_page(pool, page, dma_sync_size, allow_direct);
>  #endif
>  }
>  
> +/* Same as above but will try to sync the entire area pool->max_len */
> +static inline void page_pool_put_full_page(struct page_pool *pool,
> +					   struct page *page, bool allow_direct)
> +{
> +	page_pool_put_page(pool, page, -1, allow_direct);
> +}
> +
>  /* Same as above but the caller must guarantee safe context. e.g NAPI */
>  static inline void page_pool_recycle_direct(struct page_pool *pool,
>  					    struct page *page)
> @@ -243,30 +289,6 @@ static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>  		page->dma_addr_upper = upper_32_bits(addr);
>  }
>  
> -static inline void page_pool_set_frag_count(struct page *page, long nr)
> -{
> -	atomic_long_set(&page->pp_frag_count, nr);
> -}
> -
> -static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
> -							  long nr)
> -{
> -	long ret;
> -
> -	/* As suggested by Alexander, atomic_long_read() may cover up the
> -	 * reference count errors, so avoid calling atomic_long_read() in
> -	 * the cases of freeing or draining the page_frags, where we would
> -	 * not expect it to match or that are slowpath anyway.
> -	 */
> -	if (__builtin_constant_p(nr) &&
> -	    atomic_long_read(&page->pp_frag_count) == nr)
> -		return 0;
> -
> -	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> -	WARN_ON(ret < 0);
> -	return ret;
> -}
> -
>  static inline bool is_page_pool_compiled_in(void)
>  {
>  #ifdef CONFIG_PAGE_POOL
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index bd62c01a2ec3..e25d359d84d9 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -423,11 +423,6 @@ static __always_inline struct page *
>  __page_pool_put_page(struct page_pool *pool, struct page *page,
>  		     unsigned int dma_sync_size, bool allow_direct)
>  {
> -	/* It is not the last user for the page frag case */
> -	if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
> -	    page_pool_atomic_sub_frag_count_return(page, 1))
> -		return NULL;
> -
>  	/* This allocator is optimized for the XDP mode that uses
>  	 * one-frame-per-page, but have fallbacks that act like the
>  	 * regular page allocator APIs.
> @@ -471,8 +466,8 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>  	return NULL;
>  }
>  
> -void page_pool_put_page(struct page_pool *pool, struct page *page,
> -			unsigned int dma_sync_size, bool allow_direct)
> +void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
> +				  unsigned int dma_sync_size, bool allow_direct)
>  {
>  	page = __page_pool_put_page(pool, page, dma_sync_size, allow_direct);
>  	if (page && !page_pool_recycle_in_ring(pool, page)) {
> @@ -480,7 +475,7 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
>  		page_pool_return_page(pool, page);
>  	}
>  }
> -EXPORT_SYMBOL(page_pool_put_page);
> +EXPORT_SYMBOL(page_pool_put_defragged_page);
>  
>  /* Caller must not use data area after call, as this function overwrites it */
>  void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> @@ -491,6 +486,10 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>  	for (i = 0; i < count; i++) {
>  		struct page *page = virt_to_head_page(data[i]);
>  
> +		/* It is not the last user for the page frag case */
> +		if (!page_pool_is_last_frag(pool, page))
> +			continue;
> +
>  		page = __page_pool_put_page(pool, page, -1, false);
>  		/* Approved for bulk recycling in ptr_ring cache */
>  		if (page)
> @@ -526,8 +525,7 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
>  	long drain_count = BIAS_MAX - pool->frag_users;
>  
>  	/* Some user is still using the page frag */
> -	if (likely(page_pool_atomic_sub_frag_count_return(page,
> -							  drain_count)))
> +	if (likely(page_pool_defrag_page(page, drain_count)))
>  		return NULL;
>  
>  	if (page_ref_count(page) == 1 && !page_is_pfmemalloc(page)) {
> @@ -548,8 +546,7 @@ static void page_pool_free_frag(struct page_pool *pool)
>  
>  	pool->frag_page = NULL;
>  
> -	if (!page ||
> -	    page_pool_atomic_sub_frag_count_return(page, drain_count))
> +	if (!page || page_pool_defrag_page(page, drain_count))
>  		return;
>  
>  	page_pool_return_page(pool, page);
> @@ -588,7 +585,7 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
>  		pool->frag_users = 1;
>  		*offset = 0;
>  		pool->frag_offset = size;
> -		page_pool_set_frag_count(page, BIAS_MAX);
> +		page_pool_fragment_page(page, BIAS_MAX);
>  		return page;
>  	}
>  
> 
> 
> .
> 
