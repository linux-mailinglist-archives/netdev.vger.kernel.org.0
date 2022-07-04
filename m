Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C841564B16
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 03:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiGDBOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 21:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiGDBOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 21:14:07 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8B76395;
        Sun,  3 Jul 2022 18:14:05 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Lbnps1K8czkX55;
        Mon,  4 Jul 2022 09:12:37 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 4 Jul 2022 09:14:01 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 4 Jul
 2022 09:14:01 +0800
Subject: Re: [PATCH net-next v2] net: page_pool: optimize page pool page
 allocation in NUMA scenario
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <20220629133305.15012-1-huangguangbin2@huawei.com>
 <20220630211534.6d1c32da@kernel.org>
 <728b4c15-8114-e253-5d45-a5610882f891@redhat.com>
CC:     <brouer@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <lorenzo@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <5fbe43df-7469-f8af-97a2-ad5f20efa889@huawei.com>
Date:   Mon, 4 Jul 2022 09:14:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <728b4c15-8114-e253-5d45-a5610882f891@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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



On 2022/7/1 15:56, Jesper Dangaard Brouer wrote:
>
> On 01/07/2022 06.15, Jakub Kicinski wrote:
>> On Wed, 29 Jun 2022 21:33:05 +0800 Guangbin Huang wrote:
>>> +#ifdef CONFIG_NUMA
>>> +    pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() :
>>> pool->p.nid;
>>> +#else
>>> +    /* Ignore pool->p.nid setting if !CONFIG_NUMA */
>>> +    pref_nid = NUMA_NO_NODE;
>>> +#endif
>>
>> Please factor this out to a helper, this is a copy of the code from
>> page_pool_refill_alloc_cache() and #ifdefs are a little yuck.
>>
>
> I would say simply use 'pool->p.nid' in the call to
> alloc_pages_bulk_array_node() and drop this optimization (that was
> copy-pasted from fast-path).
>
> The optimization avoids one reading from memory compile time depending
> on CONFIG_NUMA.  It is *not* worth doing in this code path which is even
> named "slow" (__page_pool_alloc_pages_slow).
>
> --Jesper
>
Simply use pool->p.nid looks simply and makes sense in both scenario. I 
will rewrite and test the patch in next version.
>
> .
>

