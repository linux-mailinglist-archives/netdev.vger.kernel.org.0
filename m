Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236A84DC42D
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiCQKo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbiCQKo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:44:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015441DEC23;
        Thu, 17 Mar 2022 03:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647513807; x=1679049807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qZuWXBv+U/n4TCpunyuEbs2mdThKzpsMkQAxycKKplg=;
  b=0uzpaQejUkOt1AxgMHCcMkBMYxCZW69yj6S0fy0nKlRLAuwJ5kf7aTmv
   yOEyHdtQPJWltwm38rdcxr55MIL+hqSCYfAzsRgua1aLMKI4KqVoQcTl8
   EwZn58cHkNdDQI1DzDLBnvwGoPNASQHVlvUkcZvN+Jt3wRR40tU5eSvsE
   L6EEOttx/PR6iXI4bpkJJqqDs6YvXnHegZfxoi6uS7n3c5JlwK3wpWmOK
   MtSMN5HEtPM85QarxiDAupMficDlMmuQEx8lThja9locl/9XGhEqQjA0R
   P/biqeGRZd3jQGLoNUjHiCqaGLJLKyZfJYhvw/AWNF9AzfmjSeOHVeyC8
   w==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="152326638"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 03:43:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 03:43:26 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 17 Mar 2022 03:43:23 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 3/5] net: lan743x: Add support for OTP
Date:   Thu, 17 Mar 2022 16:13:08 +0530
Message-ID: <20220317104310.61091-4-Raju.Lakkaraju@microchip.com>
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

Add new the OTP read and write access functions for PCI11010/PCI11414 chips
PCI11010/PCI11414 OTP module register offsets are different from
LAN743x OTP module

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Change List:                                                                    
V0 -> V1:                                                                       
 1. use the "readx_poll_timeout()"                                              
 2. Remove the MAX_OTP_SIZE check                                            
 3. Fix the checkpatch warnings                                                 
                                
 .../net/ethernet/microchip/lan743x_ethtool.c  | 169 +++++++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.h |  14 ++
 2 files changed, 180 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index af64ec8c344d..c8fe8b31f07b 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -212,6 +212,160 @@ static void lan743x_hs_syslock_release(struct lan743x_adapter *adapter)
 	spin_unlock(&adapter->eth_syslock_spinlock);
 }
 
+static void lan743x_hs_otp_power_up(struct lan743x_adapter *adapter)
+{
+	u32 reg_value;
+
+	reg_value = lan743x_csr_read(adapter, HS_OTP_PWR_DN);
+	if (reg_value & OTP_PWR_DN_PWRDN_N_) {
+		reg_value &= ~OTP_PWR_DN_PWRDN_N_;
+		lan743x_csr_write(adapter, HS_OTP_PWR_DN, reg_value);
+		/* To flush the posted write so the subsequent delay is
+		 * guaranteed to happen after the write at the hardware
+		 */
+		lan743x_csr_read(adapter, HS_OTP_PWR_DN);
+		udelay(1);
+	}
+}
+
+static void lan743x_hs_otp_power_down(struct lan743x_adapter *adapter)
+{
+	u32 reg_value;
+
+	reg_value = lan743x_csr_read(adapter, HS_OTP_PWR_DN);
+	if (!(reg_value & OTP_PWR_DN_PWRDN_N_)) {
+		reg_value |= OTP_PWR_DN_PWRDN_N_;
+		lan743x_csr_write(adapter, HS_OTP_PWR_DN, reg_value);
+		/* To flush the posted write so the subsequent delay is
+		 * guaranteed to happen after the write at the hardware
+		 */
+		lan743x_csr_read(adapter, HS_OTP_PWR_DN);
+		udelay(1);
+	}
+}
+
+static void lan743x_hs_otp_set_address(struct lan743x_adapter *adapter,
+				       u32 address)
+{
+	lan743x_csr_write(adapter, HS_OTP_ADDR_HIGH, (address >> 8) & 0x03);
+	lan743x_csr_write(adapter, HS_OTP_ADDR_LOW, address & 0xFF);
+}
+
+static void lan743x_hs_otp_read_go(struct lan743x_adapter *adapter)
+{
+	lan743x_csr_write(adapter, HS_OTP_FUNC_CMD, OTP_FUNC_CMD_READ_);
+	lan743x_csr_write(adapter, HS_OTP_CMD_GO, OTP_CMD_GO_GO_);
+}
+
+static int lan743x_hs_otp_cmd_cmplt_chk(struct lan743x_adapter *adapter)
+{
+	u32 val;
+
+	return readx_poll_timeout(LAN743X_CSR_READ_OP, HS_OTP_STATUS, val,
+				  !(val & OTP_STATUS_BUSY_),
+				  80, 10000);
+}
+
+static int lan743x_hs_otp_read(struct lan743x_adapter *adapter, u32 offset,
+			       u32 length, u8 *data)
+{
+	int ret;
+	int i;
+
+	ret = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
+	if (ret < 0)
+		return ret;
+
+	lan743x_hs_otp_power_up(adapter);
+
+	ret = lan743x_hs_otp_cmd_cmplt_chk(adapter);
+	if (ret < 0)
+		goto power_down;
+
+	lan743x_hs_syslock_release(adapter);
+
+	for (i = 0; i < length; i++) {
+		ret = lan743x_hs_syslock_acquire(adapter,
+						 LOCK_TIMEOUT_MAX_CNT);
+		if (ret < 0)
+			return ret;
+
+		lan743x_hs_otp_set_address(adapter, offset + i);
+
+		lan743x_hs_otp_read_go(adapter);
+		ret = lan743x_hs_otp_cmd_cmplt_chk(adapter);
+		if (ret < 0)
+			goto power_down;
+
+		data[i] = lan743x_csr_read(adapter, HS_OTP_READ_DATA);
+
+		lan743x_hs_syslock_release(adapter);
+	}
+
+	ret = lan743x_hs_syslock_acquire(adapter,
+					 LOCK_TIMEOUT_MAX_CNT);
+	if (ret < 0)
+		return ret;
+
+power_down:
+	lan743x_hs_otp_power_down(adapter);
+	lan743x_hs_syslock_release(adapter);
+
+	return ret;
+}
+
+static int lan743x_hs_otp_write(struct lan743x_adapter *adapter, u32 offset,
+				u32 length, u8 *data)
+{
+	int ret;
+	int i;
+
+	ret = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
+	if (ret < 0)
+		return ret;
+
+	lan743x_hs_otp_power_up(adapter);
+
+	ret = lan743x_hs_otp_cmd_cmplt_chk(adapter);
+	if (ret < 0)
+		goto power_down;
+
+	/* set to BYTE program mode */
+	lan743x_csr_write(adapter, HS_OTP_PRGM_MODE, OTP_PRGM_MODE_BYTE_);
+
+	lan743x_hs_syslock_release(adapter);
+
+	for (i = 0; i < length; i++) {
+		ret = lan743x_hs_syslock_acquire(adapter,
+						 LOCK_TIMEOUT_MAX_CNT);
+		if (ret < 0)
+			return ret;
+
+		lan743x_hs_otp_set_address(adapter, offset + i);
+
+		lan743x_csr_write(adapter, HS_OTP_PRGM_DATA, data[i]);
+		lan743x_csr_write(adapter, HS_OTP_TST_CMD,
+				  OTP_TST_CMD_PRGVRFY_);
+		lan743x_csr_write(adapter, HS_OTP_CMD_GO, OTP_CMD_GO_GO_);
+
+		ret = lan743x_hs_otp_cmd_cmplt_chk(adapter);
+		if (ret < 0)
+			goto power_down;
+
+		lan743x_hs_syslock_release(adapter);
+	}
+
+	ret = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
+	if (ret < 0)
+		return ret;
+
+power_down:
+	lan743x_hs_otp_power_down(adapter);
+	lan743x_hs_syslock_release(adapter);
+
+	return ret;
+}
+
 static int lan743x_eeprom_wait(struct lan743x_adapter *adapter)
 {
 	unsigned long start_time = jiffies;
@@ -462,7 +616,12 @@ static int lan743x_ethtool_get_eeprom(struct net_device *netdev,
 	int ret = 0;
 
 	if (adapter->flags & LAN743X_ADAPTER_FLAG_OTP) {
-		ret = lan743x_otp_read(adapter, ee->offset, ee->len, data);
+		if (adapter->is_pci11x1x)
+			ret = lan743x_hs_otp_read(adapter, ee->offset,
+						  ee->len, data);
+		else
+			ret = lan743x_otp_read(adapter, ee->offset,
+					       ee->len, data);
 	} else {
 		if (adapter->is_pci11x1x)
 			ret = lan743x_hs_eeprom_read(adapter, ee->offset,
@@ -484,8 +643,12 @@ static int lan743x_ethtool_set_eeprom(struct net_device *netdev,
 	if (adapter->flags & LAN743X_ADAPTER_FLAG_OTP) {
 		/* Beware!  OTP is One Time Programming ONLY! */
 		if (ee->magic == LAN743X_OTP_MAGIC) {
-			ret = lan743x_otp_write(adapter, ee->offset,
-						ee->len, data);
+			if (adapter->is_pci11x1x)
+				ret = lan743x_hs_otp_write(adapter, ee->offset,
+							   ee->len, data);
+			else
+				ret = lan743x_otp_write(adapter, ee->offset,
+							ee->len, data);
 		}
 	} else {
 		if (ee->magic == LAN743X_EEPROM_MAGIC) {
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 5ae3420340f3..d1036a323c52 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -556,6 +556,20 @@
 #define OTP_STATUS				(0x1030)
 #define OTP_STATUS_BUSY_			BIT(0)
 
+/* Hearthstone OTP block registers */
+#define HS_OTP_BLOCK_BASE			(ETH_SYS_REG_ADDR_BASE + \
+						 ETH_OTP_REG_ADDR_BASE)
+#define HS_OTP_PWR_DN				(HS_OTP_BLOCK_BASE + 0x0)
+#define HS_OTP_ADDR_HIGH			(HS_OTP_BLOCK_BASE + 0x4)
+#define HS_OTP_ADDR_LOW				(HS_OTP_BLOCK_BASE + 0x8)
+#define HS_OTP_PRGM_DATA			(HS_OTP_BLOCK_BASE + 0x10)
+#define HS_OTP_PRGM_MODE			(HS_OTP_BLOCK_BASE + 0x14)
+#define HS_OTP_READ_DATA			(HS_OTP_BLOCK_BASE + 0x18)
+#define HS_OTP_FUNC_CMD				(HS_OTP_BLOCK_BASE + 0x20)
+#define HS_OTP_TST_CMD				(HS_OTP_BLOCK_BASE + 0x24)
+#define HS_OTP_CMD_GO				(HS_OTP_BLOCK_BASE + 0x28)
+#define HS_OTP_STATUS				(HS_OTP_BLOCK_BASE + 0x30)
+
 /* MAC statistics registers */
 #define STAT_RX_FCS_ERRORS			(0x1200)
 #define STAT_RX_ALIGNMENT_ERRORS		(0x1204)
-- 
2.25.1

