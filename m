Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7772A4998
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgKCP24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:28:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60876 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbgKCP10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 10:27:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZyDT-0052lC-CU; Tue, 03 Nov 2020 16:27:23 +0100
Date:   Tue, 3 Nov 2020 16:27:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Juerg Haefliger <juerg.haefliger@canonical.com>
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com
Subject: Re: lan78xx: /sys/class/net/eth0/carrier stuck at 1
Message-ID: <20201103152723.GK1109407@lunn.ch>
References: <20201021170053.4832d1ad@gollum>
 <20201021193548.GU139700@lunn.ch>
 <20201023082959.496d4596@gollum>
 <20201023130519.GB745568@lunn.ch>
 <20201103134712.6de0c2b5@gollum>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201103134712.6de0c2b5@gollum>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 01:47:12PM +0100, Juerg Haefliger wrote:
> On Fri, 23 Oct 2020 15:05:19 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Fri, Oct 23, 2020 at 08:29:59AM +0200, Juerg Haefliger wrote:
> > > On Wed, 21 Oct 2020 21:35:48 +0200
> > > Andrew Lunn <andrew@lunn.ch> wrote:
> > >   
> > > > On Wed, Oct 21, 2020 at 05:00:53PM +0200, Juerg Haefliger wrote:  
> > > > > Hi,
> > > > > 
> > > > > If the lan78xx driver is compiled into the kernel and the network cable is
> > > > > plugged in at boot, /sys/class/net/eth0/carrier is stuck at 1 and doesn't
> > > > > toggle if the cable is unplugged and replugged.
> > > > > 
> > > > > If the network cable is *not* plugged in at boot, all seems to work fine.
> > > > > I.e., post-boot cable plugs and unplugs toggle the carrier flag.
> > > > > 
> > > > > Also, everything seems to work fine if the driver is compiled as a module.
> > > > > 
> > > > > There's an older ticket for the raspi kernel [1] but I've just tested this
> > > > > with a 5.8 kernel on a Pi 3B+ and still see that behavior.    
> > > > 
> > > > Hi Jürg  
> > > 
> > > Hi Andrew,
> > > 
> > >   
> > > > Could you check if a different PHY driver is being used when it is
> > > > built and broken vs module or built in and working.
> > > > 
> > > > Look at /sys/class/net/eth0/phydev/driver  
> > > 
> > > There's no such file.  
> > 
> > I _think_ that means it is using genphy, the generic PHY driver, not a
> > specific vendor PHY driver? What does
> > 
> > /sys/class/net/eth0/phydev/phy_id contain.
> 
> There is no directory /sys/class/net/eth0/phydev.

[Goes and looks at the code]

The symbolic link is only created if the PHY is connected to the MAC
if the MAC has been registered with the core first. lan78xx does it
the other way around:

        ret = lan78xx_phy_init(dev);
        if (ret < 0)
                goto out4;

        ret = register_netdev(netdev);
        if (ret != 0) {
                netif_err(dev, probe, netdev, "couldn't register the device\n");
                goto out5;
        }

The register dump you show below indicates an ID of 007c132, which
fits the drivers drivers/net/phy/microchip.c : "Microchip
LAN88xx". Any mention of that in dmesg, do you see the module loaded?

> 
> > > Given that all works fine as long as the cable is unplugged at boot points
> > > more towards a race at boot or incorrect initialization sequence or something.  
> > 
> > Could be. Could you run
> > 
> > mii-tool -vv eth0
> 
> Hrm. Running that command unlocks the carrier flag and it starts toggling on
> cable unplug/plug. First invocation:
> 
> $ sudo mii-tool -vv eth0
> Using SIOCGMIIPHY=0x8947
> eth0: negotiated 1000baseT-FD flow-control, link ok
>   registers for MII PHY 1: 
>     1040 79ed 0007 c132 05e1 cde1 000f 0000
>     0000 0200 0800 0000 0000 0000 0000 3000
>     0000 0000 0088 0000 0000 0000 3200 0004
>     0040 a000 a000 0000 a035 0000 0000 0000
>   product info: vendor 00:01:f0, model 19 rev 2
>   basic mode:   autonegotiation enabled
>   basic status: autonegotiation complete, link ok
>   capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>   advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
>   link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
> 
> Subsequent invocation:
> 
> $ sudo mii-tool -vv eth0
> Using SIOCGMIIPHY=0x8947
> eth0: negotiated 1000baseT-FD flow-control, link ok
>   registers for MII PHY 1: 
>     1040 79ed 0007 c132 05e1 cde1 000d 0000
>     0000 0200 0800 0000 0000 0000 0000 3000
>     0000 0000 0088 0000 0000 0000 3200 0004
>     0040 a000 0000 0000 a035 0000 0000 0000
>   product info: vendor 00:01:f0, model 19 rev 2
>   basic mode:   autonegotiation enabled
>   basic status: autonegotiation complete, link ok
>   capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>   advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
>   link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
> 
> In the first invocation, register 0x1a shows a pending link-change interrupt
> (0xa000) which wasn't serviced (and cleared) for some reason. Dumping the
> registers cleared that interrupt bit and things start working correctly
> afterwards. Nor sure yet why that first interrupt is ignored.

So, 0x1a is the interrupt status, and 0x19 is the interrupt mask.

This should really be interpreted as a level interrupt. But it appears
the hardware the interrupt is connected to is actually doing edge. And
the edge has been missed, and so the interrupt is never serviced.

I think the call sequence goes something like this, if i'm reading the
code correct:

lan78xx_probe() calls lan78xx_bind:

    lan78xx_bind() registers an interrupt domain. This allows USB
    status messages indicating an interrupt to be dispatched using the
    normal interrupt mechanism, despite there not being a proper
    interrupt as such. The masking of interrupts seems to be part of
    INT_EP_CTL. This register is read during
    lan78xx_setup_irq_domain(), but it is not written to disable all
    interrupts. So it could be, PHY interrupts in the interrupt
    controller are already enabled at this point.

    lan78xx_bind() also registers an MDIO bus. This will cause the bus
    to be probed and the PHY should be found. 

lan78xx_probe() calls lan78xx_phy_init:

    lan78xx_phy_init gets the phydev, and fills in the interrupt
    number. It then connects the PHY to the MAC using
    phy_connect_direct(). phy_connect_direct() will request the
    interrupt from the kernel, meaning it can then service interrupts,
    and as part of that, it calls into the interrupt domain and
    enables interrupts in the interrupt controller.  It clears the
    interrupts in the PHY, which means the PHY interrupt status
    register is read, clearing it. It then enables interrupts in the
    PHY by again reading the status register to clear any pending
    interrupts and then sets the mask to enable interrupts.
    
So at this point, the PHY is ready to generate interrupts, the
interrupt controller in the USB device is ready to accept them. The
kernel itself is read for them, and they should be passed to the PHY
subsystem. What is not clear to me is if the USB endpoint is correctly
setup to report interrupts.

    Interestingly, the last thing lan78xx_phy_init() does is call
    genphy_config_aneg(). That configures the PHY to start an
    auto-neg. That is wrong, on a number of levels. The PHY drivers
    implementation, lan88xx_config_aneg() sets the mdix before
    starting autoneg. That gets skipped by directly calling
    genphy_config_aneg(). However, the interface is not even
    registered yet, let alone up. It has no business starting an
    auto-neg. But if the cable is connected and the peer is ready,
    about 1.5 seconds later, we expect auto-neg to complete and the
    interrupt to fire.

Sometime later, lan78xx_open() is called when the interface is
configured up. It calls phy_start() which is the correct way to get
the PHY going. That will call into the PHY driver to start auto-neg.
I've no idea what happens in this PHY when two auto-negs are going.

What lan78xx_open() also does is trigger a delayed work for
EVENT_LINK_RESET. lan78xx_link_reset() gets called as a result, and
that writes to the interrupt status register to clear it. Why clear
interrupts when we have just started auto-neg and we expect it to
cause an interrupt? The whole of lan78xx_link_reset() looks odd, and
some of it should be moved to lan78xx_link_status_change() which
phylib will call when the PHY changes status.

O.K. As a start, remove the genphy_config_aneg() from
lan78xx_phy_init(). I don't know if that is enough, but it is clearly
wrong.

    Andrew
