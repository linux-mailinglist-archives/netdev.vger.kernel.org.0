Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0A2DA769
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 10:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393360AbfJQI3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 04:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389585AbfJQI3J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 04:29:09 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8AAB5757C6;
        Thu, 17 Oct 2019 08:29:08 +0000 (UTC)
Received: from carbon (ovpn-200-46.brq.redhat.com [10.40.200.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E169E5C1D6;
        Thu, 17 Oct 2019 08:29:02 +0000 (UTC)
Date:   Thu, 17 Oct 2019 10:29:01 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <ilias.apalodimas@linaro.org>, <saeedm@mellanox.com>,
        <tariqt@mellanox.com>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>, brouer@redhat.com
Subject: Re: [PATCH 08/10 net-next] page_pool: Add statistics
Message-ID: <20191017102901.43a09b35@carbon>
In-Reply-To: <20191016225028.2100206-9-jonathan.lemon@gmail.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
        <20191016225028.2100206-9-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 17 Oct 2019 08:29:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 15:50:26 -0700
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> Add statistics to the page pool, providing visibility into its operation.
> 
> Callers can provide a location where the stats are stored, otherwise
> the page pool will allocate a statistic area.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/net/page_pool.h | 21 +++++++++++++---
>  net/core/page_pool.c    | 55 +++++++++++++++++++++++++++++++++++------
>  2 files changed, 65 insertions(+), 11 deletions(-)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index fc340db42f9a..4f383522b141 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -34,8 +34,11 @@
>  #include <linux/ptr_ring.h>
>  #include <linux/dma-direction.h>
>  
> -#define PP_FLAG_DMA_MAP 1 /* Should page_pool do the DMA map/unmap */
> -#define PP_FLAG_ALL	PP_FLAG_DMA_MAP
> +#define PP_FLAG_DMA_MAP		BIT(0) /* page_pool does the DMA map/unmap */
> +#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP)
> +
> +/* internal flags, not expoed to user */
> +#define PP_FLAG_INTERNAL_STATS	BIT(8)
>  
>  /*
>   * Fast allocation side cache array/stack
> @@ -57,6 +60,17 @@
>  #define PP_ALLOC_POOL_DEFAULT	1024
>  #define PP_ALLOC_POOL_LIMIT	32768
>  
> +struct page_pool_stats {
> +	u64 cache_hit;
> +	u64 cache_full;
> +	u64 cache_empty;
> +	u64 ring_produce;
> +	u64 ring_consume;

You are placing producer and consumer counters on the same cache-line.
This is not acceptable.

The page pool and ptr_ring, are specifically designed to avoid
cache-line contention between consumers and producers.  This patch
kills that work.


> +	u64 ring_return;
> +	u64 flush;
> +	u64 node_change;
> +};

Another example of carefully avoiding cache-line bouncing is the
inflight tracking, e.g. the struct placement of pages_state_release_cnt
and pages_state_hold_cnt for inflight accounting.


> +
>  struct page_pool_params {
>  	unsigned int	flags;
>  	unsigned int	order;
> @@ -65,6 +79,7 @@ struct page_pool_params {
>  	int		nid;  /* Numa node id to allocate from pages from */
>  	enum dma_data_direction dma_dir; /* DMA mapping direction */
>  	struct device	*dev; /* device, for DMA pre-mapping purposes */
> +	struct page_pool_stats *stats; /* pool stats stored externally */
>  };
>  
>  struct page_pool {
> @@ -230,8 +245,8 @@ static inline bool page_pool_put(struct page_pool *pool)
>  static inline void page_pool_update_nid(struct page_pool *pool, int new_nid)
>  {
>  	if (unlikely(pool->p.nid != new_nid)) {
> -		/* TODO: Add statistics/trace */
>  		pool->p.nid = new_nid;
> +		pool->p.stats->node_change++;
>  	}
>  }
>  #endif /* _NET_PAGE_POOL_H */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index f8fedecddb6f..ea6202813584 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -20,9 +20,10 @@
>  
>  static int page_pool_init(struct page_pool *pool)
>  {
> +	int size;
>  
>  	/* Validate only known flags were used */
> -	if (pool->p.flags & ~(PP_FLAG_ALL))
> +	if (pool->p.flags & ~PP_FLAG_ALL)
>  		return -EINVAL;
>  
>  	if (!pool->p.pool_size)
> @@ -40,8 +41,16 @@ static int page_pool_init(struct page_pool *pool)
>  	    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
>  		return -EINVAL;
>  
> +	if (!pool->p.stats) {
> +		size  = sizeof(struct page_pool_stats);
> +		pool->p.stats = kzalloc_node(size, GFP_KERNEL, pool->p.nid);
> +		if (!pool->p.stats)
> +			return -ENOMEM;
> +		pool->p.flags |= PP_FLAG_INTERNAL_STATS;
> +	}
> +
>  	if (ptr_ring_init(&pool->ring, pool->p.pool_size, GFP_KERNEL) < 0)
> -		return -ENOMEM;
> +		goto fail;
>  
>  	atomic_set(&pool->pages_state_release_cnt, 0);
>  
> @@ -52,6 +61,12 @@ static int page_pool_init(struct page_pool *pool)
>  		get_device(pool->p.dev);
>  
>  	return 0;
> +
> +fail:
> +	if (pool->p.flags & PP_FLAG_INTERNAL_STATS)
> +		kfree(pool->p.stats);
> +
> +	return -ENOMEM;
>  }
>  
>  struct page_pool *page_pool_create(const struct page_pool_params *params)
> @@ -98,9 +113,11 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
>  	if (likely(in_serving_softirq())) {
>  		if (likely(pool->alloc_count)) {
>  			/* Fast-path */
> +			pool->p.stats->cache_hit++;
>  			page = pool->alloc_cache[--pool->alloc_count];
>  			return page;
>  		}
> +		pool->p.stats->cache_empty++;
>  		refill = true;
>  	}
>  
> @@ -113,10 +130,13 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
>  	 */
>  	spin_lock(&r->consumer_lock);
>  	page = __ptr_ring_consume(r);
> -	if (refill)
> +	if (refill) {
>  		pool->alloc_count = __ptr_ring_consume_batched(r,
>  							pool->alloc_cache,
>  							PP_ALLOC_CACHE_REFILL);
> +		pool->p.stats->ring_consume += pool->alloc_count;
> +	}
> +	pool->p.stats->ring_consume += !!page;
>  	spin_unlock(&r->consumer_lock);
>  	return page;
>  }
> @@ -266,15 +286,23 @@ static void __page_pool_return_page(struct page_pool *pool, struct page *page)
>  static bool __page_pool_recycle_into_ring(struct page_pool *pool,
>  				   struct page *page)
>  {
> +	struct ptr_ring *r = &pool->ring;
>  	int ret;
>  
> -	/* BH protection not needed if current is serving softirq */
>  	if (in_serving_softirq())
> -		ret = ptr_ring_produce(&pool->ring, page);
> +		spin_lock(&r->producer_lock);
>  	else
> -		ret = ptr_ring_produce_bh(&pool->ring, page);
> +		spin_lock_bh(&r->producer_lock);
>  
> -	return (ret == 0) ? true : false;
> +	ret = __ptr_ring_produce(r, page);
> +	pool->p.stats->ring_produce++;
> +
> +	if (in_serving_softirq())
> +		spin_unlock(&r->producer_lock);
> +	else
> +		spin_unlock_bh(&r->producer_lock);
> +
> +	return ret == 0;
>  }
>  
>  /* Only allow direct recycling in special circumstances, into the
> @@ -285,8 +313,10 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
>  static bool __page_pool_recycle_into_cache(struct page *page,
>  					   struct page_pool *pool)
>  {
> -	if (unlikely(pool->alloc_count == pool->p.cache_size))
> +	if (unlikely(pool->alloc_count == pool->p.cache_size)) {
> +		pool->p.stats->cache_full++;
>  		return false;
> +	}
>  
>  	/* Caller MUST have verified/know (page_ref_count(page) == 1) */
>  	pool->alloc_cache[pool->alloc_count++] = page;
> @@ -343,6 +373,7 @@ EXPORT_SYMBOL(__page_pool_put_page);
>  static void __page_pool_empty_ring(struct page_pool *pool)
>  {
>  	struct page *page;
> +	int count = 0;
>  
>  	/* Empty recycle ring */
>  	while ((page = ptr_ring_consume_bh(&pool->ring))) {
> @@ -351,8 +382,11 @@ static void __page_pool_empty_ring(struct page_pool *pool)
>  			pr_crit("%s() page_pool refcnt %d violation\n",
>  				__func__, page_ref_count(page));
>  
> +		count++;
>  		__page_pool_return_page(pool, page);
>  	}
> +
> +	pool->p.stats->ring_return += count;
>  }
>  
>  static void __warn_in_flight(struct page_pool *pool)
> @@ -381,6 +415,9 @@ void __page_pool_free(struct page_pool *pool)
>  	if (!__page_pool_safe_to_destroy(pool))
>  		__warn_in_flight(pool);
>  
> +	if (pool->p.flags & PP_FLAG_INTERNAL_STATS)
> +		kfree(pool->p.stats);
> +
>  	ptr_ring_cleanup(&pool->ring, NULL);
>  
>  	if (pool->p.flags & PP_FLAG_DMA_MAP)
> @@ -394,6 +431,8 @@ static void page_pool_flush(struct page_pool *pool)
>  {
>  	struct page *page;
>  
> +	pool->p.stats->flush++;
> +
>  	/* Empty alloc cache, assume caller made sure this is
>  	 * no-longer in use, and page_pool_alloc_pages() cannot be
>  	 * called concurrently.

Have you benchmarked the overhead of adding this accounting?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
