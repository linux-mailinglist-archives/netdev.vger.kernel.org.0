Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8845233935
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgG3Toj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3Toj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:44:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDF7C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=U5U5IcfGf3U48jrB2+2tkJslfLNYAkamEuHKN39AE4g=; b=PCzlq1qN1bmDpzgPE2Rvy39sJ
        vjQWCBqeR/iyJ2synlTE0CFwcjMUu6jLhrulkNXfnyS396YjTKbVdEMC2FuQYwE5lJuCxcqYLBbAW
        zHyk0NawORylfgIhXLtmmEnxEz+Uad0Y1ghK293l/9Q4DHVET1a+dG/3MLsG0FqKsTWlqs+bYXAv9
        6tDD6+fm4OibghTvi7Crp2lLu3vHABGmlVuVOaAYtUGqCW1CTKwc11o/rz/s/bS3rIynphH5OOk5o
        k9AnV8oOSeiuqtHyrp6aqh6jjYvxyurfDTufbIJM+h94O7OE4aj7Jacw1XrmoZK4MimF55mFgk3Hi
        r1L88pmVw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46222)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k1ETe-0006oJ-BO; Thu, 30 Jul 2020 20:44:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k1ETb-000725-RC; Thu, 30 Jul 2020 20:44:27 +0100
Date:   Thu, 30 Jul 2020 20:44:27 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200730194427.GE1551@shell.armlinux.org.uk>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20200729131932.GA23222@hoboy>
 <20200729132832.GA1551@shell.armlinux.org.uk>
 <20200729220748.GW1605@shell.armlinux.org.uk>
 <20200730155326.GB28298@hoboy>
 <20200730183800.GD1551@shell.armlinux.org.uk>
 <20200730193245.GB6621@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730193245.GB6621@hoboy>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 12:32:45PM -0700, Richard Cochran wrote:
> On Thu, Jul 30, 2020 at 07:38:00PM +0100, Russell King - ARM Linux admin wrote:
> > What I ended up doing was:
> > 
> >         if (ops->get_ts_info) {
> >                 ret = ops->get_ts_info(dev, info);
> >                 if (ret != -EOPNOTSUPP)
> >                         return ret;
> >         }
> >         if (phy_has_tsinfo(phydev))
> >                 return phy_ts_info(phydev, info);
> > ...
> > 
> > which gives the MAC first refusal.  If the MAC wishes to defer to
> > phylib or the default, it can just return -EOPNOTSUPP.
> 
> I guess that makes sense.  If someone designs a board that happens to
> have a PHY with unwanted time stamping fcunctionality, then at least
> the MAC time stamping function will work.  If the designers really
> want PHY time stamping, then they are likely to have to patch the MAC
> driver in any case.
> 
> So I'm not against such a change.  It would be important to keep the
> current "PHY-friendly" MAC drivers still friendly, and so they would
> need patching as part of the change.

That would only be necessary if they also provide the get_ts_info
method.

So, I guess I need to find all drivers that refer to phylink or phylib
functions, that also implement get_ts_info method and review them.
I would expect that to be very small, since there's currently little
point implementing PTP at both the PHY and the MAC for the reason I've
raised earlier in this thread.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
