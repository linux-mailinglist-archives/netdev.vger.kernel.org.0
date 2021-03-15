Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7A333B4C4
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhCONkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:40:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229613AbhCONjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 09:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615815579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FBloEIKc9d+TaaEDfCG9lNf3Br/ubHPcgUeOPhTr6GA=;
        b=WYh5YYJHw7TIENPxuvjrSsqRYyZxe5XmXCFjYV2eBOoFjC9VSGg74QfkFBB+y5ftXhU0Wg
        YA14bRSH8BOv6C6u7PusRpbaLwzpQLSIhjamd3+j/30G8ZU+yxRfuzTU3XT2IltE229Dih
        /68WUlHCqZjFECSz7tBEax7d3wzx04I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-jeXUEtpqMLCSpUTFmj-UZg-1; Mon, 15 Mar 2021 09:39:37 -0400
X-MC-Unique: jeXUEtpqMLCSpUTFmj-UZg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7338E809AC7;
        Mon, 15 Mar 2021 13:39:35 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7292118AAF;
        Mon, 15 Mar 2021 13:39:29 +0000 (UTC)
Date:   Mon, 15 Mar 2021 14:39:28 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH 7/7] net: page_pool: use alloc_pages_bulk in refill code
 path
Message-ID: <20210315143928.5d94da8f@carbon>
In-Reply-To: <YEvJmVrnTzKT1XAY@apalos.home>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
        <20210312154331.32229-8-mgorman@techsingularity.net>
        <CAKgT0UebK=mMwDV+UH8CqBRt0E0Koc7EB42kwgf0hYHDT_2OfQ@mail.gmail.com>
        <YEvJmVrnTzKT1XAY@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Mar 2021 22:05:45 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> [...]
> > 6. return last_page
> >   
> > > +       /* Remaining pages store in alloc.cache */
> > > +       list_for_each_entry_safe(page, next, &page_list, lru) {
> > > +               list_del(&page->lru);
> > > +               if ((pp_flags & PP_FLAG_DMA_MAP) &&
> > > +                   unlikely(!page_pool_dma_map(pool, page))) {
> > > +                       put_page(page);
> > > +                       continue;
> > > +               }  
> > 
> > So if you added a last_page pointer what you could do is check for it
> > here and assign it to the alloc cache. If last_page is not set the
> > block would be skipped.
> >   
> > > +               if (likely(pool->alloc.count < PP_ALLOC_CACHE_SIZE)) {
> > > +                       pool->alloc.cache[pool->alloc.count++] = page;
> > > +                       pool->pages_state_hold_cnt++;
> > > +                       trace_page_pool_state_hold(pool, page,
> > > +                                                  pool->pages_state_hold_cnt);
> > > +               } else {
> > > +                       put_page(page);  
> > 
> > If you are just calling put_page here aren't you leaking DMA mappings?
> > Wouldn't you need to potentially unmap the page before you call
> > put_page on it?  
> 
> Oops, I completely missed that. Alexander is right here.

Well, the put_page() case can never happen as the pool->alloc.cache[]
is known to be empty when this function is called.  I do agree that the
code looks cumbersome and should free the DMA mapping, if it could
happen.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

