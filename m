Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A6F49E33E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbiA0NVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:21:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37620 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiA0NVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 08:21:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80B14B82213;
        Thu, 27 Jan 2022 13:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B509C340E4;
        Thu, 27 Jan 2022 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643289701;
        bh=Cdi4tpSl0bmCYXxwOW63erAWHsnHXus7AGOBzsdCke0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rEoV2+xzNgMSKA3n0Gy08J1o9p8yCiwgPIVPWvJoodBPvatKR3FR1xqTk33ClOuXX
         x8mPReSZGXWOtjtzh6bDNdm/tlzfLPcphuo+PLbPvndWcilW52XdhlMqFVmIQKsIWS
         Ncj0z+RJeVVjZHSHRZVpgSgU7H1l2Im3gBl+yR6k=
Date:   Thu, 27 Jan 2022 14:21:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v1 4/4] usbnet: add support for label from
 device tree
Message-ID: <YfKcYXjfhVKUKfzY@kroah.com>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-5-o.rempel@pengutronix.de>
 <YfJ6lhZMAEmetdad@kroah.com>
 <20220127112305.GC9150@pengutronix.de>
 <YfKCTG7N86yy74q+@kroah.com>
 <20220127120039.GE9150@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127120039.GE9150@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 01:00:39PM +0100, Oleksij Rempel wrote:
> On Thu, Jan 27, 2022 at 12:30:20PM +0100, Greg KH wrote:
> > On Thu, Jan 27, 2022 at 12:23:05PM +0100, Oleksij Rempel wrote:
> > > On Thu, Jan 27, 2022 at 11:57:26AM +0100, Greg KH wrote:
> > > > On Thu, Jan 27, 2022 at 11:49:05AM +0100, Oleksij Rempel wrote:
> > > > > Similar to the option to set a netdev name in device tree for switch
> > > > > ports by using the property "label" in the DSA framework, this patch
> > > > > adds this functionality to the usbnet infrastructure.
> > > > > 
> > > > > This will help to name the interfaces properly throughout supported
> > > > > devices. This provides stable interface names which are useful
> > > > > especially in embedded use cases.
> > > > 
> > > > Stable interface names are for userspace to set, not the kernel.
> > > > 
> > > > Why would USB care about this?  If you need something like this, get it
> > > > from the USB device itself, not DT, which should have nothing to do with
> > > > USB as USB is a dynamic, self-describing, bus.  Unlike DT.
> > > > 
> > > > So I do not think this is a good idea.
> > > 
> > > This is needed for embedded devices with integrated USB Ethernet
> > > controller. Currently I have following use cases to solve:
> > > - Board with one or multiple USB Ethernet controllers with external PHY.
> > >   The PHY need devicetree to describe IRQ, clock sources, label on board, etc.
> > 
> > The phy is for the USB controller, not the Ethernet controller, right?
> > If for the ethernet controller, ugh, that's a crazy design and I would
> > argue a broken one.  But whatever, DT should not be used to describe a
> > USB device itself.
> > 
> > > - Board with USB Ethernet controller with DSA switch. The USB ethernet
> > >   controller is attached to the CPU port of DSA switch. In this case,
> > >   DSA switch is the sub-node of the USB device.
> > 
> > What do you mean exactly by "sub node"?  USB does not have such a term.
> 
> Here are some examples:
> 
>   - |
>     usb@11270000 {
>         reg = <0x11270000 0x1000>;

How can a USB device have a register?

And what does 11270000 mean?


>         #address-cells = <1>;
>         #size-cells = <0>;
> 
>         ethernet@1 {
>             compatible = "usb424,ec00";
>             reg = <1>;
>             label = "LAN0";

Where did that come from?  That should be added in userspace, not from
the kernel.

> 	    // there is no internal eeprom, so MAC address is taken from
> 	    // NVMEM of the SoC.
>             local-mac-address = [00 00 00 00 00 00];
> 
>             mdio {
> 		ethernet-phy@4 {
> 			reg = <4>;
> 			// Interrupt is attached to the SoC or the GPIO
> 			// controller of the same USB devices.
> 			interrupts-extended = <&gpio1 28 IRQ_TYPE_LEVEL_LOW>;
> 			// same about reset. It is attached to the SoC
> 			// or GPIO controller of the USB device.
> 			reset-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
> 			reset-assert-us = <10000>;
> 			reset-deassert-us = <1000>;
> 			// some external clock provider
> 			clocks = <&clk>
> 			qca,smarteee-tw-us-1g = <24>;
> 			qca,clk-out-frequency = <125000000>;

So this device does not follow the spec for this driver in that you have
to get the values for the phy from DT and not the device itself?  Why
not fix the firmware in the device to report this?

Anyway, this feels really wrong, USB should not be involved in DT by
virtue of how the bus was designed.

And again, pick your names in userspace, embedded is not "special" here.
You can do persistant network device names in a very trivial shell
script if needed, we used to do it that way 18 years ago :)

thanks,

greg k-h
