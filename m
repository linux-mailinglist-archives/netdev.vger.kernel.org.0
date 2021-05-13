Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B92437F549
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 12:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhEMKF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 06:05:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:37548 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232823AbhEMKET (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 06:04:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620900187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IvMcIqdk9ustdCpVTzueaYDVUeZhxZ/EAhd4OmpuXOI=;
        b=ZtkMcNuE8kcXYMHWB1eAm7u1BAxzlLMEVdB2/nA1DPxetMUzGjtcv/vVkiGbyoq1n6El5i
        PAGibUSBe7Lu5nOiM0Qi+5bXkfUI8pECgwiYR2WcylRx5+Zaxpept3Jo1M/ifP+MvuluDv
        yvkasKkirJJf3j0dKyowWy7EMykFZjc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D6B09B156;
        Thu, 13 May 2021 10:03:06 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7/8] xen/netfront: don't trust the backend response data blindly
Date:   Thu, 13 May 2021 12:03:01 +0200
Message-Id: <20210513100302.22027-8-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210513100302.22027-1-jgross@suse.com>
References: <20210513100302.22027-1-jgross@suse.com>
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
 drivers/net/xen-netfront.c | 71 +++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 261c35be0147..ccd6d1389b0a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -154,6 +154,8 @@ struct netfront_queue {
 
 	struct page_pool *page_pool;
 	struct xdp_rxq_info xdp_rxq;
+
+	bool tx_pending[NET_TX_RING_SIZE];
 };
 
 struct netfront_info {
@@ -173,6 +175,9 @@ struct netfront_info {
 	bool netback_has_xdp_headroom;
 	bool netfront_xdp_enabled;
 
+	/* Is device behaving sane? */
+	bool broken;
+
 	atomic_t rx_gso_checksum_fixup;
 };
 
@@ -363,7 +368,7 @@ static int xennet_open(struct net_device *dev)
 	unsigned int i = 0;
 	struct netfront_queue *queue = NULL;
 
-	if (!np->queues)
+	if (!np->queues || np->broken)
 		return -ENODEV;
 
 	for (i = 0; i < num_queues; ++i) {
@@ -391,11 +396,17 @@ static void xennet_tx_buf_gc(struct netfront_queue *queue)
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
@@ -406,12 +417,25 @@ static void xennet_tx_buf_gc(struct netfront_queue *queue)
 				continue;
 
 			id  = txrsp.id;
+			if (id >= RING_SIZE(&queue->tx)) {
+				dev_alert(dev,
+					  "Response has incorrect id (%u)\n",
+					  id);
+				goto err;
+			}
+			if (!queue->tx_pending[id]) {
+				dev_alert(dev,
+					  "Response for inactive request\n");
+				goto err;
+			}
+
+			queue->tx_pending[id] = false;
 			skb = queue->tx_skbs[id].skb;
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
@@ -429,6 +453,12 @@ static void xennet_tx_buf_gc(struct netfront_queue *queue)
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
@@ -472,6 +502,13 @@ static void xennet_tx_setup_grant(unsigned long gfn, unsigned int offset,
 
 	*tx = info->tx_local;
 
+	/*
+	 * The request is not in its final form, as size and flags might be
+	 * modified later, but even if a malicious backend will send a response
+	 * now, nothing bad regarding security could happen.
+	 */
+	queue->tx_pending[id] = true;
+
 	info->tx = tx;
 	info->size += info->tx_local.size;
 }
@@ -605,6 +642,8 @@ static int xennet_xdp_xmit(struct net_device *dev, int n,
 	int nxmit = 0;
 	int i;
 
+	if (unlikely(np->broken))
+		return -ENODEV;
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
 
@@ -649,6 +688,8 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	/* Drop the packet if no queues are set up */
 	if (num_queues < 1)
 		goto drop;
+	if (unlikely(np->broken))
+		goto drop;
 	/* Determine which queue to transmit this SKB on */
 	queue_index = skb_get_queue_mapping(skb);
 	queue = &np->queues[queue_index];
@@ -1153,6 +1194,13 @@ static int xennet_poll(struct napi_struct *napi, int budget)
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
@@ -1373,6 +1421,9 @@ static irqreturn_t xennet_tx_interrupt(int irq, void *dev_id)
 	struct netfront_queue *queue = dev_id;
 	unsigned long flags;
 
+	if (queue->info->broken)
+		return IRQ_HANDLED;
+
 	spin_lock_irqsave(&queue->tx_lock, flags);
 	xennet_tx_buf_gc(queue);
 	spin_unlock_irqrestore(&queue->tx_lock, flags);
@@ -1385,6 +1436,9 @@ static irqreturn_t xennet_rx_interrupt(int irq, void *dev_id)
 	struct netfront_queue *queue = dev_id;
 	struct net_device *dev = queue->info->netdev;
 
+	if (queue->info->broken)
+		return IRQ_HANDLED;
+
 	if (likely(netif_carrier_ok(dev) &&
 		   RING_HAS_UNCONSUMED_RESPONSES(&queue->rx)))
 		napi_schedule(&queue->napi);
@@ -1406,6 +1460,10 @@ static void xennet_poll_controller(struct net_device *dev)
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
@@ -1477,6 +1535,11 @@ static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
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
-- 
2.26.2

