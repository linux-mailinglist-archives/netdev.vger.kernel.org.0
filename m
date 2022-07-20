Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB5F57B283
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbiGTIM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240449AbiGTIMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:12:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397BA6B773
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:11:41 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE4nz-0000o9-Al
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:11:39 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id ED77CB5986
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:10:42 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0FEC5B5946;
        Wed, 20 Jul 2022 08:10:42 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5606939a;
        Wed, 20 Jul 2022 08:10:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 17/29] can: peak_usb: include support for a new MCU
Date:   Wed, 20 Jul 2022 10:10:22 +0200
Message-Id: <20220720081034.3277385-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720081034.3277385-1-mkl@pengutronix.de>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
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

The CANFD-USB PCAN-USB FD interface undergoes an internal component
change that requires a slight modification of its drivers, which leads
them to dynamically use endpoint numbers provided by the interface
itself. In addition to a change in the calls to the USB functions
exported by the kernel, the detection of the USB interface dedicated
to CAN must also be modified, as some PEAK-System devices support
other interfaces than CAN.

Link: https://lore.kernel.org/all/20220719120632.26774-3-s.grosjean@peak-system.com
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
[mkl: add missing cpu_to_le16() conversion]
[mkl: fix networking block comment style]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 68 ++++++++++++++++++----
 1 file changed, 58 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 65487ec33566..3d7e0e370505 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -33,6 +33,10 @@
 #define PCAN_UFD_RX_BUFFER_SIZE		2048
 #define PCAN_UFD_TX_BUFFER_SIZE		512
 
+/* struct pcan_ufd_fw_info::type */
+#define PCAN_USBFD_TYPE_STD		1
+#define PCAN_USBFD_TYPE_EXT		2	/* includes EP numbers */
+
 /* read some versions info from the hw device */
 struct __packed pcan_ufd_fw_info {
 	__le16	size_of;	/* sizeof this */
@@ -44,6 +48,13 @@ struct __packed pcan_ufd_fw_info {
 	__le32	dev_id[2];	/* "device id" per CAN */
 	__le32	ser_no;		/* S/N */
 	__le32	flags;		/* special functions */
+
+	/* extended data when type == PCAN_USBFD_TYPE_EXT */
+	u8	cmd_out_ep;	/* ep for cmd */
+	u8	cmd_in_ep;	/* ep for replies */
+	u8	data_out_ep[2];	/* ep for CANx TX */
+	u8	data_in_ep;	/* ep for CAN RX */
+	u8	dummy[3];
 };
 
 /* handle device specific info used by the netdevices */
@@ -171,6 +182,9 @@ static inline void *pcan_usb_fd_cmd_buffer(struct peak_usb_device *dev)
 /* send PCAN-USB Pro FD commands synchronously */
 static int pcan_usb_fd_send_cmd(struct peak_usb_device *dev, void *cmd_tail)
 {
+	struct pcan_usb_fd_device *pdev =
+		container_of(dev, struct pcan_usb_fd_device, dev);
+	struct pcan_ufd_fw_info *fw_info = &pdev->usb_if->fw_info;
 	void *cmd_head = pcan_usb_fd_cmd_buffer(dev);
 	int err = 0;
 	u8 *packet_ptr;
@@ -200,7 +214,7 @@ static int pcan_usb_fd_send_cmd(struct peak_usb_device *dev, void *cmd_tail)
 	do {
 		err = usb_bulk_msg(dev->udev,
 				   usb_sndbulkpipe(dev->udev,
-						   PCAN_USBPRO_EP_CMDOUT),
+						   fw_info->cmd_out_ep),
 				   packet_ptr, packet_len,
 				   NULL, PCAN_UFD_CMD_TIMEOUT_MS);
 		if (err) {
@@ -426,6 +440,9 @@ static int pcan_usb_fd_set_bittiming_fast(struct peak_usb_device *dev,
 static int pcan_usb_fd_restart_async(struct peak_usb_device *dev,
 				     struct urb *urb, u8 *buf)
 {
+	struct pcan_usb_fd_device *pdev =
+		container_of(dev, struct pcan_usb_fd_device, dev);
+	struct pcan_ufd_fw_info *fw_info = &pdev->usb_if->fw_info;
 	u8 *pc = buf;
 
 	/* build the entire cmds list in the provided buffer, to go back into
@@ -439,7 +456,7 @@ static int pcan_usb_fd_restart_async(struct peak_usb_device *dev,
 
 	/* complete the URB */
 	usb_fill_bulk_urb(urb, dev->udev,
-			  usb_sndbulkpipe(dev->udev, PCAN_USBPRO_EP_CMDOUT),
+			  usb_sndbulkpipe(dev->udev, fw_info->cmd_out_ep),
 			  buf, pc - buf,
 			  pcan_usb_pro_restart_complete, dev);
 
@@ -839,6 +856,15 @@ static int pcan_usb_fd_get_berr_counter(const struct net_device *netdev,
 	return 0;
 }
 
+/* probe function for all PCAN-USB FD family usb interfaces */
+static int pcan_usb_fd_probe(struct usb_interface *intf)
+{
+	struct usb_host_interface *iface_desc = &intf->altsetting[0];
+
+	/* CAN interface is always interface #0 */
+	return iface_desc->desc.bInterfaceNumber;
+}
+
 /* stop interface (last chance before set bus off) */
 static int pcan_usb_fd_stop(struct peak_usb_device *dev)
 {
@@ -860,6 +886,7 @@ static int pcan_usb_fd_init(struct peak_usb_device *dev)
 {
 	struct pcan_usb_fd_device *pdev =
 			container_of(dev, struct pcan_usb_fd_device, dev);
+	struct pcan_ufd_fw_info *fw_info;
 	int i, err = -ENOMEM;
 
 	/* do this for 1st channel only */
@@ -878,10 +905,12 @@ static int pcan_usb_fd_init(struct peak_usb_device *dev)
 		/* number of ts msgs to ignore before taking one into account */
 		pdev->usb_if->cm_ignore_count = 5;
 
+		fw_info = &pdev->usb_if->fw_info;
+
 		err = pcan_usb_pro_send_req(dev, PCAN_USBPRO_REQ_INFO,
 					    PCAN_USBPRO_INFO_FW,
-					    &pdev->usb_if->fw_info,
-					    sizeof(pdev->usb_if->fw_info));
+					    fw_info,
+					    sizeof(*fw_info));
 		if (err) {
 			dev_err(dev->netdev->dev.parent,
 				"unable to read %s firmware info (err %d)\n",
@@ -895,14 +924,14 @@ static int pcan_usb_fd_init(struct peak_usb_device *dev)
 		 */
 		dev_info(dev->netdev->dev.parent,
 			 "PEAK-System %s v%u fw v%u.%u.%u (%u channels)\n",
-			 dev->adapter->name, pdev->usb_if->fw_info.hw_version,
-			 pdev->usb_if->fw_info.fw_version[0],
-			 pdev->usb_if->fw_info.fw_version[1],
-			 pdev->usb_if->fw_info.fw_version[2],
+			 dev->adapter->name, fw_info->hw_version,
+			 fw_info->fw_version[0],
+			 fw_info->fw_version[1],
+			 fw_info->fw_version[2],
 			 dev->adapter->ctrl_count);
 
 		/* check for ability to switch between ISO/non-ISO modes */
-		if (pdev->usb_if->fw_info.fw_version[0] >= 2) {
+		if (fw_info->fw_version[0] >= 2) {
 			/* firmware >= 2.x supports ISO/non-ISO switching */
 			dev->can.ctrlmode_supported |= CAN_CTRLMODE_FD_NON_ISO;
 		} else {
@@ -910,6 +939,14 @@ static int pcan_usb_fd_init(struct peak_usb_device *dev)
 			dev->can.ctrlmode |= CAN_CTRLMODE_FD_NON_ISO;
 		}
 
+		/* if vendor rsp is of type 2, then it contains EP numbers to
+		 * use for cmds pipes. If not, then default EP should be used.
+		 */
+		if (fw_info->type != cpu_to_le16(PCAN_USBFD_TYPE_EXT)) {
+			fw_info->cmd_out_ep = PCAN_USBPRO_EP_CMDOUT;
+			fw_info->cmd_in_ep = PCAN_USBPRO_EP_CMDIN;
+		}
+
 		/* tell the hardware the can driver is running */
 		err = pcan_usb_fd_drv_loaded(dev, 1);
 		if (err) {
@@ -930,12 +967,23 @@ static int pcan_usb_fd_init(struct peak_usb_device *dev)
 		/* do a copy of the ctrlmode[_supported] too */
 		dev->can.ctrlmode = ppdev->dev.can.ctrlmode;
 		dev->can.ctrlmode_supported = ppdev->dev.can.ctrlmode_supported;
+
+		fw_info = &pdev->usb_if->fw_info;
 	}
 
 	pdev->usb_if->dev[dev->ctrl_idx] = dev;
 	dev->device_number =
 		le32_to_cpu(pdev->usb_if->fw_info.dev_id[dev->ctrl_idx]);
 
+	/* if vendor rsp is of type 2, then it contains EP numbers to
+	 * use for data pipes. If not, then statically defined EP are used
+	 * (see peak_usb_create_dev()).
+	 */
+	if (fw_info->type == cpu_to_le16(PCAN_USBFD_TYPE_EXT)) {
+		dev->ep_msg_in = fw_info->data_in_ep;
+		dev->ep_msg_out = fw_info->data_out_ep[dev->ctrl_idx];
+	}
+
 	/* set clock domain */
 	for (i = 0; i < ARRAY_SIZE(pcan_usb_fd_clk_freq); i++)
 		if (dev->adapter->clock.freq == pcan_usb_fd_clk_freq[i])
@@ -1091,7 +1139,7 @@ const struct peak_usb_adapter pcan_usb_fd = {
 	.tx_buffer_size = PCAN_UFD_TX_BUFFER_SIZE,
 
 	/* device callbacks */
-	.intf_probe = pcan_usb_pro_probe,	/* same as PCAN-USB Pro */
+	.intf_probe = pcan_usb_fd_probe,
 	.dev_init = pcan_usb_fd_init,
 
 	.dev_exit = pcan_usb_fd_exit,
-- 
2.35.1


