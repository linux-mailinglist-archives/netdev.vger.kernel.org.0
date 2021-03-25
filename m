Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937D0349254
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhCYMpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:45:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46864 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230140AbhCYMpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 08:45:07 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPPMH-00Cx2y-Pn; Thu, 25 Mar 2021 13:45:05 +0100
Date:   Thu, 25 Mar 2021 13:45:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: FEC unbind/bind feature
Message-ID: <YFyF0dEgjN562aT8@lunn.ch>
References: <DB8PR04MB6795E5896375A9A9FED55A84E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795E5896375A9A9FED55A84E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 08:04:58AM +0000, Joakim Zhang wrote:
> 
> Hi Andrew, Florian, Heiner
> 
> You are all Ethernet MDIO bus and PHY experts, I have some questions may need your help, thanks a lot in advance.
> 
> For many board designs, if it has dual MAC instances, they always share one MDIO bus to save PINs. Such as, i.MX6UL EVK board:

Please wrap your lines at around 75 characters. Standard netiquette
rules for emails apply to all Linux lists.

> 
> &fec1 {
> 	pinctrl-names = "default";
> 	pinctrl-0 = <&pinctrl_enet1>;
> 	phy-mode = "rmii";
> 	phy-handle = <&ethphy0>;
> 	phy-supply = <&reg_peri_3v3>;
> 	status = "okay";
> };
> 
> &fec2 {
> 	pinctrl-names = "default";
> 	pinctrl-0 = <&pinctrl_enet2>;
> 	phy-mode = "rmii";
> 	phy-handle = <&ethphy1>;
> 	phy-supply = <&reg_peri_3v3>;
> 	status = "okay";
> 
> 	mdio {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		ethphy0: ethernet-phy@2 {
> 			compatible = "ethernet-phy-id0022.1560";
> 			reg = <2>;
> 			micrel,led-mode = <1>;
> 			clocks = <&clks IMX6UL_CLK_ENET_REF>;
> 			clock-names = "rmii-ref";
> 
> 		};
> 
> 		ethphy1: ethernet-phy@1 {
> 			compatible = "ethernet-phy-id0022.1560";
> 			reg = <1>;
> 			micrel,led-mode = <1>;
> 			clocks = <&clks IMX6UL_CLK_ENET2_REF>;
> 			clock-names = "rmii-ref";
> 		};
> 	};
> };
> 
> For FEC driver now, there is a patch from Fabio to prevent unbind/bind feature since dual FEC controllers share one MDIO bus. (https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/net/ethernet/freescale/fec_main.c?h=next-20210324&id=272bb0e9e8cdc76e04baeefa0cd43019daa0841b)
> If we unbind fec2 and then fec1 can't work since MDIO bus is controlled by FEC1, FEC2 can't use it independently.
> 
> My question is that if we want to implement unbind/bind feature, what need we do?

One option is you unbind FEC1 first, and then FEC2.

> It seems to abstract an independent MDIO bus for dual FEC
> instances. I look at the MDIO dt bindings, it seems support such
> case as it has "reg"
> property. (Documentation/devicetree/bindings/net/mdio.yaml)

You can have fully standalone MDIO bus drivers. You generally do this
when the MDIO bus registers are in their own address space, which you
can ioremap() separately from the MAC registers. Take a look in
drivers/net/mdio/.

> From your opinions, do you think it is necessary to improve it?

What is you use case for unbinding/binding the FEC?

     Andrew
