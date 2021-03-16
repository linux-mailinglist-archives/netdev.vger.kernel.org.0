Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4175333CB91
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 03:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbhCPCla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 22:41:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3478 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhCPClH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 22:41:07 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4DzyD90d23zRQP8;
        Tue, 16 Mar 2021 10:39:21 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 16 Mar 2021 10:41:04 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 16 Mar
 2021 10:41:04 +0800
Subject: Re: [PATCH net-next] net: sched: remove unnecessay lock protection
 for skb_bad_txq/gso_skb
To:     David Miller <davem@redhat.com>
CC:     <kuba@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1615800610-34700-1-git-send-email-linyunsheng@huawei.com>
 <20210315.164151.1093629330365238718.davem@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1fea8225-69b0-5a73-0e9d-f5bfdecdc840@huawei.com>
Date:   Tue, 16 Mar 2021 10:40:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210315.164151.1093629330365238718.davem@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/16 7:41, David Miller wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> Date: Mon, 15 Mar 2021 17:30:10 +0800
> 
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
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> What about other things protected by this lock, such as statistics and qlen?
> 
> This change looks too risky to me.

Ok, If that is the case, maybe we just remove qdisc->seqlock and use
qdisc_lock(q) for lockless qdisc too, so that we do not need to worry
about "lockless qdisc' other things protected by qdisc_lock(q)".

At least for the fast path, taking two locks for lockless qdisc hurts
performance when handling requeued skb, especially if the lockless
qdisc supports TCQ_F_CAN_BYPASS.

> 
> 
> .
> 

