Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419844A37FE
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 19:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355793AbiA3SJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 13:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243299AbiA3SJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 13:09:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF4DC061714;
        Sun, 30 Jan 2022 10:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Sjv4ri6d/zwK5o3BDCYKjDrynuBeoqvc8zhjFZGTMtA=; b=Xw91yuRboB65bMgg1ei2IS4aFf
        XE8LQmCshMm46bCzBMnK2SSuuEzNNQRjvvHK+qNeqCo/oTX7x7QuDheXmcQvzPzg2CXADLeK7PjBu
        kqOTZTdApjquHC77VSnev0dm+wS6vireyGeQHhqUYiyn19OnDZobl+6eGUbeAWXJNwymBCadlyLas
        VOto0JkrwfN6DhKfpTfMzZIkahtI3+y2vlbtOzoXriQF/DLzRZxrTvOpkRzqyMMYycAHqACFPQ6gd
        nsRRWfRqBOec1M5rIoRNhSOxHMpZG4KlM9rfk8JiPnkZt3XuQ5U9q9XWWN5SaPVAXSDJ90vc5tvFD
        hzuQmfLQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56936)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nEEdw-0007W5-7r; Sun, 30 Jan 2022 18:09:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nEEdt-0000MQ-NE; Sun, 30 Jan 2022 18:09:37 +0000
Date:   Sun, 30 Jan 2022 18:09:37 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luo Jie <luoj@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Marko <robimarko@gmail.com>
Subject: Re: [PATCH net] net: phy: Fix qca8081 with speeds lower than 2.5Gb/s
Message-ID: <YfbUYcOLiikv9Pyv@shell.armlinux.org.uk>
References: <YfZnmMteVry/A1XR@earth.li>
 <YfaHWSe+FvZC7w/x@shell.armlinux.org.uk>
 <YfasMniiA8wn+isu@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfasMniiA8wn+isu@earth.li>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30, 2022 at 03:18:10PM +0000, Jonathan McDowell wrote:
> On Sun, Jan 30, 2022 at 12:40:57PM +0000, Russell King (Oracle) wrote:
> > On Sun, Jan 30, 2022 at 10:25:28AM +0000, Jonathan McDowell wrote:
> > > A typo in qca808x_read_status means we try to set SMII mode on the port
> > > rather than SGMII when the link speed is not 2.5Gb/s. This results in no
> > > traffic due to the mismatch in configuration between the phy and the
> > > mac.
> > > 
> > > Fixes: 79c7bc0521545 ("net: phy: add qca8081 read_status")
> > > Signed-off-by: Jonathan McDowell <noodles@earth.li>
> > > ---
> > >  drivers/net/phy/at803x.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> > > index 5b6c0d120e09..7077e3a92d31 100644
> > > --- a/drivers/net/phy/at803x.c
> > > +++ b/drivers/net/phy/at803x.c
> > > @@ -1691,7 +1691,7 @@ static int qca808x_read_status(struct phy_device *phydev)
> > >  	if (phydev->link && phydev->speed == SPEED_2500)
> > >  		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
> > >  	else
> > > -		phydev->interface = PHY_INTERFACE_MODE_SMII;
> > > +		phydev->interface = PHY_INTERFACE_MODE_SGMII;
> > 
> > Is it intentional to set the interface to SGMII also when there is no
> > link?
> 
> My reading of the code is that if this was just a GigE capable phy the
> interface would be set once and never changed/unset. The only reason
> it happens here is because the link changes to support the 2.5G mode, so
> there's no problem with it defaulting to SGMII even when the external
> link isn't actually up. Perhap Luo can confirm if this is the case?

My point is that other PHY drivers only change the interface mode when
the link comes up, and we ought to have consistency between PHY drivers
rather than each PHY driver deciding on different behaviours - unless
there is a good reason to be different.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
