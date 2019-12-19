Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDE61261CB
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 13:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfLSMPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 07:15:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53780 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726668AbfLSMPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 07:15:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576757716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bwteTCqO+mZi96HO2yiYUl6ee0bLkbJPNd/nB67orPw=;
        b=K111hXBFikRJE6ADum7dj+3Be5/5vJLAe1VTr7xesAmCBqcSujx26LLbqoeIH0Xoyp9Nyi
        U4gwzYS/HRUbwMsBya6ij/BZsmgcpN2PZAwmlsS+y1SZ3hGa/ZFHotPm6isG8Al+kATK0H
        dPFUjEZRt+zPfL14VqQ560y25dhwFYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-zpb069LyMcKDp20xgdC-mA-1; Thu, 19 Dec 2019 07:15:10 -0500
X-MC-Unique: zpb069LyMcKDp20xgdC-mA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79A75800EB8;
        Thu, 19 Dec 2019 12:15:08 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F4731001281;
        Thu, 19 Dec 2019 12:15:02 +0000 (UTC)
Date:   Thu, 19 Dec 2019 13:15:00 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <netdev@vger.kernel.org>, <lirongqing@baidu.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>, <mhocko@kernel.org>,
        <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: [net-next v4 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191219131500.47970427@carbon>
In-Reply-To: <40fb6aff-beec-f186-2bc0-187ad370cf0b@huawei.com>
References: <20191218084437.6db92d32@carbon>
        <157665609556.170047.13435503155369210509.stgit@firesoul>
        <40fb6aff-beec-f186-2bc0-187ad370cf0b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Dec 2019 09:52:14 +0800
Yunsheng Lin <linyunsheng@huawei.com> wrote:

> On 2019/12/18 16:01, Jesper Dangaard Brouer wrote:
> > The check in pool_page_reusable (page_to_nid(page) == pool->p.nid) is
> > not valid if page_pool was configured with pool->p.nid = NUMA_NO_NODE.
> > 
> > The goal of the NUMA changes in commit d5394610b1ba ("page_pool: Don't
> > recycle non-reusable pages"), were to have RX-pages that belongs to the
> > same NUMA node as the CPU processing RX-packet during softirq/NAPI. As
> > illustrated by the performance measurements.
> > 
> > This patch moves the NAPI checks out of fast-path, and at the same time
> > solves the NUMA_NO_NODE issue.
> > 
> > First realize that alloc_pages_node() with pool->p.nid = NUMA_NO_NODE
> > will lookup current CPU nid (Numa ID) via numa_mem_id(), which is used
> > as the the preferred nid.  It is only in rare situations, where
> > e.g. NUMA zone runs dry, that page gets doesn't get allocated from
> > preferred nid.  The page_pool API allows drivers to control the nid
> > themselves via controlling pool->p.nid.
> > 
> > This patch moves the NAPI check to when alloc cache is refilled, via
> > dequeuing/consuming pages from the ptr_ring. Thus, we can allow placing
> > pages from remote NUMA into the ptr_ring, as the dequeue/consume step
> > will check the NUMA node. All current drivers using page_pool will
> > alloc/refill RX-ring from same CPU running softirq/NAPI process.
> > 
> > Drivers that control the nid explicitly, also use page_pool_update_nid
> > when changing nid runtime.  To speed up transision to new nid the alloc
> > cache is now flushed on nid changes.  This force pages to come from
> > ptr_ring, which does the appropate nid check.
> > 
> > For the NUMA_NO_NODE case, when a NIC IRQ is moved to another NUMA
> > node, then ptr_ring will be emptied in 65 (PP_ALLOC_CACHE_REFILL+1)
> > chunks per allocation and allocation fall-through to the real
> > page-allocator with the new nid derived from numa_mem_id(). We accept
> > that transitioning the alloc cache doesn't happen immediately.
> > 
> > Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable pages")
> > Reported-by: Li RongQing <lirongqing@baidu.com>
> > Reported-by: Yunsheng Lin <linyunsheng@huawei.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  net/core/page_pool.c |   82 ++++++++++++++++++++++++++++++++++++++------------
> >  1 file changed, 63 insertions(+), 19 deletions(-)
> > 
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index a6aefe989043..bd4f8b2c46b6 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -96,10 +96,61 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
> >  }
> >  EXPORT_SYMBOL(page_pool_create);
> >  
> > +static void __page_pool_return_page(struct page_pool *pool, struct page *page);  
> 
> It is possible to avoid forword-declare it by move the __page_pool_return_page()?
> Maybe it is ok since this patch is targetting net-next?
> 
> > +
> > +noinline
> > +static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
> > +						 bool refill)
> > +{
> > +	struct ptr_ring *r = &pool->ring;
> > +	struct page *first_page, *page;
> > +	int i, curr_nid;
> > +
> > +	/* Quicker fallback, avoid locks when ring is empty */
> > +	if (__ptr_ring_empty(r))
> > +		return NULL;
> > +
> > +	/* Softirq guarantee CPU and thus NUMA node is stable. This,
> > +	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
> > +	 */
> > +	curr_nid = numa_mem_id();
> > +
> > +	/* Slower-path: Get pages from locked ring queue */
> > +	spin_lock(&r->consumer_lock);
> > +	first_page = __ptr_ring_consume(r);
> > +
> > +	/* Fallback to page-allocator if NUMA node doesn't match */
> > +	if (first_page && unlikely(!(page_to_nid(first_page) == curr_nid))) {
> > +		__page_pool_return_page(pool, first_page);
> > +		first_page = NULL;
> > +	}
> > +
> > +	if (unlikely(!refill))
> > +		goto out;
> > +
> > +	/* Refill alloc array, but only if NUMA node match */
> > +	for (i = 0; i < PP_ALLOC_CACHE_REFILL; i++) {
> > +		page = __ptr_ring_consume(r);
> > +		if (unlikely(!page))
> > +			break;
> > +
> > +		if (likely(page_to_nid(page) == curr_nid)) {
> > +			pool->alloc.cache[pool->alloc.count++] = page;
> > +		} else {
> > +			/* Release page to page-allocator, assume
> > +			 * refcnt == 1 invariant of cached pages
> > +			 */
> > +			__page_pool_return_page(pool, page);
> > +		}
> > +	}  
> 
> The above code seems to not clear all the pages in the ptr_ring that
> is not in the local node in some case?
> 
> I am not so familiar with asm, but does below code make sense and
> generate better asm code?

I'm not too concerned with ASM-level optimization for this function
call, as it only happens once every 64 packets.


> 	struct page *page = NULL;
> 
> 	while (pool->alloc.count < PP_ALLOC_CACHE_REFILL || !refill) {
> 		page = __ptr_ring_consume(r);
> 
> 		if (unlikely(!page || !refill))
> 			break;
> 
> 		if (likely(page_to_nid(page) == curr_nid)) {
> 			pool->alloc.cache[pool->alloc.count++] = page;
> 		} else {
> 			/* Release page to page-allocator, assume
> 			 * refcnt == 1 invariant of cached pages
> 			 */
> 			__page_pool_return_page(pool, page);
> 		}
> 	}
> 
> out:
> 	if (likely(refill && pool->alloc.count > 0))
> 		page = pool->alloc.cache[--pool->alloc.count];
> 
> 	spin_unlock(&r->consumer_lock);
> 	
> 	return page;
>
> 
> "The above code does not compile or test yet".
> 
> the above will clear all the pages in the ptr_ring that is not in the
> local node and treat the refill and !refill case consistently.

I don't want to empty the entire ptr_ring in one go.  That is
problematic, because we are running in Softirq with bh + preemption
disabled.  Returning 1024 pages will undoubtedly trigger some page
buddy coalescing work.  That is why I choose to max return 65 pages (I
felt this detail was important enought to mention it in the description
above).

I do acknowledge that the code can be improved.  What I don't like with
my own code, is that I handle the 'first_page' as a special case.  You
code did solve that case, so I'll try to improve my code and send V5.


> 
> But for the refill case, the pool->alloc.count may be PP_ALLOC_CACHE_REFILL - 1
> after page_pool_refill_alloc_cache() returns.
> 
> 
> > +out:
> > +	spin_unlock(&r->consumer_lock);
> > +	return first_page;
> > +}
> > +
> >  /* fast path */
> >  static struct page *__page_pool_get_cached(struct page_pool *pool)
> >  {
> > -	struct ptr_ring *r = &pool->ring;
> >  	bool refill = false;
> >  	struct page *page;
> >  
> > @@ -113,20 +164,7 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
> >  		refill = true;
> >  	}
> >  
> > -	/* Quicker fallback, avoid locks when ring is empty */
> > -	if (__ptr_ring_empty(r))
> > -		return NULL;
> > -
> > -	/* Slow-path: Get page from locked ring queue,
> > -	 * refill alloc array if requested.
> > -	 */
> > -	spin_lock(&r->consumer_lock);
> > -	page = __ptr_ring_consume(r);
> > -	if (refill)
> > -		pool->alloc.count = __ptr_ring_consume_batched(r,
> > -							pool->alloc.cache,
> > -							PP_ALLOC_CACHE_REFILL);
> > -	spin_unlock(&r->consumer_lock);
> > +	page = page_pool_refill_alloc_cache(pool, refill);
> >  	return page;
> >  }
> >  
> > @@ -311,13 +349,10 @@ static bool __page_pool_recycle_direct(struct page *page,
> >  
> >  /* page is NOT reusable when:
> >   * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
> > - * 2) belongs to a different NUMA node than pool->p.nid.
> > - *
> > - * To update pool->p.nid users must call page_pool_update_nid.
> >   */
> >  static bool pool_page_reusable(struct page_pool *pool, struct page *page)
> >  {
> > -	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool->p.nid;
> > +	return !page_is_pfmemalloc(page);
> >  }
> >  
> >  void __page_pool_put_page(struct page_pool *pool, struct page *page,
> > @@ -484,7 +519,16 @@ EXPORT_SYMBOL(page_pool_destroy);
> >  /* Caller must provide appropriate safe context, e.g. NAPI. */
> >  void page_pool_update_nid(struct page_pool *pool, int new_nid)
> >  {
> > +	struct page *page;
> > +
> > +	WARN_ON(!in_serving_softirq());
> >  	trace_page_pool_update_nid(pool, new_nid);
> >  	pool->p.nid = new_nid;
> > +
> > +	/* Flush pool alloc cache, as refill will check NUMA node */
> > +	while (pool->alloc.count) {
> > +		page = pool->alloc.cache[--pool->alloc.count];
> > +		__page_pool_return_page(pool, page);
> > +	}
> >  }
> >  EXPORT_SYMBOL(page_pool_update_nid);
> > 


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

