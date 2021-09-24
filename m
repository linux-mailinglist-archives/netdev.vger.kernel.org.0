Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F66A416CC8
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244339AbhIXHYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:24:53 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9918 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244191AbhIXHYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:24:52 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HG3Kv1gx2z8yn0;
        Fri, 24 Sep 2021 15:18:43 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 15:23:17 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Fri, 24 Sep
 2021 15:23:17 +0800
Subject: Re: [PATCH net-next 2/7] page_pool: support non-split page with
 PP_FLAG_PAGE_FRAG
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <brouer@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <jonathan.lemon@gmail.com>, <alobakin@pm.me>, <willemb@google.com>,
        <cong.wang@bytedance.com>, <pabeni@redhat.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
References: <20210922094131.15625-1-linyunsheng@huawei.com>
 <20210922094131.15625-3-linyunsheng@huawei.com>
 <c85a4ecc-80bb-d78f-d72a-0f820fb02eb9@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <2f5a4b07-7acf-1838-cb42-fd8b5d4ba4c6@huawei.com>
Date:   Fri, 24 Sep 2021 15:23:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <c85a4ecc-80bb-d78f-d72a-0f820fb02eb9@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/9/23 20:08, Jesper Dangaard Brouer wrote:
> 
> 
> On 22/09/2021 11.41, Yunsheng Lin wrote:
>> Currently when PP_FLAG_PAGE_FRAG is set, the caller is not
>> expected to call page_pool_alloc_pages() directly because of
>> the PP_FLAG_PAGE_FRAG checking in __page_pool_put_page().
>>
>> The patch removes the above checking to enable non-split page
>> support when PP_FLAG_PAGE_FRAG is set.
>>
>> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>   net/core/page_pool.c | 12 +++++++-----
>>   1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index a65bd7972e37..f7e71dcb6a2e 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -315,11 +315,14 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
>>         /* Fast-path: Get a page from cache */
>>       page = __page_pool_get_cached(pool);
>> -    if (page)
>> -        return page;
>>         /* Slow-path: cache empty, do real allocation */
>> -    page = __page_pool_alloc_pages_slow(pool, gfp);
>> +    if (!page)
>> +        page = __page_pool_alloc_pages_slow(pool, gfp);
>> +
>> +    if (likely(page))
>> +        page_pool_set_frag_count(page, 1);
>> +
> 
> I really don't like that you add one atomic_long_set operation per page alloc call.
> This is a fast-path for XDP use-cases, which you are ignoring as you drivers doesn't implement XDP.
> 
> As I cannot ask you to run XDP benchmarks, I fortunately have some page_pool specific microbenchmarks you can run instead.
> 
> I will ask you to provide before and after results from running these benchmarks [1] and [2].
> 
>  [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c
> 
>  [2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_cross_cpu.c
> 
> How to use these module is documented here[3]:
>  [3] https://prototype-kernel.readthedocs.io/en/latest/prototype-kernel/build-process.html

Will running these benchmarks to see if any performance overhead noticable here,
thanks for the benchmarks.

> 
>>       return page;
>>   }
>>   EXPORT_SYMBOL(page_pool_alloc_pages);
>> @@ -428,8 +431,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>>                unsigned int dma_sync_size, bool allow_direct)
>>   {
>>       /* It is not the last user for the page frag case */
>> -    if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
>> -        page_pool_atomic_sub_frag_count_return(page, 1))
>> +    if (page_pool_atomic_sub_frag_count_return(page, 1))
>>           return NULL;
> 
> This adds an atomic_long_read, even when PP_FLAG_PAGE_FRAG is not set.

The point here is to have consistent handling for both PP_FLAG_PAGE_FRAG
and non-PP_FLAG_PAGE_FRAG case in the following patch.

As the page->_refcount is accessed in "page_ref_count(page) == 1" checking
in __page_pool_put_page(), and page->pp_frag_count is most likely in the
same cache line as the page->_refcount, So I am not expecting a noticable
overhead here.

Anyway, will use the above benchmarks as an example to verify it.


> 
>>         /* This allocator is optimized for the XDP mode that uses
>>
> 
> .
> 
