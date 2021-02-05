Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3892310BD3
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 14:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhBENca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 08:32:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50350 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230035AbhBEN2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:28:53 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l818f-004NO7-Fu; Fri, 05 Feb 2021 14:27:09 +0100
Date:   Fri, 5 Feb 2021 14:27:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan Varadharajan 
        <prasanna.vengateshan@microchip.com>
Cc:     olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/8] net: dsa: microchip: add DSA support for
 microchip lan937x
Message-ID: <YB1HrTfUvgXbcsTr@lunn.ch>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
 <20210128064112.372883-4-prasanna.vengateshan@microchip.com>
 <YBNf715MJ9OfaXfV@lunn.ch>
 <b565944e72a0af12dec0430bd819eb6b755d84b4.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b565944e72a0af12dec0430bd819eb6b755d84b4.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +bool lan937x_is_internal_tx_phy_port(struct ksz_device *dev, int
> > > port)
> > > +{
> > > +     /* Check if the port is internal tx phy port */
> > 
> > What is an internal TX phy port? Is it actually a conventional t2
> > Fast
> > Ethernet port, as opposed to a t1 port?
> This is 100 Base-Tx phy which is compliant with
> 802.3/802.3u standards. Two of the SKUs have both T1 and TX integrated
> Phys as mentioned in the patch intro mail.

I don't think we have a good name for a conventional fast Ethernet.
But since we call the other T1, since it has a single pair, maybe use
T2, since Fast Ethernet uses 2 pair. I would also suggest a comment
near this code explaining what T1 and T2 mean.

> > What PHY driver is actually used? The "Microchip LAN87xx T1" driver?

> Phy is basically a LAN87xx PHY. But the driver is customized for
> LAN937x.

Does it have its own ID in registers 2 and 3? Can you tell this
customised version from the regular?

> > > +static void tx_phy_port_init(struct ksz_device *dev, int port)
> > > +{
> > > +     u32 data;
> > > +
> > > +     /* Software reset. */
> > > +     lan937x_t1_tx_phy_mod_bits(dev, port, MII_BMCR, BMCR_RESET,
> > > true);
> > > +
> > > +     /* tx phy setup */
> > > +     tx_phy_setup(dev, port);
> > 
> > And which PHY driver is used here? "Microchip LAN88xx"? All this code
> > should be in the PHY driver.
> As of now, no driver is available in the kernel since its part of
> LAN937x.

Right, so you need to write such a driver, and put it into
drivers/net/phy.

> > > +             member = dev->host_mask | p->vid_member;
> > > +             mutex_lock(&dev->dev_mutex);
> > > +
> > > +             /* Port is a member of a bridge. */
> > > +             if (dev->br_member & (1 << port)) {
> > > +                     dev->member |= (1 << port);
> > > +                     member = dev->member;
> > > +             }
> > > +             mutex_unlock(&dev->dev_mutex);
> > > +             break;
> > > +     case BR_STATE_BLOCKING:
> > > +             data |= PORT_LEARN_DISABLE;
> > > +             if (port != dev->cpu_port &&
> > > +                 p->stp_state == BR_STATE_DISABLED)
> > > +                     member = dev->host_mask | p->vid_member;
> > > +             break;
> > > +     default:
> > > +             dev_err(ds->dev, "invalid STP state: %d\n", state);
> > > +             return;
> > > +     }
> > > +
> > > +     lan937x_pwrite8(dev, port, P_STP_CTRL, data);
> > > +
> > > +     p->stp_state = state;
> > > +     mutex_lock(&dev->dev_mutex);
> > > +
> > > +     /* Port membership may share register with STP state. */
> > > +     if (member >= 0 && member != p->member)
> > > +             lan937x_cfg_port_member(dev, port, (u8)member);
> > > +
> > > +     /* Check if forwarding needs to be updated. */
> > > +     if (state != BR_STATE_FORWARDING) {
> > > +             if (dev->br_member & (1 << port))
> > > +                     dev->member &= ~(1 << port);
> > > +     }
> > > +
> > > +     /* When topology has changed the function
> > > ksz_update_port_member
> > > +      * should be called to modify port forwarding behavior.
> > > +      */
> > > +     if (forward != dev->member)
> > > +             ksz_update_port_member(dev, port);
> > 
> > Please could you explain more what is going on with membership?
> > Generally, STP state is specific to the port, and nothing else
> > changes. So it is not clear what this membership is all about.
> It updates the membership for the forwarding behavior based on
> forwarding state of the port.

So membership is about forwarding packets between ports. Most other
chips handles this itself. But for this device, you need to handle
this in software. O.K.

You only want to forward when in STP state BR_STATE_FORWARDING. But
the code seems more complex than this.

    Andrew
