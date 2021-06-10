Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243053A2CE8
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 15:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhFJN1I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Jun 2021 09:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhFJN1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 09:27:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690F4C061760
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 06:25:10 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lrKgG-000829-53; Thu, 10 Jun 2021 15:25:08 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lrKgD-0000cv-1a; Thu, 10 Jun 2021 15:25:05 +0200
Date:   Thu, 10 Jun 2021 15:25:05 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 4/9] net: phy: micrel: apply resume errata
 workaround for ksz8873 and ksz8863
Message-ID: <20210610132505.wgv6454sfahqmd27@pengutronix.de>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-5-o.rempel@pengutronix.de>
 <20210526224329.raaxr6b2s2uid4dw@skbuf>
 <20210610114920.w5xyijxe62svzdfp@pengutronix.de>
 <20210610130445.l5iiswxpzpez25cv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20210610130445.l5iiswxpzpez25cv@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:21:05 up 190 days,  3:27, 50 users,  load average: 0.06, 0.07,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 04:04:45PM +0300, Vladimir Oltean wrote:
> On Thu, Jun 10, 2021 at 01:49:20PM +0200, Oleksij Rempel wrote:
> > On Thu, May 27, 2021 at 01:43:29AM +0300, Vladimir Oltean wrote:
> > > On Wed, May 26, 2021 at 06:30:32AM +0200, Oleksij Rempel wrote:
> > > > The ksz8873 and ksz8863 switches are affected by following errata:
> > > > 
> > > > | "Receiver error in 100BASE-TX mode following Soft Power Down"
> > > > |
> > > > | Some KSZ8873 devices may exhibit receiver errors after transitioning
> > > > | from Soft Power Down mode to Normal mode, as controlled by register 195
> > > > | (0xC3) bits [1:0]. When exiting Soft Power Down mode, the receiver
> > > > | blocks may not start up properly, causing the PHY to miss data and
> > > > | exhibit erratic behavior. The problem may appear on either port 1 or
> > > > | port 2, or both ports. The problem occurs only for 100BASE-TX, not
> > > > | 10BASE-T.
> > > > |
> > > > | END USER IMPLICATIONS
> > > > | When the failure occurs, the following symptoms are seen on the affected
> > > > | port(s):
> > > > | - The port is able to link
> > > > | - LED0 blinks, even when there is no traffic
> > > > | - The MIB counters indicate receive errors (Rx Fragments, Rx Symbol
> > > > |   Errors, Rx CRC Errors, Rx Alignment Errors)
> > > > | - Only a small fraction of packets is correctly received and forwarded
> > > > |   through the switch. Most packets are dropped due to receive errors.
> > > > |
> > > > | The failing condition cannot be corrected by the following:
> > > > | - Removing and reconnecting the cable
> > > > | - Hardware reset
> > > > | - Software Reset and PCS Reset bits in register 67 (0x43)
> > > > |
> > > > | Work around:
> > > > | The problem can be corrected by setting and then clearing the Port Power
> > > > | Down bits (registers 29 (0x1D) and 45 (0x2D), bit 3). This must be done
> > > > | separately for each affected port after returning from Soft Power Down
> > > > | Mode to Normal Mode. The following procedure will ensure no further
> > > > | issues due to this erratum. To enter Soft Power Down Mode, set register
> > > > | 195 (0xC3), bits [1:0] = 10.
> > > > |
> > > > | To exit Soft Power Down Mode, follow these steps:
> > > > | 1. Set register 195 (0xC3), bits [1:0] = 00 // Exit soft power down mode
> > > > | 2. Wait 1ms minimum
> > > > | 3. Set register 29 (0x1D), bit [3] = 1 // Enter PHY port 1 power down mode
> > > > | 4. Set register 29 (0x1D), bit [3] = 0 // Exit PHY port 1 power down mode
> > > > | 5. Set register 45 (0x2D), bit [3] = 1 // Enter PHY port 2 power down mode
> > > > | 6. Set register 45 (0x2D), bit [3] = 0 // Exit PHY port 2 power down mode
> > > > 
> > > > This patch implements steps 2...6 of the suggested workaround. The first
> > > > step needs to be implemented in the switch driver.
> > > 
> > > Am I right in understanding that register 195 (0xc3) is not a port register?
> > > 
> > > To hit the erratum, you have to enter Soft Power Down in the first place,
> > > presumably by writing register 0xc3 from somewhere, right?
> > > 
> > > Where does Linux write this register from?
> > > 
> > > Once we find that place that enters/exits Soft Power Down mode, can't we
> > > just toggle the Port Power Down bits for each port, exactly like the ERR
> > > workaround says, instead of fooling around with a PHY driver?
> > 
> > The KSZ8873 switch is using multiple register mappings.
> > https://ww1.microchip.com/downloads/en/DeviceDoc/00002348A.pdf
> > Page 38:
> > "The MIIM interface is used to access the MII PHY registers defined in
> > this section. The SPI, I2C, and SMI interfaces can also be used to access
> > some of these registers. The latter three interfaces use a different
> > mapping mechanism than the MIIM interface."
> > 
> > This PHY driver is able to work directly over MIIM (MDIO). Or work with DSA over
> > integrated register translation mapping.
> 
> This doesn't answer my question of where is the Soft Power Down mode enabled.
> 
> > > > 
> > > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > > ---
> > > >  drivers/net/phy/micrel.c | 22 +++++++++++++++++++++-
> > > >  1 file changed, 21 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> > > > index 227d88db7d27..f03188ed953a 100644
> > > > --- a/drivers/net/phy/micrel.c
> > > > +++ b/drivers/net/phy/micrel.c
> > > > @@ -1048,6 +1048,26 @@ static int ksz8873mll_config_aneg(struct phy_device *phydev)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +static int ksz886x_resume(struct phy_device *phydev)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	/* Apply errata workaround for KSZ8863 and KSZ8873:
> > > > +	 * Receiver error in 100BASE-TX mode following Soft Power Down
> > > > +	 *
> > > > +	 * When exiting Soft Power Down mode, the receiver blocks may not start
> > > > +	 * up properly, causing the PHY to miss data and exhibit erratic
> > > > +	 * behavior.
> > > > +	 */
> > > > +	usleep_range(1000, 2000);
> > > > +
> > > > +	ret = phy_set_bits(phydev, MII_BMCR, BMCR_PDOWN);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	return phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);
> > > > +}
> > > > +
> > > >  static int kszphy_get_sset_count(struct phy_device *phydev)
> > > >  {
> > > >  	return ARRAY_SIZE(kszphy_hw_stats);
> > > > @@ -1401,7 +1421,7 @@ static struct phy_driver ksphy_driver[] = {
> > > >  	/* PHY_BASIC_FEATURES */
> > > >  	.config_init	= kszphy_config_init,
> > > >  	.suspend	= genphy_suspend,
> > > > -	.resume		= genphy_resume,
> > > > +	.resume		= ksz886x_resume,
> > > 
> > > Are you able to explain the relation between the call paths of
> > > phy_resume() and the lifetime of the Soft Power Down setting of the
> > > switch? How do we know that the PHYs are resumed after the switch has
> > > exited Soft Power Down mode?
> > 
> > The MII_BMCRs BMCR_PDOWN bit is mapped to the "register 29 (0x1D), bit
> > [3]" for the PHY0 and to "register 45 (0x2D), bit [3]" for the PHY1.
> > 
> > I assume, I'll need to add this comments to the commit message. Or do
> > you have other suggestions on how this should be implemented?
> 
> According to "3.2 Power Management" in the datasheet you shared:
> 
> There are 5 (five) operation modes under the power management function,
> which is controlled by two bits in Register 195 (0xC3) and one bit in
> Register 29 (0x1D), 45 (0x2D) as shown below:
> 
> Register 195 bit[1:0] = 00 Normal Operation Mode
> Register 195 bit[1:0] = 01 Energy Detect Mode
> Register 195 bit[1:0] = 10 Soft Power Down Mode
> Register 195 bit[1:0] = 11 Power Saving Mode
> Register 29, 45 bit 3 = 1 Port Based Power Down Mode
> 
> 3.2.4 SOFT POWER DOWN MODE
> 
> The soft power down mode is entered by setting bit[1:0]=10 in register
> 195. When KSZ8873MLL/FLL/RLL is in this mode, all PLL clocks are
> disabled, the PHY and the MAC are off, all internal registers values
> will not change. When the host set bit[1:0]=00 in register 195, this
> device will be back from current soft power down mode to normal
> operation mode.
> 
> 3.2.5 PORT-BASED POWER DOWN MODE
> 
> In addition, the KSZ8873MLL/FLL/RLL features a per-port power down mode.
> To save power, a PHY port that is not in use can be powered down via
> port control register 29 or 45 bit 3, or MIIM PHY register. It saves
> about 15 mA per port.
> 
> 
> 
> From the above I understand that the first 4 power management modes are
> global, and the 5th isn't.
> 
> You've explained how the PHY driver enters port-based power down mode.
> But the ERR describes an issue being triggered by a global power down
> mode. What you are describing is not what the ERR text is describing.
> 
> Excuse my perhaps stupid question, but have you triggered the issue
> described by the erratum? Does this patch fix that? Where is the disconnect?

Yes, this issue was seen  at some early point of development (back in 2019)
reproducible on system start. Where switch was in some default state or
on a state configured by the bootloader. I didn't tried to reproduce it
now. With other words, there is no need to provide global power
management by the DSA driver to trigger it.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
