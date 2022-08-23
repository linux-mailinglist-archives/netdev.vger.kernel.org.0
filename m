Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E970A59E7FF
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244908AbiHWQr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245632AbiHWQpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:45:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6C9D074F;
        Tue, 23 Aug 2022 07:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oSSJjh3lqiw7ATgiat2qlcw21F100TaF8UUg9/PhsKM=; b=PLCMBUpUhdUUFIYhkO2W9sm7+e
        M+IV4bx/t0DfCBog+Z5tVzN4UfGPBhSt5ftrDZk0UJIaf7unNoeLc7cRSX8DQTIeL59Xyfy4jAmau
        SoJrmYAANwp6SKzxqpaYvTOawwtanYpM/Cth/5bwsDMSohHaXGrHNnWAqDEDPWOXg2Ms=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQUxu-00EMFN-Mx; Tue, 23 Aug 2022 16:33:14 +0200
Date:   Tue, 23 Aug 2022 16:33:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun.Ramadoss@microchip.com
Cc:     olteanv@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [RFC Patch net-next v2] net: dsa: microchip: lan937x: enable
 interrupt for internal phy link detection
Message-ID: <YwTlKnpgMRp2Nugm@lunn.ch>
References: <20220822092017.5671-1-arun.ramadoss@microchip.com>
 <YwOAxh7Bc12OornD@lunn.ch>
 <b1e66b49e8006bd7dcb3fd74d5185db807e5a9f6.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1e66b49e8006bd7dcb3fd74d5185db807e5a9f6.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I used the same gpio line number of switch as the interrupt for
> internal phy. And when phy link up/down happens, it triggers both the
> switch and phy interrupt routine.

Ah, shared interrupt. O.K.

> I have not used irq_domain before. Can you please brief on how phy
> interrupt handler is called from chip.c & global2.

There are two different ways this can all be glued together.

Using irq_domain, each interrupt source becomes a full interrupt in
Linux. You can see these individual interrupt sources in
/proc/interrupts. You can use request_threaded_irq() on it. The
mv88e6xxx driver is also an interrupt controller as well as an
Ethernet switch.

> The dts file I used for testing,
> spi1: spi@f8008000 {
> 	cs-gpios = <0>, <0>, <0>, <&pioC 28 0>;
> 	id = <1>;
> 	status = "okay";
> 	
> 	lan9370: lan9370@3 {
> 		compatible = "microchip,lan9370";
> 		reg = <3>;
> 		spi-max-frequency = <44000000>;
> 		interrupt-parent = <&pioB>;
> 		interrupts = <28 IRQ_TYPE_LEVEL_LOW>;
> 		interrupt-controller;
> 		status = "okay";
> 		ports {
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 			port@0 {
> 				reg = <0x0>;
> 				phy-handle = <&t1phy0>;
> 				phy-mode = "internal";
> 				label = "lan1";
> 			};
> 			port@1 {
> 				reg = <0x1>;
> 				phy-handle = <&t1phy1>;
> 				phy-mode = "internal";
> 				label = "lan2";
> 			};
> 		}
> 	}
> 
> 	mdio {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 		compatible = "microchip,lan937x-mdio";
> 		
> 		t1phy0: ethernet-phy@0{
> 			interrupt-parent = <&lan9370>;
> 			interrupts = <28 IRQ_TYPE_LEVEL_LOW>;

So here you would use the interrupt number within the domain. Ideally
you want port 0 to use interrupt 0.


> 			reg = <0x0>;
> 		};
> 		t1phy1: ethernet-phy@1{
> 			interrupt-parent = <&lan9370>;
> 			interrupts = <28 IRQ_TYPE_LEVEL_LOW>;

and here port 1 uses interrupt 1.

> 			reg = <0x1>;
> 		};
> 	}
> }
 
You can see this for an Marvell switch here:

https://elixir.bootlin.com/linux/latest/source/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts#L93

Doing it this way is however very verbose. I later discovered a short
cut:

https://elixir.bootlin.com/linux/latest/source/drivers/net/dsa/mv88e6xxx/global2.c#L1164

by setting mdiobus->irq[] to the interrupt number, phylib will
automatically use the correct interrupt without needing an DT.

	Andrew
