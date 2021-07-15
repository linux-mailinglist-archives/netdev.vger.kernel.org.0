Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABE63C96AB
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 05:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhGODxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 23:53:00 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15014 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhGODw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 23:52:59 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GQL034H72zbcqP;
        Thu, 15 Jul 2021 11:46:43 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 11:49:57 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 15 Jul
 2021 11:49:57 +0800
Subject: Re: [PATCH rfc v5 2/4] page_pool: add interface to manipulate frag
 count in page pool
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        "Matthew Wilcox" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, <fenghua.yu@intel.com>,
        <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        "Feng Tang" <feng.tang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        "Willem de Bruijn" <willemb@google.com>, <wenxu@ucloud.cn>,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, <nogikh@google.com>,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        <kpsingh@kernel.org>, <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <songliubraving@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1626255285-5079-1-git-send-email-linyunsheng@huawei.com>
 <1626255285-5079-3-git-send-email-linyunsheng@huawei.com>
 <79d9e41c-6433-efe1-773a-4f5e91e8de0f@redhat.com>
 <CAKgT0UcDxSmMqCGvrWeYFiKNsxWXskF+pUhKQVCC6totduUyDQ@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <73ef1add-01df-7783-7982-da9e59c26330@huawei.com>
Date:   Thu, 15 Jul 2021 11:49:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UcDxSmMqCGvrWeYFiKNsxWXskF+pUhKQVCC6totduUyDQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/14 22:46, Alexander Duyck wrote:
> On Wed, Jul 14, 2021 at 3:18 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>>
>> On 14/07/2021 11.34, Yunsheng Lin wrote:
>>> As suggested by Alexander, "A DMA mapping should be page
>>> aligned anyway so the lower 12 bits would be reserved 0",
>>> so it might make more sense to repurpose the lower 12 bits
>>> of the dma address to store the frag count for frag page
>>> support in page pool for 32 bit systems with 64 bit dma,
>>> which should be rare those days.
>>
>> Do we have any real driver users with 32-bit arch and 64-bit DMA, that
>> want to use this new frag-count system you are adding to page_pool?
>>
>> This "lower 12-bit use" complicates the code we need to maintain
>> forever. My guess is that it is never used, but we need to update and
>> maintain it, and it will never be tested.
>>
>> Why don't you simply reject using page_pool flag PP_FLAG_PAGE_FRAG
>> during setup of the page_pool for this case?
>>
>>   if ((pool->p.flags & PP_FLAG_PAGE_FRAG) &&
>>       (sizeof(dma_addr_t) > sizeof(unsigned long)))
>>     goto reject-setup;
>>
>>
> 
> That sounds good to me if we want to go that route. It would simplify
> this quite a bit since essentially we could just drop these if blocks.

Ok, let's wait for a few day to see if there is anyone with 32-bit arch
and 64-bit DMA system care enough to use the frag-count support in the page
pool.

> 
> Thanks.
> 
> - Alex
> .
> 
