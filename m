Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034292C627A
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgK0KEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgK0KEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:04:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F3AC0617A7
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 02:04:03 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kiabi-0007fq-0i
        for netdev@vger.kernel.org; Fri, 27 Nov 2020 11:04:02 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7C6BF59DE9A
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 10:03:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id ED8D559DE68;
        Fri, 27 Nov 2020 10:03:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c90e9565;
        Fri, 27 Nov 2020 10:03:53 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Maximilian Schneider <max@schneidersoft.net>,
        Hubert Denkmair <hubert@denkmair.de>,
        Michael Rausch <mr@netadair.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [net 1/6] can: gs_usb: fix endianess problem with candleLight firmware
Date:   Fri, 27 Nov 2020 11:02:56 +0100
Message-Id: <20201127100301.512603-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127100301.512603-1-mkl@pengutronix.de>
References: <20201127100301.512603-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The firmware on the original USB2CAN by Geschwister Schneider Technologie
Entwicklungs- und Vertriebs UG exchanges all data between the host and the
device in host byte order. This is done with the struct
gs_host_config::byte_order member, which is sent first to indicate the desired
byte order.

The widely used open source firmware candleLight doesn't support this feature
and exchanges the data in little endian byte order. This breaks if a device
with candleLight firmware is used on big endianess systems.

To fix this problem, all u32 (but not the struct gs_host_frame::echo_id, which
is a transparent cookie) are converted to __le32.

Cc: Maximilian Schneider <max@schneidersoft.net>
Cc: Hubert Denkmair <hubert@denkmair.de>
Reported-by: Michael Rausch <mr@netadair.de>
Link: https://lore.kernel.org/r/b58aace7-61f3-6df7-c6df-69fee2c66906@netadair.de
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://lore.kernel.org/r/20201120103818.3386964-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 131 +++++++++++++++++++----------------
 1 file changed, 70 insertions(+), 61 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 3005157059ca..018ca3b057a3 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -63,21 +63,27 @@ enum gs_can_identify_mode {
 };
 
 /* data types passed between host and device */
+
+/* The firmware on the original USB2CAN by Geschwister Schneider
+ * Technologie Entwicklungs- und Vertriebs UG exchanges all data
+ * between the host and the device in host byte order. This is done
+ * with the struct gs_host_config::byte_order member, which is sent
+ * first to indicate the desired byte order.
+ *
+ * The widely used open source firmware candleLight doesn't support
+ * this feature and exchanges the data in little endian byte order.
+ */
 struct gs_host_config {
-	u32 byte_order;
+	__le32 byte_order;
 } __packed;
-/* All data exchanged between host and device is exchanged in host byte order,
- * thanks to the struct gs_host_config byte_order member, which is sent first
- * to indicate the desired byte order.
- */
 
 struct gs_device_config {
 	u8 reserved1;
 	u8 reserved2;
 	u8 reserved3;
 	u8 icount;
-	u32 sw_version;
-	u32 hw_version;
+	__le32 sw_version;
+	__le32 hw_version;
 } __packed;
 
 #define GS_CAN_MODE_NORMAL               0
@@ -87,26 +93,26 @@ struct gs_device_config {
 #define GS_CAN_MODE_ONE_SHOT             BIT(3)
 
 struct gs_device_mode {
-	u32 mode;
-	u32 flags;
+	__le32 mode;
+	__le32 flags;
 } __packed;
 
 struct gs_device_state {
-	u32 state;
-	u32 rxerr;
-	u32 txerr;
+	__le32 state;
+	__le32 rxerr;
+	__le32 txerr;
 } __packed;
 
 struct gs_device_bittiming {
-	u32 prop_seg;
-	u32 phase_seg1;
-	u32 phase_seg2;
-	u32 sjw;
-	u32 brp;
+	__le32 prop_seg;
+	__le32 phase_seg1;
+	__le32 phase_seg2;
+	__le32 sjw;
+	__le32 brp;
 } __packed;
 
 struct gs_identify_mode {
-	u32 mode;
+	__le32 mode;
 } __packed;
 
 #define GS_CAN_FEATURE_LISTEN_ONLY      BIT(0)
@@ -117,23 +123,23 @@ struct gs_identify_mode {
 #define GS_CAN_FEATURE_IDENTIFY         BIT(5)
 
 struct gs_device_bt_const {
-	u32 feature;
-	u32 fclk_can;
-	u32 tseg1_min;
-	u32 tseg1_max;
-	u32 tseg2_min;
-	u32 tseg2_max;
-	u32 sjw_max;
-	u32 brp_min;
-	u32 brp_max;
-	u32 brp_inc;
+	__le32 feature;
+	__le32 fclk_can;
+	__le32 tseg1_min;
+	__le32 tseg1_max;
+	__le32 tseg2_min;
+	__le32 tseg2_max;
+	__le32 sjw_max;
+	__le32 brp_min;
+	__le32 brp_max;
+	__le32 brp_inc;
 } __packed;
 
 #define GS_CAN_FLAG_OVERFLOW 1
 
 struct gs_host_frame {
 	u32 echo_id;
-	u32 can_id;
+	__le32 can_id;
 
 	u8 can_dlc;
 	u8 channel;
@@ -329,13 +335,13 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		if (!skb)
 			return;
 
-		cf->can_id = hf->can_id;
+		cf->can_id = le32_to_cpu(hf->can_id);
 
 		cf->can_dlc = get_can_dlc(hf->can_dlc);
 		memcpy(cf->data, hf->data, 8);
 
 		/* ERROR frames tell us information about the controller */
-		if (hf->can_id & CAN_ERR_FLAG)
+		if (le32_to_cpu(hf->can_id) & CAN_ERR_FLAG)
 			gs_update_state(dev, cf);
 
 		netdev->stats.rx_packets++;
@@ -418,11 +424,11 @@ static int gs_usb_set_bittiming(struct net_device *netdev)
 	if (!dbt)
 		return -ENOMEM;
 
-	dbt->prop_seg = bt->prop_seg;
-	dbt->phase_seg1 = bt->phase_seg1;
-	dbt->phase_seg2 = bt->phase_seg2;
-	dbt->sjw = bt->sjw;
-	dbt->brp = bt->brp;
+	dbt->prop_seg = cpu_to_le32(bt->prop_seg);
+	dbt->phase_seg1 = cpu_to_le32(bt->phase_seg1);
+	dbt->phase_seg2 = cpu_to_le32(bt->phase_seg2);
+	dbt->sjw = cpu_to_le32(bt->sjw);
+	dbt->brp = cpu_to_le32(bt->brp);
 
 	/* request bit timings */
 	rc = usb_control_msg(interface_to_usbdev(intf),
@@ -503,7 +509,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 
 	cf = (struct can_frame *)skb->data;
 
-	hf->can_id = cf->can_id;
+	hf->can_id = cpu_to_le32(cf->can_id);
 	hf->can_dlc = cf->can_dlc;
 	memcpy(hf->data, cf->data, cf->can_dlc);
 
@@ -573,6 +579,7 @@ static int gs_can_open(struct net_device *netdev)
 	int rc, i;
 	struct gs_device_mode *dm;
 	u32 ctrlmode;
+	u32 flags = 0;
 
 	rc = open_candev(netdev);
 	if (rc)
@@ -640,24 +647,24 @@ static int gs_can_open(struct net_device *netdev)
 
 	/* flags */
 	ctrlmode = dev->can.ctrlmode;
-	dm->flags = 0;
 
 	if (ctrlmode & CAN_CTRLMODE_LOOPBACK)
-		dm->flags |= GS_CAN_MODE_LOOP_BACK;
+		flags |= GS_CAN_MODE_LOOP_BACK;
 	else if (ctrlmode & CAN_CTRLMODE_LISTENONLY)
-		dm->flags |= GS_CAN_MODE_LISTEN_ONLY;
+		flags |= GS_CAN_MODE_LISTEN_ONLY;
 
 	/* Controller is not allowed to retry TX
 	 * this mode is unavailable on atmels uc3c hardware
 	 */
 	if (ctrlmode & CAN_CTRLMODE_ONE_SHOT)
-		dm->flags |= GS_CAN_MODE_ONE_SHOT;
+		flags |= GS_CAN_MODE_ONE_SHOT;
 
 	if (ctrlmode & CAN_CTRLMODE_3_SAMPLES)
-		dm->flags |= GS_CAN_MODE_TRIPLE_SAMPLE;
+		flags |= GS_CAN_MODE_TRIPLE_SAMPLE;
 
 	/* finally start device */
-	dm->mode = GS_CAN_MODE_START;
+	dm->mode = cpu_to_le32(GS_CAN_MODE_START);
+	dm->flags = cpu_to_le32(flags);
 	rc = usb_control_msg(interface_to_usbdev(dev->iface),
 			     usb_sndctrlpipe(interface_to_usbdev(dev->iface), 0),
 			     GS_USB_BREQ_MODE,
@@ -737,9 +744,9 @@ static int gs_usb_set_identify(struct net_device *netdev, bool do_identify)
 		return -ENOMEM;
 
 	if (do_identify)
-		imode->mode = GS_CAN_IDENTIFY_ON;
+		imode->mode = cpu_to_le32(GS_CAN_IDENTIFY_ON);
 	else
-		imode->mode = GS_CAN_IDENTIFY_OFF;
+		imode->mode = cpu_to_le32(GS_CAN_IDENTIFY_OFF);
 
 	rc = usb_control_msg(interface_to_usbdev(dev->iface),
 			     usb_sndctrlpipe(interface_to_usbdev(dev->iface),
@@ -790,6 +797,7 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	struct net_device *netdev;
 	int rc;
 	struct gs_device_bt_const *bt_const;
+	u32 feature;
 
 	bt_const = kmalloc(sizeof(*bt_const), GFP_KERNEL);
 	if (!bt_const)
@@ -830,14 +838,14 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 
 	/* dev setup */
 	strcpy(dev->bt_const.name, "gs_usb");
-	dev->bt_const.tseg1_min = bt_const->tseg1_min;
-	dev->bt_const.tseg1_max = bt_const->tseg1_max;
-	dev->bt_const.tseg2_min = bt_const->tseg2_min;
-	dev->bt_const.tseg2_max = bt_const->tseg2_max;
-	dev->bt_const.sjw_max = bt_const->sjw_max;
-	dev->bt_const.brp_min = bt_const->brp_min;
-	dev->bt_const.brp_max = bt_const->brp_max;
-	dev->bt_const.brp_inc = bt_const->brp_inc;
+	dev->bt_const.tseg1_min = le32_to_cpu(bt_const->tseg1_min);
+	dev->bt_const.tseg1_max = le32_to_cpu(bt_const->tseg1_max);
+	dev->bt_const.tseg2_min = le32_to_cpu(bt_const->tseg2_min);
+	dev->bt_const.tseg2_max = le32_to_cpu(bt_const->tseg2_max);
+	dev->bt_const.sjw_max = le32_to_cpu(bt_const->sjw_max);
+	dev->bt_const.brp_min = le32_to_cpu(bt_const->brp_min);
+	dev->bt_const.brp_max = le32_to_cpu(bt_const->brp_max);
+	dev->bt_const.brp_inc = le32_to_cpu(bt_const->brp_inc);
 
 	dev->udev = interface_to_usbdev(intf);
 	dev->iface = intf;
@@ -854,28 +862,29 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 
 	/* can setup */
 	dev->can.state = CAN_STATE_STOPPED;
-	dev->can.clock.freq = bt_const->fclk_can;
+	dev->can.clock.freq = le32_to_cpu(bt_const->fclk_can);
 	dev->can.bittiming_const = &dev->bt_const;
 	dev->can.do_set_bittiming = gs_usb_set_bittiming;
 
 	dev->can.ctrlmode_supported = 0;
 
-	if (bt_const->feature & GS_CAN_FEATURE_LISTEN_ONLY)
+	feature = le32_to_cpu(bt_const->feature);
+	if (feature & GS_CAN_FEATURE_LISTEN_ONLY)
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_LISTENONLY;
 
-	if (bt_const->feature & GS_CAN_FEATURE_LOOP_BACK)
+	if (feature & GS_CAN_FEATURE_LOOP_BACK)
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_LOOPBACK;
 
-	if (bt_const->feature & GS_CAN_FEATURE_TRIPLE_SAMPLE)
+	if (feature & GS_CAN_FEATURE_TRIPLE_SAMPLE)
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
 
-	if (bt_const->feature & GS_CAN_FEATURE_ONE_SHOT)
+	if (feature & GS_CAN_FEATURE_ONE_SHOT)
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_ONE_SHOT;
 
 	SET_NETDEV_DEV(netdev, &intf->dev);
 
-	if (dconf->sw_version > 1)
-		if (bt_const->feature & GS_CAN_FEATURE_IDENTIFY)
+	if (le32_to_cpu(dconf->sw_version) > 1)
+		if (feature & GS_CAN_FEATURE_IDENTIFY)
 			netdev->ethtool_ops = &gs_usb_ethtool_ops;
 
 	kfree(bt_const);
@@ -910,7 +919,7 @@ static int gs_usb_probe(struct usb_interface *intf,
 	if (!hconf)
 		return -ENOMEM;
 
-	hconf->byte_order = 0x0000beef;
+	hconf->byte_order = cpu_to_le32(0x0000beef);
 
 	/* send host config */
 	rc = usb_control_msg(interface_to_usbdev(intf),

base-commit: cbf3d60329c4e11edcecac0c8fc6767b0f05e3a7
-- 
2.29.2


