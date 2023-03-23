Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47226C6292
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjCWJCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 05:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjCWJCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:02:16 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926B419106;
        Thu, 23 Mar 2023 02:01:59 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Phzlt0tnnz17KMk;
        Thu, 23 Mar 2023 16:58:50 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 23 Mar
 2023 17:01:57 +0800
Subject: Re: [PATCH] rps: process the skb directly if rps cpu not changed
To:     xu xin <xu.xin.sc@gmail.com>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <jiang.xuexin@zte.com.cn>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <xu.xin16@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <zhang.yunkai@zte.com.cn>
References: <aadae1c0-9d50-d89d-d0ea-a300fa09682c@huawei.com>
 <20230322072435.32813-1-xu.xin16@zte.com.cn>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <ef94a525-c5f3-fa9f-d66d-d9dc62533e78@huawei.com>
Date:   Thu, 23 Mar 2023 17:01:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230322072435.32813-1-xu.xin16@zte.com.cn>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/22 15:24, xu xin wrote:
> [So sorry, I made a mistake in the reply title]
> 
> On 2023/3/21 20:12, yang.yang29@zte.com.cn wrote:
>>> From: xu xin <xu.xin16@zte.com.cn>
>>>
>>> In the RPS procedure of NAPI receiving, regardless of whether the
>>> rps-calculated CPU of the skb equals to the currently processing CPU, RPS
>>> will always use enqueue_to_backlog to enqueue the skb to per-cpu backlog,
>>> which will trigger a new NET_RX softirq.
>>
>> Does bypassing the backlog cause out of order problem for packet handling?
>> It seems currently the RPS/RFS will ensure order delivery,such as:
>> https://elixir.bootlin.com/linux/v6.3-rc3/source/net/core/dev.c#L4485
>>
>> Also, this is an optimization, it should target the net-next branch:
>> [PATCH net-next] rps: process the skb directly if rps cpu not changed
>>
> 
> Well, I thought the patch would't break the effort RFS tried to avoid "Out of
> Order" packets. But thanks for your reminder, I rethink it again, bypassing the
> backlog from "netif_receive_skb_list" will mislead RFS's judging if all
> previous packets for the flow have been dequeued, where RFS thought all packets
> have been dealed with, but actually they are still in skb lists. Fortunately,
> bypassing the backlog from "netif_receive_skb" for a single skb is okay and won't
> cause OOO packets because every skb is processed serially by RPS and sent to the
> protocol stack as soon as possible.

Suppose a lot of skbs have been queued to the backlog waiting to
processed and passed to the stack when current_cpu is not the same
as the target cpu, then current_cpu is changed to be the same as the
target cpu, with your patch, new skb will be processed and passed to
the stack immediately, which may bypass the old skb in the backlog.

> 
> If I'm correct, the code as follws can fix this.
> 
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5666,8 +5666,9 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
>         if (static_branch_unlikely(&rps_needed)) {
>                 struct rps_dev_flow voidflow, *rflow = &voidflow;
>                 int cpu = get_rps_cpu(skb->dev, skb, &rflow);
> +               int current_cpu = smp_processor_id();
>  
> -               if (cpu >= 0) {
> +               if (cpu >= 0 && cpu != current_cpu) {
>                         ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
>                         rcu_read_unlock();
>                         return ret;
> @@ -5699,11 +5700,15 @@ void netif_receive_skb_list_internal(struct list_head *head)
>                 list_for_each_entry_safe(skb, next, head, list) {
>                         struct rps_dev_flow voidflow, *rflow = &voidflow;
>                         int cpu = get_rps_cpu(skb->dev, skb, &rflow);
> +                       int current_cpu = smp_processor_id();
>  
>                         if (cpu >= 0) {
>                                 /* Will be handled, remove from list */
>                                 skb_list_del_init(skb);
> -                               enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
> +                               if (cpu != current_cpu)
> +                                       enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
> +                               else
> +                                       __netif_receive_skb(skb);
>                         }
>                 }
> 
> 
> Thanks.
> 
>>>
>>> Actually, it's not necessary to enqueue it to backlog when rps-calculated
>>> CPU id equals to the current processing CPU, and we can call
>>> __netif_receive_skb or __netif_receive_skb_list to process the skb directly.
>>> The benefit is that it can reduce the number of softirqs of NET_RX and reduce
>>> the processing delay of skb.
>>>
>>> The measured result shows the patch brings 50% reduction of NET_RX softirqs.
>>> The test was done on the QEMU environment with two-core CPU by iperf3.
>>> taskset 01 iperf3 -c 192.168.2.250 -t 3 -u -R;
>>> taskset 02 iperf3 -c 192.168.2.250 -t 3 -u -R;
>>>
>>> Previous RPS:
>>> 		    	CPU0       CPU1
>>> NET_RX:         45          0    (before iperf3 testing)
>>> NET_RX:        1095         241   (after iperf3 testing)
>>>
>>> Patched RPS:
>>>                 CPU0       CPU1
>>> NET_RX:         28          4    (before iperf3 testing)
>>> NET_RX:         573         32   (after iperf3 testing)
>>
>> Sincerely.
>> Xu Xin
> .
> 
