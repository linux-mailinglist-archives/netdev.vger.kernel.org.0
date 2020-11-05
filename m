Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94112A7E56
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 13:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbgKEMJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 07:09:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:34550 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbgKEMJR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 07:09:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B0829AB95;
        Thu,  5 Nov 2020 12:09:15 +0000 (UTC)
Subject: Re: [PATCH] page_frag: Recover from memory pressure
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Bert Barbe <bert.barbe@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        SRINIVAS <srinivas.eeda@oracle.com>, stable@vger.kernel.org,
        Jann Horn <jannh@google.com>
References: <20201105042140.5253-1-willy@infradead.org>
 <83d68f28-cae7-012d-0f4b-82960b248bd8@suse.cz>
 <20201105120554.GJ17076@casper.infradead.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <bd404987-6c26-ae7d-55cf-be74b432c3ec@suse.cz>
Date:   Thu, 5 Nov 2020 13:09:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201105120554.GJ17076@casper.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/20 1:05 PM, Matthew Wilcox wrote:
> On Thu, Nov 05, 2020 at 12:56:43PM +0100, Vlastimil Babka wrote:
>> > +++ b/mm/page_alloc.c
>> > @@ -5139,6 +5139,10 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>> >   		if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
>> >   			goto refill;
>> > +		if (nc->pfmemalloc) {
>> > +			free_the_page(page, compound_order(page));
>> > +			goto refill;
>> 
>> Theoretically the refill can fail and we return NULL while leaving nc->va
>> pointing to a freed page, so I think you should set nc->va to NULL.
>> 
>> Geez, can't the same thing already happen after we sub the nc->pagecnt_bias
>> from page ref, and last users of the page fragments then return them and dec
>> the ref to zero and the page gets freed?
> 
> I don't think you read __page_frag_cache_refill() closely enough ...

Or rather not at all, sorry :) somehow I just saw "ah here we call the page 
allocator".

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> 
>          if (unlikely(!page))
>                  page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
> 
>          nc->va = page ? page_address(page) : NULL;
> 
> 

