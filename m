Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B04895B8F
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbfHTJuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:50:07 -0400
Received: from first.geanix.com ([116.203.34.67]:36282 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729763AbfHTJuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 05:50:06 -0400
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 6D9FD26E;
        Tue, 20 Aug 2019 09:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1566294599; bh=majl3nyBvA4Hc7wv6h7n+t2Fd+WbI8G3CV7l7IjaXiY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=a3pD806N0396ONmRk31tMI1l7TyT2tNLFd0s2OPFFSDeKwLgadghDGo+oCCSz3j/A
         iFRpWLfqPKKMYuEBhoex1QY/2XcxD2mmyKZdKSBfELzfzyHa3A0qAA1YPBsFHoBPai
         8QYpjicVnRe3izUPnASMD2/cBfK1Lu7ZUibVFOrD1auox5K7IGq3fFVorPHzt0cG6+
         DEij66Vcqog4L49guUho8SN4Mh5O8yRp02lNjsm3KoKeOgTVXWCBYunVBt7zvbU8AG
         BGlV878gwTeQrlyZPoWz7faGIEQqaattlD66XUEVDsyLyrkodcp3HFpynY+gZs4Q9o
         UnUV/gWdmJfSg==
Subject: Re: [PATCH] can: flexcan: free error skb if enqueueing failed
To:     =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <martin@geanix.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>
References: <20190715185308.104333-1-martin@geanix.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <6bddb702-e9ba-1c9e-7d7a-eb974d2e0fdd@geanix.com>
Date:   Tue, 20 Aug 2019 11:49:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190715185308.104333-1-martin@geanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 77834cc0481d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC'ing Joakim Zhang

On 15/07/2019 20.53, Martin Hundebøll wrote:
> If the call to can_rx_offload_queue_sorted() fails, the passed skb isn't
> consumed, so the caller must do so.
> 
> Fixes: 30164759db1b ("can: flexcan: make use of rx-offload's irq_offload_fifo")
> Signed-off-by: Martin Hundebøll <martin@geanix.com>
> ---
>   drivers/net/can/flexcan.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index 1c66fb2ad76b..21f39e805d42 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -688,7 +688,8 @@ static void flexcan_irq_bus_err(struct net_device *dev, u32 reg_esr)
>   	if (tx_errors)
>   		dev->stats.tx_errors++;
>   
> -	can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
> +	if (can_rx_offload_queue_sorted(&priv->offload, skb, timestamp))
> +		kfree_skb(skb);
>   }
>   
>   static void flexcan_irq_state(struct net_device *dev, u32 reg_esr)
> @@ -732,7 +733,8 @@ static void flexcan_irq_state(struct net_device *dev, u32 reg_esr)
>   	if (unlikely(new_state == CAN_STATE_BUS_OFF))
>   		can_bus_off(dev);
>   
> -	can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
> +	if (can_rx_offload_queue_sorted(&priv->offload, skb, timestamp))
> +		kfree_skb(skb);
>   }
>   
>   static inline struct flexcan_priv *rx_offload_to_priv(struct can_rx_offload *offload)
> 
