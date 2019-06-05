Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D7A35DAC
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 15:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfFENUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 09:20:10 -0400
Received: from mx-relay02-hz1.antispameurope.com ([94.100.132.202]:40717 "EHLO
        mx-relay02-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727642AbfFENUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 09:20:10 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jun 2019 09:20:08 EDT
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay02-hz1.antispameurope.com;
 Wed, 05 Jun 2019 15:12:17 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Wed, 5 Jun
 2019 15:12:16 +0200
Subject: Re: DSA with MV88E6321 and imx28
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <8812014c-1105-5fb6-bc20-bad0f86d33ea@eks-engel.de>
 <20190604135000.GD16951@lunn.ch>
 <854a0d9c-17a2-c502-458d-4d02a2cd90bb@eks-engel.de>
 <20190605122404.GH16951@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <414bd616-9383-073d-b3f3-6b6138c8b163@eks-engel.de>
Date:   Wed, 5 Jun 2019 15:12:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190605122404.GH16951@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay02-hz1.antispameurope.com with 38CAD11C7563
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:.1659
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> I got the devicetree from somebody that is why German is in it. But
>> first I wanted to get it running before I tidy it up.  The switch is
>> strapped to single mode (so I can read SMI addresses 0x10-0x16 and
>> 0x1b-0x1e directly).
> Hi Benjamin
>
> You have miss-understood what reg means.
>
> There are three addressing modes used by the various switches,
> although most only support two.
>
> In multi-chip mode, it occupies one address, and there are two
> registers used to multiplex access to the underlying registers.  In
> this setup, you use reg=<X> to indicate the switch is using address X.
>
> In single mode, it occupies all addresses on the MDIO bus, but many
> are reserved. In this mode you use reg=<0>.
>
> A few chips support dual mode, where you can have two switches on one
> MDIO bus, one using 0x0-0xf, and the second using 0x10-0x1f. Here you
> use reg=<0> or reg=<16>.
>
> Try setting reg=<0> if you have it in single mode.
>
>     Andrew

Hi Andrew, 

thanks a lot. That was the hint I needed. Now the DSA ist recognized. 
But the external PHYs are not recognized and the Serdes Ports neither.

Here is my device tree

mdio { 
                #address-cells = <1>;
                #size-cells = <0>;

                switch0: switch0@0 {
                        compatible = "marvell,mv88e6085";
                        reg = <0x0>;
                        pinctrl-0 = <&lcd_d06_pins>;
                        reset-gpios = <&gpio1 6 GPIO_ACTIVE_LOW>;

                        dsa,member = <0 0>;

                        ports {
                                #address-cells = <1>;
                                #size-cells = <0>;

                                port@0 {
/* Changed reg to 0xc too, same error message */
                                        reg = <0x0>;
                                        label = "Serdes0";
                                        phy-handle = <&switch0phy0>;
                                };

                                port@1 {
/* Changed reg to 0xd too, same error message */
                                        reg = <0x1>;
                                        label = "Serdes1";
                                        phy-handle = <&switch0phy1>;
                                };
				
				port@2 {
                                        reg = <0x2>;
                                        label = "lan1";
                                        phy-handle = <&switch0phy2>;
                                };

                                port@3 {
                                        reg = <0x3>;
                                        label = "lan2";
                                        phy-handle = <&switch0phy3>;
                                };

                                port@4 {
                                        reg = <0x4>;
                                        label = "lan3";
                                        phy-handle = <&switch0phy4>;
                                };

                                port5 {
                                        reg = <0x5>;
                                        label = "cpu";
                                        ethernet = <&mac0>;
                                        phy-mode = "rmii";
                                        fixed-link {
                                                speed = <100>;
                                                full-duplex;
                                        };
				};

                                port@6 {
                                        reg = <0x6>;
                                        label = "lan4";
                                        phy-handle = <&switch0phy6>;
                                };
                        };

                        mdio {
                                #address-cells = <1>;
                                #size-cells = <0>;
                                switch0phy0: switch0phy0@0 {
/* Changed reg to 0 too, same error message */
					 reg = <0xc>;
                                };
                                switch0phy1: switch0phy1@1 {
/* Changed reg to 1 too, same error message */
                                        reg = <0xd>;
                                };
                                switch0phy3: switch0phy3@3 {
                                        reg = <0x3>;
                                };
                                switch0phy4: switch0phy4@4 {
                                        reg = <0x4>;
                                };
                        };

                        mdio1 {
				compatible = "marvell,mv88e6xxx-mdio-external";
                                #address-cells = <1>;
                                #size-cells = <0>;

                                switch0phy2: switch0phy2@2 {
                                        reg = <0x2>;
                                };
                                switch0phy6: switch0phy6@6 {
                                        reg = <0x6>;
                                };
                        };
                };
        };
				
and here the bootup.
--snip
mv88e6085 800f0000.ethernet-1:00: switch 0x310 detected: Marvell 88E6321, revision 2
[    1.737480] libphy: /ahb@80080000/ethernet@800f0000/mdio/switch0@10: probed
[    1.754443] DSA: switch 0 0 parsed
[    1.757915] DSA: tree 0 parsed
[    1.825228] random: fast init done
[    1.847046] mv88e6085 800f0000.ethernet-1:00 Serdes0 (uninitialized): no phy at 0
[    1.854597] mv88e6085 800f0000.ethernet-1:00 Serdes0 (uninitialized): failed to connect to port 0: -19
[    1.863968] fec 800f0000.ethernet eth0: error -19 setting up slave phy
[    1.870591] mv88e6085 800f0000.ethernet-1:00: Failed to create slave 0: -19
[    1.877821] mv88e6085 800f0000.ethernet-1:00 Serdes1 (uninitialized): no phy at 1
[    1.885365] mv88e6085 800f0000.ethernet-1:00 Serdes1 (uninitialized): failed to connect to port 1: -19
[    1.894736] fec 800f0000.ethernet eth0: error -19 setting up slave phy
[    1.901359] mv88e6085 800f0000.ethernet-1:00: Failed to create slave 1: -19
[    1.908568] mv88e6085 800f0000.ethernet-1:00 lan1 (uninitialized): no phy at 2
[    1.915849] mv88e6085 800f0000.ethernet-1:00 lan1 (uninitialized): failed to connect to phy2: -19
[    1.925106] fec 800f0000.ethernet eth0: error -19 setting up slave phy
[    1.931721] mv88e6085 800f0000.ethernet-1:00: Failed to create slave 2: -19
[    1.943446] Generic PHY !ahb@80080000!ethernet@800f0000!mdio!switch0@10:03: attached PHY driver [Generic PHY] (mii_bus:phy_addr=!ahb@80080000!ethernet@800f0000!mdio!switch0@10:03, irq=-1)
[    1.973026] Generic PHY !ahb@80080000!ethernet@800f0000!mdio!switch0@10:04: attached PHY driver [Generic PHY] (mii_bus:phy_addr=!ahb@80080000!ethernet@800f0000!mdio!switch0@10:04, irq=-1)
[    1.993580] mv88e6085 800f0000.ethernet-1:00 lan4 (uninitialized): no phy at 6
[    2.000896] mv88e6085 800f0000.ethernet-1:00 lan4 (uninitialized): failed to connect to phy6: -19
[    2.009848] fec 800f0000.ethernet eth0: error -19 setting up slave phy
[    2.016475] mv88e6085 800f0000.ethernet-1:00: Failed to create slave 6: -19
--snip

Same error occurs when I put PHY 2 and 6 into the mdio part above 
(the PHYs are working properly in forwarding mode without DSA).

But I can read the internal PHY Identifier register (0x2 and 0x3)
over indirect mode per mdio. But I can't read the registers of the external PHYs.

Thanks in advance.
Benjamin 

