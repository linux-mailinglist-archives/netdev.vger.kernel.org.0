Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FEF4B361C
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 16:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbiBLPyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 10:54:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiBLPyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 10:54:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B52B9
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 07:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644681239; x=1676217239;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f7IDvLlOE+eTC6EiSiyRTyO3hbUar7Tqaz6EUokbg2Y=;
  b=DfQAvfnYZYOGnYn0vk5uuVOrEWyFfELi6EfvPmQDcL7sCekJaOlnwGeT
   qko0+EFpR5JKHX4ipOSt/cydXuIBGwuCDqkbuyGp5xAzp/BhVj1galx+8
   azgYFU6LJE82t2n4X8cbwD2DBnC96AMd/5nYqSurAGn3eRk3JPayMhSdZ
   bANr/8AnV+7cy3m6+PjJj5hlR2CMRGRxsEombsm0/YHTCfn9AHP2male+
   ygwbruwJH8jsPjF/DXQwONAMGperwRhU1ywYDGFkiTLPwjPbCb11hLxUm
   G9RIFEXiJrmWr/zjZPiCm3VUBu5+ABWEZYxABM7hYO2pCnJwq8MGZ3FvF
   g==;
IronPort-SDR: jShMyL4+Qeh3hPQofox9UsCxyu+iUALlnQzwAl4MV42/2/xqZ7J5liZDkvqWY8LkvrKUzB/o9f
 0g+MFBjmTgFtzcpRU8F6YR7plJymhgpl6rjSWBppnsYocRvOHGN2c5SwRoxFbbL1dFE/Bqeuq+
 N5R33i1NvpwyKtsISVK7lyniWT3Pq4Ea5bSXt3IyhZxEBRzL6pht8HanAN2rWARSMHOgopv7Vn
 yY7ttSqDcVN8m2K1L4NovXZGGfm0ZUzDnnPi053FkI7A3hm45LLwr5bW41Su6pQ01IVdbFP8IX
 SZbJWHEwXJDqG6e8njyNQwt3
X-IronPort-AV: E=Sophos;i="5.88,363,1635231600"; 
   d="scan'208";a="152858654"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2022 08:53:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 12 Feb 2022 08:53:35 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 12 Feb 2022 08:53:33 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next V1 5/5] net: lan743x: Add support for Clause-45 MDIO PHY management
Date:   Sat, 12 Feb 2022 21:23:15 +0530
Message-ID: <20220212155315.340359-6-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
References: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Clause-45 MDIO PHY management

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Changes:
 V1: 1. Remove "freq" argument in lan743x_mac_mmd_access( ) function
     2. Define MMD Operation macros instead of values

 drivers/net/ethernet/microchip/lan743x_main.c | 109 +++++++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.h |  16 +++
 2 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 8b0890aa66fa..5282d25a6f9b 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -18,6 +18,11 @@
 #include "lan743x_main.h"
 #include "lan743x_ethtool.h"
 
+#define MMD_ACCESS_ADDRESS	0
+#define MMD_ACCESS_WRITE	1
+#define MMD_ACCESS_READ		2
+#define MMD_ACCESS_READ_INC	3
+
 static void pci11x1x_strap_get_status(struct lan743x_adapter *adapter)
 {
 	u32 chip_rev;
@@ -814,6 +819,96 @@ static int lan743x_mdiobus_write(struct mii_bus *bus,
 	return ret;
 }
 
+static u32 lan743x_mac_mmd_access(int id, int index, int op)
+{
+	u16 dev_addr;
+	u32 ret;
+
+	dev_addr = (index >> 16) & 0x1f;
+	ret = (id << MAC_MII_ACC_PHY_ADDR_SHIFT_) &
+		MAC_MII_ACC_PHY_ADDR_MASK_;
+	ret |= (dev_addr << MAC_MII_ACC_MIIMMD_SHIFT_) &
+		MAC_MII_ACC_MIIMMD_MASK_;
+	if (op == MMD_ACCESS_WRITE)
+		ret |= MAC_MII_ACC_MIICMD_WRITE_;
+	else if (op == MMD_ACCESS_READ)
+		ret |= MAC_MII_ACC_MIICMD_READ_;
+	else if (op == MMD_ACCESS_READ_INC)
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
+		mmd_access = lan743x_mac_mmd_access(phy_id, index,
+						    MMD_ACCESS_ADDRESS);
+		lan743x_csr_write(adapter, MAC_MII_ACC, mmd_access);
+		ret = lan743x_mac_mii_wait_till_not_busy(adapter);
+		if (ret < 0)
+			return ret;
+		/* Read Data */
+		mmd_access = lan743x_mac_mmd_access(phy_id, index,
+						    MMD_ACCESS_READ);
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
+		mmd_access = lan743x_mac_mmd_access(phy_id, index,
+						    MMD_ACCESS_ADDRESS);
+		lan743x_csr_write(adapter, MAC_MII_ACC, mmd_access);
+		ret = lan743x_mac_mii_wait_till_not_busy(adapter);
+		if (ret < 0)
+			return ret;
+		/* Write Data */
+		lan743x_csr_write(adapter, MAC_MII_DATA, (u32)regval);
+		mmd_access = lan743x_mac_mmd_access(phy_id, index,
+						    MMD_ACCESS_WRITE);
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
@@ -2847,11 +2942,19 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 			netif_dbg(adapter, drv, adapter->netdev,
 					  "(R)GMII operation\n");
 		}
+
+		adapter->mdiobus->probe_capabilities = MDIOBUS_C22_C45;
+		adapter->mdiobus->read = lan743x_mdiobus_c45_read;
+		adapter->mdiobus->write = lan743x_mdiobus_c45_write;
+		adapter->mdiobus->name = "lan743x-mdiobus-c45";
+		netif_dbg(adapter, drv, adapter->netdev, "lan743x-mdiobus-c45\n");
+	} else {
+		adapter->mdiobus->read = lan743x_mdiobus_read;
+		adapter->mdiobus->write = lan743x_mdiobus_write;
+		adapter->mdiobus->name = "lan743x-mdiobus";
+		netif_dbg(adapter, drv, adapter->netdev, "lan743x-mdiobus\n");
 	}
 
-	adapter->mdiobus->read = lan743x_mdiobus_read;
-	adapter->mdiobus->write = lan743x_mdiobus_write;
-	adapter->mdiobus->name = "lan743x-mdiobus";
 	snprintf(adapter->mdiobus->id, MII_BUS_ID_SIZE,
 		 "pci-%s", pci_name(adapter->pdev));
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 7c387ca2d25c..2c8e76b4e1f7 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -151,6 +151,13 @@
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
@@ -159,6 +166,15 @@
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

