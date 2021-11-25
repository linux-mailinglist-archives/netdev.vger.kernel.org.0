Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3648945E0BB
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 19:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238719AbhKYSzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 13:55:24 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:30255 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242526AbhKYSxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 13:53:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637866204;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=iBQ+vqxgwLF6dT3pSXOjf18nr9Ye1/Cz08Fes5fTY+o=;
    b=JNXH103kFDPqjsb1RadqNnJTSrOTucDLvp82wwejQ16RBYqpEOITrRorX2dH2GqwFn
    EZ3q5S0iIOtappCxaQANU7EN+L2/HlV35kAYjBk0R9YLXSZ1wHyJeHP9YOFmnNXONaNU
    VNtIy8KczuxtUWwYIHbPD8OglsGICw7QYFEbhDzXXX3LxPeL6DwD5bszb+shcYkq75G1
    S1JHxTgiTlbSosNhE/Fzvh125JR5LstQF+DSJSMIVS8VmX3mCwf399xoY7kV4kY8skSs
    AVL8cdkSX491E5XyUJOnbzV4Frvb1pnl40p64DkFdTCLmEA/jxl7JQvAdpRgQegToYAb
    9h2w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.34.10 AUTH)
    with ESMTPSA id c09e88xAPIo14Pz
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 25 Nov 2021 19:50:01 +0100 (CET)
Subject: Re: [PATCH v2 4/5] can: do not increase rx_bytes statistics for RTR
 frames
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
        Yasushi SHOJI <yashi@spacecubics.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>
References: <20211125172021.976384-1-mailhol.vincent@wanadoo.fr>
 <20211125172021.976384-5-mailhol.vincent@wanadoo.fr>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <ed755990-4169-604e-d982-7e4370114512@hartkopp.net>
Date:   Thu, 25 Nov 2021 19:50:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211125172021.976384-5-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

On 25.11.21 18:20, Vincent Mailhol wrote:

> diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
> index d582c39fc8d0..717d4925fdb0 100644
> --- a/drivers/net/can/usb/ucan.c
> +++ b/drivers/net/can/usb/ucan.c
> @@ -619,12 +619,13 @@ static void ucan_rx_can_msg(struct ucan_priv *up, struct ucan_message_in *m)
>   	/* copy the payload of non RTR frames */
>   	if (!(cf->can_id & CAN_RTR_FLAG) || (cf->can_id & CAN_ERR_FLAG))
>   		memcpy(cf->data, m->msg.can_msg.data, cf->len);
> +	/* only frames which are neither RTR nor ERR have a payload */
> +	else
> +		stats->rx_bytes += cf->len;

This 'else' path looks wrong ...

>   
>   	/* don't count error frames as real packets */
> -	if (!(cf->can_id & CAN_ERR_FLAG)) {
> +	if (!(cf->can_id & CAN_ERR_FLAG))
>   		stats->rx_packets++;
> -		stats->rx_bytes += cf->len;
> -	}
>   
>   	/* pass it to Linux */
>   	netif_rx(skb);

Regards,
Oliver
