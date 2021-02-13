Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B863231A8BB
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhBMATM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhBMATH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:19:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49709C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SRYockgpuvIyHm/YFs0cpym/SnCSJbFanYtLei8SK9Y=; b=C9m3QOu8vNVhqWh1ZuitFj659
        tVUi6Q/lAWCU2l4wnqXtHhYg8exRClZ5bAmIJ3MQbIW4O2uvoq0AVmHV4KvafSQQu2bDiQx0/ZZZq
        sCa7SOLbdGKVprAf1F5FzHpE42G6D+dlmSQO4L95oxy9VMNen0CoEqe5KUGl8+3gxrgyT1sbJ7vC4
        GTPFY/5hOYc6RtdtUuGqzPT7kHyJVNJrrhedJAthoxFxwDWNvPB45thg10uHD57vGJALXvKSicDXz
        3MVUP6OnS0UakA9Jb5Vmx/5C6zvZZdjexndRXkqSwrkIfzoFUjYvk0BWy10n8VwPPQd6WFiIldMz8
        XJFEzbJDw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42650)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lAidY-0007no-3k; Sat, 13 Feb 2021 00:18:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lAidU-0007Xw-Ka; Sat, 13 Feb 2021 00:18:08 +0000
Date:   Sat, 13 Feb 2021 00:18:08 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
Message-ID: <20210213001808.GN1463@shell.armlinux.org.uk>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <eb7b911f4fe008e1412058f219623ee2@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb7b911f4fe008e1412058f219623ee2@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 11:40:59PM +0100, Michael Walle wrote:
> Fun fact, now it may be the other way around. If the bootloader doesn't
> configure it and the PHY isn't reset by the hardware, it won't work in
> the bootloader after a reboot ;)

If we start messing around with the configuration of PHYs in that
regard, we could be opening ourselves up for a world of pain...

> If you disable aneg between MAC and PHY, what would be the actual speed
> setting/duplex mode then? I guess it have to match the external speed?

That is a function of the interface mode and the PHY capabilities.

1) if the PHY supports rate adaption, and is programmed for that, then
   the PHY link normally operates at a fixed speed (e.g. 1G for SGMII)
   and the PHY converts to the appropriate speed.

   We don't actually support this per se, since the parameters we give
   to the MAC via mac_link_up() are the media side parameters, not the
   link parameters.

2) if the PHY does not support rate adaption, then the MAC to PHY link
   needs to follow the media speed and duplex. phylink will be in "PHY"
   mode, where it passes the media side negotiation results to the MAC
   just like phylib would, and the MAC should be programmed
   appropriately. In the case of a SGMII link, the link needs to be
   programmed to do the appropriate symbol repetition for 100M and 10M
   speeds. The PHY /should/ do that automatically, but if it doesn't,
   then the PHY also needs to be programmed to conform. (since if
   there's no rate adaption in the PHY, the MAC side and the media side
   must match.)

Hope that helps.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
