Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F248730F2CC
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 13:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhBDL7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:59:13 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:58522 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235856AbhBDL7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:59:10 -0500
Received: from [51.148.178.73] (port=37344 helo=pbcl-dsk8.fritz.box)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l7crn-008lpZ-PP; Thu, 04 Feb 2021 11:32:07 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next 3/9] lan78xx: fix USB errors and packet loss on suspend/resume
Date:   Thu,  4 Feb 2021 11:31:15 +0000
Message-Id: <20210204113121.29786-4-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ares.krystal.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pebblebay.com
X-Get-Message-Sender-Via: ares.krystal.co.uk: authenticated_id: john.efstathiades@pebblebay.com
X-Authenticated-Sender: ares.krystal.co.uk: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following introduction of the NAPI interface, URB errors and buffer
loss were observed during suspend and resume operations. Both
auto-suspend and system suspend were affected.

Add control of USB packet FIFOs in addition to the MAC when suspending
and resuming the device.

Add support for driver's static URB and buffer pools (introduced with
NAPI interface support) to suspend and resume handling.

Refactor suspend and resume handling to simplify lan78xx_suspend() and
lan78xx_resume() routines.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 503 +++++++++++++++++++++++++++++---------
 1 file changed, 381 insertions(+), 122 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 38664b48329a..776d84d2b513 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -128,6 +128,15 @@
 /* statistic update interval (mSec) */
 #define STAT_UPDATE_TIMER		(1 * 1000)
 
+/* time to wait for MAC or FCT to stop (msec) */
+#define HW_DISABLE_TIMEOUT		10
+
+/* time to wait between polling MAC or FCT state */
+#define HW_DISABLE_DELAY		1
+
+/* max number of times to poll MAC or FCT state */
+#define HW_DISABLE_POLL_MAX		(HW_DISABLE_TIMEOUT / HW_DISABLE_DELAY)
+
 /* defines interrupts from interrupt EP */
 #define MAX_INT_EP			(32)
 #define INT_EP_INTEP			(31)
@@ -429,6 +438,7 @@ struct lan78xx_net {
 	struct urb		*urb_intr;
 	struct usb_anchor	deferred;
 
+	struct mutex		dev_mutex; /* serialise open/stop wrt suspend/resume */
 	struct mutex		phy_mutex; /* for phy access */
 	unsigned		pipe_in, pipe_out, pipe_intr;
 
@@ -2650,6 +2660,174 @@ static int lan78xx_urb_config_init(struct lan78xx_net *dev)
 	return result;
 }
 
+static int lan78xx_start_tx_path(struct lan78xx_net *dev)
+{
+	int ret;
+	u32 buf;
+
+	netif_dbg(dev, drv, dev->net, "start tx path");
+
+	/* Start the MAC transmitter */
+
+	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
+	buf |= MAC_TX_TXEN_;
+	ret = lan78xx_write_reg(dev, MAC_TX, buf);
+
+	/* Start the Tx FIFO */
+
+	ret = lan78xx_read_reg(dev, FCT_TX_CTL, &buf);
+	buf |= FCT_TX_CTL_EN_;
+	ret = lan78xx_write_reg(dev, FCT_TX_CTL, buf);
+
+	return 0;
+}
+
+static int lan78xx_stop_tx_path(struct lan78xx_net *dev)
+{
+	int ret;
+	u32 buf = 0;
+	int i;
+
+	netif_dbg(dev, drv, dev->net, "stop tx path");
+
+	/* Stop the Tx FIFO (if not already stopped) */
+
+	ret = lan78xx_read_reg(dev, FCT_TX_CTL, &buf);
+
+	if ((buf & FCT_TX_CTL_EN_) != 0) {
+		buf &= ~FCT_TX_CTL_EN_;
+		ret = lan78xx_write_reg(dev, FCT_TX_CTL, buf);
+
+		for (i = 0; i < HW_DISABLE_POLL_MAX; ++i) {
+			ret = lan78xx_read_reg(dev, FCT_TX_CTL, &buf);
+
+			if ((buf & FCT_TX_CTL_DIS_) != 0)
+				break;
+
+			msleep(HW_DISABLE_DELAY);
+		}
+	}
+
+	/* Stop the MAC transmitter (if not already stopped) */
+
+	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
+
+	if ((buf & MAC_TX_TXEN_) != 0) {
+		buf &= ~MAC_TX_TXEN_;
+		ret = lan78xx_write_reg(dev, MAC_TX, buf);
+
+		for (i = 0; i < HW_DISABLE_POLL_MAX; ++i) {
+			ret = lan78xx_read_reg(dev, MAC_TX, &buf);
+
+			if ((buf & MAC_TX_TXD_) != 0)
+				break;
+
+			msleep(HW_DISABLE_DELAY);
+		}
+	}
+
+	return 0;
+}
+
+/* The caller must ensure the Tx path is stopped before calling
+ * lan78xx_flush_tx_fifo().
+ */
+static int lan78xx_flush_tx_fifo(struct lan78xx_net *dev)
+{
+	int ret;
+	u32 buf;
+
+	ret = lan78xx_read_reg(dev, FCT_TX_CTL, &buf);
+	buf |= FCT_TX_CTL_RST_;
+	ret = lan78xx_write_reg(dev, FCT_TX_CTL, buf);
+
+	return 0;
+}
+
+static int lan78xx_start_rx_path(struct lan78xx_net *dev)
+{
+	int ret;
+	u32 buf;
+
+	netif_dbg(dev, drv, dev->net, "start rx path");
+
+	/* Start the Rx FIFO */
+
+	ret = lan78xx_read_reg(dev, FCT_RX_CTL, &buf);
+	buf |= FCT_RX_CTL_EN_;
+	ret = lan78xx_write_reg(dev, FCT_RX_CTL, buf);
+
+	/* Start the MAC receiver*/
+
+	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
+	buf |= MAC_RX_RXEN_;
+	ret = lan78xx_write_reg(dev, MAC_RX, buf);
+
+	return 0;
+}
+
+static int lan78xx_stop_rx_path(struct lan78xx_net *dev)
+{
+	int ret;
+	u32 buf;
+	int i;
+
+	netif_dbg(dev, drv, dev->net, "stop rx path");
+
+	/* Stop the MAC receiver (if not already running) */
+
+	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
+
+	if ((buf & MAC_RX_RXEN_) != 0) {
+		buf &= ~MAC_RX_RXEN_;
+		ret = lan78xx_write_reg(dev, MAC_RX, buf);
+
+		for (i = 0; i < HW_DISABLE_POLL_MAX; ++i) {
+			ret = lan78xx_read_reg(dev, MAC_RX, &buf);
+
+			if ((buf & MAC_RX_RXD_) != 0)
+				break;
+
+			msleep(HW_DISABLE_DELAY);
+		}
+	}
+
+	/* Stop the Rx FIFO (if not already stopped) */
+
+	ret = lan78xx_read_reg(dev, FCT_RX_CTL, &buf);
+
+	if ((buf & FCT_RX_CTL_EN_) != 0) {
+		buf &= ~FCT_RX_CTL_EN_;
+		ret = lan78xx_write_reg(dev, FCT_RX_CTL, buf);
+
+		for (i = 0; i < HW_DISABLE_POLL_MAX; ++i) {
+			ret = lan78xx_read_reg(dev, FCT_RX_CTL, &buf);
+
+			if ((buf & FCT_RX_CTL_DIS_) != 0)
+				break;
+
+			msleep(HW_DISABLE_DELAY);
+		}
+	}
+
+	return 0;
+}
+
+/* The caller must ensure the Rx path is stopped before calling
+ * lan78xx_flush_rx_fifo().
+ */
+static int lan78xx_flush_rx_fifo(struct lan78xx_net *dev)
+{
+	int ret;
+	u32 buf;
+
+	ret = lan78xx_read_reg(dev, FCT_RX_CTL, &buf);
+	buf |= FCT_RX_CTL_RST_;
+	ret = lan78xx_write_reg(dev, FCT_RX_CTL, buf);
+
+	return 0;
+}
+
 static int lan78xx_reset(struct lan78xx_net *dev)
 {
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
@@ -2752,25 +2930,9 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 	}
 	ret = lan78xx_write_reg(dev, MAC_CR, buf);
 
-	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
-	buf |= MAC_TX_TXEN_;
-	ret = lan78xx_write_reg(dev, MAC_TX, buf);
-
-	ret = lan78xx_read_reg(dev, FCT_TX_CTL, &buf);
-	buf |= FCT_TX_CTL_EN_;
-	ret = lan78xx_write_reg(dev, FCT_TX_CTL, buf);
-
 	ret = lan78xx_set_rx_max_frame_length(dev,
 					      RX_MAX_FRAME_LEN(dev->net->mtu));
 
-	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-	buf |= MAC_RX_RXEN_;
-	ret = lan78xx_write_reg(dev, MAC_RX, buf);
-
-	ret = lan78xx_read_reg(dev, FCT_RX_CTL, &buf);
-	buf |= FCT_RX_CTL_EN_;
-	ret = lan78xx_write_reg(dev, FCT_RX_CTL, buf);
-
 	return 0;
 }
 
@@ -2811,6 +2973,8 @@ static int lan78xx_open(struct net_device *net)
 	if (ret < 0)
 		goto out;
 
+	mutex_lock(&dev->dev_mutex);
+
 	phy_start(net->phydev);
 
 	netif_dbg(dev, ifup, dev->net, "phy initialised successfully");
@@ -2825,6 +2989,12 @@ static int lan78xx_open(struct net_device *net)
 		}
 	}
 
+	lan78xx_flush_rx_fifo(dev);
+	lan78xx_flush_tx_fifo(dev);
+
+	ret = lan78xx_start_tx_path(dev);
+	ret = lan78xx_start_rx_path(dev);
+
 	lan78xx_init_stats(dev);
 
 	set_bit(EVENT_DEV_OPEN, &dev->flags);
@@ -2837,8 +3007,9 @@ static int lan78xx_open(struct net_device *net)
 
 	lan78xx_defer_kevent(dev, EVENT_LINK_RESET);
 done:
-	usb_autopm_put_interface(dev->intf);
+	mutex_unlock(&dev->dev_mutex);
 
+	usb_autopm_put_interface(dev->intf);
 out:
 	return ret;
 }
@@ -2885,6 +3056,8 @@ static int lan78xx_stop(struct net_device *net)
 {
 	struct lan78xx_net *dev = netdev_priv(net);
 
+	mutex_lock(&dev->dev_mutex);
+
 	if (timer_pending(&dev->stat_monitor))
 		del_timer_sync(&dev->stat_monitor);
 
@@ -2899,6 +3072,9 @@ static int lan78xx_stop(struct net_device *net)
 		   net->stats.rx_packets, net->stats.tx_packets,
 		   net->stats.rx_errors, net->stats.tx_errors);
 
+	lan78xx_stop_tx_path(dev);
+	lan78xx_stop_rx_path(dev);
+
 	if (net->phydev)
 		phy_stop(net->phydev);
 
@@ -2913,6 +3089,8 @@ static int lan78xx_stop(struct net_device *net)
 
 	usb_autopm_put_interface(dev->intf);
 
+	mutex_unlock(&dev->dev_mutex);
+
 	return 0;
 }
 
@@ -2966,16 +3144,20 @@ static void tx_complete(struct urb *urb)
 		/* software-driven interface shutdown */
 		case -ECONNRESET:
 		case -ESHUTDOWN:
+			netif_dbg(dev, tx_err, dev->net,
+				  "tx err interface gone %d\n", entry->urb->status);
 			break;
 
 		case -EPROTO:
 		case -ETIME:
 		case -EILSEQ:
 			netif_stop_queue(dev->net);
+			netif_dbg(dev, tx_err, dev->net,
+				  "tx err queue stopped %d\n", entry->urb->status);
 			break;
 		default:
 			netif_dbg(dev, tx_err, dev->net,
-				  "tx err %d\n", entry->urb->status);
+				  "unknown tx err %d\n", entry->urb->status);
 			break;
 		}
 	}
@@ -3361,6 +3543,7 @@ static int rx_submit(struct lan78xx_net *dev, struct sk_buff *skb, gfp_t flags)
 			lan78xx_defer_kevent(dev, EVENT_RX_HALT);
 			break;
 		case -ENODEV:
+		case -ENOENT:
 			netif_dbg(dev, ifdown, dev->net, "device gone\n");
 			netif_device_detach(dev->net);
 			break;
@@ -3781,18 +3964,17 @@ static void lan78xx_delayedwork(struct work_struct *work)
 
 	dev = container_of(work, struct lan78xx_net, wq.work);
 
+	if (usb_autopm_get_interface(dev->intf) < 0)
+		return;
+
 	if (test_bit(EVENT_TX_HALT, &dev->flags)) {
 		unlink_urbs(dev, &dev->txq);
-		status = usb_autopm_get_interface(dev->intf);
-		if (status < 0)
-			goto fail_pipe;
+
 		status = usb_clear_halt(dev->udev, dev->pipe_out);
-		usb_autopm_put_interface(dev->intf);
 		if (status < 0 &&
 		    status != -EPIPE &&
 		    status != -ESHUTDOWN) {
 			if (netif_msg_tx_err(dev))
-fail_pipe:
 				netdev_err(dev->net,
 					   "can't clear tx halt, status %d\n",
 					   status);
@@ -3802,18 +3984,14 @@ static void lan78xx_delayedwork(struct work_struct *work)
 				netif_wake_queue(dev->net);
 		}
 	}
+
 	if (test_bit(EVENT_RX_HALT, &dev->flags)) {
 		unlink_urbs(dev, &dev->rxq);
-		status = usb_autopm_get_interface(dev->intf);
-		if (status < 0)
-				goto fail_halt;
 		status = usb_clear_halt(dev->udev, dev->pipe_in);
-		usb_autopm_put_interface(dev->intf);
 		if (status < 0 &&
 		    status != -EPIPE &&
 		    status != -ESHUTDOWN) {
 			if (netif_msg_rx_err(dev))
-fail_halt:
 				netdev_err(dev->net,
 					   "can't clear rx halt, status %d\n",
 					   status);
@@ -3821,22 +3999,16 @@ static void lan78xx_delayedwork(struct work_struct *work)
 			clear_bit(EVENT_RX_HALT, &dev->flags);
 			napi_schedule(&dev->napi);
 		}
+
 	}
 
 	if (test_bit(EVENT_LINK_RESET, &dev->flags)) {
 		int ret = 0;
 
 		clear_bit(EVENT_LINK_RESET, &dev->flags);
-		status = usb_autopm_get_interface(dev->intf);
-		if (status < 0)
-			goto skip_reset;
 		if (lan78xx_link_reset(dev) < 0) {
-			usb_autopm_put_interface(dev->intf);
-skip_reset:
 			netdev_info(dev->net, "link reset failed (%d)\n",
 				    ret);
-		} else {
-			usb_autopm_put_interface(dev->intf);
 		}
 	}
 
@@ -3850,6 +4022,8 @@ static void lan78xx_delayedwork(struct work_struct *work)
 
 		dev->delta = min((dev->delta * 2), 50);
 	}
+
+	usb_autopm_put_interface(dev->intf);
 }
 
 static void intr_complete(struct urb *urb)
@@ -3865,6 +4039,7 @@ static void intr_complete(struct urb *urb)
 
 	/* software-driven interface shutdown */
 	case -ENOENT:			/* urb killed */
+	case -ENODEV:
 	case -ESHUTDOWN:		/* hardware gone */
 		netif_dbg(dev, ifdown, dev->net,
 			  "intr shutdown, code %d\n", status);
@@ -3885,10 +4060,22 @@ static void intr_complete(struct urb *urb)
 	}
 
 	memset(urb->transfer_buffer, 0, urb->transfer_buffer_length);
+
 	status = usb_submit_urb(urb, GFP_ATOMIC);
-	if (status != 0)
-		netif_err(dev, timer, dev->net,
-			  "intr resubmit --> %d\n", status);
+
+	switch (status) {
+	case  0:
+		break;
+	case -ENODEV:
+	case -ENOENT:
+		netif_dbg(dev, timer, dev->net,
+			  "intr resubmit %d (disconnect?)", status);
+		netif_device_detach(dev->net);
+		break;
+	default:
+		netif_err(dev, timer, dev->net, "intr resubmit --> %d\n", status);
+		break;
+	}
 }
 
 static void lan78xx_disconnect(struct usb_interface *intf)
@@ -4022,6 +4209,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	skb_queue_head_init(&dev->txq_pend);
 	skb_queue_head_init(&dev->rxq_overflow);
 	mutex_init(&dev->phy_mutex);
+	mutex_init(&dev->dev_mutex);
 
 	ret = lan78xx_urb_config_init(dev);
 	if (ret < 0)
@@ -4173,6 +4361,43 @@ static u16 lan78xx_wakeframe_crc16(const u8 *buf, int len)
 	return crc;
 }
 
+static int lan78xx_set_auto_suspend(struct lan78xx_net *dev)
+{
+	u32 buf;
+	int ret;
+
+	lan78xx_stop_tx_path(dev);
+	lan78xx_stop_rx_path(dev);
+
+	/* auto suspend (selective suspend) */
+
+	ret = lan78xx_write_reg(dev, WUCSR, 0);
+	ret = lan78xx_write_reg(dev, WUCSR2, 0);
+	ret = lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
+
+	/* set goodframe wakeup */
+
+	ret = lan78xx_read_reg(dev, WUCSR, &buf);
+	buf |= WUCSR_RFE_WAKE_EN_;
+	buf |= WUCSR_STORE_WAKE_;
+	ret = lan78xx_write_reg(dev, WUCSR, buf);
+	ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+	buf &= ~PMT_CTL_RES_CLR_WKP_EN_;
+	buf |= PMT_CTL_RES_CLR_WKP_STS_;
+	buf |= PMT_CTL_PHY_WAKE_EN_;
+	buf |= PMT_CTL_WOL_EN_;
+	buf &= ~PMT_CTL_SUS_MODE_MASK_;
+	buf |= PMT_CTL_SUS_MODE_3_;
+	ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+	ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+	buf |= PMT_CTL_WUPS_MASK_;
+	ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+
+	lan78xx_start_rx_path(dev);
+
+	return 0;
+}
+
 static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 {
 	u32 buf;
@@ -4184,12 +4409,8 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 	const u8 ipv6_multicast[3] = { 0x33, 0x33 };
 	const u8 arp_type[2] = { 0x08, 0x06 };
 
-	lan78xx_read_reg(dev, MAC_TX, &buf);
-	buf &= ~MAC_TX_TXEN_;
-	lan78xx_write_reg(dev, MAC_TX, buf);
-	lan78xx_read_reg(dev, MAC_RX, &buf);
-	buf &= ~MAC_RX_RXEN_;
-	lan78xx_write_reg(dev, MAC_RX, buf);
+	lan78xx_stop_tx_path(dev);
+	lan78xx_stop_rx_path(dev);
 
 	lan78xx_write_reg(dev, WUCSR, 0);
 	lan78xx_write_reg(dev, WUCSR2, 0);
@@ -4308,9 +4529,7 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 	buf |= PMT_CTL_WUPS_MASK_;
 	lan78xx_write_reg(dev, PMT_CTL, buf);
 
-	lan78xx_read_reg(dev, MAC_RX, &buf);
-	buf |= MAC_RX_RXEN_;
-	lan78xx_write_reg(dev, MAC_RX, buf);
+	lan78xx_start_rx_path(dev);
 
 	return 0;
 }
@@ -4319,15 +4538,22 @@ static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct lan78xx_net *dev = usb_get_intfdata(intf);
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
-	u32 buf;
 	int ret;
+	bool dev_open;
+
+	mutex_lock(&dev->dev_mutex);
 
-	if (!dev->suspend_count++) {
+	netif_dbg(dev, ifdown, dev->net,
+		  "suspending: pm event %#x", message.event);
+
+	dev_open = test_bit(EVENT_DEV_OPEN, &dev->flags);
+
+	if (dev_open) {
 		spin_lock_irq(&dev->txq.lock);
 		/* don't autosuspend while transmitting */
 		if ((skb_queue_len(&dev->txq) ||
 		     skb_queue_len(&dev->txq_pend)) &&
-			PMSG_IS_AUTO(message)) {
+		    PMSG_IS_AUTO(message)) {
 			spin_unlock_irq(&dev->txq.lock);
 			ret = -EBUSY;
 			goto out;
@@ -4336,118 +4562,151 @@ static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
 			spin_unlock_irq(&dev->txq.lock);
 		}
 
-		/* stop TX & RX */
-		ret = lan78xx_read_reg(dev, MAC_TX, &buf);
-		buf &= ~MAC_TX_TXEN_;
-		ret = lan78xx_write_reg(dev, MAC_TX, buf);
-		ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-		buf &= ~MAC_RX_RXEN_;
-		ret = lan78xx_write_reg(dev, MAC_RX, buf);
+		/* stop RX */
+		lan78xx_stop_rx_path(dev);
+		lan78xx_flush_rx_fifo(dev);
+
+		/* stop Tx */
+		lan78xx_stop_tx_path(dev);
 
-		/* empty out the rx and queues */
+		/* empty out the Rx and Tx queues */
 		netif_device_detach(dev->net);
 		lan78xx_terminate_urbs(dev);
 		usb_kill_urb(dev->urb_intr);
 
 		/* reattach */
 		netif_device_attach(dev->net);
-	}
 
-	if (test_bit(EVENT_DEV_ASLEEP, &dev->flags)) {
 		del_timer(&dev->stat_monitor);
 
 		if (PMSG_IS_AUTO(message)) {
-			/* auto suspend (selective suspend) */
-			ret = lan78xx_read_reg(dev, MAC_TX, &buf);
-			buf &= ~MAC_TX_TXEN_;
-			ret = lan78xx_write_reg(dev, MAC_TX, buf);
-			ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-			buf &= ~MAC_RX_RXEN_;
-			ret = lan78xx_write_reg(dev, MAC_RX, buf);
-
-			ret = lan78xx_write_reg(dev, WUCSR, 0);
-			ret = lan78xx_write_reg(dev, WUCSR2, 0);
-			ret = lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
+			lan78xx_set_auto_suspend(dev);
+		} else {
+			netif_carrier_off(dev->net);
+			lan78xx_set_suspend(dev, pdata->wol);
+		}
+	} else {
+		/* Interface is down; WOL and PHY events
+		 * will not wake up the host
+		 */
+		u32 buf;
 
-			/* set goodframe wakeup */
-			ret = lan78xx_read_reg(dev, WUCSR, &buf);
+		set_bit(EVENT_DEV_ASLEEP, &dev->flags);
 
-			buf |= WUCSR_RFE_WAKE_EN_;
-			buf |= WUCSR_STORE_WAKE_;
+		ret = lan78xx_write_reg(dev, WUCSR, 0);
+		ret = lan78xx_write_reg(dev, WUCSR2, 0);
 
-			ret = lan78xx_write_reg(dev, WUCSR, buf);
+		ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+		buf &= ~PMT_CTL_RES_CLR_WKP_EN_;
+		buf |= PMT_CTL_RES_CLR_WKP_STS_;
+		buf &= ~PMT_CTL_SUS_MODE_MASK_;
+		buf |= PMT_CTL_SUS_MODE_3_;
+		ret = lan78xx_write_reg(dev, PMT_CTL, buf);
 
-			ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+		ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+		buf |= PMT_CTL_WUPS_MASK_;
+		ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+	}
 
-			buf &= ~PMT_CTL_RES_CLR_WKP_EN_;
-			buf |= PMT_CTL_RES_CLR_WKP_STS_;
+	ret = 0;
+out:
+	mutex_unlock(&dev->dev_mutex);
 
-			buf |= PMT_CTL_PHY_WAKE_EN_;
-			buf |= PMT_CTL_WOL_EN_;
-			buf &= ~PMT_CTL_SUS_MODE_MASK_;
-			buf |= PMT_CTL_SUS_MODE_3_;
+	return ret;
+}
 
-			ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+static bool lan78xx_submit_deferred_urbs(struct lan78xx_net *dev)
+{
+	struct urb *urb;
+	bool pipe_halted = false;
 
-			ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+	while ((urb = usb_get_from_anchor(&dev->deferred))) {
+		struct sk_buff *skb = urb->context;
+		int ret;
 
-			buf |= PMT_CTL_WUPS_MASK_;
+		if (!netif_device_present(dev->net) ||
+		    !netif_carrier_ok(dev->net) ||
+		    pipe_halted) {
+			lan78xx_free_tx_buf(dev, skb);
+			continue;
+		}
 
-			ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+		ret = usb_submit_urb(urb, GFP_ATOMIC);
 
-			ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-			buf |= MAC_RX_RXEN_;
-			ret = lan78xx_write_reg(dev, MAC_RX, buf);
+		if (ret == 0) {
+			netif_trans_update(dev->net);
+			lan78xx_queue_skb(&dev->txq, skb, tx_start);
 		} else {
-			lan78xx_set_suspend(dev, pdata->wol);
+			if (ret == -EPIPE) {
+				netif_stop_queue(dev->net);
+				pipe_halted = true;
+			} else if (ret == -ENODEV) {
+				netif_device_detach(dev->net);
+			}
+
+			lan78xx_free_tx_buf(dev, skb);
 		}
 	}
 
-	ret = 0;
-out:
-	return ret;
+	return pipe_halted;
 }
 
 static int lan78xx_resume(struct usb_interface *intf)
 {
 	struct lan78xx_net *dev = usb_get_intfdata(intf);
-	struct sk_buff *skb;
-	struct urb *res;
 	int ret;
-	u32 buf;
+	bool dev_open;
 
-	if (!timer_pending(&dev->stat_monitor)) {
-		dev->delta = 1;
-		mod_timer(&dev->stat_monitor,
-			  jiffies + STAT_UPDATE_TIMER);
-	}
+	mutex_lock(&dev->dev_mutex);
 
-	if (!--dev->suspend_count) {
-		/* resume interrupt URBs */
-		if (dev->urb_intr && test_bit(EVENT_DEV_OPEN, &dev->flags))
-				usb_submit_urb(dev->urb_intr, GFP_NOIO);
+	netif_dbg(dev, ifup, dev->net, "resuming device");
 
-		spin_lock_irq(&dev->txq.lock);
-		while ((res = usb_get_from_anchor(&dev->deferred))) {
-			skb = (struct sk_buff *)res->context;
-			ret = usb_submit_urb(res, GFP_ATOMIC);
+	dev_open = test_bit(EVENT_DEV_OPEN, &dev->flags);
+
+	if (dev_open) {
+		bool pipe_halted = false;
+
+		lan78xx_flush_tx_fifo(dev);
+
+		if (dev->urb_intr) {
+			ret = usb_submit_urb(dev->urb_intr, GFP_KERNEL);
 			if (ret < 0) {
-				lan78xx_free_tx_buf(dev, skb);
-				usb_autopm_put_interface_async(dev->intf);
-			} else {
-				netif_trans_update(dev->net);
-				lan78xx_queue_skb(&dev->txq, skb, tx_start);
+				if (ret == -ENODEV)
+					netif_device_detach(dev->net);
+
+			netdev_warn(dev->net, "Failed to submit intr URB");
 			}
 		}
 
+		spin_lock_irq(&dev->txq.lock);
+
+		if (netif_device_present(dev->net))
+			pipe_halted = lan78xx_submit_deferred_urbs(dev);
+
+		if (pipe_halted)
+			lan78xx_defer_kevent(dev, EVENT_TX_HALT);
+
 		clear_bit(EVENT_DEV_ASLEEP, &dev->flags);
+
 		spin_unlock_irq(&dev->txq.lock);
 
-		if (test_bit(EVENT_DEV_OPEN, &dev->flags)) {
-			if (lan78xx_tx_pend_data_len(dev) < LAN78XX_TX_URB_SPACE(dev))
-				netif_start_queue(dev->net);
-			napi_schedule(&dev->napi);
+		if (!pipe_halted &&
+		    netif_device_present(dev->net) &&
+		    (lan78xx_tx_pend_data_len(dev) < LAN78XX_TX_URB_SPACE(dev)))
+			netif_start_queue(dev->net);
+
+		lan78xx_start_tx_path(dev);
+
+		napi_schedule(&dev->napi);
+
+		if (!timer_pending(&dev->stat_monitor)) {
+			dev->delta = 1;
+			mod_timer(&dev->stat_monitor,
+				  jiffies + STAT_UPDATE_TIMER);
 		}
+
+	} else {
+		clear_bit(EVENT_DEV_ASLEEP, &dev->flags);
 	}
 
 	ret = lan78xx_write_reg(dev, WUCSR2, 0);
@@ -4467,9 +4726,7 @@ static int lan78xx_resume(struct usb_interface *intf)
 					    WUCSR_MPR_ |
 					    WUCSR_BCST_FR_);
 
-	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
-	buf |= MAC_TX_TXEN_;
-	ret = lan78xx_write_reg(dev, MAC_TX, buf);
+	mutex_unlock(&dev->dev_mutex);
 
 	return 0;
 }
@@ -4478,6 +4735,8 @@ static int lan78xx_reset_resume(struct usb_interface *intf)
 {
 	struct lan78xx_net *dev = usb_get_intfdata(intf);
 
+	netif_dbg(dev, ifup, dev->net, "(reset) resuming device");
+
 	lan78xx_reset(dev);
 
 	phy_start(dev->net->phydev);
-- 
2.17.1

