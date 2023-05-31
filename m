Return-Path: <netdev+bounces-6785-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88AF3717FBB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2056B1C20E4E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E071428E;
	Wed, 31 May 2023 12:19:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DB81428A
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:19:13 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9241B121;
	Wed, 31 May 2023 05:19:10 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QWSvH6GS3zLlkV;
	Wed, 31 May 2023 20:17:31 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 31 May
 2023 20:19:07 +0800
Subject: Re: [PATCH net-next v2 2/3] page_pool: support non-frag page for
 page_pool_alloc_frag()
To: Alexander H Duyck <alexander.duyck@gmail.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-3-linyunsheng@huawei.com>
 <977d55210bfcb4f454b9d740fcbe6c451079a086.camel@gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <2e4f0359-151a-5cff-6d31-0ea0f014ef9a@huawei.com>
Date: Wed, 31 May 2023 20:19:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <977d55210bfcb4f454b9d740fcbe6c451079a086.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/30 23:07, Alexander H Duyck wrote:
...

>> +	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
>> +		*offset = 0;
>> +		return page_pool_alloc_pages(pool, gfp);
>> +	}
>> +
> 
> This is a recipe for pain. Rather than doing this I would say we should
> stick with our existing behavior and not allow page pool fragments to
> be used when the DMA address is consuming the region. Otherwise we are
> going to make things very confusing.

Are there any other concern other than confusing? we could add a
big comment to make it clear.

The point of adding that is to avoid the driver handling the
PAGE_POOL_DMA_USE_PP_FRAG_COUNT when using page_pool_alloc_frag()
like something like below:

if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
	page = page_pool_alloc_frag()
else
	page = XXXXX;

Or do you perfer the driver handling it? why?

> 
> If we have to have both version I would much rather just have some
> inline calls in the header wrapped in one #ifdef for
> PAGE_POOL_DMA_USE_PP_FRAG_COUNT that basically are a wrapper for
> page_pool pages treated as pp_frag.

Do you have a good name in mind for that wrapper.
In addition to the naming, which API should I use when I am a driver
author wanting to add page pool support?

> 
>>  	size = ALIGN(size, dma_get_cache_alignment());
>> -	*offset = pool->frag_offset;
>>  
> 
> If we are going to be allocating mono-frag pages they should be
> allocated here based on the size check. That way we aren't discrupting
> the performance for the smaller fragments and the code below could
> function undisturbed.

It is to allow possible optimization as below.

> 
>> -	if (page && *offset + size > max_size) {
>> +	if (page) {
>> +		*offset = pool->frag_offset;
>> +
>> +		if (*offset + size <= max_size) {
>> +			pool->frag_users++;
>> +			pool->frag_offset = *offset + size;
>> +			alloc_stat_inc(pool, fast);
>> +			return page;

Note that we still allow frag page here when '(size << 1 > max_size)'.

>> +		}
>> +
>> +		pool->frag_page = NULL;
>>  		page = page_pool_drain_frag(pool, page);
>>  		if (page) {
>>  			alloc_stat_inc(pool, fast);
>> @@ -714,26 +727,24 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
>>  		}
>>  	}
>>  
>> -	if (!page) {
>> -		page = page_pool_alloc_pages(pool, gfp);
>> -		if (unlikely(!page)) {
>> -			pool->frag_page = NULL;
>> -			return NULL;
>> -		}
>> -
>> -		pool->frag_page = page;
>> +	page = page_pool_alloc_pages(pool, gfp);
>> +	if (unlikely(!page))
>> +		return NULL;
>>  
>>  frag_reset:
>> -		pool->frag_users = 1;
>> +	/* return page as non-frag page if a page is not able to
>> +	 * hold two frags for the current requested size.
>> +	 */
> 
> This statement ins't exactly true since you make all page pool pages
> into fragmented pages.

Any suggestion to describe it more accurately?
I wrote that thinking frag_count being one as non-frag page.

> 
> 
>> +	if (unlikely(size << 1 > max_size)) {
> 
> This should happen much sooner so you aren't mixing these allocations
> with the smaller ones and forcing the fragmented page to be evicted.

As mentioned above, it is to allow a possible optimization

