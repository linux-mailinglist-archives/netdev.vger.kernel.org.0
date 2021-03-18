Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28509340049
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 08:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhCRHeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 03:34:06 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3490 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhCRHd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 03:33:26 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4F1JcT5N0PzRRH8;
        Thu, 18 Mar 2021 15:31:37 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 18 Mar 2021 15:33:05 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Thu, 18 Mar
 2021 15:33:05 +0800
Subject: Re: [Linuxarm] Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS
 for lockless qdisc
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "Wei Wang" <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
 <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpXvVZxBRHF6PBDOYSOSCj08nPyfcY0adKuuTg=cqffV+w@mail.gmail.com>
 <87eegddhsj.fsf@toke.dk>
 <CAHmME9qDU7VRmBV+v0tzLiUpMJykjswSDwqc9P43ZwG1UD7mzw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3bae7b26-9d7f-15b8-d466-ff5c26d08b35@huawei.com>
Date:   Thu, 18 Mar 2021 15:33:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAHmME9qDU7VRmBV+v0tzLiUpMJykjswSDwqc9P43ZwG1UD7mzw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/17 21:45, Jason A. Donenfeld wrote:
> On 3/17/21, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>>
>>> On Mon, Mar 15, 2021 at 2:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>
>>>> I thought pfifo was supposed to be "lockless" and this change
>>>> re-introduces a lock between producer and consumer, no?
>>>
>>> It has never been truly lockless, it uses two spinlocks in the ring
>>> buffer
>>> implementation, and it introduced a q->seqlock recently, with this patch
>>> now we have priv->lock, 4 locks in total. So our "lockless" qdisc ends
>>> up having more locks than others. ;) I don't think we are going to a
>>> right direction...
>>
>> Just a thought, have you guys considered adopting the lockless MSPC ring
>> buffer recently introduced into Wireguard in commit:
>>
>> 8b5553ace83c ("wireguard: queueing: get rid of per-peer ring buffers")
>>
>> Jason indicated he was willing to work on generalising it into a
>> reusable library if there was a use case for it. I haven't quite though
>> through the details of whether this would be such a use case, but
>> figured I'd at least mention it :)
> 
> That offer definitely still stands. Generalization sounds like a lot of fun.
> 
> Keep in mind though that it's an eventually consistent queue, not an
> immediately consistent one, so that might not match all use cases. It
> works with wg because we always trigger the reader thread anew when it
> finishes, but that doesn't apply to everyone's queueing setup.

Thanks for mentioning this.

"multi-producer, single-consumer" seems to match the lockless qdisc's
paradigm too, for now concurrent enqueuing/dequeuing to the pfifo_fast's
queues() is not allowed, it is protected by producer_lock or consumer_lock.

So it would be good to has lockless concurrent enqueuing, while dequeuing
can be protected by qdisc_lock() or q->seqlock, which meets the "multi-producer,
single-consumer" paradigm.

But right now lockless qdisc has some packet stuck problem, which I tried to
fix in [1].

If the packet stuck problem for lockless qdisc can be fixed, and we can do
more optimization on lockless qdisc, including the one you mention:)

1.https://patchwork.kernel.org/project/netdevbpf/patch/1616050402-37023-1-git-send-email-linyunsheng@huawei.com/

> _______________________________________________
> Linuxarm mailing list -- linuxarm@openeuler.org
> To unsubscribe send an email to linuxarm-leave@openeuler.org
> 

