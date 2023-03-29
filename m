Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAC66CD988
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjC2Mrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjC2Mrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:47:32 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C9A4202
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:47:26 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PmmWW5NkGzrV9S;
        Wed, 29 Mar 2023 20:46:15 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Wed, 29 Mar
 2023 20:47:24 +0800
Subject: Re: [PATCH net-next 4/4] net: optimize ____napi_schedule() to avoid
 extra NET_RX_SOFTIRQ
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jason Xing <kernelxing@tencent.com>, <netdev@vger.kernel.org>,
        <eric.dumazet@gmail.com>
References: <20230328235021.1048163-1-edumazet@google.com>
 <20230328235021.1048163-5-edumazet@google.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <fa860d02-0310-2666-1043-6909dc68ea01@huawei.com>
Date:   Wed, 29 Mar 2023 20:47:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230328235021.1048163-5-edumazet@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/29 7:50, Eric Dumazet wrote:
> ____napi_schedule() adds a napi into current cpu softnet_data poll_list,
> then raises NET_RX_SOFTIRQ to make sure net_rx_action() will process it.
> 
> Idea of this patch is to not raise NET_RX_SOFTIRQ when being called indirectly
> from net_rx_action(), because we can process poll_list from this point,
> without going to full softirq loop.
> 
> This needs a change in net_rx_action() to make sure we restart
> its main loop if sd->poll_list was updated without NET_RX_SOFTIRQ
> being raised.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Xing <kernelxing@tencent.com>
> ---
>  net/core/dev.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index f34ce93f2f02e7ec71f5e84d449fa99b7a882f0c..0c4b21291348d4558f036fb05842dab023f65dc3 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4360,7 +4360,11 @@ static inline void ____napi_schedule(struct softnet_data *sd,
>  	}
>  
>  	list_add_tail(&napi->poll_list, &sd->poll_list);
> -	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
> +	/* If not called from net_rx_action()
> +	 * we have to raise NET_RX_SOFTIRQ.
> +	 */
> +	if (!sd->in_net_rx_action)

It seems sd->in_net_rx_action may be read/writen by different CPUs at the same
time, does it need something like READ_ONCE()/WRITE_ONCE() to access
sd->in_net_rx_action?

> +		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
>  }
>  
>  #ifdef CONFIG_RPS
> @@ -6648,6 +6652,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>  	LIST_HEAD(list);
>  	LIST_HEAD(repoll);
>  
> +start:
>  	sd->in_net_rx_action = true;
>  	local_irq_disable();
>  	list_splice_init(&sd->poll_list, &list);
> @@ -6659,9 +6664,18 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>  		skb_defer_free_flush(sd);
>  
>  		if (list_empty(&list)) {
> -			sd->in_net_rx_action = false;
> -			if (!sd_has_rps_ipi_waiting(sd) && list_empty(&repoll))
> -				goto end;
> +			if (list_empty(&repoll)) {
> +				sd->in_net_rx_action = false;
> +				barrier();

Do we need a stronger barrier to prevent out-of-order execution
from cpu?
Do we need a barrier between list_add_tail() and sd->in_net_rx_action
checking in ____napi_schedule() to pair with the above barrier?

> +				/* We need to check if ____napi_schedule()
> +				 * had refilled poll_list while
> +				 * sd->in_net_rx_action was true.
> +				 */
> +				if (!list_empty(&sd->poll_list))
> +					goto start;
> +				if (!sd_has_rps_ipi_waiting(sd))
> +					goto end;
> +			}
>  			break;
>  		}
>  
> 
