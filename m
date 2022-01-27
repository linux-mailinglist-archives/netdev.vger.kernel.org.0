Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682AC49E1CB
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 13:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiA0MAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 07:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiA0MAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 07:00:51 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E244C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 04:00:51 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD3SE-000228-HS; Thu, 27 Jan 2022 13:00:42 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD3SB-0001Rk-Jt; Thu, 27 Jan 2022 13:00:39 +0100
Date:   Thu, 27 Jan 2022 13:00:39 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Greg KH <gregkh@linuxfoundation.org>
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
Message-ID: <20220127120039.GE9150@pengutronix.de>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-5-o.rempel@pengutronix.de>
 <YfJ6lhZMAEmetdad@kroah.com>
 <20220127112305.GC9150@pengutronix.de>
 <YfKCTG7N86yy74q+@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfKCTG7N86yy74q+@kroah.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:48:04 up 47 days, 20:33, 86 users,  load average: 0.02, 0.06,
 0.13
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:30:20PM +0100, Greg KH wrote:
> On Thu, Jan 27, 2022 at 12:23:05PM +0100, Oleksij Rempel wrote:
> > On Thu, Jan 27, 2022 at 11:57:26AM +0100, Greg KH wrote:
> > > On Thu, Jan 27, 2022 at 11:49:05AM +0100, Oleksij Rempel wrote:
> > > > Similar to the option to set a netdev name in device tree for switch
> > > > ports by using the property "label" in the DSA framework, this patch
> > > > adds this functionality to the usbnet infrastructure.
> > > > 
> > > > This will help to name the interfaces properly throughout supported
> > > > devices. This provides stable interface names which are useful
> > > > especially in embedded use cases.
> > > 
> > > Stable interface names are for userspace to set, not the kernel.
> > > 
> > > Why would USB care about this?  If you need something like this, get it
> > > from the USB device itself, not DT, which should have nothing to do with
> > > USB as USB is a dynamic, self-describing, bus.  Unlike DT.
> > > 
> > > So I do not think this is a good idea.
> > 
> > This is needed for embedded devices with integrated USB Ethernet
> > controller. Currently I have following use cases to solve:
> > - Board with one or multiple USB Ethernet controllers with external PHY.
> >   The PHY need devicetree to describe IRQ, clock sources, label on board, etc.
> 
> The phy is for the USB controller, not the Ethernet controller, right?
> If for the ethernet controller, ugh, that's a crazy design and I would
> argue a broken one.  But whatever, DT should not be used to describe a
> USB device itself.
> 
> > - Board with USB Ethernet controller with DSA switch. The USB ethernet
> >   controller is attached to the CPU port of DSA switch. In this case,
> >   DSA switch is the sub-node of the USB device.
> 
> What do you mean exactly by "sub node"?  USB does not have such a term.

Here are some examples:

  - |
    usb@11270000 {
        reg = <0x11270000 0x1000>;
        #address-cells = <1>;
        #size-cells = <0>;

        ethernet@1 {
            compatible = "usb424,ec00";
            reg = <1>;
            label = "LAN0";
	    // there is no internal eeprom, so MAC address is taken from
	    // NVMEM of the SoC.
            local-mac-address = [00 00 00 00 00 00];

            mdio {
		ethernet-phy@4 {
			reg = <4>;
			// Interrupt is attached to the SoC or the GPIO
			// controller of the same USB devices.
			interrupts-extended = <&gpio1 28 IRQ_TYPE_LEVEL_LOW>;
			// same about reset. It is attached to the SoC
			// or GPIO controller of the USB device.
			reset-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
			reset-assert-us = <10000>;
			reset-deassert-us = <1000>;
			// some external clock provider
			clocks = <&clk>
			qca,smarteee-tw-us-1g = <24>;
			qca,clk-out-frequency = <125000000>;
		};
            };
        };
    };
  - |
    usb@11270000 {
        reg = <0x11270000 0x1000>;
        #address-cells = <1>;
        #size-cells = <0>;

        usb1@1 {
            compatible = "usb424,9514";
            reg = <1>;
            #address-cells = <1>;
            #size-cells = <0>;

            eth0: ethernet@1 {
               compatible = "usb424,ec00";
               reg = <1>;
               label = "cpu0";

               fixed-link {
                   speed = <1000>;
                   full-duplex;
               };

               // managment interface of the switch is attached to the
	       // MDIO bus of this USB device.
               mdio {
                switch@0 {
                    compatible = "microchip,ksz9477";
                    reg = <0>;
		    // reset is controlled by the SoC or by the GPIO
		    // controller of this USB device.
                    reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;

                    ethernet-ports {
                        #address-cells = <1>;
                        #size-cells = <0>;
                        port@0 {
                            reg = <0>;
                            label = "lan1";
                        };
                        port@1 {
                            reg = <1>;
                            label = "lan2";
                        };
                        port@2 {
                            reg = <2>;
                            label = "lan3";
                        };
                        port@3 {
                            reg = <3>;
                            label = "lan4";
                        };
                        port@4 {
                            reg = <4>;
                            label = "lan5";
                        };
                        port@5 {
                            reg = <5>;
                            label = "cpu";
                            ethernet = <&eth0>;
                            fixed-link {
                                speed = <1000>;
                                full-duplex;
                            };
                        };
                    };
                };
               };
            };
        };
    };


> >  The CPU port should have
> >   stable name for all device related to this product.
> 
> name for who to use?  Userspace?  Or within the kernel?
> 
> Naming is done by userspace, as USB is NOT determinisitic in numbering /
> naming the devices attached to it, by design.  If you need to have a
> stable name, do so in userspace please, we have loads of tools that
> already do this there today.  Let's not reinvent the wheel.
> 
> > Using user space tools to name interfaces would double the maintenance
> > of similar information: DT - describing the HW + udev scripts describing
> > same HW again.
> 
> Not for the network name of the device, that belongs in userspace.
> 
> Do not be listing USB device ids in a DT file, that way lies madness.
> 
> thanks,
> 
> greg k-h
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
