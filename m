Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE92025CCD8
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgICVxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:53:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726679AbgICVxf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 17:53:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDxAh-00D6wK-ED; Thu, 03 Sep 2020 23:53:31 +0200
Date:   Thu, 3 Sep 2020 23:53:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH] net: fec: Fix PHY init after phy_reset_after_clk_enable()
Message-ID: <20200903215331.GG3112546@lunn.ch>
References: <20200903202712.143878-1-marex@denx.de>
 <20200903210011.GD3112546@lunn.ch>
 <b6397b39-c897-6e0a-6bf7-b6b24908de1a@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6397b39-c897-6e0a-6bf7-b6b24908de1a@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 11:36:39PM +0200, Marek Vasut wrote:
> On 9/3/20 11:00 PM, Andrew Lunn wrote:
> > On Thu, Sep 03, 2020 at 10:27:12PM +0200, Marek Vasut wrote:
> >> The phy_reset_after_clk_enable() does a PHY reset, which means the PHY
> >> loses its register settings. The fec_enet_mii_probe() starts the PHY
> >> and does the necessary calls to configure the PHY via PHY framework,
> >> and loads the correct register settings into the PHY. Therefore,
> >> fec_enet_mii_probe() should be called only after the PHY has been
> >> reset, not before as it is now.
> > 
> > I think this patch is related to what Florian is currently doing with
> > PHY clocks.
> 
> Which is what ? Details please.

Have you used b4 before?

b4 am 20200903043947.3272453-1-f.fainelli@gmail.com

> > I think a better fix for the original problem is for the SMSC PHY
> > driver to control the clock itself. If it clk_prepare_enables() the
> > clock, it knows it will not be shut off again by the FEC run time
> > power management.
> 
> The FEC MAC is responsible for generating the clock, the PHY clock are
> not part of the clock framework as far as I can tell.

I'm not sure this is true. At least:

https://elixir.bootlin.com/linux/latest/source/arch/arm/boot/dts/imx6ul-kontron-n6x1x-s.dtsi#L123

and there are a few more examples:

imx6ul-14x14-evk.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
imx6ul-kontron-n6x1x-s.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
imx6ul-kontron-n6x1x-som-common.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
imx6ull-myir-mys-6ulx.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
imx6ul-phytec-phycore-som.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;

Maybe it is just IMX6?

      Andrew
