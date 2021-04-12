Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C504E35B7E2
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 03:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbhDLBFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 21:05:01 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5126 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbhDLBFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 21:05:00 -0400
Received: from dggeml405-hub.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FJVp16GyHzYVpt;
        Mon, 12 Apr 2021 09:02:33 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml405-hub.china.huawei.com (10.3.17.49) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 12 Apr 2021 09:04:37 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Mon, 12 Apr
 2021 09:04:37 +0800
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
To:     Juergen Gross <jgross@suse.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <olteanv@gmail.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
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
        <alexander.duyck@gmail.com>, Jiri Kosina <JKosina@suse.com>
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
 <eb0e44fe-bbe0-75ba-fd16-cbf4638e1c0d@suse.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c0e6bb67-1f60-b784-0baa-4a942b0f1f1e@huawei.com>
Date:   Mon, 12 Apr 2021 09:04:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <eb0e44fe-bbe0-75ba-fd16-cbf4638e1c0d@suse.com>
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

On 2021/4/9 13:31, Juergen Gross wrote:
> On 25.03.21 04:13, Yunsheng Lin wrote:
>> Lockless qdisc has below concurrent problem:
>>      cpu0                 cpu1
>>       .                     .
>> q->enqueue                 .
>>       .                     .
>> qdisc_run_begin()          .
>>       .                     .
>> dequeue_skb()              .
>>       .                     .
>> sch_direct_xmit()          .
>>       .                     .
>>       .                q->enqueue
>>       .             qdisc_run_begin()
>>       .            return and do nothing
>>       .                     .
>> qdisc_run_end()            .
>>
>> cpu1 enqueue a skb without calling __qdisc_run() because cpu0
>> has not released the lock yet and spin_trylock() return false
>> for cpu1 in qdisc_run_begin(), and cpu0 do not see the skb
>> enqueued by cpu1 when calling dequeue_skb() because cpu1 may
>> enqueue the skb after cpu0 calling dequeue_skb() and before
>> cpu0 calling qdisc_run_end().
>>
>> Lockless qdisc has below another concurrent problem when
>> tx_action is involved:
>>
>> cpu0(serving tx_action)     cpu1             cpu2
>>            .                   .                .
>>            .              q->enqueue            .
>>            .            qdisc_run_begin()       .
>>            .              dequeue_skb()         .
>>            .                   .            q->enqueue
>>            .                   .                .
>>            .             sch_direct_xmit()      .
>>            .                   .         qdisc_run_begin()
>>            .                   .       return and do nothing
>>            .                   .                .
>>   clear __QDISC_STATE_SCHED    .                .
>>   qdisc_run_begin()            .                .
>>   return and do nothing        .                .
>>            .                   .                .
>>            .            qdisc_run_end()         .
>>
>> This patch fixes the above data race by:
>> 1. Get the flag before doing spin_trylock().
>> 2. If the first spin_trylock() return false and the flag is not
>>     set before the first spin_trylock(), Set the flag and retry
>>     another spin_trylock() in case other CPU may not see the new
>>     flag after it releases the lock.
>> 3. reschedule if the flags is set after the lock is released
>>     at the end of qdisc_run_end().
>>
>> For tx_action case, the flags is also set when cpu1 is at the
>> end if qdisc_run_end(), so tx_action will be rescheduled
>> again to dequeue the skb enqueued by cpu2.
>>
>> Only clear the flag before retrying a dequeuing when dequeuing
>> returns NULL in order to reduce the overhead of the above double
>> spin_trylock() and __netif_schedule() calling.
>>
>> The performance impact of this patch, tested using pktgen and
>> dummy netdev with pfifo_fast qdisc attached:
>>
>>   threads  without+this_patch   with+this_patch      delta
>>      1        2.61Mpps            2.60Mpps           -0.3%
>>      2        3.97Mpps            3.82Mpps           -3.7%
>>      4        5.62Mpps            5.59Mpps           -0.5%
>>      8        2.78Mpps            2.77Mpps           -0.3%
>>     16        2.22Mpps            2.22Mpps           -0.0%
>>
>> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> I have a setup which is able to reproduce the issue quite reliably:
> 
> In a Xen guest I'm mounting 8 NFS shares and run sysbench fileio on
> each of them. The average latency reported by sysbench is well below
> 1 msec, but at least once per hour I get latencies in the minute
> range.
> 
> With this patch I don't see these high latencies any longer (test
> is running for more than 20 hours now).
> 
> So you can add my:
> 
> Tested-by: Juergen Gross <jgross@suse.com>

Hi, Juergen

Thanks for the testing.

With the simulated test case suggested by Michal, I still has some
potential issue to debug, hopefully will send out new version in
this week.

Also, is it possible to run your testcase any longer? I think "72 hours"
would be enough to testify that it fixes the problem completely:)



> 
> 
> Juergen

