Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93CC344C0B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhCVQpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:45:30 -0400
Received: from outbound-smtp17.blacknight.com ([46.22.139.234]:38773 "EHLO
        outbound-smtp17.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229913AbhCVQo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:44:59 -0400
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp17.blacknight.com (Postfix) with ESMTPS id 48F991C4F48
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 16:44:55 +0000 (GMT)
Received: (qmail 4119 invoked from network); 22 Mar 2021 16:44:55 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 22 Mar 2021 16:44:55 -0000
Date:   Mon, 22 Mar 2021 16:44:53 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Message-ID: <20210322164453.GH3697@techsingularity.net>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
 <20210322130446.0a505db0@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210322130446.0a505db0@carbon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 01:04:46PM +0100, Jesper Dangaard Brouer wrote:
> On Mon, 22 Mar 2021 09:18:42 +0000
> Mel Gorman <mgorman@techsingularity.net> wrote:
> 
> > This series is based on top of Matthew Wilcox's series "Rationalise
> > __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
> > test and are not using Andrew's tree as a baseline, I suggest using the
> > following git tree
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v5r9
> 
> page_bench04_bulk[1] micro-benchmark on branch: mm-bulk-rebase-v5r9
>  [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/mm/bench/page_bench04_bulk.c
> 
> BASELINE
>  single_page alloc+put: Per elem: 199 cycles(tsc) 55.472 ns
> 
> LIST variant: time_bulk_page_alloc_free_list: step=bulk size
> 
>  Per elem: 206 cycles(tsc) 57.478 ns (step:1)
>  Per elem: 154 cycles(tsc) 42.861 ns (step:2)
>  Per elem: 145 cycles(tsc) 40.536 ns (step:3)
>  Per elem: 142 cycles(tsc) 39.477 ns (step:4)
>  Per elem: 142 cycles(tsc) 39.610 ns (step:8)
>  Per elem: 137 cycles(tsc) 38.155 ns (step:16)
>  Per elem: 135 cycles(tsc) 37.739 ns (step:32)
>  Per elem: 134 cycles(tsc) 37.282 ns (step:64)
>  Per elem: 133 cycles(tsc) 36.993 ns (step:128)
> 
> ARRAY variant: time_bulk_page_alloc_free_array: step=bulk size
> 
>  Per elem: 202 cycles(tsc) 56.383 ns (step:1)
>  Per elem: 144 cycles(tsc) 40.047 ns (step:2)
>  Per elem: 134 cycles(tsc) 37.339 ns (step:3)
>  Per elem: 128 cycles(tsc) 35.578 ns (step:4)
>  Per elem: 120 cycles(tsc) 33.592 ns (step:8)
>  Per elem: 116 cycles(tsc) 32.362 ns (step:16)
>  Per elem: 113 cycles(tsc) 31.476 ns (step:32)
>  Per elem: 110 cycles(tsc) 30.633 ns (step:64)
>  Per elem: 110 cycles(tsc) 30.596 ns (step:128)
> 
> Compared to the previous results (see below) list-variant got faster,
> but array-variant is still faster.  The array variant lost a little
> performance.  I think this can be related to the stats counters got
> added/moved inside the loop, in this patchset.
> 

If you are feeling particularly brave, take a look at
git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-percpu-local_lock-v1r10

It's a prototype series rebased on top of the bulk allocator and this
version has not even been boot tested.  While it'll get rough treatment
during review, it should reduce the cost of the stat updates in the
bulk allocator as a side-effect.

-- 
Mel Gorman
SUSE Labs
