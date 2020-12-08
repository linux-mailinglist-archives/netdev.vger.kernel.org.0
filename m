Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF532D3334
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbgLHUQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731040AbgLHUMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:12:50 -0500
Date:   Tue, 8 Dec 2020 11:50:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607457037;
        bh=Evmr4NCR73nJG7NR2K0eviLkh4z4YujSYKA4BQDd15o=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=T8QeED49xiiUzJADy3kbbjWWLJtYVMvMX8Yq3Gon37syE3BWQorrGAbfhvDsQb/+h
         uuvY72OxmS7HJ5e46Q8ibG4myZ3Ub6OAuH1IjwUmngU62YIx4pWJNg+wqzOee0ERDY
         U139jynoRlKekLDYgdY/RBhwaloU90xj5jhpfVvUQ4lxO5Yhkme0bhhE0S/6lp/GA5
         qD3sTDi6VIN9a0G+n38AJJK+ETR1IF8nb+3pXXyiSOEHG/8HOz6bAfzgUAScG96IYp
         +M6yuVBhQmcylTGKuVm19VGLw+gs2uVCYkzG+LKLedxjJGU9skEcG2GuBFwFbDSAS1
         VS5DYY2sbtaXw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1 1/2] lan743x: improve performance: fix
 rx_napi_poll/interrupt ping-pong
Message-ID: <20201208115035.74221c31@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201206034408.31492-1-TheSven73@gmail.com>
References: <20201206034408.31492-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Dec 2020 22:44:07 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> Even if the rx ring is completely full, and there is more rx data
> waiting on the chip, the rx napi poll fn will never run more than
> once - it will always immediately bail out and re-enable interrupts.
> Which results in ping-pong between napi and interrupt.
> 
> This defeats the purpose of napi, and is bad for performance.
> 
> Fix by addressing two separate issues:
> 
> 1. Ensure the rx napi poll fn always updates the rx ring tail
>    when returning, even when not re-enabling interrupts.
> 
> 2. Up to half of elements in a full rx ring are extension
>    frames, which do not generate any skbs. Limit the default
>    napi weight to the smallest no. of skbs that can be generated
>    by a full rx ring.
> 
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> ---
> 
> Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 905b2032fa42
> 
> To: Bryan Whitehead <bryan.whitehead@microchip.com>
> To: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> To: "David S. Miller" <davem@davemloft.net>
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
>  drivers/net/ethernet/microchip/lan743x_main.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index 87b6c59a1e03..ebb5e0bc516b 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -2260,10 +2260,11 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
>  				  INT_BIT_DMA_RX_(rx->channel_number));
>  	}
>  
> +done:
>  	/* update RX_TAIL */
>  	lan743x_csr_write(adapter, RX_TAIL(rx->channel_number),
>  			  rx_tail_flags | rx->last_tail);
> -done:
> +

I assume this rings the doorbell to let the device know that more
buffers are available? If so it's a little unusual to do this at the
end of NAPI poll. The more usual place would be to do this every n
times a new buffer is allocated (in lan743x_rx_init_ring_element()?)
That's to say for example ring the doorbell every time a buffer is put
at an index divisible by 16.

>  	return count;
>  }
>  
> @@ -2405,9 +2406,15 @@ static int lan743x_rx_open(struct lan743x_rx *rx)
>  	if (ret)
>  		goto return_error;
>  
> +	/* up to half of elements in a full rx ring are
> +	 * extension frames. these do not generate skbs.
> +	 * to prevent napi/interrupt ping-pong, limit default
> +	 * weight to the smallest no. of skbs that can be
> +	 * generated by a full rx ring.
> +	 */
>  	netif_napi_add(adapter->netdev,
>  		       &rx->napi, lan743x_rx_napi_poll,
> -		       rx->ring_size - 1);
> +		       (rx->ring_size - 1) / 2);

This is rather unusual, drivers should generally pass NAPI_POLL_WEIGHT
here.
