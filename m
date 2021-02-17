Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517A131D781
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhBQKXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbhBQKWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 05:22:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C40C061574;
        Wed, 17 Feb 2021 02:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=moQ0K1ybjmFAChqM3PVggT6XITk45iTZJYuoxQXEgdo=; b=v/6b0cej0F9Ox3+XoClr3+x/2
        Vrm3miaNkzAGaywJwwFU5E7HzCQnv8K5IR8DVYZv0BZD/IFl1CLEdXjKQIrPKT+u9t+NT1/LKg0CN
        fE6hfg8xF1A8BJFjHz3ACXveWYjw42tED0FtGX/c71zCgw6+MdM1LttQ/FpcYq4CukN+/ECgnFbYF
        mQYkKMt06atEEKCvKvSVOLjqVd9ZWgxOBtNYwxHQuupcJ4n7sGDfwsBbpcFN7YB4othFtxE3tgkm5
        aMkRMZZhFMeFCznmsRnqJboRvyaik6K+Y5i6yKWAV+5sfgmrPygt86+2YkrJ+dA+uLLpjH6/FHBjo
        PhhhEH+Pg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44558)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lCJy3-0002WT-N5; Wed, 17 Feb 2021 10:21:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lCJy2-0003fD-TX; Wed, 17 Feb 2021 10:21:58 +0000
Date:   Wed, 17 Feb 2021 10:21:58 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: icplus: Call phy_restore_page() when
 phy_select_page() fails
Message-ID: <20210217102158.GE1463@shell.armlinux.org.uk>
References: <YCy1F5xKFJAaLBFw@mwanda>
 <20210217100420.GD1463@shell.armlinux.org.uk>
 <6a7032cea19b8798176012f128f4977a@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a7032cea19b8798176012f128f4977a@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 11:12:11AM +0100, Michael Walle wrote:
> Am 2021-02-17 11:04, schrieb Russell King - ARM Linux admin:
> > On Wed, Feb 17, 2021 at 09:17:59AM +0300, Dan Carpenter wrote:
> > > Smatch warns that there is a locking issue in this function:
> > > 
> > > drivers/net/phy/icplus.c:273 ip101a_g_config_intr_pin()
> > > warn: inconsistent returns '&phydev->mdio.bus->mdio_lock'.
> > >   Locked on  : 242
> > >   Unlocked on: 273
> > > 
> > > It turns out that the comments in phy_select_page() say we have to
> > > call
> > > phy_restore_page() even if the call to phy_select_page() fails.
> > 
> > It seems it's a total waste of time documenting functions...
> 
> You once said
> 
> """
> Kernel development is fundamentally a difficult, frustrating and
> depressing activity.
> """
> 
> But really this comment doesn't make it much better. Yes I've made
> a mistake although I _read_ the function documentation. So shame on
> me.

It wasn't aimed at you - it was more pointing out that in the normal
process of kernel development, reading documentation is fairly low,
yet we spend time creating it. So, does writing documentation actually
help, or does it just slow down the development cycle? Does it have a
net positive value? Personally, I don't think it does.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
