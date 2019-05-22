Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4CD725FAC
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 10:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfEVIkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 04:40:04 -0400
Received: from mx-relay56-hz2.antispameurope.com ([94.100.136.156]:42598 "EHLO
        mx-relay56-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727453AbfEVIkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 04:40:04 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 May 2019 04:40:04 EDT
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay56-hz2.antispameurope.com;
 Wed, 22 May 2019 10:33:50 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Wed, 22 May
 2019 10:33:29 +0200
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Subject: DSA setup IMX6ULL and Marvell 88E6390 with 2 Ethernet Phys - CPU Port
 is not working
To:     <netdev@vger.kernel.org>
Message-ID: <944bfcc1-b118-3b4a-9bd7-53e1ca85be0a@eks-engel.de>
Date:   Wed, 22 May 2019 10:33:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
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
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay56-hz2.antispameurope.com with 8B7525404C2
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:5.638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm currently working on a custom board with the imx6ull processor and the 6390 
switching chip. This is our hardware setup. 

------------     ---------         ---------    MAC     ------------
|   i.MX   | MAC |  PHY  |   PHY   |  PHY  |------------|  88E6390 |
|   6ULL   |-----|KSZ8081|---------|LAN8742|	MDIO	|P0        |
|          |     |ID 0x1 |         | ID0x0 |------------|          |
|          |     ---------         ---------            |          |
|          |	     |                                  |MULTI CHIP|
|          |	     |MDIO                              |ADDR MODE |
|          |	     |                                  |          |
|          |--------------------------------------------|   PHY ID |
|          |                    MDIO                    |     0x2  |
------------						------------

The switch is working properly so far, but I don't get any connection to linux.
Here is my device tree, I already did it with fixed-links, but from my 
understanding there can't be a fixed link because there are two dedicated phys.

---- snip
&fec1 {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_enet1 &pinctrl_gpios>;
	reset-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
	phy-supply = <&reg_3v3>;
	phy-mode = "rmii";
	phy-handle = <&fecphy1>;
	status = "okay";

	mdio0: mdio {
		#address-cells = <1>;
		#size-cells = <0>;

		fecphy1: fecphy@1 {
			reg = <0x1>;
		};
	};
};

&mdio0 {
	switch0: switch0@2 {
		compatible = "marvell,mv88e6190";
		reg = <2>;
		pinctrl-0 = <&pinctrl_gpios>;
		reset-gpios = <&gpio4 16 GPIO_ACTIVE_LOW>;

		dsa,member = <0 0>;

		ports {
			#address-cells = <1>;
			#size-cells = <0>;

			port@0 {
				reg = <0>;
				label = "cpu";
				ethernet = <&fec1>;
				phy-mode = "rmii";
				phy-handle = <&switch0phy0>;
			};

			port@1 {
				reg = <1>;
				label = "lan1";
				phy-handle = <&switch0phy1>;
			};

			port@2 {
				reg = <2>;
				label = "lan2";
				phy-handle = <&switch0phy2>;
			};

			port@3 {
				reg = <3>;
				label = "lan3";
				phy-handle = <&switch0phy3>;
			};

			port@4 {
				reg = <4>;
				label = "lan4";
				phy-handle = <&switch0phy4>;
			};

			port@5 {
				reg = <5>;
				label = "lan5";
				phy-handle = <&switch0phy5>;
			};

			port@6 {
				reg = <6>;
				label = "lan6";
				phy-handle = <&switch0phy6>;
			};

			port@7 {
				reg = <7>;
				label = "lan7";
				phy-handle = <&switch0phy7>;
			};

			port@8 {
				reg = <8>;
				label = "lan8";
				phy-handle = <&switch0phy8>;
			};
		};

		mdio {
			#address-cells = <1>;
			#size-cells = <0>;

			switch0phy1: switch0phy1@1 {
				reg = <0x1>;
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
			switch0phy5: switch0phy5@5 {
				reg = <0x5>;
			};
			switch0phy6: switch0phy6@6 {
				reg = <0x6>;
			};
			switch0phy7: switch0phy7@7 {
				reg = <0x7>;
			};
			switch0phy8: switch0phy8@8 {
				reg = <0x8>;
			};
		};

		mdio1 {
			compatible = "marvell,mv88e6xxx-mdio-external";
			#address-cells = <1>;
			#size-cells = <0>;

			switch0phy0: switch0phy0@0 {
				reg = <0x0>;
			};
		};
	};
};
---- snip

Do I miss something here? I know it is an odd layout, but we have a custom CPU 
capture with the KSZ PHY on it, so we thought it might work this way. 

The switch P0 is configured in PHY Mode because otherwise we don't have the 
RMII 50 MHz clock.

When we configure the devicetree without DSA, the switch is in forwarding mode.
When I ping the device from a directly connected PC, I see an ARP Request and 
the ARP Reply with tcpdump. We followed the signals back to the switch with an 
oscilloscope, so we assume that the connection is ok. 

But in boot up the following message is printed out:
[    1.551382] libphy: /soc/aips-bus@2100000/ethernet@2188000/mdio/switch0@2/mdio1: probed
[    1.562317] mdio_bus !soc!aips-bus@2100000!ethernet@2188000!mdio!switch0@2!mdio1: MDIO device at address 0 is missing.

So Linux or the DSA is not recognizing the LAN8742 PHY on PHY ID 0x0. Before 
we setup the P0 port to RMII PHY MODE (before it was set to RGMII, what is wrong)
it was recognized. But when I read the phy_id from /ssys/bus/mdio_bus it was 
only correct to the half. It should be 0x0007C131 but I got 0xffffC131 or 
sometimes 0x0007ffff.

When DSA is loaded our MII tool is not recognizing the switch on ID 2 (or at 
least with some odd values). The KSZ is recognized correctly with its Phy ID.
Does the DSA driver do something here?

I know it's a lot of information but maybe somebody can help me to get the DSA
working properly..

Thanks in advance.

Cheers,
Benjamin Beckmeyer

