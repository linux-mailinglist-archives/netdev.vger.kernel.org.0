Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C927E41DD1A
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 17:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245111AbhI3PRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 11:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239388AbhI3PRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 11:17:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64584C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 08:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IpTng+5CE68Hi69wqmp2aihJFfqdcatLme+2pXwTmRQ=; b=xyAh/b8rc9ynbwDDK0Zb7cMI22
        LwdanZQBnn1A07zp+odn7bK+LcL4nMRpOKtZSEl8RqCEkuFyf68KtpMwezeyKbfDYXPELM1W6o6e8
        q/Evrs/TM4I6hkd6CNYetfwWjn3+/O+B7FMVLfwMv2L/zSdwSmkcOk4hVyJl4opRzkX29b5UzwzsG
        YY3cob48hAuo0muOo3gP5jNkImdnkXoquNgxlo0fm/XltOXvC+2tF7yuC1lkvHeFrK1exm4qZEEtS
        hr326VFae94g5Dp3YxbBTVIIJ0duLL9jHtkrN4c6DLfkV7JKWfPZSjx85zV2aqrVs4dX4WpJQJ2ca
        6TT4RQTw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54878)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mVxmb-0003e2-JE; Thu, 30 Sep 2021 16:15:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mVxma-0003l0-8Z; Thu, 30 Sep 2021 16:15:36 +0100
Date:   Thu, 30 Sep 2021 16:15:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFT net-next] net: mdio: ensure the type of mdio devices
 match mdio drivers
Message-ID: <YVXUmDkkTT3ihKh0@shell.armlinux.org.uk>
References: <E1mVxSO-000aHB-P0@rmk-PC.armlinux.org.uk>
 <YVXQrTe392mMNAa+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVXQrTe392mMNAa+@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 04:58:53PM +0200, Andrew Lunn wrote:
> On Thu, Sep 30, 2021 at 03:54:44PM +0100, Russell King (Oracle) wrote:
> > On the MDIO bus, we have PHYLIB devices and drivers, and we have non-
> > PHYLIB devices and drivers. PHYLIB devices are MDIO devices that are
> > wrapped with a struct phy_device.
> > 
> > Trying to bind a MDIO device with a PHYLIB driver results in out-of-
> > bounds accesses as we attempt to access struct phy_device members. So,
> > let's prevent this by ensuring that the type of the MDIO device
> > (indicated by the MDIO_DEVICE_FLAG_PHY flag) matches the type of the
> > MDIO driver (indicated by the MDIO_DEVICE_IS_PHY flag.)
> > 
> > Link: https://lore.kernel.org/r/2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> > Tested locally in SolidRun Clearfog, DSA switch and PHY get probed
> > correctly. Further testing welcomed.
> > 
> >  drivers/net/phy/mdio_bus.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 53f034fc2ef7..779e49715e91 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -939,6 +939,12 @@ EXPORT_SYMBOL_GPL(mdiobus_modify);
> >  static int mdio_bus_match(struct device *dev, struct device_driver *drv)
> >  {
> >  	struct mdio_device *mdio = to_mdio_device(dev);
> > +	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
> 
> DaveM would request these two lines are swapped for reverse Christmas tree.

Yep. I'll get around to that sometime.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
