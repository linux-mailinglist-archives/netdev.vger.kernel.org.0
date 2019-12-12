Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E78011C1D6
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfLLBE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:04:56 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7671 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726791AbfLLBE4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 20:04:56 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0B33BABFEBC6B4922017;
        Thu, 12 Dec 2019 09:04:52 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 12 Dec 2019
 09:04:47 +0800
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
 <910156da-0b43-0a86-67a0-f4e7e6547373@huawei.com>
 <a6c43e98662b24574cb1e996fcccad196b9e2bcd.camel@mellanox.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <82f1ddb0-805e-c6db-51dc-b6c4aa8c9bd6@huawei.com>
Date:   Thu, 12 Dec 2019 09:04:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <a6c43e98662b24574cb1e996fcccad196b9e2bcd.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/12 4:57, Saeed Mahameed wrote:
> On Wed, 2019-12-11 at 11:01 +0800, Yunsheng Lin wrote:
>> On 2019/12/11 3:45, Saeed Mahameed wrote:
>>>>> maybe assume that __page_pool_recycle_direct() is always called
>>>>> from
>>>>> the right node and change the current bogus check:
>>>>>
>>>>> from:
>>>>> page_to_nid(page) == pool->p.nid 
>>>>>
>>>>> to:
>>>>> page_to_nid(page) == numa_mem_id()
>>>>>
>>>>> This will allow recycling only if handling node is the same as
>>>>> where
>>>>> the page was allocated, regardless of pool->p.nid.
>>>>>
>>>>> so semantics are:
>>>>>
>>>>> 1) allocate from: pool->p.nid, as chosen by user.
>>>>> 2) recycle when: page_to_nid(page) == numa_mem_id().
>>>>> 3) pool user must guarantee that the handler will run on the
>>>>> right
>>>>> node. which should always be the case. otherwise recycling will
>>>>> be
>>>>> skipped (no cross numa recycling).
>>>>>
>>>>>
>>>>> a) if the pool migrates, we will stop recycling until the pool
>>>>> moves
>>>>> back to original node, or user calls pool_update_nid() as we do
>>>>> in
>>>>> mlx5.
>>>>> b) if pool is NUMA_NO_NODE, then allocation and handling will
>>>>> be
>>>>> done
>>>>> on numa_mem_id(), which means the above check will work.
>>>>
>>>> Only checking page_to_nid(page) == numa_mem_id() may not work for
>>>> the
>>>> below
>>>> case in mvneta.c:
>>>>
>>>> static int mvneta_create_page_pool(struct mvneta_port *pp,
>>>> 				   struct mvneta_rx_queue *rxq, int
>>>> size)
>>>> {
>>>> 	struct bpf_prog *xdp_prog = READ_ONCE(pp->xdp_prog);
>>>> 	struct page_pool_params pp_params = {
>>>> 		.order = 0,
>>>> 		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
>>>> 		.pool_size = size,
>>>> 		.nid = cpu_to_node(0),
>>>> 		.dev = pp->dev->dev.parent,
>>>> 		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL :
>>>> DMA_FROM_DEVICE,
>>>> 		.offset = pp->rx_offset_correction,
>>>> 		.max_len = MVNETA_MAX_RX_BUF_SIZE,
>>>> 	};
>>>>
>>>> the pool->p.nid is not NUMA_NO_NODE, then the node of page
>>>> allocated
>>>> for rx
>>>> may not be numa_mem_id() when running in the NAPI polling,
>>>> because
>>>> pool->p.nid
>>>> is not the same as the node of cpu running in the NAPI polling.
>>>>
>>>> Does the page pool support recycling for above case?
>>>>
>>>
>>> I don't think you want to allow cross numa recycling.
>>
>> Cross numa recycling is not what I want.
>>
>>>> Or we "fix' the above case by setting pool->p.nid to
>>>> NUMA_NO_NODE/dev_to_node(),
>>>> or by calling pool_update_nid() in NAPI polling as mlx5 does?
>>>>
>>>
>>> Yes just update_nid when needed, and make sure the NAPI polling
>>> runs on
>>> a consistent core and eventually alloc/recycling will happen on the
>>> same core.
>>
>> To me, passing NUMA_NO_NODE/dev_to_node() seems to always work.
>> Calling pool_update_nid() in NAPI polling is another way of passing
>> NUMA_NO_NODE to page_pool_init().
>>
>> And it seems it is a copy & paste problem for mvneta and netsec
>> driver that uses cpu_to_node(0) as pool->p.nid but does not call
>> page_pool_nid_changed() in the NAPI polling as mlx5 does.
>>
>> So I suggest to remove page_pool_nid_changed() and always use
>> NUMA_NO_NODE/dev_to_node() as pool->p.nid or make it clear (
>> by comment or warning?)that page_pool_nid_changed() should be
>> called when pool->p.nid is NUMA_NO_NODE/dev_to_node().
>>
> 
> not an option.
> 
> rx rings should always allocate data buffers according to their cpu
> affinity and not dev_node or default to NUMA_NO_NODE.

Does "their cpu affinity" mean numa_mem_id() when runnig in the
NAPI polling context?

If yes, the node of data buffers allocated for rx will be default to
numa_mem_id() when the pool->p.nid is NUMA_NO_NODE.

See:

/*
 * Allocate pages, preferring the node given as nid. When nid == NUMA_NO_NODE,
 * prefer the current CPU's closest node. Otherwise node must be valid and
 * online.
 */
static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
						unsigned int order)
{
	if (nid == NUMA_NO_NODE)
		nid = numa_mem_id();

	return __alloc_pages_node(nid, gfp_mask, order);
}

If the above is true, NUMA_NO_NODE is default to numa_mem_id().

> 
>> I prefer to remove page_pool_nid_changed() if we do not allow
>> cross numa recycling.
>>
> 
> This is not for cross numa recycling. 
> Since rx rings can migragte between cores, (msix affinity/IRQ balancer)
> we need page_pool_nid_changed() for seamless migration and for
> recycling and allocation to migrate with the ring.


If the allocation and recycling for rx data buffer is guaranteed to be in
NAPI polling context, when rx rings migragtes between nodes, it will stop
recycling the old pages allocated from old node, and start allocating new
page from new node and start recycling those new pages, because numa_mem_id()
will return different node id based on node the current cpu is running on.

Or allocation and recycling for rx data buffer will not be guaranteed to be
in the same NAPI polling context for a specific ring? Is there a usecase for
this?


> 
>>
>>>>> Thanks,
>>>>> Saeed.
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>

