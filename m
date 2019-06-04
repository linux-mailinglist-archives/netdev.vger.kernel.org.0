Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9A23495C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfFDNuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:50:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54776 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727503AbfFDNuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 09:50:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SnirIPJjHpjqRgzAfrMLyWGPEmM8TanyWnI8Nkm/r18=; b=XytRgNnw6lOS3SaU+/fTEITCX9
        gmUQ14zhBBEv3SdMMlfOZN+sQK12Ke2s5jFmp2dWDEYL6UYdIvHy9sbfS0nQ/57KeJzdqC4dMAT5q
        YyHpKzwywWpUp9M5oNOY3rNVKNHOlCl1VzlT9sgU543Waewg1jmiU2xF6A3tX8p3dmpw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hY9pA-00055t-QT; Tue, 04 Jun 2019 15:50:00 +0200
Date:   Tue, 4 Jun 2019 15:50:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA with MV88E6321 and imx28
Message-ID: <20190604135000.GD16951@lunn.ch>
References: <8812014c-1105-5fb6-bc20-bad0f86d33ea@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8812014c-1105-5fb6-bc20-bad0f86d33ea@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 03:07:25PM +0200, Benjamin Beckmeyer wrote:
> Hi all,
> 
> I'm working on a custom board with a 88E6321 and an i.MX28. Port 5 is directly connected per RMII to the CPU. 
> The switch is running in CPU attached mode. On Port 2 and 6 we have 2 external Micrel KSZ9031 PHYs.
> Here is the snip of my device tree:
> 
> &mac0 {
> 	pinctrl-0 = <&mac0_pins_a &mac0_freigabe &mac0_lcd_d04>;
> 	phy-supply = <&reg_3p3v>;
> 	status = "okay";
> 
> 	fixed-link = <1 1 100 0 0>;

Hi Benjamin

That is the old format for a fixed-link. Please use the new one.

> 
> 	/* this is done to remove enet_out */
> 	clocks = <&clks 57>, <&clks 57>;
> 	clock-names = "ipg", "ahb";
> 
> 	/delete-property/ phy-reset-gpios;
> 	/delete-property/ phy-reset-duration;
> 	freigabe-gpios = <&gpio0 26 GPIO_ACTIVE_HIGH>;

German in device tree? 

> 	trigger-gpios = <&gpio1 3 GPIO_ACTIVE_HIGH>;
> 
> 	mdio {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
> 
> 		switch0: switch0@10 {
>                         compatible = "marvell,mv88e6085";
>                         reg = <0x10>;

So you have the switch strapped to use a single address?

> 			pinctrl-0 = <&lcd_d06_pins>;

lcd ?

> 			reset-gpios = <&gpio1 6 GPIO_ACTIVE_LOW>;
> 
>                         dsa,member = <0 0>;
> 
>                         ports {
>                                 #address-cells = <1>;
>                                 #size-cells = <0>;
> 
>                                 port@0 {
>                                         reg = <0x0>;
>                                         label = "Serdes0";
>                                         phy-handle = <&switch0phy0>;
>                                 };
> 
>                                 port@1 {
>                                         reg = <0x1>;
>                                         label = "Serdes1";
>                                         phy-handle = <&switch0phy1>;
>                                 };
> 
>                                 port@2 {
> 					reg = <0x2>;
>                                         label = "lan1";
>                                         phy-handle = <&switch0phy2>;
>                                 };
> 
>                                 port@3 {
>                                         reg = <0x3>;
>                                         label = "lan2";
>                                         phy-handle = <&switch0phy3>;
>                                 };
> 
>                                 port@4 {
>                                         reg = <0x4>;
>                                         label = "lan3";
>                                         phy-handle = <&switch0phy4>;
>                                 };
> 
>                                 port5 {
>                                         reg = <0x5>;
>                                         label = "cpu";
>                                         ethernet = <&mac0>;
>                                         phy-mode = "rmii";
>                                         fixed-link {
>                                                 speed = <100>;
>                                                 full-duplex;
>                                         };
>                                 };
> 
> 				port@6 {
>                                         reg = <0x6>;
>                                         label = "lan4";
>                                         phy-handle = <&switch0phy6>;
>                                 };
>                         };
> 
> 			mdio {
> 				#address-cells = <1>;
> 				#size-cells = <0>;
> 				switch0phy0: switch0phy0@0 {
> 					reg = <0xc>;
> 				};
> 				switch0phy1: switch0phy1@1 {
> 				        reg = <0xd>;
> 				};
> 				switch0phy2: switch0phy2@2 {
> 				        reg = <0x2>;
> 				};
> 				switch0phy3: switch0phy3@3 {
> 				        reg = <0x3>;
> 				};
> 				switch0phy4: switch0phy4@4 {
> 				        reg = <0x4>;
> 				};
> 				switch0phy6: switch0phy6@6 {
> 				        reg = <0x6>;
> 				};
> 			};
> 		};
>         };
> }; 
> 
> I'm sure it must be wrong. Does the mdio part in between the switch part is for the internal
> mdio bus? 

It is for the switch MDIO bus. For this generation of switch, it is
both internal and external. Later generations have two MDIO busses,
one internal and one external.

> >From the outside I can read and write the SMI Register 0x10-0x16. 
> 
> Here is a snip from the bootup
> 
> [    1.377362] at24 0-0051: 256 byte 24c02 EEPROM, writable, 32 bytes/write
> [    1.391046] libphy: Fixed MDIO Bus: probed
> [    1.396763] libphy: mdio_driver_register: mv88e6085
> [    1.407168] fec 800f0000.ethernet (unnamed net_device) (uninitialized): Invalid MAC address: 00:00:00:00:00:00
> [    1.417279] fec 800f0000.ethernet (unnamed net_device) (uninitialized): Using random MAC address: 86:50:72:5d:79:ad
> [    1.429918] libphy: fec_enet_mii_bus: probed
> [    1.434374] mdio_bus 800f0000.ethernet-1:10: mdio_device_register
> ---
> [   18.735835] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=-1)

You probably want to put some printk mv88e6xxx_detect(). Is it getting
called? What value does id have? When these switches are held in
reset, they don't respond on the bus at all, so you will get MDIO
reads of 0xffff.

      Andrew
