Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F641153028
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 12:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBELuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 06:50:46 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59496 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726944AbgBELup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 06:50:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580903443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FYebKB7yhQM7GctpkUqr4pLrxF+mVtTk76IkEEVA2Yk=;
        b=Yu7AwkGFTrRGmow43zkwVqhJysA2RNE0HobR124iajWC0TNDz6ymdWEyljzzPPNdYVF8vM
        4HAhfguKOo5WW7T4ODJt3CZvj7Cd8m4ThQVWRlqF6INuax6zaoMEVMeP+kz9uMQcgp1QMy
        CcsKp39pqIuJZLvSQH3qHfJ6+jOaFX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-bqQCSUWmPFuF2hkihehTtw-1; Wed, 05 Feb 2020 06:50:40 -0500
X-MC-Unique: bqQCSUWmPFuF2hkihehTtw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D337285EE6A;
        Wed,  5 Feb 2020 11:50:39 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B34919C7F;
        Wed,  5 Feb 2020 11:50:35 +0000 (UTC)
Date:   Wed, 5 Feb 2020 12:50:31 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org, brouer@redhat.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH] page_pool: fill page only when refill condition is true
Message-ID: <20200205125031.57c1f0d6@carbon>
In-Reply-To: <1580890954-21322-1-git-send-email-lirongqing@baidu.com>
References: <1580890954-21322-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Feb 2020 16:22:34 +0800
Li RongQing <lirongqing@baidu.com> wrote:

> "do {} while" in page_pool_refill_alloc_cache will always
> refill page once whether refill is true or false, and whether
> alloc.count of pool is less than PP_ALLOC_CACHE_REFILL.
> 
> so fix it by calling page_pool_refill_alloc_cache() only when
> refill is true
> 
> Fixes: 44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE condition")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>

Hmmm... I'm not 100% convinced this is the right approach.

I do realize that in commit 44768decb7c0, I also added touching
pool->alloc.cache[] which was protected by "called under" in_serving_softirq().
(before I used a locked ptr_ring_consume(r)).

BUT maybe it will be better to remove, the test in_serving_softirq(),
because the caller should provide guarantee that pool->alloc.cache[] is
safe to access.

I added this in_serving_softirq() check, because I noticed NIC drivers
will call this from normal process context, during (1) initial fill of
their RX-rings, and (2) during driver RX-ring shutdown.  BUT in both
cases the NIC drivers will first have made sure that their RX-ring have
been disconnected and no concurrent accesses will happen.  Thus, access
to pool->alloc.cache[] is safe, so page_pool API should trust the
caller knows this.


> ---
>  net/core/page_pool.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9b7cbe35df37..35ce663cb9de 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -99,8 +99,7 @@ EXPORT_SYMBOL(page_pool_create);
>  static void __page_pool_return_page(struct page_pool *pool, struct page *page);
>  
>  noinline
> -static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
> -						 bool refill)
> +static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
>  {
>  	struct ptr_ring *r = &pool->ring;
>  	struct page *page;
> @@ -141,8 +140,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
>  			page = NULL;
>  			break;
>  		}
> -	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL &&
> -		 refill);
> +	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL);
>  
>  	/* Return last page */
>  	if (likely(pool->alloc.count > 0))
> @@ -156,7 +154,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
>  static struct page *__page_pool_get_cached(struct page_pool *pool)
>  {
>  	bool refill = false;
> -	struct page *page;
> +	struct page *page = NULL;
>  
>  	/* Test for safe-context, caller should provide this guarantee */
>  	if (likely(in_serving_softirq())) {
> @@ -168,7 +166,8 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
>  		refill = true;
>  	}
>  
> -	page = page_pool_refill_alloc_cache(pool, refill);
> +	if (refill)
> +		page = page_pool_refill_alloc_cache(pool);
>  	return page;
>  }

I guess, I instead propose:

 git diff
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b7cbe35df37..10d2b255df5e 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -99,8 +99,7 @@ EXPORT_SYMBOL(page_pool_create);
 static void __page_pool_return_page(struct page_pool *pool, struct page *page);
 
 noinline
-static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
-                                                bool refill)
+static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 {
        struct ptr_ring *r = &pool->ring;
        struct page *page;
@@ -141,8 +140,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
                        page = NULL;
                        break;
                }
-       } while (pool->alloc.count < PP_ALLOC_CACHE_REFILL &&
-                refill);
+       } while (pool->alloc.count < PP_ALLOC_CACHE_REFILL);
 
        /* Return last page */
        if (likely(pool->alloc.count > 0))
@@ -155,20 +153,16 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
 /* fast path */
 static struct page *__page_pool_get_cached(struct page_pool *pool)
 {
-       bool refill = false;
        struct page *page;
 
-       /* Test for safe-context, caller should provide this guarantee */
-       if (likely(in_serving_softirq())) {
-               if (likely(pool->alloc.count)) {
-                       /* Fast-path */
-                       page = pool->alloc.cache[--pool->alloc.count];
-                       return page;
-               }
-               refill = true;
+       /* Caller MUST guarantee safe non-concurrent access, e.g. softirq */
+       if (likely(pool->alloc.count)) {
+               /* Fast-path */
+               page = pool->alloc.cache[--pool->alloc.count];
+       } else {
+               page = page_pool_refill_alloc_cache(pool);
        }
 
-       page = page_pool_refill_alloc_cache(pool, refill);
  



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

