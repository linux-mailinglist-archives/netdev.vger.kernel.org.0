Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBDD232754
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 00:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgG2WIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 18:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgG2WIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 18:08:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9823CC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 15:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CTQkp/TDoWR+g/t3QQAaVCVbDsEuOL1z2OgYhy5QDME=; b=ql2s0Dw3xsLL64Tc1Xo+Ye8GV
        xZeg3/mVAm1mW6ZlLs5NEiT3tJopzMF+oJes1WwBQMeP3f+8oleK7Jc05hy4iRF5/u2Tu3442E0G/
        /aXFer+GW+OiaaR9iHGITxMQOVopnIlzXRMDsBNspH/J4ESfL7zIob3PnlwBF+CpchKXMw4FEwHDH
        vj4oD1mXeFSHUyMnLIqFAWknoTWDrXbabv7ajAC2wyP+veyT2khWg/X02gC8L3jRT6nuOZkWjXWSc
        Y4JsO6PfREgjJV2X440ihG4BeMUs5ChWPQ5phCHVc0GAXdWPadV9GT0xGGM93S7A8v1DyYnITLX0R
        G7ySFNrdQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45842)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0uEr-0005om-9s; Wed, 29 Jul 2020 23:07:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0uEm-00061k-UW; Wed, 29 Jul 2020 23:07:48 +0100
Date:   Wed, 29 Jul 2020 23:07:48 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200729220748.GW1605@shell.armlinux.org.uk>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20200729131932.GA23222@hoboy>
 <20200729132832.GA1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729132832.GA1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 02:28:32PM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jul 29, 2020 at 06:19:32AM -0700, Richard Cochran wrote:
> > On Wed, Jul 29, 2020 at 11:58:07AM +0100, Russell King - ARM Linux admin wrote:
> > > How do we deal with this situation - from what I can see from the
> > > ethtool API, we have to make a choice about which to use.  How do we
> > > make that choice?
> > 
> > Unfortunately the stack does not implement simultaneous MAC + PHY time
> > stamping.  If your board has both, then you make the choice to use the
> > PHY by selecting NETWORK_PHY_TIMESTAMPING at kernel compile time.
> 
> Which is more or less what I said in my email.  However, the important
> question about how to select between the two, which is really what I'm
> after, has not been addressed.
> 
> > (Also some MAC drivers do not defer to the PHY properly.  Sometimes
> > you can work around that by de-selecting the MAC's PTP function in the
> > Kconfig if possible, but otherwise you need to patch the MAC driver.)
> 
> ... which really doesn't work if you have a board where only some
> network interfaces have a PHY with PTP support, but all have PTP
> support in the MAC.
> 
> If all MACs or the majority of MACs use a common PTP clock, it seems
> to me that you would want to use the MACs rather than the PHY,
> especially if the PHY doesn't offer as good a quality PTP clock as
> is available from the MAC.
> 
> Randomly patching the kernel is out of the question, for arm based
> systems we want one kernel that works correctly across as many
> platforms as possible, and Kconfig choices to set platform specific
> details are basically unacceptable, let alone patching the kernel to
> make those decisions.

The way PHY PTP support is handled is _really_ not nice.

If we have a phylib driver that supports timestamping, and a MAC driver
that also supports timestamping, then what we end up with is very
messed up.

1. The SIOCGHWTSTAMP/SIOCSHWTSTAMP calls are directed through
   ndo_do_ioctl().  The MAC driver gets first call on whether to
   intercept these or not.  See dev_ifsioc().

2. The ethtool ETHTOOL_GET_TS_INFO call, however, is given to the
   PHY in preference to the MAC driver - there is no way for the MAC
   driver to gain preference.  See __ethtool_get_ts_info().

So, if we have this situation (and yes, I do), then the SIOC*HWTSTAMP
calls get implemented by the MAC driver, and takes effect at the MAC
driver, while the ethtool ETHTOOL_GET_TS_INFO call returns results
from the PHY driver.

That means the MAC driver's timestamping will be controllable from
userspace, but userspace sees the abilities of the PHY driver's
timestamping, and potentially directed to the wrong PTP clock
instance.

What I see elsewhere in ethtool is that the MAC has the ability to
override the phylib provided functionality - for example,
__ethtool_get_sset_count(), __ethtool_get_strings(), and
ethtool_get_phy_stats().  Would it be possible to do the same in
 __ethtool_get_ts_info(), so at least a MAC driver can then decide
whether to propagate the ethtool request to phylib or not, just like
it can do with the SIOC*HWTSTAMP ioctls?  Essentially, reversing the
order of:

        if (phy_has_tsinfo(phydev))
                return phy_ts_info(phydev, info);
        if (ops->get_ts_info)
                return ops->get_ts_info(dev, info);

?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
