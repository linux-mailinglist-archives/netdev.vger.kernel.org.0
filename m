Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19806346FA0
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 03:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhCXCg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 22:36:56 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3497 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhCXCgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 22:36:50 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4F4slP6mlzzRSX3;
        Wed, 24 Mar 2021 10:34:57 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 24 Mar 2021 10:36:47 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Wed, 24 Mar
 2021 10:36:47 +0800
Subject: Re: [Linuxarm] Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS
 for lockless qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Eric Dumazet" <edumazet@google.com>, Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
 <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpXvVZxBRHF6PBDOYSOSCj08nPyfcY0adKuuTg=cqffV+w@mail.gmail.com>
 <87eegddhsj.fsf@toke.dk>
 <CAHmME9qDU7VRmBV+v0tzLiUpMJykjswSDwqc9P43ZwG1UD7mzw@mail.gmail.com>
 <3bae7b26-9d7f-15b8-d466-ff5c26d08b35@huawei.com>
 <CAM_iQpVvR1eUQxgihWrZ==X=xQjaaeH_qkehvU0Y2R6i9eM-Qw@mail.gmail.com>
 <9d045462-051e-0cde-24d0-349dd397e2b7@huawei.com>
 <CAM_iQpVgARDaUd3jdvSA11j=Q_K6KvcKfn7DQavGYXUWmvLZtw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <750de5f8-ff1a-a300-e5b5-8381893e2db9@huawei.com>
Date:   Wed, 24 Mar 2021 10:36:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVgARDaUd3jdvSA11j=Q_K6KvcKfn7DQavGYXUWmvLZtw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/24 9:49, Cong Wang wrote:
> On Sun, Mar 21, 2021 at 5:55 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2021/3/20 2:15, Cong Wang wrote:
>>> On Thu, Mar 18, 2021 at 12:33 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>
>>>> On 2021/3/17 21:45, Jason A. Donenfeld wrote:
>>>>> On 3/17/21, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>>>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>>>>>>
>>>>>>> On Mon, Mar 15, 2021 at 2:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>>>>>
>>>>>>>> I thought pfifo was supposed to be "lockless" and this change
>>>>>>>> re-introduces a lock between producer and consumer, no?
>>>>>>>
>>>>>>> It has never been truly lockless, it uses two spinlocks in the ring
>>>>>>> buffer
>>>>>>> implementation, and it introduced a q->seqlock recently, with this patch
>>>>>>> now we have priv->lock, 4 locks in total. So our "lockless" qdisc ends
>>>>>>> up having more locks than others. ;) I don't think we are going to a
>>>>>>> right direction...
>>>>>>
>>>>>> Just a thought, have you guys considered adopting the lockless MSPC ring
>>>>>> buffer recently introduced into Wireguard in commit:
>>>>>>
>>>>>> 8b5553ace83c ("wireguard: queueing: get rid of per-peer ring buffers")
>>>>>>
>>>>>> Jason indicated he was willing to work on generalising it into a
>>>>>> reusable library if there was a use case for it. I haven't quite though
>>>>>> through the details of whether this would be such a use case, but
>>>>>> figured I'd at least mention it :)
>>>>>
>>>>> That offer definitely still stands. Generalization sounds like a lot of fun.
>>>>>
>>>>> Keep in mind though that it's an eventually consistent queue, not an
>>>>> immediately consistent one, so that might not match all use cases. It
>>>>> works with wg because we always trigger the reader thread anew when it
>>>>> finishes, but that doesn't apply to everyone's queueing setup.
>>>>
>>>> Thanks for mentioning this.
>>>>
>>>> "multi-producer, single-consumer" seems to match the lockless qdisc's
>>>> paradigm too, for now concurrent enqueuing/dequeuing to the pfifo_fast's
>>>> queues() is not allowed, it is protected by producer_lock or consumer_lock.
>>>>
>>>> So it would be good to has lockless concurrent enqueuing, while dequeuing
>>>> can be protected by qdisc_lock() or q->seqlock, which meets the "multi-producer,
>>>> single-consumer" paradigm.
>>>
>>> I don't think so. Usually we have one queue for each CPU so we can expect
>>> each CPU has a lockless qdisc assigned, but we can not assume this in
>>> the code, so we still have to deal with multiple CPU's sharing a lockless qdisc,
>>> and we usually enqueue and dequeue in process context, so it means we could
>>> have multiple producers and multiple consumers.
>>
>> For lockless qdisc, dequeuing is always within the qdisc_run_begin() and
>> qdisc_run_end(), so multiple consumers is protected with each other by
>> q->seqlock .
> 
> So are you saying you will never go lockless for lockless qdisc? I thought
> you really want to go lockless with Jason's proposal of MPMC ring buffer
> code.

I think we has different definition about lockless qdisc.

For my understanding, the dequeuing is within the qdisc_run_begin()
and qdisc_run_end(), so it is always protected by q->seqlock for
lockless qdisck currently, and by lockless qdisc, I never mean
lockless dequeuing, and I am not proposing lockless dequeuing
currently.

Current lockless qdisc for pfifo_fast only means there is no lock
for protection between dequeuing and enqueuing, which also means
when __qdisc_run() is dequeuing a skb while other cpu is enqueuing
a skb.

But enqueuing is protected by producer_lock in skb_array_produce(),
so only one cpu can do the enqueuing at the same time, so I am
proposing to use Jason's proposal to enable multi cpus to do
concurrent enqueuing without taking any lock.

> 
>>
>> For enqueuing, multiple consumers is protected by producer_lock, see
>> pfifo_fast_enqueue() -> skb_array_produce() -> ptr_ring_produce().
> 
> I think you seriously misunderstand how we classify MPMC or MPSC,
> it is not about how we lock them, it is about whether we truly have
> a single or multiple consumers regardless of locks used, because the
> goal is to go lockless.

I think I am only relying on the MPSC(multi-produce & single-consumer),
as explained above.

> 
>> I am not sure if lockless MSPC can work with the process context, but
>> even if not, the enqueuing is also protected by rcu_read_lock_bh(),
>> which provides some kind of atomicity, so that producer_lock can be
>> reomved when lockless MSPC is used.
> 
> 
> Not sure if I can even understand what you are saying here, Jason's
> code only disables preemption with busy wait, I can't see why it can
> not be used in the process context.

I am saying q->enqeue() is protected by rcu_read_lock_bh().
rcu_read_lock_bh() will disable preemption for us for most configuation,
otherwise it will break netdev_xmit_more() interface too, for it relies
on the cpu not being prempted by using per cpu var(softnet_data.xmit.more).

> 
> Thanks.
> 
> .
> 

