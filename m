Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F7D613A82
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbiJaPoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiJaPoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:44:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAB011A38
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:44:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1opWxS-0002sr-Ch
        for netdev@vger.kernel.org; Mon, 31 Oct 2022 16:44:14 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5AFA210F470
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:44:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5681110F411;
        Mon, 31 Oct 2022 15:44:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f83c69dc;
        Mon, 31 Oct 2022 15:44:07 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 05/14] can: peak_usb: add ethtool interface to user defined flashed device number
Date:   Mon, 31 Oct 2022 16:43:57 +0100
Message-Id: <20221031154406.259857-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221031154406.259857-1-mkl@pengutronix.de>
References: <20221031154406.259857-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
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

From: Stephane Grosjean <s.grosjean@peak-system.com>

This patch introduces 3 new functions implementing support for eeprom
access of USB - CAN network interfaces managed by the driver, through the
ethtool interface. All of them (except the PCAN-USB interface) interpret
the 4 data bytes as a 32-bit value to be read/write in the non-volatile
memory of the device. The PCAN-USB only manages a single byte value.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Lukas Magel <lukas.magel@posteo.net>
Link: https://lore.kernel.org/all/20221030105939.87658-6-lukas.magel@posteo.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c      |  9 +++
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 80 ++++++++++++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb_core.h |  6 ++
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   |  3 +
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c  |  3 +
 5 files changed, 101 insertions(+)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 6c01b2c6212b..d205da827016 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -984,9 +984,18 @@ static int pcan_usb_set_phys_id(struct net_device *netdev,
 	return err;
 }
 
+/* This device only handles 8-bit user device id. */
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
index b010b546f6d1..d8af448058fa 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -808,6 +808,86 @@ static const struct net_device_ops peak_usb_netdev_ops = {
 	.ndo_change_mtu = can_change_mtu,
 };
 
+/* CAN-USB devices generally handle 32-bit user device id.
+ * In case one doesn't, then it have to overload this function.
+ */
+int peak_usb_get_eeprom_len(struct net_device *netdev)
+{
+	return sizeof(u32);
+}
+
+/* Every CAN-USB device exports the dev_get_user_devid() operation. It is used
+ * here to fill the data buffer with the user defined device number.
+ */
+int peak_usb_get_eeprom(struct net_device *netdev,
+			struct ethtool_eeprom *eeprom, u8 *data)
+{
+	struct peak_usb_device *dev = netdev_priv(netdev);
+	u32 devid;
+	__le32 devid_le;
+	int err;
+
+	err = dev->adapter->dev_get_user_devid(dev, &devid);
+	if (err)
+		return err;
+
+	/* ethtool operates on individual bytes. The byte order of the user
+	 * device id in memory depends on the kernel architecture. We
+	 * convert the user device id back to the native byte order of the PEAK
+	 * device itself to ensure that the order is consistent for all
+	 * host architectures.
+	 */
+	devid_le = cpu_to_le32(devid);
+	memcpy(data, (u8 *)&devid_le + eeprom->offset, eeprom->len);
+
+	/* update cached value */
+	dev->user_devid = devid;
+	return err;
+}
+
+/* Every CAN-USB device exports the dev_get_user_devid()/dev_set_user_devid()
+ * operations. They are used here to set the new user defined device number.
+ */
+int peak_usb_set_eeprom(struct net_device *netdev,
+			struct ethtool_eeprom *eeprom, u8 *data)
+{
+	struct peak_usb_device *dev = netdev_priv(netdev);
+	u32 devid;
+	__le32 devid_le;
+	int err;
+
+	/* first, read the current user defined device value number */
+	err = dev->adapter->dev_get_user_devid(dev, &devid);
+	if (err) {
+		netdev_err(netdev, "Failed to init device id (err %d)\n", err);
+		return err;
+	}
+
+	/* do update the value with user given bytes.
+	 * ethtool operates on individual bytes. The byte order of the user
+	 * device id in memory depends on the kernel architecture. We
+	 * convert the user device id back to the native byte order of the PEAK
+	 * device itself to ensure that the order is consistent for all
+	 * host architectures.
+	 */
+	devid_le = cpu_to_le32(devid);
+	memcpy((u8 *)&devid_le + eeprom->offset, data, eeprom->len);
+	devid = le32_to_cpu(devid_le);
+
+	/* flash the new value now */
+	err = dev->adapter->dev_set_user_devid(dev, devid);
+	if (err) {
+		netdev_err(netdev, "Failed to write new device id (err %d)\n",
+			   err);
+		return err;
+	}
+
+	/* update cached value with the new one */
+	dev->user_devid = devid;
+
+	return 0;
+}
+
 int pcan_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 {
 	info->so_timestamping =
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.h b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
index d9c9e333c47a..a4a43edc0456 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
@@ -148,4 +148,10 @@ void peak_usb_async_complete(struct urb *urb);
 void peak_usb_restart_complete(struct peak_usb_device *dev);
 int pcan_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info);
 
+/* common 32-bit devid ethtool management */
+int peak_usb_get_eeprom_len(struct net_device *netdev);
+int peak_usb_get_eeprom(struct net_device *netdev,
+			struct ethtool_eeprom *eeprom, u8 *data);
+int peak_usb_set_eeprom(struct net_device *netdev,
+			struct ethtool_eeprom *eeprom, u8 *data);
 #endif
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 1f5ad0dc2b1c..5188915c4299 100644
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
index d3731c5aa4ed..d45e6562a4bb 100644
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
2.35.1


