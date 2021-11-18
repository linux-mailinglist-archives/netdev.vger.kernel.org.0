Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD18545598D
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343556AbhKRLFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:05:25 -0500
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:11734 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235730AbhKRLFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:05:19 -0500
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 577B79226E0;
        Thu, 18 Nov 2021 11:02:13 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-18-151.trex.outbound.svc.cluster.local [100.96.18.151])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 93A58922673;
        Thu, 18 Nov 2021 11:02:11 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.18.151 (trex/6.4.3);
        Thu, 18 Nov 2021 11:02:13 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Plucky-Fearful: 51a2256a791118a5_1637233332896_2361335838
X-MC-Loop-Signature: 1637233332896:2927311956
X-MC-Ingress-Time: 1637233332896
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0x9i6nlkEJ9K9gnL7ZteS70kGT5tv2BaRAYgEQWwGoM=; b=CKIfyDSTkEUzznjXSgmPRff8gz
        4xCscN8mgXXQkiukEbPtHR+uLu64JMNSRXQWj9LsB8A1XsmgQiwsnc0MY7IUhaCfIsY5kXZgIfFB7
        Rpy4Y6FMmKEczUpQtnaBvnUIctHV7gs4FIEh7NTCZlw7/mGlWf+J1wQIlquqVcjWBBXVHZ7mCB22r
        B6Tr+a2U+TjmZwVTQLZ5mOk9wHMcDRH48MygsiRXZeSRITzZalHJrhnrhczMWz0FLVkTuYnMWa/D9
        Rks0Sgbba7QNRhKrzpHfsP7NBMAtstYOJ01Ut2K5YBDtOCjZ8PcfdASmGFaPaymj/nugIgTzY20/r
        GMfoCJsg==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:46024 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mnfBD-004NG9-Bt; Thu, 18 Nov 2021 11:02:09 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 3/6] lan78xx: Introduce Rx URB processing improvements
Date:   Thu, 18 Nov 2021 11:01:36 +0000
Message-Id: <20211118110139.7321-4-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118110139.7321-1-john.efstathiades@pebblebay.com>
References: <20211118110139.7321-1-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new approach to allocating and managing
Rx URBs that contributes to improving driver throughput and reducing
CPU load.

A pool of Rx URBs is created during driver instantiation. All the
URBs are initially submitted to the USB host controller for
processing.

The default URB buffer size is different for each USB bus speed.
The chosen sizes provide good USB utilisation with little impact on
overall packet latency.

Completed URBs are processed in the driver bottom half. The URB
buffer contents are copied to a dynamically allocated SKB, which is
then passed to the network stack. The URB is then re-submitted to
the USB host controller.

NOTE: the call to skb_copy() in rx_process() that copies the URB
contents to a new SKB is a temporary change to make this patch work
in its own right. This call will be removed when the NAPI processing
is introduced by patch 6 in this patch set.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 282 ++++++++++++++++++++++----------------
 1 file changed, 166 insertions(+), 116 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 7187aac01e7e..3dfd46c91093 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -102,6 +102,20 @@
 #define TX_HS_URB_SIZE			(16 * 1024)
 #define TX_FS_URB_SIZE			(10 * 1024)
 
+#define RX_SS_URB_NUM			30
+#define RX_HS_URB_NUM			10
+#define RX_FS_URB_NUM			10
+#define RX_SS_URB_SIZE			TX_SS_URB_SIZE
+#define RX_HS_URB_SIZE			TX_HS_URB_SIZE
+#define RX_FS_URB_SIZE			TX_FS_URB_SIZE
+
+#define SS_BURST_CAP_SIZE		RX_SS_URB_SIZE
+#define SS_BULK_IN_DELAY		0x2000
+#define HS_BURST_CAP_SIZE		RX_HS_URB_SIZE
+#define HS_BULK_IN_DELAY		0x2000
+#define FS_BURST_CAP_SIZE		RX_FS_URB_SIZE
+#define FS_BULK_IN_DELAY		0x2000
+
 #define TX_CMD_LEN			8
 #define TX_SKB_MIN_LEN			(TX_CMD_LEN + ETH_HLEN)
 #define LAN78XX_TSO_SIZE(dev)		((dev)->tx_urb_size - TX_SKB_MIN_LEN)
@@ -403,11 +417,13 @@ struct lan78xx_net {
 
 	unsigned int		tx_pend_data_len;
 	size_t			n_tx_urbs;
+	size_t			n_rx_urbs;
 	size_t			tx_urb_size;
+	size_t			rx_urb_size;
 
-	int			rx_qlen;
+	struct sk_buff_head	rxq_free;
 	struct sk_buff_head	rxq;
-	struct sk_buff_head	done;
+	struct sk_buff_head	rxq_done;
 	struct sk_buff_head	txq_free;
 	struct sk_buff_head	txq;
 	struct sk_buff_head	txq_pend;
@@ -425,7 +441,9 @@ struct lan78xx_net {
 	unsigned int		pipe_in, pipe_out, pipe_intr;
 
 	u32			hard_mtu;	/* count any extra framing */
-	size_t			rx_urb_size;	/* size for rx urbs */
+
+	unsigned int		bulk_in_delay;
+	unsigned int		burst_cap;
 
 	unsigned long		flags;
 
@@ -542,6 +560,28 @@ static int lan78xx_alloc_buf_pool(struct sk_buff_head *buf_pool,
 	return -ENOMEM;
 }
 
+static struct sk_buff *lan78xx_get_rx_buf(struct lan78xx_net *dev)
+{
+	return lan78xx_get_buf(&dev->rxq_free);
+}
+
+static void lan78xx_release_rx_buf(struct lan78xx_net *dev,
+				   struct sk_buff *rx_buf)
+{
+	lan78xx_release_buf(&dev->rxq_free, rx_buf);
+}
+
+static void lan78xx_free_rx_resources(struct lan78xx_net *dev)
+{
+	lan78xx_free_buf_pool(&dev->rxq_free);
+}
+
+static int lan78xx_alloc_rx_resources(struct lan78xx_net *dev)
+{
+	return lan78xx_alloc_buf_pool(&dev->rxq_free,
+				      dev->n_rx_urbs, dev->rx_urb_size, dev);
+}
+
 static struct sk_buff *lan78xx_get_tx_buf(struct lan78xx_net *dev)
 {
 	return lan78xx_get_buf(&dev->txq_free);
@@ -1321,6 +1361,8 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
 	return 0;
 }
 
+static void lan78xx_rx_urb_submit_all(struct lan78xx_net *dev);
+
 static int lan78xx_mac_reset(struct lan78xx_net *dev)
 {
 	unsigned long start_time = jiffies;
@@ -1452,6 +1494,8 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 				  jiffies + STAT_UPDATE_TIMER);
 		}
 
+		lan78xx_rx_urb_submit_all(dev);
+
 		tasklet_schedule(&dev->bh);
 	}
 
@@ -2684,16 +2728,28 @@ static int lan78xx_urb_config_init(struct lan78xx_net *dev)
 
 	switch (dev->udev->speed) {
 	case USB_SPEED_SUPER:
+		dev->rx_urb_size = RX_SS_URB_SIZE;
 		dev->tx_urb_size = TX_SS_URB_SIZE;
+		dev->n_rx_urbs = RX_SS_URB_NUM;
 		dev->n_tx_urbs = TX_SS_URB_NUM;
+		dev->bulk_in_delay = SS_BULK_IN_DELAY;
+		dev->burst_cap = SS_BURST_CAP_SIZE / SS_USB_PKT_SIZE;
 		break;
 	case USB_SPEED_HIGH:
+		dev->rx_urb_size = RX_HS_URB_SIZE;
 		dev->tx_urb_size = TX_HS_URB_SIZE;
+		dev->n_rx_urbs = RX_HS_URB_NUM;
 		dev->n_tx_urbs = TX_HS_URB_NUM;
+		dev->bulk_in_delay = HS_BULK_IN_DELAY;
+		dev->burst_cap = HS_BURST_CAP_SIZE / HS_USB_PKT_SIZE;
 		break;
 	case USB_SPEED_FULL:
+		dev->rx_urb_size = RX_FS_URB_SIZE;
 		dev->tx_urb_size = TX_FS_URB_SIZE;
+		dev->n_rx_urbs = RX_FS_URB_NUM;
 		dev->n_tx_urbs = TX_FS_URB_NUM;
+		dev->bulk_in_delay = FS_BULK_IN_DELAY;
+		dev->burst_cap = FS_BURST_CAP_SIZE / FS_USB_PKT_SIZE;
 		break;
 	default:
 		netdev_warn(dev->net, "USB bus speed not supported\n");
@@ -2911,25 +2967,11 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 	/* Init LTM */
 	lan78xx_init_ltm(dev);
 
-	if (dev->udev->speed == USB_SPEED_SUPER) {
-		buf = DEFAULT_BURST_CAP_SIZE / SS_USB_PKT_SIZE;
-		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
-		dev->rx_qlen = 4;
-	} else if (dev->udev->speed == USB_SPEED_HIGH) {
-		buf = DEFAULT_BURST_CAP_SIZE / HS_USB_PKT_SIZE;
-		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
-		dev->rx_qlen = RX_MAX_QUEUE_MEMORY / dev->rx_urb_size;
-	} else {
-		buf = DEFAULT_BURST_CAP_SIZE / FS_USB_PKT_SIZE;
-		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
-		dev->rx_qlen = 4;
-	}
-
-	ret = lan78xx_write_reg(dev, BURST_CAP, buf);
+	ret = lan78xx_write_reg(dev, BURST_CAP, dev->burst_cap);
 	if (ret < 0)
 		return ret;
 
-	ret = lan78xx_write_reg(dev, BULK_IN_DLY, DEFAULT_BULK_IN_DELAY);
+	ret = lan78xx_write_reg(dev, BULK_IN_DLY, dev->bulk_in_delay);
 	if (ret < 0)
 		return ret;
 
@@ -3155,14 +3197,12 @@ static void lan78xx_terminate_urbs(struct lan78xx_net *dev)
 	dev->wait = NULL;
 	remove_wait_queue(&unlink_wakeup, &wait);
 
-	while (!skb_queue_empty(&dev->done)) {
-		struct skb_data *entry;
-		struct sk_buff *skb;
+	/* empty Rx done and Tx pend queues
+	 */
+	while (!skb_queue_empty(&dev->rxq_done)) {
+		struct sk_buff *skb = skb_dequeue(&dev->rxq_done);
 
-		skb = skb_dequeue(&dev->done);
-		entry = (struct skb_data *)(skb->cb);
-		usb_free_urb(entry->urb);
-		dev_kfree_skb(skb);
+		lan78xx_release_rx_buf(dev, skb);
 	}
 
 	skb_queue_purge(&dev->txq_pend);
@@ -3230,12 +3270,12 @@ static enum skb_state defer_bh(struct lan78xx_net *dev, struct sk_buff *skb,
 
 	__skb_unlink(skb, list);
 	spin_unlock(&list->lock);
-	spin_lock(&dev->done.lock);
+	spin_lock(&dev->rxq_done.lock);
 
-	__skb_queue_tail(&dev->done, skb);
-	if (skb_queue_len(&dev->done) == 1)
+	__skb_queue_tail(&dev->rxq_done, skb);
+	if (skb_queue_len(&dev->rxq_done) == 1)
 		tasklet_schedule(&dev->bh);
-	spin_unlock_irqrestore(&dev->done.lock, flags);
+	spin_unlock_irqrestore(&dev->rxq_done.lock, flags);
 
 	return old_state;
 }
@@ -3624,43 +3664,32 @@ static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb)
 
 static inline void rx_process(struct lan78xx_net *dev, struct sk_buff *skb)
 {
-	if (!lan78xx_rx(dev, skb)) {
+	struct sk_buff *rx_buf = skb_copy(skb, GFP_ATOMIC);
+
+	if (!lan78xx_rx(dev, rx_buf)) {
 		dev->net->stats.rx_errors++;
-		goto done;
+		return;
 	}
 
-	if (skb->len) {
-		lan78xx_skb_return(dev, skb);
+	if (rx_buf->len) {
+		lan78xx_skb_return(dev, rx_buf);
 		return;
 	}
 
 	netif_dbg(dev, rx_err, dev->net, "drop\n");
 	dev->net->stats.rx_errors++;
-done:
-	skb_queue_tail(&dev->done, skb);
 }
 
 static void rx_complete(struct urb *urb);
 
-static int rx_submit(struct lan78xx_net *dev, struct urb *urb, gfp_t flags)
+static int rx_submit(struct lan78xx_net *dev, struct sk_buff *skb, gfp_t flags)
 {
-	struct sk_buff *skb;
-	struct skb_data *entry;
-	unsigned long lockflags;
+	struct skb_data	*entry = (struct skb_data *)skb->cb;
 	size_t size = dev->rx_urb_size;
+	struct urb *urb = entry->urb;
+	unsigned long lockflags;
 	int ret = 0;
 
-	skb = netdev_alloc_skb_ip_align(dev->net, size);
-	if (!skb) {
-		usb_free_urb(urb);
-		return -ENOMEM;
-	}
-
-	entry = (struct skb_data *)skb->cb;
-	entry->urb = urb;
-	entry->dev = dev;
-	entry->length = 0;
-
 	usb_fill_bulk_urb(urb, dev->udev, dev->pipe_in,
 			  skb->data, size, rx_complete, skb);
 
@@ -3670,7 +3699,7 @@ static int rx_submit(struct lan78xx_net *dev, struct urb *urb, gfp_t flags)
 	    netif_running(dev->net) &&
 	    !test_bit(EVENT_RX_HALT, &dev->flags) &&
 	    !test_bit(EVENT_DEV_ASLEEP, &dev->flags)) {
-		ret = usb_submit_urb(urb, GFP_ATOMIC);
+		ret = usb_submit_urb(urb, flags);
 		switch (ret) {
 		case 0:
 			lan78xx_queue_skb(&dev->rxq, skb, rx_start);
@@ -3685,21 +3714,23 @@ static int rx_submit(struct lan78xx_net *dev, struct urb *urb, gfp_t flags)
 			break;
 		case -EHOSTUNREACH:
 			ret = -ENOLINK;
+			tasklet_schedule(&dev->bh);
 			break;
 		default:
 			netif_dbg(dev, rx_err, dev->net,
 				  "rx submit, %d\n", ret);
 			tasklet_schedule(&dev->bh);
+			break;
 		}
 	} else {
 		netif_dbg(dev, ifdown, dev->net, "rx: stopped\n");
 		ret = -ENOLINK;
 	}
 	spin_unlock_irqrestore(&dev->rxq.lock, lockflags);
-	if (ret) {
-		dev_kfree_skb_any(skb);
-		usb_free_urb(urb);
-	}
+
+	if (ret)
+		lan78xx_release_rx_buf(dev, skb);
+
 	return ret;
 }
 
@@ -3711,9 +3742,14 @@ static void rx_complete(struct urb *urb)
 	int urb_status = urb->status;
 	enum skb_state state;
 
+	netif_dbg(dev, rx_status, dev->net,
+		  "rx done: status %d", urb->status);
+
 	skb_put(skb, urb->actual_length);
 	state = rx_done;
-	entry->urb = NULL;
+
+	if (urb != entry->urb)
+		netif_warn(dev, rx_err, dev->net, "URB pointer mismatch");
 
 	switch (urb_status) {
 	case 0:
@@ -3735,16 +3771,12 @@ static void rx_complete(struct urb *urb)
 		netif_dbg(dev, ifdown, dev->net,
 			  "rx shutdown, code %d\n", urb_status);
 		state = rx_cleanup;
-		entry->urb = urb;
-		urb = NULL;
 		break;
 	case -EPROTO:
 	case -ETIME:
 	case -EILSEQ:
 		dev->net->stats.rx_errors++;
 		state = rx_cleanup;
-		entry->urb = urb;
-		urb = NULL;
 		break;
 
 	/* data overrun ... flush fifo? */
@@ -3760,17 +3792,31 @@ static void rx_complete(struct urb *urb)
 	}
 
 	state = defer_bh(dev, skb, &dev->rxq, state);
+}
 
-	if (urb) {
-		if (netif_running(dev->net) &&
-		    !test_bit(EVENT_RX_HALT, &dev->flags) &&
-		    state != unlink_start) {
-			rx_submit(dev, urb, GFP_ATOMIC);
-			return;
-		}
-		usb_free_urb(urb);
+static void lan78xx_rx_urb_submit_all(struct lan78xx_net *dev)
+{
+	struct sk_buff *rx_buf;
+
+	/* Ensure the maximum number of Rx URBs is submitted
+	 */
+	while ((rx_buf = lan78xx_get_rx_buf(dev)) != NULL) {
+		if (rx_submit(dev, rx_buf, GFP_ATOMIC) != 0)
+			break;
 	}
-	netif_dbg(dev, rx_err, dev->net, "no read resubmitted\n");
+}
+
+static void lan78xx_rx_urb_resubmit(struct lan78xx_net *dev,
+				    struct sk_buff *rx_buf)
+{
+	/* reset SKB data pointers */
+
+	rx_buf->data = rx_buf->head;
+	skb_reset_tail_pointer(rx_buf);
+	rx_buf->len = 0;
+	rx_buf->data_len = 0;
+
+	rx_submit(dev, rx_buf, GFP_ATOMIC);
 }
 
 static void lan78xx_fill_tx_cmd_words(struct sk_buff *skb, u8 *buffer)
@@ -3960,47 +4006,41 @@ static void lan78xx_tx_bh(struct lan78xx_net *dev)
 	} while (ret == 0);
 }
 
-static void lan78xx_rx_bh(struct lan78xx_net *dev)
-{
-	struct urb *urb;
-	int i;
-
-	if (skb_queue_len(&dev->rxq) < dev->rx_qlen) {
-		for (i = 0; i < 10; i++) {
-			if (skb_queue_len(&dev->rxq) >= dev->rx_qlen)
-				break;
-			urb = usb_alloc_urb(0, GFP_ATOMIC);
-			if (urb)
-				if (rx_submit(dev, urb, GFP_ATOMIC) == -ENOLINK)
-					return;
-		}
-
-		if (skb_queue_len(&dev->rxq) < dev->rx_qlen)
-			tasklet_schedule(&dev->bh);
-	}
-}
-
 static void lan78xx_bh(struct tasklet_struct *t)
 {
 	struct lan78xx_net *dev = from_tasklet(dev, t, bh);
-	struct sk_buff *skb;
+	struct sk_buff_head done;
+	struct sk_buff *rx_buf;
 	struct skb_data *entry;
+	unsigned long flags;
+
+	/* Take a snapshot of the done queue and move items to a
+	 * temporary queue. Rx URB completions will continue to add
+	 * to the done queue.
+	 */
+	__skb_queue_head_init(&done);
+
+	spin_lock_irqsave(&dev->rxq_done.lock, flags);
+	skb_queue_splice_init(&dev->rxq_done, &done);
+	spin_unlock_irqrestore(&dev->rxq_done.lock, flags);
 
-	while ((skb = skb_dequeue(&dev->done))) {
-		entry = (struct skb_data *)(skb->cb);
+	/* Extract receive frames from completed URBs and
+	 * pass them to the stack. Re-submit each completed URB.
+	 */
+	while ((rx_buf = __skb_dequeue(&done))) {
+		entry = (struct skb_data *)(rx_buf->cb);
 		switch (entry->state) {
 		case rx_done:
-			entry->state = rx_cleanup;
-			rx_process(dev, skb);
-			continue;
+			rx_process(dev, rx_buf);
+			break;
 		case rx_cleanup:
-			usb_free_urb(entry->urb);
-			dev_kfree_skb(skb);
-			continue;
+			break;
 		default:
 			netdev_dbg(dev->net, "skb state %d\n", entry->state);
-			return;
+			break;
 		}
+
+		lan78xx_rx_urb_resubmit(dev, rx_buf);
 	}
 
 	if (netif_device_present(dev->net) && netif_running(dev->net)) {
@@ -4012,11 +4052,14 @@ static void lan78xx_bh(struct tasklet_struct *t)
 		}
 
 		if (!test_bit(EVENT_RX_HALT, &dev->flags))
-			lan78xx_rx_bh(dev);
+			lan78xx_rx_urb_submit_all(dev);
 
 		lan78xx_tx_bh(dev);
 
-		if (!skb_queue_empty(&dev->done)) {
+		/* Start a new polling cycle if data was received or
+		 * data is waiting to be transmitted.
+		 */
+		if (!skb_queue_empty(&dev->rxq_done)) {
 			tasklet_schedule(&dev->bh);
 		} else if (netif_carrier_ok(dev->net)) {
 			if (skb_queue_empty(&dev->txq) &&
@@ -4196,6 +4239,7 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 	lan78xx_unbind(dev, intf);
 
 	lan78xx_free_tx_resources(dev);
+	lan78xx_free_rx_resources(dev);
 
 	usb_kill_urb(dev->urb_intr);
 	usb_free_urb(dev->urb_intr);
@@ -4284,7 +4328,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	skb_queue_head_init(&dev->rxq);
 	skb_queue_head_init(&dev->txq);
-	skb_queue_head_init(&dev->done);
+	skb_queue_head_init(&dev->rxq_done);
 	skb_queue_head_init(&dev->txq_pend);
 	mutex_init(&dev->phy_mutex);
 	mutex_init(&dev->dev_mutex);
@@ -4297,6 +4341,10 @@ static int lan78xx_probe(struct usb_interface *intf,
 	if (ret < 0)
 		goto out2;
 
+	ret = lan78xx_alloc_rx_resources(dev);
+	if (ret < 0)
+		goto out3;
+
 	netif_set_gso_max_size(netdev, LAN78XX_TSO_SIZE(dev));
 
 	tasklet_setup(&dev->bh, lan78xx_bh);
@@ -4314,27 +4362,27 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	if (intf->cur_altsetting->desc.bNumEndpoints < 3) {
 		ret = -ENODEV;
-		goto out3;
+		goto out4;
 	}
 
 	dev->pipe_in = usb_rcvbulkpipe(udev, BULK_IN_PIPE);
 	ep_blkin = usb_pipe_endpoint(udev, dev->pipe_in);
 	if (!ep_blkin || !usb_endpoint_is_bulk_in(&ep_blkin->desc)) {
 		ret = -ENODEV;
-		goto out3;
+		goto out4;
 	}
 
 	dev->pipe_out = usb_sndbulkpipe(udev, BULK_OUT_PIPE);
 	ep_blkout = usb_pipe_endpoint(udev, dev->pipe_out);
 	if (!ep_blkout || !usb_endpoint_is_bulk_out(&ep_blkout->desc)) {
 		ret = -ENODEV;
-		goto out3;
+		goto out4;
 	}
 
 	ep_intr = &intf->cur_altsetting->endpoint[2];
 	if (!usb_endpoint_is_int_in(&ep_intr->desc)) {
 		ret = -ENODEV;
-		goto out3;
+		goto out4;
 	}
 
 	dev->pipe_intr = usb_rcvintpipe(dev->udev,
@@ -4342,7 +4390,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	ret = lan78xx_bind(dev, intf);
 	if (ret < 0)
-		goto out3;
+		goto out4;
 
 	if (netdev->mtu > (dev->hard_mtu - netdev->hard_header_len))
 		netdev->mtu = dev->hard_mtu - netdev->hard_header_len;
@@ -4356,13 +4404,13 @@ static int lan78xx_probe(struct usb_interface *intf,
 	buf = kmalloc(maxp, GFP_KERNEL);
 	if (!buf) {
 		ret = -ENOMEM;
-		goto out4;
+		goto out5;
 	}
 
 	dev->urb_intr = usb_alloc_urb(0, GFP_KERNEL);
 	if (!dev->urb_intr) {
 		ret = -ENOMEM;
-		goto out5;
+		goto out6;
 	} else {
 		usb_fill_int_urb(dev->urb_intr, dev->udev,
 				 dev->pipe_intr, buf, maxp,
@@ -4383,12 +4431,12 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	ret = lan78xx_phy_init(dev);
 	if (ret < 0)
-		goto out6;
+		goto out7;
 
 	ret = register_netdev(netdev);
 	if (ret != 0) {
 		netif_err(dev, probe, netdev, "couldn't register the device\n");
-		goto out7;
+		goto out8;
 	}
 
 	usb_set_intfdata(intf, dev);
@@ -4403,14 +4451,16 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	return 0;
 
-out7:
+out8:
 	phy_disconnect(netdev->phydev);
-out6:
+out7:
 	usb_free_urb(dev->urb_intr);
-out5:
+out6:
 	kfree(buf);
-out4:
+out5:
 	lan78xx_unbind(dev, intf);
+out4:
+	lan78xx_free_rx_resources(dev);
 out3:
 	lan78xx_free_tx_resources(dev);
 out2:
-- 
2.25.1

