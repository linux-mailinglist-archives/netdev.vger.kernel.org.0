Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2E02AA90E
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 05:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgKHEO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 23:14:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41234 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgKHEO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 23:14:59 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kbc6J-005rwH-Hv; Sun, 08 Nov 2020 05:14:47 +0100
Date:   Sun, 8 Nov 2020 05:14:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Roelof Berg <rberg@berg-solutions.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lan743x: correctly handle chips with internal PHY
Message-ID: <20201108041447.GZ933237@lunn.ch>
References: <20201106134324.20656-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106134324.20656-1-TheSven73@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 08:43:24AM -0500, Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> Commit 6f197fb63850 ("lan743x: Added fixed link and RGMII support")
> assumes that chips with an internal PHY will never have a devicetree
> entry. This is incorrect: even for these chips, a devicetree entry
> can be useful e.g. to pass the mac address from bootloader to chip:
> 
>     &pcie {
>             status = "okay";
> 
>             host@0 {
>                     reg = <0 0 0 0 0>;
> 
>                     #address-cells = <3>;
>                     #size-cells = <2>;
> 
>                     lan7430: ethernet@0 {
>                             /* LAN7430 with internal PHY */
>                             compatible = "microchip,lan743x";
>                             status = "okay";
>                             reg = <0 0 0 0 0>;
>                             /* filled in by bootloader */
>                             local-mac-address = [00 00 00 00 00 00];
>                     };
>             };
>     };
> 
> If a devicetree entry is present, the driver will not attach the chip
> to its internal phy, and the chip will be non-operational.
> 
> Fix by tweaking the phy connection algorithm:
> - first try to connect to a phy specified in the devicetree
>   (could be 'real' phy, or just a 'fixed-link')
> - if that doesn't succeed, try to connect to an internal phy, even
>   if the chip has a devnode
> 
> Tested on a LAN7430 with internal PHY. I cannot test a device using
> fixed-link, as I do not have access to one.
> 
> Fixes: 6f197fb63850 ("lan743x: Added fixed link and RGMII support")
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> ---
> 
> v1 -> v2:
>     Andrew Lunn: keep patch minimal and correct, so keep open-coded version
>     of of_phy_get_and_connect().

Hi Sven

Why is it required to remove adapter->phy_mode? It is not clear to me
what this change has to do with not looking for an internal PHY.

> @@ -1063,6 +1065,7 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
>  
>  	phy_start(phydev);
>  	phy_start_aneg(phydev);
> +	phy_attached_info(phydev);

This also has nothing to do with the problem you are fixing. It is a
sensible thing to do, but it should be a separate patch, and target
net-next, since it is not a fix.

	  Andrew
