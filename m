Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779635BA81C
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 10:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiIPIXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 04:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIPIXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 04:23:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE19A4B2E;
        Fri, 16 Sep 2022 01:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663316623; x=1694852623;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UDK3+va0e0yyHCehNUfrN8CoW1Dehixv+5zwkMh+MXQ=;
  b=HPPQWNzLYPezdFcpw5VT2cLcTQw+SIhlCy3ggSA5R8rfmXu+5e293jJu
   Qc4ZrnkohzGQC5GuOYiP/y04yC8e2DFRGuv2Wb774ZgB7uazEye2VaZoT
   5x3CBAsrCicCayKbKOoAI+Y1hD7N+OXgGlwV3+o/BC2jrxnk2P4XMi5jP
   rG7blFWRQbcKbH6VzpzltYTTZyWndIaZykqX7TMeKGSlzG80NmUrsCE+c
   PQ6mEvfn7XLP5yG/An2Y7MBnJ1ul8mO4olyAIcM03leE98Oy4+Xg16cXZ
   lgaa52BxZOyWrBp7av6BpLbQvdh5rFqAB6J+nkIwq9Zuyy+G97qHFcbKY
   g==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="177461706"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2022 01:23:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 16 Sep 2022 01:23:41 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 16 Sep 2022 01:23:38 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 2/2] net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414 chips
Date:   Fri, 16 Sep 2022 13:53:27 +0530
Message-ID: <20220916082327.370579-3-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220916082327.370579-1-Raju.Lakkaraju@microchip.com>
References: <20220916082327.370579-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to SGMII register dump

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 .../net/ethernet/microchip/lan743x_ethtool.c  | 136 +++++++++++++++++-
 .../net/ethernet/microchip/lan743x_ethtool.h  |  70 +++++++++
 drivers/net/ethernet/microchip/lan743x_main.c |  16 +++
 drivers/net/ethernet/microchip/lan743x_main.h |   9 +-
 4 files changed, 228 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index c739d60ee17d..81e61b9dac5c 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -24,6 +24,9 @@
 #define LOCK_TIMEOUT_MAX_CNT		    (100) // 1 sec (10 msce * 100)
 
 #define LAN743X_CSR_READ_OP(offset)	     lan743x_csr_read(adapter, offset)
+#define VSPEC1			MDIO_MMD_VEND1
+#define VSPEC2			MDIO_MMD_VEND2
+#define SGMII_RD(adp, dev, adr) lan743x_sgmii_dump_read(adp, dev, adr)
 
 static int lan743x_otp_power_up(struct lan743x_adapter *adapter)
 {
@@ -582,6 +585,7 @@ static void lan743x_ethtool_get_drvinfo(struct net_device *netdev,
 	strscpy(info->driver, DRIVER_NAME, sizeof(info->driver));
 	strscpy(info->bus_info,
 		pci_name(adapter->pdev), sizeof(info->bus_info));
+	info->n_priv_flags = adapter->flags;
 }
 
 static u32 lan743x_ethtool_get_msglevel(struct net_device *netdev)
@@ -796,6 +800,7 @@ static const u32 lan743x_set2_hw_cnt_addr[] = {
 
 static const char lan743x_priv_flags_strings[][ETH_GSTRING_LEN] = {
 	"OTP_ACCESS",
+	"SGMII_REG_DUMP",
 };
 
 static void lan743x_ethtool_get_strings(struct net_device *netdev,
@@ -1190,6 +1195,76 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 }
 #endif /* CONFIG_PM */
 
+static void lan743x_sgmii_regs(struct net_device *dev,
+			       struct ethtool_regs *regs, void *p)
+{
+	struct lan743x_adapter *adp = netdev_priv(dev);
+	u32 *rb = p;
+
+	rb[ETH_SR_VSMMD_DEV_ID1]                = SGMII_RD(adp, VSPEC1, 0x0002);
+	rb[ETH_SR_VSMMD_DEV_ID2]                = SGMII_RD(adp, VSPEC1, 0x0003);
+	rb[ETH_SR_VSMMD_PCS_ID1]                = SGMII_RD(adp, VSPEC1, 0x0004);
+	rb[ETH_SR_VSMMD_PCS_ID2]                = SGMII_RD(adp, VSPEC1, 0x0005);
+	rb[ETH_SR_VSMMD_STS]                    = SGMII_RD(adp, VSPEC1, 0x0008);
+	rb[ETH_SR_VSMMD_CTRL]                   = SGMII_RD(adp, VSPEC1, 0x0009);
+	rb[ETH_SR_MII_CTRL]                     = SGMII_RD(adp, VSPEC2, 0x0000);
+	rb[ETH_SR_MII_STS]                      = SGMII_RD(adp, VSPEC2, 0x0001);
+	rb[ETH_SR_MII_DEV_ID1]                  = SGMII_RD(adp, VSPEC2, 0x0002);
+	rb[ETH_SR_MII_DEV_ID2]                  = SGMII_RD(adp, VSPEC2, 0x0003);
+	rb[ETH_SR_MII_AN_ADV]                   = SGMII_RD(adp, VSPEC2, 0x0004);
+	rb[ETH_SR_MII_LP_BABL]                  = SGMII_RD(adp, VSPEC2, 0x0005);
+	rb[ETH_SR_MII_EXPN]                     = SGMII_RD(adp, VSPEC2, 0x0006);
+	rb[ETH_SR_MII_EXT_STS]                  = SGMII_RD(adp, VSPEC2, 0x000F);
+	rb[ETH_SR_MII_TIME_SYNC_ABL]            = SGMII_RD(adp, VSPEC2, 0x0708);
+	rb[ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x0709);
+	rb[ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x070A);
+	rb[ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x070B);
+	rb[ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x070C);
+	rb[ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x070D);
+	rb[ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x070E);
+	rb[ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x070F);
+	rb[ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x0710);
+	rb[ETH_VR_MII_DIG_CTRL1]                = SGMII_RD(adp, VSPEC2, 0x8000);
+	rb[ETH_VR_MII_AN_CTRL]                  = SGMII_RD(adp, VSPEC2, 0x8001);
+	rb[ETH_VR_MII_AN_INTR_STS]              = SGMII_RD(adp, VSPEC2, 0x8002);
+	rb[ETH_VR_MII_TC]                       = SGMII_RD(adp, VSPEC2, 0x8003);
+	rb[ETH_VR_MII_DBG_CTRL]                 = SGMII_RD(adp, VSPEC2, 0x8005);
+	rb[ETH_VR_MII_EEE_MCTRL0]               = SGMII_RD(adp, VSPEC2, 0x8006);
+	rb[ETH_VR_MII_EEE_TXTIMER]              = SGMII_RD(adp, VSPEC2, 0x8008);
+	rb[ETH_VR_MII_EEE_RXTIMER]              = SGMII_RD(adp, VSPEC2, 0x8009);
+	rb[ETH_VR_MII_LINK_TIMER_CTRL]          = SGMII_RD(adp, VSPEC2, 0x800A);
+	rb[ETH_VR_MII_EEE_MCTRL1]               = SGMII_RD(adp, VSPEC2, 0x800B);
+	rb[ETH_VR_MII_DIG_STS]                  = SGMII_RD(adp, VSPEC2, 0x8010);
+	rb[ETH_VR_MII_ICG_ERRCNT1]              = SGMII_RD(adp, VSPEC2, 0x8011);
+	rb[ETH_VR_MII_GPIO]                     = SGMII_RD(adp, VSPEC2, 0x8015);
+	rb[ETH_VR_MII_EEE_LPI_STATUS]           = SGMII_RD(adp, VSPEC2, 0x8016);
+	rb[ETH_VR_MII_EEE_WKERR]                = SGMII_RD(adp, VSPEC2, 0x8017);
+	rb[ETH_VR_MII_MISC_STS]                 = SGMII_RD(adp, VSPEC2, 0x8018);
+	rb[ETH_VR_MII_RX_LSTS]                  = SGMII_RD(adp, VSPEC2, 0x8020);
+	rb[ETH_VR_MII_Gen2_Gen4_TX_BSTCTRL0]    = SGMII_RD(adp, VSPEC2, 0x8038);
+	rb[ETH_VR_MII_Gen2_Gen4_TX_LVLCTRL0]    = SGMII_RD(adp, VSPEC2, 0x803A);
+	rb[ETH_VR_MII_Gen2_Gen4_TXGENCTRL0]     = SGMII_RD(adp, VSPEC2, 0x803C);
+	rb[ETH_VR_MII_Gen2_Gen4_TXGENCTRL1]     = SGMII_RD(adp, VSPEC2, 0x803D);
+	rb[ETH_VR_MII_Gen4_TXGENCTRL2]          = SGMII_RD(adp, VSPEC2, 0x803E);
+	rb[ETH_VR_MII_Gen2_Gen4_TX_STS]         = SGMII_RD(adp, VSPEC2, 0x8048);
+	rb[ETH_VR_MII_Gen2_Gen4_RXGENCTRL0]     = SGMII_RD(adp, VSPEC2, 0x8058);
+	rb[ETH_VR_MII_Gen2_Gen4_RXGENCTRL1]     = SGMII_RD(adp, VSPEC2, 0x8059);
+	rb[ETH_VR_MII_Gen4_RXEQ_CTRL]           = SGMII_RD(adp, VSPEC2, 0x805B);
+	rb[ETH_VR_MII_Gen4_RXLOS_CTRL0]         = SGMII_RD(adp, VSPEC2, 0x805D);
+	rb[ETH_VR_MII_Gen2_Gen4_MPLL_CTRL0]     = SGMII_RD(adp, VSPEC2, 0x8078);
+	rb[ETH_VR_MII_Gen2_Gen4_MPLL_CTRL1]     = SGMII_RD(adp, VSPEC2, 0x8079);
+	rb[ETH_VR_MII_Gen2_Gen4_MPLL_STS]       = SGMII_RD(adp, VSPEC2, 0x8088);
+	rb[ETH_VR_MII_Gen2_Gen4_LVL_CTRL]       = SGMII_RD(adp, VSPEC2, 0x8090);
+	rb[ETH_VR_MII_Gen4_MISC_CTRL2]          = SGMII_RD(adp, VSPEC2, 0x8093);
+	rb[ETH_VR_MII_Gen2_Gen4_MISC_CTRL0]     = SGMII_RD(adp, VSPEC2, 0x8099);
+	rb[ETH_VR_MII_Gen2_Gen4_MISC_CTRL1]     = SGMII_RD(adp, VSPEC2, 0x809A);
+	rb[ETH_VR_MII_SNPS_CR_CTRL]             = SGMII_RD(adp, VSPEC2, 0x80A0);
+	rb[ETH_VR_MII_SNPS_CR_ADDR]             = SGMII_RD(adp, VSPEC2, 0x80A1);
+	rb[ETH_VR_MII_SNPS_CR_DATA]             = SGMII_RD(adp, VSPEC2, 0x80A2);
+	rb[ETH_VR_MII_DIG_CTRL2]                = SGMII_RD(adp, VSPEC2, 0x80E1);
+	rb[ETH_VR_MII_DIG_ERRCNT]               = SGMII_RD(adp, VSPEC2, 0x80E2);
+}
+
 static void lan743x_common_regs(struct net_device *dev,
 				struct ethtool_regs *regs, void *p)
 
@@ -1222,15 +1297,70 @@ static void lan743x_common_regs(struct net_device *dev,
 
 static int lan743x_get_regs_len(struct net_device *dev)
 {
-	return MAX_LAN743X_ETH_REGS * sizeof(u32);
+	struct lan743x_adapter *adapter = netdev_priv(dev);
+	u32 priv_flags = adapter->flags;
+	int regs;
+
+	if (priv_flags & LAN743X_SGMII_REG_DUMP)
+		regs = MAX_LAN743X_ETH_SGMII_REGS;
+	else
+		regs = MAX_LAN743X_ETH_REGS;
+
+	return regs * sizeof(u32);
 }
 
 static void lan743x_get_regs(struct net_device *dev,
 			     struct ethtool_regs *regs, void *p)
 {
+	struct lan743x_adapter *adapter = netdev_priv(dev);
+	int regs_len;
+	u32 *rb = p;
+
 	regs->version = LAN743X_ETH_REG_VERSION;
 
-	lan743x_common_regs(dev, regs, p);
+	regs_len = lan743x_get_regs_len(dev);
+	memset(p, 0, regs_len);
+
+	if (adapter->flags & LAN743X_SGMII_REG_DUMP) {
+		rb[ETH_SGMII_PRIV_FLAGS]  = adapter->flags;
+		lan743x_sgmii_regs(dev, regs, p);
+	} else {
+		lan743x_common_regs(dev, regs, p);
+	}
+}
+
+static void lan743x_get_pauseparam(struct net_device *dev,
+				   struct ethtool_pauseparam *pause)
+{
+	struct lan743x_adapter *adapter = netdev_priv(dev);
+
+//	pause->autoneg = adapter->pause_autoneg;
+	pause->tx_pause = adapter->pause_tx;
+	pause->rx_pause = adapter->pause_rx;
+}
+
+static int lan743x_set_pauseparam(struct net_device *dev,
+				  struct ethtool_pauseparam *pause)
+{
+	struct lan743x_adapter *adapter = netdev_priv(dev);
+	struct phy_device *phydev = dev->phydev;
+
+	if (pause->autoneg)
+		return -EINVAL;
+
+	if (!phydev)
+		return -EINVAL;
+
+	if (!phy_validate_pause(phydev, pause))
+		return -EINVAL;
+
+	//adapter->pause_auto = pause->autoneg;
+	adapter->pause_rx   = pause->rx_pause;
+	adapter->pause_tx   = pause->tx_pause;
+
+	phy_set_asym_pause(phydev, pause->rx_pause, pause->tx_pause);
+
+	return 0;
 }
 
 const struct ethtool_ops lan743x_ethtool_ops = {
@@ -1259,6 +1389,8 @@ const struct ethtool_ops lan743x_ethtool_ops = {
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 	.get_regs_len = lan743x_get_regs_len,
 	.get_regs = lan743x_get_regs,
+	.get_pauseparam = lan743x_get_pauseparam,
+	.set_pauseparam = lan743x_set_pauseparam,
 #ifdef CONFIG_PM
 	.get_wol = lan743x_ethtool_get_wol,
 	.set_wol = lan743x_ethtool_set_wol,
diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.h b/drivers/net/ethernet/microchip/lan743x_ethtool.h
index 7f5996a52488..2a68f1c21770 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.h
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.h
@@ -32,6 +32,76 @@ enum {
 	MAX_LAN743X_ETH_REGS
 };
 
+enum {
+	ETH_SGMII_PRIV_FLAGS,
+	/* SGMII Register */
+	ETH_SR_VSMMD_DEV_ID1,
+	ETH_SR_VSMMD_DEV_ID2,
+	ETH_SR_VSMMD_PCS_ID1,
+	ETH_SR_VSMMD_PCS_ID2,
+	ETH_SR_VSMMD_STS,
+	ETH_SR_VSMMD_CTRL,
+	ETH_SR_MII_CTRL,
+	ETH_SR_MII_STS,
+	ETH_SR_MII_DEV_ID1,
+	ETH_SR_MII_DEV_ID2,
+	ETH_SR_MII_AN_ADV,
+	ETH_SR_MII_LP_BABL,
+	ETH_SR_MII_EXPN,
+	ETH_SR_MII_EXT_STS,
+	ETH_SR_MII_TIME_SYNC_ABL,
+	ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR,
+	ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_UPR,
+	ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_LWR,
+	ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_UPR,
+	ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_LWR,
+	ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_UPR,
+	ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_LWR,
+	ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_UPR,
+	ETH_VR_MII_DIG_CTRL1,
+	ETH_VR_MII_AN_CTRL,
+	ETH_VR_MII_AN_INTR_STS,
+	ETH_VR_MII_TC,
+	ETH_VR_MII_DBG_CTRL,
+	ETH_VR_MII_EEE_MCTRL0,
+	ETH_VR_MII_EEE_TXTIMER,
+	ETH_VR_MII_EEE_RXTIMER,
+	ETH_VR_MII_LINK_TIMER_CTRL,
+	ETH_VR_MII_EEE_MCTRL1,
+	ETH_VR_MII_DIG_STS,
+	ETH_VR_MII_ICG_ERRCNT1,
+	ETH_VR_MII_GPIO,
+	ETH_VR_MII_EEE_LPI_STATUS,
+	ETH_VR_MII_EEE_WKERR,
+	ETH_VR_MII_MISC_STS,
+	ETH_VR_MII_RX_LSTS,
+	ETH_VR_MII_Gen2_Gen4_TX_BSTCTRL0,
+	ETH_VR_MII_Gen2_Gen4_TX_LVLCTRL0,
+	ETH_VR_MII_Gen2_Gen4_TXGENCTRL0,
+	ETH_VR_MII_Gen2_Gen4_TXGENCTRL1,
+	ETH_VR_MII_Gen4_TXGENCTRL2,
+	ETH_VR_MII_Gen2_Gen4_TX_STS,
+	ETH_VR_MII_Gen2_Gen4_RXGENCTRL0,
+	ETH_VR_MII_Gen2_Gen4_RXGENCTRL1,
+	ETH_VR_MII_Gen4_RXEQ_CTRL,
+	ETH_VR_MII_Gen4_RXLOS_CTRL0,
+	ETH_VR_MII_Gen2_Gen4_MPLL_CTRL0,
+	ETH_VR_MII_Gen2_Gen4_MPLL_CTRL1,
+	ETH_VR_MII_Gen2_Gen4_MPLL_STS,
+	ETH_VR_MII_Gen2_Gen4_LVL_CTRL,
+	ETH_VR_MII_Gen4_MISC_CTRL2,
+	ETH_VR_MII_Gen2_Gen4_MISC_CTRL0,
+	ETH_VR_MII_Gen2_Gen4_MISC_CTRL1,
+	ETH_VR_MII_SNPS_CR_CTRL,
+	ETH_VR_MII_SNPS_CR_ADDR,
+	ETH_VR_MII_SNPS_CR_DATA,
+	ETH_VR_MII_DIG_CTRL2,
+	ETH_VR_MII_DIG_ERRCNT,
+
+	/* Add new registers above */
+	MAX_LAN743X_ETH_SGMII_REGS
+};
+
 extern const struct ethtool_ops lan743x_ethtool_ops;
 
 #endif /* _LAN743X_ETHTOOL_H */
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 2599dfffd1da..b79609fd33e4 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -25,6 +25,22 @@
 #define PCS_POWER_STATE_DOWN	0x6
 #define PCS_POWER_STATE_UP	0x4
 
+static int lan743x_sgmii_read(struct lan743x_adapter *adapter,
+			      u8 mmd, u16 addr);
+int lan743x_sgmii_dump_read(struct lan743x_adapter *adapter,
+			    u8 dev, u16 adr)
+{
+	int ret;
+
+	ret = lan743x_sgmii_read(adapter, dev, adr);
+	if (ret < 0) {
+		pr_warn("SGMII read fail\n");
+		return ret;
+	}
+
+	return ret;
+}
+
 static void pci11x1x_strap_get_status(struct lan743x_adapter *adapter)
 {
 	u32 chip_rev;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 67877d3b6dd9..170adc46dd08 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -1039,11 +1039,16 @@ struct lan743x_adapter {
 	u8			used_tx_channels;
 	u8			max_vector_count;
 
-#define LAN743X_ADAPTER_FLAG_OTP		BIT(0)
 	u32			flags;
 	u32			hw_cfg;
+	u32			pause_tx;
+	u32			pause_rx;
+	u32			pause_auto;
 };
 
+#define LAN743X_ADAPTER_FLAG_OTP		BIT(0)
+#define LAN743X_SGMII_REG_DUMP			BIT(1)
+
 #define LAN743X_COMPONENT_FLAG_RX(channel)  BIT(20 + (channel))
 
 #define INTR_FLAG_IRQ_REQUESTED(vector_index)	BIT(0 + vector_index)
@@ -1159,5 +1164,7 @@ u32 lan743x_csr_read(struct lan743x_adapter *adapter, int offset);
 void lan743x_csr_write(struct lan743x_adapter *adapter, int offset, u32 data);
 int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter, u16 timeout);
 void lan743x_hs_syslock_release(struct lan743x_adapter *adapter);
+int lan743x_sgmii_dump_read(struct lan743x_adapter *adapter,
+			    u8 dev, u16 adr);
 
 #endif /* _LAN743X_H */
-- 
2.25.1

