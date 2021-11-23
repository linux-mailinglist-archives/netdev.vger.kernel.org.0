Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8153245ADB9
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 22:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhKWVEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 16:04:22 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:32440 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhKWVEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 16:04:22 -0500
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2021 16:04:21 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637701266;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=mg4VWecMO36Enlno6yIYtnHI//ggzrvLe9u3FrxrYmg=;
    b=nX9hY+fbYWczN0YtaeWpolPbXSvoNcvtrHEapO3PR+95xLVH1Ugb9M6ljGobYozU2t
    YJm1jl5JK9YN+jv96BfMiDTOZzKVyqb76oRbA0JzfQCWlpBt70lNiNA5GOrK6mMfVWw2
    eElOI70yselad6aMhMS+3QvNwAwUWe9pZW57BuufAPpUV5UE0Qu4DDvpKjg1xINY7Slr
    +oPxM0yGnTBgqAUCSfgIYyP9RPnye2HL3ekaDJPLqak9vlNARgDMfMtlo+anPb+IdkcM
    vORpzXeW/0KBf6WyNdSyw+WE6ssUABSINlt7prGVgMhq1Uhh1FJb+6CJSwdZK6xODYWq
    gOjg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.34.6 AUTH)
    with ESMTPSA id a04d59xANL146aE
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 23 Nov 2021 22:01:04 +0100 (CET)
Subject: Re: [PATCH v1 1/2] can: do not increase rx statistics when receiving
 CAN error frames
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        Jimmy Assarsson <extja@kvaser.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>
References: <20211123115333.624335-1-mailhol.vincent@wanadoo.fr>
 <20211123115333.624335-2-mailhol.vincent@wanadoo.fr>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <aafec053-1054-4797-e1f1-e89586fe326f@hartkopp.net>
Date:   Tue, 23 Nov 2021 22:01:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211123115333.624335-2-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23.11.21 12:53, Vincent Mailhol wrote:
> CAN error skb is an interface specific to socket CAN. The CAN error
> skb does not correspond to any actual CAN frame sent on the wire. Only
> an error flag and a delimiter are transmitted when an error occurs
> (c.f. ISO 11898-1 section 10.4.4.2 "Error flag").
> 
> For this reason, it makes no sense to increment the rx_packets and
> rx_bytes fields of struct net_device_stats because no actual payload
> were transmitted on the wire.
> 

(..)

> diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
> index 37b0cc65237b..bb47e9a49240 100644
> --- a/drivers/net/can/dev/rx-offload.c
> +++ b/drivers/net/can/dev/rx-offload.c
> @@ -54,8 +54,10 @@ static int can_rx_offload_napi_poll(struct napi_struct *napi, int quota)
>   		struct can_frame *cf = (struct can_frame *)skb->data;
>   
>   		work_done++;
> -		stats->rx_packets++;
> -		stats->rx_bytes += cf->len;
> +		if (!(cf->can_id & CAN_ERR_MASK)) {

This looks wrong.

Did you think of CAN_ERR_FLAG ??


> +			stats->rx_packets++;
> +			stats->rx_bytes += cf->len;
> +		}
>   		netif_receive_skb(skb);

(..)

> diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
> index 1679cbe45ded..d582c39fc8d0 100644
> --- a/drivers/net/can/usb/ucan.c
> +++ b/drivers/net/can/usb/ucan.c
> @@ -621,8 +621,10 @@ static void ucan_rx_can_msg(struct ucan_priv *up, struct ucan_message_in *m)
>   		memcpy(cf->data, m->msg.can_msg.data, cf->len);
>   
>   	/* don't count error frames as real packets */
> -	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
> +	if (!(cf->can_id & CAN_ERR_FLAG)) {

Ah, here we are :-)

> +		stats->rx_packets++;
> +		stats->rx_bytes += cf->len;
> +	}
