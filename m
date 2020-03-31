Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E14198EC7
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 10:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgCaIpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 04:45:02 -0400
Received: from protonic.xs4all.nl ([83.163.252.89]:57658 "EHLO protonic.nl"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbgCaIpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 04:45:02 -0400
Received: from erd988 (erd988.prtnl [192.168.224.30])
        by sparta.prtnl (Postfix) with ESMTP id 7038644A024D;
        Tue, 31 Mar 2020 10:45:00 +0200 (CEST)
Date:   Tue, 31 Mar 2020 10:44:59 +0200
From:   David Jander <david@protonic.nl>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, kernel@pengutronix.de,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Message-ID: <20200331104459.6857474e@erd988>
In-Reply-To: <20200330174114.GG25745@shell.armlinux.org.uk>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
        <20200329150854.GA31812@lunn.ch>
        <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
        <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
        <20200330174114.GG25745@shell.armlinux.org.uk>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Mar 2020 18:41:14 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Mon, Mar 30, 2020 at 10:33:03AM -0700, Florian Fainelli wrote:
> > 
> > 
> > On 3/29/2020 10:26 PM, Oleksij Rempel wrote:  
> > > Hi Andrew,
> > > 
> > > On Sun, Mar 29, 2020 at 05:08:54PM +0200, Andrew Lunn wrote:  
> > >> On Sun, Mar 29, 2020 at 01:04:57PM +0200, Oleksij Rempel wrote:
> > >>
> > >> Hi Oleksij
> > >>  
> > >>> +config DEPRECATED_PHY_FIXUPS
> > >>> +	bool "Enable deprecated PHY fixups"
> > >>> +	default y
> > >>> +	---help---
> > >>> +	  In the early days it was common practice to configure PHYs by adding a
> > >>> +	  phy_register_fixup*() in the machine code. This practice turned out to
> > >>> +	  be potentially dangerous, because:
> > >>> +	  - it affects all PHYs in the system
> > >>> +	  - these register changes are usually not preserved during PHY reset
> > >>> +	    or suspend/resume cycle.
> > >>> +	  - it complicates debugging, since these configuration changes were not
> > >>> +	    done by the actual PHY driver.
> > >>> +	  This option allows to disable all fixups which are identified as
> > >>> +	  potentially harmful and give the developers a chance to implement the
> > >>> +	  proper configuration via the device tree (e.g.: phy-mode) and/or the
> > >>> +	  related PHY drivers.  
> > >>
> > >> This appears to be an IMX only problem. Everybody else seems to of got
> > >> this right. There is no need to bother everybody with this new
> > >> option. Please put this in arch/arm/mach-mxs/Kconfig and have IMX in
> > >> the name.  
> > > 
> > > Actually, all fixups seems to do wring thing:
> > > arch/arm/mach-davinci/board-dm644x-evm.c:915:		phy_register_fixup_for_uid(LXT971_PHY_ID, LXT971_PHY_MASK,
> > > 
> > > Increased MII drive strength. Should be probably enabled by the PHY
> > > driver.
> > > 
> > > arch/arm/mach-imx/mach-imx6q.c:167:		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
> > > arch/arm/mach-imx/mach-imx6q.c:169:		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
> > > arch/arm/mach-imx/mach-imx6q.c:171:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
> > > arch/arm/mach-imx/mach-imx6q.c:173:		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,  
> 
> As far as I'm concerned, the AR8035 fixup is there with good reason.
> It's not just "random" but is required to make the AR8035 usable with
> the iMX6 SoCs.  Not because of a board level thing, but because it's
> required for the AR8035 to be usable with an iMX6 SoC.

I have checked with the datasheet of the AR8035, and AFAICS, what the code
does is this:

 - Disable the SmartEEE feature of the phy. The comment in the code implies
   that for some reason it doesn't work, but the reason itself is not given.
   Anyway, disabling SmartEEE should IMHO opinion be controlled by a DT
   setting. There is no reason to believe this problem is specific to the
   i.MX6. Besides, it is a feature of the phy, so it seems logical to expose
   that via the DT. Once that is done, it has no place here.

 - Set the external clock output to 125MHz. This is needed because the i.MX6
   needs a 125MHz reference clock input. But it is not a requirement to use
   this output. It is perfectly fine and possible to design a board that uses
   an external oscillator for this. It is also possible that an i.MX6 design
   has such a phy connected to a MAC behind a switch or some other interface.
   Independent of i.MX6 this setting can also be necessary for other hardware
   designs, based on different SoC's. In summary, this is a feature of the
   specific hardware design at hand, and has nothing to do with the i.MX6
   specifically. This should definitely be exposed through the DT and not be
   here.

 - Enable TXC delay. To clarify, the RGMII specification version 1 specified
   that the RXC and TXC traces should be routed long enough to introduce a
   certain delay to the clock signal, or the delay should be introduced via
   other means. In a later version of the spec, a provision was given for MAC
   or PHY devices to generate this delay internally. The i.MX6 MAC interface
   is unable to generate the required delay internally, so it has to be taken
   care of either by the board layout, or by the PHY device. This is the
   crucial point: The amount of delay set by the PHY delay register depends on
   the board layout. It should NEVER be hard-coded in SoC setup code. The
   correct way is to specify it in the DT. Needless to say that this too,
   isn't i.MX6-specific.

> So, having it registered by the iMX6 SoC code is entirely logical and
> correct.

I'm afraid I don't agree. See above. This code really should never have been
here. It is not i.MX6-specific as I pointed out above, nor is it necessarily
applicable to all i.MX6 boards that use those phy devices.

> That's likely true of the AR8031 situation as well.
> 
> I can't speak for any of the others.

Best regards,

-- 
David Jander
Protonic Holland.

