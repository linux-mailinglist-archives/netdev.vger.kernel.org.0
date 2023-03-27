Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD7D6CAB60
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjC0RDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjC0RCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:02:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D007955A3
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=h67vNxfq+sxz1quWZUmFvXj45Bhu49zJ3A4SdYAGQXI=; b=Lt+xM7At1bplqBV3fC31YNhNsq
        Mij/kWnDBgpFjLIXTfh0R2Aeh64fgUYWZwgOScmPePOUQNjGjrVyjQbl91p0PIJlNJce6bIggs82S
        Xc2J8RgGACWTa1032xhpe1Ogbb5fI3i4/LNEG4TdCMUGi/ILNE/36qQNTbEzeJBwGC8s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEV-008Xsi-BN; Mon, 27 Mar 2023 19:02:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 17/23] net: phy: remove unused phy_init_eee()
Date:   Mon, 27 Mar 2023 19:01:55 +0200
Message-Id: <20230327170201.2036708-18-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327170201.2036708-1-andrew@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no users left of phy_init_eee(), and it is often wrongly
used. So remove it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 34 ----------------------------------
 include/linux/phy.h   |  1 -
 2 files changed, 35 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index b074ac5d1de1..3d12a46f7a4c 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1523,40 +1523,6 @@ int phy_eee_clk_stop_enable(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(phy_eee_clk_stop_enable);
 
-/**
- * phy_init_eee - init and check the EEE feature
- * @phydev: target phy_device struct
- * @clk_stop_enable: PHY may stop the clock during LPI
- *
- * Description: it checks if the Energy-Efficient Ethernet (EEE)
- * is supported by looking at the MMD registers 3.20 and 7.60/61
- * and it programs the MMD register 3.0 setting the "Clock stop enable"
- * bit if required.
- */
-int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable)
-{
-	int ret;
-
-	if (!phydev->drv)
-		return -EIO;
-
-	ret = genphy_c45_eee_is_active(phydev, NULL, NULL, NULL);
-	if (ret < 0)
-		return ret;
-	if (!ret)
-		return -EPROTONOSUPPORT;
-
-	if (clk_stop_enable)
-		/* Configure the PHY to stop receiving xMII
-		 * clock while it is signaling LPI.
-		 */
-		ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
-				       MDIO_PCS_CTRL1_CLKSTOP_EN);
-
-	return ret < 0 ? ret : 0;
-}
-EXPORT_SYMBOL(phy_init_eee);
-
 /**
  * phy_get_eee_err - report the EEE wake error count
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index f746d0b10e68..9769021b1aa7 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1847,7 +1847,6 @@ int phy_unregister_fixup(const char *bus_id, u32 phy_uid, u32 phy_uid_mask);
 int phy_unregister_fixup_for_id(const char *bus_id);
 int phy_unregister_fixup_for_uid(u32 phy_uid, u32 phy_uid_mask);
 
-int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable);
 int phy_eee_clk_stop_enable(struct phy_device *phydev);
 int phy_get_eee_err(struct phy_device *phydev);
 int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data);
-- 
2.39.2

