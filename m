Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB4F88C7C
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 19:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfHJRc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 13:32:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfHJRc1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 13:32:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SE+j5+r+nEkjEXOe9lM/1B29SIYVYszt5l3ktEQBqlc=; b=26SxF121GywZKJ+OnXRvXdHP7f
        D90MvJPCNOMSpOAsZM0yh1dUB1s0LSj/rPJOliU241Ux1EXbgO7k7jfeqXKRknyKVpp7jn5hwDfr1
        +wmLABjUzxbNeDSg7KZrFXoIP9O2QR8oxZDjLVZBQEgR0UPm6Bn2ECNs87jzN+ezDHCc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwVE8-0000Uo-48; Sat, 10 Aug 2019 19:32:24 +0200
Date:   Sat, 10 Aug 2019 19:32:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v5 6/6] net: mscc: PTP Hardware Clock (PHC)
 support
Message-ID: <20190810173224.GI30120@lunn.ch>
References: <20190807092214.19936-1-antoine.tenart@bootlin.com>
 <20190807092214.19936-7-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807092214.19936-7-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Antoine

> @@ -596,11 +606,53 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	dev->stats.tx_packets++;
>  	dev->stats.tx_bytes += skb->len;
> -	dev_kfree_skb_any(skb);
> +
> +	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
> +	    port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> +		struct ocelot_skb *oskb =
> +			kzalloc(sizeof(struct ocelot_skb), GFP_ATOMIC);
> +
> +		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> +
> +		oskb->skb = skb;

You have not checked if oskb == NULL. The allocation could of failed.

> +	irq_ptp_rdy = platform_get_irq_byname(pdev, "ptp_rdy");
> +	if (irq_ptp_rdy > 0) {

I wonder if this should be

> +	if (irq_ptp_rdy > 0 && ocelot->targets[PTP]) {

There is not much you can do in the PTP interrupt handler if you don't
have the PTP registers. In fact, bad things might happen if it tried
to handle such an interrupt.

> +		err = devm_request_threaded_irq(&pdev->dev, irq_ptp_rdy, NULL,
> +						ocelot_ptp_rdy_irq_handler,
> +						IRQF_ONESHOT, "ptp ready",
> +						ocelot);
> +		if (err)
> +			return err;
> +
> +		/* Check if we can support PTP */
> +		if (ocelot->targets[PTP])
> +			ocelot->ptp = 1;
> +	}
> +

  Andrew
