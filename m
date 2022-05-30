Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC15537954
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbiE3Kpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbiE3KpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:45:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A443B7CB16;
        Mon, 30 May 2022 03:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653907483; x=1685443483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RwQc5FyNxnZwDYZUUhQH6gr1/5DebPTnHa51OwkXzy0=;
  b=gpicyVzhuwnWBM7adP49h0YOI8QG5YYOwp0D72YE018IPbVTrSSEuLd3
   l7V5Oi5f1NVsAJ2r+jjtqyYE8cPdeLamWj8XlZ2jYfCzuwwo1RlToKLu2
   d4/aI7WqI+B+0kSP/f4Wucppkf0wjY1q7RhbpjZIhNcAQ3SzF6qKW5vEy
   JXU0xZ9Z+V5FGddnF16bfTtFWv5rKvqDAUGPEHundBa2a+aAMecqEaPZV
   ICBxnzkMISV44o1blhIpsKPNH4gdwafW9zaPrto+RA8ZUf2tw53337KMC
   xpzdyHP55WNDgcqIceSkEfODUPu1sJL8H+HvAQ9XVDpzMUuOPzvNwQ+kV
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="166258930"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2022 03:44:42 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 30 May 2022 03:44:41 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 30 May 2022 03:44:37 -0700
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
Subject: [RFC Patch net-next v2 12/15] net: dsa: microchip: ksz9477: separate phylink mode from switch register
Date:   Mon, 30 May 2022 16:12:54 +0530
Message-ID: <20220530104257.21485-13-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530104257.21485-1-arun.ramadoss@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
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
the common switch register function, moving this phy init after
dsa_register_switch using the new ksz_dev_ops.dsa_init hook.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 49 ++++++++++++++------------
 drivers/net/dsa/microchip/ksz_common.c |  5 ++-
 drivers/net/dsa/microchip/ksz_common.h |  1 +
 3 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index ecce99b77ef6..c87ce0e2afd8 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1349,6 +1349,30 @@ static void ksz9477_switch_exit(struct ksz_device *dev)
 	ksz9477_reset_switch(dev);
 }
 
+static int ksz9477_dsa_init(struct ksz_device *dev)
+{
+	struct phy_device *phydev;
+	int i;
+
+	for (i = 0; i < dev->phy_port_cnt; ++i) {
+		if (!dsa_is_user_port(dev->ds, i))
+			continue;
+
+		phydev = dsa_to_port(dev->ds, i)->slave->phydev;
+
+		/* The MAC actually cannot run in 1000 half-duplex mode. */
+		phy_remove_link_mode(phydev,
+				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+
+		/* PHY does not support gigabit. */
+		if (!(dev->features & GBIT_SUPPORT))
+			phy_remove_link_mode(phydev,
+					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
+	}
+
+	return 0;
+}
+
 static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.setup = ksz9477_setup,
 	.get_port_addr = ksz9477_get_port_addr,
@@ -1377,35 +1401,14 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.change_mtu = ksz9477_change_mtu,
 	.max_mtu = ksz9477_max_mtu,
 	.shutdown = ksz9477_reset_switch,
+	.dsa_init = ksz9477_dsa_init,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
 };
 
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
index ace5cf0ad5a8..f40d64858d35 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1253,7 +1253,10 @@ int ksz_switch_register(struct ksz_device *dev,
 	/* Start the MIB timer. */
 	schedule_delayed_work(&dev->mib_read, 0);
 
-	return 0;
+	if (dev->dev_ops->dsa_init)
+		ret = dev->dev_ops->dsa_init(dev);
+
+	return ret;
 }
 EXPORT_SYMBOL(ksz_switch_register);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 872d378ac45c..23962f47df46 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -213,6 +213,7 @@ struct ksz_dev_ops {
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
+	int (*dsa_init)(struct ksz_device *dev);
 	int (*init)(struct ksz_device *dev);
 	void (*exit)(struct ksz_device *dev);
 };
-- 
2.36.1

