Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85762589F5
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgIAIAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgIAIAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 04:00:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDF2C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 01:00:08 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kD1Cy-0000No-U9; Tue, 01 Sep 2020 10:00:00 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kD1Cu-0004l6-3W; Tue, 01 Sep 2020 09:59:56 +0200
Date:   Tue, 1 Sep 2020 09:59:56 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        zhengdejin5@gmail.com, richard.leitner@skidata.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/5] net: phy: smsc: skip ENERGYON interrupt if disabled
Message-ID: <20200901075956.3r6cyibq4gdyl3jj@pengutronix.de>
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
 <20200831134836.20189-2-m.felsch@pengutronix.de>
 <20200831140240.GD2403519@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831140240.GD2403519@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:57:32 up 290 days, 23:16, 278 users,  load average: 0.09, 0.15,
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

Hi Andrew,

thanks for your fast response :)

On 20-08-31 16:02, Andrew Lunn wrote:
> On Mon, Aug 31, 2020 at 03:48:32PM +0200, Marco Felsch wrote:
> > Don't enable the interrupt if the platform disable the energy detection
> > by "smsc,disable-energy-detect".
> > 
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > ---
> >  drivers/net/phy/smsc.c | 15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> > index 74568ae16125..fa539a867de6 100644
> > --- a/drivers/net/phy/smsc.c
> > +++ b/drivers/net/phy/smsc.c
> > @@ -37,10 +37,17 @@ struct smsc_phy_priv {
> >  
> >  static int smsc_phy_config_intr(struct phy_device *phydev)
> >  {
> > -	int rc = phy_write (phydev, MII_LAN83C185_IM,
> > -			((PHY_INTERRUPT_ENABLED == phydev->interrupts)
> > -			? MII_LAN83C185_ISF_INT_PHYLIB_EVENTS
> > -			: 0));
> > +	struct smsc_phy_priv *priv = phydev->priv;
> > +	u16 intmask = 0;
> > +	int rc;
> > +
> > +	if (phydev->interrupts) {
> > +		intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
> > +		if (priv->energy_enable)
> > +			intmask |= MII_LAN83C185_ISF_INT7;
> 
> Hi Marco
> 
> These names are not particularly helpful. The include file does
> actually document the bits.
> 
> #define MII_LAN83C185_ISF_INT1 (1<<1) /* Auto-Negotiation Page Received */
> #define MII_LAN83C185_ISF_INT2 (1<<2) /* Parallel Detection Fault */
> #define MII_LAN83C185_ISF_INT3 (1<<3) /* Auto-Negotiation LP Ack */
> #define MII_LAN83C185_ISF_INT4 (1<<4) /* Link Down */
> #define MII_LAN83C185_ISF_INT5 (1<<5) /* Remote Fault Detected */
> #define MII_LAN83C185_ISF_INT6 (1<<6) /* Auto-Negotiation complete */
> #define MII_LAN83C185_ISF_INT7 (1<<7) /* ENERGYON */
> 
> If you feel like it, maybe add another patch which renames these to
> something better. MII_LAN83C185_ISF_DOWN, MII_LAN83C185_ISF_ENERGY_ON,
> etc?

I know.. I will add a patch to change this after we get the clock
discussion done.

Regards,
  Marco

> For this patch:
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>     Andrew
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
