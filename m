Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBF634361D
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 02:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCVBGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 21:06:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5100 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCVBF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 21:05:28 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4F3bpx2724zYMmV;
        Mon, 22 Mar 2021 09:03:37 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 22 Mar 2021 09:05:25 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Mon, 22 Mar
 2021 09:05:25 +0800
Subject: Re: [Linuxarm] Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS
 for lockless qdisc
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, Thomas Gschwantner <tharre3@gmail.com>
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
 <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpXvVZxBRHF6PBDOYSOSCj08nPyfcY0adKuuTg=cqffV+w@mail.gmail.com>
 <87eegddhsj.fsf@toke.dk>
 <CAHmME9qDU7VRmBV+v0tzLiUpMJykjswSDwqc9P43ZwG1UD7mzw@mail.gmail.com>
 <3bae7b26-9d7f-15b8-d466-ff5c26d08b35@huawei.com>
 <CAHmME9qS-_H7Z5Gjw7SbZS0fO84vzpx4ZNHu0Ay=2krZpJQy3A@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <50b730de-1546-144f-6cdf-3943de0a65ad@huawei.com>
Date:   Mon, 22 Mar 2021 09:05:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAHmME9qS-_H7Z5Gjw7SbZS0fO84vzpx4ZNHu0Ay=2krZpJQy3A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme717-chm.china.huawei.com (10.1.199.113) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/20 3:03, Jason A. Donenfeld wrote:
> On Thu, Mar 18, 2021 at 1:33 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
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
> 
> The other thing is that if you've got memory for a ring buffer rather
> than a list queue, we worked on an MPMC ring structure for WireGuard a
> few years ago that we didn't wind up using in the end, but it lives
> here:
> https://git.zx2c4.com/wireguard-monolithic-historical/tree/src/mpmc_ptr_ring.h?h=tg/mpmc-benchmark

Thanks for mentioning that, It seems that is exactly what the
pfifo_fast qdisc need for locklees multi-producer, because it
only need the memory to store the skb pointer.

Does it have any limitation? More specifically, does it works with
the process or softirq context, if not, how about context with
rcu protection?

> _______________________________________________
> Linuxarm mailing list -- linuxarm@openeuler.org
> To unsubscribe send an email to linuxarm-leave@openeuler.org
> 

