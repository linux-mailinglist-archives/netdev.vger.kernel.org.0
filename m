Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626B730F2C4
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbhBDL4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:56:47 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:55376 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbhBDL4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:56:42 -0500
Received: from [51.148.178.73] (port=37344 helo=pbcl-dsk8.fritz.box)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l7crn-008lpZ-I1; Thu, 04 Feb 2021 11:32:07 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next 1/9] lan78xx: add NAPI interface support
Date:   Thu,  4 Feb 2021 11:31:13 +0000
Message-Id: <20210204113121.29786-2-john.efstathiades@pebblebay.com>
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

Improve driver throughput and reduce CPU overhead by using the NAPI
interface for processing Rx packets and scheduling Tx and Rx URBs.

Provide statically-allocated URB and buffer pool for both Tx and Rx
packets to give greater control over resource allocation.

Remove modification of hard_header_len that prevents correct operation
of generic receive offload (GRO) handling of TCP connections.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 1176 ++++++++++++++++++++++++-------------
 1 file changed, 775 insertions(+), 401 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index e81c5699c952..1c872edc816a 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -47,17 +47,17 @@
 
 #define MAX_RX_FIFO_SIZE		(12 * 1024)
 #define MAX_TX_FIFO_SIZE		(12 * 1024)
-#define DEFAULT_BURST_CAP_SIZE		(MAX_TX_FIFO_SIZE)
-#define DEFAULT_BULK_IN_DELAY		(0x0800)
 #define MAX_SINGLE_PACKET_SIZE		(9000)
 #define DEFAULT_TX_CSUM_ENABLE		(true)
 #define DEFAULT_RX_CSUM_ENABLE		(true)
 #define DEFAULT_TSO_CSUM_ENABLE		(true)
 #define DEFAULT_VLAN_FILTER_ENABLE	(true)
 #define DEFAULT_VLAN_RX_OFFLOAD		(true)
-#define TX_OVERHEAD			(8)
+#define TX_ALIGNMENT			(4)
 #define RXW_PADDING			2
 
+#define MIN_IPV4_DGRAM			68
+
 #define LAN78XX_USB_VENDOR_ID		(0x0424)
 #define LAN7800_USB_PRODUCT_ID		(0x7800)
 #define LAN7850_USB_PRODUCT_ID		(0x7850)
@@ -78,6 +78,44 @@
 					 WAKE_MCAST | WAKE_BCAST | \
 					 WAKE_ARP | WAKE_MAGIC)
 
+#define LAN78XX_NAPI_WEIGHT		64
+
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
+#define TX_CMD_LEN			8
+#define TX_SKB_MIN_LEN			(TX_CMD_LEN + ETH_HLEN)
+#define LAN78XX_TSO_SIZE(dev)		((dev)->tx_urb_size - TX_SKB_MIN_LEN)
+
+#define RX_CMD_LEN			10
+#define RX_SKB_MIN_LEN			(RX_CMD_LEN + ETH_HLEN)
+#define RX_MAX_FRAME_LEN(mtu)		((mtu) + ETH_HLEN + VLAN_HLEN)
+
+#define LAN78XX_MIN_MTU			MIN_IPV4_DGRAM
+#define LAN78XX_MAX_MTU			MAX_SINGLE_PACKET_SIZE
+
 /* USB related defines */
 #define BULK_IN_PIPE			1
 #define BULK_OUT_PIPE			2
@@ -366,15 +404,22 @@ struct lan78xx_net {
 	struct usb_interface	*intf;
 	void			*driver_priv;
 
-	int			rx_qlen;
-	int			tx_qlen;
+	int			tx_pend_data_len;
+	int			n_tx_urbs;
+	int			n_rx_urbs;
+	int			rx_urb_size;
+	int			tx_urb_size;
+
+	struct sk_buff_head	rxq_free;
+	struct sk_buff_head	rxq_overflow;
+	struct sk_buff_head	rxq_done;
 	struct sk_buff_head	rxq;
+	struct sk_buff_head	txq_free;
 	struct sk_buff_head	txq;
-	struct sk_buff_head	done;
-	struct sk_buff_head	rxq_pause;
 	struct sk_buff_head	txq_pend;
 
-	struct tasklet_struct	bh;
+	struct napi_struct	napi;
+
 	struct delayed_work	wq;
 
 	int			msg_enable;
@@ -385,16 +430,15 @@ struct lan78xx_net {
 	struct mutex		phy_mutex; /* for phy access */
 	unsigned		pipe_in, pipe_out, pipe_intr;
 
-	u32			hard_mtu;	/* count any extra framing */
-	size_t			rx_urb_size;	/* size for rx urbs */
+	unsigned int		bulk_in_delay;
+	unsigned int		burst_cap;
 
 	unsigned long		flags;
 
 	wait_queue_head_t	*wait;
 	unsigned char		suspend_count;
 
-	unsigned		maxpacket;
-	struct timer_list	delay;
+	unsigned int		maxpacket;
 	struct timer_list	stat_monitor;
 
 	unsigned long		data[5];
@@ -425,6 +469,128 @@ static int msg_level = -1;
 module_param(msg_level, int, 0);
 MODULE_PARM_DESC(msg_level, "Override default message level");
 
+static inline struct sk_buff *lan78xx_get_buf(struct sk_buff_head *buf_pool)
+{
+	if (!skb_queue_empty(buf_pool))
+		return skb_dequeue(buf_pool);
+	else
+		return NULL;
+}
+
+static inline void lan78xx_free_buf(struct sk_buff_head *buf_pool,
+				    struct sk_buff *buf)
+{
+	buf->data = buf->head;
+	skb_reset_tail_pointer(buf);
+	buf->len = 0;
+	buf->data_len = 0;
+
+	skb_queue_tail(buf_pool, buf);
+}
+
+static void lan78xx_free_buf_pool(struct sk_buff_head *buf_pool)
+{
+	struct sk_buff *buf;
+	struct skb_data *entry;
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
+				  int n_urbs, int urb_size,
+				  struct lan78xx_net *dev)
+{
+	int i;
+	struct sk_buff *buf;
+	struct skb_data *entry;
+	struct urb *urb;
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
+static inline struct sk_buff *lan78xx_get_rx_buf(struct lan78xx_net *dev)
+{
+	return lan78xx_get_buf(&dev->rxq_free);
+}
+
+static inline void lan78xx_free_rx_buf(struct lan78xx_net *dev,
+				       struct sk_buff *rx_buf)
+{
+	lan78xx_free_buf(&dev->rxq_free, rx_buf);
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
+static inline struct sk_buff *lan78xx_get_tx_buf(struct lan78xx_net *dev)
+{
+	return lan78xx_get_buf(&dev->txq_free);
+}
+
+static inline void lan78xx_free_tx_buf(struct lan78xx_net *dev,
+				       struct sk_buff *tx_buf)
+{
+	lan78xx_free_buf(&dev->txq_free, tx_buf);
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
 	u32 *buf = kmalloc(sizeof(u32), GFP_KERNEL);
@@ -1135,7 +1301,7 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
 		flow |= FLOW_CR_RX_FCEN_;
 
 	if (dev->udev->speed == USB_SPEED_SUPER)
-		fct_flow = 0x817;
+		fct_flow = 0x812;
 	else if (dev->udev->speed == USB_SPEED_HIGH)
 		fct_flow = 0x211;
 
@@ -1151,6 +1317,8 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
 	return 0;
 }
 
+static void lan78xx_rx_urb_submit_all(struct lan78xx_net *dev);
+
 static int lan78xx_link_reset(struct lan78xx_net *dev)
 {
 	struct phy_device *phydev = dev->net->phydev;
@@ -1223,7 +1391,9 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 				  jiffies + STAT_UPDATE_TIMER);
 		}
 
-		tasklet_schedule(&dev->bh);
+		lan78xx_rx_urb_submit_all(dev);
+
+		napi_schedule(&dev->napi);
 	}
 
 	return ret;
@@ -2196,7 +2366,8 @@ static int lan78xx_set_rx_max_frame_length(struct lan78xx_net *dev, int size)
 
 	/* add 4 to size for FCS */
 	buf &= ~MAC_RX_MAX_SIZE_MASK_;
-	buf |= (((size + 4) << MAC_RX_MAX_SIZE_SHIFT_) & MAC_RX_MAX_SIZE_MASK_);
+	buf |= (((size + ETH_FCS_LEN) << MAC_RX_MAX_SIZE_SHIFT_) &
+		MAC_RX_MAX_SIZE_MASK_);
 
 	lan78xx_write_reg(dev, MAC_RX, buf);
 
@@ -2256,28 +2427,26 @@ static int unlink_urbs(struct lan78xx_net *dev, struct sk_buff_head *q)
 static int lan78xx_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct lan78xx_net *dev = netdev_priv(netdev);
-	int ll_mtu = new_mtu + netdev->hard_header_len;
-	int old_hard_mtu = dev->hard_mtu;
-	int old_rx_urb_size = dev->rx_urb_size;
+	int max_frame_len = RX_MAX_FRAME_LEN(new_mtu);
+	int ret;
+
+	if (new_mtu < LAN78XX_MIN_MTU ||
+	    new_mtu > LAN78XX_MAX_MTU)
+		return -EINVAL;
 
 	/* no second zero-length packet read wanted after mtu-sized packets */
-	if ((ll_mtu % dev->maxpacket) == 0)
+	if ((max_frame_len % dev->maxpacket) == 0)
 		return -EDOM;
 
-	lan78xx_set_rx_max_frame_length(dev, new_mtu + VLAN_ETH_HLEN);
+	ret = usb_autopm_get_interface(dev->intf);
+	if (ret < 0)
+		return ret;
+
+	ret = lan78xx_set_rx_max_frame_length(dev, max_frame_len);
 
 	netdev->mtu = new_mtu;
 
-	dev->hard_mtu = netdev->mtu + netdev->hard_header_len;
-	if (dev->rx_urb_size == old_hard_mtu) {
-		dev->rx_urb_size = dev->hard_mtu;
-		if (dev->rx_urb_size > old_rx_urb_size) {
-			if (netif_running(dev->net)) {
-				unlink_urbs(dev, &dev->rxq);
-				tasklet_schedule(&dev->bh);
-			}
-		}
-	}
+	usb_autopm_put_interface(dev->intf);
 
 	return 0;
 }
@@ -2435,6 +2604,44 @@ static void lan78xx_init_ltm(struct lan78xx_net *dev)
 	lan78xx_write_reg(dev, LTM_INACTIVE1, regs[5]);
 }
 
+static int lan78xx_urb_config_init(struct lan78xx_net *dev)
+{
+	int result = 0;
+
+	switch (dev->udev->speed) {
+	case USB_SPEED_SUPER:
+		dev->rx_urb_size = RX_SS_URB_SIZE;
+		dev->tx_urb_size = TX_SS_URB_SIZE;
+		dev->n_rx_urbs = RX_SS_URB_NUM;
+		dev->n_tx_urbs = TX_SS_URB_NUM;
+		dev->bulk_in_delay = SS_BULK_IN_DELAY;
+		dev->burst_cap = SS_BURST_CAP_SIZE / SS_USB_PKT_SIZE;
+		break;
+	case USB_SPEED_HIGH:
+		dev->rx_urb_size = RX_HS_URB_SIZE;
+		dev->tx_urb_size = TX_HS_URB_SIZE;
+		dev->n_rx_urbs = RX_HS_URB_NUM;
+		dev->n_tx_urbs = TX_HS_URB_NUM;
+		dev->bulk_in_delay = HS_BULK_IN_DELAY;
+		dev->burst_cap = HS_BURST_CAP_SIZE / HS_USB_PKT_SIZE;
+		break;
+	case USB_SPEED_FULL:
+		dev->rx_urb_size = RX_FS_URB_SIZE;
+		dev->tx_urb_size = TX_FS_URB_SIZE;
+		dev->n_rx_urbs = RX_FS_URB_NUM;
+		dev->n_tx_urbs = TX_FS_URB_NUM;
+		dev->bulk_in_delay = FS_BULK_IN_DELAY;
+		dev->burst_cap = FS_BURST_CAP_SIZE / FS_USB_PKT_SIZE;
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
 static int lan78xx_reset(struct lan78xx_net *dev)
 {
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
@@ -2473,25 +2680,8 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 	/* Init LTM */
 	lan78xx_init_ltm(dev);
 
-	if (dev->udev->speed == USB_SPEED_SUPER) {
-		buf = DEFAULT_BURST_CAP_SIZE / SS_USB_PKT_SIZE;
-		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
-		dev->rx_qlen = 4;
-		dev->tx_qlen = 4;
-	} else if (dev->udev->speed == USB_SPEED_HIGH) {
-		buf = DEFAULT_BURST_CAP_SIZE / HS_USB_PKT_SIZE;
-		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
-		dev->rx_qlen = RX_MAX_QUEUE_MEMORY / dev->rx_urb_size;
-		dev->tx_qlen = RX_MAX_QUEUE_MEMORY / dev->hard_mtu;
-	} else {
-		buf = DEFAULT_BURST_CAP_SIZE / FS_USB_PKT_SIZE;
-		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
-		dev->rx_qlen = 4;
-		dev->tx_qlen = 4;
-	}
-
-	ret = lan78xx_write_reg(dev, BURST_CAP, buf);
-	ret = lan78xx_write_reg(dev, BULK_IN_DLY, DEFAULT_BULK_IN_DELAY);
+	ret = lan78xx_write_reg(dev, BURST_CAP, dev->burst_cap);
+	ret = lan78xx_write_reg(dev, BULK_IN_DLY, dev->bulk_in_delay);
 
 	ret = lan78xx_read_reg(dev, HW_CFG, &buf);
 	buf |= HW_CFG_MEF_;
@@ -2501,6 +2691,8 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 	buf |= USB_CFG_BCE_;
 	ret = lan78xx_write_reg(dev, USB_CFG0, buf);
 
+	netdev_info(dev->net, "USB_CFG0 0x%08x\n", buf);
+
 	/* set FIFO sizes */
 	buf = (MAX_RX_FIFO_SIZE - 512) / 512;
 	ret = lan78xx_write_reg(dev, FCT_RX_FIFO_END, buf);
@@ -2561,7 +2753,7 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 	ret = lan78xx_write_reg(dev, FCT_TX_CTL, buf);
 
 	ret = lan78xx_set_rx_max_frame_length(dev,
-					      dev->net->mtu + VLAN_ETH_HLEN);
+					      RX_MAX_FRAME_LEN(dev->net->mtu));
 
 	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
 	buf |= MAC_RX_RXEN_;
@@ -2600,6 +2792,8 @@ static void lan78xx_init_stats(struct lan78xx_net *dev)
 	set_bit(EVENT_STAT_UPDATE, &dev->flags);
 }
 
+static int rx_submit(struct lan78xx_net *dev, struct sk_buff *rx_buf, gfp_t flags);
+
 static int lan78xx_open(struct net_device *net)
 {
 	struct lan78xx_net *dev = netdev_priv(net);
@@ -2631,6 +2825,8 @@ static int lan78xx_open(struct net_device *net)
 
 	dev->link_on = false;
 
+	napi_enable(&dev->napi);
+
 	lan78xx_defer_kevent(dev, EVENT_LINK_RESET);
 done:
 	usb_autopm_put_interface(dev->intf);
@@ -2639,11 +2835,14 @@ static int lan78xx_open(struct net_device *net)
 	return ret;
 }
 
+static int lan78x_tx_pend_skb_get(struct lan78xx_net *dev, struct sk_buff **skb);
+
 static void lan78xx_terminate_urbs(struct lan78xx_net *dev)
 {
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(unlink_wakeup);
 	DECLARE_WAITQUEUE(wait, current);
 	int temp;
+	struct sk_buff *skb;
 
 	/* ensure there are no more active urbs */
 	add_wait_queue(&unlink_wakeup, &wait);
@@ -2652,17 +2851,26 @@ static void lan78xx_terminate_urbs(struct lan78xx_net *dev)
 	temp = unlink_urbs(dev, &dev->txq) + unlink_urbs(dev, &dev->rxq);
 
 	/* maybe wait for deletions to finish. */
-	while (!skb_queue_empty(&dev->rxq) &&
-	       !skb_queue_empty(&dev->txq) &&
-	       !skb_queue_empty(&dev->done)) {
+	while (!skb_queue_empty(&dev->rxq) ||
+	       !skb_queue_empty(&dev->txq)) {
 		schedule_timeout(msecs_to_jiffies(UNLINK_TIMEOUT_MS));
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		netif_dbg(dev, ifdown, dev->net,
-			  "waited for %d urb completions\n", temp);
+			  "waited for %d urb completions", temp);
 	}
 	set_current_state(TASK_RUNNING);
 	dev->wait = NULL;
 	remove_wait_queue(&unlink_wakeup, &wait);
+
+	/* empty Rx done, Rx overflow and Tx pend queues
+	 */
+	while (!skb_queue_empty(&dev->rxq_done)) {
+		skb = skb_dequeue(&dev->rxq_done);
+		lan78xx_free_rx_buf(dev, skb);
+	}
+
+	skb_queue_purge(&dev->rxq_overflow);
+	skb_queue_purge(&dev->txq_pend);
 }
 
 static int lan78xx_stop(struct net_device *net)
@@ -2672,78 +2880,34 @@ static int lan78xx_stop(struct net_device *net)
 	if (timer_pending(&dev->stat_monitor))
 		del_timer_sync(&dev->stat_monitor);
 
-	if (net->phydev)
-		phy_stop(net->phydev);
-
 	clear_bit(EVENT_DEV_OPEN, &dev->flags);
 	netif_stop_queue(net);
+	napi_disable(&dev->napi);
+
+	lan78xx_terminate_urbs(dev);
 
 	netif_info(dev, ifdown, dev->net,
 		   "stop stats: rx/tx %lu/%lu, errs %lu/%lu\n",
 		   net->stats.rx_packets, net->stats.tx_packets,
 		   net->stats.rx_errors, net->stats.tx_errors);
 
-	lan78xx_terminate_urbs(dev);
+	if (net->phydev)
+		phy_stop(net->phydev);
 
 	usb_kill_urb(dev->urb_intr);
 
-	skb_queue_purge(&dev->rxq_pause);
-
 	/* deferred work (task, timer, softirq) must also stop.
 	 * can't flush_scheduled_work() until we drop rtnl (later),
 	 * else workers could deadlock; so make workers a NOP.
 	 */
 	dev->flags = 0;
 	cancel_delayed_work_sync(&dev->wq);
-	tasklet_kill(&dev->bh);
 
 	usb_autopm_put_interface(dev->intf);
 
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
@@ -2752,17 +2916,21 @@ static enum skb_state defer_bh(struct lan78xx_net *dev, struct sk_buff *skb,
 	struct skb_data *entry = (struct skb_data *)skb->cb;
 
 	spin_lock_irqsave(&list->lock, flags);
+
 	old_state = entry->state;
 	entry->state = state;
 
 	__skb_unlink(skb, list);
+
 	spin_unlock(&list->lock);
-	spin_lock(&dev->done.lock);
+	spin_lock(&dev->rxq_done.lock);
+
+	__skb_queue_tail(&dev->rxq_done, skb);
+
+	if (skb_queue_len(&dev->rxq_done) == 1)
+		napi_schedule(&dev->napi);
 
-	__skb_queue_tail(&dev->done, skb);
-	if (skb_queue_len(&dev->done) == 1)
-		tasklet_schedule(&dev->bh);
-	spin_unlock_irqrestore(&dev->done.lock, flags);
+	spin_unlock_irqrestore(&dev->rxq_done.lock, flags);
 
 	return old_state;
 }
@@ -2773,11 +2941,14 @@ static void tx_complete(struct urb *urb)
 	struct skb_data *entry = (struct skb_data *)skb->cb;
 	struct lan78xx_net *dev = entry->dev;
 
+	netif_dbg(dev, tx_done, dev->net,
+		  "tx done: status %d\n", urb->status);
+
 	if (urb->status == 0) {
 		dev->net->stats.tx_packets += entry->num_of_packet;
 		dev->net->stats.tx_bytes += entry->length;
 	} else {
-		dev->net->stats.tx_errors++;
+		dev->net->stats.tx_errors += entry->num_of_packet;
 
 		switch (urb->status) {
 		case -EPIPE:
@@ -2803,7 +2974,15 @@ static void tx_complete(struct urb *urb)
 
 	usb_autopm_put_interface_async(dev->intf);
 
-	defer_bh(dev, skb, &dev->txq, tx_done);
+	skb_unlink(skb, &dev->txq);
+
+	lan78xx_free_tx_buf(dev, skb);
+
+	/* Re-schedule NAPI if Tx data pending but no URBs in progress.
+	 */
+	if (skb_queue_empty(&dev->txq) &&
+	    !skb_queue_empty(&dev->txq_pend))
+		napi_schedule(&dev->napi);
 }
 
 static void lan78xx_queue_skb(struct sk_buff_head *list,
@@ -2815,32 +2994,102 @@ static void lan78xx_queue_skb(struct sk_buff_head *list,
 	entry->state = state;
 }
 
+#define LAN78XX_TX_URB_SPACE(dev) (skb_queue_len(&(dev)->txq_free) * \
+				   (dev)->tx_urb_size)
+
+static int lan78xx_tx_pend_data_len(struct lan78xx_net *dev)
+{
+	return dev->tx_pend_data_len;
+}
+
+static int lan78x_tx_pend_skb_add(struct lan78xx_net *dev, struct sk_buff *skb)
+{
+	int tx_pend_data_len;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->txq_pend.lock, flags);
+
+	__skb_queue_tail(&dev->txq_pend, skb);
+
+	dev->tx_pend_data_len += skb->len;
+	tx_pend_data_len = dev->tx_pend_data_len;
+
+	spin_unlock_irqrestore(&dev->txq_pend.lock, flags);
+
+	return tx_pend_data_len;
+}
+
+static int lan78x_tx_pend_skb_head_add(struct lan78xx_net *dev, struct sk_buff *skb)
+{
+	int tx_pend_data_len;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->txq_pend.lock, flags);
+
+	__skb_queue_head(&dev->txq_pend, skb);
+
+	dev->tx_pend_data_len += skb->len;
+	tx_pend_data_len = dev->tx_pend_data_len;
+
+	spin_unlock_irqrestore(&dev->txq_pend.lock, flags);
+
+	return tx_pend_data_len;
+}
+
+static int lan78x_tx_pend_skb_get(struct lan78xx_net *dev, struct sk_buff **skb)
+{
+	int tx_pend_data_len;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->txq_pend.lock, flags);
+
+	*skb = __skb_dequeue(&dev->txq_pend);
+
+	if (*skb)
+		dev->tx_pend_data_len -= (*skb)->len;
+	tx_pend_data_len = dev->tx_pend_data_len;
+
+	spin_unlock_irqrestore(&dev->txq_pend.lock, flags);
+
+	return tx_pend_data_len;
+}
+
 static netdev_tx_t
 lan78xx_start_xmit(struct sk_buff *skb, struct net_device *net)
 {
+	int tx_pend_data_len;
+
 	struct lan78xx_net *dev = netdev_priv(net);
-	struct sk_buff *skb2 = NULL;
 
-	if (skb) {
-		skb_tx_timestamp(skb);
-		skb2 = lan78xx_tx_prep(dev, skb, GFP_ATOMIC);
-	}
+	/* Get the deferred work handler to resume the
+	 * device if it's suspended.
+	 */
+	if (test_bit(EVENT_DEV_ASLEEP, &dev->flags))
+		schedule_delayed_work(&dev->wq, 0);
 
-	if (skb2) {
-		skb_queue_tail(&dev->txq_pend, skb2);
+	skb_tx_timestamp(skb);
 
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
+	tx_pend_data_len = lan78x_tx_pend_skb_add(dev, skb);
+
+	/* Set up a Tx URB if none is in progress.
+	 */
+	if (skb_queue_empty(&dev->txq))
+		napi_schedule(&dev->napi);
+
+	/* Stop stack Tx queue if we have enough data to fill
+	 * all the free Tx URBs.
+	 */
+	if (tx_pend_data_len > LAN78XX_TX_URB_SPACE(dev)) {
+		netif_stop_queue(net);
 
-	tasklet_schedule(&dev->bh);
+		netif_dbg(dev, hw, dev->net, "tx data len: %d, urb space %d\n",
+			  tx_pend_data_len, LAN78XX_TX_URB_SPACE(dev));
+
+		/* Kick off transmission of pending data */
+
+		if (!skb_queue_empty(&dev->txq_free))
+			napi_schedule(&dev->napi);
+	}
 
 	return NETDEV_TX_OK;
 }
@@ -2897,9 +3146,6 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 		goto out1;
 	}
 
-	dev->net->hard_header_len += TX_OVERHEAD;
-	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
-
 	/* Init all registers */
 	ret = lan78xx_reset(dev);
 	if (ret) {
@@ -2978,12 +3224,7 @@ static void lan78xx_rx_vlan_offload(struct lan78xx_net *dev,
 
 static void lan78xx_skb_return(struct lan78xx_net *dev, struct sk_buff *skb)
 {
-	int status;
-
-	if (test_bit(EVENT_RX_PAUSED, &dev->flags)) {
-		skb_queue_tail(&dev->rxq_pause, skb);
-		return;
-	}
+	gro_result_t gro_result;
 
 	dev->net->stats.rx_packets++;
 	dev->net->stats.rx_bytes += skb->len;
@@ -2997,21 +3238,24 @@ static void lan78xx_skb_return(struct lan78xx_net *dev, struct sk_buff *skb)
 	if (skb_defer_rx_timestamp(skb))
 		return;
 
-	status = netif_rx(skb);
-	if (status != NET_RX_SUCCESS)
-		netif_dbg(dev, rx_err, dev->net,
-			  "netif_rx status %d\n", status);
+	gro_result = napi_gro_receive(&dev->napi, skb);
+
+	if (gro_result == GRO_DROP)
+		netif_dbg(dev, rx_err, dev->net, "GRO packet dropped\n");
 }
 
-static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb)
+static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb,
+		      int budget, int *work_done)
 {
-	if (skb->len < dev->net->hard_header_len)
-		return 0;
+	if (skb->len < RX_SKB_MIN_LEN)
+		return -1;
 
+	/* Extract frames from the URB buffer and pass each one to
+	 * the stack in a new NAPI SKB.
+	 */
 	while (skb->len > 0) {
 		u32 rx_cmd_a, rx_cmd_b, align_count, size;
 		u16 rx_cmd_c;
-		struct sk_buff *skb2;
 		unsigned char *packet;
 
 		rx_cmd_a = get_unaligned_le32(skb->data);
@@ -3033,36 +3277,33 @@ static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb)
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error rx_cmd_a=0x%08x", rx_cmd_a);
 		} else {
-			/* last frame in this batch */
-			if (skb->len == size) {
-				lan78xx_rx_csum_offload(dev, skb,
-							rx_cmd_a, rx_cmd_b);
-				lan78xx_rx_vlan_offload(dev, skb,
-							rx_cmd_a, rx_cmd_b);
-
-				skb_trim(skb, skb->len - 4); /* remove fcs */
-				skb->truesize = size + sizeof(struct sk_buff);
-
-				return 1;
-			}
+			struct sk_buff *skb2;
+			u32 frame_len = size - ETH_FCS_LEN;
 
-			skb2 = skb_clone(skb, GFP_ATOMIC);
-			if (unlikely(!skb2)) {
+			skb2 = napi_alloc_skb(&dev->napi, frame_len);
+			if (!skb2) {
 				netdev_warn(dev->net, "Error allocating skb");
-				return 0;
+				return -1;
 			}
 
-			skb2->len = size;
-			skb2->data = packet;
-			skb_set_tail_pointer(skb2, size);
+			memcpy(skb2->data, packet, frame_len);
+
+			skb_put(skb2, frame_len);
 
 			lan78xx_rx_csum_offload(dev, skb2, rx_cmd_a, rx_cmd_b);
 			lan78xx_rx_vlan_offload(dev, skb2, rx_cmd_a, rx_cmd_b);
 
-			skb_trim(skb2, skb2->len - 4); /* remove fcs */
-			skb2->truesize = size + sizeof(struct sk_buff);
-
-			lan78xx_skb_return(dev, skb2);
+			/* Processing of the URB buffer must complete once
+			 * it has started. If the NAPI work budget is exhausted
+			 * while frames remain they are added to the overflow
+			 * queue for delivery in the next NAPI polling cycle.
+			 */
+			if (*work_done < budget) {
+				lan78xx_skb_return(dev, skb2);
+				++(*work_done);
+			} else {
+				skb_queue_tail(&dev->rxq_overflow, skb2);
+			}
 		}
 
 		skb_pull(skb, size);
@@ -3072,48 +3313,28 @@ static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb)
 			skb_pull(skb, align_count);
 	}
 
-	return 1;
+	return 0;
 }
 
-static inline void rx_process(struct lan78xx_net *dev, struct sk_buff *skb)
+static inline void rx_process(struct lan78xx_net *dev, struct sk_buff *skb,
+			      int budget, int *work_done)
 {
-	if (!lan78xx_rx(dev, skb)) {
+	if (lan78xx_rx(dev, skb, budget, work_done) < 0) {
+		netif_dbg(dev, rx_err, dev->net, "drop\n");
 		dev->net->stats.rx_errors++;
-		goto done;
 	}
-
-	if (skb->len) {
-		lan78xx_skb_return(dev, skb);
-		return;
-	}
-
-	netif_dbg(dev, rx_err, dev->net, "drop\n");
-	dev->net->stats.rx_errors++;
-done:
-	skb_queue_tail(&dev->done, skb);
 }
 
 static void rx_complete(struct urb *urb);
 
-static int rx_submit(struct lan78xx_net *dev, struct urb *urb, gfp_t flags)
+static int rx_submit(struct lan78xx_net *dev, struct sk_buff *skb, gfp_t flags)
 {
-	struct sk_buff *skb;
-	struct skb_data *entry;
+	struct skb_data	*entry = (struct skb_data *)skb->cb;
+	struct urb *urb = entry->urb;
 	unsigned long lockflags;
 	size_t size = dev->rx_urb_size;
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
 
@@ -3123,7 +3344,7 @@ static int rx_submit(struct lan78xx_net *dev, struct urb *urb, gfp_t flags)
 	    netif_running(dev->net) &&
 	    !test_bit(EVENT_RX_HALT, &dev->flags) &&
 	    !test_bit(EVENT_DEV_ASLEEP, &dev->flags)) {
-		ret = usb_submit_urb(urb, GFP_ATOMIC);
+		ret = usb_submit_urb(urb, flags);
 		switch (ret) {
 		case 0:
 			lan78xx_queue_skb(&dev->rxq, skb, rx_start);
@@ -3137,20 +3358,22 @@ static int rx_submit(struct lan78xx_net *dev, struct urb *urb, gfp_t flags)
 			break;
 		case -EHOSTUNREACH:
 			ret = -ENOLINK;
+			napi_schedule(&dev->napi);
 			break;
 		default:
 			netif_dbg(dev, rx_err, dev->net,
 				  "rx submit, %d\n", ret);
-			tasklet_schedule(&dev->bh);
+			napi_schedule(&dev->napi);
+			break;
 		}
 	} else {
 		netif_dbg(dev, ifdown, dev->net, "rx: stopped\n");
 		ret = -ENOLINK;
 	}
 	spin_unlock_irqrestore(&dev->rxq.lock, lockflags);
+
 	if (ret) {
-		dev_kfree_skb_any(skb);
-		usb_free_urb(urb);
+		lan78xx_free_rx_buf(dev, skb);
 	}
 	return ret;
 }
@@ -3165,11 +3388,13 @@ static void rx_complete(struct urb *urb)
 
 	skb_put(skb, urb->actual_length);
 	state = rx_done;
-	entry->urb = NULL;
+
+	if (urb != entry->urb)
+		netif_warn(dev, rx_err, dev->net, "URB pointer mismatch\n");
 
 	switch (urb_status) {
 	case 0:
-		if (skb->len < dev->net->hard_header_len) {
+		if (skb->len < RX_SKB_MIN_LEN) {
 			state = rx_cleanup;
 			dev->net->stats.rx_errors++;
 			dev->net->stats.rx_length_errors++;
@@ -3187,16 +3412,12 @@ static void rx_complete(struct urb *urb)
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
@@ -3212,196 +3433,274 @@ static void rx_complete(struct urb *urb)
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
+static void lan78xx_fill_tx_cmd_words(struct sk_buff *skb, u8 *buffer)
+{
+	u32 tx_cmd_a, tx_cmd_b;
+
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
+	}
+
+	if (skb_vlan_tag_present(skb)) {
+		tx_cmd_a |= TX_CMD_A_IVTG_;
+		tx_cmd_b |= skb_vlan_tag_get(skb) & TX_CMD_B_VTAG_MASK_;
 	}
-	netif_dbg(dev, rx_err, dev->net, "no read resubmitted\n");
+
+	put_unaligned_le32(tx_cmd_a, buffer);
+	put_unaligned_le32(tx_cmd_b, buffer + 4);
 }
 
-static void lan78xx_tx_bh(struct lan78xx_net *dev)
+static struct skb_data *lan78xx_tx_buf_fill(struct lan78xx_net *dev,
+					    struct sk_buff *tx_buf)
 {
-	int length;
-	struct urb *urb = NULL;
+	int remain;
+	u8 *tx_data;
+	u32 urb_len;
 	struct skb_data *entry;
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
 
-		if ((skb_totallen + skb->len) > MAX_SINGLE_PACKET_SIZE)
+	tx_data = tx_buf->data;
+	entry = (struct skb_data *)tx_buf->cb;
+	entry->num_of_packet = 0;
+	entry->length = 0;
+	urb_len = 0;
+	remain = dev->tx_urb_size;
+
+	/* Work through the pending SKBs and copy the data of each SKB into
+	 * the URB buffer if there room for all the SKB data.
+	 *
+	 * There must be at least DST+SRC+TYPE in the SKB (with padding enabled)
+	 */
+	while (remain >= TX_SKB_MIN_LEN) {
+		struct sk_buff *skb;
+		unsigned int len, align;
+
+		lan78x_tx_pend_skb_get(dev, &skb);
+
+		if (!skb)
+			break;
+
+		align = (TX_ALIGNMENT - (urb_len % TX_ALIGNMENT)) % TX_ALIGNMENT;
+		len =  align + TX_CMD_LEN + skb->len;
+		if (len > remain) {
+			lan78x_tx_pend_skb_head_add(dev, skb);
 			break;
-		skb_totallen = skb->len + roundup(skb_totallen, sizeof(u32));
-		pkt_cnt++;
-	}
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
 		}
-	}
 
-gso_skb:
-	urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!urb)
-		goto drop;
+		tx_data += align;
 
-	entry = (struct skb_data *)skb->cb;
-	entry->urb = urb;
-	entry->dev = dev;
-	entry->length = length;
-	entry->num_of_packet = count;
+		lan78xx_fill_tx_cmd_words(skb, tx_data);
+		tx_data += TX_CMD_LEN;
 
-	spin_lock_irqsave(&dev->txq.lock, flags);
-	ret = usb_autopm_get_interface_async(dev->intf);
-	if (ret < 0) {
-		spin_unlock_irqrestore(&dev->txq.lock, flags);
-		goto drop;
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
 
-	if (length % dev->maxpacket == 0) {
-		/* send USB_ZERO_PACKET */
-		urb->transfer_flags |= URB_ZERO_PACKET;
+	return entry;
+}
+
+static void lan78xx_tx_bh(struct lan78xx_net *dev)
+{
+	int ret;
+
+	/* Start the stack Tx queue if it was stopped
+	 */
+	netif_tx_lock(dev->net);
+	if (netif_queue_stopped(dev->net)) {
+		if (lan78xx_tx_pend_data_len(dev) < LAN78XX_TX_URB_SPACE(dev))
+			netif_wake_queue(dev->net);
 	}
+	netif_tx_unlock(dev->net);
+
+	/* Go through the Tx pending queue and set up URBs to transfer
+	 * the data to the device. Stop if no more pending data or URBs,
+	 * or if an error occurs when a URB is submitted.
+	 */
+	do {
+		unsigned long flags;
+		struct sk_buff *tx_buf;
+		struct skb_data *entry;
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
+				  tx_buf->data, tx_buf->len, tx_complete, tx_buf);
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
+		/* if this triggers the device is still a sleep */
+		if (test_bit(EVENT_DEV_ASLEEP, &dev->flags)) {
+			/* transmission will be done in resume */
+			usb_anchor_urb(entry->urb, &dev->deferred);
+			/* no use to process more packets */
+			netif_stop_queue(dev->net);
+			spin_unlock_irqrestore(&dev->txq.lock, flags);
+			netdev_dbg(dev->net, "Delaying transmission for resumption\n");
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
+				  "tx: submit urb err %d (disconnected?)", ret);
+			netif_device_detach(dev->net);
+			break;
+		default:
+			usb_autopm_put_interface_async(dev->intf);
+			netif_dbg(dev, tx_err, dev->net,
+				  "tx: submit urb err %d\n", ret);
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
-	} else
-		netif_dbg(dev, tx_queued, dev->net,
-			  "> tx, len %d, type 0x%x\n", length, skb->protocol);
+		if (ret) {
+			netdev_warn(dev->net,	"failed to tx urb %d\n", ret);
+out:
+			dev->net->stats.tx_dropped += entry->num_of_packet;
+			lan78xx_free_tx_buf(dev, tx_buf);
+		}
+	} while (ret == 0);
 }
 
-static void lan78xx_rx_bh(struct lan78xx_net *dev)
+static void lan78xx_rx_urb_submit_all(struct lan78xx_net *dev)
 {
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
+	struct sk_buff *rx_buf;
 
-		if (skb_queue_len(&dev->rxq) < dev->rx_qlen)
-			tasklet_schedule(&dev->bh);
+	/* Ensure the maximum number of Rx URBs is submitted
+	 */
+	while ((rx_buf = lan78xx_get_rx_buf(dev)) != NULL) {
+		if (rx_submit(dev, rx_buf, GFP_ATOMIC) != 0)
+			break;
 	}
-	if (skb_queue_len(&dev->txq) < dev->tx_qlen)
-		netif_wake_queue(dev->net);
 }
 
-static void lan78xx_bh(struct tasklet_struct *t)
+static void lan78xx_rx_urb_resubmit(struct lan78xx_net *dev,
+				    struct sk_buff *rx_buf)
 {
-	struct lan78xx_net *dev = from_tasklet(dev, t, bh);
-	struct sk_buff *skb;
+	/* reset SKB data pointers */
+
+	rx_buf->data = rx_buf->head;
+	skb_reset_tail_pointer(rx_buf);
+	rx_buf->len = 0;
+	rx_buf->data_len = 0;
+
+	rx_submit(dev, rx_buf, GFP_ATOMIC);
+}
+
+static int lan78xx_bh(struct lan78xx_net *dev, int budget)
+{
+	struct sk_buff_head done;
+	struct sk_buff *rx_buf;
 	struct skb_data *entry;
+	int work_done = 0;
+	unsigned long flags;
 
-	while ((skb = skb_dequeue(&dev->done))) {
-		entry = (struct skb_data *)(skb->cb);
+	/* Pass frames received in the last NAPI cycle before
+	 * working on newly completed URBs.
+	 */
+	while (!skb_queue_empty(&dev->rxq_overflow)) {
+		lan78xx_skb_return(dev, skb_dequeue(&dev->rxq_overflow));
+		++work_done;
+	}
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
+
+	/* Extract receive frames from completed URBs and
+	 * pass them to the stack. Re-submit each completed URB.
+	 */
+	while ((work_done < budget) &&
+	       (rx_buf = __skb_dequeue(&done))) {
+		entry = (struct skb_data *)(rx_buf->cb);
 		switch (entry->state) {
 		case rx_done:
-			entry->state = rx_cleanup;
-			rx_process(dev, skb);
-			continue;
-		case tx_done:
-			usb_free_urb(entry->urb);
-			dev_kfree_skb(skb);
-			continue;
+			rx_process(dev, rx_buf, budget, &work_done);
+			break;
 		case rx_cleanup:
-			usb_free_urb(entry->urb);
-			dev_kfree_skb(skb);
-			continue;
+			break;
 		default:
-			netdev_dbg(dev->net, "skb state %d\n", entry->state);
-			return;
+			netdev_dbg(dev->net, "rx buf state %d\n", entry->state);
+			break;
 		}
+
+		lan78xx_rx_urb_resubmit(dev, rx_buf);
 	}
 
+	/* If budget was consumed before processing all the URBs put them
+	 * back on the front of the done queue. They will be first to be
+	 * processed in the next NAPI cycle.
+	 */
+	spin_lock_irqsave(&dev->rxq_done.lock, flags);
+	skb_queue_splice(&done, &dev->rxq_done);
+	spin_unlock_irqrestore(&dev->rxq_done.lock, flags);
+
 	if (netif_device_present(dev->net) && netif_running(dev->net)) {
 		/* reset update timer delta */
 		if (timer_pending(&dev->stat_monitor) && (dev->delta != 1)) {
@@ -3410,13 +3709,61 @@ static void lan78xx_bh(struct tasklet_struct *t)
 				  jiffies + STAT_UPDATE_TIMER);
 		}
 
-		if (!skb_queue_empty(&dev->txq_pend))
-			lan78xx_tx_bh(dev);
+		/* Submit all free Rx URBs */
+
+		if (!test_bit(EVENT_RX_HALT, &dev->flags))
+			lan78xx_rx_urb_submit_all(dev);
+
+		/* Submit new Tx URBs */
+
+		lan78xx_tx_bh(dev);
+	}
+
+	return work_done;
+}
+
+static int lan78xx_poll(struct napi_struct *napi, int budget)
+{
+	struct lan78xx_net *dev = container_of(napi, struct lan78xx_net, napi);
+	int work_done;
+	int result = budget;
+
+	/* Don't do any work if the device is suspended */
+
+	if (test_bit(EVENT_DEV_ASLEEP, &dev->flags)) {
+		napi_complete_done(napi, 0);
+		return 0;
+	}
+
+	/* Process completed URBs and submit new URBs */
+
+	work_done = lan78xx_bh(dev, budget);
+
+	if (work_done < budget) {
+		napi_complete_done(napi, work_done);
 
-		if (!timer_pending(&dev->delay) &&
-		    !test_bit(EVENT_RX_HALT, &dev->flags))
-			lan78xx_rx_bh(dev);
+		/* Start a new polling cycle if data was received or
+		 * data is waiting to be transmitted.
+		 */
+		if (!skb_queue_empty(&dev->rxq_done)) {
+			napi_schedule(napi);
+		} else if (netif_carrier_ok(dev->net)) {
+			if (skb_queue_empty(&dev->txq) &&
+			    !skb_queue_empty(&dev->txq_pend)) {
+				napi_schedule(napi);
+			} else {
+				netif_tx_lock(dev->net);
+				if (netif_queue_stopped(dev->net)) {
+					netif_wake_queue(dev->net);
+					napi_schedule(napi);
+				}
+				netif_tx_unlock(dev->net);
+			}
+		}
+		result = work_done;
 	}
+
+	return result;
 }
 
 static void lan78xx_delayedwork(struct work_struct *work)
@@ -3464,7 +3811,7 @@ static void lan78xx_delayedwork(struct work_struct *work)
 					   status);
 		} else {
 			clear_bit(EVENT_RX_HALT, &dev->flags);
-			tasklet_schedule(&dev->bh);
+			napi_schedule(&dev->napi);
 		}
 	}
 
@@ -3523,8 +3870,11 @@ static void intr_complete(struct urb *urb)
 		break;
 	}
 
-	if (!netif_running(dev->net))
+	if (!netif_device_present(dev->net) ||
+	    !netif_running(dev->net)) {
+		netdev_warn(dev->net, "not submitting new status URB");
 		return;
+	}
 
 	memset(urb->transfer_buffer, 0, urb->transfer_buffer_length);
 	status = usb_submit_urb(urb, GFP_ATOMIC);
@@ -3545,6 +3895,8 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 	if (!dev)
 		return;
 
+	netif_napi_del(&dev->napi);
+
 	udev = interface_to_usbdev(intf);
 	net = dev->net;
 	phydev = net->phydev;
@@ -3563,8 +3915,14 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 
 	usb_scuttle_anchored_urbs(&dev->deferred);
 
+	if (timer_pending(&dev->stat_monitor))
+		del_timer_sync(&dev->stat_monitor);
+
 	lan78xx_unbind(dev, intf);
 
+	lan78xx_free_tx_resources(dev);
+	lan78xx_free_rx_resources(dev);
+
 	usb_kill_urb(dev->urb_intr);
 	usb_free_urb(dev->urb_intr);
 
@@ -3577,14 +3935,16 @@ static void lan78xx_tx_timeout(struct net_device *net, unsigned int txqueue)
 	struct lan78xx_net *dev = netdev_priv(net);
 
 	unlink_urbs(dev, &dev->txq);
-	tasklet_schedule(&dev->bh);
+	napi_schedule(&dev->napi);
 }
 
 static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
 						struct net_device *netdev,
 						netdev_features_t features)
 {
-	if (skb->len + TX_OVERHEAD > MAX_SINGLE_PACKET_SIZE)
+	struct lan78xx_net *dev = netdev_priv(netdev);
+
+	if (skb->len > LAN78XX_TSO_SIZE(dev))
 		features &= ~NETIF_F_GSO_MASK;
 
 	features = vlan_features_check(skb, features);
@@ -3650,12 +4010,27 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	skb_queue_head_init(&dev->rxq);
 	skb_queue_head_init(&dev->txq);
-	skb_queue_head_init(&dev->done);
-	skb_queue_head_init(&dev->rxq_pause);
+	skb_queue_head_init(&dev->rxq_done);
 	skb_queue_head_init(&dev->txq_pend);
+	skb_queue_head_init(&dev->rxq_overflow);
 	mutex_init(&dev->phy_mutex);
 
-	tasklet_setup(&dev->bh, lan78xx_bh);
+	ret = lan78xx_urb_config_init(dev);
+	if (ret < 0)
+		goto out2;
+
+	ret = lan78xx_alloc_tx_resources(dev);
+	if (ret < 0)
+		goto out2;
+
+	ret = lan78xx_alloc_rx_resources(dev);
+	if (ret < 0)
+		goto out3;
+
+	netif_set_gso_max_size(netdev, LAN78XX_TSO_SIZE(dev));
+
+	netif_napi_add(netdev, &dev->napi, lan78xx_poll, LAN78XX_NAPI_WEIGHT);
+
 	INIT_DELAYED_WORK(&dev->wq, lan78xx_delayedwork);
 	init_usb_anchor(&dev->deferred);
 
@@ -3670,27 +4045,27 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	if (intf->cur_altsetting->desc.bNumEndpoints < 3) {
 		ret = -ENODEV;
-		goto out2;
+		goto out4;
 	}
 
 	dev->pipe_in = usb_rcvbulkpipe(udev, BULK_IN_PIPE);
 	ep_blkin = usb_pipe_endpoint(udev, dev->pipe_in);
 	if (!ep_blkin || !usb_endpoint_is_bulk_in(&ep_blkin->desc)) {
 		ret = -ENODEV;
-		goto out2;
+		goto out4;
 	}
 
 	dev->pipe_out = usb_sndbulkpipe(udev, BULK_OUT_PIPE);
 	ep_blkout = usb_pipe_endpoint(udev, dev->pipe_out);
 	if (!ep_blkout || !usb_endpoint_is_bulk_out(&ep_blkout->desc)) {
 		ret = -ENODEV;
-		goto out2;
+		goto out4;
 	}
 
 	ep_intr = &intf->cur_altsetting->endpoint[2];
 	if (!usb_endpoint_is_int_in(&ep_intr->desc)) {
 		ret = -ENODEV;
-		goto out2;
+		goto out4;
 	}
 
 	dev->pipe_intr = usb_rcvintpipe(dev->udev,
@@ -3698,30 +4073,23 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	ret = lan78xx_bind(dev, intf);
 	if (ret < 0)
-		goto out2;
-
-	if (netdev->mtu > (dev->hard_mtu - netdev->hard_header_len))
-		netdev->mtu = dev->hard_mtu - netdev->hard_header_len;
-
-	/* MTU range: 68 - 9000 */
-	netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
-	netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
+		goto out4;
 
 	period = ep_intr->desc.bInterval;
 	maxp = usb_maxpacket(dev->udev, dev->pipe_intr, 0);
 	buf = kmalloc(maxp, GFP_KERNEL);
-	if (buf) {
-		dev->urb_intr = usb_alloc_urb(0, GFP_KERNEL);
-		if (!dev->urb_intr) {
-			ret = -ENOMEM;
-			kfree(buf);
-			goto out3;
-		} else {
-			usb_fill_int_urb(dev->urb_intr, dev->udev,
-					 dev->pipe_intr, buf, maxp,
-					 intr_complete, dev, period);
-			dev->urb_intr->transfer_flags |= URB_FREE_BUFFER;
-		}
+	if (!buf)
+		goto out5;
+
+	dev->urb_intr = usb_alloc_urb(0, GFP_KERNEL);
+	if (!dev->urb_intr) {
+		ret = -ENOMEM;
+		goto out6;
+	} else {
+		usb_fill_int_urb(dev->urb_intr, dev->udev,
+				 dev->pipe_intr, buf, maxp,
+				 intr_complete, dev, period);
+		dev->urb_intr->transfer_flags |= URB_FREE_BUFFER;
 	}
 
 	dev->maxpacket = usb_maxpacket(dev->udev, dev->pipe_out, 1);
@@ -3731,12 +4099,12 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	ret = lan78xx_phy_init(dev);
 	if (ret < 0)
-		goto out4;
+		goto out7;
 
 	ret = register_netdev(netdev);
 	if (ret != 0) {
 		netif_err(dev, probe, netdev, "couldn't register the device\n");
-		goto out5;
+		goto out8;
 	}
 
 	usb_set_intfdata(intf, dev);
@@ -3751,12 +4119,19 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	return 0;
 
-out5:
+out8:
 	phy_disconnect(netdev->phydev);
-out4:
+out7:
 	usb_free_urb(dev->urb_intr);
-out3:
+out6:
+	kfree(buf);
+out5:
 	lan78xx_unbind(dev, intf);
+out4:
+	netif_napi_del(&dev->napi);
+	lan78xx_free_rx_resources(dev);
+out3:
+	lan78xx_free_tx_resources(dev);
 out2:
 	free_netdev(netdev);
 out1:
@@ -4049,8 +4424,7 @@ static int lan78xx_resume(struct usb_interface *intf)
 			skb = (struct sk_buff *)res->context;
 			ret = usb_submit_urb(res, GFP_ATOMIC);
 			if (ret < 0) {
-				dev_kfree_skb_any(skb);
-				usb_free_urb(res);
+				lan78xx_free_tx_buf(dev, skb);
 				usb_autopm_put_interface_async(dev->intf);
 			} else {
 				netif_trans_update(dev->net);
@@ -4062,9 +4436,9 @@ static int lan78xx_resume(struct usb_interface *intf)
 		spin_unlock_irq(&dev->txq.lock);
 
 		if (test_bit(EVENT_DEV_OPEN, &dev->flags)) {
-			if (!(skb_queue_len(&dev->txq) >= dev->tx_qlen))
+			if (lan78xx_tx_pend_data_len(dev) < LAN78XX_TX_URB_SPACE(dev))
 				netif_start_queue(dev->net);
-			tasklet_schedule(&dev->bh);
+			napi_schedule(&dev->napi);
 		}
 	}
 
-- 
2.17.1

