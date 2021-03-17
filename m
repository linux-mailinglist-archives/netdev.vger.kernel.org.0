Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E595233E55D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhCQBDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:03:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3488 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbhCQBBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 21:01:09 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4F0WyL2VQJzRNfr;
        Wed, 17 Mar 2021 08:59:22 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 17 Mar 2021 09:01:06 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Wed, 17 Mar
 2021 09:01:06 +0800
Subject: Re: [PATCH net-next] net: sched: remove unnecessay lock protection
 for skb_bad_txq/gso_skb
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1615800610-34700-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpXT+tS1NdpiF2M0hAocWJ90mxd5Wp8HoxkEhp4k9QM4hw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e6fd29fe-ccc1-d360-9840-0314cd77d7e6@huawei.com>
Date:   Wed, 17 Mar 2021 09:01:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXT+tS1NdpiF2M0hAocWJ90mxd5Wp8HoxkEhp4k9QM4hw@mail.gmail.com>
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

On 2021/3/17 2:41, Cong Wang wrote:
> On Mon, Mar 15, 2021 at 2:29 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> Currently qdisc_lock(q) is taken before enqueuing and dequeuing
>> for lockless qdisc's skb_bad_txq/gso_skb queue, qdisc->seqlock is
>> also taken, which can provide the same protection as qdisc_lock(q).
>>
>> This patch removes the unnecessay qdisc_lock(q) protection for
>> lockless qdisc' skb_bad_txq/gso_skb queue.
>>
>> And dev_reset_queue() takes the qdisc->seqlock for lockless qdisc
>> besides taking the qdisc_lock(q) when doing the qdisc reset,
>> some_qdisc_is_busy() takes both qdisc->seqlock and qdisc_lock(q)
>> when checking qdisc status. It is unnecessary to take both lock
>> while the fast path only take one lock, so this patch also changes
>> it to only take qdisc_lock(q) for locked qdisc, and only take
>> qdisc->seqlock for lockless qdisc.
>>
>> Since qdisc->seqlock is taken for lockless qdisc when calling
>> qdisc_is_running() in some_qdisc_is_busy(), use qdisc->running
>> to decide if the lockless qdisc is running.
> 
> What's the benefit here? Since qdisc->q.lock is also per-qdisc,
> so there is no actual contention to take it when we already acquire
> q->seqlock, right?

Yes, there is no actual contention to take qdisc->q.lock while
q->seqlock is acquired, but a cleanup or minor optimization.

> 
> Also, is ->seqlock supposed to be used for protecting skb_bad_txq
> etc.? From my understanding, it was introduced merely for replacing
> __QDISC_STATE_RUNNING. If you want to extend it, you probably
> have to rename it too.

How about just using qdisc->q.lock for lockless qdisc too and remove
dqisc->seqlock completely?

> 
> Thanks.
> 
> .
> 

