Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E1A564333
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 01:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiGBW61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 18:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiGBW6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 18:58:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4145F10FE
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 15:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656802701; x=1688338701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Qpks+4jDqqQmX7FNbYBUW9pi2GUk4cBG8/P8HuN5+po=;
  b=nXVNLTMTk31ipBMpmnT3C+/zmUsEWYQzNqUhcmKHfY1dNx3+f+2ZO/jh
   CGQwo8zd8Qn8mVtYc1FK/nV5WbW2f35L1EiWA26MuUADBiWSict7rvr+8
   prPABnIRsGYJa0is0R5xpCq9PchVZY0m8jaT02Pd0O2GoZx3lWgXkO80J
   dVeAB2+O4xIAZbcbSCg+s1g1vOfDUyM5W5IjDksdWbNJ74fwfXk/NVphC
   XVQfFLqo7OeGFBMqIhWfIJ6MhMNwKVHFrswYSHHZ79tZa3JrBH0d5fZAS
   maeSy/iBPLzpMsnmFc0uvRjT3rDW2V1xo5GKnXQxodcAn2SkoSRu59M4G
   g==;
X-IronPort-AV: E=Sophos;i="5.92,241,1650956400"; 
   d="scan'208";a="170546641"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2022 15:58:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 2 Jul 2022 15:58:15 -0700
Received: from hat-linux.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 2 Jul 2022 15:58:14 -0700
From:   <Tristram.Ha@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     Tristram Ha <Tristram.Ha@microchip.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 2/2] net: phy: smsc: add EEE support to LAN8740/LAN8742 PHYs.
Date:   Sat, 2 Jul 2022 15:58:28 -0700
Message-ID: <1656802708-7918-3-git-send-email-Tristram.Ha@microchip.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1656802708-7918-1-git-send-email-Tristram.Ha@microchip.com>
References: <1656802708-7918-1-git-send-email-Tristram.Ha@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tristram Ha <Tristram.Ha@microchip.com>

EEE feature is enabled in LAN8740/LAN8742 during initialization.

Signed-off-by: Tristram Ha <Tristram.Ha@microchip.com>
---
 drivers/net/phy/smsc.c  | 5 +++++
 include/linux/smscphy.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 5b77f0c..7d485bc 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -272,6 +272,11 @@ static int lan874x_phy_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	/* enable EEE */
+	val = phy_read(phydev, MII_LAN874X_PHY_EEE_CFG);
+	val |= MII_LAN874X_PHY_PHYEEEEN;
+	phy_write(phydev, MII_LAN874X_PHY_EEE_CFG, val);
+
 	return smsc_phy_config_init(phydev);
 }
 
diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
index f5e123b..645b0f4 100644
--- a/include/linux/smscphy.h
+++ b/include/linux/smscphy.h
@@ -28,6 +28,9 @@
 #define MII_LAN83C185_MODE_POWERDOWN 0xC0 /* Power Down mode */
 #define MII_LAN83C185_MODE_ALL       0xE0 /* All capable mode */
 
+#define MII_LAN874X_PHY_EEE_CFG			16
+#define MII_LAN874X_PHY_PHYEEEEN		BIT(2)
+
 #define MII_LAN874X_PHY_MMD_WOL_WUCSR		0x8010
 #define MII_LAN874X_PHY_MMD_WOL_WUF_CFGA	0x8011
 #define MII_LAN874X_PHY_MMD_WOL_WUF_CFGB	0x8012
-- 
1.9.1

