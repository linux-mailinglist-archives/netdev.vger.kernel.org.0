Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF2615A408
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgBLIy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:54:58 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33223 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbgBLIy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:54:58 -0500
Received: by mail-wr1-f66.google.com with SMTP id u6so1203723wrt.0
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 00:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AW2rXZETrRJaKBFlOMRMrrok587Wjo8k9wRUzDgbX2s=;
        b=WbmOt5MojWk+Lbo0aI1T5AVy9iZfSc0O4qTeY8kA1x5xy0cqTOAJmHeKxN3psE4Utp
         nqbv7K7zgr9rCmqcuXa2X4fulo59YJbz3aWk95qHK7rcnep6aLdoeGi9pwBcH2XEtFCb
         H9MUSKJeVFg60OHeCD4+J7c26ZKs6qVmsgqerLhYCZ8crVD0KSHjWUfy84DZyJVUM4rQ
         hPkoif4N8yFqTwh7s8pgWSQonT5wMjN4p2u7PUPmYb/o82fHsH/O4rJhNz3wmnK4Cx6A
         sJZ236S92F37GZ5l+XEj5uNand9+OoLcvvFOmcrgG+f8iHyPLe72CO/YvNLiN/4/9i40
         vd6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AW2rXZETrRJaKBFlOMRMrrok587Wjo8k9wRUzDgbX2s=;
        b=QjrBZ8VqLvMuNDWwVK8jxzGGIR+exyLUNPnd6JKqWutFHOkt+NUyMCvJEXaF21zdL/
         0d35wTk4Ndm3r5eKmepCscLdnxX8HrjOlUqxGRRywT1O6V1T4S5woHRppEgrXxw0dgCW
         LMYcEALTaF972pklADDEfIKqZZ007njVGtDyZarl+K3ozMql/0A4XBuPF6BVesPmCsOn
         Wc52ejmbk+UeFe5RmM66LvPNNBCfkZdRQ3ZuZNpfbk6PepW/t+YMyESD5ZjumMspLmA8
         d6Z1QFFu8qfrCngHUTyFndNg+M/JJB+I+CwLWzXEZht97fxtN1/ts4UEad8wd9TVBgI6
         RbNQ==
X-Gm-Message-State: APjAAAXAZ1zLN1T4+0k43p/ItAIf2LLEv7dVrvloP8oYvX7XOkAC9VzK
        kcdbcuRtTLrVRCfOB0IJ9rCl+g==
X-Google-Smtp-Source: APXvYqxBa+AzL1Qnf+Q1bRABioSpC/7kzStNtSi7vCnzjYEaSb+BS5d0AKz4DY5sdnPGbRwNI4ySYg==
X-Received: by 2002:a5d:4c84:: with SMTP id z4mr14644530wrs.423.1581497696614;
        Wed, 12 Feb 2020 00:54:56 -0800 (PST)
Received: from apalos.home (ppp-2-87-54-32.home.otenet.gr. [2.87.54.32])
        by smtp.gmail.com with ESMTPSA id 16sm7104338wmi.0.2020.02.12.00.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 00:54:56 -0800 (PST)
Date:   Wed, 12 Feb 2020 10:54:54 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH][v2] page_pool: refill page when alloc.count of pool is
 zero
Message-ID: <20200212085454.GA1179593@apalos.home>
References: <1581387224-20719-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581387224-20719-1-git-send-email-lirongqing@baidu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 10:13:44AM +0800, Li RongQing wrote:
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
> ---
> v1-->v2: remove the in_serving_softirq test
> 
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
> -- 
> 2.16.2
> 

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
