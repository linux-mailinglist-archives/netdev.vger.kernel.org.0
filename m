Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F82262AB2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgIIIoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgIIIoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:44:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448A8C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:44:12 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFvhq-0007Uz-VG; Wed, 09 Sep 2020 10:43:54 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFvhl-0000xY-8I; Wed, 09 Sep 2020 10:43:49 +0200
Date:   Wed, 9 Sep 2020 10:43:49 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        zhengdejin5@gmail.com, richard.leitner@skidata.com,
        netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/5] net: phy: smsc: skip ENERGYON interrupt if
 disabled
Message-ID: <20200909084349.mst4xbayjsukt7dy@pengutronix.de>
References: <20200908112520.3439-1-m.felsch@pengutronix.de>
 <20200908112520.3439-2-m.felsch@pengutronix.de>
 <c1e70a48-794a-5fc5-822e-ad153679d58d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1e70a48-794a-5fc5-822e-ad153679d58d@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:42:52 up 299 days, 1 min, 303 users,  load average: 0.01, 0.08,
 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-08 18:58, Florian Fainelli wrote:
> 
> 
> On 9/8/2020 4:25 AM, Marco Felsch wrote:
> > Don't enable the interrupt if the platform disable the energy detection
> > by "smsc,disable-energy-detect".
> > 
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> > v2:
> > - Add Andrew's tag
> > 
> >   drivers/net/phy/smsc.c | 15 +++++++++++----
> >   1 file changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> > index 74568ae16125..fa539a867de6 100644
> > --- a/drivers/net/phy/smsc.c
> > +++ b/drivers/net/phy/smsc.c
> > @@ -37,10 +37,17 @@ struct smsc_phy_priv {
> >   static int smsc_phy_config_intr(struct phy_device *phydev)
> >   {
> > -	int rc = phy_write (phydev, MII_LAN83C185_IM,
> > -			((PHY_INTERRUPT_ENABLED == phydev->interrupts)
> > -			? MII_LAN83C185_ISF_INT_PHYLIB_EVENTS
> > -			: 0));
> > +	struct smsc_phy_priv *priv = phydev->priv;
> > +	u16 intmask = 0;
> > +	int rc;
> > +
> > +	if (phydev->interrupts) {
> 
> Not that it changes the code functionally, but it would be nice to preserve
> the phydev->interrupts == PHY_INTERRUPT_ENABLED.

Okay, I will apply this and add your reviewed-by tag.

Thanks,
  Marco

> 
> > +		intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
> > +		if (priv->energy_enable)
> > +			intmask |= MII_LAN83C185_ISF_INT7;
> > +	}
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> -- 
> Florian
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
