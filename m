Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698A14559DE
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343861AbhKRLQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:16:51 -0500
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:5304 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343854AbhKRLOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:14:48 -0500
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 8464B21D41;
        Thu, 18 Nov 2021 11:02:13 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-11-115.trex.outbound.svc.cluster.local [100.96.11.115])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id DFC4E22979;
        Thu, 18 Nov 2021 11:02:11 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.11.115 (trex/6.4.3);
        Thu, 18 Nov 2021 11:02:13 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Continue-Shelf: 008edd6d3e7ba3b2_1637233333229_1323311373
X-MC-Loop-Signature: 1637233333229:2364739950
X-MC-Ingress-Time: 1637233333228
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vRd3GPr1Vhlwqah69n91lgCUC4o+BQZ1G4S4cz9Faq4=; b=e+yyT9dbnQSUF8vBQjkizFbL/3
        BangQvo9FcgqkFVRpAQAY5Ze1wLd0c5V4OPgFHYuKcR/KeC8mzJrpO7csmkknXG9VNTFT7/YGhSTT
        eQrdSLZvFiXCBlrRUtXYWQal9A29FqibcCIx2lo/TS11gxr5Yb+hBKsV7XdoSAiagss4KvjVjgGh5
        BP+XCKnZGj5MZaaZoA8VPXm6BNwh9LMZV7qbH0yOVJ8nEXP6dRHgeMYlbBy7upboUcJVCphDZEIY/
        W01ebU1Batk30jotNLCrsFKJkTuGzaP29IukRzvxRVqkxZqjBrE7BmhHYx05a1qk4nuCn6QiyvxGl
        pjIAmW+Q==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:46024 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mnfBD-004NG9-Tv; Thu, 18 Nov 2021 11:02:09 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 6/6] lan78xx: Introduce NAPI polling support
Date:   Thu, 18 Nov 2021 11:01:39 +0000
Message-Id: <20211118110139.7321-7-john.efstathiades@pebblebay.com>
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

This patch introduces a NAPI-style approach for processing completed
Rx URBs that contributes to improving driver throughput and reducing
CPU load.

Packets in completed URBs are copied to NAPI SKBs and passed to the
network stack for processing. Each frame passed to the stack is one
work item in the NAPI budget.

If the NAPI budget is consumed and frames remain, they are added to
an overflow queue that is processed at the start of the next NAPI
polling cycle.

The NAPI handler is also responsible for copying pending Tx data to
Tx URBs and submitting them to the USB host controller for
transmission.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 182 ++++++++++++++++++++++++--------------
 1 file changed, 114 insertions(+), 68 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 64f60cf6c911..a9e7cbe15f20 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -90,6 +90,8 @@
 					 WAKE_MCAST | WAKE_BCAST | \
 					 WAKE_ARP | WAKE_MAGIC)
 
+#define LAN78XX_NAPI_WEIGHT		64
+
 #define TX_URB_NUM			10
 #define TX_SS_URB_NUM			TX_URB_NUM
 #define TX_HS_URB_NUM			TX_URB_NUM
@@ -427,11 +429,13 @@ struct lan78xx_net {
 	struct sk_buff_head	rxq_free;
 	struct sk_buff_head	rxq;
 	struct sk_buff_head	rxq_done;
+	struct sk_buff_head	rxq_overflow;
 	struct sk_buff_head	txq_free;
 	struct sk_buff_head	txq;
 	struct sk_buff_head	txq_pend;
 
-	struct tasklet_struct	bh;
+	struct napi_struct	napi;
+
 	struct delayed_work	wq;
 
 	int			msg_enable;
@@ -1497,7 +1501,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 
 		lan78xx_rx_urb_submit_all(dev);
 
-		tasklet_schedule(&dev->bh);
+		napi_schedule(&dev->napi);
 	}
 
 	return 0;
@@ -3152,6 +3156,8 @@ static int lan78xx_open(struct net_device *net)
 
 	dev->link_on = false;
 
+	napi_enable(&dev->napi);
+
 	lan78xx_defer_kevent(dev, EVENT_LINK_RESET);
 done:
 	mutex_unlock(&dev->dev_mutex);
@@ -3185,7 +3191,7 @@ static void lan78xx_terminate_urbs(struct lan78xx_net *dev)
 	dev->wait = NULL;
 	remove_wait_queue(&unlink_wakeup, &wait);
 
-	/* empty Rx done and Tx pend queues
+	/* empty Rx done, Rx overflow and Tx pend queues
 	 */
 	while (!skb_queue_empty(&dev->rxq_done)) {
 		struct sk_buff *skb = skb_dequeue(&dev->rxq_done);
@@ -3193,6 +3199,7 @@ static void lan78xx_terminate_urbs(struct lan78xx_net *dev)
 		lan78xx_release_rx_buf(dev, skb);
 	}
 
+	skb_queue_purge(&dev->rxq_overflow);
 	skb_queue_purge(&dev->txq_pend);
 }
 
@@ -3209,7 +3216,7 @@ static int lan78xx_stop(struct net_device *net)
 
 	clear_bit(EVENT_DEV_OPEN, &dev->flags);
 	netif_stop_queue(net);
-	tasklet_kill(&dev->bh);
+	napi_disable(&dev->napi);
 
 	lan78xx_terminate_urbs(dev);
 
@@ -3262,7 +3269,8 @@ static enum skb_state defer_bh(struct lan78xx_net *dev, struct sk_buff *skb,
 
 	__skb_queue_tail(&dev->rxq_done, skb);
 	if (skb_queue_len(&dev->rxq_done) == 1)
-		tasklet_schedule(&dev->bh);
+		napi_schedule(&dev->napi);
+
 	spin_unlock_irqrestore(&dev->rxq_done.lock, flags);
 
 	return old_state;
@@ -3315,11 +3323,11 @@ static void tx_complete(struct urb *urb)
 
 	lan78xx_release_tx_buf(dev, skb);
 
-	/* Re-schedule tasklet if Tx data pending but no URBs in progress.
+	/* Re-schedule NAPI if Tx data pending but no URBs in progress.
 	 */
 	if (skb_queue_empty(&dev->txq) &&
 	    !skb_queue_empty(&dev->txq_pend))
-		tasklet_schedule(&dev->bh);
+		napi_schedule(&dev->napi);
 }
 
 static void lan78xx_queue_skb(struct sk_buff_head *list,
@@ -3405,7 +3413,7 @@ lan78xx_start_xmit(struct sk_buff *skb, struct net_device *net)
 	/* Set up a Tx URB if none is in progress */
 
 	if (skb_queue_empty(&dev->txq))
-		tasklet_schedule(&dev->bh);
+		napi_schedule(&dev->napi);
 
 	/* Stop stack Tx queue if we have enough data to fill
 	 * all the free Tx URBs.
@@ -3419,7 +3427,7 @@ lan78xx_start_xmit(struct sk_buff *skb, struct net_device *net)
 		/* Kick off transmission of pending data */
 
 		if (!skb_queue_empty(&dev->txq_free))
-			tasklet_schedule(&dev->bh);
+			napi_schedule(&dev->napi);
 	}
 
 	return NETDEV_TX_OK;
@@ -3555,8 +3563,6 @@ static void lan78xx_rx_vlan_offload(struct lan78xx_net *dev,
 
 static void lan78xx_skb_return(struct lan78xx_net *dev, struct sk_buff *skb)
 {
-	int status;
-
 	dev->net->stats.rx_packets++;
 	dev->net->stats.rx_bytes += skb->len;
 
@@ -3569,21 +3575,21 @@ static void lan78xx_skb_return(struct lan78xx_net *dev, struct sk_buff *skb)
 	if (skb_defer_rx_timestamp(skb))
 		return;
 
-	status = netif_rx(skb);
-	if (status != NET_RX_SUCCESS)
-		netif_dbg(dev, rx_err, dev->net,
-			  "netif_rx status %d\n", status);
+	napi_gro_receive(&dev->napi, skb);
 }
 
-static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb)
+static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb,
+		      int budget, int *work_done)
 {
 	if (skb->len < RX_SKB_MIN_LEN)
 		return 0;
 
+	/* Extract frames from the URB buffer and pass each one to
+	 * the stack in a new NAPI SKB.
+	 */
 	while (skb->len > 0) {
 		u32 rx_cmd_a, rx_cmd_b, align_count, size;
 		u16 rx_cmd_c;
-		struct sk_buff *skb2;
 		unsigned char *packet;
 
 		rx_cmd_a = get_unaligned_le32(skb->data);
@@ -3605,41 +3611,36 @@ static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb)
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
+			u32 frame_len = size - ETH_FCS_LEN;
+			struct sk_buff *skb2;
 
-			skb2 = skb_clone(skb, GFP_ATOMIC);
-			if (unlikely(!skb2)) {
-				netdev_warn(dev->net, "Error allocating skb");
+			skb2 = napi_alloc_skb(&dev->napi, frame_len);
+			if (!skb2)
 				return 0;
-			}
 
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
 
-		/* padding bytes before the next frame starts */
+		/* skip padding bytes before the next frame starts */
 		if (skb->len)
 			skb_pull(skb, align_count);
 	}
@@ -3647,22 +3648,13 @@ static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb)
 	return 1;
 }
 
-static inline void rx_process(struct lan78xx_net *dev, struct sk_buff *skb)
+static inline void rx_process(struct lan78xx_net *dev, struct sk_buff *skb,
+			      int budget, int *work_done)
 {
-	struct sk_buff *rx_buf = skb_copy(skb, GFP_ATOMIC);
-
-	if (!lan78xx_rx(dev, rx_buf)) {
+	if (!lan78xx_rx(dev, skb, budget, work_done)) {
+		netif_dbg(dev, rx_err, dev->net, "drop\n");
 		dev->net->stats.rx_errors++;
-		return;
 	}
-
-	if (rx_buf->len) {
-		lan78xx_skb_return(dev, rx_buf);
-		return;
-	}
-
-	netif_dbg(dev, rx_err, dev->net, "drop\n");
-	dev->net->stats.rx_errors++;
 }
 
 static void rx_complete(struct urb *urb)
@@ -3757,12 +3749,12 @@ static int rx_submit(struct lan78xx_net *dev, struct sk_buff *skb, gfp_t flags)
 			break;
 		case -EHOSTUNREACH:
 			ret = -ENOLINK;
-			tasklet_schedule(&dev->bh);
+			napi_schedule(&dev->napi);
 			break;
 		default:
 			netif_dbg(dev, rx_err, dev->net,
 				  "rx submit, %d\n", ret);
-			tasklet_schedule(&dev->bh);
+			napi_schedule(&dev->napi);
 			break;
 		}
 	} else {
@@ -3989,13 +3981,21 @@ static void lan78xx_tx_bh(struct lan78xx_net *dev)
 	} while (ret == 0);
 }
 
-static void lan78xx_bh(struct tasklet_struct *t)
+static int lan78xx_bh(struct lan78xx_net *dev, int budget)
 {
-	struct lan78xx_net *dev = from_tasklet(dev, t, bh);
 	struct sk_buff_head done;
 	struct sk_buff *rx_buf;
 	struct skb_data *entry;
 	unsigned long flags;
+	int work_done = 0;
+
+	/* Pass frames received in the last NAPI cycle before
+	 * working on newly completed URBs.
+	 */
+	while (!skb_queue_empty(&dev->rxq_overflow)) {
+		lan78xx_skb_return(dev, skb_dequeue(&dev->rxq_overflow));
+		++work_done;
+	}
 
 	/* Take a snapshot of the done queue and move items to a
 	 * temporary queue. Rx URB completions will continue to add
@@ -4010,22 +4010,32 @@ static void lan78xx_bh(struct tasklet_struct *t)
 	/* Extract receive frames from completed URBs and
 	 * pass them to the stack. Re-submit each completed URB.
 	 */
-	while ((rx_buf = __skb_dequeue(&done))) {
+	while ((work_done < budget) &&
+	       (rx_buf = __skb_dequeue(&done))) {
 		entry = (struct skb_data *)(rx_buf->cb);
 		switch (entry->state) {
 		case rx_done:
-			rx_process(dev, rx_buf);
+			rx_process(dev, rx_buf, budget, &work_done);
 			break;
 		case rx_cleanup:
 			break;
 		default:
-			netdev_dbg(dev->net, "skb state %d\n", entry->state);
+			netdev_dbg(dev->net, "rx buf state %d\n",
+				   entry->state);
 			break;
 		}
 
 		lan78xx_rx_urb_resubmit(dev, rx_buf);
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
@@ -4034,30 +4044,61 @@ static void lan78xx_bh(struct tasklet_struct *t)
 				  jiffies + STAT_UPDATE_TIMER);
 		}
 
+		/* Submit all free Rx URBs */
+
 		if (!test_bit(EVENT_RX_HALT, &dev->flags))
 			lan78xx_rx_urb_submit_all(dev);
 
+		/* Submit new Tx URBs */
+
 		lan78xx_tx_bh(dev);
+	}
+
+	return work_done;
+}
+
+static int lan78xx_poll(struct napi_struct *napi, int budget)
+{
+	struct lan78xx_net *dev = container_of(napi, struct lan78xx_net, napi);
+	int result = budget;
+	int work_done;
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
 
 		/* Start a new polling cycle if data was received or
 		 * data is waiting to be transmitted.
 		 */
 		if (!skb_queue_empty(&dev->rxq_done)) {
-			tasklet_schedule(&dev->bh);
+			napi_schedule(napi);
 		} else if (netif_carrier_ok(dev->net)) {
 			if (skb_queue_empty(&dev->txq) &&
 			    !skb_queue_empty(&dev->txq_pend)) {
-				tasklet_schedule(&dev->bh);
+				napi_schedule(napi);
 			} else {
 				netif_tx_lock(dev->net);
 				if (netif_queue_stopped(dev->net)) {
 					netif_wake_queue(dev->net);
-					tasklet_schedule(&dev->bh);
+					napi_schedule(napi);
 				}
 				netif_tx_unlock(dev->net);
 			}
 		}
+		result = work_done;
 	}
+
+	return result;
 }
 
 static void lan78xx_delayedwork(struct work_struct *work)
@@ -4103,7 +4144,7 @@ static void lan78xx_delayedwork(struct work_struct *work)
 					   status);
 		} else {
 			clear_bit(EVENT_RX_HALT, &dev->flags);
-			tasklet_schedule(&dev->bh);
+			napi_schedule(&dev->napi);
 		}
 	}
 
@@ -4197,6 +4238,8 @@ static void lan78xx_disconnect(struct usb_interface *intf)
 
 	set_bit(EVENT_DEV_DISCONNECT, &dev->flags);
 
+	netif_napi_del(&dev->napi);
+
 	udev = interface_to_usbdev(intf);
 	net = dev->net;
 
@@ -4236,7 +4279,7 @@ static void lan78xx_tx_timeout(struct net_device *net, unsigned int txqueue)
 	struct lan78xx_net *dev = netdev_priv(net);
 
 	unlink_urbs(dev, &dev->txq);
-	tasklet_schedule(&dev->bh);
+	napi_schedule(&dev->napi);
 }
 
 static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
@@ -4313,6 +4356,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	skb_queue_head_init(&dev->txq);
 	skb_queue_head_init(&dev->rxq_done);
 	skb_queue_head_init(&dev->txq_pend);
+	skb_queue_head_init(&dev->rxq_overflow);
 	mutex_init(&dev->phy_mutex);
 	mutex_init(&dev->dev_mutex);
 
@@ -4333,7 +4377,8 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	netif_set_gso_max_size(netdev, LAN78XX_TSO_SIZE(dev));
 
-	tasklet_setup(&dev->bh, lan78xx_bh);
+	netif_napi_add(netdev, &dev->napi, lan78xx_poll, LAN78XX_NAPI_WEIGHT);
+
 	INIT_DELAYED_WORK(&dev->wq, lan78xx_delayedwork);
 	init_usb_anchor(&dev->deferred);
 
@@ -4439,6 +4484,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 out5:
 	lan78xx_unbind(dev, intf);
 out4:
+	netif_napi_del(&dev->napi);
 	lan78xx_free_rx_resources(dev);
 out3:
 	lan78xx_free_tx_resources(dev);
@@ -4938,7 +4984,7 @@ static int lan78xx_resume(struct usb_interface *intf)
 		if (ret < 0)
 			goto out;
 
-		tasklet_schedule(&dev->bh);
+		napi_schedule(&dev->napi);
 
 		if (!timer_pending(&dev->stat_monitor)) {
 			dev->delta = 1;
-- 
2.25.1

