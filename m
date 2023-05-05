Return-Path: <netdev+bounces-481-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05EEA6F7A39
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 02:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2F2C280F3A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 00:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A6610F5;
	Fri,  5 May 2023 00:54:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD81D7E;
	Fri,  5 May 2023 00:54:55 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B57311625;
	Thu,  4 May 2023 17:54:53 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QCByH2wFxzHqb0;
	Fri,  5 May 2023 08:53:43 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 5 May
 2023 08:54:51 +0800
Subject: Re: [PATCH RFC net-next/mm V3 1/2] page_pool: Remove workqueue in new
 shutdown scheme
To: Jesper Dangaard Brouer <jbrouer@redhat.com>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, <netdev@vger.kernel.org>, Eric Dumazet
	<eric.dumazet@gmail.com>, <linux-mm@kvack.org>, Mel Gorman
	<mgorman@techsingularity.net>
CC: <brouer@redhat.com>, <lorenzo@kernel.org>,
	=?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
	<bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, <willy@infradead.org>
References: <168269854650.2191653.8465259808498269815.stgit@firesoul>
 <168269857929.2191653.13267688321246766547.stgit@firesoul>
 <387f4653-1986-3ffe-65e7-448a59002ed0@huawei.com>
 <3785321f-b2f8-d753-7efc-78ee40e6d0b6@redhat.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <fb8bbf84-20c2-c398-d972-949e909e2c51@huawei.com>
Date: Fri, 5 May 2023 08:54:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <3785321f-b2f8-d753-7efc-78ee40e6d0b6@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/4 21:48, Jesper Dangaard Brouer wrote:
> On 04/05/2023 04.42, Yunsheng Lin wrote:
>> On 2023/4/29 0:16, Jesper Dangaard Brouer wrote:
>>>   void page_pool_release_page(struct page_pool *pool, struct page *page)
>>>   {
>>> +    unsigned int flags = READ_ONCE(pool->p.flags);
>>>       dma_addr_t dma;
>>> -    int count;
>>> +    u32 release_cnt;
>>> +    u32 hold_cnt;
>>>         if (!(pool->p.flags & PP_FLAG_DMA_MAP))
>>>           /* Always account for inflight pages, even if we didn't
>>> @@ -490,11 +503,15 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>>>   skip_dma_unmap:
>>>       page_pool_clear_pp_info(page);
>>>   -    /* This may be the last page returned, releasing the pool, so
>>> -     * it is not safe to reference pool afterwards.
>>> -     */
>>> -    count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
>>> -    trace_page_pool_state_release(pool, page, count);
>>
>> There is a time window between "unsigned int flags = READ_ONCE(pool->p.flags)"
>> and flags checking, if page_pool_destroy() is called concurrently during that
>> time window, it seems we will have a pp instance leaking problem here?
>>
> 
> Nope, that is resolved by the code changes in page_pool_destroy(), see below.

Maybe I did not describe the data race clearly enough.

         CPU 0                                               CPU1
	   .
	   .
unsigned int flags = READ_ONCE(pool->p.flags);
	   .
	   .                                         page_pool_destroy()
	   .
atomic_inc_return(&pool->pages_state_release_cnt)
           .
	   .
	   .
 if (flags & PP_FLAG_SHUTDOWN)
	page_pool_free_attempt();

The above data race may cause a pp instance leaking problem:
CPU0 is releasing the last page for a pp and it did not see the pool->p.flags
with the PP_FLAG_SHUTDOWN set because page_pool_destroy() is called after
reading pool->p.flags, so page_pool_free_attempt() is not called to free
pp.

CPU1 calling the page_pool_destroy() also did not free pp as CPU0 had not
done the atomic_inc_return() for pool->pages_state_release_cnt yet.

Or did I miss something obvious here?

> 
>> It seems it is very hard to aovid this kind of corner case when using both
>> flags & PP_FLAG_SHUTDOWN and release_cnt/hold_cnt checking to decide if pp
>> instance can be freed.
>> Can we use something like biased reference counting, which used by frag support
>> in page pool? So that we only need to check only one variable and avoid cache
>> bouncing as much as possible.
>>
> 
> See below, I believe we are doing an equivalent refcnt bias trick, that
> solves these corner cases in page_pool_destroy().
> In short: hold_cnt is increased, prior to setting PP_FLAG_SHUTDOWN.
> Thus, if this code READ_ONCE flags without PP_FLAG_SHUTDOWN, we know it
> will not be the last to release pool->pages_state_release_cnt.

It is not exactly the kind of refcnt bias trick in my mind, I was thinking
about using pool->pages_state_hold_cnt as refcnt bias and merge it to
pool->pages_state_release_cnt as needed, maybe I need to try to implement
that to see if it turn out to be what I want it to be.

> Below: Perhaps, we should add a RCU grace period to make absolutely
> sure, that this code completes before page_pool_destroy() call completes.
> 
> 
>>> +    if (flags & PP_FLAG_SHUTDOWN)
>>> +        hold_cnt = pp_read_hold_cnt(pool);
>>> +
> 
> I would like to avoid above code, and I'm considering using call_rcu(),
> which I think will resolve the race[0] this code deals with.
> As I explained here[0], this code deals with another kind of race.

Yes, I understand that. I even went to check if the below tracepoint
trace_page_pool_state_release() was causing a use-after-free problem
as it is passing 'pool':)

> 
>  [0] https://lore.kernel.org/all/f671f5da-d9bc-a559-2120-10c3491e6f6d@redhat.com/
> 
>>> +    release_cnt = atomic_inc_return(&pool->pages_state_release_cnt);
>>> +    trace_page_pool_state_release(pool, page, release_cnt);
>>> +
>>> +    /* In shutdown phase, last page will free pool instance */
>>> +    if (flags & PP_FLAG_SHUTDOWN)
>>> +        page_pool_free_attempt(pool, hold_cnt, release_cnt);
>>>   }
>>>   EXPORT_SYMBOL(page_pool_release_page);
>>>
>>
>> ...
>>
>>>     void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
>>> @@ -856,6 +884,10 @@ EXPORT_SYMBOL(page_pool_unlink_napi);
>>>     void page_pool_destroy(struct page_pool *pool)
>>>   {
>>> +    unsigned int flags;
>>> +    u32 release_cnt;
>>> +    u32 hold_cnt;
>>> +
>>>       if (!pool)
>>>           return;
>>>   @@ -868,11 +900,39 @@ void page_pool_destroy(struct page_pool *pool)
>>>       if (!page_pool_release(pool))
>>>           return;
>>>   -    pool->defer_start = jiffies;
>>> -    pool->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
>>> +    /* PP have pages inflight, thus cannot immediately release memory.
>>> +     * Enter into shutdown phase, depending on remaining in-flight PP
>>> +     * pages to trigger shutdown process (on concurrent CPUs) and last
>>> +     * page will free pool instance.
>>> +     *
>>> +     * There exist two race conditions here, we need to take into
>>> +     * account in the following code.
>>> +     *
>>> +     * 1. Before setting PP_FLAG_SHUTDOWN another CPU released the last
>>> +     *    pages into the ptr_ring.  Thus, it missed triggering shutdown
>>> +     *    process, which can then be stalled forever.
>>> +     *
>>> +     * 2. After setting PP_FLAG_SHUTDOWN another CPU released the last
>>> +     *    page, which triggered shutdown process and freed pool
>>> +     *    instance. Thus, its not safe to dereference *pool afterwards.
>>> +     *
>>> +     * Handling races by holding a fake in-flight count, via
>>> +     * artificially bumping pages_state_hold_cnt, which assures pool
>>> +     * isn't freed under us.  For race(1) its safe to recheck ptr_ring
>>> +     * (it will not free pool). Race(2) cannot happen, and we can
>>> +     * release fake in-flight count as last step.
>>> +     */
>>> +    hold_cnt = READ_ONCE(pool->pages_state_hold_cnt) + 1;
>>> +    smp_store_release(&pool->pages_state_hold_cnt, hold_cnt);
>>
>> I assume the smp_store_release() is used to ensure the correct order
>> between the above store operations?
>> There is data dependency between those two store operations, do we
>> really need the smp_store_release() here?
>>
>>> +    barrier();
>>> +    flags = READ_ONCE(pool->p.flags) | PP_FLAG_SHUTDOWN;
>>
>> Do we need a stronger barrier like smp_rmb() to prevent cpu from
>> executing "flags = READ_ONCE(pool->p.flags) | PP_FLAG_SHUTDOWN"
>> before "smp_store_release(&pool->pages_state_hold_cnt, hold_cnt)"
>> even if there is a smp_store_release() barrier here?
>>
> I do see you point and how it is related to your above comment for
> page_pool_release_page().
> 
> I think we need to replace barrier() with synchronize_rcu().
> Meaning we add a RCU grace period to "wait" for above code (in
> page_pool_release_page) that read the old flags value to complete.
> 
> 
>>> +    smp_store_release(&pool->p.flags, flags);
> 
> When doing a synchronize_rcu(), I assume this smp_store_release() is
> overkill, right?
> Will a WRITE_ONCE() be sufficient?
> 
> Hmm, the synchronize_rcu(), shouldn't that be *after* storing the flags?

Yes.
As my understanding, we probably do not need any of those *_ONCE() and
barrier when using rcu.

But I am not really convinced that we need to go for rcu yet.

