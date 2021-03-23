Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCB6345A41
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 10:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhCWJCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 05:02:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229986AbhCWJBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 05:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616490111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lnKo84NJRibXYx1pHZppaLUJVye8I3wagPHafQ3chwg=;
        b=P0YK4y1mYD+JZQ74D578GIkAQRpp+lvBoaApWq1J17Cur/vH9BT8a7YxLI/P3tZ8B2FDbX
        To1Luh5DUcVFaWUqvpE6MoQk2C7k3y2JXzbmuybojuV4yg1XfZdA90iWphDLoqWwa0JUMW
        UFIRPJiPtZ0J1TYccWUyn2nNwluz5v0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-F5AhZnT2N8ib0revLWM4yw-1; Tue, 23 Mar 2021 05:01:47 -0400
X-MC-Unique: F5AhZnT2N8ib0revLWM4yw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B46AD180FCAA;
        Tue, 23 Mar 2021 09:01:44 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C191860C5D;
        Tue, 23 Mar 2021 09:01:38 +0000 (UTC)
Date:   Tue, 23 Mar 2021 10:01:38 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     brouer@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] page_pool: let the compiler optimize and
 inline core functions
Message-ID: <20210323100138.791a77ce@carbon>
In-Reply-To: <20210322183047.10768-1-alobakin@pm.me>
References: <20210322183047.10768-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021 18:30:55 +0000
Alexander Lobakin <alobakin@pm.me> wrote:

> As per disscussion in Page Pool bulk allocator thread [0],
> there are two functions in Page Pool core code that are marked as
> 'noinline'. The reason for this is not so clear, and even if it
> was made to reduce hotpath overhead, in fact it only makes things
> worse.
> As both of these functions as being called only once through the
> code, they could be inlined/folded into the non-static entry point.
> However, 'noinline' marks effectively prevent from doing that and
> induce totally unneeded fragmentation (baseline -> after removal):
> 
> add/remove: 0/3 grow/shrink: 1/0 up/down: 1024/-1096 (-72)
> Function                                     old     new   delta
> page_pool_alloc_pages                        100    1124   +1024
> page_pool_dma_map                            164       -    -164
> page_pool_refill_alloc_cache                 332       -    -332
> __page_pool_alloc_pages_slow                 600       -    -600
> 
> (taken from Mel's branch, hence factored-out page_pool_dma_map())

I see that the refactor of page_pool_dma_map() caused it to be
uninlined, that were a mistake.  Thanks for high-lighting that again
as I forgot about this (even-though I think Alex Duyck did point this
out earlier).

I am considering if we should allow compiler to inline
page_pool_refill_alloc_cache + __page_pool_alloc_pages_slow, for the
sake of performance and I loose the ability to diagnose the behavior
from perf-report.  Mind that page_pool avoids stat for the sake of
performance, but these noinline makes it possible to diagnose the
behavior anyway.

> 
> 1124 is a normal hotpath frame size, but these jumps between tiny
> page_pool_alloc_pages(), page_pool_refill_alloc_cache() and
> __page_pool_alloc_pages_slow() are really redundant and harmful
> for performance.

Well, I disagree. (this is a NACK)

If pages were recycled then the code never had to visit
__page_pool_alloc_pages_slow().  And today without the bulk page-alloc
(that we are working on adding together with Mel) we have to visit
__page_pool_alloc_pages_slow() every time, which is a bad design, but
I'm trying to fix that.

Matteo is working on recycling here[1]:
 [1] https://lore.kernel.org/netdev/20210322170301.26017-1-mcroce@linux.microsoft.com/

It would be really great if you could try out his patchset, as it will
help your driver avoid the slow path of the page_pool.  Given you are
very detailed oriented, I do want to point out that Matteo's patchset
is only the first step, as to really improve performance for page_pool,
we need to bulk return these page_pool pages (it is requires some
restructure of the core code, that will be confusing at this point).


> This simple removal of 'noinline' keywords bumps the throughput
> on XDP_PASS + napi_build_skb() + napi_gro_receive() on 25+ Mbps
> for 1G embedded NIC.
> 
> [0] https://lore.kernel.org/netdev/20210317222506.1266004-1-alobakin@pm.me
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/core/page_pool.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ad8b0707af04..589e4df6ef2b 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -102,7 +102,6 @@ EXPORT_SYMBOL(page_pool_create);
> 
>  static void page_pool_return_page(struct page_pool *pool, struct page *page);
> 
> -noinline
>  static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
>  {
>  	struct ptr_ring *r = &pool->ring;
> @@ -181,7 +180,6 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
>  }
> 
>  /* slow path */
> -noinline
>  static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  						 gfp_t _gfp)
>  {
> --
> 2.31.0
> 
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

