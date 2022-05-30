Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0BA538542
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242350AbiE3Pr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242624AbiE3PrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:47:22 -0400
Received: from smtp2.infineon.com (smtp2.infineon.com [IPv6:2a00:18f0:1e00:4::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A60985B6;
        Mon, 30 May 2022 08:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1653922978; x=1685458978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sF24iHjs3QmS/Bu9PDMsfCXuaOpFZWepSWRnrVNqdVU=;
  b=Rk2jGYsexIVJvwVoakfqzMoGgX+MOiFkvir3k6xBbMjuP4ToRNLaGs12
   bv+JtsayDzB05jMYqUAbM2G3t8OAj0Cak00ITEFdlLmiTuSHiBNThHhjr
   9C/Dbr/1xQw5wyvqj9bjYRU4EMgoB3a5rJbNBZZlA4Z7BQbfCW+DIVg6y
   s=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="181563708"
X-IronPort-AV: E=Sophos;i="5.91,263,1647298800"; 
   d="scan'208";a="181563708"
Received: from unknown (HELO mucxv002.muc.infineon.com) ([172.23.11.17])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 17:02:55 +0200
Received: from MUCSE819.infineon.com (MUCSE819.infineon.com [172.23.29.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv002.muc.infineon.com (Postfix) with ESMTPS;
        Mon, 30 May 2022 17:02:55 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE819.infineon.com
 (172.23.29.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 30 May
 2022 17:02:54 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 30 May 2022 17:02:54 +0200
From:   Hakan Jansson <hakan.jansson@infineon.com>
CC:     Hakan Jansson <hakan.jansson@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
Subject: [PATCH v3 2/2] Bluetooth: hci_bcm: Add support for FW loading in autobaud mode
Date:   Mon, 30 May 2022 17:02:18 +0200
Message-ID: <5c401dcc64c962d9e3bb848b760b60b264005ca9.1653916330.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1653916330.git.hakan.jansson@infineon.com>
References: <cover.1653916330.git.hakan.jansson@infineon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE808.infineon.com (172.23.29.34) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the presence of a DT property, "brcm,requires-autobaud-mode", to enable
startup in autobaud mode. If the property is present, the device is started
in autobaud mode by asserting RTS (BT_UART_CTS_N) prior to powering on the
device.

Also prevent the use of unsupported commands for devices started in
autobaud mode. Only a limited subset of HCI commands are supported in
autobaud mode.

Some devices (e.g. CYW5557x) require autobaud mode to enable FW loading.
Autobaud mode can also be required on some boards where the controller
device is using a non-standard baud rate in normal mode when first powered
on.

Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
---
V2 -> V3:
  - Rename DT property to "brcm,requires-autobaud-mode"
    https://lore.kernel.org/linux-devicetree/e6e83743-1441-dc53-fd1f-cdfb9a24932a@linaro.org/

V1 -> V2:
  - No changes, submitted as part of updated patch series

 drivers/bluetooth/btbcm.c   | 31 +++++++++++++++++++++++--------
 drivers/bluetooth/btbcm.h   |  8 ++++----
 drivers/bluetooth/hci_bcm.c | 16 +++++++++++++---
 3 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 76fbb046bdbe..cfe018a6c1fc 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -403,6 +403,13 @@ static int btbcm_read_info(struct hci_dev *hdev)
 	bt_dev_info(hdev, "BCM: chip id %u", skb->data[1]);
 	kfree_skb(skb);
 
+	return 0;
+}
+
+static int btbcm_print_controller_features(struct hci_dev *hdev)
+{
+	struct sk_buff *skb;
+
 	/* Read Controller Features */
 	skb = btbcm_read_controller_features(hdev);
 	if (IS_ERR(skb))
@@ -514,7 +521,7 @@ static const char *btbcm_get_board_name(struct device *dev)
 #endif
 }
 
-int btbcm_initialize(struct hci_dev *hdev, bool *fw_load_done)
+int btbcm_initialize(struct hci_dev *hdev, bool *fw_load_done, bool use_autobaud_mode)
 {
 	u16 subver, rev, pid, vid;
 	struct sk_buff *skb;
@@ -551,9 +558,16 @@ int btbcm_initialize(struct hci_dev *hdev, bool *fw_load_done)
 		if (err)
 			return err;
 	}
-	err = btbcm_print_local_name(hdev);
-	if (err)
-		return err;
+
+	if (!use_autobaud_mode) {
+		err = btbcm_print_controller_features(hdev);
+		if (err)
+			return err;
+
+		err = btbcm_print_local_name(hdev);
+		if (err)
+			return err;
+	}
 
 	bcm_subver_table = (hdev->bus == HCI_USB) ? bcm_usb_subver_table :
 						    bcm_uart_subver_table;
@@ -636,13 +650,13 @@ int btbcm_initialize(struct hci_dev *hdev, bool *fw_load_done)
 }
 EXPORT_SYMBOL_GPL(btbcm_initialize);
 
-int btbcm_finalize(struct hci_dev *hdev, bool *fw_load_done)
+int btbcm_finalize(struct hci_dev *hdev, bool *fw_load_done, bool use_autobaud_mode)
 {
 	int err;
 
 	/* Re-initialize if necessary */
 	if (*fw_load_done) {
-		err = btbcm_initialize(hdev, fw_load_done);
+		err = btbcm_initialize(hdev, fw_load_done, use_autobaud_mode);
 		if (err)
 			return err;
 	}
@@ -658,15 +672,16 @@ EXPORT_SYMBOL_GPL(btbcm_finalize);
 int btbcm_setup_patchram(struct hci_dev *hdev)
 {
 	bool fw_load_done = false;
+	bool use_autobaud_mode = false;
 	int err;
 
 	/* Initialize */
-	err = btbcm_initialize(hdev, &fw_load_done);
+	err = btbcm_initialize(hdev, &fw_load_done, use_autobaud_mode);
 	if (err)
 		return err;
 
 	/* Re-initialize after loading Patch */
-	return btbcm_finalize(hdev, &fw_load_done);
+	return btbcm_finalize(hdev, &fw_load_done, use_autobaud_mode);
 }
 EXPORT_SYMBOL_GPL(btbcm_setup_patchram);
 
diff --git a/drivers/bluetooth/btbcm.h b/drivers/bluetooth/btbcm.h
index 8bf01565fdfc..b4cb24231a20 100644
--- a/drivers/bluetooth/btbcm.h
+++ b/drivers/bluetooth/btbcm.h
@@ -62,8 +62,8 @@ int btbcm_write_pcm_int_params(struct hci_dev *hdev,
 int btbcm_setup_patchram(struct hci_dev *hdev);
 int btbcm_setup_apple(struct hci_dev *hdev);
 
-int btbcm_initialize(struct hci_dev *hdev, bool *fw_load_done);
-int btbcm_finalize(struct hci_dev *hdev, bool *fw_load_done);
+int btbcm_initialize(struct hci_dev *hdev, bool *fw_load_done, bool use_autobaud_mode);
+int btbcm_finalize(struct hci_dev *hdev, bool *fw_load_done, bool use_autobaud_mode);
 
 #else
 
@@ -104,12 +104,12 @@ static inline int btbcm_setup_apple(struct hci_dev *hdev)
 	return 0;
 }
 
-static inline int btbcm_initialize(struct hci_dev *hdev, bool *fw_load_done)
+static inline int btbcm_initialize(struct hci_dev *hdev, bool *fw_load_done, bool use_autobaud_mode)
 {
 	return 0;
 }
 
-static inline int btbcm_finalize(struct hci_dev *hdev, bool *fw_load_done)
+static inline int btbcm_finalize(struct hci_dev *hdev, bool *fw_load_done, bool use_autobaud_mode)
 {
 	return 0;
 }
diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index 785f445dd60d..4309654f95a5 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -99,6 +99,7 @@ struct bcm_device_data {
  * @no_early_set_baudrate: don't set_baudrate before setup()
  * @drive_rts_on_open: drive RTS signal on ->open() when platform requires it
  * @pcm_int_params: keep the initial PCM configuration
+ * @use_autobaud_mode: start Bluetooth device in autobaud mode
  */
 struct bcm_device {
 	/* Must be the first member, hci_serdev.c expects this. */
@@ -136,6 +137,7 @@ struct bcm_device {
 #endif
 	bool			no_early_set_baudrate;
 	bool			drive_rts_on_open;
+	bool			use_autobaud_mode;
 	u8			pcm_int_params[5];
 };
 
@@ -472,7 +474,9 @@ static int bcm_open(struct hci_uart *hu)
 
 out:
 	if (bcm->dev) {
-		if (bcm->dev->drive_rts_on_open)
+		if (bcm->dev->use_autobaud_mode)
+			hci_uart_set_flow_control(hu, false);	/* Assert BT_UART_CTS_N */
+		else if (bcm->dev->drive_rts_on_open)
 			hci_uart_set_flow_control(hu, true);
 
 		hu->init_speed = bcm->dev->init_speed;
@@ -564,6 +568,7 @@ static int bcm_setup(struct hci_uart *hu)
 {
 	struct bcm_data *bcm = hu->priv;
 	bool fw_load_done = false;
+	bool use_autobaud_mode = (bcm->dev ? bcm->dev->use_autobaud_mode : 0);
 	unsigned int speed;
 	int err;
 
@@ -572,7 +577,7 @@ static int bcm_setup(struct hci_uart *hu)
 	hu->hdev->set_diag = bcm_set_diag;
 	hu->hdev->set_bdaddr = btbcm_set_bdaddr;
 
-	err = btbcm_initialize(hu->hdev, &fw_load_done);
+	err = btbcm_initialize(hu->hdev, &fw_load_done, use_autobaud_mode);
 	if (err)
 		return err;
 
@@ -616,7 +621,7 @@ static int bcm_setup(struct hci_uart *hu)
 		btbcm_write_pcm_int_params(hu->hdev, &params);
 	}
 
-	err = btbcm_finalize(hu->hdev, &fw_load_done);
+	err = btbcm_finalize(hu->hdev, &fw_load_done, use_autobaud_mode);
 	if (err)
 		return err;
 
@@ -1197,6 +1202,11 @@ static int bcm_acpi_probe(struct bcm_device *dev)
 
 static int bcm_of_probe(struct bcm_device *bdev)
 {
+	bdev->use_autobaud_mode = device_property_read_bool(bdev->dev,
+							    "brcm,requires-autobaud-mode");
+	if (bdev->use_autobaud_mode)
+		bdev->no_early_set_baudrate = true;
+
 	device_property_read_u32(bdev->dev, "max-speed", &bdev->oper_speed);
 	device_property_read_u8_array(bdev->dev, "brcm,bt-pcm-int-params",
 				      bdev->pcm_int_params, 5);
-- 
2.25.1

