Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB2935C437
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239267AbhDLKmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:42:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:37350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237538AbhDLKmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 06:42:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 60439AF11;
        Mon, 12 Apr 2021 10:41:44 +0000 (UTC)
Subject: Re: [PATCH 4/9] mm/page_alloc: optimize code layout for
 __alloc_pages_bulk
To:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325114228.27719-5-mgorman@techsingularity.net>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <71449835-d4da-657e-b4cf-b077e9636ff7@suse.cz>
Date:   Mon, 12 Apr 2021 12:41:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325114228.27719-5-mgorman@techsingularity.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/21 12:42 PM, Mel Gorman wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> Looking at perf-report and ASM-code for __alloc_pages_bulk() it is clear
> that the code activated is suboptimal. The compiler guesses wrong and
> places unlikely code at the beginning. Due to the use of WARN_ON_ONCE()
> macro the UD2 asm instruction is added to the code, which confuse the
> I-cache prefetcher in the CPU.

Hm that's weird, WARN_ON_ONCE() uses unlikely() too, so the UD2 should end up in
the out-of-fast-path part?
But anyway.

> [mgorman: Minor changes and rebasing]
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>

Acked-By: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/page_alloc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index be1e33a4df39..1ec18121268b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5001,7 +5001,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  	unsigned int alloc_flags;
>  	int nr_populated = 0;
>  
> -	if (WARN_ON_ONCE(nr_pages <= 0))
> +	if (unlikely(nr_pages <= 0))
>  		return 0;
>  
>  	/*
> @@ -5048,7 +5048,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  	 * If there are no allowed local zones that meets the watermarks then
>  	 * try to allocate a single page and reclaim if necessary.
>  	 */
> -	if (!zone)
> +	if (unlikely(!zone))
>  		goto failed;
>  
>  	/* Attempt the batch allocation */
> @@ -5066,7 +5066,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  
>  		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
>  								pcp, pcp_list);
> -		if (!page) {
> +		if (unlikely(!page)) {
>  			/* Try and get at least one page */
>  			if (!nr_populated)
>  				goto failed_irq;
> 

