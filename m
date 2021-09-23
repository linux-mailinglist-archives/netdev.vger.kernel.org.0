Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A07415DEA
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240792AbhIWMJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:09:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240733AbhIWMJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632398889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wfX6IYx3+cjotqqgeU3GLgEgUJixfrJO00QEhWanizg=;
        b=EqChbtiSxedZbLcGdvtAbgNOcGSPkY8qRIWz7Z0QFaAcKYOCM4pdtKQt29vqojoOGa2Htz
        7EMMlViKfmc2GKnvBYRXXRRJ+YmBhzJUuUofYTIDcY5AiPdxCP3hPjTn0srBN3ofxsH9wH
        TMGuoTPOnghpyyA4fDj/1c90GuPPqhc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-1JD4UfQgMCm6RzaQ7eDqFg-1; Thu, 23 Sep 2021 08:08:07 -0400
X-MC-Unique: 1JD4UfQgMCm6RzaQ7eDqFg-1
Received: by mail-lf1-f69.google.com with SMTP id o4-20020a056512230400b003fc39bb96c7so5904774lfu.8
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 05:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wfX6IYx3+cjotqqgeU3GLgEgUJixfrJO00QEhWanizg=;
        b=alpjQMU0lmESBKDtsxSJzJPbj9exGvad5VFYTgZGvYlXtMmYM+K4xXy4xoLHzstd78
         nWorDhmbm2xw2Cb329D435QsXxHCTRusLYegVoofQTPi6bipxSUhX3WsVE3JOAnifpnP
         CxxJxrsP+fyPElrPfBl6GE7udPMh6l0W9KumnF9Qm6l0SCpUkGGyYSTbyx1kTJGucu2T
         ChGZyVeOlgpSjEEkzlEH7/0vFHpStDuf/S4oAo15AKz8OW+LLtWCwpQtYuL1by7fW5SJ
         l4M4WzyHTPxsODRlG38tYS11HYc6Vzgs8y5lbLnVvPudRocWV+foiih1jSLGFQVWiyvK
         1V0w==
X-Gm-Message-State: AOAM530tYlPCRWPYqxkp9tRGEGKQM8DGlzAYUBCEYc5ArdPaQSSLE61F
        YRpdBf2Ly3hXtrflu7aTtPJpKAQWeXBMZoBwzqhE+tuiMSL5k31WGD8nIBtyKgoZs2D3he+swNI
        sF5o8p2+lycnbMO8Y
X-Received: by 2002:a2e:584:: with SMTP id 126mr491196ljf.126.1632398886321;
        Thu, 23 Sep 2021 05:08:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvHZO4Tckj6DIt294JJG00bnWYHQJ7x4NbhTMU8P1fLHefb48FQBjkpuhOQ9xDF6sE59tRXg==
X-Received: by 2002:a2e:584:: with SMTP id 126mr491169ljf.126.1632398886131;
        Thu, 23 Sep 2021 05:08:06 -0700 (PDT)
Received: from [192.168.42.238] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id l9sm213486ljg.44.2021.09.23.05.08.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 05:08:05 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        jonathan.lemon@gmail.com, alobakin@pm.me, willemb@google.com,
        cong.wang@bytedance.com, pabeni@redhat.com, haokexin@gmail.com,
        nogikh@google.com, elver@google.com, memxor@gmail.com,
        edumazet@google.com, alexander.duyck@gmail.com, dsahern@gmail.com
Subject: Re: [PATCH net-next 2/7] page_pool: support non-split page with
 PP_FLAG_PAGE_FRAG
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
References: <20210922094131.15625-1-linyunsheng@huawei.com>
 <20210922094131.15625-3-linyunsheng@huawei.com>
Message-ID: <c85a4ecc-80bb-d78f-d72a-0f820fb02eb9@redhat.com>
Date:   Thu, 23 Sep 2021 14:08:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922094131.15625-3-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22/09/2021 11.41, Yunsheng Lin wrote:
> Currently when PP_FLAG_PAGE_FRAG is set, the caller is not
> expected to call page_pool_alloc_pages() directly because of
> the PP_FLAG_PAGE_FRAG checking in __page_pool_put_page().
> 
> The patch removes the above checking to enable non-split page
> support when PP_FLAG_PAGE_FRAG is set.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>   net/core/page_pool.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index a65bd7972e37..f7e71dcb6a2e 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -315,11 +315,14 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
>   
>   	/* Fast-path: Get a page from cache */
>   	page = __page_pool_get_cached(pool);
> -	if (page)
> -		return page;
>   
>   	/* Slow-path: cache empty, do real allocation */
> -	page = __page_pool_alloc_pages_slow(pool, gfp);
> +	if (!page)
> +		page = __page_pool_alloc_pages_slow(pool, gfp);
> +
> +	if (likely(page))
> +		page_pool_set_frag_count(page, 1);
> +

I really don't like that you add one atomic_long_set operation per page 
alloc call.
This is a fast-path for XDP use-cases, which you are ignoring as you 
drivers doesn't implement XDP.

As I cannot ask you to run XDP benchmarks, I fortunately have some 
page_pool specific microbenchmarks you can run instead.

I will ask you to provide before and after results from running these 
benchmarks [1] and [2].

  [1] 
https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c

  [2] 
https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_cross_cpu.c

How to use these module is documented here[3]:
  [3] 
https://prototype-kernel.readthedocs.io/en/latest/prototype-kernel/build-process.html

>   	return page;
>   }
>   EXPORT_SYMBOL(page_pool_alloc_pages);
> @@ -428,8 +431,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>   		     unsigned int dma_sync_size, bool allow_direct)
>   {
>   	/* It is not the last user for the page frag case */
> -	if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
> -	    page_pool_atomic_sub_frag_count_return(page, 1))
> +	if (page_pool_atomic_sub_frag_count_return(page, 1))
>   		return NULL;

This adds an atomic_long_read, even when PP_FLAG_PAGE_FRAG is not set.

>   
>   	/* This allocator is optimized for the XDP mode that uses
> 

