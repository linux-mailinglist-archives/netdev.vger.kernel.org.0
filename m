Return-Path: <netdev+bounces-10694-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F4572FD84
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:55:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38E991C20C94
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B322883C;
	Wed, 14 Jun 2023 11:55:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBD81FD3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:55:24 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053961BF3;
	Wed, 14 Jun 2023 04:55:23 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Qh3hM3SHRztQq3;
	Wed, 14 Jun 2023 19:52:51 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 14 Jun
 2023 19:55:20 +0800
Subject: Re: [PATCH net-next v4 2/5] page_pool: unify frag_count handling in
 page_pool_is_last_frag()
To: Jakub Kicinski <kuba@kernel.org>
CC: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Alexander Duyck <alexander.duyck@gmail.com>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric
 Dumazet <edumazet@google.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-3-linyunsheng@huawei.com>
 <20230613213317.4eb4be7c@kernel.org>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <84100dd1-b005-5b03-fe3e-838a08640b8e@huawei.com>
Date: Wed, 14 Jun 2023 19:55:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230613213317.4eb4be7c@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/14 12:33, Jakub Kicinski wrote:
> On Mon, 12 Jun 2023 21:02:53 +0800 Yunsheng Lin wrote:
>>  static inline void page_pool_fragment_page(struct page *page, long nr)
>>  {
>> -	atomic_long_set(&page->pp_frag_count, nr);
>> +	if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
>> +		atomic_long_set(&page->pp_frag_count, nr);
> 
> why not let the driver take references on the page count in this case?
> I'm not saying it's worth the effort, but a comment may be useful?

I suppose page count refers to page->_refcount, right?
Page pool can only hold one reference for page->_refcount, so that
it can use that to decide if the netstack or other subsystem have
taken additional reference on that page in __page_pool_put_page():

https://elixir.bootlin.com/linux/v6.4-rc6/source/net/core/page_pool.c#L591

> 
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 9c4118c62997..69e3c5175236 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -352,6 +352,14 @@ static void page_pool_set_pp_info(struct page_pool *pool,
>>  {
>>  	page->pp = pool;
>>  	page->pp_magic |= PP_SIGNATURE;
>> +
>> +	/* Ensuring all pages have been split into one big frag initially:
> 
> Again, I find the "one big frag" slightly confusing.
> Maybe we should rename pp_frag_cnt into pp_refcnt?
> After this series is looks even more like a page pool reference
> count rather than some form of number of fragments.

It depends on how you look at it, perhaps we can see page->pp_frag_count
being one as the page being split into one frag?

Using pp_refcnt may cause confusing for cases in page_pool_alloc_frag().

> 
>> +	 * page_pool_set_pp_info() is only called once for every page when it
>> +	 * is allocated from the page allocator and page_pool_fragment_page()
>> +	 * is dirtying the same cache line as the page->pp_magic above, so
>> +	 * the overhead is negligible.
>> +	 */
>> +	page_pool_fragment_page(page, 1);
>>  	if (pool->p.init_callback)
>>  		pool->p.init_callback(page, pool->p.init_arg);
>>  }
> 
> 
> .
> 

