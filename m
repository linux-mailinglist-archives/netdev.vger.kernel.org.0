Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4BB19F714
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgDFNh1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Apr 2020 09:37:27 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43381 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbgDFNh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:37:27 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jLRwF-0000or-9G; Mon, 06 Apr 2020 15:37:19 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jLRwB-0002wI-Ja; Mon, 06 Apr 2020 15:37:15 +0200
Date:   Mon, 6 Apr 2020 15:37:15 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Philippe Schenker <philippe.schenker@toradex.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "david@protonic.nl" <david@protonic.nl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] net: phy: micrel: add phy-mode support for the
 KSZ9031 PHY
Message-ID: <20200406133715.GA15542@pengutronix.de>
References: <20200403081812.19717-1-o.rempel@pengutronix.de>
 <868f2449c1bc93cfe38629708c1e449d6c16de6d.camel@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <868f2449c1bc93cfe38629708c1e449d6c16de6d.camel@toradex.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:55:45 up 207 days, 23:43, 472 users,  load average: 31.03,
 38.66, 32.05
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Apr 06, 2020 at 08:58:49AM +0000, Philippe Schenker wrote:
> On Fri, 2020-04-03 at 10:18 +0200, Oleksij Rempel wrote:
> > Add support for following phy-modes: rgmii, rgmii-id, rgmii-txid,
> > rgmii-rxid.
> > 
> > This PHY has an internal RX delay of 1.2ns and no delay for TX.
> > 
> > The pad skew registers allow to set the total TX delay to max 1.38ns
> > and
> > the total RX delay to max of 2.58ns (configurable 1.38ns + build in
> > 1.2ns) and a minimal delay of 0ns.
> 
> This skew delay registers of the KSZ9031 are not meant for this delay.

According to the documentation of the PHY [1], these registers should be
used to tune the total delay of the circuit.

> But I agree that it could make sense to implement phy-modes too for this
> PHY. I even thought myself about implementing it.

> But I guess it is not a good thing to be able to set the same
> registers in a chip in two different places in a DT. How is this
> solved generally in linux?

In this case i would prefer to talk about several device tree properties
describing the same thing. The phy-mode property will set a more generic
defaults where the *-skew-ps properties cane be used to overwrite single
or all pads.

The current situation is:
- we have a RGMII-RXID PHY (with internal not optional delay of 1.2ns)
- which is configured in many (all?) devicetries as phy-mode="rgmii", not
  "rgmii-rxid".

There are boards:
- with default options. No extra delays are configured, so actually they
  want to have a "rgmii-rxid", but configure as phy-mode="rgmii" 
- configured by fixup (for example in i'MX6Q:  RGMII-ID, but in DT
  configuration with phy-mode=rgmii)

All of this configurations are broken. This one is correct:

- configured by *-skew-ps property and using phy-mode=rgmii.

> Another reasoning is that this will *only* work, if the PCB traces are
> length- matched. This leads me to the conclusion that throwing an
> error so the PHY doesn't work if someone added e.g. 'rgmii-id' and
> skew registers is a good thing.

So you mean, skew setting should only work with phy-mode="rgmii", and
throw an error otherwise? Makes sense to me.

> But with that we would maybe break some boards... At least I would throw
> a warning in ksz9031_of_load_skew_values.
> 
> > According to the RGMII v2 specification the delay provided by PCB
> > traces
> 
> As I understood, RGMII v1.3 demands delay by PCB traces (that is for
> embedded mostly not possible). Whereas RGMII v2.0 demands de MAC to add
> the delay for TXC and the PHY for RXC.
> 
> I know its nitpicky but still can be confusing for someone trying to
> understand that. Could you adjust that here?
> 
> > should be between 1.5ns and 2.0ns. As this PHY can provide max delay
> > of
> > only 1.38ns on the TX line, in RGMII-ID mode a symmetric delay of
> > 1.38ns
> > for both the RX and TX lines is chosen, even if the RX line could be
> > configured with the 1.5ns according to the standard.
> 
> Why do you decided for a symmetric delay? I guess the hardware level
> doesn't care if the input-stages of two different silicons don't care if
> the delay is symmetrical. I suggest to use a delay for RXC to get the
> RXC clock edge in the middle of the data lines.

Are there any technical justification to use both 1.38 or one 1.38 and
other 2.0?

Our HW expert suggest to use the middle of the RGMII recommended delay:
1.75ns. What is your opinion? So far ksz9031 provide not configurable 1.2ns and
ksu9131 use 2.0ns (DLL based) delay. It looks like the "internal delay"
interpretation has some valid range of numbers.

> 
> Best Regards,
> Philippe
> > 
> > The phy-modes can still be fine tuned/overwritten by *-skew-ps
> > device tree properties described in:
> > Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/phy/micrel.c | 109
> > +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 109 insertions(+)
> > 
> > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> > index 2ec19e5540bff..4fe5a814f586d 100644
> > --- a/drivers/net/phy/micrel.c
> > +++ b/drivers/net/phy/micrel.c
> > @@ -19,6 +19,7 @@
> >   *			 ksz9477
> >   */
> >  
> > +#include <linux/bitfield.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/phy.h>
> > @@ -489,9 +490,50 @@ static int ksz9021_config_init(struct phy_device
> > *phydev)
> >  
> >  /* MMD Address 0x2 */
> >  #define MII_KSZ9031RN_CONTROL_PAD_SKEW	4
> > +#define MII_KSZ9031RN_RX_CTL_M		GENMASK(7, 4)
> > +#define MII_KSZ9031RN_TX_CTL_M		GENMASK(3, 0)
> > +
> >  #define MII_KSZ9031RN_RX_DATA_PAD_SKEW	5
> > +#define MII_KSZ9031RN_RXD3		GENMASK(15, 12)
> > +#define MII_KSZ9031RN_RXD2		GENMASK(11, 8)
> > +#define MII_KSZ9031RN_RXD1		GENMASK(7, 4)
> > +#define MII_KSZ9031RN_RXD0		GENMASK(3, 0)
> > +
> >  #define MII_KSZ9031RN_TX_DATA_PAD_SKEW	6
> > +#define MII_KSZ9031RN_TXD3		GENMASK(15, 12)
> > +#define MII_KSZ9031RN_TXD2		GENMASK(11, 8)
> > +#define MII_KSZ9031RN_TXD1		GENMASK(7, 4)
> > +#define MII_KSZ9031RN_TXD0		GENMASK(3, 0)
> > +
> >  #define MII_KSZ9031RN_CLK_PAD_SKEW	8
> > +#define MII_KSZ9031RN_GTX_CLK		GENMASK(9, 5)
> > +#define MII_KSZ9031RN_RX_CLK		GENMASK(4, 0)
> > +
> > +/* KSZ9031 has internal RGMII_IDRX = 1.2ns and RGMII_IDTX = 0ns. To
> > + * provide different RGMII options we need to configure delay offset
> > + * for each pad relative to build in delay.
> > + */
> > +/* set rx to +0.18ns and rx_clk to "No delay adjustment" value to get
> > delays of
> > + * 1.38ns
> > + */
> > +#define RX_ID				0x1a
> 
> 0.18ns would be 0xa, why do you put 0x1a a 5-bit value into a 4-bit
> register?

Yes, it was a typo. kbuild bot already reported this bug.

> Then there's that thing with plus/minus. You shift now data-lines with
> 0.18ns. Is that now adding or subtracting to the 1.2ns? I would say as
> RXC is shifted by 1.2ns and you add a positive delay of 0.18ns you will
> end up with 1.02ns delay in total.

Thx! I'll fix it.

> > +#define RX_CLK_ID			0xf
> > +
> > +/* set rx to +0.30ns and rx_clk to -0.90ns to compensate the
> > + * internal 1.2ns delay.
> > + */
> > +#define RX_ND				0xc
> > +#define RX_CLK_ND			0x0
> > +
> > +/* set tx to -0.42ns and tx_clk to +0.96ns to get 1.38ns delay */
> > +#define TX_ID				0x0
> > +#define TX_CLK_ID			0x1f
> > +
> > +/* set tx and tx_clk to "No delay adjustment" to keep 0ns
> > + * dealy
> > + */
> > +#define TX_ND				0x7
> > +#define TX_CLK_ND			0xf
> >  
> >  /* MMD Address 0x1C */
> >  #define MII_KSZ9031RN_EDPD		0x23
> > @@ -564,6 +606,67 @@ static int ksz9031_enable_edpd(struct phy_device
> > *phydev)
> >  			     reg | MII_KSZ9031RN_EDPD_ENABLE);
> >  }
> >  
> > +static int ksz9031_config_rgmii_delay(struct phy_device *phydev)
> > +{
> > +	u16 rx, tx, rx_clk, tx_clk;
> > +	int ret;
> > +
> > +	switch (phydev->interface) {
> > +	case PHY_INTERFACE_MODE_RGMII:
> > +		tx = TX_ND;
> > +		tx_clk = TX_CLK_ND;
> > +		rx = RX_ND;
> > +		rx_clk = RX_CLK_ND;
> > +		break;
> > +	case PHY_INTERFACE_MODE_RGMII_ID:
> > +		tx = TX_ID;
> > +		tx_clk = TX_CLK_ID;
> > +		rx = RX_ID;
> > +		rx_clk = RX_CLK_ID;
> > +		break;
> > +	case PHY_INTERFACE_MODE_RGMII_RXID:
> > +		tx = TX_ND;
> > +		tx_clk = TX_CLK_ND;
> > +		rx = RX_ID;
> > +		rx_clk = RX_CLK_ID;
> > +		break;
> > +	case PHY_INTERFACE_MODE_RGMII_TXID:
> > +		tx = TX_ID;
> > +		tx_clk = TX_CLK_ID;
> > +		rx = RX_ND;
> > +		rx_clk = RX_CLK_ND;
> > +		break;
> > +	default:
> > +		return 0;
> > +	}
> > +
> > +	ret = phy_write_mmd(phydev, 2, MII_KSZ9031RN_CONTROL_PAD_SKEW,
> > +			    FIELD_PREP(MII_KSZ9031RN_RX_CTL_M, rx) |
> > +			    FIELD_PREP(MII_KSZ9031RN_TX_CTL_M, tx));
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = phy_write_mmd(phydev, 2, MII_KSZ9031RN_RX_DATA_PAD_SKEW,
> > +			    FIELD_PREP(MII_KSZ9031RN_RXD3, rx) |
> > +			    FIELD_PREP(MII_KSZ9031RN_RXD2, rx) |
> > +			    FIELD_PREP(MII_KSZ9031RN_RXD1, rx) |
> > +			    FIELD_PREP(MII_KSZ9031RN_RXD0, rx));
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = phy_write_mmd(phydev, 2, MII_KSZ9031RN_TX_DATA_PAD_SKEW,
> > +			    FIELD_PREP(MII_KSZ9031RN_TXD3, tx) |
> > +			    FIELD_PREP(MII_KSZ9031RN_TXD2, tx) |
> > +			    FIELD_PREP(MII_KSZ9031RN_TXD1, tx) |
> > +			    FIELD_PREP(MII_KSZ9031RN_TXD0, tx));
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return phy_write_mmd(phydev, 2, MII_KSZ9031RN_CLK_PAD_SKEW,
> > +			     FIELD_PREP(MII_KSZ9031RN_GTX_CLK, tx_clk) |
> > +			     FIELD_PREP(MII_KSZ9031RN_RX_CLK, rx_clk));
> > +}
> > +
> >  static int ksz9031_config_init(struct phy_device *phydev)
> >  {
> >  	const struct device *dev = &phydev->mdio.dev;
> > @@ -596,6 +699,12 @@ static int ksz9031_config_init(struct phy_device
> > *phydev)
> >  	} while (!of_node && dev_walker);
> >  
> >  	if (of_node) {
> > +		if (phy_interface_is_rgmii(phydev)) {
> > +			result = ksz9031_config_rgmii_delay(phydev);
> > +			if (result < 0)
> > +				return result;
> > +		}
> > +
> >  		ksz9031_of_load_skew_values(phydev, of_node,
> >  		ksz9031_of_load_skew_values		MII_KSZ9031RN_CLK_PAD_SKEW, 5,
> >  				clk_skews, 2);

[1]
==============================================================================
When computing the RGMII timing relationships, delays along the entire
data path must be aggregated to determine the total delay to be used for
comparison between RGMII pins within their respective timing group. For
the transmit data path, total delay includes MAC output delay,
MAC-to-PHY PCB routing delay, and PHY (KSZ9031RNX) input delay and skew
setting (if any). For the receive data path, the total delay includes
PHY (KSZ9031RNX) output delay, PHY-to-MAC PCB routing delay, and MAC
input delay and skew setting (if any).

As the default, after power-up or reset, the KSZ9031RNX RGMII timing
conforms to the timing requirements in the RGMII Version 2.0
Specification for internal PHY chip delay.

For the transmit path (MAC to KSZ9031RNX), the KSZ9031RNX does not add
any delay locally at its GTX_CLK, TX_EN and TXD[3:0] input pins, and
expects the GTX_CLK delay to be provided on-chip by the MAC. If MAC does
not provide any delay or insufficient delay for the GTX_CLK, the
KSZ9031RNX has pad skew registers that can provide up to 1.38 ns on-chip
delay.

For the receive path (KSZ9031RNX to MAC), the KSZ9031RNX adds 1.2ns
typical delay to the RX_CLK output pin with respect to RX_DV and
RXD[3:0] output pins. If necessary, the KSZ9031RNX has pad skew
registers that can adjust the RX_CLK on-chip delay up to 2.58 ns from
the 1.2 ns default delay.
==============================================================================

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
