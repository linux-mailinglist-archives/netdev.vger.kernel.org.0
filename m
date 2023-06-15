Return-Path: <netdev+bounces-10994-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A421730F82
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E775B1C20D9E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61B2635;
	Thu, 15 Jun 2023 06:39:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D1D375
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:39:17 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1660526B8;
	Wed, 14 Jun 2023 23:39:15 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QhXZF56rCzqTbg;
	Thu, 15 Jun 2023 14:34:13 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 14:39:12 +0800
Subject: Re: [PATCH net-next v3 3/4] page_pool: introduce page_pool_alloc()
 API
To: Alexander Duyck <alexander.duyck@gmail.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
References: <20230609131740.7496-1-linyunsheng@huawei.com>
 <20230609131740.7496-4-linyunsheng@huawei.com>
 <CAKgT0UfVwQ=ri7ZDNnsATH2RQpEz+zDBBb6YprvniMEWGdw+dQ@mail.gmail.com>
 <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com>
 <CAKgT0UdXTSv1fDHBX4UC6Ok9NXKMJ_9F88CEv5TK+mpzy0N21g@mail.gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c06f6f59-6c35-4944-8f7a-7f6f0e076649@huawei.com>
Date: Thu, 15 Jun 2023 14:39:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKgT0UdXTSv1fDHBX4UC6Ok9NXKMJ_9F88CEv5TK+mpzy0N21g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/14 22:18, Alexander Duyck wrote:
> On Tue, Jun 13, 2023 at 8:51 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2023/6/13 22:36, Alexander Duyck wrote:
>>> On Fri, Jun 9, 2023 at 6:20 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> ...
>>
>>>>
>>>> +static inline struct page *page_pool_alloc(struct page_pool *pool,
>>>> +                                          unsigned int *offset,
>>>> +                                          unsigned int *size, gfp_t gfp)
>>>> +{
>>>> +       unsigned int max_size = PAGE_SIZE << pool->p.order;
>>>> +       struct page *page;
>>>> +
>>>> +       *size = ALIGN(*size, dma_get_cache_alignment());
>>>> +
>>>> +       if (WARN_ON(*size > max_size))
>>>> +               return NULL;
>>>> +
>>>> +       if ((*size << 1) > max_size || PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
>>>> +               *size = max_size;
>>>> +               *offset = 0;
>>>> +               return page_pool_alloc_pages(pool, gfp);
>>>> +       }
>>>> +
>>>> +       page = __page_pool_alloc_frag(pool, offset, *size, gfp);
>>>> +       if (unlikely(!page))
>>>> +               return NULL;
>>>> +
>>>> +       /* There is very likely not enough space for another frag, so append the
>>>> +        * remaining size to the current frag to avoid truesize underestimate
>>>> +        * problem.
>>>> +        */
>>>> +       if (pool->frag_offset + *size > max_size) {
>>>> +               *size = max_size - *offset;
>>>> +               pool->frag_offset = max_size;
>>>> +       }
>>>> +
>>>
>>> Rather than preventing a truesize underestimation this will cause one.
>>> You are adding memory to the size of the page reserved and not
>>> accounting for it anywhere as this isn't reported up to the network
>>> stack. I would suggest dropping this from your patch.
>>
>> I was thinking about the driver author reporting it up to the network
>> stack using the new API as something like below:
>>
>> int truesize = size;
>> struct page *page;
>> int offset;
>>
>> page = page_pool_dev_alloc(pool, &offset, &truesize);
>> if (unlikely(!page))
>>         goto err;
>>
>> skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
>>                 offset, size, truesize);
>>
>> and similiar handling for *_build_skb() case too.
>>
>> Does it make senses for that? or did I miss something obvious here?
> 
> It is more the fact that you are creating a solution in search of a
> problem. As I said before most of the drivers will deal with these
> sorts of issues by just doing the fragmentation themselves or
> allocating fixed size frags and knowing how it will be divided into
> the page.

It seems that there are already some drivers which using the page pool
API with different frag size for almost every calling, the virtio_net
and veth are the obvious ones.

When reviewing the page frag support for virtio_net, I found that it
was manipulating the page_pool->frag_offset directly to do something
as this patch does, see:

https://lore.kernel.org/lkml/CAKhg4tL9PrUebqQHL+s7A6-xqNnju3erNQejMr7UFjwTaOduZw@mail.gmail.com/

I am not sure we are both agreed that drivers should not be manipulating
the page_pool->frag_offset directly unless it is really necessary?

For the specific case for virtio_net, it seems we have the below options:
1. both the driver and page pool do not handle it.
2. the driver handles it by manipulating the page_pool->frag_offset
   directly.
3. the page pool handles it as this patch does.

Is there any other options I missed for the specific case for virtio_net?
What is your perfer option? And why?

> 
> If you are going to go down this path then you should have a consumer
> for the API and fully implement it instead of taking half measures and
> making truesize underreporting worse by evicting pages earlier.

I am not sure I understand what do you mean by "a consumer for the API",
Do you mean adding a new API something like page_pool_free() to do
something ligthweight, such as decrementing the frag user and adjusting
the frag_offset, which is corresponding to the page_pool_alloc() API
introduced in this patch?
If yes, I was considering about that before, but I am not sure it worth
the effort, as for most usecase, it is a very rare case for error handling
as my understanding.

I just note that we already have page_pool_free() used by the page pool
destroy process，we might need to do something to avoid the confusion
between page_pool_alloc() and page_pool_free() :(

> 
> .
> 

