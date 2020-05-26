Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A751E25E4
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgEZPqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbgEZPqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:46:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F71C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sxNmYmV0IYPudK58d4p/I69fRiY3x5KyBE6/1i6Pti0=; b=xpkECbh2L46+B2Eq2ZtGy1t9C
        qoaeCOnGkthQ2OOBS4Pup0VM/poz90e6Il86n8LIJKDUOZAtKhP829eU/rlYf1Zc1+dTiE4SSpLh+
        eUKatoPISD3H8P+TcuBhgl0JwfqwTcZff+yb5TNmTg3GbvPvVa1THIeWSTp311/CMXU2dgGmfd6at
        Kmhx2vuPE82A7AhPu+tMyKFpDmcRMio/buJ3N0G4sBw6aAfgEdbIfim+ch8ezBxuwQbqOSU8J1il0
        GCFIJ2SICja367AXOSaYunJlJGPBzNAcCOAFtZu1yP44lbOXb4Jrk/DMzkyxVjGgt4rL87VRtKIyU
        wkJcAdOjw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45338)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdbmD-0008DZ-Ah; Tue, 26 May 2020 16:46:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdbmC-0005VR-Ky; Tue, 26 May 2020 16:46:00 +0100
Date:   Tue, 26 May 2020 16:46:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 7/7] net: phy: read MMD ID from all present MMDs
Message-ID: <20200526154600.GC1551@shell.armlinux.org.uk>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdac8-0005tC-3o@rmk-PC.armlinux.org.uk>
 <5bce099a-1bbe-d3ee-7cc1-50ff5e8e25ca@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bce099a-1bbe-d3ee-7cc1-50ff5e8e25ca@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 10:35:46AM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/26/20 9:31 AM, Russell King wrote:
> > Expand the device_ids[] array to allow all MMD IDs to be read rather
> > than just the first 8 MMDs, but only read the ID if the MDIO_STAT2
> > register reports that a device really is present here for these new
> > devices to maintain compatibility with our current behaviour.
> > 
> > 88X3310 PHY vendor MMDs do are marked as present in the
> > devices_in_package, but do not contain IEE 802.3 compatible register
> > sets in their lower space.  This avoids reading incorrect values as MMD
> > identifiers.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >   drivers/net/phy/phy_device.c | 14 ++++++++++++++
> >   include/linux/phy.h          |  2 +-
> >   2 files changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 1c948bbf4fa0..92742c7be80f 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -773,6 +773,20 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> >   		if (!(devs_in_pkg & (1 << i)))
> >   			continue;
> > +		if (i >= 8) {
> > +			/* Only probe the MMD ID for MMDs >= 8 if they report
> > +			 * that they are present. We have at least one PHY that
> > +			 * reports MMD presence in devs_in_pkg, but does not
> > +			 * contain valid IEEE 802.3 ID registers in some MMDs.
> > +			 */
> > +			ret = phy_c45_probe_present(bus, addr, i);
> > +			if (ret < 0)
> > +				return ret;
> > +
> > +			if (!ret)
> > +				continue;
> > +		}
> > +
> >   		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID1);
> >   		if (phy_reg < 0)
> >   			return -EIO;
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 0d41c710339a..3325dd8fb9ac 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -361,7 +361,7 @@ enum phy_state {
> >   struct phy_c45_device_ids {
> >   	u32 devices_in_package;
> >   	u32 mmds_present;
> > -	u32 device_ids[8];
> > +	u32 device_ids[MDIO_MMD_NUM];
> 
> You have a array overflow/invalid access if you don't do this earlier in
> 4/7.

I'm very sorry, but you are mistaken - there is no overflow.

The overflow would happen if I'd changed the _second_ loop in
get_phy_c45_ids(), but that still relies upon the size of this
array.  In fact, everywhere that the device_ids array is indexed
with a for() loop, the maximum bound is defined by the element
size of the array.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
