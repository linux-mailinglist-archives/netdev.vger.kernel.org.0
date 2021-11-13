Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB1F44F118
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 04:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhKMDus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 22:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232113AbhKMDus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 22:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90BEB60234;
        Sat, 13 Nov 2021 03:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636775276;
        bh=pzBUyuU4KfvJK4QWnvcGDlaxdbV9hnK0iIgw8C2LWwI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tC38gj6xCm1R0Pju0/km6b7T1/p714NHHq9ddEjBDcmWT2zBG1Q+T6RSGJSuiHzX4
         fBNq7cAJuIm+nYJzPTKdhTosdWsvsXLGgl0jPHQ3Lt7sHbBiw8L1bR94652BnDx/Df
         iT6Nl21kiI13wGDB35llGtP5qEuK2AA1EMFsYw0PNdhdlBWWRiEFVjFr20k/ggzhbg
         yIJ8ZomoCH0UVHTV1uTtqeTCUYWCKM9/zA3MIeTw5BhmNGHLn27YKEME8M4PaX83H1
         S8CoawsSWjbdVR1G/nNXdxSANmGqK78r7+wnVlObxtxhWaF5oRaopZKr0qqoVbz3jM
         NwVmMqykAdbcQ==
Date:   Fri, 12 Nov 2021 19:47:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacky Chou <jackychou@asix.com.tw>
Cc:     davem@davemloft.net, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        louis@asix.com.tw
Subject: Re: [PATCH] net: usb: ax88179_178a: add TSO feature
Message-ID: <20211112194755.6862ac1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211112033322.741974-1-jackychou@asix.com.tw>
References: <20211112033322.741974-1-jackychou@asix.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Nov 2021 11:33:22 +0800 Jacky Chou wrote:
> On low-effciency embedded platforms, transmission performance is poor
> due to on Bulk-out with single packet.
> Adding TSO feature improves the transmission performance and reduces
> the number of interrupt caused by Bulk-out complete.
> 
> Reference to module, net: usb: aqc111.
> 
> Signed-off-by: Jacky Chou <jackychou@asix.com.tw>
> ---
>  drivers/net/usb/ax88179_178a.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
> index c13167183..866954155 100644
> --- a/drivers/net/usb/ax88179_178a.c
> +++ b/drivers/net/usb/ax88179_178a.c
> @@ -1368,6 +1368,9 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
>  	dev->net->needed_headroom = 8;
>  	dev->net->max_mtu = 4088;
>  
> +	if (usb_device_no_sg_constraint(dev->udev))
> +		dev->can_dma_sg = 1;

Why don't you use this information...

>  	/* Initialize MII structure */
>  	dev->mii.dev = dev->net;
>  	dev->mii.mdio_read = ax88179_mdio_read;
> @@ -1377,11 +1380,14 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
>  	dev->mii.phy_id = 0x03;
>  	dev->mii.supports_gmii = 1;
>  
> -	dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
> -			      NETIF_F_RXCSUM;
> +	dev->net->features |= NETIF_F_SG | NETIF_F_IP_CSUM |
> +			      NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM | NETIF_F_TSO;

... to conditionally set the NETIF_F_SG flag?

> -	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
> -				 NETIF_F_RXCSUM;
> +	dev->net->hw_features |= NETIF_F_SG | NETIF_F_IP_CSUM |
> +				 NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
> +				 NETIF_F_TSO;

If you want to enable all the features just write:

	dev->net->hw_features |= dev->net->features;

No need to repeat all the flags.

> +	netif_set_gso_max_size(dev->net, 16384);
>  
>  	/* Enable checksum offload */
>  	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
> @@ -1537,6 +1543,10 @@ ax88179_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
>  
>  	headroom = skb_headroom(skb) - 8;
>  
> +	if (!dev->can_dma_sg && (dev->net->features & NETIF_F_SG) &&
> +	    skb_linearize(skb))
> +		return NULL;
> +
>  	if ((skb_header_cloned(skb) || headroom < 0) &&
>  	    pskb_expand_head(skb, headroom < 0 ? 8 : 0, 0, GFP_ATOMIC)) {
>  		dev_kfree_skb_any(skb);

Okay... where is the TSO implementation? The TCP stack passes
parameters like MSS which you need to inform the device about.
You should also count TSO packets as multiple packets in stats.

Are you sure this device supports TSO and not just SG?
