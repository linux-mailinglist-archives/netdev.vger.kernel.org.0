Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A7C3379BD
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhCKQmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbhCKQm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:42:28 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2C9C061574;
        Thu, 11 Mar 2021 08:42:28 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id y20so4274505iot.4;
        Thu, 11 Mar 2021 08:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=85YCALcXdYdlt5hBAqGVrxlQ+tcI4W++hP/xGI3GPIg=;
        b=SpSDrjjgCXXsmnhjzJldSUJKGFqiQr0RGU0laB1cgVYxXT2FezwKH/nHOuBwYECIs1
         gzhw0HRKXoXZkalzPYjorZcx8wE/SJL7RIoLkM/p9CVXijfC1GcprA4gHqXu7zHnGlRh
         DKYiB5c1sTCKTlyWygqjhTY/SHoN+2EBM1sNZwEEQo+gSE09ad3mod5v5gHDNHyoZtkT
         yqnbs2TTSocz0ba5YP8+CTqMtaX2rT6Ap4Molv/UsGd6pa3UjJRGqycuwEp6K8il1MW9
         jq4Ze9IYuWiLEZ5+17h0cIdC/3PnnUqBbb6AAxT5b22K7k15RAki5Vkl7f+g2vPadAV/
         jYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85YCALcXdYdlt5hBAqGVrxlQ+tcI4W++hP/xGI3GPIg=;
        b=Wf+hoZ/a2uCEcbyMrpRcP9bn4dYW/e24tUD7SeT/Sop1f6xFHU9wHdEJkQf2QU9WQr
         70kqsyfjsmeRSBJsekQo/Lbe1ZSd9jvX/iUaDyu8UDHKlrwBPGdc+5lDusG7eJeifdwr
         FSP33qkcKiSZhLJpsdabDRmzbQE5Vptim4sCTwxcGKB5uM9LSvwwo4kOhHwQ5YqXU2Ma
         ZJVLcag5mX23oOlOKH5D/9YGG6lMHwoWZmWE44g+xKql8VtBnxYhrR35W0VMq7Rb0cpx
         MOspNc92iLLf1RnHq+T2vauWSRkNy7+nD7WIyJWCUos1hprBNE9/uAF87Lr+fdSS9w38
         Hrbg==
X-Gm-Message-State: AOAM5313TvxrzpnQNzyETCNJMqZQjmmKjpcXVUKxK+xPep9R7gyzDBS1
        d+sg5ch+ivopVofnr0T3gPugOvo0EdTlzp/Ip5M=
X-Google-Smtp-Source: ABdhPJzdwLWqA0vHm16sIX64k5YxxEfmprvL4krrXgLvdXiezVI8RFEpZV2UfL1vYB6W0T/6g2JAT5ZD696fPq803H4=
X-Received: by 2002:a5d:938e:: with SMTP id c14mr7022561iol.88.1615480947405;
 Thu, 11 Mar 2021 08:42:27 -0800 (PST)
MIME-Version: 1.0
References: <20210311114935.11379-1-mgorman@techsingularity.net> <20210311114935.11379-3-mgorman@techsingularity.net>
In-Reply-To: <20210311114935.11379-3-mgorman@techsingularity.net>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 11 Mar 2021 08:42:16 -0800
Message-ID: <CAKgT0UcgiS0DpU4weOeVUN7o9dzoP=R20ytWC434sY4FxgQbtg@mail.gmail.com>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 3:49 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> This patch adds a new page allocator interface via alloc_pages_bulk,
> and __alloc_pages_bulk_nodemask. A caller requests a number of pages
> to be allocated and added to a list. They can be freed in bulk using
> free_pages_bulk().
>
> The API is not guaranteed to return the requested number of pages and
> may fail if the preferred allocation zone has limited free memory, the
> cpuset changes during the allocation or page debugging decides to fail
> an allocation. It's up to the caller to request more pages in batch
> if necessary.
>
> Note that this implementation is not very efficient and could be improved
> but it would require refactoring. The intent is to make it available early
> to determine what semantics are required by different callers. Once the
> full semantics are nailed down, it can be refactored.
>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> ---
>  include/linux/gfp.h |  13 +++++
>  mm/page_alloc.c     | 118 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 129 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 8572a1474e16..4903d1cc48dc 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -515,6 +515,10 @@ static inline int arch_make_page_accessible(struct page *page)
>  }
>  #endif
>
> +int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int preferred_nid,
> +                               nodemask_t *nodemask, int nr_pages,
> +                               struct list_head *list);
> +
>  struct page *
>  __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
>                                                         nodemask_t *nodemask);
> @@ -525,6 +529,14 @@ __alloc_pages(gfp_t gfp_mask, unsigned int order, int preferred_nid)
>         return __alloc_pages_nodemask(gfp_mask, order, preferred_nid, NULL);
>  }
>
> +/* Bulk allocate order-0 pages */
> +static inline unsigned long
> +alloc_pages_bulk(gfp_t gfp_mask, unsigned long nr_pages, struct list_head *list)
> +{
> +       return __alloc_pages_bulk_nodemask(gfp_mask, numa_mem_id(), NULL,
> +                                                       nr_pages, list);
> +}
> +
>  /*
>   * Allocate pages, preferring the node given as nid. The node must be valid and
>   * online. For more general interface, see alloc_pages_node().
> @@ -594,6 +606,7 @@ void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
>
>  extern void __free_pages(struct page *page, unsigned int order);
>  extern void free_pages(unsigned long addr, unsigned int order);
> +extern void free_pages_bulk(struct list_head *list);
>
>  struct page_frag_cache;
>  extern void __page_frag_cache_drain(struct page *page, unsigned int count);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3e4b29ee2b1e..415059324dc3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4436,6 +4436,21 @@ static void wake_all_kswapds(unsigned int order, gfp_t gfp_mask,
>         }
>  }
>
> +/* Drop reference counts and free order-0 pages from a list. */
> +void free_pages_bulk(struct list_head *list)
> +{
> +       struct page *page, *next;
> +
> +       list_for_each_entry_safe(page, next, list, lru) {
> +               trace_mm_page_free_batched(page);
> +               if (put_page_testzero(page)) {
> +                       list_del(&page->lru);
> +                       __free_pages_ok(page, 0, FPI_NONE);
> +               }
> +       }
> +}
> +EXPORT_SYMBOL_GPL(free_pages_bulk);
> +
>  static inline unsigned int
>  gfp_to_alloc_flags(gfp_t gfp_mask)
>  {
> @@ -4919,6 +4934,9 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>                 struct alloc_context *ac, gfp_t *alloc_mask,
>                 unsigned int *alloc_flags)
>  {
> +       gfp_mask &= gfp_allowed_mask;
> +       *alloc_mask = gfp_mask;
> +
>         ac->highest_zoneidx = gfp_zone(gfp_mask);
>         ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
>         ac->nodemask = nodemask;

It might be better to pull this and the change from the bottom out
into a seperate patch. I was reviewing this and when I hit the bottom
I apparently had the same question other reviewers had wondering if it
was intentional. By splitting it out it would be easier to review.

> @@ -4960,6 +4978,104 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>         return true;
>  }
>
> +/*
> + * This is a batched version of the page allocator that attempts to
> + * allocate nr_pages quickly from the preferred zone and add them to list.
> + *
> + * Returns the number of pages allocated.
> + */
> +int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int preferred_nid,
> +                       nodemask_t *nodemask, int nr_pages,
> +                       struct list_head *alloc_list)
> +{
> +       struct page *page;
> +       unsigned long flags;
> +       struct zone *zone;
> +       struct zoneref *z;
> +       struct per_cpu_pages *pcp;
> +       struct list_head *pcp_list;
> +       struct alloc_context ac;
> +       gfp_t alloc_mask;
> +       unsigned int alloc_flags;
> +       int alloced = 0;
> +
> +       if (nr_pages == 1)
> +               goto failed;

I might change this to "<= 1" just to cover the case where somebody
messed something up and passed a negative value.

> +
> +       /* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
> +       if (!prepare_alloc_pages(gfp_mask, 0, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
> +               return 0;
> +       gfp_mask = alloc_mask;
> +
> +       /* Find an allowed local zone that meets the high watermark. */
> +       for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
> +               unsigned long mark;
> +
> +               if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
> +                   !__cpuset_zone_allowed(zone, gfp_mask)) {
> +                       continue;
> +               }
> +
> +               if (nr_online_nodes > 1 && zone != ac.preferred_zoneref->zone &&
> +                   zone_to_nid(zone) != zone_to_nid(ac.preferred_zoneref->zone)) {
> +                       goto failed;
> +               }
> +
> +               mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
> +               if (zone_watermark_fast(zone, 0,  mark,
> +                               zonelist_zone_idx(ac.preferred_zoneref),
> +                               alloc_flags, gfp_mask)) {
> +                       break;
> +               }
> +       }
> +       if (!zone)
> +               return 0;
> +
> +       /* Attempt the batch allocation */
> +       local_irq_save(flags);
> +       pcp = &this_cpu_ptr(zone->pageset)->pcp;
> +       pcp_list = &pcp->lists[ac.migratetype];
> +
> +       while (alloced < nr_pages) {
> +               page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
> +                                                               pcp, pcp_list);
> +               if (!page)
> +                       break;
> +
> +               list_add(&page->lru, alloc_list);
> +               alloced++;
> +       }
> +
> +       if (!alloced)
> +               goto failed_irq;

Since we already covered the case above verifying the nr_pages is
greater than one it might make sense to move this check inside the
loop for the !page case. Then we only are checking this if we failed
an allocation.

> +
> +       if (alloced) {

Isn't this redundant? In the previous lines you already checked
"alloced" was zero before jumping to the label so you shouldn't need a
second check as it isn't going to change after we already verified it
is non-zero.

Also not a fan of the name "alloced". Maybe nr_alloc or something.
Trying to make that abbreviation past tense just doesn't read right.

> +               __count_zid_vm_events(PGALLOC, zone_idx(zone), alloced);
> +               zone_statistics(zone, zone);
> +       }
> +
> +       local_irq_restore(flags);
> +
> +       /* Prep page with IRQs enabled to reduce disabled times */
> +       list_for_each_entry(page, alloc_list, lru)
> +               prep_new_page(page, 0, gfp_mask, 0);
> +
> +       return alloced;
> +
> +failed_irq:
> +       local_irq_restore(flags);
> +
> +failed:
> +       page = __alloc_pages_nodemask(gfp_mask, 0, preferred_nid, nodemask);
> +       if (page) {
> +               alloced++;

You could be explicit here and just set alloced to 1 and make this a
write instead of bothering with the increment. Either that or just
simplify this and return 1 after the list_add, and return 0 in the
default case assuming you didn't allocate a page.

> +               list_add(&page->lru, alloc_list);
> +       }
> +
> +       return alloced;
> +}
> +EXPORT_SYMBOL_GPL(__alloc_pages_bulk_nodemask);
> +
>  /*
>   * This is the 'heart' of the zoned buddy allocator.
>   */
> @@ -4981,8 +5097,6 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
>                 return NULL;
>         }
>
> -       gfp_mask &= gfp_allowed_mask;
> -       alloc_mask = gfp_mask;
>         if (!prepare_alloc_pages(gfp_mask, order, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
>                 return NULL;
>
> --
> 2.26.2
>
>
