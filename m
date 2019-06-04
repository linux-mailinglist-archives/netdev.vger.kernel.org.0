Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848983479D
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfFDNHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:07:32 -0400
Received: from mx-relay91-hz2.antispameurope.com ([94.100.136.191]:55374 "EHLO
        mx-relay91-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727093AbfFDNHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:07:32 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay91-hz2.antispameurope.com;
 Tue, 04 Jun 2019 15:07:28 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Tue, 4 Jun
 2019 15:07:25 +0200
To:     <netdev@vger.kernel.org>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Subject: DSA with MV88E6321 and imx28
Message-ID: <8812014c-1105-5fb6-bc20-bad0f86d33ea@eks-engel.de>
Date:   Tue, 4 Jun 2019 15:07:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay91-hz2.antispameurope.com with 7440510CCEAE
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:.2180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm working on a custom board with a 88E6321 and an i.MX28. Port 5 is directly connected per RMII to the CPU. 
The switch is running in CPU attached mode. On Port 2 and 6 we have 2 external Micrel KSZ9031 PHYs.
Here is the snip of my device tree:

&mac0 {
	pinctrl-0 = <&mac0_pins_a &mac0_freigabe &mac0_lcd_d04>;
	phy-supply = <&reg_3p3v>;
	status = "okay";

	fixed-link = <1 1 100 0 0>;

	/* this is done to remove enet_out */
	clocks = <&clks 57>, <&clks 57>;
	clock-names = "ipg", "ahb";

	/delete-property/ phy-reset-gpios;
	/delete-property/ phy-reset-duration;
	freigabe-gpios = <&gpio0 26 GPIO_ACTIVE_HIGH>;
	trigger-gpios = <&gpio1 3 GPIO_ACTIVE_HIGH>;

	mdio {
                #address-cells = <1>;
                #size-cells = <0>;

		switch0: switch0@10 {
                        compatible = "marvell,mv88e6085";
                        reg = <0x10>;
			pinctrl-0 = <&lcd_d06_pins>;
			reset-gpios = <&gpio1 6 GPIO_ACTIVE_LOW>;

                        dsa,member = <0 0>;

                        ports {
                                #address-cells = <1>;
                                #size-cells = <0>;

                                port@0 {
                                        reg = <0x0>;
                                        label = "Serdes0";
                                        phy-handle = <&switch0phy0>;
                                };

                                port@1 {
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
					reg = <0xc>;
				};
				switch0phy1: switch0phy1@1 {
				        reg = <0xd>;
				};
				switch0phy2: switch0phy2@2 {
				        reg = <0x2>;
				};
				switch0phy3: switch0phy3@3 {
				        reg = <0x3>;
				};
				switch0phy4: switch0phy4@4 {
				        reg = <0x4>;
				};
				switch0phy6: switch0phy6@6 {
				        reg = <0x6>;
				};
			};
		};
        };
}; 

I'm sure it must be wrong. Does the mdio part in between the switch part is for the internal
mdio bus? 
From the outside I can read and write the SMI Register 0x10-0x16. 

Here is a snip from the bootup

[    1.377362] at24 0-0051: 256 byte 24c02 EEPROM, writable, 32 bytes/write
[    1.391046] libphy: Fixed MDIO Bus: probed
[    1.396763] libphy: mdio_driver_register: mv88e6085
[    1.407168] fec 800f0000.ethernet (unnamed net_device) (uninitialized): Invalid MAC address: 00:00:00:00:00:00
[    1.417279] fec 800f0000.ethernet (unnamed net_device) (uninitialized): Using random MAC address: 86:50:72:5d:79:ad
[    1.429918] libphy: fec_enet_mii_bus: probed
[    1.434374] mdio_bus 800f0000.ethernet-1:10: mdio_device_register
---
[   18.735835] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=-1)

On the other board it was at least recognized but now I don't get anything about the switch.

Here I'm running 4.9.109. I've tested newer kernels but then the MDIO bus can not be accessed anymore.
I've tested 4.19.47 and 4.14.179. 

@Andrew Lunn I haven't forgotten to answer your the last mail. But this product has a higher
priority so I will come back later to the other custom board again.

Thanks in advance.

Cheers,
Benjamin Beckmeyer

