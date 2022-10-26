Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD4360DD5A
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 10:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbiJZIlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 04:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbiJZIk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 04:40:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598AF4332A
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:40:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onbxX-0006sH-0G
        for netdev@vger.kernel.org; Wed, 26 Oct 2022 10:40:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D4C3E10A117
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:40:16 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B9F0C10A0CE;
        Wed, 26 Oct 2022 08:40:14 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id cf0daf03;
        Wed, 26 Oct 2022 08:40:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 17/29] can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
Date:   Wed, 26 Oct 2022 10:39:55 +0200
Message-Id: <20221026084007.1583333-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026084007.1583333-1-mkl@pengutronix.de>
References: <20221026084007.1583333-1-mkl@pengutronix.de>
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

From: Jimmy Assarsson <extja@kvaser.com>

Use the CMD_GET_CAPABILITIES_REQ command to query the device for certain
capabilities. We are only interested in LISTENONLY mode and wither the
device reports CAN error counters.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Reported-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Tested-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010185237.319219-3-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 144 +++++++++++++++++-
 1 file changed, 143 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 50f2ac8319ff..c87b13dc1048 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -74,6 +74,8 @@
 #define CMD_TX_ACKNOWLEDGE		50
 #define CMD_CAN_ERROR_EVENT		51
 #define CMD_FLUSH_QUEUE_REPLY		68
+#define CMD_GET_CAPABILITIES_REQ	95
+#define CMD_GET_CAPABILITIES_RESP	96
 
 #define CMD_LEAF_LOG_MESSAGE		106
 
@@ -83,6 +85,8 @@
 #define KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK BIT(5)
 #define KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK BIT(6)
 
+#define KVASER_USB_LEAF_SWOPTION_EXT_CAP BIT(12)
+
 /* error factors */
 #define M16C_EF_ACKE			BIT(0)
 #define M16C_EF_CRCE			BIT(1)
@@ -278,6 +282,28 @@ struct leaf_cmd_log_message {
 	u8 data[8];
 } __packed;
 
+/* Sub commands for cap_req and cap_res */
+#define KVASER_USB_LEAF_CAP_CMD_LISTEN_MODE 0x02
+#define KVASER_USB_LEAF_CAP_CMD_ERR_REPORT 0x05
+struct kvaser_cmd_cap_req {
+	__le16 padding0;
+	__le16 cap_cmd;
+	__le16 padding1;
+	__le16 channel;
+} __packed;
+
+/* Status codes for cap_res */
+#define KVASER_USB_LEAF_CAP_STAT_OK 0x00
+#define KVASER_USB_LEAF_CAP_STAT_NOT_IMPL 0x01
+#define KVASER_USB_LEAF_CAP_STAT_UNAVAIL 0x02
+struct kvaser_cmd_cap_res {
+	__le16 padding;
+	__le16 cap_cmd;
+	__le16 status;
+	__le32 mask;
+	__le32 value;
+} __packed;
+
 struct kvaser_cmd {
 	u8 len;
 	u8 id;
@@ -295,6 +321,8 @@ struct kvaser_cmd {
 			struct leaf_cmd_chip_state_event chip_state_event;
 			struct leaf_cmd_error_event error_event;
 			struct leaf_cmd_log_message log_message;
+			struct kvaser_cmd_cap_req cap_req;
+			struct kvaser_cmd_cap_res cap_res;
 		} __packed leaf;
 
 		union {
@@ -324,6 +352,7 @@ static const u8 kvaser_usb_leaf_cmd_sizes_leaf[] = {
 	[CMD_LEAF_LOG_MESSAGE]		= kvaser_fsize(u.leaf.log_message),
 	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.leaf.chip_state_event),
 	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.leaf.error_event),
+	[CMD_GET_CAPABILITIES_RESP]	= kvaser_fsize(u.leaf.cap_res),
 	/* ignored events: */
 	[CMD_FLUSH_QUEUE_REPLY]		= CMD_SIZE_ANY,
 };
@@ -606,6 +635,9 @@ static void kvaser_usb_leaf_get_software_info_leaf(struct kvaser_usb *dev,
 	dev->fw_version = le32_to_cpu(softinfo->fw_version);
 	dev->max_tx_urbs = le16_to_cpu(softinfo->max_outstanding_tx);
 
+	if (sw_options & KVASER_USB_LEAF_SWOPTION_EXT_CAP)
+		dev->card_data.capabilities |= KVASER_USB_CAP_EXT_CAP;
+
 	if (dev->driver_info->quirks & KVASER_USB_QUIRK_IGNORE_CLK_FREQ) {
 		/* Firmware expects bittiming parameters calculated for 16MHz
 		 * clock, regardless of the actual clock
@@ -693,6 +725,116 @@ static int kvaser_usb_leaf_get_card_info(struct kvaser_usb *dev)
 	return 0;
 }
 
+static int kvaser_usb_leaf_get_single_capability(struct kvaser_usb *dev,
+						 u16 cap_cmd_req, u16 *status)
+{
+	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
+	struct kvaser_cmd *cmd;
+	u32 value = 0;
+	u32 mask = 0;
+	u16 cap_cmd_res;
+	int err;
+	int i;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->id = CMD_GET_CAPABILITIES_REQ;
+	cmd->u.leaf.cap_req.cap_cmd = cpu_to_le16(cap_cmd_req);
+	cmd->len = CMD_HEADER_LEN + sizeof(struct kvaser_cmd_cap_req);
+
+	err = kvaser_usb_send_cmd(dev, cmd, cmd->len);
+	if (err)
+		goto end;
+
+	err = kvaser_usb_leaf_wait_cmd(dev, CMD_GET_CAPABILITIES_RESP, cmd);
+	if (err)
+		goto end;
+
+	*status = le16_to_cpu(cmd->u.leaf.cap_res.status);
+
+	if (*status != KVASER_USB_LEAF_CAP_STAT_OK)
+		goto end;
+
+	cap_cmd_res = le16_to_cpu(cmd->u.leaf.cap_res.cap_cmd);
+	switch (cap_cmd_res) {
+	case KVASER_USB_LEAF_CAP_CMD_LISTEN_MODE:
+	case KVASER_USB_LEAF_CAP_CMD_ERR_REPORT:
+		value = le32_to_cpu(cmd->u.leaf.cap_res.value);
+		mask = le32_to_cpu(cmd->u.leaf.cap_res.mask);
+		break;
+	default:
+		dev_warn(&dev->intf->dev, "Unknown capability command %u\n",
+			 cap_cmd_res);
+		break;
+	}
+
+	for (i = 0; i < dev->nchannels; i++) {
+		if (BIT(i) & (value & mask)) {
+			switch (cap_cmd_res) {
+			case KVASER_USB_LEAF_CAP_CMD_LISTEN_MODE:
+				card_data->ctrlmode_supported |=
+						CAN_CTRLMODE_LISTENONLY;
+				break;
+			case KVASER_USB_LEAF_CAP_CMD_ERR_REPORT:
+				card_data->capabilities |=
+						KVASER_USB_CAP_BERR_CAP;
+				break;
+			}
+		}
+	}
+
+end:
+	kfree(cmd);
+
+	return err;
+}
+
+static int kvaser_usb_leaf_get_capabilities_leaf(struct kvaser_usb *dev)
+{
+	int err;
+	u16 status;
+
+	if (!(dev->card_data.capabilities & KVASER_USB_CAP_EXT_CAP)) {
+		dev_info(&dev->intf->dev,
+			 "No extended capability support. Upgrade device firmware.\n");
+		return 0;
+	}
+
+	err = kvaser_usb_leaf_get_single_capability(dev,
+						    KVASER_USB_LEAF_CAP_CMD_LISTEN_MODE,
+						    &status);
+	if (err)
+		return err;
+	if (status)
+		dev_info(&dev->intf->dev,
+			 "KVASER_USB_LEAF_CAP_CMD_LISTEN_MODE failed %u\n",
+			 status);
+
+	err = kvaser_usb_leaf_get_single_capability(dev,
+						    KVASER_USB_LEAF_CAP_CMD_ERR_REPORT,
+						    &status);
+	if (err)
+		return err;
+	if (status)
+		dev_info(&dev->intf->dev,
+			 "KVASER_USB_LEAF_CAP_CMD_ERR_REPORT failed %u\n",
+			 status);
+
+	return 0;
+}
+
+static int kvaser_usb_leaf_get_capabilities(struct kvaser_usb *dev)
+{
+	int err = 0;
+
+	if (dev->driver_info->family == KVASER_LEAF)
+		err = kvaser_usb_leaf_get_capabilities_leaf(dev);
+
+	return err;
+}
+
 static void kvaser_usb_leaf_tx_acknowledge(const struct kvaser_usb *dev,
 					   const struct kvaser_cmd *cmd)
 {
@@ -1486,7 +1628,7 @@ const struct kvaser_usb_dev_ops kvaser_usb_leaf_dev_ops = {
 	.dev_get_software_info = kvaser_usb_leaf_get_software_info,
 	.dev_get_software_details = NULL,
 	.dev_get_card_info = kvaser_usb_leaf_get_card_info,
-	.dev_get_capabilities = NULL,
+	.dev_get_capabilities = kvaser_usb_leaf_get_capabilities,
 	.dev_set_opt_mode = kvaser_usb_leaf_set_opt_mode,
 	.dev_start_chip = kvaser_usb_leaf_start_chip,
 	.dev_stop_chip = kvaser_usb_leaf_stop_chip,
-- 
2.35.1


