Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4BF3F9A6B
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 15:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245252AbhH0Npi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 09:45:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232312AbhH0Nph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 09:45:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=U4iw9bGfwsiLVriGmOSmQiVeY8AhY1Wlg6keAnSbylw=; b=2MIAxJFd2O7afg050RyBGVQMpJ
        l8Jj/0grtM4Wjh7TBzLXmtNY1mAAoeqEMdyjyMzsvZI36V2+FCutEf9iO9TbObDSXzC/vUQKIHzDX
        k0OKanA0JtQR+322DPhNY8A2HiHr8rd2lOyeeQyFJqEMRUzJ+BFFBpxlrSSpNoJmcOtA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJc9q-0047E0-1o; Fri, 27 Aug 2021 15:44:34 +0200
Date:   Fri, 27 Aug 2021 15:44:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YSjsQmx8l4MXNvP+@lunn.ch>
References: <20210826074526.825517-1-saravanak@google.com>
 <20210826074526.825517-2-saravanak@google.com>
 <YSeTdb6DbHbBYabN@lunn.ch>
 <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
 <YSf/Mps9E77/6kZX@lunn.ch>
 <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch>
 <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> fw_devlink=on/device links short circuits the probe() call of a
> consumer (in this case the PHY) and returns -EPROBE_DEFER if the
> supplier's (in this case switch) probe hasn't finished without an
> error. fw_devlink/device links effectively does the probe in graph
> topological order and there's a ton of good reasons to do it that way
> -- what's why fw_devlink=on was implemented.
> 
> In this specific case though, since the PHY depends on the parent
> device, if we fail the parent's probe realtek_smi_probe() because the
> PHYs failed to probe, we'll get into a catch-22/chicken-n-egg
> situation and the switch/PHYs will never probe.

So lets look at:

arch/arm/boot/dts/vf610-zii-dev-rev-b.dts

       mdio-mux {
                compatible = "mdio-mux-gpio";
                pinctrl-0 = <&pinctrl_mdio_mux>;
                pinctrl-names = "default";
                gpios = <&gpio0 8  GPIO_ACTIVE_HIGH
                         &gpio0 9  GPIO_ACTIVE_HIGH
                         &gpio0 24 GPIO_ACTIVE_HIGH
                         &gpio0 25 GPIO_ACTIVE_HIGH>;
                mdio-parent-bus = <&mdio1>;
                #address-cells = <1>;
                #size-cells = <0>;


We have an MDIO multiplexor


                mdio_mux_1: mdio@1 {
                        reg = <1>;
                        #address-cells = <1>;
                        #size-cells = <0>;

                        switch0: switch@0 {
                                compatible = "marvell,mv88e6085";
                                pinctrl-0 = <&pinctrl_gpio_switch0>;
                                pinctrl-names = "default";
                                reg = <0>;
                                dsa,member = <0 0>;
                                interrupt-parent = <&gpio0>;
                                interrupts = <27 IRQ_TYPE_LEVEL_LOW>;

On the first bus, we have a Ethernet switch.

                                interrupt-controller;
                                #interrupt-cells = <2>;
                                eeprom-length = <512>;

                                ports {
                                        #address-cells = <1>;
                                        #size-cells = <0>;

                                        port@0 {
                                                reg = <0>;
                                                label = "lan0";
                                                phy-handle = <&switch0phy0>;
                                        };

The first port of that switch has a pointer to a PHY.

                               mdio {
                                        #address-cells = <1>;
                                        #size-cells = <0>;

That Ethernet switch also has an MDIO bus,

                                        switch0phy0: switch0phy0@0 {
                                                reg = <0>;

On that bus is the PHY.

                                                interrupt-parent = <&switch0>;
                                                interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;

And that PHY has an interrupt. And that interrupt is provided by the switch.

Given your description, it sounds like this is also go to break.

vf610-zii-dev-rev-c.dts is the same pattern, and there are more
examples for mv88e6xxx.

It is a common pattern, e.g. the mips ar9331.dtsi follows it.

I've not yet looked at plain Ethernet drivers. This pattern could also
exist there. And i wonder about other complex structures, i2c bus
multiplexors, you can have interrupt controllers as i2c devices,
etc. So the general case could exist in other places.

I don't think we should be playing whack-a-mole by changing drivers as
we find they regress and break. We need a generic fix. I think the
solution is pretty clear. As you said the device depends on its
parent. DT is a tree, so it is easy to walk up the tree to detect this
relationship, and not fail the probe.

   Andrew
