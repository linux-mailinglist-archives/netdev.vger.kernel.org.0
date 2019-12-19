Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A16812597D
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 03:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfLSCJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 21:09:38 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:38098 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726463AbfLSCJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 21:09:38 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D04168F00FB80AA0F132;
        Thu, 19 Dec 2019 10:09:35 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Dec 2019
 10:09:34 +0800
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
To:     Michal Hocko <mhocko@kernel.org>
CC:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
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
 <9041ea7f-0ca6-d0fe-9942-8907222ead5e@huawei.com>
 <20191217091131.GB31063@dhcp22.suse.cz>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <ff280412-bb31-5ffb-99f0-6d49bb470855@huawei.com>
Date:   Thu, 19 Dec 2019 10:09:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20191217091131.GB31063@dhcp22.suse.cz>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/17 17:11, Michal Hocko wrote:
> On Tue 17-12-19 10:11:12, Yunsheng Lin wrote:
>> On 2019/12/16 21:21, Ilias Apalodimas wrote:
>>> On Mon, Dec 16, 2019 at 02:08:45PM +0100, Michal Hocko wrote:
>>>> On Mon 16-12-19 14:34:26, Ilias Apalodimas wrote:
>>>>> Hi Michal, 
>>>>> On Mon, Dec 16, 2019 at 01:15:57PM +0100, Michal Hocko wrote:
>>>>>> On Thu 12-12-19 09:34:14, Yunsheng Lin wrote:
>>>>>>> +CC Michal, Peter, Greg and Bjorn
>>>>>>> Because there has been disscusion about where and how the NUMA_NO_NODE
>>>>>>> should be handled before.
>>>>>>
>>>>>> I do not have a full context. What is the question here?
>>>>>
>>>>> When we allocate pages for the page_pool API, during the init, the driver writer
>>>>> decides which NUMA node to use. The API can,  in some cases recycle the memory,
>>>>> instead of freeing it and re-allocating it. If the NUMA node has changed (irq
>>>>> affinity for example), we forbid recycling and free the memory, since recycling
>>>>> and using memory on far NUMA nodes is more expensive (more expensive than
>>>>> recycling, at least on the architectures we tried anyway).
>>>>> Since this would be expensive to do it per packet, the burden falls on the 
>>>>> driver writer for that. Drivers *have* to call page_pool_update_nid() or 
>>>>> page_pool_nid_changed() if they want to check for that which runs once
>>>>> per NAPI cycle.
>>>>
>>>> Thanks for the clarification.
>>>>
>>>>> The current code in the API though does not account for NUMA_NO_NODE. That's
>>>>> what this is trying to fix.
>>>>> If the page_pool params are initialized with that, we *never* recycle
>>>>> the memory. This is happening because the API is allocating memory with 
>>>>> 'nid = numa_mem_id()' if NUMA_NO_NODE is configured so the current if statement
>>>>> 'page_to_nid(page) == pool->p.nid' will never trigger.
>>>>
>>>> OK. There is no explicit mention of the expected behavior for
>>>> NUMA_NO_NODE. The semantic is usually that there is no NUMA placement
>>>> requirement and the MM code simply starts the allocate from a local node
>>>> in that case. But the memory might come from any node so there is no
>>>> "local node" guarantee.
>>>>
>>>> So the main question is what is the expected semantic? Do people expect
>>>> that NUMA_NO_NODE implies locality? Why don't you simply always reuse
>>>> when there was no explicit numa requirement?
>>
>> For driver that has not supported page pool yet, NUMA_NO_NODE seems to
>> imply locality, see [1].
> 
> Which is kinda awkward, no? Is there any reason for __dev_alloc_pages to
> not use numa_mem_id explicitly when the local node affinity is required?

Not sure why.

And it seems other places that uses NUMA_NO_NODE in the net code too.

grep -rn "NUMA_NO_NODE" net
net/openvswitch/flow_table.c:85:                                      node_online(0) ? 0 : NUMA_NO_NODE);
net/core/skbuff.c:436:          skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
net/core/skbuff.c:507:          skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
net/core/skbuff.c:1514:                                 skb_alloc_rx_flag(skb), NUMA_NO_NODE);
net/core/skbuff.c:1553: struct sk_buff *n = __alloc_skb(size, gfp_mask, flags, NUMA_NO_NODE);
net/core/skbuff.c:1629:                        gfp_mask, NUMA_NO_NODE, NULL);
net/core/skbuff.c:1747:                                 NUMA_NO_NODE);
net/core/skbuff.c:3811:                                    NUMA_NO_NODE);
net/core/skbuff.c:5720:                        gfp_mask, NUMA_NO_NODE, NULL);
net/core/skbuff.c:5844:                        gfp_mask, NUMA_NO_NODE, NULL);
net/core/dev.c:2378:                            NUMA_NO_NODE);
net/core/dev.c:2617:                                         numa_node_id : NUMA_NO_NODE);
net/core/dev.c:9117:    netdev_queue_numa_node_write(queue, NUMA_NO_NODE);
net/core/pktgen.c:3632: pkt_dev->node = NUMA_NO_NODE;
net/sunrpc/svc.c:296:   return NUMA_NO_NODE;
net/qrtr/qrtr.c:97:static unsigned int qrtr_local_nid = NUMA_NO_NODE;


> There is not real guarantee that NUMA_NO_NODE is going to imply local
> node and we do not want to grow any subtle dependency on that behavior.

Strictly speaking, using numa_mem_id() also does not have real guarantee
that it will allocate local memory when local memory is used up, right?
Because alloc_pages_node() is basically turning the node to numa_mem_id()
when it is NUMA_NO_NODE.

Unless we do not allow passing NUMA_NO_NODE to alloc_pages_node(), otherwise
I can not see difference between NUMA_NO_NODE and numa_mem_id().

> 
>> And for those drivers, locality is decided by rx interrupt affinity, not
>> dev_to_node(). So when rx interrupt affinity changes, the old page from old
>> node will not be recycled(by checking page_to_nid(page) == numa_mem_id()),
>> new pages will be allocated to replace the old pages and the new pages will
>> be recycled because allocation and recycling happens in the same context,
>> which means numa_mem_id() returns the same node of new page allocated, see
>> [2].
> 
> Well, but my understanding is that the generic page pool implementation
> has a clear means to change the affinity (namely page_pool_update_nid()).
> So my primary question is, why does NUMA_NO_NODE should be use as a
> bypass for that?

In that case, page_pool_update_nid() need to be called explicitly, which
may not be the reality, because for drivers using page pool now, mlx5 seems
to be the only one to call page_pool_update_nid(), which may lead to
copy & paste problem when not careful enough.


> 

