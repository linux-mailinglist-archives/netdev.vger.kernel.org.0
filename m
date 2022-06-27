Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B9755D2EC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbiF0NFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 09:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiF0NEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 09:04:43 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C457E1144D;
        Mon, 27 Jun 2022 06:04:06 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LWnry6PW2zShRY;
        Mon, 27 Jun 2022 21:00:34 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 27 Jun 2022 21:04:03 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 27 Jun
 2022 21:04:02 +0800
Subject: Re: [PATCH net-next] net: page_pool: optimize page pool page
 allocation in NUMA scenario
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>
References: <20220624093621.12505-1-huangguangbin2@huawei.com>
 <64caa039-14fb-c883-de1c-6549b5314269@redhat.com>
CC:     <brouer@redhat.com>, <lorenzo@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <7b004f0d-7a15-6e01-ffa3-ed1826ba9810@huawei.com>
Date:   Mon, 27 Jun 2022 21:04:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <64caa039-14fb-c883-de1c-6549b5314269@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/6/27 17:50, Jesper Dangaard Brouer wrote:
>
>
> On 24/06/2022 11.36, Guangbin Huang wrote:
>> From: Jie Wang <wangjie125@huawei.com>
>>
>> Currently NIC packet receiving performance based on page pool
>> deteriorates
>> occasionally. To analysis the causes of this problem page allocation
>> stats
>> are collected. Here are the stats when NIC rx performance deteriorates:
>>
>> bandwidth(Gbits/s)        16.8        6.91
>> rx_pp_alloc_fast        13794308    21141869
>> rx_pp_alloc_slow        108625        166481
>> rx_pp_alloc_slow_h        0        0
>> rx_pp_alloc_empty        8192        8192
>> rx_pp_alloc_refill        0        0
>> rx_pp_alloc_waive        100433        158289
>> rx_pp_recycle_cached        0        0
>> rx_pp_recycle_cache_full    0        0
>> rx_pp_recycle_ring        362400        420281
>> rx_pp_recycle_ring_full        6064893        9709724
>> rx_pp_recycle_released_ref    0        0
>>
>> The rx_pp_alloc_waive count indicates that a large number of pages' numa
>> node are inconsistent with the NIC device numa node. Therefore these
>> pages
>> can't be reused by the page pool. As a result, many new pages would be
>> allocated by __page_pool_alloc_pages_slow which is time consuming. This
>> causes the NIC rx performance fluctuations.
>>
>> The main reason of huge numa mismatch pages in page pool is that page
>> pool
>> uses alloc_pages_bulk_array to allocate original pages. This function is
>> not suitable for page allocation in NUMA scenario. So this patch uses
>> alloc_pages_bulk_array_node which has a NUMA id input parameter to ensure
>> the NUMA consistent between NIC device and allocated pages.
>>
>> Repeated NIC rx performance tests are performed 40 times. NIC rx
>> bandwidth
>> is higher and more stable compared to the datas above. Here are three
>> test
>> stats, the rx_pp_alloc_waive count is zero and rx_pp_alloc_slow which
>> indicates pages allocated from slow patch is relatively low.
>>
>> bandwidth(Gbits/s)        93        93.9        93.8
>> rx_pp_alloc_fast        60066264    61266386    60938254
>> rx_pp_alloc_slow        16512        16517        16539
>> rx_pp_alloc_slow_ho        0        0        0
>> rx_pp_alloc_empty        16512        16517        16539
>> rx_pp_alloc_refill        473841        481910        481585
>> rx_pp_alloc_waive        0        0        0
>> rx_pp_recycle_cached        0        0        0
>> rx_pp_recycle_cache_full    0        0        0
>> rx_pp_recycle_ring        29754145    30358243    30194023
>> rx_pp_recycle_ring_full        0        0        0
>> rx_pp_recycle_released_ref    0        0        0
>>
>> Signed-off-by: Jie Wang <wangjie125@huawei.com>
>> ---
>>   net/core/page_pool.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>
> Thanks for improving this, but we need some small adjustments below.
> And then you need to send a V2 of the patch.
>
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index f18e6e771993..15997fcd78f3 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -377,6 +377,7 @@ static struct page
>> *__page_pool_alloc_pages_slow(struct page_pool *pool,
>>       unsigned int pp_order = pool->p.order;
>>       struct page *page;
>>       int i, nr_pages;
>> +    int pref_nid; /* preferred NUMA node */
>>         /* Don't support bulk alloc for high-order pages */
>>       if (unlikely(pp_order))
>> @@ -386,10 +387,18 @@ static struct page
>> *__page_pool_alloc_pages_slow(struct page_pool *pool,
>>       if (unlikely(pool->alloc.count > 0))
>>           return pool->alloc.cache[--pool->alloc.count];
>>   +#ifdef CONFIG_NUMA
>> +    pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() :
>> pool->p.nid;
>> +#else
>> +    /* Ignore pool->p.nid setting if !CONFIG_NUMA, helps compiler */
>
> Remove "helps compiler" from comments, it only make sense in the code
> this was copy-pasted from.
>
>
>> +    pref_nid = numa_mem_id(); /* will be zero like page_to_nid() */
>
> The comment about "page_to_nid()" is only relevant in the code
> this was copy-pasted from.
>
> Change to:
>     pref_nid = NUMA_NO_NODE;
>
> As alloc_pages_bulk_array_node() will be inlined, the effect (generated
> asm code) will be the same, but it will be better for code maintenance.
>
OK，thanks for your review, I will fix it in next version.
>> +#endif
>> +
>>       /* Mark empty alloc.cache slots "empty" for
>> alloc_pages_bulk_array */
>>       memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
>>   -    nr_pages = alloc_pages_bulk_array(gfp, bulk, pool->alloc.cache);
>> +    nr_pages = alloc_pages_bulk_array_node(gfp, pref_nid, bulk,
>> +                           pool->alloc.cache);
>>       if (unlikely(!nr_pages))
>>           return NULL;
>>
>
>
> .
>

