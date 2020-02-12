Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC2815A29D
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgBLIBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:01:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33695 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgBLIBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:01:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id m10so4063212wmc.0
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 00:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lmPR1Xe9opiuaBTqrJK/I3zu36nY5Lxo/WsN3SiXlI0=;
        b=NOz0kGbONpCvbGLpHXyA4Q80Txi1QLqlWEjOXFPVUa3QxO6Iu9JwYaRNJYQAvV5fhT
         fzjos+xg51q4TFepcexEzDzHvnTTPguzGhhYOSFC+ngvCnRXCDEDf3Y1Ocxe39KzYAL0
         mUi0MwkgZAvEdVjiWcZoseQc7+oqL0onEL50VmCRt7ze+/fJOED4VhPNuVpltxYfh9jn
         Cu+mUdMkIMoPKQX3+q+ROvAI9uwTFUgT2uceXtuibpGO5vrdozpkv4aOA9y/Zj8LETl6
         aaYl+YrdVqHcemw6VkpIB623gbJBJ0W5gWirpZGy0NjNj6+/DNse7lpGUE7miZSut31Z
         EUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lmPR1Xe9opiuaBTqrJK/I3zu36nY5Lxo/WsN3SiXlI0=;
        b=j08Fk5EdpeS3up4inlo2NdGnJ5+3rJw21QffAYLrcldfYD1Z22sGEYWIQlwo7LDQsK
         flvczWw52n9ceMQpD2YNO/J6ovHrpk8RTanJ7P/9UaIJ/Sx/KveMYdmH7g0pof+YLpc0
         jIx3t2ipwxX+hKo1vSVIiUS6xOb+YbiWNYso/bmeewtNdN/hH25JM+oX1kVW3StfgOox
         1c3w9nTApASaSrvzV4vhhZpsf16Mw6DzgctcCp0Lm0miX8TbsDWDDrP7n0s4ZFDUXiri
         yVYWmhpVFCho0U0lfnx3fet9jxMntIUJ7HMX4BgW6jfsD/5euTfXIpY3hHWJbzdsa8SD
         m+bw==
X-Gm-Message-State: APjAAAUpII0orAQieid/59/vDKI44aawk+fBsVFSfri11fj+J7jNaJ5T
        Iab8O9o0J60uciKjqnUox4qsZg==
X-Google-Smtp-Source: APXvYqw+Ie/n5t8mClN7YTsdOesmGk4YpEm2+t+XRc9xxjbuU63PqDca4gVk8bDUk8SbPvsGpKwYnQ==
X-Received: by 2002:a1c:48c1:: with SMTP id v184mr11029309wma.5.1581494504748;
        Wed, 12 Feb 2020 00:01:44 -0800 (PST)
Received: from apalos.home (ppp-2-87-54-32.home.otenet.gr. [2.87.54.32])
        by smtp.gmail.com with ESMTPSA id i204sm7531612wma.44.2020.02.12.00.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 00:01:44 -0800 (PST)
Date:   Wed, 12 Feb 2020 10:01:41 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH][v2] page_pool: refill page when alloc.count of pool is
 zero
Message-ID: <20200212080141.GA1174676@apalos.home>
References: <1581387224-20719-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581387224-20719-1-git-send-email-lirongqing@baidu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Li,

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

Please include me on any future mails regarding pate pool. I almost missed this
one

Thanks
/Ilias
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
