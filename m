Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273D52F67A1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbhANR2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbhANR2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:28:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A18CC061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 09:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=C0ZKt54n1bqGIa4Z3eyYv1CgjOiIMJ+DV8U88FoM7WI=; b=TmXk7aOXGBz03bt4FcYcOUU/A
        XPM5Ol6zKlqDs/IvB/gU60ZOtrA3fURBrwOH2wVhDs6aCkbFj/GAZRD8Y30erGU6ydlKR/kgPJrWI
        L7vjGwWmaImAvZBANdNi2KsmYpQKdtj7HgzP6XO4ZMoAov2h4p3JSloTva76v00gzeRfTwJ2ocHKI
        yLuLz32E2Z4yS7b6aLIxIoeLdcbc6iMDbX5d7yN9+ufkkvUkGtOZui/ynB+rtvxhC/7OLzOp+WxBj
        35XHpvAZpRCZunaohNn5p9UEI/qdy3NiJ6cOvZofm3EkezmyZowKe7fWLGwCUcGmFnwBzELipVvVX
        LTXK30Npg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47958)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l06PB-0002kD-Lb; Thu, 14 Jan 2021 17:27:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l06PB-00005L-Aj; Thu, 14 Jan 2021 17:27:29 +0000
Date:   Thu, 14 Jan 2021 17:27:29 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210114172729.GQ1605@shell.armlinux.org.uk>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
 <X/sszQBPDHehtQWM@lunn.ch>
 <20210114170942.GW1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114170942.GW1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 05:09:42PM +0000, Russell King - ARM Linux admin wrote:
> On Sun, Jan 10, 2021 at 05:35:25PM +0100, Andrew Lunn wrote:
> > On Sun, Jan 10, 2021 at 11:13:44AM +0000, Russell King wrote:
> > > Check whether the MAC driver has implemented the get_ts_info()
> > > method first, and call it if present.  If this method returns
> > > -EOPNOTSUPP, defer to the phylib or default implementation.
> > > 
> > > This allows network drivers such as mvpp2 to use their more accurate
> > > timestamping implementation than using a less accurate implementation
> > > in the PHY. Network drivers can opt to defer to phylib by returning
> > > -EOPNOTSUPP.
> > > 
> > > This change will be needed if the Marvell PHY drivers add support for
> > > PTP.
> > > 
> > > Note: this may cause a change for any drivers that use phylib and
> > > provide get_ts_info(). It is not obvious if any such cases exist.
> > 
> > Hi Russell
> > 
> > We can detect that condition through? Call both, then do a WARN() if
> > we are changing the order? Maybe we should do that for a couple of
> > cycles?
> 
> I guess we could do something, but IMHO this really does not justify
> using heavy hammers like WARN(). It's pointless producing a backtrace.
> If we want a large noisy multi-line message that stands out, we should
> just do that.
> 
> I think we can detect with something like:
> 
> 	if (ops->get_ts_info && phy_has_tsinfo(phydev)) {
> 		netdev_warn(dev, "Both the PHY and the MAC support PTP. Which you end up with may change.\n");
> 	}
> 
> That said, this is _actually_ a fix.
> 
> As the code stands today:
> 
> __ethtool_get_ts_info() checks phy_has_tsinfo() and uses phy_ts_info()
> in preference to ops->get_ts_info(), giving the PHY code first dibs on
> intercepting this call.
> 
> Meanwhile, the ioctl() code gives the network driver first dibs on
> intercepting the SIOCSHWTSTAMP and SIOCGHWTSTAMP ioctls.
> 
> This means that if you have both a PHY supporting timestamping, and a
> MAC driver, you end up with the ethtool get_ts_info() call giving a
> response from the PHY implementation but SIOCSHWTSTAMP and
> SIOCGHWTSTAMP being intercepted by the MAC implementation.
> 
> This is exactly what will happen today to mvpp2 if we merge my patches
> adding PTP support to the Marvell 88e151x PHYs without this patch.
> 
> So, my patch merely brings consistency to this.
> 
> > For netlink ethtool, we can also provide an additional attribute. A
> > MAC, or PHY indicator we can do in the core. A string for the name of
> > the driver would need a bigger change.
> 
> Unfortunately, PTP is not solely controlled through ethtool - it's
> also controlled via ioctl() where it's not so easy to direct the
> calls to either the MAC or PHY.

BTW, none of this is new informationm we're just re-covering the same
points that were already discussed back in July 2020:

https://lore.kernel.org/netdev/20200729105807.GZ1551@shell.armlinux.org.uk/

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
