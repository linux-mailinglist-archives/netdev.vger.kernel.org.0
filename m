Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06276380237
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 04:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhENC5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 22:57:39 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2309 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhENC5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 22:57:37 -0400
Received: from dggeml706-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FhCjf4xsHz19PQl;
        Fri, 14 May 2021 10:52:06 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml706-chm.china.huawei.com (10.3.17.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 14 May 2021 10:56:23 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 14 May
 2021 10:56:23 +0800
Subject: Re: [PATCH net v8 0/3] fix packet stuck problem for lockless qdisc
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
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
References: <1620959218-17250-1-git-send-email-linyunsheng@huawei.com>
Message-ID: <7ef8c6db-a2cc-dc05-af6a-8797b9e7e1a7@huawei.com>
Date:   Fri, 14 May 2021 10:56:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1620959218-17250-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/14 10:26, Yunsheng Lin wrote:
> This patchset fixes the packet stuck problem mentioned in [1].
> 
> Patch 1: Add STATE_MISSED flag to fix packet stuck problem.
> Patch 2: Fix a tx_action rescheduling problem after STATE_MISSED
>          flag is added in patch 1.
> Patch 3: Fix the significantly higher CPU consumption problem when
>          multiple threads are competing on a saturated outgoing
>          device.
> 
> V8: Change function name in patch 3 as suggested by Jakub, adjust
>     commit log in patch 2, and add Acked-by from Jakub.

Please ignore this patchset, there is some typo in patch 3.

> V7: Fix netif_tx_wake_queue() data race noted by Jakub.
> V6: Some performance optimization in patch 1 suggested by Jakub
>     and drop NET_XMIT_DROP checking in patch 3.
> V5: add patch 3 to fix the problem reported by Michal Kubecek.
> V4: Change STATE_NEED_RESCHEDULE to STATE_MISSED and add patch 2.
> 
> [1]. https://lkml.org/lkml/2019/10/9/42
> 
> Yunsheng Lin (3):
>   net: sched: fix packet stuck problem for lockless qdisc
>   net: sched: fix tx action rescheduling issue during deactivation
>   net: sched: fix tx action reschedule issue with stopped queue
> 
>  include/net/pkt_sched.h   |  7 +------
>  include/net/sch_generic.h | 35 ++++++++++++++++++++++++++++++++-
>  net/core/dev.c            | 29 ++++++++++++++++++++++-----
>  net/sched/sch_generic.c   | 50 +++++++++++++++++++++++++++++++++++++++++++++--
>  4 files changed, 107 insertions(+), 14 deletions(-)
> 

