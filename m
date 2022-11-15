Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0599629F9A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiKOQvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbiKOQvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:51:50 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9851327DFA;
        Tue, 15 Nov 2022 08:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668531104; x=1700067104;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=XIh2fV9eknqvwLJH8ZW0CqGGOX5uZmD6Wzpbfiuo/4c=;
  b=l9yL7WY5Vr9IFlMvyVKmXozUxbo7tTKVZ1tPEt9Z8ou/Ujab+hVCqUYn
   LNB/yd1jVjAZ8Wk/wHqIM05a4sF4G1ktgubQm3VhLt+tMDnABrDCQobEX
   fmD/ZzJrTiQfPI4gf74L5l2FHMFIMkUrOsrDic7jD1YKvKf4u2o+M4hGX
   LKyLGpDasiLToglla20KfYiyjt9Pni2sK3MHAFEyQ5nXFYzey0CJJAFdB
   zhJfbgZiIiX+yHfdaEZY9Bq26v43Jndt6c4tG6+vxsJWqsd1Jm7uE++1C
   vn7PLH+JL2F//TRogY6k7AFP3/BkzC3tnEfHaNg+l1zuiTgcO4YZef/UH
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="199904746"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Nov 2022 09:51:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 15 Nov 2022 09:51:40 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 15 Nov 2022 09:51:36 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jerry Ray <jerry.ray@microchip.com>
Subject: [net-next][PATCH v2 2/2] dsa: lan9303: Add 2 ethtool stats
Date:   Tue, 15 Nov 2022 10:51:31 -0600
Message-ID: <20221115165131.11467-2-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221115165131.11467-1-jerry.ray@microchip.com>
References: <20221115165131.11467-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding RxDropped and TxDropped counters to the reported statistics.
As these stats are kept by the switch rather than the port instance,
they are indexed differently.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
v1->v2:
  Split patch into 2 pieces.
  Removed the adding of a module number to the driver.
---
 drivers/net/dsa/lan9303-core.c | 38 ++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 80f07bd20593..714a21d7aa0a 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -177,10 +177,12 @@
 #define LAN9303_SWE_INGRESS_PORT_TYPE 0x1847
 #define  LAN9303_SWE_INGRESS_PORT_TYPE_VLAN 3
 #define LAN9303_BM_CFG 0x1c00
+#define LAN9303_BM_DRP_CNT_SRC_0 0x1c05
 #define LAN9303_BM_EGRSS_PORT_TYPE 0x1c0c
 # define LAN9303_BM_EGRSS_PORT_TYPE_SPECIAL_TAG_PORT2 (BIT(17) | BIT(16))
 # define LAN9303_BM_EGRSS_PORT_TYPE_SPECIAL_TAG_PORT1 (BIT(9) | BIT(8))
 # define LAN9303_BM_EGRSS_PORT_TYPE_SPECIAL_TAG_PORT0 (BIT(1) | BIT(0))
+#define LAN9303_BM_RATE_DRP_CNT_SRC_0 0x1c16
 
 #define LAN9303_SWITCH_PORT_REG(port, reg0) (0x400 * (port) + (reg0))
 
@@ -978,10 +980,16 @@ static const struct lan9303_mib_desc lan9303_mib[] = {
 	{ .offset = LAN9303_MAC_TX_LATECOL_0, .name = "TxLateCol", },
 };
 
+/* Buffer Management Statistics (indexed by port) */
+static const struct lan9303_mib_desc lan9303_switch_mib[] = {
+	{ .offset = LAN9303_BM_RATE_DRP_CNT_SRC_0, .name = "RxDropped", },
+	{ .offset = LAN9303_BM_DRP_CNT_SRC_0, .name = "TxDropped", },
+};
+
 static void lan9303_get_strings(struct dsa_switch *ds, int port,
 				u32 stringset, uint8_t *data)
 {
-	unsigned int u;
+	unsigned int i, u;
 
 	if (stringset != ETH_SS_STATS)
 		return;
@@ -990,26 +998,44 @@ static void lan9303_get_strings(struct dsa_switch *ds, int port,
 		strncpy(data + u * ETH_GSTRING_LEN, lan9303_mib[u].name,
 			ETH_GSTRING_LEN);
 	}
+	for (i = 0; i < ARRAY_SIZE(lan9303_switch_mib); i++) {
+		strncpy(data + (u + i) * ETH_GSTRING_LEN,
+			lan9303_switch_mib[i].name, ETH_GSTRING_LEN);
+	}
 }
 
 static void lan9303_get_ethtool_stats(struct dsa_switch *ds, int port,
 				      uint64_t *data)
 {
 	struct lan9303 *chip = ds->priv;
-	unsigned int u;
+	unsigned int i, u;
 
 	for (u = 0; u < ARRAY_SIZE(lan9303_mib); u++) {
 		u32 reg;
 		int ret;
 
-		ret = lan9303_read_switch_port(
-			chip, port, lan9303_mib[u].offset, &reg);
-
+		/* Read Port-based MIB stats. */
+		ret = lan9303_read_switch_port(chip, port,
+					       lan9303_mib[u].offset,
+					       &reg);
 		if (ret)
 			dev_warn(chip->dev, "Reading status port %d reg %u failed\n",
 				 port, lan9303_mib[u].offset);
 		data[u] = reg;
 	}
+	for (i = 0; i < ARRAY_SIZE(lan9303_switch_mib); i++) {
+		u32 reg;
+		int ret;
+
+		/* Read Switch stats indexed by port. */
+		ret = lan9303_read_switch_reg(chip,
+					      (lan9303_switch_mib[i].offset +
+					       port), &reg);
+		if (ret)
+			dev_warn(chip->dev, "Reading status port %d reg %u failed\n",
+				 port, lan9303_switch_mib[i].offset);
+		data[i + u] = reg;
+	}
 }
 
 static int lan9303_get_sset_count(struct dsa_switch *ds, int port, int sset)
@@ -1017,7 +1043,7 @@ static int lan9303_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	if (sset != ETH_SS_STATS)
 		return 0;
 
-	return ARRAY_SIZE(lan9303_mib);
+	return ARRAY_SIZE(lan9303_mib) + ARRAY_SIZE(lan9303_switch_mib);
 }
 
 static int lan9303_phy_read(struct dsa_switch *ds, int phy, int regnum)
-- 
2.17.1

