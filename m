Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0487B33E5C4
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhCQBO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:14:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5093 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCQBOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 21:14:42 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4F0XFv57DFzYKq0;
        Wed, 17 Mar 2021 09:12:51 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 17 Mar 2021 09:14:35 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Wed, 17 Mar
 2021 09:14:35 +0800
Subject: Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS for lockless
 qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     David Miller <davem@davemloft.net>,
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
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c91af612-24d3-798e-3df3-8bab35e01a38@huawei.com>
Date:   Wed, 17 Mar 2021 09:14:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXvVZxBRHF6PBDOYSOSCj08nPyfcY0adKuuTg=cqffV+w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/17 6:48, Cong Wang wrote:
> On Mon, Mar 15, 2021 at 2:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> I thought pfifo was supposed to be "lockless" and this change
>> re-introduces a lock between producer and consumer, no?
> 
> It has never been truly lockless, it uses two spinlocks in the ring buffer
> implementation, and it introduced a q->seqlock recently, with this patch
> now we have priv->lock, 4 locks in total. So our "lockless" qdisc ends
> up having more locks than others. ;) I don't think we are going to a
> right direction...

Yes, we have 4 locks in total, but lockless qdisc only use two locks
in this patch, which are priv->lock and q->seqlock.

The qdisc at least uses two locks, which is qdisc_lock(q) and q->busylock,
which seems to have bigger contention when concurrent accessing to the
same qdisc.

If we want to reduce the total number of lock, we can use qdisc_lock(q)
for lockless qdisc and remove q->seqlock:)

> 
> Thanks.
> 
> .
> 

