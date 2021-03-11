Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C2E336E2D
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 09:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhCKIso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 03:48:44 -0500
Received: from outbound-smtp14.blacknight.com ([46.22.139.231]:49803 "EHLO
        outbound-smtp14.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231613AbhCKIs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 03:48:29 -0500
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp14.blacknight.com (Postfix) with ESMTPS id 958391C52E4
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:48:28 +0000 (GMT)
Received: (qmail 19459 invoked from network); 11 Mar 2021 08:48:28 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 11 Mar 2021 08:48:28 -0000
Date:   Thu, 11 Mar 2021 08:48:27 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/5] Introduce a bulk order-0 page allocator with two
 in-tree users
Message-ID: <20210311084827.GS3697@techsingularity.net>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310154704.9389055d0be891a0c3549cc2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210310154704.9389055d0be891a0c3549cc2@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 03:47:04PM -0800, Andrew Morton wrote:
> On Wed, 10 Mar 2021 10:46:13 +0000 Mel Gorman <mgorman@techsingularity.net> wrote:
> 
> > This series introduces a bulk order-0 page allocator with sunrpc and
> > the network page pool being the first users.
> 
> <scratches head>
> 
> Right now, the [0/n] doesn't even tell us that it's a performance
> patchset!
> 

I'll add a note about this improving performance for users that operate
on batches of patches and want to avoid multiple round-trips to the
page allocator.

> The whole point of this patchset appears to appear in the final paragraph
> of the final patch's changelog.
> 

I'll copy&paste that note to the introduction. It's likely that high-speed
networking is the most relevant user in the short-term.

> : For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
> : redirecting xdp_frame packets into a veth, that does XDP_PASS to create
> : an SKB from the xdp_frame, which then cannot return the page to the
> : page_pool.  In this case, we saw[1] an improvement of 18.8% from using
> : the alloc_pages_bulk API (3,677,958 pps -> 4,368,926 pps).
> 
> Much more detail on the overall objective and the observed results,
> please?
> 

I cannot generate that data right now so I need Jesper to comment on
exactly why this is beneficial. For example, while I get that more data
can be processed in a microbenchmark, I do not have a good handle on how
much difference that makes to a practical application. About all I know
is that this problem has been knocking around for 3-4 years at least.

> Also, that workload looks awfully corner-casey.  How beneficial is this
> work for more general and widely-used operations?
> 

At this point, probably nothing for most users because batch page
allocation is not common. It's primarily why I avoided reworking the
whole allocator just to make this a bit tidier.

> > The implementation is not
> > particularly efficient and the intention is to iron out what the semantics
> > of the API should have for users. Once the semantics are ironed out, it can
> > be made more efficient.
> 
> And some guesstimates about how much benefit remains to be realized
> would be helpful.
> 

I don't have that information unfortunately. It's a chicken and egg
problem because without the API, there is no point creating new users.
For example, fault around or readahead could potentially batch pages
but whether it is actually noticable when page zeroing has to happen
is a completely different story. It's a similar story for SLUB, we know
lower order allocations hurt some microbenchmarks like hackbench-sockets
but have not quantified what happens if SLUB batch allocates pages when
high-order allocations fail.

-- 
Mel Gorman
SUSE Labs
