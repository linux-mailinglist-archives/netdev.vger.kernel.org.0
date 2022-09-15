Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8F65B962F
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiIOIVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiIOIU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:20:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C376897D46
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:20:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYk6n-0004Om-HM
        for netdev@vger.kernel.org; Thu, 15 Sep 2022 10:20:29 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B59C0E39A2
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:20:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E63BDE393B;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 30e9f693;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, John Whittington <git@jbrengineering.co.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 10/23] can: gs_usb: add RX and TX hardware timestamp support
Date:   Thu, 15 Sep 2022 10:20:00 +0200
Message-Id: <20220915082013.369072-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220915082013.369072-1-mkl@pengutronix.de>
References: <20220915082013.369072-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Whittington <git@jbrengineering.co.uk>

Add support for hardware timestamps, if the firmware includes it as a
feature via the GS_CAN_FEATURE_HW_TIMESTAMP flag. Check for this
feature during probe, extend the RX expected length if it is and
enable it during open.

The struct classic_can_ts and struct canfd_ts are extended to include
the µs timestamp following data as defined in the firmware. The
timestamp is then captured and set using skb_hwtstamps() on each RX
and TX.

The frame µs timestamp is provided from a 32 bit 1 MHz timer which
rolls over every 4294 seconds, so a cyclecounter, timecounter, and
delayed worker are used to convert the timer into a proper ns
timestamp - same implementation as commit efd8d98dfb900 ("can:
mcp251xfd: add HW timestamp infrastructure").

Hardware timestamps are added to capabilities as commit
b1f6b93e678f ("can: mcp251xfd: advertise timestamping capabilities and
add ioctl support").

Signed-off-by: John Whittington <git@jbrengineering.co.uk>
Link: https://github.com/candle-usb/candleLight_fw/issues/100
Link: https://lore.kernel.org/all/20220827221548.3291393-3-mkl@pengutronix.de
Co-developed-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 193 +++++++++++++++++++++++++++++++++--
 1 file changed, 186 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 532510902f60..cc363f1935ce 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -10,12 +10,16 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/clocksource.h>
 #include <linux/ethtool.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/signal.h>
+#include <linux/timecounter.h>
+#include <linux/units.h>
 #include <linux/usb.h>
+#include <linux/workqueue.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
@@ -37,6 +41,14 @@
 #define GS_USB_ENDPOINT_IN 1
 #define GS_USB_ENDPOINT_OUT 2
 
+/* Timestamp 32 bit timer runs at 1 MHz (1 µs tick). Worker accounts
+ * for timer overflow (will be after ~71 minutes)
+ */
+#define GS_USB_TIMESTAMP_TIMER_HZ (1 * HZ_PER_MHZ)
+#define GS_USB_TIMESTAMP_WORK_DELAY_SEC 1800
+static_assert(GS_USB_TIMESTAMP_WORK_DELAY_SEC <
+	      CYCLECOUNTER_MASK(32) / GS_USB_TIMESTAMP_TIMER_HZ / 2);
+
 /* Device specific constants */
 enum gs_usb_breq {
 	GS_USB_BREQ_HOST_FORMAT = 0,
@@ -199,6 +211,11 @@ struct classic_can {
 	u8 data[8];
 } __packed;
 
+struct classic_can_ts {
+	u8 data[8];
+	__le32 timestamp_us;
+} __packed;
+
 struct classic_can_quirk {
 	u8 data[8];
 	u8 quirk;
@@ -208,6 +225,11 @@ struct canfd {
 	u8 data[64];
 } __packed;
 
+struct canfd_ts {
+	u8 data[64];
+	__le32 timestamp_us;
+} __packed;
+
 struct canfd_quirk {
 	u8 data[64];
 	u8 quirk;
@@ -224,8 +246,10 @@ struct gs_host_frame {
 
 	union {
 		DECLARE_FLEX_ARRAY(struct classic_can, classic_can);
+		DECLARE_FLEX_ARRAY(struct classic_can_ts, classic_can_ts);
 		DECLARE_FLEX_ARRAY(struct classic_can_quirk, classic_can_quirk);
 		DECLARE_FLEX_ARRAY(struct canfd, canfd);
+		DECLARE_FLEX_ARRAY(struct canfd_ts, canfd_ts);
 		DECLARE_FLEX_ARRAY(struct canfd_quirk, canfd_quirk);
 	};
 } __packed;
@@ -259,6 +283,11 @@ struct gs_can {
 	struct can_bittiming_const bt_const, data_bt_const;
 	unsigned int channel;	/* channel number */
 
+	/* time counter for hardware timestamps */
+	struct cyclecounter cc;
+	struct timecounter tc;
+	struct delayed_work timestamp;
+
 	u32 feature;
 	unsigned int hf_size_tx;
 
@@ -351,6 +380,87 @@ static int gs_cmd_reset(struct gs_can *gsdev)
 	return rc;
 }
 
+static inline int gs_usb_get_timestamp(const struct gs_can *dev,
+				       u32 *timestamp_p)
+{
+	__le32 timestamp;
+	int rc;
+
+	rc = usb_control_msg_recv(interface_to_usbdev(dev->iface),
+				  usb_sndctrlpipe(interface_to_usbdev(dev->iface), 0),
+				  GS_USB_BREQ_TIMESTAMP,
+				  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				  dev->channel, 0,
+				  &timestamp, sizeof(timestamp),
+				  USB_CTRL_GET_TIMEOUT,
+				  GFP_KERNEL);
+	if (rc)
+		return rc;
+
+	*timestamp_p = le32_to_cpu(timestamp);
+
+	return 0;
+}
+
+static u64 gs_usb_timestamp_read(const struct cyclecounter *cc)
+{
+	const struct gs_can *dev;
+	u32 timestamp = 0;
+	int err;
+
+	dev = container_of(cc, struct gs_can, cc);
+	err = gs_usb_get_timestamp(dev, &timestamp);
+	if (err)
+		netdev_err(dev->netdev,
+			   "Error %d while reading timestamp. HW timestamps may be inaccurate.",
+			   err);
+
+	return timestamp;
+}
+
+static void gs_usb_timestamp_work(struct work_struct *work)
+{
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct gs_can *dev;
+
+	dev = container_of(delayed_work, struct gs_can, timestamp);
+	timecounter_read(&dev->tc);
+
+	schedule_delayed_work(&dev->timestamp,
+			      GS_USB_TIMESTAMP_WORK_DELAY_SEC * HZ);
+}
+
+static void gs_usb_skb_set_timestamp(const struct gs_can *dev,
+				     struct sk_buff *skb, u32 timestamp)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	u64 ns;
+
+	ns = timecounter_cyc2time(&dev->tc, timestamp);
+	hwtstamps->hwtstamp = ns_to_ktime(ns);
+}
+
+static void gs_usb_timestamp_init(struct gs_can *dev)
+{
+	struct cyclecounter *cc = &dev->cc;
+
+	cc->read = gs_usb_timestamp_read;
+	cc->mask = CYCLECOUNTER_MASK(32);
+	cc->shift = 32 - bits_per(NSEC_PER_SEC / GS_USB_TIMESTAMP_TIMER_HZ);
+	cc->mult = clocksource_hz2mult(GS_USB_TIMESTAMP_TIMER_HZ, cc->shift);
+
+	timecounter_init(&dev->tc, &dev->cc, ktime_get_real_ns());
+
+	INIT_DELAYED_WORK(&dev->timestamp, gs_usb_timestamp_work);
+	schedule_delayed_work(&dev->timestamp,
+			      GS_USB_TIMESTAMP_WORK_DELAY_SEC * HZ);
+}
+
+static void gs_usb_timestamp_stop(struct gs_can *dev)
+{
+	cancel_delayed_work_sync(&dev->timestamp);
+}
+
 static void gs_update_state(struct gs_can *dev, struct can_frame *cf)
 {
 	struct can_device_stats *can_stats = &dev->can.can_stats;
@@ -376,6 +486,24 @@ static void gs_update_state(struct gs_can *dev, struct can_frame *cf)
 	}
 }
 
+static void gs_usb_set_timestamp(const struct gs_can *dev, struct sk_buff *skb,
+				 const struct gs_host_frame *hf)
+{
+	u32 timestamp;
+
+	if (!(dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP))
+		return;
+
+	if (hf->flags & GS_CAN_FLAG_FD)
+		timestamp = le32_to_cpu(hf->canfd_ts->timestamp_us);
+	else
+		timestamp = le32_to_cpu(hf->classic_can_ts->timestamp_us);
+
+	gs_usb_skb_set_timestamp(dev, skb, timestamp);
+
+	return;
+}
+
 static void gs_usb_receive_bulk_callback(struct urb *urb)
 {
 	struct gs_usb *usbcan = urb->context;
@@ -443,6 +571,8 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 				gs_update_state(dev, cf);
 		}
 
+		gs_usb_set_timestamp(dev, skb, hf);
+
 		netdev->stats.rx_packets++;
 		netdev->stats.rx_bytes += hf->can_dlc;
 
@@ -465,6 +595,9 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 			goto resubmit_urb;
 		}
 
+		skb = dev->can.echo_skb[hf->echo_id];
+		gs_usb_set_timestamp(dev, skb, hf);
+
 		netdev->stats.tx_packets++;
 		netdev->stats.tx_bytes += can_get_echo_skb(netdev, hf->echo_id,
 							   NULL);
@@ -823,6 +956,10 @@ static int gs_can_open(struct net_device *netdev)
 	if (ctrlmode & CAN_CTRLMODE_3_SAMPLES)
 		flags |= GS_CAN_MODE_TRIPLE_SAMPLE;
 
+	/* if hardware supports timestamps, enable it */
+	if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+		flags |= GS_CAN_MODE_HW_TIMESTAMP;
+
 	/* finally start device */
 	dm->mode = cpu_to_le32(GS_CAN_MODE_START);
 	dm->flags = cpu_to_le32(flags);
@@ -840,6 +977,10 @@ static int gs_can_open(struct net_device *netdev)
 
 	kfree(dm);
 
+	/* start polling timestamp */
+	if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+		gs_usb_timestamp_init(dev);
+
 	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	parent->active_channels++;
@@ -858,6 +999,10 @@ static int gs_can_close(struct net_device *netdev)
 
 	netif_stop_queue(netdev);
 
+	/* stop polling timestamp */
+	if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+		gs_usb_timestamp_stop(dev);
+
 	/* Stop polling */
 	parent->active_channels--;
 	if (!parent->active_channels) {
@@ -890,11 +1035,22 @@ static int gs_can_close(struct net_device *netdev)
 	return 0;
 }
 
+static int gs_can_eth_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
+{
+	const struct gs_can *dev = netdev_priv(netdev);
+
+	if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+		return can_eth_ioctl_hwts(netdev, ifr, cmd);
+
+	return -EOPNOTSUPP;
+}
+
 static const struct net_device_ops gs_usb_netdev_ops = {
 	.ndo_open = gs_can_open,
 	.ndo_stop = gs_can_close,
 	.ndo_start_xmit = gs_can_start_xmit,
 	.ndo_change_mtu = can_change_mtu,
+	.ndo_eth_ioctl = gs_can_eth_ioctl,
 };
 
 static int gs_usb_set_identify(struct net_device *netdev, bool do_identify)
@@ -944,9 +1100,21 @@ static int gs_usb_set_phys_id(struct net_device *dev,
 	return rc;
 }
 
+static int gs_usb_get_ts_info(struct net_device *netdev,
+			      struct ethtool_ts_info *info)
+{
+	struct gs_can *dev = netdev_priv(netdev);
+
+	/* report if device supports HW timestamps */
+	if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+		return can_ethtool_op_get_ts_info_hwts(netdev, info);
+
+	return ethtool_op_get_ts_info(netdev, info);
+}
+
 static const struct ethtool_ops gs_usb_ethtool_ops = {
 	.set_phys_id = gs_usb_set_phys_id,
-	.get_ts_info = ethtool_op_get_ts_info,
+	.get_ts_info = gs_usb_get_ts_info,
 };
 
 static struct gs_can *gs_make_candev(unsigned int channel,
@@ -1202,15 +1370,13 @@ static int gs_usb_probe(struct usb_interface *intf,
 	}
 
 	init_usb_anchor(&dev->rx_submitted);
-	/* default to classic CAN, switch to CAN-FD if at least one of
-	 * our channels support CAN-FD.
-	 */
-	dev->hf_size_rx = struct_size(hf, classic_can, 1);
 
 	usb_set_intfdata(intf, dev);
 	dev->udev = udev;
 
 	for (i = 0; i < icount; i++) {
+		unsigned int hf_size_rx = 0;
+
 		dev->canch[i] = gs_make_candev(i, intf, dconf);
 		if (IS_ERR_OR_NULL(dev->canch[i])) {
 			/* save error code to return later */
@@ -1228,8 +1394,21 @@ static int gs_usb_probe(struct usb_interface *intf,
 		}
 		dev->canch[i]->parent = dev;
 
-		if (dev->canch[i]->can.ctrlmode_supported & CAN_CTRLMODE_FD)
-			dev->hf_size_rx = struct_size(hf, canfd, 1);
+		/* set RX packet size based on FD and if hardware
+                * timestamps are supported.
+		*/
+		if (dev->canch[i]->can.ctrlmode_supported & CAN_CTRLMODE_FD) {
+			if (dev->canch[i]->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+				hf_size_rx = struct_size(hf, canfd_ts, 1);
+			else
+				hf_size_rx = struct_size(hf, canfd, 1);
+		} else {
+			if (dev->canch[i]->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+				hf_size_rx = struct_size(hf, classic_can_ts, 1);
+			else
+				hf_size_rx = struct_size(hf, classic_can, 1);
+		}
+		dev->hf_size_rx = max(dev->hf_size_rx, hf_size_rx);
 	}
 
 	kfree(dconf);
-- 
2.35.1


