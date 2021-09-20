Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D69F412ACB
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbhIUB6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236374AbhIUBuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:50:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404BBC0698FE;
        Mon, 20 Sep 2021 15:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yy0EwQ7J0sMHzSOPWcbFHFKHWeUukuqykjyt5I+NDUo=; b=c8ZwljTjtslpLLghi95Cqy1/Hk
        +Yu0waLRiRkg6H9rbFRN+VMHIJtVt7AIv0NX7aD2Zxg+WTo4aIrL6ma+oPWOwgeGusYXsw7OwAlkx
        IhrswmJoiAvUAOKqgARM9OaT+CpqaAzyIT2BvFmlN7YW3WBIlGIk0WIBo9/Hf/FH1h1W4s1o9ci1P
        Z6m7moIAwWub//99wTuoNA6EABZh8wGAsrjxhRp9aClp7olPq89oJmR2XyGPoBvK/TkysYHTP+R0d
        S5shbYSilOSOaPGSP+4crgkPbescejHhV9c5BIg0rX+4+BEgPCjsyo907BEdHB6bR7DnYGcILYA9x
        9yOZyurw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSRLg-003IEY-VT; Mon, 20 Sep 2021 22:01:23 +0000
Date:   Mon, 20 Sep 2021 23:01:16 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        John Garry <john.garry@huawei.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC v2 PATCH] mm, sl[au]b: Introduce lockless cache
Message-ID: <YUkErK1vVZMht4s8@casper.infradead.org>
References: <20210920154816.31832-1-42.hyeyoo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920154816.31832-1-42.hyeyoo@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 03:48:16PM +0000, Hyeonggon Yoo wrote:
> +#define KMEM_LOCKLESS_CACHE_QUEUE_SIZE 64

I would suggest that, to be nice to the percpu allocator, this be
one less than 2^n.

> +struct kmem_lockless_cache {
> +	void *queue[KMEM_LOCKLESS_CACHE_QUEUE_SIZE];
> +	unsigned int size;
> +};

I would also suggest that 'size' be first as it is going to be accessed
every time, and then there's a reasonable chance that queue[size - 1] will
be in the same cacheline.  CPUs will tend to handle that better.

> +/**
> + * kmem_cache_alloc_cached - try to allocate from cache without lock
> + * @s: slab cache
> + * @flags: SLAB flags
> + *
> + * Try to allocate from cache without lock. If fails, fill the lockless cache
> + * using bulk alloc API
> + *
> + * Be sure that there's no race condition.
> + * Must create slab cache with SLAB_LOCKLESS_CACHE flag to use this function.
> + *
> + * Return: a pointer to free object on allocation success, NULL on failure.
> + */
> +void *kmem_cache_alloc_cached(struct kmem_cache *s, gfp_t gfpflags)
> +{
> +	struct kmem_lockless_cache *cache = this_cpu_ptr(s->cache);
> +
> +	BUG_ON(!(s->flags & SLAB_LOCKLESS_CACHE));
> +
> +	if (cache->size) /* fastpath without lock */
> +		return cache->queue[--cache->size];
> +
> +	/* slowpath */
> +	cache->size = kmem_cache_alloc_bulk(s, gfpflags,
> +			KMEM_LOCKLESS_CACHE_QUEUE_SIZE, cache->queue);

Go back to the Bonwick paper and look at the magazine section again.
You have to allocate _half_ the size of the queue, otherwise you get
into pathological situations where you start to free and allocate
every time.

> +void kmem_cache_free_cached(struct kmem_cache *s, void *p)
> +{
> +	struct kmem_lockless_cache *cache = this_cpu_ptr(s->cache);
> +
> +	BUG_ON(!(s->flags & SLAB_LOCKLESS_CACHE));
> +
> +	/* Is there better way to do this? */
> +	if (cache->size == KMEM_LOCKLESS_CACHE_QUEUE_SIZE)
> +		kmem_cache_free(s, cache->queue[--cache->size]);

Yes.

	if (cache->size == KMEM_LOCKLESS_CACHE_QUEUE_SIZE) {
		kmem_cache_free_bulk(s, KMEM_LOCKLESS_CACHE_QUEUE_SIZE / 2,
			&cache->queue[KMEM_LOCKLESS_CACHE_QUEUE_SIZE / 2));
		cache->size = KMEM_LOCKLESS_CACHE_QUEUE_SIZE / 2;

(check the maths on that; it might have some off-by-one)

