Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6E932641F
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 15:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhBZOdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 09:33:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229586AbhBZOd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 09:33:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614349920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9RX//Bdd8HPk0Ssm+CTrvmQb+OiGD1xCr+0Drqw+QDY=;
        b=e9Du2nmlDqmmMfNaIhVHXlY6VbHuAl/+fG58odwjwK/dpWAKjXEbQNhCGMSxtgnDp23C5u
        kzyvNSHGvSqT8GRBqrBlfUxA5twu0vjSuwjRSPnc53WSK8YeU6vsud9WC7dJZVVmwv9Pa/
        xaSLfXSHwrkg/eS5DfN4HA1RciNgSw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-bzAVz64zNeSf0a_rv2AhZA-1; Fri, 26 Feb 2021 09:31:56 -0500
X-MC-Unique: bzAVz64zNeSf0a_rv2AhZA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 728691936B61;
        Fri, 26 Feb 2021 14:31:55 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 565195D9DE;
        Fri, 26 Feb 2021 14:31:50 +0000 (UTC)
Date:   Fri, 26 Feb 2021 15:31:49 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org,
        chuck.lever@oracle.com, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH RFC net-next 2/3] net: page_pool: use alloc_pages_bulk
 in refill code path
Message-ID: <20210226153149.08b3d822@carbon>
In-Reply-To: <YDaz2tXXxEkcBfRR@apalos.home>
References: <161419296941.2718959.12575257358107256094.stgit@firesoul>
        <161419300618.2718959.11165518489200268845.stgit@firesoul>
        <YDaz2tXXxEkcBfRR@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 22:15:22 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> Hi Jesper, 
> 
> On Wed, Feb 24, 2021 at 07:56:46PM +0100, Jesper Dangaard Brouer wrote:
> > There are cases where the page_pool need to refill with pages from the
> > page allocator. Some workloads cause the page_pool to release pages
> > instead of recycling these pages.
> > 
> > For these workload it can improve performance to bulk alloc pages from
> > the page-allocator to refill the alloc cache.
> > 
> > For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
> > redirecting xdp_frame packets into a veth, that does XDP_PASS to create
> > an SKB from the xdp_frame, which then cannot return the page to the
> > page_pool. In this case, we saw[1] an improvement of 18.8% from using
> > the alloc_pages_bulk API (3,677,958 pps -> 4,368,926 pps).
> > 
> > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>  
> 
> [...]
> 
> > +	/* Remaining pages store in alloc.cache */
> > +	list_for_each_entry_safe(page, next, &page_list, lru) {
> > +		list_del(&page->lru);
> > +		if (pp_flags & PP_FLAG_DMA_MAP) {
> > +			page = page_pool_dma_map(pool, page);
> > +			if (!page)  
> 
> As I commented on the previous patch, i'd prefer the put_page() here to be
> explicitly called, instead of hiding in the page_pool_dma_map()

I fully agree.  I will fixup the code.

> > +				continue;
> > +		}
> > +		if (likely(pool->alloc.count < PP_ALLOC_CACHE_SIZE)) {
> > +			pool->alloc.cache[pool->alloc.count++] = page;
> > +			pool->pages_state_hold_cnt++;
> > +			trace_page_pool_state_hold(pool, page,
> > +						   pool->pages_state_hold_cnt);
> > +		} else {
> > +			put_page(page);
> > +		}
> > +	}
> > +out:
> >  	if (pool->p.flags & PP_FLAG_DMA_MAP) {
> > -		page = page_pool_dma_map(pool, page);
> > -		if (!page)
> > +		first_page = page_pool_dma_map(pool, first_page);
> > +		if (!first_page)
> >  			return NULL;
> >  	}
> >    
> [...]

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

