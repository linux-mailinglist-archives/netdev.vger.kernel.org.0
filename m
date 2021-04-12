Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D947F35C4E6
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 13:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240235AbhDLLUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 07:20:12 -0400
Received: from outbound-smtp21.blacknight.com ([81.17.249.41]:39198 "EHLO
        outbound-smtp21.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240209AbhDLLUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 07:20:11 -0400
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp21.blacknight.com (Postfix) with ESMTPS id 2946ACCA7E
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:19:53 +0100 (IST)
Received: (qmail 30339 invoked from network); 12 Apr 2021 11:19:52 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 12 Apr 2021 11:19:52 -0000
Date:   Mon, 12 Apr 2021 12:19:51 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/9] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210412111951.GW3697@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325114228.27719-3-mgorman@techsingularity.net>
 <28729c76-4e09-f860-0db1-9c79c8220683@suse.cz>
 <20210412105938.GU3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210412105938.GU3697@techsingularity.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 11:59:38AM +0100, Mel Gorman wrote:
> > I don't understand this comment. Only alloc_flags_nofragment() sets this flag
> > and we don't use it here?
> > 
> 
> It's there as a reminder that there are non-obvious consequences
> to ALLOC_NOFRAGMENT that may affect the bulk allocation success
> rate. __rmqueue_fallback will only select pageblock_order pages and if that
> fails, we fall into the slow path that allocates a single page. I didn't
> deal with it because it was not obvious that it's even relevant but I bet
> in 6 months time, I'll forget that ALLOC_NOFRAGMENT may affect success
> rates without the comment. I'm waiting for a bug that can trivially trigger
> a case with a meaningful workload where the success rate is poor enough to
> affect latency before adding complexity. Ideally by then, the allocation
> paths would be unified a bit better.
> 

So this needs better clarification. ALLOC_NOFRAGMENT is not a
problem at the moment but at one point during development, it was a
non-obvious potential problem. If the paths are unified, ALLOC_NOFRAGMENT
*potentially* becomes a problem depending on how it's done and it needs
careful consideration. For example, it could be part unified by moving
the alloc_flags_nofragment() call into prepare_alloc_pages because in
__alloc_pages, it always happens and it looks like an obvious partial
unification. Hence the comment "May set ALLOC_NOFRAGMENT" because I wanted
a reminder in case I "fixed" this in 6 months time and forgot the downside.

-- 
Mel Gorman
SUSE Labs
