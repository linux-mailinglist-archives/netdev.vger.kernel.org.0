Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68863124083
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 08:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLRHow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 02:44:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32165 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726497AbfLRHov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 02:44:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576655088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tBFoNfgLpzA13A7RXBcD4HAk6sSXm851mZwQvJWaQR0=;
        b=jQZZ/uY2Anm+DUwo2N4UJngIIUh0RAOHn78i3urJfJFvPDCrPv/RxdA78M/ThbGsPJqhdS
        WOcwF2z17thHY7n2VIJPVMW7xEaXRdMnyNdKGwonADyVFZ/Rpjn1o4oBTU/hcOrZQ53WxK
        6BItqsp7JE3u02/ISoW3+y8vL0qUXko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-9kVKGSAtMXSZtOJrBo4M_Q-1; Wed, 18 Dec 2019 02:44:45 -0500
X-MC-Unique: 9kVKGSAtMXSZtOJrBo4M_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 109FC800D48;
        Wed, 18 Dec 2019 07:44:44 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF571610E0;
        Wed, 18 Dec 2019 07:44:38 +0000 (UTC)
Date:   Wed, 18 Dec 2019 08:44:37 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     lirongqing@baidu.com, linyunsheng@huawei.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>, mhocko@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [net-next v3 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191218084437.6db92d32@carbon>
In-Reply-To: <157662465670.141017.5588210646574716982.stgit@firesoul>
References: <157662465670.141017.5588210646574716982.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 00:17:36 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

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
>  net/core/page_pool.c |   64 ++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 49 insertions(+), 15 deletions(-)

I'm going to send a V4, because GCC doesn't generate the optimal ASM
code for the fast-path (details below).

> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index a6aefe989043..37316ea66937 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -96,19 +96,22 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
>  }
>  EXPORT_SYMBOL(page_pool_create);
>  
> +static void __page_pool_return_page(struct page_pool *pool, struct page *page);
> +
>  /* fast path */
>  static struct page *__page_pool_get_cached(struct page_pool *pool)
>  {
>  	struct ptr_ring *r = &pool->ring;
> +	struct page *first_page, *page;
>  	bool refill = false;
> -	struct page *page;
> +	int i, curr_nid;
>  
>  	/* Test for safe-context, caller should provide this guarantee */
>  	if (likely(in_serving_softirq())) {
>  		if (likely(pool->alloc.count)) {
>  			/* Fast-path */
> -			page = pool->alloc.cache[--pool->alloc.count];
> -			return page;
> +			first_page = pool->alloc.cache[--pool->alloc.count];
> +			return first_page;
>  		}
>  		refill = true;
>  	}

The compiler (gcc (GCC) 9.2.1 20190827 (Red Hat 9.2.1-1)) doesn't
generate optimal ASM code for the likely fast-path of pool->alloc.cache
containing an element.  It does "isolate" it and return (retq) early in
this likely case, BUT it chooses to use %r15 (a call-preserved
register, aka callee-saved register).  Later other call-preserved
registers are used, which leads to pushing all the registers (%rbx,
%rbp, and %r12-r15) on the stack.

000000000000af0 <page_pool_alloc_pages>:
{
 af0:   e8 00 00 00 00          callq  af5 <page_pool_alloc_pages+0x5>
                        af1: R_X86_64_PLT32     __fentry__-0x4
 af5:   41 57                   push   %r15
 af7:   41 56                   push   %r14
 af9:   41 89 f6                mov    %esi,%r14d
 afc:   41 55                   push   %r13
 afe:   41 54                   push   %r12
 b00:   55                      push   %rbp
 b01:   48 89 fd                mov    %rdi,%rbp
 b04:   53                      push   %rbx
 b05:   48 83 ec 08             sub    $0x8,%rsp
 b09:   65 8b 05 00 00 00 00    mov    %gs:0x0(%rip),%eax        # b10 <page_pool_alloc_pages+
0x20>
                        b0c: R_X86_64_PC32      __preempt_count-0x4
        if (likely(in_serving_softirq())) {
 b10:   f6 c4 01                test   $0x1,%ah
 b13:   74 60                   je     b75 <page_pool_alloc_pages+0x85>
                if (likely(pool->alloc.count)) {
 b15:   8b 87 c0 00 00 00       mov    0xc0(%rdi),%eax
 b1b:   85 c0                   test   %eax,%eax
 b1d:   0f 84 94 01 00 00       je     cb7 <page_pool_alloc_pages+0x1c7>
                        first_page = pool->alloc.cache[--pool->alloc.count];
 b23:   83 e8 01                sub    $0x1,%eax
 b26:   89 87 c0 00 00 00       mov    %eax,0xc0(%rdi)
 b2c:   4c 8b bc c7 c8 00 00    mov    0xc8(%rdi,%rax,8),%r15
 b33:   00 
        if (page)
 b34:   4d 85 ff                test   %r15,%r15
 b37:   74 23                   je     b5c <page_pool_alloc_pages+0x6c>
}
 b39:   48 83 c4 08             add    $0x8,%rsp
 b3d:   4c 89 f8                mov    %r15,%rax
 b40:   5b                      pop    %rbx
 b41:   5d                      pop    %rbp
 b42:   41 5c                   pop    %r12
 b44:   41 5d                   pop    %r13
 b46:   41 5e                   pop    %r14
 b48:   41 5f                   pop    %r15
 b4a:   c3                      retq   
 [...]


> @@ -117,17 +120,42 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
>  	if (__ptr_ring_empty(r))
>  		return NULL;
>  
> -	/* Slow-path: Get page from locked ring queue,
> -	 * refill alloc array if requested.
> +	/* Softirq guarantee CPU and thus NUMA node is stable. This,
> +	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
>  	 */
> +	curr_nid = numa_mem_id();
> +
> +	/* Slower-path: Get pages from locked ring queue */
>  	spin_lock(&r->consumer_lock);
> -	page = __ptr_ring_consume(r);
> -	if (refill)
> -		pool->alloc.count = __ptr_ring_consume_batched(r,
> -							pool->alloc.cache,
> -							PP_ALLOC_CACHE_REFILL);
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
> +out:
>  	spin_unlock(&r->consumer_lock);
> -	return page;
> +	return first_page;
>  }

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

