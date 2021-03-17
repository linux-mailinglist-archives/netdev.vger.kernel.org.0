Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3713233E303
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhCQAue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:50:34 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3040 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhCQAuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:50:21 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4F0WhP0dtgzWGD4;
        Wed, 17 Mar 2021 08:47:17 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 17 Mar 2021 08:50:18 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Wed, 17 Mar
 2021 08:50:18 +0800
Subject: Re: [PATCH net-next] net: sched: remove unnecessay lock protection
 for skb_bad_txq/gso_skb
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@redhat.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1615800610-34700-1-git-send-email-linyunsheng@huawei.com>
 <20210315.164151.1093629330365238718.davem@redhat.com>
 <CAM_iQpWPSouO-JP4xHFqOLM8H4Rn5ucF68sa_EK5hUWSYw8feA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <a8874cd1-b7c4-5307-db46-8906c0949e12@huawei.com>
Date:   Wed, 17 Mar 2021 08:50:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWPSouO-JP4xHFqOLM8H4Rn5ucF68sa_EK5hUWSYw8feA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/17 2:43, Cong Wang wrote:
> On Mon, Mar 15, 2021 at 4:42 PM David Miller <davem@redhat.com> wrote:
>>
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Date: Mon, 15 Mar 2021 17:30:10 +0800
>>
>>> Currently qdisc_lock(q) is taken before enqueuing and dequeuing
>>> for lockless qdisc's skb_bad_txq/gso_skb queue, qdisc->seqlock is
>>> also taken, which can provide the same protection as qdisc_lock(q).
>>>
>>> This patch removes the unnecessay qdisc_lock(q) protection for
>>> lockless qdisc' skb_bad_txq/gso_skb queue.
>>>
>>> And dev_reset_queue() takes the qdisc->seqlock for lockless qdisc
>>> besides taking the qdisc_lock(q) when doing the qdisc reset,
>>> some_qdisc_is_busy() takes both qdisc->seqlock and qdisc_lock(q)
>>> when checking qdisc status. It is unnecessary to take both lock
>>> while the fast path only take one lock, so this patch also changes
>>> it to only take qdisc_lock(q) for locked qdisc, and only take
>>> qdisc->seqlock for lockless qdisc.
>>>
>>> Since qdisc->seqlock is taken for lockless qdisc when calling
>>> qdisc_is_running() in some_qdisc_is_busy(), use qdisc->running
>>> to decide if the lockless qdisc is running.
>>>
>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>
>> What about other things protected by this lock, such as statistics and qlen?
>>
>> This change looks too risky to me.
> 
> They are per-cpu for pfifo_fast which sets TCQ_F_CPUSTATS too.

Did you mean qdisc_lock(q) are protecting per-cpu stats for
pfifo_fast too?

> 
> Thanks.
> 
> .
> 

