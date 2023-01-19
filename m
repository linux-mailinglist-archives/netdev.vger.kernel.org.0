Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F2E672F16
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 03:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjASCjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 21:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjASCjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 21:39:36 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC5C69B2E
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:39:34 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ny6H51fLGzRrF5;
        Thu, 19 Jan 2023 10:37:37 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 10:39:30 +0800
Subject: Re: [PATCH net-next V2 2/2] net: kfree_skb_list use
 kmem_cache_free_bulk
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <brouer@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>
References: <167361788585.531803.686364041841425360.stgit@firesoul>
 <167361792462.531803.224198635706602340.stgit@firesoul>
 <6f634864-2937-6e32-ba9d-7fa7f2b576cb@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b0fcf845-0abc-2f70-250e-0a1da8e93d2f@huawei.com>
Date:   Thu, 19 Jan 2023 10:39:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <6f634864-2937-6e32-ba9d-7fa7f2b576cb@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/1/19 5:37, Jesper Dangaard Brouer wrote:
> (related to syzbot issue[1])
> 
> On 13/01/2023 14.52, Jesper Dangaard Brouer wrote:
>> The kfree_skb_list function walks SKB (via skb->next) and frees them
>> individually to the SLUB/SLAB allocator (kmem_cache). It is more
>> efficient to bulk free them via the kmem_cache_free_bulk API.
>>
>> This patches create a stack local array with SKBs to bulk free while
>> walking the list. Bulk array size is limited to 16 SKBs to trade off
>> stack usage and efficiency. The SLUB kmem_cache "skbuff_head_cache"
>> uses objsize 256 bytes usually in an order-1 page 8192 bytes that is
>> 32 objects per slab (can vary on archs and due to SLUB sharing). Thus,
>> for SLUB the optimal bulk free case is 32 objects belonging to same
>> slab, but runtime this isn't likely to occur.
>>
>> The expected gain from using kmem_cache bulk alloc and free API
>> have been assessed via a microbencmark kernel module[1].
>>
>> The module 'slab_bulk_test01' results at bulk 16 element:
>>   kmem-in-loop Per elem: 109 cycles(tsc) 30.532 ns (step:16)
>>   kmem-bulk    Per elem: 64 cycles(tsc) 17.905 ns (step:16)
>>
>> More detailed description of benchmarks avail in [2].
>>
>> [1] https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/mm
>> [2] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/kfree_skb_list01.org
>>
>> V2: rename function to kfree_skb_add_bulk.
>>
>> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   net/core/skbuff.c |   40 +++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 39 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 007a5fbe284b..79c9e795a964 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -964,16 +964,54 @@ kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
>>   }
>>   EXPORT_SYMBOL(kfree_skb_reason);
>>   +#define KFREE_SKB_BULK_SIZE    16
>> +
>> +struct skb_free_array {
>> +    unsigned int skb_count;
>> +    void *skb_array[KFREE_SKB_BULK_SIZE];
>> +};
>> +
>> +static void kfree_skb_add_bulk(struct sk_buff *skb,
>> +                   struct skb_free_array *sa,
>> +                   enum skb_drop_reason reason)
>> +{
>> +    /* if SKB is a clone, don't handle this case */
>> +    if (unlikely(skb->fclone != SKB_FCLONE_UNAVAILABLE)) {
>> +        __kfree_skb(skb);
>> +        return;
>> +    }
>> +
>> +    skb_release_all(skb, reason);
>> +    sa->skb_array[sa->skb_count++] = skb;
>> +
>> +    if (unlikely(sa->skb_count == KFREE_SKB_BULK_SIZE)) {
>> +        kmem_cache_free_bulk(skbuff_head_cache, KFREE_SKB_BULK_SIZE,
>> +                     sa->skb_array);
>> +        sa->skb_count = 0;
>> +    }
>> +}
>> +
>>   void __fix_address
>>   kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
>>   {
>> +    struct skb_free_array sa;
>> +
>> +    sa.skb_count = 0;
>> +
>>       while (segs) {
>>           struct sk_buff *next = segs->next;
>>   +        skb_mark_not_on_list(segs);
> 
> The syzbot[1] bug goes way if I remove this skb_mark_not_on_list().
> 
> I don't understand why I cannot clear skb->next here?

Clearing skb->next seems unrelated, it may just increase the problem
recurrence probability.

Because It seems kfree_skb_list_reason() is also used to release skb in
shinfo->frag_list, which should go through the skb_unref() checking,
and this patch seems to skip the skb_unref() checking for skb in
shinfo->frag_list.

> 
> [1] https://lore.kernel.org/all/000000000000d58eae05f28ca51f@google.com/
> 
>>           if (__kfree_skb_reason(segs, reason))
>> -            __kfree_skb(segs);
>> +            kfree_skb_add_bulk(segs, &sa, reason);
>> +
>>           segs = next;
>>       }
>> +
>> +    if (sa.skb_count)
>> +        kmem_cache_free_bulk(skbuff_head_cache, sa.skb_count,
>> +                     sa.skb_array);
>>   }
>>   EXPORT_SYMBOL(kfree_skb_list_reason);
>>  
>>
> 
> .
> 
