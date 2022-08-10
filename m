Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DFC58E92D
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiHJI6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbiHJI56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:57:58 -0400
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FFB6E8AC
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:57:52 -0700 (PDT)
X-QQ-mid: bizesmtp82t1660121804tz52nvpf
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 10 Aug 2022 16:56:43 +0800 (CST)
X-QQ-SSF: 01400000000000G0S000B00A0000000
X-QQ-FEAT: znfcQSa1hKZM/58imM7esN9dDFKjq3mNwO4hn70DFRMokADeavE535AeEwwBp
        dcEJmAG4vHHVOiYOe+HOdM1fzb/IXHCDAyqPS0qhmUk4h+w9QJGko6PFuk8VBj1q7umV4aW
        I4RHgxHqQTjmyStRl6UE4rpYEYQ8M2gFwX3ZoYBTLB28XLBDVfXQ+XlOmVb1pywNNS/9aH4
        S5YhoPv2rQ9rIgDPBowrthdTHyQHqvtO5idcHXb/5xdZ6D801A3VBBs7vq2TsC2qDRtbkt8
        tVBPeBT+7YVTiMOvgEmlGkgzTcK8w48RLeBCZM/e/VhEqx4R4F+3UjLMN4V9FHvDBjTt2k5
        7RUe2wzfMt6fISWWdxDYpxNCy0vZF1IVpqktrjqSBjuurTWPQgvg8/ow5Mdup/J+8M4dRUW
        AynbdMCN9/oTZSKlFsPkvA==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next 11/16] net: txgbe: Allocate Rx and Tx resources
Date:   Wed, 10 Aug 2022 16:55:27 +0800
Message-Id: <20220810085532.246613-12-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220810085532.246613-1-jiawenwu@trustnetic.com>
References: <20220810085532.246613-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocate receive and transmit descriptors for all queues.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  64 +++
 .../net/ethernet/wangxun/txgbe/txgbe_lib.c    |   9 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 498 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  45 ++
 4 files changed, 615 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 516b4f865e6d..d3db6f1aabc5 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -12,9 +12,19 @@
 #include "txgbe_type.h"
 
 /* TX/RX descriptor defines */
+#define TXGBE_DEFAULT_TXD               512
+#define TXGBE_DEFAULT_TX_WORK   256
 #define TXGBE_MAX_TXD                   8192
 #define TXGBE_MIN_TXD                   128
 
+#if (PAGE_SIZE < 8192)
+#define TXGBE_DEFAULT_RXD               512
+#define TXGBE_DEFAULT_RX_WORK   256
+#else
+#define TXGBE_DEFAULT_RXD               256
+#define TXGBE_DEFAULT_RX_WORK   128
+#endif
+
 #define TXGBE_MAX_RXD                   8192
 #define TXGBE_MIN_RXD                   128
 
@@ -36,13 +46,36 @@
 
 #define TXGBE_MAX_RX_DESC_POLL          10
 
+/* wrapper around a pointer to a socket buffer,
+ * so a DMA handle can be stored along with the buffer
+ */
+struct txgbe_tx_buffer {
+	union txgbe_tx_desc *next_to_watch;
+	struct sk_buff *skb;
+	DEFINE_DMA_UNMAP_ADDR(dma);
+	DEFINE_DMA_UNMAP_LEN(len);
+};
+
+struct txgbe_rx_buffer {
+	struct sk_buff *skb;
+	dma_addr_t dma;
+	dma_addr_t page_dma;
+	struct page *page;
+};
+
 struct txgbe_ring {
 	struct txgbe_ring *next;        /* pointer to next ring in q_vector */
 	struct txgbe_q_vector *q_vector; /* backpointer to host q_vector */
 	struct net_device *netdev;      /* netdev ring belongs to */
 	struct device *dev;             /* device for DMA mapping */
+	void *desc;                     /* descriptor ring memory */
+	union {
+		struct txgbe_tx_buffer *tx_buffer_info;
+		struct txgbe_rx_buffer *rx_buffer_info;
+	};
 	u8 __iomem *tail;
 	dma_addr_t dma;                 /* phys. address of descriptor ring */
+	unsigned int size;              /* length in bytes */
 
 	u16 count;                      /* amount of descriptors */
 
@@ -50,6 +83,7 @@ struct txgbe_ring {
 	u8 reg_idx;
 	u16 next_to_use;
 	u16 next_to_clean;
+	u16 rx_buf_len;
 	u16 next_to_alloc;
 } ____cacheline_internodealigned_in_smp;
 
@@ -69,6 +103,13 @@ static inline unsigned int txgbe_rx_bufsz(struct txgbe_ring __maybe_unused *ring
 #endif
 }
 
+static inline unsigned int txgbe_rx_pg_order(struct txgbe_ring __maybe_unused *ring)
+{
+	return 0;
+}
+
+#define txgbe_rx_pg_size(_ring) (PAGE_SIZE << txgbe_rx_pg_order(_ring))
+
 struct txgbe_ring_container {
 	struct txgbe_ring *ring;        /* pointer to linked list of rings */
 	u16 work_limit;                 /* total work allowed per interrupt */
@@ -178,10 +219,12 @@ struct txgbe_adapter {
 	/* Tx fast path data */
 	int num_tx_queues;
 	u16 tx_itr_setting;
+	u16 tx_work_limit;
 
 	/* Rx fast path data */
 	int num_rx_queues;
 	u16 rx_itr_setting;
+	u16 rx_work_limit;
 
 	/* TX */
 	struct txgbe_ring *tx_ring[TXGBE_MAX_TX_QUEUES] ____cacheline_aligned_in_smp;
@@ -249,6 +292,15 @@ enum txgbe_state_t {
 	__TXGBE_IN_SFP_INIT,
 };
 
+struct txgbe_cb {
+	dma_addr_t dma;
+	u16     append_cnt;      /* number of skb's appended */
+	bool    page_released;
+	bool    dma_released;
+};
+
+#define TXGBE_CB(skb) ((struct txgbe_cb *)(skb)->cb)
+
 /* needed by txgbe_main.c */
 void txgbe_service_event_schedule(struct txgbe_adapter *adapter);
 void txgbe_assign_netdev_ops(struct net_device *netdev);
@@ -263,6 +315,10 @@ void txgbe_reinit_locked(struct txgbe_adapter *adapter);
 void txgbe_reset(struct txgbe_adapter *adapter);
 s32 txgbe_init_shared_code(struct txgbe_hw *hw);
 void txgbe_disable_device(struct txgbe_adapter *adapter);
+int txgbe_setup_rx_resources(struct txgbe_ring *rx_ring);
+int txgbe_setup_tx_resources(struct txgbe_ring *tx_ring);
+void txgbe_free_rx_resources(struct txgbe_ring *rx_ring);
+void txgbe_free_tx_resources(struct txgbe_ring *tx_ring);
 void txgbe_configure_rx_ring(struct txgbe_adapter *adapter,
 			     struct txgbe_ring *ring);
 void txgbe_configure_tx_ring(struct txgbe_adapter *adapter,
@@ -271,13 +327,21 @@ int txgbe_init_interrupt_scheme(struct txgbe_adapter *adapter);
 void txgbe_reset_interrupt_capability(struct txgbe_adapter *adapter);
 void txgbe_set_interrupt_capability(struct txgbe_adapter *adapter);
 void txgbe_clear_interrupt_scheme(struct txgbe_adapter *adapter);
+void txgbe_unmap_and_free_tx_resource(struct txgbe_ring *ring,
+				      struct txgbe_tx_buffer *tx_buffer);
 void txgbe_configure_port(struct txgbe_adapter *adapter);
 void txgbe_set_rx_mode(struct net_device *netdev);
 int txgbe_write_mc_addr_list(struct net_device *netdev);
 void txgbe_write_eitr(struct txgbe_q_vector *q_vector);
+int txgbe_poll(struct napi_struct *napi, int budget);
 void txgbe_disable_rx_queue(struct txgbe_adapter *adapter,
 			    struct txgbe_ring *ring);
 
+static inline struct netdev_queue *txring_txq(const struct txgbe_ring *ring)
+{
+	return netdev_get_tx_queue(ring->netdev, ring->queue_index);
+}
+
 int txgbe_write_uc_addr_list(struct net_device *netdev, int pool);
 int txgbe_add_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool);
 int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
index e7b6316e3b56..84b7e01cc27e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
@@ -166,11 +166,19 @@ static int txgbe_alloc_q_vector(struct txgbe_adapter *adapter,
 	/* initialize CPU for DCA */
 	q_vector->cpu = -1;
 
+	/* initialize NAPI */
+	netif_napi_add(adapter->netdev, &q_vector->napi,
+		       txgbe_poll, 64);
+
 	/* tie q_vector and adapter together */
 	adapter->q_vector[v_idx] = q_vector;
 	q_vector->adapter = adapter;
 	q_vector->v_idx = v_idx;
 
+	/* initialize work limits */
+	q_vector->tx.work_limit = adapter->tx_work_limit;
+	q_vector->rx.work_limit = adapter->rx_work_limit;
+
 	/* initialize pointer to rings */
 	ring = q_vector->ring;
 
@@ -265,6 +273,7 @@ static void txgbe_free_q_vector(struct txgbe_adapter *adapter, int v_idx)
 		adapter->rx_ring[ring->queue_index] = NULL;
 
 	adapter->q_vector[v_idx] = NULL;
+	netif_napi_del(&q_vector->napi);
 	kfree_rcu(q_vector, rcu);
 }
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 8f6946379c79..c66ad524750b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -41,6 +41,10 @@ static const struct pci_device_id txgbe_pci_tbl[] = {
 static struct workqueue_struct *txgbe_wq;
 
 static bool txgbe_is_sfp(struct txgbe_hw *hw);
+static void txgbe_clean_rx_ring(struct txgbe_ring *rx_ring);
+static void txgbe_clean_tx_ring(struct txgbe_ring *tx_ring);
+static void txgbe_napi_enable_all(struct txgbe_adapter *adapter);
+static void txgbe_napi_disable_all(struct txgbe_adapter *adapter);
 
 static void txgbe_check_minimum_link(struct txgbe_adapter *adapter)
 {
@@ -178,6 +182,28 @@ static void txgbe_set_ivar(struct txgbe_adapter *adapter, s8 direction,
 	}
 }
 
+void txgbe_unmap_and_free_tx_resource(struct txgbe_ring *ring,
+				      struct txgbe_tx_buffer *tx_buffer)
+{
+	if (tx_buffer->skb) {
+		dev_kfree_skb_any(tx_buffer->skb);
+		if (dma_unmap_len(tx_buffer, len))
+			dma_unmap_single(ring->dev,
+					 dma_unmap_addr(tx_buffer, dma),
+					 dma_unmap_len(tx_buffer, len),
+					 DMA_TO_DEVICE);
+	} else if (dma_unmap_len(tx_buffer, len)) {
+		dma_unmap_page(ring->dev,
+			       dma_unmap_addr(tx_buffer, dma),
+			       dma_unmap_len(tx_buffer, len),
+			       DMA_TO_DEVICE);
+	}
+	tx_buffer->next_to_watch = NULL;
+	tx_buffer->skb = NULL;
+	dma_unmap_len_set(tx_buffer, len, 0);
+	/* tx_buffer must be completely set up in the transmit path */
+}
+
 /**
  * txgbe_configure_msix - Configure MSI-X hardware
  * @adapter: board private structure
@@ -438,6 +464,18 @@ static irqreturn_t txgbe_msix_clean_rings(int __always_unused irq, void *data)
 	return IRQ_HANDLED;
 }
 
+/**
+ * txgbe_poll - NAPI polling RX/TX cleanup routine
+ * @napi: napi struct with our devices info in it
+ * @budget: amount of work driver is allowed to do this pass, in packets
+ *
+ * This function will clean all queues associated with a q_vector.
+ **/
+int txgbe_poll(struct napi_struct *napi, int budget)
+{
+	return 0;
+}
+
 /**
  * txgbe_request_msix_irqs - Initialize MSI-X interrupts
  * @adapter: board private structure
@@ -1279,6 +1317,28 @@ void txgbe_set_rx_mode(struct net_device *netdev)
 	wr32(hw, TXGBE_PSR_VM_L2CTL(0), vmolr);
 }
 
+static void txgbe_napi_enable_all(struct txgbe_adapter *adapter)
+{
+	struct txgbe_q_vector *q_vector;
+	int q_idx;
+
+	for (q_idx = 0; q_idx < adapter->num_q_vectors; q_idx++) {
+		q_vector = adapter->q_vector[q_idx];
+		napi_enable(&q_vector->napi);
+	}
+}
+
+static void txgbe_napi_disable_all(struct txgbe_adapter *adapter)
+{
+	struct txgbe_q_vector *q_vector;
+	int q_idx;
+
+	for (q_idx = 0; q_idx < adapter->num_q_vectors; q_idx++) {
+		q_vector = adapter->q_vector[q_idx];
+		napi_disable(&q_vector->napi);
+	}
+}
+
 static void txgbe_configure_pb(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
@@ -1403,6 +1463,7 @@ static void txgbe_up_complete(struct txgbe_adapter *adapter)
 	/* make sure to complete pre-operations */
 	smp_mb__before_atomic();
 	clear_bit(__TXGBE_DOWN, &adapter->state);
+	txgbe_napi_enable_all(adapter);
 
 	if (txgbe_is_sfp(hw)) {
 		txgbe_sfp_link_config(adapter);
@@ -1434,6 +1495,9 @@ static void txgbe_up_complete(struct txgbe_adapter *adapter)
 		wr32(hw, TXGBE_GPIO_EOI, TXGBE_GPIO_EOI_6);
 	txgbe_irq_enable(adapter, true, true);
 
+	/* enable transmits */
+	netif_tx_start_all_queues(adapter->netdev);
+
 	/* bring the link up in the watchdog, this could race with our first
 	 * link up interrupt but shouldn't be a problem
 	 */
@@ -1507,6 +1571,129 @@ void txgbe_reset(struct txgbe_adapter *adapter)
 	TCALL(hw, mac.ops.set_vmdq_san_mac, 0);
 }
 
+/**
+ * txgbe_clean_rx_ring - Free Rx Buffers per Queue
+ * @rx_ring: ring to free buffers from
+ **/
+static void txgbe_clean_rx_ring(struct txgbe_ring *rx_ring)
+{
+	struct device *dev = rx_ring->dev;
+	unsigned long size;
+	u16 i;
+
+	/* ring already cleared, nothing to do */
+	if (!rx_ring->rx_buffer_info)
+		return;
+
+	/* Free all the Rx ring sk_buffs */
+	for (i = 0; i < rx_ring->count; i++) {
+		struct txgbe_rx_buffer *rx_buffer = &rx_ring->rx_buffer_info[i];
+
+		if (rx_buffer->dma) {
+			dma_unmap_single(dev,
+					 rx_buffer->dma,
+					 rx_ring->rx_buf_len,
+					 DMA_FROM_DEVICE);
+			rx_buffer->dma = 0;
+		}
+
+		if (rx_buffer->skb) {
+			struct sk_buff *skb = rx_buffer->skb;
+
+			if (TXGBE_CB(skb)->dma_released) {
+				dma_unmap_single(dev,
+						 TXGBE_CB(skb)->dma,
+						 rx_ring->rx_buf_len,
+						 DMA_FROM_DEVICE);
+				TXGBE_CB(skb)->dma = 0;
+				TXGBE_CB(skb)->dma_released = false;
+			}
+
+			if (TXGBE_CB(skb)->page_released)
+				dma_unmap_page(dev,
+					       TXGBE_CB(skb)->dma,
+					       txgbe_rx_bufsz(rx_ring),
+					       DMA_FROM_DEVICE);
+			dev_kfree_skb(skb);
+			rx_buffer->skb = NULL;
+		}
+
+		if (!rx_buffer->page)
+			continue;
+
+		dma_unmap_page(dev, rx_buffer->page_dma,
+			       txgbe_rx_pg_size(rx_ring),
+			       DMA_FROM_DEVICE);
+
+		__free_pages(rx_buffer->page,
+			     txgbe_rx_pg_order(rx_ring));
+		rx_buffer->page = NULL;
+	}
+
+	size = sizeof(struct txgbe_rx_buffer) * rx_ring->count;
+	memset(rx_ring->rx_buffer_info, 0, size);
+
+	/* Zero out the descriptor ring */
+	memset(rx_ring->desc, 0, rx_ring->size);
+
+	rx_ring->next_to_alloc = 0;
+	rx_ring->next_to_clean = 0;
+	rx_ring->next_to_use = 0;
+}
+
+/**
+ * txgbe_clean_tx_ring - Free Tx Buffers
+ * @tx_ring: ring to be cleaned
+ **/
+static void txgbe_clean_tx_ring(struct txgbe_ring *tx_ring)
+{
+	struct txgbe_tx_buffer *tx_buffer_info;
+	unsigned long size;
+	u16 i;
+
+	/* ring already cleared, nothing to do */
+	if (!tx_ring->tx_buffer_info)
+		return;
+
+	/* Free all the Tx ring sk_buffs */
+	for (i = 0; i < tx_ring->count; i++) {
+		tx_buffer_info = &tx_ring->tx_buffer_info[i];
+		txgbe_unmap_and_free_tx_resource(tx_ring, tx_buffer_info);
+	}
+
+	netdev_tx_reset_queue(txring_txq(tx_ring));
+
+	size = sizeof(struct txgbe_tx_buffer) * tx_ring->count;
+	memset(tx_ring->tx_buffer_info, 0, size);
+
+	/* Zero out the descriptor ring */
+	memset(tx_ring->desc, 0, tx_ring->size);
+}
+
+/**
+ * txgbe_clean_all_rx_rings - Free Rx Buffers for all queues
+ * @adapter: board private structure
+ **/
+static void txgbe_clean_all_rx_rings(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_rx_queues; i++)
+		txgbe_clean_rx_ring(adapter->rx_ring[i]);
+}
+
+/**
+ * txgbe_clean_all_tx_rings - Free Tx Buffers for all queues
+ * @adapter: board private structure
+ **/
+static void txgbe_clean_all_tx_rings(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_tx_queues; i++)
+		txgbe_clean_tx_ring(adapter->tx_ring[i]);
+}
+
 void txgbe_disable_device(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
@@ -1526,11 +1713,15 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 		/* this call also flushes the previous write */
 		txgbe_disable_rx_queue(adapter, adapter->rx_ring[i]);
 
+	netif_tx_stop_all_queues(netdev);
+
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
 	txgbe_irq_disable(adapter);
 
+	txgbe_napi_disable_all(adapter);
+
 	adapter->flags2 &= ~(TXGBE_FLAG2_PF_RESET_REQUESTED |
 			     TXGBE_FLAG2_GLOBAL_RESET_REQUESTED);
 	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
@@ -1572,6 +1763,9 @@ void txgbe_down(struct txgbe_adapter *adapter)
 	if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP)))
 		/* power down the optics for SFP+ fiber */
 		TCALL(&adapter->hw, mac.ops.disable_tx_laser);
+
+	txgbe_clean_all_tx_rings(adapter);
+	txgbe_clean_all_rx_rings(adapter);
 }
 
 /**
@@ -1641,12 +1835,181 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 
 	adapter->max_q_vectors = TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE;
 
+	/* set default ring sizes */
+	adapter->tx_ring_count = TXGBE_DEFAULT_TXD;
+	adapter->rx_ring_count = TXGBE_DEFAULT_RXD;
+
+	/* set default work limits */
+	adapter->tx_work_limit = TXGBE_DEFAULT_TX_WORK;
+	adapter->rx_work_limit = TXGBE_DEFAULT_RX_WORK;
+
 	set_bit(0, &adapter->fwd_bitmask);
 	set_bit(__TXGBE_DOWN, &adapter->state);
 
 	return 0;
 }
 
+/**
+ * txgbe_setup_tx_resources - allocate Tx resources (Descriptors)
+ * @tx_ring:    tx descriptor ring (for a specific queue) to setup
+ *
+ * Return 0 on success, negative on failure
+ **/
+int txgbe_setup_tx_resources(struct txgbe_ring *tx_ring)
+{
+	struct device *dev = tx_ring->dev;
+	int orig_node = dev_to_node(dev);
+	int numa_node = -1;
+	int size;
+
+	size = sizeof(struct txgbe_tx_buffer) * tx_ring->count;
+
+	if (tx_ring->q_vector)
+		numa_node = tx_ring->q_vector->numa_node;
+
+	tx_ring->tx_buffer_info = vzalloc_node(size, numa_node);
+	if (!tx_ring->tx_buffer_info)
+		tx_ring->tx_buffer_info = vzalloc(size);
+	if (!tx_ring->tx_buffer_info)
+		goto err;
+
+	/* round up to nearest 4K */
+	tx_ring->size = tx_ring->count * sizeof(union txgbe_tx_desc);
+	tx_ring->size = ALIGN(tx_ring->size, 4096);
+
+	set_dev_node(dev, numa_node);
+	tx_ring->desc = dma_alloc_coherent(dev,
+					   tx_ring->size,
+					   &tx_ring->dma,
+					   GFP_KERNEL);
+	set_dev_node(dev, orig_node);
+	if (!tx_ring->desc)
+		tx_ring->desc = dma_alloc_coherent(dev, tx_ring->size,
+						   &tx_ring->dma, GFP_KERNEL);
+	if (!tx_ring->desc)
+		goto err;
+
+	return 0;
+
+err:
+	vfree(tx_ring->tx_buffer_info);
+	tx_ring->tx_buffer_info = NULL;
+	dev_err(dev, "Unable to allocate memory for the Tx descriptor ring\n");
+	return -ENOMEM;
+}
+
+/**
+ * txgbe_setup_all_tx_resources - allocate all queues Tx resources
+ * @adapter: board private structure
+ *
+ * If this function returns with an error, then it's possible one or
+ * more of the rings is populated (while the rest are not).  It is the
+ * callers duty to clean those orphaned rings.
+ *
+ * Return 0 on success, negative on failure
+ **/
+static int txgbe_setup_all_tx_resources(struct txgbe_adapter *adapter)
+{
+	int i, err = 0;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		err = txgbe_setup_tx_resources(adapter->tx_ring[i]);
+		if (!err)
+			continue;
+
+		netif_err(adapter, probe, adapter->netdev,
+			  "Allocation for Tx Queue %u failed\n", i);
+		goto err_setup_tx;
+	}
+
+	return 0;
+err_setup_tx:
+	/* rewind the index freeing the rings as we go */
+	while (i--)
+		txgbe_free_tx_resources(adapter->tx_ring[i]);
+	return err;
+}
+
+/**
+ * txgbe_setup_rx_resources - allocate Rx resources (Descriptors)
+ * @rx_ring:    rx descriptor ring (for a specific queue) to setup
+ *
+ * Returns 0 on success, negative on failure
+ **/
+int txgbe_setup_rx_resources(struct txgbe_ring *rx_ring)
+{
+	struct device *dev = rx_ring->dev;
+	int orig_node = dev_to_node(dev);
+	int numa_node = -1;
+	int size;
+
+	size = sizeof(struct txgbe_rx_buffer) * rx_ring->count;
+
+	if (rx_ring->q_vector)
+		numa_node = rx_ring->q_vector->numa_node;
+
+	rx_ring->rx_buffer_info = vzalloc_node(size, numa_node);
+	if (!rx_ring->rx_buffer_info)
+		rx_ring->rx_buffer_info = vzalloc(size);
+	if (!rx_ring->rx_buffer_info)
+		goto err;
+
+	/* Round up to nearest 4K */
+	rx_ring->size = rx_ring->count * sizeof(union txgbe_rx_desc);
+	rx_ring->size = ALIGN(rx_ring->size, 4096);
+
+	set_dev_node(dev, numa_node);
+	rx_ring->desc = dma_alloc_coherent(dev,
+					   rx_ring->size,
+					   &rx_ring->dma,
+					   GFP_KERNEL);
+	set_dev_node(dev, orig_node);
+	if (!rx_ring->desc)
+		rx_ring->desc = dma_alloc_coherent(dev, rx_ring->size,
+						   &rx_ring->dma, GFP_KERNEL);
+	if (!rx_ring->desc)
+		goto err;
+
+	return 0;
+err:
+	vfree(rx_ring->rx_buffer_info);
+	rx_ring->rx_buffer_info = NULL;
+	dev_err(dev, "Unable to allocate memory for the Rx descriptor ring\n");
+	return -ENOMEM;
+}
+
+/**
+ * txgbe_setup_all_rx_resources - allocate all queues Rx resources
+ * @adapter: board private structure
+ *
+ * If this function returns with an error, then it's possible one or
+ * more of the rings is populated (while the rest are not).  It is the
+ * callers duty to clean those orphaned rings.
+ *
+ * Return 0 on success, negative on failure
+ **/
+static int txgbe_setup_all_rx_resources(struct txgbe_adapter *adapter)
+{
+	int i, err = 0;
+
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		err = txgbe_setup_rx_resources(adapter->rx_ring[i]);
+		if (!err)
+			continue;
+
+		netif_err(adapter, probe, adapter->netdev,
+			  "Allocation for Rx Queue %u failed\n", i);
+		goto err_setup_rx;
+	}
+
+		return 0;
+err_setup_rx:
+	/* rewind the index freeing the rings as we go */
+	while (i--)
+		txgbe_free_rx_resources(adapter->rx_ring[i]);
+	return err;
+}
+
 /**
  * txgbe_setup_isb_resources - allocate interrupt status resources
  * @adapter: board private structure
@@ -1682,6 +2045,79 @@ static void txgbe_free_isb_resources(struct txgbe_adapter *adapter)
 	adapter->isb_mem = NULL;
 }
 
+/**
+ * txgbe_free_tx_resources - Free Tx Resources per Queue
+ * @tx_ring: Tx descriptor ring for a specific queue
+ *
+ * Free all transmit software resources
+ **/
+void txgbe_free_tx_resources(struct txgbe_ring *tx_ring)
+{
+	txgbe_clean_tx_ring(tx_ring);
+
+	vfree(tx_ring->tx_buffer_info);
+	tx_ring->tx_buffer_info = NULL;
+
+	/* if not set, then don't free */
+	if (!tx_ring->desc)
+		return;
+
+	dma_free_coherent(tx_ring->dev, tx_ring->size,
+			  tx_ring->desc, tx_ring->dma);
+	tx_ring->desc = NULL;
+}
+
+/**
+ * txgbe_free_all_tx_resources - Free Tx Resources for All Queues
+ * @adapter: board private structure
+ *
+ * Free all transmit software resources
+ **/
+static void txgbe_free_all_tx_resources(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_tx_queues; i++)
+		txgbe_free_tx_resources(adapter->tx_ring[i]);
+}
+
+/**
+ * txgbe_free_rx_resources - Free Rx Resources
+ * @rx_ring: ring to clean the resources from
+ *
+ * Free all receive software resources
+ **/
+void txgbe_free_rx_resources(struct txgbe_ring *rx_ring)
+{
+	txgbe_clean_rx_ring(rx_ring);
+
+	vfree(rx_ring->rx_buffer_info);
+	rx_ring->rx_buffer_info = NULL;
+
+	/* if not set, then don't free */
+	if (!rx_ring->desc)
+		return;
+
+	dma_free_coherent(rx_ring->dev, rx_ring->size,
+			  rx_ring->desc, rx_ring->dma);
+
+	rx_ring->desc = NULL;
+}
+
+/**
+ * txgbe_free_all_rx_resources - Free Rx Resources for All Queues
+ * @adapter: board private structure
+ *
+ * Free all receive software resources
+ **/
+static void txgbe_free_all_rx_resources(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_rx_queues; i++)
+		txgbe_free_rx_resources(adapter->rx_ring[i]);
+}
+
 /**
  * txgbe_open - Called when a network interface is made active
  * @netdev: network interface device structure
@@ -1701,10 +2137,20 @@ int txgbe_open(struct net_device *netdev)
 
 	netif_carrier_off(netdev);
 
-	err = txgbe_setup_isb_resources(adapter);
+	/* allocate transmit descriptors */
+	err = txgbe_setup_all_tx_resources(adapter);
 	if (err)
 		goto err_reset;
 
+	/* allocate receive descriptors */
+	err = txgbe_setup_all_rx_resources(adapter);
+	if (err)
+		goto err_free_tx;
+
+	err = txgbe_setup_isb_resources(adapter);
+	if (err)
+		goto err_free_rx;
+
 	txgbe_configure(adapter);
 
 	err = txgbe_request_irq(adapter);
@@ -1728,6 +2174,10 @@ int txgbe_open(struct net_device *netdev)
 	txgbe_free_irq(adapter);
 err_free_isb:
 	txgbe_free_isb_resources(adapter);
+err_free_rx:
+	txgbe_free_all_rx_resources(adapter);
+err_free_tx:
+	txgbe_free_all_tx_resources(adapter);
 err_reset:
 	txgbe_reset(adapter);
 
@@ -1748,9 +2198,14 @@ static void txgbe_close_suspend(struct txgbe_adapter *adapter)
 	txgbe_disable_device(adapter);
 	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
 		TCALL(hw, mac.ops.disable_tx_laser);
+	txgbe_clean_all_tx_rings(adapter);
+	txgbe_clean_all_rx_rings(adapter);
+
 	txgbe_free_irq(adapter);
 
 	txgbe_free_isb_resources(adapter);
+	txgbe_free_all_rx_resources(adapter);
+	txgbe_free_all_tx_resources(adapter);
 }
 
 /**
@@ -1772,6 +2227,8 @@ int txgbe_close(struct net_device *netdev)
 	txgbe_free_irq(adapter);
 
 	txgbe_free_isb_resources(adapter);
+	txgbe_free_all_rx_resources(adapter);
+	txgbe_free_all_tx_resources(adapter);
 
 	txgbe_release_hw_control(adapter);
 
@@ -1904,6 +2361,7 @@ static void txgbe_watchdog_link_is_up(struct txgbe_adapter *adapter)
 		   "NIC Link is Up %s\n", speed_str);
 
 	netif_carrier_on(netdev);
+	netif_tx_wake_all_queues(netdev);
 }
 
 /**
@@ -1924,6 +2382,41 @@ static void txgbe_watchdog_link_is_down(struct txgbe_adapter *adapter)
 
 	netif_info(adapter, drv, netdev, "NIC Link is Down\n");
 	netif_carrier_off(netdev);
+	netif_tx_stop_all_queues(netdev);
+}
+
+static bool txgbe_ring_tx_pending(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct txgbe_ring *tx_ring = adapter->tx_ring[i];
+
+		if (tx_ring->next_to_use != tx_ring->next_to_clean)
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * txgbe_watchdog_flush_tx - flush queues on link down
+ * @adapter: pointer to the device adapter structure
+ **/
+static void txgbe_watchdog_flush_tx(struct txgbe_adapter *adapter)
+{
+	if (!netif_carrier_ok(adapter->netdev)) {
+		if (txgbe_ring_tx_pending(adapter)) {
+			/* We've lost link, so the controller stops DMA,
+			 * but we've got queued Tx work that's never going
+			 * to get done, so reset controller to flush Tx.
+			 * (Do the reset outside of interrupt context).
+			 */
+			netif_warn(adapter, drv, adapter->netdev,
+				   "initiating reset due to lost link with pending Tx work\n");
+			adapter->flags2 |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+		}
+	}
 }
 
 /**
@@ -1944,6 +2437,8 @@ static void txgbe_watchdog_subtask(struct txgbe_adapter *adapter)
 		txgbe_watchdog_link_is_up(adapter);
 	else
 		txgbe_watchdog_link_is_down(adapter);
+
+	txgbe_watchdog_flush_tx(adapter);
 }
 
 /**
@@ -2453,6 +2948,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
+	netif_tx_stop_all_queues(netdev);
 
 	/* calculate the expected PCIe bandwidth required for optimal
 	 * performance. Note that some older parts will never have enough
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index fc51f82b6087..a2a38fc842e8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -955,6 +955,51 @@ enum {
 #define TXGBE_PCIDEVCTRL2_4_8s          0xd
 #define TXGBE_PCIDEVCTRL2_17_34s        0xe
 
+/* Transmit Descriptor */
+union txgbe_tx_desc {
+	struct {
+		__le64 buffer_addr; /* Address of descriptor's data buf */
+		__le32 cmd_type_len;
+		__le32 olinfo_status;
+	} read;
+	struct {
+		__le64 rsvd; /* Reserved */
+		__le32 nxtseq_seed;
+		__le32 status;
+	} wb;
+};
+
+/* Receive Descriptor */
+union txgbe_rx_desc {
+	struct {
+		__le64 pkt_addr; /* Packet buffer address */
+		__le64 hdr_addr; /* Header buffer address */
+	} read;
+	struct {
+		struct {
+			union {
+				__le32 data;
+				struct {
+					__le16 pkt_info; /* RSS, Pkt type */
+					__le16 hdr_info; /* Splithdr, hdrlen */
+				} hs_rss;
+			} lo_dword;
+			union {
+				__le32 rss; /* RSS Hash */
+				struct {
+					__le16 ip_id; /* IP id */
+					__le16 csum; /* Packet Checksum */
+				} csum_ip;
+			} hi_dword;
+		} lower;
+		struct {
+			__le32 status_error; /* ext status/error */
+			__le16 length; /* Packet length */
+			__le16 vlan; /* VLAN tag */
+		} upper;
+	} wb;  /* writeback */
+};
+
 /****************** Manageablility Host Interface defines ********************/
 #define TXGBE_HI_MAX_BLOCK_BYTE_LENGTH  256 /* Num of bytes in range */
 #define TXGBE_HI_MAX_BLOCK_DWORD_LENGTH 64 /* Num of dwords in range */
-- 
2.27.0

