Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8065D338FA1
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhCLOQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:16:16 -0500
Received: from outbound-smtp16.blacknight.com ([46.22.139.233]:59981 "EHLO
        outbound-smtp16.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229913AbhCLOPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 09:15:51 -0500
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp16.blacknight.com (Postfix) with ESMTPS id CEA401C3CE7
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 14:15:45 +0000 (GMT)
Received: (qmail 20309 invoked from network); 12 Mar 2021 14:15:45 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 12 Mar 2021 14:15:45 -0000
Date:   Fri, 12 Mar 2021 14:15:44 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210312141544.GV3697@techsingularity.net>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310104618.22750-3-mgorman@techsingularity.net>
 <20210312124331.GY3479805@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210312124331.GY3479805@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 12:43:31PM +0000, Matthew Wilcox wrote:
> On Wed, Mar 10, 2021 at 10:46:15AM +0000, Mel Gorman wrote:
> > +int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int preferred_nid,
> > +				nodemask_t *nodemask, int nr_pages,
> > +				struct list_head *list);
> 
> For the next revision, can you ditch the '_nodemask' part of the name?
> Andrew just took this patch from me:
> 

Ok, the first three patches are needed from that series. For convenience,
I'm going to post the same series with the rest of the patches as a
pre-requisite to avoid people having to take patches out of mmotm to test.
For review purposes, they can be ignored.

> > <SNIP>
> >
> > @@ -4919,6 +4934,9 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
> >  		struct alloc_context *ac, gfp_t *alloc_mask,
> >  		unsigned int *alloc_flags)
> >  {
> > +	gfp_mask &= gfp_allowed_mask;
> > +	*alloc_mask = gfp_mask;
> 
> Also I renamed alloc_mask to alloc_gfp.
> 

It then becomes obvious that prepare_alloc_pages does not share the same
naming convention as __alloc_pages(). In an effort to keep the naming
convention consistent, I updated the patch to also rename gfp_mask to
gfp in prepare_alloc_pages.

As a complete aside, I don't actually like the gfp name and would have
preferred gfp_flags because GFP is just an acronym and the context of the
variable is that it's a set of GFP Flags. The mask naming was wrong I admit
because it's not a mask but I'm not interested in naming the bike shed :)

Thanks for pointing this out early because it would have been a merge
headache!

-- 
Mel Gorman
SUSE Labs
