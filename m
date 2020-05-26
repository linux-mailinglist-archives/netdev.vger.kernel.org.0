Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D79B1E25EF
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgEZPsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgEZPsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:48:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9B7C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=siva99cGoQHTdUndQstOL5EcLByng9QgTfqNXrbz0qo=; b=AccXTZTTH+tLQlQFqnd7zf85j
        JXXBXgTXwcmA85dkryePNIrEALryiaB2mmehbmKhAJNHHypZzKbMbGmd/zhdWIHnpOEDw3F0XLaIR
        wAoCUY70Es/IcS4s7bZhWltE7q/V+bsMM1s2pUWGIKfnTc4DDuQnnzDr60pCgHidnIsAsHISmWdrL
        oBlJlh2Owx3av5KNWFc02XkB9gMCDqd/gtf/7J1Niz4dbLaP+0VDTsoLpFqmQqzM3MB4yRLYk02C1
        iNTJboCPaD9upmPPsBETxuwVJddLElU9FlQzDhy7Y0PqKHz0SfQkxlHg5GJUjS18JowKgoNFXv/3P
        crEArLLbQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:34836)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdbo3-0008E0-2t; Tue, 26 May 2020 16:47:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdbo2-0005Vh-DX; Tue, 26 May 2020 16:47:54 +0100
Date:   Tue, 26 May 2020 16:47:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 6/7] net: phy: split devices_in_package
Message-ID: <20200526154754.GE1551@shell.armlinux.org.uk>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdac2-0005sv-W5@rmk-PC.armlinux.org.uk>
 <d46d859f-f170-68f5-907f-0470ea9b218f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d46d859f-f170-68f5-907f-0470ea9b218f@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 10:39:08AM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/26/20 9:31 AM, Russell King wrote:
> > We have two competing requirements for the devices_in_package field.
> > We want to use it as a bit array indicating which MMDs are present, but
> > we also want to know if the Clause 22 registers are present.
> > 
> > Since "devices in package" is a term used in the 802.3 specification,
> > keep this as the as-specified values read from the PHY, and introduce
> > a new member "mmds_present" to indicate which MMDs are actually
> > present in the PHY, derived from the "devices in package" value.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >   drivers/net/phy/phy-c45.c    | 4 ++--
> >   drivers/net/phy/phy_device.c | 6 +++---
> >   drivers/net/phy/phylink.c    | 8 ++++----
> >   include/linux/phy.h          | 4 +++-
> >   4 files changed, 12 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> > index 8cd952950a75..4b5805e2bd0e 100644
> > --- a/drivers/net/phy/phy-c45.c
> > +++ b/drivers/net/phy/phy-c45.c
> > @@ -219,7 +219,7 @@ int genphy_c45_read_link(struct phy_device *phydev)
> >   	int val, devad;
> >   	bool link = true;
> > -	if (phydev->c45_ids.devices_in_package & MDIO_DEVS_AN) {
> > +	if (phydev->c45_ids.mmds_present & MDIO_DEVS_AN) {
> >   		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
> >   		if (val < 0)
> >   			return val;
> > @@ -397,7 +397,7 @@ int genphy_c45_pma_read_abilities(struct phy_device *phydev)
> >   	int val;
> >   	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
> > -	if (phydev->c45_ids.devices_in_package & MDIO_DEVS_AN) {
> > +	if (phydev->c45_ids.mmds_present & MDIO_DEVS_AN) {
> >   		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
> >   		if (val < 0)
> >   			return val;
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index a483d79cfc87..1c948bbf4fa0 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -707,9 +707,6 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
> >   		return -EIO;
> >   	*devices_in_package |= phy_reg;
> > -	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
> > -	*devices_in_package &= ~BIT(0);
> > -
> >   	return 0;
> >   }
> > @@ -788,6 +785,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> >   	}
> >   	c45_ids->devices_in_package = devs_in_pkg;
> > +	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
> > +	c45_ids->mmds_present = devs_in_pkg & ~BIT(0);
> >   	*phy_id = 0;
> >   	return 0;
> > @@ -842,6 +841,7 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
> >   	int r;
> >   	c45_ids.devices_in_package = 0;
> > +	c45_ids.mmds_present = 0;
> >   	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
> >   	if (is_c45)
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index 6defd5eddd58..b548e0418694 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -1709,11 +1709,11 @@ static int phylink_phy_read(struct phylink *pl, unsigned int phy_id,
> >   		case MII_BMSR:
> >   		case MII_PHYSID1:
> >   		case MII_PHYSID2:
> > -			devad = __ffs(phydev->c45_ids.devices_in_package);
> > +			devad = __ffs(phydev->c45_ids.mmds_present);
> >   			break;
> >   		case MII_ADVERTISE:
> >   		case MII_LPA:
> > -			if (!(phydev->c45_ids.devices_in_package & MDIO_DEVS_AN))
> > +			if (!(phydev->c45_ids.mmds_present & MDIO_DEVS_AN))
> >   				return -EINVAL;
> >   			devad = MDIO_MMD_AN;
> >   			if (reg == MII_ADVERTISE)
> > @@ -1749,11 +1749,11 @@ static int phylink_phy_write(struct phylink *pl, unsigned int phy_id,
> >   		case MII_BMSR:
> >   		case MII_PHYSID1:
> >   		case MII_PHYSID2:
> > -			devad = __ffs(phydev->c45_ids.devices_in_package);
> > +			devad = __ffs(phydev->c45_ids.mmds_present);
> >   			break;
> >   		case MII_ADVERTISE:
> >   		case MII_LPA:
> > -			if (!(phydev->c45_ids.devices_in_package & MDIO_DEVS_AN))
> > +			if (!(phydev->c45_ids.mmds_present & MDIO_DEVS_AN))
> >   				return -EINVAL;
> >   			devad = MDIO_MMD_AN;
> >   			if (reg == MII_ADVERTISE)
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 41c046545354..0d41c710339a 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -354,11 +354,13 @@ enum phy_state {
> >   /**
> >    * struct phy_c45_device_ids - 802.3-c45 Device Identifiers
> > - * @devices_in_package: Bit vector of devices present.
> > + * @devices_in_package: IEEE 802.3 devices in package register value.
> > + * @mmds_present: bit vector of MMDs present.
> >    * @device_ids: The device identifer for each present device.
> >    */
> >   struct phy_c45_device_ids {
> >   	u32 devices_in_package;
> > +	u32 mmds_present;
> >   	u32 device_ids[8];
> >   };
> 
> It seems like the majority of the devices_in_package accessors are just bit
> masking for a given MMD/field. The case that has the problem is the __ffs()
> calls which failed to account for this. So why not just fix those two cases
> instead of creating a duplicate field with exactly the same data in it minus
> a bit.

I think I explained that in the commit message...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
