Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8815D35C486
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239763AbhDLK77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:59:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:52494 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238530AbhDLK76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 06:59:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1B690AEFE;
        Mon, 12 Apr 2021 10:59:39 +0000 (UTC)
Subject: Re: [PATCH 5/9] mm/page_alloc: inline __rmqueue_pcplist
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
 <20210325114228.27719-6-mgorman@techsingularity.net>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <d76d4cb0-8b5b-cff4-6f7f-aec4dde47844@suse.cz>
Date:   Mon, 12 Apr 2021 12:59:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325114228.27719-6-mgorman@techsingularity.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/21 12:42 PM, Mel Gorman wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> When __alloc_pages_bulk() got introduced two callers of __rmqueue_pcplist
> exist and the compiler chooses to not inline this function.
> 
>  ./scripts/bloat-o-meter vmlinux-before vmlinux-inline__rmqueue_pcplist
> add/remove: 0/1 grow/shrink: 2/0 up/down: 164/-125 (39)
> Function                                     old     new   delta
> rmqueue                                     2197    2296     +99
> __alloc_pages_bulk                          1921    1986     +65
> __rmqueue_pcplist                            125       -    -125
> Total: Before=19374127, After=19374166, chg +0.00%
> 
> modprobe page_bench04_bulk loops=$((10**7))
> 
> Type:time_bulk_page_alloc_free_array
>  -  Per elem: 106 cycles(tsc) 29.595 ns (step:64)
>  - (measurement period time:0.295955434 sec time_interval:295955434)
>  - (invoke count:10000000 tsc_interval:1065447105)
> 
> Before:
>  - Per elem: 110 cycles(tsc) 30.633 ns (step:64)
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/page_alloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1ec18121268b..d900e92884b2 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3415,7 +3415,8 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z)
>  }
>  
>  /* Remove page from the per-cpu list, caller must protect the list */
> -static struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
> +static inline
> +struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
>  			unsigned int alloc_flags,
>  			struct per_cpu_pages *pcp,
>  			struct list_head *list)
> 

