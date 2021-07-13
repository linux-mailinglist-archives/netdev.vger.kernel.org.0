Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DE83C6AAB
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 08:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhGMGlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 02:41:45 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:14074 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhGMGlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 02:41:44 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GP9qp6GhTzbbwx;
        Tue, 13 Jul 2021 14:35:34 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 14:38:51 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 13 Jul
 2021 14:38:50 +0800
Subject: Re: [PATCH rfc v3 2/4] page_pool: add interface for getting and
 setting pagecnt_bias
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     Alexander Duyck <alexander.duyck@gmail.com>, <brouer@redhat.com>,
        "David Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Russell King - ARM Linux" <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Will Deacon" <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Vlastimil Babka" <vbabka@suse.cz>, <fenghua.yu@intel.com>,
        <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Alexander Lobakin" <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, <wenxu@ucloud.cn>,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, <nogikh@google.com>,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        <kpsingh@kernel.org>, <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>, <songliubraving@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1626092196-44697-1-git-send-email-linyunsheng@huawei.com>
 <1626092196-44697-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Uf1W1H_0jK+zTDHdQnpa-dFSfcAtANqhPTJyZ21VeGmjg@mail.gmail.com>
 <2d9a3d29-8e6b-8462-c410-6b7fd4518c9d@redhat.com>
 <YOyFAkahxxMKNeGb@enceladus>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b217802f-368f-2d7d-d216-6614305acfa2@huawei.com>
Date:   Tue, 13 Jul 2021 14:38:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YOyFAkahxxMKNeGb@enceladus>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/13 2:08, Ilias Apalodimas wrote:
> [...]
>>>> +static inline bool page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>>>>   {
>>>> +       if (WARN_ON(addr & ~PAGE_MASK))
>>>> +               return false;
>>>> +
>>>>          page->dma_addr[0] = addr;
>>>>          if (sizeof(dma_addr_t) > sizeof(unsigned long))
>>>>                  page->dma_addr[1] = upper_32_bits(addr);
>>>> +
>>>> +       return true;
>>>> +}
>>>> +
>>>
>>> Rather than making this a part of the check here it might make more
>>> sense to pull this out and perform the WARN_ON after the check for
>>> dma_mapping_error.
>>
>> I need to point out that I don't like WARN_ON and BUG_ON code in fast-path
>> code, because compiler adds 'ud2' assembler instructions that influences the
>> instruction-cache fetching in the CPU.  Yes, I have seen a measuresable
>> impact from this before.
>>
>>
>>> Also it occurs to me that we only really have to do this in the case
>>> where dma_addr_t is larger than the size of a long. Otherwise we could
>>> just have the code split things so that dma_addr[0] is the dma_addr
>>> and dma_addr[1] is our pagecnt_bias value in which case we could
>>> probably just skip the check.
>>
>> The dance to get 64-bit DMA addr on 32-bit systems is rather ugly and
>> confusing, sadly.  We could take advantage of this, I just hope this will
>> not make it uglier.
> 
> Note here that we can only use this because dma_addr is not aliased to
> compound page anymore (after the initial page_pool recycling patchset). 
> We must keep this in mind if we even restructure struct page.
> 
> Can we do something more radical for this? The 64/32 bit dance is only
> there for 32 bit systems with 64 bit dma.  Since the last time we asked
> about this no one seemed to care about these, and I really doubt we'll get
> an ethernet driver for them (that needs recycling....), can we *only* support 
> frag allocation and recycling for 'normal' systems? We could always just r
> e-purpose dma_addr[1] for those.

Will define a macro for "sizeof(dma_addr_t) > sizeof(unsigned long)" to
decide whether to use the dma_addr[1], hopefully the compiler will optimize
out the unused code in a specific system.

> 
> Regards
> /Ilias
> 
>>
>>
>>>> +static inline int page_pool_get_pagecnt_bias(struct page *page)
>>>> +{
>>>> +       return READ_ONCE(page->dma_addr[0]) & ~PAGE_MASK;
>>>> +}
>>>> +
>>>> +static inline unsigned long *page_pool_pagecnt_bias_ptr(struct page *page)
>>>> +{
>>>> +       return page->dma_addr;
>>>> +}
>>>> +
>>>> +static inline void page_pool_set_pagecnt_bias(struct page *page, int bias)
>>>> +{
>>>> +       unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
>>>> +
>>>> +       dma_addr_0 &= PAGE_MASK;
>>>> +       dma_addr_0 |= bias;
>>>> +
>>>> +       WRITE_ONCE(page->dma_addr[0], dma_addr_0);
>>>>   }
>>>>
>>>>   static inline bool is_page_pool_compiled_in(void)
>>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>>>> index 78838c6..1abefc6 100644
>>>> --- a/net/core/page_pool.c
>>>> +++ b/net/core/page_pool.c
>>>> @@ -198,7 +198,13 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>>>>          if (dma_mapping_error(pool->p.dev, dma))
>>>>                  return false;
>>>>
>>>
>>> So instead of adding to the function below you could just add your
>>> WARN_ON check here with the unmapping call.

Ok.

>>>
>>>> -       page_pool_set_dma_addr(page, dma);
>>>> +       if (unlikely(!page_pool_set_dma_addr(page, dma))) {
>>>> +               dma_unmap_page_attrs(pool->p.dev, dma,
>>>> +                                    PAGE_SIZE << pool->p.order,
>>>> +                                    pool->p.dma_dir,
>>>> +                                    DMA_ATTR_SKIP_CPU_SYNC);
>>>> +               return false;
>>>> +       }
>>>>
>>>>          if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>>>>                  page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
>>>> --
>>>> 2.7.4
>>>>
>>>
>>
> .
> 
