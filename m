Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E96345D02
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 12:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhCWLfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 07:35:08 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3919 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhCWLfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 07:35:01 -0400
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4F4Tkf6Ktbz5hBl;
        Tue, 23 Mar 2021 19:32:58 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML403-HUB.china.huawei.com (10.3.17.33) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 23 Mar 2021 19:34:56 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 23 Mar
 2021 19:34:56 +0800
Subject: Re: [RFC v3] net: sched: implement TCQ_F_CAN_BYPASS for lockless
 qdisc
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
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
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>
References: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
 <1616404156-11772-1-git-send-email-linyunsheng@huawei.com>
 <5bef912e-aa7d-8a27-4d18-ac8cf4f7afdf@pengutronix.de>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <774fadf5-6383-f9e0-bbc6-e5862482a7d1@huawei.com>
Date:   Tue, 23 Mar 2021 19:34:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <5bef912e-aa7d-8a27-4d18-ac8cf4f7afdf@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/23 14:37, Ahmad Fatoum wrote:
> Hi,
> 
> On 22.03.21 10:09, Yunsheng Lin wrote:
>> Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
>> flag set, but queue discipline by-pass does not work for lockless
>> qdisc because skb is always enqueued to qdisc even when the qdisc
>> is empty, see __dev_xmit_skb().
>>
>> This patch calls sch_direct_xmit() to transmit the skb directly
>> to the driver for empty lockless qdisc too, which aviod enqueuing
>> and dequeuing operation. qdisc->empty is set to false whenever a
>> skb is enqueued, see pfifo_fast_enqueue(), and is set to true when
>> skb dequeuing return NULL, see pfifo_fast_dequeue().
>>
>> There is a data race between enqueue/dequeue and qdisc->empty
>> setting, qdisc->empty is only used as a hint, so we need to call
>> sch_may_need_requeuing() to see if the queue is really empty and if
>> there is requeued skb, which has higher priority than the current
>> skb.
>>
>> The performance for ip_forward test increases about 10% with this
>> patch.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>> Hi, Vladimir and Ahmad
>> 	Please give it a test to see if there is any out of order
>> packet for this patch, which has removed the priv->lock added in
>> RFC v2.
> 
> Overnight test (10h, 64 mil frames) didn't see any out-of-order frames
> between 2 FlexCANs on a dual core machine:
> 
> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> 
> No performance measurements taken.

Thanks for the testing.
And I has done the performance measurement.

L3 forward testing improves from 1.09Mpps to 1.21Mpps, still about
10% improvement.

pktgen + dummy netdev:

 threads  without+this_patch   with+this_patch      delta
    1       2.56Mpps            3.11Mpps             +21%
    2       3.76Mpps            4.31Mpps             +14%
    4       5.51Mpps            5.53Mpps             +0.3%
    8       2.81Mpps            2.72Mpps             -3%
   16       2.24Mpps            2.22Mpps             -0.8%

> 
>>


