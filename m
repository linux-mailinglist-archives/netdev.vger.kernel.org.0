Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6833B49E90C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244611AbiA0Rbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:31:36 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:32171 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240239AbiA0Rbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:31:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643304695; x=1674840695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1tgw1M+S1Cj1d45rPu0CDjghKMmBCide0loK8LZc/NE=;
  b=wtRFzkbDdElUGNPjaWFHMLDOWBfoso2neqa6rjLw50+MItNFGbG2jpQT
   L3UqowHfn7iS997xEFBWb2sh4n2YzIJouaxAreNAwI0i6RF/YckW+i+ck
   UElDRF9MgGhYgQGewQwnDAzVisaj8Qqwt9gqSI3YkRRGgyokOqmz5+7eK
   2m+FRaEO7VbuGc8ksuuzQ7gRD40uB3lHlLnK8xfHEWWveiPMkXvZRUTud
   hgmugX+6HOnNK6J9T1oaTJo+ENnQKlo3m2e14eGxAFjPXp0QnQ/NZ/8VF
   rnCbyLL8AmvEgZEpMFDPUIRvmZEWSJiKhgBTCF/xcxUIqJkpDVRzybuoA
   Q==;
IronPort-SDR: iIn0nE/+WFL5eirbUPAdun+97+2jyLQwzML0uxhBT3NagVtr67zCEZBlMBkb2crs0d3CA1iCwv
 Mj9hnhVmACnJsQWODbq35HNptQB1kQalt3z2lfaJhlESnCCDk/7cDI0JmP/FTrS6oRM1O5G9ht
 9dE6E/XN/slFi9WfoS1hdHTDT+7WzZjxx+Nnz2WE+6Ff32sBBERNBEV7x8GbFrwdjWguD01kUQ
 a4dmr4fKL/i4N2DnDldpi2XDoPdDmfbqjmkr5Gc8Py+RcOT15gOstSlpsWsJu0p8P2AA8h8okG
 rrxBYNdQ90ary85YRZ1z9xPO
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="144113671"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 10:31:15 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 10:31:15 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 10:31:13 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 5/5] net: lan743x: Add Clause-45 MDIO access
Date:   Thu, 27 Jan 2022 23:00:55 +0530
Message-ID: <20220127173055.308918-6-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
References: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCI1A011/PCI1A041 chip support the MDIO Clause-45 access

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 110 +++++++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.h |  16 +++
 2 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 6f6655eb6438..98d346aaf627 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -793,6 +793,95 @@ static int lan743x_mdiobus_write(struct mii_bus *bus,
 	return ret;
 }
 
+static u32 lan743x_mac_mmd_access(int id, int index, int op, u8 freq)
+{
+	u16 dev_addr;
+	u32 ret;
+
+	dev_addr = (index >> 16) & 0x1f;
+	ret = (id << MAC_MII_ACC_PHY_ADDR_SHIFT_) &
+		MAC_MII_ACC_PHY_ADDR_MASK_;
+	ret |= (dev_addr << MAC_MII_ACC_MIIMMD_SHIFT_) &
+		MAC_MII_ACC_MIIMMD_MASK_;
+	if (freq)
+		ret |= (freq << MAC_MII_ACC_MDC_CYCLE_SHIFT_) &
+			MAC_MII_ACC_MDC_CYCLE_MASK_;
+	if (op == 1)
+		ret |= MAC_MII_ACC_MIICMD_WRITE_;
+	else if (op == 2)
+		ret |= MAC_MII_ACC_MIICMD_READ_;
+	else if (op == 3)
+		ret |= MAC_MII_ACC_MIICMD_READ_INC_;
+	else
+		ret |= MAC_MII_ACC_MIICMD_ADDR_;
+	ret |= (MAC_MII_ACC_MII_BUSY_ | MAC_MII_ACC_MIICL45_);
+
+	return ret;
+}
+
+static int lan743x_mdiobus_c45_read(struct mii_bus *bus, int phy_id, int index)
+{
+	struct lan743x_adapter *adapter = bus->priv;
+	u32 mmd_access;
+	int ret;
+
+	/* comfirm MII not busy */
+	ret = lan743x_mac_mii_wait_till_not_busy(adapter);
+	if (ret < 0)
+		return ret;
+	if (index & MII_ADDR_C45) {
+		/* Load Register Address */
+		lan743x_csr_write(adapter, MAC_MII_DATA, (u32)(index & 0xffff));
+		mmd_access = lan743x_mac_mmd_access(phy_id, index, 0, 0);
+		lan743x_csr_write(adapter, MAC_MII_ACC, mmd_access);
+		ret = lan743x_mac_mii_wait_till_not_busy(adapter);
+		if (ret < 0)
+			return ret;
+		/* Read Data */
+		mmd_access = lan743x_mac_mmd_access(phy_id, index, 2, 0);
+		lan743x_csr_write(adapter, MAC_MII_ACC, mmd_access);
+		ret = lan743x_mac_mii_wait_till_not_busy(adapter);
+		if (ret < 0)
+			return ret;
+		ret = lan743x_csr_read(adapter, MAC_MII_DATA);
+		return (int)(ret & 0xFFFF);
+	}
+
+	ret = lan743x_mdiobus_read(bus, phy_id, index);
+	return ret;
+}
+
+static int lan743x_mdiobus_c45_write(struct mii_bus *bus,
+				     int phy_id, int index, u16 regval)
+{
+	struct lan743x_adapter *adapter = bus->priv;
+	u32 mmd_access;
+	int ret;
+
+	/* confirm MII not busy */
+	ret = lan743x_mac_mii_wait_till_not_busy(adapter);
+	if (ret < 0)
+		return ret;
+	if (index & MII_ADDR_C45) {
+		/* Load Register Address */
+		lan743x_csr_write(adapter, MAC_MII_DATA, (u32)(index & 0xffff));
+		mmd_access = lan743x_mac_mmd_access(phy_id, index, 0, 0);
+		lan743x_csr_write(adapter, MAC_MII_ACC, mmd_access);
+		ret = lan743x_mac_mii_wait_till_not_busy(adapter);
+		if (ret < 0)
+			return ret;
+		/* Write Data */
+		lan743x_csr_write(adapter, MAC_MII_DATA, (u32)regval);
+		mmd_access = lan743x_mac_mmd_access(phy_id, index, 1, 0);
+		lan743x_csr_write(adapter, MAC_MII_ACC, mmd_access);
+		ret = lan743x_mac_mii_wait_till_not_busy(adapter);
+	} else {
+		ret = lan743x_mdiobus_write(bus, phy_id, index, regval);
+	}
+
+	return ret;
+}
+
 static void lan743x_mac_set_address(struct lan743x_adapter *adapter,
 				    u8 *addr)
 {
@@ -1053,6 +1142,9 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 					 PHY_INTERFACE_MODE_GMII);
 		if (ret)
 			goto return_error;
+
+		if (adapter->mdiobus->probe_capabilities == MDIOBUS_C45)
+			phydev->c45_ids.devices_in_package &= ~BIT(0);
 	}
 
 	/* MAC doesn't support 1000T Half */
@@ -2822,12 +2914,14 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
 			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
 			netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
+			adapter->mdiobus->probe_capabilities = MDIOBUS_C22_C45;
 		} else {
 			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
 			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
 			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
 			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
 			netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
+			adapter->mdiobus->probe_capabilities = MDIOBUS_C22;
 		}
 	} else {
 		chip_ver = lan743x_csr_read(adapter, STRAP_READ);
@@ -2839,19 +2933,29 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
 			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
 			netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
+			adapter->mdiobus->probe_capabilities = MDIOBUS_C22_C45;
 		} else {
 			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
 			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
 			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
 			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
 			netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
+			adapter->mdiobus->probe_capabilities = MDIOBUS_C22;
 		}
 	}
 
 	adapter->mdiobus->priv = (void *)adapter;
-	adapter->mdiobus->read = lan743x_mdiobus_read;
-	adapter->mdiobus->write = lan743x_mdiobus_write;
-	adapter->mdiobus->name = "lan743x-mdiobus";
+	if (adapter->mdiobus->probe_capabilities == MDIOBUS_C45 ||
+	    adapter->mdiobus->probe_capabilities == MDIOBUS_C22_C45) {
+		adapter->mdiobus->read = lan743x_mdiobus_c45_read;
+		adapter->mdiobus->write = lan743x_mdiobus_c45_write;
+		adapter->mdiobus->name = "lan743x-mdiobus-c45";
+	} else {
+		adapter->mdiobus->read = lan743x_mdiobus_read;
+		adapter->mdiobus->write = lan743x_mdiobus_write;
+		adapter->mdiobus->name = "lan743x-mdiobus";
+	}
+
 	snprintf(adapter->mdiobus->id, MII_BUS_ID_SIZE,
 		 "pci-%s", pci_name(adapter->pdev));
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 233555dd5464..12facf905eaa 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -149,6 +149,13 @@
 #define MAC_RX_ADDRL			(0x11C)
 
 #define MAC_MII_ACC			(0x120)
+#define MAC_MII_ACC_MDC_CYCLE_SHIFT_	(16)
+#define MAC_MII_ACC_MDC_CYCLE_MASK_	(0x00070000)
+#define MAC_MII_ACC_MDC_CYCLE_2_5MHZ_	(0)
+#define MAC_MII_ACC_MDC_CYCLE_5MHZ_	(1)
+#define MAC_MII_ACC_MDC_CYCLE_12_5MHZ_	(2)
+#define MAC_MII_ACC_MDC_CYCLE_25MHZ_	(3)
+#define MAC_MII_ACC_MDC_CYCLE_1_25MHZ_	(4)
 #define MAC_MII_ACC_PHY_ADDR_SHIFT_	(11)
 #define MAC_MII_ACC_PHY_ADDR_MASK_	(0x0000F800)
 #define MAC_MII_ACC_MIIRINDA_SHIFT_	(6)
@@ -157,6 +164,15 @@
 #define MAC_MII_ACC_MII_WRITE_		(0x00000002)
 #define MAC_MII_ACC_MII_BUSY_		BIT(0)
 
+#define MAC_MII_ACC_MIIMMD_SHIFT_	(6)
+#define MAC_MII_ACC_MIIMMD_MASK_	(0x000007C0)
+#define MAC_MII_ACC_MIICL45_		BIT(3)
+#define MAC_MII_ACC_MIICMD_MASK_	(0x00000006)
+#define MAC_MII_ACC_MIICMD_ADDR_	(0x00000000)
+#define MAC_MII_ACC_MIICMD_WRITE_	(0x00000002)
+#define MAC_MII_ACC_MIICMD_READ_	(0x00000004)
+#define MAC_MII_ACC_MIICMD_READ_INC_	(0x00000006)
+
 #define MAC_MII_DATA			(0x124)
 
 #define MAC_EEE_TX_LPI_REQ_DLY_CNT		(0x130)
-- 
2.25.1

