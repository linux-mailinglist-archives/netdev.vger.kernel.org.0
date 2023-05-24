Return-Path: <netdev+bounces-4955-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B079170F5C8
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 769B01C20CD1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C53E17AD5;
	Wed, 24 May 2023 12:00:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D915C8FE;
	Wed, 24 May 2023 12:00:20 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62A5135;
	Wed, 24 May 2023 05:00:16 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QR8pt0Nl8zLmHP;
	Wed, 24 May 2023 19:58:46 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 24 May
 2023 20:00:14 +0800
Subject: Re: [PATCH RFC net-next/mm V4 2/2] page_pool: Remove workqueue in new
 shutdown scheme
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, Jesper
 Dangaard Brouer <brouer@redhat.com>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, <netdev@vger.kernel.org>, Eric Dumazet
	<eric.dumazet@gmail.com>, <linux-mm@kvack.org>, Mel Gorman
	<mgorman@techsingularity.net>
CC: <lorenzo@kernel.org>, <bpf@vger.kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	<willy@infradead.org>
References: <168485351546.2849279.13771638045665633339.stgit@firesoul>
 <168485357834.2849279.8073426325295894331.stgit@firesoul>
 <87h6s3nhv4.fsf@toke.dk>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1d4d9c47-c236-b661-4ac7-788102af8bed@huawei.com>
Date: Wed, 24 May 2023 20:00:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <87h6s3nhv4.fsf@toke.dk>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/24 0:16, Toke Høiland-Jørgensen wrote:
>>  void page_pool_destroy(struct page_pool *pool)
>>  {
>> +	unsigned int flags;
>> +	u32 release_cnt;
>> +	u32 hold_cnt;
>> +
>>  	if (!pool)
>>  		return;
>>  
>> @@ -868,11 +894,45 @@ void page_pool_destroy(struct page_pool *pool)
>>  	if (!page_pool_release(pool))
>>  		return;
>>  
>> -	pool->defer_start = jiffies;
>> -	pool->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
>> +	/* PP have pages inflight, thus cannot immediately release memory.
>> +	 * Enter into shutdown phase, depending on remaining in-flight PP
>> +	 * pages to trigger shutdown process (on concurrent CPUs) and last
>> +	 * page will free pool instance.
>> +	 *
>> +	 * There exist two race conditions here, we need to take into
>> +	 * account in the following code.
>> +	 *
>> +	 * 1. Before setting PP_FLAG_SHUTDOWN another CPU released the last
>> +	 *    pages into the ptr_ring.  Thus, it missed triggering shutdown
>> +	 *    process, which can then be stalled forever.
>> +	 *
>> +	 * 2. After setting PP_FLAG_SHUTDOWN another CPU released the last
>> +	 *    page, which triggered shutdown process and freed pool
>> +	 *    instance. Thus, its not safe to dereference *pool afterwards.
>> +	 *
>> +	 * Handling races by holding a fake in-flight count, via artificially
>> +	 * bumping pages_state_hold_cnt, which assures pool isn't freed under
>> +	 * us.  Use RCU Grace-Periods to guarantee concurrent CPUs will
>> +	 * transition safely into the shutdown phase.
>> +	 *
>> +	 * After safely transition into this state the races are resolved.  For
>> +	 * race(1) its safe to recheck and empty ptr_ring (it will not free
>> +	 * pool). Race(2) cannot happen, and we can release fake in-flight count
>> +	 * as last step.
>> +	 */
>> +	hold_cnt = READ_ONCE(pool->pages_state_hold_cnt) + 1;
>> +	WRITE_ONCE(pool->pages_state_hold_cnt, hold_cnt);
>> +	synchronize_rcu();
>> +
>> +	flags = READ_ONCE(pool->p.flags) | PP_FLAG_SHUTDOWN;
>> +	WRITE_ONCE(pool->p.flags, flags);
>> +	synchronize_rcu();
> 
> Hmm, synchronize_rcu() can be quite expensive; why do we need two of
> them? Should be fine to just do one after those two writes, as long as
> the order of those writes is correct (which WRITE_ONCE should ensure)?

I am not sure rcu is the right scheme to fix the problem, as rcu is usually
for one doing freeing/updating and many doing reading, while the case we
try to fix here is all doing the reading and trying to do the freeing.

And there might still be data race here as below:
     cpu0 calling page_pool_destroy()                cpu1 caling page_pool_release_page()

WRITE_ONCE(pool->pages_state_hold_cnt, hold_cnt);
      WRITE_ONCE(pool->p.flags, flags);
           synchronize_rcu();
                                                             atomic_inc_return()

        release_cnt = atomic_inc_return();
      page_pool_free_attempt(pool, release_cnt);
        rcu call page_pool_free_rcu()

				                     if (READ_ONCE(pool->p.flags) & PP_FLAG_SHUTDOWN)
                                                               page_pool_free_attempt()

As the rcu_read_[un]lock are only in page_pool_free_attempt(), cpu0
will see the inflight being zero and triger the rcu to free the pp,
and cpu1 see the pool->p.flags with PP_FLAG_SHUTDOWN set, it will
access pool->pages_state_hold_cnt in __page_pool_inflight(), causing
a use-after-free problem?


> 
> Also, if we're adding this (blocking) operation in the teardown path we
> risk adding latency to that path (network interface removal,
> BPF_PROG_RUN syscall etc), so not sure if this actually ends up being an
> improvement anymore, as opposed to just keeping the workqueue but
> dropping the warning?

we might be able to remove the workqueue from the destroy path, a
workqueue might be still needed to be trigered to call page_pool_free()
in non-atomic context instead of calling page_pool_free() directly in
page_pool_release_page(), as page_pool_release_page() might be called
in atomic context and page_pool_free() requires a non-atomic context
for put_device() and pool->disconnect using the mutex_lock() in
mem_allocator_disconnect().

