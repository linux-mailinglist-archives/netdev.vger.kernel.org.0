Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38603B3F5E
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 10:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhFYIgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 04:36:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11095 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhFYIgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 04:36:06 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GB9Dx51skzZjdq;
        Fri, 25 Jun 2021 16:30:41 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 16:33:41 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 25 Jun
 2021 16:33:41 +0800
Subject: Re: [PATCH net-next v2 2/2] ptr_ring: make __ptr_ring_empty()
 checking more reliable
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jasowang@redhat.com>,
        <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
 <1624591136-6647-3-git-send-email-linyunsheng@huawei.com>
 <20210625022128-mutt-send-email-mst@kernel.org>
 <c6975b2d-2b4a-5b3f-418c-1a59607b9864@huawei.com>
 <20210625032508-mutt-send-email-mst@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <4ced872f-da7a-95a3-2ef1-c281dfb84425@huawei.com>
Date:   Fri, 25 Jun 2021 16:33:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210625032508-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/25 15:30, Michael S. Tsirkin wrote:
> On Fri, Jun 25, 2021 at 03:21:33PM +0800, Yunsheng Lin wrote:
>> On 2021/6/25 14:32, Michael S. Tsirkin wrote:
>>> On Fri, Jun 25, 2021 at 11:18:56AM +0800, Yunsheng Lin wrote:
>>>> Currently r->queue[] is cleared after r->consumer_head is moved
>>>> forward, which makes the __ptr_ring_empty() checking called in
>>>> page_pool_refill_alloc_cache() unreliable if the checking is done
>>>> after the r->queue clearing and before the consumer_head moving
>>>> forward.
>>>
>>>
>>> Well the documentation for __ptr_ring_empty clearly states is
>>> is not guaranteed to be reliable.
>>
>> Yes, this patch does not make __ptr_ring_empty() strictly reliable
>> without taking the r->consumer_lock, as the disscuission in [1].
>>
>> 1. https://patchwork.kernel.org/project/netdevbpf/patch/1622032173-11883-1-git-send-email-linyunsheng@huawei.com/#24207011
>>
>>>
>>>  *
>>>  * NB: This is only safe to call if ring is never resized.
>>>  *
>>>  * However, if some other CPU consumes ring entries at the same time, the value
>>>  * returned is not guaranteed to be correct.
>>>  *
>>>  * In this case - to avoid incorrectly detecting the ring
>>>  * as empty - the CPU consuming the ring entries is responsible
>>>  * for either consuming all ring entries until the ring is empty,
>>>  * or synchronizing with some other CPU and causing it to
>>>  * re-test __ptr_ring_empty and/or consume the ring enteries
>>>  * after the synchronization point.
>>>  *
>>>
>>> Is it then the case that page_pool_refill_alloc_cache violates
>>> this requirement? How?
>>
>> As my understanding:
>> page_pool_refill_alloc_cache() uses __ptr_ring_empty() to avoid
>> taking r->consumer_lock, when the above data race happens, it will
>> exit out and allocate page from the page allocator instead of reusing
>> the page in ptr_ring, which *may* not be happening if __ptr_ring_empty()
>> is more reliable.
> 
> Question is how do we know it's more reliable?
> It would be nice if we did actually made it more reliable,
> as it is we are just shifting races around.
> 
> 
>>>
>>> It looks like you are trying to make the guarantee stronger and ensure
>>> no false positives.
>>>
>>> If yes please document this as such, update the comment so all
>>> code can be evaluated with the eye towards whether the new stronger
>>> guarantee is maintained. In particular I think I see at least one
>>> issue with this immediately.
>>>
>>>
>>>> Move the r->queue[] clearing after consumer_head moving forward
>>>> to make __ptr_ring_empty() checking more reliable.
>>>>
>>>> As a side effect of above change, a consumer_head checking is
>>>> avoided for the likely case, and it has noticeable performance
>>>> improvement when it is tested using the ptr_ring_test selftest
>>>> added in the previous patch.
>>>>
>>>> Using "taskset -c 1 ./ptr_ring_test -s 1000 -m 0 -N 100000000"
>>>> to test the case of single thread doing both the enqueuing and
>>>> dequeuing:
>>>>
>>>>  arch     unpatched           patched       delta
>>>> arm64      4648 ms            4464 ms       +3.9%
>>>>  X86       2562 ms            2401 ms       +6.2%
>>>>
>>>> Using "taskset -c 1-2 ./ptr_ring_test -s 1000 -m 1 -N 100000000"
>>>> to test the case of one thread doing enqueuing and another thread
>>>> doing dequeuing concurrently, also known as single-producer/single-
>>>> consumer:
>>>>
>>>>  arch      unpatched             patched         delta
>>>> arm64   3624 ms + 3624 ms   3462 ms + 3462 ms    +4.4%
>>>>  x86    2758 ms + 2758 ms   2547 ms + 2547 ms    +7.6%
>>>>
>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>> ---
>>>> V2: Add performance data.
>>>> ---
>>>>  include/linux/ptr_ring.h | 25 ++++++++++++++++---------
>>>>  1 file changed, 16 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
>>>> index 808f9d3..db9c282 100644
>>>> --- a/include/linux/ptr_ring.h
>>>> +++ b/include/linux/ptr_ring.h
>>>> @@ -261,8 +261,7 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>>>>  	/* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
>>>>  	 * to work correctly.
>>>>  	 */
>>>> -	int consumer_head = r->consumer_head;
>>>> -	int head = consumer_head++;
>>>> +	int consumer_head = r->consumer_head + 1;
>>>>  
>>>>  	/* Once we have processed enough entries invalidate them in
>>>>  	 * the ring all at once so producer can reuse their space in the ring.
>>>> @@ -271,19 +270,27 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>>>>  	 */
>>>>  	if (unlikely(consumer_head - r->consumer_tail >= r->batch ||
>>>>  		     consumer_head >= r->size)) {
>>>> +		int tail = r->consumer_tail;
>>>> +
>>>> +		if (unlikely(consumer_head >= r->size)) {
>>>> +			r->consumer_tail = 0;
>>>> +			WRITE_ONCE(r->consumer_head, 0);
>>>> +		} else {
>>>> +			r->consumer_tail = consumer_head;
>>>> +			WRITE_ONCE(r->consumer_head, consumer_head);
>>>> +		}
>>>> +
>>>>  		/* Zero out entries in the reverse order: this way we touch the
>>>>  		 * cache line that producer might currently be reading the last;
>>>>  		 * producer won't make progress and touch other cache lines
>>>>  		 * besides the first one until we write out all entries.
>>>>  		 */
>>>> -		while (likely(head >= r->consumer_tail))
>>>> -			r->queue[head--] = NULL;
>>>> -		r->consumer_tail = consumer_head;
>>>> -	}
>>>> -	if (unlikely(consumer_head >= r->size)) {
>>>> -		consumer_head = 0;
>>>> -		r->consumer_tail = 0;
>>>> +		while (likely(--consumer_head >= tail))
>>>> +			r->queue[consumer_head] = NULL;
>>>> +
>>>> +		return;
>>>
>>>
>>> So if now we need this to be reliable then
>>> we also need smp_wmb before writing r->queue[consumer_head],
>>> there could be other gotchas.
>>
>> Yes, This patch does not make it strictly reliable.
>> T think I could mention that in the commit log?
> 
> OK so it's not that it makes it more reliable - this patch simply makes
> a possible false positive less likely while making  a false negative
> more likely. Our assumption is that a false negative is cheaper then?
> 
> How do we know that it is?
> 
> And even if we prove the ptr_ring itself is faster now,
> how do we know what affects callers in a better way a
> false positive or a false negative?
> 
> I would rather we worked on actually making it reliable
> e.g. if we can guarantee no false positives, that would be
> a net win.
I thought deeper about the case you mentioned above, it
seems for the above to happen, the consumer_head need to
be rolled back to zero and incremented to the point when
caller of __ptr_ring_empty() is still *not* able to see the
r->queue[] which has been set to NULL in __ptr_ring_discard_one().

It seems smp_wmb() only need to be done once when consumer_head
is rolled back to zero, and maybe that is enough to make sure the
case you mentioned is fixed too?

And the smp_wmb() is only done once in a round of producing/
consuming, so the performance impact should be minimized?(of
course we need to test it too).

> 
>>
>>>
>>>>  	}
>>>> +
>>>>  	/* matching READ_ONCE in __ptr_ring_empty for lockless tests */
>>>>  	WRITE_ONCE(r->consumer_head, consumer_head);
>>>>  }
>>>> -- 
>>>> 2.7.4
>>>
>>>
>>> .
>>>
> 
> 
> .
> 

