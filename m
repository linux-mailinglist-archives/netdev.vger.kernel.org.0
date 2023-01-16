Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B960E66D02A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjAPUZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbjAPUZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:25:18 -0500
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C3A28868
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3leVY5h1n5ns/3USqT7jf4YNsjeKiLZvyI5iV2ANLZ4=; b=qnXLblhTq095tNwM7TlQgzGcYM
        bupIgdLiH3Ids8iZGjKEIr0cAl7p0RjrBDLqJNF3HmzIQoQaPWRuVfbk2EnkXR+5Tk6S3Bi4Om84g
        0dkl54sP+6oPOwkUtjN2XkeUNjj7M17WupQWa8F2zUcyg7jkG/LTKEZWKUhPQlLpUXKA=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pHW2b-00018Q-VL; Mon, 16 Jan 2023 21:25:14 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, alexander.duyck@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v5 8/9] tsnep: Add XDP RX support
Date:   Mon, 16 Jan 2023 21:24:57 +0100
Message-Id: <20230116202458.56677-9-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230116202458.56677-1-gerhard@engleder-embedded.com>
References: <20230116202458.56677-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If BPF program is set up, then run BPF program for every received frame
and execute the selected action.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |   3 +
 drivers/net/ethernet/engleder/tsnep_main.c | 131 ++++++++++++++++++++-
 2 files changed, 132 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index c9bfe6ff3add..999fa47be4ba 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -109,6 +109,7 @@ struct tsnep_rx {
 	struct tsnep_adapter *adapter;
 	void __iomem *addr;
 	int queue_index;
+	int tx_queue_index;
 
 	void *page[TSNEP_RING_PAGE_COUNT];
 	dma_addr_t page_dma[TSNEP_RING_PAGE_COUNT];
@@ -176,6 +177,8 @@ struct tsnep_adapter {
 	int rxnfc_count;
 	int rxnfc_max;
 
+	struct bpf_prog *xdp_prog;
+
 	int num_tx_queues;
 	struct tsnep_tx tx[TSNEP_MAX_QUEUES];
 	int num_rx_queues;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 90dda7ca033b..bbf21a6a9e15 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -27,6 +27,7 @@
 #include <linux/phy.h>
 #include <linux/iopoll.h>
 #include <linux/bpf.h>
+#include <linux/bpf_trace.h>
 
 #define TSNEP_RX_OFFSET (max(NET_SKB_PAD, XDP_PACKET_HEADROOM) + NET_IP_ALIGN)
 #define TSNEP_HEADROOM ALIGN(TSNEP_RX_OFFSET, 4)
@@ -49,6 +50,9 @@
 #define TSNEP_TX_TYPE_XDP_TX	BIT(2)
 #define TSNEP_TX_TYPE_XDP_NDO	BIT(3)
 
+#define TSNEP_XDP_TX		BIT(0)
+#define TSNEP_XDP_REDIRECT	BIT(1)
+
 static void tsnep_enable_irq(struct tsnep_adapter *adapter, u32 mask)
 {
 	iowrite32(mask, adapter->addr + ECM_INT_ENABLE);
@@ -607,6 +611,29 @@ static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
 	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
 }
 
+static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
+				struct xdp_buff *xdp,
+				struct netdev_queue *tx_nq, struct tsnep_tx *tx)
+{
+	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
+	bool xmit;
+
+	if (unlikely(!xdpf))
+		return false;
+
+	__netif_tx_lock(tx_nq, smp_processor_id());
+
+	xmit = tsnep_xdp_xmit_frame_ring(xdpf, tx, TSNEP_TX_TYPE_XDP_TX);
+
+	/* Avoid transmit queue timeout since we share it with the slow path */
+	if (xmit)
+		txq_trans_cond_update(tx_nq);
+
+	__netif_tx_unlock(tx_nq);
+
+	return xmit;
+}
+
 static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 {
 	struct tsnep_tx_entry *entry;
@@ -938,6 +965,62 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
 	return i;
 }
 
+static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
+			       struct xdp_buff *xdp, int *status,
+			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
+{
+	unsigned int length;
+	unsigned int sync;
+	u32 act;
+
+	length = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
+
+	act = bpf_prog_run_xdp(prog, xdp);
+
+	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
+	sync = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
+	sync = max(sync, length);
+
+	switch (act) {
+	case XDP_PASS:
+		return false;
+	case XDP_TX:
+		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx))
+			goto out_failure;
+		*status |= TSNEP_XDP_TX;
+		return true;
+	case XDP_REDIRECT:
+		if (xdp_do_redirect(rx->adapter->netdev, xdp, prog) < 0)
+			goto out_failure;
+		*status |= TSNEP_XDP_REDIRECT;
+		return true;
+	default:
+		bpf_warn_invalid_xdp_action(rx->adapter->netdev, prog, act);
+		fallthrough;
+	case XDP_ABORTED:
+out_failure:
+		trace_xdp_exception(rx->adapter->netdev, prog, act);
+		fallthrough;
+	case XDP_DROP:
+		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
+				   sync, true);
+		return true;
+	}
+}
+
+static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status,
+			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
+{
+	if (status & TSNEP_XDP_TX) {
+		__netif_tx_lock(tx_nq, smp_processor_id());
+		tsnep_xdp_xmit_flush(tx);
+		__netif_tx_unlock(tx_nq);
+	}
+
+	if (status & TSNEP_XDP_REDIRECT)
+		xdp_do_flush();
+}
+
 static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 				       int length)
 {
@@ -973,15 +1056,28 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 			 int budget)
 {
 	struct device *dmadev = rx->adapter->dmadev;
-	int desc_available;
-	int done = 0;
 	enum dma_data_direction dma_dir;
 	struct tsnep_rx_entry *entry;
+	struct netdev_queue *tx_nq;
+	struct bpf_prog *prog;
+	struct xdp_buff xdp;
 	struct sk_buff *skb;
+	struct tsnep_tx *tx;
+	int desc_available;
+	int xdp_status = 0;
+	int done = 0;
 	int length;
 
 	desc_available = tsnep_rx_desc_available(rx);
 	dma_dir = page_pool_get_dma_dir(rx->page_pool);
+	prog = READ_ONCE(rx->adapter->xdp_prog);
+	if (prog) {
+		tx_nq = netdev_get_tx_queue(rx->adapter->netdev,
+					    rx->tx_queue_index);
+		tx = &rx->adapter->tx[rx->tx_queue_index];
+
+		xdp_init_buff(&xdp, PAGE_SIZE, &rx->xdp_rxq);
+	}
 
 	while (likely(done < budget) && (rx->read != rx->write)) {
 		entry = &rx->entry[rx->read];
@@ -1031,6 +1127,25 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
 		desc_available++;
 
+		if (prog) {
+			bool consume;
+
+			xdp_prepare_buff(&xdp, page_address(entry->page),
+					 XDP_PACKET_HEADROOM + TSNEP_RX_INLINE_METADATA_SIZE,
+					 length, false);
+
+			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
+						     &xdp_status, tx_nq, tx);
+			if (consume) {
+				rx->packets++;
+				rx->bytes += length;
+
+				entry->page = NULL;
+
+				continue;
+			}
+		}
+
 		skb = tsnep_build_skb(rx, entry->page, length);
 		if (skb) {
 			page_pool_release_page(rx->page_pool, entry->page);
@@ -1049,6 +1164,9 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		entry->page = NULL;
 	}
 
+	if (xdp_status)
+		tsnep_finalize_xdp(rx->adapter, xdp_status, tx_nq, tx);
+
 	if (desc_available)
 		tsnep_rx_refill(rx, desc_available, false);
 
@@ -1221,6 +1339,7 @@ static int tsnep_queue_open(struct tsnep_adapter *adapter,
 			    struct tsnep_queue *queue, bool first)
 {
 	struct tsnep_rx *rx = queue->rx;
+	struct tsnep_tx *tx = queue->tx;
 	int retval;
 
 	queue->adapter = adapter;
@@ -1228,6 +1347,14 @@ static int tsnep_queue_open(struct tsnep_adapter *adapter,
 	netif_napi_add(adapter->netdev, &queue->napi, tsnep_poll);
 
 	if (rx) {
+		/* choose TX queue for XDP_TX */
+		if (tx)
+			rx->tx_queue_index = tx->queue_index;
+		else if (rx->queue_index < adapter->num_tx_queues)
+			rx->tx_queue_index = rx->queue_index;
+		else
+			rx->tx_queue_index = 0;
+
 		retval = xdp_rxq_info_reg(&rx->xdp_rxq, adapter->netdev,
 					  rx->queue_index, queue->napi.napi_id);
 		if (retval)
-- 
2.30.2

