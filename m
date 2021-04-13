Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D3535DF3D
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345712AbhDMMp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:45:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48134 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244347AbhDMMpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 08:45:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWIPF-00GTTs-GY; Tue, 13 Apr 2021 14:44:37 +0200
Date:   Tue, 13 Apr 2021 14:44:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Jonathan McDowell <noodles@earth.li>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: Broken imx6 to QCA8334 connection since PHYLIB to PHYLINK
 conversion
Message-ID: <YHWSNaoNELqI3e4r@lunn.ch>
References: <b7f5842a-c7b7-6439-ae68-51e1690d2507@ysoft.com>
 <YHRVv/GwCmnRN14j@lunn.ch>
 <9fa83984-f385-4705-a50f-688928cc366f@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9fa83984-f385-4705-a50f-688928cc366f@ysoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 09:09:37AM +0200, Michal Vokáč wrote:
> On 12. 04. 21 16:14, Andrew Lunn wrote:
> > > [1] https://elixir.bootlin.com/linux/v5.12-rc7/source/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi#L101
> > 
> > &fec {
> > 	pinctrl-names = "default";
> > 	pinctrl-0 = <&pinctrl_enet>;
> > 	phy-mode = "rgmii-id";
> > 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
> > 	phy-reset-duration = <20>;
> > 	phy-supply = <&sw2_reg>;
> > 	phy-handle = <&ethphy0>;

 
> > The fec phy-handle = <&ethphy0>; is pointing to the PHY of switch port
> > 0. This seems wrong.
> 
> I do not understand. Why this seems wrong?

> The switch has four ports. Ports 2 and 3 have a PHY and are connected
> to the transformers/RJ45 connectors. Port 0 is MII/RMII/RGMII of
> the switch. Port 6 (not used) is a SerDes.
> 
> > Does the FEC have a PHY? Do you connect the FEC
> > and the SWITCH at the RGMII level? Or with two back to back PHYs?
> > 
> > If you are doing it RGMII level, the FEC also needs a fixed-link.
> 
> The FEC does not have PHY and is connected to the switch at RGMII level.
> Adding the fixed-link { speed = <1000>; full-duplex; }; subnode to FEC
> does not help.

If the FEC does not have a PHY, it should not have a
phy-handle. Instead, you need a fixed-link.

What is currently happening is that both the switch and the FEC are
trying to connect to the same PHY. Probably the switch does its
connection first and succeeds. When the FEC tries to connect, the PHY
is in use, so an error is returned.

By providing a fixed-link, instead of a phy-handle, a simulated PHY is
generated, which the FEC can connect to.

	  Andrew
