Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0596338B4
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiKVJjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiKVJiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:38:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12FB4FF9D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5BdpH7uCstx53nBFWAVFA9aKrhAthuDfvtbFgzqJR5I=; b=Poxc0h5fooDKduILz5aVeGC/HR
        iMNiUMe57yyHuniqAH3DC8cjyxjeFH97nLpU5/xdJ16CeUwqxZoo8W7eLvt5QJh9jQM0oEE5s0VVi
        FDF4b09FMgAKU3pzNtWn9dL0vC3Uw6lOBagf9MRIWVpCYWtW/gGvl6jA1NdamB67tY7OGl2k3qo5u
        djMs0xZm0LHO89H6ZB3vpVU3ejdjXwrERW2eHjhOPnCmT5k/4rnDBBBLtqOjAr4zj0usHAETB8C4c
        FrczrPShJO/8n7K9woqWIoljtjEvdbEMTJ9zjTs8v1iPlUXeaSrg8WqWUyBcWCXRLPqwJ34im/Z1W
        T5yCl55Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35376)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxPjr-0001HE-1z; Tue, 22 Nov 2022 09:38:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxPjn-0003DK-GO; Tue, 22 Nov 2022 09:38:43 +0000
Date:   Tue, 22 Nov 2022 09:38:43 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118000124.2754581-4-vladimir.oltean@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 02:01:19AM +0200, Vladimir Oltean wrote:
> Now that there is a generic interface through which phylink can query
> PHY drivers whether they support various forms of in-band autoneg, use
> that and delete the special case from phylink.c.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I think I'd prefer to see patch 2 and patch 3 first in this series
(patch 3 without the phylink change). Possibly followed by other PHY
driver patches adding the validate_an_inband function, but that's not
important. Then the next patch can be patch 1 and the phylink part of
this patch combined - which makes the changes to phylink smaller as
there's no need to move the phylink_phy_no_inband() function and then
delete it a few patches later.

Also, if we get the Marvell driver implementing validate_an_inband()
then I believe we can get rid of other parts of this patch - 88E1111 is
the commonly used accessible PHY on gigabit SFPs, as this PHY implements
I2C access natively. As I mentioned, Marvell PHYs can be set to no
inband, requiring inband, or inband with bypass mode enabled. So we
need to decide how we deal with that - especially if we're going to be
changing the mode from 1000base-X to SGMII (which we do on some SFP
modules so they work at 10/100/1000.)

In that regard, I'm not entirely convinced that validate_an_inband()
covers the functionality we need - as reading the config register on
Marvell hardware doesn't guarantee that we're reading the right mode -
the PHY may be in 1000base-X, and we might change it to
SGMII-with-bypass - I'd need to go through the PHY datasheets to check
what we actually do.

Changing what the PHY driver does would be a recipe for regressions,
especially for drivers that do not use phylink.

Sorry, the above is a bit rambling, but are my thoughts on the current
approach.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
