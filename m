Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15ECD3F695C
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhHXS6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:58:16 -0400
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:65039 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233155AbhHXS6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:58:08 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 969716426A4;
        Tue, 24 Aug 2021 18:57:23 +0000 (UTC)
Received: from ares.krystal.co.uk (100-101-162-88.trex-nlb.outbound.svc.cluster.local [100.101.162.88])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 5C14D641C62;
        Tue, 24 Aug 2021 18:57:21 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.101.162.88 (trex/6.4.3);
        Tue, 24 Aug 2021 18:57:23 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Power-Daffy: 5aaf95ff26029350_1629831443480_4198797654
X-MC-Loop-Signature: 1629831443480:2762857034
X-MC-Ingress-Time: 1629831443480
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3859oHeP48Vjxd6oFeFv4VBBCvElQzRJP+0ctQjryWM=; b=IxkmfO9ivSj9oUYhRVBJfA7f4V
        ktn6GFbayl0GcQA0jpFeOT747i86PHTzesog6m8fYYXHtbptnRdSGL+oEE/sDHsIlPZ0r5hdCyxUX
        h9CUv4CxVCZsxMPOALJZtMo7WWI6VIYo170lkIxLK3t34FpboSbvBSMerST3KAFVl3WHWgv7yJF8V
        cWqnywBnBRJCVJRNs2ZIIVUEpxjM9TAb8ScJjoJ3lE6lj2IZakT9LGkdAf12fWWKyfapJoRzF6ELL
        OLln130hiGp47Z6F0/NPnLxD2vXc1/ULfwuz0Bc+V3N4ESBamVb1fJriOp4TI06QaDDdoTwAtJhew
        TQ237wUg==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51816 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIbbs-00BQSi-DC; Tue, 24 Aug 2021 19:57:19 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-usb@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next v2 07/10] lan78xx: Fix partial packet errors on suspend/resume
Date:   Tue, 24 Aug 2021 19:56:10 +0100
Message-Id: <20210824185613.49545-8-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
References: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC can get out of step with the internal packet FIFOs if the
system goes to sleep when the link is active, especially at high
data rates. This can result in partial frames in the packet FIFOs
that in result in malformed frames being delivered to the host.
This occurs because the driver does not enable/disable the internal
packet FIFOs in step with the corresponding MAC data path. The
following changes fix this problem.

Update code that enables/disables the MAC receiver and transmitter
to the more general Rx and Tx data path, where the data path in each
direction consists of both the MAC function (Tx or Rx) and the
corresponding packet FIFO.

In the receive path the packet FIFO must be enabled before the MAC
receiver but disabled after the MAC receiver.

In the transmit path the opposite is true: the packet FIFO must be
enabled after the MAC transmitter but disabled before the MAC
transmitter.

The packet FIFOs can be flushed safely once the corresponding data
path is stopped.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 303 +++++++++++++++++++++++++-------------
 1 file changed, 197 insertions(+), 106 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 2eb853b13c2a..9170a786a24c 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -100,6 +100,12 @@
 /* statistic update interval (mSec) */
 #define STAT_UPDATE_TIMER		(1 * 1000)
 
+/* time to wait for MAC or FCT to stop (jiffies) */
+#define HW_DISABLE_TIMEOUT		(HZ / 10)
+
+/* time to wait between polling MAC or FCT state (ms) */
+#define HW_DISABLE_DELAY_MS		1
+
 /* defines interrupts from interrupt EP */
 #define MAX_INT_EP			(32)
 #define INT_EP_INTEP			(31)
@@ -487,6 +493,26 @@ static int lan78xx_write_reg(struct lan78xx_net *dev, u32 index, u32 data)
 	return ret;
 }
 
+static int lan78xx_update_reg(struct lan78xx_net *dev, u32 reg, u32 mask,
+			      u32 data)
+{
+	int ret;
+	u32 buf;
+
+	ret = lan78xx_read_reg(dev, reg, &buf);
+	if (ret < 0)
+		return ret;
+
+	buf &= ~mask;
+	buf |= (mask & data);
+
+	ret = lan78xx_write_reg(dev, reg, buf);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static int lan78xx_read_stats(struct lan78xx_net *dev,
 			      struct lan78xx_statstage *data)
 {
@@ -2513,6 +2539,156 @@ static void lan78xx_init_ltm(struct lan78xx_net *dev)
 	lan78xx_write_reg(dev, LTM_INACTIVE1, regs[5]);
 }
 
+static int lan78xx_start_hw(struct lan78xx_net *dev, u32 reg, u32 hw_enable)
+{
+	return lan78xx_update_reg(dev, reg, hw_enable, hw_enable);
+}
+
+static int lan78xx_stop_hw(struct lan78xx_net *dev, u32 reg, u32 hw_enabled,
+			   u32 hw_disabled)
+{
+	unsigned long timeout;
+	bool stopped = true;
+	int ret;
+	u32 buf;
+
+	/* Stop the h/w block (if not already stopped) */
+
+	ret = lan78xx_read_reg(dev, reg, &buf);
+	if (ret < 0)
+		return ret;
+
+	if (buf & hw_enabled) {
+		buf &= ~hw_enabled;
+
+		ret = lan78xx_write_reg(dev, reg, buf);
+		if (ret < 0)
+			return ret;
+
+		stopped = false;
+		timeout = jiffies + HW_DISABLE_TIMEOUT;
+		do  {
+			ret = lan78xx_read_reg(dev, reg, &buf);
+			if (ret < 0)
+				return ret;
+
+			if (buf & hw_disabled)
+				stopped = true;
+			else
+				msleep(HW_DISABLE_DELAY_MS);
+		} while (!stopped && !time_after(jiffies, timeout));
+	}
+
+	ret = stopped ? 0 : -ETIME;
+
+	return ret;
+}
+
+static int lan78xx_flush_fifo(struct lan78xx_net *dev, u32 reg, u32 fifo_flush)
+{
+	return lan78xx_update_reg(dev, reg, fifo_flush, fifo_flush);
+}
+
+static int lan78xx_start_tx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "start tx path");
+
+	/* Start the MAC transmitter */
+
+	ret = lan78xx_start_hw(dev, MAC_TX, MAC_TX_TXEN_);
+	if (ret < 0)
+		return ret;
+
+	/* Start the Tx FIFO */
+
+	ret = lan78xx_start_hw(dev, FCT_TX_CTL, FCT_TX_CTL_EN_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int lan78xx_stop_tx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "stop tx path");
+
+	/* Stop the Tx FIFO */
+
+	ret = lan78xx_stop_hw(dev, FCT_TX_CTL, FCT_TX_CTL_EN_, FCT_TX_CTL_DIS_);
+	if (ret < 0)
+		return ret;
+
+	/* Stop the MAC transmitter */
+
+	ret = lan78xx_stop_hw(dev, MAC_TX, MAC_TX_TXEN_, MAC_TX_TXD_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/* The caller must ensure the Tx path is stopped before calling
+ * lan78xx_flush_tx_fifo().
+ */
+static int lan78xx_flush_tx_fifo(struct lan78xx_net *dev)
+{
+	return lan78xx_flush_fifo(dev, FCT_TX_CTL, FCT_TX_CTL_RST_);
+}
+
+static int lan78xx_start_rx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "start rx path");
+
+	/* Start the Rx FIFO */
+
+	ret = lan78xx_start_hw(dev, FCT_RX_CTL, FCT_RX_CTL_EN_);
+	if (ret < 0)
+		return ret;
+
+	/* Start the MAC receiver*/
+
+	ret = lan78xx_start_hw(dev, MAC_RX, MAC_RX_RXEN_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int lan78xx_stop_rx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "stop rx path");
+
+	/* Stop the MAC receiver */
+
+	ret = lan78xx_stop_hw(dev, MAC_RX, MAC_RX_RXEN_, MAC_RX_RXD_);
+	if (ret < 0)
+		return ret;
+
+	/* Stop the Rx FIFO */
+
+	ret = lan78xx_stop_hw(dev, FCT_RX_CTL, FCT_RX_CTL_EN_, FCT_RX_CTL_DIS_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/* The caller must ensure the Rx path is stopped before calling
+ * lan78xx_flush_rx_fifo().
+ */
+static int lan78xx_flush_rx_fifo(struct lan78xx_net *dev)
+{
+	return lan78xx_flush_fifo(dev, FCT_RX_CTL, FCT_RX_CTL_RST_);
+}
+
 static int lan78xx_reset(struct lan78xx_net *dev)
 {
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
@@ -2703,23 +2879,7 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 	if (ret < 0)
 		return ret;
 
-	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
-	if (ret < 0)
-		return ret;
-
-	buf |= MAC_TX_TXEN_;
-
-	ret = lan78xx_write_reg(dev, MAC_TX, buf);
-	if (ret < 0)
-		return ret;
-
-	ret = lan78xx_read_reg(dev, FCT_TX_CTL, &buf);
-	if (ret < 0)
-		return ret;
-
-	buf |= FCT_TX_CTL_EN_;
-
-	ret = lan78xx_write_reg(dev, FCT_TX_CTL, buf);
+	ret = lan78xx_start_tx_path(dev);
 	if (ret < 0)
 		return ret;
 
@@ -2728,27 +2888,9 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 	if (ret < 0)
 		return ret;
 
-	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-	if (ret < 0)
-		return ret;
-
-	buf |= MAC_RX_RXEN_;
-
-	ret = lan78xx_write_reg(dev, MAC_RX, buf);
-	if (ret < 0)
-		return ret;
+	ret = lan78xx_start_rx_path(dev);
 
-	ret = lan78xx_read_reg(dev, FCT_RX_CTL, &buf);
-	if (ret < 0)
-		return ret;
-
-	buf |= FCT_RX_CTL_EN_;
-
-	ret = lan78xx_write_reg(dev, FCT_RX_CTL, buf);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 static void lan78xx_init_stats(struct lan78xx_net *dev)
@@ -3970,23 +4112,10 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 	u16 crc;
 	int ret;
 
-	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
+	ret = lan78xx_stop_tx_path(dev);
 	if (ret < 0)
 		return ret;
-
-	buf &= ~MAC_TX_TXEN_;
-
-	ret = lan78xx_write_reg(dev, MAC_TX, buf);
-	if (ret < 0)
-		return ret;
-
-	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-	if (ret < 0)
-		return ret;
-
-	buf &= ~MAC_RX_RXEN_;
-
-	ret = lan78xx_write_reg(dev, MAC_RX, buf);
+	ret = lan78xx_stop_rx_path(dev);
 	if (ret < 0)
 		return ret;
 
@@ -4163,17 +4292,9 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 	if (ret < 0)
 		return ret;
 
-	lan78xx_read_reg(dev, MAC_RX, &buf);
-	if (ret < 0)
-		return ret;
+	ret = lan78xx_start_rx_path(dev);
 
-	buf |= MAC_RX_RXEN_;
-
-	lan78xx_write_reg(dev, MAC_RX, buf);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
@@ -4196,24 +4317,17 @@ static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
 			spin_unlock_irq(&dev->txq.lock);
 		}
 
-		/* stop TX & RX */
-		ret = lan78xx_read_reg(dev, MAC_TX, &buf);
+		/* stop RX */
+		ret = lan78xx_stop_rx_path(dev);
 		if (ret < 0)
 			return ret;
 
-		buf &= ~MAC_TX_TXEN_;
-
-		ret = lan78xx_write_reg(dev, MAC_TX, buf);
+		ret = lan78xx_flush_rx_fifo(dev);
 		if (ret < 0)
 			return ret;
 
-		ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-		if (ret < 0)
-			return ret;
-
-		buf &= ~MAC_RX_RXEN_;
-
-		ret = lan78xx_write_reg(dev, MAC_RX, buf);
+		/* stop Tx */
+		ret = lan78xx_stop_tx_path(dev);
 		if (ret < 0)
 			return ret;
 
@@ -4231,23 +4345,11 @@ static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
 
 		if (PMSG_IS_AUTO(message)) {
 			/* auto suspend (selective suspend) */
-			ret = lan78xx_read_reg(dev, MAC_TX, &buf);
-			if (ret < 0)
-				return ret;
-
-			buf &= ~MAC_TX_TXEN_;
-
-			ret = lan78xx_write_reg(dev, MAC_TX, buf);
-			if (ret < 0)
-				return ret;
-
-			ret = lan78xx_read_reg(dev, MAC_RX, &buf);
+			ret = lan78xx_stop_tx_path(dev);
 			if (ret < 0)
 				return ret;
 
-			buf &= ~MAC_RX_RXEN_;
-
-			ret = lan78xx_write_reg(dev, MAC_RX, buf);
+			ret = lan78xx_stop_rx_path(dev);
 			if (ret < 0)
 				return ret;
 
@@ -4299,13 +4401,7 @@ static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
 			if (ret < 0)
 				return ret;
 
-			ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-			if (ret < 0)
-				return ret;
-
-			buf |= MAC_RX_RXEN_;
-
-			ret = lan78xx_write_reg(dev, MAC_RX, buf);
+			ret = lan78xx_start_rx_path(dev);
 			if (ret < 0)
 				return ret;
 		} else {
@@ -4330,7 +4426,6 @@ static int lan78xx_resume(struct usb_interface *intf)
 	struct sk_buff *skb;
 	struct urb *res;
 	int ret;
-	u32 buf;
 
 	if (!timer_pending(&dev->stat_monitor)) {
 		dev->delta = 1;
@@ -4338,6 +4433,10 @@ static int lan78xx_resume(struct usb_interface *intf)
 			  jiffies + STAT_UPDATE_TIMER);
 	}
 
+	ret = lan78xx_flush_tx_fifo(dev);
+	if (ret < 0)
+		return ret;
+
 	if (!--dev->suspend_count) {
 		/* resume interrupt URBs */
 		if (dev->urb_intr && test_bit(EVENT_DEV_OPEN, &dev->flags)) {
@@ -4397,17 +4496,9 @@ static int lan78xx_resume(struct usb_interface *intf)
 	if (ret < 0)
 		return ret;
 
-	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
-	if (ret < 0)
-		return ret;
-
-	buf |= MAC_TX_TXEN_;
+	ret = lan78xx_start_tx_path(dev);
 
-	ret = lan78xx_write_reg(dev, MAC_TX, buf);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 static int lan78xx_reset_resume(struct usb_interface *intf)
-- 
2.25.1

