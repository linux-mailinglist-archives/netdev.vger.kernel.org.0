Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5724A227996
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 09:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgGUHi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 03:38:59 -0400
Received: from mail.intenta.de ([178.249.25.132]:36101 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgGUHi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 03:38:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=8CiWC98Y8EMpovvGd0JVLmDPYgJZOOTOJz1RuJIBbZQ=;
        b=UPTUx03jbulgumSiPVAelMr40+wPxX8fVHbXigVL9tlSTTERSbfCtgFSvGuXDjF99zEHarBXAcRluXLPpGkvvqFnlzbPA9pklLNneTVsh0Cw5KvIqJAKIXpPf0RGjROCrd+PAyvX1W6hbOPS8svrs38Sti4z/dtGoiYLdFybn/kaPvGP5JOz4hmWOehBXjtsPaA9JXHiPfJ05EVrTGRNDc04XUyHVik3mwhYZDikCBnq5cv4augSPCF6hN6bFyMy5AyIG/QuTfjarl4oxbJemNhZZBH1raGMkH99ZSFKwsUwuifN+GvHMC/5g53DxNY5Mg+r3N8DK7yOKA3r7YJLbw==;
Date:   Tue, 21 Jul 2020 09:38:53 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [PATCH v3] net: dsa: microchip: call phy_remove_link_mode during
 probe
Message-ID: <20200721073853.GA5495@laureti-dev>
References: <20200717131814.GA1336433@lunn.ch>
 <20200720090416.GA7307@laureti-dev>
 <20200720210449.GP1339445@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200720210449.GP1339445@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Your persistence on this matter is much appreciated.

On Mon, Jul 20, 2020 at 11:04:49PM +0200, Andrew Lunn wrote:
> > The dev->ports[i].phydev is not actually exposed beyond the driver. The
> > driver sets the phydev.speed in a few places and even reads it back in
> > one place. It also sets phydev.duplex, but never reads it back. It
> > queries phydev.link, which is statically 0 due to using devm_kzalloc.
> > 
> > I think the use of this ksz_port.phydev is very misleading, but I'm
> > unsure how to fix this. It is not clear to me whether all those updates
> > should be performed on the connected phydev instead or whether this is
> > just internal state tracking.
> 
> I took a quick look at the code.
> 
> For PHY addresses < dev->phy_port_cnt it passes all reads/writes
> through to the hardware. So the Linux MDIO/PHY subsystem will be able
> to fully drive these PHYs, and the ksz9477 internal phydev is
> unneeded.

I do not fully concur here yet. For instance, ksz8795_port_setup and
ksz9477_port_setup branch on the port being a CPU port and evaluate the
phydev.link for non-CPU ports. Given that phydev.link is never assigned,
the branch where dev->live_ports is assigned is dead. Following
live_ports through the code reveals that it is only ever written to, but
no logic ever depends on its value. I'm not yet sure whether all of that
should simply be removed with no replacement or whether it was meant to
be extended some time later.

> Where it gets interesting is addr >= dev->phy_port_cnt. Reads of the
> PHY registers return hard coded values, or the link speed from the
> local phydev. Writes to these registers are just ignored.

This makes somewhat sense to me. It may become clearer below.

> If you compare this to other DSA drivers/DSA switches, reads/write for
> addresses where there are no internal PHY get passed out to an
> external MDIO bus, where an external PHY can be connected. The Linux
> MDIO/PHY subsystem will discover these external PHYs and create phydev
> instance for them. If there is no external PHY, for example the MAC is
> connected to another MAC, no PHY will be detected, and fixed-link is
> used in its place.

These switches all have internal PHYs for addresses < phy_port_cnt.
Beyond this index, the MACs are located. Few devices have multiple MACs
and only one MAC can be connected to the CPU at a time, because the tail
tagging scheme can only be enabled on one MAC port at a time. The driver
requires tail tagging on CPU ports (although this is not required by the
hardware).

> Do these switches have an external MDIO bus?

One has a choice of how one wishes to communicate with these switches.
Depending on configuration straps, they can do SPI or I²C or MDIO,
though the register space on the MDIO bus is too limited to do anything
useful, so the driver does not support MDIO. You can reach all of the
internal PHYs through the chosen bus. If you connect an external PHY to
a MAC, the KSZ is not involved in a management connection such as MDIO.

> How are external PHYs usually managed?

I honestly don't know. I only deal with internal PHYs. The typical use
case for the MAC ports is to establish fixed-links to other MACs (such
as the CPU or other switches).

> At a minimum, the internal phydev can be replaced with just a speed,
> rather than a full phydev, which will reduce confusion. But it would
> be nice to go further and remove all the addr >= dev->phy_port_cnt
> handling. But we need to understand the implications of that.

addr >= dev->phy_port_cnt identifies a MAC. While the KSZ may have a
data connection to the other side, but it does not have a management
connection (e.g. MDIO). The driver presently assumes that all MAC
connections are fixed-links, which is the case when you connect it to
the CPU. A significant fraction of KSZ switches only have one MAC or
have multiple MACs of which you only use one in a particular product
(e.g. because one only support SGMII and othe other only supports
RGMII). So the common case here is that addr >= dev->phy_port_cnt
uniquely identifies the fixed-link CPU port.

This also means that very likely the addr >= dev->phy_port_cnt handling
is not going away.

It also kinda routes us back to another thread of mine. In the followup
to https://lore.kernel.org/netdev/20200714120827.GA7939@laureti-dev/,
you also identified the assumption that any MAC port is the CPU port of
this driver and asked me to build on it. It is unclear whether that
should be lifted. If it isn't, I think it is fairly safe to assume that
any MAC is connected using a fixed-link and that there is no need for
any external PHY management.

Helmut
