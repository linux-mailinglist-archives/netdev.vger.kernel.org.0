Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE685F2EE1
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiJCKii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJCKic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:38:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BC91DA74;
        Mon,  3 Oct 2022 03:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664793509; x=1696329509;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IHnyPUinNSgUaevr7C8GcWLmaOEQczba+vVPpm/CuB8=;
  b=l47ye3QHMKWCr13kxCmha4QTklt+0x+vbk+QC15qS7SG2JJwxP1QI26s
   lMncuEQZ9i62BJr64pSWx4KjYzinhiCZJNHxDvpJwjTN6mITs5eu7/eFr
   xccRtOKObcQ4EgfhoDjEZZJOmwbJ5af9QunreRt+Blcr1CrNQotZ18GjJ
   sruqDnWO5JMM0uIFgEN5RJHaNWwae6veKcvYiH/2HZyEHK3FZOS21NUFV
   qE+2IxhR1UwKiXdllGtsH3Cta8DF9RJoLKlmgaFUcDKK8QzXpHffJuQH7
   yfOa3dZktwk9fLX6faCw4ydY/VOPr4z6bz/17roJmSUJEhsIIsGY1uTWx
   w==;
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="193541791"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Oct 2022 03:38:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 3 Oct 2022 03:38:30 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 3 Oct 2022 03:38:26 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next V3] net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414 chips
Date:   Mon, 3 Oct 2022 16:08:21 +0530
Message-ID: <20221003103821.4356-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
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
Changes:
========
V2 -> V3:
 - Remove the private flag option.
   As per review comment, use -w/-W to configure dump flag. 
   But, change to -w/-W option, EEPROM/OTP data might be corrupt
   in case of wrong flag input.
   Need to fix this properly in future development.

V1 -> V2:
 - Add set_dump and get_dump_flag functions

V0 -> V1:
 - Removed unwanted code

 .../net/ethernet/microchip/lan743x_ethtool.c  | 101 ++++++++++++++++--
 .../net/ethernet/microchip/lan743x_ethtool.h  |  71 +++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.c |  14 +++
 drivers/net/ethernet/microchip/lan743x_main.h |   2 +
 4 files changed, 180 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index c739d60ee17d..49a801cdf897 100644
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
@@ -1190,15 +1193,11 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 }
 #endif /* CONFIG_PM */
 
-static void lan743x_common_regs(struct net_device *dev,
-				struct ethtool_regs *regs, void *p)
-
+static void lan743x_common_regs(struct net_device *dev, void *p)
 {
 	struct lan743x_adapter *adapter = netdev_priv(dev);
 	u32 *rb = p;
 
-	memset(p, 0, (MAX_LAN743X_ETH_REGS * sizeof(u32)));
-
 	rb[ETH_PRIV_FLAGS] = adapter->flags;
 	rb[ETH_ID_REV]     = lan743x_csr_read(adapter, ID_REV);
 	rb[ETH_FPGA_REV]   = lan743x_csr_read(adapter, FPGA_REV);
@@ -1220,17 +1219,105 @@ static void lan743x_common_regs(struct net_device *dev,
 	rb[ETH_WK_SRC]     = lan743x_csr_read(adapter, MAC_WK_SRC);
 }
 
+static void lan743x_sgmii_regs(struct net_device *dev, void *p)
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
+	rb[ETH_VR_MII_GEN2_GEN4_TX_BSTCTRL0]    = SGMII_RD(adp, VSPEC2, 0x8038);
+	rb[ETH_VR_MII_GEN2_GEN4_TX_LVLCTRL0]    = SGMII_RD(adp, VSPEC2, 0x803A);
+	rb[ETH_VR_MII_GEN2_GEN4_TXGENCTRL0]     = SGMII_RD(adp, VSPEC2, 0x803C);
+	rb[ETH_VR_MII_GEN2_GEN4_TXGENCTRL1]     = SGMII_RD(adp, VSPEC2, 0x803D);
+	rb[ETH_VR_MII_GEN4_TXGENCTRL2]          = SGMII_RD(adp, VSPEC2, 0x803E);
+	rb[ETH_VR_MII_GEN2_GEN4_TX_STS]         = SGMII_RD(adp, VSPEC2, 0x8048);
+	rb[ETH_VR_MII_GEN2_GEN4_RXGENCTRL0]     = SGMII_RD(adp, VSPEC2, 0x8058);
+	rb[ETH_VR_MII_GEN2_GEN4_RXGENCTRL1]     = SGMII_RD(adp, VSPEC2, 0x8059);
+	rb[ETH_VR_MII_GEN4_RXEQ_CTRL]           = SGMII_RD(adp, VSPEC2, 0x805B);
+	rb[ETH_VR_MII_GEN4_RXLOS_CTRL0]         = SGMII_RD(adp, VSPEC2, 0x805D);
+	rb[ETH_VR_MII_GEN2_GEN4_MPLL_CTRL0]     = SGMII_RD(adp, VSPEC2, 0x8078);
+	rb[ETH_VR_MII_GEN2_GEN4_MPLL_CTRL1]     = SGMII_RD(adp, VSPEC2, 0x8079);
+	rb[ETH_VR_MII_GEN2_GEN4_MPLL_STS]       = SGMII_RD(adp, VSPEC2, 0x8088);
+	rb[ETH_VR_MII_GEN2_GEN4_LVL_CTRL]       = SGMII_RD(adp, VSPEC2, 0x8090);
+	rb[ETH_VR_MII_GEN4_MISC_CTRL2]          = SGMII_RD(adp, VSPEC2, 0x8093);
+	rb[ETH_VR_MII_GEN2_GEN4_MISC_CTRL0]     = SGMII_RD(adp, VSPEC2, 0x8099);
+	rb[ETH_VR_MII_GEN2_GEN4_MISC_CTRL1]     = SGMII_RD(adp, VSPEC2, 0x809A);
+	rb[ETH_VR_MII_SNPS_CR_CTRL]             = SGMII_RD(adp, VSPEC2, 0x80A0);
+	rb[ETH_VR_MII_SNPS_CR_ADDR]             = SGMII_RD(adp, VSPEC2, 0x80A1);
+	rb[ETH_VR_MII_SNPS_CR_DATA]             = SGMII_RD(adp, VSPEC2, 0x80A2);
+	rb[ETH_VR_MII_DIG_CTRL2]                = SGMII_RD(adp, VSPEC2, 0x80E1);
+	rb[ETH_VR_MII_DIG_ERRCNT]               = SGMII_RD(adp, VSPEC2, 0x80E2);
+}
+
 static int lan743x_get_regs_len(struct net_device *dev)
 {
-	return MAX_LAN743X_ETH_REGS * sizeof(u32);
+	struct lan743x_adapter *adapter = netdev_priv(dev);
+	u32 num_regs = MAX_LAN743X_ETH_COMMON_REGS;
+
+	if (adapter->is_sgmii_en)
+		num_regs += MAX_LAN743X_ETH_SGMII_REGS;
+
+	return num_regs * sizeof(u32);
 }
 
 static void lan743x_get_regs(struct net_device *dev,
 			     struct ethtool_regs *regs, void *p)
 {
+	struct lan743x_adapter *adapter = netdev_priv(dev);
+	int regs_len;
+
+	regs_len = lan743x_get_regs_len(dev);
+	memset(p, 0, regs_len);
+
 	regs->version = LAN743X_ETH_REG_VERSION;
+	regs->len = regs_len;
+
+	lan743x_common_regs(dev, p);
+	p = (u32 *)p + MAX_LAN743X_ETH_COMMON_REGS;
 
-	lan743x_common_regs(dev, regs, p);
+	if (adapter->is_sgmii_en) {
+		lan743x_sgmii_regs(dev, p);
+		p = (u32 *)p + MAX_LAN743X_ETH_SGMII_REGS;
+	}
 }
 
 const struct ethtool_ops lan743x_ethtool_ops = {
diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.h b/drivers/net/ethernet/microchip/lan743x_ethtool.h
index 7f5996a52488..267d5035b8ad 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.h
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.h
@@ -29,7 +29,76 @@ enum {
 	ETH_WK_SRC,
 
 	/* Add new registers above */
-	MAX_LAN743X_ETH_REGS
+	MAX_LAN743X_ETH_COMMON_REGS
+};
+
+enum {
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
+	ETH_VR_MII_GEN2_GEN4_TX_BSTCTRL0,
+	ETH_VR_MII_GEN2_GEN4_TX_LVLCTRL0,
+	ETH_VR_MII_GEN2_GEN4_TXGENCTRL0,
+	ETH_VR_MII_GEN2_GEN4_TXGENCTRL1,
+	ETH_VR_MII_GEN4_TXGENCTRL2,
+	ETH_VR_MII_GEN2_GEN4_TX_STS,
+	ETH_VR_MII_GEN2_GEN4_RXGENCTRL0,
+	ETH_VR_MII_GEN2_GEN4_RXGENCTRL1,
+	ETH_VR_MII_GEN4_RXEQ_CTRL,
+	ETH_VR_MII_GEN4_RXLOS_CTRL0,
+	ETH_VR_MII_GEN2_GEN4_MPLL_CTRL0,
+	ETH_VR_MII_GEN2_GEN4_MPLL_CTRL1,
+	ETH_VR_MII_GEN2_GEN4_MPLL_STS,
+	ETH_VR_MII_GEN2_GEN4_LVL_CTRL,
+	ETH_VR_MII_GEN4_MISC_CTRL2,
+	ETH_VR_MII_GEN2_GEN4_MISC_CTRL0,
+	ETH_VR_MII_GEN2_GEN4_MISC_CTRL1,
+	ETH_VR_MII_SNPS_CR_CTRL,
+	ETH_VR_MII_SNPS_CR_ADDR,
+	ETH_VR_MII_SNPS_CR_DATA,
+	ETH_VR_MII_DIG_CTRL2,
+	ETH_VR_MII_DIG_ERRCNT,
+
+	/* Add new registers above */
+	MAX_LAN743X_ETH_SGMII_REGS
 };
 
 extern const struct ethtool_ops lan743x_ethtool_ops;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 50eeecba1f18..f1ebb2ca8caf 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -25,6 +25,20 @@
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
+	if (ret < 0)
+		pr_warn("SGMII read fail\n");
+
+	return ret;
+}
+
 static void pci11x1x_strap_get_status(struct lan743x_adapter *adapter)
 {
 	u32 chip_rev;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 67877d3b6dd9..7c0f285b4c96 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -1159,5 +1159,7 @@ u32 lan743x_csr_read(struct lan743x_adapter *adapter, int offset);
 void lan743x_csr_write(struct lan743x_adapter *adapter, int offset, u32 data);
 int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter, u16 timeout);
 void lan743x_hs_syslock_release(struct lan743x_adapter *adapter);
+int lan743x_sgmii_dump_read(struct lan743x_adapter *adapter,
+			    u8 dev, u16 adr);
 
 #endif /* _LAN743X_H */
-- 
2.34.1

