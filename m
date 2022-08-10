Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2238A58E91E
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiHJI4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbiHJI4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:56:45 -0400
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C076E2FB
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:56:40 -0700 (PDT)
X-QQ-mid: bizesmtp82t1660121797t2y9mspf
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 10 Aug 2022 16:56:36 +0800 (CST)
X-QQ-SSF: 01400000000000G0S000B00A0000000
X-QQ-FEAT: lj50s4tNr7pfT/+PH6k1Cm4MGA9A5e9/HgeCXSiY1NDXeZGK3sj604tR/WLPG
        rBhZjF+oye8l5G70KeEoyOkN9/TNIQ1tJQJnjxcwkzp6x7pwDmoxf5Vrxf2CXCHSh1H3sNG
        5P1CixVHF5GT8lFliFlRL6t1TyFezw/tTCmGy060NLXffMPPTw1wkcuPkcInuZqtx1BMsEc
        C8q0ruHbCIsWm3MLz65OvIsfMutgG1gugIP6xlO5YA+3VS3GeCeIuZMDzSBUbnhKDE893ht
        HxADDiKhSnBhi9vHsQM8PIY7zt0HiT7yzFa9wIVMbxoSsb+RYsfAOUnQWdTrd9DaIn7Rc0J
        pj8wK+K1+DJP55NDk1IELfuDq0u0RTA9O49m3Z4ktIHb/e4JMCBGKsfC90m9k9a+Hhapajk
        TDf9zxg9RC4=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next 08/16] net: txgbe: Add interrupt support
Date:   Wed, 10 Aug 2022 16:55:24 +0800
Message-Id: <20220810085532.246613-9-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220810085532.246613-1-jiawenwu@trustnetic.com>
References: <20220810085532.246613-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Determine proper interrupt scheme based on kernel support and
hardware queue count. Allocate memory for interrupt vectors.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    | 128 +++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  35 ++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_lib.c    | 435 ++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 480 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 131 +++++
 7 files changed, 1211 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c

diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index 875704a29c4c..0111fda0e784 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -7,4 +7,5 @@
 obj-$(CONFIG_TXGBE) += txgbe.o
 
 txgbe-objs := txgbe_main.o \
-              txgbe_hw.o txgbe_phy.o
+              txgbe_hw.o txgbe_phy.o \
+              txgbe_lib.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 0f06efbcfef5..a4ebc58a984b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -12,6 +12,13 @@
 #include "txgbe_type.h"
 
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
 
@@ -20,6 +27,52 @@ struct txgbe_ring {
 #define TXGBE_MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 #define TXGBE_MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 
+struct txgbe_ring_container {
+	struct txgbe_ring *ring;        /* pointer to linked list of rings */
+	u16 work_limit;                 /* total work allowed per interrupt */
+	u8 count;                       /* total number of rings in vector */
+};
+
+/* iterator for handling rings in ring container */
+#define txgbe_for_each_ring(pos, head) \
+	for (pos = (head).ring; pos; pos = pos->next)
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
+#define TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE       64
+
 struct txgbe_mac_addr {
 	u8 addr[ETH_ALEN];
 	u16 state; /* bitmask */
@@ -30,6 +83,12 @@ struct txgbe_mac_addr {
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
@@ -39,6 +98,8 @@ struct txgbe_mac_addr {
  **/
 #define TXGBE_FLAG_NEED_LINK_UPDATE             BIT(0)
 #define TXGBE_FLAG_NEED_LINK_CONFIG             BIT(1)
+#define TXGBE_FLAG_MSI_ENABLED                  BIT(2)
+#define TXGBE_FLAG_MSIX_ENABLED                 BIT(3)
 
 /**
  * txgbe_adapter.flag2
@@ -46,6 +107,14 @@ struct txgbe_mac_addr {
 #define TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED     BIT(0)
 #define TXGBE_FLAG2_SFP_NEEDS_RESET             BIT(1)
 
+enum txgbe_isb_idx {
+	TXGBE_ISB_HEADER,
+	TXGBE_ISB_MISC,
+	TXGBE_ISB_VEC0,
+	TXGBE_ISB_VEC1,
+	TXGBE_ISB_MAX
+};
+
 /* board specific private data structure */
 struct txgbe_adapter {
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
@@ -59,14 +128,30 @@ struct txgbe_adapter {
 	u32 flags2;
 	/* Tx fast path data */
 	int num_tx_queues;
+	u16 tx_itr_setting;
+
+	/* Rx fast path data */
+	int num_rx_queues;
+	u16 rx_itr_setting;
 
 	/* TX */
 	struct txgbe_ring *tx_ring[TXGBE_MAX_TX_QUEUES] ____cacheline_aligned_in_smp;
 
+	/* RX */
+	struct txgbe_ring *rx_ring[TXGBE_MAX_RX_QUEUES];
+	struct txgbe_q_vector *q_vector[MAX_MSIX_Q_VECTORS];
+
+	int num_q_vectors;      /* current number of q_vectors for device */
+	int max_q_vectors;      /* upper limit of q_vectors for device */
+	struct msix_entry *msix_entries;
+
 	/* structs defined in txgbe_type.h */
 	struct txgbe_hw hw;
 	u16 msg_enable;
 
+	unsigned int tx_ring_count;
+	unsigned int rx_ring_count;
+
 	u32 link_speed;
 	bool link_up;
 	unsigned long sfp_poll_time;
@@ -80,8 +165,24 @@ struct txgbe_adapter {
 
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
+
+	cur_tag = adapter->isb_mem[TXGBE_ISB_HEADER];
+
+	adapter->isb_tag[idx] = cur_tag;
+
+	return adapter->isb_mem[idx];
+}
+
 enum txgbe_state_t {
 	__TXGBE_TESTING,
 	__TXGBE_RESETTING,
@@ -98,14 +199,41 @@ enum txgbe_state_t {
 void txgbe_service_event_schedule(struct txgbe_adapter *adapter);
 void txgbe_assign_netdev_ops(struct net_device *netdev);
 
+void txgbe_irq_disable(struct txgbe_adapter *adapter);
+void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush);
 int txgbe_open(struct net_device *netdev);
 int txgbe_close(struct net_device *netdev);
 void txgbe_down(struct txgbe_adapter *adapter);
 void txgbe_reset(struct txgbe_adapter *adapter);
 s32 txgbe_init_shared_code(struct txgbe_hw *hw);
 void txgbe_disable_device(struct txgbe_adapter *adapter);
+int txgbe_init_interrupt_scheme(struct txgbe_adapter *adapter);
+void txgbe_reset_interrupt_capability(struct txgbe_adapter *adapter);
+void txgbe_set_interrupt_capability(struct txgbe_adapter *adapter);
+void txgbe_clear_interrupt_scheme(struct txgbe_adapter *adapter);
+void txgbe_write_eitr(struct txgbe_q_vector *q_vector);
 
+/**
+ * interrupt masking operations. each bit in PX_ICn correspond to a interrupt.
+ * disable a interrupt by writing to PX_IMS with the corresponding bit=1
+ * enable a interrupt by writing to PX_IMC with the corresponding bit=1
+ * trigger a interrupt by writing to PX_ICS with the corresponding bit=1
+ **/
 #define TXGBE_INTR_ALL (~0ULL)
+#define TXGBE_INTR_MISC(A) (1ULL << (A)->num_q_vectors)
+#define TXGBE_INTR_QALL(A) (TXGBE_INTR_MISC(A) - 1)
+#define TXGBE_INTR_Q(i) (1ULL << (i))
+static inline void txgbe_intr_enable(struct txgbe_hw *hw, u64 qmask)
+{
+	u32 mask;
+
+	mask = (qmask & 0xFFFFFFFF);
+	if (mask)
+		wr32(hw, TXGBE_PX_IMC(0), mask);
+	mask = (qmask >> 32);
+	if (mask)
+		wr32(hw, TXGBE_PX_IMC(1), mask);
+}
 
 static inline void txgbe_intr_disable(struct txgbe_hw *hw, u64 qmask)
 {
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 89a67b158fa5..8dd0dec41971 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -57,6 +57,40 @@ void txgbe_wr32_epcs(struct txgbe_hw *hw, u32 addr, u32 data)
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
+	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
+	u16 msix_count = 1;
+	u16 max_msix_count;
+	u32 pos;
+
+	max_msix_count = TXGBE_MAX_MSIX_VECTORS_SAPPHIRE;
+	pos = pci_find_capability(adapter->pdev, PCI_CAP_ID_MSIX);
+	if (!pos)
+		return msix_count;
+	pci_read_config_word(adapter->pdev,
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
@@ -1521,6 +1555,7 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	mac->num_rar_entries    = TXGBE_SP_RAR_ENTRIES;
 	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
 	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
+	mac->max_msix_vectors   = txgbe_get_pcie_msix_count(hw);
 
 	/* EEPROM */
 	eeprom->ops.init_params = txgbe_init_eeprom_params;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index d620c88f6318..d52c3b5775cc 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -16,6 +16,7 @@
 #define SPI_H_DAT_REG_ADDR           0x10108  /* SPI Data register address */
 #define SPI_H_STA_REG_ADDR           0x1010c  /* SPI Status register address */
 
+u16 txgbe_get_pcie_msix_count(struct txgbe_hw *hw);
 s32 txgbe_init_hw(struct txgbe_hw *hw);
 s32 txgbe_start_hw(struct txgbe_hw *hw);
 s32 txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num,
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
new file mode 100644
index 000000000000..e7b6316e3b56
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
@@ -0,0 +1,435 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
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
+		dev_warn(&adapter->pdev->dev,
+			 "Failed to allocate MSI-X interrupts. Err: %d\n",
+			 vectors);
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
+		ring->dev = &adapter->pdev->dev;
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
+		ring->dev = &adapter->pdev->dev;
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
+	adapter->num_q_vectors = 1;
+
+	err = pci_enable_msi(adapter->pdev);
+	if (err)
+		dev_warn(&adapter->pdev->dev,
+			 "Failed to allocate MSI interrupt, falling back to legacy. Error: %d\n",
+			 err);
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
+		netif_err(adapter, probe, adapter->netdev,
+			  "Unable to allocate memory for queue vectors\n");
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
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 7f5225004e28..71954d2d4b9a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -139,6 +139,355 @@ static void txgbe_get_hw_control(struct txgbe_adapter *adapter)
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
+ * txgbe_irq_enable - Enable default interrupt generation settings
+ * @adapter: board private structure
+ * @queues: enable irqs for queues
+ * @flush: flush register write
+ **/
+void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush)
+{
+	u32 mask = 0;
+	struct txgbe_hw *hw = &adapter->hw;
+	u8 device_type = hw->subsystem_device_id & 0xF0;
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
+
+	txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
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
+			netif_err(adapter, probe, netdev,
+				  "request_irq failed for MSIX interrupt '%s' Error: %d\n",
+				  q_vector->name, err);
+			goto free_queue_irqs;
+		}
+	}
+
+	err = request_irq(adapter->msix_entries[vector].vector,
+			  txgbe_msix_other, 0, netdev->name, adapter);
+	if (err) {
+		netif_err(adapter, probe, netdev,
+			  "request_irq for msix_other failed: %d\n", err);
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
+	u32 eicr;
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
+	txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
+
+	adapter->isb_mem[TXGBE_ISB_MISC] = 0;
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
+		netif_err(adapter, probe, adapter->netdev,
+			  "request_irq failed, Error %d\n", err);
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
+ * @adapter: board private structure
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
+	netif_info(adapter, hw, adapter->netdev,
+		   "Legacy interrupt IVAR setup done\n");
+}
+
 static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
@@ -190,6 +539,21 @@ static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
 	txgbe_sync_mac_table(adapter);
 }
 
+static void txgbe_configure_isb(struct txgbe_adapter *adapter)
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
 	switch (hw->phy.media_type) {
@@ -226,12 +590,29 @@ static void txgbe_sfp_link_config(struct txgbe_adapter *adapter)
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
@@ -262,6 +643,14 @@ static void txgbe_up_complete(struct txgbe_adapter *adapter)
 		}
 	}
 
+	/* clear any pending interrupts, may auto mask */
+	rd32(hw, TXGBE_PX_IC(0));
+	rd32(hw, TXGBE_PX_IC(1));
+	rd32(hw, TXGBE_PX_MISC_IC);
+	if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_XAUI)
+		wr32(hw, TXGBE_GPIO_EOI, TXGBE_GPIO_EOI_6);
+	txgbe_irq_enable(adapter, true, true);
+
 	/* Set PF Reset Done bit so PF/VF Mail Ops can work */
 	wr32m(hw, TXGBE_CFG_PORT_CTL,
 	      TXGBE_CFG_PORT_CTL_PFRSTD, TXGBE_CFG_PORT_CTL_PFRSTD);
@@ -324,6 +713,8 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
+	txgbe_irq_disable(adapter);
+
 	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
 
 	del_timer_sync(&adapter->service_timer);
@@ -426,11 +817,52 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 		return err;
 	}
 
+	/* enable itr by default in dynamic mode */
+	adapter->rx_itr_setting = 1;
+	adapter->tx_itr_setting = 1;
+
+	adapter->max_q_vectors = TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE;
+
 	set_bit(__TXGBE_DOWN, &adapter->state);
 
 	return 0;
 }
 
+/**
+ * txgbe_setup_isb_resources - allocate interrupt status resources
+ * @adapter: board private structure
+ *
+ * Return 0 on success, negative on failure
+ **/
+static int txgbe_setup_isb_resources(struct txgbe_adapter *adapter)
+{
+	struct device *dev = &adapter->pdev->dev;
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
+	struct device *dev = &adapter->pdev->dev;
+
+	dma_free_coherent(dev, sizeof(u32) * TXGBE_ISB_MAX,
+			  adapter->isb_mem, adapter->isb_dma);
+	adapter->isb_mem = NULL;
+}
+
 /**
  * txgbe_open - Called when a network interface is made active
  * @netdev: network interface device structure
@@ -438,17 +870,49 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
  * Returns 0 on success, negative value on failure
  *
  * The open entry point is called when a network interface is made
- * active by the system (IFF_UP).
+ * active by the system (IFF_UP).  At this point all resources needed
+ * for transmit and receive operations are allocated, the interrupt
+ * handler is registered with the OS, the watchdog timer is started,
+ * and the stack is notified that the interface is ready.
  **/
 int txgbe_open(struct net_device *netdev)
 {
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	int err;
 
 	netif_carrier_off(netdev);
 
+	err = txgbe_setup_isb_resources(adapter);
+	if (err)
+		goto err_reset;
+
+	txgbe_configure(adapter);
+
+	err = txgbe_request_irq(adapter);
+	if (err)
+		goto err_free_isb;
+
+	/* Notify the stack of the actual queue counts. */
+	err = netif_set_real_num_tx_queues(netdev, adapter->num_tx_queues);
+	if (err)
+		goto err_free_irq;
+
+	err = netif_set_real_num_rx_queues(netdev, adapter->num_rx_queues);
+	if (err)
+		goto err_free_irq;
+
 	txgbe_up_complete(adapter);
 
 	return 0;
+
+err_free_irq:
+	txgbe_free_irq(adapter);
+err_free_isb:
+	txgbe_free_isb_resources(adapter);
+err_reset:
+	txgbe_reset(adapter);
+
+	return err;
 }
 
 /**
@@ -465,6 +929,9 @@ static void txgbe_close_suspend(struct txgbe_adapter *adapter)
 	txgbe_disable_device(adapter);
 	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
 		TCALL(hw, mac.ops.disable_tx_laser);
+	txgbe_free_irq(adapter);
+
+	txgbe_free_isb_resources(adapter);
 }
 
 /**
@@ -483,6 +950,9 @@ int txgbe_close(struct net_device *netdev)
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
 
 	txgbe_down(adapter);
+	txgbe_free_irq(adapter);
+
+	txgbe_free_isb_resources(adapter);
 
 	txgbe_release_hw_control(adapter);
 
@@ -501,6 +971,8 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		txgbe_close_suspend(adapter);
 	rtnl_unlock();
 
+	txgbe_clear_interrupt_scheme(adapter);
+
 	txgbe_release_hw_control(adapter);
 
 	if (!test_and_set_bit(__TXGBE_DISABLED, &adapter->state))
@@ -1000,6 +1472,10 @@ static int txgbe_probe(struct pci_dev *pdev,
 	set_bit(__TXGBE_SERVICE_INITED, &adapter->state);
 	clear_bit(__TXGBE_SERVICE_SCHED, &adapter->state);
 
+	err = txgbe_init_interrupt_scheme(adapter);
+	if (err)
+		goto err_free_mac_table;
+
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
 	 */
@@ -1116,6 +1592,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	return 0;
 
 err_release_hw:
+	txgbe_clear_interrupt_scheme(adapter);
 	txgbe_release_hw_control(adapter);
 err_free_mac_table:
 	kfree(adapter->mac_table);
@@ -1157,6 +1634,7 @@ static void txgbe_remove(struct pci_dev *pdev)
 		adapter->netdev_registered = false;
 	}
 
+	txgbe_clear_interrupt_scheme(adapter);
 	txgbe_release_hw_control(adapter);
 
 	pci_release_selected_regions(pdev,
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index a8f9a8af980e..690b644962f2 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -410,6 +410,12 @@ struct txgbe_thermal_sensor_data {
 /* GPIO Registers */
 #define TXGBE_GPIO_DR                   0x14800
 #define TXGBE_GPIO_DDR                  0x14804
+#define TXGBE_GPIO_CTL                  0x14808
+#define TXGBE_GPIO_INTEN                0x14830
+#define TXGBE_GPIO_INTMASK              0x14834
+#define TXGBE_GPIO_INTTYPE_LEVEL        0x14838
+#define TXGBE_GPIO_INTSTATUS            0x14844
+#define TXGBE_GPIO_EOI                  0x1484C
 /*GPIO bit */
 #define TXGBE_GPIO_DR_0         0x00000001U /* SDP0 Data Value */
 #define TXGBE_GPIO_DR_1         0x00000002U /* SDP1 Data Value */
@@ -427,6 +433,25 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_GPIO_DDR_5        0x00000020U /* SDP5 IO direction */
 #define TXGBE_GPIO_DDR_6        0x00000040U /* SDP6 IO direction */
 #define TXGBE_GPIO_DDR_7        0x00000080U /* SDP7 IO direction */
+#define TXGBE_GPIO_CTL_SW_MODE  0x00000000U /* SDP software mode */
+#define TXGBE_GPIO_INTEN_1      0x00000002U /* SDP1 interrupt enable */
+#define TXGBE_GPIO_INTEN_2      0x00000004U /* SDP2 interrupt enable */
+#define TXGBE_GPIO_INTEN_3      0x00000008U /* SDP3 interrupt enable */
+#define TXGBE_GPIO_INTEN_5      0x00000020U /* SDP5 interrupt enable */
+#define TXGBE_GPIO_INTEN_6      0x00000040U /* SDP6 interrupt enable */
+#define TXGBE_GPIO_INTTYPE_LEVEL_2 0x00000004U /* SDP2 interrupt type level */
+#define TXGBE_GPIO_INTTYPE_LEVEL_3 0x00000008U /* SDP3 interrupt type level */
+#define TXGBE_GPIO_INTTYPE_LEVEL_5 0x00000020U /* SDP5 interrupt type level */
+#define TXGBE_GPIO_INTTYPE_LEVEL_6 0x00000040U /* SDP6 interrupt type level */
+#define TXGBE_GPIO_INTSTATUS_1  0x00000002U /* SDP1 interrupt status */
+#define TXGBE_GPIO_INTSTATUS_2  0x00000004U /* SDP2 interrupt status */
+#define TXGBE_GPIO_INTSTATUS_3  0x00000008U /* SDP3 interrupt status */
+#define TXGBE_GPIO_INTSTATUS_5  0x00000020U /* SDP5 interrupt status */
+#define TXGBE_GPIO_INTSTATUS_6  0x00000040U /* SDP6 interrupt status */
+#define TXGBE_GPIO_EOI_2        0x00000004U /* SDP2 interrupt clear */
+#define TXGBE_GPIO_EOI_3        0x00000008U /* SDP3 interrupt clear */
+#define TXGBE_GPIO_EOI_5        0x00000020U /* SDP5 interrupt clear */
+#define TXGBE_GPIO_EOI_6        0x00000040U /* SDP6 interrupt clear */
 
 /*********************** Transmit DMA registers **************************/
 /* transmit global control */
@@ -615,6 +640,107 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_PX_TRANSACTION_PENDING            0x168
 #define TXGBE_PX_INTA                           0x110
 
+/* Interrupt register bitmasks */
+/* Extended Interrupt Cause Read */
+#define TXGBE_PX_MISC_IC_ETH_LKDN       0x00000100U /* eth link down */
+#define TXGBE_PX_MISC_IC_DEV_RST        0x00000400U /* device reset event */
+#define TXGBE_PX_MISC_IC_TIMESYNC       0x00000800U /* time sync */
+#define TXGBE_PX_MISC_IC_STALL          0x00001000U /* trans or recv path is stalled */
+#define TXGBE_PX_MISC_IC_LINKSEC        0x00002000U /* Tx LinkSec require key exchange */
+#define TXGBE_PX_MISC_IC_RX_MISS        0x00004000U /* Packet Buffer Overrun */
+#define TXGBE_PX_MISC_IC_FLOW_DIR       0x00008000U /* FDir Exception */
+#define TXGBE_PX_MISC_IC_I2C            0x00010000U /* I2C interrupt */
+#define TXGBE_PX_MISC_IC_ETH_EVENT      0x00020000U /* err reported by MAC except eth link down */
+#define TXGBE_PX_MISC_IC_ETH_LK         0x00040000U /* link up */
+#define TXGBE_PX_MISC_IC_ETH_AN         0x00080000U /* link auto-nego done */
+#define TXGBE_PX_MISC_IC_INT_ERR        0x00100000U /* integrity error */
+#define TXGBE_PX_MISC_IC_SPI            0x00200000U /* SPI interface */
+#define TXGBE_PX_MISC_IC_VF_MBOX        0x00800000U /* VF-PF message box */
+#define TXGBE_PX_MISC_IC_GPIO           0x04000000U /* GPIO interrupt */
+#define TXGBE_PX_MISC_IC_PCIE_REQ_ERR   0x08000000U /* pcie request error int */
+#define TXGBE_PX_MISC_IC_OVER_HEAT      0x10000000U /* overheat detection */
+#define TXGBE_PX_MISC_IC_PROBE_MATCH    0x20000000U /* probe match */
+#define TXGBE_PX_MISC_IC_MNG_HOST_MBOX  0x40000000U /* mng mailbox */
+#define TXGBE_PX_MISC_IC_TIMER          0x80000000U /* tcp timer */
+
+/* Extended Interrupt Cause Set */
+#define TXGBE_PX_MISC_ICS_ETH_LKDN      0x00000100U
+#define TXGBE_PX_MISC_ICS_DEV_RST       0x00000400U
+#define TXGBE_PX_MISC_ICS_TIMESYNC      0x00000800U
+#define TXGBE_PX_MISC_ICS_STALL         0x00001000U
+#define TXGBE_PX_MISC_ICS_LINKSEC       0x00002000U
+#define TXGBE_PX_MISC_ICS_RX_MISS       0x00004000U
+#define TXGBE_PX_MISC_ICS_FLOW_DIR      0x00008000U
+#define TXGBE_PX_MISC_ICS_I2C           0x00010000U
+#define TXGBE_PX_MISC_ICS_ETH_EVENT     0x00020000U
+#define TXGBE_PX_MISC_ICS_ETH_LK        0x00040000U
+#define TXGBE_PX_MISC_ICS_ETH_AN        0x00080000U
+#define TXGBE_PX_MISC_ICS_INT_ERR       0x00100000U
+#define TXGBE_PX_MISC_ICS_SPI           0x00200000U
+#define TXGBE_PX_MISC_ICS_VF_MBOX       0x00800000U
+#define TXGBE_PX_MISC_ICS_GPIO          0x04000000U
+#define TXGBE_PX_MISC_ICS_PCIE_REQ_ERR  0x08000000U
+#define TXGBE_PX_MISC_ICS_OVER_HEAT     0x10000000U
+#define TXGBE_PX_MISC_ICS_PROBE_MATCH   0x20000000U
+#define TXGBE_PX_MISC_ICS_MNG_HOST_MBOX 0x40000000U
+#define TXGBE_PX_MISC_ICS_TIMER         0x80000000U
+
+/* Extended Interrupt Enable Set */
+#define TXGBE_PX_MISC_IEN_ETH_LKDN      0x00000100U
+#define TXGBE_PX_MISC_IEN_DEV_RST       0x00000400U
+#define TXGBE_PX_MISC_IEN_TIMESYNC      0x00000800U
+#define TXGBE_PX_MISC_IEN_STALL         0x00001000U
+#define TXGBE_PX_MISC_IEN_LINKSEC       0x00002000U
+#define TXGBE_PX_MISC_IEN_RX_MISS       0x00004000U
+#define TXGBE_PX_MISC_IEN_FLOW_DIR      0x00008000U
+#define TXGBE_PX_MISC_IEN_I2C           0x00010000U
+#define TXGBE_PX_MISC_IEN_ETH_EVENT     0x00020000U
+#define TXGBE_PX_MISC_IEN_ETH_LK        0x00040000U
+#define TXGBE_PX_MISC_IEN_ETH_AN        0x00080000U
+#define TXGBE_PX_MISC_IEN_INT_ERR       0x00100000U
+#define TXGBE_PX_MISC_IEN_SPI           0x00200000U
+#define TXGBE_PX_MISC_IEN_VF_MBOX       0x00800000U
+#define TXGBE_PX_MISC_IEN_GPIO          0x04000000U
+#define TXGBE_PX_MISC_IEN_PCIE_REQ_ERR  0x08000000U
+#define TXGBE_PX_MISC_IEN_OVER_HEAT     0x10000000U
+#define TXGBE_PX_MISC_IEN_PROBE_MATCH   0x20000000U
+#define TXGBE_PX_MISC_IEN_MNG_HOST_MBOX 0x40000000U
+#define TXGBE_PX_MISC_IEN_TIMER         0x80000000U
+
+#define TXGBE_PX_MISC_IEN_MASK ( \
+				TXGBE_PX_MISC_IEN_ETH_LKDN | \
+				TXGBE_PX_MISC_IEN_DEV_RST | \
+				TXGBE_PX_MISC_IEN_ETH_EVENT | \
+				TXGBE_PX_MISC_IEN_ETH_LK | \
+				TXGBE_PX_MISC_IEN_ETH_AN | \
+				TXGBE_PX_MISC_IEN_INT_ERR | \
+				TXGBE_PX_MISC_IEN_VF_MBOX | \
+				TXGBE_PX_MISC_IEN_GPIO | \
+				TXGBE_PX_MISC_IEN_MNG_HOST_MBOX | \
+				TXGBE_PX_MISC_IEN_STALL | \
+				TXGBE_PX_MISC_IEN_PCIE_REQ_ERR | \
+				TXGBE_PX_MISC_IEN_TIMER)
+
+/* General purpose Interrupt Enable */
+#define TXGBE_PX_GPIE_MODEL             0x00000001U
+#define TXGBE_PX_GPIE_IMEN              0x00000002U
+#define TXGBE_PX_GPIE_LL_INTERVAL       0x000000F0U
+#define TXGBE_PX_GPIE_RSC_DELAY         0x00000700U
+
+/* Interrupt Vector Allocation Registers */
+#define TXGBE_PX_IVAR_REG_NUM              64
+#define TXGBE_PX_IVAR_ALLOC_VAL            0x80 /* Interrupt Allocation valid */
+
+#define TXGBE_MAX_INT_RATE              500000
+#define TXGBE_MIN_INT_RATE              980
+#define TXGBE_MAX_EITR                  0x00000FF8U
+#define TXGBE_MIN_EITR                  8
+#define TXGBE_PX_ITR_ITR_INT_MASK       0x00000FF8U
+#define TXGBE_PX_ITR_LLI_CREDIT         0x001f0000U
+#define TXGBE_PX_ITR_LLI_MOD            0x00008000U
+#define TXGBE_PX_ITR_CNT_WDIS           0x80000000U
+#define TXGBE_PX_ITR_ITR_CNT            0x0FE00000U
+
 /* transmit DMA Registers */
 #define TXGBE_PX_TR_BAL(_i)     (0x03000 + ((_i) * 0x40))
 #define TXGBE_PX_TR_BAH(_i)     (0x03004 + ((_i) * 0x40))
@@ -680,6 +806,10 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_ISCSI_BOOT_CONFIG         0x07
 
 #define TXGBE_SERIAL_NUMBER_MAC_ADDR    0x11
+#define TXGBE_MAX_MSIX_VECTORS_SAPPHIRE 0x40
+
+/* MSI-X capability fields masks */
+#define TXGBE_PCIE_MSIX_TBL_SZ_MASK     0x7FF
 
 #define TXGBE_ETH_LENGTH_OF_ADDRESS     6
 
@@ -1058,6 +1188,7 @@ struct txgbe_mac_info {
 	u32 orig_sr_an_mmd_adv_reg2;
 	u32 orig_vr_xs_or_pcs_mmd_digi_ctl1;
 	u8  san_mac_rar_index;
+	u16 max_msix_vectors;
 	bool orig_link_settings_stored;
 	bool autotry_restart;
 	struct txgbe_thermal_sensor_data  thermal_sensor_data;
-- 
2.27.0

