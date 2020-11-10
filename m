Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C372AD444
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 12:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgKJLAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 06:00:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726280AbgKJLAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 06:00:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605006032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQDWo1vCPPz1rv0IIc4nrWdJxfXcy7I/Q8oJ88R2uIc=;
        b=G0xtZjQf0CJ39Tl7WuI7+7uwPUDKVDnW/VOUXSFeYXkJU8IRwSyyA9J6A404LlBSQXXT4D
        Jr+Eoalu0Sn239PMUkp5IBwhT45qCvhBoLEWkdUgcRyHAKyG6Ar2dsd1HtDWQ8epCezEqo
        i+t41wUAnV7/RnGsZ7xZ4ugKihZ/p8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-zcaJI0hqPg-blo29m5lR3w-1; Tue, 10 Nov 2020 06:00:29 -0500
X-MC-Unique: zcaJI0hqPg-blo29m5lR3w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 374A5809DDA;
        Tue, 10 Nov 2020 11:00:28 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F42F1002C1E;
        Tue, 10 Nov 2020 11:00:19 +0000 (UTC)
Date:   Tue, 10 Nov 2020 12:00:17 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH v4 net-next 2/5] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201110120017.362f5ca5@carbon>
In-Reply-To: <1a39bf0efb8c2832245216d7ccd41582c408e9f4.1604686496.git.lorenzo@kernel.org>
References: <cover.1604686496.git.lorenzo@kernel.org>
        <1a39bf0efb8c2832245216d7ccd41582c408e9f4.1604686496.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 19:19:08 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce the capability to batch page_pool ptr_ring refill since it is
> usually run inside the driver NAPI tx completion loop.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/page_pool.h | 26 ++++++++++++++++
>  net/core/page_pool.c    | 66 ++++++++++++++++++++++++++++++++++-------
>  net/core/xdp.c          |  9 ++----
>  3 files changed, 84 insertions(+), 17 deletions(-)

My own suggestion to create __page_pool_put_page() for code sharing,
cause a performance regression, because compiler chooses not to inline
the function.  This cause unnecessary code for in_serving_softirq() and
function call overhead.

I'm currently testing with __always_inline and likely/unlikely
annotation to get compiler to layout code better for I-cache.  This
shows improvements in my benchmarks. Details in[1].

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/xdp_bulk_return01.org

> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ef98372facf6..31dac2ad4a1f 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
[...]
> @@ -362,8 +364,9 @@ static bool pool_page_reusable(struct page_pool *pool, struct page *page)
>   * If the page refcnt != 1, then the page will be returned to memory
>   * subsystem.
>   */
> -void page_pool_put_page(struct page_pool *pool, struct page *page,
> -			unsigned int dma_sync_size, bool allow_direct)
> +static struct page *
> +__page_pool_put_page(struct page_pool *pool, struct page *page,
> +		     unsigned int dma_sync_size, bool allow_direct)
>  {
>  	/* This allocator is optimized for the XDP mode that uses
>  	 * one-frame-per-page, but have fallbacks that act like the
> @@ -379,15 +382,12 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
>  			page_pool_dma_sync_for_device(pool, page,
>  						      dma_sync_size);
>  
> -		if (allow_direct && in_serving_softirq())
> -			if (page_pool_recycle_in_cache(page, pool))
> -				return;
> +		if (allow_direct && in_serving_softirq() &&
> +		    page_pool_recycle_in_cache(page, pool))
> +			return NULL;
>  
> -		if (!page_pool_recycle_in_ring(pool, page)) {
> -			/* Cache full, fallback to free pages */
> -			page_pool_return_page(pool, page);
> -		}
> -		return;
> +		/* page is candidate for bulking */
> +		return page;
>  	}
>  	/* Fallback/non-XDP mode: API user have elevated refcnt.
>  	 *
> @@ -405,9 +405,55 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
>  	/* Do not replace this with page_pool_return_page() */
>  	page_pool_release_page(pool, page);
>  	put_page(page);
> +
> +	return NULL;
> +}
> +
> +void page_pool_put_page(struct page_pool *pool, struct page *page,
> +			unsigned int dma_sync_size, bool allow_direct)
> +{
> +	page = __page_pool_put_page(pool, page, dma_sync_size, allow_direct);
> +	if (page && !page_pool_recycle_in_ring(pool, page)) {
> +		/* Cache full, fallback to free pages */
> +		page_pool_return_page(pool, page);
> +	}
>  }
>  EXPORT_SYMBOL(page_pool_put_page);
>  
> +/* Caller must not use data area after call, as this function overwrites it */
> +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> +			     int count)
> +{
> +	int i, bulk_len = 0, pa_len = 0;
> +
> +	for (i = 0; i < count; i++) {
> +		struct page *page = virt_to_head_page(data[i]);
> +
> +		page = __page_pool_put_page(pool, page, -1, false);
> +		/* Approved for bulk recycling in ptr_ring cache */
> +		if (page)
> +			data[bulk_len++] = page;
> +	}
> +
> +	if (!bulk_len)
> +		return;
> +
> +	/* Bulk producer into ptr_ring page_pool cache */
> +	page_pool_ring_lock(pool);
> +	for (i = 0; i < bulk_len; i++) {
> +		if (__ptr_ring_produce(&pool->ring, data[i]))
> +			data[pa_len++] = data[i];
> +	}
> +	page_pool_ring_unlock(pool);
> +
> +	/* ptr_ring cache full, free pages outside producer lock since
> +	 * put_page() with refcnt == 1 can be an expensive operation
> +	 */
> +	for (i = 0; i < pa_len; i++)
> +		page_pool_return_page(pool, data[i]);
> +}
> +EXPORT_SYMBOL(page_pool_put_page_bulk);


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

