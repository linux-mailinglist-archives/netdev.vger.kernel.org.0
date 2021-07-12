Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014CE3C54F9
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 12:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346444AbhGLII2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 04:08:28 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:11257 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352915AbhGLIAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 04:00:45 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GNbZg4LxNz1CJ01;
        Mon, 12 Jul 2021 15:52:11 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 15:57:46 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 12 Jul
 2021 15:57:46 +0800
Subject: Re: [PATCH rfc v2 4/5] page_pool: support page frag API for page pool
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, "Salil Mehta" <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
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
        Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com>
 <1625903002-31619-5-git-send-email-linyunsheng@huawei.com>
 <CAKgT0UeDf1+-CjzsCo0Chtd2kn_mFV7=my1ygeKMBHBSdjrAHQ@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <2d31020f-2b94-e4ad-1100-378778424b12@huawei.com>
Date:   Mon, 12 Jul 2021 15:57:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UeDf1+-CjzsCo0Chtd2kn_mFV7=my1ygeKMBHBSdjrAHQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/11 1:43, Alexander Duyck wrote:
> On Sat, Jul 10, 2021 at 12:44 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> Currently each desc use a whole page to do ping-pong page
>> reusing in most driver. As the page pool has support page
>> recycling based on elevated refcnt, it makes sense to add
>> a page frag API in page pool to split a page to different
>> frag to serve multi descriptions.
>>
>> This means a huge memory saving for kernel with page size of
>> 64K, as a page can be used by 32 descriptions with 2k buffer
>> size, comparing to each desc using one page currently.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  include/net/page_pool.h | 14 ++++++++++++++
>>  net/core/page_pool.c    | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 63 insertions(+)
>>
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index f0e708d..06a5e43 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -80,6 +80,7 @@ struct page_pool_params {
>>         enum dma_data_direction dma_dir; /* DMA mapping direction */
>>         unsigned int    max_len; /* max DMA sync memory size */
>>         unsigned int    offset;  /* DMA addr offset */
>> +       unsigned int    frag_size;
>>  };
>>
>>  struct page_pool {
>> @@ -91,6 +92,8 @@ struct page_pool {
>>         unsigned long defer_warn;
>>
>>         u32 pages_state_hold_cnt;
>> +       unsigned int frag_offset;
>> +       struct page *frag_page;
>>
>>         /*
>>          * Data structure for allocation side
>> @@ -140,6 +143,17 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
>>         return page_pool_alloc_pages(pool, gfp);
>>  }
>>
>> +struct page *page_pool_alloc_frag(struct page_pool *pool,
>> +                                 unsigned int *offset, gfp_t gfp);
>> +
>> +static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
>> +                                                   unsigned int *offset)
>> +{
>> +       gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
>> +
>> +       return page_pool_alloc_frag(pool, offset, gfp);
>> +}
>> +
>>  /* get the stored dma direction. A driver might decide to treat this locally and
>>   * avoid the extra cache line from page_pool to determine the direction
>>   */
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index a87cbe1..b787033 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -350,6 +350,53 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
>>  }
>>  EXPORT_SYMBOL(page_pool_alloc_pages);
>>
>> +struct page *page_pool_alloc_frag(struct page_pool *pool,
>> +                                 unsigned int *offset, gfp_t gfp)
>> +{
>> +       unsigned int frag_offset = pool->frag_offset;
>> +       unsigned int frag_size = pool->p.frag_size;
>> +       struct page *frag_page = pool->frag_page;
>> +       unsigned int max_len = pool->p.max_len;
>> +
>> +       if (!frag_page || frag_offset + frag_size > max_len) {
>> +               frag_page = page_pool_alloc_pages(pool, gfp);
>> +               if (unlikely(!frag_page)) {
>> +                       pool->frag_page = NULL;
>> +                       return NULL;
>> +               }
>> +
>> +               pool->frag_page = frag_page;
>> +               frag_offset = 0;
>> +
>> +               page_pool_sub_bias(pool, frag_page,
>> +                                  max_len / frag_size - 1);
>> +       }
>> +
>> +       *offset = frag_offset;
>> +       pool->frag_offset = frag_offset + frag_size;
>> +
>> +       return frag_page;
>> +}
>> +EXPORT_SYMBOL(page_pool_alloc_frag);
> 
> I'm still not a fan of the fixed implementation. For the cost of the
> division as I said before you could make this flexible like
> page_frag_alloc_align and just decrement the bias by one per
> allocation instead of trying to batch it.
> 
> I'm sure there would likely be implementations that might need to
> operate at two different sizes, for example a header and payload size.

Will try to implement the frag allocation of different sizes
in new version.

> 
>> +static void page_pool_empty_frag(struct page_pool *pool)
>> +{
>> +       unsigned int frag_offset = pool->frag_offset;
>> +       unsigned int frag_size = pool->p.frag_size;
>> +       struct page *frag_page = pool->frag_page;
>> +       unsigned int max_len = pool->p.max_len;
>> +
>> +       if (!frag_page)
>> +               return;
>> +
>> +       while (frag_offset + frag_size <= max_len) {
>> +               page_pool_put_full_page(pool, frag_page, false);
>> +               frag_offset += frag_size;
>> +       }
>> +
> 
> Having to call this to free the page seems confusing. Rather than
> reserving multiple and having to free the page multiple times I really
> think you would be better off just holding one bias reservation on the
> page at a time.

will remove the above freeing the page multiple times.

> 
>> +       pool->frag_page = NULL;
>> +}
>> +
>>  /* Calculate distance between two u32 values, valid if distance is below 2^(31)
>>   *  https://en.wikipedia.org/wiki/Serial_number_arithmetic#General_Solution
>>   */
>> @@ -670,6 +717,8 @@ void page_pool_destroy(struct page_pool *pool)
>>         if (!page_pool_put(pool))
>>                 return;
>>
>> +       page_pool_empty_frag(pool);
>> +
>>         if (!page_pool_release(pool))
>>                 return;
>>
>> --
>> 2.7.4
>>
> .
> 
