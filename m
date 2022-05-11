Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5C0522A5A
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241675AbiEKDTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240784AbiEKDTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:46 -0400
Received: from smtpproxy21.qq.com (smtpbg701.qq.com [203.205.195.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B111D6CF62
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:30 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239156tpufh809
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:16 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: Z953UCsBqO661Kjn+P09SuNrgZ2SKQBZyU3ZRaBsB+XRAAtpYoKmpshF6LAxX
        YDoif+VMhSJ32tYiiqrm+75eJgzHqs6hYqhrMVWpKW7pwHmhp9FfywWJA8z/pbyn15ybxYV
        gwmKspA2/o+lBvLSwQT+NXiArkqHx8bGO0ncKe2SzsM5wrFh0WMJhajETip0dw1mqZfD3wb
        NMKH7diQpc6sMzz83l1tjwl1+jZKPEK0NDU85mcVB7+0V+WM10YqooRvQdyd44xlHMVC7Mq
        q6WED5gvXNBufSUqZVksxaDoHt3ezOP8+oaPrLZ3tWX7El6PMJ4KuYKjZqga6J6lUM20mzd
        Gk8cjW7Z3ElR+B0ZtNQaSc8zQ3sMkNW7K/VleUH
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 05/14] net: txgbe: Add interrupt support
Date:   Wed, 11 May 2022 11:26:50 +0800
Message-Id: <20220511032659.641834-6-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign9
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Determine proper interrupt scheme based on kernel support and
hardware queue count. Allocate memory for interrupt vectors,
and handle different interrupts.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    | 116 +++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  35 +
 .../net/ethernet/wangxun/txgbe/txgbe_lib.c    | 442 +++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 736 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    |  22 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   2 +
 8 files changed, 1356 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c

diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index 7dc73b58fe75..aceb0d2e56ee 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -7,4 +7,5 @@
 obj-$(CONFIG_TXGBE) += txgbe.o
 
 txgbe-objs := txgbe_main.o \
-              txgbe_hw.o txgbe_phy.o
+              txgbe_hw.o txgbe_phy.o \
+              txgbe_lib.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 58a89d43046f..c5a02f1950ae 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -19,13 +19,66 @@
 #endif
 
 struct txgbe_ring {
+	struct txgbe_ring *next;        /* pointer to next ring in q_vector */
+	struct txgbe_q_vector *q_vector; /* backpointer to host q_vector */
+	struct net_device *netdev;      /* netdev ring belongs to */
+	struct device *dev;             /* device for DMA mapping */
+	u16 count;                      /* amount of descriptors */
+
+	u8 queue_index; /* needed for multiqueue queue management */
 	u8 reg_idx;
 } ____cacheline_internodealigned_in_smp;
 
 #define TXGBE_MAX_FDIR_INDICES          63
 
+#define MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 #define MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 
+struct txgbe_ring_container {
+	struct txgbe_ring *ring;        /* pointer to linked list of rings */
+	u16 work_limit;                 /* total work allowed per interrupt */
+	u8 count;                       /* total number of rings in vector */
+};
+
+/* iterator for handling rings in ring container */
+#define txgbe_for_each_ring(pos, head) \
+	for (pos = (head).ring; pos != NULL; pos = pos->next)
+
+/* MAX_MSIX_Q_VECTORS of these are allocated,
+ * but we only use one per queue-specific vector.
+ */
+struct txgbe_q_vector {
+	struct txgbe_adapter *adapter;
+	int cpu;
+	u16 v_idx;      /* index of q_vector within array, also used for
+			 * finding the bit in EICR and friends that
+			 * represents the vector for this ring
+			 */
+	u16 itr;        /* Interrupt throttle rate written to EITR */
+	struct txgbe_ring_container rx, tx;
+
+	struct napi_struct napi;
+	cpumask_t affinity_mask;
+	int numa_node;
+	struct rcu_head rcu;    /* to avoid race with update stats on free */
+	char name[IFNAMSIZ + 17];
+
+	/* for dynamic allocation of rings associated with this q_vector */
+	struct txgbe_ring ring[0] ____cacheline_internodealigned_in_smp;
+};
+
+/* microsecond values for various ITR rates shifted by 2 to fit itr register
+ * with the first 3 bits reserved 0
+ */
+#define TXGBE_100K_ITR          40
+#define TXGBE_20K_ITR           200
+#define TXGBE_16K_ITR           248
+#define TXGBE_12K_ITR           336
+
+#define TCP_TIMER_VECTOR        0
+#define OTHER_VECTOR    1
+#define NON_Q_VECTORS   (OTHER_VECTOR + TCP_TIMER_VECTOR)
+
 #define TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE       64
 
 struct txgbe_mac_addr {
@@ -38,6 +91,12 @@ struct txgbe_mac_addr {
 #define TXGBE_MAC_STATE_MODIFIED        0x2
 #define TXGBE_MAC_STATE_IN_USE          0x4
 
+#define MAX_MSIX_Q_VECTORS      TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE
+#define MAX_MSIX_COUNT          TXGBE_MAX_MSIX_VECTORS_SAPPHIRE
+
+#define MIN_MSIX_Q_VECTORS      1
+#define MIN_MSIX_COUNT          (MIN_MSIX_Q_VECTORS + NON_Q_VECTORS)
+
 /* default to trying for four seconds */
 #define TXGBE_TRY_LINK_TIMEOUT  (4 * HZ)
 #define TXGBE_SFP_POLL_JIFFIES  (2 * HZ)        /* SFP poll every 2 seconds */
@@ -47,12 +106,26 @@ struct txgbe_mac_addr {
  **/
 #define TXGBE_FLAG_NEED_LINK_UPDATE             ((u32)(1 << 0))
 #define TXGBE_FLAG_NEED_LINK_CONFIG             ((u32)(1 << 1))
+#define TXGBE_FLAG_MSI_ENABLED                  ((u32)(1 << 2))
+#define TXGBE_FLAG_MSIX_ENABLED                 ((u32)(1 << 3))
 
 /**
  * txgbe_adapter.flag2
  **/
 #define TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED     (1U << 0)
 #define TXGBE_FLAG2_SFP_NEEDS_RESET             (1U << 1)
+#define TXGBE_FLAG2_TEMP_SENSOR_EVENT           (1U << 2)
+#define TXGBE_FLAG2_PF_RESET_REQUESTED          (1U << 3)
+#define TXGBE_FLAG2_RESET_INTR_RECEIVED         (1U << 4)
+#define TXGBE_FLAG2_GLOBAL_RESET_REQUESTED      (1U << 5)
+
+enum txgbe_isb_idx {
+	TXGBE_ISB_HEADER,
+	TXGBE_ISB_MISC,
+	TXGBE_ISB_VEC0,
+	TXGBE_ISB_VEC1,
+	TXGBE_ISB_MAX
+};
 
 /* board specific private data structure */
 struct txgbe_adapter {
@@ -72,20 +145,33 @@ struct txgbe_adapter {
 	/* Tx fast path data */
 	int num_tx_queues;
 	u16 tx_itr_setting;
+	u16 tx_work_limit;
 
 	/* Rx fast path data */
 	int num_rx_queues;
 	u16 rx_itr_setting;
+	u16 rx_work_limit;
 
 	/* TX */
 	struct txgbe_ring *tx_ring[MAX_TX_QUEUES] ____cacheline_aligned_in_smp;
 
+	u64 lsc_int;
+
+	/* RX */
+	struct txgbe_ring *rx_ring[MAX_RX_QUEUES];
+	struct txgbe_q_vector *q_vector[MAX_MSIX_Q_VECTORS];
+
+	int num_q_vectors;      /* current number of q_vectors for device */
 	int max_q_vectors;      /* upper limit of q_vectors for device */
+	struct msix_entry *msix_entries;
 
 	/* structs defined in txgbe_hw.h */
 	struct txgbe_hw hw;
 	u16 msg_enable;
 
+	unsigned int tx_ring_count;
+	unsigned int rx_ring_count;
+
 	u32 link_speed;
 	bool link_up;
 	unsigned long sfp_poll_time;
@@ -99,11 +185,30 @@ struct txgbe_adapter {
 
 	char eeprom_id[32];
 	bool netdev_registered;
+	u32 interrupt_event;
 
 	struct txgbe_mac_addr *mac_table;
 
+	/* misc interrupt status block */
+	dma_addr_t isb_dma;
+	u32 *isb_mem;
+	u32 isb_tag[TXGBE_ISB_MAX];
 };
 
+static inline u32 txgbe_misc_isb(struct txgbe_adapter *adapter,
+				 enum txgbe_isb_idx idx)
+{
+	u32 cur_tag = 0;
+	u32 cur_diff = 0;
+
+	cur_tag = adapter->isb_mem[TXGBE_ISB_HEADER];
+	cur_diff = cur_tag - adapter->isb_tag[idx];
+
+	adapter->isb_tag[idx] = cur_tag;
+
+	return adapter->isb_mem[idx];
+}
+
 enum txgbe_state_t {
 	__TXGBE_TESTING,
 	__TXGBE_RESETTING,
@@ -118,7 +223,18 @@ enum txgbe_state_t {
 	__TXGBE_PTP_TX_IN_PROGRESS,
 };
 
+void txgbe_irq_disable(struct txgbe_adapter *adapter);
+void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush);
+int txgbe_open(struct net_device *netdev);
+int txgbe_close(struct net_device *netdev);
+void txgbe_up(struct txgbe_adapter *adapter);
 void txgbe_down(struct txgbe_adapter *adapter);
+int txgbe_init_interrupt_scheme(struct txgbe_adapter *adapter);
+void txgbe_reset_interrupt_capability(struct txgbe_adapter *adapter);
+void txgbe_set_interrupt_capability(struct txgbe_adapter *adapter);
+void txgbe_clear_interrupt_scheme(struct txgbe_adapter *adapter);
+void txgbe_write_eitr(struct txgbe_q_vector *q_vector);
+
 
 /**
  * interrupt masking operations. each bit in PX_ICn correspond to a interrupt.
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 0c1260ba7c72..1e30878f7c6f 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -57,6 +57,39 @@ void txgbe_wr32_epcs(struct txgbe_hw *hw, u32 addr, u32 data)
 	wr32(hw, offset, data);
 }
 
+/**
+ *  txgbe_get_pcie_msix_count - Gets MSI-X vector count
+ *  @hw: pointer to hardware structure
+ *
+ *  Read PCIe configuration space, and get the MSI-X vector count from
+ *  the capabilities table.
+ **/
+u16 txgbe_get_pcie_msix_count(struct txgbe_hw *hw)
+{
+	u16 msix_count = 1;
+	u16 max_msix_count;
+	u32 pos;
+
+	max_msix_count = TXGBE_MAX_MSIX_VECTORS_SAPPHIRE;
+	pos = pci_find_capability(((struct txgbe_adapter *)hw->back)->pdev, PCI_CAP_ID_MSIX);
+	if (!pos)
+		return msix_count;
+	pci_read_config_word(((struct txgbe_adapter *)hw->back)->pdev,
+			     pos + PCI_MSIX_FLAGS, &msix_count);
+
+	if (TXGBE_REMOVED(hw->hw_addr))
+		msix_count = 0;
+	msix_count &= TXGBE_PCIE_MSIX_TBL_SZ_MASK;
+
+	/* MSI-X count is zero-based in HW */
+	msix_count++;
+
+	if (msix_count > max_msix_count)
+		msix_count = max_msix_count;
+
+	return msix_count;
+}
+
 s32 txgbe_init_hw(struct txgbe_hw *hw)
 {
 	s32 status;
@@ -1542,6 +1575,7 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	phy->ops.read_i2c_byte = txgbe_read_i2c_byte;
 	phy->ops.read_i2c_eeprom = txgbe_read_i2c_eeprom;
 	phy->ops.identify_sfp = txgbe_identify_module;
+	phy->ops.check_overtemp = txgbe_check_overtemp;
 	phy->ops.identify = txgbe_identify_phy;
 	phy->ops.init = txgbe_init_phy_ops;
 
@@ -1576,6 +1610,7 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	mac->num_rar_entries    = TXGBE_SP_RAR_ENTRIES;
 	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
 	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
+	mac->max_msix_vectors   = txgbe_get_pcie_msix_count(hw);
 
 	/* EEPROM */
 	eeprom->ops.init_params = txgbe_init_eeprom_params;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
new file mode 100644
index 000000000000..514a38941488
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
@@ -0,0 +1,442 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#include "txgbe.h"
+
+/**
+ * txgbe_cache_ring_register - Descriptor ring to register mapping
+ * @adapter: board private structure to initialize
+ *
+ * Once we know the feature-set enabled for the device, we'll cache
+ * the register offset the descriptor ring is assigned to.
+ *
+ * Note, the order the various feature calls is important.  It must start with
+ * the "most" features enabled at the same time, then trickle down to the
+ * least amount of features turned on at once.
+ **/
+static void txgbe_cache_ring_register(struct txgbe_adapter *adapter)
+{
+	u16 i;
+
+	for (i = 0; i < adapter->num_rx_queues; i++)
+		adapter->rx_ring[i]->reg_idx = i;
+
+	for (i = 0; i < adapter->num_tx_queues; i++)
+		adapter->tx_ring[i]->reg_idx = i;
+}
+
+/**
+ * txgbe_set_num_queues: Allocate queues for device, feature dependent
+ * @adapter: board private structure to initialize
+ **/
+static void txgbe_set_num_queues(struct txgbe_adapter *adapter)
+{
+	/* Start with base case */
+	adapter->num_rx_queues = 1;
+	adapter->num_tx_queues = 1;
+}
+
+/**
+ * txgbe_acquire_msix_vectors - acquire MSI-X vectors
+ * @adapter: board private structure
+ *
+ * Attempts to acquire a suitable range of MSI-X vector interrupts. Will
+ * return a negative error code if unable to acquire MSI-X vectors for any
+ * reason.
+ */
+static int txgbe_acquire_msix_vectors(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int i, vectors, vector_threshold;
+
+	/* We start by asking for one vector per queue pair */
+	vectors = max(adapter->num_rx_queues, adapter->num_tx_queues);
+
+	/* It is easy to be greedy for MSI-X vectors. However, it really
+	 * doesn't do much good if we have a lot more vectors than CPUs. We'll
+	 * be somewhat conservative and only ask for (roughly) the same number
+	 * of vectors as there are CPUs.
+	 */
+	vectors = min_t(int, vectors, num_online_cpus());
+
+	/* Some vectors are necessary for non-queue interrupts */
+	vectors += NON_Q_VECTORS;
+
+	/* Hardware can only support a maximum of hw.mac->max_msix_vectors.
+	 * With features such as RSS and VMDq, we can easily surpass the
+	 * number of Rx and Tx descriptor queues supported by our device.
+	 * Thus, we cap the maximum in the rare cases where the CPU count also
+	 * exceeds our vector limit
+	 */
+	vectors = min_t(int, vectors, hw->mac.max_msix_vectors);
+
+	/* We want a minimum of two MSI-X vectors for (1) a TxQ[0] + RxQ[0]
+	 * handler, and (2) an Other (Link Status Change, etc.) handler.
+	 */
+	vector_threshold = MIN_MSIX_COUNT;
+
+	adapter->msix_entries = kcalloc(vectors,
+					sizeof(struct msix_entry),
+					GFP_KERNEL);
+	if (!adapter->msix_entries)
+		return -ENOMEM;
+
+	for (i = 0; i < vectors; i++)
+		adapter->msix_entries[i].entry = i;
+
+	vectors = pci_enable_msix_range(adapter->pdev, adapter->msix_entries,
+					vector_threshold, vectors);
+	if (vectors < 0) {
+		/* A negative count of allocated vectors indicates an error in
+		 * acquiring within the specified range of MSI-X vectors
+		 */
+		txgbe_dev_warn("Failed to allocate MSI-X interrupts. Err: %d\n",
+			       vectors);
+
+		adapter->flags &= ~TXGBE_FLAG_MSIX_ENABLED;
+		kfree(adapter->msix_entries);
+		adapter->msix_entries = NULL;
+
+		return vectors;
+	}
+
+	/* we successfully allocated some number of vectors within our
+	 * requested range.
+	 */
+	adapter->flags |= TXGBE_FLAG_MSIX_ENABLED;
+
+	/* Adjust for only the vectors we'll use, which is minimum
+	 * of max_q_vectors, or the number of vectors we were allocated.
+	 */
+	vectors -= NON_Q_VECTORS;
+	adapter->num_q_vectors = min_t(int, vectors, adapter->max_q_vectors);
+
+	return 0;
+}
+
+static void txgbe_add_ring(struct txgbe_ring *ring,
+			   struct txgbe_ring_container *head)
+{
+	ring->next = head->ring;
+	head->ring = ring;
+	head->count++;
+}
+
+/**
+ * txgbe_alloc_q_vector - Allocate memory for a single interrupt vector
+ * @adapter: board private structure to initialize
+ * @v_count: q_vectors allocated on adapter, used for ring interleaving
+ * @v_idx: index of vector in adapter struct
+ * @txr_count: total number of Tx rings to allocate
+ * @txr_idx: index of first Tx ring to allocate
+ * @rxr_count: total number of Rx rings to allocate
+ * @rxr_idx: index of first Rx ring to allocate
+ *
+ * We allocate one q_vector.  If allocation fails we return -ENOMEM.
+ **/
+static int txgbe_alloc_q_vector(struct txgbe_adapter *adapter,
+				unsigned int v_count, unsigned int v_idx,
+				unsigned int txr_count, unsigned int txr_idx,
+				unsigned int rxr_count, unsigned int rxr_idx)
+{
+	struct txgbe_q_vector *q_vector;
+	struct txgbe_ring *ring;
+	int node = -1;
+	int cpu = -1;
+	int ring_count, size;
+
+	/* note this will allocate space for the ring structure as well! */
+	ring_count = txr_count + rxr_count;
+	size = sizeof(struct txgbe_q_vector) +
+	       (sizeof(struct txgbe_ring) * ring_count);
+
+	/* allocate q_vector and rings */
+	q_vector = kzalloc_node(size, GFP_KERNEL, node);
+	if (!q_vector)
+		q_vector = kzalloc(size, GFP_KERNEL);
+	if (!q_vector)
+		return -ENOMEM;
+
+	/* setup affinity mask and node */
+	if (cpu != -1)
+		cpumask_set_cpu(cpu, &q_vector->affinity_mask);
+	q_vector->numa_node = node;
+
+	/* initialize CPU for DCA */
+	q_vector->cpu = -1;
+
+	/* tie q_vector and adapter together */
+	adapter->q_vector[v_idx] = q_vector;
+	q_vector->adapter = adapter;
+	q_vector->v_idx = v_idx;
+
+	/* initialize work limits */
+	q_vector->tx.work_limit = adapter->tx_work_limit;
+	q_vector->rx.work_limit = adapter->rx_work_limit;
+
+	/* initialize pointer to rings */
+	ring = q_vector->ring;
+
+	/* initialize ITR */
+	if (txr_count && !rxr_count) {
+		/* tx only vector */
+		if (adapter->tx_itr_setting == 1)
+			q_vector->itr = TXGBE_12K_ITR;
+		else
+			q_vector->itr = adapter->tx_itr_setting;
+	} else {
+		/* rx or rx/tx vector */
+		if (adapter->rx_itr_setting == 1)
+			q_vector->itr = TXGBE_20K_ITR;
+		else
+			q_vector->itr = adapter->rx_itr_setting;
+	}
+
+	while (txr_count) {
+		/* assign generic ring traits */
+		ring->dev = pci_dev_to_dev(adapter->pdev);
+		ring->netdev = adapter->netdev;
+
+		/* configure backlink on ring */
+		ring->q_vector = q_vector;
+
+		/* update q_vector Tx values */
+		txgbe_add_ring(ring, &q_vector->tx);
+
+		/* apply Tx specific ring traits */
+		ring->count = adapter->tx_ring_count;
+		ring->queue_index = txr_idx;
+
+		/* assign ring to adapter */
+		adapter->tx_ring[txr_idx] = ring;
+
+		/* update count and index */
+		txr_count--;
+		txr_idx += v_count;
+
+		/* push pointer to next ring */
+		ring++;
+	}
+
+	while (rxr_count) {
+		/* assign generic ring traits */
+		ring->dev = pci_dev_to_dev(adapter->pdev);
+		ring->netdev = adapter->netdev;
+
+		/* configure backlink on ring */
+		ring->q_vector = q_vector;
+
+		/* update q_vector Rx values */
+		txgbe_add_ring(ring, &q_vector->rx);
+
+		/* apply Rx specific ring traits */
+		ring->count = adapter->rx_ring_count;
+		ring->queue_index = rxr_idx;
+
+		/* assign ring to adapter */
+		adapter->rx_ring[rxr_idx] = ring;
+
+		/* update count and index */
+		rxr_count--;
+		rxr_idx += v_count;
+
+		/* push pointer to next ring */
+		ring++;
+	}
+
+	return 0;
+}
+
+/**
+ * txgbe_free_q_vector - Free memory allocated for specific interrupt vector
+ * @adapter: board private structure to initialize
+ * @v_idx: Index of vector to be freed
+ *
+ * This function frees the memory allocated to the q_vector.  In addition if
+ * NAPI is enabled it will delete any references to the NAPI struct prior
+ * to freeing the q_vector.
+ **/
+static void txgbe_free_q_vector(struct txgbe_adapter *adapter, int v_idx)
+{
+	struct txgbe_q_vector *q_vector = adapter->q_vector[v_idx];
+	struct txgbe_ring *ring;
+
+	txgbe_for_each_ring(ring, q_vector->tx)
+		adapter->tx_ring[ring->queue_index] = NULL;
+
+	txgbe_for_each_ring(ring, q_vector->rx)
+		adapter->rx_ring[ring->queue_index] = NULL;
+
+	adapter->q_vector[v_idx] = NULL;
+	kfree_rcu(q_vector, rcu);
+}
+
+/**
+ * txgbe_alloc_q_vectors - Allocate memory for interrupt vectors
+ * @adapter: board private structure to initialize
+ *
+ * We allocate one q_vector per queue interrupt.  If allocation fails we
+ * return -ENOMEM.
+ **/
+static int txgbe_alloc_q_vectors(struct txgbe_adapter *adapter)
+{
+	unsigned int q_vectors = adapter->num_q_vectors;
+	unsigned int rxr_remaining = adapter->num_rx_queues;
+	unsigned int txr_remaining = adapter->num_tx_queues;
+	unsigned int rxr_idx = 0, txr_idx = 0, v_idx = 0;
+	int err;
+
+	if (q_vectors >= (rxr_remaining + txr_remaining)) {
+		for (; rxr_remaining; v_idx++) {
+			err = txgbe_alloc_q_vector(adapter, q_vectors, v_idx,
+						   0, 0, 1, rxr_idx);
+			if (err)
+				goto err_out;
+
+			/* update counts and index */
+			rxr_remaining--;
+			rxr_idx++;
+		}
+	}
+
+	for (; v_idx < q_vectors; v_idx++) {
+		int rqpv = DIV_ROUND_UP(rxr_remaining, q_vectors - v_idx);
+		int tqpv = DIV_ROUND_UP(txr_remaining, q_vectors - v_idx);
+
+		err = txgbe_alloc_q_vector(adapter, q_vectors, v_idx,
+					   tqpv, txr_idx,
+					   rqpv, rxr_idx);
+
+		if (err)
+			goto err_out;
+
+		/* update counts and index */
+		rxr_remaining -= rqpv;
+		txr_remaining -= tqpv;
+		rxr_idx++;
+		txr_idx++;
+	}
+
+	return 0;
+
+err_out:
+	adapter->num_tx_queues = 0;
+	adapter->num_rx_queues = 0;
+	adapter->num_q_vectors = 0;
+
+	while (v_idx--)
+		txgbe_free_q_vector(adapter, v_idx);
+
+	return -ENOMEM;
+}
+
+/**
+ * txgbe_free_q_vectors - Free memory allocated for interrupt vectors
+ * @adapter: board private structure to initialize
+ *
+ * This function frees the memory allocated to the q_vectors.  In addition if
+ * NAPI is enabled it will delete any references to the NAPI struct prior
+ * to freeing the q_vector.
+ **/
+static void txgbe_free_q_vectors(struct txgbe_adapter *adapter)
+{
+	int v_idx = adapter->num_q_vectors;
+
+	adapter->num_tx_queues = 0;
+	adapter->num_rx_queues = 0;
+	adapter->num_q_vectors = 0;
+
+	while (v_idx--)
+		txgbe_free_q_vector(adapter, v_idx);
+}
+
+void txgbe_reset_interrupt_capability(struct txgbe_adapter *adapter)
+{
+	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED) {
+		adapter->flags &= ~TXGBE_FLAG_MSIX_ENABLED;
+		pci_disable_msix(adapter->pdev);
+		kfree(adapter->msix_entries);
+		adapter->msix_entries = NULL;
+	} else if (adapter->flags & TXGBE_FLAG_MSI_ENABLED) {
+		adapter->flags &= ~TXGBE_FLAG_MSI_ENABLED;
+		pci_disable_msi(adapter->pdev);
+	}
+}
+
+/**
+ * txgbe_set_interrupt_capability - set MSI-X or MSI if supported
+ * @adapter: board private structure to initialize
+ *
+ * Attempt to configure the interrupts using the best available
+ * capabilities of the hardware and the kernel.
+ **/
+void txgbe_set_interrupt_capability(struct txgbe_adapter *adapter)
+{
+	int err;
+
+	/* We will try to get MSI-X interrupts first */
+	if (!txgbe_acquire_msix_vectors(adapter))
+		return;
+
+	/* recalculate number of queues now that many features have been
+	 * changed or disabled.
+	 */
+	txgbe_set_num_queues(adapter);
+	adapter->num_q_vectors = 1;
+
+	err = pci_enable_msi(adapter->pdev);
+	if (err)
+		txgbe_dev_warn("Failed to allocate MSI interrupt, falling back to legacy. Error: %d\n",
+			       err);
+	else
+		adapter->flags |= TXGBE_FLAG_MSI_ENABLED;
+}
+
+/**
+ * txgbe_init_interrupt_scheme - Determine proper interrupt scheme
+ * @adapter: board private structure to initialize
+ *
+ * We determine which interrupt scheme to use based on...
+ * - Kernel support (MSI, MSI-X)
+ *   - which can be user-defined (via MODULE_PARAM)
+ * - Hardware queue count (num_*_queues)
+ *   - defined by miscellaneous hardware support/features (RSS, etc.)
+ **/
+int txgbe_init_interrupt_scheme(struct txgbe_adapter *adapter)
+{
+	int err;
+
+	/* Number of supported queues */
+	txgbe_set_num_queues(adapter);
+
+	/* Set interrupt mode */
+	txgbe_set_interrupt_capability(adapter);
+
+	/* Allocate memory for queues */
+	err = txgbe_alloc_q_vectors(adapter);
+	if (err) {
+		txgbe_err(probe, "Unable to allocate memory for queue vectors\n");
+		txgbe_reset_interrupt_capability(adapter);
+		return err;
+	}
+
+	txgbe_cache_ring_register(adapter);
+
+	set_bit(__TXGBE_DOWN, &adapter->state);
+
+	return 0;
+}
+
+/**
+ * txgbe_clear_interrupt_scheme - Clear the current interrupt scheme settings
+ * @adapter: board private structure to clear interrupt scheme on
+ *
+ * We go through and clear interrupt specific resources and reset the structure
+ * to pre-load conditions
+ **/
+void txgbe_clear_interrupt_scheme(struct txgbe_adapter *adapter)
+{
+	txgbe_free_q_vectors(adapter);
+	txgbe_reset_interrupt_capability(adapter);
+}
+
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index e49a31cefb67..385c0f35e82a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -21,6 +21,11 @@ static const char txgbe_driver_string[] =
 
 static const char txgbe_copyright[] =
 	"Copyright (c) 2015 -2017 Beijing WangXun Technology Co., Ltd";
+static const char txgbe_overheat_msg[] =
+	"Network adapter has been stopped because it has over heated. "
+	"If the problem persists, restart the computer, or power off the system and replace the adapter";
+static const char txgbe_underheat_msg[] =
+	"Network adapter has been started again since the temperature has been back to normal state";
 
 /* txgbe_pci_tbl - PCI Device ID Table
  *
@@ -140,6 +145,510 @@ static void txgbe_get_hw_control(struct txgbe_adapter *adapter)
 	      TXGBE_CFG_PORT_CTL_DRV_LOAD, TXGBE_CFG_PORT_CTL_DRV_LOAD);
 }
 
+/**
+ * txgbe_set_ivar - set the IVAR registers, mapping interrupt causes to vectors
+ * @adapter: pointer to adapter struct
+ * @direction: 0 for Rx, 1 for Tx, -1 for other causes
+ * @queue: queue to map the corresponding interrupt to
+ * @msix_vector: the vector to map to the corresponding queue
+ *
+ **/
+static void txgbe_set_ivar(struct txgbe_adapter *adapter, s8 direction,
+			   u16 queue, u16 msix_vector)
+{
+	u32 ivar, index;
+	struct txgbe_hw *hw = &adapter->hw;
+
+	if (direction == -1) {
+		/* other causes */
+		msix_vector |= TXGBE_PX_IVAR_ALLOC_VAL;
+		index = 0;
+		ivar = rd32(&adapter->hw, TXGBE_PX_MISC_IVAR);
+		ivar &= ~(0xFF << index);
+		ivar |= (msix_vector << index);
+		wr32(&adapter->hw, TXGBE_PX_MISC_IVAR, ivar);
+	} else {
+		/* tx or rx causes */
+		msix_vector |= TXGBE_PX_IVAR_ALLOC_VAL;
+		index = ((16 * (queue & 1)) + (8 * direction));
+		ivar = rd32(hw, TXGBE_PX_IVAR(queue >> 1));
+		ivar &= ~(0xFF << index);
+		ivar |= (msix_vector << index);
+		wr32(hw, TXGBE_PX_IVAR(queue >> 1), ivar);
+	}
+}
+
+/**
+ * txgbe_configure_msix - Configure MSI-X hardware
+ * @adapter: board private structure
+ *
+ * txgbe_configure_msix sets up the hardware to properly generate MSI-X
+ * interrupts.
+ **/
+static void txgbe_configure_msix(struct txgbe_adapter *adapter)
+{
+	u16 v_idx;
+
+	/* Populate MSIX to EITR Select */
+	wr32(&adapter->hw, TXGBE_PX_ITRSEL, 0);
+
+	/* Populate the IVAR table and set the ITR values to the
+	 * corresponding register.
+	 */
+	for (v_idx = 0; v_idx < adapter->num_q_vectors; v_idx++) {
+		struct txgbe_q_vector *q_vector = adapter->q_vector[v_idx];
+		struct txgbe_ring *ring;
+
+		txgbe_for_each_ring(ring, q_vector->rx)
+			txgbe_set_ivar(adapter, 0, ring->reg_idx, v_idx);
+
+		txgbe_for_each_ring(ring, q_vector->tx)
+			txgbe_set_ivar(adapter, 1, ring->reg_idx, v_idx);
+
+		txgbe_write_eitr(q_vector);
+	}
+
+	txgbe_set_ivar(adapter, -1, 0, v_idx);
+
+	wr32(&adapter->hw, TXGBE_PX_ITR(v_idx), 1950);
+}
+
+/**
+ * txgbe_write_eitr - write EITR register in hardware specific way
+ * @q_vector: structure containing interrupt and ring information
+ *
+ * This function is made to be called by ethtool and by the driver
+ * when it needs to update EITR registers at runtime.  Hardware
+ * specific quirks/differences are taken care of here.
+ */
+void txgbe_write_eitr(struct txgbe_q_vector *q_vector)
+{
+	struct txgbe_adapter *adapter = q_vector->adapter;
+	struct txgbe_hw *hw = &adapter->hw;
+	int v_idx = q_vector->v_idx;
+	u32 itr_reg = q_vector->itr & TXGBE_MAX_EITR;
+
+	itr_reg |= TXGBE_PX_ITR_CNT_WDIS;
+
+	wr32(hw, TXGBE_PX_ITR(v_idx), itr_reg);
+}
+
+/**
+ * txgbe_check_overtemp_subtask - check for over temperature
+ * @adapter: pointer to adapter
+ **/
+static void txgbe_check_overtemp_subtask(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 eicr = adapter->interrupt_event;
+	s32 temp_state;
+
+	if (test_bit(__TXGBE_DOWN, &adapter->state))
+		return;
+	if (!(adapter->flags2 & TXGBE_FLAG2_TEMP_SENSOR_EVENT))
+		return;
+
+	adapter->flags2 &= ~TXGBE_FLAG2_TEMP_SENSOR_EVENT;
+
+	/* Since the warning interrupt is for both ports
+	 * we don't have to check if:
+	 *  - This interrupt wasn't for our port.
+	 *  - We may have missed the interrupt so always have to
+	 *    check if we  got a LSC
+	 */
+	if (!(eicr & TXGBE_PX_MISC_IC_OVER_HEAT))
+		return;
+
+	temp_state = TCALL(hw, phy.ops.check_overtemp);
+	if (!temp_state || temp_state == TXGBE_NOT_IMPLEMENTED)
+		return;
+
+	if (temp_state == TXGBE_ERR_UNDERTEMP &&
+	    test_bit(__TXGBE_HANGING, &adapter->state)) {
+		txgbe_crit(drv, "%s\n", txgbe_underheat_msg);
+		wr32m(&adapter->hw, TXGBE_RDB_PB_CTL,
+		      TXGBE_RDB_PB_CTL_RXEN, TXGBE_RDB_PB_CTL_RXEN);
+		netif_carrier_on(adapter->netdev);
+		clear_bit(__TXGBE_HANGING, &adapter->state);
+	} else if (temp_state == TXGBE_ERR_OVERTEMP &&
+		!test_and_set_bit(__TXGBE_HANGING, &adapter->state)) {
+		txgbe_crit(drv, "%s\n", txgbe_overheat_msg);
+		netif_carrier_off(adapter->netdev);
+		wr32m(&adapter->hw, TXGBE_RDB_PB_CTL,
+		      TXGBE_RDB_PB_CTL_RXEN, 0);
+	}
+
+	adapter->interrupt_event = 0;
+}
+
+static void txgbe_check_overtemp_event(struct txgbe_adapter *adapter, u32 eicr)
+{
+	if (!(eicr & TXGBE_PX_MISC_IC_OVER_HEAT))
+		return;
+
+	if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
+		adapter->interrupt_event = eicr;
+		adapter->flags2 |= TXGBE_FLAG2_TEMP_SENSOR_EVENT;
+		txgbe_service_event_schedule(adapter);
+	}
+}
+
+static void txgbe_check_sfp_event(struct txgbe_adapter *adapter, u32 eicr)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 eicr_mask = TXGBE_PX_MISC_IC_GPIO;
+	u32 reg;
+
+	if (eicr & eicr_mask) {
+		if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
+			wr32(hw, TXGBE_GPIO_INTMASK, 0xFF);
+			reg = rd32(hw, TXGBE_GPIO_INTSTATUS);
+			if (reg & TXGBE_GPIO_INTSTATUS_2) {
+				adapter->flags2 |= TXGBE_FLAG2_SFP_NEEDS_RESET;
+				wr32(hw, TXGBE_GPIO_EOI,
+				     TXGBE_GPIO_EOI_2);
+				adapter->sfp_poll_time = 0;
+				txgbe_service_event_schedule(adapter);
+			}
+			if (reg & TXGBE_GPIO_INTSTATUS_3) {
+				adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
+				wr32(hw, TXGBE_GPIO_EOI,
+				     TXGBE_GPIO_EOI_3);
+				txgbe_service_event_schedule(adapter);
+			}
+
+			if (reg & TXGBE_GPIO_INTSTATUS_6) {
+				wr32(hw, TXGBE_GPIO_EOI,
+				     TXGBE_GPIO_EOI_6);
+				adapter->flags |=
+					TXGBE_FLAG_NEED_LINK_CONFIG;
+				txgbe_service_event_schedule(adapter);
+			}
+			wr32(hw, TXGBE_GPIO_INTMASK, 0x0);
+		}
+	}
+}
+
+static void txgbe_check_lsc(struct txgbe_adapter *adapter)
+{
+	adapter->lsc_int++;
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
+	adapter->link_check_timeout = jiffies;
+	if (!test_bit(__TXGBE_DOWN, &adapter->state))
+		txgbe_service_event_schedule(adapter);
+}
+
+/**
+ * txgbe_irq_enable - Enable default interrupt generation settings
+ * @adapter: board private structure
+ **/
+void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush)
+{
+	u32 mask = 0;
+	struct txgbe_hw *hw = &adapter->hw;
+	u8 device_type = hw->subsystem_id & 0xF0;
+
+	/* enable gpio interrupt */
+	if (device_type != TXGBE_ID_MAC_XAUI &&
+	    device_type != TXGBE_ID_MAC_SGMII) {
+		mask |= TXGBE_GPIO_INTEN_2;
+		mask |= TXGBE_GPIO_INTEN_3;
+		mask |= TXGBE_GPIO_INTEN_6;
+	}
+	wr32(&adapter->hw, TXGBE_GPIO_INTEN, mask);
+
+	if (device_type != TXGBE_ID_MAC_XAUI &&
+	    device_type != TXGBE_ID_MAC_SGMII) {
+		mask = TXGBE_GPIO_INTTYPE_LEVEL_2 | TXGBE_GPIO_INTTYPE_LEVEL_3 |
+			TXGBE_GPIO_INTTYPE_LEVEL_6;
+	}
+	wr32(&adapter->hw, TXGBE_GPIO_INTTYPE_LEVEL, mask);
+
+	/* enable misc interrupt */
+	mask = TXGBE_PX_MISC_IEN_MASK;
+
+	mask |= TXGBE_PX_MISC_IEN_OVER_HEAT;
+
+	wr32(&adapter->hw, TXGBE_PX_MISC_IEN, mask);
+
+	/* unmask interrupt */
+	txgbe_intr_enable(&adapter->hw, TXGBE_INTR_MISC(adapter));
+	if (queues)
+		txgbe_intr_enable(&adapter->hw, TXGBE_INTR_QALL(adapter));
+
+	/* flush configuration */
+	if (flush)
+		TXGBE_WRITE_FLUSH(&adapter->hw);
+}
+
+static irqreturn_t txgbe_msix_other(int __always_unused irq, void *data)
+{
+	struct txgbe_adapter *adapter = data;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 eicr;
+	u32 ecc;
+
+	eicr = txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
+
+	if (eicr & (TXGBE_PX_MISC_IC_ETH_LK | TXGBE_PX_MISC_IC_ETH_LKDN))
+		txgbe_check_lsc(adapter);
+
+	if (eicr & TXGBE_PX_MISC_IC_INT_ERR) {
+		txgbe_info(link, "Received unrecoverable ECC Err, initiating reset.\n");
+		ecc = rd32(hw, TXGBE_MIS_ST);
+		if (((ecc & TXGBE_MIS_ST_LAN0_ECC) && hw->bus.lan_id == 0) ||
+		    ((ecc & TXGBE_MIS_ST_LAN1_ECC) && hw->bus.lan_id == 1))
+			adapter->flags2 |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+
+		txgbe_service_event_schedule(adapter);
+	}
+	if (eicr & TXGBE_PX_MISC_IC_DEV_RST) {
+		adapter->flags2 |= TXGBE_FLAG2_RESET_INTR_RECEIVED;
+		txgbe_service_event_schedule(adapter);
+	}
+	if ((eicr & TXGBE_PX_MISC_IC_STALL) ||
+	    (eicr & TXGBE_PX_MISC_IC_ETH_EVENT)) {
+		adapter->flags2 |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+		txgbe_service_event_schedule(adapter);
+	}
+
+	txgbe_check_sfp_event(adapter, eicr);
+	txgbe_check_overtemp_event(adapter, eicr);
+
+	/* re-enable the original interrupt state, no lsc, no queues */
+	if (!test_bit(__TXGBE_DOWN, &adapter->state))
+		txgbe_irq_enable(adapter, false, false);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t txgbe_msix_clean_rings(int __always_unused irq, void *data)
+{
+	struct txgbe_q_vector *q_vector = data;
+
+	/* EIAM disabled interrupts (on this vector) for us */
+
+	if (q_vector->rx.ring || q_vector->tx.ring)
+		napi_schedule_irqoff(&q_vector->napi);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * txgbe_request_msix_irqs - Initialize MSI-X interrupts
+ * @adapter: board private structure
+ *
+ * txgbe_request_msix_irqs allocates MSI-X vectors and requests
+ * interrupts from the kernel.
+ **/
+static int txgbe_request_msix_irqs(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	int vector, err;
+	int ri = 0, ti = 0;
+
+	for (vector = 0; vector < adapter->num_q_vectors; vector++) {
+		struct txgbe_q_vector *q_vector = adapter->q_vector[vector];
+		struct msix_entry *entry = &adapter->msix_entries[vector];
+
+		if (q_vector->tx.ring && q_vector->rx.ring) {
+			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
+				 "%s-TxRx-%d", netdev->name, ri++);
+			ti++;
+		} else if (q_vector->rx.ring) {
+			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
+				 "%s-rx-%d", netdev->name, ri++);
+		} else if (q_vector->tx.ring) {
+			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
+				 "%s-tx-%d", netdev->name, ti++);
+		} else {
+			/* skip this unused q_vector */
+			continue;
+		}
+		err = request_irq(entry->vector, &txgbe_msix_clean_rings, 0,
+				  q_vector->name, q_vector);
+		if (err) {
+			txgbe_err(probe, "request_irq failed for MSIX interrupt '%s' Error: %d\n",
+				  q_vector->name, err);
+			goto free_queue_irqs;
+		}
+	}
+
+	err = request_irq(adapter->msix_entries[vector].vector,
+			  txgbe_msix_other, 0, netdev->name, adapter);
+	if (err) {
+		txgbe_err(probe, "request_irq for msix_other failed: %d\n", err);
+		goto free_queue_irqs;
+	}
+
+	return 0;
+
+free_queue_irqs:
+	while (vector) {
+		vector--;
+		irq_set_affinity_hint(adapter->msix_entries[vector].vector,
+				      NULL);
+		free_irq(adapter->msix_entries[vector].vector,
+			 adapter->q_vector[vector]);
+	}
+	adapter->flags &= ~TXGBE_FLAG_MSIX_ENABLED;
+	pci_disable_msix(adapter->pdev);
+	kfree(adapter->msix_entries);
+	adapter->msix_entries = NULL;
+	return err;
+}
+
+/**
+ * txgbe_intr - legacy mode Interrupt Handler
+ * @irq: interrupt number
+ * @data: pointer to a network interface device structure
+ **/
+static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
+{
+	struct txgbe_adapter *adapter = data;
+	struct txgbe_q_vector *q_vector = adapter->q_vector[0];
+	u32 eicr;
+	u32 eicr_misc;
+
+	eicr = txgbe_misc_isb(adapter, TXGBE_ISB_VEC0);
+	if (!eicr) {
+		/* shared interrupt alert!
+		 * the interrupt that we masked before the EICR read.
+		 */
+		if (!test_bit(__TXGBE_DOWN, &adapter->state))
+			txgbe_irq_enable(adapter, true, true);
+		return IRQ_NONE;        /* Not our interrupt */
+	}
+	adapter->isb_mem[TXGBE_ISB_VEC0] = 0;
+	if (!(adapter->flags & TXGBE_FLAG_MSI_ENABLED))
+		wr32(&adapter->hw, TXGBE_PX_INTA, 1);
+
+	eicr_misc = txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
+	if (eicr_misc & (TXGBE_PX_MISC_IC_ETH_LK | TXGBE_PX_MISC_IC_ETH_LKDN))
+		txgbe_check_lsc(adapter);
+
+	if (eicr_misc & TXGBE_PX_MISC_IC_INT_ERR) {
+		txgbe_info(link, "Received unrecoverable ECC Err, initiating reset.\n");
+		adapter->flags2 |= TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
+		txgbe_service_event_schedule(adapter);
+	}
+
+	if (eicr_misc & TXGBE_PX_MISC_IC_DEV_RST) {
+		adapter->flags2 |= TXGBE_FLAG2_RESET_INTR_RECEIVED;
+		txgbe_service_event_schedule(adapter);
+	}
+	txgbe_check_sfp_event(adapter, eicr_misc);
+	txgbe_check_overtemp_event(adapter, eicr_misc);
+
+	adapter->isb_mem[TXGBE_ISB_MISC] = 0;
+	/* would disable interrupts here but it is auto disabled */
+	napi_schedule_irqoff(&q_vector->napi);
+
+	/* re-enable link(maybe) and non-queue interrupts, no flush.
+	 * txgbe_poll will re-enable the queue interrupts
+	 */
+	if (!test_bit(__TXGBE_DOWN, &adapter->state))
+		txgbe_irq_enable(adapter, false, false);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * txgbe_request_irq - initialize interrupts
+ * @adapter: board private structure
+ *
+ * Attempts to configure interrupts using the best available
+ * capabilities of the hardware and kernel.
+ **/
+static int txgbe_request_irq(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	int err;
+
+	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED)
+		err = txgbe_request_msix_irqs(adapter);
+	else if (adapter->flags & TXGBE_FLAG_MSI_ENABLED)
+		err = request_irq(adapter->pdev->irq, &txgbe_intr, 0,
+				  netdev->name, adapter);
+	else
+		err = request_irq(adapter->pdev->irq, &txgbe_intr, IRQF_SHARED,
+				  netdev->name, adapter);
+
+	if (err)
+		txgbe_err(probe, "request_irq failed, Error %d\n", err);
+
+	return err;
+}
+
+static void txgbe_free_irq(struct txgbe_adapter *adapter)
+{
+	int vector;
+
+	if (!(adapter->flags & TXGBE_FLAG_MSIX_ENABLED)) {
+		free_irq(adapter->pdev->irq, adapter);
+		return;
+	}
+
+	for (vector = 0; vector < adapter->num_q_vectors; vector++) {
+		struct txgbe_q_vector *q_vector = adapter->q_vector[vector];
+		struct msix_entry *entry = &adapter->msix_entries[vector];
+
+		/* free only the irqs that were actually requested */
+		if (!q_vector->rx.ring && !q_vector->tx.ring)
+			continue;
+
+		/* clear the affinity_mask in the IRQ descriptor */
+		irq_set_affinity_hint(entry->vector, NULL);
+		free_irq(entry->vector, q_vector);
+	}
+
+	free_irq(adapter->msix_entries[vector++].vector, adapter);
+}
+
+/**
+ * txgbe_irq_disable - Mask off interrupt generation on the NIC
+ * @adapter: board private structure
+ **/
+void txgbe_irq_disable(struct txgbe_adapter *adapter)
+{
+	wr32(&adapter->hw, TXGBE_PX_MISC_IEN, 0);
+	txgbe_intr_disable(&adapter->hw, TXGBE_INTR_ALL);
+
+	TXGBE_WRITE_FLUSH(&adapter->hw);
+	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED) {
+		int vector;
+
+		for (vector = 0; vector < adapter->num_q_vectors; vector++)
+			synchronize_irq(adapter->msix_entries[vector].vector);
+
+		synchronize_irq(adapter->msix_entries[vector++].vector);
+	} else {
+		synchronize_irq(adapter->pdev->irq);
+	}
+}
+
+/**
+ * txgbe_configure_msi_and_legacy - Initialize PIN (INTA...) and MSI interrupts
+ *
+ **/
+static void txgbe_configure_msi_and_legacy(struct txgbe_adapter *adapter)
+{
+	struct txgbe_q_vector *q_vector = adapter->q_vector[0];
+	struct txgbe_ring *ring;
+
+	txgbe_write_eitr(q_vector);
+
+	txgbe_for_each_ring(ring, q_vector->rx)
+		txgbe_set_ivar(adapter, 0, ring->reg_idx, 0);
+
+	txgbe_for_each_ring(ring, q_vector->tx)
+		txgbe_set_ivar(adapter, 1, ring->reg_idx, 0);
+
+	txgbe_set_ivar(adapter, -1, 0, 1);
+
+	txgbe_info(hw, "Legacy interrupt IVAR setup done\n");
+}
+
 static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
@@ -191,6 +700,21 @@ static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
 	txgbe_sync_mac_table(adapter);
 }
 
+void txgbe_configure_isb(struct txgbe_adapter *adapter)
+{
+	/* set ISB Address */
+	struct txgbe_hw *hw = &adapter->hw;
+
+	wr32(hw, TXGBE_PX_ISB_ADDR_L,
+	     adapter->isb_dma & DMA_BIT_MASK(32));
+	wr32(hw, TXGBE_PX_ISB_ADDR_H, adapter->isb_dma >> 32);
+}
+
+static void txgbe_configure(struct txgbe_adapter *adapter)
+{
+	txgbe_configure_isb(adapter);
+}
+
 static bool txgbe_is_sfp(struct txgbe_hw *hw)
 {
 	switch (TCALL(hw, mac.ops.get_media_type)) {
@@ -227,12 +751,29 @@ static void txgbe_sfp_link_config(struct txgbe_adapter *adapter)
 	adapter->sfp_poll_time = 0;
 }
 
+static void txgbe_setup_gpie(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 gpie = 0;
+
+	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED)
+		gpie = TXGBE_PX_GPIE_MODEL;
+
+	wr32(hw, TXGBE_PX_GPIE, gpie);
+}
+
 static void txgbe_up_complete(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
 	u32 links_reg;
 
 	txgbe_get_hw_control(adapter);
+	txgbe_setup_gpie(adapter);
+
+	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED)
+		txgbe_configure_msix(adapter);
+	else
+		txgbe_configure_msi_and_legacy(adapter);
 
 	/* enable the optics for SFP+ fiber */
 	TCALL(hw, mac.ops.enable_tx_laser);
@@ -262,6 +803,22 @@ static void txgbe_up_complete(struct txgbe_adapter *adapter)
 		}
 	}
 
+	/* clear any pending interrupts, may auto mask */
+	rd32(hw, TXGBE_PX_IC(0));
+	rd32(hw, TXGBE_PX_IC(1));
+	rd32(hw, TXGBE_PX_MISC_IC);
+	if ((hw->subsystem_id & 0xF0) == TXGBE_ID_XAUI)
+		wr32(hw, TXGBE_GPIO_EOI, TXGBE_GPIO_EOI_6);
+	txgbe_irq_enable(adapter, true, true);
+
+	/* bring the link up in the watchdog, this could race with our first
+	 * link up interrupt but shouldn't be a problem
+	 */
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
+	adapter->link_check_timeout = jiffies;
+
+	mod_timer(&adapter->service_timer, jiffies);
+
 	if (hw->bus.lan_id == 0) {
 		wr32m(hw, TXGBE_MIS_PRB_CTL,
 		      TXGBE_MIS_PRB_CTL_LAN0_UP, TXGBE_MIS_PRB_CTL_LAN0_UP);
@@ -278,6 +835,26 @@ static void txgbe_up_complete(struct txgbe_adapter *adapter)
 	      TXGBE_CFG_PORT_CTL_PFRSTD, TXGBE_CFG_PORT_CTL_PFRSTD);
 }
 
+void txgbe_reinit_locked(struct txgbe_adapter *adapter)
+{
+	/* put off any impending NetWatchDogTimeout */
+	netif_trans_update(adapter->netdev);
+
+	while (test_and_set_bit(__TXGBE_RESETTING, &adapter->state))
+		usleep_range(1000, 2000);
+	txgbe_down(adapter);
+	txgbe_up(adapter);
+	clear_bit(__TXGBE_RESETTING, &adapter->state);
+}
+
+void txgbe_up(struct txgbe_adapter *adapter)
+{
+	/* hardware has been reset, we need to reload some things */
+	txgbe_configure(adapter);
+
+	txgbe_up_complete(adapter);
+}
+
 void txgbe_reset(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
@@ -336,6 +913,10 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
+	txgbe_irq_disable(adapter);
+
+	adapter->flags2 &= ~(TXGBE_FLAG2_PF_RESET_REQUESTED |
+			     TXGBE_FLAG2_GLOBAL_RESET_REQUESTED);
 	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
 
 	del_timer_sync(&adapter->service_timer);
@@ -451,6 +1032,41 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 	return err;
 }
 
+/**
+ * txgbe_setup_isb_resources - allocate interrupt status resources
+ * @adapter: board private structure
+ *
+ * Return 0 on success, negative on failure
+ **/
+static int txgbe_setup_isb_resources(struct txgbe_adapter *adapter)
+{
+	struct device *dev = pci_dev_to_dev(adapter->pdev);
+
+	adapter->isb_mem = dma_alloc_coherent(dev,
+					      sizeof(u32) * TXGBE_ISB_MAX,
+					      &adapter->isb_dma,
+					      GFP_KERNEL);
+	if (!adapter->isb_mem)
+		return -ENOMEM;
+	memset(adapter->isb_mem, 0, sizeof(u32) * TXGBE_ISB_MAX);
+	return 0;
+}
+
+/**
+ * txgbe_free_isb_resources - allocate all queues Rx resources
+ * @adapter: board private structure
+ *
+ * Return 0 on success, negative on failure
+ **/
+static void txgbe_free_isb_resources(struct txgbe_adapter *adapter)
+{
+	struct device *dev = pci_dev_to_dev(adapter->pdev);
+
+	dma_free_coherent(dev, sizeof(u32) * TXGBE_ISB_MAX,
+			  adapter->isb_mem, adapter->isb_dma);
+	adapter->isb_mem = NULL;
+}
+
 /**
  * txgbe_open - Called when a network interface is made active
  * @netdev: network interface device structure
@@ -466,12 +1082,39 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 int txgbe_open(struct net_device *netdev)
 {
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	int err;
 
 	netif_carrier_off(netdev);
 
+	err = txgbe_setup_isb_resources(adapter);
+	if (err)
+		goto err_req_isb;
+
+	txgbe_configure(adapter);
+
+	err = txgbe_request_irq(adapter);
+	if (err)
+		goto err_req_irq;
+
+	/* Notify the stack of the actual queue counts. */
+	err = netif_set_real_num_tx_queues(netdev, adapter->num_tx_queues);
+	if (err)
+		goto err_set_queues;
+
+	err = netif_set_real_num_rx_queues(netdev, adapter->num_rx_queues);
+	if (err)
+		goto err_set_queues;
+
 	txgbe_up_complete(adapter);
 
 	return 0;
+
+err_set_queues:
+	txgbe_free_irq(adapter);
+err_req_irq:
+	txgbe_free_isb_resources(adapter);
+err_req_isb:
+	return err;
 }
 
 /**
@@ -488,6 +1131,9 @@ static void txgbe_close_suspend(struct txgbe_adapter *adapter)
 	txgbe_disable_device(adapter);
 	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
 		TCALL(hw, mac.ops.disable_tx_laser);
+	txgbe_free_irq(adapter);
+
+	txgbe_free_isb_resources(adapter);
 }
 
 /**
@@ -506,6 +1152,9 @@ int txgbe_close(struct net_device *netdev)
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
 
 	txgbe_down(adapter);
+	txgbe_free_irq(adapter);
+
+	txgbe_free_isb_resources(adapter);
 
 	txgbe_release_hw_control(adapter);
 
@@ -524,6 +1173,8 @@ static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		txgbe_close_suspend(adapter);
 	rtnl_unlock();
 
+	txgbe_clear_interrupt_scheme(adapter);
+
 	txgbe_release_hw_control(adapter);
 
 	if (!test_and_set_bit(__TXGBE_DISABLED, &adapter->state))
@@ -811,6 +1462,83 @@ static void txgbe_service_timer(struct timer_list *t)
 	txgbe_service_event_schedule(adapter);
 }
 
+static void txgbe_reset_subtask(struct txgbe_adapter *adapter)
+{
+	u32 reset_flag = 0;
+	u32 value = 0;
+
+	if (!(adapter->flags2 & (TXGBE_FLAG2_PF_RESET_REQUESTED |
+				 TXGBE_FLAG2_GLOBAL_RESET_REQUESTED |
+				 TXGBE_FLAG2_RESET_INTR_RECEIVED)))
+		return;
+
+	/* If we're already down, just bail */
+	if (test_bit(__TXGBE_DOWN, &adapter->state) ||
+	    test_bit(__TXGBE_REMOVING, &adapter->state))
+		return;
+
+	netdev_err(adapter->netdev, "Reset adapter\n");
+
+	rtnl_lock();
+	if (adapter->flags2 & TXGBE_FLAG2_GLOBAL_RESET_REQUESTED) {
+		reset_flag |= TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
+		adapter->flags2 &= ~TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
+	}
+	if (adapter->flags2 & TXGBE_FLAG2_PF_RESET_REQUESTED) {
+		reset_flag |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+		adapter->flags2 &= ~TXGBE_FLAG2_PF_RESET_REQUESTED;
+	}
+
+	if (adapter->flags2 & TXGBE_FLAG2_RESET_INTR_RECEIVED) {
+		/* If there's a recovery already waiting, it takes
+		 * precedence before starting a new reset sequence.
+		 */
+		adapter->flags2 &= ~TXGBE_FLAG2_RESET_INTR_RECEIVED;
+		value = rd32m(&adapter->hw, TXGBE_MIS_RST_ST,
+			      TXGBE_MIS_RST_ST_DEV_RST_TYPE_MASK) >>
+			TXGBE_MIS_RST_ST_DEV_RST_TYPE_SHIFT;
+		if (value == TXGBE_MIS_RST_ST_DEV_RST_TYPE_SW_RST) {
+			adapter->hw.reset_type = TXGBE_SW_RESET;
+			/* errata 7 */
+			if (txgbe_mng_present(&adapter->hw) &&
+			    adapter->hw.revision_id == TXGBE_SP_MPW)
+				adapter->flags2 |=
+					TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED;
+		} else if (value == TXGBE_MIS_RST_ST_DEV_RST_TYPE_GLOBAL_RST) {
+			adapter->hw.reset_type = TXGBE_GLOBAL_RESET;
+		}
+		adapter->hw.force_full_reset = true;
+		txgbe_reinit_locked(adapter);
+		adapter->hw.force_full_reset = false;
+		goto unlock;
+	}
+
+	if (reset_flag & TXGBE_FLAG2_PF_RESET_REQUESTED) {
+		/*debug to up*/
+		txgbe_reinit_locked(adapter);
+	} else if (reset_flag & TXGBE_FLAG2_GLOBAL_RESET_REQUESTED) {
+		/* Request a Global Reset
+		 *
+		 * This will start the chip's countdown to the actual full
+		 * chip reset event, and a warning interrupt to be sent
+		 * to all PFs, including the requestor.  Our handler
+		 * for the warning interrupt will deal with the shutdown
+		 * and recovery of the switch setup.
+		 */
+		/*debug to up*/
+		pci_save_state(adapter->pdev);
+		if (txgbe_mng_present(&adapter->hw))
+			txgbe_reset_hostif(&adapter->hw);
+		else
+			wr32m(&adapter->hw, TXGBE_MIS_RST,
+			      TXGBE_MIS_RST_GLOBAL_RST,
+			      TXGBE_MIS_RST_GLOBAL_RST);
+	}
+
+unlock:
+	rtnl_unlock();
+}
+
 /**
  * txgbe_service_task - manages and runs subtasks
  * @work: pointer to work_struct containing our data
@@ -830,8 +1558,10 @@ static void txgbe_service_task(struct work_struct *work)
 		return;
 	}
 
+	txgbe_reset_subtask(adapter);
 	txgbe_sfp_detection_subtask(adapter);
 	txgbe_sfp_link_config_subtask(adapter);
+	txgbe_check_overtemp_subtask(adapter);
 	txgbe_watchdog_subtask(adapter);
 
 	txgbe_service_event_complete(adapter);
@@ -1053,6 +1783,10 @@ static int txgbe_probe(struct pci_dev *pdev,
 	set_bit(__TXGBE_SERVICE_INITED, &adapter->state);
 	clear_bit(__TXGBE_SERVICE_SCHED, &adapter->state);
 
+	err = txgbe_init_interrupt_scheme(adapter);
+	if (err)
+		goto err_sw_init;
+
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
 	 */
@@ -1167,6 +1901,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	return 0;
 
 err_register:
+	txgbe_clear_interrupt_scheme(adapter);
 	txgbe_release_hw_control(adapter);
 err_sw_init:
 	kfree(adapter->mac_table);
@@ -1215,6 +1950,7 @@ static void txgbe_remove(struct pci_dev *pdev)
 		adapter->netdev_registered = false;
 	}
 
+	txgbe_clear_interrupt_scheme(adapter);
 	txgbe_release_hw_control(adapter);
 
 	iounmap(adapter->io_addr);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index bd4c5e117358..1e3137506812 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -399,3 +399,25 @@ s32 txgbe_read_i2c_byte(struct txgbe_hw *hw, u8 byte_offset,
 				       data, true);
 }
 
+/**
+ *  txgbe_tn_check_overtemp - Checks if an overtemp occurred.
+ *  @hw: pointer to hardware structure
+ *
+ *  Checks if the LASI temp alarm status was triggered due to overtemp
+ **/
+s32 txgbe_check_overtemp(struct txgbe_hw *hw)
+{
+	s32 status = 0;
+	u32 ts_state;
+
+	/* Check that the LASI temp alarm status was triggered */
+	ts_state = rd32(hw, TXGBE_TS_ALARM_ST);
+
+	if (ts_state & TXGBE_TS_ALARM_ST_DALARM)
+		status = TXGBE_ERR_UNDERTEMP;
+	else if (ts_state & TXGBE_TS_ALARM_ST_ALARM)
+		status = TXGBE_ERR_OVERTEMP;
+
+	return status;
+}
+
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
index 4798623fb735..3efb4abef03a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
@@ -43,6 +43,7 @@ s32 txgbe_check_reset_blocked(struct txgbe_hw *hw);
 
 s32 txgbe_identify_module(struct txgbe_hw *hw);
 s32 txgbe_identify_sfp_module(struct txgbe_hw *hw);
+s32 txgbe_check_overtemp(struct txgbe_hw *hw);
 s32 txgbe_init_i2c(struct txgbe_hw *hw);
 s32 txgbe_switch_i2c_slave_addr(struct txgbe_hw *hw, u8 dev_addr);
 s32 txgbe_read_i2c_byte(struct txgbe_hw *hw, u8 byte_offset,
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index c068fa933ab6..ff2b7a4f028b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -2002,6 +2002,7 @@ struct txgbe_phy_operations {
 			     u8 dev_addr, u8 *data);
 	s32 (*read_i2c_eeprom)(struct txgbe_hw *hw, u8 byte_offset,
 			       u8 *eeprom_data);
+	s32 (*check_overtemp)(struct txgbe_hw *hw);
 };
 
 struct txgbe_eeprom_info {
@@ -2032,6 +2033,7 @@ struct txgbe_mac_info {
 	u32 orig_sr_an_mmd_adv_reg2;
 	u32 orig_vr_xs_or_pcs_mmd_digi_ctl1;
 	u8  san_mac_rar_index;
+	u16 max_msix_vectors;
 	bool orig_link_settings_stored;
 	bool autotry_restart;
 	struct txgbe_thermal_sensor_data  thermal_sensor_data;
-- 
2.27.0



