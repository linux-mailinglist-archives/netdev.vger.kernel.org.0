Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83554EEA92
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 11:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344665AbiDAJiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 05:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344653AbiDAJis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 05:38:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FBF26B3A3;
        Fri,  1 Apr 2022 02:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648805818; x=1680341818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8SOAYzNZRqNk713P5UplsGuvt3kP/bvIxPw6GOJY6zc=;
  b=WIiKMo33lP48CL/s3sy00NpsJxHRPGOzAfdEoQg4r4WW0NOJxpNZ7HOp
   FUQiDQcwE56QAN2WPTcegZUu8nEzIj0RWS+AGLt/eAwQE0csqaihrjSBg
   +nYNhzHMzN599m9vAF0jn4oVJHOb9HGSKQidRtDMyq+AT3stfEPN0KVk8
   r7XQi26Dt0TQ2lRP24wHuEBMDJABhVjbS+JpdWyDbFogyttcLZYexB+pg
   XWAm3oMjnYef1G4fj6JPYZcENkGVNxGsio06Aig7UsPPVK78D6KxjQXID
   MhKSRcjTuc3jcOZgQvYG7X3BIUVZR4XCW5dQOwAPR5mpDfnlRGimr5LWv
   g==;
X-IronPort-AV: E=Sophos;i="5.90,226,1643698800"; 
   d="scan'208";a="167969083"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 02:36:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 02:36:58 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Apr 2022 02:36:56 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 2/2] net: phy: micrel: Implement set/get_tunable
Date:   Fri, 1 Apr 2022 11:39:09 +0200
Message-ID: <20220401093909.3341836-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220401093909.3341836-1-horatiu.vultur@microchip.com>
References: <20220401093909.3341836-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement set/get_tunable to set/get the PHY latencies.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 93 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index fc53b71dc872..f537e61cb61d 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -99,6 +99,15 @@
 #define PTP_TIMESTAMP_EN_PDREQ_			BIT(2)
 #define PTP_TIMESTAMP_EN_PDRES_			BIT(3)
 
+#define PTP_RX_LATENCY_1000			0x0224
+#define PTP_TX_LATENCY_1000			0x0225
+
+#define PTP_RX_LATENCY_100			0x0222
+#define PTP_TX_LATENCY_100			0x0223
+
+#define PTP_RX_LATENCY_10			0x0220
+#define PTP_TX_LATENCY_10			0x0221
+
 #define PTP_TX_PARSE_L2_ADDR_EN			0x0284
 #define PTP_RX_PARSE_L2_ADDR_EN			0x0244
 
@@ -2591,6 +2600,88 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 	return 0;
 }
 
+static void lan8814_get_latency(struct phy_device *phydev, u32 id, s32 *latency)
+{
+	switch (id) {
+	case ETHTOOL_PHY_LATENCY_RX_10MBIT:
+		*latency = lanphy_read_page_reg(phydev, 5, PTP_RX_LATENCY_10);
+		break;
+	case ETHTOOL_PHY_LATENCY_TX_10MBIT:
+		*latency = lanphy_read_page_reg(phydev, 5, PTP_TX_LATENCY_10);
+		break;
+	case ETHTOOL_PHY_LATENCY_RX_100MBIT:
+		*latency = lanphy_read_page_reg(phydev, 5, PTP_RX_LATENCY_100);
+		break;
+	case ETHTOOL_PHY_LATENCY_TX_100MBIT:
+		*latency = lanphy_read_page_reg(phydev, 5, PTP_TX_LATENCY_100);
+		break;
+	case ETHTOOL_PHY_LATENCY_RX_1000MBIT:
+		*latency = lanphy_read_page_reg(phydev, 5, PTP_RX_LATENCY_1000);
+		break;
+	case ETHTOOL_PHY_LATENCY_TX_1000MBIT:
+		*latency = lanphy_read_page_reg(phydev, 5, PTP_TX_LATENCY_1000);
+		break;
+	}
+}
+
+static int lan8814_get_tunable(struct phy_device *phydev,
+			       struct ethtool_tunable *tuna, void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_LATENCY_RX_10MBIT:
+	case ETHTOOL_PHY_LATENCY_TX_10MBIT:
+	case ETHTOOL_PHY_LATENCY_RX_100MBIT:
+	case ETHTOOL_PHY_LATENCY_TX_100MBIT:
+	case ETHTOOL_PHY_LATENCY_RX_1000MBIT:
+	case ETHTOOL_PHY_LATENCY_TX_1000MBIT:
+		lan8814_get_latency(phydev, tuna->id, data);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void lan8814_set_latency(struct phy_device *phydev, u32 id, s32 latency)
+{
+	switch (id) {
+	case ETHTOOL_PHY_LATENCY_RX_10MBIT:
+		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_10, latency);
+		break;
+	case ETHTOOL_PHY_LATENCY_TX_10MBIT:
+		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_10, latency);
+		break;
+	case ETHTOOL_PHY_LATENCY_RX_100MBIT:
+		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_100, latency);
+		break;
+	case ETHTOOL_PHY_LATENCY_TX_100MBIT:
+		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_100, latency);
+		break;
+	case ETHTOOL_PHY_LATENCY_RX_1000MBIT:
+		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_1000, latency);
+		break;
+	case ETHTOOL_PHY_LATENCY_TX_1000MBIT:
+		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_1000, latency);
+		break;
+	}
+}
+
+static int lan8814_set_tunable(struct phy_device *phydev,
+			       struct ethtool_tunable *tuna, const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_LATENCY_RX_10MBIT:
+	case ETHTOOL_PHY_LATENCY_TX_10MBIT:
+	case ETHTOOL_PHY_LATENCY_RX_100MBIT:
+	case ETHTOOL_PHY_LATENCY_TX_100MBIT:
+	case ETHTOOL_PHY_LATENCY_RX_1000MBIT:
+	case ETHTOOL_PHY_LATENCY_TX_1000MBIT:
+		lan8814_set_latency(phydev, tuna->id, *(const s32 *)data);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int lan8814_config_init(struct phy_device *phydev)
 {
 	int val;
@@ -2827,6 +2918,8 @@ static struct phy_driver ksphy_driver[] = {
 	.probe		= lan8814_probe,
 	.soft_reset	= genphy_soft_reset,
 	.read_status	= ksz9031_read_status,
+	.get_tunable	= lan8814_get_tunable,
+	.set_tunable	= lan8814_set_tunable,
 	.get_sset_count	= kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-- 
2.33.0

