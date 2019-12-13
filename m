Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2B611DCA8
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 04:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731777AbfLMDlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 22:41:07 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7230 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731357AbfLMDlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 22:41:06 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 30D258930D18FE1C2229;
        Fri, 13 Dec 2019 11:41:04 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Fri, 13 Dec 2019
 11:40:58 +0800
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <mhocko@kernel.org>, <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191212111831.2a9f05d3@carbon>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <7c555cb1-6beb-240d-08f8-7044b9087fe4@huawei.com>
Date:   Fri, 13 Dec 2019 11:40:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20191212111831.2a9f05d3@carbon>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/12 18:18, Jesper Dangaard Brouer wrote:
> On Thu, 12 Dec 2019 09:34:14 +0800
> Yunsheng Lin <linyunsheng@huawei.com> wrote:
> 
>> +CC Michal, Peter, Greg and Bjorn
>> Because there has been disscusion about where and how the NUMA_NO_NODE
>> should be handled before.
>>
>> On 2019/12/12 5:24, Saeed Mahameed wrote:
>>> On Wed, 2019-12-11 at 19:49 +0100, Jesper Dangaard Brouer wrote:  
>>>> On Sat, 7 Dec 2019 03:52:41 +0000
>>>> Saeed Mahameed <saeedm@mellanox.com> wrote:
>>>>  
>>>>> I don't think it is correct to check that the page nid is same as
>>>>> numa_mem_id() if pool is NUMA_NO_NODE. In such case we should allow
>>>>> all  pages to recycle, because you can't assume where pages are
>>>>> allocated from and where they are being handled.  
>>>>
>>>> I agree, using numa_mem_id() is not valid, because it takes the numa
>>>> node id from the executing CPU and the call to __page_pool_put_page()
>>>> can happen on a remote CPU (e.g. cpumap redirect, and in future
>>>> SKBs).
>>>>
>>>>  
>>>>> I suggest the following:
>>>>>
>>>>> return !page_pfmemalloc() && 
>>>>> ( page_to_nid(page) == pool->p.nid || pool->p.nid == NUMA_NO_NODE );  
>>>>
>>>> Above code doesn't generate optimal ASM code, I suggest:
>>>>
>>>>  static bool pool_page_reusable(struct page_pool *pool, struct page *page)
>>>>  {
>>>> 	return !page_is_pfmemalloc(page) &&
>>>> 		pool->p.nid != NUMA_NO_NODE &&
>>>> 		page_to_nid(page) == pool->p.nid;
>>>>  }
>>>>  
>>>
>>> this is not equivalent to the above. Here in case pool->p.nid is
>>> NUMA_NO_NODE, pool_page_reusable() will always be false.
>>>
>>> We can avoid the extra check in data path.
>>> How about avoiding NUMA_NO_NODE in page_pool altogether, and force
>>> numa_mem_id() as pool->p.nid when user requests NUMA_NO_NODE at page
>>> pool init, as already done in alloc_pages_node().   
>>
>> That means we will not support page reuse mitigation for NUMA_NO_NODE,
>> which is not same semantic that alloc_pages_node() handle NUMA_NO_NODE,
>> because alloc_pages_node() will allocate the page based on the node
>> of the current running cpu.
> 
> True, as I wrote (below) my code defines semantics as: that a page_pool
> configured with NUMA_NO_NODE means skip NUMA checks, and allow recycle
> regardless of NUMA node page belong to.  It seems that you want another
> semantics.

For driver that does not have page pool support yet, the semantics seems
to be: always allocate and recycle local page(excpet pfmemalloc one). Page
reuse migration moves when the rx interrupt affinity moves(the NAPI polling
context moves accordingly) regardless of the dev_to_node().

It would be good to maintain the above semantics. And rx data page seems
to be close to the cpu that doing the rx cleaning, which means the cpu
can process the buffer quicker?

> 
> I'm open to other semantics. My main concern is performance.  The
> page_pool fast-path for driver recycling use-case of XDP_DROP, have
> extreme performance requirements, as it needs to compete with driver
> local recycle tricks (else we cannot use page_pool to simplify drivers).
> The extreme performance target is 100Gbit/s = 148Mpps = 6.72ns, and
> in practice I'm measuring 25Mpps = 40ns with Mlx5 driver (single q),
> and Bjørn is showing 30 Mpps = 33.3ns with i40e.  At this level every
> cycle/instruction counts.

Yes, the performance is a concern too.
But if the rx page is closer to the cpu, maybe the time taken to process
the buffer can be reduced?

It is good to allocate the rx page close to both cpu and device, but if
both goal can not be reached, maybe we choose to allocate page that close
to cpu?

> 
>  
>> Also, There seems to be a wild guessing of the node id here, which has
>> been disscussed before and has not reached a agreement yet.
>>
>>>
>>> which will imply recycling without adding any extra condition to the
>>> data path.
> 
> I love code that moves thing out of our fast-path.
> 
>>>
>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>>> index a6aefe989043..00c99282a306 100644
>>> --- a/net/core/page_pool.c
>>> +++ b/net/core/page_pool.c
>>> @@ -28,6 +28,9 @@ static int page_pool_init(struct page_pool *pool,
>>>  
>>>         memcpy(&pool->p, params, sizeof(pool->p));
>>>  
>>> +	/* overwrite to allow recycling.. */
>>> +       if (pool->p.nid == NUMA_NO_NODE) 
>>> +               pool->p.nid = numa_mem_id(); 
>>> +
> 
> The problem is that page_pool_init() is can be initiated from a random
> CPU, first at driver setup/bringup, and later at other queue changes
> that can be started via ethtool or XDP attach. (numa_mem_id() picks
> from running CPU).

Yes, changing ring num or ring depth releases and allocates rx data page,
so using NUMA_NO_NODE to allocate page and alway recycle those page may
has different performance noticable to user.

> 
> As Yunsheng mentioned elsewhere, there is also a dev_to_node() function.
> Isn't that what we want in a place like this?
> 
> 
> One issue with dev_to_node() is that in case of !CONFIG_NUMA it returns
> NUMA_NO_NODE (-1).  (And device_initialize() also set it to -1).  Thus,
> in that case we set pool->p.nid = 0, as page_to_nid() will also return
> zero in that case (as far as I follow the code).
> 
> 
>>> After a quick look, i don't see any reason why to keep NUMA_NO_NODE in
>>> pool->p.nid.. 
>>>
>>>   
>>>> I have compiled different variants and looked at the ASM code
>>>> generated by GCC.  This seems to give the best result.
>>>>
>>>>  
>>>>> 1) never recycle emergency pages, regardless of pool nid.
>>>>> 2) always recycle if pool is NUMA_NO_NODE.  
>>>>
>>>> Yes, this defines the semantics, that a page_pool configured with
>>>> NUMA_NO_NODE means skip NUMA checks.  I think that sounds okay...
>>>>
>>>>  
>>>>> the above change should not add any overhead, a modest branch
>>>>> predictor will handle this with no effort.  
>>>>
>>>> It still annoys me that we keep adding instructions to this code
>>>> hot-path (I counted 34 bytes and 11 instructions in my proposed
>>>> function).
>>>>
>>>> I think that it might be possible to move these NUMA checks to
>>>> alloc-side (instead of return/recycles side as today), and perhaps
>>>> only on slow-path when dequeuing from ptr_ring (as recycles that
>>>> call __page_pool_recycle_direct() will be pinned during NAPI).
>>>> But lets focus on a smaller fix for the immediate issue...
>>>>  
>>>
>>> I know. It annoys me too, but we need recycling to work in
>>> production : where rings/napi can migrate and numa nodes can be
>>> NUMA_NO_NODE :-(.
>>>
>>>   
> 

