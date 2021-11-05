Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57ACE44643A
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhKENj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 09:39:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48430 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhKENj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 09:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=denP3kmSD6IXR8Bp1s7m9uM6u56hzDvbAqHxvI7j02Q=; b=12
        HqT2rdS+lE5Bso3joKwGtg8uf59mmk815YjYTlOvjsWwKwRoBttM7ZZ9ii+j3LHcI1wICHKGuI2np
        ebpEYydeu3CNx9KLRZwqf8micGdzVT7ZfJLiXaEPL3vNjC2A77D/V0fDU5tEvzbi9jacyP9KMlT1S
        FuVJ27SlFtHNV30=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mizP1-00Cg6c-F5; Fri, 05 Nov 2021 14:37:07 +0100
Date:   Fri, 5 Nov 2021 14:37:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YYUzgyS6pfQOmKRk@lunn.ch>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <YYK+EeCOu/BXBXDi@lunn.ch>
 <64626e48052c4fba9057369060bfbc84@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <64626e48052c4fba9057369060bfbc84@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +config NET_VENDOR_SUNPLUS
> > > +	tristate "Sunplus Dual 10M/100M Ethernet (with L2 switch) devices"
> > 
> > The "with L2 Switch" is causing lots of warning bells to ring for me.
> > 
> > I don't see any references to switchdev or DSA in this driver. How is the
> > switch managed? There have been a few examples in the past of similar two
> > port switches being first supported in Dual MAC mode. Later trying to
> > actually use the switch in the Linux was always ran into problems, and
> > basically needed a new driver. So i want to make sure you don't have this
> > problem.
> > 
> > In the Linux world, Ethernet switches default to having there
> > ports/interfaces separated. This effectively gives you your dual MAC mode by
> > default.  You then create a Linux bridge, and add the ports/interfaces to the
> > bridge. switchdev is used to offload the bridge, telling the hardware to
> > enable the L2 switch between the ports.
> > 
> > So you don't need the mode parameter in DT. switchdev tells you this.
> > Switchdev gives user space access to the address table etc.
> 
> The L2 switch of Ethernet of SP7021 is not used to forward packets 
> between two network interfaces.
> 
> Sunplus Dual Ethernet devices consists of one CPU port, two LAN 
> ports, and a L2 switch. L2 switch is a circuitry which receives packets 
> from CPU or LAN ports and then forwards them other ports. Rules of 
> forwarding packets are set by driver.
> 
> Ethernet driver of SP7021 of Sunplus supports 3 operation modes:
>   - Dual NIC mode
>   - An NIC with two LAN ports mode (daisy-chain mode)
>   - An NIC with two LAN ports mode 2
> 
> Dual NIC mode
> Ethernet driver creates two net-device interfaces (eg: eth0 and eth1). 
> Each has its dedicated LAN port. For example, LAN port 0 is for 
> net-device interface eth0. LAN port 1 is for net-device interface 
> eth1. Packets from LAN port 0 will be always forwarded to eth0 and 
> vice versa by L2 switch. Similarly, packets from LAN port 1 will be 
> always forwarded to eth1 and vice versa by L2 switch. Packets will 
> never be forwarded between two LAN ports, or between eth0 and 
> LAN port 1, or between eth1 and LAN port 0. The two network 
> devices work independently.
> 
> An NIC with two LAN ports mode (daisy-chain mode)
> Ethernet driver creates one net-device interface (eg: eth0), but the 
> net-device interface has two LAN ports. In this mode, a packet from 
> one LAN port will be either forwarded to net-device interface (eht0) 
> if its destination address matches MAC address of net-device 
> interface (eth0), or forwarded to other LAN port. A packet from 
> net-device interface (eth0) will be forwarded to a LAN port if its 
> destination address is learnt by L2 switch, or forwarded to both 
> LAN ports if its destination has not been learnt yet.
> 
> An NIC with two LAN ports mode 2
> This mode is similar to “An NIC with two LAN ports mode”. The 
> difference is that a packet from net-device interface (eth0) will be 
> always forwarded to both LAN ports. Learning function of L2 switch 
> is turned off in this mode. This means L2 switch will never learn the 
> source address of a packet. So, it always forward packets to both 
> LAN ports. This mode works like you have 2-port Ethernet hub.

So here you describe how the hardware can be used. Dual is two
interfaces. Daisy-chain is what you get by taking those two interfaces
and adding them to a bridge. The bridge then forwards frames between
the interfaces and the CPU as needed, based on learning. And your
third mode is the bridge always performs flooding.

A linux driver must follow the linux networking model. You cannot make
up your own model. In the linux world, you model the external
ports. The hardware always has two external ports, so you need to
always have two netdev interfaces. To bridge packets between those two
interfaces, you create a bridge and you add the interfaces to the
bridge. That is the model you need to follow. switchdev gives you the
API calls you need to implement this.

> > > +struct l2sw_common {
> > 
> > Please change your prefix. l2sw is a common prefix, there are other silicon
> > vendors using l2sw. I would suggest sp_l2sw or spl2sw.
> 
> Ok, I'll modify two struct names in next patch as shown below:
> l2sw_common --> sp_common
> l2sw_mac --> sp_mac
> 
> Should I also modify prefix of file name?

You need to modify the prefix everywhere you use it.  Function names,
variable names, all symbols. Search and replace throughout the whole
code.

> > > +			return -EINVAL;
> > > +		}
> > > +	}
> > > +
> > > +	switch (cmd) {
> > > +	case SIOCGMIIPHY:
> > > +		if (comm->dual_nic && (strcmp(ifr->ifr_ifrn.ifrn_name, "eth1") ==
> > > +0))
> > 
> > You cannot rely on the name, systemd has probably renamed it. If you have
> > using phylib correctly, net_dev->phydev is what you want.
> 
> Ok, I'll use name of the second net device to do compare, 
> instead of using fixed string "eth1", in next patch.

No. There are always two interfaces. You always have two netdev
structures. Each netdev structure has a phydev. So use netdev->phydev.

This is another advantage of the Linux model. In your daisy chain
mode, how do i control the two PHYs? How do i see one is up and one is
down? How do i configure one to 10Half and the other 100Full?

> > > +int phy_cfg(struct l2sw_mac *mac)
> > > +{
> > > +	// Bug workaround:
> > > +	// Flow-control of phy should be enabled. L2SW IP flow-control will refer
> > > +	// to the bit to decide to enable or disable flow-control.
> > > +	mdio_write(mac->comm->phy1_addr, 4,
> > mdio_read(mac->comm->phy1_addr, 4) | (1 << 10));
> > > +	mdio_write(mac->comm->phy2_addr, 4,
> > mdio_read(mac->comm->phy2_addr,
> > > +4) | (1 << 10));
> > 
> > This should be in the PHY driver. The MAC driver should never need to touch
> > PHY registers.
> 
> Sunplus Ethernet MAC integrates MDIO controller. 
> So Ethernet driver has MDIO- and PHY-related code. 
> To work-around a circuitry bug, we need to enable 
> bit 10 of register 4 of PHY.
> Where should we place the code?

The silicon is integrated, but it is still a collection of standard
blocks. Linux models those blocks independently. There is a subsystem
for the MAC, a subsystem for the MDIO bus master and a subsystem for
the PHY. You register a driver with each of these subsystems. PHY
drivers live in drivers/net/phy. Put a PHY driver in there, which
includes this workaround.

> > > +static void mii_linkchange(struct net_device *netdev) { }
> > 
> > Nothing to do? Seems very odd. Don't you need to tell the MAC it should do
> > 10Mbps or 100Mbps? What about pause?
> 
> No, hardware does it automatically.
> Sunplus MAC integrates MDIO controller.
> It reads PHY status and set MAC automatically.

The PHY is external? So you have no idea what PHY that is? It could be
a Marvell PHY, a microchip PHY, an Atheros PHY. Often PHYs have
pages. In order to read the temperature sensor you change the page,
read a register, and then hopefully change the page back again. If the
PHY supports Fibre as well as copper, it can put the fibre registers
in a second page. The PHY driver knows about this, it will flip the
pages as needed. The phylib core has a mutex, so that only one
operation happens at a time. So a page flip does not happen
unexpectedly.

Your MAC hardware does not take this mutex. It has no idea what page
is selected when it reads registers. Instead of getting the basic mode
register, it could get the LED control register...

The MAC should never directly access the PHY. Please disable this
hardware, and use the mii_linkchange callback to configure the MAC.

> > So the MAC does not support pause? I'm then confused about phy_cfg().
 
> Yes, MAC supports pause. MAC (hardware) takes care of pause 
> automatically.
> 
> Should I remove the two lines?

Yes.

And you need to configure the MAC based on the results of the
auto-neg.

	Andrew
