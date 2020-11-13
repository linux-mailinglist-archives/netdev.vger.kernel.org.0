Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91522B242A
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgKMS7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:59:51 -0500
Received: from mailout12.rmx.de ([94.199.88.78]:51195 "EHLO mailout12.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKMS7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 13:59:51 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout12.rmx.de (Postfix) with ESMTPS id 4CXnp91sLxzRqWG;
        Fri, 13 Nov 2020 19:59:45 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CXnnt421hz2TTLx;
        Fri, 13 Nov 2020 19:59:30 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.24) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 13 Nov
 2020 19:57:34 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "Richard Cochran" <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 06/11] net: dsa: microchip: ksz9477: basic interrupt support
Date:   Fri, 13 Nov 2020 19:57:08 +0100
Message-ID: <2666087.ia0MCzDV76@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201112232617.dka72sudrbii52aq@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de> <20201112153537.22383-7-ceggers@arri.de> <20201112232617.dka72sudrbii52aq@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.24]
X-RMX-ID: 20201113-195938-4CXnnt421hz2TTLx-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, 13 November 2020, 00:26:17 CET, Vladimir Oltean wrote:
> On Thu, Nov 12, 2020 at 04:35:32PM +0100, Christian Eggers wrote:
> > Interrupts are required for TX time stamping. Probably they could also
> > be used for PHY connection status.
> 
> Do the KSZ switches have an internal PHY? And there's a single interrupt
> line, shared between the PTP timestamping engine, and the internal PHY
> that is driver by phylib?
The device has only one interrupt line (INTRP_N), although there may be
applications which use additionally the GPIO (PPS/PEROUT) output as an
interrupt.

I assume that the PHY driver currently uses polling (as the KSZ9477 driver
used to have no interrupt functionality. Maybe this can be changed in future,
as the KSZ hardware has hierarchical interrupt enable/status registers.

> > This patch only adds the basic infrastructure for interrupts, no
> > interrupts are actually enabled nor handled.
> > 
> > ksz9477_reset_switch() must be called before requesting the IRQ (in
> > ksz9477_init() instead of ksz9477_setup()).
> 
> A patch can never be "too simple". Maybe you could factor out that code
> movement into a separate patch.
I haven't checked yet, but I'll try.

[...]

> > +static irqreturn_t ksz9477_switch_irq_thread(int irq, void *dev_id)
> > +{
> > +	struct ksz_device *dev = dev_id;
> > +	u32 data;
> > +	int port;
> > +	int ret;
> > +	irqreturn_t result = IRQ_NONE;
> 
> Please keep local variable declaration sorted in the reverse order of
> line length. But....
> 
> > +
> > +	/* Read global port interrupt status register */
> > +	ret = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data);
> > +	if (ret)
> > +		return result;
> 
> ...Is there any point at all in keeping the "result" variable?
> 
> > +
> > +	for (port = 0; port < dev->port_cnt; port++) {
> > +		if (data & BIT(port)) {
> 
> You can reduce the indentation level by 1 here using:
> 
> 		if (!(data & BIT(port)))
> 			continue;
> 
> > +			u8 data8;
> > +
> > +			/* Read port interrupt status register */
> > +			ret = ksz_read8(dev, PORT_CTRL_ADDR(port, REG_PORT_INT_STATUS),
> > +					&data8);
> > +			if (ret)
> > +				return result;
> > +
> > +			/* ToDo: Add specific handling of port interrupts */
> 
> Buggy? Please return IRQ_HANDLED, otherwise the system, when bisected to
> this commit exactly, will emit interrupts and complain that nobody cared.
Probably this can be kept as it is. The hardware will only emit interrupts
if these have been explicitly enabled. Although the *port* interrupts are
enabled here (and all bits in the "Port Interrupt Mask Register" (section
5.2.1.12) are active after reset), actually no interrupts should be raised as
the ports sub units (PTP, PHY and ACL) don't emit interrupt after reset:
- PHY (section 5.2.2.19): All interrupts are disabled after reset
- PTP (section 5.2.11.11): dito
- ACL (not found): I got never interrupts from here

> 
> > +		}
> > +	}
> > +
> > +	return result;
> > +}
> > +
> > +static int ksz9477_enable_port_interrupts(struct ksz_device *dev)
> > +{
> > +	u32 data;
> > +	int ret;
> > +
> > +	ret = ksz_read32(dev, REG_SW_PORT_INT_MASK__4, &data);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Enable port interrupts (0 means enabled) */
> > +	data &= ~((1 << dev->port_cnt) - 1);
> 
> And what's the " - 1" for?
I build a bitmask where the bits 0..(dev->port_cnt-1) are set... I'll whether
GENMASK() can be used with variable data as argument.
> 
> > +	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, data);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return 0;
> 
> 	return ksz_write32(dev, REG_SW_PORT_INT_MASK__4, data);
> 
> > +}
> > +
> > +static int ksz9477_disable_port_interrupts(struct ksz_device *dev)
> > +{
> > +	u32 data;
> > +	int ret;
> > +
> > +	ret = ksz_read32(dev, REG_SW_PORT_INT_MASK__4, &data);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Disable port interrupts (1 means disabled) */
> > +	data |= ((1 << dev->port_cnt) - 1);
> > +	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, data);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return 0;
> 
> same comments as above.
> 
> Also, it's almost as if you want to implement these in the same
> function, with a "bool enable"?
You are right.

> 
> > +}
> > +
> > 
> >  static int ksz9477_switch_init(struct ksz_device *dev)
> >  {
> > 
> > -	int i;
> > +	int i, ret;
> > 
> >  	dev->ds->ops = &ksz9477_switch_ops;
> > 
> > +	ret = ksz9477_reset_switch(dev);
> > +	if (ret) {
> > +		dev_err(dev->dev, "failed to reset switch\n");
> > +		return ret;
> > +	}
> > +
> > 
> >  	for (i = 0; i < ARRAY_SIZE(ksz9477_switch_chips); i++) {
> >  	
> >  		const struct ksz_chip_data *chip = &ksz9477_switch_chips[i];
> > 
> > @@ -1584,12 +1651,32 @@ static int ksz9477_switch_init(struct ksz_device
> > *dev)> 
> >  	/* set the real number of ports */
> >  	dev->ds->num_ports = dev->port_cnt;
> > 
> > +	if (dev->irq > 0) {
> > +		unsigned long irqflags =
> > irqd_get_trigger_type(irq_get_irq_data(dev->irq));
> What is irqd_get_trigger_type and what does it have to do with the
> "irqflags" argument of request_threaded_irq? Where else have you even
> seen this?
No idea where I originally found this. It's some time ago when I wrote this.

> 
> > +
> > +		irqflags |= IRQF_ONESHOT;
> 
> And shared maybe?
I don't need it. Is there a rule when to add shared? At least the KSZ should 
be able to tell whether it has raised an IRQ or not.

> 
> > +		ret = devm_request_threaded_irq(dev->dev, dev->irq, NULL,
> > +						ksz9477_switch_irq_thread,
> > +						irqflags,
> > +						dev_name(dev->dev),
> > +						dev);
> > +		if (ret) {
> > +			dev_err(dev->dev, "failed to request IRQ.\n");
> > +			return ret;
> > +		}
> > +
> > +		ret = ksz9477_enable_port_interrupts(dev);
> > +		if (ret)
> > +			return ret;
> 
> Could you also clear pending interrupts before enabling the line?
As the device has just been reset and no concrete interrupts have been enabled,
there should be no need for this.

> 
> > +	}
> > 
> >  	return 0;
> >  
> >  }
> >  
> >  static void ksz9477_switch_exit(struct ksz_device *dev)
> >  {
> > 
> > +	if (dev->irq > 0)
> > +		ksz9477_disable_port_interrupts(dev);
> 
> I think it'd look a bit nicer if you moved this condition into
> ksz9477_disable_port_interrupts:
> 
> 	if (!dev->irq)
> 		return;
> 
> >  	ksz9477_reset_switch(dev);
> >  
> >  }

regards
Christian



