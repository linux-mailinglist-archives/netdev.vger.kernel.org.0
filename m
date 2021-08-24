Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693A83F5C1C
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 12:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbhHXK3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 06:29:05 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44536 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbhHXK27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 06:28:59 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 969A920051;
        Tue, 24 Aug 2021 10:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629800894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nfhixkZoKYt7ltZuGvoMSJv4YyU9Ov7I0dmOxqpdsKE=;
        b=DcR+51AtjNOu/RurWnkc4/qcw2RfDI2dJrDj/kJHKxCouGLQNJhFK50ZaZBZasJVpbTU7Q
        iqFhF5ojLAljx7+nVh/UOfGJnk12i3tue4uY5AJkjdNeDxN1IDCzpRXe0jh3onS3kfaPuX
        sIsCN8m06Dkp46Gon3fUJYQTn0DLNLo=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 52545136DD;
        Tue, 24 Aug 2021 10:28:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id yDeiEr7JJGG8DwAAGKfGzw
        (envelope-from <jgross@suse.com>); Tue, 24 Aug 2021 10:28:14 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 4/4] xen/netfront: don't trust the backend response data blindly
Date:   Tue, 24 Aug 2021 12:28:09 +0200
Message-Id: <20210824102809.26370-5-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210824102809.26370-1-jgross@suse.com>
References: <20210824102809.26370-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Today netfront will trust the backend to send only sane response data.
In order to avoid privilege escalations or crashes in case of malicious
backends verify the data to be within expected limits. Especially make
sure that the response always references an outstanding request.

Note that only the tx queue needs special id handling, as for the rx
queue the id is equal to the index in the ring page.

Introduce a new indicator for the device whether it is broken and let
the device stop working when it is set. Set this indicator in case the
backend sets any weird data.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- set the pending flag only just before sending the request (Jan Beulich)
- reset broken indicator during connect (Jan Beulich)
---
 drivers/net/xen-netfront.c | 89 +++++++++++++++++++++++++++++++++++---
 1 file changed, 84 insertions(+), 5 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 956e1266bd1a..e31b98403f31 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -131,10 +131,12 @@ struct netfront_queue {
 	struct sk_buff *tx_skbs[NET_TX_RING_SIZE];
 	unsigned short tx_link[NET_TX_RING_SIZE];
 #define TX_LINK_NONE 0xffff
+#define TX_PENDING   0xfffe
 	grant_ref_t gref_tx_head;
 	grant_ref_t grant_tx_ref[NET_TX_RING_SIZE];
 	struct page *grant_tx_page[NET_TX_RING_SIZE];
 	unsigned tx_skb_freelist;
+	unsigned int tx_pend_queue;
 
 	spinlock_t   rx_lock ____cacheline_aligned_in_smp;
 	struct xen_netif_rx_front_ring rx;
@@ -167,6 +169,9 @@ struct netfront_info {
 	bool netback_has_xdp_headroom;
 	bool netfront_xdp_enabled;
 
+	/* Is device behaving sane? */
+	bool broken;
+
 	atomic_t rx_gso_checksum_fixup;
 };
 
@@ -349,7 +354,7 @@ static int xennet_open(struct net_device *dev)
 	unsigned int i = 0;
 	struct netfront_queue *queue = NULL;
 
-	if (!np->queues)
+	if (!np->queues || np->broken)
 		return -ENODEV;
 
 	for (i = 0; i < num_queues; ++i) {
@@ -377,11 +382,17 @@ static void xennet_tx_buf_gc(struct netfront_queue *queue)
 	unsigned short id;
 	struct sk_buff *skb;
 	bool more_to_do;
+	const struct device *dev = &queue->info->netdev->dev;
 
 	BUG_ON(!netif_carrier_ok(queue->info->netdev));
 
 	do {
 		prod = queue->tx.sring->rsp_prod;
+		if (RING_RESPONSE_PROD_OVERFLOW(&queue->tx, prod)) {
+			dev_alert(dev, "Illegal number of responses %u\n",
+				  prod - queue->tx.rsp_cons);
+			goto err;
+		}
 		rmb(); /* Ensure we see responses up to 'rp'. */
 
 		for (cons = queue->tx.rsp_cons; cons != prod; cons++) {
@@ -391,14 +402,27 @@ static void xennet_tx_buf_gc(struct netfront_queue *queue)
 			if (txrsp.status == XEN_NETIF_RSP_NULL)
 				continue;
 
-			id  = txrsp.id;
+			id = txrsp.id;
+			if (id >= RING_SIZE(&queue->tx)) {
+				dev_alert(dev,
+					  "Response has incorrect id (%u)\n",
+					  id);
+				goto err;
+			}
+			if (queue->tx_link[id] != TX_PENDING) {
+				dev_alert(dev,
+					  "Response for inactive request\n");
+				goto err;
+			}
+
+			queue->tx_link[id] = TX_LINK_NONE;
 			skb = queue->tx_skbs[id];
 			queue->tx_skbs[id] = NULL;
 			if (unlikely(gnttab_query_foreign_access(
 				queue->grant_tx_ref[id]) != 0)) {
-				pr_alert("%s: warning -- grant still in use by backend domain\n",
-					 __func__);
-				BUG();
+				dev_alert(dev,
+					  "Grant still in use by backend domain\n");
+				goto err;
 			}
 			gnttab_end_foreign_access_ref(
 				queue->grant_tx_ref[id], GNTMAP_readonly);
@@ -416,6 +440,12 @@ static void xennet_tx_buf_gc(struct netfront_queue *queue)
 	} while (more_to_do);
 
 	xennet_maybe_wake_tx(queue);
+
+	return;
+
+ err:
+	queue->info->broken = true;
+	dev_alert(dev, "Disabled for further use\n");
 }
 
 struct xennet_gnttab_make_txreq {
@@ -459,6 +489,12 @@ static void xennet_tx_setup_grant(unsigned long gfn, unsigned int offset,
 
 	*tx = info->tx_local;
 
+	/*
+	 * Put the request in the pending queue, it will be set to be pending
+	 * when the producer index is about to be raised.
+	 */
+	add_id_to_list(&queue->tx_pend_queue, queue->tx_link, id);
+
 	info->tx = tx;
 	info->size += info->tx_local.size;
 }
@@ -551,6 +587,15 @@ static u16 xennet_select_queue(struct net_device *dev, struct sk_buff *skb,
 	return queue_idx;
 }
 
+static void xennet_mark_tx_pending(struct netfront_queue *queue)
+{
+	unsigned int i;
+
+	while ((i = get_id_from_list(&queue->tx_pend_queue, queue->tx_link)) !=
+	       TX_LINK_NONE)
+		queue->tx_link[i] = TX_PENDING;
+}
+
 static int xennet_xdp_xmit_one(struct net_device *dev,
 			       struct netfront_queue *queue,
 			       struct xdp_frame *xdpf)
@@ -568,6 +613,8 @@ static int xennet_xdp_xmit_one(struct net_device *dev,
 				offset_in_page(xdpf->data),
 				xdpf->len);
 
+	xennet_mark_tx_pending(queue);
+
 	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&queue->tx, notify);
 	if (notify)
 		notify_remote_via_irq(queue->tx_irq);
@@ -592,6 +639,8 @@ static int xennet_xdp_xmit(struct net_device *dev, int n,
 	int nxmit = 0;
 	int i;
 
+	if (unlikely(np->broken))
+		return -ENODEV;
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
 
@@ -636,6 +685,8 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	/* Drop the packet if no queues are set up */
 	if (num_queues < 1)
 		goto drop;
+	if (unlikely(np->broken))
+		goto drop;
 	/* Determine which queue to transmit this SKB on */
 	queue_index = skb_get_queue_mapping(skb);
 	queue = &np->queues[queue_index];
@@ -742,6 +793,8 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	/* timestamp packet in software */
 	skb_tx_timestamp(skb);
 
+	xennet_mark_tx_pending(queue);
+
 	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&queue->tx, notify);
 	if (notify)
 		notify_remote_via_irq(queue->tx_irq);
@@ -1141,6 +1194,13 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 	skb_queue_head_init(&tmpq);
 
 	rp = queue->rx.sring->rsp_prod;
+	if (RING_RESPONSE_PROD_OVERFLOW(&queue->rx, rp)) {
+		dev_alert(&dev->dev, "Illegal number of responses %u\n",
+			  rp - queue->rx.rsp_cons);
+		queue->info->broken = true;
+		spin_unlock(&queue->rx_lock);
+		return 0;
+	}
 	rmb(); /* Ensure we see queued responses up to 'rp'. */
 
 	i = queue->rx.rsp_cons;
@@ -1362,6 +1422,9 @@ static irqreturn_t xennet_tx_interrupt(int irq, void *dev_id)
 	struct netfront_queue *queue = dev_id;
 	unsigned long flags;
 
+	if (queue->info->broken)
+		return IRQ_HANDLED;
+
 	spin_lock_irqsave(&queue->tx_lock, flags);
 	xennet_tx_buf_gc(queue);
 	spin_unlock_irqrestore(&queue->tx_lock, flags);
@@ -1374,6 +1437,9 @@ static irqreturn_t xennet_rx_interrupt(int irq, void *dev_id)
 	struct netfront_queue *queue = dev_id;
 	struct net_device *dev = queue->info->netdev;
 
+	if (queue->info->broken)
+		return IRQ_HANDLED;
+
 	if (likely(netif_carrier_ok(dev) &&
 		   RING_HAS_UNCONSUMED_RESPONSES(&queue->rx)))
 		napi_schedule(&queue->napi);
@@ -1395,6 +1461,10 @@ static void xennet_poll_controller(struct net_device *dev)
 	struct netfront_info *info = netdev_priv(dev);
 	unsigned int num_queues = dev->real_num_tx_queues;
 	unsigned int i;
+
+	if (info->broken)
+		return;
+
 	for (i = 0; i < num_queues; ++i)
 		xennet_interrupt(0, &info->queues[i]);
 }
@@ -1466,6 +1536,11 @@ static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
 static int xennet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
+	struct netfront_info *np = netdev_priv(dev);
+
+	if (np->broken)
+		return -ENODEV;
+
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return xennet_xdp_set(dev, xdp->prog, xdp->extack);
@@ -1841,6 +1916,7 @@ static int xennet_init_queue(struct netfront_queue *queue)
 
 	/* Initialise tx_skb_freelist as a free chain containing every entry. */
 	queue->tx_skb_freelist = 0;
+	queue->tx_pend_queue = TX_LINK_NONE;
 	for (i = 0; i < NET_TX_RING_SIZE; i++) {
 		queue->tx_link[i] = i + 1;
 		queue->grant_tx_ref[i] = GRANT_INVALID_REF;
@@ -2115,6 +2191,9 @@ static int talk_to_netback(struct xenbus_device *dev,
 	if (info->queues)
 		xennet_destroy_queues(info);
 
+	/* For the case of a reconnect reset the "broken" indicator. */
+	info->broken = false;
+
 	err = xennet_create_queues(info, &num_queues);
 	if (err < 0) {
 		xenbus_dev_fatal(dev, err, "creating queues");
-- 
2.26.2

