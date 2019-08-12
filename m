Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC26898FA
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 10:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfHLItr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 04:49:47 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:33905 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbfHLItq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 04:49:46 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 728A120000F;
        Mon, 12 Aug 2019 08:49:44 +0000 (UTC)
Date:   Mon, 12 Aug 2019 10:49:43 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v5 6/6] net: mscc: PTP Hardware Clock (PHC)
 support
Message-ID: <20190812084943.GG3698@kwain>
References: <20190807092214.19936-1-antoine.tenart@bootlin.com>
 <20190807092214.19936-7-antoine.tenart@bootlin.com>
 <20190810173224.GI30120@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190810173224.GI30120@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sat, Aug 10, 2019 at 07:32:24PM +0200, Andrew Lunn wrote:
> > @@ -596,11 +606,53 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
> >  
> >  	dev->stats.tx_packets++;
> >  	dev->stats.tx_bytes += skb->len;
> > -	dev_kfree_skb_any(skb);
> > +
> > +	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
> > +	    port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> > +		struct ocelot_skb *oskb =
> > +			kzalloc(sizeof(struct ocelot_skb), GFP_ATOMIC);
> > +
> > +		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> > +
> > +		oskb->skb = skb;
> 
> You have not checked if oskb == NULL. The allocation could of failed.

Will fix.

> > +	irq_ptp_rdy = platform_get_irq_byname(pdev, "ptp_rdy");
> > +	if (irq_ptp_rdy > 0) {
> 
> I wonder if this should be
> 
> > +	if (irq_ptp_rdy > 0 && ocelot->targets[PTP]) {
> 
> There is not much you can do in the PTP interrupt handler if you don't
> have the PTP registers. In fact, bad things might happen if it tried
> to handle such an interrupt.

That's right, the IRQ could be described and the register bank not. I'll
fix that.

> > +		err = devm_request_threaded_irq(&pdev->dev, irq_ptp_rdy, NULL,
> > +						ocelot_ptp_rdy_irq_handler,
> > +						IRQF_ONESHOT, "ptp ready",
> > +						ocelot);
> > +		if (err)
> > +			return err;
> > +
> > +		/* Check if we can support PTP */
> > +		if (ocelot->targets[PTP])
> > +			ocelot->ptp = 1;
> > +	}

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
