Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A034B66AB5D
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 13:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjANMaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 07:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjANMav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 07:30:51 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE4C8685
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 04:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673699451; x=1705235451;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=w2HqJkxH3Sd5M+8pTUqFqt54zmtpHZhL/TdcAd3/PQw=;
  b=QoPrBmCNp6F1wjhHrPIDOmgACESTvzTt/yX5DvWLH88aYGXCWBLUK1bV
   7l6bViy2vc/Ox9thUbAlsriTUrhKO2Coc7uC+/xqh9soxcgjh5gM2gbVc
   jyCaozXM2DilqUkxnT//Tdgi1Z3DttmOJui4OWqCpQJ50xeoXmFLDqbUz
   s=;
X-IronPort-AV: E=Sophos;i="5.97,216,1669075200"; 
   d="scan'208";a="300343502"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2023 12:30:46 +0000
Received: from EX13D47EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id B755781310;
        Sat, 14 Jan 2023 12:30:42 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX13D47EUB003.ant.amazon.com (10.43.166.246) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Sat, 14 Jan 2023 12:30:41 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.161.198) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Sat, 14 Jan 2023 12:30:38 +0000
References: <20230111042214.907030-1-willy@infradead.org>
 <20230111042214.907030-9-willy@infradead.org>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
CC:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v3 08/26] page_pool: Convert pp_alloc_cache to contain
 netmem
Date:   Sat, 14 Jan 2023 14:28:50 +0200
In-Reply-To: <20230111042214.907030-9-willy@infradead.org>
Message-ID: <pj41zlwn5p1eom.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D43UWA004.ant.amazon.com (10.43.160.108) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


"Matthew Wilcox (Oracle)" <willy@infradead.org> writes:

> Change the type here from page to netmem.  It works out well to
> convert page_pool_refill_alloc_cache() to return a netmem 
> instead
> of a page as part of this commit.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  include/net/page_pool.h |  2 +-
>  net/core/page_pool.c    | 52 
>  ++++++++++++++++++++---------------------
>  2 files changed, 27 insertions(+), 27 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 34d47c10550e..583c13f6f2ab 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -173,7 +173,7 @@ static inline bool 
> netmem_is_pfmemalloc(const struct netmem *nmem)
>  #define PP_ALLOC_CACHE_REFILL	64
>  struct pp_alloc_cache {
>  	u32 count;
> -	struct page *cache[PP_ALLOC_CACHE_SIZE];
> +	struct netmem *cache[PP_ALLOC_CACHE_SIZE];
>  };
>  
>  struct page_pool_params {
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 8f3f7cc5a2d5..c54217ce6b77 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -229,10 +229,10 @@ void page_pool_return_page(struct 
> page_pool *pool, struct page *page)
>  }
>  
>  noinline
> -static struct page *page_pool_refill_alloc_cache(struct 
> page_pool *pool)
> +static struct netmem *page_pool_refill_alloc_cache(struct 
> page_pool *pool)
>  {
>  	struct ptr_ring *r = &pool->ring;
> -	struct page *page;
> +	struct netmem *nmem;
>  	int pref_nid; /* preferred NUMA node */
>  
>  	/* Quicker fallback, avoid locks when ring is empty */
> @@ -253,49 +253,49 @@ static struct page 
> *page_pool_refill_alloc_cache(struct page_pool *pool)
>  
>  	/* Refill alloc array, but only if NUMA match */
>  	do {
> -		page = __ptr_ring_consume(r);
> -		if (unlikely(!page))
> +		nmem = __ptr_ring_consume(r);
> +		if (unlikely(!nmem))
>  			break;
>  
> -		if (likely(page_to_nid(page) == pref_nid)) {
> -			pool->alloc.cache[pool->alloc.count++] = 
> page;
> +		if (likely(netmem_nid(nmem) == pref_nid)) {
> +			pool->alloc.cache[pool->alloc.count++] = 
> nmem;
>  		} else {
>  			/* NUMA mismatch;
>  			 * (1) release 1 page to page-allocator 
>  and
>  			 * (2) break out to fallthrough to 
>  alloc_pages_node.
>  			 * This limit stress on page buddy 
>  alloactor.
>  			 */
> -			page_pool_return_page(pool, page);
> +			page_pool_return_netmem(pool, nmem);
>  			alloc_stat_inc(pool, waive);
> -			page = NULL;
> +			nmem = NULL;
>  			break;
>  		}
>  	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL);
>  
>  	/* Return last page */
>  	if (likely(pool->alloc.count > 0)) {
> -		page = pool->alloc.cache[--pool->alloc.count];
> +		nmem = pool->alloc.cache[--pool->alloc.count];
>  		alloc_stat_inc(pool, refill);
>  	}
>  
> -	return page;
> +	return nmem;
>  }
>  
>  /* fast path */
>  static struct page *__page_pool_get_cached(struct page_pool 
>  *pool)
>  {
> -	struct page *page;
> +	struct netmem *nmem;
>  
>  	/* Caller MUST guarantee safe non-concurrent access, 
>  e.g. softirq */
>  	if (likely(pool->alloc.count)) {
>  		/* Fast-path */
> -		page = pool->alloc.cache[--pool->alloc.count];
> +		nmem = pool->alloc.cache[--pool->alloc.count];
>  		alloc_stat_inc(pool, fast);
>  	} else {
> -		page = page_pool_refill_alloc_cache(pool);
> +		nmem = page_pool_refill_alloc_cache(pool);
>  	}
>  
> -	return page;
> +	return netmem_page(nmem);
>  }
>  
>  static void page_pool_dma_sync_for_device(struct page_pool 
>  *pool,
> @@ -391,13 +391,13 @@ static struct page 
> *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  
>  	/* Unnecessary as alloc cache is empty, but guarantees 
>  zero count */
>  	if (unlikely(pool->alloc.count > 0))
> -		return pool->alloc.cache[--pool->alloc.count];
> +		return 
> netmem_page(pool->alloc.cache[--pool->alloc.count]);
>  
>  	/* Mark empty alloc.cache slots "empty" for 
>  alloc_pages_bulk_array */
>  	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
>  
>  	nr_pages = alloc_pages_bulk_array_node(gfp, pool->p.nid, 
>  bulk,
> -					       pool->alloc.cache);
> +					(struct page 
> **)pool->alloc.cache);

Can you fix the alignment here (so that the '(struct page **)' 
would align the the 'gfp' argument one line above) ?

Shay

>  	if (unlikely(!nr_pages))
>  		return NULL;
>  
> @@ -405,7 +405,7 @@ static struct page 
> *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  	 * page element have not been (possibly) DMA mapped.
>  	 */
>  	for (i = 0; i < nr_pages; i++) {
> -		struct netmem *nmem = 
> page_netmem(pool->alloc.cache[i]);
> +		struct netmem *nmem = pool->alloc.cache[i];
>  		if ((pp_flags & PP_FLAG_DMA_MAP) &&
>  		    unlikely(!page_pool_dma_map(pool, nmem))) {
>  			netmem_put(nmem);
> @@ -413,7 +413,7 @@ static struct page 
> *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  		}
>  
>  		page_pool_set_pp_info(pool, nmem);
> -		pool->alloc.cache[pool->alloc.count++] = 
> netmem_page(nmem);
> +		pool->alloc.cache[pool->alloc.count++] = nmem;
>  		/* Track how many pages are held 'in-flight' */
>  		pool->pages_state_hold_cnt++;
>  		trace_page_pool_state_hold(pool, nmem,
> @@ -422,7 +422,7 @@ static struct page 
> *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  
>  	/* Return last page */
>  	if (likely(pool->alloc.count > 0)) {
> -		page = pool->alloc.cache[--pool->alloc.count];
> +		page = 
> netmem_page(pool->alloc.cache[--pool->alloc.count]);
>  		alloc_stat_inc(pool, slow);
>  	} else {
>  		page = NULL;
> @@ -547,7 +547,7 @@ static bool 
> page_pool_recycle_in_cache(struct page *page,
>  	}
>  
>  	/* Caller MUST have verified/know (page_ref_count(page) == 
>  1) */
> -	pool->alloc.cache[pool->alloc.count++] = page;
> +	pool->alloc.cache[pool->alloc.count++] = 
> page_netmem(page);
>  	recycle_stat_inc(pool, cached);
>  	return true;
>  }
> @@ -785,7 +785,7 @@ static void page_pool_free(struct page_pool 
> *pool)
>  
>  static void page_pool_empty_alloc_cache_once(struct page_pool 
>  *pool)
>  {
> -	struct page *page;
> +	struct netmem *nmem;
>  
>  	if (pool->destroy_cnt)
>  		return;
> @@ -795,8 +795,8 @@ static void 
> page_pool_empty_alloc_cache_once(struct page_pool *pool)
>  	 * call concurrently.
>  	 */
>  	while (pool->alloc.count) {
> -		page = pool->alloc.cache[--pool->alloc.count];
> -		page_pool_return_page(pool, page);
> +		nmem = pool->alloc.cache[--pool->alloc.count];
> +		page_pool_return_netmem(pool, nmem);
>  	}
>  }
>  
> @@ -878,15 +878,15 @@ EXPORT_SYMBOL(page_pool_destroy);
>  /* Caller must provide appropriate safe context, e.g. NAPI. */
>  void page_pool_update_nid(struct page_pool *pool, int new_nid)
>  {
> -	struct page *page;
> +	struct netmem *nmem;
>  
>  	trace_page_pool_update_nid(pool, new_nid);
>  	pool->p.nid = new_nid;
>  
>  	/* Flush pool alloc cache, as refill will check NUMA node 
>  */
>  	while (pool->alloc.count) {
> -		page = pool->alloc.cache[--pool->alloc.count];
> -		page_pool_return_page(pool, page);
> +		nmem = pool->alloc.cache[--pool->alloc.count];
> +		page_pool_return_netmem(pool, nmem);
>  	}
>  }
>  EXPORT_SYMBOL(page_pool_update_nid);

