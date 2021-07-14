Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5063C7E82
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 08:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbhGNG1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 02:27:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11410 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238003AbhGNG1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 02:27:12 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GPnSX0VS5zccty;
        Wed, 14 Jul 2021 14:21:00 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 14:24:17 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 14:24:16 +0800
Subject: Re: [PATCH rfc v4 2/4] page_pool: add interface to manipulate bias in
 page pool
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
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        <kpsingh@kernel.org>, <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>, <songliubraving@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1626168272-25622-1-git-send-email-linyunsheng@huawei.com>
 <1626168272-25622-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0UevHk7n=Lnfkvw1t04HvRCX9vtyc0a6_2cda3c6hgDdJg@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5bdaac3b-1148-4cbd-ca67-9c06e67933fb@huawei.com>
Date:   Wed, 14 Jul 2021 14:24:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UevHk7n=Lnfkvw1t04HvRCX9vtyc0a6_2cda3c6hgDdJg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme705-chm.china.huawei.com (10.1.199.101) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/14 2:41, Alexander Duyck wrote:
> On Tue, Jul 13, 2021 at 2:25 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> As suggested by Alexander, "A DMA mapping should be page
>> aligned anyway so the lower 12 bits would be reserved 0",
>> so it might make more sense to repurpose the lower 12 bits
>> of the dma address to store the bias for frag page support
>> in page pool for 32 bit systems with 64 bit dma, which
>> should be rare those days.
>>
>> For normal system, the dma_addr[1] in 'struct page' is not
>> used, so we can reuse the dma_addr[1] for storing bias.
>>
>> The PAGE_POOP_USE_DMA_ADDR_1 macro is used to decide where
>> to store the bias, as the "sizeof(dma_addr_t) > sizeof(
>> unsigned long)" is false for normal system, so hopefully the
>> compiler will optimize out the unused code for those system.
> 
> I assume the name is a typo and you meant PAGE_POOL_USE_DMA_ADDR_1?

Yes, will use the PAGE_POOL_DMA_USE_PP_FRAG_COUNT you suggested below.

> 
>> The newly added page_pool_set_bias() should be called before
>> the page is passed to any user. Otherwise, call the newly
>> added page_pool_atomic_sub_bias_return().
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  include/net/page_pool.h | 70 ++++++++++++++++++++++++++++++++++++++++++++++---
>>  net/core/page_pool.c    | 10 +++++++
>>  2 files changed, 77 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index 8d7744d..315b9f2 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -198,21 +198,85 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>>         page_pool_put_full_page(pool, page, true);
>>  }
>>
>> +#define PAGE_POOP_USE_DMA_ADDR_1       (sizeof(dma_addr_t) > sizeof(unsigned long))
>> +
>>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>>  {
>> -       dma_addr_t ret = page->dma_addr[0];
>> -       if (sizeof(dma_addr_t) > sizeof(unsigned long))
>> +       dma_addr_t ret;
>> +
>> +       if (PAGE_POOP_USE_DMA_ADDR_1) {
>> +               ret = READ_ONCE(page->dma_addr[0]) & PAGE_MASK;
>>                 ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
> 
> Alternatively we could change things a bit and rename things so we
> have the MSB of dma_addr where dma_addr[1] is and we rename
> dma_addr[0] to pp_frag_count we could have it also contain the lower
> bits and handle it like so:
>     ret = page->dma_addr;
>     if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
>         ret <<= 32;
>         ret |= atomic_long_read(&page->pp_frag_count) & PAGE_MASK;
>     }

Ok, it seems better.

> 
>> +       } else {
>> +               ret = page->dma_addr[0];
>> +       }
>> +
>>         return ret;
>>  }
>>
>>  static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>>  {
>>         page->dma_addr[0] = addr;
>> -       if (sizeof(dma_addr_t) > sizeof(unsigned long))
>> +       if (PAGE_POOP_USE_DMA_ADDR_1)
>>                 page->dma_addr[1] = upper_32_bits(addr);
> 
> So assuming similar logic to above we could do something like:
>     if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
>         atomic_long_set(&page->pp_frag_count, addr & PAGE_MASK);
>         addr >>= 32;
>     }
>     pp->dma_addr = addr;

ok.

> 
>>  }
>>
>> +static inline int page_pool_atomic_sub_bias_return(struct page *page, int nr)
>> +{
>> +       int bias;
>> +
>> +       if (PAGE_POOP_USE_DMA_ADDR_1) {
>> +               unsigned long *bias_ptr = &page->dma_addr[0];
>> +               unsigned long old_bias = READ_ONCE(*bias_ptr);
>> +               unsigned long new_bias;
>> +
>> +               do {
>> +                       bias = (int)(old_bias & ~PAGE_MASK);
>> +
>> +                       /* Warn when page_pool_dev_alloc_pages() is called
>> +                        * with PP_FLAG_PAGE_FRAG flag in driver.
>> +                        */
>> +                       WARN_ON(!bias);
>> +
>> +                       /* already the last user */
>> +                       if (!(bias - nr))
>> +                               return 0;
>> +
>> +                       new_bias = old_bias - nr;
>> +               } while (!try_cmpxchg(bias_ptr, &old_bias, new_bias));
>> +
>> +               WARN_ON((new_bias & PAGE_MASK) != (old_bias & PAGE_MASK));
>> +
>> +               bias = new_bias & ~PAGE_MASK;
>> +       } else {
>> +               atomic_t *v = (atomic_t *)&page->dma_addr[1];
> 
> The problem with casting like this is that it makes assumptions about
> byte ordering in the case that atomic_t is a 32b value and dma_addr is
> a long value.

Will define a pp_frag_count as type of atomic_long_t to replace
dma_addr[1].

> 
>> +
>> +               if (atomic_read(v) == nr)
>> +                       return 0;
>> +
>> +               bias = atomic_sub_return(nr, v);
>> +               WARN_ON(bias < 0);
>> +       }
> 
> Rather than have 2 versions of this function it might work better to
> just use the atomic_long version of these functions instead. Then you
> shouldn't need to have two versions of the code.
> 
> You could just modify the block on the end to check for new_frag_count
> vs old_frag_count if PAGE_POOL_USE_PP_FRAG_COUNT is true, or
> new_frag_count < 0 if false.

When implementing the above, it seems it may still be better to have two
big blocks when both are using the atomic_long_sub_return(), otherwise we
may have many small blocks.

> 
>> +
>> +       return bias;
>> +}
>> +
>> +static inline void page_pool_set_bias(struct page *page, int bias)
>> +{
>> +       if (PAGE_POOP_USE_DMA_ADDR_1) {
>> +               unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
>> +
>> +               dma_addr_0 &= PAGE_MASK;
>> +               dma_addr_0 |= bias;
>> +
>> +               WRITE_ONCE(page->dma_addr[0], dma_addr_0);
>> +       } else {
>> +               atomic_t *v = (atomic_t *)&page->dma_addr[1];
>> +
>> +               atomic_set(v, bias);
>> +       }
> 
> Similarly here you could just update bias to include the dma_addr in
> the if case, and then use atomic_long_set for both cases.

ok.

> 
>> +}
>> +
>>  static inline bool is_page_pool_compiled_in(void)
>>  {
>>  #ifdef CONFIG_PAGE_POOL
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 78838c6..6ac5b00 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -198,6 +198,16 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>>         if (dma_mapping_error(pool->p.dev, dma))
>>                 return false;
>>
>> +       if (PAGE_POOP_USE_DMA_ADDR_1 &&
>> +           WARN_ON(pool->p.flags & PP_FLAG_PAGE_FRAG &&
>> +                   dma & ~PAGE_MASK)) {
>> +               dma_unmap_page_attrs(pool->p.dev, dma,
>> +                                    PAGE_SIZE << pool->p.order,
>> +                                    pool->p.dma_dir,
>> +                                    DMA_ATTR_SKIP_CPU_SYNC);
>> +               return false;
>> +       }
>> +
>>         page_pool_set_dma_addr(page, dma);
>>
>>         if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>> --
>> 2.7.4
>>
> .
> 
