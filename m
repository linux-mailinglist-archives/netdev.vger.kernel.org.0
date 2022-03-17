Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9BE4DC429
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbiCQKoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiCQKok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:44:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A84DEBAB;
        Thu, 17 Mar 2022 03:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647513804; x=1679049804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WIjjE61BQ0+XpHOugTufbMZQg9a3ch/Eun5dxvwsaqo=;
  b=ygldAYoy3hXBaZwomdnpd72Ctn1AtJ9Vgym3n9HmK8Sy2HPNQ1n1h/wr
   v0CMq/8GywenwxVLZVZpt4GGWmusGw/pnQIfbwpUq9YPVY0Qa/8CwZJJ2
   0QSWj4rpgHotYNYKgCm/UYJNBrfHVzPtt3RXTAD/ZnukgYbYu8KyAUANh
   JDlDNAPlj15e+/ySB20/4q4cf4OgjZPiwf2SFsYfJTe7mr7Z8kyKZjZNB
   P1awYvY12fmipfcB1BIy79c1as9JIPUuDhIV4Gq8Pp8U39BiVNExr2gg6
   z/xd/BFHVlpSpQwG65nmNnYkZhpaUCA1swcx2wNq0VJaFLBRA56YcsaGD
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="149509392"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 03:43:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 03:43:23 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 17 Mar 2022 03:43:19 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 2/5] net: lan743x: Add support for EEPROM
Date:   Thu, 17 Mar 2022 16:13:07 +0530
Message-ID: <20220317104310.61091-3-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317104310.61091-1-Raju.Lakkaraju@microchip.com>
References: <20220317104310.61091-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new the EEPROM read and write access functions and system lock
protection to access by devices for PCI11010/PCI11414 chips

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Change List:                                                                    
V0 -> V1:                                                                       
 1. use the "readx_poll_timeout()"                                              
 2. Remove the MAX_EEPROM_SIZE check
 3. Fix the checkpatch warnings

 .../net/ethernet/microchip/lan743x_ethtool.c  | 178 +++++++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.c |   1 +
 drivers/net/ethernet/microchip/lan743x_main.h |  38 ++++
 3 files changed, 212 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index d13d284cdaea..af64ec8c344d 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -7,6 +7,8 @@
 #include <linux/phy.h>
 #include "lan743x_main.h"
 #include "lan743x_ethtool.h"
+#include <linux/sched.h>
+#include <linux/iopoll.h>
 
 /* eeprom */
 #define LAN743X_EEPROM_MAGIC		    (0x74A5)
@@ -19,6 +21,10 @@
 #define OTP_INDICATOR_1			    (0xF3)
 #define OTP_INDICATOR_2			    (0xF7)
 
+#define LOCK_TIMEOUT_MAX_CNT		    (100) // 1 sec (10 msce * 100)
+
+#define LAN743X_CSR_READ_OP(offset)	     lan743x_csr_read(adapter, offset)
+
 static int lan743x_otp_power_up(struct lan743x_adapter *adapter)
 {
 	u32 reg_value;
@@ -149,6 +155,63 @@ static int lan743x_otp_write(struct lan743x_adapter *adapter, u32 offset,
 	return 0;
 }
 
+static int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter,
+				      u16 timeout)
+{
+	u16 timeout_cnt = 0;
+	u32 val;
+
+	do {
+		spin_lock(&adapter->eth_syslock_spinlock);
+		if (adapter->eth_syslock_acquire_cnt == 0) {
+			lan743x_csr_write(adapter, ETH_SYSTEM_SYS_LOCK_REG,
+					  SYS_LOCK_REG_ENET_SS_LOCK_);
+			val = lan743x_csr_read(adapter,
+					       ETH_SYSTEM_SYS_LOCK_REG);
+			if (val & SYS_LOCK_REG_ENET_SS_LOCK_) {
+				adapter->eth_syslock_acquire_cnt++;
+				WARN_ON(adapter->eth_syslock_acquire_cnt == 0);
+				spin_unlock(&adapter->eth_syslock_spinlock);
+				break;
+			}
+		} else {
+			adapter->eth_syslock_acquire_cnt++;
+			WARN_ON(adapter->eth_syslock_acquire_cnt == 0);
+			spin_unlock(&adapter->eth_syslock_spinlock);
+			break;
+		}
+
+		spin_unlock(&adapter->eth_syslock_spinlock);
+
+		if (timeout_cnt++ < timeout)
+			usleep_range(10000, 11000);
+		else
+			return -ETIMEDOUT;
+	} while (true);
+
+	return 0;
+}
+
+static void lan743x_hs_syslock_release(struct lan743x_adapter *adapter)
+{
+	u32 val;
+
+	spin_lock(&adapter->eth_syslock_spinlock);
+	WARN_ON(adapter->eth_syslock_acquire_cnt == 0);
+
+	if (adapter->eth_syslock_acquire_cnt) {
+		adapter->eth_syslock_acquire_cnt--;
+		if (adapter->eth_syslock_acquire_cnt == 0) {
+			lan743x_csr_write(adapter, ETH_SYSTEM_SYS_LOCK_REG, 0);
+			val = lan743x_csr_read(adapter,
+					       ETH_SYSTEM_SYS_LOCK_REG);
+			WARN_ON((val & SYS_LOCK_REG_ENET_SS_LOCK_) != 0);
+		}
+	}
+
+	spin_unlock(&adapter->eth_syslock_spinlock);
+}
+
 static int lan743x_eeprom_wait(struct lan743x_adapter *adapter)
 {
 	unsigned long start_time = jiffies;
@@ -263,6 +326,100 @@ static int lan743x_eeprom_write(struct lan743x_adapter *adapter,
 	return 0;
 }
 
+static int lan743x_hs_eeprom_cmd_cmplt_chk(struct lan743x_adapter *adapter)
+{
+	u32 val;
+
+	return readx_poll_timeout(LAN743X_CSR_READ_OP, HS_E2P_CMD, val,
+				  (!(val & HS_E2P_CMD_EPC_BUSY_) ||
+				    (val & HS_E2P_CMD_EPC_TIMEOUT_)),
+				  50, 10000);
+}
+
+static int lan743x_hs_eeprom_read(struct lan743x_adapter *adapter,
+				  u32 offset, u32 length, u8 *data)
+{
+	int retval;
+	u32 val;
+	int i;
+
+	retval = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
+	if (retval < 0)
+		return retval;
+
+	retval = lan743x_hs_eeprom_cmd_cmplt_chk(adapter);
+	lan743x_hs_syslock_release(adapter);
+	if (retval < 0)
+		return retval;
+
+	for (i = 0; i < length; i++) {
+		retval = lan743x_hs_syslock_acquire(adapter,
+						    LOCK_TIMEOUT_MAX_CNT);
+		if (retval < 0)
+			return retval;
+
+		val = HS_E2P_CMD_EPC_BUSY_ | HS_E2P_CMD_EPC_CMD_READ_;
+		val |= (offset & HS_E2P_CMD_EPC_ADDR_MASK_);
+		lan743x_csr_write(adapter, HS_E2P_CMD, val);
+		retval = lan743x_hs_eeprom_cmd_cmplt_chk(adapter);
+		if (retval < 0) {
+			lan743x_hs_syslock_release(adapter);
+			return retval;
+		}
+
+		val = lan743x_csr_read(adapter, HS_E2P_DATA);
+
+		lan743x_hs_syslock_release(adapter);
+
+		data[i] = val & 0xFF;
+		offset++;
+	}
+
+	return 0;
+}
+
+static int lan743x_hs_eeprom_write(struct lan743x_adapter *adapter,
+				   u32 offset, u32 length, u8 *data)
+{
+	int retval;
+	u32 val;
+	int i;
+
+	retval = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
+	if (retval < 0)
+		return retval;
+
+	retval = lan743x_hs_eeprom_cmd_cmplt_chk(adapter);
+	lan743x_hs_syslock_release(adapter);
+	if (retval < 0)
+		return retval;
+
+	for (i = 0; i < length; i++) {
+		retval = lan743x_hs_syslock_acquire(adapter,
+						    LOCK_TIMEOUT_MAX_CNT);
+		if (retval < 0)
+			return retval;
+
+		/* Fill data register */
+		val = data[i];
+		lan743x_csr_write(adapter, HS_E2P_DATA, val);
+
+		/* Send "write" command */
+		val = HS_E2P_CMD_EPC_BUSY_ | HS_E2P_CMD_EPC_CMD_WRITE_;
+		val |= (offset & HS_E2P_CMD_EPC_ADDR_MASK_);
+		lan743x_csr_write(adapter, HS_E2P_CMD, val);
+
+		retval = lan743x_hs_eeprom_cmd_cmplt_chk(adapter);
+		lan743x_hs_syslock_release(adapter);
+		if (retval < 0)
+			return retval;
+
+		offset++;
+	}
+
+	return 0;
+}
+
 static void lan743x_ethtool_get_drvinfo(struct net_device *netdev,
 					struct ethtool_drvinfo *info)
 {
@@ -304,10 +461,16 @@ static int lan743x_ethtool_get_eeprom(struct net_device *netdev,
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 	int ret = 0;
 
-	if (adapter->flags & LAN743X_ADAPTER_FLAG_OTP)
+	if (adapter->flags & LAN743X_ADAPTER_FLAG_OTP) {
 		ret = lan743x_otp_read(adapter, ee->offset, ee->len, data);
-	else
-		ret = lan743x_eeprom_read(adapter, ee->offset, ee->len, data);
+	} else {
+		if (adapter->is_pci11x1x)
+			ret = lan743x_hs_eeprom_read(adapter, ee->offset,
+						     ee->len, data);
+		else
+			ret = lan743x_eeprom_read(adapter, ee->offset,
+						  ee->len, data);
+	}
 
 	return ret;
 }
@@ -326,8 +489,13 @@ static int lan743x_ethtool_set_eeprom(struct net_device *netdev,
 		}
 	} else {
 		if (ee->magic == LAN743X_EEPROM_MAGIC) {
-			ret = lan743x_eeprom_write(adapter, ee->offset,
-						   ee->len, data);
+			if (adapter->is_pci11x1x)
+				ret = lan743x_hs_eeprom_write(adapter,
+							      ee->offset,
+							      ee->len, data);
+			else
+				ret = lan743x_eeprom_write(adapter, ee->offset,
+							   ee->len, data);
 		}
 	}
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 7ace3ed35778..9ac0c2b96a15 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2869,6 +2869,7 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 		adapter->used_tx_channels = PCI11X1X_USED_TX_CHANNELS;
 		adapter->max_vector_count = PCI11X1X_MAX_VECTOR_COUNT;
 		pci11x1x_strap_get_status(adapter);
+		spin_lock_init(&adapter->eth_syslock_spinlock);
 	} else {
 		adapter->max_tx_channels = LAN743X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = LAN743X_USED_TX_CHANNELS;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index bca9f105900c..5ae3420340f3 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -86,6 +86,40 @@
 
 #define E2P_DATA			(0x044)
 
+/* Hearthstone top level & System Reg Addresses */
+#define ETH_CTRL_REG_ADDR_BASE		(0x0000)
+#define ETH_SYS_REG_ADDR_BASE		(0x4000)
+#define CONFIG_REG_ADDR_BASE		(0x0000)
+#define ETH_EEPROM_REG_ADDR_BASE	(0x0E00)
+#define ETH_OTP_REG_ADDR_BASE		(0x1000)
+#define SYS_LOCK_REG			(0x00A0)
+#define SYS_LOCK_REG_MAIN_LOCK_		BIT(7)
+#define SYS_LOCK_REG_GEN_PERI_LOCK_	BIT(5)
+#define SYS_LOCK_REG_SPI_PERI_LOCK_	BIT(4)
+#define SYS_LOCK_REG_SMBUS_PERI_LOCK_	BIT(3)
+#define SYS_LOCK_REG_UART_SS_LOCK_	BIT(2)
+#define SYS_LOCK_REG_ENET_SS_LOCK_	BIT(1)
+#define SYS_LOCK_REG_USB_SS_LOCK_	BIT(0)
+#define ETH_SYSTEM_SYS_LOCK_REG		(ETH_SYS_REG_ADDR_BASE + \
+					 CONFIG_REG_ADDR_BASE + \
+					 SYS_LOCK_REG)
+#define HS_EEPROM_REG_ADDR_BASE		(ETH_SYS_REG_ADDR_BASE + \
+					 ETH_EEPROM_REG_ADDR_BASE)
+#define HS_E2P_CMD			(HS_EEPROM_REG_ADDR_BASE + 0x0000)
+#define HS_E2P_CMD_EPC_BUSY_		BIT(31)
+#define HS_E2P_CMD_EPC_CMD_WRITE_	GENMASK(29, 28)
+#define HS_E2P_CMD_EPC_CMD_READ_	(0x0)
+#define HS_E2P_CMD_EPC_TIMEOUT_		BIT(17)
+#define HS_E2P_CMD_EPC_ADDR_MASK_	GENMASK(15, 0)
+#define HS_E2P_DATA			(HS_EEPROM_REG_ADDR_BASE + 0x0004)
+#define HS_E2P_DATA_MASK_		GENMASK(7, 0)
+#define HS_E2P_CFG			(HS_EEPROM_REG_ADDR_BASE + 0x0008)
+#define HS_E2P_CFG_I2C_PULSE_MASK_	GENMASK(19, 16)
+#define HS_E2P_CFG_EEPROM_SIZE_SEL_	BIT(12)
+#define HS_E2P_CFG_I2C_BAUD_RATE_MASK_	GENMASK(9, 8)
+#define HS_E2P_CFG_TEST_EEPR_TO_BYP_	BIT(0)
+#define HS_E2P_PAD_CTL			(HS_EEPROM_REG_ADDR_BASE + 0x000C)
+
 #define GPIO_CFG0			(0x050)
 #define GPIO_CFG0_GPIO_DIR_BIT_(bit)	BIT(16 + (bit))
 #define GPIO_CFG0_GPIO_DATA_BIT_(bit)	BIT(0 + (bit))
@@ -773,6 +807,10 @@ struct lan743x_adapter {
 	struct lan743x_rx       rx[LAN743X_USED_RX_CHANNELS];
 	bool			is_pci11x1x;
 	bool			is_sgmii_en;
+	/* protect ethernet syslock */
+	spinlock_t		eth_syslock_spinlock;
+	bool			eth_syslock_en;
+	u32			eth_syslock_acquire_cnt;
 	u8			max_tx_channels;
 	u8			used_tx_channels;
 	u8			max_vector_count;
-- 
2.25.1

