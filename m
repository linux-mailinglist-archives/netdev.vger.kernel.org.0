Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1373C67C513
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbjAZHpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbjAZHpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:45:33 -0500
Received: from smtp-out-06.comm2000.it (smtp-out-06.comm2000.it [212.97.32.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7F0677A5;
        Wed, 25 Jan 2023 23:45:17 -0800 (PST)
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-06.comm2000.it (Postfix) with ESMTPSA id 730725612C9;
        Thu, 26 Jan 2023 08:45:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1674719109;
        bh=1dGlE1zXTgLSwueDjSOPuoLrwN11J9TEBJkwtVkJcDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=bcKTqbaBMVr8axqeFTypnV12jUh09CdIyp261MY4eXU57UA5cTIzZW6/yD1sjj9Ro
         Uu8FXWZiYiow+GxQLN2RMLWmJpj9eSXKI+demuUyylgx7LRH24/qYDpi7J/uW1C+kl
         JkxlqLv5GlYQPqEVS0X8RInY/RX6EkTtZWB9p0uMb4jTNhHnw1mqGIcOBAaclWEuFc
         52Hu76fcPtYB1f5sGQDvJ/zJteNYVTY7qzBPbJbTqjIDjXCormaEFiZCG4DCC20eE7
         Ib2pvfdqSrfI1xvTn1r/RsvR4rxxikh96E0wYHn8T85gA6Poe2Ev+PnSu8ppmlTXRL
         Io0ytOuIryHrw==
From:   Francesco Dolcini <francesco@dolcini.it>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH v2 4/5] Bluetooth: hci_mrvl: Add serdev support for 88W8997
Date:   Thu, 26 Jan 2023 08:43:55 +0100
Message-Id: <20230126074356.431306-5-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230126074356.431306-1-francesco@dolcini.it>
References: <20230126074356.431306-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

Add serdev support for the 88W8997 from NXP (previously Marvell). It
includes support for changing the baud rate. The command to change the
baud rate is taken from the user manual UM11483 Rev. 9 in section 7
(Bring-up of Bluetooth interfaces) from NXP.

Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
v2: no changes
---
 drivers/bluetooth/hci_mrvl.c | 88 +++++++++++++++++++++++++++++++++---
 1 file changed, 81 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/hci_mrvl.c b/drivers/bluetooth/hci_mrvl.c
index eaa9c51cacfa..90f921cb2ac8 100644
--- a/drivers/bluetooth/hci_mrvl.c
+++ b/drivers/bluetooth/hci_mrvl.c
@@ -27,10 +27,12 @@
 #define MRVL_ACK 0x5A
 #define MRVL_NAK 0xBF
 #define MRVL_RAW_DATA 0x1F
+#define MRVL_SET_BAUDRATE 0xFC09
 
 enum {
 	STATE_CHIP_VER_PENDING,
 	STATE_FW_REQ_PENDING,
+	STATE_FW_LOADED,
 };
 
 struct mrvl_data {
@@ -254,6 +256,14 @@ static int mrvl_recv(struct hci_uart *hu, const void *data, int count)
 	if (!test_bit(HCI_UART_REGISTERED, &hu->flags))
 		return -EUNATCH;
 
+	/* We might receive some noise when there is no firmware loaded. Therefore,
+	 * we drop data if the firmware is not loaded yet and if there is no fw load
+	 * request pending.
+	 */
+	if (!test_bit(STATE_FW_REQ_PENDING, &mrvl->flags) &&
+				!test_bit(STATE_FW_LOADED, &mrvl->flags))
+		return count;
+
 	mrvl->rx_skb = h4_recv_buf(hu->hdev, mrvl->rx_skb, data, count,
 				    mrvl_recv_pkts,
 				    ARRAY_SIZE(mrvl_recv_pkts));
@@ -354,6 +364,7 @@ static int mrvl_load_firmware(struct hci_dev *hdev, const char *name)
 static int mrvl_setup(struct hci_uart *hu)
 {
 	int err;
+	struct mrvl_data *mrvl = hu->priv;
 
 	hci_uart_set_flow_control(hu, true);
 
@@ -367,9 +378,9 @@ static int mrvl_setup(struct hci_uart *hu)
 	hci_uart_wait_until_sent(hu);
 
 	if (hu->serdev)
-		serdev_device_set_baudrate(hu->serdev, 3000000);
+		serdev_device_set_baudrate(hu->serdev, hu->oper_speed);
 	else
-		hci_uart_set_baudrate(hu, 3000000);
+		hci_uart_set_baudrate(hu, hu->oper_speed);
 
 	hci_uart_set_flow_control(hu, false);
 
@@ -377,13 +388,56 @@ static int mrvl_setup(struct hci_uart *hu)
 	if (err)
 		return err;
 
+	set_bit(STATE_FW_LOADED, &mrvl->flags);
+
+	return 0;
+}
+
+static int mrvl_set_baudrate(struct hci_uart *hu, unsigned int speed)
+{
+	int err;
+	struct sk_buff *skb;
+	struct mrvl_data *mrvl = hu->priv;
+	__le32 speed_le = cpu_to_le32(speed);
+
+	/* The firmware might be loaded by the Wifi driver over SDIO. We wait
+	 * up to 10s for the CTS to go up. Afterward, we know that the firmware
+	 * is ready.
+	 */
+	err = serdev_device_wait_for_cts(hu->serdev, true, 10000);
+	if (err) {
+		bt_dev_err(hu->hdev, "Wait for CTS failed with %d\n", err);
+		return err;
+	}
+
+	set_bit(STATE_FW_LOADED, &mrvl->flags);
+
+	skb = __hci_cmd_sync(hu->hdev, MRVL_SET_BAUDRATE,
+			     sizeof(speed_le), &speed_le,
+			     HCI_INIT_TIMEOUT);
+	if (IS_ERR(skb)) {
+		bt_dev_err(hu->hdev, "send command failed: %ld", PTR_ERR(skb));
+		return PTR_ERR(skb);
+	}
+	kfree_skb(skb);
+
+	serdev_device_set_baudrate(hu->serdev, speed);
+
+	/* We forcefully have to send a command to the bluetooth module so that
+	 * the driver detects it after a baudrate change. This is foreseen by
+	 * hci_serdev by setting HCI_UART_VND_DETECT which then causes a dummy
+	 * local version read.
+	 */
+	set_bit(HCI_UART_VND_DETECT, &hu->hdev_flags);
+
 	return 0;
 }
 
-static const struct hci_uart_proto mrvl_proto = {
+static const struct hci_uart_proto mrvl_proto_8897 = {
 	.id		= HCI_UART_MRVL,
 	.name		= "Marvell",
 	.init_speed	= 115200,
+	.oper_speed	= 3000000,
 	.open		= mrvl_open,
 	.close		= mrvl_close,
 	.flush		= mrvl_flush,
@@ -393,18 +447,37 @@ static const struct hci_uart_proto mrvl_proto = {
 	.dequeue	= mrvl_dequeue,
 };
 
+static const struct hci_uart_proto mrvl_proto_8997 = {
+	.id		= HCI_UART_MRVL,
+	.name		= "Marvell 8997",
+	.init_speed	= 115200,
+	.oper_speed	= 3000000,
+	.open		= mrvl_open,
+	.close		= mrvl_close,
+	.flush		= mrvl_flush,
+	.set_baudrate   = mrvl_set_baudrate,
+	.recv		= mrvl_recv,
+	.enqueue	= mrvl_enqueue,
+	.dequeue	= mrvl_dequeue,
+};
+
 static int mrvl_serdev_probe(struct serdev_device *serdev)
 {
 	struct mrvl_serdev *mrvldev;
+	const struct hci_uart_proto *mrvl_proto = device_get_match_data(&serdev->dev);
 
 	mrvldev = devm_kzalloc(&serdev->dev, sizeof(*mrvldev), GFP_KERNEL);
 	if (!mrvldev)
 		return -ENOMEM;
 
+	mrvldev->hu.oper_speed = mrvl_proto->oper_speed;
+	if (mrvl_proto->set_baudrate)
+		of_property_read_u32(serdev->dev.of_node, "max-speed", &mrvldev->hu.oper_speed);
+
 	mrvldev->hu.serdev = serdev;
 	serdev_device_set_drvdata(serdev, mrvldev);
 
-	return hci_uart_register_device(&mrvldev->hu, &mrvl_proto);
+	return hci_uart_register_device(&mrvldev->hu, mrvl_proto);
 }
 
 static void mrvl_serdev_remove(struct serdev_device *serdev)
@@ -415,7 +488,8 @@ static void mrvl_serdev_remove(struct serdev_device *serdev)
 }
 
 static const struct of_device_id __maybe_unused mrvl_bluetooth_of_match[] = {
-	{ .compatible = "mrvl,88w8897" },
+	{ .compatible = "mrvl,88w8897", .data = &mrvl_proto_8897},
+	{ .compatible = "mrvl,88w8997", .data = &mrvl_proto_8997},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, mrvl_bluetooth_of_match);
@@ -433,12 +507,12 @@ int __init mrvl_init(void)
 {
 	serdev_device_driver_register(&mrvl_serdev_driver);
 
-	return hci_uart_register_proto(&mrvl_proto);
+	return hci_uart_register_proto(&mrvl_proto_8897);
 }
 
 int __exit mrvl_deinit(void)
 {
 	serdev_device_driver_unregister(&mrvl_serdev_driver);
 
-	return hci_uart_unregister_proto(&mrvl_proto);
+	return hci_uart_unregister_proto(&mrvl_proto_8897);
 }
-- 
2.25.1

