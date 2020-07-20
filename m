Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FA9227021
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 23:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgGTVEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 17:04:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgGTVEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 17:04:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxcxt-0064s4-VK; Mon, 20 Jul 2020 23:04:49 +0200
Date:   Mon, 20 Jul 2020 23:04:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [PATCH v3] net: dsa: microchip: call phy_remove_link_mode during
 probe
Message-ID: <20200720210449.GP1339445@lunn.ch>
References: <20200717131814.GA1336433@lunn.ch>
 <20200720090416.GA7307@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720090416.GA7307@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The dev->ports[i].phydev is not actually exposed beyond the driver. The
> driver sets the phydev.speed in a few places and even reads it back in
> one place. It also sets phydev.duplex, but never reads it back. It
> queries phydev.link, which is statically 0 due to using devm_kzalloc.
> 
> I think the use of this ksz_port.phydev is very misleading, but I'm
> unsure how to fix this. It is not clear to me whether all those updates
> should be performed on the connected phydev instead or whether this is
> just internal state tracking.

I took a quick look at the code.

For PHY addresses < dev->phy_port_cnt it passes all reads/writes
through to the hardware. So the Linux MDIO/PHY subsystem will be able
to fully drive these PHYs, and the ksz9477 internal phydev is
unneeded.

Where it gets interesting is addr >= dev->phy_port_cnt. Reads of the
PHY registers return hard coded values, or the link speed from the
local phydev. Writes to these registers are just ignored.

If you compare this to other DSA drivers/DSA switches, reads/write for
addresses where there are no internal PHY get passed out to an
external MDIO bus, where an external PHY can be connected. The Linux
MDIO/PHY subsystem will discover these external PHYs and create phydev
instance for them. If there is no external PHY, for example the MAC is
connected to another MAC, no PHY will be detected, and fixed-link is
used in its place.

Do these switches have an external MDIO bus?
How are external PHYs usually managed?

At a minimum, the internal phydev can be replaced with just a speed,
rather than a full phydev, which will reduce confusion. But it would
be nice to go further and remove all the addr >= dev->phy_port_cnt
handling. But we need to understand the implications of that.

	Andrew
