Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83CE307F25
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhA1UGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:06:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231470AbhA1UEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 15:04:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECCFF64E36;
        Thu, 28 Jan 2021 19:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611863221;
        bh=H6v8ZXXV2Uym43MsLOBYTQXBG2B+5yMYkUpZPMWn644=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AWdLNwASDJjkawvi33IHgk2Zd43mbPji3juUCNIX4wOLf/YIWLq/ohWIu74Bdp56c
         k8WDDTuMUgrR9CQc7KWw5qZaVGtMi+F1V+H/Y4eBiitIXngFAvga3kq0T+jAKErfqM
         t2JjcA1OmZ11Je5t/wXUm4DaWXCgdRYsZhJ9xXHA4pFWKg2kdGkjkXl8V7igYVckCQ
         /OT0MGwzNLGKOPSnagKaBtaN3KLRHHeOyT88a4VJru6albHvmMZCFnSv7SPHF5h0YK
         whBdhho3ffywPJY1RAy/bjgn/GSiOzU8GRlNJ6QOsNHO1FKpULm8PFPbjz+HhVYK6V
         yQCAhFD8f9EtA==
Date:   Thu, 28 Jan 2021 11:46:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB
 frames
Message-ID: <20210128114659.2d81a85f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127090747.364951-1-xie.he.0141@gmail.com>
References: <20210127090747.364951-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 01:07:47 -0800 Xie He wrote:
> An HDLC hardware driver may call netif_stop_queue to temporarily stop
> the TX queue when the hardware is busy sending a frame, and after the
> hardware has finished sending the frame, call netif_wake_queue to
> resume the TX queue.
> 
> However, the LAPB module doesn't know about this. Whether or not the
> hardware driver has stopped the TX queue, the LAPB module still feeds
> outgoing frames to the hardware driver for transmission. This can cause
> frames to be dropped by the hardware driver.
> 
> It's not easy to fix this issue in the LAPB module. We can indeed let the
> LAPB module check whether the TX queue has been stopped before feeding
> each frame to the hardware driver, but when the hardware driver resumes
> the TX queue, it's not easy to immediately notify the LAPB module and ask
> it to resume transmission.
> 
> Instead, we can fix this issue at the hdlc_x25 layer, by using qdisc TX
> queues to queue outgoing LAPB frames. The qdisc TX queue will then
> automatically be controlled by netif_stop_queue and netif_wake_queue.

Noob question - could you point at or provide a quick guide to layering
here? I take there is only one netdev, and something maintains an
internal queue which is not stopped when HW driver stops the qdisc?

> This way, when sending, we will use the qdisc queue to queue and send
> the data twice: once as the L3 packet and then (after processed by the
> LAPB module) as an LAPB (L2) frame. This does not make the logic of the
> code messy, because when receiving, data are already "received" on the
> device twice: once as an LAPB (L2) frame and then (after processed by
> the LAPB module) as the L3 packet.
> 
> Some more details about the code change:
> 
> 1. dev_queue_xmit_nit is removed because we already have it when we send
> the skb through the qdisc TX queue (in xmit_one).
> 
> 2. hdlc_type_trans is replaced by assigning skb->dev and skb->protocol
> directly. skb_reset_mac_header in hdlc_type_trans is no longer necessary
> because it will be called in __dev_queue_xmit.

Sounds like we're optimizing to prevent drops, and this was not
reported from production, rather thru code inspection. Ergo I think
net-next will be more appropriate here, unless Martin disagrees.

> diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
> index bb164805804e..b7f2823bf100 100644
> --- a/drivers/net/wan/hdlc_x25.c
> +++ b/drivers/net/wan/hdlc_x25.c
> @@ -89,15 +89,10 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
>  
>  static void x25_data_transmit(struct net_device *dev, struct sk_buff *skb)
>  {
> -	hdlc_device *hdlc = dev_to_hdlc(dev);
> -
> +	skb->dev = dev;
> +	skb->protocol = htons(ETH_P_HDLC);
>  	skb_reset_network_header(skb);
> -	skb->protocol = hdlc_type_trans(skb, dev);
> -
> -	if (dev_nit_active(dev))
> -		dev_queue_xmit_nit(skb, dev);
> -
> -	hdlc->xmit(skb, dev); /* Ignore return value :-( */
> +	dev_queue_xmit(skb);
>  }
>  
>  
> @@ -106,6 +101,12 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>  	int result;
>  
> +	if (skb->protocol == htons(ETH_P_HDLC)) {
> +		hdlc_device *hdlc = dev_to_hdlc(dev);
> +
> +		return hdlc->xmit(skb, dev);
> +	}
> +
>  	/* There should be a pseudo header of 1 byte added by upper layers.
>  	 * Check to make sure it is there before reading it.
>  	 */

