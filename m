Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC6E34182E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 10:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhCSJ0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 05:26:06 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3492 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCSJZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 05:25:54 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4F1z3j2LlvzRRYx;
        Fri, 19 Mar 2021 17:24:01 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 19 Mar 2021 17:25:46 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Fri, 19 Mar
 2021 17:25:47 +0800
Subject: Re: [Linuxarm] [PATCH net] net: sched: fix packet stuck problem for
 lockless qdisc
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
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
        "Ahmad Fatoum" <a.fatoum@pengutronix.de>
References: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
Message-ID: <e5c2d82c-0158-3997-80b6-4aab56c61367@huawei.com>
Date:   Fri, 19 Mar 2021 17:25:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/18 14:53, Yunsheng Lin wrote:
> Lockless qdisc has below concurrent problem:
>         cpu0                  cpu1
>           .                     .
>      q->enqueue                 .
>           .                     .
>    qdisc_run_begin()            .
>           .                     .
>      dequeue_skb()              .
>           .                     .
>    sch_direct_xmit()            .
>           .                     .
>           .                q->enqueue
>           .             qdisc_run_begin()
>           .            return and do nothing
>           .                     .
> qdisc_run_end()                 .
> 
> cpu1 enqueue a skb without calling __qdisc_run() because cpu0
> has not released the lock yet and spin_trylock() return false
> for cpu1 in qdisc_run_begin(), and cpu0 do not see the skb
> enqueued by cpu1 when calling dequeue_skb() because cpu1 may
> enqueue the skb after cpu0 calling dequeue_skb() and before
> cpu0 calling qdisc_run_end().
> 
> Lockless qdisc has another concurrent problem when tx_action
> is involved:
> 
> cpu0(serving tx_action)     cpu1             cpu2
>           .                   .                .
>           .              q->enqueue            .
>           .            qdisc_run_begin()       .
>           .              dequeue_skb()         .
>           .                   .            q->enqueue
>           .                   .                .
>           .             sch_direct_xmit()      .
>           .                   .         qdisc_run_begin()
>           .                   .       return and do nothing
>           .                   .                .
> clear __QDISC_STATE_SCHED     .                .
>     qdisc_run_begin()         .                .
> return and do nothing         .                .
>           .                   .                .
>           .          qdisc_run_begin()         .
> 
> This patch fixes the above data race by:
> 1. Set a flag after spin_trylock() return false.
> 2. Retry a spin_trylock() in case other CPU may not see the
>    new flag after it releases the lock.
> 3. reschedule if the flag is set after the lock is released
>    at the end of qdisc_run_end().
> 
> For tx_action case, the flags is also set when cpu1 is at the
> end if qdisc_run_begin(), so tx_action will be rescheduled
> again to dequeue the skb enqueued by cpu2.
> 
> Also clear the flag before dequeuing in order to reduce the
> overhead of the above process, and aviod doing the heavy
> test_and_clear_bit() at the end of qdisc_run_end().
> 
> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> For those who has not been following the qdsic scheduling
> discussion, there is packet stuck problem for lockless qdisc,
> see [1], and I has done some cleanup and added some enhanced
> features too, see [2] [3].
> While I was doing the optimization for lockless qdisc, it
> accurred to me that these optimization is useless if there is
> still basic bug in lockless qdisc, even the bug is not easily
> reproducible. So look through [1] again, I found that the data
> race for tx action mentioned by Michael, and thought deep about
> it and came up with this patch trying to fix it.
> 
> So I am really appreciated some who still has the reproducer
> can try this patch and report back.

I had done some performance test to see if there is value to
fix the packet stuck problem and support lockless qdisc bypass,
here is some result using pktgen in 'queue_xmit' mode on a dummy
device as Paolo Abeni had done in [1], and using pfifo_fast qdisc:

threads	 vanilla    locked-qdisc    vanilla+this_patch
   1     2.6Mpps      2.9Mpps            2.5Mpps
   2     3.9Mpps      4.8Mpps            3.6Mpps
   4     5.6Mpps      3.0Mpps            4.7Mpps
   8     2.7Mpps      1.6Mpps            2.8Mpps
   16    2.2Mpps      1.3Mpps            2.3Mpps

locked-qdisc: test by removing the "TCQ_F_NOLOCK | TCQ_F_CPUSTATS".

And add the lockless qdisc bypatch and other optimization upon
this patch:

threads   patch_set_1   patch_set_2     patch_set_3
   1       2.5Mpps        3.0Mpps         3.0Mpps
   2       3.6Mpps        4.1Mpps         5.3Mpps
   4       4.7Mpps        4.6Mpps         5.1Mpps
   8       2.8Mpps        2.6Mpps         2.7Mpps
   16      2.3Mpps        2.2Mpps         2.2Mpps

patch_set_1: vanilla + this_patch
patch_set_2: vanilla + this_patch + lockless_qdisc_bypass_patch
patch_set_3: vanilla + this_patch + lockless_qdisc_bypass_patch +
             remove_seq_operation_for_lockless_qdisc_optimization +
             check_rc_before_calling_qdisc_run()_optimization +
             spin_trylock()_retry_optimization.

So all the fix and optimization added together, the lockless qdisc
has better performance than vanilla except for the 4 threads case,
which has about 9% performance degradation than vanilla one, but still
better than the locked-qdisc.


> 
> 1. https://lore.kernel.org/netdev/d102074f-7489-e35a-98cf-e2cad7efd8a2@netrounds.com/t/#ma7013a79b8c4d8e7c49015c724e481e6d5325b32
> 2. https://patchwork.kernel.org/project/netdevbpf/patch/1615777818-13969-1-git-send-email-linyunsheng@huawei.com/
> 3. https://patchwork.kernel.org/project/netdevbpf/patch/1615800610-34700-1-git-send-email-linyunsheng@huawei.com/
> 

