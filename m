Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 186481164C7
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 02:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfLIBbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 20:31:23 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:54162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726717AbfLIBbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Dec 2019 20:31:23 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 869B5C3A0546CC880ED7;
        Mon,  9 Dec 2019 09:31:21 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Mon, 9 Dec 2019
 09:31:16 +0800
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e724cb64-776d-176e-f55b-3c328d7c5298@huawei.com>
Date:   Mon, 9 Dec 2019 09:31:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/7 11:52, Saeed Mahameed wrote:
> On Fri, 2019-12-06 at 17:32 +0800, Li RongQing wrote:
>> some drivers uses page pool, but not require to allocate
>> pages from bound node, or simply assign pool.p.nid to
>> NUMA_NO_NODE, and the commit d5394610b1ba ("page_pool:
>> Don't recycle non-reusable pages") will block this kind
>> of driver to recycle
>>
>> so take page as reusable when page belongs to current
>> memory node if nid is NUMA_NO_NODE
>>
>> v1-->v2: add check with numa_mem_id from Yunsheng
>>
>> Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable pages")
>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>> Suggested-by: Yunsheng Lin <linyunsheng@huawei.com>
>> Cc: Saeed Mahameed <saeedm@mellanox.com>
>> ---
>>  net/core/page_pool.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index a6aefe989043..3c8b51ccd1c1 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -312,12 +312,17 @@ static bool __page_pool_recycle_direct(struct
>> page *page,
>>  /* page is NOT reusable when:
>>   * 1) allocated when system is under some pressure.
>> (page_is_pfmemalloc)
>>   * 2) belongs to a different NUMA node than pool->p.nid.
>> + * 3) belongs to a different memory node than current context
>> + * if pool->p.nid is NUMA_NO_NODE
>>   *
>>   * To update pool->p.nid users must call page_pool_update_nid.
>>   */
>>  static bool pool_page_reusable(struct page_pool *pool, struct page
>> *page)
>>  {
>> -	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool-
>>> p.nid;
>> +	return !page_is_pfmemalloc(page) &&
>> +		(page_to_nid(page) == pool->p.nid ||
>> +		(pool->p.nid == NUMA_NO_NODE &&
>> +		page_to_nid(page) == numa_mem_id()));
>>  }
>>  
> 
> Cc'ed Jesper, Ilias & Jonathan.
> 
> I don't think it is correct to check that the page nid is same as
> numa_mem_id() if pool is NUMA_NO_NODE. In such case we should allow all
> pages to recycle, because you can't assume where pages are allocated
> from and where they are being handled.
> 
> I suggest the following:
> 
> return !page_pfmemalloc() && 
> ( page_to_nid(page) == pool->p.nid || pool->p.nid == NUMA_NO_NODE );
> 
> 1) never recycle emergency pages, regardless of pool nid.
> 2) always recycle if pool is NUMA_NO_NODE.

As I can see, below are the cases that the pool->p.nid could be NUMA_NO_NODE:

1. kernel built with the CONFIG_NUMA being off.

2. kernel built with the CONFIG_NUMA being on, but FW/BIOS dose not provide
   a valid node id through ACPI/DT, and it has the below cases:

   a). the hardware itself is single numa node system, so maybe it is valid
       to not provide a valid node for the device.
   b). the hardware itself is multi numa nodes system, and the FW/BIOS is
       broken that it does not provide a valid one.

3. kernel built with the CONFIG_NUMA being on, and FW/BIOS dose provide a
   valid node id through ACPI/DT, but the driver does not pass the valid
   node id when calling page_pool_init().

I am not sure which case this patch is trying to fix, maybe Rongqing can
help to clarify.

For case 1 and case 2 (a), I suppose checking pool->p.nid being NUMA_NO_NODE
is enough.

For case 2 (b), There may be argument that it should be fixed in the BIOS/FW,
But it also can be argued that the numa_mem_id() checking has been done in the
driver that has not using page pool yet when deciding whether to do recycling,
see [1]. If I understanding correctly, recycling is normally done at the NAPI
pooling, which has the same affinity as the rx interrupt, and rx interrupt is
not changed very often. If it does change to different memory node, maybe it
makes sense not to recycle the old page belongs to old node?


For case 3, I am not sure if any driver is doing that, and if the page pool API
even allow that?

[1] https://elixir.bootlin.com/linux/latest/ident/numa_mem_id

> 
> the above change should not add any overhead, a modest branch predictor
> will handle this with no effort.
> 
> Jesper et al. what do you think?
> 
> -Saeed.
> 

