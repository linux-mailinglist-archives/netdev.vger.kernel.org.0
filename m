Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1018C34364B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 02:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhCVBcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 21:32:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3911 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhCVBbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 21:31:46 -0400
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4F3cP11wfDz5gf4;
        Mon, 22 Mar 2021 09:29:41 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML403-HUB.china.huawei.com (10.3.17.33) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 22 Mar 2021 09:31:38 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Mon, 22 Mar
 2021 09:31:38 +0800
Subject: Re: [PATCH net] net: sched: fix packet stuck problem for lockless
 qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        Josh Hunt <johunt@akamai.com>,
        "Jike Song" <albcamus@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>
References: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpXU_jAbE4TC3ezZbfbYmYeViVgea+xyqPAxc5XTL9+cVw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <13898fcd-3480-7dbc-3747-09c5ad725195@huawei.com>
Date:   Mon, 22 Mar 2021 09:31:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXU_jAbE4TC3ezZbfbYmYeViVgea+xyqPAxc5XTL9+cVw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/20 3:40, Cong Wang wrote:
> On Wed, Mar 17, 2021 at 11:52 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> Lockless qdisc has below concurrent problem:
>>         cpu0                  cpu1
>>           .                     .
>>      q->enqueue                 .
>>           .                     .
>>    qdisc_run_begin()            .
>>           .                     .
>>      dequeue_skb()              .
>>           .                     .
>>    sch_direct_xmit()            .
>>           .                     .
>>           .                q->enqueue
>>           .             qdisc_run_begin()
>>           .            return and do nothing
>>           .                     .
>> qdisc_run_end()                 .
>>
>> cpu1 enqueue a skb without calling __qdisc_run() because cpu0
>> has not released the lock yet and spin_trylock() return false
>> for cpu1 in qdisc_run_begin(), and cpu0 do not see the skb
>> enqueued by cpu1 when calling dequeue_skb() because cpu1 may
>> enqueue the skb after cpu0 calling dequeue_skb() and before
>> cpu0 calling qdisc_run_end().
>>
>> Lockless qdisc has another concurrent problem when tx_action
>> is involved:
>>
>> cpu0(serving tx_action)     cpu1             cpu2
>>           .                   .                .
>>           .              q->enqueue            .
>>           .            qdisc_run_begin()       .
>>           .              dequeue_skb()         .
>>           .                   .            q->enqueue
>>           .                   .                .
>>           .             sch_direct_xmit()      .
>>           .                   .         qdisc_run_begin()
>>           .                   .       return and do nothing
>>           .                   .                .
>> clear __QDISC_STATE_SCHED     .                .
>>     qdisc_run_begin()         .                .
>> return and do nothing         .                .
>>           .                   .                .
>>           .          qdisc_run_begin()         .
>>
>> This patch fixes the above data race by:
>> 1. Set a flag after spin_trylock() return false.
>> 2. Retry a spin_trylock() in case other CPU may not see the
>>    new flag after it releases the lock.
>> 3. reschedule if the flag is set after the lock is released
>>    at the end of qdisc_run_end().
>>
>> For tx_action case, the flags is also set when cpu1 is at the
>> end if qdisc_run_begin(), so tx_action will be rescheduled
>> again to dequeue the skb enqueued by cpu2.
>>
>> Also clear the flag before dequeuing in order to reduce the
>> overhead of the above process, and aviod doing the heavy
>> test_and_clear_bit() at the end of qdisc_run_end().
>>
>> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>> For those who has not been following the qdsic scheduling
>> discussion, there is packet stuck problem for lockless qdisc,
>> see [1], and I has done some cleanup and added some enhanced
>> features too, see [2] [3].
>> While I was doing the optimization for lockless qdisc, it
>> accurred to me that these optimization is useless if there is
>> still basic bug in lockless qdisc, even the bug is not easily
>> reproducible. So look through [1] again, I found that the data
>> race for tx action mentioned by Michael, and thought deep about
>> it and came up with this patch trying to fix it.
>>
>> So I am really appreciated some who still has the reproducer
>> can try this patch and report back.
>>
>> 1. https://lore.kernel.org/netdev/d102074f-7489-e35a-98cf-e2cad7efd8a2@netrounds.com/t/#ma7013a79b8c4d8e7c49015c724e481e6d5325b32
>> 2. https://patchwork.kernel.org/project/netdevbpf/patch/1615777818-13969-1-git-send-email-linyunsheng@huawei.com/
>> 3. https://patchwork.kernel.org/project/netdevbpf/patch/1615800610-34700-1-git-send-email-linyunsheng@huawei.com/
>> ---
>>  include/net/sch_generic.h | 23 ++++++++++++++++++++---
>>  net/sched/sch_generic.c   |  1 +
>>  2 files changed, 21 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
>> index f7a6e14..4220eab 100644
>> --- a/include/net/sch_generic.h
>> +++ b/include/net/sch_generic.h
>> @@ -36,6 +36,7 @@ struct qdisc_rate_table {
>>  enum qdisc_state_t {
>>         __QDISC_STATE_SCHED,
>>         __QDISC_STATE_DEACTIVATED,
>> +       __QDISC_STATE_NEED_RESCHEDULE,
>>  };
>>
>>  struct qdisc_size_table {
>> @@ -159,8 +160,17 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
>>  static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>>  {
>>         if (qdisc->flags & TCQ_F_NOLOCK) {
>> -               if (!spin_trylock(&qdisc->seqlock))
>> -                       return false;
>> +               if (!spin_trylock(&qdisc->seqlock)) {
>> +                       set_bit(__QDISC_STATE_NEED_RESCHEDULE,
>> +                               &qdisc->state);
> 
> Why do we need another bit? I mean why not just call __netif_schedule()?

I think that was your proposal in [1], the only difference is that
it also handle the tx_action case when __netif_schedule() is called
here.

So yes, it can also fix the two data race described in this patch, but
with a bigger performance degradation, quoting performance data in the
[1]:

pktgen threads	vanilla		patched		delta
nr		kpps		kpps		%

1		3240		3240		0
2		3910		2710		-30.5
4		5140		4920		-4


performance data with this patch:

threads  vanilla       vanilla+this_patch       delta
   1     2.6Mpps            2.5Mpps              -3%
   2     3.9Mpps            3.6Mpps              -7%
   4     5.6Mpps            4.7Mpps             -16%


So the performance is why I does not call __netif_schedule() directly
here.

1. https://lore.kernel.org/netdev/d102074f-7489-e35a-98cf-e2cad7efd8a2@netrounds.com/t/#md927651488ce4d226f6279aad6699b4bee4674a3

> 
>> +
>> +                       /* Retry again in case other CPU may not see the
>> +                        * new flags after it releases the lock at the
>> +                        * end of qdisc_run_end().
>> +                        */
>> +                       if (!spin_trylock(&qdisc->seqlock))
>> +                               return false;
>> +               }
>>                 WRITE_ONCE(qdisc->empty, false);
>>         } else if (qdisc_is_running(qdisc)) {
>>                 return false;
>> @@ -176,8 +186,15 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>>  static inline void qdisc_run_end(struct Qdisc *qdisc)
>>  {
>>         write_seqcount_end(&qdisc->running);
>> -       if (qdisc->flags & TCQ_F_NOLOCK)
>> +       if (qdisc->flags & TCQ_F_NOLOCK) {
>>                 spin_unlock(&qdisc->seqlock);
>> +
>> +               if (unlikely(test_bit(__QDISC_STATE_NEED_RESCHEDULE,
>> +                                     &qdisc->state) &&
>> +                            !test_bit(__QDISC_STATE_DEACTIVATED,
>> +                                      &qdisc->state)))
> 
> Testing two bits one by one is not atomic...

For non-tx_action case, actually it is atomic because the above
two bits testing is within the rcu protection, and qdisc reset
will do a synchronize_net() after setting __QDISC_STATE_DEACTIVATED.

For tx_action case, I think we need a rcu protection explicitly in
net_tx_action() too, at least for PREEMPT_RCU:

https://stackoverflow.com/questions/21287932/is-it-necessary-invoke-rcu-read-lock-in-softirq-context

> 
> 
>> +                       __netif_schedule(qdisc);
>> +       }
>>  }
>>
>>  static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
>> index 44991ea..25d75d8 100644
>> --- a/net/sched/sch_generic.c
>> +++ b/net/sched/sch_generic.c
>> @@ -205,6 +205,7 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
>>         const struct netdev_queue *txq = q->dev_queue;
>>         struct sk_buff *skb = NULL;
>>
>> +       clear_bit(__QDISC_STATE_NEED_RESCHEDULE, &q->state);
>>         *packets = 1;
>>         if (unlikely(!skb_queue_empty(&q->gso_skb))) {
>>                 spinlock_t *lock = NULL;
>> --
>> 2.7.4
>>
> 
> .
> 

