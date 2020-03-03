Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E092177A27
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgCCPMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:12:42 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37132 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgCCPMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:12:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5S6qPIUegnem6WrV7YJYhUOKnURivrwHaxHYph+byQU=; b=bn3cHJqCc0AZd4OiGqsuEjlJ6
        fy/bqYg+x87tDlQTE/+4eGLaGAeViJNd/trmkf2C7xA8199YCrpoKX3XjYghObv95FNrXgE1AucUt
        gZvux78tjNDMp7EH/PLUIS9NkOxYsYB8Fv4XEh3gJv+3lt43oMH0aiPAuTaPaoUY/MFcCEm6nZisg
        S4bn1AoEp4613th8we0yMb8+oDRhcR711a9W2IonwI7tqUD5raY1kB55UQh2/dSMcTUYJdcwGLRHL
        GpI0mGZZ/efwKuQGISGKqYJIKP0gB7DlWpxTvxvF6fkxM02UGHDi7lY6dIrhMppeMiF6gaL6SEZPP
        /Ctu7+q4A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:48212)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j99Dn-0000GJ-By; Tue, 03 Mar 2020 15:12:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j99Dk-0005zy-5Z; Tue, 03 Mar 2020 15:12:32 +0000
Date:   Tue, 3 Mar 2020 15:12:32 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: phy: marvell10g: add energy detect
 power down tunable
Message-ID: <20200303151232.GO25745@shell.armlinux.org.uk>
References: <20200303144259.GM25745@shell.armlinux.org.uk>
 <E1j98mA-00057r-U8@rmk-PC.armlinux.org.uk>
 <20200303150741.GC3179@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303150741.GC3179@kwain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 04:07:41PM +0100, Antoine Tenart wrote:
> Hi Russell,
> 
> On Tue, Mar 03, 2020 at 02:44:02PM +0000, Russell King wrote:
> >  drivers/net/phy/marvell10g.c | 111 ++++++++++++++++++++++++++++++++++-
> >  
> > +static int mv3310_maybe_reset(struct phy_device *phydev, u32 unit, bool reset)
> > +{
> > +	int retries, val, err;
> > +
> > +	if (!reset)
> > +		return 0;
> 
> You could also call mv3310_maybe_reset after testing the 'reset'
> condition, that would make it easier to read the code.

I'm not too convinced:

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index ef1ed9415d9f..3daf73e61dff 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -279,13 +279,10 @@ static int mv3310_power_up(struct phy_device *phydev)
 				  MV_V2_PORT_CTRL_PWRDOWN);
 }
 
-static int mv3310_maybe_reset(struct phy_device *phydev, u32 unit, bool reset)
+static int mv3310_reset(struct phy_device *phydev, u32 unit)
 {
 	int retries, val, err;
 
-	if (!reset)
-		return 0;
-
 	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1,
 			     MDIO_CTRL1_RESET, MDIO_CTRL1_RESET);
 	if (err < 0)
@@ -684,10 +681,10 @@ static int mv3310_config_mdix(struct phy_device *phydev)
 
 	err = phy_modify_mmd_changed(phydev, MDIO_MMD_PCS, MV_PCS_CSCR1,
 				     MV_PCS_CSCR1_MDIX_MASK, val);
-	if (err < 0)
+	if (err <= 0)
 		return err;
 
-	return mv3310_maybe_reset(phydev, MV_PCS_BASE_T, err > 0);
+	return mv3310_reset(phydev, MV_PCS_BASE_T);
 }
 
 static int mv3310_config_aneg(struct phy_device *phydev)

The change from:

	if (err < 0)

to:

	if (err <= 0)

could easily be mistaken as a bug, and someone may decide to try to
"fix" that back to being the former instead.  The way I have the code
makes the intention explicit.

> 
> >  static struct phy_driver mv3310_drivers[] = {
> >  	{
> >  		.phy_id		= MARVELL_PHY_ID_88X3310,
> > @@ -580,13 +684,14 @@ static struct phy_driver mv3310_drivers[] = {
> >  		.name		= "mv88x3310",
> >  		.get_features	= mv3310_get_features,
> >  		.soft_reset	= genphy_no_soft_reset,
> > -		.config_init	= mv3310_config_init,
> 
> Having a quick look at the code, it seems this is a leftover and you
> don't actually want to remove config_init for the 3310.

Hmm, I wonder how that crept in... it shouldn't be there!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
