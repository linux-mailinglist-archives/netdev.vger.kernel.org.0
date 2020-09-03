Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8855A25CD29
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgICWIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:08:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41664 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgICWIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 18:08:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDxPT-00D73z-Ga; Fri, 04 Sep 2020 00:08:47 +0200
Date:   Fri, 4 Sep 2020 00:08:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH] net: fec: Fix PHY init after phy_reset_after_clk_enable()
Message-ID: <20200903220847.GI3112546@lunn.ch>
References: <20200903202712.143878-1-marex@denx.de>
 <20200903210011.GD3112546@lunn.ch>
 <b6397b39-c897-6e0a-6bf7-b6b24908de1a@denx.de>
 <20200903215331.GG3112546@lunn.ch>
 <02ce2afb-7b9f-ba35-63a5-7496c7a39e6e@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02ce2afb-7b9f-ba35-63a5-7496c7a39e6e@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > b4 am 20200903043947.3272453-1-f.fainelli@gmail.com
> 
> That might be a fix for the long run, but I doubt there's any chance to
> backport it all to stable, is there ?

No. For stable we need something simpler.

> >>> I think a better fix for the original problem is for the SMSC PHY
> >>> driver to control the clock itself. If it clk_prepare_enables() the
> >>> clock, it knows it will not be shut off again by the FEC run time
> >>> power management.
> >>
> >> The FEC MAC is responsible for generating the clock, the PHY clock are
> >> not part of the clock framework as far as I can tell.
> > 
> > I'm not sure this is true. At least:
> > 
> > https://elixir.bootlin.com/linux/latest/source/arch/arm/boot/dts/imx6ul-kontron-n6x1x-s.dtsi#L123
> > 
> > and there are a few more examples:
> > 
> > imx6ul-14x14-evk.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
> > imx6ul-kontron-n6x1x-s.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
> > imx6ul-kontron-n6x1x-som-common.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
> > imx6ull-myir-mys-6ulx.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
> > imx6ul-phytec-phycore-som.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
> > 
> > Maybe it is just IMX6?
> 
> This is reference clock for the FEC inside the SoC, you probably want to
> control the clock going out of the SoC and into the PHY, which is
> different clock than the one described in the DT, right ?

I _think_ this is the external clock which is feed to the PHY. Why
else put it in the phy node in DT? And it has the name "rmii-ref"
which again suggests it is the RMII clock, not something internal to
the FEC.

To be sure, we would need to check the datasheet.

   Andrew
