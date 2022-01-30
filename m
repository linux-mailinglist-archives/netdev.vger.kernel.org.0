Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE44A4A3731
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 16:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355401AbiA3PSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 10:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355388AbiA3PSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 10:18:17 -0500
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681F4C061714;
        Sun, 30 Jan 2022 07:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
        s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uLe3+zbgWNDCe7o8/GaIi74HKEzqSq+sVOzQDKRTfp8=; b=IT/3QjsRBfNrX1y8XTauKVEIxx
        Afh522PyiKeeuP5BtOAAo7uLeT8W9ODr3R9rHCrlEznE5patYFH0C848i997DvEBLRp3m5GI+acJz
        hL5wWSqF9s5m9S27/k8r5v0xHNuzp8a7/nS5ySojLoht11FG/yK2/MJDSiK1PZOUDrRb1bRi104lu
        vCE601OZV6Wi26wnNike1M6QB4nGtx3Q9VDDf1XBLXj6fybaJDftxjn0O0HAeN3UP0r6Gur4jJFvs
        uNl3feFbLN2Rkhi0uZ2ADg2lRX6L3xs8pryL9+mnb3hycoy5R3YxkBxMGBqx1ry7NvwOgZJWD/Q9j
        2oVXDvhg==;
Received: from noodles by the.earth.li with local (Exim 4.94.2)
        (envelope-from <noodles@earth.li>)
        id 1nEBxy-00A9DP-OP; Sun, 30 Jan 2022 15:18:10 +0000
Date:   Sun, 30 Jan 2022 15:18:10 +0000
From:   Jonathan McDowell <noodles@earth.li>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luo Jie <luoj@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Marko <robimarko@gmail.com>
Subject: Re: [PATCH net] net: phy: Fix qca8081 with speeds lower than 2.5Gb/s
Message-ID: <YfasMniiA8wn+isu@earth.li>
References: <YfZnmMteVry/A1XR@earth.li>
 <YfaHWSe+FvZC7w/x@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfaHWSe+FvZC7w/x@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30, 2022 at 12:40:57PM +0000, Russell King (Oracle) wrote:
> On Sun, Jan 30, 2022 at 10:25:28AM +0000, Jonathan McDowell wrote:
> > A typo in qca808x_read_status means we try to set SMII mode on the port
> > rather than SGMII when the link speed is not 2.5Gb/s. This results in no
> > traffic due to the mismatch in configuration between the phy and the
> > mac.
> > 
> > Fixes: 79c7bc0521545 ("net: phy: add qca8081 read_status")
> > Signed-off-by: Jonathan McDowell <noodles@earth.li>
> > ---
> >  drivers/net/phy/at803x.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> > index 5b6c0d120e09..7077e3a92d31 100644
> > --- a/drivers/net/phy/at803x.c
> > +++ b/drivers/net/phy/at803x.c
> > @@ -1691,7 +1691,7 @@ static int qca808x_read_status(struct phy_device *phydev)
> >  	if (phydev->link && phydev->speed == SPEED_2500)
> >  		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
> >  	else
> > -		phydev->interface = PHY_INTERFACE_MODE_SMII;
> > +		phydev->interface = PHY_INTERFACE_MODE_SGMII;
> 
> Is it intentional to set the interface to SGMII also when there is no
> link?

My reading of the code is that if this was just a GigE capable phy the
interface would be set once and never changed/unset. The only reason
it happens here is because the link changes to support the 2.5G mode, so
there's no problem with it defaulting to SGMII even when the external
link isn't actually up. Perhap Luo can confirm if this is the case?

J.

-- 
Web [  101 things you can't have too much of : 30 - Comfy sofas.   ]
site: https:// [                                          ]      Made by
www.earth.li/~noodles/  [                      ]         HuggieTag 0.0.24
