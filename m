Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA2531DC53
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 16:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhBQPfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 10:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbhBQPeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 10:34:44 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD0DC061574;
        Wed, 17 Feb 2021 07:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=alvikSS3uPR/ie3MjZkev8maJ+BZ+uB0G91TvdSFQZo=; b=y6mGnSYbFfVg21XAFRhng+x6d
        wKwbwoROl1mC1dEBkbyMPQyUOnz2MsBzvTlYyL+aBQlqW+Xv3FZ4g2KjHoFOD0lnqd/H8R64tuQTo
        kUllwxu/8hYNslw2q9tKIqCFRu23lGcAhtF/VIfMoWjxSNFVuXJD8BDqkhPm7eYUYA7LSD1eRsT+d
        ouEGv5U987jCx4mqM70X4K9v4g2FIgLkdZxgBNnasJllkQcsVrhz61tOtAykccRgeBrij6ijsO1Z6
        dCaUVmGL2yD3+9IHmzWzVs5tzUI5fm01Ym1PCPU5KrMAmG3LJd1X7o6mrhm6Jju8kNFV4GZU0KSJ9
        oOeL9i+1Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44648)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lCOpy-0002iv-FM; Wed, 17 Feb 2021 15:33:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lCOpx-0003qX-Qz; Wed, 17 Feb 2021 15:33:57 +0000
Date:   Wed, 17 Feb 2021 15:33:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: icplus: Call phy_restore_page() when
 phy_select_page() fails
Message-ID: <20210217153357.GE1477@shell.armlinux.org.uk>
References: <YCy1F5xKFJAaLBFw@mwanda>
 <20210217142838.GM2222@kadam>
 <20210217150621.GG1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217150621.GG1463@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 03:06:21PM +0000, Russell King - ARM Linux admin wrote:
> On Wed, Feb 17, 2021 at 05:28:38PM +0300, Dan Carpenter wrote:
> > On Wed, Feb 17, 2021 at 09:17:59AM +0300, Dan Carpenter wrote:
> > > Smatch warns that there is a locking issue in this function:
> > > 
> > > drivers/net/phy/icplus.c:273 ip101a_g_config_intr_pin()
> > > warn: inconsistent returns '&phydev->mdio.bus->mdio_lock'.
> > >   Locked on  : 242
> > >   Unlocked on: 273
> > > 
> > > It turns out that the comments in phy_select_page() say we have to call
> > > phy_restore_page() even if the call to phy_select_page() fails.
> > > 
> > > Fixes: f9bc51e6cce2 ("net: phy: icplus: fix paged register access")
> > 
> > Don't apply this patch.  I have created a new Smatch warning for the
> > phy_select_page() behavior and it catches a couple similar bugs in the
> > same file.  I will send a v2 that fixes those as well.
> 
> Yes, there are three instances of this in the file, all three need
> fixing. Thanks.

I'm wondering whether we need to add __acquires() and __releases()
annotations to some of these functions so that sparse can catch
these cases. Thoughts?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
