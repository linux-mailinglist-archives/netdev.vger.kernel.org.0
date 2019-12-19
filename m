Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39966125961
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 02:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfLSBwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 20:52:23 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36578 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726463AbfLSBwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 20:52:23 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AB3485C287CEFDA569EA;
        Thu, 19 Dec 2019 09:52:20 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Dec 2019
 09:52:15 +0800
Subject: Re: [net-next v4 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <lirongqing@baidu.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>, <mhocko@kernel.org>,
        <peterz@infradead.org>, <linux-kernel@vger.kernel.org>
References: <20191218084437.6db92d32@carbon>
 <157665609556.170047.13435503155369210509.stgit@firesoul>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <40fb6aff-beec-f186-2bc0-187ad370cf0b@huawei.com>
Date:   Thu, 19 Dec 2019 09:52:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <157665609556.170047.13435503155369210509.stgit@firesoul>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/18 16:01, Jesper Dangaard Brouer wrote:
> The check in pool_page_reusable (page_to_nid(page) == pool->p.nid) is
> not valid if page_pool was configured with pool->p.nid = NUMA_NO_NODE.
> 
> The goal of the NUMA changes in commit d5394610b1ba ("page_pool: Don't
> recycle non-reusable pages"), were to have RX-pages that belongs to the
> same NUMA node as the CPU processing RX-packet during softirq/NAPI. As
> illustrated by the performance measurements.
> 
> This patch moves the NAPI checks out of fast-path, and at the same time
> solves the NUMA_NO_NODE issue.
> 
> First realize that alloc_pages_node() with pool->p.nid = NUMA_NO_NODE
> will lookup current CPU nid (Numa ID) via numa_mem_id(), which is used
> as the the preferred nid.  It is only in rare situations, where
> e.g. NUMA zone runs dry, that page gets doesn't get allocated from
> preferred nid.  The page_pool API allows drivers to control the nid
> themselves via controlling pool->p.nid.
> 
> This patch moves the NAPI check to when alloc cache is refilled, via
> dequeuing/consuming pages from the ptr_ring. Thus, we can allow placing
> pages from remote NUMA into the ptr_ring, as the dequeue/consume step
> will check the NUMA node. All current drivers using page_pool will
> alloc/refill RX-ring from same CPU running softirq/NAPI process.
> 
> Drivers that control the nid explicitly, also use page_pool_update_nid
> when changing nid runtime.  To speed up transision to new nid the alloc
> cache is now flushed on nid changes.  This force pages to come from
> ptr_ring, which does the appropate nid check.
> 
> For the NUMA_NO_NODE case, when a NIC IRQ is moved to another NUMA
> node, then ptr_ring will be emptied in 65 (PP_ALLOC_CACHE_REFILL+1)
> chunks per allocation and allocation fall-through to the real
> page-allocator with the new nid derived from numa_mem_id(). We accept
> that transitioning the alloc cache doesn't happen immediately.
> 
> Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable pages")
> Reported-by: Li RongQing <lirongqing@baidu.com>
> Reported-by: Yunsheng Lin <linyunsheng@huawei.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/core/page_pool.c |   82 ++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 63 insertions(+), 19 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index a6aefe989043..bd4f8b2c46b6 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -96,10 +96,61 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
>  }
>  EXPORT_SYMBOL(page_pool_create);
>  
> +static void __page_pool_return_page(struct page_pool *pool, struct page *page);

It is possible to avoid forword-declare it by move the __page_pool_return_page()?
Maybe it is ok since this patch is targetting net-next?

> +
> +noinline
> +static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
> +						 bool refill)
> +{
> +	struct ptr_ring *r = &pool->ring;
> +	struct page *first_page, *page;
> +	int i, curr_nid;
> +
> +	/* Quicker fallback, avoid locks when ring is empty */
> +	if (__ptr_ring_empty(r))
> +		return NULL;
> +
> +	/* Softirq guarantee CPU and thus NUMA node is stable. This,
> +	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
> +	 */
> +	curr_nid = numa_mem_id();
> +
> +	/* Slower-path: Get pages from locked ring queue */
> +	spin_lock(&r->consumer_lock);
> +	first_page = __ptr_ring_consume(r);
> +
> +	/* Fallback to page-allocator if NUMA node doesn't match */
> +	if (first_page && unlikely(!(page_to_nid(first_page) == curr_nid))) {
> +		__page_pool_return_page(pool, first_page);
> +		first_page = NULL;
> +	}
> +
> +	if (unlikely(!refill))
> +		goto out;
> +
> +	/* Refill alloc array, but only if NUMA node match */
> +	for (i = 0; i < PP_ALLOC_CACHE_REFILL; i++) {
> +		page = __ptr_ring_consume(r);
> +		if (unlikely(!page))
> +			break;
> +
> +		if (likely(page_to_nid(page) == curr_nid)) {
> +			pool->alloc.cache[pool->alloc.count++] = page;
> +		} else {
> +			/* Release page to page-allocator, assume
> +			 * refcnt == 1 invariant of cached pages
> +			 */
> +			__page_pool_return_page(pool, page);
> +		}
> +	}

The above code seems to not clear all the pages in the ptr_ring that
is not in the local node in some case?

I am not so familiar with asm, but does below code make sense and
generate better asm code?

	struct page *page = NULL;

	while (pool->alloc.count < PP_ALLOC_CACHE_REFILL || !refill) {
		page = __ptr_ring_consume(r);

		if (unlikely(!page || !refill))
			break;

		if (likely(page_to_nid(page) == curr_nid)) {
			pool->alloc.cache[pool->alloc.count++] = page;
		} else {
			/* Release page to page-allocator, assume
			 * refcnt == 1 invariant of cached pages
			 */
			__page_pool_return_page(pool, page);
		}
	}

out:
	if (likely(refill && pool->alloc.count > 0))
		page = pool->alloc.cache[--pool->alloc.count];

	spin_unlock(&r->consumer_lock);
	
	return page;


"The above code does not compile or test yet".

the above will clear all the pages in the ptr_ring that is not in the local
node and treat the refill and !refill case consistently.

But for the refill case, the pool->alloc.count may be PP_ALLOC_CACHE_REFILL - 1
after page_pool_refill_alloc_cache() returns.


> +out:
> +	spin_unlock(&r->consumer_lock);
> +	return first_page;
> +}
> +
>  /* fast path */
>  static struct page *__page_pool_get_cached(struct page_pool *pool)
>  {
> -	struct ptr_ring *r = &pool->ring;
>  	bool refill = false;
>  	struct page *page;
>  
> @@ -113,20 +164,7 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
>  		refill = true;
>  	}
>  
> -	/* Quicker fallback, avoid locks when ring is empty */
> -	if (__ptr_ring_empty(r))
> -		return NULL;
> -
> -	/* Slow-path: Get page from locked ring queue,
> -	 * refill alloc array if requested.
> -	 */
> -	spin_lock(&r->consumer_lock);
> -	page = __ptr_ring_consume(r);
> -	if (refill)
> -		pool->alloc.count = __ptr_ring_consume_batched(r,
> -							pool->alloc.cache,
> -							PP_ALLOC_CACHE_REFILL);
> -	spin_unlock(&r->consumer_lock);
> +	page = page_pool_refill_alloc_cache(pool, refill);
>  	return page;
>  }
>  
> @@ -311,13 +349,10 @@ static bool __page_pool_recycle_direct(struct page *page,
>  
>  /* page is NOT reusable when:
>   * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
> - * 2) belongs to a different NUMA node than pool->p.nid.
> - *
> - * To update pool->p.nid users must call page_pool_update_nid.
>   */
>  static bool pool_page_reusable(struct page_pool *pool, struct page *page)
>  {
> -	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool->p.nid;
> +	return !page_is_pfmemalloc(page);
>  }
>  
>  void __page_pool_put_page(struct page_pool *pool, struct page *page,
> @@ -484,7 +519,16 @@ EXPORT_SYMBOL(page_pool_destroy);
>  /* Caller must provide appropriate safe context, e.g. NAPI. */
>  void page_pool_update_nid(struct page_pool *pool, int new_nid)
>  {
> +	struct page *page;
> +
> +	WARN_ON(!in_serving_softirq());
>  	trace_page_pool_update_nid(pool, new_nid);
>  	pool->p.nid = new_nid;
> +
> +	/* Flush pool alloc cache, as refill will check NUMA node */
> +	while (pool->alloc.count) {
> +		page = pool->alloc.cache[--pool->alloc.count];
> +		__page_pool_return_page(pool, page);
> +	}
>  }
>  EXPORT_SYMBOL(page_pool_update_nid);
> 
> 
> 
> .
> 

