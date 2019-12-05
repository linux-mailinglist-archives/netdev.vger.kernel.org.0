Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFA7113967
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 02:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbfLEBn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 20:43:57 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:46968 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728098AbfLEBn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 20:43:56 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7F8D21C0E8F140E5CEEF;
        Thu,  5 Dec 2019 09:43:54 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Dec 2019
 09:43:53 +0800
Subject: =?UTF-8?Q?Re:_=e7=ad=94=e5=a4=8d:_[PATCH]_page=5fpool:_mark_unbound?=
 =?UTF-8?Q?_node_page_as_reusable_pages?=
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
References: <1575454465-15386-1-git-send-email-lirongqing@baidu.com>
 <d7836d35-ba21-69ab-8aba-457b2da6ffa1@huawei.com>
 <656e11b6605740b18ac7bb8e3b67ed93@baidu.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <f52fe7e8-2b6f-5e67-aa4b-38277478a7d1@huawei.com>
Date:   Thu, 5 Dec 2019 09:43:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <656e11b6605740b18ac7bb8e3b67ed93@baidu.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/5 9:08, Li,Rongqing wrote:
> 
> 
>> -----邮件原件-----
>> 发件人: Yunsheng Lin [mailto:linyunsheng@huawei.com]
>> 发送时间: 2019年12月5日 8:55
>> 收件人: Li,Rongqing <lirongqing@baidu.com>; netdev@vger.kernel.org;
>> saeedm@mellanox.com
>> 主题: Re: [PATCH] page_pool: mark unbound node page as reusable pages
>>
>> On 2019/12/4 18:14, Li RongQing wrote:
>>> some drivers uses page pool, but not require to allocate page from
>>> bound node, so pool.p.nid is NUMA_NO_NODE, and this fixed patch will
>>> block this kind of driver to recycle
>>>
>>> Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable pages")
>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>> Cc: Saeed Mahameed <saeedm@mellanox.com>
>>> ---
>>>  net/core/page_pool.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c index
>>> a6aefe989043..4054db683178 100644
>>> --- a/net/core/page_pool.c
>>> +++ b/net/core/page_pool.c
>>> @@ -317,7 +317,9 @@ static bool __page_pool_recycle_direct(struct page
>> *page,
>>>   */
>>>  static bool pool_page_reusable(struct page_pool *pool, struct page
>>> *page)  {
>>> -	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool->p.nid;
>>> +	return !page_is_pfmemalloc(page) &&
>>> +		(page_to_nid(page) == pool->p.nid ||
>>> +		 pool->p.nid == NUMA_NO_NODE);
>>
>> If I understand it correctly, you are allowing recycling when
>> pool->p.nid is NUMA_NO_NODE, which does not seems match the commit
>> log: "this fixed patch will block this kind of driver to recycle".
>>
>> Maybe you mean "commit d5394610b1ba" by this fixed patch?
> 
> yes
> 
>>
>> Also, maybe it is better to allow recycling if the below condition is matched:
>>
>> 	pool->p.nid == NUMA_NO_NODE && page_to_nid(page) ==
>> numa_mem_id()
> 
> If driver uses NUMA_NO_NODE, it does not care numa node, and maybe its platform
> Only has a node, so not need to compare like "page_to_nid(page) ==  numa_mem_id()"

Normally, driver does not care if the node of a device is NUMA_NO_NODE or not, it
just uses the node that returns from dev_to_node().

Even for multi node system, the node of a device may be NUMA_NO_NODE when
BIOS/FW has not specified it through ACPI/DT, see [1].


[1] https://lore.kernel.org/patchwork/patch/1141952/

> 
> 
> -RongQing
> 
> 
>>
>>>  }
>>>
>>>  void __page_pool_put_page(struct page_pool *pool, struct page *page,
>>>
> 

