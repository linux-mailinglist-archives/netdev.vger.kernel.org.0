Return-Path: <netdev+bounces-7411-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2563C720202
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:24:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71520281864
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53FE918C30;
	Fri,  2 Jun 2023 12:23:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9FF156D7
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:23:57 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FC2136;
	Fri,  2 Jun 2023 05:23:53 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QXhxP669szTkn4;
	Fri,  2 Jun 2023 20:23:37 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 2 Jun
 2023 20:23:51 +0800
Subject: Re: [PATCH net-next v2 2/3] page_pool: support non-frag page for
 page_pool_alloc_frag()
To: Alexander Duyck <alexander.duyck@gmail.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-3-linyunsheng@huawei.com>
 <977d55210bfcb4f454b9d740fcbe6c451079a086.camel@gmail.com>
 <2e4f0359-151a-5cff-6d31-0ea0f014ef9a@huawei.com>
 <CAKgT0UcGYXstFP_H8VQtUooYEaYgDpG_crkodYOEyX4q0D58LQ@mail.gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <8c9d5dd8-b654-2d50-039d-9b7732e7746f@huawei.com>
Date: Fri, 2 Jun 2023 20:23:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKgT0UcGYXstFP_H8VQtUooYEaYgDpG_crkodYOEyX4q0D58LQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/2 2:14, Alexander Duyck wrote:
> On Wed, May 31, 2023 at 5:19 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:

...

>>
>>>
>>> If we have to have both version I would much rather just have some
>>> inline calls in the header wrapped in one #ifdef for
>>> PAGE_POOL_DMA_USE_PP_FRAG_COUNT that basically are a wrapper for
>>> page_pool pages treated as pp_frag.
>>
>> Do you have a good name in mind for that wrapper.
>> In addition to the naming, which API should I use when I am a driver
>> author wanting to add page pool support?
> 
> When I usually have to deal with these sort of things I just rename
> the original with a leading underscore or two and then just name the
> inline the same as the original function.

Ok, will follow the pattern if it is really necessary.

> 
>>>
>>>>      size = ALIGN(size, dma_get_cache_alignment());
>>>> -    *offset = pool->frag_offset;
>>>>
>>>
>>> If we are going to be allocating mono-frag pages they should be
>>> allocated here based on the size check. That way we aren't discrupting
>>> the performance for the smaller fragments and the code below could
>>> function undisturbed.
>>
>> It is to allow possible optimization as below.
> 
> What optimization? From what I can tell you are taking extra steps for
> non-page pool pages.

I will talk about the optimization later.

According to my defination in this patchset:
frag page: page alloced from page_pool_alloc_frag() with page->pp_frag_count
           being greater than one.
non-frag page:page alloced return from both page_pool_alloc_frag() and
              page_pool_alloc_pages() with page->pp_frag_count being one.

I assume the above 'non-page pool pages' refer to what I call as 'non-frag
page' alloced return from both page_pool_alloc_frag(), right? And it is
still about doing the (size << 1 > max_size)' checking at the begin instead
of at the middle right now to avoid extra steps for 'non-frag page' case?

> 
>>>
>>>> -    if (page && *offset + size > max_size) {
>>>> +    if (page) {
>>>> +            *offset = pool->frag_offset;
>>>> +
>>>> +            if (*offset + size <= max_size) {
>>>> +                    pool->frag_users++;
>>>> +                    pool->frag_offset = *offset + size;
>>>> +                    alloc_stat_inc(pool, fast);
>>>> +                    return page;
>>
>> Note that we still allow frag page here when '(size << 1 > max_size)'.

This is the optimization I was taking about: suppose we start
from a clean state with 64K page size, if page_pool_alloc_frag()
is called with size being 2K and then 34K, we only need one page
to satisfy caller's need as we do the '*offset + size > max_size'
checking before the '(size << 1 > max_size)' checking.

As you mentioned below, it is at the cost of evicting the previously
fragmented page, I thought about keeping it when implementing, but I
am not sure evicting it is really matter if the previously fragmented
page does not pass the testing by '*offset + size > max_size'?

Or maybe we should adjust the code a litte bit as below to allow the
optimization I mentioned without the cost of evicting the previously
fragmented page?

struct page *page_pool_alloc_frag(struct page_pool *pool,
                                  unsigned int *offset,
                                  unsigned int size, gfp_t gfp)
{
        unsigned int max_size = PAGE_SIZE << pool->p.order;
        struct page *page = pool->frag_page;

        if (unlikely(size > max_size))
                return NULL;

        if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
                goto alloc_non_frag;

        size = ALIGN(size, dma_get_cache_alignment());

        if (page && pool->frag_offset <= max_size) {
                *offset = pool->frag_offset;
                pool->frag_users++;
                pool->frag_offset += size;
                alloc_stat_inc(pool, fast);
                return page;
        }

        if (unlikely((size << 1) > max_size))
                goto alloc_non_frag;

        if (page) {
                page = page_pool_drain_frag(pool, page);
                if (page) {
                        alloc_stat_inc(pool, fast);
                        goto frag_reset;
                }
        }

        page = page_pool_alloc_pages(pool, gfp);
        if (unlikely(!page))
                return NULL;

        pool->frag_page = page;
frag_reset:
        pool->frag_users = 1;
        *offset = 0;
        pool->frag_offset = size;
        page_pool_fragment_page(page, BIAS_MAX);
        return page;

alloc_non_frag:
        *offset = 0;
        return page_pool_alloc_pages(pool, gfp);
}

> 
> You are creating what I call a mono-frag. I am not a huge fan.

Do you mean 'mono-frag' as the unifying of frag and non-frag
page handling by assuming all pages in page pool having one
frag user initially in patch 1?
If yes, please let's continue the discussion in pacth 1 so that
we don't have to restart the discussion again.

Or is there some other obvious concern about 'mono-frag' I missed?

> 
>>>> +            }
>>>> +
>>>> +            pool->frag_page = NULL;
>>>>              page = page_pool_drain_frag(pool, page);
>>>>              if (page) {
>>>>                      alloc_stat_inc(pool, fast);
>>>> @@ -714,26 +727,24 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
>>>>              }
>>>>      }
>>>>
>>>> -    if (!page) {
>>>> -            page = page_pool_alloc_pages(pool, gfp);
>>>> -            if (unlikely(!page)) {
>>>> -                    pool->frag_page = NULL;
>>>> -                    return NULL;
>>>> -            }
>>>> -
>>>> -            pool->frag_page = page;
>>>> +    page = page_pool_alloc_pages(pool, gfp);
>>>> +    if (unlikely(!page))
>>>> +            return NULL;
>>>>
>>>>  frag_reset:
>>>> -            pool->frag_users = 1;
>>>> +    /* return page as non-frag page if a page is not able to
>>>> +     * hold two frags for the current requested size.
>>>> +     */
>>>
>>> This statement ins't exactly true since you make all page pool pages
>>> into fragmented pages.
>>
>> Any suggestion to describe it more accurately?
>> I wrote that thinking frag_count being one as non-frag page.
> 
> I wouldn't consider that to be the case. The problem is if frag count
> == 1 then you have a fragmented page. It is no different from a page
> where you had either freed earlier instances.

It seems you still have some concern about the unifying in patch 1,
please do go and comment why it is not ok to assume 'frag count == 1'
as non-frag page in patch 1.

> 
>>>
>>>
>>>> +    if (unlikely(size << 1 > max_size)) {
>>>
>>> This should happen much sooner so you aren't mixing these allocations
>>> with the smaller ones and forcing the fragmented page to be evicted.
>>
>> As mentioned above, it is to allow a possible optimization
> 
> Maybe you should point out exactly what you think the optimization is.
> I don't see it as such. If you are going to evict anything that has a
> size that is over half your max_size then you might as well just skip
> using this entirely and just output a non-fragmented/mono frag page
> rather than evicting the previously fragmented page.

As explained as above.

> .
> 

