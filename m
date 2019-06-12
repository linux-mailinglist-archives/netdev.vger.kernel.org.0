Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C94F42BCC
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502072AbfFLQHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:07:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49356 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502009AbfFLQHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:07:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yvqpt+qTGE1zCsrSc1Bz2OGjuUANkZTTsOwQ6xwQvxA=; b=GUKax4QnR8XuY+36Hdb0SOIhns
        ApzgYRQxd1HOp/w5lLN8haNQ0aCONfhon3PexM9CVQMRcFcYDrDUsLxJFsh2/Q7R4L9d87w6wpI1J
        4/GWyh/MixBnkbbeBaT5U60DWXA4BZ28ztu98HQfkmY+15er3ivqjhYA4RrSeTQhPMVI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lC-00068M-Vr; Wed, 12 Jun 2019 18:06:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 02/13] net: phy: Add support for polling cable test
Date:   Wed, 12 Jun 2019 18:05:23 +0200
Message-Id: <20190612160534.23533-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHYs are not capable of generating interrupts when a cable test
finished. They do however support interrupts for normal operations,
like link up/down. As such, the PHY state machine would normally not
poll the PHY.

Add support for indicating the PHY state machine must poll the PHY
when performing a cable test.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 2 ++
 include/linux/phy.h   | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 65b13c74c158..dbd4484f04be 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -505,6 +505,8 @@ int phy_start_cable_test(struct phy_device *phydev,
 
 	phydev->state = PHY_CABLETEST;
 
+	if (phy_polling_mode(phydev))
+		phy_trigger_machine(phydev);
 out:
 	mutex_unlock(&phydev->lock);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2531684f507d..0dc6adc73a01 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -76,6 +76,7 @@ extern const int phy_10gbit_features_array[1];
 
 #define PHY_IS_INTERNAL		0x00000001
 #define PHY_RST_AFTER_CLK_EN	0x00000002
+#define PHY_POLL_CABLE_TEST	0x00000004
 #define MDIO_DEVICE_IS_PHY	0x80000000
 
 /* Interface Mode definitions */
@@ -950,6 +951,10 @@ static inline bool phy_interrupt_is_valid(struct phy_device *phydev)
  */
 static inline bool phy_polling_mode(struct phy_device *phydev)
 {
+	if (phydev->state == PHY_CABLETEST)
+		if (phydev->drv->flags & PHY_POLL_CABLE_TEST)
+			return true;
+
 	return phydev->irq == PHY_POLL;
 }
 
-- 
2.20.1

