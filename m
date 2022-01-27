Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0B049E90A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244616AbiA0RbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:31:14 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:57213 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244611AbiA0RbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:31:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643304673; x=1674840673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pN3+MinvIjr5kdsH+qO83RbSDc0aHM1KbiRnud+JJgU=;
  b=sHuG5mqrLFJ5Nkz4npKRyQvjIuIC9gNLKPaE5vyCTp5SnFvhYsRXDiTy
   6bGwXRsp87PRm5wDwGmOY8oIUpWZ5n9MvQGf0AoTZb2H7TViveQVElhWt
   AJjWof7HWPyss7jEslY3oh0xCxc67hcan15P4k0y9NKjBWY4lt+aAMtkS
   9o31S5jUEiDWoA3g9HOPSXJGpBUKLfeJBISoGnd7js1zx5MxZPi8TGJdG
   DyYgFZZw4W4jFXVQUclKm+8zzWTouo8jCYzT7d7s7fx1qYxi4iq/l39Nf
   jIPuptbM3JaHRk+NnEkWYisEe/5lGm92XFRZUzkPNQYQHnBDCxxRB3wTE
   A==;
IronPort-SDR: AmwDSJ1+FEOO9h3KkZKKMARe5A4CHPd+hBN4RCeGnBOJCH9eNO/Qs1wfnS9Mk1PmIjTyeeTFx8
 UFeb8TjrvYWnYjSQbLL7G0uNCunTEwveg7hx6RnS8oKfZIW9SkrjHRqF7RJDIx2Q4xweyPasNs
 DDlmh85KdAnCsaXAhqSlWNA62SBM79nP9O+0RSlobwszR025/bCnovWPOry8WVyWhffsSM/ull
 A5xJNyblO1z1hz9Sa7d6yTX/Z1zAiT1eKZpjxxLrVh35KXyCI5F6JA7cuY2Xpwbne5Wep+jAYf
 VMcSWTsn3Uk5X3V8yGOYuV5Z
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="83901397"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 10:31:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 10:31:12 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 10:31:10 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 4/5] net: lan743x: Add support of selection between SGMII and GMII Interface
Date:   Thu, 27 Jan 2022 23:00:54 +0530
Message-ID: <20220127173055.308918-5-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
References: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCI1A011/PCI1A041 chip suuport SGMII interface

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 39 +++++++++++++++++++
 drivers/net/ethernet/microchip/lan743x_main.h | 15 +++++++
 2 files changed, 54 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index daba17b0ad6c..6f6655eb6438 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2801,6 +2801,8 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 
 static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 {
+	u32 sgmii_ctl;
+	u32 chip_ver;
 	int ret;
 
 	adapter->mdiobus = devm_mdiobus_alloc(&adapter->pdev->dev);
@@ -2809,6 +2811,43 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 		goto return_error;
 	}
 
+	/* GPY211 Interface enable */
+	chip_ver = lan743x_csr_read(adapter, FPGA_REV);
+	if (chip_ver) {
+		netif_info(adapter, drv, adapter->netdev,
+			   "FPGA Image version: 0x%08X\n", chip_ver);
+		if (chip_ver & FPGA_SGMII_OP) {
+			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
+			sgmii_ctl |= SGMII_CTL_SGMII_ENABLE_;
+			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
+			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
+			netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
+		} else {
+			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
+			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
+			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
+			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
+			netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
+		}
+	} else {
+		chip_ver = lan743x_csr_read(adapter, STRAP_READ);
+		netif_info(adapter, drv, adapter->netdev,
+			   "ASIC Image version: 0x%08X\n", chip_ver);
+		if (chip_ver & STRAP_READ_SGMII_EN_) {
+			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
+			sgmii_ctl |= SGMII_CTL_SGMII_ENABLE_;
+			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
+			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
+			netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
+		} else {
+			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
+			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
+			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
+			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
+			netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
+		}
+	}
+
 	adapter->mdiobus->priv = (void *)adapter;
 	adapter->mdiobus->read = lan743x_mdiobus_read;
 	adapter->mdiobus->write = lan743x_mdiobus_write;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 9c6bb8be2013..233555dd5464 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -29,6 +29,16 @@
 #define FPGA_REV			(0x04)
 #define FPGA_REV_GET_MINOR_(fpga_rev)	(((fpga_rev) >> 8) & 0x000000FF)
 #define FPGA_REV_GET_MAJOR_(fpga_rev)	((fpga_rev) & 0x000000FF)
+#define FPGA_SGMII_OP			BIT(24)
+
+#define STRAP_READ			(0x0C)
+#define STRAP_READ_SGMII_EN_		BIT(6)
+#define STRAP_READ_SGMII_REFCLK_	BIT(5)
+#define STRAP_READ_SGMII_2_5G_		BIT(4)
+#define STRAP_READ_BASE_X_		BIT(3)
+#define STRAP_READ_RGMII_TXC_DELAY_EN_	BIT(2)
+#define STRAP_READ_RGMII_RXC_DELAY_EN_	BIT(1)
+#define STRAP_READ_ADV_PM_DISABLE_	BIT(0)
 
 #define HW_CFG					(0x010)
 #define HW_CFG_RELOAD_TYPE_ALL_			(0x00000FC0)
@@ -218,6 +228,11 @@
 
 #define MAC_WUCSR2			(0x600)
 
+#define SGMII_CTL			(0x728)
+#define SGMII_CTL_SGMII_ENABLE_		BIT(31)
+#define SGMII_CTL_LINK_STATUS_SOURCE_	BIT(8)
+#define SGMII_CTL_SGMII_POWER_DN_	BIT(1)
+
 #define INT_STS				(0x780)
 #define INT_BIT_DMA_RX_(channel)	BIT(24 + (channel))
 #define INT_BIT_ALL_RX_			(0x0F000000)
-- 
2.25.1

