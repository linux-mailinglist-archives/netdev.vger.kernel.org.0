Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11E1613116
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 08:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJaHJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 03:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiJaHJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 03:09:47 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EC5C77F
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 00:09:42 -0700 (PDT)
X-QQ-mid: bizesmtp69t1667200108tz7av7s7
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 31 Oct 2022 15:08:26 +0800 (CST)
X-QQ-SSF: 01400000000000M0L000000A0000000
X-QQ-FEAT: zT6n3Y95oi25B9Av1Ei2W3C77F1uhkOAGeC/iTKq5EQwfNtmmQ6w515V7PKGx
        oZCXKHgQ+uk15MwG9ujmPsDLyXKGzS4739jj3PnPXQ1VhoRQLOBzHryTrVWi9P3luUFzlb7
        HejoO4aqnjZXGXNRBFXOreHHyJMwiHRv6YvXRodl9KN0i0utJBGytMamINfm9LHyWy55lBY
        LPnTBDjOBa3Z/w0H7z9ObpKm++Hav7AQhgHf34iNTxAXeQy2+rnNGdzSApw2Nxt9tIF2YuG
        BNXKI9GlbntYB05zr7VCUaFnK7oPtBAUpLuJ7UXHTAxnK8ZdIBLkU5y9nmCDcjcybl3raqf
        W2tS+N53Be8KVhe6npw50dtSlZzT5DhBMj31KRdCS5p7kpSWrQH5eFdjb3zO6pOn4UddxBk
        wp8m3QL4bSrzrd+ZmBlZ0w==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Cc:     Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 3/3] net: ngbe: Initialize sw info and register netdev
Date:   Mon, 31 Oct 2022 15:07:57 +0800
Message-Id: <20221031070757.982-4-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070757.982-1-mengyuanlou@net-swift.com>
References: <20221031070757.982-1-mengyuanlou@net-swift.com>
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

Initialize ngbe mac/phy type.
Check whether the firmware is initialized.
Initialize ngbe hw and register netdev.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |   1 +
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |  40 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   3 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |   6 +
 drivers/net/ethernet/wangxun/ngbe/Makefile    |   2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  55 +++
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  87 +++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |  12 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 368 ++++++++++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  99 ++++-
 10 files changed, 665 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index 565fa826b056..86310588c6c1 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -24,6 +24,7 @@ config LIBWX
 config NGBE
 	tristate "Wangxun(R) GbE PCI Express adapters support"
 	depends on PCI
+	select LIBWX
 	help
 	  This driver supports Wangxun(R) GbE PCI Express family of
 	  adapters.
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index eafc1791f859..1eb7388f1dd5 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -162,8 +162,8 @@ static int wx_acquire_sw_sync(struct wx_hw *wxhw, u32 mask)
  *   So we will leave this up to the caller to read back the data
  *   in these cases.
  **/
-static int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
-				     u32 length, u32 timeout, bool return_data)
+int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
+			      u32 length, u32 timeout, bool return_data)
 {
 	u32 hdr_size = sizeof(struct wx_hic_hdr);
 	u32 hicr, i, bi, buf[64] = {};
@@ -265,6 +265,7 @@ static int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
 	wx_release_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_MB);
 	return status;
 }
+EXPORT_SYMBOL(wx_host_interface_command);
 
 /**
  *  wx_read_ee_hostif_data - Read EEPROM word using a host interface cmd
@@ -870,6 +871,41 @@ void wx_reset_misc(struct wx_hw *wxhw)
 }
 EXPORT_SYMBOL(wx_reset_misc);
 
+/**
+ *  wx_get_pcie_msix_counts - Gets MSI-X vector count
+ *  @wxhw: pointer to hardware structure
+ *  @msix_count: number of MSI interrupts that can be obtained
+ *  @max_msix_count: number of MSI interrupts that mac need
+ *
+ *  Read PCIe configuration space, and get the MSI-X vector count from
+ *  the capabilities table.
+ **/
+int wx_get_pcie_msix_counts(struct wx_hw *wxhw, u16 *msix_count, u16 max_msix_count)
+{
+	struct pci_dev *pdev = wxhw->pdev;
+	struct device *dev = &pdev->dev;
+	int pos;
+
+	*msix_count = 1;
+	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
+	if (!pos) {
+		dev_err(dev, "Unable to find MSI-X Capabilities\n");
+		return -EINVAL;
+	}
+	pci_read_config_word(pdev,
+			     pos + PCI_MSIX_FLAGS,
+			     msix_count);
+	*msix_count &= WX_PCIE_MSIX_TBL_SZ_MASK;
+	/* MSI-X count is zero-based in HW */
+	*msix_count += 1;
+
+	if (*msix_count > max_msix_count)
+		*msix_count = max_msix_count;
+
+	return 0;
+}
+EXPORT_SYMBOL(wx_get_pcie_msix_counts);
+
 int wx_sw_init(struct wx_hw *wxhw)
 {
 	struct pci_dev *pdev = wxhw->pdev;
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index 163777d5ed96..a0652f5e9939 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -7,6 +7,8 @@
 int wx_check_flash_load(struct wx_hw *hw, u32 check_bit);
 void wx_control_hw(struct wx_hw *wxhw, bool drv);
 int wx_mng_present(struct wx_hw *wxhw);
+int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
+			      u32 length, u32 timeout, bool return_data);
 int wx_read_ee_hostif(struct wx_hw *wxhw, u16 offset, u16 *data);
 int wx_read_ee_hostif_buffer(struct wx_hw *wxhw,
 			     u16 offset, u16 words, u16 *data);
@@ -20,6 +22,7 @@ void wx_disable_rx(struct wx_hw *wxhw);
 int wx_disable_pcie_master(struct wx_hw *wxhw);
 int wx_stop_adapter(struct wx_hw *wxhw);
 void wx_reset_misc(struct wx_hw *wxhw);
+int wx_get_pcie_msix_counts(struct wx_hw *wxhw, u16 *msix_count, u16 max_msix_count);
 int wx_sw_init(struct wx_hw *wxhw);
 
 #endif /* _WX_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 3b2c4586e0c3..1cbeef8230bf 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -14,6 +14,10 @@
 #define WX_WOL_SUP                              0x4000
 #define WX_WOL_MASK                             0x4000
 
+/* MSI-X capability fields masks */
+#define WX_PCIE_MSIX_TBL_SZ_MASK                0x7FF
+#define WX_PCI_LINK_STATUS                      0xB2
+
 /**************** Global Registers ****************************/
 /* chip control Registers */
 #define WX_MIS_PWR                   0x10000
@@ -255,6 +259,8 @@ struct wx_mac_info {
 	u32 num_rar_entries;
 	u32 max_tx_queues;
 	u32 max_rx_queues;
+
+	u16 max_msix_vectors;
 	struct wx_thermal_sensor_data sensor;
 };
 
diff --git a/drivers/net/ethernet/wangxun/ngbe/Makefile b/drivers/net/ethernet/wangxun/ngbe/Makefile
index 0baf75907496..391c2cbc1bb4 100644
--- a/drivers/net/ethernet/wangxun/ngbe/Makefile
+++ b/drivers/net/ethernet/wangxun/ngbe/Makefile
@@ -6,4 +6,4 @@
 
 obj-$(CONFIG_NGBE) += ngbe.o
 
-ngbe-objs := ngbe_main.o
+ngbe-objs := ngbe_main.o ngbe_hw.o
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe.h b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
index f5fa6e5238cc..af147ca8605c 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
@@ -11,12 +11,67 @@
 #define NGBE_MAX_RX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
 #define NGBE_MAX_TX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
 
+#define NGBE_ETH_LENGTH_OF_ADDRESS	6
+#define NGBE_MAX_MSIX_VECTORS		0x09
+#define NGBE_RAR_ENTRIES		32
+
+/* TX/RX descriptor defines */
+#define NGBE_DEFAULT_TXD		512 /* default ring size */
+#define NGBE_DEFAULT_TX_WORK		256
+#define NGBE_MAX_TXD			8192
+#define NGBE_MIN_TXD			128
+
+#define NGBE_DEFAULT_RXD		512 /* default ring size */
+#define NGBE_DEFAULT_RX_WORK		256
+#define NGBE_MAX_RXD			8192
+#define NGBE_MIN_RXD			128
+
+#define NGBE_MAC_STATE_DEFAULT		0x1
+#define NGBE_MAC_STATE_MODIFIED		0x2
+#define NGBE_MAC_STATE_IN_USE		0x4
+
+struct ngbe_mac_addr {
+	u8 addr[ETH_ALEN];
+	u16 state; /* bitmask */
+	u64 pools;
+};
+
 /* board specific private data structure */
 struct ngbe_adapter {
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
 	/* OS defined structs */
 	struct net_device *netdev;
 	struct pci_dev *pdev;
+
+	/* structs defined in ngbe_hw.h */
+	struct ngbe_hw hw;
+	struct ngbe_mac_addr *mac_table;
+	u16 msg_enable;
+
+	/* Tx fast path data */
+	int num_tx_queues;
+	u16 tx_itr_setting;
+	u16 tx_work_limit;
+
+	/* Rx fast path data */
+	int num_rx_queues;
+	u16 rx_itr_setting;
+	u16 rx_work_limit;
+
+	int num_q_vectors;      /* current number of q_vectors for device */
+	int max_q_vectors;      /* upper limit of q_vectors for device */
+
+	u32 tx_ring_count;
+	u32 rx_ring_count;
+
+#define NGBE_MAX_RETA_ENTRIES 128
+	u8 rss_indir_tbl[NGBE_MAX_RETA_ENTRIES];
+
+#define NGBE_RSS_KEY_SIZE     40  /* size of RSS Hash Key in bytes */
+	u32 *rss_key;
+	u32 wol;
+
+	u16 bd_number;
 };
 
 extern char ngbe_driver_name[];
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
new file mode 100644
index 000000000000..0e3923b3737e
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/etherdevice.h>
+#include <linux/iopoll.h>
+#include <linux/pci.h>
+
+#include "../libwx/wx_type.h"
+#include "../libwx/wx_hw.h"
+#include "ngbe_type.h"
+#include "ngbe_hw.h"
+#include "ngbe.h"
+
+int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw)
+{
+	struct wx_hic_read_shadow_ram buffer;
+	struct wx_hw *wxhw = &hw->wxhw;
+	int status;
+	int tmp;
+
+	buffer.hdr.req.cmd = NGBE_FW_EEPROM_CHECKSUM_CMD;
+	buffer.hdr.req.buf_lenh = 0;
+	buffer.hdr.req.buf_lenl = 0;
+	buffer.hdr.req.checksum = NGBE_FW_CMD_DEFAULT_CHECKSUM;
+	/* convert offset from words to bytes */
+	buffer.address = 0;
+	/* one word */
+	buffer.length = 0;
+
+	status = wx_host_interface_command(wxhw, (u32 *)&buffer, sizeof(buffer),
+					   WX_HI_COMMAND_TIMEOUT, false);
+
+	if (status < 0)
+		return status;
+	tmp = rd32a(wxhw, WX_MNG_MBOX, 1);
+	if (tmp == NGBE_FW_CMD_ST_PASS)
+		return 0;
+	return -EIO;
+}
+
+static int ngbe_reset_misc(struct ngbe_hw *hw)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+
+	wx_reset_misc(wxhw);
+	if (hw->mac_type == ngbe_mac_type_rgmii)
+		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
+	if (hw->gpio_ctrl) {
+		/* gpio0 is used to power on/off control*/
+		wr32(wxhw, NGBE_GPIO_DDR, 0x1);
+		wr32(wxhw, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
+	}
+	return 0;
+}
+
+/**
+ *  ngbe_reset_hw - Perform hardware reset
+ *  @hw: pointer to hardware structure
+ *
+ *  Resets the hardware by resetting the transmit and receive units, masks
+ *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
+ *  reset.
+ **/
+int ngbe_reset_hw(struct ngbe_hw *hw)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	int status = 0;
+	u32 reset = 0;
+
+	/* Call adapter stop to disable tx/rx and clear interrupts */
+	status = wx_stop_adapter(wxhw);
+	if (status != 0)
+		return status;
+	reset = WX_MIS_RST_LAN_RST(wxhw->bus.func);
+	wr32(wxhw, WX_MIS_RST, reset | rd32(wxhw, WX_MIS_RST));
+	ngbe_reset_misc(hw);
+
+	/* Store the permanent mac address */
+	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);
+
+	/* reset num_rar_entries to 128 */
+	wxhw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
+	wx_init_rx_addrs(wxhw);
+	pci_set_master(wxhw->pdev);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
new file mode 100644
index 000000000000..42476a3fe57c
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * WangXun Gigabit PCI Express Linux driver
+ * Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
+ */
+
+#ifndef _NGBE_HW_H_
+#define _NGBE_HW_H_
+
+int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw);
+int ngbe_reset_hw(struct ngbe_hw *hw);
+#endif /* _NGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 7674cb6e5700..f0b24366da18 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -8,7 +8,12 @@
 #include <linux/string.h>
 #include <linux/aer.h>
 #include <linux/etherdevice.h>
+#include <net/ip.h>
 
+#include "../libwx/wx_type.h"
+#include "../libwx/wx_hw.h"
+#include "ngbe_type.h"
+#include "ngbe_hw.h"
 #include "ngbe.h"
 char ngbe_driver_name[] = "ngbe";
 
@@ -34,6 +39,247 @@ static const struct pci_device_id ngbe_pci_tbl[] = {
 	{ .device = 0 }
 };
 
+static void ngbe_mac_set_default_filter(struct ngbe_adapter *adapter, u8 *addr)
+{
+	struct ngbe_hw *hw = &adapter->hw;
+
+	memcpy(&adapter->mac_table[0].addr, addr, ETH_ALEN);
+	adapter->mac_table[0].pools = 1ULL;
+	adapter->mac_table[0].state = (NGBE_MAC_STATE_DEFAULT |
+				       NGBE_MAC_STATE_IN_USE);
+	wx_set_rar(&hw->wxhw, 0, adapter->mac_table[0].addr,
+		   adapter->mac_table[0].pools,
+		   WX_PSR_MAC_SWC_AD_H_AV);
+}
+
+/**
+ *  ngbe_init_type_code - Initialize the shared code
+ *  @hw: pointer to hardware structure
+ **/
+static void ngbe_init_type_code(struct ngbe_hw *hw)
+{
+	int wol_mask = 0, ncsi_mask = 0;
+	struct wx_hw *wxhw = &hw->wxhw;
+	u16 type_mask = 0;
+
+	wxhw->mac.type = wx_mac_em;
+	type_mask = (u16)(wxhw->subsystem_device_id & NGBE_OEM_MASK);
+	ncsi_mask = wxhw->subsystem_device_id & NGBE_NCSI_MASK;
+	wol_mask = wxhw->subsystem_device_id & NGBE_WOL_MASK;
+
+	switch (type_mask) {
+	case NGBE_SUBID_M88E1512_SFP:
+	case NGBE_SUBID_LY_M88E1512_SFP:
+		hw->phy.type = ngbe_phy_m88e1512_sfi;
+		break;
+	case NGBE_SUBID_M88E1512_RJ45:
+		hw->phy.type = ngbe_phy_m88e1512;
+		break;
+	case NGBE_SUBID_M88E1512_MIX:
+		hw->phy.type = ngbe_phy_m88e1512_unknown;
+		break;
+	case NGBE_SUBID_YT8521S_SFP:
+	case NGBE_SUBID_YT8521S_SFP_GPIO:
+	case NGBE_SUBID_LY_YT8521S_SFP:
+		hw->phy.type = ngbe_phy_yt8521s_sfi;
+		break;
+	case NGBE_SUBID_INTERNAL_YT8521S_SFP:
+	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
+		hw->phy.type = ngbe_phy_internal_yt8521s_sfi;
+		break;
+	case NGBE_SUBID_RGMII_FPGA:
+	case NGBE_SUBID_OCP_CARD:
+		fallthrough;
+	default:
+		hw->phy.type = ngbe_phy_internal;
+		break;
+	}
+
+	if (hw->phy.type == ngbe_phy_internal ||
+	    hw->phy.type == ngbe_phy_internal_yt8521s_sfi)
+		hw->mac_type = ngbe_mac_type_mdi;
+	else
+		hw->mac_type = ngbe_mac_type_rgmii;
+
+	hw->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
+	hw->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
+			   type_mask == NGBE_SUBID_OCP_CARD) ? 1 : 0;
+
+	switch (type_mask) {
+	case NGBE_SUBID_LY_YT8521S_SFP:
+	case NGBE_SUBID_LY_M88E1512_SFP:
+	case NGBE_SUBID_YT8521S_SFP_GPIO:
+	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
+		hw->gpio_ctrl = 1;
+		break;
+	default:
+		hw->gpio_ctrl = 0;
+		break;
+	}
+}
+
+/**
+ * ngbe_init_rss_key - Initialize adapter RSS key
+ * @adapter: device handle
+ *
+ * Allocates and initializes the RSS key if it is not allocated.
+ **/
+static inline int ngbe_init_rss_key(struct ngbe_adapter *adapter)
+{
+	u32 *rss_key;
+
+	if (!adapter->rss_key) {
+		rss_key = kzalloc(NGBE_RSS_KEY_SIZE, GFP_KERNEL);
+		if (unlikely(!rss_key))
+			return -ENOMEM;
+
+		netdev_rss_key_fill(rss_key, NGBE_RSS_KEY_SIZE);
+		adapter->rss_key = rss_key;
+	}
+
+	return 0;
+}
+
+/**
+ * ngbe_sw_init - Initialize general software structures
+ * @adapter: board private structure to initialize
+ **/
+static int ngbe_sw_init(struct ngbe_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct ngbe_hw *hw = &adapter->hw;
+	struct wx_hw *wxhw = &hw->wxhw;
+	u16 msix_count = 0;
+	int err = 0;
+
+	wxhw->hw_addr = adapter->io_addr;
+	wxhw->pdev = pdev;
+
+	/* PCI config space info */
+	err = wx_sw_init(wxhw);
+	if (err < 0) {
+		netif_err(adapter, probe, adapter->netdev,
+			  "Read of internal subsystem device id failed\n");
+		return err;
+	}
+
+	/* mac type, phy type , oem type */
+	ngbe_init_type_code(hw);
+
+	wxhw->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
+	wxhw->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
+	wxhw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
+	/* Set common capability flags and settings */
+	adapter->max_q_vectors = NGBE_MAX_MSIX_VECTORS;
+
+	err = wx_get_pcie_msix_counts(wxhw, &msix_count, NGBE_MAX_MSIX_VECTORS);
+	if (err)
+		dev_err(&pdev->dev, "Do not support MSI-X\n");
+	wxhw->mac.max_msix_vectors = msix_count;
+
+	adapter->mac_table = kcalloc(wxhw->mac.num_rar_entries,
+				     sizeof(struct ngbe_mac_addr),
+				     GFP_KERNEL);
+	if (!adapter->mac_table) {
+		dev_err(&pdev->dev, "mac_table allocation failed: %d\n", err);
+		return -ENOMEM;
+	}
+
+	if (ngbe_init_rss_key(adapter))
+		return -ENOMEM;
+
+	/* enable itr by default in dynamic mode */
+	adapter->rx_itr_setting = 1;
+	adapter->tx_itr_setting = 1;
+
+	/* set default ring sizes */
+	adapter->tx_ring_count = NGBE_DEFAULT_TXD;
+	adapter->rx_ring_count = NGBE_DEFAULT_RXD;
+
+	/* set default work limits */
+	adapter->tx_work_limit = NGBE_DEFAULT_TX_WORK;
+	adapter->rx_work_limit = NGBE_DEFAULT_RX_WORK;
+
+	return 0;
+}
+
+static void ngbe_down(struct ngbe_adapter *adapter)
+{
+	netif_carrier_off(adapter->netdev);
+	netif_tx_disable(adapter->netdev);
+};
+
+/**
+ * ngbe_open - Called when a network interface is made active
+ * @netdev: network interface device structure
+ *
+ * Returns 0 on success, negative value on failure
+ *
+ * The open entry point is called when a network interface is made
+ * active by the system (IFF_UP).
+ **/
+static int ngbe_open(struct net_device *netdev)
+{
+	struct ngbe_adapter *adapter = netdev_priv(netdev);
+	struct ngbe_hw *hw = &adapter->hw;
+	struct wx_hw *wxhw = &hw->wxhw;
+
+	wx_control_hw(wxhw, true);
+
+	return 0;
+}
+
+/**
+ * ngbe_close - Disables a network interface
+ * @netdev: network interface device structure
+ *
+ * Returns 0, this is not allowed to fail
+ *
+ * The close entry point is called when an interface is de-activated
+ * by the OS.  The hardware is still under the drivers control, but
+ * needs to be disabled.  A global MAC reset is issued to stop the
+ * hardware, and all transmit and receive resources are freed.
+ **/
+static int ngbe_close(struct net_device *netdev)
+{
+	struct ngbe_adapter *adapter = netdev_priv(netdev);
+
+	ngbe_down(adapter);
+	wx_control_hw(&adapter->hw.wxhw, false);
+
+	return 0;
+}
+
+static netdev_tx_t ngbe_xmit_frame(struct sk_buff *skb,
+				   struct net_device *netdev)
+{
+	return NETDEV_TX_OK;
+}
+
+/**
+ * ngbe_set_mac - Change the Ethernet Address of the NIC
+ * @netdev: network interface device structure
+ * @p: pointer to an address structure
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int ngbe_set_mac(struct net_device *netdev, void *p)
+{
+	struct ngbe_adapter *adapter = netdev_priv(netdev);
+	struct wx_hw *wxhw = &adapter->hw.wxhw;
+	struct sockaddr *addr = p;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	eth_hw_addr_set(netdev, addr->sa_data);
+	memcpy(wxhw->mac.addr, addr->sa_data, netdev->addr_len);
+
+	ngbe_mac_set_default_filter(adapter, wxhw->mac.addr);
+
+	return 0;
+}
+
 static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
@@ -41,13 +287,22 @@ static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 	netif_device_detach(netdev);
 
+	rtnl_lock();
+	if (netif_running(netdev))
+		ngbe_down(adapter);
+	rtnl_unlock();
+	wx_control_hw(&adapter->hw.wxhw, false);
+
 	pci_disable_device(pdev);
 }
 
 static void ngbe_shutdown(struct pci_dev *pdev)
 {
+	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
 	bool wake;
 
+	wake = !!adapter->wol;
+
 	ngbe_dev_shutdown(pdev, &wake);
 
 	if (system_state == SYSTEM_POWER_OFF) {
@@ -56,6 +311,14 @@ static void ngbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
+static const struct net_device_ops ngbe_netdev_ops = {
+	.ndo_open               = ngbe_open,
+	.ndo_stop               = ngbe_close,
+	.ndo_start_xmit         = ngbe_xmit_frame,
+	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_set_mac_address    = ngbe_set_mac,
+};
+
 /**
  * ngbe_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -71,7 +334,14 @@ static int ngbe_probe(struct pci_dev *pdev,
 		      const struct pci_device_id __always_unused *ent)
 {
 	struct ngbe_adapter *adapter = NULL;
+	struct ngbe_hw *hw = NULL;
+	struct wx_hw *wxhw = NULL;
 	struct net_device *netdev;
+	u32 e2rom_cksum_cap = 0;
+	static int func_nums;
+	u16 e2rom_ver = 0;
+	u32 etrack_id = 0;
+	u32 saved_ver = 0;
 	int err;
 
 	err = pci_enable_device_mem(pdev);
@@ -111,6 +381,9 @@ static int ngbe_probe(struct pci_dev *pdev,
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
+	hw = &adapter->hw;
+	wxhw = &hw->wxhw;
+	adapter->msg_enable = BIT(3) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
 					pci_resource_start(pdev, 0),
@@ -120,12 +393,101 @@ static int ngbe_probe(struct pci_dev *pdev,
 		goto err_pci_release_regions;
 	}
 
+	netdev->netdev_ops = &ngbe_netdev_ops;
+
 	netdev->features |= NETIF_F_HIGHDMA;
 
+	adapter->bd_number = func_nums;
+	/* setup the private structure */
+	err = ngbe_sw_init(adapter);
+	if (err)
+		goto err_free_mac_table;
+
+	/* check if flash load is done after hw power up */
+	err = wx_check_flash_load(wxhw, NGBE_SPI_ILDR_STATUS_PERST);
+	if (err)
+		goto err_free_mac_table;
+	err = wx_check_flash_load(wxhw, NGBE_SPI_ILDR_STATUS_PWRRST);
+	if (err)
+		goto err_free_mac_table;
+
+	err = wx_mng_present(wxhw);
+	if (err) {
+		dev_err(&pdev->dev, "Management capability is not present\n");
+		goto err_free_mac_table;
+	}
+
+	err = ngbe_reset_hw(hw);
+	if (err) {
+		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
+		goto err_free_mac_table;
+	}
+
+	if (wxhw->bus.func == 0) {
+		wr32(wxhw, NGBE_CALSUM_CAP_STATUS, 0x0);
+		wr32(wxhw, NGBE_EEPROM_VERSION_STORE_REG, 0x0);
+	} else {
+		e2rom_cksum_cap = rd32(wxhw, NGBE_CALSUM_CAP_STATUS);
+		saved_ver = rd32(wxhw, NGBE_EEPROM_VERSION_STORE_REG);
+	}
+
+	wx_init_eeprom_params(wxhw);
+	if (wxhw->bus.func == 0 || e2rom_cksum_cap == 0) {
+		/* make sure the EEPROM is ready */
+		err = ngbe_eeprom_chksum_hostif(hw);
+		if (err) {
+			dev_err(&pdev->dev, "The EEPROM Checksum Is Not Valid\n");
+			err = -EIO;
+			goto err_free_mac_table;
+		}
+	}
+
+	adapter->wol = 0;
+	if (hw->wol_enabled)
+		adapter->wol = NGBE_PSR_WKUP_CTL_MAG;
+
+	hw->wol_enabled = !!(adapter->wol);
+	wr32(wxhw, NGBE_PSR_WKUP_CTL, adapter->wol);
+
+	device_set_wakeup_enable(&pdev->dev, adapter->wol);
+
+	/* Save off EEPROM version number and Option Rom version which
+	 * together make a unique identify for the eeprom
+	 */
+	if (saved_ver) {
+		etrack_id = saved_ver;
+	} else {
+		wx_read_ee_hostif(wxhw,
+				  wxhw->eeprom.sw_region_offset + NGBE_EEPROM_VERSION_H,
+				  &e2rom_ver);
+		etrack_id = e2rom_ver << 16;
+		wx_read_ee_hostif(wxhw,
+				  wxhw->eeprom.sw_region_offset + NGBE_EEPROM_VERSION_L,
+				  &e2rom_ver);
+		etrack_id |= e2rom_ver;
+		wr32(wxhw, NGBE_EEPROM_VERSION_STORE_REG, etrack_id);
+	}
+
+	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
+	ngbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
+
+	err = register_netdev(netdev);
+	if (err)
+		goto err_register;
+
 	pci_set_drvdata(pdev, adapter);
 
+	netif_info(adapter, probe, netdev,
+		   "PHY: %s, PBA No: Wang Xun GbE Family Controller\n",
+		   hw->phy.type == ngbe_phy_internal ? "Internal" : "External");
+	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
+
 	return 0;
 
+err_register:
+	wx_control_hw(wxhw, false);
+err_free_mac_table:
+	kfree(adapter->mac_table);
 err_pci_release_regions:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
@@ -146,9 +508,15 @@ static int ngbe_probe(struct pci_dev *pdev,
  **/
 static void ngbe_remove(struct pci_dev *pdev)
 {
+	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct net_device *netdev;
+
+	netdev = adapter->netdev;
+	unregister_netdev(netdev);
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
+	kfree(adapter->mac_table);
 	pci_disable_pcie_error_reporting(pdev);
 
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 26e776c3539a..39f6c03f1a54 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -8,11 +8,6 @@
 #include <linux/netdevice.h>
 
 /************ NGBE_register.h ************/
-/* Vendor ID */
-#ifndef PCI_VENDOR_ID_WANGXUN
-#define PCI_VENDOR_ID_WANGXUN			0x8088
-#endif
-
 /* Device IDs */
 #define NGBE_DEV_ID_EM_WX1860AL_W		0x0100
 #define NGBE_DEV_ID_EM_WX1860A2			0x0101
@@ -47,4 +42,98 @@
 #define NGBE_WOL_SUP				0x4000
 #define NGBE_WOL_MASK				0x4000
 
+/**************** EM Registers ****************************/
+/* chip control Registers */
+#define NGBE_MIS_PRB_CTL			0x10010
+/* FMGR Registers */
+#define NGBE_SPI_ILDR_STATUS			0x10120
+#define NGBE_SPI_ILDR_STATUS_PERST		BIT(0) /* PCIE_PERST is done */
+#define NGBE_SPI_ILDR_STATUS_PWRRST		BIT(1) /* Power on reset is done */
+#define NGBE_SPI_ILDR_STATUS_LAN_SW_RST(_i)	BIT((_i) + 9) /* lan soft reset done */
+
+/* Checksum and EEPROM pointers */
+#define NGBE_CALSUM_COMMAND			0xE9
+#define NGBE_CALSUM_CAP_STATUS			0x10224
+#define NGBE_EEPROM_VERSION_STORE_REG		0x1022C
+#define NGBE_SAN_MAC_ADDR_PTR			0x18
+#define NGBE_DEVICE_CAPS			0x1C
+#define NGBE_EEPROM_VERSION_L			0x1D
+#define NGBE_EEPROM_VERSION_H			0x1E
+
+/* Media-dependent registers. */
+#define NGBE_MDIO_CLAUSE_SELECT			0x11220
+
+/* GPIO Registers */
+#define NGBE_GPIO_DR				0x14800
+#define NGBE_GPIO_DDR				0x14804
+/*GPIO bit */
+#define NGBE_GPIO_DR_0				BIT(0) /* SDP0 Data Value */
+#define NGBE_GPIO_DR_1				BIT(1) /* SDP1 Data Value */
+#define NGBE_GPIO_DDR_0				BIT(0) /* SDP0 IO direction */
+#define NGBE_GPIO_DDR_1				BIT(1) /* SDP1 IO direction */
+
+/* Wake up registers */
+#define NGBE_PSR_WKUP_CTL			0x15B80
+/* Wake Up Filter Control Bit */
+#define NGBE_PSR_WKUP_CTL_LNKC			BIT(0) /* Link Status Change Wakeup Enable*/
+#define NGBE_PSR_WKUP_CTL_MAG			BIT(1) /* Magic Packet Wakeup Enable */
+#define NGBE_PSR_WKUP_CTL_EX			BIT(2) /* Directed Exact Wakeup Enable */
+#define NGBE_PSR_WKUP_CTL_MC			BIT(3) /* Directed Multicast Wakeup Enable*/
+#define NGBE_PSR_WKUP_CTL_BC			BIT(4) /* Broadcast Wakeup Enable */
+#define NGBE_PSR_WKUP_CTL_ARP			BIT(5) /* ARP Request Packet Wakeup Enable*/
+#define NGBE_PSR_WKUP_CTL_IPV4			BIT(6) /* Directed IPv4 Pkt Wakeup Enable */
+#define NGBE_PSR_WKUP_CTL_IPV6			BIT(7) /* Directed IPv6 Pkt Wakeup Enable */
+
+#define NGBE_FW_EEPROM_CHECKSUM_CMD		0xE9
+#define NGBE_FW_NVM_DATA_OFFSET			3
+#define NGBE_FW_CMD_DEFAULT_CHECKSUM		0xFF /* checksum always 0xFF */
+#define NGBE_FW_CMD_ST_PASS			0x80658383
+#define NGBE_FW_CMD_ST_FAIL			0x70657376
+
+enum ngbe_phy_type {
+	ngbe_phy_unknown = 0,
+	ngbe_phy_none,
+	ngbe_phy_internal,
+	ngbe_phy_m88e1512,
+	ngbe_phy_m88e1512_sfi,
+	ngbe_phy_m88e1512_unknown,
+	ngbe_phy_yt8521s,
+	ngbe_phy_yt8521s_sfi,
+	ngbe_phy_internal_yt8521s_sfi,
+	ngbe_phy_generic
+};
+
+enum ngbe_media_type {
+	ngbe_media_type_unknown = 0,
+	ngbe_media_type_fiber,
+	ngbe_media_type_copper,
+	ngbe_media_type_backplane,
+};
+
+enum ngbe_mac_type {
+	ngbe_mac_type_unknown = 0,
+	ngbe_mac_type_mdi,
+	ngbe_mac_type_rgmii
+};
+
+struct ngbe_phy_info {
+	enum ngbe_phy_type type;
+	enum ngbe_media_type media_type;
+
+	u32 addr;
+	u32 id;
+
+	bool reset_if_overtemp;
+
+};
+
+struct ngbe_hw {
+	struct wx_hw wxhw;
+	struct ngbe_phy_info phy;
+	enum ngbe_mac_type mac_type;
+
+	bool wol_enabled;
+	bool ncsi_enabled;
+	bool gpio_ctrl;
+};
 #endif /* _NGBE_TYPE_H_ */
-- 
2.38.1

