Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DD26E31F2
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjDOOn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjDOOnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:43:07 -0400
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DDB4EF7;
        Sat, 15 Apr 2023 07:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sbKtFj/yowcJ8K5JqIURnDU0jQHlj7z9S5baqSD5rVY=; b=bi0i3v9AAkkMeZKadooklTs14X
        cGG3Kdvu9P9s3VwrSpImtsUy/ETASLjLkgp9CKRVUeev+8JZtiDVI7iqmS2+GCNaP1amaDbCW4J39
        ibexgE2P4mDvLrJ/aK0QhMfJOd2Yqo2pXj35F31/zNmvjP77WQv6U7Mw+OnoFJor/s0s=;
Received: from 88-117-57-231.adsl.highway.telekom.at ([88.117.57.231] helo=hornet.engleder.at)
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pnh7G-0003zN-2I; Sat, 15 Apr 2023 16:43:02 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 5/6] tsnep: Add XDP socket zero-copy RX support
Date:   Sat, 15 Apr 2023 16:42:55 +0200
Message-Id: <20230415144256.27884-6-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230415144256.27884-1-gerhard@engleder-embedded.com>
References: <20230415144256.27884-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

Test results with A53 1.2GHz:

xdpsock rxdrop copy mode:
                   pps            pkts           1.00
rx                 856,054        10,625,775
Two CPUs with both 100% utilization.

xdpsock rxdrop zero-copy mode:
                   pps            pkts           1.00
rx                 889,388        4,615,284
Two CPUs with 100% and 20% utilization.

xdpsock l2fwd copy mode:
                   pps            pkts           1.00
rx                 248,985        7,315,885
tx                 248,921        7,315,885
Two CPUs with 100% and 10% utilization.

xdpsock l2fwd zero-copy mode:
                   pps            pkts           1.00
rx                 254,735        3,039,456
tx                 254,735        3,039,456
Two CPUs with 100% and 4% utilization.

Packet rate increases and CPU utilization is reduced in both cases.
100% CPU load seems to the base load. This load is consumed by ksoftirqd
just for dropping the generated packets without xdpsock running.

Using batch API reduced CPU utilization slightly, but measurements are
not stable enough to provide meaningful numbers.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |  13 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 491 ++++++++++++++++++++-
 drivers/net/ethernet/engleder/tsnep_xdp.c  |  66 +++
 3 files changed, 555 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 1de26aec78d3..d0bea605a1d1 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -101,7 +101,10 @@ struct tsnep_rx_entry {
 
 	u32 properties;
 
-	struct page *page;
+	union {
+		struct page *page;
+		struct xdp_buff *xdp;
+	};
 	size_t len;
 	dma_addr_t dma;
 };
@@ -121,6 +124,9 @@ struct tsnep_rx {
 	u32 owner_counter;
 	int increment_owner_counter;
 	struct page_pool *page_pool;
+	struct page **page_buffer;
+	struct xsk_buff_pool *xsk_pool;
+	struct xdp_buff **xdp_batch;
 
 	u32 packets;
 	u32 bytes;
@@ -129,6 +135,7 @@ struct tsnep_rx {
 	u32 alloc_failed;
 
 	struct xdp_rxq_info xdp_rxq;
+	struct xdp_rxq_info xdp_rxq_zc;
 };
 
 struct tsnep_queue {
@@ -214,6 +221,8 @@ int tsnep_rxnfc_del_rule(struct tsnep_adapter *adapter,
 
 int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
 			 struct netlink_ext_ack *extack);
+int tsnep_xdp_setup_pool(struct tsnep_adapter *adapter,
+			 struct xsk_buff_pool *pool, u16 queue_id);
 
 #if IS_ENABLED(CONFIG_TSNEP_SELFTESTS)
 int tsnep_ethtool_get_test_count(void);
@@ -242,5 +251,7 @@ static inline void tsnep_ethtool_self_test(struct net_device *dev,
 void tsnep_get_system_time(struct tsnep_adapter *adapter, u64 *time);
 int tsnep_set_irq_coalesce(struct tsnep_queue *queue, u32 usecs);
 u32 tsnep_get_irq_coalesce(struct tsnep_queue *queue);
+int tsnep_enable_xsk(struct tsnep_queue *queue, struct xsk_buff_pool *pool);
+void tsnep_disable_xsk(struct tsnep_queue *queue);
 
 #endif /* _TSNEP_H */
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 2db94b96a1f0..13e5d4438082 100644
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
@@ -777,9 +782,12 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 
 	for (i = 0; i < TSNEP_RING_SIZE; i++) {
 		entry = &rx->entry[i];
-		if (entry->page)
+		if (!rx->xsk_pool && entry->page)
 			page_pool_put_full_page(rx->page_pool, entry->page,
 						false);
+		if (rx->xsk_pool && entry->xdp)
+			xsk_buff_free(entry->xdp);
+		/* xdp is union with page */
 		entry->page = NULL;
 	}
 
@@ -892,6 +900,37 @@ static int tsnep_rx_desc_available(struct tsnep_rx *rx)
 		return rx->read - rx->write - 1;
 }
 
+static void tsnep_rx_free_page_buffer(struct tsnep_rx *rx)
+{
+	struct page **page;
+
+	page = rx->page_buffer;
+	while (*page) {
+		page_pool_put_full_page(rx->page_pool, *page, false);
+		*page = NULL;
+		page++;
+	}
+}
+
+static int tsnep_rx_alloc_page_buffer(struct tsnep_rx *rx)
+{
+	int i;
+
+	/* alloc for all ring entries except the last one, because ring cannot
+	 * be filled completely
+	 */
+	for (i = 0; i < TSNEP_RING_SIZE - 1; i++) {
+		rx->page_buffer[i] = page_pool_dev_alloc_pages(rx->page_pool);
+		if (!rx->page_buffer[i]) {
+			tsnep_rx_free_page_buffer(rx);
+
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
 static void tsnep_rx_set_page(struct tsnep_rx *rx, struct tsnep_rx_entry *entry,
 			      struct page *page)
 {
@@ -927,7 +966,7 @@ static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
 {
 	struct tsnep_rx_entry *entry = &rx->entry[index];
 
-	/* TSNEP_MAX_RX_BUF_SIZE is a multiple of 4 */
+	/* TSNEP_MAX_RX_BUF_SIZE and TSNEP_XSK_RX_BUF_SIZE are multiple of 4 */
 	entry->properties = entry->len & TSNEP_DESC_LENGTH_MASK;
 	entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
 	if (index == rx->increment_owner_counter) {
@@ -989,6 +1028,76 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
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
+	u32 allocated;
+	int i;
+
+	allocated = xsk_buff_alloc_batch(rx->xsk_pool, rx->xdp_batch, count);
+	for (i = 0; i < allocated; i++) {
+		int index = (rx->write + i) & TSNEP_RING_MASK;
+		struct tsnep_rx_entry *entry = &rx->entry[index];
+
+		tsnep_rx_set_xdp(rx, entry, rx->xdp_batch[i]);
+		tsnep_rx_activate(rx, index);
+	}
+	if (i == 0) {
+		rx->alloc_failed++;
+
+		if (reuse) {
+			tsnep_rx_reuse_buffer_zc(rx, rx->write);
+			tsnep_rx_activate(rx, rx->write);
+		}
+	}
+
+	if (i)
+		rx->write = (rx->write + i) & TSNEP_RING_MASK;
+
+	return i;
+}
+
+static void tsnep_rx_free_zc(struct tsnep_rx *rx)
+{
+	int i;
+
+	for (i = 0; i < TSNEP_RING_SIZE; i++) {
+		struct tsnep_rx_entry *entry = &rx->entry[i];
+
+		if (entry->xdp)
+			xsk_buff_free(entry->xdp);
+		entry->xdp = NULL;
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
 			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
@@ -1000,11 +1109,6 @@ static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
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
@@ -1026,12 +1130,56 @@ static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
 		trace_xdp_exception(rx->adapter->netdev, prog, act);
 		fallthrough;
 	case XDP_DROP:
+		/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU
+		 * touch
+		 */
+		sync = xdp->data_end - xdp->data_hard_start -
+		       XDP_PACKET_HEADROOM;
+		sync = max(sync, length);
 		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
 				   sync, true);
 		return true;
 	}
 }
 
+static bool tsnep_xdp_run_prog_zc(struct tsnep_rx *rx, struct bpf_prog *prog,
+				  struct xdp_buff *xdp, int *status,
+				  struct netdev_queue *tx_nq,
+				  struct tsnep_tx *tx)
+{
+	u32 act;
+
+	act = bpf_prog_run_xdp(prog, xdp);
+
+	/* XDP_REDIRECT is the main action for zero-copy */
+	if (likely(act == XDP_REDIRECT)) {
+		if (xdp_do_redirect(rx->adapter->netdev, xdp, prog) < 0)
+			goto out_failure;
+		*status |= TSNEP_XDP_REDIRECT;
+		return true;
+	}
+
+	switch (act) {
+	case XDP_PASS:
+		return false;
+	case XDP_TX:
+		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx))
+			goto out_failure;
+		*status |= TSNEP_XDP_TX;
+		return true;
+	default:
+		bpf_warn_invalid_xdp_action(rx->adapter->netdev, prog, act);
+		fallthrough;
+	case XDP_ABORTED:
+out_failure:
+		trace_xdp_exception(rx->adapter->netdev, prog, act);
+		fallthrough;
+	case XDP_DROP:
+		xsk_buff_free(xdp);
+		return true;
+	}
+}
+
 static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status,
 			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
 {
@@ -1204,6 +1352,124 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
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
+				rx->read = (rx->read + 1) & TSNEP_RING_MASK;
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
+		xsk_buff_set_size(entry->xdp, length);
+		xsk_buff_dma_sync_for_cpu(entry->xdp, rx->xsk_pool);
+
+		/* RX metadata with timestamps is in front of actual data,
+		 * subtract metadata size to get length of actual data and
+		 * consider metadata size as offset of actual data during RX
+		 * processing
+		 */
+		length -= TSNEP_RX_INLINE_METADATA_SIZE;
+
+		rx->read = (rx->read + 1) & TSNEP_RING_MASK;
+		desc_available++;
+
+		if (prog) {
+			bool consume;
+
+			entry->xdp->data += TSNEP_RX_INLINE_METADATA_SIZE;
+			entry->xdp->data_meta += TSNEP_RX_INLINE_METADATA_SIZE;
+
+			consume = tsnep_xdp_run_prog_zc(rx, prog, entry->xdp,
+							&xdp_status, tx_nq, tx);
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
@@ -1231,21 +1497,113 @@ static int tsnep_rx_open(struct tsnep_rx *rx)
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
+		retval = tsnep_rx_alloc_page_buffer(rx);
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
 {
+	if (rx->xsk_pool)
+		tsnep_rx_free_page_buffer(rx);
+
 	tsnep_rx_ring_cleanup(rx);
 }
 
+static void tsnep_rx_reopen(struct tsnep_rx *rx)
+{
+	struct page **page = rx->page_buffer;
+	int i;
+
+	tsnep_rx_init(rx);
+
+	for (i = 0; i < TSNEP_RING_SIZE; i++) {
+		struct tsnep_rx_entry *entry = &rx->entry[i];
+
+		/* defined initial values for properties are required for
+		 * correct owner counter checking
+		 */
+		entry->desc->properties = 0;
+		entry->desc_wb->properties = 0;
+
+		/* prevent allocation failures by reusing kept pages */
+		if (*page) {
+			tsnep_rx_set_page(rx, entry, *page);
+			tsnep_rx_activate(rx, rx->write);
+			rx->write++;
+
+			*page = NULL;
+			page++;
+		}
+	}
+}
+
+static void tsnep_rx_reopen_xsk(struct tsnep_rx *rx)
+{
+	struct page **page = rx->page_buffer;
+	u32 allocated;
+	int i;
+
+	tsnep_rx_init(rx);
+
+	/* alloc all ring entries except the last one, because ring cannot be
+	 * filled completely, as many buffers as possible is enough as wakeup is
+	 * done if new buffers are available
+	 */
+	allocated = xsk_buff_alloc_batch(rx->xsk_pool, rx->xdp_batch,
+					 TSNEP_RING_SIZE - 1);
+
+	for (i = 0; i < TSNEP_RING_SIZE; i++) {
+		struct tsnep_rx_entry *entry = &rx->entry[i];
+
+		/* keep pages to prevent allocation failures when xsk is
+		 * disabled
+		 */
+		if (entry->page) {
+			*page = entry->page;
+			entry->page = NULL;
+
+			page++;
+		}
+
+		/* defined initial values for properties are required for
+		 * correct owner counter checking
+		 */
+		entry->desc->properties = 0;
+		entry->desc_wb->properties = 0;
+
+		if (allocated) {
+			tsnep_rx_set_xdp(rx, entry,
+					 rx->xdp_batch[allocated - 1]);
+			tsnep_rx_activate(rx, rx->write);
+			rx->write++;
+
+			allocated--;
+		}
+	}
+}
+
 static bool tsnep_pending(struct tsnep_queue *queue)
 {
 	if (queue->tx && tsnep_tx_pending(queue->tx))
@@ -1268,7 +1626,9 @@ static int tsnep_poll(struct napi_struct *napi, int budget)
 		complete = tsnep_tx_poll(queue->tx, budget);
 
 	if (queue->rx) {
-		done = tsnep_rx_poll(queue->rx, napi, budget);
+		done = queue->rx->xsk_pool ?
+		       tsnep_rx_poll_zc(queue->rx, napi, budget) :
+		       tsnep_rx_poll(queue->rx, napi, budget);
 		if (done >= budget)
 			complete = false;
 	}
@@ -1349,8 +1709,12 @@ static void tsnep_queue_close(struct tsnep_queue *queue, bool first)
 
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
@@ -1373,6 +1737,10 @@ static int tsnep_queue_open(struct tsnep_adapter *adapter,
 		else
 			rx->tx_queue_index = 0;
 
+		/* prepare both memory models to eliminate possible registration
+		 * errors when memory model is switched between page pool and
+		 * XSK pool during runtime
+		 */
 		retval = xdp_rxq_info_reg(&rx->xdp_rxq, adapter->netdev,
 					  rx->queue_index, queue->napi.napi_id);
 		if (retval)
@@ -1382,6 +1750,17 @@ static int tsnep_queue_open(struct tsnep_adapter *adapter,
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
@@ -1497,6 +1876,67 @@ static int tsnep_netdev_close(struct net_device *netdev)
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
+	queue->rx->page_buffer = kcalloc(TSNEP_RING_SIZE,
+					 sizeof(*queue->rx->page_buffer),
+					 GFP_KERNEL);
+	if (!queue->rx->page_buffer)
+		return -ENOMEM;
+	queue->rx->xdp_batch = kcalloc(TSNEP_RING_SIZE,
+				       sizeof(*queue->rx->xdp_batch),
+				       GFP_KERNEL);
+	if (!queue->rx->xdp_batch) {
+		kfree(queue->rx->page_buffer);
+		queue->rx->page_buffer = NULL;
+
+		return -ENOMEM;
+	}
+
+	xsk_pool_set_rxq_info(pool, &queue->rx->xdp_rxq_zc);
+
+	if (running)
+		tsnep_queue_disable(queue);
+
+	queue->rx->xsk_pool = pool;
+
+	if (running) {
+		tsnep_rx_reopen_xsk(queue->rx);
+		tsnep_queue_enable(queue);
+	}
+
+	return 0;
+}
+
+void tsnep_disable_xsk(struct tsnep_queue *queue)
+{
+	bool running = netif_running(queue->adapter->netdev);
+
+	if (running)
+		tsnep_queue_disable(queue);
+
+	tsnep_rx_free_zc(queue->rx);
+
+	queue->rx->xsk_pool = NULL;
+
+	if (running) {
+		tsnep_rx_reopen(queue->rx);
+		tsnep_queue_enable(queue);
+	}
+
+	kfree(queue->rx->xdp_batch);
+	queue->rx->xdp_batch = NULL;
+	kfree(queue->rx->page_buffer);
+	queue->rx->page_buffer = NULL;
+}
+
 static netdev_tx_t tsnep_netdev_xmit_frame(struct sk_buff *skb,
 					   struct net_device *netdev)
 {
@@ -1646,6 +2086,9 @@ static int tsnep_netdev_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 	switch (bpf->command) {
 	case XDP_SETUP_PROG:
 		return tsnep_xdp_setup_prog(adapter, bpf->prog, bpf->extack);
+	case XDP_SETUP_XSK_POOL:
+		return tsnep_xdp_setup_pool(adapter, bpf->xsk.pool,
+					    bpf->xsk.queue_id);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1700,6 +2143,24 @@ static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
 	return nxmit;
 }
 
+static int tsnep_netdev_xsk_wakeup(struct net_device *dev, u32 queue_id,
+				   u32 flags)
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
@@ -1713,6 +2174,7 @@ static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_setup_tc = tsnep_tc_setup,
 	.ndo_bpf = tsnep_netdev_bpf,
 	.ndo_xdp_xmit = tsnep_netdev_xdp_xmit,
+	.ndo_xsk_wakeup = tsnep_netdev_xsk_wakeup,
 };
 
 static int tsnep_mac_init(struct tsnep_adapter *adapter)
@@ -1973,7 +2435,8 @@ static int tsnep_probe(struct platform_device *pdev)
 
 	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
 			       NETDEV_XDP_ACT_NDO_XMIT |
-			       NETDEV_XDP_ACT_NDO_XMIT_SG;
+			       NETDEV_XDP_ACT_NDO_XMIT_SG |
+			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
diff --git a/drivers/net/ethernet/engleder/tsnep_xdp.c b/drivers/net/ethernet/engleder/tsnep_xdp.c
index 4d14cb1fd772..c0513848c547 100644
--- a/drivers/net/ethernet/engleder/tsnep_xdp.c
+++ b/drivers/net/ethernet/engleder/tsnep_xdp.c
@@ -17,3 +17,69 @@ int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
 
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
+	retval = xsk_pool_dma_map(pool, adapter->dmadev,
+				  DMA_ATTR_SKIP_CPU_SYNC);
+	if (retval) {
+		netdev_err(adapter->netdev, "failed to map XSK pool\n");
+
+		return retval;
+	}
+
+	retval = tsnep_enable_xsk(queue, pool);
+	if (retval) {
+		xsk_pool_dma_unmap(pool, DMA_ATTR_SKIP_CPU_SYNC);
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
+	xsk_pool_dma_unmap(pool, DMA_ATTR_SKIP_CPU_SYNC);
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

