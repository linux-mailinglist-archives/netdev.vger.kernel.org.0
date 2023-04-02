Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE43D6D3A0F
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 21:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjDBTjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 15:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjDBTi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 15:38:57 -0400
Received: from mx12lb.world4you.com (mx12lb.world4you.com [81.19.149.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFEEAD04;
        Sun,  2 Apr 2023 12:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=x/6O6rR0MhmuxSJMPub37bMJNUZ6vXhSz337nDsP8Xw=; b=mnqzF+O4XHv6rTqvF16gTNkdI2
        YSFj1nf146sj4ihoQX56Ppvv65OjPvfhzjJoVXInJm3/VuxUDc1KMxyh9jDUIyFoCU/XjnQoQEDjy
        esGKVW4lNselhA3RtvgTkQ54105ja9HYdrY+lndilqAD2riMC6oaVjdENAhmjMdSmHms=;
Received: from 88-117-56-218.adsl.highway.telekom.at ([88.117.56.218] helo=hornet.engleder.at)
        by mx12lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pj3XQ-0007Gn-VN; Sun, 02 Apr 2023 21:38:53 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 4/5] tsnep: Add XDP socket zero-copy RX support
Date:   Sun,  2 Apr 2023 21:38:37 +0200
Message-Id: <20230402193838.54474-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230402193838.54474-1-gerhard@engleder-embedded.com>
References: <20230402193838.54474-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for XSK zero-copy to RX path. The setup of the XSK pool can
be done at runtime. If the netdev is running, then the queue must be
disabled and enabled during reconfiguration. This can be done easily
with functions introduced in previous commits.

A more important property is that, if the netdev is running, then the
setup of the XSK pool shall not stop the netdev in case of errors. A
broken netdev after a failed XSK pool setup is bad behavior. Therefore,
the allocation and setup of resources during XSK pool setup is done only
before any queue is disabled. Additionally, freeing and later allocation
of resources is eliminated in some cases. Page pool entries are kept for
later use. Two memory models are registered in parallel. As a result,
the XSK pool setup cannot fail during queue reconfiguration.

In contrast to other drivers, XSK pool setup and XDP BPF program setup
are separate actions. XSK pool setup can be done without any XDP BPF
program. The XDP BPF program can be added, removed or changed without
any reconfiguration of the XSK pool.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |   7 +
 drivers/net/ethernet/engleder/tsnep_main.c | 432 ++++++++++++++++++++-
 drivers/net/ethernet/engleder/tsnep_xdp.c  |  67 ++++
 3 files changed, 488 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 058c2bcf31a7..836fd6b1d62e 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -101,6 +101,7 @@ struct tsnep_rx_entry {
 	u32 properties;
 
 	struct page *page;
+	struct xdp_buff *xdp;
 	size_t len;
 	dma_addr_t dma;
 };
@@ -120,6 +121,7 @@ struct tsnep_rx {
 	u32 owner_counter;
 	int increment_owner_counter;
 	struct page_pool *page_pool;
+	struct xsk_buff_pool *xsk_pool;
 
 	u32 packets;
 	u32 bytes;
@@ -128,6 +130,7 @@ struct tsnep_rx {
 	u32 alloc_failed;
 
 	struct xdp_rxq_info xdp_rxq;
+	struct xdp_rxq_info xdp_rxq_zc;
 };
 
 struct tsnep_queue {
@@ -213,6 +216,8 @@ int tsnep_rxnfc_del_rule(struct tsnep_adapter *adapter,
 
 int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
 			 struct netlink_ext_ack *extack);
+int tsnep_xdp_setup_pool(struct tsnep_adapter *adapter,
+			 struct xsk_buff_pool *pool, u16 queue_id);
 
 #if IS_ENABLED(CONFIG_TSNEP_SELFTESTS)
 int tsnep_ethtool_get_test_count(void);
@@ -241,5 +246,7 @@ static inline void tsnep_ethtool_self_test(struct net_device *dev,
 void tsnep_get_system_time(struct tsnep_adapter *adapter, u64 *time);
 int tsnep_set_irq_coalesce(struct tsnep_queue *queue, u32 usecs);
 u32 tsnep_get_irq_coalesce(struct tsnep_queue *queue);
+int tsnep_enable_xsk(struct tsnep_queue *queue, struct xsk_buff_pool *pool);
+void tsnep_disable_xsk(struct tsnep_queue *queue);
 
 #endif /* _TSNEP_H */
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 6d63b379f05a..e05835d675aa 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -28,11 +28,16 @@
 #include <linux/iopoll.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <net/xdp_sock_drv.h>
 
 #define TSNEP_RX_OFFSET (max(NET_SKB_PAD, XDP_PACKET_HEADROOM) + NET_IP_ALIGN)
 #define TSNEP_HEADROOM ALIGN(TSNEP_RX_OFFSET, 4)
 #define TSNEP_MAX_RX_BUF_SIZE (PAGE_SIZE - TSNEP_HEADROOM - \
 			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+/* XSK buffer shall store at least Q-in-Q frame */
+#define TSNEP_XSK_RX_BUF_SIZE (ALIGN(TSNEP_RX_INLINE_METADATA_SIZE + \
+				     ETH_FRAME_LEN + ETH_FCS_LEN + \
+				     VLAN_HLEN * 2, 4))
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 #define DMA_ADDR_HIGH(dma_addr) ((u32)(((dma_addr) >> 32) & 0xFFFFFFFF))
@@ -781,6 +786,9 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 			page_pool_put_full_page(rx->page_pool, entry->page,
 						false);
 		entry->page = NULL;
+		if (entry->xdp)
+			xsk_buff_free(entry->xdp);
+		entry->xdp = NULL;
 	}
 
 	if (rx->page_pool)
@@ -927,7 +935,7 @@ static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
 {
 	struct tsnep_rx_entry *entry = &rx->entry[index];
 
-	/* TSNEP_MAX_RX_BUF_SIZE is a multiple of 4 */
+	/* TSNEP_MAX_RX_BUF_SIZE and TSNEP_XSK_RX_BUF_SIZE are multiple of 4 */
 	entry->properties = entry->len & TSNEP_DESC_LENGTH_MASK;
 	entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
 	if (index == rx->increment_owner_counter) {
@@ -979,6 +987,24 @@ static int tsnep_rx_alloc(struct tsnep_rx *rx, int count, bool reuse)
 	return i;
 }
 
+static int tsnep_rx_prealloc(struct tsnep_rx *rx)
+{
+	struct tsnep_rx_entry *entry;
+	int i;
+
+	/* prealloc all ring entries except the last one, because ring cannot be
+	 * filled completely
+	 */
+	for (i = 0; i < TSNEP_RING_SIZE - 1; i++) {
+		entry = &rx->entry[i];
+		entry->page = page_pool_dev_alloc_pages(rx->page_pool);
+		if (!entry->page)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
 {
 	int desc_refilled;
@@ -990,22 +1016,118 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
 	return desc_refilled;
 }
 
+static void tsnep_rx_set_xdp(struct tsnep_rx *rx, struct tsnep_rx_entry *entry,
+			     struct xdp_buff *xdp)
+{
+	entry->xdp = xdp;
+	entry->len = TSNEP_XSK_RX_BUF_SIZE;
+	entry->dma = xsk_buff_xdp_get_dma(entry->xdp);
+	entry->desc->rx = __cpu_to_le64(entry->dma);
+}
+
+static int tsnep_rx_alloc_buffer_zc(struct tsnep_rx *rx, int index)
+{
+	struct tsnep_rx_entry *entry = &rx->entry[index];
+	struct xdp_buff *xdp;
+
+	xdp = xsk_buff_alloc(rx->xsk_pool);
+	if (unlikely(!xdp))
+		return -ENOMEM;
+	tsnep_rx_set_xdp(rx, entry, xdp);
+
+	return 0;
+}
+
+static void tsnep_rx_reuse_buffer_zc(struct tsnep_rx *rx, int index)
+{
+	struct tsnep_rx_entry *entry = &rx->entry[index];
+	struct tsnep_rx_entry *read = &rx->entry[rx->read];
+
+	tsnep_rx_set_xdp(rx, entry, read->xdp);
+	read->xdp = NULL;
+}
+
+static int tsnep_rx_alloc_zc(struct tsnep_rx *rx, int count, bool reuse)
+{
+	bool alloc_failed = false;
+	int i, index, retval;
+
+	for (i = 0; i < count && !alloc_failed; i++) {
+		index = (rx->write + i) % TSNEP_RING_SIZE;
+
+		retval = tsnep_rx_alloc_buffer_zc(rx, index);
+		if (unlikely(retval)) {
+			rx->alloc_failed++;
+			alloc_failed = true;
+
+			/* reuse only if no other allocation was successful */
+			if (i == 0 && reuse)
+				tsnep_rx_reuse_buffer_zc(rx, index);
+			else
+				break;
+		}
+		tsnep_rx_activate(rx, index);
+	}
+
+	if (i)
+		rx->write = (rx->write + i) % TSNEP_RING_SIZE;
+
+	return i;
+}
+
+static void tsnep_rx_free_zc(struct tsnep_rx *rx, struct xsk_buff_pool *pool)
+{
+	struct tsnep_rx_entry *entry;
+	int i;
+
+	for (i = 0; i < TSNEP_RING_SIZE; i++) {
+		entry = &rx->entry[i];
+		if (entry->xdp)
+			xsk_buff_free(entry->xdp);
+		entry->xdp = NULL;
+	}
+}
+
+static void tsnep_rx_prealloc_zc(struct tsnep_rx *rx,
+				 struct xsk_buff_pool *pool)
+{
+	struct tsnep_rx_entry *entry;
+	int i;
+
+	/* prealloc all ring entries except the last one, because ring cannot be
+	 * filled completely, as many buffers as possible is enough as wakeup is
+	 * done if new buffers are available
+	 */
+	for (i = 0; i < TSNEP_RING_SIZE - 1; i++) {
+		entry = &rx->entry[i];
+		entry->xdp = xsk_buff_alloc(pool);
+		if (!entry->xdp)
+			break;
+	}
+}
+
+static int tsnep_rx_refill_zc(struct tsnep_rx *rx, int count, bool reuse)
+{
+	int desc_refilled;
+
+	desc_refilled = tsnep_rx_alloc_zc(rx, count, reuse);
+	if (desc_refilled)
+		tsnep_rx_enable(rx);
+
+	return desc_refilled;
+}
+
 static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
 			       struct xdp_buff *xdp, int *status,
-			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
+			       struct netdev_queue *tx_nq, struct tsnep_tx *tx,
+			       bool zc)
 {
 	unsigned int length;
-	unsigned int sync;
 	u32 act;
 
 	length = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
 
 	act = bpf_prog_run_xdp(prog, xdp);
-
-	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
-	sync = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
-	sync = max(sync, length);
-
 	switch (act) {
 	case XDP_PASS:
 		return false;
@@ -1027,8 +1149,21 @@ static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
 		trace_xdp_exception(rx->adapter->netdev, prog, act);
 		fallthrough;
 	case XDP_DROP:
-		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
-				   sync, true);
+		if (zc) {
+			xsk_buff_free(xdp);
+		} else {
+			unsigned int sync;
+
+			/* Due xdp_adjust_tail: DMA sync for_device cover max
+			 * len CPU touch
+			 */
+			sync = xdp->data_end - xdp->data_hard_start -
+			       XDP_PACKET_HEADROOM;
+			sync = max(sync, length);
+			page_pool_put_page(rx->page_pool,
+					   virt_to_head_page(xdp->data), sync,
+					   true);
+		}
 		return true;
 	}
 }
@@ -1181,7 +1316,8 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 					 length, false);
 
 			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
-						     &xdp_status, tx_nq, tx);
+						     &xdp_status, tx_nq, tx,
+						     false);
 			if (consume) {
 				rx->packets++;
 				rx->bytes += length;
@@ -1205,6 +1341,125 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 	return done;
 }
 
+static int tsnep_rx_poll_zc(struct tsnep_rx *rx, struct napi_struct *napi,
+			    int budget)
+{
+	struct tsnep_rx_entry *entry;
+	struct netdev_queue *tx_nq;
+	struct bpf_prog *prog;
+	struct tsnep_tx *tx;
+	int desc_available;
+	int xdp_status = 0;
+	struct page *page;
+	int done = 0;
+	int length;
+
+	desc_available = tsnep_rx_desc_available(rx);
+	prog = READ_ONCE(rx->adapter->xdp_prog);
+	if (prog) {
+		tx_nq = netdev_get_tx_queue(rx->adapter->netdev,
+					    rx->tx_queue_index);
+		tx = &rx->adapter->tx[rx->tx_queue_index];
+	}
+
+	while (likely(done < budget) && (rx->read != rx->write)) {
+		entry = &rx->entry[rx->read];
+		if ((__le32_to_cpu(entry->desc_wb->properties) &
+		     TSNEP_DESC_OWNER_COUNTER_MASK) !=
+		    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
+			break;
+		done++;
+
+		if (desc_available >= TSNEP_RING_RX_REFILL) {
+			bool reuse = desc_available >= TSNEP_RING_RX_REUSE;
+
+			desc_available -= tsnep_rx_refill_zc(rx, desc_available,
+							     reuse);
+			if (!entry->xdp) {
+				/* buffer has been reused for refill to prevent
+				 * empty RX ring, thus buffer cannot be used for
+				 * RX processing
+				 */
+				rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
+				desc_available++;
+
+				rx->dropped++;
+
+				continue;
+			}
+		}
+
+		/* descriptor properties shall be read first, because valid data
+		 * is signaled there
+		 */
+		dma_rmb();
+
+		prefetch(entry->xdp->data);
+		length = __le32_to_cpu(entry->desc_wb->properties) &
+			 TSNEP_DESC_LENGTH_MASK;
+		entry->xdp->data_end = entry->xdp->data + length;
+		xsk_buff_dma_sync_for_cpu(entry->xdp, rx->xsk_pool);
+
+		/* RX metadata with timestamps is in front of actual data,
+		 * subtract metadata size to get length of actual data and
+		 * consider metadata size as offset of actual data during RX
+		 * processing
+		 */
+		length -= TSNEP_RX_INLINE_METADATA_SIZE;
+
+		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
+		desc_available++;
+
+		if (prog) {
+			bool consume;
+
+			entry->xdp->data += TSNEP_RX_INLINE_METADATA_SIZE;
+			entry->xdp->data_meta += TSNEP_RX_INLINE_METADATA_SIZE;
+
+			consume = tsnep_xdp_run_prog(rx, prog, entry->xdp,
+						     &xdp_status, tx_nq, tx,
+						     true);
+			if (consume) {
+				rx->packets++;
+				rx->bytes += length;
+
+				entry->xdp = NULL;
+
+				continue;
+			}
+		}
+
+		page = page_pool_dev_alloc_pages(rx->page_pool);
+		if (page) {
+			memcpy(page_address(page) + TSNEP_RX_OFFSET,
+			       entry->xdp->data - TSNEP_RX_INLINE_METADATA_SIZE,
+			       length + TSNEP_RX_INLINE_METADATA_SIZE);
+			tsnep_rx_page(rx, napi, page, length);
+		} else {
+			rx->dropped++;
+		}
+		xsk_buff_free(entry->xdp);
+		entry->xdp = NULL;
+	}
+
+	if (xdp_status)
+		tsnep_finalize_xdp(rx->adapter, xdp_status, tx_nq, tx);
+
+	if (desc_available)
+		desc_available -= tsnep_rx_refill_zc(rx, desc_available, false);
+
+	if (xsk_uses_need_wakeup(rx->xsk_pool)) {
+		if (desc_available)
+			xsk_set_rx_need_wakeup(rx->xsk_pool);
+		else
+			xsk_clear_rx_need_wakeup(rx->xsk_pool);
+
+		return done;
+	}
+
+	return desc_available ? budget : done;
+}
+
 static bool tsnep_rx_pending(struct tsnep_rx *rx)
 {
 	struct tsnep_rx_entry *entry;
@@ -1232,14 +1487,30 @@ static int tsnep_rx_open(struct tsnep_rx *rx)
 	tsnep_rx_init(rx);
 
 	desc_available = tsnep_rx_desc_available(rx);
-	retval = tsnep_rx_alloc(rx, desc_available, false);
+	if (rx->xsk_pool)
+		retval = tsnep_rx_alloc_zc(rx, desc_available, false);
+	else
+		retval = tsnep_rx_alloc(rx, desc_available, false);
 	if (retval != desc_available) {
-		tsnep_rx_ring_cleanup(rx);
+		retval = -ENOMEM;
 
-		return -ENOMEM;
+		goto alloc_failed;
+	}
+
+	/* prealloc pages to prevent allocation failures when XSK pool is
+	 * disabled at runtime
+	 */
+	if (rx->xsk_pool) {
+		retval = tsnep_rx_prealloc(rx);
+		if (retval)
+			goto alloc_failed;
 	}
 
 	return 0;
+
+alloc_failed:
+	tsnep_rx_ring_cleanup(rx);
+	return retval;
 }
 
 static void tsnep_rx_close(struct tsnep_rx *rx)
@@ -1247,6 +1518,43 @@ static void tsnep_rx_close(struct tsnep_rx *rx)
 	tsnep_rx_ring_cleanup(rx);
 }
 
+static void tsnep_rx_reopen(struct tsnep_rx *rx)
+{
+	int i;
+
+	tsnep_rx_init(rx);
+
+	/* prevent allocation failures by using already allocated RX buffers */
+	for (i = 0; i < TSNEP_RING_SIZE; i++) {
+		struct tsnep_rx_entry *entry = &rx->entry[i];
+
+		/* defined initial values for properties are required for
+		 * correct owner counter checking
+		 */
+		entry->desc->properties = 0;
+		entry->desc_wb->properties = 0;
+
+		if (!rx->xsk_pool && entry->page) {
+			struct tsnep_rx_entry *write_entry;
+
+			/* move page to write index entry */
+			write_entry = &rx->entry[rx->write];
+			if (write_entry != entry) {
+				write_entry->page = entry->page;
+				entry->page = NULL;
+			}
+
+			tsnep_rx_set_page(rx, write_entry, write_entry->page);
+			tsnep_rx_activate(rx, rx->write);
+			rx->write++;
+		} else if (rx->xsk_pool && entry->xdp) {
+			tsnep_rx_set_xdp(rx, entry, entry->xdp);
+			tsnep_rx_activate(rx, rx->write);
+			rx->write++;
+		}
+	}
+}
+
 static bool tsnep_pending(struct tsnep_queue *queue)
 {
 	if (queue->tx && tsnep_tx_pending(queue->tx))
@@ -1269,7 +1577,9 @@ static int tsnep_poll(struct napi_struct *napi, int budget)
 		complete = tsnep_tx_poll(queue->tx, budget);
 
 	if (queue->rx) {
-		done = tsnep_rx_poll(queue->rx, napi, budget);
+		done = queue->rx->xsk_pool ?
+		       tsnep_rx_poll_zc(queue->rx, napi, budget) :
+		       tsnep_rx_poll(queue->rx, napi, budget);
 		if (done >= budget)
 			complete = false;
 	}
@@ -1350,8 +1660,12 @@ static void tsnep_queue_close(struct tsnep_queue *queue, bool first)
 
 	tsnep_free_irq(queue, first);
 
-	if (rx && xdp_rxq_info_is_reg(&rx->xdp_rxq))
-		xdp_rxq_info_unreg(&rx->xdp_rxq);
+	if (rx) {
+		if (xdp_rxq_info_is_reg(&rx->xdp_rxq))
+			xdp_rxq_info_unreg(&rx->xdp_rxq);
+		if (xdp_rxq_info_is_reg(&rx->xdp_rxq_zc))
+			xdp_rxq_info_unreg(&rx->xdp_rxq_zc);
+	}
 
 	netif_napi_del(&queue->napi);
 }
@@ -1376,6 +1690,10 @@ static int tsnep_queue_open(struct tsnep_adapter *adapter,
 		else
 			rx->tx_queue_index = 0;
 
+		/* prepare both memory models to eliminate possible registration
+		 * errors when memory model is switched between page pool and
+		 * XSK pool during runtime
+		 */
 		retval = xdp_rxq_info_reg(&rx->xdp_rxq, adapter->netdev,
 					  rx->queue_index, queue->napi.napi_id);
 		if (retval)
@@ -1385,6 +1703,17 @@ static int tsnep_queue_open(struct tsnep_adapter *adapter,
 						    rx->page_pool);
 		if (retval)
 			goto failed;
+		retval = xdp_rxq_info_reg(&rx->xdp_rxq_zc, adapter->netdev,
+					  rx->queue_index, queue->napi.napi_id);
+		if (retval)
+			goto failed;
+		retval = xdp_rxq_info_reg_mem_model(&rx->xdp_rxq_zc,
+						    MEM_TYPE_XSK_BUFF_POOL,
+						    NULL);
+		if (retval)
+			goto failed;
+		if (rx->xsk_pool)
+			xsk_pool_set_rxq_info(rx->xsk_pool, &rx->xdp_rxq_zc);
 	}
 
 	retval = tsnep_request_irq(queue, first);
@@ -1500,6 +1829,51 @@ static int tsnep_netdev_close(struct net_device *netdev)
 	return 0;
 }
 
+int tsnep_enable_xsk(struct tsnep_queue *queue, struct xsk_buff_pool *pool)
+{
+	bool running = netif_running(queue->adapter->netdev);
+	u32 frame_size;
+
+	frame_size = xsk_pool_get_rx_frame_size(pool);
+	if (frame_size < TSNEP_XSK_RX_BUF_SIZE)
+		return -EOPNOTSUPP;
+
+	xsk_pool_set_rxq_info(pool, &queue->rx->xdp_rxq_zc);
+
+	tsnep_rx_prealloc_zc(queue->rx, pool);
+
+	if (running)
+		tsnep_queue_disable(queue);
+
+	queue->rx->xsk_pool = pool;
+
+	tsnep_rx_reopen(queue->rx);
+
+	if (running)
+		tsnep_queue_enable(queue);
+
+	return 0;
+}
+
+void tsnep_disable_xsk(struct tsnep_queue *queue)
+{
+	bool running = netif_running(queue->adapter->netdev);
+	struct xsk_buff_pool *old_pool;
+
+	if (running)
+		tsnep_queue_disable(queue);
+
+	old_pool = queue->rx->xsk_pool;
+	queue->rx->xsk_pool = NULL;
+
+	tsnep_rx_reopen(queue->rx);
+
+	if (running)
+		tsnep_queue_enable(queue);
+
+	tsnep_rx_free_zc(queue->rx, old_pool);
+}
+
 static netdev_tx_t tsnep_netdev_xmit_frame(struct sk_buff *skb,
 					   struct net_device *netdev)
 {
@@ -1649,6 +2023,9 @@ static int tsnep_netdev_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 	switch (bpf->command) {
 	case XDP_SETUP_PROG:
 		return tsnep_xdp_setup_prog(adapter, bpf->prog, bpf->extack);
+	case XDP_SETUP_XSK_POOL:
+		return tsnep_xdp_setup_pool(adapter, bpf->xsk.pool,
+					    bpf->xsk.queue_id);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1703,6 +2080,23 @@ static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
 	return nxmit;
 }
 
+static int tsnep_netdev_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
+{
+	struct tsnep_adapter *adapter = netdev_priv(dev);
+	struct tsnep_queue *queue;
+
+	if (queue_id >= adapter->num_rx_queues ||
+	    queue_id >= adapter->num_tx_queues)
+		return -EINVAL;
+
+	queue = &adapter->queue[queue_id];
+
+	if (!napi_if_scheduled_mark_missed(&queue->napi))
+		napi_schedule(&queue->napi);
+
+	return 0;
+}
+
 static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_open = tsnep_netdev_open,
 	.ndo_stop = tsnep_netdev_close,
@@ -1716,6 +2110,7 @@ static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_setup_tc = tsnep_tc_setup,
 	.ndo_bpf = tsnep_netdev_bpf,
 	.ndo_xdp_xmit = tsnep_netdev_xdp_xmit,
+	.ndo_xsk_wakeup = tsnep_netdev_xsk_wakeup,
 };
 
 static int tsnep_mac_init(struct tsnep_adapter *adapter)
@@ -1974,7 +2369,8 @@ static int tsnep_probe(struct platform_device *pdev)
 
 	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
 			       NETDEV_XDP_ACT_NDO_XMIT |
-			       NETDEV_XDP_ACT_NDO_XMIT_SG;
+			       NETDEV_XDP_ACT_NDO_XMIT_SG |
+			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
diff --git a/drivers/net/ethernet/engleder/tsnep_xdp.c b/drivers/net/ethernet/engleder/tsnep_xdp.c
index 4d14cb1fd772..6ec137870b59 100644
--- a/drivers/net/ethernet/engleder/tsnep_xdp.c
+++ b/drivers/net/ethernet/engleder/tsnep_xdp.c
@@ -6,6 +6,8 @@
 
 #include "tsnep.h"
 
+#define TSNEP_XSK_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC)
+
 int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
 			 struct netlink_ext_ack *extack)
 {
@@ -17,3 +19,68 @@ int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
 
 	return 0;
 }
+
+static int tsnep_xdp_enable_pool(struct tsnep_adapter *adapter,
+				 struct xsk_buff_pool *pool, u16 queue_id)
+{
+	struct tsnep_queue *queue;
+	int retval;
+
+	if (queue_id >= adapter->num_rx_queues ||
+	    queue_id >= adapter->num_tx_queues)
+		return -EINVAL;
+
+	queue = &adapter->queue[queue_id];
+	if (queue->rx->queue_index != queue_id ||
+	    queue->tx->queue_index != queue_id) {
+		netdev_err(adapter->netdev,
+			   "XSK support only for TX/RX queue pairs\n");
+
+		return -EOPNOTSUPP;
+	}
+
+	retval = xsk_pool_dma_map(pool, adapter->dmadev, TSNEP_XSK_DMA_ATTR);
+	if (retval) {
+		netdev_err(adapter->netdev, "failed to map XSK pool\n");
+
+		return retval;
+	}
+
+	retval = tsnep_enable_xsk(queue, pool);
+	if (retval) {
+		xsk_pool_dma_unmap(pool, TSNEP_XSK_DMA_ATTR);
+
+		return retval;
+	}
+
+	return 0;
+}
+
+static int tsnep_xdp_disable_pool(struct tsnep_adapter *adapter, u16 queue_id)
+{
+	struct xsk_buff_pool *pool;
+	struct tsnep_queue *queue;
+
+	if (queue_id >= adapter->num_rx_queues ||
+	    queue_id >= adapter->num_tx_queues)
+		return -EINVAL;
+
+	pool = xsk_get_pool_from_qid(adapter->netdev, queue_id);
+	if (!pool)
+		return -EINVAL;
+
+	queue = &adapter->queue[queue_id];
+
+	tsnep_disable_xsk(queue);
+
+	xsk_pool_dma_unmap(pool, TSNEP_XSK_DMA_ATTR);
+
+	return 0;
+}
+
+int tsnep_xdp_setup_pool(struct tsnep_adapter *adapter,
+			 struct xsk_buff_pool *pool, u16 queue_id)
+{
+	return pool ? tsnep_xdp_enable_pool(adapter, pool, queue_id) :
+		      tsnep_xdp_disable_pool(adapter, queue_id);
+}
-- 
2.30.2

