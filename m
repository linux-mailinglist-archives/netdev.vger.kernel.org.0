Return-Path: <netdev+bounces-5872-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 160AE7133D7
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 727761C20FBB
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 09:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4CD8BEA;
	Sat, 27 May 2023 09:51:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAB120FA
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 09:51:43 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF03C3;
	Sat, 27 May 2023 02:51:40 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QSxnN2kbqzLq69;
	Sat, 27 May 2023 17:48:40 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sat, 27 May
 2023 17:51:37 +0800
Subject: Re: [PATCH net-next 2/2] page_pool: support non-frag page for
 page_pool_alloc_frag()
To: Alexander Duyck <alexander.duyck@gmail.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
References: <20230526092616.40355-1-linyunsheng@huawei.com>
 <20230526092616.40355-3-linyunsheng@huawei.com>
 <CAKgT0UfuNqY240nfhBoZfYoL5uZ5hSqPOafKY1=4kz6v0MsWxw@mail.gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <f264188a-7562-8031-3fec-f84683002f9a@huawei.com>
Date: Sat, 27 May 2023 17:51:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKgT0UfuNqY240nfhBoZfYoL5uZ5hSqPOafKY1=4kz6v0MsWxw@mail.gmail.com>
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

On 2023/5/26 23:16, Alexander Duyck wrote:
> On Fri, May 26, 2023 at 2:28 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> There is performance penalty with using page frag support when
>> user requests a larger frag size and a page only supports one
>> frag user, see [1].
>>
>> It seems like user may request different frag size depending
>> on the mtu and packet size, provide an option to allocate
>> non-frag page when a whole page is not able to hold two frags,
>> so that user has a unified interface for the memory allocation
>> with least memory utilization and performance penalty.
>>
>> 1. https://lore.kernel.org/netdev/ZEU+vospFdm08IeE@localhost.localdomain/
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> CC: Lorenzo Bianconi <lorenzo@kernel.org>
>> CC: Alexander Duyck <alexander.duyck@gmail.com>
> 
> The way I see it there are several problems with this approach.
> 
> First, why not just increase the page order rather than trying to
> essentially make page_pool_alloc_frag into an analog for
> page_pool_alloc_pages? I know for the skb allocator we are working
> with an order 3 page. You could likely do something similar here to
> achieve the better performance you are looking for.

I suppose the "an order 3 page" refers to __page_frag_cache_refill()
trying to allocate an order 3 page, if it fails, then fail back to
order 0 page?

As page pool alloc and recycle page in order based on pool->alloc
and pool->ring, so we can not do the above failback trick for page
pool.

We could add different pool->alloc/pool->ring for different order
page, for example, pool->alloc_order_0/pool->ring_order_0 for order
0 page, and pool->alloc_order_3/pool->ring_order_3 for order 3 page,
but then it will be complicated and possibly more memory wasteful.

We would also create page pool with pool->p.order being 3, then
the optimization in this patch also apply.

> 
> Second, I am not a fan of these changes as they seem to be wasteful
> for drivers that might make use of a mix of large and small

I suppose 'wasteful' refer to memory usage, right?
I am not sure how drivers that might make use a mix of large and
small yet, like mlx5 using page_pool_defrag_page() directly.
but if the PAGE_SIZE << pool->p.order is integral multiple of the frag,
then some waste seems to be unavoidable, does handling the frag count
in the driver save more memory than handling the frag count in page pool?
If not, handling the frag count in page pool seems more reasonable?

> allocations. If we aren't going to use fragments then we should
> probably just wrap the call to this function in an inline wrapper that
> checks the size and just automatically pulls the larger sizes off into
> the non-frag allocation path. Look at something such as
> __netdev_alloc_skb as an example.

Do you mean adding an new inline wrapper like below?

if (len > xxx)
	return page_pool_alloc_pages(pool, gfp);
else
	return page_pool_alloc_frag();

It seems the above is essentially the same as this patch does,
this patch does it by not introducing another interface and doing
some optimization. For example, for the above case with 'len > xxx'
in this patch, we still allow frag allocate if the remaining size of
the page is bigger than 'len', which I think it is a small optimization
for 64K page size or order 3 page.

Also, do you have some thing in mind above xxx here? As this patch
chooses the ((PAGE_SIZE << pool->p.order) / 2) as xxx.

> .
> 

