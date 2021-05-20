Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F8138A314
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 11:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhETJsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 05:48:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4768 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbhETJqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 05:46:39 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fm4WY03tVzqVFT;
        Thu, 20 May 2021 17:41:45 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 17:45:15 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 20 May
 2021 17:45:15 +0800
Subject: Re: [Linuxarm] [PATCH RFC v4 0/3] Some optimization for lockless
 qdisc
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <a.fatoum@pengutronix.de>, <vladimir.oltean@nxp.com>
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
References: <1621502873-62720-1-git-send-email-linyunsheng@huawei.com>
Message-ID: <829cc4c1-46cc-c96c-47ba-438ae3534b94@huawei.com>
Date:   Thu, 20 May 2021 17:45:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1621502873-62720-1-git-send-email-linyunsheng@huawei.com>
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

On 2021/5/20 17:27, Yunsheng Lin wrote:
> Patch 1: remove unnecessary seqcount operation.
> Patch 2: implement TCQ_F_CAN_BYPASS.
> Patch 3: remove qdisc->empty.
> 
> RFC v4: Use STATE_MISSED and STATE_DRAINING to indicate non-empty
>         qdisc, and add patch 1 and 3.

@Vladimir, Ahmad
It would be good to run your testcase to see if there are any
out of order for this version, because this version has used
STATE_MISSED and STATE_DRAINING to indicate non-empty qdisc,
thanks.

It is based on newest net branch with qdisc stuck patchset.

Some performance data as below:

pktgen + dummy netdev:
 threads  without+this_patch   with+this_patch      delta
    1       2.60Mpps            3.18Mpps             +22%
    2       3.84Mpps            5.72Mpps             +48%
    4       5.52Mpps            5.52Mpps             +0.0%
    8       2.77Mpps            2.81Mpps             +1.4%
   16       2.24Mpps            2.29Mpps             +2.2%

IP forward testing: 1.05Mpps increases to 1.15Mpps

> 
> Yunsheng Lin (3):
>   net: sched: avoid unnecessary seqcount operation for lockless qdisc
>   net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc
>   net: sched: remove qdisc->empty for lockless qdisc
> 
>  include/net/sch_generic.h | 26 +++++++++++++-------------
>  net/core/dev.c            | 22 ++++++++++++++++++++--
>  net/sched/sch_generic.c   | 23 ++++++++++++++++-------
>  3 files changed, 49 insertions(+), 22 deletions(-)
> 

