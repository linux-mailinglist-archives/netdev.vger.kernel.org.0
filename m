Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA64F39271B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 08:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhE0GJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 02:09:51 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2496 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbhE0GJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 02:09:51 -0400
Received: from dggeml703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FrHNw03rLzYq9R;
        Thu, 27 May 2021 14:05:36 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml703-chm.china.huawei.com (10.3.17.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 27 May 2021 14:07:59 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 27 May
 2021 14:07:59 +0800
Subject: Re: [PATCH net-next] ptr_ring: make __ptr_ring_empty() checking more
 reliable
To:     Jason Wang <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <will@kernel.org>, <peterz@infradead.org>, <paulmck@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <mst@redhat.com>, <brouer@redhat.com>
References: <1622032173-11883-1-git-send-email-linyunsheng@huawei.com>
 <d2287691-1ef9-d2c4-13f6-2baf7b80d905@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <25a6b73d-06ec-fe07-b34c-10fea709e055@huawei.com>
Date:   Thu, 27 May 2021 14:07:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <d2287691-1ef9-d2c4-13f6-2baf7b80d905@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/27 12:57, Jason Wang wrote:
> 
> ÔÚ 2021/5/26 ÏÂÎç8:29, Yunsheng Lin Ð´µÀ:
>> Currently r->queue[] is cleared after r->consumer_head is moved
>> forward, which makes the __ptr_ring_empty() checking called in
>> page_pool_refill_alloc_cache() unreliable if the checking is done
>> after the r->queue clearing and before the consumer_head moving
>> forward.
>>
>> Move the r->queue[] clearing after consumer_head moving forward
>> to make __ptr_ring_empty() checking more reliable.
> 
> 
> If I understand this correctly, this can only happens if you run __ptr_ring_empty() in parallel with ptr_ring_discard_one().

Yes.

> 
> I think those two needs to be serialized. Or did I miss anything?

As the below comment in __ptr_ring_discard_one, if the above is true, I
do not think we need to keep consumer_head valid at all times, right?


	/* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
	 * to work correctly.
	 */

> 
> Thanks
> 
> 
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>   include/linux/ptr_ring.h | 26 +++++++++++++++++---------
>>   1 file changed, 17 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
>> index 808f9d3..f32f052 100644
>> --- a/include/linux/ptr_ring.h
>> +++ b/include/linux/ptr_ring.h
>> @@ -261,8 +261,7 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>>       /* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
>>        * to work correctly.
>>        */
>> -    int consumer_head = r->consumer_head;
>> -    int head = consumer_head++;
>> +    int consumer_head = r->consumer_head + 1;
>>         /* Once we have processed enough entries invalidate them in
>>        * the ring all at once so producer can reuse their space in the ring.
>> @@ -271,19 +270,28 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>>        */
>>       if (unlikely(consumer_head - r->consumer_tail >= r->batch ||
>>                consumer_head >= r->size)) {
>> +        int tail = r->consumer_tail;
>> +        int head = consumer_head;
>> +
>> +        if (unlikely(consumer_head >= r->size)) {
>> +            r->consumer_tail = 0;
>> +            WRITE_ONCE(r->consumer_head, 0);
>> +        } else {
>> +            r->consumer_tail = consumer_head;
>> +            WRITE_ONCE(r->consumer_head, consumer_head);
>> +        }
>> +
>>           /* Zero out entries in the reverse order: this way we touch the
>>            * cache line that producer might currently be reading the last;
>>            * producer won't make progress and touch other cache lines
>>            * besides the first one until we write out all entries.
>>            */
>> -        while (likely(head >= r->consumer_tail))
>> -            r->queue[head--] = NULL;
>> -        r->consumer_tail = consumer_head;
>> -    }
>> -    if (unlikely(consumer_head >= r->size)) {
>> -        consumer_head = 0;
>> -        r->consumer_tail = 0;
>> +        while (likely(--head >= tail))
>> +            r->queue[head] = NULL;
>> +
>> +        return;
>>       }
>> +
>>       /* matching READ_ONCE in __ptr_ring_empty for lockless tests */
>>       WRITE_ONCE(r->consumer_head, consumer_head);
>>   }
> 
> 
> .
> 

