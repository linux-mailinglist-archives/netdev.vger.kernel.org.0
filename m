Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C573F26CA
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 08:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbhHTGa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 02:30:28 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8054 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbhHTGa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 02:30:27 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GrWv454RszYrg7;
        Fri, 20 Aug 2021 14:29:20 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 14:29:47 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 20 Aug
 2021 14:29:47 +0800
Subject: Re: [PATCH net-next 2/2] page_pool: optimize the cpu sync operation
 when DMA mapping
To:     Heiner Kallweit <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1629425195-10130-1-git-send-email-linyunsheng@huawei.com>
 <1629425195-10130-3-git-send-email-linyunsheng@huawei.com>
 <badfd7fd-ff25-f399-8828-9f44180d6948@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <7a58fbbd-f5d2-1826-1168-ec5da52b794e@huawei.com>
Date:   Fri, 20 Aug 2021 14:29:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <badfd7fd-ff25-f399-8828-9f44180d6948@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme717-chm.china.huawei.com (10.1.199.113) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/20 14:10, Heiner Kallweit wrote:
> On 20.08.2021 04:06, Yunsheng Lin wrote:
>> If the DMA_ATTR_SKIP_CPU_SYNC is not set, cpu syncing is
>> also done in dma_map_page_attrs(), so set the attrs according
>> to pool->p.flags to avoid calling dma sync function again.
>>
>> Also mark the dma error as the unlikely case While we are at
>> it.
>>
> This shouldn't be needed. dma_mapping_error() will be (most likely)
> inlined by the compiler, and it includes the unlikely() hint.

Good point, will remove the unlikely() mark.
Thanks.

> 
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  net/core/page_pool.c | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 1a69784..8172045 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -191,8 +191,12 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
>>  
>>  static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>>  {
>> +	unsigned long attrs = DMA_ATTR_SKIP_CPU_SYNC;
>>  	dma_addr_t dma;
>>  
>> +	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>> +		attrs = 0;
>> +
>>  	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
>>  	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
>>  	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
>> @@ -200,15 +204,12 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>>  	 */
>>  	dma = dma_map_page_attrs(pool->p.dev, page, 0,
>>  				 (PAGE_SIZE << pool->p.order),
>> -				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
>> -	if (dma_mapping_error(pool->p.dev, dma))
>> +				 pool->p.dma_dir, attrs);
>> +	if (unlikely(dma_mapping_error(pool->p.dev, dma)))
>>  		return false;
>>  
>>  	page_pool_set_dma_addr(page, dma);
>>  
>> -	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>> -		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
>> -
>>  	return true;
>>  }
>>  
>>
> 
> .
> 
