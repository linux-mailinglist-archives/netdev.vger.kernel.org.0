Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01392343615
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 01:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhCVAzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 20:55:38 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5099 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhCVAzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 20:55:12 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4F3bb62HRPzYMlt;
        Mon, 22 Mar 2021 08:53:22 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 22 Mar 2021 08:55:09 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Mon, 22 Mar
 2021 08:55:09 +0800
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
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <9d045462-051e-0cde-24d0-349dd397e2b7@huawei.com>
Date:   Mon, 22 Mar 2021 08:55:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVvR1eUQxgihWrZ==X=xQjaaeH_qkehvU0Y2R6i9eM-Qw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/20 2:15, Cong Wang wrote:
> On Thu, Mar 18, 2021 at 12:33 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2021/3/17 21:45, Jason A. Donenfeld wrote:
>>> On 3/17/21, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>>>>
>>>>> On Mon, Mar 15, 2021 at 2:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>>>
>>>>>> I thought pfifo was supposed to be "lockless" and this change
>>>>>> re-introduces a lock between producer and consumer, no?
>>>>>
>>>>> It has never been truly lockless, it uses two spinlocks in the ring
>>>>> buffer
>>>>> implementation, and it introduced a q->seqlock recently, with this patch
>>>>> now we have priv->lock, 4 locks in total. So our "lockless" qdisc ends
>>>>> up having more locks than others. ;) I don't think we are going to a
>>>>> right direction...
>>>>
>>>> Just a thought, have you guys considered adopting the lockless MSPC ring
>>>> buffer recently introduced into Wireguard in commit:
>>>>
>>>> 8b5553ace83c ("wireguard: queueing: get rid of per-peer ring buffers")
>>>>
>>>> Jason indicated he was willing to work on generalising it into a
>>>> reusable library if there was a use case for it. I haven't quite though
>>>> through the details of whether this would be such a use case, but
>>>> figured I'd at least mention it :)
>>>
>>> That offer definitely still stands. Generalization sounds like a lot of fun.
>>>
>>> Keep in mind though that it's an eventually consistent queue, not an
>>> immediately consistent one, so that might not match all use cases. It
>>> works with wg because we always trigger the reader thread anew when it
>>> finishes, but that doesn't apply to everyone's queueing setup.
>>
>> Thanks for mentioning this.
>>
>> "multi-producer, single-consumer" seems to match the lockless qdisc's
>> paradigm too, for now concurrent enqueuing/dequeuing to the pfifo_fast's
>> queues() is not allowed, it is protected by producer_lock or consumer_lock.
>>
>> So it would be good to has lockless concurrent enqueuing, while dequeuing
>> can be protected by qdisc_lock() or q->seqlock, which meets the "multi-producer,
>> single-consumer" paradigm.
> 
> I don't think so. Usually we have one queue for each CPU so we can expect
> each CPU has a lockless qdisc assigned, but we can not assume this in
> the code, so we still have to deal with multiple CPU's sharing a lockless qdisc,
> and we usually enqueue and dequeue in process context, so it means we could
> have multiple producers and multiple consumers.

For lockless qdisc, dequeuing is always within the qdisc_run_begin() and
qdisc_run_end(), so multiple consumers is protected with each other by
q->seqlock .

For enqueuing, multiple consumers is protected by producer_lock, see
pfifo_fast_enqueue() -> skb_array_produce() -> ptr_ring_produce().
I am not sure if lockless MSPC can work with the process context, but
even if not, the enqueuing is also protected by rcu_read_lock_bh(),
which provides some kind of atomicity, so that producer_lock can be
reomved when lockless MSPC is used.

> 
> On the other hand, I don't think the problems we have been fixing are the ring
> buffer implementation itself, they are about the high-level qdisc
> state transitions.
> 
> Thanks.
> 
> .
> 

