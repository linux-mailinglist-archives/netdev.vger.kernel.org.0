Return-Path: <netdev+bounces-11798-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CBE57347AB
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:42:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38FD3280DF0
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B45DAD54;
	Sun, 18 Jun 2023 18:41:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659A2A93C
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 18:41:46 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E075EE49
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 11:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
	Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=wh3kbI8LEemmL2QeyTcsitB/PiwcBHwoHNWuD/PY3g4=; b=Yhul6A20C6BgeRGzqEbpF3xaku
	+CXn2kuT7LO/bb05/80RMeCnHA0bHvDgculWaROIr3c5Ihb8tjgKzow7hpLrWEkZhRuM7JaIACNqg
	bqFzj7UhuKxFHqz/u0lJMKW5S62aIJKgsp597v9nUsmGbw3JcW4UQ4jwWKI34v0oA6cM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAxLC-00Gr3B-Ii; Sun, 18 Jun 2023 20:41:34 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 net-next 4/9] net: phy: Add helper to set EEE Clock stop enable bit
Date: Sun, 18 Jun 2023 20:41:14 +0200
Message-Id: <20230618184119.4017149-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230618184119.4017149-1-andrew@lunn.ch>
References: <20230618184119.4017149-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The MAC driver can request that the PHY stops the clock during EEE
LPI. This has normally been does as part of phy_init_eee(), however
that function is overly complex and often wrongly used. Add a
standalone helper, to aid removing phy_init_eee().

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2: Add missing EXPORT_SYMBOL_GPL
---
 drivers/net/phy/phy.c | 20 ++++++++++++++++++++
 include/linux/phy.h   |  1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index add94626b604..629499e5aff0 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1506,6 +1506,26 @@ void phy_mac_interrupt(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_mac_interrupt);
 
+/**
+ * phy_eee_clk_stop_enable - Clock should stop during LIP
+ * @phydev: target phy_device struct
+ *
+ * Description: Program the MMD register 3.0 setting the "Clock stop enable"
+ * bit.
+ */
+int phy_eee_clk_stop_enable(struct phy_device *phydev)
+{
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
+			       MDIO_PCS_CTRL1_CLKSTOP_EN);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_eee_clk_stop_enable);
+
 /**
  * phy_init_eee - init and check the EEE feature
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 851421248212..66f69d512f45 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1925,6 +1925,7 @@ int phy_unregister_fixup_for_id(const char *bus_id);
 int phy_unregister_fixup_for_uid(u32 phy_uid, u32 phy_uid_mask);
 
 int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable);
+int phy_eee_clk_stop_enable(struct phy_device *phydev);
 int phy_get_eee_err(struct phy_device *phydev);
 int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data);
 int phy_ethtool_get_eee(struct phy_device *phydev, struct ethtool_eee *data);
-- 
2.40.1


