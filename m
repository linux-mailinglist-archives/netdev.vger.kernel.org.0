Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5609E1B307C
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgDUTi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDUTi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 15:38:26 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F362C0610D5;
        Tue, 21 Apr 2020 12:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cQsbu7/VTrxDt2wl/6zjIgUVlXPWFhpG3HWKnJn11j0=; b=UwgipCLEv4VRJvh0EI+1mBAf8
        Iuq/z4yh3iTgqvZPzxULlQ/BDdakKc/7ry5tZuLjhF/cnIfyZSFpOKEg30JSgaH6+u/WdFZgGELbH
        UF/ub5FlN7GU6nFZORUZnB9+n5juuEY5/Lk1+aruWMoq7YBEQrXxvp/8sxEj3XM5wRzfEHA+ECkdH
        j0NULigdL7d/8sB3c4WuJYL1SDZr/6Dvb38XBa2xm6ptsMG4Ca96gOtWdLPRa0tqPTuAFJN/NwGuu
        8uS5ZdV2j5oPfhAgTifnoudd7g99CtwhATAHpYTNnzWF5U/4J4th4nbASoik1KGchfevNNyt+8SfP
        RX7CickgA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:49226)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jQyie-0003Y9-4J; Tue, 21 Apr 2020 20:38:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jQyiY-0007I3-Ig; Tue, 21 Apr 2020 20:38:02 +0100
Date:   Tue, 21 Apr 2020 20:38:02 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: add concept of shared storage
 for PHYs
Message-ID: <20200421193802.GG25745@shell.armlinux.org.uk>
References: <20200420232624.9127-1-michael@walle.cc>
 <7bcd7a65740a6f85637ef17ed6b6a1e3@walle.cc>
 <20200421155031.GE933345@lunn.ch>
 <47bdeaf298a09f20ad6631db13df37d2@walle.cc>
 <20200421193055.GI933345@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200421193055.GI933345@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 09:30:55PM +0200, Andrew Lunn wrote:
> > Speaking of it. Does anyone have an idea how I could create the hwmon
> > device without the PHY device? At the moment it is attached to the
> > first PHY device and is removed when the PHY is removed, although
> > there might be still other PHYs in this package. Its unlikely to
> > happen though, but if someone has a good idea how to handle that,
> > I'd give it a try.
> 
> There is a somewhat similar problem with Marvell Ethernet switches and
> their internal PHYs. The PHYs are the same as the discrete PHYs, and
> the usual Marvell PHY driver is used. But there is only one
> temperature sensor for the whole switch, and it is mapped into all the
> PHYs. So we end up creating multiple hwmon devices for the one
> temperature sensor, one per PHY.

And sometimes we really mess it up - like on the 88e6141:

cp1configspacef4000000mdio12a200switch04mdio14-mdio-e
Adapter: MDIO adapter
temp1:        -75.0°C

because DSA forces the 6390 PHY ID for this PHY, and the marvell
driver tries to drive the PHY as if it's a different switch, so
we end up reading a register that isn't meaningful.

So, imho, the current approach isn't as good as you think it is.

That aside from wasting memory allocating multiple sensors when
there's really only one.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
