Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50DA3F26AC
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 08:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbhHTGLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 02:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbhHTGK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 02:10:58 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460B4C061575;
        Thu, 19 Aug 2021 23:10:21 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u16so12491274wrn.5;
        Thu, 19 Aug 2021 23:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ac8xk4QZ0AsubADNSbm2b6Jfh+V4lZPiV95c4+hPokQ=;
        b=kX29cpM1F0wEkMABi4kusUsEp9lYeDYd3lM5clD8+U3VaBH02hGTBDxacxILK/lcm5
         eWSNToiuNR6crBm8ECEE52OMva2tRT4wSfmhv3Z70IVsw1iRGyW8eUA2uy0WJ7+/BT/9
         7iDHHzIaYXxjA2uWKUIKwk3fOQWXET7nRD4q3i9QMG2eW6GTBPmbrV0b3x0SS7N8eq2z
         8RiW9rYK710UN5hubPldmi0Gh+JYoeosjl6YezhFOjWZMN05gz3rl07yGHm/94a+5HVC
         R+e4rUoV8ki527XyJdWyxU852MS0uHvkYpFzjOUU3U54vjZg4vQptwiZRWf9x8gkqEkY
         QwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ac8xk4QZ0AsubADNSbm2b6Jfh+V4lZPiV95c4+hPokQ=;
        b=bTJpwwN5UITVYWxttPIEAQ09MvghGAQt2mEyIh4LSgOFnB+A0cGZI7LLFBHVQbuHSS
         50IKQyfJIYdLP0V3Pms6wpDqb+U+QkVyB/cWwpdxEEpPYTULKRJg9LdN61R6S1+87po8
         E7i9JuELmh5WxzqV+eZZwPwIbB0QnWRxOkzc1shEDlHKJI0l9WjYjTuOKbj+akj9csY9
         dVoOdmU9RigUoKDdKczwgfj89koc21Ln21/sMZMi+45a8yj5/AEFzhOJ6nlSDAlhj9Kr
         7JakxmaSb21EaXt4cdqUzue/Oh4/toNeO3ynO/ZBAx/nS4UzhtKMTjj5xZN9H19Jm/Pk
         YlXQ==
X-Gm-Message-State: AOAM5325EsioOx+n3K/5esA38vjOFygaLV0iyopYNvGzuumeVl8qUByV
        HbS26iierG4ie4ogf9IzKw9CtxCvJdHEXg==
X-Google-Smtp-Source: ABdhPJwV4syEpp7yUjdE+KzlojggZVxnjCoJDVOSiGv8xARKI7jFUrSqm96QzNnnrF4/rjqA22+o0g==
X-Received: by 2002:adf:ebcd:: with SMTP id v13mr7860070wrn.400.1629439819691;
        Thu, 19 Aug 2021 23:10:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:bd22:3e10:4ffe:63e? (p200300ea8f084500bd223e104ffe063e.dip0.t-ipconnect.de. [2003:ea:8f08:4500:bd22:3e10:4ffe:63e])
        by smtp.googlemail.com with ESMTPSA id p8sm9064956wme.22.2021.08.19.23.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 23:10:19 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] page_pool: optimize the cpu sync operation
 when DMA mapping
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     hawk@kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1629425195-10130-1-git-send-email-linyunsheng@huawei.com>
 <1629425195-10130-3-git-send-email-linyunsheng@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <badfd7fd-ff25-f399-8828-9f44180d6948@gmail.com>
Date:   Fri, 20 Aug 2021 08:10:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1629425195-10130-3-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.08.2021 04:06, Yunsheng Lin wrote:
> If the DMA_ATTR_SKIP_CPU_SYNC is not set, cpu syncing is
> also done in dma_map_page_attrs(), so set the attrs according
> to pool->p.flags to avoid calling dma sync function again.
> 
> Also mark the dma error as the unlikely case While we are at
> it.
> 
This shouldn't be needed. dma_mapping_error() will be (most likely)
inlined by the compiler, and it includes the unlikely() hint.

> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  net/core/page_pool.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 1a69784..8172045 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -191,8 +191,12 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
>  
>  static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>  {
> +	unsigned long attrs = DMA_ATTR_SKIP_CPU_SYNC;
>  	dma_addr_t dma;
>  
> +	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> +		attrs = 0;
> +
>  	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
>  	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
>  	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
> @@ -200,15 +204,12 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>  	 */
>  	dma = dma_map_page_attrs(pool->p.dev, page, 0,
>  				 (PAGE_SIZE << pool->p.order),
> -				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> -	if (dma_mapping_error(pool->p.dev, dma))
> +				 pool->p.dma_dir, attrs);
> +	if (unlikely(dma_mapping_error(pool->p.dev, dma)))
>  		return false;
>  
>  	page_pool_set_dma_addr(page, dma);
>  
> -	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> -		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> -
>  	return true;
>  }
>  
> 

