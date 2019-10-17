Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2496DA7C9
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 10:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408386AbfJQIwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 04:52:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405250AbfJQIwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 04:52:00 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8183D8AC6FB;
        Thu, 17 Oct 2019 08:51:59 +0000 (UTC)
Received: from carbon (ovpn-200-46.brq.redhat.com [10.40.200.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 444D760852;
        Thu, 17 Oct 2019 08:51:53 +0000 (UTC)
Date:   Thu, 17 Oct 2019 10:51:52 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <ilias.apalodimas@linaro.org>, <saeedm@mellanox.com>,
        <tariqt@mellanox.com>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>, brouer@redhat.com
Subject: Re: [PATCH 07/10 net-next] page_pool: allow configurable linear
 cache size
Message-ID: <20191017105152.50e6ed36@carbon>
In-Reply-To: <20191016225028.2100206-8-jonathan.lemon@gmail.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
        <20191016225028.2100206-8-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Thu, 17 Oct 2019 08:51:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 15:50:25 -0700
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> Some drivers may utilize more than one page per RX work entry.
> Allow a configurable cache size, with the same defaults if the
> size is zero.
> 
> Convert magic numbers into descriptive entries.
> 
> Re-arrange the page_pool structure for efficiency.

IMHO the re-arrange you did does not improve efficiency, it kills the
efficiency...

> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/net/page_pool.h | 50 ++++++++++++++++++++---------------------
>  net/core/page_pool.c    | 49 +++++++++++++++++++++++-----------------
>  2 files changed, 54 insertions(+), 45 deletions(-)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 89bc91294b53..fc340db42f9a 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -51,41 +51,34 @@
>   * cache is already full (or partly full) then the XDP_DROP recycles
>   * would have to take a slower code path.
>   */
> -#define PP_ALLOC_CACHE_SIZE	128
>  #define PP_ALLOC_CACHE_REFILL	64
> -struct pp_alloc_cache {
> -	u32 count;
> -	void *cache[PP_ALLOC_CACHE_SIZE];
> -};
> +#define PP_ALLOC_CACHE_DEFAULT	(2 * PP_ALLOC_CACHE_REFILL)
> +#define PP_ALLOC_CACHE_LIMIT	512
> +#define PP_ALLOC_POOL_DEFAULT	1024
> +#define PP_ALLOC_POOL_LIMIT	32768
>  
>  struct page_pool_params {
>  	unsigned int	flags;
>  	unsigned int	order;
>  	unsigned int	pool_size;
> +	unsigned int	cache_size;
>  	int		nid;  /* Numa node id to allocate from pages from */
> -	struct device	*dev; /* device, for DMA pre-mapping purposes */
>  	enum dma_data_direction dma_dir; /* DMA mapping direction */
> +	struct device	*dev; /* device, for DMA pre-mapping purposes */
>  };
>  
>  struct page_pool {
>  	struct page_pool_params p;
>  
> +	u32 alloc_count;
>          u32 pages_state_hold_cnt;
> +	atomic_t pages_state_release_cnt;
  
The struct members pages_state_hold_cnt and pages_state_release_cnt,
MUST be kept on different cachelines, else the point of tracking
inflight pages this way is lost.


> -	/*
> -	 * Data structure for allocation side
> -	 *
> -	 * Drivers allocation side usually already perform some kind
> -	 * of resource protection.  Piggyback on this protection, and
> -	 * require driver to protect allocation side.
> -	 *
> -	 * For NIC drivers this means, allocate a page_pool per
> -	 * RX-queue. As the RX-queue is already protected by
> -	 * Softirq/BH scheduling and napi_schedule. NAPI schedule
> -	 * guarantee that a single napi_struct will only be scheduled
> -	 * on a single CPU (see napi_schedule).
> +	/* A page_pool is strictly tied to a single RX-queue being
> +	 * protected by NAPI, due to above pp_alloc_cache. This
                                           ^^^^^^^^^^^^^^    
You remove the 'pp_alloc_cache' in this patch, and still mention it in
the comments.

> +	 * refcnt serves purpose is to simplify drivers error handling.
>  	 */
> -	struct pp_alloc_cache alloc ____cacheline_aligned_in_smp;
> +	refcount_t user_cnt;
>  
>  	/* Data structure for storing recycled pages.
>  	 *
> @@ -100,13 +93,20 @@ struct page_pool {
>  	 */
>  	struct ptr_ring ring;
>  
> -	atomic_t pages_state_release_cnt;
> -
> -	/* A page_pool is strictly tied to a single RX-queue being
> -	 * protected by NAPI, due to above pp_alloc_cache. This
> -	 * refcnt serves purpose is to simplify drivers error handling.
> +	/*
> +	 * Data structure for allocation side
> +	 *
> +	 * Drivers allocation side usually already perform some kind
> +	 * of resource protection.  Piggyback on this protection, and
> +	 * require driver to protect allocation side.
> +	 *
> +	 * For NIC drivers this means, allocate a page_pool per
> +	 * RX-queue. As the RX-queue is already protected by
> +	 * Softirq/BH scheduling and napi_schedule. NAPI schedule
> +	 * guarantee that a single napi_struct will only be scheduled
> +	 * on a single CPU (see napi_schedule).
>  	 */
> -	refcount_t user_cnt;
> +	void *alloc_cache[];
>  };
>  
>  struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ea56823236c5..f8fedecddb6f 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -18,22 +18,18 @@
>  
>  #include <trace/events/page_pool.h>
>  
> -static int page_pool_init(struct page_pool *pool,
> -			  const struct page_pool_params *params)
> +static int page_pool_init(struct page_pool *pool)
>  {
> -	unsigned int ring_qsize = 1024; /* Default */
> -
> -	memcpy(&pool->p, params, sizeof(pool->p));
>  
>  	/* Validate only known flags were used */
>  	if (pool->p.flags & ~(PP_FLAG_ALL))
>  		return -EINVAL;
>  
> -	if (pool->p.pool_size)
> -		ring_qsize = pool->p.pool_size;
> +	if (!pool->p.pool_size)
> +		pool->p.pool_size = PP_ALLOC_POOL_DEFAULT;
>  
>  	/* Sanity limit mem that can be pinned down */
> -	if (ring_qsize > 32768)
> +	if (pool->p.pool_size > PP_ALLOC_POOL_LIMIT)
>  		return -E2BIG;
>  
>  	/* DMA direction is either DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
> @@ -44,7 +40,7 @@ static int page_pool_init(struct page_pool *pool,
>  	    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
>  		return -EINVAL;
>  
> -	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
> +	if (ptr_ring_init(&pool->ring, pool->p.pool_size, GFP_KERNEL) < 0)
>  		return -ENOMEM;
>  
>  	atomic_set(&pool->pages_state_release_cnt, 0);
> @@ -61,13 +57,26 @@ static int page_pool_init(struct page_pool *pool,
>  struct page_pool *page_pool_create(const struct page_pool_params *params)
>  {
>  	struct page_pool *pool;
> +	u32 cache_size, size;
>  	int err;
>  
> -	pool = kzalloc_node(sizeof(*pool), GFP_KERNEL, params->nid);
> +	cache_size = params->cache_size;
> +	if (!cache_size)
> +		cache_size = PP_ALLOC_CACHE_DEFAULT;
> +
> +	/* Sanity limit mem that can be pinned down */
> +	if (cache_size > PP_ALLOC_CACHE_LIMIT)
> +		return ERR_PTR(-E2BIG);
> +
> +	size = sizeof(*pool) + cache_size * sizeof(void *);
> +	pool = kzalloc_node(size, GFP_KERNEL, params->nid);

You have now placed alloc_cache at the end of page_pool struct, this
allows for dynamic changing the size, that is kind of nice.  Before I
placed pp_alloc_cache in struct to make sure that we didn't have
false-sharing.  Now, I'm unsure if false-sharing can happen?
(depend on alignment from kzalloc_node).


>  	if (!pool)
>  		return ERR_PTR(-ENOMEM);
>  
> -	err = page_pool_init(pool, params);
> +	memcpy(&pool->p, params, sizeof(pool->p));
> +	pool->p.cache_size = cache_size;
> +
> +	err = page_pool_init(pool);
>  	if (err < 0) {
>  		pr_warn("%s() gave up with errno %d\n", __func__, err);
>  		kfree(pool);
> @@ -87,9 +96,9 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
>  
>  	/* Test for safe-context, caller should provide this guarantee */
>  	if (likely(in_serving_softirq())) {
> -		if (likely(pool->alloc.count)) {
> +		if (likely(pool->alloc_count)) {
>  			/* Fast-path */
> -			page = pool->alloc.cache[--pool->alloc.count];
> +			page = pool->alloc_cache[--pool->alloc_count];
>  			return page;
>  		}
>  		refill = true;
> @@ -105,8 +114,8 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
>  	spin_lock(&r->consumer_lock);
>  	page = __ptr_ring_consume(r);
>  	if (refill)
> -		pool->alloc.count = __ptr_ring_consume_batched(r,
> -							pool->alloc.cache,
> +		pool->alloc_count = __ptr_ring_consume_batched(r,
> +							pool->alloc_cache,
>  							PP_ALLOC_CACHE_REFILL);
>  	spin_unlock(&r->consumer_lock);
>  	return page;
> @@ -276,11 +285,11 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
>  static bool __page_pool_recycle_into_cache(struct page *page,
>  					   struct page_pool *pool)
>  {
> -	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE))
> +	if (unlikely(pool->alloc_count == pool->p.cache_size))
>  		return false;
>  
>  	/* Caller MUST have verified/know (page_ref_count(page) == 1) */
> -	pool->alloc.cache[pool->alloc.count++] = page;
> +	pool->alloc_cache[pool->alloc_count++] = page;
>  	return true;
>  }
>  
> @@ -365,7 +374,7 @@ void __page_pool_free(struct page_pool *pool)
>  	if (!page_pool_put(pool))
>  		return;
>  
> -	WARN(pool->alloc.count, "API usage violation");
> +	WARN(pool->alloc_count, "API usage violation");
>  	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>  
>  	/* Can happen due to forced shutdown */
> @@ -389,8 +398,8 @@ static void page_pool_flush(struct page_pool *pool)
>  	 * no-longer in use, and page_pool_alloc_pages() cannot be
>  	 * called concurrently.
>  	 */
> -	while (pool->alloc.count) {
> -		page = pool->alloc.cache[--pool->alloc.count];
> +	while (pool->alloc_count) {
> +		page = pool->alloc_cache[--pool->alloc_count];
>  		__page_pool_return_page(pool, page);
>  	}
>  



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
