Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08705EF237
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbiI2Jgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbiI2JgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:36:03 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F44959251
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:35:42 -0700 (PDT)
X-QQ-mid: bizesmtp88t1664444136tr9qe67j
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 29 Sep 2022 17:35:36 +0800 (CST)
X-QQ-SSF: 01400000000000G0U000000A0000000
X-QQ-FEAT: oGOjGSUjcuDiL9oP+ReGU9KJMzi22EYQAdBZVhJ6NB5V+wbZpIcSgLzfXxa7S
        w0J8gDuLxzoKEckFfoIiW2Kmia4drFnP6RAYohLPhNMmlUitO7n9BtBMKvQukWyH3bE/ttS
        QGasijcgPc1abHG21rZeED5HaNpudTr9xqpDR/NscBPrP9xxlzA+laOc0VvNzVIXfehcRAC
        aKqOWPKfy7YCd+8RtLVzdsrJlG31YDUhTqHKMIhKivJ8+polimgHZ3uNQ4uaznsaHikvrhO
        EUcydew3bNa5urjMYbpq1Pj1sV177FCAlAOiioYgZxWp2GYvr23yHyeMI8+FgelYpmVRJr3
        b+7Tgz3e09MPyilbTTDgkiUFKk+Ikb4kMez1gjrddsjn1UHhiDDeIBZ6sgFkB2/mGGhaCCR
        N2iRLdOcfUU=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 2/3] net: txgbe: Reset hardware
Date:   Thu, 29 Sep 2022 17:34:23 +0800
Message-Id: <20220929093424.2104246-3-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220929093424.2104246-1-jiawenwu@trustnetic.com>
References: <20220929093424.2104246-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reset and initialize the hardware by configuring the MAC layer.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 160 ++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   2 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 144 ++++++++++++++++
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   5 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  86 ++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   9 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  21 +++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  11 +-
 9 files changed, 432 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index fed51c2f3071..76f88cfb2476 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -7,6 +7,21 @@
 #include "wx_type.h"
 #include "wx_hw.h"
 
+static void wx_intr_disable(struct wx_hw *wxhw, u64 qmask)
+{
+	u32 mask;
+
+	mask = (qmask & 0xFFFFFFFF);
+	if (mask)
+		wr32(wxhw, WX_PX_IMS(0), mask);
+
+	if (wxhw->mac.type == wx_mac_sp) {
+		mask = (qmask >> 32);
+		if (mask)
+			wr32(wxhw, WX_PX_IMS(1), mask);
+	}
+}
+
 /* cmd_addr is used for some special command:
  * 1. to be sector address, when implemented erase sector command
  * 2. to be flash address when implemented read, write flash address
@@ -56,6 +71,151 @@ int wx_check_flash_load(struct wx_hw *hw, u32 check_bit)
 }
 EXPORT_SYMBOL(wx_check_flash_load);
 
+static void wx_disable_rx(struct wx_hw *wxhw)
+{
+	u32 pfdtxgswc;
+	u32 rxctrl;
+
+	rxctrl = rd32(wxhw, WX_RDB_PB_CTL);
+	if (rxctrl & WX_RDB_PB_CTL_RXEN) {
+		pfdtxgswc = rd32(wxhw, WX_PSR_CTL);
+		if (pfdtxgswc & WX_PSR_CTL_SW_EN) {
+			pfdtxgswc &= ~WX_PSR_CTL_SW_EN;
+			wr32(wxhw, WX_PSR_CTL, pfdtxgswc);
+			wxhw->mac.set_lben = true;
+		} else {
+			wxhw->mac.set_lben = false;
+		}
+		rxctrl &= ~WX_RDB_PB_CTL_RXEN;
+		wr32(wxhw, WX_RDB_PB_CTL, rxctrl);
+
+		if (!(((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
+		      ((wxhw->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP))) {
+			/* disable mac receiver */
+			wr32m(wxhw, WX_MAC_RX_CFG,
+			      WX_MAC_RX_CFG_RE, 0);
+		}
+	}
+}
+
+/**
+ *  wx_disable_pcie_master - Disable PCI-express master access
+ *  @wxhw: pointer to hardware structure
+ *
+ *  Disables PCI-Express master access and verifies there are no pending
+ *  requests.
+ **/
+static int wx_disable_pcie_master(struct wx_hw *wxhw)
+{
+	int status = 0;
+	u32 val;
+
+	/* Always set this bit to ensure any future transactions are blocked */
+	pci_clear_master(wxhw->pdev);
+
+	/* Exit if master requests are blocked */
+	if (!(rd32(wxhw, WX_PX_TRANSACTION_PENDING)))
+		return 0;
+
+	/* Poll for master request bit to clear */
+	status = read_poll_timeout(rd32, val, !val, 100, WX_PCI_MASTER_DISABLE_TIMEOUT,
+				   false, wxhw, WX_PX_TRANSACTION_PENDING);
+	if (status < 0)
+		wx_err(wxhw, "PCIe transaction pending bit did not clear.\n");
+
+	return status;
+}
+
+/**
+ *  wx_stop_adapter - Generic stop Tx/Rx units
+ *  @hw: pointer to hardware structure
+ *
+ *  Sets the adapter_stopped flag within wx_hw struct. Clears interrupts,
+ *  disables transmit and receive units. The adapter_stopped flag is used by
+ *  the shared code and drivers to determine if the adapter is in a stopped
+ *  state and should not touch the hardware.
+ **/
+int wx_stop_adapter(struct wx_hw *wxhw)
+{
+	u16 i;
+
+	/* Set the adapter_stopped flag so other driver functions stop touching
+	 * the hardware
+	 */
+	wxhw->adapter_stopped = true;
+
+	/* Disable the receive unit */
+	wx_disable_rx(wxhw);
+
+	/* Set interrupt mask to stop interrupts from being generated */
+	wx_intr_disable(wxhw, WX_INTR_ALL);
+
+	/* Clear any pending interrupts, flush previous writes */
+	wr32(wxhw, WX_PX_MISC_IC, 0xffffffff);
+	wr32(wxhw, WX_BME_CTL, 0x3);
+
+	/* Disable the transmit unit.  Each queue must be disabled. */
+	for (i = 0; i < wxhw->mac.max_tx_queues; i++) {
+		wr32m(wxhw, WX_PX_TR_CFG(i),
+		      WX_PX_TR_CFG_SWFLSH | WX_PX_TR_CFG_ENABLE,
+		      WX_PX_TR_CFG_SWFLSH);
+	}
+
+	/* Disable the receive unit by stopping each queue */
+	for (i = 0; i < wxhw->mac.max_rx_queues; i++) {
+		wr32m(wxhw, WX_PX_RR_CFG(i),
+		      WX_PX_RR_CFG_RR_EN, 0);
+	}
+
+	/* flush all queues disables */
+	WX_WRITE_FLUSH(wxhw);
+
+	/* Prevent the PCI-E bus from hanging by disabling PCI-E master
+	 * access and verify no pending requests
+	 */
+	return wx_disable_pcie_master(wxhw);
+}
+EXPORT_SYMBOL(wx_stop_adapter);
+
+void wx_reset_misc(struct wx_hw *wxhw)
+{
+	int i;
+
+	/* receive packets that size > 2048 */
+	wr32m(wxhw, WX_MAC_RX_CFG, WX_MAC_RX_CFG_JE, WX_MAC_RX_CFG_JE);
+
+	/* clear counters on read */
+	wr32m(wxhw, WX_MMC_CONTROL,
+	      WX_MMC_CONTROL_RSTONRD, WX_MMC_CONTROL_RSTONRD);
+
+	wr32m(wxhw, WX_MAC_RX_FLOW_CTRL,
+	      WX_MAC_RX_FLOW_CTRL_RFE, WX_MAC_RX_FLOW_CTRL_RFE);
+
+	wr32(wxhw, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
+
+	wr32m(wxhw, WX_MIS_RST_ST,
+	      WX_MIS_RST_ST_RST_INIT, 0x1E00);
+
+	/* errata 4: initialize mng flex tbl and wakeup flex tbl*/
+	wr32(wxhw, WX_PSR_MNG_FLEX_SEL, 0);
+	for (i = 0; i < 16; i++) {
+		wr32(wxhw, WX_PSR_MNG_FLEX_DW_L(i), 0);
+		wr32(wxhw, WX_PSR_MNG_FLEX_DW_H(i), 0);
+		wr32(wxhw, WX_PSR_MNG_FLEX_MSK(i), 0);
+	}
+	wr32(wxhw, WX_PSR_LAN_FLEX_SEL, 0);
+	for (i = 0; i < 16; i++) {
+		wr32(wxhw, WX_PSR_LAN_FLEX_DW_L(i), 0);
+		wr32(wxhw, WX_PSR_LAN_FLEX_DW_H(i), 0);
+		wr32(wxhw, WX_PSR_LAN_FLEX_MSK(i), 0);
+	}
+
+	/* set pause frame dst mac addr */
+	wr32(wxhw, WX_RDB_PFCMACDAL, 0xC2000001);
+	wr32(wxhw, WX_RDB_PFCMACDAH, 0x0180);
+}
+EXPORT_SYMBOL(wx_reset_misc);
+
 int wx_sw_init(struct wx_hw *wxhw)
 {
 	struct pci_dev *pdev = wxhw->pdev;
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index 42e95283242c..2c4c4cbbfb46 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -5,6 +5,8 @@
 #define _WX_HW_H_
 
 int wx_check_flash_load(struct wx_hw *hw, u32 check_bit);
+int wx_stop_adapter(struct wx_hw *wxhw);
+void wx_reset_misc(struct wx_hw *wxhw);
 int wx_sw_init(struct wx_hw *wxhw);
 
 #endif /* _WX_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index fa06443ca4f5..b9b182d38e3a 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -9,6 +9,20 @@
 #define PCI_VENDOR_ID_WANGXUN                   0x8088
 #endif
 
+#define WX_NCSI_SUP                             0x8000
+#define WX_NCSI_MASK                            0x8000
+#define WX_WOL_SUP                              0x4000
+#define WX_WOL_MASK                             0x4000
+
+/**************** Global Registers ****************************/
+/* chip control Registers */
+#define WX_MIS_PWR                   0x10000
+#define WX_MIS_RST                   0x1000C
+#define WX_MIS_RST_LAN_RST(_i)       BIT((_i) + 1)
+#define WX_MIS_RST_ST                0x10030
+#define WX_MIS_RST_ST_RST_INI_SHIFT  8
+#define WX_MIS_RST_ST_RST_INIT       (0xFF << WX_MIS_RST_ST_RST_INI_SHIFT)
+
 /* FMGR Registers */
 #define WX_SPI_CMD                   0x10104
 #define WX_SPI_CMD_READ_DWORD        0x1
@@ -25,16 +39,120 @@
 #define WX_SPI_STATUS_FLASH_BYPASS   BIT(31)
 #define WX_SPI_ILDR_STATUS           0x10120
 
+/* Sensors for PVT(Process Voltage Temperature) */
+#define WX_TS_EN                     0x10304
+#define WX_TS_EN_ENA                 BIT(0)
+#define WX_TS_ALARM_THRE             0x1030C
+#define WX_TS_DALARM_THRE            0x10310
+#define WX_TS_INT_EN                 0x10314
+#define WX_TS_INT_EN_DALARM_INT_EN   BIT(1)
+#define WX_TS_INT_EN_ALARM_INT_EN    BIT(0)
+#define WX_TS_ALARM_ST               0x10318
+#define WX_TS_ALARM_ST_DALARM        BIT(1)
+#define WX_TS_ALARM_ST_ALARM         BIT(0)
+
+/***************************** RDB registers *********************************/
+/* receive packet buffer */
+#define WX_RDB_PB_CTL                0x19000
+#define WX_RDB_PB_CTL_RXEN           BIT(31) /* Enable Receiver */
+#define WX_RDB_PB_CTL_DISABLED       BIT(0)
+/* statistic */
+#define WX_RDB_PFCMACDAL             0x19210
+#define WX_RDB_PFCMACDAH             0x19214
+
+/******************************* PSR Registers *******************************/
+/* psr control */
+#define WX_PSR_CTL                   0x15000
+/* Header split receive */
+#define WX_PSR_CTL_SW_EN             BIT(18)
+#define WX_PSR_CTL_RSC_ACK           BIT(17)
+#define WX_PSR_CTL_RSC_DIS           BIT(16)
+#define WX_PSR_CTL_PCSD              BIT(13)
+#define WX_PSR_CTL_IPPCSE            BIT(12)
+#define WX_PSR_CTL_BAM               BIT(10)
+#define WX_PSR_CTL_UPE               BIT(9)
+#define WX_PSR_CTL_MPE               BIT(8)
+#define WX_PSR_CTL_MFE               BIT(7)
+#define WX_PSR_CTL_MO_SHIFT          5
+#define WX_PSR_CTL_MO                (0x3 << WX_PSR_CTL_MO_SHIFT)
+#define WX_PSR_CTL_TPE               BIT(4)
+
+/* Management */
+#define WX_PSR_MNG_FLEX_SEL          0x1582C
+#define WX_PSR_MNG_FLEX_DW_L(_i)     (0x15A00 + ((_i) * 16))
+#define WX_PSR_MNG_FLEX_DW_H(_i)     (0x15A04 + ((_i) * 16))
+#define WX_PSR_MNG_FLEX_MSK(_i)      (0x15A08 + ((_i) * 16))
+#define WX_PSR_LAN_FLEX_SEL          0x15B8C
+#define WX_PSR_LAN_FLEX_DW_L(_i)     (0x15C00 + ((_i) * 16))
+#define WX_PSR_LAN_FLEX_DW_H(_i)     (0x15C04 + ((_i) * 16))
+#define WX_PSR_LAN_FLEX_MSK(_i)      (0x15C08 + ((_i) * 16))
+
+/************************************* ETH MAC *****************************/
+#define WX_MAC_RX_CFG                0x11004
+#define WX_MAC_RX_CFG_RE             BIT(0)
+#define WX_MAC_RX_CFG_JE             BIT(8)
+#define WX_MAC_PKT_FLT               0x11008
+#define WX_MAC_PKT_FLT_PR            BIT(0) /* promiscuous mode */
+#define WX_MAC_RX_FLOW_CTRL          0x11090
+#define WX_MAC_RX_FLOW_CTRL_RFE      BIT(0) /* receive fc enable */
+#define WX_MMC_CONTROL               0x11800
+#define WX_MMC_CONTROL_RSTONRD       BIT(2) /* reset on read */
+
+/********************************* BAR registers ***************************/
+/* Interrupt Registers */
+#define WX_BME_CTL                   0x12020
+#define WX_PX_MISC_IC                0x100
+#define WX_PX_IMS(_i)                (0x140 + (_i) * 4)
+#define WX_PX_TRANSACTION_PENDING    0x168
+
+/* transmit DMA Registers */
+#define WX_PX_TR_CFG(_i)             (0x03010 + ((_i) * 0x40))
+/* Transmit Config masks */
+#define WX_PX_TR_CFG_ENABLE          BIT(0) /* Ena specific Tx Queue */
+#define WX_PX_TR_CFG_TR_SIZE_SHIFT   1 /* tx desc number per ring */
+#define WX_PX_TR_CFG_SWFLSH          BIT(26) /* Tx Desc. wr-bk flushing */
+#define WX_PX_TR_CFG_WTHRESH_SHIFT   16 /* shift to WTHRESH bits */
+#define WX_PX_TR_CFG_THRE_SHIFT      8
+
+/* Receive DMA Registers */
+#define WX_PX_RR_CFG(_i)             (0x01010 + ((_i) * 0x40))
+/* PX_RR_CFG bit definitions */
+#define WX_PX_RR_CFG_RR_EN           BIT(0)
+
+/* Number of 80 microseconds we wait for PCI Express master disable */
+#define WX_PCI_MASTER_DISABLE_TIMEOUT        80000
+
 /* Bus parameters */
 struct wx_bus_info {
 	u8 func;
 	u16 device;
 };
 
+struct wx_thermal_sensor_data {
+	s16 temp;
+	s16 alarm_thresh;
+	s16 dalarm_thresh;
+};
+
+enum wx_mac_type {
+	wx_mac_unknown = 0,
+	wx_mac_sp,
+	wx_mac_em
+};
+
+struct wx_mac_info {
+	enum wx_mac_type type;
+	bool set_lben;
+	u32 max_tx_queues;
+	u32 max_rx_queues;
+	struct wx_thermal_sensor_data sensor;
+};
+
 struct wx_hw {
 	u8 __iomem *hw_addr;
 	struct pci_dev *pdev;
 	struct wx_bus_info bus;
+	struct wx_mac_info mac;
 	u16 device_id;
 	u16 vendor_id;
 	u16 subsystem_device_id;
@@ -42,14 +160,40 @@ struct wx_hw {
 	u8 revision_id;
 	u16 oem_ssid;
 	u16 oem_svid;
+	bool adapter_stopped;
 };
 
+#define WX_INTR_ALL (~0ULL)
+
 /**
  * register operations
  **/
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
 #define rd32(a, reg)		readl((a)->hw_addr + (reg))
 
+static inline u32
+rd32m(struct wx_hw *wxhw, u32 reg, u32 mask)
+{
+	u32 val;
+
+	val = rd32(wxhw, reg);
+	return val & mask;
+}
+
+static inline void
+wr32m(struct wx_hw *wxhw, u32 reg, u32 mask, u32 field)
+{
+	u32 val;
+
+	val = rd32(wxhw, reg);
+	val = ((val & ~mask) | (field & mask));
+
+	wr32(wxhw, reg, val);
+}
+
+/* flush PCI read and write */
+#define WX_WRITE_FLUSH(H) rd32(H, WX_MIS_PWR)
+
 #define wx_err(wxhw, fmt, arg...) \
 	dev_err(&(wxhw)->pdev->dev, fmt, ##arg)
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index 431303ca75b4..78484c58b78b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -6,4 +6,5 @@
 
 obj-$(CONFIG_TXGBE) += txgbe.o
 
-txgbe-objs := txgbe_main.o
+txgbe-objs := txgbe_main.o \
+              txgbe_hw.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 9a97b85be3ac..f866d7fa7161 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -4,13 +4,14 @@
 #ifndef _TXGBE_H_
 #define _TXGBE_H_
 
-#include "txgbe_type.h"
-
 #define TXGBE_MAX_FDIR_INDICES          63
 
 #define TXGBE_MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 #define TXGBE_MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 
+#define TXGBE_SP_MAX_TX_QUEUES  128
+#define TXGBE_SP_MAX_RX_QUEUES  128
+
 /* board specific private data structure */
 struct txgbe_adapter {
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
new file mode 100644
index 000000000000..a679db3f2e41
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/string.h>
+#include <linux/iopoll.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+
+#include "../libwx/wx_type.h"
+#include "../libwx/wx_hw.h"
+#include "txgbe_type.h"
+#include "txgbe_hw.h"
+#include "txgbe.h"
+
+/**
+ *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
+ *  @hw: pointer to hardware structure
+ *
+ *  Inits the thermal sensor thresholds according to the NVM map
+ *  and save off the threshold and location values into mac.thermal_sensor_data
+ **/
+static void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	struct wx_thermal_sensor_data *data = &wxhw->mac.sensor;
+
+	memset(data, 0, sizeof(struct wx_thermal_sensor_data));
+
+	/* Only support thermal sensors attached to SP physical port 0 */
+	if (wxhw->bus.func)
+		return;
+
+	wr32(wxhw, TXGBE_TS_CTL, TXGBE_TS_CTL_EVAL_MD);
+
+	wr32(wxhw, WX_TS_INT_EN,
+	     WX_TS_INT_EN_ALARM_INT_EN | WX_TS_INT_EN_DALARM_INT_EN);
+	wr32(wxhw, WX_TS_EN, WX_TS_EN_ENA);
+
+	data->alarm_thresh = 100;
+	wr32(wxhw, WX_TS_ALARM_THRE, 677);
+	data->dalarm_thresh = 90;
+	wr32(wxhw, WX_TS_DALARM_THRE, 614);
+}
+
+static void txgbe_reset_misc(struct txgbe_hw *hw)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+
+	wx_reset_misc(wxhw);
+	txgbe_init_thermal_sensor_thresh(hw);
+}
+
+/**
+ *  txgbe_reset_hw - Perform hardware reset
+ *  @hw: pointer to hardware structure
+ *
+ *  Resets the hardware by resetting the transmit and receive units, masks
+ *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
+ *  reset.
+ **/
+int txgbe_reset_hw(struct txgbe_hw *hw)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 reset = 0;
+	int status;
+
+	/* Call adapter stop to disable tx/rx and clear interrupts */
+	status = wx_stop_adapter(wxhw);
+	if (status != 0)
+		return status;
+
+	reset = WX_MIS_RST_LAN_RST(wxhw->bus.func);
+	wr32(wxhw, WX_MIS_RST, reset | rd32(wxhw, WX_MIS_RST));
+
+	WX_WRITE_FLUSH(wxhw);
+	usleep_range(10, 100);
+
+	status = wx_check_flash_load(wxhw, TXGBE_SPI_ILDR_STATUS_LAN_SW_RST(wxhw->bus.func));
+	if (status != 0)
+		return status;
+
+	txgbe_reset_misc(hw);
+	pci_set_master(wxhw->pdev);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
new file mode 100644
index 000000000000..155f18ea4b8c
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_HW_H_
+#define _TXGBE_HW_H_
+
+int txgbe_reset_hw(struct txgbe_hw *hw);
+
+#endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 71ea197fe299..409103d5ac2b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -11,6 +11,8 @@
 
 #include "../libwx/wx_type.h"
 #include "../libwx/wx_hw.h"
+#include "txgbe_type.h"
+#include "txgbe_hw.h"
 #include "txgbe.h"
 
 char txgbe_driver_name[] = "txgbe";
@@ -92,6 +94,19 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 		return err;
 	}
 
+	switch (wxhw->device_id) {
+	case TXGBE_DEV_ID_SP1000:
+	case TXGBE_DEV_ID_WX1820:
+		wxhw->mac.type = wx_mac_sp;
+		break;
+	default:
+		wxhw->mac.type = wx_mac_unknown;
+		break;
+	}
+
+	wxhw->mac.max_tx_queues = TXGBE_SP_MAX_TX_QUEUES;
+	wxhw->mac.max_rx_queues = TXGBE_SP_MAX_RX_QUEUES;
+
 	return 0;
 }
 
@@ -201,6 +216,12 @@ static int txgbe_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_pci_release_regions;
 
+	err = txgbe_reset_hw(hw);
+	if (err) {
+		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
+		goto err_pci_release_regions;
+	}
+
 	netdev->features |= NETIF_F_HIGHDMA;
 
 	pci_set_drvdata(pdev, adapter);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 1d1ead3d3c06..c891b0f07227 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -33,12 +33,6 @@
 #define TXGBE_ID_WX1820_MAC_SGMII               0x2060
 #define TXGBE_ID_MAC_SGMII                      0x60
 
-#define TXGBE_NCSI_SUP                          0x8000
-#define TXGBE_NCSI_MASK                         0x8000
-#define TXGBE_WOL_SUP                           0x4000
-#define TXGBE_WOL_MASK                          0x4000
-#define TXGBE_DEV_MASK                          0xf0
-
 /* Combined interface*/
 #define TXGBE_ID_SFI_XAUI			0x50
 
@@ -50,6 +44,11 @@
 #define TXGBE_SPI_ILDR_STATUS                   0x10120
 #define TXGBE_SPI_ILDR_STATUS_PERST             BIT(0) /* PCIE_PERST is done */
 #define TXGBE_SPI_ILDR_STATUS_PWRRST            BIT(1) /* Power on reset is done */
+#define TXGBE_SPI_ILDR_STATUS_LAN_SW_RST(_i)    BIT((_i) + 9) /* lan soft reset done */
+
+/* Sensors for PVT(Process Voltage Temperature) */
+#define TXGBE_TS_CTL                            0x10300
+#define TXGBE_TS_CTL_EVAL_MD                    BIT(31)
 
 struct txgbe_hw {
 	struct wx_hw wxhw;
-- 
2.27.0

