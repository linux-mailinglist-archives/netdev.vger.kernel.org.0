Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7E93C5394
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 12:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348128AbhGLHzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 03:55:13 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:11256 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344103AbhGLHrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 03:47:48 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GNbHr2mLHz1CJ2P;
        Mon, 12 Jul 2021 15:39:20 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 15:44:48 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 12 Jul
 2021 15:44:48 +0800
Subject: Re: [PATCH rfc v2 2/5] page_pool: add interface for getting and
 setting pagecnt_bias
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
 <1625903002-31619-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0UcRqRcj_zewRUH4Qe-AP_ykArK0hu76kcw2xjtvkTw07g@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c42e90ba-dd6a-b714-3e4e-3620661e8c6e@huawei.com>
Date:   Mon, 12 Jul 2021 15:44:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UcRqRcj_zewRUH4Qe-AP_ykArK0hu76kcw2xjtvkTw07g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/11 0:55, Alexander Duyck wrote:
> On Sat, Jul 10, 2021 at 12:44 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> As suggested by Alexander, "A DMA mapping should be page
>> aligned anyway so the lower 12 bits would be reserved 0",
>> so it might make more sense to repurpose the lower 12 bits
>> of the dma address to store the pagecnt_bias for elevated
>> refcnt case in page pool.
>>
>> As newly added page_pool_get_pagecnt_bias() may be called
>> outside of the softirq context, so annotate the access to
>> page->dma_addr[0] with READ_ONCE() and WRITE_ONCE().
>>
>> Other three interfaces using page->dma_addr[0] is only called
>> in the softirq context during normal rx processing, hopefully
>> the barrier in the rx processing will ensure the correct order
>> between getting and setting pagecnt_bias.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  include/net/page_pool.h | 24 ++++++++++++++++++++++--
>>  1 file changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index 8d7744d..5746f17 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -200,7 +200,7 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>>
>>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>>  {
>> -       dma_addr_t ret = page->dma_addr[0];
>> +       dma_addr_t ret = READ_ONCE(page->dma_addr[0]) & PAGE_MASK;
>>         if (sizeof(dma_addr_t) > sizeof(unsigned long))
>>                 ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
>>         return ret;
>> @@ -208,11 +208,31 @@ static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>>
>>  static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>>  {
>> -       page->dma_addr[0] = addr;
>> +       unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
>> +
>> +       dma_addr_0 &= ~PAGE_MASK;
>> +       dma_addr_0 |= (addr & PAGE_MASK);
> 
> So rather than doing all this testing and clearing it would probably
> be better to add a return value to the function and do something like:
> 
> if (WARN_ON(dma_addr_0 & ~PAGE_MASK))
>     return -1;
> 
> That way you could have page_pool_dma_map unmap, free the page, and
> return false indicating that the DMA mapping failed with a visible
> error in the event that our expectionat that the dma_addr is page
> aligned is ever violated.

I suppose the above is based on that page_pool_set_dma_addr() is called
only once before page_pool_set_pagecnt_bias(), right? so we could:

static inline bool page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
{
	if (WARN_ON(dma_addr_0 & ~PAGE_MASK))
		return false;

	page->dma_addr[0] = addr;
	if (sizeof(dma_addr_t) > sizeof(unsigned long))
		page->dma_addr[1] = upper_32_bits(addr);

	return true;
}

> 
>> +       WRITE_ONCE(page->dma_addr[0], dma_addr_0);
>> +
>>         if (sizeof(dma_addr_t) > sizeof(unsigned long))
>>                 page->dma_addr[1] = upper_32_bits(addr);
>>  }
>>
>> +static inline int page_pool_get_pagecnt_bias(struct page *page)
>> +{
>> +       return (READ_ONCE(page->dma_addr[0]) & ~PAGE_MASK);
> 
> You don't need the parenthesis around the READ_ONCE and PAGE_MASK.

ok.

> 
>> +}
>> +
>> +static inline void page_pool_set_pagecnt_bias(struct page *page, int bias)
>> +{
>> +       unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
>> +
>> +       dma_addr_0 &= PAGE_MASK;
>> +       dma_addr_0 |= (bias & ~PAGE_MASK);
>> +
>> +       WRITE_ONCE(page->dma_addr[0], dma_addr_0);
>> +}
>> +
>>  static inline bool is_page_pool_compiled_in(void)
>>  {
>>  #ifdef CONFIG_PAGE_POOL
>> --
>> 2.7.4
>>
> .
> 
