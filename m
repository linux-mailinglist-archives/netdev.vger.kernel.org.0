Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1302769A423
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBQDH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjBQDHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:07:25 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF91653832
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JlEh5b9Y9r01XJYly4qkh3vhabDQxcOVDFuGdDxtFhE=; b=MmIWAHBk2cKGqtsjfhNs978Bis
        fzHzg+AUQxLbaGYp677ECJBOhN5BFOU+mzNhh/BuT+urdKu5nErFI3RWrJhTe2VmmRSy7B3q5esZ9
        iuz9J+wjygFZSzIJY4V5M505x4ZOWLEprtQel303Ggj/56t0ez9k5w0V5NVVKqkX5K4I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSr5k-005EvX-U5; Fri, 17 Feb 2023 04:07:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [=PATCH net-next 1/2] net: phy: marvell: Use the unlocked genphy_c45_ethtool_get_eee()
Date:   Fri, 17 Feb 2023 04:07:13 +0100
Message-Id: <20230217030714.1249009-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230217030714.1249009-1-andrew@lunn.ch>
References: <20230217030714.1249009-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy_ethtool_get_eee() is about to gain locking of the phydev lock.
This means it cannot be used within a PHY driver without causing a
deadlock. Swap to using genphy_c45_ethtool_get_eee() which assumes the
lock has already been taken.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 0d706ee266af..63a3644d86c9 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1467,7 +1467,7 @@ static int m88e1540_set_fld(struct phy_device *phydev, const u8 *msecs)
 	/* According to the Marvell data sheet EEE must be disabled for
 	 * Fast Link Down detection to work properly
 	 */
-	ret = phy_ethtool_get_eee(phydev, &eee);
+	ret = genphy_c45_ethtool_get_eee(phydev, &eee);
 	if (!ret && eee.eee_enabled) {
 		phydev_warn(phydev, "Fast Link Down detection requires EEE to be disabled!\n");
 		return -EBUSY;
-- 
2.39.1

