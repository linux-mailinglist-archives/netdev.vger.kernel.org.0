Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F9725F41D
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgIGHfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgIGHe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 03:34:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988ADC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 00:34:56 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFBfl-0004PD-SG; Mon, 07 Sep 2020 09:34:41 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFBfj-0004yr-Cs; Mon, 07 Sep 2020 09:34:39 +0200
Date:   Mon, 7 Sep 2020 09:34:39 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, adam.rudzinski@arf.net.pl,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH net-next 3/3] net: phy: bcm7xxx: request and manage GPHY
 clock
Message-ID: <20200907073439.sdo27cq4no72vyre@pengutronix.de>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <20200903043947.3272453-4-f.fainelli@gmail.com>
 <20200904061558.s2s33nfof6itt24y@pengutronix.de>
 <ccfa67f5-d3dd-26a6-1bb8-9772e2434d82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccfa67f5-d3dd-26a6-1bb8-9772e2434d82@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:31:30 up 296 days, 22:50, 278 users,  load average: 0.05, 0.07,
 0.07
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-04 08:37, Florian Fainelli wrote:
> 
> 
> On 9/3/2020 11:15 PM, Marco Felsch wrote:
> > Hi Florian,
> > 
> > On 20-09-02 21:39, Florian Fainelli wrote:
> > > The internal Gigabit PHY on Broadcom STB chips has a digital clock which
> > > drives its MDIO interface among other things, the driver now requests
> > > and manage that clock during .probe() and .remove() accordingly.
> > > 
> > > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > > ---
> > >   drivers/net/phy/bcm7xxx.c | 18 +++++++++++++++++-
> > >   1 file changed, 17 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
> > > index 692048d86ab1..f0ffcdcaef03 100644
> > > --- a/drivers/net/phy/bcm7xxx.c
> > > +++ b/drivers/net/phy/bcm7xxx.c
> > > @@ -11,6 +11,7 @@
> > >   #include "bcm-phy-lib.h"
> > >   #include <linux/bitops.h>
> > >   #include <linux/brcmphy.h>
> > > +#include <linux/clk.h>
> > >   #include <linux/mdio.h>
> > >   /* Broadcom BCM7xxx internal PHY registers */
> > > @@ -39,6 +40,7 @@
> > >   struct bcm7xxx_phy_priv {
> > >   	u64	*stats;
> > > +	struct clk *clk;
> > >   };
> > >   static int bcm7xxx_28nm_d0_afe_config_init(struct phy_device *phydev)
> > > @@ -534,7 +536,19 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
> > >   	if (!priv->stats)
> > >   		return -ENOMEM;
> > > -	return 0;
> > > +	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, NULL);
> > 
> > Since the clock is binded to the mdio-dev here..
> > 
> > > +	if (IS_ERR(priv->clk))
> > > +		return PTR_ERR(priv->clk);
> > > +
> > > +	return clk_prepare_enable(priv->clk);
> > 
> > clould we use devm_add_action_or_reset() here so we don't have to
> > register the .remove() hook?
> 
> Maybe, more on that below.
> 
> > 
> > > +}
> > > +
> > > +static void bcm7xxx_28nm_remove(struct phy_device *phydev)
> > > +{
> > > +	struct bcm7xxx_phy_priv *priv = phydev->priv;
> > > +
> > > +	clk_disable_unprepare(priv->clk);
> > > +	devm_clk_put(&phydev->mdio.dev, priv->clk);
> > 
> > Is this really necessary? The devm_clk_get_optional() function already
> > registers the devm_clk_release() hook.
> 
> Yes, because you can unbind the PHY driver from sysfs, and if you want to
> bind that driver again, which will call .probe() again, you must undo
> strictly everything that .probe() did. The embedded mdio_device does not go
> away, so there will be no automatic freeing of resources.

Okay I got this. Sry. I'm not that deep into the net-stack and the
device live time. Thanks for the clarification.

> Using devm_* may
> be confusing, so using just the plain clk_get() and clk_put() may be clearer
> here.

That would be better for others including me because I detected a
failure on my patchset.

Regards,
  Marco
