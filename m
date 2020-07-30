Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90C9233881
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 20:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgG3SiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 14:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgG3SiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 14:38:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A046C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 11:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wkAVRrZkmHT7NF8O4fgnNubz4Hh/zjXQQsV4ifg8mhg=; b=Mj0nAcJakMPlOG5ysW9Z7z2oT
        L8L8v9cdogU6T8x8ZdXTye0YUXh+SIAEaaPfKekbtMnssDel0tag7GxGx+EC1yh2L6EDQEaonLfuL
        8HfUrCJIveMlAq4MyFWFfCsjfXvB+JaXEGFv+vh+SqzucDv/Kcdi409h62BB4Ihd26XuHZXPUA3yE
        LziWxb7Jw+xZW1t86MZvb3gPj0nHXCVcFPUqJw1OtvZD5KL08TCMJ6wW60dXcCoz3QO35KOzHkOR8
        JfUlW1pZRlRHRlrF/blvxl3/CrkCNeDNNA8/dUZt9tGVSgoYURd8b9QN7Fk9lO6oXm3x7oJ4Odnr+
        LWf6krXKw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46204)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k1DRL-0006ly-6U; Thu, 30 Jul 2020 19:38:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k1DRI-0006y9-KT; Thu, 30 Jul 2020 19:38:00 +0100
Date:   Thu, 30 Jul 2020 19:38:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200730183800.GD1551@shell.armlinux.org.uk>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20200729131932.GA23222@hoboy>
 <20200729132832.GA1551@shell.armlinux.org.uk>
 <20200729220748.GW1605@shell.armlinux.org.uk>
 <20200730155326.GB28298@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730155326.GB28298@hoboy>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 08:53:26AM -0700, Richard Cochran wrote:
> On Wed, Jul 29, 2020 at 11:07:48PM +0100, Russell King - ARM Linux admin wrote:
> > What I see elsewhere in ethtool is that the MAC has the ability to
> > override the phylib provided functionality - for example,
> > __ethtool_get_sset_count(), __ethtool_get_strings(), and
> > ethtool_get_phy_stats().  Would it be possible to do the same in
> >  __ethtool_get_ts_info(), so at least a MAC driver can then decide
> > whether to propagate the ethtool request to phylib or not, just like
> > it can do with the SIOC*HWTSTAMP ioctls?  Essentially, reversing the
> > order of:
> > 
> >         if (phy_has_tsinfo(phydev))
> >                 return phy_ts_info(phydev, info);
> >         if (ops->get_ts_info)
> >                 return ops->get_ts_info(dev, info);
> > 
> > ?
> 
> I don't see a simple solution.  I think no matter what, the MAC
> drivers need work to allow PHY time stamping, and the great majority
> of users and driver authors are happy with MAC time stamping.

What I ended up doing was:

        if (ops->get_ts_info) {
                ret = ops->get_ts_info(dev, info);
                if (ret != -EOPNOTSUPP)
                        return ret;
        }
        if (phy_has_tsinfo(phydev))
                return phy_ts_info(phydev, info);
...

which gives the MAC first refusal.  If the MAC wishes to defer to
phylib or the default, it can just return -EOPNOTSUPP.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
