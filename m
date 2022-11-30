Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6B763E121
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 21:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiK3UIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 15:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiK3UIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 15:08:10 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BF0F711A4;
        Wed, 30 Nov 2022 12:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669838888; x=1701374888;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8guv5jwcaPQnC7by4n9uUpuRQSBkVBi41RgNbjLZ4lI=;
  b=U4yK5oV/5RhUvxKCPmIKeqqghxdMagcYu6pgMXYmbWUMj8sgRPc1PyjH
   RqNWy17a390Cnvl5OuFfHIp9FvnkE29GXXSD7lD6I/4piLGMqZDuC3N+2
   I42p17uwvAc21pONyaoQDlsReTiKzAeAe8qxbp0uxdBzES1c2HuSzog4I
   eexBv68elP2GqqfPC0+LXZUj+vQyTCGS68A6oRMhJj7rdlf+t3DSvBe0C
   xrWXnY3eB+tgOsLjrYWvN8rgQlRmkd3u1fQ54hrEsPgUCLIuo8rXHuMiW
   uEy8pC8QgZDmtYTSlCGWG+aQG+yOKKLSstXZECMJCW8l30Do5SgWk+nQ3
   g==;
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="202086423"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 13:08:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 13:08:07 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 13:08:05 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v4] dsa: lan9303: Add 3 ethtool stats
Date:   Wed, 30 Nov 2022 14:08:04 -0600
Message-ID: <20221130200804.21778-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Migrating to phylink will be a pre-requisite for adding the stats64 API,
at which point the rtnl_link_stats will come into play.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
v3->v4:
  added returning stat of 0 if there is a device read failure.
  removed unrelated change.
v2->v3:
  Isolating this patch to include only the added counters.
  Renamed the new statsistic labels to better identify them.
  Added the SWE Filtered counter to the reported statistics.
  Added comments to explain the added counters.
v1->v2:
  Split patch into 2 pieces.
  Removed the adding of a module number to the driver.
---
 drivers/net/dsa/lan9303-core.c | 57 +++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 80f07bd20593..93c2a3c549cb 100644
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
@@ -990,26 +1016,49 @@ static void lan9303_get_strings(struct dsa_switch *ds, int port,
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
 
+		/* Read Port-based MIB stats. */
 		ret = lan9303_read_switch_port(
 			chip, port, lan9303_mib[u].offset, &reg);
 
-		if (ret)
+		if (ret) {
 			dev_warn(chip->dev, "Reading status port %d reg %u failed\n",
 				 port, lan9303_mib[u].offset);
+			reg = 0;
+		}
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
+
+		if (ret) {
+			dev_warn(chip->dev, "Reading status port %d reg %u failed\n",
+				 port, lan9303_switch_mib[i].offset + port);
+			reg = 0;
+		}
+		data[i + u] = reg;
+	}
 }
 
 static int lan9303_get_sset_count(struct dsa_switch *ds, int port, int sset)
@@ -1017,7 +1066,7 @@ static int lan9303_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	if (sset != ETH_SS_STATS)
 		return 0;
 
-	return ARRAY_SIZE(lan9303_mib);
+	return ARRAY_SIZE(lan9303_mib) + ARRAY_SIZE(lan9303_switch_mib);
 }
 
 static int lan9303_phy_read(struct dsa_switch *ds, int phy, int regnum)
-- 
2.17.1

