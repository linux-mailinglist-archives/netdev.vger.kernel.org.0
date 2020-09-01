Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6806258A4B
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgIAIYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgIAIYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 04:24:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90BDC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 01:24:19 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kD1aP-0003FN-Rb; Tue, 01 Sep 2020 10:24:13 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kD1aP-0006NQ-28; Tue, 01 Sep 2020 10:24:13 +0200
Date:   Tue, 1 Sep 2020 10:24:13 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        zhengdejin5@gmail.com, richard.leitner@skidata.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 4/5] net: phy: smsc: add phy refclk in support
Message-ID: <20200901082413.cjnmy3s4lb5pfhv5@pengutronix.de>
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
 <20200831134836.20189-5-m.felsch@pengutronix.de>
 <2993e0ed-ebe9-fd85-4650-7e53c15cfe34@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2993e0ed-ebe9-fd85-4650-7e53c15cfe34@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:05:27 up 290 days, 23:24, 279 users,  load average: 0.11, 0.14,
 0.09
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-08-31 09:32, Florian Fainelli wrote:
> 
> 
> On 8/31/2020 6:48 AM, Marco Felsch wrote:
> > Add support to specify the clock provider for the phy refclk and don't
> > rely on 'magic' host clock setup. [1] tried to address this by
> > introducing a flag and fixing the corresponding host. But this commit
> > breaks the IRQ support since the irq setup during .config_intr() is
> > thrown away because the reset comes from the side without respecting the
> > current phy-state within the phy-state-machine. Furthermore the commit
> > fixed the problem only for FEC based hosts other hosts acting like the
> > FEC are not covered.
> > 
> > This commit goes the other way around to address the bug fixed by [1].
> > Instead of resetting the device from the side every time the refclk gets
> > (re-)enabled it requests and enables the clock till the device gets
> > removed. The phy is still rest but now within the phylib and  with
> > respect to the phy-state-machine.
> > 
> > [1] commit 7f64e5b18ebb ("net: phy: smsc: LAN8710/20: add
> >      PHY_RST_AFTER_CLK_EN flag")
> > 
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > ---
> >   drivers/net/phy/smsc.c | 30 ++++++++++++++++++++++++++++++
> >   1 file changed, 30 insertions(+)
> > 
> > diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> > index 79574fcbd880..b98a7845681f 100644
> > --- a/drivers/net/phy/smsc.c
> > +++ b/drivers/net/phy/smsc.c
> > @@ -12,6 +12,7 @@
> >    *
> >    */
> > +#include <linux/clk.h>
> >   #include <linux/kernel.h>
> >   #include <linux/module.h>
> >   #include <linux/mii.h>
> > @@ -33,6 +34,7 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
> >   struct smsc_phy_priv {
> >   	bool energy_enable;
> > +	struct clk *refclk;
> >   };
> >   static int smsc_phy_config_intr(struct phy_device *phydev)
> > @@ -194,11 +196,19 @@ static void smsc_get_stats(struct phy_device *phydev,
> >   		data[i] = smsc_get_stat(phydev, i);
> >   }
> > +static void smsc_clk_disable_action(void *data)
> > +{
> > +	struct smsc_phy_priv *priv = data;
> > +
> > +	clk_disable_unprepare(priv->refclk);
> > +}
> > +
> >   static int smsc_phy_probe(struct phy_device *phydev)
> >   {
> >   	struct device *dev = &phydev->mdio.dev;
> >   	struct device_node *of_node = dev->of_node;
> >   	struct smsc_phy_priv *priv;
> > +	int ret;
> >   	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> >   	if (!priv)
> > @@ -211,6 +221,26 @@ static int smsc_phy_probe(struct phy_device *phydev)
> >   	phydev->priv = priv;
> > +	priv->refclk = devm_clk_get_optional(dev, NULL);
> > +	if (IS_ERR(priv->refclk)) {
> > +		if (PTR_ERR(priv->refclk) == -EPROBE_DEFER)
> > +			return -EPROBE_DEFER;
> > +
> > +		/* Clocks are optional all errors should be ignored here */
> > +		return 0;
> > +	}
> > +
> > +	/* Starting from here errors should not be ignored anymore */
> > +	ret = clk_set_rate(priv->refclk, 50 * 1000 * 1000);
> > +	if (ret)
> > +		return ret;
> 
> The clock should be enabled first before attempting a rate change

Is this the way to use the API? My understanding was to set the correct
clk value before we enable the clk value can be out-of-range for the
phy. But you have a point, we should:

ret = clk_prepare(priv->refclk);
if (ret)
	return ret;

ret = clk_set_rate(priv->refclk, 50 * 1000 * 1000);
if (ret)
	return ret;

ret = clk_enable(priv->refclk);
if (ret)
	return ret;

to avoide the usage of unprepared clocks.

>, and this
> also causes a more fundamental question: what is the sate of the clock when
> the PHY driver is probed, and is the reference clock feeding into the MDIO
> logic of the PHY.

Currently this state is defined by the bootloader if the clk is provided
by the host.

> By that I mean that if the reference clock was disabled, would the PHY still
> respond to MDIO reads such that you would be able to probe and identify it?

Pls correct me if I'm wrong but currently all phy drivers relying on the
settings made by the bootloader/firmware.

> If not, your demv_clk_get_optional() is either too late

Yes, I got this.

> , or assuming a prior state,

This is the our case. Isn't it the purpose of the bootloader to setup
the HW?

> or you are working around this in Device Tree by using a compatible
> string with the form "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$" in which
> case, this is a making assumptions about how the OF MDIO layer works which
> is not ideal.

Nope, I'm using "ethernet-phy-ieee802.3-c22".

> I am preparing some patches that aim at enabling a given MDIO device's clock
> prior to probing it and should be able to post them by today.

Create :) Can you provide me a link? What I can say for now is: This
solution was used by the micrel driver too and it seems to work. I
wanted to keep the change smaller/more local because the current
upstream state is: SMSC-Phy <-> FEC-Host ==> IRQ broken. If your patch
fixes this too in a more general matter I'm fine with it and we can drop
this patch but we should fix this as soon as possible.

Regards,
  Marco

> > +
> > +	ret = clk_prepare_enable(priv->refclk);
> > +	if (ret)
> > +		return ret;
> > +
> > +	devm_add_action_or_reset(dev, smsc_clk_disable_action, priv);
> > +
> >   	return 0;
> >   }
> > 
> 
> -- 
> Florian
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
