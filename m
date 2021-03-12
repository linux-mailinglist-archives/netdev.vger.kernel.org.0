Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0171E33869C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 08:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhCLHc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 02:32:57 -0500
Received: from outbound-smtp57.blacknight.com ([46.22.136.241]:50915 "EHLO
        outbound-smtp57.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231768AbhCLHc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 02:32:29 -0500
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp57.blacknight.com (Postfix) with ESMTPS id DA19CFA9C1
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 07:32:27 +0000 (GMT)
Received: (qmail 20885 invoked from network); 12 Mar 2021 07:32:27 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 12 Mar 2021 07:32:27 -0000
Date:   Fri, 12 Mar 2021 07:32:26 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210312073226.GT3697@techsingularity.net>
References: <20210311114935.11379-1-mgorman@techsingularity.net>
 <20210311114935.11379-3-mgorman@techsingularity.net>
 <CAKgT0UcgiS0DpU4weOeVUN7o9dzoP=R20ytWC434sY4FxgQbtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAKgT0UcgiS0DpU4weOeVUN7o9dzoP=R20ytWC434sY4FxgQbtg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 08:42:16AM -0800, Alexander Duyck wrote:
> > @@ -4919,6 +4934,9 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
> >                 struct alloc_context *ac, gfp_t *alloc_mask,
> >                 unsigned int *alloc_flags)
> >  {
> > +       gfp_mask &= gfp_allowed_mask;
> > +       *alloc_mask = gfp_mask;
> > +
> >         ac->highest_zoneidx = gfp_zone(gfp_mask);
> >         ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
> >         ac->nodemask = nodemask;
> 
> It might be better to pull this and the change from the bottom out
> into a seperate patch. I was reviewing this and when I hit the bottom
> I apparently had the same question other reviewers had wondering if it
> was intentional. By splitting it out it would be easier to review.
> 

Done. I felt it was obvious from context that the paths were sharing code
and splitting it out felt like patch count stuffing. Still, you're the
second person to point it out so now it's a separate patch in v4.

> > @@ -4960,6 +4978,104 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
> >         return true;
> >  }
> >
> > +/*
> > + * This is a batched version of the page allocator that attempts to
> > + * allocate nr_pages quickly from the preferred zone and add them to list.
> > + *
> > + * Returns the number of pages allocated.
> > + */
> > +int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int preferred_nid,
> > +                       nodemask_t *nodemask, int nr_pages,
> > +                       struct list_head *alloc_list)
> > +{
> > +       struct page *page;
> > +       unsigned long flags;
> > +       struct zone *zone;
> > +       struct zoneref *z;
> > +       struct per_cpu_pages *pcp;
> > +       struct list_head *pcp_list;
> > +       struct alloc_context ac;
> > +       gfp_t alloc_mask;
> > +       unsigned int alloc_flags;
> > +       int alloced = 0;
> > +
> > +       if (nr_pages == 1)
> > +               goto failed;
> 
> I might change this to "<= 1" just to cover the case where somebody
> messed something up and passed a negative value.
> 

I put in a WARN_ON_ONCE check that returns 0 allocated pages. It should
be the case that it only happens during the development of a new user but
better safe than sorry. It's an open question whether the max nr_pages
should be clamped but stupidly large values will either fail the watermark
check or wrap and hit the <= 0 check. I guess it's still possible the zone
would hit a dangerously low level of free pages but that is no different
to a user calling __alloc_pages_nodemask a stupidly large number of times.

> > +
> > +       /* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
> > +       if (!prepare_alloc_pages(gfp_mask, 0, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
> > +               return 0;
> > +       gfp_mask = alloc_mask;
> > +
> > +       /* Find an allowed local zone that meets the high watermark. */
> > +       for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
> > +               unsigned long mark;
> > +
> > +               if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
> > +                   !__cpuset_zone_allowed(zone, gfp_mask)) {
> > +                       continue;
> > +               }
> > +
> > +               if (nr_online_nodes > 1 && zone != ac.preferred_zoneref->zone &&
> > +                   zone_to_nid(zone) != zone_to_nid(ac.preferred_zoneref->zone)) {
> > +                       goto failed;
> > +               }
> > +
> > +               mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
> > +               if (zone_watermark_fast(zone, 0,  mark,
> > +                               zonelist_zone_idx(ac.preferred_zoneref),
> > +                               alloc_flags, gfp_mask)) {
> > +                       break;
> > +               }
> > +       }
> > +       if (!zone)
> > +               return 0;
> > +
> > +       /* Attempt the batch allocation */
> > +       local_irq_save(flags);
> > +       pcp = &this_cpu_ptr(zone->pageset)->pcp;
> > +       pcp_list = &pcp->lists[ac.migratetype];
> > +
> > +       while (alloced < nr_pages) {
> > +               page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
> > +                                                               pcp, pcp_list);
> > +               if (!page)
> > +                       break;
> > +
> > +               list_add(&page->lru, alloc_list);
> > +               alloced++;
> > +       }
> > +
> > +       if (!alloced)
> > +               goto failed_irq;
> 
> Since we already covered the case above verifying the nr_pages is
> greater than one it might make sense to move this check inside the
> loop for the !page case. Then we only are checking this if we failed
> an allocation.
> 

Yes, good idea, it moves a branch into a very unlikely path.

> > +
> > +       if (alloced) {
> 
> Isn't this redundant? In the previous lines you already checked
> "alloced" was zero before jumping to the label so you shouldn't need a
> second check as it isn't going to change after we already verified it
> is non-zero.
> 

Yes, it is redundant and a left-over artifact during implementation.
It's even more redundant when the !allocated case is checked in the
while loop.

> Also not a fan of the name "alloced". Maybe nr_alloc or something.
> Trying to make that abbreviation past tense just doesn't read right.
> 

I used allocated and created a preparation patch that renames alloced in
other parts of the per-cpu allocator so it is consistent.

> > +               __count_zid_vm_events(PGALLOC, zone_idx(zone), alloced);
> > +               zone_statistics(zone, zone);
> > +       }
> > +
> > +       local_irq_restore(flags);
> > +
> > +       /* Prep page with IRQs enabled to reduce disabled times */
> > +       list_for_each_entry(page, alloc_list, lru)
> > +               prep_new_page(page, 0, gfp_mask, 0);
> > +
> > +       return alloced;
> > +
> > +failed_irq:
> > +       local_irq_restore(flags);
> > +
> > +failed:
> > +       page = __alloc_pages_nodemask(gfp_mask, 0, preferred_nid, nodemask);
> > +       if (page) {
> > +               alloced++;
> 
> You could be explicit here and just set alloced to 1 and make this a
> write instead of bothering with the increment. Either that or just
> simplify this and return 1 after the list_add, and return 0 in the
> default case assuming you didn't allocate a page.
> 

The intent was to deal with the case that someone in the future used
the failed path when a page had already been allocated. I cannot imagine
why that would be done so I can explicitly used allocated = 1. I'm still
letting it fall through to avoid two return paths in failed path.  I do
not think it really matters but it feels redundant.

Thanks Alexander!

-- 
Mel Gorman
SUSE Labs
