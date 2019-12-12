Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D2B11C23E
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfLLBeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:34:22 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7218 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727351AbfLLBeW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 20:34:22 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C297EAAC34B986444FA1;
        Thu, 12 Dec 2019 09:34:20 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 12 Dec 2019
 09:34:15 +0800
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <mhocko@kernel.org>, <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
Date:   Thu, 12 Dec 2019 09:34:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+CC Michal, Peter, Greg and Bjorn
Because there has been disscusion about where and how the NUMA_NO_NODE
should be handled before.

On 2019/12/12 5:24, Saeed Mahameed wrote:
> On Wed, 2019-12-11 at 19:49 +0100, Jesper Dangaard Brouer wrote:
>> On Sat, 7 Dec 2019 03:52:41 +0000
>> Saeed Mahameed <saeedm@mellanox.com> wrote:
>>
>>> I don't think it is correct to check that the page nid is same as
>>> numa_mem_id() if pool is NUMA_NO_NODE. In such case we should allow
>>> all
>>> pages to recycle, because you can't assume where pages are
>>> allocated
>>> from and where they are being handled.
>>
>> I agree, using numa_mem_id() is not valid, because it takes the numa
>> node id from the executing CPU and the call to __page_pool_put_page()
>> can happen on a remote CPU (e.g. cpumap redirect, and in future
>> SKBs).
>>
>>
>>> I suggest the following:
>>>
>>> return !page_pfmemalloc() && 
>>> ( page_to_nid(page) == pool->p.nid || pool->p.nid == NUMA_NO_NODE
>>> );
>>
>> Above code doesn't generate optimal ASM code, I suggest:
>>
>>  static bool pool_page_reusable(struct page_pool *pool, struct page
>> *page)
>>  {
>> 	return !page_is_pfmemalloc(page) &&
>> 		pool->p.nid != NUMA_NO_NODE &&
>> 		page_to_nid(page) == pool->p.nid;
>>  }
>>
> 
> this is not equivalent to the above. Here in case pool->p.nid is
> NUMA_NO_NODE, pool_page_reusable() will always be false.
> 
> We can avoid the extra check in data path.
> How about avoiding NUMA_NO_NODE in page_pool altogether, and force
> numa_mem_id() as pool->p.nid when user requests NUMA_NO_NODE at page
> pool init, as already done in alloc_pages_node(). 

That means we will not support page reuse migragtion for NUMA_NO_NODE,
which is not same semantic that alloc_pages_node() handle NUMA_NO_NODE,
because alloc_pages_node() will allocate the page based on the node
of the current running cpu.

Also, There seems to be a wild guessing of the node id here, which has
been disscussed before and has not reached a agreement yet.

> 
> which will imply recycling without adding any extra condition to the
> data path.
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index a6aefe989043..00c99282a306 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -28,6 +28,9 @@ static int page_pool_init(struct page_pool *pool,
>  
>         memcpy(&pool->p, params, sizeof(pool->p));
>  
> +	/* overwrite to allow recycling.. */
> +       if (pool->p.nid == NUMA_NO_NODE) 
> +               pool->p.nid = numa_mem_id(); 
> +
> 
> After a quick look, i don't see any reason why to keep NUMA_NO_NODE in
> pool->p.nid.. 
> 
> 
>> I have compiled different variants and looked at the A
>> SM code generated
>> by GCC.  This seems to give the best result.
>>
>>
>>> 1) never recycle emergency pages, regardless of pool nid.
>>> 2) always recycle if pool is NUMA_NO_NODE.
>>
>> Yes, this defines the semantics, that a page_pool configured with
>> NUMA_NO_NODE means skip NUMA checks.  I think that sounds okay...
>>
>>
>>> the above change should not add any overhead, a modest branch
>>> predictor will handle this with no effort.
>>
>> It still annoys me that we keep adding instructions to this code
>> hot-path (I counted 34 bytes and 11 instructions in my proposed
>> function).
>>
>> I think that it might be possible to move these NUMA checks to
>> alloc-side (instead of return/recycles side as today), and perhaps
>> only
>> on slow-path when dequeuing from ptr_ring (as recycles that call
>> __page_pool_recycle_direct() will be pinned during NAPI).  But lets
>> focus on a smaller fix for the immediate issue...
>>
> 
> I know. It annoys me too, but we need recycling to work in production :
> where rings/napi can migrate and numa nodes can be NUMA_NO_NODE :-(.
> 
> 

