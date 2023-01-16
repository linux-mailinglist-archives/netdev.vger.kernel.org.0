Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A5066BC00
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjAPKka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjAPKkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:40:06 -0500
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE97F196AA
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 02:38:58 -0800 (PST)
X-QQ-mid: bizesmtp88t1673865531txe73ugd
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 16 Jan 2023 18:38:41 +0800 (CST)
X-QQ-SSF: 01400000000000M0O000000A0000000
X-QQ-FEAT: iDzLjIm7mlYiBhT7n+iWkYWxdrnDbnYRuYWR3ytPBM0AHDtf/tdWgS1bV4dtj
        it50CZMHco84rh0gQpuIBcAJ8qWld8nY9mRyBRi4FHFjdFvVjFYK3Zxs6hIbRbcDLU7SSmG
        U7xlBL+fbRCcp2v2YKTPbDXXftWKGUlVlyCoSFR9zDUZDRfVIQLpfsZkZzJYEb/+t+M9j9b
        M7+DFGmrWCn3MSCVrhmTK8oKCywAhA4QpC2Wze4pnmw3GSMjcuMyaKO6Cd+EJiNvr3HX9IW
        UZg6MwieqCtKVOIvUygItPXBhcqkncHC5E82Fwxtfha+a5NACdFsBKCdTAzWmKS90DyTxD7
        HvIU6IILh6T/LOLxlKTEpU6rJf9rgoeSzBjvGFU6KzyHJe6ujs5R9hUpHPHDtv2ab0ccw9r
        Omi7qg/PEwI=
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next] net: wangxun: clean up the code
Date:   Mon, 16 Jan 2023 18:38:39 +0800
Message-Id: <20230116103839.84087-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert various mult-bit fields to be defined using GENMASK/FIELD_PREP.
Simplify the code with the ternary operator.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 22 ++++++++-----------
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 15 +++++++------
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  8 ++-----
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h | 12 +++++-----
 4 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 786e1090cf84..3d7ba0c0df38 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -76,15 +76,11 @@ EXPORT_SYMBOL(wx_check_flash_load);
 
 void wx_control_hw(struct wx *wx, bool drv)
 {
-	if (drv) {
-		/* Let firmware know the driver has taken over */
-		wr32m(wx, WX_CFG_PORT_CTL,
-		      WX_CFG_PORT_CTL_DRV_LOAD, WX_CFG_PORT_CTL_DRV_LOAD);
-	} else {
-		/* Let firmware take over control of hw */
-		wr32m(wx, WX_CFG_PORT_CTL,
-		      WX_CFG_PORT_CTL_DRV_LOAD, 0);
-	}
+	/* True : Let firmware know the driver has taken over
+	 * False : Let firmware take over control of hw
+	 */
+	wr32m(wx, WX_CFG_PORT_CTL, WX_CFG_PORT_CTL_DRV_LOAD,
+	      drv ? WX_CFG_PORT_CTL_DRV_LOAD : 0);
 }
 EXPORT_SYMBOL(wx_control_hw);
 
@@ -575,8 +571,8 @@ static int wx_set_rar(struct wx *wx, u32 index, u8 *addr, u64 pools,
 
 	wr32(wx, WX_PSR_MAC_SWC_AD_L, rar_low);
 	wr32m(wx, WX_PSR_MAC_SWC_AD_H,
-	      (WX_PSR_MAC_SWC_AD_H_AD(~0) |
-	       WX_PSR_MAC_SWC_AD_H_ADTYPE(~0) |
+	      (WX_PSR_MAC_SWC_AD_H_AD(U16_MAX) |
+	       WX_PSR_MAC_SWC_AD_H_ADTYPE(1) |
 	       WX_PSR_MAC_SWC_AD_H_AV),
 	      rar_high);
 
@@ -611,8 +607,8 @@ static int wx_clear_rar(struct wx *wx, u32 index)
 
 	wr32(wx, WX_PSR_MAC_SWC_AD_L, 0);
 	wr32m(wx, WX_PSR_MAC_SWC_AD_H,
-	      (WX_PSR_MAC_SWC_AD_H_AD(~0) |
-	       WX_PSR_MAC_SWC_AD_H_ADTYPE(~0) |
+	      (WX_PSR_MAC_SWC_AD_H_AD(U16_MAX) |
+	       WX_PSR_MAC_SWC_AD_H_ADTYPE(1) |
 	       WX_PSR_MAC_SWC_AD_H_AV),
 	      0);
 
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 165f61698177..c86a37914d43 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -4,6 +4,8 @@
 #ifndef _WX_TYPE_H_
 #define _WX_TYPE_H_
 
+#include <linux/bitfield.h>
+
 /* Vendor ID */
 #ifndef PCI_VENDOR_ID_WANGXUN
 #define PCI_VENDOR_ID_WANGXUN                   0x8088
@@ -36,12 +38,11 @@
 #define WX_SPI_CMD                   0x10104
 #define WX_SPI_CMD_READ_DWORD        0x1
 #define WX_SPI_CLK_DIV               0x3
-#define WX_SPI_CMD_CMD(_v)           (((_v) & 0x7) << 28)
-#define WX_SPI_CMD_CLK(_v)           (((_v) & 0x7) << 25)
-#define WX_SPI_CMD_ADDR(_v)          (((_v) & 0xFFFFFF))
+#define WX_SPI_CMD_CMD(_v)           FIELD_PREP(GENMASK(30, 28), _v)
+#define WX_SPI_CMD_CLK(_v)           FIELD_PREP(GENMASK(27, 25), _v)
+#define WX_SPI_CMD_ADDR(_v)          FIELD_PREP(GENMASK(23, 0), _v)
 #define WX_SPI_DATA                  0x10108
 #define WX_SPI_DATA_BYPASS           BIT(31)
-#define WX_SPI_DATA_STATUS(_v)       (((_v) & 0xFF) << 16)
 #define WX_SPI_DATA_OP_DONE          BIT(0)
 #define WX_SPI_STATUS                0x1010C
 #define WX_SPI_STATUS_OPDONE         BIT(0)
@@ -113,8 +114,8 @@
 /* mac switcher */
 #define WX_PSR_MAC_SWC_AD_L          0x16200
 #define WX_PSR_MAC_SWC_AD_H          0x16204
-#define WX_PSR_MAC_SWC_AD_H_AD(v)       (((v) & 0xFFFF))
-#define WX_PSR_MAC_SWC_AD_H_ADTYPE(v)   (((v) & 0x1) << 30)
+#define WX_PSR_MAC_SWC_AD_H_AD(v)       FIELD_PREP(U16_MAX, v)
+#define WX_PSR_MAC_SWC_AD_H_ADTYPE(v)   FIELD_PREP(BIT(30), v)
 #define WX_PSR_MAC_SWC_AD_H_AV       BIT(31)
 #define WX_PSR_MAC_SWC_VM_L          0x16208
 #define WX_PSR_MAC_SWC_VM_H          0x1620C
@@ -134,7 +135,7 @@
 #define WX_MAC_TX_CFG                0x11000
 #define WX_MAC_TX_CFG_TE             BIT(0)
 #define WX_MAC_TX_CFG_SPEED_MASK     GENMASK(30, 29)
-#define WX_MAC_TX_CFG_SPEED_1G       (0x3 << 29)
+#define WX_MAC_TX_CFG_SPEED_1G       FIELD_PREP(WX_MAC_TX_CFG_SPEED_MASK, 3)
 #define WX_MAC_RX_CFG                0x11004
 #define WX_MAC_RX_CFG_RE             BIT(0)
 #define WX_MAC_RX_CFG_JE             BIT(8)
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
index b9534d608d35..6562a2de9527 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -49,12 +49,8 @@ static int ngbe_reset_misc(struct wx *wx)
 
 void ngbe_sfp_modules_txrx_powerctl(struct wx *wx, bool swi)
 {
-	if (swi)
-		/* gpio0 is used to power on control*/
-		wr32(wx, NGBE_GPIO_DR, 0);
-	else
-		/* gpio0 is used to power off control*/
-		wr32(wx, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
+	/* gpio0 is used to power on control . 0 is on */
+	wr32(wx, NGBE_GPIO_DR, swi ? 0 : NGBE_GPIO_DR_0);
 }
 
 /**
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 612b9da2db8f..fd71260f73de 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -49,7 +49,6 @@
 #define NGBE_SPI_ILDR_STATUS			0x10120
 #define NGBE_SPI_ILDR_STATUS_PERST		BIT(0) /* PCIE_PERST is done */
 #define NGBE_SPI_ILDR_STATUS_PWRRST		BIT(1) /* Power on reset is done */
-#define NGBE_SPI_ILDR_STATUS_LAN_SW_RST(_i)	BIT((_i) + 9) /* lan soft reset done */
 
 /* Checksum and EEPROM pointers */
 #define NGBE_CALSUM_COMMAND			0xE9
@@ -62,12 +61,11 @@
 
 /* mdio access */
 #define NGBE_MSCA				0x11200
-#define NGBE_MSCA_RA(v)				((0xFFFF & (v)))
-#define NGBE_MSCA_PA(v)				((0x1F & (v)) << 16)
-#define NGBE_MSCA_DA(v)				((0x1F & (v)) << 21)
+#define NGBE_MSCA_RA(v)				FIELD_PREP(U16_MAX, v)
+#define NGBE_MSCA_PA(v)				FIELD_PREP(GENMASK(20, 16), v)
+#define NGBE_MSCA_DA(v)				FIELD_PREP(GENMASK(25, 21), v)
 #define NGBE_MSCC				0x11204
-#define NGBE_MSCC_DATA(v)			((0xFFFF & (v)))
-#define NGBE_MSCC_CMD(v)			((0x3 & (v)) << 16)
+#define NGBE_MSCC_CMD(v)			FIELD_PREP(GENMASK(17, 16), v)
 
 enum NGBE_MSCA_CMD_value {
 	NGBE_MSCA_CMD_RSV = 0,
@@ -78,7 +76,7 @@ enum NGBE_MSCA_CMD_value {
 
 #define NGBE_MSCC_SADDR				BIT(18)
 #define NGBE_MSCC_BUSY				BIT(22)
-#define NGBE_MDIO_CLK(v)			((0x7 & (v)) << 19)
+#define NGBE_MDIO_CLK(v)			FIELD_PREP(GENMASK(21, 19), v)
 
 /* Media-dependent registers. */
 #define NGBE_MDIO_CLAUSE_SELECT			0x11220
-- 
2.39.0

