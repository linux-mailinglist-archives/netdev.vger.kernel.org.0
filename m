Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE68E21C02D
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 00:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgGJWzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 18:55:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58166 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgGJWzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 18:55:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ju1uv-004Xkc-AU; Sat, 11 Jul 2020 00:54:53 +0200
Date:   Sat, 11 Jul 2020 00:54:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
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
Message-ID: <20200710225453.GK1014141@lunn.ch>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <20200710223610.GC3759@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710223610.GC3759@piout.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 12:36:10AM +0200, Alexandre Belloni wrote:
> Hi Oleksij,
> 
> This patch breaks Ethernet on the sama5d3 Xplained and I have not been
> able to unbreak it.

Hi Alexandre

                        macb0: ethernet@f0028000 {
                                phy-mode = "rgmii";
                                #address-cells = <1>;
                                #size-cells = <0>;
                                status = "okay";

                                ethernet-phy@7 {
                                        reg = <0x7>;
                                };
                        };

So DT says it wants rgmii. How are the delays being added? Could the
bootloader be configuring the PHY into rgmii-id mode, which is now
getting cleared? Or by strapping of pins on the PHY?

Also, looking at macb_main.c is seen:

       if (!(bp->caps & MACB_CAPS_USRIO_DISABLED)) {
                val = 0;
                if (bp->phy_interface == PHY_INTERFACE_MODE_RGMII)
                        val = GEM_BIT(RGMII);
                else if (bp->phy_interface == PHY_INTERFACE_MODE_RMII &&
                         (bp->caps & MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII))
                        val = MACB_BIT(RMII);
                else if (!(bp->caps & MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII))
                        val = MACB_BIT(MII);

                if (bp->caps & MACB_CAPS_USRIO_HAS_CLKEN)
                        val |= MACB_BIT(CLKEN);

                macb_or_gem_writel(bp, USRIO, val);
        }

I don't know if this applies for your hardware, but if you tried
fixing the PHY by setting phy-mode to "rgmii-id", it could be macb
then did not set GEM_BIT(RGMII) and so broken even more?

Rather than bp->phy_interface == PHY_INTERFACE_MODE_RGMII,
phy_interface_mode_is_rgmii() might work better.

      Andrew
