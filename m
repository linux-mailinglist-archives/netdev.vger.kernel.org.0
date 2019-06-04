Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C50A3529F
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 00:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfFDWPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 18:15:13 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:18257 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDWPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 18:15:13 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x54MFAPV019378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 4 Jun 2019 16:15:10 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x54MFAcQ003568
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 4 Jun 2019 16:15:10 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next] net: phy: Add detection of 1000BaseX link mode support
Date:   Tue,  4 Jun 2019 16:15:01 -0600
Message-Id: <1559686501-25739-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 1000BaseX to the link modes which are detected based on the
MII_ESTATUS register as per 802.3 Clause 22. This allows PHYs which
support 1000BaseX to work properly with drivers using phylink.

Previously 1000BaseX support was not detected, and if that was the only
mode the PHY indicated support for, phylink would refuse to attach it
due to the list of supported modes being empty.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/phy/phy_device.c | 3 +++
 include/uapi/linux/mii.h     | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2c879ba..03c885e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1930,6 +1930,9 @@ int genphy_config_init(struct phy_device *phydev)
 		if (val & ESTATUS_1000_THALF)
 			linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
 					 features);
+		if (val & ESTATUS_1000_XFULL)
+			linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+					 features);
 	}
 
 	linkmode_and(phydev->supported, phydev->supported, features);
diff --git a/include/uapi/linux/mii.h b/include/uapi/linux/mii.h
index a506216..51b48e4 100644
--- a/include/uapi/linux/mii.h
+++ b/include/uapi/linux/mii.h
@@ -121,6 +121,8 @@
 #define EXPANSION_MFAULTS	0x0010	/* Multiple faults detected    */
 #define EXPANSION_RESV		0xffe0	/* Unused...                   */
 
+#define ESTATUS_1000_XFULL	0x8000	/* Can do 1000BaseX Full       */
+#define ESTATUS_1000_XHALF	0x4000	/* Can do 1000BaseX Half       */
 #define ESTATUS_1000_TFULL	0x2000	/* Can do 1000BT Full          */
 #define ESTATUS_1000_THALF	0x1000	/* Can do 1000BT Half          */
 
-- 
1.8.3.1

