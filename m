Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE623361F41
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 14:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhDPMCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 08:02:10 -0400
Received: from polaris.svanheule.net ([84.16.241.116]:60122 "EHLO
        polaris.svanheule.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbhDPMCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 08:02:08 -0400
Received: from [192.168.1.109] (47.118-244-81.adsl-dyn.isp.belgacom.be [81.244.118.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sander@svanheule.net)
        by polaris.svanheule.net (Postfix) with ESMTPSA id 162F01F06E0;
        Fri, 16 Apr 2021 14:01:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svanheule.net;
        s=mail1707; t=1618574502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VJ7MVFlc6buS1xyU5lySPKOaiRufxeVsh/CWmY9V8Z8=;
        b=068y1HiGqrgYJmi1RlDPWVLQIGkVBldGHRNFkHzOZV6k48riVQjjKUzvBacisnDzqM+tlN
        cWQ92FXIrpEPje9k/630HNruFT6O+iDjX73+21dlaXwqdmQwH2seC2+9HgDrkxXlKpQ6tY
        sp7i1sUNwOiQhv+6YWKTGmE3Qm58ROzq1MNc/xBSh7865zIDt//SevCugIX+EIHPr6prB6
        BS9yz8KuSEIVDSpzU85GmIHNfWg5i6msz3vBQt+huIYtO7k/6r+UC/Z3UeeWYkIlEzG7Kg
        T7QjkCNPnnRZSwc5PU27Whcy3F00ZwHsdJ+MB0JgbsHvYQW7DU6cWP9SzMHPmw==
Message-ID: <f4c264d651dfc42bb5cef727ed1645f11fcd9ecb.camel@svanheule.net>
Subject: Re: [RFC PATCH 0/2] MIIM regmap and RTL8231 GPIO expander support
From:   Sander Vanheule <sander@svanheule.net>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>, bert@biot.com,
        Birger Koblitz <mail@birger-koblitz.de>
Date:   Fri, 16 Apr 2021 14:01:40 +0200
In-Reply-To: <YHC0vh/4O5Zm9+vO@lunn.ch>
References: <cover.1617914861.git.sander@svanheule.net>
         <YG+BObnBEOZnoJ1K@lunn.ch>
         <d73a44809c96abd0397474c63219a41e28f78235.camel@svanheule.net>
         <YHC0vh/4O5Zm9+vO@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,


On Fri, 2021-04-09 at 22:10 +0200, Andrew Lunn wrote:
> On Fri, Apr 09, 2021 at 07:42:32AM +0200, Sander Vanheule wrote:
> > Hi Andrew,
> > 
> > Thank you for the feedback. You can find a (leaked) datasheet at:
> > https://github.com/libc0607/Realtek_switch_hacking/blob/files/RTL8231_Datasheet_1.2.pdf
> 
> So this is not really an MFD. It has different ways of making use of
> pins, which could be used for GPIO, but can also be used for LEDs. You
> could look if it better fits in drivers/leds. But you can also use
> GPIO drivers for LEDs via led-gpio.

The chip provides LED scanning matrix functionality, for which one needs to set up row and column
pins. The chip supports 3×12 + 3×12 + 2×8 (88) LEDs; a lot more than it has pins available. There is
also (limited) support for hardware-accelerated blinking.

For example, single LED color scan matrix ("group A" for ports 0-11) would be wired up as follows:
   
    Row and column pins of scan matrix for LED0, LED1, LED2
    Columns control LED0/1/2 for ports [n] and [n+6]
          L0[n]    L1[n]    L2[n]    L0[n+6]  L1[n+6]  L2[n+6]
            |        |        |        |        |        |
    P0/P6 --X--------X--------X--------X--------X--------X (3)
            |        |        |        |        |        |
    P1/P7 --X--------X--------X--------X--------X--------X (4)
            |        |        |        |        |        |
    P2/P8 --X--------X--------X--------X--------X--------X (5)
            |        |        |        |        |        |
    P3/P9 --X--------X--------X--------X--------X--------X (6)
            |        |        |        |        |        |
   P4/P10 --X--------X--------X--------X--------X--------X (7)
            |        |        |        |        |        |
   P5/P11 --X--------X--------X--------X--------X--------X (8)
           (0)      (1)      (2)      (9)      (10)     (11)

So far, I haven't seen any actual hardware implementation that uses the scanning matrix
functionality (or the buzzer control feature with frequency selection).

1:1 use of GPIO pins for LEDs is indeed trivial with led-gpio, and I am currently using this on one
of my devices.

> > > I don't understand this split. Why not
> > > 
> > >      mdio-bus {
> > >          compatible = "vendor,mdio";
> > >          ...
> > >  
> > >          expander0: expander@0 {
> > >              /*
> > >               * Provide compatible for working registration of mdio
> > > device.
> > >               * Device probing happens in gpio1 node.
> > >               */
> > >              compatible = "realtek,rtl8231-expander";
> > >              reg = <0>;
> > >              gpio-controller;
> > >          };
> > >      };
> > > 
> > > You can list whatever properties you need in the node. Ethernet
> > > switches have interrupt-controller, embedded MDIO busses with PHYs on
> > > them etc.
> > 
> > This is what I tried initially, but it doesn't seem to work. The node
> > is probably still added as an MDIO device, but rtl8231_gpio_probe()
> > doesn't appear to get called at all. I do agree it would be preferable
> > over the split specification.
> 
> Look at drivers/net/dsa/mv88e6xxx/chip.c for how to register an mdio
> driver. If you still cannot get it to work, post your code and i will
> take a look.

Thanks for the suggestion. I've managed to create a cleaner mdio_device driver with a single
corresponding DT node.

Would the following make sense for a more complete DT description? Or would I need sub-nodes to
group e.g. the pin control or LED nodes/properties?

   expander@31 {
   	/* Either "realtek,rtl8231-mdio" or "realtek,rtl8231-smi" */
   	compatible = "realtek,rtl8231-mdio";
   	reg = <31>;
   
   	/* Must be <1> (8 bit) or <2> (16 bit); only for "realtek,rtl8231-smi" */
   	realtek,smi-regnum-width = <1>;
   
   	/** GPIO controller properties **/
   	gpio-controller;
   	#gpio-cells = <2>;
   	ngpios = <37>;
   
   	poe_enable {
   		gpio-hog;
   		gpios = <10 0>;
   		output-high;
   	};
   
   	/** Pin controller properties **/
   	/* Can only set a global drive strength, 4mA or 8mA */
   	realtek,gpio-drive-strength = <4>;
   
   	/* Global LED scan matrix setting, 0 (single-color) or 1 (bi-color) */
   	realtek,led-color-scan-mode = <0>;
   
   	pinctrl-names = "default";
   	pinctrl-0 = <&user_button>, <&port_leds>;
   
   	user_button : user_button_cfg {
   		pins = "gpio31";
   		function = "gpio";
   		/* Only GPIOs 31-35 can do hardware debouncing */
   		/* Debouncing is either disabled or 100ms */
   		input-debounce = <100000>;
   	};
   
   	port_leds : port_leds_cfg {
   		/* Select two columns (LED colors) for switch ports 0-7 */
   		pins = "gpio0", "gpio1", "gpio9", "gpio10",
   		       "gpio3", "gpio4", "gpio5", "gpio6";
   		function = "led";
   	};
   	
   	/** LED config **/
   	#address-cells = <2>;
   	#size-cells = <0>;
   
   	led@0.0 {
   		/* LED0 for port 0, corresponds to bits [2:0] in regnum 0x09 */
   		reg = <0 0>;
   		...
   	};
   	led@0.1 {
   		/* LED1 for port 0 */
   		reg = <0 1>;
   		...
   	};
   	/* LEDs 1.x, 2.x, 3.x, 6.x, 7.x, 8.x, 9.x omitted */
   };
   

As a final remark, I have found out that this chip doesn't actually talk I2C, but rather Realtek's
proprietary SMI. These two protocols are very similar w.r.t. to byte framing, but SMI requires the bus
master to write the register number byte(s) on both READ and WRITE frames. I2C/SMBUS does a WRITE for
the register number first, then a separate READ for the register value. This means I can't get
regmap_i2c to work.

There is an existing, bit-banged implementation of this SMI protocol (see "realtek,smi-mdio", realtek-
smi.c). If I could re-use this in some way, there would only need to be an MDIO implementation.
However, we have noticed that the larger phy address space (7-bit in SMI vs. 5-bit in MDIO) did require
a patch to make it work on ethernet switches with more than 32 ports (and corresponding phys) on a
single SMI bus.

Best,
Sander

