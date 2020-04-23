Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389CB1B5CBF
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgDWNmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726224AbgDWNmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 09:42:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7DEC08E934
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 06:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UaXf9i2Q1u7u/COPjY+IWmIElxx5bBJDu3o7GSXUabg=; b=WFPj6fCq++Fw8Z5aWGiw9jqE0
        nhKBg4hgiTrb9xN6OKYjgDCoRhRaFQRI4TGHKLOTvzJOXQaK4gFKKVh2kuQE5D5r9b8nknyG/9NvC
        qUo9uT8Yk4kKDNTiQOhRrR8vKq3B0WpzV1qGRY6YwxZFOFiyDA1QrXeExX5wKYud5+dCYfO3cinZj
        /c0bQHYBcobUmDQBvWjohpGGrlqaj4y7STIau9bg7TT7TAVfB7zs31qlQMgtzt4lIT2AqfWEFeVWN
        nBjdrk5YKNX6vPMqRVGL01CGNR03bgepV2wl3RiWajfcCyIvGQ7Ak+076MA+d9jeMu1Ax/ZwDQEkz
        hF6Rmp0yQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50120)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jRc74-0006aB-PP; Thu, 23 Apr 2020 14:41:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jRc74-0000ki-8y; Thu, 23 Apr 2020 14:41:58 +0100
Date:   Thu, 23 Apr 2020 14:41:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net v3 2/2] net: phy: marvell10g: hwmon support for 2110
Message-ID: <20200423134158.GR5827@shell.armlinux.org.uk>
References: <99771ceabb63b6a6a7d112197f639084f11e4aa4.1587618482.git.baruch@tkos.co.il>
 <f97e4690b4ec92598b3514f05e32dc26f37044ac.1587618482.git.baruch@tkos.co.il>
 <20200423133936.GS25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423133936.GS25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 02:39:36PM +0100, Russell King - ARM Linux admin wrote:
> On Thu, Apr 23, 2020 at 08:08:02AM +0300, Baruch Siach wrote:
> > Read the temperature sensor register from the correct location for the
> > 88E2110 PHY. There is no enable/disable bit, so leave
> > mv3310_hwmon_config() for 88X3310 only.
> > 
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> > v3: Split temperature register read routine per variant (Andrew Lunn)
> > 
> > v2: Fix indentation (Andrew Lunn)
> > ---
> >  drivers/net/phy/marvell10g.c | 25 +++++++++++++++++++++++--
> >  1 file changed, 23 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> > index 69530a84450f..e14b9c2e5efe 100644
> > --- a/drivers/net/phy/marvell10g.c
> > +++ b/drivers/net/phy/marvell10g.c
> > @@ -66,6 +66,8 @@ enum {
> >  	MV_PCS_CSSR1_SPD2_2500	= 0x0004,
> >  	MV_PCS_CSSR1_SPD2_10000	= 0x0000,
> >  
> > +	MV_PCS_TEMP		= 0x8042,
> 
> Please add a comment mentioning that this is for the 88E2110, and
> it would probably be a good idea to document the MV_V2_TEMP definition
> as 88X3310 specific as well.
> 
> > +
> >  	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
> >  	 * registers appear to set themselves to the 0x800X when AN is
> >  	 * restarted, but status registers appear readable from either.
> > @@ -104,6 +106,24 @@ static umode_t mv3310_hwmon_is_visible(const void *data,
> >  	return 0;
> >  }
> >  
> > +static int mv3310_hwmon_read_temp_reg(struct phy_device *phydev)
> > +{
> > +	return phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP);
> > +}
> > +
> > +static int mv2110_hwmon_read_temp_reg(struct phy_device *phydev)
> > +{
> > +	return phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_TEMP);
> > +}
> > +
> > +static int mv10g_hwmon_read_temp_reg(struct phy_device *phydev)
> > +{
> > +	if (phydev->drv->phy_id == MARVELL_PHY_ID_88X3310)
> > +		return mv3310_hwmon_read_temp_reg(phydev);
> > +	else /* MARVELL_PHY_ID_88E2110 */
> > +		return mv2110_hwmon_read_temp_reg(phydev);
> > +}
> > +
> >  static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
> >  			     u32 attr, int channel, long *value)
> >  {
> > @@ -116,7 +136,7 @@ static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
> >  	}
> >  
> >  	if (type == hwmon_temp && attr == hwmon_temp_input) {
> > -		temp = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP);
> > +		temp = mv10g_hwmon_read_temp_reg(phydev);
> >  		if (temp < 0)
> >  			return temp;
> >  
> > @@ -196,7 +216,8 @@ static int mv3310_hwmon_probe(struct phy_device *phydev)
> >  	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> >  	int i, j, ret;
> >  
> > -	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
> > +	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310 &&
> > +	    phydev->drv->phy_id != MARVELL_PHY_ID_88E2110)
> >  		return 0;
> 
> Doesn't that mean this condition can be removed, as this can only be
> reached when one of those conditions is true?

Thinking about this more, I think it may make sense to either reverse
the order of this patch series, or even better combine the two patches
into a single patch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
