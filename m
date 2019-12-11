Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0237F11A2D2
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 04:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfLKDBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 22:01:20 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7663 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726974AbfLKDBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 22:01:20 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0F8CAC025CD6E66F5CAB;
        Wed, 11 Dec 2019 11:01:18 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 11 Dec 2019
 11:01:16 +0800
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191209131416.238d4ae4@carbon>
 <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
 <e9855bd9-dddd-e12c-c889-b872702f80d1@huawei.com>
 <585eda1ebe8788959b31bca5bb6943908c08c909.camel@mellanox.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <910156da-0b43-0a86-67a0-f4e7e6547373@huawei.com>
Date:   Wed, 11 Dec 2019 11:01:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <585eda1ebe8788959b31bca5bb6943908c08c909.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/11 3:45, Saeed Mahameed wrote:
>>> maybe assume that __page_pool_recycle_direct() is always called
>>> from
>>> the right node and change the current bogus check:
>>>
>>> from:
>>> page_to_nid(page) == pool->p.nid 
>>>
>>> to:
>>> page_to_nid(page) == numa_mem_id()
>>>
>>> This will allow recycling only if handling node is the same as
>>> where
>>> the page was allocated, regardless of pool->p.nid.
>>>
>>> so semantics are:
>>>
>>> 1) allocate from: pool->p.nid, as chosen by user.
>>> 2) recycle when: page_to_nid(page) == numa_mem_id().
>>> 3) pool user must guarantee that the handler will run on the right
>>> node. which should always be the case. otherwise recycling will be
>>> skipped (no cross numa recycling).
>>>
>>>
>>> a) if the pool migrates, we will stop recycling until the pool
>>> moves
>>> back to original node, or user calls pool_update_nid() as we do in
>>> mlx5.
>>> b) if pool is NUMA_NO_NODE, then allocation and handling will be
>>> done
>>> on numa_mem_id(), which means the above check will work.
>>
>> Only checking page_to_nid(page) == numa_mem_id() may not work for the
>> below
>> case in mvneta.c:
>>
>> static int mvneta_create_page_pool(struct mvneta_port *pp,
>> 				   struct mvneta_rx_queue *rxq, int
>> size)
>> {
>> 	struct bpf_prog *xdp_prog = READ_ONCE(pp->xdp_prog);
>> 	struct page_pool_params pp_params = {
>> 		.order = 0,
>> 		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
>> 		.pool_size = size,
>> 		.nid = cpu_to_node(0),
>> 		.dev = pp->dev->dev.parent,
>> 		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL :
>> DMA_FROM_DEVICE,
>> 		.offset = pp->rx_offset_correction,
>> 		.max_len = MVNETA_MAX_RX_BUF_SIZE,
>> 	};
>>
>> the pool->p.nid is not NUMA_NO_NODE, then the node of page allocated
>> for rx
>> may not be numa_mem_id() when running in the NAPI polling, because
>> pool->p.nid
>> is not the same as the node of cpu running in the NAPI polling.
>>
>> Does the page pool support recycling for above case?
>>
> 
> I don't think you want to allow cross numa recycling.

Cross numa recycling is not what I want.

> 
>> Or we "fix' the above case by setting pool->p.nid to
>> NUMA_NO_NODE/dev_to_node(),
>> or by calling pool_update_nid() in NAPI polling as mlx5 does?
>>
> 
> Yes just update_nid when needed, and make sure the NAPI polling runs on
> a consistent core and eventually alloc/recycling will happen on the
> same core.

To me, passing NUMA_NO_NODE/dev_to_node() seems to always work.
Calling pool_update_nid() in NAPI polling is another way of passing
NUMA_NO_NODE to page_pool_init().

And it seems it is a copy & paste problem for mvneta and netsec
driver that uses cpu_to_node(0) as pool->p.nid but does not call
page_pool_nid_changed() in the NAPI polling as mlx5 does.

So I suggest to remove page_pool_nid_changed() and always use
NUMA_NO_NODE/dev_to_node() as pool->p.nid or make it clear (
by comment or warning?)that page_pool_nid_changed() should be
called when pool->p.nid is NUMA_NO_NODE/dev_to_node().

I prefer to remove page_pool_nid_changed() if we do not allow
cross numa recycling.


> 
>>
>>> Thanks,
>>> Saeed.
>>>
>>>
>>>
>>>
>>>
>>>
>>>

