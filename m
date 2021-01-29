Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBDC308E8C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhA2UhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:37:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38862 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232887AbhA2Ug4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 15:36:56 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l5aUu-003FSA-Aa; Fri, 29 Jan 2021 21:36:04 +0100
Date:   Fri, 29 Jan 2021 21:36:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        Anders =?iso-8859-1?Q?R=F8nningen?= <anders@ronningen.priv.no>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs
 w/o dma cache snooping
Message-ID: <YBRxtM/tpmegczPD@lunn.ch>
References: <20210129195240.31871-1-TheSven73@gmail.com>
 <20210129195240.31871-2-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129195240.31871-2-TheSven73@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index f1f6eba4ace4..f485320e5784 100644
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
>  static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
> @@ -1977,9 +1977,10 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
>  {
>  	struct lan743x_rx_buffer_info *buffer_info;
>  	struct lan743x_rx_descriptor *descriptor;
> -	int length = 0;
> +	struct net_device *netdev = rx->adapter->netdev;
> +	int length;

Please keep to reverse christmass tree.
>  
> -	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
> +	length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
>  	descriptor = &rx->ring_cpu_ptr[index];
>  	buffer_info = &rx->buffer_info[index];
>  	buffer_info->skb = skb;
> @@ -2148,11 +2149,18 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
>  			descriptor = &rx->ring_cpu_ptr[first_index];
>  
>  			/* unmap from dma */
> +			packet_length =	RX_DESC_DATA0_FRAME_LENGTH_GET_
> +					(descriptor->data0);
>  			if (buffer_info->dma_ptr) {
> -				dma_unmap_single(&rx->adapter->pdev->dev,
> -						 buffer_info->dma_ptr,
> -						 buffer_info->buffer_length,
> -						 DMA_FROM_DEVICE);
> +				dma_sync_single_for_cpu(&rx->adapter->pdev->dev,
> +							buffer_info->dma_ptr,
> +							packet_length,
> +							DMA_FROM_DEVICE);
> +				dma_unmap_single_attrs(&rx->adapter->pdev->dev,
> +						       buffer_info->dma_ptr,
> +						       buffer_info->buffer_length,
> +						       DMA_FROM_DEVICE,
> +						       DMA_ATTR_SKIP_CPU_SYNC);

So this patch appears to contain two different changes
1) You only allocate a receive buffer as big as the MTU plus overheads
2) You change the cache operations to operate on the received length.

The first change should be completely safe, and i guess, is giving
most of the benefits. The second one is where interesting things might
happen. So please split this patch into two.  If it does break, we can
git bisect, and probably end up on the second patch.

Thanks
	Andrew
