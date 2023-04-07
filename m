Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA6F6DA9B9
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbjDGIGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbjDGIGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:06:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CC076AA
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:06:16 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Pt9pF51CpznWtT;
        Fri,  7 Apr 2023 16:02:45 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 7 Apr
 2023 16:06:13 +0800
Subject: Re: [PATCH v2] skbuff: Fix a race between coalescing and releasing
 SKBs
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        Liang Chen <liangchen.linux@gmail.com>, <kuba@kernel.org>,
        <ilias.apalodimas@linaro.org>, <hawk@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
References: <20230406114825.18597-1-liangchen.linux@gmail.com>
 <ed4b1f1bf72ea1234a283a26d88e00658e9e4311.camel@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <7e163f24-c469-421c-3f2f-40aec177cee9@huawei.com>
Date:   Fri, 7 Apr 2023 16:06:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <ed4b1f1bf72ea1234a283a26d88e00658e9e4311.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/6 23:25, Alexander H Duyck wrote:
> On Thu, 2023-04-06 at 19:48 +0800, Liang Chen wrote:
>> Commit 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment
>> recycling") allowed coalescing to proceed with non page pool page and
>> page pool page when @from is cloned, i.e.
>>
>> to->pp_recycle    --> false
>> from->pp_recycle  --> true
>> skb_cloned(from)  --> true
>>
>> However, it actually requires skb_cloned(@from) to hold true until
>> coalescing finishes in this situation. If the other cloned SKB is
>> released while the merging is in process, from_shinfo->nr_frags will be
>> set to 0 towards the end of the function, causing the increment of frag
>> page _refcount to be unexpectedly skipped resulting in inconsistent
>> reference counts. Later when SKB(@to) is released, it frees the page
>> directly even though the page pool page is still in use, leading to
>> use-after-free or double-free errors.
>>
>> So it needs to be specially handled at where the ref count may get lost.
>>
>> The double-free error message below prompted us to investigate:
>> BUG: Bad page state in process swapper/1  pfn:0e0d1
>> page:00000000c6548b28 refcount:-1 mapcount:0 mapping:0000000000000000
>> index:0x2 pfn:0xe0d1
>> flags: 0xfffffc0000000(node=0|zone=1|lastcpupid=0x1fffff)
>> raw: 000fffffc0000000 0000000000000000 ffffffff00000101 0000000000000000
>> raw: 0000000000000002 0000000000000000 ffffffffffffffff 0000000000000000
>> page dumped because: nonzero _refcount
>>
>> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G            E      6.2.0+
>> Call Trace:
>>  <IRQ>
>> dump_stack_lvl+0x32/0x50
>> bad_page+0x69/0xf0
>> free_pcp_prepare+0x260/0x2f0
>> free_unref_page+0x20/0x1c0
>> skb_release_data+0x10b/0x1a0
>> napi_consume_skb+0x56/0x150
>> net_rx_action+0xf0/0x350
>> ? __napi_schedule+0x79/0x90
>> __do_softirq+0xc8/0x2b1
>> __irq_exit_rcu+0xb9/0xf0
>> common_interrupt+0x82/0xa0
>> </IRQ>
>> <TASK>
>> asm_common_interrupt+0x22/0x40
>> RIP: 0010:default_idle+0xb/0x20
>>
>> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
>> ---
>> Changes from v1:
>> - deal with the ref count problem instead of return back to give more opportunities to coalesce skbs.
>> ---
>>  net/core/skbuff.c | 22 ++++++++++++++++++++--
>>  1 file changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 050a875d09c5..77da8ce74a1e 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -5643,7 +5643,19 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
>>  
>>  		skb_fill_page_desc(to, to_shinfo->nr_frags,
>>  				   page, offset, skb_headlen(from));
>> -		*fragstolen = true;
>> +
>> +		/* When @from is pp_recycle and @to isn't, coalescing is
>> +		 * allowed to proceed if @from is cloned. However if the
>> +		 * execution reaches this point, @from is already transitioned
>> +		 * into non-cloned because the other cloned skb is released
>> +		 * somewhere else concurrently. In this case, we need to make
>> +		 * sure the ref count is incremented, not directly stealing
>> +		 * from page pool.
>> +		 */
>> +		if (to->pp_recycle != from->pp_recycle)
>> +			get_page(page);
>> +		else
>> +			*fragstolen = true;
>>  	} else {
>>  		if (to_shinfo->nr_frags +
>>  		    from_shinfo->nr_frags > MAX_SKB_FRAGS)
>> @@ -5659,7 +5671,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
>>  	       from_shinfo->nr_frags * sizeof(skb_frag_t));
>>  	to_shinfo->nr_frags += from_shinfo->nr_frags;
>>  
>> -	if (!skb_cloned(from))
>> +	/* Same situation as above where head data presents. When @from is
>> +	 * pp_recycle and @to isn't, coalescing is allowed to proceed if @from
>> +	 * is cloned. However @from can be transitioned into non-cloned
>> +	 * concurrently by this point. If it does happen, we need to make sure
>> +	 * the ref count is properly incremented.
>> +	 */
>> +	if (to->pp_recycle == from->pp_recycle && !skb_cloned(from))
>>  		from_shinfo->nr_frags = 0;
>>  
>>  	/* if the skb is not cloned this does nothing
> 
> So looking this over I believe this should resolve the issue you
> pointed out while maintaining current functionality.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> 
> One follow-on that we may want to do with this would be to look at
> consolidating the 3 spots where we are checking for our combination of
> pp_recycle comparison and skb_cloned and maybe pass one boolean flag
> indicating that we have to transfer everything by taking page
> references.
> 
> Also I think we can actually increase the number of cases where we
> support coalescing if we were to take apart the skb_head_is_locked call
> and move the skb_cloned check from it into your recycle check in the
> portion where we are stealing from the header.
While at it, as we have already add additional checks to handle the below
case:
 to->pp_recycle    --> false
 from->pp_recycle  --> true
 skb_cloned(from)  --> false

Does it make sense to relax the checking at the beginning to allow
the above case to support coalescing from the beginning?

Also, dose moving to a per-page marker make sense if we want to
remove those additional checking?

> .
> 
