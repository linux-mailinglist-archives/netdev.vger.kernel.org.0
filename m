Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9B51DFAA2
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 21:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgEWTMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 15:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgEWTMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 15:12:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0AEC061A0E;
        Sat, 23 May 2020 12:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PfgrFVlAaSeTY1/+5Re/jZhVxFrS69PnN73A93jIh5w=; b=rrnT3QUMfPrRa2GLlfKCFdjVc
        RbQgUGc0yls3rSCCMZPNole5gV3brCtdez17rC1uKKEmxrlIdA8nzNEsT+l7L3nsmsyPveXvslLy/
        FsqFU9AsUtphpcTevP4bb3fEzYnraabK3HWl0LuIwoBNnaetrJcMEfct456nsgXb4zFgo2G3T5qOv
        EnmB0gzVe7O/iPTv/mx1R04uSE8i2iV0F42nWRE05Uk5AXnj/dNfjwwSibXiEWGg1E7xG6JSnPnzq
        6Y8TbXIIKERwU5EMrgrbhVrzez6owO7iICdRX/28wtKr8TfHV8tSRqLltNxSCNTUPwaeJwwe61UXZ
        nCTgcjZxw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:33602)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jcZZL-0000YF-Mn; Sat, 23 May 2020 20:12:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jcZZJ-0002Vu-71; Sat, 23 May 2020 20:12:25 +0100
Date:   Sat, 23 May 2020 20:12:25 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 03/11] net: phy: refactor c45 phy identification sequence
Message-ID: <20200523191225.GC1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-4-jeremy.linton@arm.com>
 <20200523152800.GM610998@lunn.ch>
 <54e6a5d3-3d98-7cd4-3622-ab5019725979@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54e6a5d3-3d98-7cd4-3622-ab5019725979@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 23, 2020 at 12:32:59PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/23/20 10:28 AM, Andrew Lunn wrote:
> > On Fri, May 22, 2020 at 04:30:51PM -0500, Jeremy Linton wrote:
> > > Lets factor out the phy id logic, and make it generic
> > > so that it can be used for c22 and c45.
> > > 
> > > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > > ---
> > >   drivers/net/phy/phy_device.c | 65 +++++++++++++++++++-----------------
> > >   1 file changed, 35 insertions(+), 30 deletions(-)
> > > 
> > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > index 7746c07b97fe..f0761fa5e40b 100644
> > > --- a/drivers/net/phy/phy_device.c
> > > +++ b/drivers/net/phy/phy_device.c
> > > @@ -695,6 +695,29 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
> > >   	return 0;
> > >   }
> > > +static int _get_phy_id(struct mii_bus *bus, int addr, int dev_addr,
> > > +		       u32 *phy_id, bool c45)
> > 
> > Hi Jeremy
> > 
> > How about read_phy_id() so you can avoid the _ prefix.
> > 
> > >   static bool valid_phy_id(int val)
> > >   {
> > >   	return (val > 0 && ((val & 0x1fffffff) != 0x1fffffff));
> > > @@ -715,17 +738,17 @@ static bool valid_phy_id(int val)
> > >    */
> > >   static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > >   			   struct phy_c45_device_ids *c45_ids) {
> > > -	int phy_reg;
> > > -	int i, reg_addr;
> > > +	int ret;
> > > +	int i;
> > >   	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
> > >   	u32 *devs = &c45_ids->devices_in_package;
> > >   	/* Find first non-zero Devices In package. Device zero is reserved
> > >   	 * for 802.3 c45 complied PHYs, so don't probe it at first.
> > >   	 */
> > > -	for (i = 1; i < num_ids && *devs == 0; i++) {
> > > -		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
> > > -		if (phy_reg < 0)
> > > +	for (i = 0; i < num_ids && *devs == 0; i++) {
> > > +		ret = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
> > > +		if (ret < 0)
> > >   			return -EIO;
> > 
> > Renaming reg_addr to ret does not belong in this patch.
> > 
> 
> Looks like I changed the loop index in this patch while shuffling things
> around yesterday too. The "for (i = 1/0.." change belongs in 5/11 as well.

Indeed; that's a change of behaviour - see the CS4315/CS4340 workaround.

Note that MMD 0 is explicitly marked "Reserved" in 802.3, so we
shouldn't be probing it in this way.

Also note that bit 0 of the "devices in package" does not mean that
MMD 0 is accessible; it means that the clause 22 registers are
present:

  "Bit 5.0 is used to indicate that Clause 22 functionality has been
  implemented within a Clause 45 electrical interface device."

which basically means Clause 22 protocol over Clause 45 electrical
interface.

So, we should be careful about poking in MMD 0 if 5.0 is set.

Some places that will break are:

- phylink_phy_read() / phylink_phy_write()

- phy_restart_aneg() / phy_config_aneg() if we have an clause 45
  MDIO interface that can't issue clause 22 MDIO cycles with a PHY
  that sets 5.0.

These comments apply more to your patch 4, but you brought up the
MMD 0 accesses in this patch, so I thought I'd provide it here.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
