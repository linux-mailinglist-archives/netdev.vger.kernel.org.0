Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9286B33D3FC
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 13:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbhCPMh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 08:37:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3486 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbhCPMgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 08:36:53 -0400
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4F0CRb01qVzRQWX;
        Tue, 16 Mar 2021 20:35:07 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 16 Mar 2021 20:36:50 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 16 Mar
 2021 20:36:50 +0800
Subject: Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS for lockless
 qdisc
To:     Eric Dumazet <edumazet@google.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Wei Wang" <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
 <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3838b7c2-c32f-aeda-702a-5cb8f712ec0c@huawei.com>
 <CANn89iKQOxvGkr3g37xT1qkcc55gbRGNkFGcGLQmR1PVaq8RjA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <4eb6bb79-0122-3472-d4a6-ed41475f6a96@huawei.com>
Date:   Tue, 16 Mar 2021 20:36:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKQOxvGkr3g37xT1qkcc55gbRGNkFGcGLQmR1PVaq8RjA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/16 16:15, Eric Dumazet wrote:
> On Tue, Mar 16, 2021 at 1:35 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2021/3/16 2:53, Jakub Kicinski wrote:
>>> On Mon, 15 Mar 2021 11:10:18 +0800 Yunsheng Lin wrote:
>>>> @@ -606,6 +623,11 @@ static const u8 prio2band[TC_PRIO_MAX + 1] = {
>>>>   */
>>>>  struct pfifo_fast_priv {
>>>>      struct skb_array q[PFIFO_FAST_BANDS];
>>>> +
>>>> +    /* protect against data race between enqueue/dequeue and
>>>> +     * qdisc->empty setting
>>>> +     */
>>>> +    spinlock_t lock;
>>>>  };
>>>>
>>>>  static inline struct skb_array *band2list(struct pfifo_fast_priv *priv,
>>>> @@ -623,7 +645,10 @@ static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
>>>>      unsigned int pkt_len = qdisc_pkt_len(skb);
>>>>      int err;
>>>>
>>>> -    err = skb_array_produce(q, skb);
>>>> +    spin_lock(&priv->lock);
>>>> +    err = __ptr_ring_produce(&q->ring, skb);
>>>> +    WRITE_ONCE(qdisc->empty, false);
>>>> +    spin_unlock(&priv->lock);
>>>>
>>>>      if (unlikely(err)) {
>>>>              if (qdisc_is_percpu_stats(qdisc))
>>>> @@ -642,6 +667,7 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>>>>      struct sk_buff *skb = NULL;
>>>>      int band;
>>>>
>>>> +    spin_lock(&priv->lock);
>>>>      for (band = 0; band < PFIFO_FAST_BANDS && !skb; band++) {
>>>>              struct skb_array *q = band2list(priv, band);
>>>>
>>>> @@ -655,6 +681,7 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>>>>      } else {
>>>>              WRITE_ONCE(qdisc->empty, true);
>>>>      }
>>>> +    spin_unlock(&priv->lock);
>>>>
>>>>      return skb;
>>>>  }
>>>
>>> I thought pfifo was supposed to be "lockless" and this change
>>> re-introduces a lock between producer and consumer, no?
>>
>> Yes, the lock breaks the "lockless" of the lockless qdisc for now
>> I do not how to solve the below data race locklessly:
>>
>>         CPU1:                                   CPU2:
>>       dequeue skb                                .
>>           .                                      .
>>           .                                 enqueue skb
>>           .                                      .
>>           .                      WRITE_ONCE(qdisc->empty, false);
>>           .                                      .
>>           .                                      .
>> WRITE_ONCE(qdisc->empty, true);
> 
> 
> Maybe it is time to fully document/explain how this can possibly work.

I might be able to provide some document/explain on how the lockless
qdisc work for I was looking through the code the past few days.

By "lockless", I suppose it means there is no lock between enqueuing and
dequeuing, whoever grasps the qdisc->seqlock can dequeue the skb and send
it out after enqueuing the skb it tries to send, other CPU which does not
grasp the qdisc->seqlock just enqueue the skb and return, hoping other cpu
holding the qdisc->seqlock can dequeue it's skb and send it out.

For the locked qdisck(the one without TCQ_F_NOLOCK flags set), it holds
the qdisc_lock() when doing the enqueuing/dequeuing and sch_direct_xmit(),
and in sch_direct_xmit() it releases the qdisc_lock() when doing skb validation
and calling dev_hard_start_xmit() to send skb to the driver, and hold the
qdisc_lock() again after calling dev_hard_start_xmit(), so other cpu may
grasps the qdisc_lock() and repeat the above process during that qdisc_lock()
release period.

So the main difference between lockess qdisc and locked qdisc is if
there is a lock to protect both enqueuing and dequeuing. For example, pfifo_fast
uses ptr_ring to become lockless for enqueuing or dequeuing, but it still needs
producer_lock to protect the concurrent enqueue, and consumer_lock to protect
the concurrent dequeue. for Other qdisc that can not provide the lockless between
enqueuing or dequeuing, maybe we implement the locking in the specific qdisc
implementation, so that it still can claim to be "lockless", like the locking
added for pfifo_fast in this patch.

Idealy we can claim all qdisc to be lockess qdisc as long as we make sure
all qdisc either use lockless implementation, or use internal lock to protect
between enqueuing and dequeuing, so that we can remove the locked dqisc and
will have less contention between enqueuing and dequeuing.

Below patch is the first try to remove the difference between lockess qdisc
and locked qdisc, so that we can see if we can remove the locked qdisc in the
future:

https://patchwork.kernel.org/project/netdevbpf/patch/1615800610-34700-1-git-send-email-linyunsheng@huawei.com/

I may be wrong about the above analysis, if there is any error, please
point it out.

> 
> lockless qdisc used concurrently by multiple cpus, using
> WRITE_ONCE() and READ_ONCE() ?
> 
> Just say no to this.

what do you mean "no" here? Do you mean it is impossible to implement lockless
qdisc correctly?  Or TCQ_F_CAN_BYPASS for lockless qdisc is a wrong direction?
And is there any reason?

> 
>>
>> If the above happens, the qdisc->empty is true even if the qdisc has some
>> skb, which may cuase out of order or packet stuck problem.
>>
>> It seems we may need to update ptr_ring' status(empty or not) while
>> enqueuing/dequeuing atomically in the ptr_ring implementation.
>>
>> Any better idea?
> 
> .
> 

