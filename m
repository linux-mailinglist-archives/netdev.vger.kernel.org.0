Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B04A242111
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 22:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgHKUG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 16:06:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50232 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgHKUG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 16:06:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k5aXs-0094V0-Ho; Tue, 11 Aug 2020 22:06:52 +0200
Date:   Tue, 11 Aug 2020 22:06:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     David Thompson <dthompson@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Asmaa Mnebhi <Asmaa@mellanox.com>
Subject: Re: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Message-ID: <20200811200652.GD2141651@lunn.ch>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
 <20200731174222.GE1748118@lunn.ch>
 <CH2PR12MB3895E054D1E00168D9FFB2F0D7450@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB3895E054D1E00168D9FFB2F0D7450@CH2PR12MB3895.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 07:53:35PM +0000, Asmaa Mnebhi wrote:
> Hi Andrew,
> 
> Thanks again for your feedback.
> 
> > > +	/* Finally check if this interrupt is from PHY device.
> > > +	 * Return if it is not.
> > > +	 */
> > > +	val = readl(priv->gpio_io +
> > > +			MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0);
> > > +	if (!(val & priv->phy_int_gpio_mask))
> > > +		return IRQ_NONE;
> > > +
> > > +	/* Clear interrupt when done, otherwise, no further interrupt
> > > +	 * will be triggered.
> > > +	 * Writing 0x1 to the clear cause register also clears the
> > > +	 * following registers:
> > > +	 * cause_gpio_arm_coalesce0
> > > +	 * cause_rsh_coalesce0
> > > +	 */
> > > +	val = readl(priv->gpio_io +
> > > +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> > > +	val |= priv->phy_int_gpio_mask;
> > > +	writel(val, priv->gpio_io +
> > > +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> > 
> > Shoudn't there be a call into the PHY driver at this point?
> > 
> > > +
> > > +	return IRQ_HANDLED;
> > > +}
> > 
> > So these last three functions seem to be an interrupt controller?  So why not
> > model it as a Linux interrupt controller?
> 
> Apologies for the confusion. The plan is to remove support to the polling and instead support the HW interrupt as follows (from the probe):
> irq = platform_get_irq(pdev, MLXBF_GIGE_PHY_INT_N);
>          if (irq < 0) {
>                  dev_err(dev, "Failed to retrieve irq 0x%x\n", irq);
>                  return -ENODEV;
>          }
>          priv->mdiobus->irq[phy_addr] = irq;

O.K, that is one way to do it. The other is via the MAC driver calling
phy_mac_interrupt().

> I guess my question is should we model it as a linux interrupt
> controller rather than use phy_connect_direct ?

It seems like there are other interrupt sources, not just the PHY. Do
you plan to use any of them? It can be easier to debug issues if you
have an interrupt controller, can see counters in /proc/interrupts,
etc. Also, if you need to export the lines to some other driver,
e.g. SFP, it is easier to do when there is an interrupt controller.

> Using phy_connect_direct to register my interrupt handler, I have
> encountered a particular issue where the PHY interrupt is triggered
> before the phy link status bit (reg 0x1 of the PHY device) is set to
> 1 (indicating link is up).

So the hardware is broken :-(

What about the other way, link down? Same problem?

Polling is probably your best bet, since it is robust against broken
interrupts. If i remember correctly, this is an off the shelf 1G PHY?
Microchip? Is there an errata for this? Maybe the errata suggests a
work around?

     Andrew
