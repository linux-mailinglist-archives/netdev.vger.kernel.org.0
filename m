Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4949C4C4799
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 15:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241799AbiBYOe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 09:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiBYOe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 09:34:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7BF2782BB
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=twv9sAuoH8cAe8LYuUraaKkQQmSqwSFfr+YAKCSoNpU=; b=NKf8RHISYRd/Opgn15CCmRDfZd
        JUSfRfEjtWRiyW4QZyXMMtophl0xAJCEkMgDALLX8+8zR/mhbvr5d7pVBqWPpoGpzMQaSvsQBIDDW
        B91qLS3fEFZpD8PEJpkRix1LuczDVg+sfDNuYeldmDiDxBmr16vdcw6l5sSnRmK406QrJSRLrJLoe
        FPvGQ0KkL3F2y0BevfxWeJxLFCYXRNwZJMOmGbetIwI6SwTXEfLonOcWrU0hjbpTla+GlFtkqh6LU
        PttSMvM2YbrvDS6Wo8B90xiGjBdCR4bCTmggGwK1mlr1m3wnHXmOLjvHPeVrHvTgRZjNI7CET2iJo
        hRCTjRzg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57492)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNbfh-0005WO-CR; Fri, 25 Feb 2022 14:34:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNbfe-00038l-OV; Fri, 25 Feb 2022 14:34:10 +0000
Date:   Fri, 25 Feb 2022 14:34:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH RFC net-next 0/4] net: dsa: ocelot: phylink updates
Message-ID: <Yhjo4nwmEZJ/RsJ/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series updates the Ocelot DSA driver for some of the recent
phylink changes. Specifically, we fill in the supported_interfaces
fields, convert to mac_select_pcs and mark the driver as non-legacy.
We do not convert to phylink_generic_validate() as Ocelot has
special support for its rate adapting PCS which makes the generic
validate method unsuitable for this driver.

The three changes mentioned above are implemented in their own
separate patches with one additional cleanup:

1) Populate the supported_interfaces bitmap
2) Remove the now unnecessary interface checks in the validate methods
3) Convert from phylink_set_pcs() to .mac_select_pcs.
4) Mark the driver as non-legacy

Thanks.

 drivers/net/dsa/ocelot/felix.c           | 31 +++++++++++++++++++++++++------
 drivers/net/dsa/ocelot/felix.h           |  2 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 16 ++++++++++------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 16 ++++++++++------
 4 files changed, 47 insertions(+), 18 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
