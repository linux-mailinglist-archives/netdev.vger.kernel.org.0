Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125B13165C9
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhBJL5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhBJLy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:54:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09E6C061756;
        Wed, 10 Feb 2021 03:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OmYUKKN9uN+7YYNFuulRwO/nSJIKxc8GX+ietg4bF6U=; b=WMN95oqUKQGH3YtBOCm6BlAu5
        YX1yDNoo+qxDmI7vrXvREGVucPPwM22WS8khNbOjwFJJGadkoP/OkARe70lVGksYGEtYlPiVC5lAn
        X2h5pV7BSp4bqFgsN3sb29xu9T2L2UO/K6wkXkdsLN66vcwE0SiSeS08yAHrZ7K9ygiTTr3pwhBHh
        /WjKrNS3FNtZvTDHAOYvhhjgXGhInNeAMz6NQvO2NXzrhVvkPdAsnwZfVIkZ/xbmBpw4QYeiv6nIx
        aULxVz87h7T/8rJr4n9uNo96NaHFXScUx2Jkr3Ntz+kdesFqyGgPRuIPPLKtu/AK/SzjxT3xHUy9+
        rvRnmL/TQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41590)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l9o4W-0004cd-GB; Wed, 10 Feb 2021 11:54:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l9o4W-00052Y-2k; Wed, 10 Feb 2021 11:54:16 +0000
Date:   Wed, 10 Feb 2021 11:54:16 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: introduce phydev->port
Message-ID: <20210210115415.GV1463@shell.armlinux.org.uk>
References: <20210209163852.17037-1-michael@walle.cc>
 <41e4f35c87607e69cb87c4ef421d4a77@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41e4f35c87607e69cb87c4ef421d4a77@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:20:02PM +0100, Michael Walle wrote:
> 
> Am 2021-02-09 17:38, schrieb Michael Walle:
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -308,7 +308,7 @@ void phy_ethtool_ksettings_get(struct phy_device
> > *phydev,
> >  	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
> >  		cmd->base.port = PORT_BNC;
> >  	else
> > -		cmd->base.port = PORT_MII;
> > +		cmd->base.port = phydev->port;
> >  	cmd->base.transceiver = phy_is_internal(phydev) ?
> >  				XCVR_INTERNAL : XCVR_EXTERNAL;
> >  	cmd->base.phy_address = phydev->mdio.addr;
> 
> Russell, the phylink has a similiar place where PORT_MII is set. I don't
> know if we'd have to change that, too.

What would we change it to?

If there's no PHY attached and no SFP, what kind of interface do we
have? As we've no idea what's on the media side, assuming that we are
presenting a MII-like interface to stuff outside of what we control is
entirely reasonable.

Claiming the world is TP would be entirely wrong, there may not be a
RJ45 jack. Consider the case where the MAC is connected to a switch.
It's a MII-like link. It's certianly not TP, BNC, fiber, AUI, or
direct attach.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
