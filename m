Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132BF63B3B9
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbiK1Uzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbiK1Uz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:55:28 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A661A2AE09;
        Mon, 28 Nov 2022 12:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669668924; x=1701204924;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4g4tR6WuunKSsA0/YVZorNxrvXQbfJEgeLEPOdBX+wY=;
  b=eZNVGIG9BrxMnsYC6/V8YyjB/uijO2UglTOcgSH/DH4HMcov5X2dh4oH
   3BTBAc5iMaV6R3zMrgBceVh17ROEI5pOPBZEtEJLN7b84XiNdxtiVFDtL
   N8hHNX1cvmDtb0fPbwgvBbpT0aRWaAe0tzPGUAqb7g0pTDB5l3N7/ETxU
   +Ky0psYWuPs6YXy5qIxhucSxJbMjLaVaAkNzrEx7ZyxD9VzD9pSQ/VHhT
   2ln1U355BWPdeFI6tsi9YC4wSbPXHu7K6pzUHtkWQxYaiKIt+WuScmVmv
   3omAgClyvP/zc6/7fAr2Rpt7g/wPtTcBMNwhzED/h8E59bhMQEYTXBdhT
   w==;
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="189036670"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2022 13:55:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 28 Nov 2022 13:55:23 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 28 Nov 2022 13:55:21 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Date:   Mon, 28 Nov 2022 14:55:21 -0600
Message-ID: <20221128205521.32116-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Buffer Manager and Switch Engine counters to the reported
statistics. As these stats are kept by the switch rather than the port
instance, they are indexed differently.

These statistics are maintained by the switch and count the packets
dropped due to buffer limits. Note that the rtnl_link_stats: rx_dropped
statistic does not include dropped packets due to buffer exhaustion and as
such, part of this counter would more appropriately fall under the
rx_missed_errors.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
v2->v3:
  Isolating this patch to include only the added counters.
  Renamed the new statsistic labels to better identify them.
  Added the SWE Filtered counter to the reported statistics.
  Added comments to explain the added counters.
v1->v2:
  Split patch into 2 pieces.
  Removed the adding of a module number to the driver.
---
 drivers/net/dsa/lan9303-core.c | 56 ++++++++++++++++++++++++++++++----
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 80f07bd20593..ba3814164194 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -176,11 +176,14 @@
 # define LAN9303_SWE_PORT_MIRROR_DISABLED 0
 #define LAN9303_SWE_INGRESS_PORT_TYPE 0x1847
 #define  LAN9303_SWE_INGRESS_PORT_TYPE_VLAN 3
+#define LAN9303_SWE_FILTERED_CNT_SRC_0 0x1850
 #define LAN9303_BM_CFG 0x1c00
+#define LAN9303_BM_DRP_CNT_SRC_0 0x1c05
 #define LAN9303_BM_EGRSS_PORT_TYPE 0x1c0c
 # define LAN9303_BM_EGRSS_PORT_TYPE_SPECIAL_TAG_PORT2 (BIT(17) | BIT(16))
 # define LAN9303_BM_EGRSS_PORT_TYPE_SPECIAL_TAG_PORT1 (BIT(9) | BIT(8))
 # define LAN9303_BM_EGRSS_PORT_TYPE_SPECIAL_TAG_PORT0 (BIT(1) | BIT(0))
+#define LAN9303_BM_RATE_DRP_CNT_SRC_0 0x1c16
 
 #define LAN9303_SWITCH_PORT_REG(port, reg0) (0x400 * (port) + (reg0))
 
@@ -978,10 +981,33 @@ static const struct lan9303_mib_desc lan9303_mib[] = {
 	{ .offset = LAN9303_MAC_TX_LATECOL_0, .name = "TxLateCol", },
 };
 
+/* Buffer Management Statistics (indexed by port) */
+/* Switch Engine Statistics (indexed by port) */
+static const struct lan9303_mib_desc lan9303_switch_mib[] = {
+	{ .offset = LAN9303_BM_DRP_CNT_SRC_0, .name = "TotalDropped", },
+	{ .offset = LAN9303_BM_RATE_DRP_CNT_SRC_0, .name = "LimitDropped", },
+	{ .offset = LAN9303_SWE_FILTERED_CNT_SRC_0, .name = "SweFiltered", },
+};
+
+/* TotalDropped:     This register counts the total number of packets dropped
+ * by the Buffer Manager that were received on the given port. This count
+ * includes packets dropped due to buffer space limits and ingress rate limit
+ * discarding (Red and random Yellow dropping).
+ *
+ * LimitDropped:     This register counts the number of packets received on a
+ * port that were dropped by the Buffer Manager solely due to ingress rate
+ * limiting (discarding packets due to Red and random Yellow dropping).
+ *
+ * SweFiltered:      This counter contains the number of packets filtered by
+ * the Switch Engine at ingress for a given port. The count includes packets
+ * filtered due to broadcast throttling, but does not include packets dropped
+ * due to ingress rate limiting.
+ */
+
 static void lan9303_get_strings(struct dsa_switch *ds, int port,
 				u32 stringset, uint8_t *data)
 {
-	unsigned int u;
+	unsigned int i, u;
 
 	if (stringset != ETH_SS_STATS)
 		return;
@@ -990,26 +1016,44 @@ static void lan9303_get_strings(struct dsa_switch *ds, int port,
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
@@ -1017,7 +1061,7 @@ static int lan9303_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	if (sset != ETH_SS_STATS)
 		return 0;
 
-	return ARRAY_SIZE(lan9303_mib);
+	return ARRAY_SIZE(lan9303_mib) + ARRAY_SIZE(lan9303_switch_mib);
 }
 
 static int lan9303_phy_read(struct dsa_switch *ds, int phy, int regnum)
-- 
2.17.1

