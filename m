Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8798C49C4BA
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238057AbiAZHuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238036AbiAZHuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:50:08 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349F5C06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:50:08 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id j23so62555197edp.5
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dWMORSZYVYfBkjChWr8CzvxiFw3XheDssRH8lzO7cZU=;
        b=yxU9lUIMpYU9p6qL1Upq9E4MnCSR7ujhu0QUVj0SVhnCNAi6DOFrn9YrE8EowPk8We
         Gev/X9Yf4tmHVCnUR8GrhvX1pDGVwhjwX5MkbkCRJXUVDwqDgl6O3N557wqR2r0LgtML
         kF0O0cjQTbcR6LRRGzI8xITdics6Jt90bZqcvrUZmgiQobIQeICEuyse5dmzYxyuKFzs
         aH8z6ndF5Qobi8342Vu6c6ZUW9RVoP1c//FX9jgiF3esU3bkvvm4AJ0fM+1Fq4Ot9KEE
         Z8DZKG47VwzT42+bdLSjAieF5opxTo5+8V7JoSIx+kFXbwnIHyAGPZpBj+fSmCPzSIpD
         bCVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dWMORSZYVYfBkjChWr8CzvxiFw3XheDssRH8lzO7cZU=;
        b=d3pvvvFPitX3cXESTmVWmnwUX1SYfl1oZs2DspbLi3M9CproJh/KszqmPkZgyU12Ef
         o8XrzE+ONYANMqpIegnstr/ZS7NL5yksAoTq5QS81LJxM1EX0vwAJHEiqrdFwswAycDd
         wrkPW5FeNEzPXlHp3Ahm+77G83TagSJx9zIoNN1AsTikNhqRABMZufCeaMnuTVU9Ydba
         c6ZKUv2Yh49ZWU7P9jxRVT7qNl5lchYZJ+eg3gTq5UUFZaIJ9pRqZBSnD4PZH2MlDQxy
         HuBcKs8POSG+kW9imr41PLUxquEkYJrGL5Ql5IaIYff+3qop08Pk50wOWgNl5D9Z2SvC
         sRSw==
X-Gm-Message-State: AOAM531zHMauXUaVwrNybf8aMA0baDoKqp17UmsDl0VWLDu4rdzpNkcx
        sUKTB2ls5VSJL7zli9CAbfYbig==
X-Google-Smtp-Source: ABdhPJwo7k72VRCzSLixu8FMhbqH3I6Vdlwa0NhWdieeImZVgi03jondHSTNazaIhqn5yWu7jVJQwA==
X-Received: by 2002:a05:6402:2687:: with SMTP id w7mr17145101edd.381.1643183405826;
        Tue, 25 Jan 2022 23:50:05 -0800 (PST)
Received: from hades (athedsl-4461669.home.otenet.gr. [94.71.4.85])
        by smtp.gmail.com with ESMTPSA id d25sm3451654eje.41.2022.01.25.23.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:50:05 -0800 (PST)
Date:   Wed, 26 Jan 2022 09:50:02 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, hawk@kernel.org, davem@davemloft.net,
        kuba@kernel.org, alexanderduyck@fb.com
Subject: Re: [net-next PATCH] page_pool: Refactor page_pool to enable
 fragmenting after allocation
Message-ID: <YfD9KvMxl4D3+Tyi@hades>
References: <164305938406.3234.4558403245506832559.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164305938406.3234.4558403245506832559.stgit@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander, 

Thanks for the patch

On Mon, Jan 24, 2022 at 01:23:04PM -0800, Alexander Duyck wrote:
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

Any specific use cases you have in mind?

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
> 
> The general idea is that we want to have the ability to allocate a page
> with excess fragment count and then trim off the unneeded fragments.
> 
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  include/net/page_pool.h |   71 ++++++++++++++++++++++++++++-------------------
>  net/core/page_pool.c    |   24 +++++++---------
>  2 files changed, 54 insertions(+), 41 deletions(-)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 79a805542d0f..a437c0383889 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -201,8 +201,49 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>  }
>  #endif
>  
> -void page_pool_put_page(struct page_pool *pool, struct page *page,
> -			unsigned int dma_sync_size, bool allow_direct);
> +void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
> +				  unsigned int dma_sync_size,
> +				  bool allow_direct);
> +
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
> +	 * especially when dealing with a page that may be parititioned
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
> +static inline void page_pool_put_page(struct page_pool *pool,
> +				      struct page *page,
> +				      unsigned int dma_sync_size,
> +				      bool allow_direct)
> +{
> +#ifdef CONFIG_PAGE_POOL
> +	/* It is not the last user for the page frag case */
> +	if (pool->p.flags & PP_FLAG_PAGE_FRAG && page_pool_defrag_page(page, 1))
> +		return;
> +
> +	page_pool_put_defragged_page(pool, page, dma_sync_size, allow_direct);
> +#endif
> +}
>  
>  /* Same as above but will try to sync the entire area pool->max_len */
>  static inline void page_pool_put_full_page(struct page_pool *pool,
> @@ -211,9 +252,7 @@ static inline void page_pool_put_full_page(struct page_pool *pool,
>  	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
>  	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.

nit, but the comment can either go away or move to the new
page_pool_put_page()

>  	 */
> -#ifdef CONFIG_PAGE_POOL
>  	page_pool_put_page(pool, page, -1, allow_direct);
> -#endif
>  }
>  
>  /* Same as above but the caller must guarantee safe context. e.g NAPI */
> @@ -243,30 +282,6 @@ static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
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
> index bd62c01a2ec3..74fda40da51e 100644
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
> @@ -491,6 +486,11 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>  	for (i = 0; i < count; i++) {
>  		struct page *page = virt_to_head_page(data[i]);
>  
> +		/* It is not the last user for the page frag case */
> +		if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
> +		    page_pool_defrag_page(page, 1))
> +			continue;

Would it make sense to have this check on a function?  Something like
page_pool_is_last_frag() or similar? Also for for readability switch do 
(pool->p.flags & PP_FLAG_PAGE_FRAG) && ...

> +
>  		page = __page_pool_put_page(pool, page, -1, false);
>  		/* Approved for bulk recycling in ptr_ring cache */
>  		if (page)
> @@ -526,8 +526,7 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
>  	long drain_count = BIAS_MAX - pool->frag_users;
>  
>  	/* Some user is still using the page frag */
> -	if (likely(page_pool_atomic_sub_frag_count_return(page,
> -							  drain_count)))
> +	if (likely(page_pool_defrag_page(page, drain_count)))
>  		return NULL;
>  
>  	if (page_ref_count(page) == 1 && !page_is_pfmemalloc(page)) {
> @@ -548,8 +547,7 @@ static void page_pool_free_frag(struct page_pool *pool)
>  
>  	pool->frag_page = NULL;
>  
> -	if (!page ||
> -	    page_pool_atomic_sub_frag_count_return(page, drain_count))
> +	if (!page || page_pool_defrag_page(page, drain_count))
>  		return;
>  
>  	page_pool_return_page(pool, page);
> @@ -588,7 +586,7 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
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

Thanks!
/Ilias
