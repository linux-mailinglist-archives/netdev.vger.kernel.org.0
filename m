Return-Path: <netdev+bounces-10584-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2306A72F341
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5395B1C20B3A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ACFF64C;
	Wed, 14 Jun 2023 03:51:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE3C363
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:51:55 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C943EC3;
	Tue, 13 Jun 2023 20:51:53 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QgryV6Hk2ztQdJ;
	Wed, 14 Jun 2023 11:49:22 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 14 Jun
 2023 11:51:51 +0800
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
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com>
Date: Wed, 14 Jun 2023 11:51:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKgT0UfVwQ=ri7ZDNnsATH2RQpEz+zDBBb6YprvniMEWGdw+dQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/13 22:36, Alexander Duyck wrote:
> On Fri, Jun 9, 2023 at 6:20 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:

...

>>
>> +static inline struct page *page_pool_alloc(struct page_pool *pool,
>> +                                          unsigned int *offset,
>> +                                          unsigned int *size, gfp_t gfp)
>> +{
>> +       unsigned int max_size = PAGE_SIZE << pool->p.order;
>> +       struct page *page;
>> +
>> +       *size = ALIGN(*size, dma_get_cache_alignment());
>> +
>> +       if (WARN_ON(*size > max_size))
>> +               return NULL;
>> +
>> +       if ((*size << 1) > max_size || PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
>> +               *size = max_size;
>> +               *offset = 0;
>> +               return page_pool_alloc_pages(pool, gfp);
>> +       }
>> +
>> +       page = __page_pool_alloc_frag(pool, offset, *size, gfp);
>> +       if (unlikely(!page))
>> +               return NULL;
>> +
>> +       /* There is very likely not enough space for another frag, so append the
>> +        * remaining size to the current frag to avoid truesize underestimate
>> +        * problem.
>> +        */
>> +       if (pool->frag_offset + *size > max_size) {
>> +               *size = max_size - *offset;
>> +               pool->frag_offset = max_size;
>> +       }
>> +
> 
> Rather than preventing a truesize underestimation this will cause one.
> You are adding memory to the size of the page reserved and not
> accounting for it anywhere as this isn't reported up to the network
> stack. I would suggest dropping this from your patch.

I was thinking about the driver author reporting it up to the network
stack using the new API as something like below:

int truesize = size;
struct page *page;
int offset;

page = page_pool_dev_alloc(pool, &offset, &truesize);
if (unlikely(!page))
	goto err;

skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
		offset, size, truesize);

and similiar handling for *_build_skb() case too.

Does it make senses for that? or did I miss something obvious here?


> 

