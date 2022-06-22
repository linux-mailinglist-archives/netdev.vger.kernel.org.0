Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D23D554829
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357249AbiFVJKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357229AbiFVJKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:10:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4F12FE7B;
        Wed, 22 Jun 2022 02:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888934; x=1687424934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NOvKQZqx2WzUEEUgSF8gTlG5pEyDPq42kwXvF4iMA54=;
  b=OWm4C2PPtx71zkmxarrBoaC5uzeEqUMXJ5pOFj7lyXBECAg1q7T5Qesg
   4V/oaaopD5xA6AgdGWBjWDHG0y/tZpRM8mRX85Zu9uxZb7dDVZ7kSwMP6
   ggAz2CH1At0rcSHD0eGMfV1W3A4vF+kzgzdMOpCwEoQ487c+BO0DgHuGi
   u8aagF789oy1zTrSP83Kg/Z0e71gH02xS1xzEF5sFeEFZjhsFPuWxmUZz
   j4SQP/HQEq+rUpe7703ecA1ehrzsQY5cutpmw+ygZ6aeu5pTepTSPY36l
   FvpGKRRQvafK9s4Yis1G8CZEp7yM1+1Uz9GIs2WBYTl3z0xkdASfuJZ5S
   w==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="164526862"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:08:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:08:50 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:08:46 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next 09/13] net: dsa: microchip: ksz9477: separate phylink mode from switch register
Date:   Wed, 22 Jun 2022 14:34:21 +0530
Message-ID: <20220622090425.17709-10-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220622090425.17709-1-arun.ramadoss@microchip.com>
References: <20220622090425.17709-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per 'commit 3506b2f42dff ("net: dsa: microchip: call
phy_remove_link_mode during probe")' phy_remove_link_mode is added in
the switch_register function after dsa_switch_register. In order to have
the common switch register function, moving this phylink validation to
phylink_get_caps validation hook.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 31 +++++---------------------
 drivers/net/dsa/microchip/ksz_common.c |  2 +-
 2 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index e3989aef93f4..4fcc7923da4d 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1059,8 +1059,11 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
 static void ksz9477_get_caps(struct ksz_device *dev, int port,
 			     struct phylink_config *config)
 {
-	config->mac_capabilities = MAC_10 | MAC_100 | MAC_1000FD |
-				   MAC_ASYM_PAUSE | MAC_SYM_PAUSE;
+	config->mac_capabilities = MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
+				   MAC_SYM_PAUSE;
+
+	if (dev->features & GBIT_SUPPORT)
+		config->mac_capabilities |= MAC_1000FD;
 }
 
 static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
@@ -1381,29 +1384,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 
 int ksz9477_switch_register(struct ksz_device *dev)
 {
-	int ret, i;
-	struct phy_device *phydev;
-
-	ret = ksz_switch_register(dev, &ksz9477_dev_ops);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < dev->phy_port_cnt; ++i) {
-		if (!dsa_is_user_port(dev->ds, i))
-			continue;
-
-		phydev = dsa_to_port(dev->ds, i)->slave->phydev;
-
-		/* The MAC actually cannot run in 1000 half-duplex mode. */
-		phy_remove_link_mode(phydev,
-				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
-
-		/* PHY does not support gigabit. */
-		if (!(dev->features & GBIT_SUPPORT))
-			phy_remove_link_mode(phydev,
-					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
-	}
-	return ret;
+	return ksz_switch_register(dev, &ksz9477_dev_ops);
 }
 EXPORT_SYMBOL(ksz9477_switch_register);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9ebeaba2c755..62d699a47589 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1332,7 +1332,7 @@ int ksz_switch_register(struct ksz_device *dev,
 	/* Start the MIB timer. */
 	schedule_delayed_work(&dev->mib_read, 0);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(ksz_switch_register);
 
-- 
2.36.1

