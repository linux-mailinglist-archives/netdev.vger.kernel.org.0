Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74B72A7D9E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 12:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgKEL4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 06:56:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:55088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgKEL4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 06:56:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D880EAF26;
        Thu,  5 Nov 2020 11:56:43 +0000 (UTC)
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Bert Barbe <bert.barbe@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        SRINIVAS <srinivas.eeda@oracle.com>, stable@vger.kernel.org,
        Jann Horn <jannh@google.com>
References: <20201105042140.5253-1-willy@infradead.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] page_frag: Recover from memory pressure
Message-ID: <83d68f28-cae7-012d-0f4b-82960b248bd8@suse.cz>
Date:   Thu, 5 Nov 2020 12:56:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201105042140.5253-1-willy@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/20 5:21 AM, Matthew Wilcox (Oracle) wrote:
> When the machine is under extreme memory pressure, the page_frag allocator
> signals this to the networking stack by marking allocations with the
> 'pfmemalloc' flag, which causes non-essential packets to be dropped.
> Unfortunately, even after the machine recovers from the low memory
> condition, the page continues to be used by the page_frag allocator,
> so all allocations from this page will continue to be dropped.
> > Fix this by freeing and re-allocating the page instead of recycling it.
> 
> Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> Cc: Bert Barbe <bert.barbe@oracle.com>
> Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
> Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
> Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Cc: SRINIVAS <srinivas.eeda@oracle.com>
> Cc: stable@vger.kernel.org
> Fixes: 79930f5892e ("net: do not deplete pfmemalloc reserve")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   mm/page_alloc.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 778e815130a6..631546ae1c53 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5139,6 +5139,10 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>   
>   		if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
>   			goto refill;
> +		if (nc->pfmemalloc) {
> +			free_the_page(page, compound_order(page));
> +			goto refill;

Theoretically the refill can fail and we return NULL while leaving nc->va 
pointing to a freed page, so I think you should set nc->va to NULL.

Geez, can't the same thing already happen after we sub the nc->pagecnt_bias from 
page ref, and last users of the page fragments then return them and dec the ref 
to zero and the page gets freed?

> +		}
>   
>   #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
>   		/* if size can vary use size else just use PAGE_SIZE */
> 

