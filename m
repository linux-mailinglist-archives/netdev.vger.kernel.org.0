Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827DA1DFADD
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 22:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387930AbgEWUCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 16:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387893AbgEWUCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 16:02:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9D1C061A0E;
        Sat, 23 May 2020 13:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=j1ff5g6g6ztV3jNNgAfrfHjYUnntJgUcK2NdpyyQ1D0=; b=1Ar8F9SQGdd9pINkpWuadByHC
        qF3oozfiX5mGJkbqfMVvdijBhgE74/dmtTVyhskANu84hDvxDj+LgfNfMdHizaUsU5Bhn8QfMK1j4
        p/8+ELZGq88XNF8tlzl/hMKlmsNRtP1D8waM+qtBx/3/6RfmMPZOm5vHXwNu7rB2H1Nn2KAVprKya
        brm3pDSY/E2PnSdlB91hfThRnO+VmuOjhHe668mxRzXd96B0zP+JfM9s44xYjFxMZ4/b/ijADxchg
        NOZ0FO2Yj6xPdzxaBEDwi8GBH7Vv0YTx6hSVPkEqzG4fzbDxqOzyE/igcht1mGjs2mNWmVVL/JA5C
        g9EVMv6Ag==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36066)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jcaL5-0000cK-Sr; Sat, 23 May 2020 21:01:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jcaKz-0002YD-OO; Sat, 23 May 2020 21:01:41 +0100
Date:   Sat, 23 May 2020 21:01:41 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 03/11] net: phy: refactor c45 phy identification sequence
Message-ID: <20200523200141.GD1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-4-jeremy.linton@arm.com>
 <20200523183058.GX1551@shell.armlinux.org.uk>
 <20200523195131.GN610998@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523195131.GN610998@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 23, 2020 at 09:51:31PM +0200, Andrew Lunn wrote:
> > >  static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> > >  			   struct phy_c45_device_ids *c45_ids) {
> > > -	int phy_reg;
> > > -	int i, reg_addr;
> > > +	int ret;
> > > +	int i;
> > >  	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
> > >  	u32 *devs = &c45_ids->devices_in_package;
> > 
> > I feel a "reverse christmas tree" complaint brewing... yes, the original
> > code didn't follow it.  Maybe a tidy up while touching this code?
> 
> At minimum, a patch should not make it worse. ret and i should clearly
> be after devs.
> 
> > >  static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
> > >  		      bool is_c45, struct phy_c45_device_ids *c45_ids)
> > >  {
> > > -	int phy_reg;
> > > +	int ret;
> > >  
> > >  	if (is_c45)
> > >  		return get_phy_c45_ids(bus, addr, phy_id, c45_ids);
> > >  
> > > -	/* Grab the bits from PHYIR1, and put them in the upper half */
> > > -	phy_reg = mdiobus_read(bus, addr, MII_PHYSID1);
> > > -	if (phy_reg < 0) {
> > > +	ret = _get_phy_id(bus, addr, 0, phy_id, false);
> > > +	if (ret < 0) {
> > >  		/* returning -ENODEV doesn't stop bus scanning */
> > > -		return (phy_reg == -EIO || phy_reg == -ENODEV) ? -ENODEV : -EIO;
> > > +		return (ret == -EIO || ret == -ENODEV) ? -ENODEV : -EIO;
> > 
> > Since ret will only ever be -EIO here, this can only ever return
> > -ENODEV, which is a functional change in the code (probably unintended.)
> > Nevertheless, it's likely introducing a bug if the intention is for
> > some other return from mdiobus_read() to be handled differently.
> > 
> > >  	}
> > >  
> > > -	*phy_id = phy_reg << 16;
> > > -
> > > -	/* Grab the bits from PHYIR2, and put them in the lower half */
> > > -	phy_reg = mdiobus_read(bus, addr, MII_PHYSID2);
> > > -	if (phy_reg < 0)
> > > -		return -EIO;
> > 
> > ... whereas this one always returns -EIO on any error.
> > 
> > So, I think you have the potential in this patch to introduce a subtle
> > change of behaviour, which may lead to problems - have you closely
> > analysed why the code was the way it was, and whether your change of
> > behaviour is actually valid?
> 
> I could be remembering this wrongly, but i think this is to do with
> orion_mdio_xsmi_read() returning -ENODEV, not 0xffffffffff, if there
> is no device on the bus at the given address. -EIO is fatal to the
> scan, everything stops with the assumption the bus is broken. -ENODEV
> should not be fatal to the scan.

Maybe orion_mdio_xsmi_read() should be fixed then?  Also, maybe
adding return code documentation for mdiobus_read() / mdiobus_write()
would help MDIO driver authors have some consistency in what
errors they are expected to return (does anyone know for certain?)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
