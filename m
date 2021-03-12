Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B97F3392A4
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhCLQE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:04:27 -0500
Received: from outbound-smtp24.blacknight.com ([81.17.249.192]:43005 "EHLO
        outbound-smtp24.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231346AbhCLQDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:03:53 -0500
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp24.blacknight.com (Postfix) with ESMTPS id 1F0B5C0B10
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 16:03:52 +0000 (GMT)
Received: (qmail 13536 invoked from network); 12 Mar 2021 16:03:51 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 12 Mar 2021 16:03:51 -0000
Date:   Fri, 12 Mar 2021 16:03:50 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210312160350.GW3697@techsingularity.net>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310104618.22750-3-mgorman@techsingularity.net>
 <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
 <20210311084200.GR3697@techsingularity.net>
 <20210312124609.33d4d4ba@carbon>
 <20210312145814.GA2577561@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210312145814.GA2577561@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 02:58:14PM +0000, Matthew Wilcox wrote:
> On Fri, Mar 12, 2021 at 12:46:09PM +0100, Jesper Dangaard Brouer wrote:
> > In my page_pool patch I'm bulk allocating 64 pages. I wanted to ask if
> > this is too much? (PP_ALLOC_CACHE_REFILL=64).
> > 
> > The mlx5 driver have a while loop for allocation 64 pages, which it
> > used in this case, that is why 64 is chosen.  If we choose a lower
> > bulk number, then the bulk-alloc will just be called more times.
> 
> The thing about batching is that smaller batches are often better.
> Let's suppose you need to allocate 100 pages for something, and the page
> allocator takes up 90% of your latency budget.  Batching just ten pages
> at a time is going to reduce the overhead to 9%.  Going to 64 pages
> reduces the overhead from 9% to 2% -- maybe that's important, but
> possibly not.
> 

I do not think that something like that can be properly accessed in
advance. It heavily depends on whether the caller is willing to amortise
the cost of the batch allocation or if the timing of the bulk request is
critical every single time.

> > The result of the API is to deliver pages as a double-linked list via
> > LRU (page->lru member).  If you are planning to use llist, then how to
> > handle this API change later?
> > 
> > Have you notice that the two users store the struct-page pointers in an
> > array?  We could have the caller provide the array to store struct-page
> > pointers, like we do with kmem_cache_alloc_bulk API.
> 
> My preference would be for a pagevec.  That does limit you to 15 pages
> per call [1], but I do think that might be enough.  And the overhead of
> manipulating a linked list isn't free.
> 

I'm opposed to a pagevec because it unnecessarily limits the caller.  The
sunrpc user for example knows how many pages it needs at the time the bulk
allocator is called but it's not the same value every time.  When tracing,
I found it sometimes requested 1 page (most common request actually) and
other times requested 200+ pages. Forcing it to call the batch allocator
in chunks of 15 means the caller incurs the cost of multiple allocation
requests which is almost as bad as calling __alloc_pages in a loop.

I think the first version should have an easy API to start with. Optimise
the implementation if it is a bottleneck. Only make the API harder to
use if the callers are really willing to always allocate and size the
array in advance and it's shown that it really makes a big difference
performance-wise.

-- 
Mel Gorman
SUSE Labs
