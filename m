Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2898454D926
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 06:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358644AbiFPEMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 00:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358622AbiFPEMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 00:12:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E111181C;
        Wed, 15 Jun 2022 21:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655352762; x=1686888762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0jtqphEpXO/EXDUUdHo2AU4BLzmAaPYdQ1jmXTMKYmA=;
  b=XUSopjrEKyC94RVPO0GLfCgQn34NnIznsDPF4ku12+6/1jT+vLci8Cps
   Y0qcmjHceYEx+MLus4g7FzSxUCUdm/AoeikT1wFSwm4QyWyuzQGOzcjar
   1iSx2hRnD2k95Iv7PZFj+wv4IBFSSEGa1prL2e9CVmyfHOT6MQatyuV++
   YD8iHQmiXCk2XeUWe4px11x0XXQg4TKP6iAmKkfLiAarSy2nwEisJdFwN
   gx6z5kHa1igqoKDX5tUahDVP/H3120IcNtmOQkbcx2HeOIN1cimqnNJ28
   uGcQD4dhYWdIVck0lqrgaIxq89dFB1eMgv1h4/BrfY4DIzfskyXMs/y4z
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="163596760"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 21:12:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 21:12:40 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 15 Jun 2022 21:12:37 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <lxu@maxlinear.com>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <bryan.whitehead@microchip.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V2 1/4] net: lan743x: Add support to LAN743x register dump
Date:   Thu, 16 Jun 2022 09:42:23 +0530
Message-ID: <20220616041226.26996-2-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616041226.26996-1-Raju.Lakkaraju@microchip.com>
References: <20220616041226.26996-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to LAN743x common register dump

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 .../net/ethernet/microchip/lan743x_ethtool.c  | 45 +++++++++++++++++++
 .../net/ethernet/microchip/lan743x_ethtool.h  | 26 +++++++++++
 2 files changed, 71 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index c8fe8b31f07b..48b19dcd4351 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -1178,6 +1178,49 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 }
 #endif /* CONFIG_PM */
 
+static void lan743x_common_regs(struct net_device *dev,
+				struct ethtool_regs *regs, void *p)
+
+{
+	struct lan743x_adapter *adapter = netdev_priv(dev);
+	u32 *rb = p;
+
+	memset(p, 0, (MAX_LAN743X_ETH_REGS * sizeof(u32)));
+
+	rb[ETH_PRIV_FLAGS] = adapter->flags;
+	rb[ETH_ID_REV]     = lan743x_csr_read(adapter, ID_REV);
+	rb[ETH_FPGA_REV]   = lan743x_csr_read(adapter, FPGA_REV);
+	rb[ETH_STRAP_READ] = lan743x_csr_read(adapter, STRAP_READ);
+	rb[ETH_INT_STS]    = lan743x_csr_read(adapter, INT_STS);
+	rb[ETH_HW_CFG]     = lan743x_csr_read(adapter, HW_CFG);
+	rb[ETH_PMT_CTL]    = lan743x_csr_read(adapter, PMT_CTL);
+	rb[ETH_E2P_CMD]    = lan743x_csr_read(adapter, E2P_CMD);
+	rb[ETH_E2P_DATA]   = lan743x_csr_read(adapter, E2P_DATA);
+	rb[ETH_MAC_CR]     = lan743x_csr_read(adapter, MAC_CR);
+	rb[ETH_MAC_RX]     = lan743x_csr_read(adapter, MAC_RX);
+	rb[ETH_MAC_TX]     = lan743x_csr_read(adapter, MAC_TX);
+	rb[ETH_FLOW]       = lan743x_csr_read(adapter, MAC_FLOW);
+	rb[ETH_MII_ACC]    = lan743x_csr_read(adapter, MAC_MII_ACC);
+	rb[ETH_MII_DATA]   = lan743x_csr_read(adapter, MAC_MII_DATA);
+	rb[ETH_EEE_TX_LPI_REQ_DLY]  = lan743x_csr_read(adapter,
+						       MAC_EEE_TX_LPI_REQ_DLY_CNT);
+	rb[ETH_WUCSR]      = lan743x_csr_read(adapter, MAC_WUCSR);
+	rb[ETH_WK_SRC]     = lan743x_csr_read(adapter, MAC_WK_SRC);
+}
+
+static int lan743x_get_regs_len(struct net_device *dev)
+{
+	return MAX_LAN743X_ETH_REGS * sizeof(u32);
+}
+
+static void lan743x_get_regs(struct net_device *dev,
+			     struct ethtool_regs *regs, void *p)
+{
+	regs->version = LAN743X_ETH_REG_VERSION;
+
+	lan743x_common_regs(dev, regs, p);
+}
+
 const struct ethtool_ops lan743x_ethtool_ops = {
 	.get_drvinfo = lan743x_ethtool_get_drvinfo,
 	.get_msglevel = lan743x_ethtool_get_msglevel,
@@ -1202,6 +1245,8 @@ const struct ethtool_ops lan743x_ethtool_ops = {
 	.set_eee = lan743x_ethtool_set_eee,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.get_regs_len = lan743x_get_regs_len,
+	.get_regs = lan743x_get_regs,
 #ifdef CONFIG_PM
 	.get_wol = lan743x_ethtool_get_wol,
 	.set_wol = lan743x_ethtool_set_wol,
diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.h b/drivers/net/ethernet/microchip/lan743x_ethtool.h
index d0d11a777a58..7f5996a52488 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.h
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.h
@@ -6,6 +6,32 @@
 
 #include "linux/ethtool.h"
 
+#define LAN743X_ETH_REG_VERSION         1
+
+enum {
+	ETH_PRIV_FLAGS,
+	ETH_ID_REV,
+	ETH_FPGA_REV,
+	ETH_STRAP_READ,
+	ETH_INT_STS,
+	ETH_HW_CFG,
+	ETH_PMT_CTL,
+	ETH_E2P_CMD,
+	ETH_E2P_DATA,
+	ETH_MAC_CR,
+	ETH_MAC_RX,
+	ETH_MAC_TX,
+	ETH_FLOW,
+	ETH_MII_ACC,
+	ETH_MII_DATA,
+	ETH_EEE_TX_LPI_REQ_DLY,
+	ETH_WUCSR,
+	ETH_WK_SRC,
+
+	/* Add new registers above */
+	MAX_LAN743X_ETH_REGS
+};
+
 extern const struct ethtool_ops lan743x_ethtool_ops;
 
 #endif /* _LAN743X_ETHTOOL_H */
-- 
2.25.1

