Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FD62D3374
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgLHUT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbgLHUT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:19:26 -0500
Date:   Tue, 8 Dec 2020 11:43:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607456595;
        bh=0Z5bpu1nVbF3QnVaGuTjeixaoErw3LQOX5Pc9Y2x7xs=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=K7YJJADgVoOQA4WFXTX0LzCxujAPmgBwZQVMoMeuXF27q3Qacsr3wPaVgtfytn1OO
         W5ENlYvhcNqu/ZKyYjBk/Q0ZCUuhUGc5n5hfUhASAniUtxNqo1jUjCYIoU8W4TIAHv
         hX5wgzNlkUwnRxfm1MnP0swTsLes2IUyt/hknJBirVZ5En18zJeBxEnVx8uzEY0zqT
         NHk2WVTFGR45S66SAiSUyfkfDAEAxa6SQyrzAA6uwF3U0bhZG6sdrEgx/Y5/FW9ce7
         daA7EMlZCjbK9u/bxonV9cC1s5tyYA5akyDeip8MRcCK074w5MF5s1Zd9PDCg7tPj2
         veGywUHWDdphg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe
 bandwidth requirement
Message-ID: <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201206034408.31492-2-TheSven73@gmail.com>
References: <20201206034408.31492-1-TheSven73@gmail.com>
        <20201206034408.31492-2-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Dec 2020 22:44:08 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> To support jumbo frames, each rx ring dma buffer is 9K in size.
> But the chip only stores a single frame per dma buffer.
> 
> When the chip is working with the default 1500 byte MTU, a 9K
> dma buffer goes from chip -> cpu per 1500 byte frame. This means
> that to get 1G/s ethernet bandwidth, we need 6G/s PCIe bandwidth !
> 
> Fix by limiting the rx ring dma buffer size to the current MTU
> size.

I'd guess this is a memory allocate issue, not a bandwidth thing.
for 9K frames the driver needs to do order-2 allocations of 16K.
For 1500 2K allocations are sufficient (which is < 1 page, hence 
a lot cheaper).

> Tested with iperf3 on a freescale imx6 + lan7430, both sides
> set to mtu 1500 bytes.
> 
> Before:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-20.00  sec   483 MBytes   203 Mbits/sec    0
> After:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-20.00  sec  1.15 GBytes   496 Mbits/sec    0
> 
> And with both sides set to MTU 9000 bytes:
> Before:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-20.00  sec  1.87 GBytes   803 Mbits/sec   27
> After:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-20.00  sec  1.98 GBytes   849 Mbits/sec    0
> 
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

This is a performance improvement, not a fix, it really needs to target
net-next.

> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index ebb5e0bc516b..2bded1c46784 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -1957,11 +1957,11 @@ static int lan743x_rx_next_index(struct lan743x_rx *rx, int index)
>  
>  static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
>  {
> -	int length = 0;
> +	struct net_device *netdev = rx->adapter->netdev;
>  
> -	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
> -	return __netdev_alloc_skb(rx->adapter->netdev,
> -				  length, GFP_ATOMIC | GFP_DMA);
> +	return __netdev_alloc_skb(netdev,
> +				  netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING,
> +				  GFP_ATOMIC | GFP_DMA);
>  }
>  
>  static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
> @@ -1969,9 +1969,10 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
>  {
>  	struct lan743x_rx_buffer_info *buffer_info;
>  	struct lan743x_rx_descriptor *descriptor;
> -	int length = 0;
> +	struct net_device *netdev = rx->adapter->netdev;
> +	int length;
>  
> -	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
> +	length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
>  	descriptor = &rx->ring_cpu_ptr[index];
>  	buffer_info = &rx->buffer_info[index];
>  	buffer_info->skb = skb;
> @@ -2157,8 +2158,8 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
>  			int index = first_index;
>  
>  			/* multi buffer packet not supported */
> -			/* this should not happen since
> -			 * buffers are allocated to be at least jumbo size
> +			/* this should not happen since buffers are allocated
> +			 * to be at least the mtu size configured in the mac.
>  			 */
>  
>  			/* clean up buffers */
> @@ -2632,9 +2633,13 @@ static int lan743x_netdev_change_mtu(struct net_device *netdev, int new_mtu)
>  	struct lan743x_adapter *adapter = netdev_priv(netdev);
>  	int ret = 0;
>  
> +	if (netif_running(netdev))
> +		return -EBUSY;

That may cause a regression to users of the driver who expect to be
able to set the MTU when the device is running. You need to disable 
the NAPI, pause the device, swap the buffers for smaller / bigger ones
and restart the device.

>  	ret = lan743x_mac_set_mtu(adapter, new_mtu);
>  	if (!ret)
>  		netdev->mtu = new_mtu;
> +
>  	return ret;
>  }
>  

