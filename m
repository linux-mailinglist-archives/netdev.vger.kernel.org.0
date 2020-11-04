Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909602A5BD1
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgKDBVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:21:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729246AbgKDBVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:21:04 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31E052242A;
        Wed,  4 Nov 2020 01:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604452863;
        bh=PouRaEaxeS/9UqZsJtyROw/LJe348pI8+fryV7p2N9k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pqXIJRVKQNas4TN3uLC/oM70IRvpYu1UM5yHA0OXbMSBPd1tclFoo9EaNn3ZUAIkR
         GqvgaZ4368gt5aWCM1x+xZ2mVH64+ZS8Vdj3Z1+FgOsyR/r6CBXr6of0DCPGGY4Hl/
         CjrGL9vMs1MBAqJdQswYaEktGmAQwcV/NML2cRxM=
Date:   Tue, 3 Nov 2020 17:21:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [net 05/27] can: dev: can_get_echo_skb(): prevent call to
 kfree_skb() in hard IRQ context
Message-ID: <20201103172102.3d75cb96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103220636.972106-6-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
        <20201103220636.972106-6-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 23:06:14 +0100 Marc Kleine-Budde wrote:
> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> 
> If a driver calls can_get_echo_skb() during a hardware IRQ (which is often, but
> not always, the case), the 'WARN_ON(in_irq)' in
> net/core/skbuff.c#skb_release_head_state() might be triggered, under network
> congestion circumstances, together with the potential risk of a NULL pointer
> dereference.
> 
> The root cause of this issue is the call to kfree_skb() instead of
> dev_kfree_skb_irq() in net/core/dev.c#enqueue_to_backlog().
> 
> This patch prevents the skb to be freed within the call to netif_rx() by
> incrementing its reference count with skb_get(). The skb is finally freed by
> one of the in-irq-context safe functions: dev_consume_skb_any() or
> dev_kfree_skb_any(). The "any" version is used because some drivers might call
> can_get_echo_skb() in a normal context.
> 
> The reason for this issue to occur is that initially, in the core network
> stack, loopback skb were not supposed to be received in hardware IRQ context.
> The CAN stack is an exeption.
> 
> This bug was previously reported back in 2017 in [1] but the proposed patch
> never got accepted.
> 
> While [1] directly modifies net/core/dev.c, we try to propose here a
> smoother modification local to CAN network stack (the assumption
> behind is that only CAN devices are affected by this issue).
> 
> [1] http://lore.kernel.org/r/57a3ffb6-3309-3ad5-5a34-e93c3fe3614d@cetitec.com
> 
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Link: https://lore.kernel.org/r/20201002154219.4887-2-mailhol.vincent@wanadoo.fr
> Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

Hm... Why do we receive a skb with a socket attached?

At a quick glance this is some loopback, so shouldn't we skb_orphan()
in the xmit function instead?

Otherwise we should probably fix this in enqueue_to_backlog().

> diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> index b70ded3760f2..73cfcd7e9517 100644
> --- a/drivers/net/can/dev.c
> +++ b/drivers/net/can/dev.c
> @@ -538,7 +538,11 @@ unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx)
>  	if (!skb)
>  		return 0;
>  
> -	netif_rx(skb);
> +	skb_get(skb);
> +	if (netif_rx(skb) == NET_RX_SUCCESS)
> +		dev_consume_skb_any(skb);
> +	else
> +		dev_kfree_skb_any(skb);
>  
>  	return len;
>  }

