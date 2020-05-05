Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C57C1C4AEF
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgEEASm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:18:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbgEEASl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 20:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YLzA7K4y2n52yn3k9/OFNCN5fbIyAtCofRSwZ57UsrM=; b=v3U5q6hUh+8ixvl9eT55GdfDay
        //hLpp8F8RRyj9rUfdCuFlwKir9Qgpi0e9HJ367LZp9tebQTdXK8u3GCqOkbAlzcvLXBVjA7ophTb
        aA935/92rEZWvtCVoOallgYyi3xTotth1MhKXWMNloBz0ho49nHFEm3EjTGlIrLlfNvM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVlID-000sGJ-DP; Tue, 05 May 2020 02:18:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 02/10] net: phy: Add support for polling cable test
Date:   Tue,  5 May 2020 02:18:13 +0200
Message-Id: <20200505001821.208534-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200505001821.208534-1-andrew@lunn.ch>
References: <20200505001821.208534-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 4f95e605080e..cea89785bcd4 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -521,6 +521,8 @@ int phy_start_cable_test(struct phy_device *phydev,
 
 	phydev->state = PHY_CABLETEST;
 
+	if (phy_polling_mode(phydev))
+		phy_trigger_machine(phydev);
 out:
 	mutex_unlock(&phydev->lock);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 916a5eb969a1..593da2c6041d 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -78,6 +78,7 @@ extern const int phy_10gbit_features_array[1];
 
 #define PHY_IS_INTERNAL		0x00000001
 #define PHY_RST_AFTER_CLK_EN	0x00000002
+#define PHY_POLL_CABLE_TEST	0x00000004
 #define MDIO_DEVICE_IS_PHY	0x80000000
 
 /* Interface Mode definitions */
@@ -1025,6 +1026,10 @@ static inline bool phy_interrupt_is_valid(struct phy_device *phydev)
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
2.26.2

