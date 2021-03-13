Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DC9339E4D
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 14:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhCMNba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 08:31:30 -0500
Received: from outbound-smtp48.blacknight.com ([46.22.136.219]:49127 "EHLO
        outbound-smtp48.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233779AbhCMNbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 08:31:01 -0500
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp48.blacknight.com (Postfix) with ESMTPS id 71BCE37A97B
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:31:00 +0000 (GMT)
Received: (qmail 31774 invoked from network); 13 Mar 2021 13:31:00 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 13 Mar 2021 13:31:00 -0000
Date:   Sat, 13 Mar 2021 13:30:58 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 7/7] net: page_pool: use alloc_pages_bulk in refill code
 path
Message-ID: <20210313133058.GZ3697@techsingularity.net>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
 <20210312154331.32229-8-mgorman@techsingularity.net>
 <CAKgT0UebK=mMwDV+UH8CqBRt0E0Koc7EB42kwgf0hYHDT_2OfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAKgT0UebK=mMwDV+UH8CqBRt0E0Koc7EB42kwgf0hYHDT_2OfQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 11:44:09AM -0800, Alexander Duyck wrote:
> > -       /* FUTURE development:
> > -        *
> > -        * Current slow-path essentially falls back to single page
> > -        * allocations, which doesn't improve performance.  This code
> > -        * need bulk allocation support from the page allocator code.
> > -        */
> > -
> > -       /* Cache was empty, do real allocation */
> > -#ifdef CONFIG_NUMA
> > -       page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
> > -#else
> > -       page = alloc_pages(gfp, pool->p.order);
> > -#endif
> > -       if (!page)
> > +       if (unlikely(!__alloc_pages_bulk(gfp, pp_nid, NULL, bulk, &page_list)))
> >                 return NULL;
> >
> > +       /* First page is extracted and returned to caller */
> > +       first_page = list_first_entry(&page_list, struct page, lru);
> > +       list_del(&first_page->lru);
> > +
> 
> This seems kind of broken to me. If you pull the first page and then
> cannot map it you end up returning NULL even if you placed a number of
> pages in the cache.
> 

I think you're right but I'm punting this to Jesper to fix. He's more
familiar with this particular code and can verify the performance is
still ok for high speed networks.

-- 
Mel Gorman
SUSE Labs
