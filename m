Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6541795DDF
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 13:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbfHTLwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 07:52:19 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:52356 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbfHTLwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 07:52:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id 31F4023F1FF;
        Tue, 20 Aug 2019 13:52:15 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.127
X-Spam-Level: 
X-Spam-Status: No, score=-3.127 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.227, BAYES_00=-1.9] autolearn=ham
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0K5sYk7HnZrM; Tue, 20 Aug 2019 13:52:13 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPA id 6964A23F183;
        Tue, 20 Aug 2019 13:52:13 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lars Poeschel <poeschel@lemonage.de>,
        Steve Winslow <swinslow@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:NFC SUBSYSTEM)
Cc:     Johan Hovold <johan@kernel.org>
Subject: [PATCH v6 5/7] nfc: pn533: add UART phy driver
Date:   Tue, 20 Aug 2019 14:03:42 +0200
Message-Id: <20190820120345.22593-5-poeschel@lemonage.de>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190820120345.22593-1-poeschel@lemonage.de>
References: <20190820120345.22593-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the UART phy interface for the pn533 driver.
The pn533 driver can be used through UART interface this way.
It is implemented as a serdev device.

Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
Changes in v6:
- Rebased the patch series on v5.3-rc5

Changes in v5:
- Use the splitted pn53x_common_init and pn53x_register_nfc
  and pn53x_common_clean and pn53x_unregister_nfc alike

Changes in v4:
- SPDX-License-Identifier: GPL-2.0+
- Source code comments above refering items
- Error check for serdev_device_write's
- Change if (xxx == NULL) to if (!xxx)
- Remove device name from a dev_err
- move pn533_register in _probe a bit towards the end of _probe
- make use of newly added dev_up / dev_down phy_ops
- control send_wakeup variable from dev_up / dev_down

Changes in v3:
- depend on SERIAL_DEV_BUS in Kconfig

Changes in v2:
- switched from tty line discipline to serdev, resulting in many
  simplifications
- SPDX License Identifier

 drivers/nfc/pn533/Kconfig  |  11 ++
 drivers/nfc/pn533/Makefile |   2 +
 drivers/nfc/pn533/pn533.h  |   8 +
 drivers/nfc/pn533/uart.c   | 316 +++++++++++++++++++++++++++++++++++++
 4 files changed, 337 insertions(+)
 create mode 100644 drivers/nfc/pn533/uart.c

diff --git a/drivers/nfc/pn533/Kconfig b/drivers/nfc/pn533/Kconfig
index f6d6b345ba0d..7fe1bbe26568 100644
--- a/drivers/nfc/pn533/Kconfig
+++ b/drivers/nfc/pn533/Kconfig
@@ -26,3 +26,14 @@ config NFC_PN533_I2C
 
 	  If you choose to build a module, it'll be called pn533_i2c.
 	  Say N if unsure.
+
+config NFC_PN532_UART
+	tristate "NFC PN532 device support (UART)"
+	depends on SERIAL_DEV_BUS
+	select NFC_PN533
+	---help---
+	  This module adds support for the NXP pn532 UART interface.
+	  Select this if your platform is using the UART bus.
+
+	  If you choose to build a module, it'll be called pn532_uart.
+	  Say N if unsure.
diff --git a/drivers/nfc/pn533/Makefile b/drivers/nfc/pn533/Makefile
index 43c25b4f9466..b9648337576f 100644
--- a/drivers/nfc/pn533/Makefile
+++ b/drivers/nfc/pn533/Makefile
@@ -4,7 +4,9 @@
 #
 pn533_usb-objs  = usb.o
 pn533_i2c-objs  = i2c.o
+pn532_uart-objs  = uart.o
 
 obj-$(CONFIG_NFC_PN533)     += pn533.o
 obj-$(CONFIG_NFC_PN533_USB) += pn533_usb.o
 obj-$(CONFIG_NFC_PN533_I2C) += pn533_i2c.o
+obj-$(CONFIG_NFC_PN532_UART) += pn532_uart.o
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index 510ddebbd896..6541088fad73 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -43,6 +43,11 @@
 
 /* Preamble (1), SoPC (2), ACK Code (2), Postamble (1) */
 #define PN533_STD_FRAME_ACK_SIZE 6
+/*
+ * Preamble (1), SoPC (2), Packet Length (1), Packet Length Checksum (1),
+ * Specific Application Level Error Code (1) , Postamble (1)
+ */
+#define PN533_STD_ERROR_FRAME_SIZE 8
 #define PN533_STD_FRAME_CHECKSUM(f) (f->data[f->datalen])
 #define PN533_STD_FRAME_POSTAMBLE(f) (f->data[f->datalen + 1])
 /* Half start code (3), LEN (4) should be 0xffff for extended frame */
@@ -84,6 +89,9 @@
 #define PN533_CMD_MI_MASK 0x40
 #define PN533_CMD_RET_SUCCESS 0x00
 
+#define PN533_FRAME_DATALEN_ACK 0x00
+#define PN533_FRAME_DATALEN_ERROR 0x01
+#define PN533_FRAME_DATALEN_EXTENDED 0xFF
 
 enum  pn533_protocol_type {
 	PN533_PROTO_REQ_ACK_RESP = 0,
diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
new file mode 100644
index 000000000000..f1cc2354a4fd
--- /dev/null
+++ b/drivers/nfc/pn533/uart.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Driver for NXP PN532 NFC Chip - UART transport layer
+ *
+ * Copyright (C) 2018 Lemonage Software GmbH
+ * Author: Lars Pöschel <poeschel@lemonage.de>
+ * All rights reserved.
+ */
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/nfc.h>
+#include <linux/netdevice.h>
+#include <linux/of.h>
+#include <linux/serdev.h>
+#include "pn533.h"
+
+#define PN532_UART_SKB_BUFF_LEN	(PN533_CMD_DATAEXCH_DATA_MAXLEN * 2)
+
+enum send_wakeup {
+	PN532_SEND_NO_WAKEUP = 0,
+	PN532_SEND_WAKEUP,
+	PN532_SEND_LAST_WAKEUP,
+};
+
+
+struct pn532_uart_phy {
+	struct serdev_device *serdev;
+	struct sk_buff *recv_skb;
+	struct pn533 *priv;
+	enum send_wakeup send_wakeup;
+	struct timer_list cmd_timeout;
+	struct sk_buff *cur_out_buf;
+};
+
+static int pn532_uart_send_frame(struct pn533 *dev,
+				struct sk_buff *out)
+{
+	/* wakeup sequence and dummy bytes for waiting time */
+	static const u8 wakeup[] = {
+		0x55, 0x55, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	struct pn532_uart_phy *pn532 = dev->phy;
+	int err;
+
+	print_hex_dump_debug("PN532_uart TX: ", DUMP_PREFIX_NONE, 16, 1,
+			     out->data, out->len, false);
+
+	pn532->cur_out_buf = out;
+	if (pn532->send_wakeup) {
+		err= serdev_device_write(pn532->serdev,
+				wakeup, sizeof(wakeup),
+				MAX_SCHEDULE_TIMEOUT);
+		if (err < 0)
+			return err;
+	}
+
+	if (pn532->send_wakeup == PN532_SEND_LAST_WAKEUP) {
+		pn532->send_wakeup = PN532_SEND_NO_WAKEUP;
+	}
+
+	err = serdev_device_write(pn532->serdev, out->data, out->len,
+			MAX_SCHEDULE_TIMEOUT);
+	if (err < 0)
+		return err;
+
+	mod_timer(&pn532->cmd_timeout, HZ / 40 + jiffies);
+	return 0;
+}
+
+static int pn532_uart_send_ack(struct pn533 *dev, gfp_t flags)
+{
+	struct pn532_uart_phy *pn532 = dev->phy;
+	/* spec 7.1.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
+	static const u8 ack[PN533_STD_FRAME_ACK_SIZE] = {
+			0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
+	int err;
+
+	err = serdev_device_write(pn532->serdev, ack, sizeof(ack),
+			MAX_SCHEDULE_TIMEOUT);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static void pn532_uart_abort_cmd(struct pn533 *dev, gfp_t flags)
+{
+	/* An ack will cancel the last issued command */
+	pn532_uart_send_ack(dev, flags);
+	/* schedule cmd_complete_work to finish current command execution */
+	pn533_recv_frame(dev, NULL, -ENOENT);
+}
+
+static void pn532_dev_up(struct pn533 *dev)
+{
+	struct pn532_uart_phy *pn532 = dev->phy;
+
+	serdev_device_open(pn532->serdev);
+	pn532->send_wakeup = PN532_SEND_LAST_WAKEUP;
+}
+
+static void pn532_dev_down(struct pn533 *dev)
+{
+	struct pn532_uart_phy *pn532 = dev->phy;
+
+	serdev_device_close(pn532->serdev);
+	pn532->send_wakeup = PN532_SEND_WAKEUP;
+}
+
+static struct pn533_phy_ops uart_phy_ops = {
+	.send_frame = pn532_uart_send_frame,
+	.send_ack = pn532_uart_send_ack,
+	.abort_cmd = pn532_uart_abort_cmd,
+	.dev_up = pn532_dev_up,
+	.dev_down = pn532_dev_down,
+};
+
+static void pn532_cmd_timeout(struct timer_list *t)
+{
+	struct pn532_uart_phy *dev = from_timer(dev, t, cmd_timeout);
+
+	pn532_uart_send_frame(dev->priv, dev->cur_out_buf);
+}
+
+/*
+ * scans the buffer if it contains a pn532 frame. It is not checked if the
+ * frame is really valid. This is later done with pn533_rx_frame_is_valid.
+ * This is useful for malformed or errornous transmitted frames. Adjusts the
+ * bufferposition where the frame starts, since pn533_recv_frame expects a
+ * well formed frame.
+ */
+static int pn532_uart_rx_is_frame(struct sk_buff *skb)
+{
+	int i;
+	u16 frame_len;
+	struct pn533_std_frame *std;
+	struct pn533_ext_frame *ext;
+
+	for (i = 0; i + PN533_STD_FRAME_ACK_SIZE <= skb->len; i++) {
+		std = (struct pn533_std_frame *)&skb->data[i];
+		/* search start code */
+		if (std->start_frame != cpu_to_be16(PN533_STD_FRAME_SOF))
+			continue;
+
+		/* frame type */
+		switch (std->datalen) {
+		case PN533_FRAME_DATALEN_ACK:
+			if (std->datalen_checksum == 0xff) {
+				skb_pull(skb, i);
+				return 1;
+			}
+
+			break;
+		case PN533_FRAME_DATALEN_ERROR:
+			if ((std->datalen_checksum == 0xff) &&
+					(skb->len >=
+					 PN533_STD_ERROR_FRAME_SIZE)) {
+				skb_pull(skb, i);
+				return 1;
+			}
+
+			break;
+		case PN533_FRAME_DATALEN_EXTENDED:
+			ext = (struct pn533_ext_frame *)&skb->data[i];
+			frame_len = ext->datalen;
+			if (skb->len >= frame_len +
+					sizeof(struct pn533_ext_frame) +
+					2 /* CKS + Postamble */) {
+				skb_pull(skb, i);
+				return 1;
+			}
+
+			break;
+		default: /* normal information frame */
+			frame_len = std->datalen;
+			if (skb->len >= frame_len +
+					sizeof(struct pn533_std_frame) +
+					2 /* CKS + Postamble */) {
+				skb_pull(skb, i);
+				return 1;
+			}
+
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int pn532_receive_buf(struct serdev_device *serdev,
+		const unsigned char *data, size_t count)
+{
+	struct pn532_uart_phy *dev = serdev_device_get_drvdata(serdev);
+	size_t i;
+
+	del_timer(&dev->cmd_timeout);
+	for (i = 0; i < count; i++) {
+		skb_put_u8(dev->recv_skb, *data++);
+		if (!pn532_uart_rx_is_frame(dev->recv_skb))
+			continue;
+
+		pn533_recv_frame(dev->priv, dev->recv_skb, 0);
+		dev->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
+		if (!dev->recv_skb)
+			return 0;
+	}
+
+	return i;
+}
+
+static struct serdev_device_ops pn532_serdev_ops = {
+	.receive_buf = pn532_receive_buf,
+	.write_wakeup = serdev_device_write_wakeup,
+};
+
+static const struct of_device_id pn532_uart_of_match[] = {
+	{ .compatible = "nxp,pn532", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pn532_uart_of_match);
+
+static int pn532_uart_probe(struct serdev_device *serdev)
+{
+	struct pn532_uart_phy *pn532;
+	struct pn533 *priv;
+	int err;
+
+	err = -ENOMEM;
+	pn532 = kzalloc(sizeof(*pn532), GFP_KERNEL);
+	if (!pn532)
+		goto err_exit;
+
+	pn532->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
+	if (!pn532->recv_skb)
+		goto err_free;
+
+	pn532->serdev = serdev;
+	serdev_device_set_drvdata(serdev, pn532);
+	serdev_device_set_client_ops(serdev, &pn532_serdev_ops);
+	err = serdev_device_open(serdev);
+	if (err) {
+		dev_err(&serdev->dev, "Unable to open device\n");
+		goto err_skb;
+	}
+
+	err = serdev_device_set_baudrate(serdev, 115200);
+	if (err != 115200) {
+		err = -EINVAL;
+		goto err_serdev;
+	}
+
+	serdev_device_set_flow_control(serdev, false);
+	pn532->send_wakeup = PN532_SEND_WAKEUP;
+	timer_setup(&pn532->cmd_timeout, pn532_cmd_timeout, 0);
+	priv = pn53x_common_init(PN533_DEVICE_PN532,
+				     PN533_PROTO_REQ_ACK_RESP,
+				     pn532, &uart_phy_ops, NULL,
+				     &pn532->serdev->dev);
+	if (IS_ERR(priv)) {
+		err = PTR_ERR(priv);
+		goto err_serdev;
+	}
+
+	pn532->priv = priv;
+	err = pn533_finalize_setup(pn532->priv);
+	if (err)
+		goto err_clean;
+
+	serdev_device_close(serdev);
+	err = pn53x_register_nfc(priv, PN533_NO_TYPE_B_PROTOCOLS, &serdev->dev);
+	if (err) {
+		pn53x_common_clean(pn532->priv);
+		goto err_skb;
+	}
+
+	return err;
+
+err_clean:
+	pn53x_common_clean(pn532->priv);
+err_serdev:
+	serdev_device_close(serdev);
+err_skb:
+	kfree_skb(pn532->recv_skb);
+err_free:
+	kfree(pn532);
+err_exit:
+	return err;
+}
+
+static void pn532_uart_remove(struct serdev_device *serdev)
+{
+	struct pn532_uart_phy *pn532 = serdev_device_get_drvdata(serdev);
+
+	pn53x_unregister_nfc(pn532->priv);
+	serdev_device_close(serdev);
+	pn53x_common_clean(pn532->priv);
+	kfree_skb(pn532->recv_skb);
+	kfree(pn532);
+}
+
+static struct serdev_device_driver pn532_uart_driver = {
+	.probe = pn532_uart_probe,
+	.remove = pn532_uart_remove,
+	.driver = {
+		.name = "pn532_uart",
+		.of_match_table = of_match_ptr(pn532_uart_of_match),
+	},
+};
+
+module_serdev_device_driver(pn532_uart_driver);
+
+MODULE_AUTHOR("Lars Pöschel <poeschel@lemonage.de>");
+MODULE_DESCRIPTION("PN532 UART driver");
+MODULE_LICENSE("GPL");
-- 
2.23.0.rc1

