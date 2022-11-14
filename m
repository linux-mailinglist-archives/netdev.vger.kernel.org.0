Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990E8628AFD
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 22:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbiKNVCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 16:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbiKNVCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 16:02:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D914CB858;
        Mon, 14 Nov 2022 13:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668459760; x=1699995760;
  h=from:to:subject:date:message-id:mime-version;
  bh=WYQvyMe/Ouee8sxJJTDtOaNpVScXhdHxAJng8cTkrss=;
  b=e1AOgbpCEkyqeP6eEPY0o4owQP71MKOT7q215I/oyh9yVj84TeLieOMr
   ZItv1ts6qg2FS7VYNEHPhPujfFzP7D/o8Flbi0fEFfzrkLCKCC+UKfRxL
   h+l2qpfaZIWh3k3/IyUg4MHOfFWfTZt3khTzqsZ5IkM/VgQN+PoBeAci2
   EGQvkAxGCPHHdxbn6r/1OghhAC9/sLe03QNb6/paJv430Z011CHrHndar
   YHbyqkntUEaBz947Ui2xAzGDcdZEVQIAeXkm4imLbY/vOyBE1wEf6X8gk
   cE3B1+eFQSo9HhNVSJRcfVlQt/jwNSntd6mXOviUd0cdauq/j/Oc1PFf3
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="123384986"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Nov 2022 14:02:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 14 Nov 2022 14:02:37 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 14 Nov 2022 14:02:35 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [net-next][PATCH] dsa: lan9303: Changed ethtool stats
Date:   Mon, 14 Nov 2022 15:02:33 -0600
Message-ID: <20221114210233.27225-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the reported ethtool statistics for the lan9303
family of parts covered by this driver.

The TxUnderRun statistic label is renamed to RxShort to accurately
reflect what stat the device is reporting.  I did not reorder the
statistics as that might cause problems with existing user code that
are expecting the stats at a certain offset.

Added RxDropped and TxDropped counters to the reported statistics.
As these stats are kept by the switch rather than the port
instance, they are indexed differently.

Added a version number to the module.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 41 ++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 438e46af03e9..8c6daddde105 100644
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
 
@@ -961,7 +963,7 @@ static const struct lan9303_mib_desc lan9303_mib[] = {
 	{ .offset = LAN9303_MAC_TX_BRDCST_CNT_0, .name = "TxBroad", },
 	{ .offset = LAN9303_MAC_TX_PAUSE_CNT_0, .name = "TxPause", },
 	{ .offset = LAN9303_MAC_TX_MULCST_CNT_0, .name = "TxMulti", },
-	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "TxUnderRun", },
+	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "RxShort", },
 	{ .offset = LAN9303_MAC_TX_64_CNT_0, .name = "Tx64Byte", },
 	{ .offset = LAN9303_MAC_TX_127_CNT_0, .name = "Tx128Byte", },
 	{ .offset = LAN9303_MAC_TX_255_CNT_0, .name = "Tx256Byte", },
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
@@ -1414,5 +1440,6 @@ void lan9303_shutdown(struct lan9303 *chip)
 EXPORT_SYMBOL(lan9303_shutdown);
 
 MODULE_AUTHOR("Juergen Borleis <kernel@pengutronix.de>");
+MODULE_VERSION("1.1");
 MODULE_DESCRIPTION("Core driver for SMSC/Microchip LAN9303 three port ethernet switch");
 MODULE_LICENSE("GPL v2");
-- 
2.17.1

