Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADC963C161
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbiK2NnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbiK2NnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:43:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3789E186E9
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 05:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fpudl/FnftKRMrJTxTTTWeziSsjQ4C+kADcLeoKlYyw=; b=vCNS4uip8oP57GIdEkmBp7YVdH
        3WcP5Oxx/klmqL7Kz/ywDnKwcVQw0ADgmVhMsDDzQxAW7rzjgTknyVun/C2e8UPeETxBQWk1c8n6l
        34k6MYwsZOze7g5jBHXze2kk+cM2p38FWq6PFMBRPKnDr44pLTQZz174iseKrFMSoCFCX4DSN3S0H
        gmsKfDQBSgqwtcpRxsxWK+4mCJ5qRqKSYBHTdMbLq0YmCW7oa6Zg90AExhvhlQ5tLVXjM5ve7JbCC
        +HGjQ/DgEuiuywhwmAmyZoufj8SWxhvhdxcFHuWZMl/3Z1MmJGOiJMdAMNf/tIQJ6bl/JWTvPmPpC
        S/ON2IOQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35476)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p00t8-0000jx-G9; Tue, 29 Nov 2022 13:43:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p00t7-0001ar-Em; Tue, 29 Nov 2022 13:43:05 +0000
Date:   Tue, 29 Nov 2022 13:43:05 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
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
Message-ID: <Y4YMaQ8XvkBaS/7D@shell.armlinux.org.uk>
References: <20221122175603.soux2q2cxs2wfsun@skbuf>
 <Y30U1tHqLw0SWwo1@shell.armlinux.org.uk>
 <20221122193618.p57qrvhymeegu7cs@skbuf>
 <Y34NK9h86cgYmcoM@shell.armlinux.org.uk>
 <Y34b+7IOaCX401vR@shell.armlinux.org.uk>
 <20221125123022.cnqobhnuzyqb5ukw@skbuf>
 <Y4DGhv/6BHNaMEYQ@shell.armlinux.org.uk>
 <20221125153555.uzrl7j2me3lh2aeg@skbuf>
 <Y4PhVWmM6//kDoE/@shell.armlinux.org.uk>
 <Y4YL6oxIFvSMYaCl@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4YL6oxIFvSMYaCl@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 01:40:58PM +0000, Russell King (Oracle) wrote:
> Here's an updated patch.
> 8<===
> From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
> Subject: [PATCH] net: phy: marvell: add validate_an_inband() method
> 
> Add the validate_an_inband() method for Marvell 88E1111, the Finisar
> version of the 88E1111, and 88E1112.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

And this is what I was using on top to force a mismatch with bypass
enabled:

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index fbf881cd4a38..c7a0389320cd 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -683,6 +683,14 @@ static int m88e1111_validate_an_inband(struct phy_device *phydev,
 	if (extsr < 0 || bmcr < 0)
 		return PHY_AN_INBAND_UNKNOWN;
 
+	/* <<=== HACK */
+	phydev_info(phydev, "extsr: %04x fiber bmcr: %04x\n", extsr, bmcr);
+	phy_write(phydev, MII_M1111_PHY_EXT_SR, extsr |
+		  MII_M1111_HWCFG_SERIAL_AN_BYPASS);
+	genphy_soft_reset(phydev);
+	return PHY_AN_INBAND_OFF;
+	/* ===>> HACK */
+
 	/* We make no efforts to enable the ANENABLE bit when switching mode.
 	 * If this bit is clear, then we will not be using in-band signalling.
 	 */

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
