Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D333F4407
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 05:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhHWD5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 23:57:35 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8920 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbhHWD5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 23:57:34 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GtJGy4ljtz8t9b;
        Mon, 23 Aug 2021 11:52:42 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 23 Aug 2021 11:56:49 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 23 Aug
 2021 11:56:49 +0800
Subject: Re: [PATCH net-next v2 2/2] page_pool: optimize the cpu sync
 operation when DMA mapping
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <hawk@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>
References: <1629442611-61547-1-git-send-email-linyunsheng@huawei.com>
 <1629442611-61547-3-git-send-email-linyunsheng@huawei.com>
 <YR94YYRv2qpQtdSZ@Iliass-MBP>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <16468e57-49d8-0a23-0058-c920af99d74a@huawei.com>
Date:   Mon, 23 Aug 2021 11:56:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YR94YYRv2qpQtdSZ@Iliass-MBP>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/20 17:39, Ilias Apalodimas wrote:
> On Fri, Aug 20, 2021 at 02:56:51PM +0800, Yunsheng Lin wrote:
>> If the DMA_ATTR_SKIP_CPU_SYNC is not set, cpu syncing is
>> also done in dma_map_page_attrs(), so set the attrs according
>> to pool->p.flags to avoid calling cpu sync function again.
> 
> Isn't DMA_ATTR_SKIP_CPU_SYNC checked within dma_map_page_attrs() anyway?

Yes, the checking in dma_map_page_attrs() should save us from
calling dma_sync_single_for_device() again if we set the attrs
according to "pool->p.flags & PP_FLAG_DMA_SYNC_DEV".

As dma_sync_single_for_device() is EXPORT_SYMBOL()'ed, and
should be a no-op for dma coherent device, so there may be a
function calling overhead for dma coherent device, letting
dma_map_page_attrs() handling the sync seems to avoid the stack
pushing/poping overhead:

https://elixir.bootlin.com/linux/latest/source/kernel/dma/direct.h#L104

The one thing I am not sure about is that the pool->p.offset
and pool->p.max_len are used to decide the sync range before this
patch, while the sync range is the same as the map range when doing
the sync in dma_map_page_attrs().

I assumed the above is not a issue? only sync more than we need?
and it won't hurt the performance?

> 
> Regards
> /Ilias
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  net/core/page_pool.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 1a69784..3df5554 100644
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
>> +				 pool->p.dma_dir, attrs);
>>  	if (dma_mapping_error(pool->p.dev, dma))
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
>> -- 
>> 2.7.4
>>
> .
> 
