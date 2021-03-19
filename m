Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51F034217D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 17:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhCSQMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 12:12:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:34622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhCSQLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 12:11:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DF226AC75;
        Fri, 19 Mar 2021 16:11:39 +0000 (UTC)
Subject: Re: [PATCH 1/7] mm/page_alloc: Move gfp_allowed_mask enforcement to
 prepare_alloc_pages
To:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
 <20210312154331.32229-2-mgorman@techsingularity.net>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <2b5b3bea-c247-0564-f2d4-1dad28f176ed@suse.cz>
Date:   Fri, 19 Mar 2021 17:11:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210312154331.32229-2-mgorman@techsingularity.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 4:43 PM, Mel Gorman wrote:
> __alloc_pages updates GFP flags to enforce what flags are allowed
> during a global context such as booting or suspend. This patch moves the
> enforcement from __alloc_pages to prepare_alloc_pages so the code can be
> shared between the single page allocator and a new bulk page allocator.
> 
> When moving, it is obvious that __alloc_pages() and __alloc_pages
> use different names for the same variable. This is an unnecessary
> complication so rename gfp_mask to gfp in prepare_alloc_pages() so the
> name is consistent.
> 
> No functional change.

Hm, I have some doubts.

> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> ---
>  mm/page_alloc.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 00b67c47ad87..f0c1d74ead6f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4914,15 +4914,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	return page;
>  }
>  
> -static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
> +static inline bool prepare_alloc_pages(gfp_t gfp, unsigned int order,
>  		int preferred_nid, nodemask_t *nodemask,
>  		struct alloc_context *ac, gfp_t *alloc_gfp,
>  		unsigned int *alloc_flags)
>  {
> -	ac->highest_zoneidx = gfp_zone(gfp_mask);
> -	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
> +	gfp &= gfp_allowed_mask;
> +	*alloc_gfp = gfp;
> +

...

> @@ -4980,8 +4983,6 @@ struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
>  		return NULL;
>  	}
>  
> -	gfp &= gfp_allowed_mask;
> -	alloc_gfp = gfp;
>  	if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac,
>  			&alloc_gfp, &alloc_flags))
>  		return NULL;

As a result, "gfp" doesn't have the restrictions by gfp_allowed_mask applied,
only alloc_gfp does. But in case we go to slowpath, before
going there we throw away the current alloc_gfp:

    alloc_gfp = current_gfp_context(gfp);
    ...
    page = __alloc_pages_slowpath(alloc_gfp, ...);

So we lost the gfp_allowed_mask restrictions here?

