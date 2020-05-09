Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4073F1CC29E
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgEIQ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:29:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50950 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgEIQ3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 12:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yr1VwdDWOEpQrztcbRgaaPX0B8nGblzxM6jvpyonPGM=; b=ROOxDAQxBDoPU+38S/5gF6BhhH
        UjIKRUrScvOW0Z/F46VLr+hhnkWNSf/AfE3DQ71q6i3fyrT/tuIBPUraRwu5oA/ZKBdBMeZg6CY4g
        GFjwkpQoEY+u4YorBcDNqQiHwSu9DIGLkkYAAoz3R3tK3LcfzlsuMFTywd+KmMO6KSMg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXSLc-001WHB-1O; Sat, 09 May 2020 18:29:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 02/10] net: phy: Add support for polling cable test
Date:   Sat,  9 May 2020 18:28:43 +0200
Message-Id: <20200509162851.362346-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509162851.362346-1-andrew@lunn.ch>
References: <20200509162851.362346-1-andrew@lunn.ch>
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

