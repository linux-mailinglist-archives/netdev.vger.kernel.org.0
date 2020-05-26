Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5245A1E271B
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgEZQdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgEZQdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:33:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03098C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 09:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qVkBQgAFIZOykC7HbI4BSicA+egFu//ByWvBBkbTvGA=; b=O196D2c7iR2HIK02rwpDeyPnM
        DZ9NxTrQIrQPgfDAxsUhM/4iVnz85KD87ORko0O6WAaD9eOnaZdGcYj59Wbmx/9CFFsnjGZYgcFCS
        VWHi0Yt3fRDBGGcE0nTBH6yN4s0k0BDIHgQVOMzJzL2BGJwRmqGWz6VHYrs0Dvq3LOwqavHUIPbdf
        w+cuSIJRhoHb2OiIzq1Ioj8QaQgWalMWUECt75VDHzMESNY0Ga9E6wLouJ+9MzEtWZMm6m25v85P6
        D98ZJEL9JS9K0z/tRjdW3d16Z22BPtZuzdj35PrGAL0HsFE8cXYRy2L004wpdNbjcAuUONSlCnIPa
        wcdW/S7YA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:34858)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdcWB-0008KJ-Sh; Tue, 26 May 2020 17:33:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdcW9-0005XK-Tb; Tue, 26 May 2020 17:33:29 +0100
Date:   Tue, 26 May 2020 17:33:29 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 5/7] net: phy: set devices_in_package only after
 validation
Message-ID: <20200526163329.GE1605@shell.armlinux.org.uk>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdabx-0005sh-T7@rmk-PC.armlinux.org.uk>
 <758bd1ef-e7f8-f746-af76-b54c14dd5af2@arm.com>
 <20200526155028.GF1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526155028.GF1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 04:50:28PM +0100, Russell King - ARM Linux admin wrote:
> On Tue, May 26, 2020 at 10:39:49AM -0500, Jeremy Linton wrote:
> > Hi,
> > 
> > On 5/26/20 9:31 AM, Russell King wrote:
> > > Only set the devices_in_package to a non-zero value if we find a valid
> > > value for this field, so we avoid leaving it set to e.g. 0x1fffffff.
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >   drivers/net/phy/phy_device.c | 17 ++++++++++-------
> > >   1 file changed, 10 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > index fa9164ac0f3d..a483d79cfc87 100644
> > > --- a/drivers/net/phy/phy_device.c
> > > +++ b/drivers/net/phy/phy_device.c
> > > @@ -730,13 +730,13 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > >   			   struct phy_c45_device_ids *c45_ids)
> > >   {
> > >   	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
> > > -	u32 *devs = &c45_ids->devices_in_package;
> > > +	u32 devs_in_pkg = 0;
> > >   	int i, ret, phy_reg;
> > >   	/* Find first non-zero Devices In package. Device zero is reserved
> > >   	 * for 802.3 c45 complied PHYs, so don't probe it at first.
> > >   	 */
> > > -	for (i = 1; i < MDIO_MMD_NUM && *devs == 0; i++) {
> > > +	for (i = 1; i < MDIO_MMD_NUM && devs_in_pkg == 0; i++) {
> > >   		if (i >= 8) {
> > >   			/* Only probe for the devices-in-package if there
> > >   			 * is a PHY reporting as present here; this avoids
> > > @@ -750,22 +750,22 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > >   			if (!ret)
> > >   				continue;
> > >   		}
> > > -		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
> > > +		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, &devs_in_pkg);
> > >   		if (phy_reg < 0)
> > >   			return -EIO;
> > >   	}
> > > -	if ((*devs & 0x1fffffff) == 0x1fffffff) {
> > > +	if ((devs_in_pkg & 0x1fffffff) == 0x1fffffff) {
> > >   		/* If mostly Fs, there is no device there, then let's probe
> > >   		 * MMD 0, as some 10G PHYs have zero Devices In package,
> > >   		 * e.g. Cortina CS4315/CS4340 PHY.
> > >   		 */
> > > -		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, 0, devs);
> > > +		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, 0, &devs_in_pkg);
> > >   		if (phy_reg < 0)
> > >   			return -EIO;
> > >   		/* no device there, let's get out of here */
> > > -		if ((*devs & 0x1fffffff) == 0x1fffffff) {
> > > +		if ((devs_in_pkg & 0x1fffffff) == 0x1fffffff) {
> > >   			*phy_id = 0xffffffff;
> > >   			return 0;
> > >   		}
> > > @@ -773,7 +773,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > >   	/* Now probe Device Identifiers for each device present. */
> > >   	for (i = 1; i < num_ids; i++) {
> > > -		if (!(c45_ids->devices_in_package & (1 << i)))
> > > +		if (!(devs_in_pkg & (1 << i)))
> > >   			continue;
> > >   		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID1);
> > > @@ -786,6 +786,9 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > >   			return -EIO;
> > >   		c45_ids->device_ids[i] |= phy_reg;
> > >   	}
> > > +
> > > +	c45_ids->devices_in_package = devs_in_pkg;
> > > +
> > >   	*phy_id = 0;
> > >   	return 0;
> > >   }
> > > 
> > 
> > You have solved the case of 0xFFFFFFFFF devices in package, but It looks
> > like the case of devs in package = 0  still gets a successful return from
> > this path. Which can still create phys with phy_id=0 and 0 MMDs AFAIK.
> 
> Correct - I'm not looking to change the behaviour in this patch
> beyond the intended change of ensuring that c45_ids->devices_in_package
> remains untouched until we intend to return successfully.
> 
> The zero MMDs issue is an entirely orthogonal problem not addressed
> in this series.

Please note that this problem has existed back to the original addition
of clause 45 support in this commit:

commit ac28b9f8cd66d6bc54f8063df59e99abd62173a4
Author: David Daney <david.daney@cavium.com>
Date:   Wed Jun 27 07:33:35 2012 +0000

I think it only becomes a problem when we start autoprobing clause 45
PHYs.

The scanning in __mdiobus_register() does not support locating a
clause 45 PHY - it only issues clause 22 cycles.  If you are lucky
enough to have a clause 45 PHY that responds to clause 22 cycles,
then the PHY device will be created using the information in the
clause 22 registers.  get_phy_device() is called with is_c45 false.
Hence, the path above will not be used.

The only way for a clause 45 PHY to be created is explicitly via
some method - either through DT declaring a C45 PHY, or via a driver
calling get_phy_device() with is_c45 true.  There are two ethernet
drivers which do this in drivers/net, using explicit addresses
rather than autoprobing.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
