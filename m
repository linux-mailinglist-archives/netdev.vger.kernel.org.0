Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EBC15A364
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgBLIgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:36:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42860 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728370AbgBLIgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:36:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581496575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=odThS3v+1FjM1ZTU82Q0GSNfQbpDXwfoFtJgRysmwgc=;
        b=DxNjeVl/EISWK3dvFSHLlDyyM/lsSU7Q1oMmlDeLRxtR0Q7Z3NOBuMqk4bgmKFD49O+yOm
        C0qDXdmp6sEjzBrm+zCKb82ED5bhIwsHWEs+0nuvc7g/Ui7sI+KO8+9tVwP2z7r9K5p+Un
        SK13NklOgWKIHIhZPzQVjBtvb8ZTIJ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-trKM1IamONm8sekB-HkW7g-1; Wed, 12 Feb 2020 03:36:07 -0500
X-MC-Unique: trKM1IamONm8sekB-HkW7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55A791857341;
        Wed, 12 Feb 2020 08:36:06 +0000 (UTC)
Received: from carbon (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82F4988836;
        Wed, 12 Feb 2020 08:36:02 +0000 (UTC)
Date:   Wed, 12 Feb 2020 09:36:00 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH][v2] page_pool: refill page when alloc.count of pool is
 zero
Message-ID: <20200212093600.7c1a71fe@carbon>
In-Reply-To: <1581387224-20719-1-git-send-email-lirongqing@baidu.com>
References: <1581387224-20719-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Feb 2020 10:13:44 +0800
Li RongQing <lirongqing@baidu.com> wrote:

> "do {} while" in page_pool_refill_alloc_cache will always
> refill page once whether refill is true or false, and whether
> alloc.count of pool is less than PP_ALLOC_CACHE_REFILL or not
> this is wrong, and will cause overflow of pool->alloc.cache
> 
> the caller of __page_pool_get_cached should provide guarantee
> that pool->alloc.cache is safe to access, so in_serving_softirq
> should be removed as suggested by Jesper Dangaard Brouer in
> https://patchwork.ozlabs.org/patch/1233713/
> 
> so fix this issue by calling page_pool_refill_alloc_cache()
> only when pool->alloc.count is zero
> 
> Fixes: 44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE condition")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Suggested: Jesper Dangaard Brouer <brouer@redhat.com>

You forgot the "-by" part of "suggested-by:", added it below so patchwork pick it up.

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>


> ---
> v1-->v2: remove the in_serving_softirq test

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

I've tested the patch and gave it some exercise with my page_pool
benchmarks tools, everything looked good.

 
>  net/core/page_pool.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9b7cbe35df37..10d2b255df5e 100644
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
> @@ -155,20 +153,16 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
>  /* fast path */
>  static struct page *__page_pool_get_cached(struct page_pool *pool)
>  {
> -	bool refill = false;
>  	struct page *page;
>  
> -	/* Test for safe-context, caller should provide this guarantee */
> -	if (likely(in_serving_softirq())) {
> -		if (likely(pool->alloc.count)) {
> -			/* Fast-path */
> -			page = pool->alloc.cache[--pool->alloc.count];
> -			return page;
> -		}
> -		refill = true;
> +	/* Caller MUST guarantee safe non-concurrent access, e.g. softirq */
> +	if (likely(pool->alloc.count)) {
> +		/* Fast-path */
> +		page = pool->alloc.cache[--pool->alloc.count];
> +	} else {
> +		page = page_pool_refill_alloc_cache(pool);
>  	}
>  
> -	page = page_pool_refill_alloc_cache(pool, refill);
>  	return page;
>  }
>  


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

