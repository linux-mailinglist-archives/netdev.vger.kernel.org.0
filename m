Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB2235D97E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238700AbhDMH5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:57:55 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5131 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhDMH5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:57:54 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FKHvy5C2RzYXDs;
        Tue, 13 Apr 2021 15:55:26 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 13 Apr 2021 15:57:29 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 13 Apr
 2021 15:57:29 +0800
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
To:     Hillf Danton <hdanton@sina.com>
CC:     Juergen Gross <jgross@suse.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jiri Kosina <JKosina@suse.com>
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
 <20210409090909.1767-1-hdanton@sina.com>
 <20210412032111.1887-1-hdanton@sina.com>
 <20210412072856.2046-1-hdanton@sina.com>
 <20210413022129.2203-1-hdanton@sina.com>
 <20210413032620.2259-1-hdanton@sina.com>
 <20210413071241.2325-1-hdanton@sina.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <ca1da322-0083-c6e7-d905-c75572b5fdf2@huawei.com>
Date:   Tue, 13 Apr 2021 15:57:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210413071241.2325-1-hdanton@sina.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/13 15:12, Hillf Danton wrote:
> On Tue, 13 Apr 2021 11:34:27 Yunsheng Lin wrote:
>> On 2021/4/13 11:26, Hillf Danton wrote:
>>> On Tue, 13 Apr 2021 10:56:42 Yunsheng Lin wrote:
>>>> On 2021/4/13 10:21, Hillf Danton wrote:
>>>>> On Mon, 12 Apr 2021 20:00:43  Yunsheng Lin wrote:
>>>>>>
>>>>>> Yes, the below patch seems to fix the data race described in
>>>>>> the commit log.
>>>>>> Then what is the difference between my patch and your patch below:)
>>>>>
>>>>> Hehe, this is one of the tough questions over a bounch of weeks.
>>>>>
>>>>> If a seqcount can detect the race between skb enqueue and dequeue then we
>>>>> cant see any excuse for not rolling back to the point without NOLOCK.
>>>>
>>>> I am not sure I understood what you meant above.
>>>>
>>>> As my understanding, the below patch is essentially the same as
>>>> your previous patch, the only difference I see is it uses qdisc->pad
>>>> instead of __QDISC_STATE_NEED_RESCHEDULE.
>>>>
>>>> So instead of proposing another patch, it would be better if you
>>>> comment on my patch, and make improvement upon that.
>>>>
>>> Happy to do that after you show how it helps revert NOLOCK.
>>
>> Actually I am not going to revert NOLOCK, but add optimization
>> to it if the patch fixes the packet stuck problem.
>>
> Fix is not optimization, right?

For this patch, it is a fix.
In case you missed it, I do have a couple of idea to optimize the
lockless qdisc:

1. RFC patch to add lockless qdisc bypass optimization:

https://patchwork.kernel.org/project/netdevbpf/patch/1616404156-11772-1-git-send-email-linyunsheng@huawei.com/

2. implement lockless enqueuing for lockless qdisc using the idea
   from Jason and Toke. And it has a noticable proformance increase with
   1-4 threads running using the below prototype based on ptr_ring.

static inline int __ptr_ring_multi_produce(struct ptr_ring *r, void *ptr)
{

        int producer, next_producer;


        do {
                producer = READ_ONCE(r->producer);
                if (unlikely(!r->size) || r->queue[producer])
                        return -ENOSPC;
                next_producer = producer + 1;
                if (unlikely(next_producer >= r->size))
                        next_producer = 0;
        } while(cmpxchg_relaxed(&r->producer, producer, next_producer) != producer);

        /* Make sure the pointer we are storing points to a valid data. */
        /* Pairs with the dependency ordering in __ptr_ring_consume. */
        smp_wmb();

        WRITE_ONCE(r->queue[producer], ptr);
        return 0;
}

3. Maybe it is possible to remove the netif_tx_lock for lockless qdisc
   too, because dev_hard_start_xmit is also in the protection of
   qdisc_run_begin()/qdisc_run_end()(if there is only one qdisc using
   a netdev queue, which is true for pfifo_fast, I believe).

4. Remove the qdisc->running seqcount operation for lockless qdisc, which
   is mainly used to do heuristic locking on q->busylock for locked qdisc.

> 
>> Is there any reason why you want to revert it?
>>
> I think you know Jiri's plan and it would be nice to wait a couple of
> months for it to complete.

I am not sure I am aware of Jiri's plan.
Is there any link referring to the plan?

> 
> .
> 

