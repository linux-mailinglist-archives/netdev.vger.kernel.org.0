Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BCA2224ED
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgGPOKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:10:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38790 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgGPOKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 10:10:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jw4ay-005S6b-TA; Thu, 16 Jul 2020 16:10:44 +0200
Date:   Thu, 16 Jul 2020 16:10:44 +0200
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
Subject: Re: [PATCH v2] net: dsa: microchip: call phy_remove_link_mode during
 probe
Message-ID: <20200716141044.GA1266257@lunn.ch>
References: <20200715192722.GD1256692@lunn.ch>
 <20200716125723.GA19500@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716125723.GA19500@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 02:57:24PM +0200, Helmut Grohne wrote:
> When doing "ip link set dev ... up" for a ksz9477 backed link,
> ksz9477_phy_setup is called and it calls phy_remove_link_mode to remove
> 1000baseT HDX. During phy_remove_link_mode, phy_advertise_supported is
> called. Doing so reverts any previous change to advertised link modes
> e.g. using a udevd .link file.
> 
> phy_remove_link_mode is not meant to be used while opening a link and
> should be called during phy probe when the link is not yet available to
> userspace.
> 
> Therefore move the phy_remove_link_mode calls into ksz9477_setup. This
> is called during dsa_switch_register and thus comes after
> ksz9477_switch_detect, which initializes dev->features.
> 
> Remove phy_setup from ksz_dev_ops as no users remain.
> 
> Link: https://lore.kernel.org/netdev/20200715192722.GD1256692@lunn.ch/
> Fixes: 42fc6a4c613019 ("net: dsa: microchip: prepare PHY for proper advertisement")
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
> ---
>  drivers/net/dsa/microchip/ksz9477.c    | 31 ++++++++++----------------
>  drivers/net/dsa/microchip/ksz_common.c |  2 --
>  drivers/net/dsa/microchip/ksz_common.h |  2 --
>  3 files changed, 12 insertions(+), 23 deletions(-)
> 
> changes since v1:
>  * Don't change phy_remove_link_mode. Instead, call it at the right
>    time. Thanks to Andrew Lunn for the detailed explanation.
> 
> Helmut

Hi Helmut

This change looks better.

However, i'm having trouble understanding how PHYs actually work in
this driver. 

We have:

struct ksz_port {
        u16 member;
        u16 vid_member;
        int stp_state;
        struct phy_device phydev;

with an instance of this structure per port of the switch.

And it is this phydev which you are manipulating.

> +	for (i = 0; i < dev->phy_port_cnt; ++i) {
> +		/* The MAC actually cannot run in 1000 half-duplex mode. */
> +		phy_remove_link_mode(&dev->ports[i].phydev,
> +				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> +
> +		/* PHY does not support gigabit. */
> +		if (!(dev->features & GBIT_SUPPORT))
> +			phy_remove_link_mode(&dev->ports[i].phydev,
> +					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
> +	}
> +
>  	return 0;

But how is this phydev associated with the netdev? I don't see how
phylink_connect_phy() is called using this phydev structure?

      Andrew
