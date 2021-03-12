Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886E9338F10
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 14:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhCLNpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 08:45:18 -0500
Received: from outbound-smtp61.blacknight.com ([46.22.136.249]:52897 "EHLO
        outbound-smtp61.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231473AbhCLNo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 08:44:58 -0500
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp61.blacknight.com (Postfix) with ESMTPS id 2F019FAF9A
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 13:44:57 +0000 (GMT)
Received: (qmail 26842 invoked from network); 12 Mar 2021 13:44:57 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 12 Mar 2021 13:44:57 -0000
Date:   Fri, 12 Mar 2021 13:44:55 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210312134455.GU3697@techsingularity.net>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310104618.22750-3-mgorman@techsingularity.net>
 <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
 <20210311084200.GR3697@techsingularity.net>
 <20210312124609.33d4d4ba@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210312124609.33d4d4ba@carbon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 12:46:09PM +0100, Jesper Dangaard Brouer wrote:
> > > > <SNIP>
> > > > +	if (!zone)
> > > > +		return 0;
> > > > +
> > > > +	/* Attempt the batch allocation */
> > > > +	local_irq_save(flags);
> > > > +	pcp = &this_cpu_ptr(zone->pageset)->pcp;
> > > > +	pcp_list = &pcp->lists[ac.migratetype];
> > > > +
> > > > +	while (alloced < nr_pages) {
> > > > +		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
> > > > +								pcp, pcp_list);
> > > > +		if (!page)
> > > > +			break;
> > > > +
> > > > +		prep_new_page(page, 0, gfp_mask, 0);  
> > > 
> > > I wonder if it would be worth running prep_new_page() in a second pass,
> > > after reenabling interrupts.
> > >   
> > 
> > Possibly, I could add another patch on top that does this because it's
> > trading the time that IRQs are disabled for a list iteration.
> 
> I for one like this idea, of moving prep_new_page() to a second pass.
> As per below realtime concern, to reduce the time that IRQs are
> disabled.
> 

Already done.

> > > Speaking of which, will the realtime people get upset about the
> > > irqs-off latency?  How many pages are we talking about here?
> > >   
> 
> In my page_pool patch I'm bulk allocating 64 pages. I wanted to ask if
> this is too much? (PP_ALLOC_CACHE_REFILL=64).
> 

I expect no, it's not too much. The refill path should be short.

> > At the moment, it looks like batches of up to a few hundred at worst. I
> > don't think realtime sensitive applications are likely to be using the
> > bulk allocator API at this point.
> > 
> > The realtime people have a worse problem in that the per-cpu list does
> > not use local_lock and disable IRQs more than it needs to on x86 in
> > particular. I've a prototype series for this as well which splits the
> > locking for the per-cpu list and statistic handling and then converts the
> > per-cpu list to local_lock but I'm getting this off the table first because
> > I don't want multiple page allocator series in flight at the same time.
> > Thomas, Peter and Ingo would need to be cc'd on that series to review
> > the local_lock aspects.
> > 
> > Even with local_lock, it's not clear to me why per-cpu lists need to be
> > locked at all because potentially it could use a lock-free llist with some
> > struct page overloading. That one is harder to predict when batches are
> > taken into account as splicing a batch of free pages with llist would be
> > unsafe so batch free might exchange IRQ disabling overhead with multiple
> > atomics. I'd need to recheck things like whether NMI handlers ever call
> > the page allocator (they shouldn't but it should be checked).  It would
> > need a lot of review and testing.
> 
> The result of the API is to deliver pages as a double-linked list via
> LRU (page->lru member).  If you are planning to use llist, then how to
> handle this API change later?
> 

I would not have to. The per-cpu list internally can use llist internally
while pages returned to the bulk allocator user can still be a doubly
linked list. An llist_node fits in less space than the list_head lru.

> Have you notice that the two users store the struct-page pointers in an
> array?  We could have the caller provide the array to store struct-page
> pointers, like we do with kmem_cache_alloc_bulk API.
> 

That is a possibility but it ties the caller into declaring an array,
either via kmalloc, within an existing struct or on-stack. They would
then need to ensure that nr_pages does not exceed the array size or pass
in the array size. It's more error prone and a harder API to use.

> You likely have good reasons for returning the pages as a list (via
> lru), as I can see/imagine that there are some potential for grabbing
> the entire PCP-list.
> 

I used a list so that user was only required to define a list_head on
the stack to use the API.

-- 
Mel Gorman
SUSE Labs
