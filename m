Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5310F33ADC4
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 09:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhCOIlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 04:41:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229613AbhCOIkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 04:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615797652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YPPOlhAj1o8Bjr5m9KBGd7ssNyhGXUk+iULC8T743WI=;
        b=XDL+dbamYSqgfRoqriCz8kEdX4OUgQ/Qb6uYNZtltiLVLeO/NxfAUaOqazvIxp8MMAPTAG
        FLAwu6ILKVRCyhw9oJVm01rra/rVy2zBJqiAqZ8W8D2G0uBgmYGjnrhqxfs4MIEemT51OA
        5RmmF8MlDX1hnOt/FyRJrf7XpabUiaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-stEjHMdbP6auVPr4NLcJ5Q-1; Mon, 15 Mar 2021 04:40:48 -0400
X-MC-Unique: stEjHMdbP6auVPr4NLcJ5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12C55192D787;
        Mon, 15 Mar 2021 08:40:46 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64DC85C5E0;
        Mon, 15 Mar 2021 08:40:39 +0000 (UTC)
Date:   Mon, 15 Mar 2021 09:40:38 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
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
Message-ID: <20210315094038.22d6d79a@carbon>
In-Reply-To: <20210313133058.GZ3697@techsingularity.net>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
        <20210312154331.32229-8-mgorman@techsingularity.net>
        <CAKgT0UebK=mMwDV+UH8CqBRt0E0Koc7EB42kwgf0hYHDT_2OfQ@mail.gmail.com>
        <20210313133058.GZ3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Mar 2021 13:30:58 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> On Fri, Mar 12, 2021 at 11:44:09AM -0800, Alexander Duyck wrote:
> > > -       /* FUTURE development:
> > > -        *
> > > -        * Current slow-path essentially falls back to single page
> > > -        * allocations, which doesn't improve performance.  This code
> > > -        * need bulk allocation support from the page allocator code.
> > > -        */
> > > -
> > > -       /* Cache was empty, do real allocation */
> > > -#ifdef CONFIG_NUMA
> > > -       page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
> > > -#else
> > > -       page = alloc_pages(gfp, pool->p.order);
> > > -#endif
> > > -       if (!page)
> > > +       if (unlikely(!__alloc_pages_bulk(gfp, pp_nid, NULL, bulk, &page_list)))
> > >                 return NULL;
> > >
> > > +       /* First page is extracted and returned to caller */
> > > +       first_page = list_first_entry(&page_list, struct page, lru);
> > > +       list_del(&first_page->lru);
> > > +  
> > 
> > This seems kind of broken to me. If you pull the first page and then
> > cannot map it you end up returning NULL even if you placed a number of
> > pages in the cache.
> >   
> 
> I think you're right but I'm punting this to Jesper to fix. He's more
> familiar with this particular code and can verify the performance is
> still ok for high speed networks.

Yes, I'll take a look at this, and updated the patch accordingly (and re-run
the performance tests).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

