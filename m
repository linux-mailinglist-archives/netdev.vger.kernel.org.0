Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFA0117D31
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 02:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfLJBbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 20:31:31 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:33994 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726502AbfLJBbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 20:31:31 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D8F7C3B64F4FBD02D442;
        Tue, 10 Dec 2019 09:31:27 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 10 Dec 2019
 09:31:26 +0800
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191209131416.238d4ae4@carbon>
 <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e9855bd9-dddd-e12c-c889-b872702f80d1@huawei.com>
Date:   Tue, 10 Dec 2019 09:31:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/10 7:34, Saeed Mahameed wrote:
> On Mon, 2019-12-09 at 13:14 +0100, Jesper Dangaard Brouer wrote:
>> On Sat, 7 Dec 2019 03:52:41 +0000
>> Saeed Mahameed <saeedm@mellanox.com> wrote:
>>
>>> On Fri, 2019-12-06 at 17:32 +0800, Li RongQing wrote:
>>>> some drivers uses page pool, but not require to allocate
>>>> pages from bound node, or simply assign pool.p.nid to
>>>> NUMA_NO_NODE, and the commit d5394610b1ba ("page_pool:
>>>> Don't recycle non-reusable pages") will block this kind
>>>> of driver to recycle
>>>>
>>>> so take page as reusable when page belongs to current
>>>> memory node if nid is NUMA_NO_NODE
>>>>
>>>> v1-->v2: add check with numa_mem_id from Yunsheng
>>>>
>>>> Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable
>>>> pages")
>>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>>> Suggested-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>> Cc: Saeed Mahameed <saeedm@mellanox.com>
>>>> ---
>>>>  net/core/page_pool.c | 7 ++++++-
>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>>>> index a6aefe989043..3c8b51ccd1c1 100644
>>>> --- a/net/core/page_pool.c
>>>> +++ b/net/core/page_pool.c
>>>> @@ -312,12 +312,17 @@ static bool
>>>> __page_pool_recycle_direct(struct
>>>> page *page,
>>>>  /* page is NOT reusable when:
>>>>   * 1) allocated when system is under some pressure.
>>>> (page_is_pfmemalloc)
>>>>   * 2) belongs to a different NUMA node than pool->p.nid.
>>>> + * 3) belongs to a different memory node than current context
>>>> + * if pool->p.nid is NUMA_NO_NODE
>>>>   *
>>>>   * To update pool->p.nid users must call page_pool_update_nid.
>>>>   */
>>>>  static bool pool_page_reusable(struct page_pool *pool, struct
>>>> page
>>>> *page)
>>>>  {
>>>> -	return !page_is_pfmemalloc(page) && page_to_nid(page) ==
>>>> pool-  
>>>>> p.nid;  
>>>> +	return !page_is_pfmemalloc(page) &&
>>>> +		(page_to_nid(page) == pool->p.nid ||
>>>> +		(pool->p.nid == NUMA_NO_NODE &&
>>>> +		page_to_nid(page) == numa_mem_id()));
>>>>  }
>>>>    
>>>
>>> Cc'ed Jesper, Ilias & Jonathan.
>>>
>>> I don't think it is correct to check that the page nid is same as
>>> numa_mem_id() if pool is NUMA_NO_NODE. In such case we should allow
>>> all
>>> pages to recycle, because you can't assume where pages are
>>> allocated
>>> from and where they are being handled.
>>>
>>> I suggest the following:
>>>
>>> return !page_pfmemalloc() && 
>>> ( page_to_nid(page) == pool->p.nid || pool->p.nid == NUMA_NO_NODE
>>> );
>>>
>>> 1) never recycle emergency pages, regardless of pool nid.
>>> 2) always recycle if pool is NUMA_NO_NODE.
>>>
>>> the above change should not add any overhead, a modest branch
>>> predictor
>>> will handle this with no effort.
>>>
>>> Jesper et al. what do you think?
>>
>> The patch description doesn't explain the problem very well.
>>
>> Lets first establish what the problem is.  After I took at closer
>> look,
>> I do think we have a real problem here...
>>
>> If function alloc_pages_node() is called with NUMA_NO_NODE (see below
>> signature), then the nid is re-assigned to numa_mem_id().
>>
>> Our current code checks: page_to_nid(page) == pool->p.nid which seems
>> bogus, as pool->p.nid=NUMA_NO_NODE and the page NID will not return
>> NUMA_NO_NODE... as it was set to the local detect numa node, right?
>>
> 
> right.
> 
>> So, we do need a fix... but the question is that semantics do we
>> want?
>>
> 
> maybe assume that __page_pool_recycle_direct() is always called from
> the right node and change the current bogus check:
> 
> from:
> page_to_nid(page) == pool->p.nid 
> 
> to:
> page_to_nid(page) == numa_mem_id()
> 
> This will allow recycling only if handling node is the same as where
> the page was allocated, regardless of pool->p.nid.
> 
> so semantics are:
> 
> 1) allocate from: pool->p.nid, as chosen by user.
> 2) recycle when: page_to_nid(page) == numa_mem_id().
> 3) pool user must guarantee that the handler will run on the right
> node. which should always be the case. otherwise recycling will be
> skipped (no cross numa recycling).
> 
> 
> a) if the pool migrates, we will stop recycling until the pool moves
> back to original node, or user calls pool_update_nid() as we do in
> mlx5.
> b) if pool is NUMA_NO_NODE, then allocation and handling will be done
> on numa_mem_id(), which means the above check will work.


Only checking page_to_nid(page) == numa_mem_id() may not work for the below
case in mvneta.c:

static int mvneta_create_page_pool(struct mvneta_port *pp,
				   struct mvneta_rx_queue *rxq, int size)
{
	struct bpf_prog *xdp_prog = READ_ONCE(pp->xdp_prog);
	struct page_pool_params pp_params = {
		.order = 0,
		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
		.pool_size = size,
		.nid = cpu_to_node(0),
		.dev = pp->dev->dev.parent,
		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
		.offset = pp->rx_offset_correction,
		.max_len = MVNETA_MAX_RX_BUF_SIZE,
	};

the pool->p.nid is not NUMA_NO_NODE, then the node of page allocated for rx
may not be numa_mem_id() when running in the NAPI polling, because pool->p.nid
is not the same as the node of cpu running in the NAPI polling.

Does the page pool support recycling for above case?

Or we "fix' the above case by setting pool->p.nid to NUMA_NO_NODE/dev_to_node(),
or by calling pool_update_nid() in NAPI polling as mlx5 does?


> 
> Thanks,
> Saeed.
> 
> 
> 
> 
> 
> 
> 

