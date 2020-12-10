Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B492D54A2
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 08:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgLJHdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 02:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgLJHdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 02:33:01 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3561C0613CF;
        Wed,  9 Dec 2020 23:32:20 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id lt17so5935418ejb.3;
        Wed, 09 Dec 2020 23:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=KcGRFZeIemG8hKKr7kJG/jhuSs/HR0xK8rHxXX1IrL0=;
        b=uRXzUtJmFu2Z1X78asx+B5MEAqQTKSKCchETjz5BPYqdm1+44bxXyan12EKHqB6o0q
         5Dj8XV0TQu8wTX+K7c4kAvuIPmkryzZ5VoWEEg6BfIVm1teXCQODoIDplKCzA/3RYW3m
         TsV/blhdR+LvbSd4PXBDQJ+eNYGUiWh3VJvsRrzAGLIrje+2bbXpLjyqGBMTYGKYsEKA
         vpLN5Qrddk7ptMBoD8dYP6txGP5nN9Ec/az5jwUz5lVRptu79keHvgNBhNDvZf+ZcZ3n
         Q1HFuTyZUXY2HDik1Nbfhj2S0Ck4wJxGXqxcw5ylGh441IuPwBviyKjKJ961LoFu4fd2
         KDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=KcGRFZeIemG8hKKr7kJG/jhuSs/HR0xK8rHxXX1IrL0=;
        b=TikEbTH3UqG0YR8GpTE7JC9c7eArsVEO6vwj4zAdEXhFqSXCvyTnm5rf07ofN6Hhbb
         oSrRiyBd/T7q7N/ULf6x4nMFs5MsaisiAyIESpeBgiMZE/CHQjHAjCh9xUA8hrGkKO1C
         X3+Jrq4fpPuyqvnmb1V1dGX5cO/gkmlAg0iwkdyTVG141Y7mJ+q30r4rRAFhZ0XBivVL
         +NSsDUOcNAxy+H/NjLvnGtR/JNM9YcrgdT6yht3RdqFuU5X1BcTWt92cthd5dNxXhPyd
         iwUxvEuvN3IP9SuDebfo73TqjKdlK6ZiIpMhf1wvZYJTYVhHH3QbULxu38Ok7qYlutyK
         Dviw==
X-Gm-Message-State: AOAM532MhcOiM2lGsxK5Z6qUDnoNWo9Kpj5YbdGaszZZEnLzHf3/0Z6Z
        cWG/saEJ6P4QHXUmtiJdKfA6p/v+sZA=
X-Google-Smtp-Source: ABdhPJxB0Tslh2p7etwQ5B2F6MnyB1/7B7G13YqNabhhx73oWOUI0eYExY1CrEdjmCq6ozl3Wq/x/g==
X-Received: by 2002:a17:906:614:: with SMTP id s20mr5166266ejb.202.1607585539094;
        Wed, 09 Dec 2020 23:32:19 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:692a:3a6:90e2:2f3c? (p200300ea8f065500692a03a690e22f3c.dip0.t-ipconnect.de. [2003:ea:8f06:5500:692a:3a6:90e2:2f3c])
        by smtp.googlemail.com with ESMTPSA id dd18sm3695353ejb.53.2020.12.09.23.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 23:32:18 -0800 (PST)
Subject: Re: [PATCH net v2] lan743x: fix rx_napi_poll/interrupt ping-pong
To:     Sven Van Asbroeck <thesven73@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201210035540.32530-1-TheSven73@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5ff5fd64-2bf0-cbf7-642f-67be198cba05@gmail.com>
Date:   Thu, 10 Dec 2020 08:32:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201210035540.32530-1-TheSven73@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 10.12.2020 um 04:55 schrieb Sven Van Asbroeck:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> Even if there is more rx data waiting on the chip, the rx napi poll fn
> will never run more than once - it will always read a few buffers, then
> bail out and re-arm interrupts. Which results in ping-pong between napi
> and interrupt.
> 
> This defeats the purpose of napi, and is bad for performance.
> 
> Fix by making the rx napi poll behave identically to other ethernet
> drivers:
> 1. initialize rx napi polling with an arbitrary budget (64).
> 2. in the polling fn, return full weight if rx queue is not depleted,
>    this tells the napi core to "keep polling".
> 3. update the rx tail ("ring the doorbell") once for every 8 processed
>    rx ring buffers.
> 
> Thanks to Jakub Kicinski, Eric Dumazet and Andrew Lunn for their expert
> opinions and suggestions.
> 
> Tested with 20 seconds of full bandwidth receive (iperf3):
>         rx irqs      softirqs(NET_RX)
>         -----------------------------
> before  23827        33620
> after   129          4081
> 

In addition you could play with sysfs attributes
/sys/class/net/<if>/gro_flush_timeout
/sys/class/net/<if>/napi_defer_hard_irqs

> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
> Fixes: 23f0703c125be ("lan743x: Add main source files for new lan743x driver")
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> ---
> 
> Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # b7e4ba9a91df
> 
> To: Bryan Whitehead <bryan.whitehead@microchip.com>
> To: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> To: "David S. Miller" <davem@davemloft.net>
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
>  drivers/net/ethernet/microchip/lan743x_main.c | 44 ++++++++++---------
>  1 file changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index 87b6c59a1e03..30ec308b9a4c 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -1964,6 +1964,14 @@ static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
>  				  length, GFP_ATOMIC | GFP_DMA);
>  }
>  
> +static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
> +{
> +	/* update the tail once per 8 descriptors */
> +	if ((index & 7) == 7)
> +		lan743x_csr_write(rx->adapter, RX_TAIL(rx->channel_number),
> +				  index);
> +}
> +
>  static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
>  					struct sk_buff *skb)
>  {
> @@ -1994,6 +2002,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
>  	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
>  			    (length & RX_DESC_DATA0_BUF_LENGTH_MASK_));
>  	skb_reserve(buffer_info->skb, RX_HEAD_PADDING);
> +	lan743x_rx_update_tail(rx, index);
>  
>  	return 0;
>  }
> @@ -2012,6 +2021,7 @@ static void lan743x_rx_reuse_ring_element(struct lan743x_rx *rx, int index)
>  	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
>  			    ((buffer_info->buffer_length) &
>  			    RX_DESC_DATA0_BUF_LENGTH_MASK_));
> +	lan743x_rx_update_tail(rx, index);
>  }
>  
>  static void lan743x_rx_release_ring_element(struct lan743x_rx *rx, int index)
> @@ -2223,34 +2233,26 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
>  	struct lan743x_rx *rx = container_of(napi, struct lan743x_rx, napi);
>  	struct lan743x_adapter *adapter = rx->adapter;
>  	u32 rx_tail_flags = 0;
> -	int count;
> +	int count, result;
>  
>  	if (rx->vector_flags & LAN743X_VECTOR_FLAG_SOURCE_STATUS_W2C) {
>  		/* clear int status bit before reading packet */
>  		lan743x_csr_write(adapter, DMAC_INT_STS,
>  				  DMAC_INT_BIT_RXFRM_(rx->channel_number));
>  	}
> -	count = 0;
> -	while (count < weight) {
> -		int rx_process_result = lan743x_rx_process_packet(rx);
> -
> -		if (rx_process_result == RX_PROCESS_RESULT_PACKET_RECEIVED) {
> -			count++;
> -		} else if (rx_process_result ==
> -			RX_PROCESS_RESULT_NOTHING_TO_DO) {
> +	for (count = 0; count < weight; count++) {
> +		result = lan743x_rx_process_packet(rx);
> +		if (result == RX_PROCESS_RESULT_NOTHING_TO_DO)
>  			break;
> -		} else if (rx_process_result ==
> -			RX_PROCESS_RESULT_PACKET_DROPPED) {
> -			continue;
> -		}
>  	}
>  	rx->frame_count += count;
> -	if (count == weight)
> -		goto done;
> +	if (count == weight || result == RX_PROCESS_RESULT_PACKET_RECEIVED)
> +		return weight;
>  
>  	if (!napi_complete_done(napi, count))
> -		goto done;
> +		return count;
>  
> +	/* re-arm interrupts, must write to rx tail on some chip variants */
>  	if (rx->vector_flags & LAN743X_VECTOR_FLAG_VECTOR_ENABLE_AUTO_SET)
>  		rx_tail_flags |= RX_TAIL_SET_TOP_INT_VEC_EN_;
>  	if (rx->vector_flags & LAN743X_VECTOR_FLAG_SOURCE_ENABLE_AUTO_SET) {
> @@ -2260,10 +2262,10 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
>  				  INT_BIT_DMA_RX_(rx->channel_number));
>  	}
>  
> -	/* update RX_TAIL */
> -	lan743x_csr_write(adapter, RX_TAIL(rx->channel_number),
> -			  rx_tail_flags | rx->last_tail);
> -done:
> +	if (rx_tail_flags)
> +		lan743x_csr_write(adapter, RX_TAIL(rx->channel_number),
> +				  rx_tail_flags | rx->last_tail);
> +
>  	return count;
>  }
>  
> @@ -2407,7 +2409,7 @@ static int lan743x_rx_open(struct lan743x_rx *rx)
>  
>  	netif_napi_add(adapter->netdev,
>  		       &rx->napi, lan743x_rx_napi_poll,
> -		       rx->ring_size - 1);
> +		       64);

This value isn't completely arbitrary.
Better use constant NAPI_POLL_WEIGHT.

>  
>  	lan743x_csr_write(adapter, DMAC_CMD,
>  			  DMAC_CMD_RX_SWR_(rx->channel_number));
> 

