Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6AE35C870
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239287AbhDLOOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:14:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45534 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237579AbhDLOOs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:14:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVxKZ-00GH5W-Gh; Mon, 12 Apr 2021 16:14:23 +0200
Date:   Mon, 12 Apr 2021 16:14:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Jonathan McDowell <noodles@earth.li>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: Broken imx6 to QCA8334 connection since PHYLIB to PHYLINK
 conversion
Message-ID: <YHRVv/GwCmnRN14j@lunn.ch>
References: <b7f5842a-c7b7-6439-ae68-51e1690d2507@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7f5842a-c7b7-6439-ae68-51e1690d2507@ysoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [1] https://elixir.bootlin.com/linux/v5.12-rc7/source/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi#L101


&fec {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_enet>;
	phy-mode = "rgmii-id";
	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
	phy-reset-duration = <20>;
	phy-supply = <&sw2_reg>;
	phy-handle = <&ethphy0>;
	status = "okay";

	mdio {
		#address-cells = <1>;
		#size-cells = <0>;

		phy_port2: phy@1 {
			reg = <1>;
		};

		phy_port3: phy@2 {
			reg = <2>;
		};

		switch@10 {
			compatible = "qca,qca8334";
			reg = <10>;

			switch_ports: ports {
				#address-cells = <1>;
				#size-cells = <0>;

				ethphy0: port@0 {
					reg = <0>;
					label = "cpu";
					phy-mode = "rgmii-id";
					ethernet = <&fec>;

					fixed-link {
						speed = <1000>;
						full-duplex;
					};
				};

The fec phy-handle = <&ethphy0>; is pointing to the PHY of switch port
0. This seems wrong. Does the FEC have a PHY? Do you connect the FEC
and the SWITCH at the RGMII level? Or with two back to back PHYs?

If you are doing it RGMII level, the FEC also needs a fixed-link.

    Andrew
