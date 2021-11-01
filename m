Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC20044211B
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 20:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhKAT4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 15:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhKAT4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 15:56:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A97CC061714;
        Mon,  1 Nov 2021 12:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kTP1kzYzsuNb9PW9Qk1GWCP8YDGKxdsWpDJnOqiZhRY=; b=fXOOgYqpn1JxbyOAHF99eGG+Gp
        Qm6E34mFnfR4WRzBNUdG6nXUwy2YvqyZ4qoyCSmpuujxf96IK0cnXC5U/W3H7NJtNXNVdzCKIJm8D
        WJoc5+jX9FX05jpTAcvVJl3tFsVM9m/w3/xzg4uFsbuO3N6OG2snxgUJa5cp/du0ACG4GShl9iXyG
        tK9uHtanG6XAXr1SHBsEPBh63rhl8PBAmuG3okbpUvZgE3i6uZVmYWrxxM9PIoeqazQ57vXPhxj/w
        rGH3dp0+RrRzRCv/cdohVdIt8AOXskY0UvWsU1rh7cz5IsG/kL7vgP+89WiQlThqROiHFo0pqA8dk
        nydkzFUw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55420)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mhdNe-00034a-Ew; Mon, 01 Nov 2021 19:54:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mhdNc-0004f4-HN; Mon, 01 Nov 2021 19:54:04 +0000
Date:   Mon, 1 Nov 2021 19:54:04 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
Message-ID: <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYBBHsFEwGdPJw3b@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 08:33:50PM +0100, Andrew Lunn wrote:
> On Mon, Nov 01, 2021 at 08:28:59PM +0200, Grygorii Strashko wrote:
> > This patch enables access to C22 PHY MMD address space through
> 
> I'm not sure the terminology is correct here. I think it actually
> enables access to C45 address space, making use of C45 over C22.

I agree.

> > phy_mii_ioctl() SIOCGMIIREG/SIOCSMIIREG IOCTLs. It checks if R/W request is
> > received with C45 flag enabled while MDIO bus doesn't support C45 and, in
> > this case, tries to treat prtad as PHY MMD selector and use MMD API.
> > 
> > With this change it's possible to r/w PHY MMD registers with phytool, for
> > example, before:
> > 
> >   phytool read eth0/0x1f:0/0x32
> >   0xffea
> > 
> > after:
> >   phytool read eth0/0x1f:0/0x32
> >   0x00d1
> > @@ -300,8 +300,19 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
> >  			prtad = mii_data->phy_id;
> >  			devad = mii_data->reg_num;
> >  		}
> > -		mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad,
> > -						 devad);
> > +		if (mdio_phy_id_is_c45(mii_data->phy_id) &&
> > +		    phydev->mdio.bus->probe_capabilities <= MDIOBUS_C22) {
> > +			phy_lock_mdio_bus(phydev);
> > +
> > +			mii_data->val_out = __mmd_phy_read(phydev->mdio.bus,
> > +							   mdio_phy_id_devad(mii_data->phy_id),
> > +							   prtad,
> > +							   mii_data->reg_num);
> > +
> > +			phy_unlock_mdio_bus(phydev);
> > +		} else {
> > +			mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad, devad);
> > +		}
> 
> The layering look wrong here. You are trying to perform MDIO bus
> operation here, so it seems odd to perform __mmd_phy_read(). I wonder
> if it would be cleaner to move C45 over C22 down into the mdiobus_
> level API?

The use of the indirect registers is specific to PHYs, and we already
know that various PHYs don't support indirect access, and some emulate
access to the EEE registers - both of which are handled at the PHY
driver level. Pushing indirect MMD access down into the MDIO bus layer
means we need to have some way to deal with that.

Alternatively, if we're just thinking about moving, e.g.:

	if (phydev->is_c45) {
                val = __mdiobus_c45_read(phydev->mdio.bus, phydev->mdio.addr,
                                         devad, regnum);
        } else {
                struct mii_bus *bus = phydev->mdio.bus;
                int phy_addr = phydev->mdio.addr;

                mmd_phy_indirect(bus, phy_addr, devad, regnum);

                /* Read the content of the MMD's selected register */
                val = __mdiobus_read(bus, phy_addr, MII_MMD_DATA);
        }

We would need to have some way to deal with that "is_c45" flag at
mdio device level (maybe moving it to the mdio_device structure).
Still doesn't help the "phy driver emulates the accesses" problem
though.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
