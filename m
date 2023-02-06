Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0E168BDBC
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjBFNRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjBFNRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA0D23874
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N1-0007U1-U4
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:19 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 21CA0171513
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EF3E61712EC;
        Mon,  6 Feb 2023 13:16:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0fd22850;
        Mon, 6 Feb 2023 13:16:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Lukas Magel <lukas.magel@posteo.net>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 28/47] can: peak_usb: export PCAN CAN channel ID as sysfs device attribute
Date:   Mon,  6 Feb 2023 14:16:01 +0100
Message-Id: <20230206131620.2758724-29-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Magel <lukas.magel@posteo.net>

This patch exports the CAN channel ID as a sysfs attribute. The CAN
channel ID is a user-configurable u8/u32 identifier that can be set
individually for each CAN interface of a PEAK USB device.

Exporting the channel ID as a sysfs attribute allows users to easily read
the ID and to write udev rules that can match against the ID. This is
especially useful for PEAK USB devices that do not export a serial
number at SUB level.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Lukas Magel <lukas.magel@posteo.net>
Link: https://lore.kernel.org/all/20230116200932.157769-7-lukas.magel@posteo.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../ABI/testing/sysfs-class-net-peak_usb      | 19 ++++++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb_core.c  | 25 +++++++++++++++++++
 2 files changed, 44 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-peak_usb

diff --git a/Documentation/ABI/testing/sysfs-class-net-peak_usb b/Documentation/ABI/testing/sysfs-class-net-peak_usb
new file mode 100644
index 000000000000..9e3d0bf4d4b2
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-net-peak_usb
@@ -0,0 +1,19 @@
+
+What:		/sys/class/net/<iface>/peak_usb/can_channel_id
+Date:		November 2022
+KernelVersion:	6.2
+Contact:	Stephane Grosjean <s.grosjean@peak-system.com>
+Description:
+		PEAK PCAN-USB devices support user-configurable CAN channel
+		identifiers. Contrary to a USB serial number, these identifiers
+		are writable and can be set per CAN interface. This means that
+		if a USB device exports multiple CAN interfaces, each of them
+		can be assigned a unique channel ID.
+		This attribute provides read-only access to the currently
+		configured value of the channel identifier. Depending on the
+		device type, the identifier has a length of 8 or 32 bit. The
+		value read from this attribute is always an 8 digit 32 bit
+		hexadecimal value in big endian format. If the device only
+		supports an 8 bit identifier, the upper 24 bit of the value are
+		set to zero.
+
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 3bfd27742ae4..676923bd4213 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -15,6 +15,8 @@
 #include <linux/netdevice.h>
 #include <linux/usb.h>
 #include <linux/ethtool.h>
+#include <linux/sysfs.h>
+#include <linux/device.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
@@ -53,6 +55,26 @@ static const struct usb_device_id peak_usb_table[] = {
 
 MODULE_DEVICE_TABLE(usb, peak_usb_table);
 
+static ssize_t can_channel_id_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	struct peak_usb_device *peak_dev = netdev_priv(netdev);
+
+	return sysfs_emit(buf, "%08X\n", peak_dev->can_channel_id);
+}
+static DEVICE_ATTR_RO(can_channel_id);
+
+/* mutable to avoid cast in attribute_group */
+static struct attribute *peak_usb_sysfs_attrs[] = {
+	&dev_attr_can_channel_id.attr,
+	NULL,
+};
+
+static const struct attribute_group peak_usb_sysfs_group = {
+	.name	= "peak_usb",
+	.attrs	= peak_usb_sysfs_attrs,
+};
+
 /*
  * dump memory
  */
@@ -961,6 +983,9 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
 	/* add ethtool support */
 	netdev->ethtool_ops = peak_usb_adapter->ethtool_ops;
 
+	/* register peak_usb sysfs files */
+	netdev->sysfs_groups[0] = &peak_usb_sysfs_group;
+
 	init_usb_anchor(&dev->rx_submitted);
 
 	init_usb_anchor(&dev->tx_submitted);
-- 
2.39.1


