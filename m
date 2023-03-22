Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3984E6C4017
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 03:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjCVCCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 22:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjCVCCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 22:02:35 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE27D59E46;
        Tue, 21 Mar 2023 19:02:33 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PhBWM0XSrzKrSJ;
        Wed, 22 Mar 2023 10:00:15 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Wed, 22 Mar
 2023 10:02:31 +0800
Subject: Re: [PATCH] rps: process the skb directly if rps cpu not changed
To:     <yang.yang29@zte.com.cn>, <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.xin16@zte.com.cn>,
        <jiang.xuexin@zte.com.cn>, <zhang.yunkai@zte.com.cn>
References: <202303212012296834902@zte.com.cn>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <aadae1c0-9d50-d89d-d0ea-a300fa09682c@huawei.com>
Date:   Wed, 22 Mar 2023 10:02:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <202303212012296834902@zte.com.cn>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/21 20:12, yang.yang29@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> In the RPS procedure of NAPI receiving, regardless of whether the
> rps-calculated CPU of the skb equals to the currently processing CPU, RPS
> will always use enqueue_to_backlog to enqueue the skb to per-cpu backlog,
> which will trigger a new NET_RX softirq.

Does bypassing the backlog cause out of order problem for packet handling?
It seems currently the RPS/RFS will ensure order delivery,such as:
https://elixir.bootlin.com/linux/v6.3-rc3/source/net/core/dev.c#L4485

Also, this is an optimization, it should target the net-next branch:
[PATCH net-next] rps: process the skb directly if rps cpu not changed

> 
> Actually, it's not necessary to enqueue it to backlog when rps-calculated
> CPU id equals to the current processing CPU, and we can call
> __netif_receive_skb or __netif_receive_skb_list to process the skb directly.
> The benefit is that it can reduce the number of softirqs of NET_RX and reduce
> the processing delay of skb.
> 
> The measured result shows the patch brings 50% reduction of NET_RX softirqs.
> The test was done on the QEMU environment with two-core CPU by iperf3.
> taskset 01 iperf3 -c 192.168.2.250 -t 3 -u -R;
> taskset 02 iperf3 -c 192.168.2.250 -t 3 -u -R;
> 
> Previous RPS:
> 		    	CPU0       CPU1
> NET_RX:         45          0    (before iperf3 testing)
> NET_RX:        1095         241   (after iperf3 testing)
> 
> Patched RPS:
>                 CPU0       CPU1
> NET_RX:         28          4    (before iperf3 testing)
> NET_RX:         573         32   (after iperf3 testing)
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> Reviewed-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
> Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
> Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
> ---
>  net/core/dev.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c7853192563d..c33ddac3c012 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5666,8 +5666,9 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
>  	if (static_branch_unlikely(&rps_needed)) {
>  		struct rps_dev_flow voidflow, *rflow = &voidflow;
>  		int cpu = get_rps_cpu(skb->dev, skb, &rflow);
> +		int current_cpu = smp_processor_id();
> 
> -		if (cpu >= 0) {
> +		if (cpu >= 0 && cpu != current_cpu) {
>  			ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
>  			rcu_read_unlock();
>  			return ret;
> @@ -5699,8 +5700,9 @@ void netif_receive_skb_list_internal(struct list_head *head)
>  		list_for_each_entry_safe(skb, next, head, list) {
>  			struct rps_dev_flow voidflow, *rflow = &voidflow;
>  			int cpu = get_rps_cpu(skb->dev, skb, &rflow);
> +			int current_cpu = smp_processor_id();
> 
> -			if (cpu >= 0) {
> +			if (cpu >= 0 && cpu != current_cpu) {
>  				/* Will be handled, remove from list */
>  				skb_list_del_init(skb);
>  				enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
> 
