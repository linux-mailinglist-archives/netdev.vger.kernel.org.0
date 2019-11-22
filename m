Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA54107490
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 16:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfKVPJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 10:09:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51790 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfKVPJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 10:09:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t5DNyaidq3n9AbUvpdwmLiQvurnuU/NGLCi9CmlH9DU=; b=bUBd/1YLF0LHUIPc0dWwvs2OYP
        k+NYvIa+PeMYHvWg4jF/RfBm0Jyuwygh+cChOH9jKhd4Rtnc14XabXwtN8I6kI54GUVlAC8Vqz+YT
        PwUNh6gE373Yd3cF8na+bB2FQvJxQ1bzR7j1To3FuNz6WtI59SRKS3wCX8jIjSkdG7lI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iYAYu-0005tt-LN; Fri, 22 Nov 2019 16:09:32 +0100
Date:   Fri, 22 Nov 2019 16:09:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Marginean <alexandru.marginean@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: binding for scanning a MDIO bus
Message-ID: <20191122150932.GC6602@lunn.ch>
References: <7b6fc87b-b6d8-21e6-bd8d-74c72b3d63a7@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b6fc87b-b6d8-21e6-bd8d-74c72b3d63a7@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 12:31:30PM +0000, Alexandru Marginean wrote:
> Hi everyone,
> 
> I am looking for the proper binding to scan for a PHY on an MDIO bus 
> that's not a child of the Ethernet device but otherwise is associated 
> with it.  Scanning this bus should guarantee finding the correct PHY, if 
> one exists.  As far as I can tell current bindings don't allow such 
> association, although the code seems to support it.
> 
> The hardware that I'm using and could use such a binding is a NXP QDS 
> board with PHY cards.  In particular this is a LS1028A, but the problem 
> is common to the NXP QDS boards.  These cards wire MDIO up to the CPU 
> through a mux.  The mux practically selects one of the slots/cards so 
> the MDIO bus the PHY is on is private to the slot/card.
> Each slot is also associated with an Ethernet interface, this is subject 
> to serdes configuration and specifically for that I'm looking to apply a 
> DT overlay.  Overlays are really impractical with the PHY cards though, 
> there are several types of cards, number of slots can go up to 8 or so 
> on some types of QDS boards and number of PHY card overlays that should 
> be defined would blow up.  The number of overlays users would need to 
> apply at boot would also go up to number of slots + 1.
> 
> The function of_mdiobus_register does scan for PHYs if 'reg' is missing 
> in PHY nodes, is this code considered obsolete, is it OK to use it if 
> needed but otherwise discouraged?  Any thoughts on including support for 
> scanning in the binding document, like making 'reg' property in phy 
> nodes optional?
> 
> For what is worth scanning is a good solution in some cases, better than 
> others anyway.  I'm sure it's not just people being too lazy to set up 
> 'reg' that use this code.

Hi Alexandru

You often see the bus registered using mdiobus_register(). That then
means a scan is performed and all phys on the bus found. The MAC
driver then uses phy_find_first() to find the first PHY on the bus.
The danger here is that the hardware design changes, somebody adds a
second PHY, and it all stops working in interesting and confusing
ways.

Would this work for you?

      Andrew
