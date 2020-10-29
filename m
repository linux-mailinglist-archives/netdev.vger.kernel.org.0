Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C3E29EDA5
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgJ2NxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:53:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727767AbgJ2NxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 09:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603979578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6hNtivs0oPQRX04a5QZeTFePeJEJwTYJNsyfs7joYE8=;
        b=DwNbHL6QuzQ+V+CmMAQYAHpR/5Y8a7lKOOoz1RPiuEWFok/cYR4XlcKSzPwbVPq8kKeSBZ
        UnJYeqH5UYsscou4okRpz+y0nnMbIGT4ZM9hJFi5l76tYOqXSr6sVngBI2EpOlNckvj6Rd
        Rq6cgojFhXJOM5w0bLHetujZQlobpQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-uR7qEFPRM0ecf7KGezg9qA-1; Thu, 29 Oct 2020 09:52:56 -0400
X-MC-Unique: uR7qEFPRM0ecf7KGezg9qA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D2B110A0BAD;
        Thu, 29 Oct 2020 13:52:48 +0000 (UTC)
Received: from carbon (unknown [10.36.110.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA6751002C04;
        Thu, 29 Oct 2020 13:52:40 +0000 (UTC)
Date:   Thu, 29 Oct 2020 14:52:39 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH net-next 1/4] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201029145239.6f6d1713@carbon>
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

We (Ilias my co-maintainer and I) think above code is hard to read and
understand (as a reader you need to keep too many cases in your head).

I think we both have proposals to improve this, here is mine:

/* Defers return when frame belongs to same mem.id as previous frame */
void xdp_return_frame_bulk(struct xdp_frame *xdpf,
                           struct xdp_frame_bulk *bq)
{
        struct xdp_mem_info *mem = &xdpf->mem;
        struct xdp_mem_allocator *xa;

        if (mem->type != MEM_TYPE_PAGE_POOL) {
                __xdp_return(xdpf->data, &xdpf->mem, false);
                return;
        }

        rcu_read_lock();

        xa = bq->xa;
        if (unlikely(!xa)) {
		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
                bq->count = 0;
                bq->xa = xa;
        }

        if (bq->count == XDP_BULK_QUEUE_SIZE)
                xdp_flush_frame_bulk(bq);

        if (mem->id != xa->mem.id) {
		xdp_flush_frame_bulk(bq);
		bq->xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
        }

	bq->q[bq->count++] = xdpf->data;

        rcu_read_unlock();
}

Please review for correctness, and also for readability.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

