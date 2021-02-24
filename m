Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEF6323BB2
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbhBXL52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:57:28 -0500
Received: from outbound-smtp22.blacknight.com ([81.17.249.190]:39739 "EHLO
        outbound-smtp22.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235207AbhBXL4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:56:11 -0500
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp22.blacknight.com (Postfix) with ESMTPS id 40909BAA78
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 11:55:11 +0000 (GMT)
Received: (qmail 8759 invoked from network); 24 Feb 2021 11:55:11 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 24 Feb 2021 11:55:11 -0000
Date:   Wed, 24 Feb 2021 11:55:08 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] Introduce a bulk order-0 page allocator for
 sunrpc
Message-ID: <20210224115508.GL3697@techsingularity.net>
References: <20210224102603.19524-1-mgorman@techsingularity.net>
 <20210224122723.15943e95@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210224122723.15943e95@carbon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 12:27:23PM +0100, Jesper Dangaard Brouer wrote:
> On Wed, 24 Feb 2021 10:26:00 +0000
> Mel Gorman <mgorman@techsingularity.net> wrote:
> 
> > This is a prototype series that introduces a bulk order-0 page allocator
> > with sunrpc being the first user. The implementation is not particularly
> > efficient and the intention is to iron out what the semantics of the API
> > should be. That said, sunrpc was reported to have reduced allocation
> > latency when refilling a pool.
> 
> I also have a use-case in page_pool, and I've been testing with the
> earlier patches, results are here[1]
> 
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org
> 
> Awesome to see this newer patchset! thanks a lot for working on this!
> I'll run some new tests based on this.
> 

Thanks and if they get finalised, a patch on top for review would be
nice with the results included in the changelog. Obviously any change
that would need to be made to the allocator would happen first.

> > As a side-note, while the implementation could be more efficient, it
> > would require fairly deep surgery in numerous places. The lock scope would
> > need to be significantly reduced, particularly as vmstat, per-cpu and the
> > buddy allocator have different locking protocol that overal -- e.g. all
> > partially depend on irqs being disabled at various points. Secondly,
> > the core of the allocator deals with single pages where as both the bulk
> > allocator and per-cpu allocator operate in batches. All of that has to
> > be reconciled with all the existing users and their constraints (memory
> > offline, CMA and cpusets being the trickiest).
> 
> As you can see in[1], I'm getting a significant speedup from this.  I
> guess that the cost of finding the "zone" is higher than I expected, as
> this basically what we/you amortize for the bulk.
> 

The obvious goal would be that if a refactoring did happen that the
performance would be at least neutral but hopefully improved.

> > In terms of semantics required by new users, my preference is that a pair
> > of patches be applied -- the first which adds the required semantic to
> > the bulk allocator and the second which adds the new user.
> > 
> > Patch 1 of this series is a cleanup to sunrpc, it could be merged
> > 	separately but is included here for convenience.
> > 
> > Patch 2 is the prototype bulk allocator
> > 
> > Patch 3 is the sunrpc user. Chuck also has a patch which further caches
> > 	pages but is not included in this series. It's not directly
> > 	related to the bulk allocator and as it caches pages, it might
> > 	have other concerns (e.g. does it need a shrinker?)
> > 
> > This has only been lightly tested on a low-end NFS server. It did not break
> > but would benefit from an evaluation to see how much, if any, the headline
> > performance changes. The biggest concern is that a light test case showed
> > that there are a *lot* of bulk requests for 1 page which gets delegated to
> > the normal allocator.  The same criteria should apply to any other users.
> 
> If you change local_irq_save(flags) to local_irq_disable() then you can
> likely get better performance for 1 page requests via this API.  This
> limits the API to be used in cases where IRQs are enabled (which is
> most cases).  (For my use-case I will not do 1 page requests).
> 

I do not want to constrain the API to being IRQ-only prematurely. An
obvious alternative use case is the SLUB allocation path when a high-order
allocation fails. It's known that if the SLUB order is reduced that it has
an impact on hackbench communicating over sockets.  It would be interesting
to see what happens if order-0 pages are bulk allocated when s->min == 0
and that can be called from a blocking context. Tricky to test but could
be fudged by forcing all high-order allocations to fail when s->min ==
0 to evaluate the worst case scenario.  In addition, it would constrain
any potential refactoring if the lower levels have to choose between
local_irq_disable() vs local_irq_save() depending on the caller context.

-- 
Mel Gorman
SUSE Labs
