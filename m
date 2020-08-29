Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA69A25688E
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 17:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgH2PP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 11:15:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59882 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbgH2PP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 11:15:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kC2a9-00CQWH-4g; Sat, 29 Aug 2020 17:15:53 +0200
Date:   Sat, 29 Aug 2020 17:15:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adam =?utf-8?Q?Rudzi=C5=84ski?= <adam.rudzinski@arf.net.pl>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, robh+dt@kernel.org,
        frowand.list@gmail.com
Subject: Re: drivers/of/of_mdio.c needs a small modification
Message-ID: <20200829151553.GB2912863@lunn.ch>
References: <c8b74845-b9e1-6d85-3947-56333b73d756@arf.net.pl>
 <20200828222846.GA2403519@lunn.ch>
 <dcfea76d-5340-76cf-7ad0-313af334a2fd@arf.net.pl>
 <20200828225353.GB2403519@lunn.ch>
 <6eb8c287-2d9f-2497-3581-e05a5553b88f@arf.net.pl>
 <891d7e82-f22a-d24b-df5b-44b34dc419b5@gmail.com>
 <113503c8-a871-1dc0-daea-48631e1a436d@arf.net.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <113503c8-a871-1dc0-daea-48631e1a436d@arf.net.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The driver would be able to add the new PHYs to the shared MDIO bus by
> calling of_mdiobus_register_children. Then the device tree looks like this,
> which is more reasonable in my opinion:
> 
> &fec2 {
> (...)
>     mdio {
>         (phy for fec2 here)
>     };
> (...)
> };
> 
> &fec1 {
> (...)
>     mdio {
>         (phy for fec1 here)
>     };
> (...)
> };

DT describes hardware, and the topology of the hardware. The hardware really is:

ethernet1@83fec000 {
	compatible = "fsl,imx51-fec", "fsl,imx27-fec";
	reg = <0x83fec000 0x4000>;
	interrupts = <87>;
	phy-mode = "mii";
	phy-reset-gpios = <&gpio2 14 GPIO_ACTIVE_LOW>; /* GPIO2_14 */
	local-mac-address = [00 04 9F 01 1B B9];
	phy-supply = <&reg_fec_supply>;
	phy-handle = <&ethphy1>;
	mdio {
	        clock-frequency = <5000000>;
		ethphy1: ethernet-phy@1 {
			compatible = "ethernet-phy-ieee802.3-c22";
			reg = <1>;
			max-speed = <100>;
		};
		ethphy2: ethernet-phy@2 {
			compatible = "ethernet-phy-ieee802.3-c22";
			reg = <2>;
			max-speed = <100>;
		};
	};
};

ethernet2@84fec000 {
	compatible = "fsl,imx51-fec", "fsl,imx27-fec";
	reg = <0x83fec000 0x4000>;
	interrupts = <87>;
	phy-mode = "mii";
	phy-reset-gpios = <&gpio2 15 GPIO_ACTIVE_LOW>; /* GPIO2_15 */
	local-mac-address = [00 04 9F 01 1B BA];
	phy-supply = <&reg_fec_supply>;
	phy-handle = <&ethphy2>;
};

What is missing from this is clocks. The IMX has a central clock
provider:

                        clks: clock-controller@20c4000 {
                                compatible = "fsl,imx6ul-ccm";
                                reg = <0x020c4000 0x4000>;
                                interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>,
                                             <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>;
                                #clock-cells = <1>;
                                clocks = <&ckil>, <&osc>, <&ipp_di0>, <&ipp_di1>;
                                clock-names = "ckil", "osc", "ipp_di0", "ipp_di1";
                        };

and it exports two clocks, MX6UL_CLK_ENET1_REF, MX6UL_CLK_ENET2_REF

So adding the clock properties:

ethernet1@83fec000 {
	compatible = "fsl,imx51-fec", "fsl,imx27-fec";
	reg = <0x83fec000 0x4000>;
	interrupts = <87>;
	phy-mode = "mii";
	phy-reset-gpios = <&gpio2 14 GPIO_ACTIVE_LOW>; /* GPIO2_14 */
	local-mac-address = [00 04 9F 01 1B B9];
	phy-supply = <&reg_fec_supply>;
	phy-handle = <&ethphy1>;
	mdio {
	        clock-frequency = <5000000>;
		ethphy1: ethernet-phy@1 {
			compatible = "ethernet-phy-ieee802.3-c22";
			reg = <1>;
			max-speed = <100>;
			clocks = <&clks MX6UL_CLK_ENET1_REF>;
		};
		ethphy2: ethernet-phy@2 {
			compatible = "ethernet-phy-ieee802.3-c22";
			reg = <2>;
			max-speed = <100>;
			clocks = <&clks MX6UL_CLK_ENET2_REF>;
		};
	};
};

ethernet2@84fec000 {
	compatible = "fsl,imx51-fec", "fsl,imx27-fec";
	reg = <0x83fec000 0x4000>;
	interrupts = <87>;
	phy-mode = "mii";
	phy-reset-gpios = <&gpio2 15 GPIO_ACTIVE_LOW>; /* GPIO2_15 */
	local-mac-address = [00 04 9F 01 1B BA];
	phy-supply = <&reg_fec_supply>;
	phy-handle = <&ethphy2>;
};

Also look at drivers/net/phy/micrel.c. It has code to look up a FEC
clock and use it. But that code assumes the PHY responds to MDIO reads
when the clock is not ticking. It sounds like your PHY does not?
Please double check that. If it does not, you need to add clock code
to the PHY core. Florians patchset will help with that.

	Andrew
