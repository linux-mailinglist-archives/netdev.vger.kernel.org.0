Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C0463BD96
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiK2KJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiK2KJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:09:05 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB4A5DB8E
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 02:08:26 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxX1-0006yD-M3; Tue, 29 Nov 2022 11:08:03 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxWy-0012iA-Hz; Tue, 29 Nov 2022 11:08:01 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxWx-00BYH6-H5; Tue, 29 Nov 2022 11:07:59 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        neo_jou <neo_jou@realtek.com>
Subject: [PATCH v4 07/11] wifi: rtw88: Add common USB chip support
Date:   Tue, 29 Nov 2022 11:07:50 +0100
Message-Id: <20221129100754.2753237-8-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221129100754.2753237-1-s.hauer@pengutronix.de>
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the common bits and pieces to add USB support to the RTW88 driver.
This is based on https://github.com/ulli-kroll/rtw88-usb.git which
itself is first written by Neo Jou.

Signed-off-by: neo_jou <neo_jou@realtek.com>
Signed-off-by: Hans Ulli Kroll <linux@ulli-kroll.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

Notes:
    Changes since v3:
    - Add sanity break out of potentially endless loop
    - Do not interleave PCI and USB support in Makefile
    - fix rtwusb->usb_data_index locking
    - make data_ptr variable in rtw_usb_tx_agg_skb() unnecessary
    - Some coding style fixup
    - drop set-but-unused variable in rtw_usb_write_data()
    - Increase RTW_USB_MAX_RXQ_LEN to 512. I've seen "failed to get rx_queue, overflow\n"
      trigger otherwise
    
    Changes since v2:
    - Fix buffer length for aggregated tx packets
    - Increase maximum transmit buffer size to 20KiB as found in downstream drivers
    - Change register write functions to synchronous accesses instead of just firing
      a URB without waiting for its completion
    - requeue rx URBs directly in completion handler rather than having a workqueue
      for it.
    
    Changes since v1:
    - Make checkpatch.pl clean
    - Drop WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL flag
    - Use 'ret' as variable name for return values
    - Sort variable declarations in reverse Xmas tree order
    - Change potentially endless loop to a limited loop
    - Change locking to be more obviously correct
    - drop unnecessary check for !rtwdev
    - make sure the refill workqueue is not restarted again after we have
      cancelled it

 drivers/net/wireless/realtek/rtw88/Kconfig  |   3 +
 drivers/net/wireless/realtek/rtw88/Makefile |   3 +
 drivers/net/wireless/realtek/rtw88/mac.c    |   3 +
 drivers/net/wireless/realtek/rtw88/main.c   |   4 +
 drivers/net/wireless/realtek/rtw88/main.h   |   4 +
 drivers/net/wireless/realtek/rtw88/reg.h    |   1 +
 drivers/net/wireless/realtek/rtw88/tx.h     |  31 +
 drivers/net/wireless/realtek/rtw88/usb.c    | 917 ++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/usb.h    | 107 +++
 9 files changed, 1073 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index e3d7cb6c12902..1624c5db69bac 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -16,6 +16,9 @@ config RTW88_CORE
 config RTW88_PCI
 	tristate
 
+config RTW88_USB
+	tristate
+
 config RTW88_8822B
 	tristate
 
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index 834c66ec0af9e..2c2b0e5133cdf 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -46,3 +46,6 @@ rtw88_8821ce-objs		:= rtw8821ce.o
 
 obj-$(CONFIG_RTW88_PCI)		+= rtw88_pci.o
 rtw88_pci-objs			:= pci.o
+
+obj-$(CONFIG_RTW88_USB)		+= rtw88_usb.o
+rtw88_usb-objs			:= usb.o
diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 52076e89d59a3..5882fc0fb885b 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -1032,6 +1032,9 @@ static int txdma_queue_mapping(struct rtw_dev *rtwdev)
 	if (rtw_chip_wcpu_11ac(rtwdev))
 		rtw_write32(rtwdev, REG_H2CQ_CSR, BIT_H2CQ_FULL);
 
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_USB)
+		rtw_write8_set(rtwdev, REG_TXDMA_PQ_MAP, BIT_RXDMA_ARBBW_EN);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 0a2ce7f50f412..888427cf3bdf9 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1783,6 +1783,10 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
 		rtwdev->hci.rpwm_addr = 0x03d9;
 		rtwdev->hci.cpwm_addr = 0x03da;
 		break;
+	case RTW_HCI_TYPE_USB:
+		rtwdev->hci.rpwm_addr = 0xfe58;
+		rtwdev->hci.cpwm_addr = 0xfe57;
+		break;
 	default:
 		rtw_err(rtwdev, "unsupported hci type\n");
 		return -EINVAL;
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 77fd48b6cc453..165f299e8e1f9 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -871,6 +871,10 @@ struct rtw_chip_ops {
 			       bool is_tx2_path);
 	void (*config_txrx_mode)(struct rtw_dev *rtwdev, u8 tx_path,
 				 u8 rx_path, bool is_tx2_path);
+	/* for USB/SDIO only */
+	void (*fill_txdesc_checksum)(struct rtw_dev *rtwdev,
+				     struct rtw_tx_pkt_info *pkt_info,
+				     u8 *txdesc);
 
 	/* for coex */
 	void (*coex_set_init)(struct rtw_dev *rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 03bd8dc53f72a..8852b24d6c2ac 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -184,6 +184,7 @@
 #define BIT_TXDMA_VIQ_MAP(x)                                                   \
 	(((x) & BIT_MASK_TXDMA_VIQ_MAP) << BIT_SHIFT_TXDMA_VIQ_MAP)
 #define REG_TXDMA_PQ_MAP	0x010C
+#define BIT_RXDMA_ARBBW_EN	BIT(0)
 #define BIT_SHIFT_TXDMA_BEQ_MAP	8
 #define BIT_MASK_TXDMA_BEQ_MAP	0x3
 #define BIT_TXDMA_BEQ_MAP(x)                                                   \
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index 8419603adce4a..a2f3ac326041b 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -71,6 +71,14 @@
 	le32p_replace_bits((__le32 *)(txdesc) + 0x03, value, BIT(15))
 #define SET_TX_DESC_BT_NULL(txdesc, value)				       \
 	le32p_replace_bits((__le32 *)(txdesc) + 0x02, value, BIT(23))
+#define SET_TX_DESC_TXDESC_CHECKSUM(txdesc, value)				\
+	le32p_replace_bits((__le32 *)(txdesc) + 0x07, value, GENMASK(15, 0))
+#define SET_TX_DESC_DMA_TXAGG_NUM(txdesc, value)				\
+	le32p_replace_bits((__le32 *)(txdesc) + 0x07, value, GENMASK(31, 24))
+#define GET_TX_DESC_PKT_OFFSET(txdesc)						\
+	le32_get_bits(*((__le32 *)(txdesc) + 0x01), GENMASK(28, 24))
+#define GET_TX_DESC_QSEL(txdesc)						\
+	le32_get_bits(*((__le32 *)(txdesc) + 0x01), GENMASK(12, 8))
 
 enum rtw_tx_desc_queue_select {
 	TX_DESC_QSEL_TID0	= 0,
@@ -123,4 +131,27 @@ rtw_tx_write_data_h2c_get(struct rtw_dev *rtwdev,
 			  struct rtw_tx_pkt_info *pkt_info,
 			  u8 *buf, u32 size);
 
+static inline
+void fill_txdesc_checksum_common(u8 *txdesc, size_t words)
+{
+	__le16 chksum = 0;
+	__le16 *data = (__le16 *)(txdesc);
+
+	SET_TX_DESC_TXDESC_CHECKSUM(txdesc, 0x0000);
+
+	while (words--)
+		chksum ^= *data++;
+
+	SET_TX_DESC_TXDESC_CHECKSUM(txdesc, __le16_to_cpu(chksum));
+}
+
+static inline void rtw_tx_fill_txdesc_checksum(struct rtw_dev *rtwdev,
+					       struct rtw_tx_pkt_info *pkt_info,
+					       u8 *txdesc)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+
+	chip->ops->fill_txdesc_checksum(rtwdev, pkt_info, txdesc);
+}
+
 #endif
diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
new file mode 100644
index 0000000000000..75b019d5b2c78
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -0,0 +1,917 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) 2018-2019  Realtek Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/mutex.h>
+#include "main.h"
+#include "debug.h"
+#include "reg.h"
+#include "tx.h"
+#include "rx.h"
+#include "fw.h"
+#include "ps.h"
+#include "usb.h"
+
+#define RTW_USB_MAX_RXQ_LEN	512
+
+struct rtw_usb_txcb {
+	struct rtw_dev *rtwdev;
+	struct sk_buff_head tx_ack_queue;
+};
+
+static void rtw_usb_fill_tx_checksum(struct rtw_usb *rtwusb,
+				     struct sk_buff *skb, int agg_num)
+{
+	struct rtw_dev *rtwdev = rtwusb->rtwdev;
+	struct rtw_tx_pkt_info pkt_info;
+
+	SET_TX_DESC_DMA_TXAGG_NUM(skb->data, agg_num);
+	pkt_info.pkt_offset = GET_TX_DESC_PKT_OFFSET(skb->data);
+	rtw_tx_fill_txdesc_checksum(rtwdev, &pkt_info, skb->data);
+}
+
+static u32 rtw_usb_read(struct rtw_dev *rtwdev, u32 addr, u16 len)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+	struct usb_device *udev = rtwusb->udev;
+	__le32 *data;
+	unsigned long flags;
+	int idx, ret;
+	static int count;
+
+	spin_lock_irqsave(&rtwusb->usb_lock, flags);
+
+	idx = rtwusb->usb_data_index;
+	rtwusb->usb_data_index = (idx + 1) & (RTW_USB_MAX_RXTX_COUNT - 1);
+
+	spin_unlock_irqrestore(&rtwusb->usb_lock, flags);
+
+	data = &rtwusb->usb_data[idx];
+
+	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+			      RTW_USB_CMD_REQ, RTW_USB_CMD_READ, addr,
+			      RTW_USB_VENQT_CMD_IDX, data, len, 1000);
+	if (ret < 0 && ret != -ENODEV && count++ < 4)
+		rtw_err(rtwdev, "read register 0x%x failed with %d\n",
+			addr, ret);
+
+	return le32_to_cpu(*data);
+}
+
+static u8 rtw_usb_read8(struct rtw_dev *rtwdev, u32 addr)
+{
+	return (u8)rtw_usb_read(rtwdev, addr, 1);
+}
+
+static u16 rtw_usb_read16(struct rtw_dev *rtwdev, u32 addr)
+{
+	return (u16)rtw_usb_read(rtwdev, addr, 2);
+}
+
+static u32 rtw_usb_read32(struct rtw_dev *rtwdev, u32 addr)
+{
+	return (u32)rtw_usb_read(rtwdev, addr, 4);
+}
+
+static void rtw_usb_write(struct rtw_dev *rtwdev, u32 addr, u32 val, int len)
+{
+	struct rtw_usb *rtwusb = (struct rtw_usb *)rtwdev->priv;
+	struct usb_device *udev = rtwusb->udev;
+	unsigned long flags;
+	__le32 *data;
+	int idx, ret;
+	static int count;
+
+	spin_lock_irqsave(&rtwusb->usb_lock, flags);
+
+	idx = rtwusb->usb_data_index;
+	rtwusb->usb_data_index = (idx + 1) & (RTW_USB_MAX_RXTX_COUNT - 1);
+
+	spin_unlock_irqrestore(&rtwusb->usb_lock, flags);
+
+	data = &rtwusb->usb_data[idx];
+
+	*data = cpu_to_le32(val);
+
+	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			      RTW_USB_CMD_REQ, RTW_USB_CMD_WRITE,
+			      addr, 0, data, len, 30000);
+	if (ret < 0 && ret != -ENODEV && count++ < 4)
+		rtw_err(rtwdev, "write register 0x%x failed with %d\n",
+			addr, ret);
+}
+
+static void rtw_usb_write8(struct rtw_dev *rtwdev, u32 addr, u8 val)
+{
+	rtw_usb_write(rtwdev, addr, val, 1);
+}
+
+static void rtw_usb_write16(struct rtw_dev *rtwdev, u32 addr, u16 val)
+{
+	rtw_usb_write(rtwdev, addr, val, 2);
+}
+
+static void rtw_usb_write32(struct rtw_dev *rtwdev, u32 addr, u32 val)
+{
+	rtw_usb_write(rtwdev, addr, val, 4);
+}
+
+static int rtw_usb_parse(struct rtw_dev *rtwdev,
+			 struct usb_interface *interface)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+	struct usb_host_interface *host_interface = &interface->altsetting[0];
+	struct usb_interface_descriptor *interface_desc = &host_interface->desc;
+	struct usb_endpoint_descriptor *endpoint;
+	struct usb_device *usbd = interface_to_usbdev(interface);
+	int num_out_pipes = 0;
+	int i;
+	u8 num;
+
+	for (i = 0; i < interface_desc->bNumEndpoints; i++) {
+		endpoint = &host_interface->endpoint[i].desc;
+		num = usb_endpoint_num(endpoint);
+
+		if (usb_endpoint_dir_in(endpoint) &&
+		    usb_endpoint_xfer_bulk(endpoint)) {
+			if (rtwusb->pipe_in) {
+				rtw_err(rtwdev, "IN pipes overflow\n");
+				return -EINVAL;
+			}
+
+			rtwusb->pipe_in = num;
+		}
+
+		if (usb_endpoint_dir_in(endpoint) &&
+		    usb_endpoint_xfer_int(endpoint)) {
+			if (rtwusb->pipe_interrupt) {
+				rtw_err(rtwdev, "INT pipes overflow\n");
+				return -EINVAL;
+			}
+
+			rtwusb->pipe_interrupt = num;
+		}
+
+		if (usb_endpoint_dir_out(endpoint) &&
+		    usb_endpoint_xfer_bulk(endpoint)) {
+			if (num_out_pipes >= ARRAY_SIZE(rtwusb->out_ep)) {
+				rtw_err(rtwdev, "OUT pipes overflow\n");
+				return -EINVAL;
+			}
+
+			rtwusb->out_ep[num_out_pipes++] = num;
+		}
+	}
+
+	switch (usbd->speed) {
+	case USB_SPEED_LOW:
+	case USB_SPEED_FULL:
+		rtwusb->bulkout_size = RTW_USB_FULL_SPEED_BULK_SIZE;
+		break;
+	case USB_SPEED_HIGH:
+		rtwusb->bulkout_size = RTW_USB_HIGH_SPEED_BULK_SIZE;
+		break;
+	case USB_SPEED_SUPER:
+		rtwusb->bulkout_size = RTW_USB_SUPER_SPEED_BULK_SIZE;
+		break;
+	default:
+		rtw_err(rtwdev, "failed to detect usb speed\n");
+		return -EINVAL;
+	}
+
+	rtwdev->hci.bulkout_num = num_out_pipes;
+
+	switch (num_out_pipes) {
+	case 4:
+	case 3:
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID0] = 2;
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID1] = 2;
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID2] = 2;
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID3] = 2;
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID4] = 1;
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID5] = 1;
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID6] = 0;
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID7] = 0;
+		break;
+	case 2:
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID0] = 1;
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID1] = 1;
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID2] = 1;
+		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID3] = 1;
+		break;
+	case 1:
+		break;
+	default:
+		rtw_err(rtwdev, "failed to get out_pipes(%d)\n", num_out_pipes);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void rtw_usb_write_port_tx_complete(struct urb *urb)
+{
+	struct rtw_usb_txcb *txcb = urb->context;
+	struct rtw_dev *rtwdev = txcb->rtwdev;
+	struct ieee80211_hw *hw = rtwdev->hw;
+	int max_iter = RTW_USB_MAX_XMITBUF_SZ;
+
+	while (true) {
+		struct sk_buff *skb = skb_dequeue(&txcb->tx_ack_queue);
+		struct ieee80211_tx_info *info;
+		struct rtw_usb_tx_data *tx_data;
+
+		if (!skb)
+			break;
+
+		if (!--max_iter) {
+			rtw_err(rtwdev, "failed to empty TX ack queue\n");
+			break;
+		}
+
+		info = IEEE80211_SKB_CB(skb);
+		tx_data = rtw_usb_get_tx_data(skb);
+
+		/* enqueue to wait for tx report */
+		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
+			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
+			continue;
+		}
+
+		/* always ACK for others, then they won't be marked as drop */
+		ieee80211_tx_info_clear_status(info);
+		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+			info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+		else
+			info->flags |= IEEE80211_TX_STAT_ACK;
+
+		ieee80211_tx_status_irqsafe(hw, skb);
+	}
+
+	kfree(txcb);
+}
+
+static int qsel_to_ep(struct rtw_usb *rtwusb, unsigned int qsel)
+{
+	if (qsel >= ARRAY_SIZE(rtwusb->qsel_to_ep))
+		return 0;
+
+	return rtwusb->qsel_to_ep[qsel];
+}
+
+static int rtw_usb_write_port(struct rtw_dev *rtwdev, u8 qsel, struct sk_buff *skb,
+			      usb_complete_t cb, void *context)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+	struct usb_device *usbd = rtwusb->udev;
+	struct urb *urb;
+	unsigned int pipe;
+	int ret;
+	int ep = qsel_to_ep(rtwusb, qsel);
+
+	pipe = usb_sndbulkpipe(usbd, rtwusb->out_ep[ep]);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!urb)
+		return -ENOMEM;
+
+	usb_fill_bulk_urb(urb, usbd, pipe, skb->data, skb->len, cb, context);
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
+
+	usb_free_urb(urb);
+
+	return ret;
+}
+
+static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list)
+{
+	struct rtw_dev *rtwdev = rtwusb->rtwdev;
+	struct rtw_usb_txcb *txcb;
+	struct sk_buff *skb_head;
+	struct sk_buff *skb_iter;
+	int agg_num = 0;
+	unsigned int align_next = 0;
+
+	if (skb_queue_empty(list))
+		return false;
+
+	txcb = kmalloc(sizeof(*txcb), GFP_ATOMIC);
+	if (!txcb)
+		return false;
+
+	txcb->rtwdev = rtwdev;
+	skb_queue_head_init(&txcb->tx_ack_queue);
+
+	skb_iter = skb_dequeue(list);
+
+	if (skb_queue_empty(list)) {
+		skb_head = skb_iter;
+		goto queue;
+	}
+
+	skb_head = dev_alloc_skb(RTW_USB_MAX_XMITBUF_SZ);
+	if (!skb_head) {
+		skb_head = skb_iter;
+		goto queue;
+	}
+
+	while (skb_iter) {
+		unsigned long flags;
+
+		skb_put(skb_head, align_next);
+		skb_put_data(skb_head, skb_iter->data, skb_iter->len);
+
+		align_next = ALIGN(skb_iter->len, 8) - skb_iter->len;
+
+		agg_num++;
+
+		skb_queue_tail(&txcb->tx_ack_queue, skb_iter);
+
+		spin_lock_irqsave(&list->lock, flags);
+
+		skb_iter = skb_peek(list);
+
+		if (skb_iter && skb_iter->len + skb_head->len <= RTW_USB_MAX_XMITBUF_SZ)
+			__skb_unlink(skb_iter, list);
+		else
+			skb_iter = NULL;
+		spin_unlock_irqrestore(&list->lock, flags);
+	}
+
+	if (agg_num > 1)
+		rtw_usb_fill_tx_checksum(rtwusb, skb_head, agg_num);
+
+queue:
+	skb_queue_tail(&txcb->tx_ack_queue, skb_head);
+
+	rtw_usb_write_port(rtwdev, GET_TX_DESC_QSEL(skb_head->data), skb_head,
+			   rtw_usb_write_port_tx_complete, txcb);
+
+	return true;
+}
+
+static void rtw_usb_tx_handler(struct work_struct *work)
+{
+	struct rtw_usb *rtwusb = container_of(work, struct rtw_usb, tx_work);
+	int i, limit;
+
+	for (i = ARRAY_SIZE(rtwusb->tx_queue) - 1; i >= 0; i--) {
+		for (limit = 0; limit < 200; limit++) {
+			struct sk_buff_head *list = &rtwusb->tx_queue[i];
+
+			if (!rtw_usb_tx_agg_skb(rtwusb, list))
+				break;
+		}
+	}
+}
+
+static void rtw_usb_tx_queue_purge(struct rtw_usb *rtwusb)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(rtwusb->tx_queue); i++)
+		skb_queue_purge(&rtwusb->tx_queue[i]);
+}
+
+static void rtw_usb_write_port_complete(struct urb *urb)
+{
+	struct sk_buff *skb = urb->context;
+
+	dev_kfree_skb_any(skb);
+}
+
+static int rtw_usb_write_data(struct rtw_dev *rtwdev,
+			      struct rtw_tx_pkt_info *pkt_info,
+			      u8 *buf)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct sk_buff *skb;
+	unsigned int desclen, headsize, size;
+	u8 qsel;
+	int ret = 0;
+
+	size = pkt_info->tx_pkt_size;
+	qsel = pkt_info->qsel;
+	desclen = chip->tx_pkt_desc_sz;
+	headsize = pkt_info->offset ? pkt_info->offset : desclen;
+
+	skb = dev_alloc_skb(headsize + size);
+	if (unlikely(!skb))
+		return -ENOMEM;
+
+	skb_reserve(skb, headsize);
+	skb_put_data(skb, buf, size);
+	skb_push(skb, headsize);
+	memset(skb->data, 0, headsize);
+	rtw_tx_fill_tx_desc(pkt_info, skb);
+	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
+
+	ret = rtw_usb_write_port(rtwdev, qsel, skb,
+				 rtw_usb_write_port_complete, skb);
+	if (unlikely(ret))
+		rtw_err(rtwdev, "failed to do USB write, ret=%d\n", ret);
+
+	return ret;
+}
+
+static int rtw_usb_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
+					u32 size)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_usb *rtwusb;
+	struct rtw_tx_pkt_info pkt_info = {0};
+	u32 len, desclen;
+
+	rtwusb = rtw_get_usb_priv(rtwdev);
+
+	pkt_info.tx_pkt_size = size;
+	pkt_info.qsel = TX_DESC_QSEL_BEACON;
+
+	desclen = chip->tx_pkt_desc_sz;
+	len = desclen + size;
+	if (len % rtwusb->bulkout_size == 0) {
+		len += RTW_USB_PACKET_OFFSET_SZ;
+		pkt_info.offset = desclen + RTW_USB_PACKET_OFFSET_SZ;
+		pkt_info.pkt_offset = 1;
+	} else {
+		pkt_info.offset = desclen;
+	}
+
+	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
+}
+
+static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
+{
+	struct rtw_tx_pkt_info pkt_info = {0};
+
+	pkt_info.tx_pkt_size = size;
+	pkt_info.qsel = TX_DESC_QSEL_H2C;
+
+	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
+}
+
+static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	__le16 fc = hdr->frame_control;
+	u8 qsel;
+
+	if (unlikely(ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)))
+		qsel = TX_DESC_QSEL_MGMT;
+	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
+		qsel = skb->priority;
+	else
+		qsel = TX_DESC_QSEL_BEACON;
+
+	return qsel;
+}
+
+static int rtw_usb_tx_write(struct rtw_dev *rtwdev,
+			    struct rtw_tx_pkt_info *pkt_info,
+			    struct sk_buff *skb)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_usb_tx_data *tx_data;
+	u8 *pkt_desc;
+	int ep;
+
+	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
+	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
+	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(skb);
+	ep = qsel_to_ep(rtwusb, pkt_info->qsel);
+	rtw_tx_fill_tx_desc(pkt_info, skb);
+	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
+	tx_data = rtw_usb_get_tx_data(skb);
+	tx_data->sn = pkt_info->sn;
+
+	skb_queue_tail(&rtwusb->tx_queue[ep], skb);
+
+	return 0;
+}
+
+static void rtw_usb_tx_kick_off(struct rtw_dev *rtwdev)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+
+	queue_work(rtwusb->txwq, &rtwusb->tx_work);
+}
+
+static void rtw_usb_rx_handler(struct work_struct *work)
+{
+	struct rtw_usb *rtwusb = container_of(work, struct rtw_usb, rx_work);
+	struct rtw_dev *rtwdev = rtwusb->rtwdev;
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_rx_pkt_stat pkt_stat;
+	struct ieee80211_rx_status rx_status;
+	struct sk_buff *skb;
+	u32 pkt_desc_sz = chip->rx_pkt_desc_sz;
+	u32 pkt_offset;
+	u8 *rx_desc;
+	int limit;
+
+	for (limit = 0; limit < 200; limit++) {
+		skb = skb_dequeue(&rtwusb->rx_queue);
+		if (!skb)
+			break;
+
+		rx_desc = skb->data;
+		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat,
+					 &rx_status);
+		pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
+			     pkt_stat.shift;
+
+		if (pkt_stat.is_c2h) {
+			skb_put(skb, pkt_stat.pkt_len + pkt_offset);
+			rtw_fw_c2h_cmd_rx_irqsafe(rtwdev, pkt_offset, skb);
+			continue;
+		}
+
+		if (skb_queue_len(&rtwusb->rx_queue) >= RTW_USB_MAX_RXQ_LEN) {
+			rtw_err(rtwdev, "failed to get rx_queue, overflow\n");
+			dev_kfree_skb_any(skb);
+			continue;
+		}
+
+		skb_put(skb, pkt_stat.pkt_len);
+		skb_reserve(skb, pkt_offset);
+		memcpy(skb->cb, &rx_status, sizeof(rx_status));
+		ieee80211_rx_irqsafe(rtwdev->hw, skb);
+	}
+}
+
+static void rtw_usb_read_port_complete(struct urb *urb);
+
+static void rtw_usb_rx_resubmit(struct rtw_usb *rtwusb, struct rx_usb_ctrl_block *rxcb)
+{
+	struct rtw_dev *rtwdev = rtwusb->rtwdev;
+	int error;
+
+	rxcb->rx_skb = alloc_skb(RTW_USB_MAX_RECVBUF_SZ, GFP_ATOMIC);
+	if (!rxcb->rx_skb)
+		return;
+
+	usb_fill_bulk_urb(rxcb->rx_urb, rtwusb->udev,
+			  usb_rcvbulkpipe(rtwusb->udev, rtwusb->pipe_in),
+			  rxcb->rx_skb->data, RTW_USB_MAX_RECVBUF_SZ,
+			  rtw_usb_read_port_complete, rxcb);
+
+	error = usb_submit_urb(rxcb->rx_urb, GFP_ATOMIC);
+	if (error) {
+		kfree_skb(rxcb->rx_skb);
+		if (error != -ENODEV)
+			rtw_err(rtwdev, "Err sending rx data urb %d\n",
+				error);
+	}
+}
+
+static void rtw_usb_read_port_complete(struct urb *urb)
+{
+	struct rx_usb_ctrl_block *rxcb = urb->context;
+	struct rtw_dev *rtwdev = rxcb->rtwdev;
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+	struct sk_buff *skb = rxcb->rx_skb;
+
+	if (urb->status == 0) {
+		if (urb->actual_length >= RTW_USB_MAX_RECVBUF_SZ ||
+		    urb->actual_length < 24) {
+			rtw_err(rtwdev, "failed to get urb length:%d\n",
+				urb->actual_length);
+			if (skb)
+				dev_kfree_skb_any(skb);
+		} else {
+			skb_queue_tail(&rtwusb->rx_queue, skb);
+			queue_work(rtwusb->rxwq, &rtwusb->rx_work);
+		}
+		rtw_usb_rx_resubmit(rtwusb, rxcb);
+	} else {
+		switch (urb->status) {
+		case -EINVAL:
+		case -EPIPE:
+		case -ENODEV:
+		case -ESHUTDOWN:
+		case -ENOENT:
+		case -EPROTO:
+		case -EILSEQ:
+		case -ETIME:
+		case -ECOMM:
+		case -EOVERFLOW:
+		case -EINPROGRESS:
+			break;
+		default:
+			rtw_err(rtwdev, "status %d\n", urb->status);
+			break;
+		}
+		if (skb)
+			dev_kfree_skb_any(skb);
+	}
+}
+
+static void rtw_usb_cancel_rx_bufs(struct rtw_usb *rtwusb)
+{
+	struct rx_usb_ctrl_block *rxcb;
+	int i;
+
+	for (i = 0; i < RTW_USB_RXCB_NUM; i++) {
+		rxcb = &rtwusb->rx_cb[i];
+		if (rxcb->rx_urb)
+			usb_kill_urb(rxcb->rx_urb);
+	}
+}
+
+static void rtw_usb_free_rx_bufs(struct rtw_usb *rtwusb)
+{
+	struct rx_usb_ctrl_block *rxcb;
+	int i;
+
+	for (i = 0; i < RTW_USB_RXCB_NUM; i++) {
+		rxcb = &rtwusb->rx_cb[i];
+		if (rxcb->rx_urb) {
+			usb_kill_urb(rxcb->rx_urb);
+			usb_free_urb(rxcb->rx_urb);
+		}
+	}
+}
+
+static int rtw_usb_alloc_rx_bufs(struct rtw_usb *rtwusb)
+{
+	int i;
+
+	for (i = 0; i < RTW_USB_RXCB_NUM; i++) {
+		struct rx_usb_ctrl_block *rxcb = &rtwusb->rx_cb[i];
+
+		rxcb->n = i;
+		rxcb->rtwdev = rtwusb->rtwdev;
+		rxcb->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!rxcb->rx_urb)
+			goto err;
+	}
+
+	return 0;
+err:
+	rtw_usb_free_rx_bufs(rtwusb);
+	return -ENOMEM;
+}
+
+static int rtw_usb_setup(struct rtw_dev *rtwdev)
+{
+	/* empty function for rtw_hci_ops */
+	return 0;
+}
+
+static int rtw_usb_start(struct rtw_dev *rtwdev)
+{
+	return 0;
+}
+
+static void rtw_usb_stop(struct rtw_dev *rtwdev)
+{
+}
+
+static void rtw_usb_deep_ps(struct rtw_dev *rtwdev, bool enter)
+{
+	/* empty function for rtw_hci_ops */
+}
+
+static void rtw_usb_link_ps(struct rtw_dev *rtwdev, bool enter)
+{
+	/* empty function for rtw_hci_ops */
+}
+
+static void rtw_usb_interface_cfg(struct rtw_dev *rtwdev)
+{
+	/* empty function for rtw_hci_ops */
+}
+
+static struct rtw_hci_ops rtw_usb_ops = {
+	.tx_write = rtw_usb_tx_write,
+	.tx_kick_off = rtw_usb_tx_kick_off,
+	.setup = rtw_usb_setup,
+	.start = rtw_usb_start,
+	.stop = rtw_usb_stop,
+	.deep_ps = rtw_usb_deep_ps,
+	.link_ps = rtw_usb_link_ps,
+	.interface_cfg = rtw_usb_interface_cfg,
+
+	.write8  = rtw_usb_write8,
+	.write16 = rtw_usb_write16,
+	.write32 = rtw_usb_write32,
+	.read8	= rtw_usb_read8,
+	.read16 = rtw_usb_read16,
+	.read32 = rtw_usb_read32,
+
+	.write_data_rsvd_page = rtw_usb_write_data_rsvd_page,
+	.write_data_h2c = rtw_usb_write_data_h2c,
+};
+
+static int rtw_usb_init_rx(struct rtw_dev *rtwdev)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+	int i;
+
+	rtwusb->rxwq = create_singlethread_workqueue("rtw88_usb: rx wq");
+	if (!rtwusb->rxwq) {
+		rtw_err(rtwdev, "failed to create RX work queue\n");
+		return -ENOMEM;
+	}
+
+	skb_queue_head_init(&rtwusb->rx_queue);
+
+	INIT_WORK(&rtwusb->rx_work, rtw_usb_rx_handler);
+
+	for (i = 0; i < RTW_USB_RXCB_NUM; i++) {
+		struct rx_usb_ctrl_block *rxcb = &rtwusb->rx_cb[i];
+
+		rtw_usb_rx_resubmit(rtwusb, rxcb);
+	}
+
+	return 0;
+}
+
+static void rtw_usb_deinit_rx(struct rtw_dev *rtwdev)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+
+	skb_queue_purge(&rtwusb->rx_queue);
+
+	flush_workqueue(rtwusb->rxwq);
+	destroy_workqueue(rtwusb->rxwq);
+}
+
+static int rtw_usb_init_tx(struct rtw_dev *rtwdev)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+	int i;
+
+	rtwusb->txwq = create_singlethread_workqueue("rtw88_usb: tx wq");
+	if (!rtwusb->txwq) {
+		rtw_err(rtwdev, "failed to create TX work queue\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(rtwusb->tx_queue); i++)
+		skb_queue_head_init(&rtwusb->tx_queue[i]);
+
+	INIT_WORK(&rtwusb->tx_work, rtw_usb_tx_handler);
+
+	return 0;
+}
+
+static void rtw_usb_deinit_tx(struct rtw_dev *rtwdev)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+
+	rtw_usb_tx_queue_purge(rtwusb);
+	flush_workqueue(rtwusb->txwq);
+	destroy_workqueue(rtwusb->txwq);
+}
+
+static int rtw_usb_intf_init(struct rtw_dev *rtwdev,
+			     struct usb_interface *intf)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+	struct usb_device *udev = usb_get_dev(interface_to_usbdev(intf));
+	int ret;
+
+	rtwusb->udev = udev;
+	ret = rtw_usb_parse(rtwdev, intf);
+	if (ret)
+		return ret;
+
+	rtwusb->usb_data = kcalloc(RTW_USB_MAX_RXTX_COUNT, sizeof(u32),
+				   GFP_KERNEL);
+	if (!rtwusb->usb_data)
+		return -ENOMEM;
+
+	usb_set_intfdata(intf, rtwdev->hw);
+
+	SET_IEEE80211_DEV(rtwdev->hw, &intf->dev);
+	spin_lock_init(&rtwusb->usb_lock);
+
+	return 0;
+}
+
+static void rtw_usb_intf_deinit(struct rtw_dev *rtwdev,
+				struct usb_interface *intf)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+
+	usb_put_dev(rtwusb->udev);
+	usb_set_intfdata(intf, NULL);
+}
+
+int rtw_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
+{
+	struct rtw_dev *rtwdev;
+	struct ieee80211_hw *hw;
+	struct rtw_usb *rtwusb;
+	int drv_data_size;
+	int ret;
+
+	drv_data_size = sizeof(struct rtw_dev) + sizeof(struct rtw_usb);
+	hw = ieee80211_alloc_hw(drv_data_size, &rtw_ops);
+	if (!hw)
+		return -ENOMEM;
+
+	rtwdev = hw->priv;
+	rtwdev->hw = hw;
+	rtwdev->dev = &intf->dev;
+	rtwdev->chip = (struct rtw_chip_info *)id->driver_info;
+	rtwdev->hci.ops = &rtw_usb_ops;
+	rtwdev->hci.type = RTW_HCI_TYPE_USB;
+
+	rtwusb = rtw_get_usb_priv(rtwdev);
+	rtwusb->rtwdev = rtwdev;
+
+	ret = rtw_usb_alloc_rx_bufs(rtwusb);
+	if (ret)
+		return ret;
+
+	ret = rtw_core_init(rtwdev);
+	if (ret)
+		goto err_release_hw;
+
+	ret = rtw_usb_intf_init(rtwdev, intf);
+	if (ret) {
+		rtw_err(rtwdev, "failed to init USB interface\n");
+		goto err_deinit_core;
+	}
+
+	ret = rtw_usb_init_tx(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to init USB TX\n");
+		goto err_destroy_usb;
+	}
+
+	ret = rtw_usb_init_rx(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to init USB RX\n");
+		goto err_destroy_txwq;
+	}
+
+	ret = rtw_chip_info_setup(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to setup chip information\n");
+		goto err_destroy_rxwq;
+	}
+
+	ret = rtw_register_hw(rtwdev, rtwdev->hw);
+	if (ret) {
+		rtw_err(rtwdev, "failed to register hw\n");
+		goto err_destroy_rxwq;
+	}
+
+	return 0;
+
+err_destroy_rxwq:
+	rtw_usb_deinit_rx(rtwdev);
+
+err_destroy_txwq:
+	rtw_usb_deinit_tx(rtwdev);
+
+err_destroy_usb:
+	rtw_usb_intf_deinit(rtwdev, intf);
+
+err_deinit_core:
+	rtw_core_deinit(rtwdev);
+
+err_release_hw:
+	ieee80211_free_hw(hw);
+
+	return ret;
+}
+EXPORT_SYMBOL(rtw_usb_probe);
+
+void rtw_usb_disconnect(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct rtw_dev *rtwdev;
+	struct rtw_usb *rtwusb;
+
+	if (!hw)
+		return;
+
+	rtwdev = hw->priv;
+	rtwusb = rtw_get_usb_priv(rtwdev);
+
+	rtw_usb_cancel_rx_bufs(rtwusb);
+
+	rtw_unregister_hw(rtwdev, hw);
+	rtw_usb_deinit_tx(rtwdev);
+	rtw_usb_deinit_rx(rtwdev);
+
+	if (rtwusb->udev->state != USB_STATE_NOTATTACHED)
+		usb_reset_device(rtwusb->udev);
+
+	rtw_usb_free_rx_bufs(rtwusb);
+
+	rtw_usb_intf_deinit(rtwdev, intf);
+	rtw_core_deinit(rtwdev);
+	ieee80211_free_hw(hw);
+}
+EXPORT_SYMBOL(rtw_usb_disconnect);
+
+MODULE_AUTHOR("Realtek Corporation");
+MODULE_DESCRIPTION("Realtek 802.11ac wireless USB driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wireless/realtek/rtw88/usb.h
new file mode 100644
index 0000000000000..30647f0dd61c6
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/usb.h
@@ -0,0 +1,107 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* Copyright(c) 2018-2019  Realtek Corporation
+ */
+
+#ifndef __RTW_USB_H_
+#define __RTW_USB_H_
+
+#define FW_8192C_START_ADDRESS		0x1000
+#define FW_8192C_END_ADDRESS		0x5fff
+
+#define RTW_USB_MAX_RXTX_COUNT		128
+#define RTW_USB_VENQT_MAX_BUF_SIZE	254
+#define MAX_USBCTRL_VENDORREQ_TIMES	10
+
+#define RTW_USB_CMD_READ		0xc0
+#define RTW_USB_CMD_WRITE		0x40
+#define RTW_USB_CMD_REQ			0x05
+
+#define RTW_USB_VENQT_CMD_IDX		0x00
+
+#define RTW_USB_SUPER_SPEED_BULK_SIZE	1024
+#define RTW_USB_HIGH_SPEED_BULK_SIZE	512
+#define RTW_USB_FULL_SPEED_BULK_SIZE	64
+
+#define RTW_USB_TX_SEL_HQ		BIT(0)
+#define RTW_USB_TX_SEL_LQ		BIT(1)
+#define RTW_USB_TX_SEL_NQ		BIT(2)
+#define RTW_USB_TX_SEL_EQ		BIT(3)
+
+#define RTW_USB_BULK_IN_ADDR		0x80
+#define RTW_USB_INT_IN_ADDR		0x81
+
+#define RTW_USB_HW_QUEUE_ENTRY		8
+
+#define RTW_USB_PACKET_OFFSET_SZ	8
+#define RTW_USB_MAX_XMITBUF_SZ		(1024 * 20)
+#define RTW_USB_MAX_RECVBUF_SZ		32768
+
+#define RTW_USB_RECVBUFF_ALIGN_SZ	8
+
+#define RTW_USB_RXAGG_SIZE		6
+#define RTW_USB_RXAGG_TIMEOUT		10
+
+#define RTW_USB_RXCB_NUM		4
+
+#define RTW_USB_EP_MAX			4
+
+#define TX_DESC_QSEL_MAX		20
+
+#define RTW_USB_VENDOR_ID_REALTEK	0x0bda
+
+static inline struct rtw_usb *rtw_get_usb_priv(struct rtw_dev *rtwdev)
+{
+	return (struct rtw_usb *)rtwdev->priv;
+}
+
+struct rx_usb_ctrl_block {
+	struct rtw_dev *rtwdev;
+	struct urb *rx_urb;
+	struct sk_buff *rx_skb;
+	int n;
+};
+
+struct rtw_usb_tx_data {
+	u8 sn;
+};
+
+struct rtw_usb {
+	struct rtw_dev *rtwdev;
+	struct usb_device *udev;
+
+	/* protects usb_data_index */
+	spinlock_t usb_lock;
+	__le32 *usb_data;
+	unsigned int usb_data_index;
+
+	u32 bulkout_size;
+	u8 pipe_interrupt;
+	u8 pipe_in;
+	u8 out_ep[RTW_USB_EP_MAX];
+	u8 qsel_to_ep[TX_DESC_QSEL_MAX];
+	u8 usb_txagg_num;
+
+	struct workqueue_struct *txwq, *rxwq;
+
+	struct sk_buff_head tx_queue[RTW_USB_EP_MAX];
+	struct work_struct tx_work;
+
+	struct rx_usb_ctrl_block rx_cb[RTW_USB_RXCB_NUM];
+	struct sk_buff_head rx_queue;
+	struct work_struct rx_work;
+};
+
+static inline struct rtw_usb_tx_data *rtw_usb_get_tx_data(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	BUILD_BUG_ON(sizeof(struct rtw_usb_tx_data) >
+		     sizeof(info->status.status_driver_data));
+
+	return (struct rtw_usb_tx_data *)info->status.status_driver_data;
+}
+
+int rtw_usb_probe(struct usb_interface *intf, const struct usb_device_id *id);
+void rtw_usb_disconnect(struct usb_interface *intf);
+
+#endif
-- 
2.30.2

