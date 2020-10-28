Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C789029E24A
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387999AbgJ2CMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:12:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726117AbgJ1Vg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603920985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9rqOW65xAuPlxO/fPjDZqq3N4k//usVfbQHxHvVoa5o=;
        b=VM33z7gf8gFIpBS5VtdeJY5ybt+HXwLVYdzi7wOUQHYvxCill0bPsck43F3Jb/g8/oRSl7
        hoBzOXRF3Hj3z68dKsKSB6TdPYAH1mzs/CFoOgv2MoIRA1GSU1oqHO1r3VWFz5wFTAGeNS
        zPV9faMwV95EGsREf5MQDcp9f9FWLnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-bWMkvP3BM_eLxzxyCP3Z8w-1; Wed, 28 Oct 2020 07:34:31 -0400
X-MC-Unique: bWMkvP3BM_eLxzxyCP3Z8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76E9E1099F67;
        Wed, 28 Oct 2020 11:34:29 +0000 (UTC)
Received: from carbon (unknown [10.36.110.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E997C10013D0;
        Wed, 28 Oct 2020 11:34:20 +0000 (UTC)
Date:   Wed, 28 Oct 2020 12:34:19 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH net-next 1/4] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201028123419.27e1ac54@carbon>
In-Reply-To: <7495b5ac96b0fd2bf5ab79b12e01bf0ee0fff803.1603824486.git.lorenzo@kernel.org>
References: <cover.1603824486.git.lorenzo@kernel.org>
        <7495b5ac96b0fd2bf5ab79b12e01bf0ee0fff803.1603824486.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 20:04:07 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce bulking capability in xdp tx return path (XDP_REDIRECT).
> xdp_return_frame is usually run inside the driver NAPI tx completion
> loop so it is possible batch it.
> Current implementation considers only page_pool memory model.
> Convert mvneta driver to xdp_return_frame_bulk APIs.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>

I think you/we have to explain better in this commit message, what the
idea/concept behind this bulk return is.  Or even explain this as a
comment above "xdp_return_frame_bulk".

Maybe add/append text to commit below:

The bulk API introduced is a defer and flush API, that will defer
the return if the xdp_mem_allocator object is the same, identified
via the mem.id field (xdp_mem_info).  Thus, the flush operation will
operate on the same xdp_mem_allocator object.

The bulk queue size of 16 is no coincident.  This is connected to how
XDP redirect will bulk xmit (upto 16) frames. Thus, the idea is for the
API to find these boundaries (via mem.id match), which is optimal for
both the I-cache and D-cache for the memory allocator code and object.

The data structure (xdp_frame_bulk) used for deferred elements is
stored/allocated on the function call-stack, which allows lockfree
access.


> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
[...]
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 3814fb631d52..9567110845ef 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -104,6 +104,12 @@ struct xdp_frame {
>  	struct net_device *dev_rx; /* used by cpumap */
>  };
>  
> +#define XDP_BULK_QUEUE_SIZE	16

Maybe "#define DEV_MAP_BULK_SIZE 16" should be def to
XDP_BULK_QUEUE_SIZE, to express the described connection.

> +struct xdp_frame_bulk {
> +	void *q[XDP_BULK_QUEUE_SIZE];
> +	int count;
> +	void *xa;

Just a hunch (not benchmarked), but I think it will be more optimal to
place 'count' and '*xa' above the '*q' array.  (It might not matter at
all, as we cannot control the start alignment, when this is on the
stack.)

> +};
[...]

> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 48aba933a5a8..93eabd789246 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -380,6 +380,57 @@ void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
>  
> +void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq)
> +{
> +	struct xdp_mem_allocator *xa = bq->xa;
> +	int i;
> +
> +	if (unlikely(!xa))
> +		return;
> +
> +	for (i = 0; i < bq->count; i++) {
> +		struct page *page = virt_to_head_page(bq->q[i]);
> +
> +		page_pool_put_full_page(xa->page_pool, page, false);
> +	}
> +	bq->count = 0;
> +}
> +EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
> +

Wondering if we should have a comment that explains the intent and idea
behind this function?

/* Defers return when frame belongs to same mem.id as previous frame */

> +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> +			   struct xdp_frame_bulk *bq)
> +{
> +	struct xdp_mem_info *mem = &xdpf->mem;
> +	struct xdp_mem_allocator *xa, *nxa;
> +
> +	if (mem->type != MEM_TYPE_PAGE_POOL) {
> +		__xdp_return(xdpf->data, &xdpf->mem, false);
> +		return;
> +	}
> +
> +	rcu_read_lock();
> +
> +	xa = bq->xa;
> +	if (unlikely(!xa || mem->id != xa->mem.id)) {
> +		nxa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> +		if (unlikely(!xa)) {
> +			bq->count = 0;
> +			bq->xa = nxa;
> +			xa = nxa;
> +		}
> +	}
> +
> +	if (mem->id != xa->mem.id || bq->count == XDP_BULK_QUEUE_SIZE)
> +		xdp_flush_frame_bulk(bq);
> +
> +	bq->q[bq->count++] = xdpf->data;
> +	if (mem->id != xa->mem.id)
> +		bq->xa = nxa;
> +
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

