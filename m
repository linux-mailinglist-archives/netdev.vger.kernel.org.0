Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7944634E6AC
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhC3LrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhC3Lqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481C7C061765
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpK-0006C4-5m
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:30 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id F2687603E68
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9C314603E00;
        Tue, 30 Mar 2021 11:46:07 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ef36f8c5;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 15/39] can: peak_usb: add support of ethtool set_phys_id()
Date:   Tue, 30 Mar 2021 13:45:35 +0200
Message-Id: <20210330114559.1114855-16-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

This patch makes it possible to specifically flash the LED of a CAN
port of the CAN-USB interfaces of PEAK-System.

Link: https://lore.kernel.org/r/20210309122141.3276927-1-mkl@pengutronix.de
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
[mkl: use common prefix PCAN_ for defines]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c      | 47 ++++++++++++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |  4 ++
 drivers/net/can/usb/peak_usb/pcan_usb_core.h |  2 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   | 34 ++++++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c  | 34 +++++++++++++-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h  |  6 +++
 6 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index e393e8457d77..ba509aed7b4c 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <linux/usb.h>
 #include <linux/module.h>
+#include <linux/ethtool.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
@@ -40,6 +41,7 @@
 #define PCAN_USB_CMD_REGISTER	9
 #define PCAN_USB_CMD_EXT_VCC	10
 #define PCAN_USB_CMD_ERR_FR	11
+#define PCAN_USB_CMD_LED	12
 
 /* PCAN_USB_CMD_SET_BUS number arg */
 #define PCAN_USB_BUS_XCVER		2
@@ -248,6 +250,15 @@ static int pcan_usb_set_ext_vcc(struct peak_usb_device *dev, u8 onoff)
 	return pcan_usb_send_cmd(dev, PCAN_USB_CMD_EXT_VCC, PCAN_USB_SET, args);
 }
 
+static int pcan_usb_set_led(struct peak_usb_device *dev, u8 onoff)
+{
+	u8 args[PCAN_USB_CMD_ARGS_LEN] = {
+		[0] = !!onoff,
+	};
+
+	return pcan_usb_send_cmd(dev, PCAN_USB_CMD_LED, PCAN_USB_SET, args);
+}
+
 /*
  * set bittiming value to can
  */
@@ -971,6 +982,40 @@ static int pcan_usb_probe(struct usb_interface *intf)
 	return 0;
 }
 
+static int pcan_usb_set_phys_id(struct net_device *netdev,
+				enum ethtool_phys_id_state state)
+{
+	struct peak_usb_device *dev = netdev_priv(netdev);
+	int err = 0;
+
+	switch (state) {
+	case ETHTOOL_ID_ACTIVE:
+		/* call ON/OFF twice a second */
+		return 2;
+
+	case ETHTOOL_ID_OFF:
+		err = pcan_usb_set_led(dev, 0);
+		break;
+
+	case ETHTOOL_ID_ON:
+		fallthrough;
+
+	case ETHTOOL_ID_INACTIVE:
+		/* restore LED default */
+		err = pcan_usb_set_led(dev, 1);
+		break;
+
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static const struct ethtool_ops pcan_usb_ethtool_ops = {
+	.set_phys_id = pcan_usb_set_phys_id,
+};
+
 /*
  * describe the PCAN-USB adapter
  */
@@ -1001,6 +1046,8 @@ const struct peak_usb_adapter pcan_usb = {
 	/* size of device private data */
 	.sizeof_dev_private = sizeof(struct pcan_usb),
 
+	.ethtool_ops = &pcan_usb_ethtool_ops,
+
 	/* timestamps usage */
 	.ts_used_bits = 16,
 	.ts_period = 24575, /* calibration period in ts. */
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 29227b5851fe..ad006edf474d 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/usb.h>
+#include <linux/ethtool.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
@@ -820,6 +821,9 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
 
 	netdev->flags |= IFF_ECHO; /* we support local echo */
 
+	/* add ethtool support */
+	netdev->ethtool_ops = peak_usb_adapter->ethtool_ops;
+
 	init_usb_anchor(&dev->rx_submitted);
 
 	init_usb_anchor(&dev->tx_submitted);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.h b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
index 4b1528a42a7b..e15b4c78f309 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
@@ -46,6 +46,8 @@ struct peak_usb_adapter {
 	const struct can_bittiming_const * const data_bittiming_const;
 	unsigned int ctrl_count;
 
+	const struct ethtool_ops *ethtool_ops;
+
 	int (*intf_probe)(struct usb_interface *intf);
 
 	int (*dev_init)(struct peak_usb_device *dev);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index bae078579c0d..b3e56ee03cd5 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -7,6 +7,7 @@
 #include <linux/netdevice.h>
 #include <linux/usb.h>
 #include <linux/module.h>
+#include <linux/ethtool.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
@@ -1006,6 +1007,31 @@ static void pcan_usb_fd_free(struct peak_usb_device *dev)
 	}
 }
 
+/* blink LED's */
+static int pcan_usb_fd_set_phys_id(struct net_device *netdev,
+				   enum ethtool_phys_id_state state)
+{
+	struct peak_usb_device *dev = netdev_priv(netdev);
+	int err = 0;
+
+	switch (state) {
+	case ETHTOOL_ID_ACTIVE:
+		err = pcan_usb_fd_set_can_led(dev, PCAN_UFD_LED_FAST);
+		break;
+	case ETHTOOL_ID_INACTIVE:
+		err = pcan_usb_fd_set_can_led(dev, PCAN_UFD_LED_DEF);
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static const struct ethtool_ops pcan_usb_fd_ethtool_ops = {
+	.set_phys_id = pcan_usb_fd_set_phys_id,
+};
+
 /* describes the PCAN-USB FD adapter */
 static const struct can_bittiming_const pcan_usb_fd_const = {
 	.name = "pcan_usb_fd",
@@ -1047,6 +1073,8 @@ const struct peak_usb_adapter pcan_usb_fd = {
 	/* size of device private data */
 	.sizeof_dev_private = sizeof(struct pcan_usb_fd_device),
 
+	.ethtool_ops = &pcan_usb_fd_ethtool_ops,
+
 	/* timestamps usage */
 	.ts_used_bits = 32,
 	.ts_period = 1000000, /* calibration period in ts. */
@@ -1120,6 +1148,8 @@ const struct peak_usb_adapter pcan_usb_chip = {
 	/* size of device private data */
 	.sizeof_dev_private = sizeof(struct pcan_usb_fd_device),
 
+	.ethtool_ops = &pcan_usb_fd_ethtool_ops,
+
 	/* timestamps usage */
 	.ts_used_bits = 32,
 	.ts_period = 1000000, /* calibration period in ts. */
@@ -1193,6 +1223,8 @@ const struct peak_usb_adapter pcan_usb_pro_fd = {
 	/* size of device private data */
 	.sizeof_dev_private = sizeof(struct pcan_usb_fd_device),
 
+	.ethtool_ops = &pcan_usb_fd_ethtool_ops,
+
 	/* timestamps usage */
 	.ts_used_bits = 32,
 	.ts_period = 1000000, /* calibration period in ts. */
@@ -1266,6 +1298,8 @@ const struct peak_usb_adapter pcan_usb_x6 = {
 	/* size of device private data */
 	.sizeof_dev_private = sizeof(struct pcan_usb_fd_device),
 
+	.ethtool_ops = &pcan_usb_fd_ethtool_ops,
+
 	/* timestamps usage */
 	.ts_used_bits = 32,
 	.ts_period = 1000000, /* calibration period in ts. */
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index 902900d4f7c1..b314d2eaaece 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -9,6 +9,7 @@
 #include <linux/netdevice.h>
 #include <linux/usb.h>
 #include <linux/module.h>
+#include <linux/ethtool.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
@@ -906,7 +907,7 @@ static int pcan_usb_pro_init(struct peak_usb_device *dev)
 	usb_if->dev[dev->ctrl_idx] = dev;
 
 	/* set LED in default state (end of init phase) */
-	pcan_usb_pro_set_led(dev, 0, 1);
+	pcan_usb_pro_set_led(dev, PCAN_USBPRO_LED_DEVICE, 1);
 
 	kfree(bi);
 	kfree(fi);
@@ -990,6 +991,35 @@ int pcan_usb_pro_probe(struct usb_interface *intf)
 	return 0;
 }
 
+static int pcan_usb_pro_set_phys_id(struct net_device *netdev,
+				    enum ethtool_phys_id_state state)
+{
+	struct peak_usb_device *dev = netdev_priv(netdev);
+	int err = 0;
+
+	switch (state) {
+	case ETHTOOL_ID_ACTIVE:
+		/* fast blinking forever */
+		err = pcan_usb_pro_set_led(dev, PCAN_USBPRO_LED_BLINK_FAST,
+					   0xffffffff);
+		break;
+
+	case ETHTOOL_ID_INACTIVE:
+		/* restore LED default */
+		err = pcan_usb_pro_set_led(dev, PCAN_USBPRO_LED_DEVICE, 1);
+		break;
+
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static const struct ethtool_ops pcan_usb_pro_ethtool_ops = {
+	.set_phys_id = pcan_usb_pro_set_phys_id,
+};
+
 /*
  * describe the PCAN-USB Pro adapter
  */
@@ -1018,6 +1048,8 @@ const struct peak_usb_adapter pcan_usb_pro = {
 	/* size of device private data */
 	.sizeof_dev_private = sizeof(struct pcan_usb_pro_device),
 
+	.ethtool_ops = &pcan_usb_pro_ethtool_ops,
+
 	/* timestamps usage */
 	.ts_used_bits = 32,
 	.ts_period = 1000000, /* calibration period in ts. */
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.h b/drivers/net/can/usb/peak_usb/pcan_usb_pro.h
index 6bb12357d078..6f4504300e23 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.h
@@ -115,6 +115,12 @@ struct __packed pcan_usb_pro_devid {
 	__le32 serial_num;
 };
 
+#define PCAN_USBPRO_LED_DEVICE		0x00
+#define PCAN_USBPRO_LED_BLINK_FAST	0x01
+#define PCAN_USBPRO_LED_BLINK_SLOW	0x02
+#define PCAN_USBPRO_LED_ON		0x03
+#define PCAN_USBPRO_LED_OFF		0x04
+
 struct __packed pcan_usb_pro_setled {
 	u8  data_type;
 	u8  channel;
-- 
2.30.2


