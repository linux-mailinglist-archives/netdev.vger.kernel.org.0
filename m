Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2658769C129
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 16:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjBSPIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 10:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjBSPI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 10:08:29 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB5BCC25;
        Sun, 19 Feb 2023 07:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V6cAn+Kbhs2/g9CQamm2tp5eaYDHzFhILdtI4rJ8LGo=; b=sU14Thko0GAJ0Rp1KBkv9dHMq/
        eADkI0ptMcrQyaXY3jzlHa8qPYDpsKb0z4X1Evoq6iW+bNhMNgmTGInLNC4nzGK9FgKrVQo/SMohT
        6EDPoyri29KsTJtX44lkieZFWrZKXLp/b8xwDQUM0NVIH9SC0FY5kOOKMhGwnjeKQPsY=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pTlIa-009xOe-EL; Sun, 19 Feb 2023 16:08:20 +0100
Message-ID: <a66335ec-0911-1902-7585-827b918fe957@nbd.name>
Date:   Sun, 19 Feb 2023 16:08:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [RFC v3] net/core: add optional threading for backlog processing
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org
References: <20230219131006.92681-1-nbd@nbd.name>
In-Reply-To: <20230219131006.92681-1-nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.02.23 14:10, Felix Fietkau wrote:
> When dealing with few flows or an imbalance on CPU utilization, static RPS
> CPU assignment can be too inflexible. Add support for enabling threaded NAPI
> for backlog processing in order to allow the scheduler to better balance
> processing. This helps better spread the load across idle CPUs.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
> RFC v3:
>   - make patch more generic, applies to backlog processing in general
>   - fix process queue access on flush
> RFC v2:
>   - fix rebase error in rps locking
> 
>   include/linux/netdevice.h  |  2 +
>   net/core/dev.c             | 78 +++++++++++++++++++++++++++++++++++---
>   net/core/sysctl_net_core.c | 27 +++++++++++++
>   3 files changed, 102 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index d9cdbc047b49..b3cef91b1696 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -522,6 +522,7 @@ static inline bool napi_complete(struct napi_struct *n)
>   }
>   
>   int dev_set_threaded(struct net_device *dev, bool threaded);
> +int backlog_set_threaded(bool threaded);
>   
>   /**
>    *	napi_disable - prevent NAPI from scheduling
> @@ -3192,6 +3193,7 @@ struct softnet_data {
>   	unsigned int		cpu;
>   	unsigned int		input_queue_tail;
>   #endif
> +	unsigned int		process_queue_empty;
>   	unsigned int		received_rps;
>   	unsigned int		dropped;
>   	struct sk_buff_head	input_pkt_queue;
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 357081b0113c..76874513b7b5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4597,7 +4597,7 @@ static int napi_schedule_rps(struct softnet_data *sd)
>   	struct softnet_data *mysd = this_cpu_ptr(&softnet_data);
>   
>   #ifdef CONFIG_RPS
> -	if (sd != mysd) {
> +	if (sd != mysd && !test_bit(NAPI_STATE_THREADED, &sd->backlog.state)) {
>   		sd->rps_ipi_next = mysd->rps_ipi_list;
>   		mysd->rps_ipi_list = sd;
>   
> @@ -5778,6 +5778,8 @@ static DEFINE_PER_CPU(struct work_struct, flush_works);
>   /* Network device is going away, flush any packets still pending */
>   static void flush_backlog(struct work_struct *work)
>   {
> +	unsigned int process_queue_empty;
> +	bool threaded, flush_processq;
>   	struct sk_buff *skb, *tmp;
>   	struct softnet_data *sd;
>   
> @@ -5792,8 +5794,15 @@ static void flush_backlog(struct work_struct *work)
>   			input_queue_head_incr(sd);
>   		}
>   	}
> +
> +	threaded = test_bit(NAPI_STATE_THREADED, &sd->backlog.state);
> +	flush_processq = threaded &&
> +			 !skb_queue_empty_lockless(&sd->process_queue);
Sorry, the patch was missing these lines:
	if (flush_processq)
		process_queue_empty = sd->process_queue_empty;

>   	rps_unlock_irq_enable(sd);
>   
> +	if (threaded)
> +		goto out;
> +
>   	skb_queue_walk_safe(&sd->process_queue, skb, tmp) {
>   		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
>   			__skb_unlink(skb, &sd->process_queue);


