Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACC62A9E5B
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgKFUCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:02:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728139AbgKFUCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 15:02:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604692963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IEqJQhGR6BWutrG60hEyihEs9IE7LdmX+au3tc7ZcmQ=;
        b=RvCHbNwPGmx7r/9IKcwdlx+FxcgfuAlTEyptylC1NHGxZt2qCpkFzcsrLN89zKPPj29QnT
        fGwzWdqHFt77lrT6v5rlymXh7t7puadfR0pknVfYSc/dvaclYobyTGmihDZxYpeXT0TLZV
        rbkGLyHwJilhUW/WR659qv9Lu8UoH4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-EJ6ckdChPYabuNly2I2ODA-1; Fri, 06 Nov 2020 15:02:39 -0500
X-MC-Unique: EJ6ckdChPYabuNly2I2ODA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8DAE64174;
        Fri,  6 Nov 2020 20:02:37 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79B2C1002C35;
        Fri,  6 Nov 2020 20:02:05 +0000 (UTC)
Date:   Fri, 6 Nov 2020 21:02:01 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH v4 net-next 2/5] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201106210201.644d722a@carbon>
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

> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ef98372facf6..31dac2ad4a1f 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -11,6 +11,8 @@
>  #include <linux/device.h>
>  
>  #include <net/page_pool.h>
> +#include <net/xdp.h>
> +
>  #include <linux/dma-direction.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/page-flags.h>
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

I don't like this comment.  This function is also used by non-bulking
case.  Reaching this point means the page is ready or fulfill the
requirement for being recycled into the ptr_ring.

I suggest (as before):
		/* Page found as candidate for recycling */

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

Rest looks okay :-)
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

