Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED69474F85
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 01:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238618AbhLOAti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 19:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbhLOAti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 19:49:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92194C061574;
        Tue, 14 Dec 2021 16:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FzXY7sl5S8h2qdDHdwMRvfifQOha1K6MVJQWY3VouUE=; b=FmetdnOjOQ4EZC5waJ/JR2z1Mu
        e9Ed69AFfl7jAP2LroGmGeKKenHO4w2NxjKwLsqEGoc2LcEunt5N9w4sPPXiNxG5IKSaHqoeFrA1N
        +bvp0EIkam8bSHWcTs2VXHHQbN7zTGK4wcRfr7zfneQlaHZ2blMPC2Gf9Nk+XeAlEG32jESXoIEZR
        arGActGv64VhWB9d2SsUWOoUrVN1lZKcW54Dq57NVx4Eon5mBuOUqbN9h7gYk9YunZjAx9Et9tRZP
        ymx8bWns8p2DlCKf2BEze4G7eUPsodhdItAm6QP24mPabLNLXq0gKAmfZ0hEagINSGOabErIfdFx3
        GDhgKUlw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56292)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxITw-0005cX-Bi; Wed, 15 Dec 2021 00:49:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxITq-0003zB-Kq; Wed, 15 Dec 2021 00:49:14 +0000
Date:   Wed, 15 Dec 2021 00:49:14 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marcin Wojtas <mw@semihalf.com>, UNGLinuxDriver@microchip.com,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: Pass state to pcs_config
Message-ID: <Ybk7iuxdin69MjTo@shell.armlinux.org.uk>
References: <20211214233450.1488736-1-sean.anderson@seco.com>
 <YbkshnqgXP7Gd188@shell.armlinux.org.uk>
 <de1f7214-58c8-cdc6-1d29-08c979ce68f1@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de1f7214-58c8-cdc6-1d29-08c979ce68f1@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 07:16:53PM -0500, Sean Anderson wrote:
> Ok, so let me clarify my understanding. Perhaps this can be eliminated
> through a different approach.
> 
> When I read the datasheet for mvneta (which hopefully has the same
> logic here, since I could not find a datasheet for an mvpp2 device), I
> noticed that the Pause_Adv bit said
> 
> > It is valid only if flow control mode is defined by Auto-Negotiation
> > (as defined by the <AnFcEn> bit).
> 
> Which I interpreted to mean that if AnFcEn was clear, then no flow
> control was advertised. But perhaps it instead means that the logic is
> something like
> 
> if (AnFcEn)
> 	Config_Reg.PAUSE = Pause_Adv;
> else
> 	Config_Reg.PAUSE = SetFcEn;
> 
> which would mean that we can just clear AnFcEn in link_up if the
> autonegotiated pause settings are different from the configured pause
> settings.

Having actually played with this hardware quite a bit and observed what
it sends, what it implements for advertising is:

	Config_Reg.PAUSE = Pause_Adv;

Config_Reg gets sent over the 1000BASE-X link to the link partner, and
we receive Remote_Reg from the link partner.

Then, the hardware implements:

	if (AnFcEn)
		MAC_PAUSE = Config_Reg.PAUSE & Remote_Reg.PAUSE;
	else
		MAC_PAUSE = SetFcEn;

In otherwords, AnFcEn controls whether the result of autonegotiation
or the value of SetFcEn controls whether the MAC enables symmetric
pause mode.

Pause_Adv comes from the advertisement, and this is controlled from
ethtool -s and somewhat by ethtool -A.

AnFcEn is controlled purely and only by ethtool -A ... autoneg on|off.
You can't derive this from "state".

SetFcEn comes from ethtool -A ... tx and rx parameters (which must
both be on or both be off.)

Since we have no knowledge what Remote_Reg contains (it's not made
accessible by the hardware), it's impossible to derive whether the
autonegotiated pause settings are different from the configured pause
settings.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
