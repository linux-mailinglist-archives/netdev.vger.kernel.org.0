Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30237302B9A
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 20:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731876AbhAYT1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 14:27:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731494AbhAYTYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 14:24:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611602558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sLaxbldCpmtlUDFodMqs6EtRoH2fJw9kHTicx3mvJQs=;
        b=TpLlE2chPMLDkOEmxB4XV1i3z3nyNI/pMrsrcDBNDGoP00NDzvDGCVX8KFoJU0AQpNUPpS
        es8i+TD21rKVerJAGwl3wBI1OByZMA8Ah7jL8MmG5iHbupn+BqiESfnAQyuO2mq62DMen1
        tMxBsXA2PQIxC1UE29qDNF/lRbnzI4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-wbF-Bqt3NsKIoD6ejRlndQ-1; Mon, 25 Jan 2021 14:22:34 -0500
X-MC-Unique: wbF-Bqt3NsKIoD6ejRlndQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E23E9100C601;
        Mon, 25 Jan 2021 19:22:30 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 251C960C0F;
        Mon, 25 Jan 2021 19:22:21 +0000 (UTC)
Date:   Mon, 25 Jan 2021 20:22:19 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     brouer@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Aleksandr Nogikh <nogikh@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH net-next 3/3] net: page_pool: simplify page recycling
 condition tests
Message-ID: <20210125202219.43d3d0f0@carbon>
In-Reply-To: <20210125164612.243838-4-alobakin@pm.me>
References: <20210125164612.243838-1-alobakin@pm.me>
        <20210125164612.243838-4-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 16:47:20 +0000
Alexander Lobakin <alobakin@pm.me> wrote:

> pool_page_reusable() is a leftover from pre-NUMA-aware times. For now,
> this function is just a redundant wrapper over page_is_pfmemalloc(),
> so Inline it into its sole call site.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/core/page_pool.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index f3c690b8c8e3..ad8b0707af04 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -350,14 +350,6 @@ static bool page_pool_recycle_in_cache(struct page *page,
>  	return true;
>  }
>  
> -/* page is NOT reusable when:
> - * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
> - */
> -static bool pool_page_reusable(struct page_pool *pool, struct page *page)
> -{
> -	return !page_is_pfmemalloc(page);
> -}
> -
>  /* If the page refcnt == 1, this will try to recycle the page.
>   * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
>   * the configured size min(dma_sync_size, pool->max_len).
> @@ -373,9 +365,11 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>  	 * regular page allocator APIs.
>  	 *
>  	 * refcnt == 1 means page_pool owns page, and can recycle it.
> +	 *
> +	 * page is NOT reusable when allocated when system is under
> +	 * some pressure. (page_is_pfmemalloc)
>  	 */
> -	if (likely(page_ref_count(page) == 1 &&
> -		   pool_page_reusable(pool, page))) {
> +	if (likely(page_ref_count(page) == 1 && !page_is_pfmemalloc(page))) {
>  		/* Read barrier done in page_ref_count / READ_ONCE */
>  
>  		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

