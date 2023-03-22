Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D172A6C408E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 03:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjCVCzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 22:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjCVCzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 22:55:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA94251FB2;
        Tue, 21 Mar 2023 19:55:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0842E61F21;
        Wed, 22 Mar 2023 02:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E16C433D2;
        Wed, 22 Mar 2023 02:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679453701;
        bh=d4qlAOSOxshZz/xSFFLff/N4ITVjepBM5qtZzLlPmuQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sudPEoNwhcOWAaL5kXZ7fhlCjmBR9kV9To3ED4zBzvUoz3oPAYGTIDQAA9cGKcaI6
         8dt3BEeJ8hZtJVR4R98OKe4vcLKe6o5biKuMVR7M96EX1JHQSbrd7hhbEH4LkQlpjo
         MLBmhtOfV612nFkrTTM5kIAqJ5X93DSqy1qrS4+earwyLm/SMZedGvWO+xvzeHaX+7
         U3NFyOJdkn/xOtOjjfWruxe8AOmgg8kfwu1NTdivx3hi11efpqEZLvhell7btS1Akl
         C4WWC556XCS2kK+XrvGlwjOZp6PV5diZ1T/TZD9I8GmqKPRXcHJZ3RAjpZ+3lz66XH
         r/mjyWMHI+hAw==
Date:   Tue, 21 Mar 2023 19:54:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <edumazet@google.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xu.xin16@zte.com.cn>, <jiang.xuexin@zte.com.cn>,
        <zhang.yunkai@zte.com.cn>
Subject: Re: [PATCH] rps: process the skb directly if rps cpu not changed
Message-ID: <20230321195459.390dea45@kernel.org>
In-Reply-To: <202303212012296834902@zte.com.cn>
References: <202303212012296834902@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Mar 2023 20:12:29 +0800 (CST) yang.yang29@zte.com.cn wrote:
> The measured result shows the patch brings 50% reduction of NET_RX softirqs.
> The test was done on the QEMU environment with two-core CPU by iperf3.
> taskset 01 iperf3 -c 192.168.2.250 -t 3 -u -R;
> taskset 02 iperf3 -c 192.168.2.250 -t 3 -u -R;
> 
> Previous RPS:
> 		    	CPU0       CPU1

this header looks misalinged

> NET_RX:         45          0    (before iperf3 testing)
> NET_RX:        1095         241   (after iperf3 testing)
> 
> Patched RPS:
>                 CPU0       CPU1
> NET_RX:         28          4    (before iperf3 testing)
> NET_RX:         573         32   (after iperf3 testing)

This table is really confusing. What's the unit, how is it measured 
and why are you showing before/after rather than the delta?

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

This does not have to be in the loop.

> 
> -			if (cpu >= 0) {
> +			if (cpu >= 0 && cpu != current_cpu) {

Please answer Yunsheng's question as well..
