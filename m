Return-Path: <netdev+bounces-3503-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F1A707958
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:54:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E1342813B5
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82E038D;
	Thu, 18 May 2023 04:54:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974AC631
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:54:44 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595B52698;
	Wed, 17 May 2023 21:54:42 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QMHZh5zsKzTkxf;
	Thu, 18 May 2023 12:49:48 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 18 May
 2023 12:54:38 +0800
Subject: Re: [PATCH net-next 06/11] net: page_pool: avoid calling no-op
 externals when possible
To: Jakub Kicinski <kuba@kernel.org>, Alexander Lobakin
	<aleksander.lobakin@intel.com>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Maciej Fijalkowski
	<maciej.fijalkowski@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>, Larysa Zaremba
	<larysa.zaremba@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Christoph Hellwig <hch@lst.de>,
	<netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<linux-kernel@vger.kernel.org>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
 <20230516161841.37138-7-aleksander.lobakin@intel.com>
 <20230517210804.7de610bd@kernel.org>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b84ad4ef-a996-4fd7-dc90-3b44f7acaf39@huawei.com>
Date: Thu, 18 May 2023 12:54:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230517210804.7de610bd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/18 12:08, Jakub Kicinski wrote:
> On Tue, 16 May 2023 18:18:36 +0200 Alexander Lobakin wrote:
>> +		/* Try to avoid calling no-op syncs */
>> +		pool->p.flags |= PP_FLAG_DMA_MAYBE_SYNC;
>> +		pool->p.flags &= ~PP_FLAG_DMA_SYNC_DEV;
>>  	}
>>  
>>  	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
>> @@ -323,6 +327,12 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>>  
>>  	page_pool_set_dma_addr(page, dma);
>>  
>> +	if ((pool->p.flags & PP_FLAG_DMA_MAYBE_SYNC) &&
>> +	    dma_need_sync(pool->p.dev, dma)) {
>> +		pool->p.flags |= PP_FLAG_DMA_SYNC_DEV;
>> +		pool->p.flags &= ~PP_FLAG_DMA_MAYBE_SYNC;
>> +	}
> 
> is it just me or does it feel cleaner to allocate a page at init,
> and throw it into the cache, rather than adding a condition to a
> fast(ish) path?

Is dma_need_sync() not reliable until a dma map is called?
Is there any reason why not just clear PP_FLAG_DMA_SYNC_DEV if
dma_need_sync() is false without introducing the PP_FLAG_DMA_MAYBE_SYNC
flag?

> 
> .
> 

