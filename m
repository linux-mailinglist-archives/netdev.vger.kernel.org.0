Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F7F1CCD38
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 21:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgEJTNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 15:13:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729290AbgEJTNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 15:13:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yr1VwdDWOEpQrztcbRgaaPX0B8nGblzxM6jvpyonPGM=; b=muGHq7Os1HH/ztbKHbcGpdutkJ
        eRYxI4oMWVUN/VNOICk9T2JGYeE3HPy8wVKsWS2/zB+jqaqMBOk9ND+ZnuUnK7EeirxJPIYLOwKP4
        MiLuSCZ28BfG3h1861+u6e83AsG+PH1X64KfzXF4HKyRRl9IkreO/M/Zh2U5ILq9o7C8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXrNc-001jdZ-HO; Sun, 10 May 2020 21:12:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 02/10] net: phy: Add support for polling cable test
Date:   Sun, 10 May 2020 21:12:32 +0200
Message-Id: <20200510191240.413699-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200510191240.413699-1-andrew@lunn.ch>
References: <20200510191240.413699-1-andrew@lunn.ch>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy.c | 2 ++
 include/linux/phy.h   | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 0f4b27215429..9fa61019533f 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -523,6 +523,8 @@ int phy_start_cable_test(struct phy_device *phydev,
 
 	phydev->state = PHY_CABLETEST;
 
+	if (phy_polling_mode(phydev))
+		phy_trigger_machine(phydev);
 out:
 	mutex_unlock(&phydev->lock);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 632403fc34f4..f58eee735a45 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -79,6 +79,7 @@ extern const int phy_10gbit_features_array[1];
 
 #define PHY_IS_INTERNAL		0x00000001
 #define PHY_RST_AFTER_CLK_EN	0x00000002
+#define PHY_POLL_CABLE_TEST	0x00000004
 #define MDIO_DEVICE_IS_PHY	0x80000000
 
 /* Interface Mode definitions */
@@ -1061,6 +1062,10 @@ static inline bool phy_interrupt_is_valid(struct phy_device *phydev)
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

