Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274F268BDAA
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjBFNRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjBFNRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7AF234CE
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:20 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N0-0007RR-Au
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:18 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1B242171554
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:30 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id DEFD21712E5;
        Mon,  6 Feb 2023 13:16:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 960d77b6;
        Mon, 6 Feb 2023 13:16:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 27/47] can: peak_usb: add ethtool interface to user-configurable CAN channel identifier
Date:   Mon,  6 Feb 2023 14:16:00 +0100
Message-Id: <20230206131620.2758724-28-mkl@pengutronix.de>
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

From: Stephane Grosjean <s.grosjean@peak-system.com>

This patch introduces 3 new functions implementing support for ethtool
access to the CAN channel ID of all USB CAN network interfaces managed by
the driver. With this patch, it is possible to read/write the CAN
channel ID from/to the EEPROM via the ethtool interface.

The CAN channel ID is a user-configurable device identifier that can be
set individually for each CAN interface of a PEAK USB device. Depending on
the device, the identifier has a length of 8 or 32 bit. The identifier
is stored in the non-volatile memory of the device.

The identifier of a CAN interface can be read/written as an 8 or 32 bit
byte string in native (little-endian) byte order, where the length depends
on the device type.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Lukas Magel <lukas.magel@posteo.net>
Link: https://lore.kernel.org/all/20230116200932.157769-6-lukas.magel@posteo.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c      |  9 +++
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 80 ++++++++++++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb_core.h |  6 ++
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   |  3 +
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c  |  3 +
 5 files changed, 101 insertions(+)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 44e894a1f2c2..bead4f4ba472 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -982,9 +982,18 @@ static int pcan_usb_set_phys_id(struct net_device *netdev,
 	return err;
 }
 
+/* This device only handles 8-bit CAN channel id. */
+static int pcan_usb_get_eeprom_len(struct net_device *netdev)
+{
+	return sizeof(u8);
+}
+
 static const struct ethtool_ops pcan_usb_ethtool_ops = {
 	.set_phys_id = pcan_usb_set_phys_id,
 	.get_ts_info = pcan_get_ts_info,
+	.get_eeprom_len	= pcan_usb_get_eeprom_len,
+	.get_eeprom = peak_usb_get_eeprom,
+	.set_eeprom = peak_usb_set_eeprom,
 };
 
 /*
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 3a73eac314ff..3bfd27742ae4 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -808,6 +808,86 @@ static const struct net_device_ops peak_usb_netdev_ops = {
 	.ndo_change_mtu = can_change_mtu,
 };
 
+/* CAN-USB devices generally handle 32-bit CAN channel IDs.
+ * In case one doesn't, then it have to overload this function.
+ */
+int peak_usb_get_eeprom_len(struct net_device *netdev)
+{
+	return sizeof(u32);
+}
+
+/* Every CAN-USB device exports the dev_get_can_channel_id() operation. It is used
+ * here to fill the data buffer with the user defined CAN channel ID.
+ */
+int peak_usb_get_eeprom(struct net_device *netdev,
+			struct ethtool_eeprom *eeprom, u8 *data)
+{
+	struct peak_usb_device *dev = netdev_priv(netdev);
+	u32 ch_id;
+	__le32 ch_id_le;
+	int err;
+
+	err = dev->adapter->dev_get_can_channel_id(dev, &ch_id);
+	if (err)
+		return err;
+
+	/* ethtool operates on individual bytes. The byte order of the CAN
+	 * channel id in memory depends on the kernel architecture. We
+	 * convert the CAN channel id back to the native byte order of the PEAK
+	 * device itself to ensure that the order is consistent for all
+	 * host architectures.
+	 */
+	ch_id_le = cpu_to_le32(ch_id);
+	memcpy(data, (u8 *)&ch_id_le + eeprom->offset, eeprom->len);
+
+	/* update cached value */
+	dev->can_channel_id = ch_id;
+	return err;
+}
+
+/* Every CAN-USB device exports the dev_get_can_channel_id()/dev_set_can_channel_id()
+ * operations. They are used here to set the new user defined CAN channel ID.
+ */
+int peak_usb_set_eeprom(struct net_device *netdev,
+			struct ethtool_eeprom *eeprom, u8 *data)
+{
+	struct peak_usb_device *dev = netdev_priv(netdev);
+	u32 ch_id;
+	__le32 ch_id_le;
+	int err;
+
+	/* first, read the current user defined CAN channel ID */
+	err = dev->adapter->dev_get_can_channel_id(dev, &ch_id);
+	if (err) {
+		netdev_err(netdev, "Failed to init CAN channel id (err %d)\n", err);
+		return err;
+	}
+
+	/* do update the value with user given bytes.
+	 * ethtool operates on individual bytes. The byte order of the CAN
+	 * channel ID in memory depends on the kernel architecture. We
+	 * convert the CAN channel ID back to the native byte order of the PEAK
+	 * device itself to ensure that the order is consistent for all
+	 * host architectures.
+	 */
+	ch_id_le = cpu_to_le32(ch_id);
+	memcpy((u8 *)&ch_id_le + eeprom->offset, data, eeprom->len);
+	ch_id = le32_to_cpu(ch_id_le);
+
+	/* flash the new value now */
+	err = dev->adapter->dev_set_can_channel_id(dev, ch_id);
+	if (err) {
+		netdev_err(netdev, "Failed to write new CAN channel id (err %d)\n",
+			   err);
+		return err;
+	}
+
+	/* update cached value with the new one */
+	dev->can_channel_id = ch_id;
+
+	return 0;
+}
+
 int pcan_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 {
 	info->so_timestamping =
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.h b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
index 1e461aef0f2a..980e315186cf 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
@@ -149,4 +149,10 @@ void peak_usb_async_complete(struct urb *urb);
 void peak_usb_restart_complete(struct peak_usb_device *dev);
 int pcan_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info);
 
+/* common 32-bit CAN channel ID ethtool management */
+int peak_usb_get_eeprom_len(struct net_device *netdev);
+int peak_usb_get_eeprom(struct net_device *netdev,
+			struct ethtool_eeprom *eeprom, u8 *data);
+int peak_usb_set_eeprom(struct net_device *netdev,
+			struct ethtool_eeprom *eeprom, u8 *data);
 #endif
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 1ea4cfdfd640..fd925ae96331 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -1124,6 +1124,9 @@ static int pcan_usb_fd_set_phys_id(struct net_device *netdev,
 static const struct ethtool_ops pcan_usb_fd_ethtool_ops = {
 	.set_phys_id = pcan_usb_fd_set_phys_id,
 	.get_ts_info = pcan_get_ts_info,
+	.get_eeprom_len	= peak_usb_get_eeprom_len,
+	.get_eeprom = peak_usb_get_eeprom,
+	.set_eeprom = peak_usb_set_eeprom,
 };
 
 /* describes the PCAN-USB FD adapter */
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index 061f04c20f96..0c805d9672bf 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -1037,6 +1037,9 @@ static int pcan_usb_pro_set_phys_id(struct net_device *netdev,
 static const struct ethtool_ops pcan_usb_pro_ethtool_ops = {
 	.set_phys_id = pcan_usb_pro_set_phys_id,
 	.get_ts_info = pcan_get_ts_info,
+	.get_eeprom_len	= peak_usb_get_eeprom_len,
+	.get_eeprom = peak_usb_get_eeprom,
+	.set_eeprom = peak_usb_set_eeprom,
 };
 
 /*
-- 
2.39.1


