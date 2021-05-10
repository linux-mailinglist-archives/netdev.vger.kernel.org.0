Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557B2379436
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhEJQj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:39:27 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:33350 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbhEJQjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 12:39:13 -0400
Received: by mail-ej1-f47.google.com with SMTP id t4so25569634ejo.0;
        Mon, 10 May 2021 09:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bMp27vjnpmoienkYOT4SN0KllWYc9kDbddnvTB+uzc0=;
        b=YsCXn5TUhrY9TC79A3oY/ofHCDCZ4s/MMuOFgV2REc2qjTeV8jNoIN+qE3u+KnYFjo
         LJmDDgILA84wuJelo5+h5m96tOVOvKfgWs19VKbdQSmDN3xUhoLcWSjkmrRRbMD+gm/8
         y6bsD9rWvfXJHJgP4uWhJfoEWjIe8V2Rh7KWH6K6nM9jEOXBbldNQLSpKkl0e+DAzlIj
         ovEU8aDV0uV9LQKlg7LJymE+FSIMQdPf3yfjzpnxzKKDb6hjHnsy4YEZFpPmxKtM5Rqv
         ofpAC29rowzyHQmQgryXz5sL80s5rRUQn2h321Bp6BiomAT6dva3pZdU5nlWrxjliZSS
         e2Ew==
X-Gm-Message-State: AOAM532Db8W4EBc01QUNXz8zRWQxbdFjxZA0JgGRpm/aS/8fgYDnkPTe
        YfvzSf6B2Xfu0o3/gTBj/Hc=
X-Google-Smtp-Source: ABdhPJxngxasS9kSwAqLewU+kX4d6eFSK+sYWdvZKTa8IXx9X39lFpQYeqK/u/q6+52891rCrKTCZQ==
X-Received: by 2002:a17:906:8285:: with SMTP id h5mr26338206ejx.456.1620664687663;
        Mon, 10 May 2021 09:38:07 -0700 (PDT)
Received: from localhost (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id g4sm11680730edq.0.2021.05.10.09.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 09:38:07 -0700 (PDT)
Date:   Mon, 10 May 2021 18:38:04 +0200
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-mm@kvack.org, stable@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, netdev@vger.kernel.org
Subject: Re: [PATCH] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210510183804.05bc134f@linux.microsoft.com>
In-Reply-To: <20210510153211.1504886-1-willy@infradead.org>
References: <20210510153211.1504886-1-willy@infradead.org>
Organization: Microsoft
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 May 2021 16:32:11 +0100
"Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> 32-bit architectures which expect 8-byte alignment for 8-byte integers
> and need 64-bit DMA addresses (arm, mips, ppc) had their struct page
> inadvertently expanded in 2019.  When the dma_addr_t was added, it
> forced the alignment of the union to 8 bytes, which inserted a 4 byte
> gap between 'flags' and the union.
> 
> Fix this by storing the dma_addr_t in one or two adjacent unsigned
> longs. This restores the alignment to that of an unsigned long.  We
> always store the low bits in the first word to prevent the PageTail
> bit from being inadvertently set on a big endian platform.  If that
> happened, get_user_pages_fast() racing against a page which was freed
> and reallocated to the page_pool could dereference a bogus
> compound_head(), which would be hard to trace back to this cause.
> 
> Fixes: c25fff7171be ("mm: add dma_addr_t to struct page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/mm_types.h |  4 ++--
>  include/net/page_pool.h  | 12 +++++++++++-
>  net/core/page_pool.c     | 12 +++++++-----
>  3 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 6613b26a8894..5aacc1c10a45 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -97,10 +97,10 @@ struct page {
>  		};
>  		struct {	/* page_pool used by netstack */
>  			/**
> -			 * @dma_addr: might require a 64-bit value
> even on
> +			 * @dma_addr: might require a 64-bit value on
>  			 * 32-bit architectures.
>  			 */
> -			dma_addr_t dma_addr;
> +			unsigned long dma_addr[2];
>  		};
>  		struct {	/* slab, slob and slub */
>  			union {
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 6d517a37c18b..b4b6de909c93 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -198,7 +198,17 @@ static inline void
> page_pool_recycle_direct(struct page_pool *pool, 
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
> -	return page->dma_addr;
> +	dma_addr_t ret = page->dma_addr[0];
> +	if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +		ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
> +	return ret;
> +}
> +
> +static inline void page_pool_set_dma_addr(struct page *page,
> dma_addr_t addr) +{
> +	page->dma_addr[0] = addr;
> +	if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +		page->dma_addr[1] = upper_32_bits(addr);
>  }
>  
>  static inline bool is_page_pool_compiled_in(void)
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9ec1aa9640ad..3c4c4c7a0402 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -174,8 +174,10 @@ static void page_pool_dma_sync_for_device(struct
> page_pool *pool, struct page *page,
>  					  unsigned int dma_sync_size)
>  {
> +	dma_addr_t dma_addr = page_pool_get_dma_addr(page);
> +
>  	dma_sync_size = min(dma_sync_size, pool->p.max_len);
> -	dma_sync_single_range_for_device(pool->p.dev, page->dma_addr,
> +	dma_sync_single_range_for_device(pool->p.dev, dma_addr,
>  					 pool->p.offset,
> dma_sync_size, pool->p.dma_dir);
>  }
> @@ -195,7 +197,7 @@ static bool page_pool_dma_map(struct page_pool
> *pool, struct page *page) if (dma_mapping_error(pool->p.dev, dma))
>  		return false;
>  
> -	page->dma_addr = dma;
> +	page_pool_set_dma_addr(page, dma);
>  
>  	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>  		page_pool_dma_sync_for_device(pool, page,
> pool->p.max_len); @@ -331,13 +333,13 @@ void
> page_pool_release_page(struct page_pool *pool, struct page *page) */
>  		goto skip_dma_unmap;
>  
> -	dma = page->dma_addr;
> +	dma = page_pool_get_dma_addr(page);
>  
> -	/* When page is unmapped, it cannot be returned our pool */
> +	/* When page is unmapped, it cannot be returned to our pool
> */ dma_unmap_page_attrs(pool->p.dev, dma,
>  			     PAGE_SIZE << pool->p.order,
> pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> -	page->dma_addr = 0;
> +	page_pool_set_dma_addr(page, 0);
>  skip_dma_unmap:
>  	/* This may be the last page returned, releasing the pool, so
>  	 * it is not safe to reference pool afterwards.

I rebased the skb recycling series against this change. I have it
running since a few days on a machine (MacchiatoBIN Double shot) which
uses the mvpp2 driver.
No issues so far.

Regards,
-- 
per aspera ad upstream
