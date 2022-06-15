Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF78D54C63F
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 12:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346629AbiFOKc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 06:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346203AbiFOKcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 06:32:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF357B7C8;
        Wed, 15 Jun 2022 03:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655289171; x=1686825171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n/Yskv1LOKyVi42mKRDNKn0kVtKenk3cNngUH99xKsI=;
  b=Ob0BT2MxC/87Ld1Ec3x+S2EaCwdealhYrpEnPa3JiYBM2imvfR5sxI3R
   N6nEThJ5h8J9f1px3zus2byDf26eHUAR4m6apFAZyANm7yO1h63kG2wub
   gw0NHYLxdLs65/oqvrDfZIvVCs6nzCDAyRHp8d8gw9Y3Ec64m8qbAdi+h
   I2TeJJscK345smR9kpV4/HU2+LF/0/l7bcEcVQHRfkEw1POXerHTnWwae
   NGdqOHmB3MWKYK3a4ERgihQ8ka52UyGsZTWsiKVTgyftOwksPZ4Hqhfhi
   T9U+azZ2gJwBzZIbGu59+Nh/JpcU2TRV+O1Px+PIH2V/dt03exY4ZzaJV
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="168502168"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 03:32:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 03:32:50 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 15 Jun 2022 03:32:47 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 2/5] net: lan743x: Add support to Secure-ON WOL
Date:   Wed, 15 Jun 2022 16:02:34 +0530
Message-ID: <20220615103237.3331-3-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220615103237.3331-1-Raju.Lakkaraju@microchip.com>
References: <20220615103237.3331-1-Raju.Lakkaraju@microchip.com>
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

Add support to Magic Packet Detection with Secure-ON for PCI11010/PCI11414 chips

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Changes:
V0 -> V1:
  1. Change to sizeof(wol->sopass) instead of SOPASS_MAX * sizeof(wol->sopass[0])

 .../net/ethernet/microchip/lan743x_ethtool.c  | 12 ++++++++
 drivers/net/ethernet/microchip/lan743x_main.c | 29 +++++++++++++++++++
 drivers/net/ethernet/microchip/lan743x_main.h | 10 +++++++
 3 files changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index 48b19dcd4351..99776f7b64aa 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -1149,7 +1149,12 @@ static void lan743x_ethtool_get_wol(struct net_device *netdev,
 	wol->supported |= WAKE_BCAST | WAKE_UCAST | WAKE_MCAST |
 		WAKE_MAGIC | WAKE_PHY | WAKE_ARP;
 
+	if (adapter->is_pci11x1x)
+		wol->supported |= WAKE_MAGICSECURE;
+
 	wol->wolopts |= adapter->wolopts;
+	if (adapter->wolopts & WAKE_MAGICSECURE)
+		memcpy(wol->sopass, adapter->sopass, sizeof(wol->sopass));
 }
 
 static int lan743x_ethtool_set_wol(struct net_device *netdev,
@@ -1170,6 +1175,13 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 		adapter->wolopts |= WAKE_PHY;
 	if (wol->wolopts & WAKE_ARP)
 		adapter->wolopts |= WAKE_ARP;
+	if (wol->wolopts & WAKE_MAGICSECURE &&
+	    wol->wolopts & WAKE_MAGIC) {
+		memcpy(adapter->sopass, wol->sopass, sizeof(wol->sopass));
+		adapter->wolopts |= WAKE_MAGICSECURE;
+	} else {
+		memset(adapter->sopass, 0, sizeof(u8) * SOPASS_MAX);
+	}
 
 	device_set_wakeup_enable(&adapter->pdev->dev, (bool)wol->wolopts);
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index af81236b4b4e..6352cba19691 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3124,6 +3124,7 @@ static void lan743x_pm_set_wol(struct lan743x_adapter *adapter)
 	const u8 ipv6_multicast[3] = { 0x33, 0x33 };
 	const u8 arp_type[2] = { 0x08, 0x06 };
 	int mask_index;
+	u32 sopass;
 	u32 pmtctl;
 	u32 wucsr;
 	u32 macrx;
@@ -3218,6 +3219,14 @@ static void lan743x_pm_set_wol(struct lan743x_adapter *adapter)
 		pmtctl |= PMT_CTL_RX_FCT_RFE_D3_CLK_OVR_;
 	}
 
+	if (adapter->wolopts & WAKE_MAGICSECURE) {
+		sopass = *(u32 *)adapter->sopass;
+		lan743x_csr_write(adapter, MAC_MP_SO_LO, sopass);
+		sopass = *(u16 *)&adapter->sopass[4];
+		lan743x_csr_write(adapter, MAC_MP_SO_HI, sopass);
+		wucsr |= MAC_MP_SO_EN_;
+	}
+
 	lan743x_csr_write(adapter, MAC_WUCSR, wucsr);
 	lan743x_csr_write(adapter, PMT_CTL, pmtctl);
 	lan743x_csr_write(adapter, MAC_RX, macrx);
@@ -3228,6 +3237,7 @@ static int lan743x_pm_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	u32 data;
 
 	lan743x_pcidev_shutdown(pdev);
 
@@ -3239,6 +3249,18 @@ static int lan743x_pm_suspend(struct device *dev)
 	if (adapter->wolopts)
 		lan743x_pm_set_wol(adapter);
 
+	if (adapter->is_pci11x1x) {
+		/* Save HW_CFG to config again in PM resume */
+		data = lan743x_csr_read(adapter, HW_CFG);
+		adapter->hw_cfg = data;
+		data |= (HW_CFG_RST_PROTECT_PCIE_ |
+			 HW_CFG_D3_RESET_DIS_ |
+			 HW_CFG_D3_VAUX_OVR_ |
+			 HW_CFG_HOT_RESET_DIS_ |
+			 HW_CFG_RST_PROTECT_);
+		lan743x_csr_write(adapter, HW_CFG, data);
+	}
+
 	/* Host sets PME_En, put D3hot */
 	return pci_prepare_to_sleep(pdev);
 }
@@ -3254,6 +3276,10 @@ static int lan743x_pm_resume(struct device *dev)
 	pci_restore_state(pdev);
 	pci_save_state(pdev);
 
+	/* Restore HW_CFG that was saved during pm suspend */
+	if (adapter->is_pci11x1x)
+		lan743x_csr_write(adapter, HW_CFG, adapter->hw_cfg);
+
 	ret = lan743x_hardware_init(adapter, pdev);
 	if (ret) {
 		netif_err(adapter, probe, adapter->netdev,
@@ -3270,6 +3296,9 @@ static int lan743x_pm_resume(struct device *dev)
 		lan743x_netdev_open(netdev);
 
 	netif_device_attach(netdev);
+	ret = lan743x_csr_read(adapter, MAC_WK_SRC);
+	netif_info(adapter, drv, adapter->netdev,
+		   "Wakeup source : 0x%08X\n", ret);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 1ca5f3216403..5d37263b25c8 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -43,6 +43,11 @@
 #define STRAP_READ_ADV_PM_DISABLE_	BIT(0)
 
 #define HW_CFG					(0x010)
+#define HW_CFG_RST_PROTECT_PCIE_		BIT(19)
+#define HW_CFG_HOT_RESET_DIS_			BIT(15)
+#define HW_CFG_D3_VAUX_OVR_			BIT(14)
+#define HW_CFG_D3_RESET_DIS_			BIT(13)
+#define HW_CFG_RST_PROTECT_			BIT(12)
 #define HW_CFG_RELOAD_TYPE_ALL_			(0x00000FC0)
 #define HW_CFG_EE_OTP_RELOAD_			BIT(4)
 #define HW_CFG_LRST_				BIT(1)
@@ -214,6 +219,7 @@
 #define MAC_EEE_TX_LPI_REQ_DLY_CNT		(0x130)
 
 #define MAC_WUCSR				(0x140)
+#define MAC_MP_SO_EN_				BIT(21)
 #define MAC_WUCSR_RFE_WAKE_EN_			BIT(14)
 #define MAC_WUCSR_PFDA_EN_			BIT(3)
 #define MAC_WUCSR_WAKE_EN_			BIT(2)
@@ -221,6 +227,8 @@
 #define MAC_WUCSR_BCST_EN_			BIT(0)
 
 #define MAC_WK_SRC				(0x144)
+#define MAC_MP_SO_HI				(0x148)
+#define MAC_MP_SO_LO				(0x14C)
 
 #define MAC_WUF_CFG0			(0x150)
 #define MAC_NUM_OF_WUF_CFG		(32)
@@ -912,6 +920,7 @@ struct lan743x_adapter {
 	int                     msg_enable;
 #ifdef CONFIG_PM
 	u32			wolopts;
+	u8			sopass[SOPASS_MAX];
 #endif
 	struct pci_dev		*pdev;
 	struct lan743x_csr      csr;
@@ -937,6 +946,7 @@ struct lan743x_adapter {
 
 #define LAN743X_ADAPTER_FLAG_OTP		BIT(0)
 	u32			flags;
+	u32			hw_cfg;
 };
 
 #define LAN743X_COMPONENT_FLAG_RX(channel)  BIT(20 + (channel))
-- 
2.25.1

