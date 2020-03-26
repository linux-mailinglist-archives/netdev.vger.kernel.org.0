Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E36F193B77
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgCZJFo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Mar 2020 05:05:44 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58687 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgCZJFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:05:44 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jHOSL-0006fk-4z; Thu, 26 Mar 2020 10:05:41 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jHOSH-0002UK-45; Thu, 26 Mar 2020 10:05:37 +0100
Date:   Thu, 26 Mar 2020 10:05:37 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, mkl@pengutronix.de,
        David Miller <davem@davemloft.net>, kernel@pengutronix.de,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Jander <david@protonic.nl>
Subject: Re: RFC: future of ethtool tunables (Re: [RFC][PATCH 1/2] ethtool:
 Add BroadRReach Master/Slave PHY tunable)
Message-ID: <20200326090537.GA23804@pengutronix.de>
References: <20200325101736.2100-1-marex@denx.de>
 <20200325164958.GZ31519@unicorn.suse.cz>
 <20200325215538.GB27427@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200325215538.GB27427@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:42:04 up 196 days, 21:30, 450 users,  load average: 0.55, 0.47,
 0.44
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 10:55:38PM +0100, Andrew Lunn wrote:
> > What might be useful, on the other hand, would be device specific
> > tunables: an interface allowing device drivers to define a list of
> > tunables and their types for each device. It would be a generalization
> > of private flags. There is, of course, the risk that we could end up
> > with multiple NIC vendors defining the same parameters, each under
> > a different name and with slightly different semantics.
>  
> Hi Michal
> 
> I'm not too happy to let PHY drivers do whatever they want. So far,
> all PHY tunables have been generic. Any T1 PHY can implement control
> of master/slave, and there is no reason for each PHY to do it
> different to any other PHY. Downshift is a generic concept, multiple
> PHYs have implemented it, and they all implement it the same. Only
> Marvell currently supports fast link down, but the API is generic
> enough that other PHYs could implement it, if the hardware supports
> it.
> 
> I don't however mind if it gets a different name, or a different tool,
> etc.
> 
> I will let others comment on NICs. They are a different beast.

IMO, this is not a T1 specific feature. Since T1 lacks the auto
negotiation functionality, we are forced to use Master/Slave
configuration in one or other way. But even (non T1) PHYs with autoneg
available, implement this feature.

We may need to be able to force master or slave mode, at least as
workaround for existing errata. Here is one example:

-------------------------------------------------------------------------------
http://ww1.microchip.com/downloads/en/DeviceDoc/80000692D.pdf
Module 2: Duty cycle variation for optional 125MHz reference output clock

DESCRIPTION

When the device links in the 1000BASE-T slave mode only, the optional
125MHz reference output clock (CLK125_NDO, Pin 41) has wide duty cycle
variation.

END USER IMPLICATIONS

The optional CLK125_NDO clock does not meet the RGMII 45/55 percent
(min/max) duty cycle requirement and there- fore cannot be used directly
by the MAC side for clocking applications that have setup/hold time
requirements on rising and falling clock edges (e.g., to clock out RGMII
transmit data from MAC to PHY (KSZ9031RNX device)).

Work around
[...]
Another solution requires the device to always operate in master mode
(Register 9h, Bits [12:11] = '11') whenever there is 1000BASE-T link-up,
which is workable only in those applications where the link partner is
known and can always be configured to slave mode for 1000BASE-T.
-------------------------------------------------------------------------------

In this example we see, that even on non T1 PHYs we sometimes want to
force Master or Slave mode. At least for testing or workaround.

The BASE-T1 related example is described in 802.3-2018:
-------------------------------------------------------------------------------
45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)

Bit 1.2100.14 is used to select MASTER or SLAVE operation when
Auto-Negotiation enable bit 7.512.12 is set to zero, or if
Auto-Negotiation is not implemented. If bit 1.2100.14 is set to one the
PHY shall operate as MASTER. If bit 1.2100.14 is set to zero the PHY
shall operate as SLAVE.  This bit shall be ignored when the
Auto-Negotiation enable bit 7.512.12 is set to one.
-------------------------------------------------------------------------------

This example shows, that forcing Master or Slave modes is documented
part of 802.3-2018 specification.

IMO, this feature fits to the already existing LINKMODES_SET interface,
as forcing of Master/Slave Mode only makes sense of autoneg is not
implemented or disabled.

LINKMODES_SET/GET:

Request contents:
  ====================================  ======  ==========================
  ``ETHTOOL_A_LINKMODES_HEADER``        nested  request header
  ``ETHTOOL_A_LINKMODES_AUTONEG``       u8      autonegotiation status
  ``ETHTOOL_A_LINKMODES_OURS``          bitset  advertised link modes
  ``ETHTOOL_A_LINKMODES_PEER``          bitset  partner link modes
  ``ETHTOOL_A_LINKMODES_SPEED``         u32     link speed (Mb/s)
  ``ETHTOOL_A_LINKMODES_DUPLEX``        u8      duplex mode
  ====================================  ======  ==========================


Regards,
Oleksij & Marc
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
