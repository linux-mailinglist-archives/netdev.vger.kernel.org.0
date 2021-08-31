Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AF03FC286
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 08:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhHaGPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 02:15:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8801 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhHaGPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 02:15:33 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GzH294r93zYwCN;
        Tue, 31 Aug 2021 14:13:53 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 31 Aug 2021 14:14:34 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Tue, 31 Aug
 2021 14:14:34 +0800
Subject: Re: [PATCH net-next 1/2] page_pool: support non-split page with
 PP_FLAG_PAGE_FRAG
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Kevin Hao" <haokexin@gmail.com>, <nogikh@google.com>,
        Marco Elver <elver@google.com>, <memxor@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>
References: <1630286290-43714-1-git-send-email-linyunsheng@huawei.com>
 <1630286290-43714-2-git-send-email-linyunsheng@huawei.com>
 <CAKgT0UfNFw+jwoDr_xx6kX_OoCVgrq2rCSc4zdXRMSZLBmbA8Q@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e0f927bb-7a03-de00-d62a-d2235a0f4d8c@huawei.com>
Date:   Tue, 31 Aug 2021 14:14:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UfNFw+jwoDr_xx6kX_OoCVgrq2rCSc4zdXRMSZLBmbA8Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/30 23:05, Alexander Duyck wrote:
> On Sun, Aug 29, 2021 at 6:19 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> Currently when PP_FLAG_PAGE_FRAG is set, the caller is not
>> expected to call page_pool_alloc_pages() directly because of
>> the PP_FLAG_PAGE_FRAG checking in __page_pool_put_page().
>>
>> The patch removes the above checking to enable non-split page
>> support when PP_FLAG_PAGE_FRAG is set.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  include/net/page_pool.h |  6 ++++++
>>  net/core/page_pool.c    | 12 +++++++-----
>>  2 files changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index a408240..2ad0706 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -238,6 +238,9 @@ static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>>
>>  static inline void page_pool_set_frag_count(struct page *page, long nr)
>>  {
>> +       if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
>> +               return;
>> +
>>         atomic_long_set(&page->pp_frag_count, nr);
>>  }
>>
>> @@ -246,6 +249,9 @@ static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>>  {
>>         long ret;
>>
>> +       if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
>> +               return 0;
>> +
>>         /* As suggested by Alexander, atomic_long_read() may cover up the
>>          * reference count errors, so avoid calling atomic_long_read() in
>>          * the cases of freeing or draining the page_frags, where we would
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 1a69784..ba9f14d 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -313,11 +313,14 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
>>
>>         /* Fast-path: Get a page from cache */
>>         page = __page_pool_get_cached(pool);
>> -       if (page)
>> -               return page;
>>
>>         /* Slow-path: cache empty, do real allocation */
>> -       page = __page_pool_alloc_pages_slow(pool, gfp);
>> +       if (!page)
>> +               page = __page_pool_alloc_pages_slow(pool, gfp);
>> +
>> +       if (likely(page))
>> +               page_pool_set_frag_count(page, 1);
>> +
>>         return page;
>>  }
>>  EXPORT_SYMBOL(page_pool_alloc_pages);
>> @@ -426,8 +429,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>>                      unsigned int dma_sync_size, bool allow_direct)
>>  {
>>         /* It is not the last user for the page frag case */
>> -       if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
>> -           page_pool_atomic_sub_frag_count_return(page, 1))
>> +       if (page_pool_atomic_sub_frag_count_return(page, 1))
>>                 return NULL;
> 
> Isn't this going to have a negative performance impact on page pool
> pages in general? Essentially you are adding an extra atomic operation
> for all the non-frag pages.
> 
> It would work better if this was doing a check against 1 to determine
> if it is okay for this page to be freed here and only if the check
> fails then you perform the atomic sub_return.

The page_pool_atomic_sub_frag_count_return() has added the optimization
to not do the atomic sub_return when the caller is the last user of the
page, see page_pool_atomic_sub_frag_count_return():

	/* As suggested by Alexander, atomic_long_read() may cover up the
	 * reference count errors, so avoid calling atomic_long_read() in
	 * the cases of freeing or draining the page_frags, where we would
	 * not expect it to match or that are slowpath anyway.
	 */
        if (__builtin_constant_p(nr) &&
            atomic_long_read(&page->pp_frag_count) == nr)
                return 0;

So the check against 1 is not needed here?

> .
> 
