Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AB033A925
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 01:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhCOAui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 20:50:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13530 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhCOAuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 20:50:06 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DzHnm55xjzNmty;
        Mon, 15 Mar 2021 08:47:40 +0800 (CST)
Received: from [127.0.0.1] (10.69.30.204) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Mon, 15 Mar 2021
 08:50:01 +0800
Subject: Re: [PATCH RFC] net: sched: implement TCQ_F_CAN_BYPASS for lockless
 qdisc
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>, <edumazet@google.com>,
        <weiwan@google.com>, <cong.wang@bytedance.com>,
        <ap420073@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <pabeni@redhat.com>, linux-can <linux-can@vger.kernel.org>
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <20210314000350.2mrhvprsi77qwqdi@skbuf>
 <298228b3-af1d-6907-92a3-b273dad7a150@pengutronix.de>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3e6ecce5-188e-d2cf-69e4-ddb672236c27@huawei.com>
Date:   Mon, 15 Mar 2021 08:50:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <298228b3-af1d-6907-92a3-b273dad7a150@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/14 18:15, Marc Kleine-Budde wrote:
> Cc += linux-can@vger.kernel.org
> 
> On 3/14/21 1:03 AM, Vladimir Oltean wrote:
>> On Sat, Mar 13, 2021 at 10:47:47AM +0800, Yunsheng Lin wrote:
>>> Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
>>> flag set, but queue discipline by-pass does not work for lockless
>>> qdisc because skb is always enqueued to qdisc even when the qdisc
>>> is empty, see __dev_xmit_skb().
>>>
>>> This patch calles sch_direct_xmit() to transmit the skb directly
>>> to the driver for empty lockless qdisc too, which aviod enqueuing
>>> and dequeuing operation. qdisc->empty is set to false whenever a
>>> skb is enqueued, and is set to true when skb dequeuing return NULL,
>>> see pfifo_fast_dequeue().
>>>
>>> Also, qdisc is scheduled at the end of qdisc_run_end() when q->empty
>>> is false to avoid packet stuck problem.
>>>
>>> The performance for ip_forward test increases about 10% with this
>>> patch.
>>>
>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>> ---
>>
>> I can confirm the ~10% IP forwarding throughput improvement brought by
>> this patch, but as you might be aware, there was a previous attempt to
>> add qdisc bypass to pfifo_fast by Paolo Abeni:
>> https://lore.kernel.org/netdev/661cc33a-5f65-2769-cc1a-65791cb4b131@pengutronix.de/

Thanks for mention the previous attempt to add qdisc bypass to pfifo_fast.

>> It was reverted because TX reordering was observed with SocketCAN
>> (although, presumably it should also be seen with Ethernet and such).

When writing this patch, I was more foucusing on packet stuck problem
when TCQ_F_CAN_BYPASS is added for lockless qdisc.

When I am looking at flexcan_start_xmit() used by the can driver you mentioned,
it calls netif_stop_queue() to disable the queue when sending each skb, which may
cuause other skb to be requeued, see dev_requeue_skb() called by sch_direct_xmit(),
and q->empty is still true when this happens, so other cpu may send skb directly
bypassing the requeued skb, causing an out of order problem.

I will try to deal with the above requeued skb problem, and see if there are other
timing issus beside the requeued skb problem.

Thanks for the testing again.

> 
> Thanks for testing that, I just stumbled over this patch by accident.
> 
> Marc
> 

