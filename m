Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B415425CC28
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgICVZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:25:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728436AbgICVZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 17:25:56 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDwjt-00D6jk-Ol; Thu, 03 Sep 2020 23:25:49 +0200
Date:   Thu, 3 Sep 2020 23:25:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, adam.rudzinski@arf.net.pl,
        m.felsch@pengutronix.de, hkallweit1@gmail.com,
        richard.leitner@skidata.com, zhengdejin5@gmail.com,
        devicetree@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        robh+dt@kernel.org
Subject: Re: [PATCH net-next 1/3] net: phy: Support enabling clocks prior to
 bus probe
Message-ID: <20200903212549.GE3112546@lunn.ch>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <20200903043947.3272453-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903043947.3272453-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 09:39:45PM -0700, Florian Fainelli wrote:
> Some Ethernet PHYs may require that their clock, which typically drives
> their logic to respond to reads on the MDIO bus be enabled before
> issusing a MDIO bus scan.
> 
> We have a chicken and egg problem though which is that we cannot enable
> a given Ethernet PHY's device clock until we have a phy_device instance
> create and called the driver's probe function. This will not happen
> unless we are successful in probing the PHY device, which requires its
> clock(s) to be turned on.
> 
> For DT based systems we can solve this by using of_clk_get() which
> operates on a device_node reference, and make sure that all clocks
> associaed with the node are enabled prior to doing any reads towards the
> device. In order to avoid drivers having to know the a priori reference
> count of the resources, we drop them back to 0 right before calling
> ->probe() which is then supposed to manage the resources normally.

Hi Florian

This seems asymmetric. The resources are enabled in
of_mdiobus_phy_device_register() but disabled in phy_probe().

What we are really interested in is having the clock ticking while
trying to read the ID registers. Could the enable/disable be placed
around the call to get_phy_id()?

       Andrew
