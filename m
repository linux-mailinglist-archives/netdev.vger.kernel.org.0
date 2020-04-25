Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8A91B8866
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 20:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDYSG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 14:06:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34958 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgDYSGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 14:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=o+Qfkyk/Hfizo3X7Mfou54Ct2AKfsLGZGHAPiDt9Cs0=; b=ST0yzAdgZKR6mo6HaCM603K0Ii
        uL6YSOJ/sG5egGvFc/Xg62kZeUtpgRoZkuvjWplhedBxY4chbV72JKKpfRbXWwoTqG7Q0Q9e2a5dz
        2biji8uXsWhwxBuvEnHpBuw3Rbr5AUppVLyAYSKDwrLmzRbDDZQtXerDwXWyWHgv23xM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSPCG-004mhX-6p; Sat, 25 Apr 2020 20:06:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 2/9] net: phy: Add support for polling cable test
Date:   Sat, 25 Apr 2020 20:06:14 +0200
Message-Id: <20200425180621.1140452-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200425180621.1140452-1-andrew@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
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
index 4a6279c4a3a3..242a7c1c4b6c 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -510,6 +510,8 @@ int phy_start_cable_test(struct phy_device *phydev,
 
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
2.26.1

