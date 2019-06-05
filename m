Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F0035607
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 06:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbfFEEwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 00:52:22 -0400
Received: from mx-relay06-hz2.antispameurope.com ([83.246.65.92]:33347 "EHLO
        mx-relay06-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbfFEEwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 00:52:22 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay06-hz2.antispameurope.com;
 Wed, 05 Jun 2019 06:52:18 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Wed, 5 Jun
 2019 06:52:17 +0200
Subject: Re: DSA with MV88E6321 and imx28
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <8812014c-1105-5fb6-bc20-bad0f86d33ea@eks-engel.de>
 <20190604135000.GD16951@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <854a0d9c-17a2-c502-458d-4d02a2cd90bb@eks-engel.de>
Date:   Wed, 5 Jun 2019 06:52:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190604135000.GD16951@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay06-hz2.antispameurope.com with 754AA260C68
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:.1670
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Andrew,
thanks for you reply. 
I got the devicetree from somebody that is why German is in it. But first I wanted to get it running before I tidy it up.
The switch is strapped to single mode (so I can read SMI addresses 0x10-0x16 and 0x1b-0x1e directly). Do I have to
tell this the devicetree? I thought the driver will recognized that and I only give it the start SMI address of the switch?
I can read the internal PHYs with the indirectly read over the SMI COMMAND and SMI DATA registers.

The switch is not held in reset anymore, I take it out of reset in barebox manually every start, not a good solution but
for the moment to get it running it is okay.

The LCD port is just a GPIO. Like I said before, the devicetree is not completely from me. I've already started to write 
a new one but then the MDIO bus can't be accessed anymore.

I will put some printk's in that function and see what is happening. What I think is confusing me, the switch is working 
with internal addresses from 0-6 for the ports and you can read the port status registers at 0x10-0x16. And I'm not sure
which addresses should be in the switch mdio part.

Cheers,
Benjamin

> On Tue, Jun 04, 2019 at 03:07:25PM +0200, Benjamin Beckmeyer wrote:
>> Hi all,
>>
>> I'm working on a custom board with a 88E6321 and an i.MX28. Port 5 is directly connected per RMII to the CPU. 
>> The switch is running in CPU attached mode. On Port 2 and 6 we have 2 external Micrel KSZ9031 PHYs.
>> Here is the snip of my device tree:
>>
>> &mac0 {
>> 	pinctrl-0 = <&mac0_pins_a &mac0_freigabe &mac0_lcd_d04>;
>> 	phy-supply = <&reg_3p3v>;
>> 	status = "okay";
>>
>> 	fixed-link = <1 1 100 0 0>;
> Hi Benjamin
>
> That is the old format for a fixed-link. Please use the new one.
>
>> 	/* this is done to remove enet_out */
>> 	clocks = <&clks 57>, <&clks 57>;
>> 	clock-names = "ipg", "ahb";
>>
>> 	/delete-property/ phy-reset-gpios;
>> 	/delete-property/ phy-reset-duration;
>> 	freigabe-gpios = <&gpio0 26 GPIO_ACTIVE_HIGH>;
> German in device tree? 
>
>> 	trigger-gpios = <&gpio1 3 GPIO_ACTIVE_HIGH>;
>>
>> 	mdio {
>>                 #address-cells = <1>;
>>                 #size-cells = <0>;
>>
>> 		switch0: switch0@10 {
>>                         compatible = "marvell,mv88e6085";
>>                         reg = <0x10>;
> So you have the switch strapped to use a single address?
>
>> 			pinctrl-0 = <&lcd_d06_pins>;
> lcd ?
>
>> 			reset-gpios = <&gpio1 6 GPIO_ACTIVE_LOW>;
>>
>>                         dsa,member = <0 0>;
>>
>>                         ports {
>>                                 #address-cells = <1>;
>>                                 #size-cells = <0>;
>>
>>                                 port@0 {
>>                                         reg = <0x0>;
>>                                         label = "Serdes0";
>>                                         phy-handle = <&switch0phy0>;
>>                                 };
>>
>>                                 port@1 {
>>                                         reg = <0x1>;
>>                                         label = "Serdes1";
>>                                         phy-handle = <&switch0phy1>;
>>                                 };
>>
>>                                 port@2 {
>> 					reg = <0x2>;
>>                                         label = "lan1";
>>                                         phy-handle = <&switch0phy2>;
>>                                 };
>>
>>                                 port@3 {
>>                                         reg = <0x3>;
>>                                         label = "lan2";
>>                                         phy-handle = <&switch0phy3>;
>>                                 };
>>
>>                                 port@4 {
>>                                         reg = <0x4>;
>>                                         label = "lan3";
>>                                         phy-handle = <&switch0phy4>;
>>                                 };
>>
>>                                 port5 {
>>                                         reg = <0x5>;
>>                                         label = "cpu";
>>                                         ethernet = <&mac0>;
>>                                         phy-mode = "rmii";
>>                                         fixed-link {
>>                                                 speed = <100>;
>>                                                 full-duplex;
>>                                         };
>>                                 };
>>
>> 				port@6 {
>>                                         reg = <0x6>;
>>                                         label = "lan4";
>>                                         phy-handle = <&switch0phy6>;
>>                                 };
>>                         };
>>
>> 			mdio {
>> 				#address-cells = <1>;
>> 				#size-cells = <0>;
>> 				switch0phy0: switch0phy0@0 {
>> 					reg = <0xc>;
>> 				};
>> 				switch0phy1: switch0phy1@1 {
>> 				        reg = <0xd>;
>> 				};
>> 				switch0phy2: switch0phy2@2 {
>> 				        reg = <0x2>;
>> 				};
>> 				switch0phy3: switch0phy3@3 {
>> 				        reg = <0x3>;
>> 				};
>> 				switch0phy4: switch0phy4@4 {
>> 				        reg = <0x4>;
>> 				};
>> 				switch0phy6: switch0phy6@6 {
>> 				        reg = <0x6>;
>> 				};
>> 			};
>> 		};
>>         };
>> }; 
>>
>> I'm sure it must be wrong. Does the mdio part in between the switch part is for the internal
>> mdio bus? 
> It is for the switch MDIO bus. For this generation of switch, it is
> both internal and external. Later generations have two MDIO busses,
> one internal and one external.
>
>> >From the outside I can read and write the SMI Register 0x10-0x16. 
>>
>> Here is a snip from the bootup
>>
>> [    1.377362] at24 0-0051: 256 byte 24c02 EEPROM, writable, 32 bytes/write
>> [    1.391046] libphy: Fixed MDIO Bus: probed
>> [    1.396763] libphy: mdio_driver_register: mv88e6085
>> [    1.407168] fec 800f0000.ethernet (unnamed net_device) (uninitialized): Invalid MAC address: 00:00:00:00:00:00
>> [    1.417279] fec 800f0000.ethernet (unnamed net_device) (uninitialized): Using random MAC address: 86:50:72:5d:79:ad
>> [    1.429918] libphy: fec_enet_mii_bus: probed
>> [    1.434374] mdio_bus 800f0000.ethernet-1:10: mdio_device_register
>> ---
>> [   18.735835] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=-1)
> You probably want to put some printk mv88e6xxx_detect(). Is it getting
> called? What value does id have? When these switches are held in
> reset, they don't respond on the bus at all, so you will get MDIO
> reads of 0xffff.
>
>       Andrew
