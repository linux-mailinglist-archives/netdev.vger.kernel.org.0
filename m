Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C5B3F8FED
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 23:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243584AbhHZUyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 16:54:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43772 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243561AbhHZUyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 16:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qC9/a8QwjDtxsvgwRxW0lzbEcViqsOvHK7tcWNdMLbQ=; b=zMzBLIqCfZ/pbHHDZG1oQ6Pt2v
        HrbBiDt6y4JivV0Gvj8EA/iOEiybhzEbk+LqeG7Es/mHBDe2MtxmetfUgQS0wWsnnBDgehyNvgyC9
        p34jvzvu2WpMJGjkvBG2OPZlfGvsW6AW8I/B7J9KdJKWvPXXWB+wf4UC6YV2pRFhu4Ps=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJMN0-0040b5-3d; Thu, 26 Aug 2021 22:53:06 +0200
Date:   Thu, 26 Aug 2021 22:53:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YSf/Mps9E77/6kZX@lunn.ch>
References: <20210826074526.825517-1-saravanak@google.com>
 <20210826074526.825517-2-saravanak@google.com>
 <YSeTdb6DbHbBYabN@lunn.ch>
 <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The  DT node in [2] is probed by realtek_smi_probe() [3]. The call flow is:
> realtek_smi_probe()
>   -> dsa_register_switch()
>     -> dsa_switch_probe()
>       -> dsa_tree_setup()
>         -> dsa_tree_setup_switches()
>           -> dsa_switch_setup()
>             -> ds->ops->setup(ds)
>               -> rtl8366rb_setup()
>                 -> realtek_smi_setup_mdio()
>                   -> of_mdiobus_register()
>                      This scans the MDIO bus/DT and device_add()s the PHYs
>           -> dsa_port_setup()
>             -> dsa_port_link_register_of()
>               -> dsa_port_phylink_register()
>                 -> phylink_of_phy_connect()
>                   -> phylink_fwnode_phy_connect()
>                     -> phy_attach_direct()
>                        This checks if PHY device has already probed (by
>                        checking for dev->driver). If not, it forces the
>                        probe of the PHY using one of the generic PHY
>                        drivers.
> 
> So within dsa_register_switch() the PHY device is added and then
> expected to have probed in the same thread/calling context. As stated
> earlier, this is not guaranteed by the driver core.

Have you looked at:

commit 16983507742cbcaa5592af530872a82e82fb9c51
Author: Heiner Kallweit <hkallweit1@gmail.com>
Date:   Fri Mar 27 01:00:22 2020 +0100

    net: phy: probe PHY drivers synchronously

See the full commit message, but the code change is:

iff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 3b8f6b0b47b5..d543df282365 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2577,6 +2577,7 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner)
        new_driver->mdiodrv.driver.probe = phy_probe;
        new_driver->mdiodrv.driver.remove = phy_remove;
        new_driver->mdiodrv.driver.owner = owner;
+       new_driver->mdiodrv.driver.probe_type = PROBE_FORCE_SYNCHRONOUS;
 
        retval = driver_register(&new_driver->mdiodrv.driver);
        if (retval) {

How does this add to the overall picture?

    Andrew
