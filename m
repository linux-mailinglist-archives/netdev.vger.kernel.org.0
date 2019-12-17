Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B9E1221DF
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 03:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfLQCLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 21:11:20 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8131 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726445AbfLQCLU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 21:11:20 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6519298E236B0F6128C0;
        Tue, 17 Dec 2019 10:11:17 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 17 Dec 2019
 10:11:12 +0800
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Michal Hocko <mhocko@kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191216121557.GE30281@dhcp22.suse.cz> <20191216123426.GA18663@apalos.home>
 <20191216130845.GF30281@dhcp22.suse.cz> <20191216132128.GA19355@apalos.home>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <9041ea7f-0ca6-d0fe-9942-8907222ead5e@huawei.com>
Date:   Tue, 17 Dec 2019 10:11:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20191216132128.GA19355@apalos.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/16 21:21, Ilias Apalodimas wrote:
> On Mon, Dec 16, 2019 at 02:08:45PM +0100, Michal Hocko wrote:
>> On Mon 16-12-19 14:34:26, Ilias Apalodimas wrote:
>>> Hi Michal, 
>>> On Mon, Dec 16, 2019 at 01:15:57PM +0100, Michal Hocko wrote:
>>>> On Thu 12-12-19 09:34:14, Yunsheng Lin wrote:
>>>>> +CC Michal, Peter, Greg and Bjorn
>>>>> Because there has been disscusion about where and how the NUMA_NO_NODE
>>>>> should be handled before.
>>>>
>>>> I do not have a full context. What is the question here?
>>>
>>> When we allocate pages for the page_pool API, during the init, the driver writer
>>> decides which NUMA node to use. The API can,  in some cases recycle the memory,
>>> instead of freeing it and re-allocating it. If the NUMA node has changed (irq
>>> affinity for example), we forbid recycling and free the memory, since recycling
>>> and using memory on far NUMA nodes is more expensive (more expensive than
>>> recycling, at least on the architectures we tried anyway).
>>> Since this would be expensive to do it per packet, the burden falls on the 
>>> driver writer for that. Drivers *have* to call page_pool_update_nid() or 
>>> page_pool_nid_changed() if they want to check for that which runs once
>>> per NAPI cycle.
>>
>> Thanks for the clarification.
>>
>>> The current code in the API though does not account for NUMA_NO_NODE. That's
>>> what this is trying to fix.
>>> If the page_pool params are initialized with that, we *never* recycle
>>> the memory. This is happening because the API is allocating memory with 
>>> 'nid = numa_mem_id()' if NUMA_NO_NODE is configured so the current if statement
>>> 'page_to_nid(page) == pool->p.nid' will never trigger.
>>
>> OK. There is no explicit mention of the expected behavior for
>> NUMA_NO_NODE. The semantic is usually that there is no NUMA placement
>> requirement and the MM code simply starts the allocate from a local node
>> in that case. But the memory might come from any node so there is no
>> "local node" guarantee.
>>
>> So the main question is what is the expected semantic? Do people expect
>> that NUMA_NO_NODE implies locality? Why don't you simply always reuse
>> when there was no explicit numa requirement?

For driver that has not supported page pool yet, NUMA_NO_NODE seems to
imply locality, see [1].

And for those drivers, locality is decided by rx interrupt affinity, not
dev_to_node(). So when rx interrupt affinity changes, the old page from old
node will not be recycled(by checking page_to_nid(page) == numa_mem_id()),
new pages will be allocated to replace the old pages and the new pages will
be recycled because allocation and recycling happens in the same context,
which means numa_mem_id() returns the same node of new page allocated, see
[2].

As why not allocate and recycle page based on dev_to_node(), Jesper had
explained it better than me, see [3]:

"(Based on the optimizations done for Facebook (the reason we added this))
What seems to matter is the NUMA node of CPU that runs RX NAPI-polling,
this is the first CPU that touch the packet memory and struct-page
memory.  For these drivers, it is also the same "RX-CPU" that does the
allocation of new pages (to refill the RX-ring), and these "new" pages
can come from the page_pool."

So maybe the tricky part for page pool is to find the same context to
allocate and recycle pages, so that NUMA_NO_NODE can be used to allocate
pages and numa_mem_id() can be used to decide recycling. Or update the
node dynamically as proposed by Rongqing, see [4].


[1] https://elixir.bootlin.com/linux/v5.5-rc1/ident/dev_alloc_pages
[2] https://elixir.bootlin.com/linux/v5.5-rc1/source/drivers/net/ethernet/intel/i40e/i40e_txrx.c#L1856
[3] https://lkml.org/lkml/2019/12/13/132
[4] https://lkml.org/lkml/2019/12/15/353
>>
> 
> Well they shouldn't. Hence my next proposal. I think we are pretty much saying
> the same thing here. 
> If the driver defines NUMA_NO_NODE, just blindly recycle memory.

Not really. see above.

> 
>>> The initial proposal was to check:
>>> pool->p.nid == NUMA_NO_NODE && page_to_nid(page) == numa_mem_id()));
>>
>>> After that the thread span out of control :)
>>> My question is do we *really* have to check for 
>>> page_to_nid(page) == numa_mem_id()? if the architecture is not NUMA aware
>>> wouldn't pool->p.nid == NUMA_NO_NODE be enough?
>>
>> If the architecture is !NUMA then numa_mem_id and page_to_nid should
>> always equal and be both zero.

The tricky one is that dev_to_node() always return -1 when CONFIG_NUMA is
not defined, and some driver may use that to allocte page, and the node of
page may be checked with dev_to_node() to decide whether to recycle.

>>
> 
> Ditto
> 
>> -- 
>> Michal Hocko
>> SUSE Labs
> 
> 
> Thanks
> /Ilias
> 
> .
> 

