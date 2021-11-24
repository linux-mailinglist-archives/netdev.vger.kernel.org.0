Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1784945CEDE
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 22:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243919AbhKXVYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 16:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhKXVYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 16:24:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C98C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 13:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FxGSAtHXWg9NgBwLSMa5lo9wBbWRfIVlILK4nDvCWog=; b=mouETFILzEXM59aRyXHe0hILZA
        782NVY1vh70ZpmGW1dnsrME3dbJnbYKSzVOehbYZaxrJzwyGBwehTnyCLlCw8ujNcEQ4YUOhSvCwJ
        EuU8BIkFpq5ueIKFv7+0z6bDNJcHGsPgD1E3hKBk02+fZHjnuX9mruhHQaqqVHPYeoXHfagzH88YL
        hcoInjU9Uz+tTtZMaJcImfybzl7AYLGGTWXIDodZe4VU0Ftvj3Vb6rFlvwYC9ZpjKRwCGePtW6AUl
        yqtZ0Fmgon17X0L1JmfZRYlJwnTbUiBaz/ebcnFKIDswisa20A/RgaJ7hawFrPkw9RFNYy2P3iVOo
        EY/A3VAg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55876)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpzha-0001Es-LZ; Wed, 24 Nov 2021 21:21:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpzhZ-0001XT-M4; Wed, 24 Nov 2021 21:21:13 +0000
Date:   Wed, 24 Nov 2021 21:21:13 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 09/12] net: dsa: ocelot: convert to
 phylink_generic_validate()
Message-ID: <YZ6syUqWKoXJiQGv@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwSD-00D8Ln-88@rmk-PC.armlinux.org.uk>
 <20211124200748.mrjuzgwunnn4zjxf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124200748.mrjuzgwunnn4zjxf@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 08:07:49PM +0000, Vladimir Oltean wrote:
> On Wed, Nov 24, 2021 at 05:53:09PM +0000, Russell King (Oracle) wrote:
> > Populate the supported interfaces and MAC capabilities for the Ocelot
> > DSA switches and remove the old validate implementation to allow DSA to
> > use phylink_generic_validate() for this switch driver.
> > 
> > The felix_vsc9959 and seville_vsc9953 sub-drivers only supports a
> > single interface mode, defined by ocelot_port->phy_mode, so we indicate
> > only this interface mode to phylink. Since phylink restricts the
> > ethtool link modes based on interface, we do not need to make the MAC
> > capabilities dependent on the interface mode.
> 
> Yes, and this driver cannot make use of phylink_generic_validate()
> unless something changes in phylink_get_linkmodes(). You've said a
> number of times that PHY rate adaptation via PAUSE frames is not
> something that is supported, yet it works with 2500base-x and the felix
> driver, and we use this functionality on LS1028A-QDS boards and the
> AQR412 PHY, and customer boards using LS1028A probably use it too. See
> this comment in ocelot_phylink_mac_link_up():

I'll drop this for now, since the issues around rate adaption should
not be handled by phylink_generic_validate(). The point of this
generic helper is to deal with the common case.

We don't get have a way of knowing that the PHY is using rate adaption,
and when rate adaption is in use, it changes the requirements for the
validation path quite substantially. So, we need:

1) phylib to be able to tell us that rate adaption is happening on the
   PHY.
2) change the way we restrict the PHY support/advertisements when
   rate adaption is in use.

I view this as an entirely separate change to this series; it needs to
change in phylink_bringup_phy(), where the restriction is applied to
the PHY, and not in phylink_validate() or below that function.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
