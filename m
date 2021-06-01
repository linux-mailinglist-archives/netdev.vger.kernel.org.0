Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186C7396EB4
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhFAIUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:20:40 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3316 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbhFAIUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:20:38 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FvQ121RVYz19S9G;
        Tue,  1 Jun 2021 16:14:14 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 16:18:55 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 1 Jun 2021
 16:18:55 +0800
Subject: Re: [Linuxarm] Re: [PATCH net-next 2/3] net: sched: implement
 TCQ_F_CAN_BYPASS for lockless qdisc
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Yunsheng Lin <yunshenglin0825@gmail.com>, <davem@davemloft.net>,
        <olteanv@gmail.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andriin@fb.com>, <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
References: <1622170197-27370-1-git-send-email-linyunsheng@huawei.com>
 <1622170197-27370-3-git-send-email-linyunsheng@huawei.com>
 <20210528180012.676797d6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <a6a965ee-7368-d37b-9c70-bba50c67eec9@huawei.com>
 <20210528213218.2b90864c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <ee1a62da-9758-70db-abd3-c5ca2e8e0ce0@huawei.com>
 <20210529114919.4f8b1980@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <9cc9f513-7655-07df-3c74-5abe07ae8321@gmail.com>
 <20210530132111.3a974275@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <3c2fbc70-841f-d90b-ca13-1f058169be50@huawei.com>
 <3a307707-9fb5-d73a-01f9-93aaf5c7a437@huawei.com>
 <428f92d8-f4a2-13cf-8dcc-b38d48a42965@huawei.com>
 <20210531215146.5ca802a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <cf75e1f4-7972-8efa-7554-fc528c5da380@huawei.com>
Date:   Tue, 1 Jun 2021 16:18:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210531215146.5ca802a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/1 12:51, Jakub Kicinski wrote:
> On Mon, 31 May 2021 20:40:01 +0800 Yunsheng Lin wrote:
>> On 2021/5/31 9:10, Yunsheng Lin wrote:
>>> On 2021/5/31 8:40, Yunsheng Lin wrote:  
>>>> On 2021/5/31 4:21, Jakub Kicinski wrote:  
>>  [...]  >>>
>>>
>>>          CPU1                                   CPU2
>>>    qdisc_run_begin(q)                            .
>>>            .                                enqueue skb1
>>>      dequeue skb1                                .
>>>            .                                     .
>>> netdevice stopped and MISSED is clear            .
>>>            .                        nolock_qdisc_is_empty() return true
>>>      requeue skb                                 .
>>>            .                                     .
>>>            .                                     .
>>>            .                                     .
>>>   qdisc_run_end(q)                               .
>>>            .                              qdisc_run_begin(q)
>>>            .                             transmit skb2 directly
>>>            .                           transmit the requeued skb1
>>>
>>> The above sequence diagram seems more correct, it is basically about how to
>>> avoid transmitting a packet directly bypassing the requeued packet.
> 
> I see, thanks! That explains the need. Perhaps we can rephrase the
> comment? Maybe:
> 
> +			/* Retest nolock_qdisc_is_empty() within the protection
> +			 * of q->seqlock to protect from racing with requeuing.
> +			 */

Yes if we still decide to preserve the nolock_qdisc_is_empty() rechecking
under q->seqlock.

> 
>> I had did some interesting testing to show how adjust a small number
>> of code has some notiable performance degrade.
>>
>> 1. I used below patch to remove the nolock_qdisc_is_empty() testing
>>    under q->seqlock.
>>
>> @@ -3763,17 +3763,6 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>>         if (q->flags & TCQ_F_NOLOCK) {
>>                 if (q->flags & TCQ_F_CAN_BYPASS && nolock_qdisc_is_empty(q) &&
>>                     qdisc_run_begin(q)) {
>> -                       /* Retest nolock_qdisc_is_empty() within the protection
>> -                        * of q->seqlock to ensure qdisc is indeed empty.
>> -                        */
>> -                       if (unlikely(!nolock_qdisc_is_empty(q))) {
>> -                               rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
>> -                               __qdisc_run(q);
>> -                               qdisc_run_end(q);
>> -
>> -                               goto no_lock_out;
>> -                       }
>> -
>>                         qdisc_bstats_cpu_update(q, skb);
>>                         if (sch_direct_xmit(skb, q, dev, txq, NULL, true) &&
>>                             !nolock_qdisc_is_empty(q))
>> @@ -3786,7 +3775,6 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>>                 rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
>>                 qdisc_run(q);
>>
>> -no_lock_out:
>>                 if (unlikely(to_free))
>>                         kfree_skb_list(to_free);
>>                 return rc;
>>
>> which has the below performance improvement:
>>
>>  threads      v1             v1 + above patch          delta
>>     1       3.21Mpps            3.20Mpps               -0.3%
>>     2       5.56Mpps            5.94Mpps               +4.9%
>>     4       5.58Mpps            5.60Mpps               +0.3%
>>     8       2.76Mpps            2.77Mpps               +0.3%
>>    16       2.23Mpps            2.23Mpps               +0.0%
>>
>> v1 = this patchset.
>>
>>
>> 2. After the above testing, it seems worthwhile to remove the
>>    nolock_qdisc_is_empty() testing under q->seqlock, so I used below
>>    patch to make sure nolock_qdisc_is_empty() always return false for
>>    netdev queue stopped case。
>>
>> --- a/net/sched/sch_generic.c
>> +++ b/net/sched/sch_generic.c
>> @@ -38,6 +38,15 @@ EXPORT_SYMBOL(default_qdisc_ops);
>>  static void qdisc_maybe_clear_missed(struct Qdisc *q,
>>                                      const struct netdev_queue *txq)
>>  {
>> +       set_bit(__QDISC_STATE_DRAINING, &q->state);
>> +
>> +       /* Make sure DRAINING is set before clearing MISSED
>> +        * to make sure nolock_qdisc_is_empty() always return
>> +        * false for aoviding transmitting a packet directly
>> +        * bypassing the requeued packet.
>> +        */
>> +       smp_mb__after_atomic();
>> +
>>         clear_bit(__QDISC_STATE_MISSED, &q->state);
>>
>>         /* Make sure the below netif_xmit_frozen_or_stopped()
>> @@ -52,8 +61,6 @@ static void qdisc_maybe_clear_missed(struct Qdisc *q,
>>          */
>>         if (!netif_xmit_frozen_or_stopped(txq))
>>                 set_bit(__QDISC_STATE_MISSED, &q->state);
>> -       else
>> -               set_bit(__QDISC_STATE_DRAINING, &q->state);
>>  }
> 
> But this would not be enough because we may also clear MISSING 
> in pfifo_fast_dequeue()?

For the MISSING clearing in pfifo_fast_dequeue(), it seems it
looks like the data race described in RFC v3 too?

      CPU1                 CPU2               CPU3
qdisc_run_begin(q)          .                  .
        .              MISSED is set           .
  MISSED is cleared         .                  .
    q->dequeue()            .                  .
        .              enqueue skb1     check MISSED # true
qdisc_run_end(q)            .                  .
        .                   .         qdisc_run_begin(q) # true
        .            MISSED is set      send skb2 directly


> 
>> which has the below performance data:
>>
>>  threads      v1          v1 + above two patch          delta
>>     1       3.21Mpps            3.20Mpps               -0.3%
>>     2       5.56Mpps            5.94Mpps               +4.9%
>>     4       5.58Mpps            5.02Mpps                -10%
>>     8       2.76Mpps            2.77Mpps               +0.3%
>>    16       2.23Mpps            2.23Mpps               +0.0%
>>
>> So the adjustment in qdisc_maybe_clear_missed() seems to have
>> caused about 10% performance degradation for 4 threads case.
>>
>> And the cpu topdown perf data suggested that icache missed and
>> bad Speculation play the main factor to those performance difference.
>>
>> I tried to control the above factor by removing the inline function
>> and add likely and unlikely tag for netif_xmit_frozen_or_stopped()
>> in sch_generic.c.
>>
>> And after removing the inline mark for function in sch_generic.c
>> and add likely/unlikely tag for netif_xmit_frozen_or_stopped()
>> checking in in sch_generic.c, we got notiable performance improvement
>> for 1/2 threads case(some performance improvement for ip forwarding
>> test too), but not for 4 threads case.
>>
>> So it seems we need to ignore the performance degradation for 4
>> threads case? or any idea?
> 
> No ideas, are the threads pinned to CPUs in some particular way?

The pktgen seems already runnig a thread for each CPU, so I do not
need to do the pinning myself, for the 4 threads case, it runs on
the 0~3 cpu.

It seems more related to specific cpu implemantaion.

> 
> .
> 

