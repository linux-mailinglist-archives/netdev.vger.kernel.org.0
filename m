Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB4B1DFACD
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 21:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387938AbgEWTvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 15:51:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46550 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbgEWTvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 15:51:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PFCyc6acPZlxNiaaAXGg8gqtKeEybE/CLvO7b+Q8cE4=; b=kbdB0YripATEiV0bY55/9sjWnK
        yYYhM6/eL8pnSLvbU5zj1rSN/hsHT4Hd7okI+l49su85WWOyI8kecLdgkICwjFPPv9mDrW0a1sEGY
        G4gNZrO/7DaqsoJDT2D3/J/crUfDSFS1GaxfIXGV18ulH9MIzvwWQMbD5BRKW4OX7Dqg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jcaB9-0035FH-I5; Sat, 23 May 2020 21:51:31 +0200
Date:   Sat, 23 May 2020 21:51:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 03/11] net: phy: refactor c45 phy identification sequence
Message-ID: <20200523195131.GN610998@lunn.ch>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-4-jeremy.linton@arm.com>
 <20200523183058.GX1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523183058.GX1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >  static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
> >  			   struct phy_c45_device_ids *c45_ids) {
> > -	int phy_reg;
> > -	int i, reg_addr;
> > +	int ret;
> > +	int i;
> >  	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
> >  	u32 *devs = &c45_ids->devices_in_package;
> 
> I feel a "reverse christmas tree" complaint brewing... yes, the original
> code didn't follow it.  Maybe a tidy up while touching this code?

At minimum, a patch should not make it worse. ret and i should clearly
be after devs.

> >  static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
> >  		      bool is_c45, struct phy_c45_device_ids *c45_ids)
> >  {
> > -	int phy_reg;
> > +	int ret;
> >  
> >  	if (is_c45)
> >  		return get_phy_c45_ids(bus, addr, phy_id, c45_ids);
> >  
> > -	/* Grab the bits from PHYIR1, and put them in the upper half */
> > -	phy_reg = mdiobus_read(bus, addr, MII_PHYSID1);
> > -	if (phy_reg < 0) {
> > +	ret = _get_phy_id(bus, addr, 0, phy_id, false);
> > +	if (ret < 0) {
> >  		/* returning -ENODEV doesn't stop bus scanning */
> > -		return (phy_reg == -EIO || phy_reg == -ENODEV) ? -ENODEV : -EIO;
> > +		return (ret == -EIO || ret == -ENODEV) ? -ENODEV : -EIO;
> 
> Since ret will only ever be -EIO here, this can only ever return
> -ENODEV, which is a functional change in the code (probably unintended.)
> Nevertheless, it's likely introducing a bug if the intention is for
> some other return from mdiobus_read() to be handled differently.
> 
> >  	}
> >  
> > -	*phy_id = phy_reg << 16;
> > -
> > -	/* Grab the bits from PHYIR2, and put them in the lower half */
> > -	phy_reg = mdiobus_read(bus, addr, MII_PHYSID2);
> > -	if (phy_reg < 0)
> > -		return -EIO;
> 
> ... whereas this one always returns -EIO on any error.
> 
> So, I think you have the potential in this patch to introduce a subtle
> change of behaviour, which may lead to problems - have you closely
> analysed why the code was the way it was, and whether your change of
> behaviour is actually valid?

I could be remembering this wrongly, but i think this is to do with
orion_mdio_xsmi_read() returning -ENODEV, not 0xffffffffff, if there
is no device on the bus at the given address. -EIO is fatal to the
scan, everything stops with the assumption the bus is broken. -ENODEV
should not be fatal to the scan.

   Andrew
