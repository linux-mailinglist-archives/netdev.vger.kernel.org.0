Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264C5F6AE9
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfKJSuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:50:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbfKJSuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 13:50:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/y8k2c28+hL2dCV63JWWk4z9hfYxN2UUeOgQM9eFPkk=; b=gGLx3nLVOYgX2FC8XjiqaKjgeo
        iRZcutjpgDwD9pmcuf5fU9K42p5qHd9uNp82yXqfL8h0eT9k4cLRKAm0awPHZGxApyF4JNoijMM0N
        gmZl6kNccMzT5v69JcRl8VWZ1LMSCspi/vj3C1pHkREzJCMGh6A2OM54DJ+8wRISAk5U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTsIS-0007OE-JZ; Sun, 10 Nov 2019 19:50:48 +0100
Date:   Sun, 10 Nov 2019 19:50:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Possibility of me mainlining Tehuti Networks 10GbE driver
Message-ID: <20191110185048.GV25889@lunn.ch>
References: <PS2P216MB0755843A57F285E4EE452EE5807B0@PS2P216MB0755.KORP216.PROD.OUTLOOK.COM>
 <6fc9c7ef-0f6c-01e0-132b-74a80711788e@gmail.com>
 <PS2P216MB0755A999533207D9E687F61780750@PS2P216MB0755.KORP216.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PS2P216MB0755A999533207D9E687F61780750@PS2P216MB0755.KORP216.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Could I please have more information / reading resources on the PHY 
> business? My understanding is that the NIC firmware would be dealing 
> with the PHY (this is the MII, right?) and the OS would have nothing to 
> do with it (it just sees a NIC which processes packets).

There are two different strategies boards can use:

1) The MAC firmware handles the PHY, and the firmware has all the PHY
   drivers needed.

2) Linux handles the PHY, and uses drivers from drivers/net/phy. The
   MAC driver then needs to export an MDIO bus, and use either phylink
   or phylib.

> Above you mentioned mii_bus for PHYs, but a driver like Aquantia 
> Atlantic does not have references to PHYs or MII. Why do some not need 
> the feature when others do?

The Aquantia MAC driver uses the firmware strategy. The PHY is
completely hidden from Linux with the firmware running on the MAC
handling the PHY.

But say look at the Marvell MAC drivers. They expose an MDIO bus, and
linux then drives the PHY. The MAC driver then uses the phylink_ API
to interact with the PHY via the phylink core code.

I also had a quick look at the code. It has the basic code you need to
export an MDIO bus, and let Linux control the PHYs.  bdx_mdio_read()
and bdx_mdio_write() would become the two functions you need for
struct mii_bus, and then pass it to mdiobus_register(). You would then
need to add phylink calls in the write place in the MAC driver.

If you think writing a new driver is too much work for you, then going
via staging is probably the better idea. You can slowly working on
improving the driver. One of the big chunks of work is going to be
swapping to the kernel PHY drivers, using PHYLINK, etc. And to do
that, you really do need to have hardware. You don't need all the
different variants the driver supports, but you should at least have
one. And i would suggest you get hardware which uses either the
Marvell or Aquantia PHY.

     Andrew
