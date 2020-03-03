Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F71D177A73
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgCCPaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:30:21 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37380 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbgCCPaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:30:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0AOalMujzfvOp/qBTNhEuZ9p7mv0TJBRJaYBnhdgVL8=; b=RMtEwPuH2+iWJTvoAX4mY/lFZ
        9YDhKjgowtPy5FCyDZVxr3fG9EmZvKmeXhukYcsuJjB6nHC65Q6fb06rE1n0G1vK5bJd5RjQGn5vk
        TRbFi8WR75wwgFRk7dIT9OVfF3rkz9aRZsRZqeKPITiU1Bv8Z4I2PuCZtidUIsA0ex9DtihIST5Xd
        9I2bV+nYl3dNLt7vmM9G56UITFYsv7wvjJNUnMDCY2LocPmX07Mo+hFtbn8tzYnh0N8FnnN+YxFZe
        qit5YNKnjIdM07bM1MgPx0DlqfcA0zxzY3A5h5ARkFXFfYX5Gmspebl0xUPeCUTZypMmegA1DQlho
        hE+1Ku2Xg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:55738)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j99Us-0000Lj-R3; Tue, 03 Mar 2020 15:30:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j99Ur-00060a-FJ; Tue, 03 Mar 2020 15:30:13 +0000
Date:   Tue, 3 Mar 2020 15:30:13 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: phy: marvell10g: add energy detect
 power down tunable
Message-ID: <20200303153013.GQ25745@shell.armlinux.org.uk>
References: <20200303144259.GM25745@shell.armlinux.org.uk>
 <E1j98mA-00057r-U8@rmk-PC.armlinux.org.uk>
 <20200303150741.GC3179@kwain>
 <20200303151232.GO25745@shell.armlinux.org.uk>
 <20200303151958.GE3179@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303151958.GE3179@kwain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 04:19:58PM +0100, Antoine Tenart wrote:
> On Tue, Mar 03, 2020 at 03:12:32PM +0000, Russell King - ARM Linux admin wrote:
> > On Tue, Mar 03, 2020 at 04:07:41PM +0100, Antoine Tenart wrote:
> > > On Tue, Mar 03, 2020 at 02:44:02PM +0000, Russell King wrote:
> > > >  drivers/net/phy/marvell10g.c | 111 ++++++++++++++++++++++++++++++++++-
> > > >  
> > > > +static int mv3310_maybe_reset(struct phy_device *phydev, u32 unit, bool reset)
> > > > +{
> > > > +	int retries, val, err;
> > > > +
> > > > +	if (!reset)
> > > > +		return 0;
> > > 
> > > You could also call mv3310_maybe_reset after testing the 'reset'
> > > condition, that would make it easier to read the code.
> > 
> > I'm not too convinced:
> > 
> > diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> > index ef1ed9415d9f..3daf73e61dff 100644
> > --- a/drivers/net/phy/marvell10g.c
> > +++ b/drivers/net/phy/marvell10g.c
> > @@ -279,13 +279,10 @@ static int mv3310_power_up(struct phy_device *phydev)
> >  				  MV_V2_PORT_CTRL_PWRDOWN);
> >  }
> >  
> > -static int mv3310_maybe_reset(struct phy_device *phydev, u32 unit, bool reset)
> > +static int mv3310_reset(struct phy_device *phydev, u32 unit)
> >  {
> >  	int retries, val, err;
> >  
> > -	if (!reset)
> > -		return 0;
> > -
> >  	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1,
> >  			     MDIO_CTRL1_RESET, MDIO_CTRL1_RESET);
> >  	if (err < 0)
> > @@ -684,10 +681,10 @@ static int mv3310_config_mdix(struct phy_device *phydev)
> >  
> >  	err = phy_modify_mmd_changed(phydev, MDIO_MMD_PCS, MV_PCS_CSCR1,
> >  				     MV_PCS_CSCR1_MDIX_MASK, val);
> > -	if (err < 0)
> > +	if (err <= 0)
> >  		return err;
> >  
> > -	return mv3310_maybe_reset(phydev, MV_PCS_BASE_T, err > 0);
> > +	return mv3310_reset(phydev, MV_PCS_BASE_T);
> >  }
> >  
> >  static int mv3310_config_aneg(struct phy_device *phydev)
> > 
> > The change from:
> > 
> > 	if (err < 0)
> > 
> > to:
> > 
> > 	if (err <= 0)
> > 
> > could easily be mistaken as a bug, and someone may decide to try to
> > "fix" that back to being the former instead.  The way I have the code
> > makes the intention explicit.
> 
> Using a single line to test both the error and the 'return 0'
> conditions, yes, I agree. Another solution would be to do something of
> the like:
> 
> 	phy_modify_mmd_changed()
> 	if (err < 0)
> 		return err;
> 
> 	if (err)
> 		mv3310_reset();
> 
> 	return 0;
> 
> I find it more readable, but this kind of thing is also a matter of
> personal taste.

Well, it either becomes:

        err = phy_modify_mmd_changed(phydev, MDIO_MMD_PCS, MV_PCS_CSCR1,
                                     MV_PCS_CSCR1_MDIX_MASK, val);
        if (err < 0)
                return err;

        if (err > 0)
                return mv3310_reset(phydev, MV_PCS_BASE_T);

        return 0;

or:

        err = phy_modify_mmd_changed(phydev, MDIO_MMD_PCS, MV_PCS_CSCR1,
                                     MV_PCS_CSCR1_MDIX_MASK, val);
        if (err > 0)
                err = mv3310_reset(phydev, MV_PCS_BASE_T);

        return err;

In the former case, we have two success-exit paths - one via a successful
mv3310_reset() and one by dropping through to the final return statement.

The latter case looks a bit better, at least to me.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
