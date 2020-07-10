Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFC221C0B1
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 01:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgGJXZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 19:25:21 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45877 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGJXZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 19:25:21 -0400
X-Originating-IP: 90.65.108.121
Received: from localhost (lfbn-lyo-1-1676-121.w90-65.abo.wanadoo.fr [90.65.108.121])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id A241060002;
        Fri, 10 Jul 2020 23:25:16 +0000 (UTC)
Date:   Sat, 11 Jul 2020 01:25:16 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Message-ID: <20200710232516.GE3759@piout.net>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <20200710223610.GC3759@piout.net>
 <20200710225453.GK1014141@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710225453.GK1014141@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/07/2020 00:54:53+0200, Andrew Lunn wrote:
> On Sat, Jul 11, 2020 at 12:36:10AM +0200, Alexandre Belloni wrote:
> > Hi Oleksij,
> > 
> > This patch breaks Ethernet on the sama5d3 Xplained and I have not been
> > able to unbreak it.
> 
> Hi Alexandre
> 
>                         macb0: ethernet@f0028000 {
>                                 phy-mode = "rgmii";
>                                 #address-cells = <1>;
>                                 #size-cells = <0>;
>                                 status = "okay";
> 
>                                 ethernet-phy@7 {
>                                         reg = <0x7>;
>                                 };
>                         };
> 
> So DT says it wants rgmii. How are the delays being added? Could the
> bootloader be configuring the PHY into rgmii-id mode, which is now
> getting cleared? Or by strapping of pins on the PHY?
> 
> Also, looking at macb_main.c is seen:
> 
>        if (!(bp->caps & MACB_CAPS_USRIO_DISABLED)) {
>                 val = 0;
>                 if (bp->phy_interface == PHY_INTERFACE_MODE_RGMII)
>                         val = GEM_BIT(RGMII);
>                 else if (bp->phy_interface == PHY_INTERFACE_MODE_RMII &&
>                          (bp->caps & MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII))
>                         val = MACB_BIT(RMII);
>                 else if (!(bp->caps & MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII))
>                         val = MACB_BIT(MII);
> 
>                 if (bp->caps & MACB_CAPS_USRIO_HAS_CLKEN)
>                         val |= MACB_BIT(CLKEN);
> 
>                 macb_or_gem_writel(bp, USRIO, val);
>         }
> 
> I don't know if this applies for your hardware, but if you tried
> fixing the PHY by setting phy-mode to "rgmii-id", it could be macb
> then did not set GEM_BIT(RGMII) and so broken even more?
> 

This is exactly what happens. I'll send patches. Thanks Andrew!

> Rather than bp->phy_interface == PHY_INTERFACE_MODE_RGMII,
> phy_interface_mode_is_rgmii() might work better.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
