Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBC65A5C85
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiH3HH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiH3HHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:07:20 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C596C6FF1
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:06:57 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843147t52l7dzg
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:47 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: mAIGYkUeGE0eJlVB4FuZZupbA7qGsX280rvKvqIWTo7Tvl8xx0V3f52qdluGi
        4Xg10w/qv5o178oG/rNiwk0wbk8H9ckScSkzaLU+0AFf6jokBSKZY/kpIpYkZtzRAuHdxQF
        0Bec7C/X1G5Ygp7dXXG+h4KzmIe4DUF0PkahcKu9RVEJkgGjTdZJyjNuKPcFLEgHrSPONdi
        RmvnyEaVi0hhmDcdbxO3hdgHcRzQHwdx7/3552BEWu7KvfvVWDg2JP4HMdOxZmN0wEGdRNO
        lwDAcZxy4ykyonLbaR2DI8r7bTo4FFGMuXqyW4KfnxpnxZI3CWN05plPISKXGIPCj6dqwI8
        NiCcCE3WooE9gJ5belZ3QsWSgqSHG+iQc2BK96aikz+1z6AKKx7ifrhKXglwmuPS1idRrCt
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 10/16] net: txgbe: Configure Rx and Tx unit of the MAC
Date:   Tue, 30 Aug 2022 15:04:48 +0800
Message-Id: <20220830070454.146211-11-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220830070454.146211-1-jiawenwu@trustnetic.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
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

Configure receive and transmit unit of the MAC, setup Rx and Tx ring.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  60 ++
 .../net/ethernet/wangxun/txgbe/txgbe_dummy.h  |  34 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 263 +++++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   9 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 586 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 117 +++-
 6 files changed, 1066 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 4f45c7becdb9..88fe4ce98033 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -10,15 +10,44 @@
 
 #include "txgbe_type.h"
 
+/* TX/RX descriptor defines */
+#define TXGBE_MAX_TXD                   8192
+#define TXGBE_MIN_TXD                   128
+
+#define TXGBE_MAX_RXD                   8192
+#define TXGBE_MIN_RXD                   128
+
+/* Supported Rx Buffer Sizes */
+#define TXGBE_RXBUFFER_256       256  /* Used for skb receive header */
+#define TXGBE_RXBUFFER_2K       2048
+#define TXGBE_RXBUFFER_3K       3072
+#define TXGBE_RXBUFFER_4K       4096
+#define TXGBE_MAX_RXBUFFER      16384  /* largest size for single descriptor */
+
+/* NOTE: netdev_alloc_skb reserves up to 64 bytes, NET_IP_ALIGN means we
+ * reserve 64 more, and skb_shared_info adds an additional 320 bytes more,
+ * this adds up to 448 bytes of extra data.
+ *
+ * Since netdev_alloc_skb now allocates a page fragment we can use a value
+ * of 256 and the resultant skb will have a truesize of 960 or less.
+ */
+#define TXGBE_RX_HDR_SIZE       TXGBE_RXBUFFER_256
+
 struct txgbe_ring {
 	struct txgbe_ring *next;        /* pointer to next ring in q_vector */
 	struct txgbe_q_vector *q_vector; /* backpointer to host q_vector */
 	struct net_device *netdev;      /* netdev ring belongs to */
 	struct device *dev;             /* device for DMA mapping */
+	u8 __iomem *tail;
+	dma_addr_t dma;                 /* phys. address of descriptor ring */
+
 	u16 count;                      /* amount of descriptors */
 
 	u8 queue_index; /* needed for multiqueue queue management */
 	u8 reg_idx;
+	u16 next_to_use;
+	u16 next_to_clean;
+	u16 next_to_alloc;
 } ____cacheline_internodealigned_in_smp;
 
 #define TXGBE_MAX_FDIR_INDICES          63
@@ -26,6 +55,17 @@ struct txgbe_ring {
 #define TXGBE_MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 #define TXGBE_MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 
+#define TXGBE_MAX_MACVLANS      32
+
+static inline unsigned int txgbe_rx_bufsz(struct txgbe_ring __maybe_unused *ring)
+{
+#if MAX_SKB_FRAGS < 8
+	return ALIGN(TXGBE_MAX_RXBUFFER / MAX_SKB_FRAGS, 1024);
+#else
+	return TXGBE_RXBUFFER_2K;
+#endif
+}
+
 struct txgbe_ring_container {
 	struct txgbe_ring *ring;        /* pointer to linked list of rings */
 	u16 work_limit;                 /* total work allowed per interrupt */
@@ -67,6 +107,8 @@ struct txgbe_q_vector {
 #define TXGBE_16K_ITR           248
 #define TXGBE_12K_ITR           336
 
+#define TXGBE_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
+
 #define TCP_TIMER_VECTOR        0
 #define OTHER_VECTOR    1
 #define NON_Q_VECTORS   (OTHER_VECTOR + TCP_TIMER_VECTOR)
@@ -172,6 +214,8 @@ struct txgbe_adapter {
 
 	struct txgbe_mac_addr *mac_table;
 
+	unsigned long fwd_bitmask; /* bitmask indicating in use pools */
+
 	/* misc interrupt status block */
 	dma_addr_t isb_dma;
 	u32 *isb_mem;
@@ -215,13 +259,27 @@ void txgbe_down(struct txgbe_adapter *adapter);
 void txgbe_reinit_locked(struct txgbe_adapter *adapter);
 void txgbe_reset(struct txgbe_adapter *adapter);
 void txgbe_disable_device(struct txgbe_adapter *adapter);
+void txgbe_configure_rx_ring(struct txgbe_adapter *adapter,
+			     struct txgbe_ring *ring);
+void txgbe_configure_tx_ring(struct txgbe_adapter *adapter,
+			     struct txgbe_ring *ring);
 int txgbe_init_interrupt_scheme(struct txgbe_adapter *adapter);
 void txgbe_reset_interrupt_capability(struct txgbe_adapter *adapter);
 void txgbe_set_interrupt_capability(struct txgbe_adapter *adapter);
 void txgbe_clear_interrupt_scheme(struct txgbe_adapter *adapter);
+void txgbe_configure_port(struct txgbe_adapter *adapter);
+void txgbe_set_rx_mode(struct net_device *netdev);
+int txgbe_write_mc_addr_list(struct net_device *netdev);
 void txgbe_write_eitr(struct txgbe_q_vector *q_vector);
+void txgbe_disable_rx_queue(struct txgbe_adapter *adapter,
+			    struct txgbe_ring *ring);
 
+int txgbe_write_uc_addr_list(struct net_device *netdev, int pool);
+int txgbe_add_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool);
 int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool);
+int txgbe_available_rars(struct txgbe_adapter *adapter);
+
+void txgbe_set_rx_drop_en(struct txgbe_adapter *adapter);
 
 /**
  * interrupt masking operations. each bit in PX_ICn correspond to a interrupt.
@@ -257,6 +315,8 @@ static inline void txgbe_intr_disable(struct txgbe_hw *hw, u64 qmask)
 		wr32(hw, TXGBE_PX_IMS(1), mask);
 }
 
+#define TXGBE_RING_SIZE(R) ((R)->count < TXGBE_MAX_TXD ? (R)->count / 128 : 0)
+
 extern char txgbe_driver_name[];
 
 __maybe_unused static struct device *txgbe_hw_to_dev(const struct txgbe_hw *hw)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
index 202e80d1b2ff..01438fc89b01 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
@@ -79,6 +79,18 @@ static int txgbe_reset_hw_dummy(struct txgbe_hw *TUP0)
 	return -EPERM;
 }
 
+static void txgbe_disable_sec_rx_path_dummy(struct txgbe_hw *TUP0)
+{
+}
+
+static void txgbe_enable_sec_rx_path_dummy(struct txgbe_hw *TUP0)
+{
+}
+
+static void txgbe_enable_rx_dma_dummy(struct txgbe_hw *TUP0, u32 TUP1)
+{
+}
+
 static void txgbe_start_hw_dummy(struct txgbe_hw *TUP0)
 {
 }
@@ -92,6 +104,11 @@ static void txgbe_get_wwn_prefix_dummy(struct txgbe_hw *TUP0,
 {
 }
 
+static void txgbe_set_rxpba_dummy(struct txgbe_hw *TUP0, int TUP1,
+				  u32 TUP2, int TUP3)
+{
+}
+
 static void txgbe_set_rar_dummy(struct txgbe_hw *TUP0, u32 TUP1,
 				u8 *TUP2, u64 TUP3, u32 TUP4)
 {
@@ -109,6 +126,15 @@ static void txgbe_clear_vmdq_dummy(struct txgbe_hw *TUP0, u32 TUP1, u32 TUP2)
 {
 }
 
+static void txgbe_update_mc_addr_list_dummy(struct txgbe_hw *TUP0, u8 *TUP1,
+					    u32 TUP2, txgbe_mc_addr_itr TUP3, bool TUP4)
+{
+}
+
+static void txgbe_enable_rx_dummy(struct txgbe_hw *TUP0)
+{
+}
+
 static void txgbe_disable_rx_dummy(struct txgbe_hw *TUP0)
 {
 }
@@ -215,15 +241,21 @@ static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
 	mac->ops.acquire_swfw_sync = txgbe_acquire_swfw_sync_dummy;
 	mac->ops.release_swfw_sync = txgbe_release_swfw_sync_dummy;
 	mac->ops.reset_hw = txgbe_reset_hw_dummy;
+	mac->ops.disable_sec_rx_path = txgbe_disable_sec_rx_path_dummy;
+	mac->ops.enable_sec_rx_path = txgbe_enable_sec_rx_path_dummy;
+	mac->ops.enable_rx_dma = txgbe_enable_rx_dma_dummy;
 	mac->ops.start_hw = txgbe_start_hw_dummy;
 	mac->ops.get_san_mac_addr = txgbe_get_san_mac_addr_dummy;
 	mac->ops.get_wwn_prefix = txgbe_get_wwn_prefix_dummy;
+	mac->ops.setup_rxpba = txgbe_set_rxpba_dummy;
 
-	/* RAR */
+	/* RAR, Multicast */
 	mac->ops.set_rar = txgbe_set_rar_dummy;
 	mac->ops.clear_rar = txgbe_clear_rar_dummy;
 	mac->ops.init_rx_addrs = txgbe_init_rx_addrs_dummy;
 	mac->ops.clear_vmdq = txgbe_clear_vmdq_dummy;
+	mac->ops.update_mc_addr_list = txgbe_update_mc_addr_list_dummy;
+	mac->ops.enable_rx = txgbe_enable_rx_dummy;
 	mac->ops.disable_rx = txgbe_disable_rx_dummy;
 	mac->ops.set_vmdq_san_mac = txgbe_set_vmdq_san_mac_dummy;
 	mac->ops.init_uta_tables = txgbe_init_uta_tables_dummy;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index cb952e49e61b..ab333659dea6 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -9,6 +9,8 @@
 #define TXGBE_SP_MAX_TX_QUEUES  128
 #define TXGBE_SP_MAX_RX_QUEUES  128
 #define TXGBE_SP_RAR_ENTRIES    128
+#define TXGBE_SP_MC_TBL_SIZE    128
+#define TXGBE_SP_RX_PB_SIZE     512
 
 static int txgbe_get_eeprom_semaphore(struct txgbe_hw *hw);
 static void txgbe_release_eeprom_semaphore(struct txgbe_hw *hw);
@@ -519,6 +521,125 @@ void txgbe_init_rx_addrs(struct txgbe_hw *hw)
 	hw->mac.ops.init_uta_tables(hw);
 }
 
+/**
+ *  txgbe_mta_vector - Determines bit-vector in multicast table to set
+ *  @hw: pointer to hardware structure
+ *  @mc_addr: the multicast address
+ *
+ *  Extracts the 12 bits, from a multicast address, to determine which
+ *  bit-vector to set in the multicast table. The hardware uses 12 bits, from
+ *  incoming rx multicast addresses, to determine the bit-vector to check in
+ *  the MTA. Which of the 4 combination, of 12-bits, the hardware uses is set
+ *  by the MO field of the MCSTCTRL. The MO field is set during initialization
+ *  to mc_filter_type.
+ **/
+static u32 txgbe_mta_vector(struct txgbe_hw *hw, u8 *mc_addr)
+{
+	u32 vector = 0;
+
+	switch (hw->mac.mc_filter_type) {
+	case 0:   /* use bits [47:36] of the address */
+		vector = ((mc_addr[4] >> 4) | (((u16)mc_addr[5]) << 4));
+		break;
+	case 1:   /* use bits [46:35] of the address */
+		vector = ((mc_addr[4] >> 3) | (((u16)mc_addr[5]) << 5));
+		break;
+	case 2:   /* use bits [45:34] of the address */
+		vector = ((mc_addr[4] >> 2) | (((u16)mc_addr[5]) << 6));
+		break;
+	case 3:   /* use bits [43:32] of the address */
+		vector = ((mc_addr[4]) | (((u16)mc_addr[5]) << 8));
+		break;
+	default:  /* Invalid mc_filter_type */
+		txgbe_info(hw, "MC filter type param set incorrectly\n");
+		break;
+	}
+
+	/* vector can only be 12-bits or boundary will be exceeded */
+	vector &= 0xFFF;
+	return vector;
+}
+
+/**
+ *  txgbe_set_mta - Set bit-vector in multicast table
+ *  @hw: pointer to hardware structure
+ *  @mc_addr: Multicast address
+ *
+ *  Sets the bit-vector in the multicast table.
+ **/
+static void txgbe_set_mta(struct txgbe_hw *hw, u8 *mc_addr)
+{
+	u32 vector, vector_bit, vector_reg;
+
+	hw->addr_ctrl.mta_in_use++;
+
+	vector = txgbe_mta_vector(hw, mc_addr);
+	txgbe_dbg(hw, " bit-vector = 0x%03X\n", vector);
+
+	/* The MTA is a register array of 128 32-bit registers. It is treated
+	 * like an array of 4096 bits.  We want to set bit
+	 * BitArray[vector_value]. So we figure out what register the bit is
+	 * in, read it, OR in the new bit, then write back the new value.  The
+	 * register is determined by the upper 7 bits of the vector value and
+	 * the bit within that register are determined by the lower 5 bits of
+	 * the value.
+	 */
+	vector_reg = (vector >> 5) & 0x7F;
+	vector_bit = vector & 0x1F;
+	hw->mac.mta_shadow[vector_reg] |= (1 << vector_bit);
+}
+
+/**
+ *  txgbe_update_mc_addr_list - Updates MAC list of multicast addresses
+ *  @hw: pointer to hardware structure
+ *  @mc_addr_list: the list of new multicast addresses
+ *  @mc_addr_count: number of addresses
+ *  @next: iterator function to walk the multicast address list
+ *  @clear: flag, when set clears the table beforehand
+ *
+ *  When the clear flag is set, the given list replaces any existing list.
+ *  Hashes the given addresses into the multicast table.
+ **/
+void txgbe_update_mc_addr_list(struct txgbe_hw *hw, u8 *mc_addr_list,
+			       u32 mc_addr_count, txgbe_mc_addr_itr next,
+			       bool clear)
+{
+	u32 i, vmdq, psrctl;
+
+	/* Set the new number of MC addresses that we are being requested to
+	 * use.
+	 */
+	hw->addr_ctrl.num_mc_addrs = mc_addr_count;
+	hw->addr_ctrl.mta_in_use = 0;
+
+	/* Clear mta_shadow */
+	if (clear) {
+		txgbe_dbg(hw, " Clearing MTA\n");
+		memset(&hw->mac.mta_shadow, 0, sizeof(hw->mac.mta_shadow));
+	}
+
+	/* Update mta_shadow */
+	for (i = 0; i < mc_addr_count; i++) {
+		txgbe_dbg(hw, " Adding the multicast addresses:\n");
+		txgbe_set_mta(hw, next(hw, &mc_addr_list, &vmdq));
+	}
+
+	/* Enable mta */
+	for (i = 0; i < hw->mac.mcft_size; i++)
+		wr32a(hw, TXGBE_PSR_MC_TBL(0), i,
+		      hw->mac.mta_shadow[i]);
+
+	if (hw->addr_ctrl.mta_in_use > 0) {
+		psrctl = rd32(hw, TXGBE_PSR_CTL);
+		psrctl &= ~(TXGBE_PSR_CTL_MO | TXGBE_PSR_CTL_MFE);
+		psrctl |= TXGBE_PSR_CTL_MFE |
+			(hw->mac.mc_filter_type << TXGBE_PSR_CTL_MO_SHIFT);
+		wr32(hw, TXGBE_PSR_CTL, psrctl);
+	}
+
+	txgbe_dbg(hw, "txgbe update mc addr list Complete\n");
+}
+
 /**
  *  txgbe_disable_pcie_master - Disable PCI-express master access
  *  @hw: pointer to hardware structure
@@ -617,6 +738,40 @@ void txgbe_release_swfw_sync(struct txgbe_hw *hw, u32 mask)
 	txgbe_release_eeprom_semaphore(hw);
 }
 
+/**
+ *  txgbe_disable_sec_rx_path - Stops the receive data path
+ *  @hw: pointer to hardware structure
+ *
+ *  Stops the receive data path and waits for the HW to internally empty
+ *  the Rx security block
+ **/
+void txgbe_disable_sec_rx_path(struct txgbe_hw *hw)
+{
+	int ret, secrxreg;
+
+	wr32m(hw, TXGBE_RSC_CTL,
+	      TXGBE_RSC_CTL_RX_DIS, TXGBE_RSC_CTL_RX_DIS);
+
+	ret = read_poll_timeout(rd32, secrxreg, secrxreg & TXGBE_RSC_ST_RSEC_RDY,
+				1000, 40000, false, hw, TXGBE_RSC_ST);
+
+	/* For informational purposes only */
+	if (ret == -ETIMEDOUT)
+		txgbe_dbg(hw, "Rx unit being enabled before security path fully disabled. Continuing with init.\n");
+}
+
+/**
+ *  txgbe_enable_sec_rx_path - Enables the receive data path
+ *  @hw: pointer to hardware structure
+ *
+ *  Enables the receive data path.
+ **/
+void txgbe_enable_sec_rx_path(struct txgbe_hw *hw)
+{
+	wr32m(hw, TXGBE_RSC_CTL, TXGBE_RSC_CTL_RX_DIS, 0);
+	TXGBE_WRITE_FLUSH(hw);
+}
+
 /**
  *  txgbe_get_san_mac_addr_offset - Get SAN MAC address offset from the EEPROM
  *  @hw: pointer to hardware structure
@@ -1094,6 +1249,65 @@ int txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr, u32 *data)
 	return ret;
 }
 
+/**
+ * txgbe_set_rxpba - Initialize Rx packet buffer
+ * @hw: pointer to hardware structure
+ * @num_pb: number of packet buffers to allocate
+ * @headroom: reserve n KB of headroom
+ * @strategy: packet buffer allocation strategy
+ **/
+void txgbe_set_rxpba(struct txgbe_hw *hw, int num_pb, u32 headroom,
+		     int strategy)
+{
+	u32 rxpktsize, txpktsize, txpbthresh;
+	u32 pbsize = hw->mac.rx_pb_size;
+	int i = 0;
+
+	/* Reserve headroom */
+	pbsize -= headroom;
+
+	if (!num_pb)
+		num_pb = 1;
+
+	/* Divide remaining packet buffer space amongst the number of packet
+	 * buffers requested using supplied strategy.
+	 */
+	switch (strategy) {
+	case PBA_STRATEGY_WEIGHTED:
+		/* txgbe_dcb_pba_80_48 strategy weight first half of packet
+		 * buffer with 5/8 of the packet buffer space.
+		 */
+		rxpktsize = (pbsize * 5) / (num_pb * 4);
+		pbsize -= rxpktsize * (num_pb / 2);
+		rxpktsize <<= TXGBE_RDB_PB_SZ_SHIFT;
+		for (; i < (num_pb / 2); i++)
+			wr32(hw, TXGBE_RDB_PB_SZ(i), rxpktsize);
+		fallthrough;
+	case PBA_STRATEGY_EQUAL:
+		rxpktsize = (pbsize / (num_pb - i)) << TXGBE_RDB_PB_SZ_SHIFT;
+		for (; i < num_pb; i++)
+			wr32(hw, TXGBE_RDB_PB_SZ(i), rxpktsize);
+		break;
+	default:
+		break;
+	}
+
+	/* Only support an equally distributed Tx packet buffer strategy. */
+	txpktsize = TXGBE_TDB_PB_SZ_MAX / num_pb;
+	txpbthresh = (txpktsize / 1024) - TXGBE_TXPKT_SIZE_MAX;
+	for (i = 0; i < num_pb; i++) {
+		wr32(hw, TXGBE_TDB_PB_SZ(i), txpktsize);
+		wr32(hw, TXGBE_TDM_PB_THRE(i), txpbthresh);
+	}
+
+	/* Clear unused TCs, if any, to zero buffer size*/
+	for (; i < TXGBE_MAX_PB; i++) {
+		wr32(hw, TXGBE_RDB_PB_SZ(i), 0);
+		wr32(hw, TXGBE_TDB_PB_SZ(i), 0);
+		wr32(hw, TXGBE_TDM_PB_THRE(i), 0);
+	}
+}
+
 /**
  *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
  *  @hw: pointer to hardware structure
@@ -1149,6 +1363,25 @@ void txgbe_disable_rx(struct txgbe_hw *hw)
 	}
 }
 
+void txgbe_enable_rx(struct txgbe_hw *hw)
+{
+	u32 pfdtxgswc;
+
+	/* enable mac receiver */
+	wr32m(hw, TXGBE_MAC_RX_CFG,
+	      TXGBE_MAC_RX_CFG_RE, TXGBE_MAC_RX_CFG_RE);
+
+	wr32m(hw, TXGBE_RDB_PB_CTL,
+	      TXGBE_RDB_PB_CTL_RXEN, TXGBE_RDB_PB_CTL_RXEN);
+
+	if (hw->mac.set_lben) {
+		pfdtxgswc = rd32(hw, TXGBE_PSR_CTL);
+		pfdtxgswc |= TXGBE_PSR_CTL_SW_EN;
+		wr32(hw, TXGBE_PSR_CTL, pfdtxgswc);
+		hw->mac.set_lben = false;
+	}
+}
+
 /**
  * txgbe_mng_present - returns true when management capability is present
  * @hw: pointer to hardware structure
@@ -1392,15 +1625,21 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.acquire_swfw_sync = txgbe_acquire_swfw_sync;
 	mac->ops.release_swfw_sync = txgbe_release_swfw_sync;
 	mac->ops.reset_hw = txgbe_reset_hw;
+	mac->ops.disable_sec_rx_path = txgbe_disable_sec_rx_path;
+	mac->ops.enable_sec_rx_path = txgbe_enable_sec_rx_path;
+	mac->ops.enable_rx_dma = txgbe_enable_rx_dma;
 	mac->ops.start_hw = txgbe_start_hw;
 	mac->ops.get_san_mac_addr = txgbe_get_san_mac_addr;
 	mac->ops.get_wwn_prefix = txgbe_get_wwn_prefix;
+	mac->ops.setup_rxpba = txgbe_set_rxpba;
 
-	/* RAR */
+	/* RAR, Multicast */
 	mac->ops.set_rar = txgbe_set_rar;
 	mac->ops.clear_rar = txgbe_clear_rar;
 	mac->ops.init_rx_addrs = txgbe_init_rx_addrs;
 	mac->ops.clear_vmdq = txgbe_clear_vmdq;
+	mac->ops.update_mc_addr_list = txgbe_update_mc_addr_list;
+	mac->ops.enable_rx = txgbe_enable_rx;
 	mac->ops.disable_rx = txgbe_disable_rx;
 	mac->ops.set_vmdq_san_mac = txgbe_set_vmdq_san_mac;
 	mac->ops.init_uta_tables = txgbe_init_uta_tables;
@@ -1408,7 +1647,10 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 	/* Link */
 	mac->ops.get_link_capabilities = txgbe_get_link_capabilities;
 	mac->ops.check_link = txgbe_check_mac_link;
+
+	mac->mcft_size          = TXGBE_SP_MC_TBL_SIZE;
 	mac->num_rar_entries    = TXGBE_SP_RAR_ENTRIES;
+	mac->rx_pb_size         = TXGBE_SP_RX_PB_SIZE;
 	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
 	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
 	mac->max_msix_vectors   = txgbe_get_pcie_msix_count(hw);
@@ -2725,6 +2967,25 @@ int txgbe_identify_phy(struct txgbe_hw *hw)
 	return status;
 }
 
+/**
+ *  txgbe_enable_rx_dma - Enable the Rx DMA unit on sapphire
+ *  @hw: pointer to hardware structure
+ *  @regval: register value to write to RXCTRL
+ *
+ *  Enables the Rx DMA unit for sapphire
+ **/
+void txgbe_enable_rx_dma(struct txgbe_hw *hw, u32 regval)
+{
+	hw->mac.ops.disable_sec_rx_path(hw);
+
+	if (regval & TXGBE_RDB_PB_CTL_RXEN)
+		hw->mac.ops.enable_rx(hw);
+	else
+		hw->mac.ops.disable_rx(hw);
+
+	hw->mac.ops.enable_sec_rx_path(hw);
+}
+
 /**
  *  txgbe_init_eeprom_params - Initialize EEPROM params
  *  @hw: pointer to hardware structure
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 5a03d6bc4b3c..c63c4f5a79ad 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -29,6 +29,11 @@ void txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
 		   u32 enable_addr);
 void txgbe_clear_rar(struct txgbe_hw *hw, u32 index);
 void txgbe_init_rx_addrs(struct txgbe_hw *hw);
+void txgbe_update_mc_addr_list(struct txgbe_hw *hw, u8 *mc_addr_list,
+			       u32 mc_addr_count,
+			       txgbe_mc_addr_itr func, bool clear);
+void txgbe_disable_sec_rx_path(struct txgbe_hw *hw);
+void txgbe_enable_sec_rx_path(struct txgbe_hw *hw);
 
 int txgbe_acquire_swfw_sync(struct txgbe_hw *hw, u32 mask);
 void txgbe_release_swfw_sync(struct txgbe_hw *hw, u32 mask);
@@ -43,6 +48,8 @@ void txgbe_init_uta_tables(struct txgbe_hw *hw);
 void txgbe_get_wwn_prefix(struct txgbe_hw *hw, u16 *wwnn_prefix,
 			  u16 *wwpn_prefix);
 
+void txgbe_set_rxpba(struct txgbe_hw *hw, int num_pb, u32 headroom,
+		     int strategy);
 int txgbe_set_fw_drv_ver(struct txgbe_hw *hw, u8 maj, u8 min,
 			 u8 build, u8 ver);
 int txgbe_reset_hostif(struct txgbe_hw *hw);
@@ -54,6 +61,7 @@ bool txgbe_mng_present(struct txgbe_hw *hw);
 bool txgbe_check_mng_access(struct txgbe_hw *hw);
 
 void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
+void txgbe_enable_rx(struct txgbe_hw *hw);
 void txgbe_disable_rx(struct txgbe_hw *hw);
 int txgbe_setup_mac_link_multispeed_fiber(struct txgbe_hw *hw,
 					  u32 speed,
@@ -76,6 +84,7 @@ void txgbe_reset_misc(struct txgbe_hw *hw);
 int txgbe_reset_hw(struct txgbe_hw *hw);
 int txgbe_identify_phy(struct txgbe_hw *hw);
 int txgbe_init_phy_ops(struct txgbe_hw *hw);
+void txgbe_enable_rx_dma(struct txgbe_hw *hw, u32 regval);
 void txgbe_init_ops(struct txgbe_hw *hw);
 
 void txgbe_init_eeprom_params(struct txgbe_hw *hw);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 9a589564e28a..0f2634ae3039 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -615,6 +615,367 @@ static void txgbe_configure_msi_and_legacy(struct txgbe_adapter *adapter)
 		   "Legacy interrupt IVAR setup done\n");
 }
 
+/**
+ * txgbe_configure_tx_ring - Configure Tx ring after Reset
+ * @adapter: board private structure
+ * @ring: structure containing ring specific data
+ *
+ * Configure the Tx descriptor ring after a reset.
+ **/
+void txgbe_configure_tx_ring(struct txgbe_adapter *adapter,
+			     struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 txdctl = TXGBE_PX_TR_CFG_ENABLE;
+	u8 reg_idx = ring->reg_idx;
+	u64 tdba = ring->dma;
+	int ret;
+
+	/* disable queue to avoid issues while updating state */
+	wr32(hw, TXGBE_PX_TR_CFG(reg_idx), TXGBE_PX_TR_CFG_SWFLSH);
+	TXGBE_WRITE_FLUSH(hw);
+
+	wr32(hw, TXGBE_PX_TR_BAL(reg_idx), tdba & DMA_BIT_MASK(32));
+	wr32(hw, TXGBE_PX_TR_BAH(reg_idx), tdba >> 32);
+
+	/* reset head and tail pointers */
+	wr32(hw, TXGBE_PX_TR_RP(reg_idx), 0);
+	wr32(hw, TXGBE_PX_TR_WP(reg_idx), 0);
+	ring->tail = adapter->io_addr + TXGBE_PX_TR_WP(reg_idx);
+
+	/* reset ntu and ntc to place SW in sync with hardwdare */
+	ring->next_to_clean = 0;
+	ring->next_to_use = 0;
+
+	txdctl |= TXGBE_RING_SIZE(ring) << TXGBE_PX_TR_CFG_TR_SIZE_SHIFT;
+
+	/* set WTHRESH to encourage burst writeback, it should not be set
+	 * higher than 1 when:
+	 * - ITR is 0 as it could cause false TX hangs
+	 * - ITR is set to > 100k int/sec and BQL is enabled
+	 *
+	 * In order to avoid issues WTHRESH + PTHRESH should always be equal
+	 * to or less than the number of on chip descriptors, which is
+	 * currently 40.
+	 */
+
+	txdctl |= 0x20 << TXGBE_PX_TR_CFG_WTHRESH_SHIFT;
+
+	/* enable queue */
+	wr32(hw, TXGBE_PX_TR_CFG(reg_idx), txdctl);
+
+	/* poll to verify queue is enabled */
+	ret = read_poll_timeout(rd32, txdctl, txdctl & TXGBE_PX_TR_CFG_ENABLE,
+				1000, 10000, true, hw, TXGBE_PX_TR_CFG(reg_idx));
+	if (ret == -ETIMEDOUT)
+		netif_err(adapter, drv, adapter->netdev,
+			  "Could not enable Tx Queue %d\n", reg_idx);
+}
+
+/**
+ * txgbe_configure_tx - Configure Transmit Unit after Reset
+ * @adapter: board private structure
+ *
+ * Configure the Tx unit of the MAC after a reset.
+ **/
+static void txgbe_configure_tx(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i;
+
+	/* TDM_CTL.TE must be before Tx queues are enabled */
+	wr32m(hw, TXGBE_TDM_CTL,
+	      TXGBE_TDM_CTL_TE, TXGBE_TDM_CTL_TE);
+
+	/* Setup the HW Tx Head and Tail descriptor pointers */
+	for (i = 0; i < adapter->num_tx_queues; i++)
+		txgbe_configure_tx_ring(adapter, adapter->tx_ring[i]);
+
+	wr32m(hw, TXGBE_TSC_BUF_AE, 0x3FF, 0x10);
+	/* enable mac transmitter */
+	wr32m(hw, TXGBE_MAC_TX_CFG,
+	      TXGBE_MAC_TX_CFG_TE, TXGBE_MAC_TX_CFG_TE);
+}
+
+static void txgbe_enable_rx_drop(struct txgbe_adapter *adapter,
+				 struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u16 reg_idx = ring->reg_idx;
+
+	u32 srrctl = rd32(hw, TXGBE_PX_RR_CFG(reg_idx));
+
+	srrctl |= TXGBE_PX_RR_CFG_DROP_EN;
+
+	wr32(hw, TXGBE_PX_RR_CFG(reg_idx), srrctl);
+}
+
+static void txgbe_disable_rx_drop(struct txgbe_adapter *adapter,
+				  struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u16 reg_idx = ring->reg_idx;
+
+	u32 srrctl = rd32(hw, TXGBE_PX_RR_CFG(reg_idx));
+
+	srrctl &= ~TXGBE_PX_RR_CFG_DROP_EN;
+
+	wr32(hw, TXGBE_PX_RR_CFG(reg_idx), srrctl);
+}
+
+void txgbe_set_rx_drop_en(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	/* We should set the drop enable bit if:
+	 *  Number of Rx queues > 1
+	 *
+	 *  This allows us to avoid head of line blocking for security
+	 *  and performance reasons.
+	 */
+	if (adapter->num_rx_queues > 1) {
+		for (i = 0; i < adapter->num_rx_queues; i++)
+			txgbe_enable_rx_drop(adapter, adapter->rx_ring[i]);
+	} else {
+		for (i = 0; i < adapter->num_rx_queues; i++)
+			txgbe_disable_rx_drop(adapter, adapter->rx_ring[i]);
+	}
+}
+
+static void txgbe_configure_srrctl(struct txgbe_adapter *adapter,
+				   struct txgbe_ring *rx_ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u16 reg_idx = rx_ring->reg_idx;
+	u32 srrctl;
+
+	srrctl = rd32m(hw, TXGBE_PX_RR_CFG(reg_idx),
+		       ~(TXGBE_PX_RR_CFG_RR_HDR_SZ |
+		       TXGBE_PX_RR_CFG_RR_BUF_SZ |
+		       TXGBE_PX_RR_CFG_SPLIT_MODE));
+	/* configure header buffer length, needed for RSC */
+	srrctl |= TXGBE_RX_HDR_SIZE << TXGBE_PX_RR_CFG_BSIZEHDRSIZE_SHIFT;
+
+	/* configure the packet buffer length */
+	srrctl |= txgbe_rx_bufsz(rx_ring) >> TXGBE_PX_RR_CFG_BSIZEPKT_SHIFT;
+
+	wr32(hw, TXGBE_PX_RR_CFG(reg_idx), srrctl);
+}
+
+static void txgbe_rx_desc_queue_enable(struct txgbe_adapter *adapter,
+				       struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u8 reg_idx = ring->reg_idx;
+	u32 rxdctl;
+	int ret;
+
+	ret = read_poll_timeout(rd32, rxdctl, rxdctl & TXGBE_PX_RR_CFG_RR_EN,
+				1000, 10000, true, hw, TXGBE_PX_RR_CFG(reg_idx));
+
+	if (ret == -ETIMEDOUT)
+		netif_err(adapter, drv, adapter->netdev,
+			  "RRCFG.EN on Rx queue %d not set within the polling period\n",
+			  reg_idx);
+}
+
+/* disable the specified rx ring/queue */
+void txgbe_disable_rx_queue(struct txgbe_adapter *adapter,
+			    struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u8 reg_idx = ring->reg_idx;
+	u32 rxdctl;
+	int ret;
+
+	/* write value back with RRCFG.EN bit cleared */
+	wr32m(hw, TXGBE_PX_RR_CFG(reg_idx),
+	      TXGBE_PX_RR_CFG_RR_EN, 0);
+
+	/* the hardware may take up to 100us to really disable the rx queue */
+	ret = read_poll_timeout(rd32, rxdctl, !(rxdctl & TXGBE_PX_RR_CFG_RR_EN),
+				10, 100, true, hw, TXGBE_PX_RR_CFG(reg_idx));
+
+	if (ret == -ETIMEDOUT) {
+		netif_err(adapter, drv, adapter->netdev,
+			  "RRCFG.EN on Rx queue %d not cleared within the polling period\n",
+			  reg_idx);
+	}
+}
+
+void txgbe_configure_rx_ring(struct txgbe_adapter *adapter,
+			     struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u16 reg_idx = ring->reg_idx;
+	u64 rdba = ring->dma;
+	u32 rxdctl;
+
+	/* disable queue to avoid issues while updating state */
+	rxdctl = rd32(hw, TXGBE_PX_RR_CFG(reg_idx));
+	txgbe_disable_rx_queue(adapter, ring);
+
+	wr32(hw, TXGBE_PX_RR_BAL(reg_idx), rdba & DMA_BIT_MASK(32));
+	wr32(hw, TXGBE_PX_RR_BAH(reg_idx), rdba >> 32);
+
+	if (ring->count == TXGBE_MAX_RXD)
+		rxdctl |= 0 << TXGBE_PX_RR_CFG_RR_SIZE_SHIFT;
+	else
+		rxdctl |= (ring->count / 128) << TXGBE_PX_RR_CFG_RR_SIZE_SHIFT;
+
+	rxdctl |= 0x1 << TXGBE_PX_RR_CFG_RR_THER_SHIFT;
+	wr32(hw, TXGBE_PX_RR_CFG(reg_idx), rxdctl);
+
+	/* reset head and tail pointers */
+	wr32(hw, TXGBE_PX_RR_RP(reg_idx), 0);
+	wr32(hw, TXGBE_PX_RR_WP(reg_idx), 0);
+	ring->tail = adapter->io_addr + TXGBE_PX_RR_WP(reg_idx);
+
+	/* reset ntu and ntc to place SW in sync with hardwdare */
+	ring->next_to_clean = 0;
+	ring->next_to_use = 0;
+	ring->next_to_alloc = 0;
+
+	txgbe_configure_srrctl(adapter, ring);
+
+	/* enable receive descriptor ring */
+	wr32m(hw, TXGBE_PX_RR_CFG(reg_idx),
+	      TXGBE_PX_RR_CFG_RR_EN, TXGBE_PX_RR_CFG_RR_EN);
+
+	txgbe_rx_desc_queue_enable(adapter, ring);
+}
+
+static void txgbe_setup_psrtype(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int pool;
+
+	/* PSRTYPE must be initialized in adapters */
+	u32 psrtype = TXGBE_RDB_PL_CFG_L4HDR |
+		      TXGBE_RDB_PL_CFG_L3HDR |
+		      TXGBE_RDB_PL_CFG_L2HDR |
+		      TXGBE_RDB_PL_CFG_TUN_OUTER_L2HDR |
+		      TXGBE_RDB_PL_CFG_TUN_TUNHDR;
+
+	for_each_set_bit(pool, &adapter->fwd_bitmask, TXGBE_MAX_MACVLANS)
+		wr32(hw, TXGBE_RDB_PL_CFG(pool), psrtype);
+}
+
+static void txgbe_set_rx_buffer_len(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 mhadd, max_frame;
+
+	max_frame = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
+	/* adjust max frame to be at least the size of a standard frame */
+	if (max_frame < (ETH_FRAME_LEN + ETH_FCS_LEN))
+		max_frame = (ETH_FRAME_LEN + ETH_FCS_LEN);
+
+	mhadd = rd32(hw, TXGBE_PSR_MAX_SZ);
+	if (max_frame != mhadd)
+		wr32(hw, TXGBE_PSR_MAX_SZ, max_frame);
+}
+
+/**
+ * txgbe_configure_rx - Configure Receive Unit after Reset
+ * @adapter: board private structure
+ *
+ * Configure the Rx unit of the MAC after a reset.
+ **/
+static void txgbe_configure_rx(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 rxctrl, psrctl;
+	int i;
+
+	/* disable receives while setting up the descriptors */
+	hw->mac.ops.disable_rx(hw);
+
+	txgbe_setup_psrtype(adapter);
+
+	/* enable hw crc stripping */
+	wr32m(hw, TXGBE_RSC_CTL,
+	      TXGBE_RSC_CTL_CRC_STRIP, TXGBE_RSC_CTL_CRC_STRIP);
+
+	/* RSC Setup */
+	psrctl = rd32m(hw, TXGBE_PSR_CTL, ~TXGBE_PSR_CTL_RSC_DIS);
+	psrctl |= TXGBE_PSR_CTL_RSC_ACK; /* Disable RSC for ACK packets */
+	psrctl |= TXGBE_PSR_CTL_RSC_DIS;
+	wr32(hw, TXGBE_PSR_CTL, psrctl);
+
+	/* set_rx_buffer_len must be called before ring initialization */
+	txgbe_set_rx_buffer_len(adapter);
+
+	/* Setup the HW Rx Head and Tail Descriptor Pointers and
+	 * the Base and Length of the Rx Descriptor Ring
+	 */
+	for (i = 0; i < adapter->num_rx_queues; i++)
+		txgbe_configure_rx_ring(adapter, adapter->rx_ring[i]);
+
+	rxctrl = rd32(hw, TXGBE_RDB_PB_CTL);
+
+	/* enable all receives */
+	rxctrl |= TXGBE_RDB_PB_CTL_RXEN;
+	hw->mac.ops.enable_rx_dma(hw, rxctrl);
+}
+
+static u8 *txgbe_addr_list_itr(struct txgbe_hw __maybe_unused *hw,
+			       u8 **mc_addr_ptr, u32 *vmdq)
+{
+	struct netdev_hw_addr *mc_ptr;
+	u8 *addr = *mc_addr_ptr;
+
+	*vmdq = 0;
+
+	mc_ptr = container_of(addr, struct netdev_hw_addr, addr[0]);
+	if (mc_ptr->list.next) {
+		struct netdev_hw_addr *ha;
+
+		ha = list_entry(mc_ptr->list.next, struct netdev_hw_addr, list);
+		*mc_addr_ptr = ha->addr;
+	} else {
+		*mc_addr_ptr = NULL;
+	}
+
+	return addr;
+}
+
+/**
+ * txgbe_write_mc_addr_list - write multicast addresses to MTA
+ * @netdev: network interface device structure
+ *
+ * Writes multicast address list to the MTA hash table.
+ * Returns: 0 on no addresses written
+ *          X on writing X addresses to MTA
+ **/
+int txgbe_write_mc_addr_list(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	struct netdev_hw_addr *ha;
+	u8  *addr_list = NULL;
+	int addr_count = 0;
+
+	if (!netif_running(netdev))
+		return 0;
+
+	if (netdev_mc_empty(netdev)) {
+		hw->mac.ops.update_mc_addr_list(hw, NULL, 0,
+						txgbe_addr_list_itr, true);
+	} else {
+		ha = list_first_entry(&netdev->mc.list,
+				      struct netdev_hw_addr, list);
+		addr_list = ha->addr;
+		addr_count = netdev_mc_count(netdev);
+
+		hw->mac.ops.update_mc_addr_list(hw, addr_list, addr_count,
+						txgbe_addr_list_itr, true);
+	}
+
+	return addr_count;
+}
+
 static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
@@ -636,6 +997,18 @@ static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
 	}
 }
 
+int txgbe_available_rars(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i, count = 0;
+
+	for (i = 0; i < hw->mac.num_rar_entries; i++) {
+		if (adapter->mac_table[i].state == 0)
+			count++;
+	}
+	return count;
+}
+
 /* this function destroys the first RAR entry */
 static void txgbe_mac_set_default_filter(struct txgbe_adapter *adapter,
 					 u8 *addr)
@@ -651,6 +1024,38 @@ static void txgbe_mac_set_default_filter(struct txgbe_adapter *adapter,
 			    TXGBE_PSR_MAC_SWC_AD_H_AV);
 }
 
+int txgbe_add_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i;
+
+	if (is_zero_ether_addr(addr))
+		return -EINVAL;
+
+	for (i = 0; i < hw->mac.num_rar_entries; i++) {
+		if (adapter->mac_table[i].state & TXGBE_MAC_STATE_IN_USE) {
+			if (ether_addr_equal(addr, adapter->mac_table[i].addr)) {
+				if (adapter->mac_table[i].pools != (1ULL << pool)) {
+					memcpy(adapter->mac_table[i].addr, addr, ETH_ALEN);
+					adapter->mac_table[i].pools |= (1ULL << pool);
+					txgbe_sync_mac_table(adapter);
+					return i;
+				}
+			}
+		}
+
+		if (adapter->mac_table[i].state & TXGBE_MAC_STATE_IN_USE)
+			continue;
+		adapter->mac_table[i].state |= (TXGBE_MAC_STATE_MODIFIED |
+						TXGBE_MAC_STATE_IN_USE);
+		memcpy(adapter->mac_table[i].addr, addr, ETH_ALEN);
+		adapter->mac_table[i].pools |= (1ULL << pool);
+		txgbe_sync_mac_table(adapter);
+		return i;
+	}
+	return -ENOMEM;
+}
+
 static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
@@ -700,6 +1105,130 @@ int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool)
 	return -ENOMEM;
 }
 
+/**
+ * txgbe_write_uc_addr_list - write unicast addresses to RAR table
+ * @netdev: network interface device structure
+ * @pool: index for mac table
+ *
+ * Writes unicast address list to the RAR table.
+ * Returns: -ENOMEM on failure/insufficient address space
+ *                0 on no addresses written
+ *                X on writing X addresses to the RAR table
+ **/
+int txgbe_write_uc_addr_list(struct net_device *netdev, int pool)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	int count = 0;
+
+	/* return ENOMEM indicating insufficient memory for addresses */
+	if (netdev_uc_count(netdev) > txgbe_available_rars(adapter))
+		return -ENOMEM;
+
+	if (!netdev_uc_empty(netdev)) {
+		struct netdev_hw_addr *ha;
+
+		netdev_for_each_uc_addr(ha, netdev) {
+			txgbe_del_mac_filter(adapter, ha->addr, pool);
+			txgbe_add_mac_filter(adapter, ha->addr, pool);
+			count++;
+		}
+	}
+	return count;
+}
+
+/**
+ * txgbe_set_rx_mode - Unicast, Multicast and Promiscuous mode set
+ * @netdev: network interface device structure
+ *
+ * The set_rx_method entry point is called whenever the unicast/multicast
+ * address list or the network interface flags are updated.  This routine is
+ * responsible for configuring the hardware for proper unicast, multicast and
+ * promiscuous mode.
+ **/
+void txgbe_set_rx_mode(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 fctrl, vmolr, vlnctrl;
+	int count;
+
+	/* Check for Promiscuous and All Multicast modes */
+	fctrl = rd32m(hw, TXGBE_PSR_CTL,
+		      ~(TXGBE_PSR_CTL_UPE | TXGBE_PSR_CTL_MPE));
+	vmolr = rd32m(hw, TXGBE_PSR_VM_L2CTL(0),
+		      ~(TXGBE_PSR_VM_L2CTL_UPE |
+			TXGBE_PSR_VM_L2CTL_MPE |
+			TXGBE_PSR_VM_L2CTL_ROPE |
+			TXGBE_PSR_VM_L2CTL_ROMPE));
+	vlnctrl = rd32m(hw, TXGBE_PSR_VLAN_CTL,
+			~(TXGBE_PSR_VLAN_CTL_VFE |
+			  TXGBE_PSR_VLAN_CTL_CFIEN));
+
+	/* set all bits that we expect to always be set */
+	fctrl |= TXGBE_PSR_CTL_BAM | TXGBE_PSR_CTL_MFE;
+	vmolr |= TXGBE_PSR_VM_L2CTL_BAM |
+		 TXGBE_PSR_VM_L2CTL_AUPE |
+		 TXGBE_PSR_VM_L2CTL_VACC;
+	vlnctrl |= TXGBE_PSR_VLAN_CTL_VFE;
+
+	hw->addr_ctrl.user_set_promisc = false;
+	if (netdev->flags & IFF_PROMISC) {
+		hw->addr_ctrl.user_set_promisc = true;
+		fctrl |= (TXGBE_PSR_CTL_UPE | TXGBE_PSR_CTL_MPE);
+		/* pf don't want packets routing to vf, so clear UPE */
+		vmolr |= TXGBE_PSR_VM_L2CTL_MPE;
+		vlnctrl &= ~TXGBE_PSR_VLAN_CTL_VFE;
+	}
+
+	if (netdev->flags & IFF_ALLMULTI) {
+		fctrl |= TXGBE_PSR_CTL_MPE;
+		vmolr |= TXGBE_PSR_VM_L2CTL_MPE;
+	}
+
+	/* This is useful for sniffing bad packets. */
+	if (netdev->features & NETIF_F_RXALL) {
+		vmolr |= (TXGBE_PSR_VM_L2CTL_UPE | TXGBE_PSR_VM_L2CTL_MPE);
+		vlnctrl &= ~TXGBE_PSR_VLAN_CTL_VFE;
+		/* receive bad packets */
+		wr32m(hw, TXGBE_RSC_CTL,
+		      TXGBE_RSC_CTL_SAVE_MAC_ERR,
+		      TXGBE_RSC_CTL_SAVE_MAC_ERR);
+	} else {
+		vmolr |= TXGBE_PSR_VM_L2CTL_ROPE | TXGBE_PSR_VM_L2CTL_ROMPE;
+	}
+
+	/* Write addresses to available RAR registers, if there is not
+	 * sufficient space to store all the addresses then enable
+	 * unicast promiscuous mode
+	 */
+	count = txgbe_write_uc_addr_list(netdev, 0);
+	if (count < 0) {
+		vmolr &= ~TXGBE_PSR_VM_L2CTL_ROPE;
+		vmolr |= TXGBE_PSR_VM_L2CTL_UPE;
+	}
+
+	/* Write addresses to the MTA, if the attempt fails
+	 * then we should just turn on promiscuous mode so
+	 * that we can at least receive multicast traffic
+	 */
+	count = txgbe_write_mc_addr_list(netdev);
+	if (count < 0) {
+		vmolr &= ~TXGBE_PSR_VM_L2CTL_ROMPE;
+		vmolr |= TXGBE_PSR_VM_L2CTL_MPE;
+	}
+
+	wr32(hw, TXGBE_PSR_VLAN_CTL, vlnctrl);
+	wr32(hw, TXGBE_PSR_CTL, fctrl);
+	wr32(hw, TXGBE_PSR_VM_L2CTL(0), vmolr);
+}
+
+static void txgbe_configure_pb(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+
+	hw->mac.ops.setup_rxpba(hw, 0, 0, PBA_STRATEGY_EQUAL);
+}
+
 static void txgbe_configure_isb(struct txgbe_adapter *adapter)
 {
 	/* set ISB Address */
@@ -710,8 +1239,44 @@ static void txgbe_configure_isb(struct txgbe_adapter *adapter)
 	wr32(hw, TXGBE_PX_ISB_ADDR_H, adapter->isb_dma >> 32);
 }
 
+void txgbe_configure_port(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 value, i;
+
+	value = TXGBE_CFG_PORT_CTL_D_VLAN | TXGBE_CFG_PORT_CTL_QINQ;
+	wr32m(hw, TXGBE_CFG_PORT_CTL,
+	      TXGBE_CFG_PORT_CTL_D_VLAN |
+	      TXGBE_CFG_PORT_CTL_QINQ,
+	      value);
+
+	wr32(hw, TXGBE_CFG_TAG_TPID(0),
+	     ETH_P_8021Q | ETH_P_8021AD << 16);
+	adapter->hw.tpid[0] = ETH_P_8021Q;
+	adapter->hw.tpid[1] = ETH_P_8021AD;
+	for (i = 1; i < 4; i++)
+		wr32(hw, TXGBE_CFG_TAG_TPID(i),
+		     ETH_P_8021Q | ETH_P_8021Q << 16);
+	for (i = 2; i < 8; i++)
+		adapter->hw.tpid[i] = ETH_P_8021Q;
+}
+
 static void txgbe_configure(struct txgbe_adapter *adapter)
 {
+	struct txgbe_hw *hw = &adapter->hw;
+
+	txgbe_configure_pb(adapter);
+
+	txgbe_configure_port(adapter);
+
+	txgbe_set_rx_mode(adapter->netdev);
+
+	hw->mac.ops.disable_sec_rx_path(hw);
+
+	hw->mac.ops.enable_sec_rx_path(hw);
+
+	txgbe_configure_tx(adapter);
+	txgbe_configure_rx(adapter);
 	txgbe_configure_isb(adapter);
 }
 
@@ -889,6 +1454,11 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 	/* disable receives */
 	hw->mac.ops.disable_rx(hw);
 
+	/* disable all enabled rx queues */
+	for (i = 0; i < adapter->num_rx_queues; i++)
+		/* this call also flushes the previous write */
+		txgbe_disable_rx_queue(adapter, adapter->rx_ring[i]);
+
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
@@ -987,6 +1557,7 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 
 	adapter->max_q_vectors = TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE;
 
+	set_bit(0, &adapter->fwd_bitmask);
 	set_bit(__TXGBE_DOWN, &adapter->state);
 
 	return 0;
@@ -1185,6 +1756,8 @@ static void txgbe_watchdog_update_link(struct txgbe_adapter *adapter)
 	adapter->link_speed = link_speed;
 
 	if (link_up) {
+		txgbe_set_rx_drop_en(adapter);
+
 		if (link_speed & TXGBE_LINK_SPEED_10GB_FULL) {
 			wr32(hw, TXGBE_MAC_TX_CFG,
 			     (rd32(hw, TXGBE_MAC_TX_CFG) &
@@ -1584,6 +2157,7 @@ static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_open               = txgbe_open,
 	.ndo_stop               = txgbe_close,
 	.ndo_start_xmit         = txgbe_xmit_frame,
+	.ndo_set_rx_mode        = txgbe_set_rx_mode,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = txgbe_set_mac,
 };
@@ -1703,8 +2277,20 @@ static int txgbe_probe(struct pci_dev *pdev,
 		}
 	}
 
+	netdev->features = NETIF_F_SG;
+
+	/* copy netdev features into list of user selectable features */
+	netdev->hw_features |= netdev->features |
+			       NETIF_F_RXALL;
+
 	netdev->features |= NETIF_F_HIGHDMA;
 
+	netdev->priv_flags |= IFF_UNICAST_FLT;
+	netdev->priv_flags |= IFF_SUPP_NOFCS;
+
+	netdev->min_mtu = ETH_MIN_MTU;
+	netdev->max_mtu = TXGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
+
 	/* make sure the EEPROM is good */
 	err = hw->eeprom.ops.validate_checksum(hw, NULL);
 	if (err != 0) {
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index ee3c8d6e39b3..7ac0cba9fdee 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -448,6 +448,7 @@ struct txgbe_thermal_sensor_data {
 /*********************** Transmit DMA registers **************************/
 /* transmit global control */
 #define TXGBE_TDM_CTL           0x18000
+#define TXGBE_TDM_PB_THRE(_i)   (0x18020 + ((_i) * 4)) /* 8 of these 0 - 7 */
 /* TDM CTL BIT */
 #define TXGBE_TDM_CTL_TE        0x1 /* Transmit Enable */
 #define TXGBE_TDM_CTL_PADDING   0x2 /* Padding byte number for ipsec ESP */
@@ -470,6 +471,9 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_RDB_UP2TC             0x19008
 #define TXGBE_RDB_PB_SZ_SHIFT       10
 #define TXGBE_RDB_PB_SZ_MASK        0x000FFC00U
+
+/* ring assignment */
+#define TXGBE_RDB_PL_CFG(_i)    (0x19300 + ((_i) * 4))
 /* statistic */
 #define TXGBE_RDB_MPCNT(_i)         (0x19040 + ((_i) * 4)) /* 8 of 3FA0-3FBC*/
 #define TXGBE_RDB_LXONTXC           0x1921C
@@ -481,6 +485,23 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_RDB_PFCMACDAH         0x19214
 #define TXGBE_RDB_TXSWERR           0x1906C
 #define TXGBE_RDB_TXSWERR_TB_FREE   0x3FF
+/* rdb_pl_cfg reg mask */
+#define TXGBE_RDB_PL_CFG_L4HDR          0x2
+#define TXGBE_RDB_PL_CFG_L3HDR          0x4
+#define TXGBE_RDB_PL_CFG_L2HDR          0x8
+#define TXGBE_RDB_PL_CFG_TUN_OUTER_L2HDR 0x20
+#define TXGBE_RDB_PL_CFG_TUN_TUNHDR     0x10
+#define TXGBE_RDB_PL_CFG_RSS_PL_MASK    0x7
+#define TXGBE_RDB_PL_CFG_RSS_PL_SHIFT   29
+
+/* Packet buffer allocation strategies */
+enum {
+	PBA_STRATEGY_EQUAL      = 0, /* Distribute PB space equally */
+#define PBA_STRATEGY_EQUAL      PBA_STRATEGY_EQUAL
+	PBA_STRATEGY_WEIGHTED   = 1, /* Weight front half of TCs */
+#define PBA_STRATEGY_WEIGHTED   PBA_STRATEGY_WEIGHTED
+};
+
 /* Receive Config masks */
 #define TXGBE_RDB_PB_CTL_RXEN           (0x80000000) /* Enable Receiver */
 #define TXGBE_RDB_PB_CTL_DISABLED       0x1
@@ -503,6 +524,32 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_PSR_CTL_MO                0x00000060U
 #define TXGBE_PSR_CTL_TPE               0x00000010U
 #define TXGBE_PSR_CTL_MO_SHIFT          5
+/* VT_CTL bitmasks */
+#define TXGBE_PSR_VM_CTL_DIS_DEFPL      0x20000000U /* disable default pool */
+#define TXGBE_PSR_VM_CTL_REPLEN         0x40000000U /* replication enabled */
+#define TXGBE_PSR_VM_CTL_POOL_SHIFT     7
+#define TXGBE_PSR_VM_CTL_POOL_MASK      (0x3F << TXGBE_PSR_VM_CTL_POOL_SHIFT)
+/* VLAN Control Bit Masks */
+#define TXGBE_PSR_VLAN_CTL_VET          0x0000FFFFU  /* bits 0-15 */
+#define TXGBE_PSR_VLAN_CTL_CFI          0x10000000U  /* bit 28 */
+#define TXGBE_PSR_VLAN_CTL_CFIEN        0x20000000U  /* bit 29 */
+#define TXGBE_PSR_VLAN_CTL_VFE          0x40000000U  /* bit 30 */
+
+/* vm L2 contorl */
+#define TXGBE_PSR_VM_L2CTL(_i)          (0x15600 + ((_i) * 4))
+/* VMOLR bitmasks */
+#define TXGBE_PSR_VM_L2CTL_LBDIS        0x00000002U /* disable loopback */
+#define TXGBE_PSR_VM_L2CTL_LLB          0x00000004U /* local pool loopback */
+#define TXGBE_PSR_VM_L2CTL_UPE          0x00000010U /* unicast promiscuous */
+#define TXGBE_PSR_VM_L2CTL_TPE          0x00000020U /* ETAG promiscuous */
+#define TXGBE_PSR_VM_L2CTL_VACC         0x00000040U /* accept nomatched vlan */
+#define TXGBE_PSR_VM_L2CTL_VPE          0x00000080U /* vlan promiscuous mode */
+#define TXGBE_PSR_VM_L2CTL_AUPE         0x00000100U /* accept untagged packets */
+#define TXGBE_PSR_VM_L2CTL_ROMPE        0x00000200U /*accept packets in MTA tbl*/
+#define TXGBE_PSR_VM_L2CTL_ROPE         0x00000400U /* accept packets in UC tbl*/
+#define TXGBE_PSR_VM_L2CTL_BAM          0x00000800U /* accept broadcast packets*/
+#define TXGBE_PSR_VM_L2CTL_MPE          0x00001000U /* multicast promiscuous */
+
 /* mcasst/ucast overflow tbl */
 #define TXGBE_PSR_MC_TBL(_i)    (0x15200  + ((_i) * 4))
 #define TXGBE_PSR_UC_TBL(_i)    (0x15400 + ((_i) * 4))
@@ -537,6 +584,55 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_PSR_LAN_FLEX_DW_H(_i)     (0x15C04 + ((_i) * 16))
 #define TXGBE_PSR_LAN_FLEX_MSK(_i)      (0x15C08 + ((_i) * 16))
 #define TXGBE_PSR_LAN_FLEX_CTL  0x15CFC
+
+#define TXGBE_PSR_MAX_SZ                0x15020
+
+/****************************** TDB ******************************************/
+#define TXGBE_TDB_RFCS                  0x1CE00
+#define TXGBE_TDB_PB_SZ(_i)             (0x1CC00 + ((_i) * 4)) /* 8 of these */
+#define TXGBE_TDB_MNG_TC                0x1CD10
+#define TXGBE_TDB_PRB_CTL               0x17010
+#define TXGBE_TDB_PBRARB_CTL            0x1CD00
+#define TXGBE_TDB_UP2TC                 0x1C800
+#define TXGBE_TDB_PBRARB_CFG(_i)        (0x1CD20 + ((_i) * 4)) /* 8 of (0-7) */
+
+#define TXGBE_TDB_PB_SZ_20KB    0x00005000U /* 20KB Packet Buffer */
+#define TXGBE_TDB_PB_SZ_40KB    0x0000A000U /* 40KB Packet Buffer */
+#define TXGBE_TDB_PB_SZ_MAX     0x00028000U /* 160KB Packet Buffer */
+#define TXGBE_TXPKT_SIZE_MAX    0xA /* Max Tx Packet size */
+#define TXGBE_MAX_PB            8
+
+/****************************** TSEC *****************************************/
+/* Security Control Registers */
+#define TXGBE_TSC_CTL                   0x1D000
+#define TXGBE_TSC_ST                    0x1D004
+#define TXGBE_TSC_BUF_AF                0x1D008
+#define TXGBE_TSC_BUF_AE                0x1D00C
+#define TXGBE_TSC_PRB_CTL               0x1D010
+#define TXGBE_TSC_MIN_IFG               0x1D020
+/* Security Bit Fields and Masks */
+#define TXGBE_TSC_CTL_SECTX_DIS         0x00000001U
+#define TXGBE_TSC_CTL_TX_DIS            0x00000002U
+#define TXGBE_TSC_CTL_STORE_FORWARD     0x00000004U
+#define TXGBE_TSC_CTL_IV_MSK_EN         0x00000008U
+#define TXGBE_TSC_ST_SECTX_RDY          0x00000001U
+#define TXGBE_TSC_ST_OFF_DIS            0x00000002U
+#define TXGBE_TSC_ST_ECC_TXERR          0x00000004U
+
+/********************************* RSEC **************************************/
+/* general rsec */
+#define TXGBE_RSC_CTL                   0x17000
+#define TXGBE_RSC_ST                    0x17004
+/* general rsec fields */
+#define TXGBE_RSC_CTL_SECRX_DIS         0x00000001U
+#define TXGBE_RSC_CTL_RX_DIS            0x00000002U
+#define TXGBE_RSC_CTL_CRC_STRIP         0x00000004U
+#define TXGBE_RSC_CTL_IV_MSK_EN         0x00000008U
+#define TXGBE_RSC_CTL_SAVE_MAC_ERR      0x00000040U
+#define TXGBE_RSC_ST_RSEC_RDY           0x00000001U
+#define TXGBE_RSC_ST_RSEC_OFLD_DIS      0x00000002U
+#define TXGBE_RSC_ST_ECC_RXERR          0x00000004U
+
 /************************************** ETH PHY ******************************/
 #define TXGBE_XPCS_IDA_ADDR    0x13000
 #define TXGBE_XPCS_IDA_DATA    0x13004
@@ -1012,6 +1108,10 @@ struct txgbe_bus_info {
 /* forward declaration */
 struct txgbe_hw;
 
+/* iterator type for walking multicast address lists */
+typedef u8* (*txgbe_mc_addr_itr) (struct txgbe_hw *hw, u8 **mc_addr_ptr,
+				  u32 *vmdq);
+
 /* Function pointer table */
 struct txgbe_eeprom_operations {
 	void (*init_params)(struct txgbe_hw *hw);
@@ -1032,6 +1132,9 @@ struct txgbe_mac_operations {
 			       u16 *wwpn_prefix);
 	int (*stop_adapter)(struct txgbe_hw *hw);
 	void (*set_lan_id)(struct txgbe_hw *hw);
+	void (*enable_rx_dma)(struct txgbe_hw *hw, u32 regval);
+	void (*disable_sec_rx_path)(struct txgbe_hw *hw);
+	void (*enable_sec_rx_path)(struct txgbe_hw *hw);
 	int (*acquire_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 	void (*release_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 
@@ -1049,14 +1152,22 @@ struct txgbe_mac_operations {
 				     bool *autoneg);
 	void (*set_rate_select_speed)(struct txgbe_hw *hw, u32 speed);
 
-	/* RAR */
+	/* Packet Buffer manipulation */
+	void (*setup_rxpba)(struct txgbe_hw *hw, int num_pb, u32 headroom,
+			    int strategy);
+
+	/* RAR, Multicast */
 	void (*set_rar)(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
 			u32 enable_addr);
 	void (*clear_rar)(struct txgbe_hw *hw, u32 index);
 	void (*disable_rx)(struct txgbe_hw *hw);
+	void (*enable_rx)(struct txgbe_hw *hw);
 	void (*set_vmdq_san_mac)(struct txgbe_hw *hw, u32 vmdq);
 	void (*clear_vmdq)(struct txgbe_hw *hw, u32 rar, u32 vmdq);
 	void (*init_rx_addrs)(struct txgbe_hw *hw);
+	void (*update_mc_addr_list)(struct txgbe_hw *hw, u8 *mc_addr_list,
+				    u32 mc_addr_count,
+				    txgbe_mc_addr_itr func, bool clear);
 	void (*init_uta_tables)(struct txgbe_hw *hw);
 
 	/* Manageability interface */
@@ -1092,9 +1203,12 @@ struct txgbe_mac_info {
 	u16 wwnn_prefix;
 	/* prefix for World Wide Port Name (WWPN) */
 	u16 wwpn_prefix;
+#define TXGBE_MAX_MTA                   128
+	u32 mta_shadow[TXGBE_MAX_MTA];
 	s32 mc_filter_type;
 	u32 mcft_size;
 	u32 num_rar_entries;
+	u32 rx_pb_size;
 	u32 max_tx_queues;
 	u32 max_rx_queues;
 	u32 orig_sr_pcs_ctl2;
@@ -1149,6 +1263,7 @@ struct txgbe_hw {
 	enum txgbe_reset_type reset_type;
 	bool force_full_reset;
 	enum txgbe_link_status link_status;
+	u16 tpid[8];
 	u16 oem_ssid;
 	u16 oem_svid;
 };
-- 
2.27.0

