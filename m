Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7FD35C5D9
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 14:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240799AbhDLMBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 08:01:06 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3397 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240733AbhDLMBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 08:01:05 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FJnL93smNz5pnK;
        Mon, 12 Apr 2021 19:57:53 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 12 Apr 2021 20:00:43 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Mon, 12 Apr
 2021 20:00:44 +0800
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
To:     Hillf Danton <hdanton@sina.com>
CC:     Juergen Gross <jgross@suse.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jiri Kosina <JKosina@suse.com>
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
 <20210409090909.1767-1-hdanton@sina.com>
 <20210412032111.1887-1-hdanton@sina.com>
 <20210412072856.2046-1-hdanton@sina.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <d7b8a391-0b2f-f0a9-82ed-0609addcadb2@huawei.com>
Date:   Mon, 12 Apr 2021 20:00:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210412072856.2046-1-hdanton@sina.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/12 15:28, Hillf Danton wrote:
> On Mon, 12 Apr 2021 11:37:24 Yunsheng Lin wrote:
>> On 2021/4/12 11:21, Hillf Danton wrote:
>>> On Mon, 12 Apr 2021 09:24:30  Yunsheng Lin wrote:
>>>> On 2021/4/9 17:09, Hillf Danton wrote:
>>>>> On Fri, 9 Apr 2021 07:31:03  Juergen Gross wrote:
>>>>>> On 25.03.21 04:13, Yunsheng Lin wrote:
>>>>>> I have a setup which is able to reproduce the issue quite reliably:
>>>>>>
>>>>>> In a Xen guest I'm mounting 8 NFS shares and run sysbench fileio on
>>>>>> each of them. The average latency reported by sysbench is well below
>>>>>> 1 msec, but at least once per hour I get latencies in the minute
>>>>>> range.
>>>>>>
>>>>>> With this patch I don't see these high latencies any longer (test
>>>>>> is running for more than 20 hours now).
>>>>>>
>>>>>> So you can add my:
>>>>>>
>>>>>> Tested-by: Juergen Gross <jgross@suse.com>
>>>>>>
>>>>>
>>>>> If retry is allowed in the dequeue method then a simple seqcount can do the
>>>>> work of serializing enqueuer and dequeuer. IIUC it was not attempted last year.
>>>>
>>>> At the first glance, I do not think the below patch fix the data race
>>>
>>> Thanks for taking a look.
>>>
>>>> described in the commit log, as it does not handle the time window
>>>> between dequeuing and q->seqlock releasing, as below:
>>>>
>>> Yes the time window does exist.
>>>
>>>> The cpu1 may not see the qdisc->pad changed after pfifo_fast_dequeue(),
>>>> and cpu2 is not able to take the q->seqlock yet because cpu1 do not
>>>> release the q->seqlock.
>>>>
>>> It's now covered by extending the seqcount aperture a bit.
>>>
>>> --- x/net/sched/sch_generic.c
>>> +++ y/net/sched/sch_generic.c
>>> @@ -380,14 +380,23 @@ void __qdisc_run(struct Qdisc *q)
>>>  {
>>>  	int quota = dev_tx_weight;
>>>  	int packets;
>>> +	int seq;
>>> +
>>> +again:
>>> +	seq = READ_ONCE(q->pad);
>>> +	smp_rmb();
>>>  
>>>  	while (qdisc_restart(q, &packets)) {
>>>  		quota -= packets;
>>>  		if (quota <= 0) {
>>>  			__netif_schedule(q);
>>> -			break;
>>> +			return;
>>>  		}
>>>  	}
>>> +
>>> +	smp_rmb();
>>> +	if (seq != READ_ONCE(q->pad))
>>> +		goto again;
>>
>> As my understanding, there is still time window between q->pad checking
>> above and q->seqlock releasing in qdisc_run_end().
>>
> Then extend the cover across q->seqlock on top of the flag you added.

Yes, the below patch seems to fix the data race described in
the commit log.
Then what is the difference between my patch and your patch below:)

> 
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -36,6 +36,7 @@ struct qdisc_rate_table {
>  enum qdisc_state_t {
>  	__QDISC_STATE_SCHED,
>  	__QDISC_STATE_DEACTIVATED,
> +	__QDISC_STATE_NEED_RESCHEDULE,
>  };
>  
>  struct qdisc_size_table {
> @@ -176,8 +177,13 @@ static inline bool qdisc_run_begin(struc
>  static inline void qdisc_run_end(struct Qdisc *qdisc)
>  {
>  	write_seqcount_end(&qdisc->running);
> -	if (qdisc->flags & TCQ_F_NOLOCK)
> +	if (qdisc->flags & TCQ_F_NOLOCK) {
>  		spin_unlock(&qdisc->seqlock);
> +
> +		if (test_and_clear_bit(__QDISC_STATE_NEED_RESCHEDULE,
> +							&qdisc->state))
> +			__netif_schedule(qdisc);
> +	}
>  }
>  
>  static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -381,13 +381,21 @@ void __qdisc_run(struct Qdisc *q)
>  	int quota = dev_tx_weight;
>  	int packets;
>  
> +	if (q->flags & TCQ_F_NOLOCK)
> +		clear_bit(__QDISC_STATE_NEED_RESCHEDULE, &q->state);
> +again:
>  	while (qdisc_restart(q, &packets)) {
>  		quota -= packets;
>  		if (quota <= 0) {
>  			__netif_schedule(q);
> -			break;
> +			return;
>  		}
>  	}
> +
> +	if (q->flags & TCQ_F_NOLOCK)
> +		if (test_and_clear_bit(__QDISC_STATE_NEED_RESCHEDULE,
> +					&q->state))
> +			goto again;
>  }
>  
>  unsigned long dev_trans_start(struct net_device *dev)
> @@ -632,6 +640,9 @@ static int pfifo_fast_enqueue(struct sk_
>  			return qdisc_drop(skb, qdisc, to_free);
>  	}
>  
> +	if (qdisc->flags & TCQ_F_NOLOCK)
> +		set_bit(__QDISC_STATE_NEED_RESCHEDULE, &qdisc->state);

Doing set_bit() in pfifo_fast_enqueue() unconditionally does not
seems to be performance friendly, because it requires exclusive access
to the cache line of qdisc->state.
Perhaps do some performance test?


> +
>  	qdisc_update_stats_at_enqueue(qdisc, pkt_len);
>  	return NET_XMIT_SUCCESS;
>  }
> 
> .
> 

