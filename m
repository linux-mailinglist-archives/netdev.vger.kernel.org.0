Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909FB3B9E75
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 11:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhGBJor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 05:44:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230476AbhGBJoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 05:44:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625218934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bxwKO+TgelEV59wHN0aU2wt3K0vBg//dDFe7XB1ce7E=;
        b=F4ach72GgX/rgKB3+Ap/AHxx9hVSUuM0PcUKLIoRt4oq7qy9PpAXMRcGVGQY29v+Pd7Vqu
        BgeaDb/ci4wE1UvzEkv7tgXOXXoxd9lxfzPJgg3w05jCvuYXfio2lPuAmsg6/Ht6iwgUxL
        nQQmeVW5LucALrg15asGU/NeNaGlQ54=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-nZwYnQ5pOO-_Z0Zn3jsyrA-1; Fri, 02 Jul 2021 05:42:13 -0400
X-MC-Unique: nZwYnQ5pOO-_Z0Zn3jsyrA-1
Received: by mail-ed1-f71.google.com with SMTP id ee28-20020a056402291cb0290394a9a0bfaeso4799839edb.6
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 02:42:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bxwKO+TgelEV59wHN0aU2wt3K0vBg//dDFe7XB1ce7E=;
        b=AjDDCBrTeOQla1rlMhUXvOPgwiP7+JCCvCUa6nuPcJggSzUuyAybXivIdlN6KpMSBp
         dwTh/yExNhYVN6A4nJnr+Lwuv5iF4oD1gXimvg5X3HKGnhULOeU8B8A7f0yqzxVVd3pQ
         T6yLlPNrAKTI8mCXl/kVKpPMeYMljjpd9D8G1+R79vwwTgLzcdyeN9tzTcEWa+StgMgv
         UxQWgaGHgNG8MGY3jSTsinH/zi543MT4YbKiOGjtJhLoP140tdK82V16Dvg45uV7Gek1
         PytvIc/0WsdLuBCoEL0yVi1JbFWs6OGb4aReraNBnYL8z7CIkLt9ViUi/rr5hMuP1TyO
         ZOhA==
X-Gm-Message-State: AOAM530ZfpiBUI0CD73u+YTDk0uSgwmHSwxxGDMWjW6SvFPCxc3Q5Eby
        i+sLrntnzX7szvWcy5uf6QiyNNez3Sob8vpxbQxd+nQ79gLWFsmnB7zCemWxu5iqN/6Kxs9iJTZ
        oswl/w2sy8FYEGt5l
X-Received: by 2002:a17:907:9d1:: with SMTP id bx17mr4458908ejc.322.1625218931896;
        Fri, 02 Jul 2021 02:42:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXQq2Jx5p3GqWzgfje8ySA7IuGECFOa3d4+7aEND9A5+IbSzdoCyPoB1grnU8zZJ4lXr2uww==
X-Received: by 2002:a17:907:9d1:: with SMTP id bx17mr4458853ejc.322.1625218931404;
        Fri, 02 Jul 2021 02:42:11 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id h8sm864954ejj.22.2021.07.02.02.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 02:42:11 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH net-next RFC 1/2] page_pool: add page recycling support
 based on elevated refcnt
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linuxarm@openeuler.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, thomas.petazzoni@bootlin.com,
        mw@semihalf.com, linux@armlinux.org.uk, hawk@kernel.org,
        ilias.apalodimas@linaro.org, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, akpm@linux-foundation.org,
        peterz@infradead.org, will@kernel.org, willy@infradead.org,
        vbabka@suse.cz, fenghua.yu@intel.com, guro@fb.com,
        peterx@redhat.com, feng.tang@intel.com, jgg@ziepe.ca,
        mcroce@microsoft.com, hughd@google.com, jonathan.lemon@gmail.com,
        alobakin@pm.me, willemb@google.com, wenxu@ucloud.cn,
        cong.wang@bytedance.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
Message-ID: <6c2d76e2-30ce-5c0f-9d71-f6b71f9ad34f@redhat.com>
Date:   Fri, 2 Jul 2021 11:42:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30/06/2021 11.17, Yunsheng Lin wrote:
> Currently page pool only support page recycling only when
> refcnt of page is one, which means it can not support the
> split page recycling implemented in the most ethernet driver.

Cc. Alex Duyck as I consider him an expert in this area.


> So add elevated refcnt support in page pool, and support
> allocating page frag to enable multi-frames-per-page based
> on the elevated refcnt support.
>
> As the elevated refcnt is per page, and there is no space
> for that in "struct page" now, so add a dynamically allocated
> "struct page_pool_info" to record page pool ptr and refcnt
> corrsponding to a page for now. Later, we can recycle the
> "struct page_pool_info" too, or use part of page memory to
> record pp_info.

I'm not happy with allocating a memory (slab) object "struct 
page_pool_info" per page.

This also gives us an extra level of indirection.


You are also adding a page "frag" API inside page pool, which I'm not 
100% convinced belongs inside page_pool APIs.

Please notice the APIs that Alex Duyck added in mm/page_alloc.c:

  __page_frag_cache_refill() + __page_frag_cache_drain() + 
page_frag_alloc_align()


No more comments below, but kept it if Alex wants to review the details.

> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>   drivers/net/ethernet/marvell/mvneta.c           |   6 +-
>   drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |   2 +-
>   include/linux/mm_types.h                        |   2 +-
>   include/linux/skbuff.h                          |   4 +-
>   include/net/page_pool.h                         |  30 +++-
>   net/core/page_pool.c                            | 215 ++++++++++++++++++++----
>   6 files changed, 207 insertions(+), 52 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 88a7550..5a29af2 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2327,7 +2327,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>   	if (!skb)
>   		return ERR_PTR(-ENOMEM);
>   
> -	skb_mark_for_recycle(skb, virt_to_page(xdp->data), pool);
> +	skb_mark_for_recycle(skb);
>   
>   	skb_reserve(skb, xdp->data - xdp->data_hard_start);
>   	skb_put(skb, xdp->data_end - xdp->data);
> @@ -2339,10 +2339,6 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>   		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
>   				skb_frag_page(frag), skb_frag_off(frag),
>   				skb_frag_size(frag), PAGE_SIZE);
> -		/* We don't need to reset pp_recycle here. It's already set, so
> -		 * just mark fragments for recycling.
> -		 */
> -		page_pool_store_mem_info(skb_frag_page(frag), pool);
>   	}
>   
>   	return skb;
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 3135220..540e387 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -3997,7 +3997,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>   		}
>   
>   		if (pp)
> -			skb_mark_for_recycle(skb, page, pp);
> +			skb_mark_for_recycle(skb);
>   		else
>   			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
>   					       bm_pool->buf_size, DMA_FROM_DEVICE,
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 862f88a..cf613df 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -101,7 +101,7 @@ struct page {
>   			 * page_pool allocated pages.
>   			 */
>   			unsigned long pp_magic;
> -			struct page_pool *pp;
> +			struct page_pool_info *pp_info;
>   			unsigned long _pp_mapping_pad;
>   			/**
>   			 * @dma_addr: might require a 64-bit value on
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index b2db9cd..7795979 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4711,11 +4711,9 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
>   }
>   
>   #ifdef CONFIG_PAGE_POOL
> -static inline void skb_mark_for_recycle(struct sk_buff *skb, struct page *page,
> -					struct page_pool *pp)
> +static inline void skb_mark_for_recycle(struct sk_buff *skb)
>   {
>   	skb->pp_recycle = 1;
> -	page_pool_store_mem_info(page, pp);
>   }
>   #endif
>   
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 3dd62dd..44e7545 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -45,7 +45,9 @@
>   					* Please note DMA-sync-for-CPU is still
>   					* device driver responsibility
>   					*/
> -#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
> +#define PP_FLAG_PAGECNT_BIAS	BIT(2)	/* Enable elevated refcnt */
> +#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV |\
> +				 PP_FLAG_PAGECNT_BIAS)
>   
>   /*
>    * Fast allocation side cache array/stack
> @@ -77,6 +79,7 @@ struct page_pool_params {
>   	enum dma_data_direction dma_dir; /* DMA mapping direction */
>   	unsigned int	max_len; /* max DMA sync memory size */
>   	unsigned int	offset;  /* DMA addr offset */
> +	unsigned int	frag_size;
>   };
>   
>   struct page_pool {
> @@ -88,6 +91,8 @@ struct page_pool {
>   	unsigned long defer_warn;
>   
>   	u32 pages_state_hold_cnt;
> +	unsigned int frag_offset;
> +	struct page *frag_page;
>   
>   	/*
>   	 * Data structure for allocation side
> @@ -128,6 +133,11 @@ struct page_pool {
>   	u64 destroy_cnt;
>   };
>   
> +struct page_pool_info {
> +	struct page_pool *pp;
> +	int pagecnt_bias;
> +};
> +
>   struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
>   
>   static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
> @@ -137,6 +147,17 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
>   	return page_pool_alloc_pages(pool, gfp);
>   }
>   
> +struct page *page_pool_alloc_frag(struct page_pool *pool,
> +				  unsigned int *offset, gfp_t gfp);
> +
> +static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
> +						    unsigned int *offset)
> +{
> +	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
> +
> +	return page_pool_alloc_frag(pool, offset, gfp);
> +}
> +
>   /* get the stored dma direction. A driver might decide to treat this locally and
>    * avoid the extra cache line from page_pool to determine the direction
>    */
> @@ -253,11 +274,4 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
>   		spin_unlock_bh(&pool->ring.producer_lock);
>   }
>   
> -/* Store mem_info on struct page and use it while recycling skb frags */
> -static inline
> -void page_pool_store_mem_info(struct page *page, struct page_pool *pp)
> -{
> -	page->pp = pp;
> -}
> -
>   #endif /* _NET_PAGE_POOL_H */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 5e4eb45..95d94a7 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -206,6 +206,49 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>   	return true;
>   }
>   
> +static int page_pool_set_pp_info(struct page_pool *pool,
> +				 struct page *page, gfp_t gfp)
> +{
> +	struct page_pool_info *pp_info;
> +
> +	pp_info = kzalloc_node(sizeof(*pp_info), gfp, pool->p.nid);
> +	if (!pp_info)
> +		return -ENOMEM;
> +
> +	if (pool->p.flags & PP_FLAG_PAGECNT_BIAS) {
> +		page_ref_add(page, USHRT_MAX);
> +		pp_info->pagecnt_bias = USHRT_MAX;
> +	} else {
> +		pp_info->pagecnt_bias = 0;
> +	}
> +
> +	page->pp_magic |= PP_SIGNATURE;
> +	pp_info->pp = pool;
> +	page->pp_info = pp_info;
> +	return 0;
> +}
> +
> +static int page_pool_clear_pp_info(struct page *page)
> +{
> +	struct page_pool_info *pp_info = page->pp_info;
> +	int bias;
> +
> +	bias = pp_info->pagecnt_bias;
> +
> +	kfree(pp_info);
> +	page->pp_info = NULL;
> +	page->pp_magic = 0;
> +
> +	return bias;
> +}
> +
> +static void page_pool_clear_and_drain_page(struct page *page)
> +{
> +	int bias = page_pool_clear_pp_info(page);
> +
> +	__page_frag_cache_drain(page, bias + 1);
> +}
> +
>   static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
>   						 gfp_t gfp)
>   {
> @@ -216,13 +259,16 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
>   	if (unlikely(!page))
>   		return NULL;
>   
> -	if ((pool->p.flags & PP_FLAG_DMA_MAP) &&
> -	    unlikely(!page_pool_dma_map(pool, page))) {
> +	if (unlikely(page_pool_set_pp_info(pool, page, gfp))) {
>   		put_page(page);
>   		return NULL;
>   	}
>   
> -	page->pp_magic |= PP_SIGNATURE;
> +	if ((pool->p.flags & PP_FLAG_DMA_MAP) &&
> +	    unlikely(!page_pool_dma_map(pool, page))) {
> +		page_pool_clear_and_drain_page(page);
> +		return NULL;
> +	}
>   
>   	/* Track how many pages are held 'in-flight' */
>   	pool->pages_state_hold_cnt++;
> @@ -261,12 +307,17 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>   	 */
>   	for (i = 0; i < nr_pages; i++) {
>   		page = pool->alloc.cache[i];
> +		if (unlikely(page_pool_set_pp_info(pool, page, gfp))) {
> +			put_page(page);
> +			continue;
> +		}
> +
>   		if ((pp_flags & PP_FLAG_DMA_MAP) &&
>   		    unlikely(!page_pool_dma_map(pool, page))) {
> -			put_page(page);
> +			page_pool_clear_and_drain_page(page);
>   			continue;
>   		}
> -		page->pp_magic |= PP_SIGNATURE;
> +
>   		pool->alloc.cache[pool->alloc.count++] = page;
>   		/* Track how many pages are held 'in-flight' */
>   		pool->pages_state_hold_cnt++;
> @@ -284,6 +335,25 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>   	return page;
>   }
>   
> +static void page_pool_sub_bias(struct page *page, int nr)
> +{
> +	struct page_pool_info *pp_info = page->pp_info;
> +
> +	/* "pp_info->pagecnt_bias == 0" indicates the PAGECNT_BIAS
> +	 * flags is not set.
> +	 */
> +	if (!pp_info->pagecnt_bias)
> +		return;
> +
> +	/* Make sure pagecnt_bias > 0 for elevated refcnt case */
> +	if (unlikely(pp_info->pagecnt_bias <= nr)) {
> +		page_ref_add(page, USHRT_MAX);
> +		pp_info->pagecnt_bias += USHRT_MAX;
> +	}
> +
> +	pp_info->pagecnt_bias -= nr;
> +}
> +
>   /* For using page_pool replace: alloc_pages() API calls, but provide
>    * synchronization guarantee for allocation side.
>    */
> @@ -293,15 +363,66 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
>   
>   	/* Fast-path: Get a page from cache */
>   	page = __page_pool_get_cached(pool);
> -	if (page)
> +	if (page) {
> +		page_pool_sub_bias(page, 1);
>   		return page;
> +	}
>   
>   	/* Slow-path: cache empty, do real allocation */
>   	page = __page_pool_alloc_pages_slow(pool, gfp);
> +	if (page)
> +		page_pool_sub_bias(page, 1);
> +
>   	return page;
>   }
>   EXPORT_SYMBOL(page_pool_alloc_pages);
>   
> +struct page *page_pool_alloc_frag(struct page_pool *pool,
> +				  unsigned int *offset, gfp_t gfp)
> +{
> +	unsigned int frag_offset = pool->frag_offset;
> +	unsigned int frag_size = pool->p.frag_size;
> +	struct page *frag_page = pool->frag_page;
> +	unsigned int max_len = pool->p.max_len;
> +
> +	if (!frag_page || frag_offset + frag_size > max_len) {
> +		frag_page = page_pool_alloc_pages(pool, gfp);
> +		if (unlikely(!frag_page)) {
> +			pool->frag_page = NULL;
> +			return NULL;
> +		}
> +
> +		pool->frag_page = frag_page;
> +		frag_offset = 0;
> +
> +		page_pool_sub_bias(frag_page, max_len / frag_size - 1);
> +	}
> +
> +	*offset = frag_offset;
> +	pool->frag_offset = frag_offset + frag_size;
> +
> +	return frag_page;
> +}
> +EXPORT_SYMBOL(page_pool_alloc_frag);
> +
> +static void page_pool_empty_frag(struct page_pool *pool)
> +{
> +	unsigned int frag_offset = pool->frag_offset;
> +	unsigned int frag_size = pool->p.frag_size;
> +	struct page *frag_page = pool->frag_page;
> +	unsigned int max_len = pool->p.max_len;
> +
> +	if (!frag_page)
> +		return;
> +
> +	while (frag_offset + frag_size <= max_len) {
> +		page_pool_put_full_page(pool, frag_page, false);
> +		frag_offset += frag_size;
> +	}
> +
> +	pool->frag_page = NULL;
> +}
> +
>   /* Calculate distance between two u32 values, valid if distance is below 2^(31)
>    *  https://en.wikipedia.org/wiki/Serial_number_arithmetic#General_Solution
>    */
> @@ -326,10 +447,11 @@ static s32 page_pool_inflight(struct page_pool *pool)
>    * a regular page (that will eventually be returned to the normal
>    * page-allocator via put_page).
>    */
> -void page_pool_release_page(struct page_pool *pool, struct page *page)
> +static int __page_pool_release_page(struct page_pool *pool,
> +				    struct page *page)
>   {
>   	dma_addr_t dma;
> -	int count;
> +	int bias, count;
>   
>   	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
>   		/* Always account for inflight pages, even if we didn't
> @@ -345,22 +467,29 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>   			     DMA_ATTR_SKIP_CPU_SYNC);
>   	page_pool_set_dma_addr(page, 0);
>   skip_dma_unmap:
> -	page->pp_magic = 0;
> +	bias = page_pool_clear_pp_info(page);
>   
>   	/* This may be the last page returned, releasing the pool, so
>   	 * it is not safe to reference pool afterwards.
>   	 */
>   	count = atomic_inc_return(&pool->pages_state_release_cnt);
>   	trace_page_pool_state_release(pool, page, count);
> +	return bias;
> +}
> +
> +void page_pool_release_page(struct page_pool *pool, struct page *page)
> +{
> +	int bias = __page_pool_release_page(pool, page);
> +
> +	WARN_ONCE(bias, "PAGECNT_BIAS is not supposed to be enabled\n");
>   }
>   EXPORT_SYMBOL(page_pool_release_page);
>   
>   /* Return a page to the page allocator, cleaning up our state */
>   static void page_pool_return_page(struct page_pool *pool, struct page *page)
>   {
> -	page_pool_release_page(pool, page);
> +	__page_frag_cache_drain(page, __page_pool_release_page(pool, page) + 1);
>   
> -	put_page(page);
>   	/* An optimization would be to call __free_pages(page, pool->p.order)
>   	 * knowing page is not part of page-cache (thus avoiding a
>   	 * __page_cache_release() call).
> @@ -395,7 +524,16 @@ static bool page_pool_recycle_in_cache(struct page *page,
>   	return true;
>   }
>   
> -/* If the page refcnt == 1, this will try to recycle the page.
> +static bool page_pool_bias_page_recyclable(struct page *page, int bias)
> +{
> +	int ref = page_ref_dec_return(page);
> +
> +	WARN_ON(ref < bias);
> +	return ref == bias + 1;
> +}
> +
> +/* If pagecnt_bias == 0 and the page refcnt == 1, this will try to
> + * recycle the page.
>    * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
>    * the configured size min(dma_sync_size, pool->max_len).
>    * If the page refcnt != 1, then the page will be returned to memory
> @@ -405,16 +543,35 @@ static __always_inline struct page *
>   __page_pool_put_page(struct page_pool *pool, struct page *page,
>   		     unsigned int dma_sync_size, bool allow_direct)
>   {
> -	/* This allocator is optimized for the XDP mode that uses
> +	int bias = page->pp_info->pagecnt_bias;
> +
> +	/* Handle the elevated refcnt case first:
> +	 * multi-frames-per-page, it is likely from the skb, which
> +	 * is likely called in non-sofrirq context, so do not recycle
> +	 * it in pool->alloc.
> +	 *
> +	 * Then handle non-elevated refcnt case:
>   	 * one-frame-per-page, but have fallbacks that act like the
>   	 * regular page allocator APIs.
> -	 *
>   	 * refcnt == 1 means page_pool owns page, and can recycle it.
>   	 *
>   	 * page is NOT reusable when allocated when system is under
>   	 * some pressure. (page_is_pfmemalloc)
>   	 */
> -	if (likely(page_ref_count(page) == 1 && !page_is_pfmemalloc(page))) {
> +	if (bias) {
> +		/* We have gave some refcnt to the stack, so wait for
> +		 * all refcnt of the stack to be decremented before
> +		 * enabling recycling.
> +		 */
> +		if (!page_pool_bias_page_recyclable(page, bias))
> +			return NULL;
> +
> +		/* only enable recycling when it is not pfmemalloced */
> +		if (!page_is_pfmemalloc(page))
> +			return page;
> +
> +	} else if (likely(page_ref_count(page) == 1 &&
> +			  !page_is_pfmemalloc(page))) {
>   		/* Read barrier done in page_ref_count / READ_ONCE */
>   
>   		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> @@ -428,22 +585,8 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>   		/* Page found as candidate for recycling */
>   		return page;
>   	}
> -	/* Fallback/non-XDP mode: API user have elevated refcnt.
> -	 *
> -	 * Many drivers split up the page into fragments, and some
> -	 * want to keep doing this to save memory and do refcnt based
> -	 * recycling. Support this use case too, to ease drivers
> -	 * switching between XDP/non-XDP.
> -	 *
> -	 * In-case page_pool maintains the DMA mapping, API user must
> -	 * call page_pool_put_page once.  In this elevated refcnt
> -	 * case, the DMA is unmapped/released, as driver is likely
> -	 * doing refcnt based recycle tricks, meaning another process
> -	 * will be invoking put_page.
> -	 */
> -	/* Do not replace this with page_pool_return_page() */
> +
>   	page_pool_release_page(pool, page);
> -	put_page(page);
>   
>   	return NULL;
>   }
> @@ -452,6 +595,7 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
>   			unsigned int dma_sync_size, bool allow_direct)
>   {
>   	page = __page_pool_put_page(pool, page, dma_sync_size, allow_direct);
> +
>   	if (page && !page_pool_recycle_in_ring(pool, page)) {
>   		/* Cache full, fallback to free pages */
>   		page_pool_return_page(pool, page);
> @@ -503,8 +647,11 @@ static void page_pool_empty_ring(struct page_pool *pool)
>   
>   	/* Empty recycle ring */
>   	while ((page = ptr_ring_consume_bh(&pool->ring))) {
> -		/* Verify the refcnt invariant of cached pages */
> -		if (!(page_ref_count(page) == 1))
> +		/* Verify the refcnt invariant of cached pages for
> +		 * non elevated refcnt case.
> +		 */
> +		if (!(pool->p.flags & PP_FLAG_PAGECNT_BIAS) &&
> +		    !(page_ref_count(page) == 1))
>   			pr_crit("%s() page_pool refcnt %d violation\n",
>   				__func__, page_ref_count(page));
>   
> @@ -544,6 +691,7 @@ static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
>   
>   static void page_pool_scrub(struct page_pool *pool)
>   {
> +	page_pool_empty_frag(pool);
>   	page_pool_empty_alloc_cache_once(pool);
>   	pool->destroy_cnt++;
>   
> @@ -637,14 +785,13 @@ bool page_pool_return_skb_page(struct page *page)
>   	if (unlikely(page->pp_magic != PP_SIGNATURE))
>   		return false;
>   
> -	pp = page->pp;
> +	pp = page->pp_info->pp;
>   
>   	/* Driver set this to memory recycling info. Reset it on recycle.
>   	 * This will *not* work for NIC using a split-page memory model.
>   	 * The page will be returned to the pool here regardless of the
>   	 * 'flipped' fragment being in use or not.
>   	 */
> -	page->pp = NULL;
>   	page_pool_put_full_page(pp, page, false);
>   
>   	return true;

