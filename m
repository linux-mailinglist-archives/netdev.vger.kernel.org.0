Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4164559E1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344024AbhKRLQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:16:58 -0500
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:4136 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343852AbhKRLOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:14:48 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Nov 2021 06:14:48 EST
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id E812222797;
        Thu, 18 Nov 2021 11:02:12 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-39-10.trex.outbound.svc.cluster.local [100.96.39.10])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 542F22270C;
        Thu, 18 Nov 2021 11:02:11 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.39.10 (trex/6.4.3);
        Thu, 18 Nov 2021 11:02:12 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Turn-Squirrel: 5f390aee29b3bc20_1637233332646_2805523782
X-MC-Loop-Signature: 1637233332646:1920807150
X-MC-Ingress-Time: 1637233332646
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GQlIvrMBCGyT0yetGESs8PTQDWcCTJxfvEYt67ZDK/0=; b=DeDtero2uPoiduUv+u6WDUCw31
        YdgbF/YZmW+2GjoIIia84FEqGXB8GaP8I8JpXCBHiJFE+BCr8tdIw0z79FX4GKh6zYAy8oJ9khwEL
        Ymb//2TmlvY5CE9GiE2UsodEBWO1hjKycxpS6ZyDQC8WKOLZVv004+fXio3egBkl5vZLIxicFl9uf
        rNvzyeLSkM8Fhgbp736WtLH3quXdqlOXDpwfjUwMakh1IAcR7zQcNAhVe2t0xaMych4ictaawlraM
        7i4jAsboNUhETfLcsKHSC63j7kgxtwL6GfX67bJw/xjQH0wm0KnhoJ3GnAdvfo3wgC/A5BdqLXf7z
        zgoJbhFg==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:46024 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mnfBD-004NG9-5K; Thu, 18 Nov 2021 11:02:09 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 2/6] lan78xx: Introduce Tx URB processing improvements
Date:   Thu, 18 Nov 2021 11:01:35 +0000
Message-Id: <20211118110139.7321-3-john.efstathiades@pebblebay.com>
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
Tx URBs that contributes to improving driver throughput and reducing
CPU load.

A pool of Tx URBs is created during driver instantiation. A URB is
allocated from the pool when there is data to transmit. The URB is
released back to the pool when the data has been transmitted by the
device.

The default URB buffer size is different for each USB bus speed.
The chosen sizes provide good USB utilisation with little impact on
overall packet latency.

SKBs to be transmitted are added to a pending queue for processing.
The driver tracks the available Tx URB buffer space and copies as
much pending data as possible into each free URB. Each full URB
is then submitted to the USB host controller for transmission.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 674 ++++++++++++++++++++++++++------------
 1 file changed, 461 insertions(+), 213 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3ddacc6239a3..7187aac01e7e 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -68,6 +68,7 @@
 #define DEFAULT_VLAN_FILTER_ENABLE	(true)
 #define DEFAULT_VLAN_RX_OFFLOAD		(true)
 #define TX_OVERHEAD			(8)
+#define TX_ALIGNMENT			(4)
 #define RXW_PADDING			2
 
 #define LAN78XX_USB_VENDOR_ID		(0x0424)
@@ -90,6 +91,21 @@
 					 WAKE_MCAST | WAKE_BCAST | \
 					 WAKE_ARP | WAKE_MAGIC)
 
+#define TX_URB_NUM			10
+#define TX_SS_URB_NUM			TX_URB_NUM
+#define TX_HS_URB_NUM			TX_URB_NUM
+#define TX_FS_URB_NUM			TX_URB_NUM
+
+/* A single URB buffer must be large enough to hold a complete jumbo packet
+ */
+#define TX_SS_URB_SIZE			(32 * 1024)
+#define TX_HS_URB_SIZE			(16 * 1024)
+#define TX_FS_URB_SIZE			(10 * 1024)
+
+#define TX_CMD_LEN			8
+#define TX_SKB_MIN_LEN			(TX_CMD_LEN + ETH_HLEN)
+#define LAN78XX_TSO_SIZE(dev)		((dev)->tx_urb_size - TX_SKB_MIN_LEN)
+
 /* USB related defines */
 #define BULK_IN_PIPE			1
 #define BULK_OUT_PIPE			2
@@ -385,11 +401,15 @@ struct lan78xx_net {
 	struct usb_interface	*intf;
 	void			*driver_priv;
 
+	unsigned int		tx_pend_data_len;
+	size_t			n_tx_urbs;
+	size_t			tx_urb_size;
+
 	int			rx_qlen;
-	int			tx_qlen;
 	struct sk_buff_head	rxq;
-	struct sk_buff_head	txq;
 	struct sk_buff_head	done;
+	struct sk_buff_head	txq_free;
+	struct sk_buff_head	txq;
 	struct sk_buff_head	txq_pend;
 
 	struct tasklet_struct	bh;
@@ -443,6 +463,107 @@ static int msg_level = -1;
 module_param(msg_level, int, 0);
 MODULE_PARM_DESC(msg_level, "Override default message level");
 
+static struct sk_buff *lan78xx_get_buf(struct sk_buff_head *buf_pool)
+{
+	if (skb_queue_empty(buf_pool))
+		return NULL;
+
+	return skb_dequeue(buf_pool);
+}
+
+static void lan78xx_release_buf(struct sk_buff_head *buf_pool,
+				struct sk_buff *buf)
+{
+	buf->data = buf->head;
+	skb_reset_tail_pointer(buf);
+
+	buf->len = 0;
+	buf->data_len = 0;
+
+	skb_queue_tail(buf_pool, buf);
+}
+
+static void lan78xx_free_buf_pool(struct sk_buff_head *buf_pool)
+{
+	struct skb_data *entry;
+	struct sk_buff *buf;
+
+	while (!skb_queue_empty(buf_pool)) {
+		buf = skb_dequeue(buf_pool);
+		if (buf) {
+			entry = (struct skb_data *)buf->cb;
+			usb_free_urb(entry->urb);
+			dev_kfree_skb_any(buf);
+		}
+	}
+}
+
+static int lan78xx_alloc_buf_pool(struct sk_buff_head *buf_pool,
+				  size_t n_urbs, size_t urb_size,
+				  struct lan78xx_net *dev)
+{
+	struct skb_data *entry;
+	struct sk_buff *buf;
+	struct urb *urb;
+	int i;
+
+	skb_queue_head_init(buf_pool);
+
+	for (i = 0; i < n_urbs; i++) {
+		buf = alloc_skb(urb_size, GFP_ATOMIC);
+		if (!buf)
+			goto error;
+
+		if (skb_linearize(buf) != 0) {
+			dev_kfree_skb_any(buf);
+			goto error;
+		}
+
+		urb = usb_alloc_urb(0, GFP_ATOMIC);
+		if (!urb) {
+			dev_kfree_skb_any(buf);
+			goto error;
+		}
+
+		entry = (struct skb_data *)buf->cb;
+		entry->urb = urb;
+		entry->dev = dev;
+		entry->length = 0;
+		entry->num_of_packet = 0;
+
+		skb_queue_tail(buf_pool, buf);
+	}
+
+	return 0;
+
+error:
+	lan78xx_free_buf_pool(buf_pool);
+
+	return -ENOMEM;
+}
+
+static struct sk_buff *lan78xx_get_tx_buf(struct lan78xx_net *dev)
+{
+	return lan78xx_get_buf(&dev->txq_free);
+}
+
+static void lan78xx_release_tx_buf(struct lan78xx_net *dev,
+				   struct sk_buff *tx_buf)
+{
+	lan78xx_release_buf(&dev->txq_free, tx_buf);
+}
+
+static void lan78xx_free_tx_resources(struct lan78xx_net *dev)
+{
+	lan78xx_free_buf_pool(&dev->txq_free);
+}
+
+static int lan78xx_alloc_tx_resources(struct lan78xx_net *dev)
+{
+	return lan78xx_alloc_buf_pool(&dev->txq_free,
+				      dev->n_tx_urbs, dev->tx_urb_size, dev);
+}
+
 static int lan78xx_read_reg(struct lan78xx_net *dev, u32 index, u32 *data)
 {
 	u32 *buf;
@@ -2557,6 +2678,32 @@ static void lan78xx_init_ltm(struct lan78xx_net *dev)
 	lan78xx_write_reg(dev, LTM_INACTIVE1, regs[5]);
 }
 
+static int lan78xx_urb_config_init(struct lan78xx_net *dev)
+{
+	int result = 0;
+
+	switch (dev->udev->speed) {
+	case USB_SPEED_SUPER:
+		dev->tx_urb_size = TX_SS_URB_SIZE;
+		dev->n_tx_urbs = TX_SS_URB_NUM;
+		break;
+	case USB_SPEED_HIGH:
+		dev->tx_urb_size = TX_HS_URB_SIZE;
+		dev->n_tx_urbs = TX_HS_URB_NUM;
+		break;
+	case USB_SPEED_FULL:
+		dev->tx_urb_size = TX_FS_URB_SIZE;
+		dev->n_tx_urbs = TX_FS_URB_NUM;
+		break;
+	default:
+		netdev_warn(dev->net, "USB bus speed not supported\n");
+		result = -EIO;
+		break;
+	}
+
+	return result;
+}
+
 static int lan78xx_start_hw(struct lan78xx_net *dev, u32 reg, u32 hw_enable)
 {
 	return lan78xx_update_reg(dev, reg, hw_enable, hw_enable);
@@ -2768,17 +2915,14 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 		buf = DEFAULT_BURST_CAP_SIZE / SS_USB_PKT_SIZE;
 		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
 		dev->rx_qlen = 4;
-		dev->tx_qlen = 4;
 	} else if (dev->udev->speed == USB_SPEED_HIGH) {
 		buf = DEFAULT_BURST_CAP_SIZE / HS_USB_PKT_SIZE;
 		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
 		dev->rx_qlen = RX_MAX_QUEUE_MEMORY / dev->rx_urb_size;
-		dev->tx_qlen = RX_MAX_QUEUE_MEMORY / dev->hard_mtu;
 	} else {
 		buf = DEFAULT_BURST_CAP_SIZE / FS_USB_PKT_SIZE;
 		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
 		dev->rx_qlen = 4;
-		dev->tx_qlen = 4;
 	}
 
 	ret = lan78xx_write_reg(dev, BURST_CAP, buf);
@@ -3020,6 +3164,8 @@ static void lan78xx_terminate_urbs(struct lan78xx_net *dev)
 		usb_free_urb(entry->urb);
 		dev_kfree_skb(skb);
 	}
+
+	skb_queue_purge(&dev->txq_pend);
 }
 
 static int lan78xx_stop(struct net_device *net)
@@ -3071,48 +3217,6 @@ static int lan78xx_stop(struct net_device *net)
 	return 0;
 }
 
-static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
-				       struct sk_buff *skb, gfp_t flags)
-{
-	u32 tx_cmd_a, tx_cmd_b;
-	void *ptr;
-
-	if (skb_cow_head(skb, TX_OVERHEAD)) {
-		dev_kfree_skb_any(skb);
-		return NULL;
-	}
-
-	if (skb_linearize(skb)) {
-		dev_kfree_skb_any(skb);
-		return NULL;
-	}
-
-	tx_cmd_a = (u32)(skb->len & TX_CMD_A_LEN_MASK_) | TX_CMD_A_FCS_;
-
-	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		tx_cmd_a |= TX_CMD_A_IPE_ | TX_CMD_A_TPE_;
-
-	tx_cmd_b = 0;
-	if (skb_is_gso(skb)) {
-		u16 mss = max(skb_shinfo(skb)->gso_size, TX_CMD_B_MSS_MIN_);
-
-		tx_cmd_b = (mss << TX_CMD_B_MSS_SHIFT_) & TX_CMD_B_MSS_MASK_;
-
-		tx_cmd_a |= TX_CMD_A_LSO_;
-	}
-
-	if (skb_vlan_tag_present(skb)) {
-		tx_cmd_a |= TX_CMD_A_IVTG_;
-		tx_cmd_b |= skb_vlan_tag_get(skb) & TX_CMD_B_VTAG_MASK_;
-	}
-
-	ptr = skb_push(skb, 8);
-	put_unaligned_le32(tx_cmd_a, ptr);
-	put_unaligned_le32(tx_cmd_b, ptr + 4);
-
-	return skb;
-}
-
 static enum skb_state defer_bh(struct lan78xx_net *dev, struct sk_buff *skb,
 			       struct sk_buff_head *list, enum skb_state state)
 {
@@ -3146,7 +3250,7 @@ static void tx_complete(struct urb *urb)
 		dev->net->stats.tx_packets += entry->num_of_packet;
 		dev->net->stats.tx_bytes += entry->length;
 	} else {
-		dev->net->stats.tx_errors++;
+		dev->net->stats.tx_errors += entry->num_of_packet;
 
 		switch (urb->status) {
 		case -EPIPE:
@@ -3179,7 +3283,15 @@ static void tx_complete(struct urb *urb)
 
 	usb_autopm_put_interface_async(dev->intf);
 
-	defer_bh(dev, skb, &dev->txq, tx_done);
+	skb_unlink(skb, &dev->txq);
+
+	lan78xx_release_tx_buf(dev, skb);
+
+	/* Re-schedule tasklet if Tx data pending but no URBs in progress.
+	 */
+	if (skb_queue_empty(&dev->txq) &&
+	    !skb_queue_empty(&dev->txq_pend))
+		tasklet_schedule(&dev->bh);
 }
 
 static void lan78xx_queue_skb(struct sk_buff_head *list,
@@ -3191,35 +3303,96 @@ static void lan78xx_queue_skb(struct sk_buff_head *list,
 	entry->state = state;
 }
 
+static unsigned int lan78xx_tx_urb_space(struct lan78xx_net *dev)
+{
+	return skb_queue_len(&dev->txq_free) * dev->tx_urb_size;
+}
+
+static unsigned int lan78xx_tx_pend_data_len(struct lan78xx_net *dev)
+{
+	return dev->tx_pend_data_len;
+}
+
+static void lan78xx_tx_pend_skb_add(struct lan78xx_net *dev,
+				    struct sk_buff *skb,
+				    unsigned int *tx_pend_data_len)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->txq_pend.lock, flags);
+
+	__skb_queue_tail(&dev->txq_pend, skb);
+
+	dev->tx_pend_data_len += skb->len;
+	*tx_pend_data_len = dev->tx_pend_data_len;
+
+	spin_unlock_irqrestore(&dev->txq_pend.lock, flags);
+}
+
+static void lan78xx_tx_pend_skb_head_add(struct lan78xx_net *dev,
+					 struct sk_buff *skb,
+					 unsigned int *tx_pend_data_len)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->txq_pend.lock, flags);
+
+	__skb_queue_head(&dev->txq_pend, skb);
+
+	dev->tx_pend_data_len += skb->len;
+	*tx_pend_data_len = dev->tx_pend_data_len;
+
+	spin_unlock_irqrestore(&dev->txq_pend.lock, flags);
+}
+
+static void lan78xx_tx_pend_skb_get(struct lan78xx_net *dev,
+				    struct sk_buff **skb,
+				    unsigned int *tx_pend_data_len)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->txq_pend.lock, flags);
+
+	*skb = __skb_dequeue(&dev->txq_pend);
+	if (*skb)
+		dev->tx_pend_data_len -= (*skb)->len;
+	*tx_pend_data_len = dev->tx_pend_data_len;
+
+	spin_unlock_irqrestore(&dev->txq_pend.lock, flags);
+}
+
 static netdev_tx_t
 lan78xx_start_xmit(struct sk_buff *skb, struct net_device *net)
 {
 	struct lan78xx_net *dev = netdev_priv(net);
-	struct sk_buff *skb2 = NULL;
+	unsigned int tx_pend_data_len;
 
 	if (test_bit(EVENT_DEV_ASLEEP, &dev->flags))
 		schedule_delayed_work(&dev->wq, 0);
 
-	if (skb) {
-		skb_tx_timestamp(skb);
-		skb2 = lan78xx_tx_prep(dev, skb, GFP_ATOMIC);
-	}
+	skb_tx_timestamp(skb);
 
-	if (skb2) {
-		skb_queue_tail(&dev->txq_pend, skb2);
+	lan78xx_tx_pend_skb_add(dev, skb, &tx_pend_data_len);
 
-		/* throttle TX patch at slower than SUPER SPEED USB */
-		if ((dev->udev->speed < USB_SPEED_SUPER) &&
-		    (skb_queue_len(&dev->txq_pend) > 10))
-			netif_stop_queue(net);
-	} else {
-		netif_dbg(dev, tx_err, dev->net,
-			  "lan78xx_tx_prep return NULL\n");
-		dev->net->stats.tx_errors++;
-		dev->net->stats.tx_dropped++;
-	}
+	/* Set up a Tx URB if none is in progress */
 
-	tasklet_schedule(&dev->bh);
+	if (skb_queue_empty(&dev->txq))
+		tasklet_schedule(&dev->bh);
+
+	/* Stop stack Tx queue if we have enough data to fill
+	 * all the free Tx URBs.
+	 */
+	if (tx_pend_data_len > lan78xx_tx_urb_space(dev)) {
+		netif_stop_queue(net);
+
+		netif_dbg(dev, hw, dev->net, "tx data len: %u, urb space %u",
+			  tx_pend_data_len, lan78xx_tx_urb_space(dev));
+
+		/* Kick off transmission of pending data */
+
+		if (!skb_queue_empty(&dev->txq_free))
+			tasklet_schedule(&dev->bh);
+	}
 
 	return NETDEV_TX_OK;
 }
@@ -3600,139 +3773,191 @@ static void rx_complete(struct urb *urb)
 	netif_dbg(dev, rx_err, dev->net, "no read resubmitted\n");
 }
 
-static void lan78xx_tx_bh(struct lan78xx_net *dev)
+static void lan78xx_fill_tx_cmd_words(struct sk_buff *skb, u8 *buffer)
 {
-	int length;
-	struct urb *urb = NULL;
-	struct skb_data *entry;
-	unsigned long flags;
-	struct sk_buff_head *tqp = &dev->txq_pend;
-	struct sk_buff *skb, *skb2;
-	int ret;
-	int count, pos;
-	int skb_totallen, pkt_cnt;
-
-	skb_totallen = 0;
-	pkt_cnt = 0;
-	count = 0;
-	length = 0;
-	spin_lock_irqsave(&tqp->lock, flags);
-	skb_queue_walk(tqp, skb) {
-		if (skb_is_gso(skb)) {
-			if (!skb_queue_is_first(tqp, skb)) {
-				/* handle previous packets first */
-				break;
-			}
-			count = 1;
-			length = skb->len - TX_OVERHEAD;
-			__skb_unlink(skb, tqp);
-			spin_unlock_irqrestore(&tqp->lock, flags);
-			goto gso_skb;
-		}
+	u32 tx_cmd_a;
+	u32 tx_cmd_b;
 
-		if ((skb_totallen + skb->len) > MAX_SINGLE_PACKET_SIZE)
-			break;
-		skb_totallen = skb->len + roundup(skb_totallen, sizeof(u32));
-		pkt_cnt++;
+	tx_cmd_a = (u32)(skb->len & TX_CMD_A_LEN_MASK_) | TX_CMD_A_FCS_;
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL)
+		tx_cmd_a |= TX_CMD_A_IPE_ | TX_CMD_A_TPE_;
+
+	tx_cmd_b = 0;
+	if (skb_is_gso(skb)) {
+		u16 mss = max(skb_shinfo(skb)->gso_size, TX_CMD_B_MSS_MIN_);
+
+		tx_cmd_b = (mss << TX_CMD_B_MSS_SHIFT_) & TX_CMD_B_MSS_MASK_;
+
+		tx_cmd_a |= TX_CMD_A_LSO_;
 	}
-	spin_unlock_irqrestore(&tqp->lock, flags);
-
-	/* copy to a single skb */
-	skb = alloc_skb(skb_totallen, GFP_ATOMIC);
-	if (!skb)
-		goto drop;
-
-	skb_put(skb, skb_totallen);
-
-	for (count = pos = 0; count < pkt_cnt; count++) {
-		skb2 = skb_dequeue(tqp);
-		if (skb2) {
-			length += (skb2->len - TX_OVERHEAD);
-			memcpy(skb->data + pos, skb2->data, skb2->len);
-			pos += roundup(skb2->len, sizeof(u32));
-			dev_kfree_skb(skb2);
-		}
+
+	if (skb_vlan_tag_present(skb)) {
+		tx_cmd_a |= TX_CMD_A_IVTG_;
+		tx_cmd_b |= skb_vlan_tag_get(skb) & TX_CMD_B_VTAG_MASK_;
 	}
 
-gso_skb:
-	urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!urb)
-		goto drop;
+	put_unaligned_le32(tx_cmd_a, buffer);
+	put_unaligned_le32(tx_cmd_b, buffer + 4);
+}
 
-	entry = (struct skb_data *)skb->cb;
-	entry->urb = urb;
-	entry->dev = dev;
-	entry->length = length;
-	entry->num_of_packet = count;
+static struct skb_data *lan78xx_tx_buf_fill(struct lan78xx_net *dev,
+					    struct sk_buff *tx_buf)
+{
+	struct skb_data *entry = (struct skb_data *)tx_buf->cb;
+	int remain = dev->tx_urb_size;
+	u8 *tx_data = tx_buf->data;
+	u32 urb_len = 0;
 
-	spin_lock_irqsave(&dev->txq.lock, flags);
-	ret = usb_autopm_get_interface_async(dev->intf);
-	if (ret < 0) {
-		spin_unlock_irqrestore(&dev->txq.lock, flags);
-		goto drop;
+	entry->num_of_packet = 0;
+	entry->length = 0;
+
+	/* Work through the pending SKBs and copy the data of each SKB into
+	 * the URB buffer if there room for all the SKB data.
+	 *
+	 * There must be at least DST+SRC+TYPE in the SKB (with padding enabled)
+	 */
+	while (remain >= TX_SKB_MIN_LEN) {
+		unsigned int pending_bytes;
+		unsigned int align_bytes;
+		struct sk_buff *skb;
+		unsigned int len;
+
+		lan78xx_tx_pend_skb_get(dev, &skb, &pending_bytes);
+
+		if (!skb)
+			break;
+
+		align_bytes = (TX_ALIGNMENT - (urb_len % TX_ALIGNMENT)) %
+			      TX_ALIGNMENT;
+		len = align_bytes + TX_CMD_LEN + skb->len;
+		if (len > remain) {
+			lan78xx_tx_pend_skb_head_add(dev, skb, &pending_bytes);
+			break;
+		}
+
+		tx_data += align_bytes;
+
+		lan78xx_fill_tx_cmd_words(skb, tx_data);
+		tx_data += TX_CMD_LEN;
+
+		len = skb->len;
+		if (skb_copy_bits(skb, 0, tx_data, len) < 0) {
+			struct net_device_stats *stats = &dev->net->stats;
+
+			stats->tx_dropped++;
+			dev_kfree_skb_any(skb);
+			tx_data -= TX_CMD_LEN;
+			continue;
+		}
+
+		tx_data += len;
+		entry->length += len;
+		entry->num_of_packet += skb_shinfo(skb)->gso_segs ?: 1;
+
+		dev_kfree_skb_any(skb);
+
+		urb_len = (u32)(tx_data - (u8 *)tx_buf->data);
+
+		remain = dev->tx_urb_size - urb_len;
 	}
 
-	usb_fill_bulk_urb(urb, dev->udev, dev->pipe_out,
-			  skb->data, skb->len, tx_complete, skb);
+	skb_put(tx_buf, urb_len);
+
+	return entry;
+}
+
+static void lan78xx_tx_bh(struct lan78xx_net *dev)
+{
+	int ret;
 
-	if (length % dev->maxpacket == 0) {
-		/* send USB_ZERO_PACKET */
-		urb->transfer_flags |= URB_ZERO_PACKET;
+	/* Start the stack Tx queue if it was stopped
+	 */
+	netif_tx_lock(dev->net);
+	if (netif_queue_stopped(dev->net)) {
+		if (lan78xx_tx_pend_data_len(dev) < lan78xx_tx_urb_space(dev))
+			netif_wake_queue(dev->net);
 	}
+	netif_tx_unlock(dev->net);
+
+	/* Go through the Tx pending queue and set up URBs to transfer
+	 * the data to the device. Stop if no more pending data or URBs,
+	 * or if an error occurs when a URB is submitted.
+	 */
+	do {
+		struct skb_data *entry;
+		struct sk_buff *tx_buf;
+		unsigned long flags;
+
+		if (skb_queue_empty(&dev->txq_pend))
+			break;
+
+		tx_buf = lan78xx_get_tx_buf(dev);
+		if (!tx_buf)
+			break;
+
+		entry = lan78xx_tx_buf_fill(dev, tx_buf);
+
+		spin_lock_irqsave(&dev->txq.lock, flags);
+		ret = usb_autopm_get_interface_async(dev->intf);
+		if (ret < 0) {
+			spin_unlock_irqrestore(&dev->txq.lock, flags);
+			goto out;
+		}
+
+		usb_fill_bulk_urb(entry->urb, dev->udev, dev->pipe_out,
+				  tx_buf->data, tx_buf->len, tx_complete,
+				  tx_buf);
+
+		if (tx_buf->len % dev->maxpacket == 0) {
+			/* send USB_ZERO_PACKET */
+			entry->urb->transfer_flags |= URB_ZERO_PACKET;
+		}
 
 #ifdef CONFIG_PM
-	/* if this triggers the device is still a sleep */
-	if (test_bit(EVENT_DEV_ASLEEP, &dev->flags)) {
-		/* transmission will be done in resume */
-		usb_anchor_urb(urb, &dev->deferred);
-		/* no use to process more packets */
-		netif_stop_queue(dev->net);
-		usb_put_urb(urb);
-		spin_unlock_irqrestore(&dev->txq.lock, flags);
-		netdev_dbg(dev->net, "Delaying transmission for resumption\n");
-		return;
-	}
+		/* if device is asleep stop outgoing packet processing */
+		if (test_bit(EVENT_DEV_ASLEEP, &dev->flags)) {
+			usb_anchor_urb(entry->urb, &dev->deferred);
+			netif_stop_queue(dev->net);
+			spin_unlock_irqrestore(&dev->txq.lock, flags);
+			netdev_dbg(dev->net,
+				   "Delaying transmission for resumption\n");
+			return;
+		}
 #endif
-
-	ret = usb_submit_urb(urb, GFP_ATOMIC);
-	switch (ret) {
-	case 0:
-		netif_trans_update(dev->net);
-		lan78xx_queue_skb(&dev->txq, skb, tx_start);
-		if (skb_queue_len(&dev->txq) >= dev->tx_qlen)
+		ret = usb_submit_urb(entry->urb, GFP_ATOMIC);
+		switch (ret) {
+		case 0:
+			netif_trans_update(dev->net);
+			lan78xx_queue_skb(&dev->txq, tx_buf, tx_start);
+			break;
+		case -EPIPE:
 			netif_stop_queue(dev->net);
-		break;
-	case -EPIPE:
-		netif_stop_queue(dev->net);
-		lan78xx_defer_kevent(dev, EVENT_TX_HALT);
-		usb_autopm_put_interface_async(dev->intf);
-		break;
-	case -ENODEV:
-	case -ENOENT:
-		netif_dbg(dev, tx_err, dev->net,
-			  "tx: submit urb err %d (disconnected?)", ret);
-		netif_device_detach(dev->net);
-		break;
-	default:
-		usb_autopm_put_interface_async(dev->intf);
-		netif_dbg(dev, tx_err, dev->net,
-			  "tx: submit urb err %d\n", ret);
-		break;
-	}
+			lan78xx_defer_kevent(dev, EVENT_TX_HALT);
+			usb_autopm_put_interface_async(dev->intf);
+			break;
+		case -ENODEV:
+		case -ENOENT:
+			netif_dbg(dev, tx_err, dev->net,
+				  "tx submit urb err %d (disconnected?)", ret);
+			netif_device_detach(dev->net);
+			break;
+		default:
+			usb_autopm_put_interface_async(dev->intf);
+			netif_dbg(dev, tx_err, dev->net,
+				  "tx submit urb err %d\n", ret);
+			break;
+		}
 
-	spin_unlock_irqrestore(&dev->txq.lock, flags);
+		spin_unlock_irqrestore(&dev->txq.lock, flags);
 
-	if (ret) {
-		netif_dbg(dev, tx_err, dev->net, "drop, code %d\n", ret);
-drop:
-		dev->net->stats.tx_dropped++;
-		if (skb)
-			dev_kfree_skb_any(skb);
-		usb_free_urb(urb);
-	} else {
-		netif_dbg(dev, tx_queued, dev->net,
-			  "> tx, len %d, type 0x%x\n", length, skb->protocol);
-	}
+		if (ret) {
+			netdev_warn(dev->net, "failed to tx urb %d\n", ret);
+out:
+			dev->net->stats.tx_dropped += entry->num_of_packet;
+			lan78xx_release_tx_buf(dev, tx_buf);
+		}
+	} while (ret == 0);
 }
 
 static void lan78xx_rx_bh(struct lan78xx_net *dev)
@@ -3753,8 +3978,6 @@ static void lan78xx_rx_bh(struct lan78xx_net *dev)
 		if (skb_queue_len(&dev->rxq) < dev->rx_qlen)
 			tasklet_schedule(&dev->bh);
 	}
-	if (skb_queue_len(&dev->txq) < dev->tx_qlen)
-		netif_wake_queue(dev->net);
 }
 
 static void lan78xx_bh(struct tasklet_struct *t)
@@ -3770,10 +3993,6 @@ static void lan78xx_bh(struct tasklet_struct *t)
 			entry->state = rx_cleanup;
 			rx_process(dev, skb);
 			continue;
-		case tx_done:
-			usb_free_urb(entry->urb);
-			dev_kfree_skb(skb);
-			continue;
 		case rx_cleanup:
 			usb_free_urb(entry->urb);
 			dev_kfree_skb(skb);
@@ -3792,11 +4011,26 @@ static void lan78xx_bh(struct tasklet_struct *t)
 				  jiffies + STAT_UPDATE_TIMER);
 		}
 
-		if (!skb_queue_empty(&dev->txq_pend))
-			lan78xx_tx_bh(dev);
-
 		if (!test_bit(EVENT_RX_HALT, &dev->flags))
 			lan78xx_rx_bh(dev);
+
+		lan78xx_tx_bh(dev);
+
+		if (!skb_queue_empty(&dev->done)) {
+			tasklet_schedule(&dev->bh);
+		} else if (netif_carrier_ok(dev->net)) {
+			if (skb_queue_empty(&dev->txq) &&
+			    !skb_queue_empty(&dev->txq_pend)) {
+				tasklet_schedule(&dev->bh);
+			} else {
+				netif_tx_lock(dev->net);
+				if (netif_queue_stopped(dev->net)) {
+					netif_wake_queue(dev->net);
+					tasklet_schedule(&dev->bh);
+				}
+				netif_tx_unlock(dev->net);
+			}
+		}
 	}
 }
 
@@ -3961,6 +4195,8 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 
 	lan78xx_unbind(dev, intf);
 
+	lan78xx_free_tx_resources(dev);
+
 	usb_kill_urb(dev->urb_intr);
 	usb_free_urb(dev->urb_intr);
 
@@ -3980,7 +4216,9 @@ static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
 						struct net_device *netdev,
 						netdev_features_t features)
 {
-	if (skb->len + TX_OVERHEAD > MAX_SINGLE_PACKET_SIZE)
+	struct lan78xx_net *dev = netdev_priv(netdev);
+
+	if (skb->len > LAN78XX_TSO_SIZE(dev))
 		features &= ~NETIF_F_GSO_MASK;
 
 	features = vlan_features_check(skb, features);
@@ -4051,6 +4289,16 @@ static int lan78xx_probe(struct usb_interface *intf,
 	mutex_init(&dev->phy_mutex);
 	mutex_init(&dev->dev_mutex);
 
+	ret = lan78xx_urb_config_init(dev);
+	if (ret < 0)
+		goto out2;
+
+	ret = lan78xx_alloc_tx_resources(dev);
+	if (ret < 0)
+		goto out2;
+
+	netif_set_gso_max_size(netdev, LAN78XX_TSO_SIZE(dev));
+
 	tasklet_setup(&dev->bh, lan78xx_bh);
 	INIT_DELAYED_WORK(&dev->wq, lan78xx_delayedwork);
 	init_usb_anchor(&dev->deferred);
@@ -4066,27 +4314,27 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	if (intf->cur_altsetting->desc.bNumEndpoints < 3) {
 		ret = -ENODEV;
-		goto out2;
+		goto out3;
 	}
 
 	dev->pipe_in = usb_rcvbulkpipe(udev, BULK_IN_PIPE);
 	ep_blkin = usb_pipe_endpoint(udev, dev->pipe_in);
 	if (!ep_blkin || !usb_endpoint_is_bulk_in(&ep_blkin->desc)) {
 		ret = -ENODEV;
-		goto out2;
+		goto out3;
 	}
 
 	dev->pipe_out = usb_sndbulkpipe(udev, BULK_OUT_PIPE);
 	ep_blkout = usb_pipe_endpoint(udev, dev->pipe_out);
 	if (!ep_blkout || !usb_endpoint_is_bulk_out(&ep_blkout->desc)) {
 		ret = -ENODEV;
-		goto out2;
+		goto out3;
 	}
 
 	ep_intr = &intf->cur_altsetting->endpoint[2];
 	if (!usb_endpoint_is_int_in(&ep_intr->desc)) {
 		ret = -ENODEV;
-		goto out2;
+		goto out3;
 	}
 
 	dev->pipe_intr = usb_rcvintpipe(dev->udev,
@@ -4094,7 +4342,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	ret = lan78xx_bind(dev, intf);
 	if (ret < 0)
-		goto out2;
+		goto out3;
 
 	if (netdev->mtu > (dev->hard_mtu - netdev->hard_header_len))
 		netdev->mtu = dev->hard_mtu - netdev->hard_header_len;
@@ -4108,13 +4356,13 @@ static int lan78xx_probe(struct usb_interface *intf,
 	buf = kmalloc(maxp, GFP_KERNEL);
 	if (!buf) {
 		ret = -ENOMEM;
-		goto out3;
+		goto out4;
 	}
 
 	dev->urb_intr = usb_alloc_urb(0, GFP_KERNEL);
 	if (!dev->urb_intr) {
 		ret = -ENOMEM;
-		goto out4;
+		goto out5;
 	} else {
 		usb_fill_int_urb(dev->urb_intr, dev->udev,
 				 dev->pipe_intr, buf, maxp,
@@ -4127,7 +4375,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	/* Reject broken descriptors. */
 	if (dev->maxpacket == 0) {
 		ret = -ENODEV;
-		goto out5;
+		goto out6;
 	}
 
 	/* driver requires remote-wakeup capability during autosuspend. */
@@ -4135,12 +4383,12 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	ret = lan78xx_phy_init(dev);
 	if (ret < 0)
-		goto out5;
+		goto out6;
 
 	ret = register_netdev(netdev);
 	if (ret != 0) {
 		netif_err(dev, probe, netdev, "couldn't register the device\n");
-		goto out6;
+		goto out7;
 	}
 
 	usb_set_intfdata(intf, dev);
@@ -4155,14 +4403,16 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	return 0;
 
-out6:
+out7:
 	phy_disconnect(netdev->phydev);
-out5:
+out6:
 	usb_free_urb(dev->urb_intr);
-out4:
+out5:
 	kfree(buf);
-out3:
+out4:
 	lan78xx_unbind(dev, intf);
+out3:
+	lan78xx_free_tx_resources(dev);
 out2:
 	free_netdev(netdev);
 out1:
@@ -4583,8 +4833,7 @@ static bool lan78xx_submit_deferred_urbs(struct lan78xx_net *dev)
 		if (!netif_device_present(dev->net) ||
 		    !netif_carrier_ok(dev->net) ||
 		    pipe_halted) {
-			usb_free_urb(urb);
-			dev_kfree_skb(skb);
+			lan78xx_release_tx_buf(dev, skb);
 			continue;
 		}
 
@@ -4594,15 +4843,14 @@ static bool lan78xx_submit_deferred_urbs(struct lan78xx_net *dev)
 			netif_trans_update(dev->net);
 			lan78xx_queue_skb(&dev->txq, skb, tx_start);
 		} else {
-			usb_free_urb(urb);
-			dev_kfree_skb(skb);
-
 			if (ret == -EPIPE) {
 				netif_stop_queue(dev->net);
 				pipe_halted = true;
 			} else if (ret == -ENODEV) {
 				netif_device_detach(dev->net);
 			}
+
+			lan78xx_release_tx_buf(dev, skb);
 		}
 	}
 
@@ -4654,7 +4902,7 @@ static int lan78xx_resume(struct usb_interface *intf)
 
 		if (!pipe_halted &&
 		    netif_device_present(dev->net) &&
-		    (skb_queue_len(&dev->txq) < dev->tx_qlen))
+		    (lan78xx_tx_pend_data_len(dev) < lan78xx_tx_urb_space(dev)))
 			netif_start_queue(dev->net);
 
 		ret = lan78xx_start_tx_path(dev);
-- 
2.25.1

