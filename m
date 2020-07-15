Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483FA221518
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGOT11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:27:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37474 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgGOT11 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 15:27:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jvn3q-005HpK-JP; Wed, 15 Jul 2020 21:27:22 +0200
Date:   Wed, 15 Jul 2020 21:27:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH] net: phy: phy_remove_link_mode should not advertise new
 modes
Message-ID: <20200715192722.GD1256692@lunn.ch>
References: <20200714082540.GA31028@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714082540.GA31028@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 10:25:42AM +0200, Helmut Grohne wrote:
> When doing "ip link set dev ... up" for a ksz9477 backed link,
> ksz9477_phy_setup is called and it calls phy_remove_link_mode to remove
> 1000baseT HDX. During phy_remove_link_mode, phy_advertise_supported is
> called.
> 
> If one wants to advertise fewer modes than the supported ones, one
> usually reduces the advertised link modes before upping the link (e.g.
> by passing an appropriate .link file to udev).  However upping
> overrwrites the advertised link modes due to the call to
> phy_advertise_supported reverting to the supported link modes.
> 
> It seems unintentional to have phy_remove_link_mode enable advertising
> bits and it does not match its description in any way. Instead of
> calling phy_advertise_supported, we should simply clear the link mode to
> be removed from both supported and advertising.

We have two different reasons for removing link modes.

1) The PHY cannot support a link mode. E.g.

static int bcm84881_get_features(struct phy_device *phydev)
{
        int ret;

        ret = genphy_c45_pma_read_abilities(phydev);
        if (ret)
                return ret;

        /* Although the PHY sets bit 1.11.8, it does not support 10M modes */
        linkmode_clear_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
                           phydev->supported);
        linkmode_clear_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
                           phydev->supported);

        return 0;
}

This is done very early on, as part of probing the PHY. This is done
before supported is copied into advertised towards the end of the PHYs
probe.

2) The MAC does not support a link mode. It uses
phy_remove_link_mode() to remove a link mode. There are two different
times this can be done:

a) As part of open(), the PHY is connected to the MAC. Since the PHY
is not connected to the MAC until you open it, you cannot use ethtool
to change the advertised modes until you have opened it. Hence user
space cannot of removed anything and you don't need to worry about
this copy.

b) As part of the MAC drivers probe, the PHY is connected to the MAC.
In this case, ethtool can be used by userspace to remove link
modes. But the MAC driver should of already removed the modes it does
not support, directly after connecting the PHY to the MAC in its probe
function. So advertising and supported at the same already.

The key point here is ksz9477_phy_setup(), and how it breaks this
model. It is called from ksz_enable_port(). That is called via
dsa_port_enable() in dsa_slave_open(). But the PHY was connected to
the MAC during probe of the MAC. So we have a bad mix of a) and b),
which is leading to your problem. You need to fix the switch driver so
it cleanly does b), removes the link mode early on before the user has
chance to use ethtool.

       Andrew

