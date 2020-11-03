Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4352A50F1
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 21:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgKCUfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 15:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCUfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 15:35:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5FFC0613D1;
        Tue,  3 Nov 2020 12:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jhWIvk3/m3TC3v+j/QSDYklWLqY6U0e9Aq2JYeev2bo=; b=vanESlzZiWnsgefLrh4w3dnT9Y
        cNAfQDzAn/FezTBH2U59DIZ5rsVUCvfd8K+oNJkOSNLjEJdVtt+5hPnCKCT6IGg3cQlfgzWDxreT7
        i1ReQe92bQFhRSjJofShWJsHHNnRrekqF+tvQTw2fOgZKnKWUHPHvbsBG22zz5RZWpoi8dTZoBTMe
        vJa2Ww/U8oy9ERytyLbgx+4UibMt2juPVF4XdTttSav5EZg77xgz7PG3Pt4ncf14kqf1jG7MasQAP
        ucSaL4vodjorEfigR6KZQHT4PrjabxpRlMU2mNOO6o214i7ac71c9BJhjNgav0+tUXKKtCtIyYbpZ
        HIVxG/7Q==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ka31A-0003zw-VI; Tue, 03 Nov 2020 20:35:01 +0000
Date:   Tue, 3 Nov 2020 20:35:00 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, aruna.ramakrishna@oracle.com,
        bert.barbe@oracle.com, rama.nichanamatlu@oracle.com,
        venkat.x.venkatsubra@oracle.com, manjunath.b.patil@oracle.com,
        joe.jin@oracle.com, srinivas.eeda@oracle.com
Subject: Re: [PATCH 1/1] mm: avoid re-using pfmemalloc page in
 page_frag_alloc()
Message-ID: <20201103203500.GG27442@casper.infradead.org>
References: <20201103193239.1807-1-dongli.zhang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103193239.1807-1-dongli.zhang@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 11:32:39AM -0800, Dongli Zhang wrote:
> The ethernet driver may allocates skb (and skb->data) via napi_alloc_skb().
> This ends up to page_frag_alloc() to allocate skb->data from
> page_frag_cache->va.
> 
> During the memory pressure, page_frag_cache->va may be allocated as
> pfmemalloc page. As a result, the skb->pfmemalloc is always true as
> skb->data is from page_frag_cache->va. The skb will be dropped if the
> sock (receiver) does not have SOCK_MEMALLOC. This is expected behaviour
> under memory pressure.
> 
> However, once kernel is not under memory pressure any longer (suppose large
> amount of memory pages are just reclaimed), the page_frag_alloc() may still
> re-use the prior pfmemalloc page_frag_cache->va to allocate skb->data. As a
> result, the skb->pfmemalloc is always true unless page_frag_cache->va is
> re-allocated, even the kernel is not under memory pressure any longer.
> 
> Here is how kernel runs into issue.
> 
> 1. The kernel is under memory pressure and allocation of
> PAGE_FRAG_CACHE_MAX_ORDER in __page_frag_cache_refill() will fail. Instead,
> the pfmemalloc page is allocated for page_frag_cache->va.
> 
> 2: All skb->data from page_frag_cache->va (pfmemalloc) will have
> skb->pfmemalloc=true. The skb will always be dropped by sock without
> SOCK_MEMALLOC. This is an expected behaviour.
> 
> 3. Suppose a large amount of pages are reclaimed and kernel is not under
> memory pressure any longer. We expect skb->pfmemalloc drop will not happen.
> 
> 4. Unfortunately, page_frag_alloc() does not proactively re-allocate
> page_frag_alloc->va and will always re-use the prior pfmemalloc page. The
> skb->pfmemalloc is always true even kernel is not under memory pressure any
> longer.
> 
> Therefore, this patch always checks and tries to avoid re-using the
> pfmemalloc page for page_frag_alloc->va.
> 
> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> Cc: Bert Barbe <bert.barbe@oracle.com>
> Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
> Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
> Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Cc: SRINIVAS <srinivas.eeda@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  mm/page_alloc.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 23f5066bd4a5..291df2f9f8f3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5075,6 +5075,16 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>  	struct page *page;
>  	int offset;
>  
> +	/*
> +	 * Try to avoid re-using pfmemalloc page because kernel may already
> +	 * run out of the memory pressure situation at any time.
> +	 */
> +	if (unlikely(nc->va && nc->pfmemalloc)) {
> +		page = virt_to_page(nc->va);
> +		__page_frag_cache_drain(page, nc->pagecnt_bias);
> +		nc->va = NULL;
> +	}

I think this is the wrong way to solve this problem.  Instead, we should
use up this page, but refuse to recycle it.  How about something like this (not even compile tested):

+++ b/mm/page_alloc.c
@@ -5139,6 +5139,10 @@ void *page_frag_alloc(struct page_frag_cache *nc,
 
                if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
                        goto refill;
+               if (nc->pfmemalloc) {
+                       free_the_page(page);
+                       goto refill;
+               }
 
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
                /* if size can vary use size else just use PAGE_SIZE */

