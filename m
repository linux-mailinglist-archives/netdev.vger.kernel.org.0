Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B0526A21
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbfEVSuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:50:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728674AbfEVSuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 14:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kbsILPKkaJO1Pp7B4u1i0S5OQWBKuPN5iZBTzw5V0CY=; b=gH4vii2ymGle6inF9n5b1x29LJ
        6L/LkGDCZ1ou647ceszNA1TwhdwRZlu2l2hvRyl51LRZJpZUwtslCySQbxtNRK/sKyF27IaVZDGav
        DibYMcgjQ0jK+NVJMzb5KsomijIoTEDt7UozUfFaClS1GHCRVv/o0jkU5CpWhRlbQvNw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTWGr-0001t3-6w; Wed, 22 May 2019 20:47:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/2] net: phy: Add support for 100BaseT1 and 1000BaseT1
Date:   Wed, 22 May 2019 20:47:03 +0200
Message-Id: <20190522184704.7195-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522184704.7195-1-andrew@lunn.ch>
References: <20190522184704.7195-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add link modes for 100Mbps and 1Gbps over a single pair.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy-core.c   | 4 +++-
 include/uapi/linux/ethtool.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 3daf0214a242..16667fbac8bf 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -8,7 +8,7 @@
 
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 67,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 69,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
@@ -131,9 +131,11 @@ static const struct phy_setting settings[] = {
 	PHY_SETTING(   1000, FULL,   1000baseKX_Full		),
 	PHY_SETTING(   1000, FULL,   1000baseT_Full		),
 	PHY_SETTING(   1000, HALF,   1000baseT_Half		),
+	PHY_SETTING(   1000, FULL,   1000baseT1_Full		),
 	PHY_SETTING(   1000, FULL,   1000baseX_Full		),
 	/* 100M */
 	PHY_SETTING(    100, FULL,    100baseT_Full		),
+	PHY_SETTING(    100, FULL,    100baseT1_Full		),
 	PHY_SETTING(    100, HALF,    100baseT_Half		),
 	/* 10M */
 	PHY_SETTING(     10, FULL,     10baseT_Full		),
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 3534ce157ae9..dd06302aa93e 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1483,6 +1483,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT = 64,
 	ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT	 = 65,
 	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
+	ETHTOOL_LINK_MODE_100baseT1_Full_BIT		 = 67,
+	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT		 = 68,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
-- 
2.20.1

