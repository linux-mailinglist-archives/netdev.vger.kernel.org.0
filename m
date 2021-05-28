Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC88C393B5C
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 04:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbhE1C1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 22:27:51 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5123 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbhE1C1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 22:27:49 -0400
Received: from dggeml767-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FrpQD6qCvzYn5g;
        Fri, 28 May 2021 10:23:32 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml767-chm.china.huawei.com (10.1.199.177) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 10:26:13 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 28 May
 2021 10:26:12 +0800
Subject: Re: [PATCH net-next] ptr_ring: make __ptr_ring_empty() checking more
 reliable
To:     Jason Wang <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <will@kernel.org>, <peterz@infradead.org>, <paulmck@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <mst@redhat.com>, <brouer@redhat.com>
References: <1622032173-11883-1-git-send-email-linyunsheng@huawei.com>
 <d2287691-1ef9-d2c4-13f6-2baf7b80d905@redhat.com>
 <25a6b73d-06ec-fe07-b34c-10fea709e055@huawei.com>
 <51bc1c38-da20-1090-e3ef-1972f28adfee@redhat.com>
 <938bdb23-4335-845d-129e-db8af2484c27@huawei.com>
 <0b64f53d-e120-f90d-bf59-bb89cceea83e@redhat.com>
 <758d89e8-3be1-25ae-9a42-cc8703ac097b@huawei.com>
 <b2eb7c0b-f3e8-bc89-1644-0d9b533af749@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <a366ee9b-e3d1-0004-1fae-7f44b5708bdc@huawei.com>
Date:   Fri, 28 May 2021 10:26:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <b2eb7c0b-f3e8-bc89-1644-0d9b533af749@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/28 9:31, Jason Wang wrote:
> 
> 在 2021/5/27 下午5:03, Yunsheng Lin 写道:
>> On 2021/5/27 16:05, Jason Wang wrote:
>>> 在 2021/5/27 下午3:21, Yunsheng Lin 写道:
>>>> On 2021/5/27 14:53, Jason Wang wrote:
>>>>> 在 2021/5/27 下午2:07, Yunsheng Lin 写道:
>>>>>> On 2021/5/27 12:57, Jason Wang wrote:
>>>>>>> 在 2021/5/26 下午8:29, Yunsheng Lin 写道:
>>>>>>>> Currently r->queue[] is cleared after r->consumer_head is moved
>>>>>>>> forward, which makes the __ptr_ring_empty() checking called in
>>>>>>>> page_pool_refill_alloc_cache() unreliable if the checking is done
>>>>>>>> after the r->queue clearing and before the consumer_head moving
>>>>>>>> forward.
>>>>>>>>
>>>>>>>> Move the r->queue[] clearing after consumer_head moving forward
>>>>>>>> to make __ptr_ring_empty() checking more reliable.
>>>>>>> If I understand this correctly, this can only happens if you run __ptr_ring_empty() in parallel with ptr_ring_discard_one().
>>>>>> Yes.
>>>>>>
>>>>>>> I think those two needs to be serialized. Or did I miss anything?
>>>>>> As the below comment in __ptr_ring_discard_one, if the above is true, I
>>>>>> do not think we need to keep consumer_head valid at all times, right?
>>>>>>
>>>>>>
>>>>>>       /* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
>>>>>>        * to work correctly.
>>>>>>        */
>>>>> I'm not sure I understand. But my point is that you need to synchronize the __ptr_ring_discard_one() and __ptr_empty() as explained in the comment above __ptr_ring_empty():
>>>> I am saying if __ptr_ring_empty() and __ptr_ring_discard_one() is
>>>> always serialized, then it seems that the below commit is unnecessary?
>>>
>>> Just to make sure we are at the same page. What I really meant is "synchronized" not "serialized". So they can be called at the same time but need synchronization.
>>>
>>>
>>>> 406de7555424 ("ptr_ring: keep consumer_head valid at all times")
>>>
>>> This still needed in this case.
>>>
>>>
>>>>> /*
>>>>>    * Test ring empty status without taking any locks.
>>>>>    *
>>>>>    * NB: This is only safe to call if ring is never resized.
>>>>>    *
>>>>>    * However, if some other CPU consumes ring entries at the same time, the value
>>>>>    * returned is not guaranteed to be correct.
>>>>>    *
>>>>>    * In this case - to avoid incorrectly detecting the ring
>>>>>    * as empty - the CPU consuming the ring entries is responsible
>>>>>    * for either consuming all ring entries until the ring is empty,
>>>>>    * or synchronizing with some other CPU and causing it to
>>>>>    * re-test __ptr_ring_empty and/or consume the ring enteries
>>>>>    * after the synchronization point.
>>>> I am not sure I understand "incorrectly detecting the ring as empty"
>>>> means, is it because of the data race described in the commit log?
>>>
>>> It means "the ring might be empty but __ptr_ring_empty() returns false".
>> But the ring might be non-empty but __ptr_ring_empty() returns true
>> for the data race described in the commit log:)
> 
> 
> Which commit log?

this commit log.
If the data race described in this commit log happens, the ring might be
non-empty, but __ptr_ring_empty() returns true.


> 
> 
>>
>>>
>>>> Or other data race? I can not think of other data race if consuming
>>>> and __ptr_ring_empty() is serialized:)
>>>>
>>>> I am agreed that __ptr_ring_empty() checking is not totally reliable
>>>> without taking r->consumer_lock, that is why I use "more reliable"
>>>> in the title:)
>>>
>>> Is __ptr_ring_empty() synchronized with the consumer in your case? If yes, have you done some benchmark to see the difference?
>>>
>>> Have a look at page pool, this only helps when multiple refill request happens in parallel which can make some of the refill return early if the ring has been consumed.
>>>
>>> This is the slow-path and I'm not sure we see any difference. If one the request runs faster then the following request will go through the fast path.
>> Yes, I am agreed there may not be any difference.
>> But it is better to make it more reliable, right?
> 
> 
> No, any performance optimization must be benchmark to show obvious difference to be accepted.
> 
> ptr_ring has been used by various subsystems so we should not risk our self-eves to accept theoretical optimizations.

As a matter of fact, I am not treating it as a performance optimization for this patch.
I treated it as improvement for the checking of __ptr_ring_empty().
But you are right that we need to ensure there is not performance regression when improving
it.

Any existing and easy-to-setup testcase to benchmark the ptr_ring performance?

> 
> 
>>
>>> If it really helps, can we do it more simpler by:
>>>


