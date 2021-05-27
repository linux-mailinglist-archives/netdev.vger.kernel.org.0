Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BE639313D
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbhE0OqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbhE0OqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 10:46:07 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0230FC061761;
        Thu, 27 May 2021 07:44:33 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lmHFM-0002jz-AV; Thu, 27 May 2021 17:44:28 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next v4 4/4] atl1c: add 4 RX/TX queue support for Mikrotik 10/25G NIC
Date:   Thu, 27 May 2021 17:44:23 +0300
Message-Id: <20210527144423.3395719-5-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527144423.3395719-1-gatis@mikrotik.com>
References: <20210527144423.3395719-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More RX/TX queues on a network card help spread the CPU load among
cores and achieve higher overall networking performance. The new
Mikrotik 10/25G NIC supports 4 RX and 4 TX queues. TX queues are
treated with equal priority. RX queue balancing is fixed based on
L2/L3/L4 hash.

This adds support for 4 RX/TX queues while maintaining backwards
compatibility with older hardware.

Simultaneous TX + RX performance on AMD Threadripper 3960X
with Mikrotik 10/25G NIC improved from 1.6Mpps to 3.2Mpps per port.

Backwards compatiblitiy was verified with AR8151 and AR8131 based
NICs.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c.h    |   9 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h |  34 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 406 +++++++++++-------
 3 files changed, 291 insertions(+), 158 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index 9edf90e1f028..43d821fe7a54 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -63,7 +63,7 @@
 
 #define AT_MAX_RECEIVE_QUEUE    4
 #define AT_DEF_RECEIVE_QUEUE	1
-#define AT_MAX_TRANSMIT_QUEUE	2
+#define AT_MAX_TRANSMIT_QUEUE  4
 
 #define AT_DMA_HI_ADDR_MASK     0xffffffff00000000ULL
 #define AT_DMA_LO_ADDR_MASK     0x00000000ffffffffULL
@@ -294,11 +294,6 @@ enum atl1c_nic_type {
 	athr_mt,
 };
 
-enum atl1c_trans_queue {
-	atl1c_trans_normal = 0,
-	atl1c_trans_high = 1
-};
-
 struct atl1c_hw_stats {
 	/* rx */
 	unsigned long rx_ok;		/* The number of good packet received. */
@@ -522,6 +517,8 @@ struct atl1c_adapter {
 	struct atl1c_hw_stats  hw_stats;
 	struct mii_if_info  mii;    /* MII interface info */
 	u16 rx_buffer_len;
+	unsigned int tx_queue_count;
+	unsigned int rx_queue_count;
 
 	unsigned long flags;
 #define __AT_TESTING        0x0001
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
index c263b326cec5..c567c920628f 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
@@ -528,15 +528,24 @@ void atl1c_post_phy_linkchg(struct atl1c_hw *hw, u16 link_speed);
 #define REG_RX_BASE_ADDR_HI		0x1540
 #define REG_TX_BASE_ADDR_HI		0x1544
 #define REG_RFD0_HEAD_ADDR_LO		0x1550
+#define REG_RFD1_HEAD_ADDR_LO          0x1554
+#define REG_RFD2_HEAD_ADDR_LO          0x1558
+#define REG_RFD3_HEAD_ADDR_LO          0x155C
 #define REG_RFD_RING_SIZE		0x1560
 #define RFD_RING_SIZE_MASK		0x0FFF
 #define REG_RX_BUF_SIZE			0x1564
 #define RX_BUF_SIZE_MASK		0xFFFF
 #define REG_RRD0_HEAD_ADDR_LO		0x1568
+#define REG_RRD1_HEAD_ADDR_LO          0x156C
+#define REG_RRD2_HEAD_ADDR_LO          0x1570
+#define REG_RRD3_HEAD_ADDR_LO          0x1574
 #define REG_RRD_RING_SIZE		0x1578
 #define RRD_RING_SIZE_MASK		0x0FFF
 #define REG_TPD_PRI1_ADDR_LO		0x157C
 #define REG_TPD_PRI0_ADDR_LO		0x1580
+#define REG_TPD_PRI2_ADDR_LO           0x1F10
+#define REG_TPD_PRI3_ADDR_LO           0x1F14
+
 #define REG_TPD_RING_SIZE		0x1584
 #define TPD_RING_SIZE_MASK		0xFFFF
 
@@ -655,15 +664,26 @@ void atl1c_post_phy_linkchg(struct atl1c_hw *hw, u16 link_speed);
 /* Mail box */
 #define MB_RFDX_PROD_IDX_MASK		0xFFFF
 #define REG_MB_RFD0_PROD_IDX		0x15E0
+#define REG_MB_RFD1_PROD_IDX           0x15E4
+#define REG_MB_RFD2_PROD_IDX           0x15E8
+#define REG_MB_RFD3_PROD_IDX           0x15EC
 
 #define REG_TPD_PRI1_PIDX               0x15F0	/* 16bit,hi-tpd producer idx */
 #define REG_TPD_PRI0_PIDX		0x15F2	/* 16bit,lo-tpd producer idx */
 #define REG_TPD_PRI1_CIDX		0x15F4	/* 16bit,hi-tpd consumer idx */
 #define REG_TPD_PRI0_CIDX		0x15F6	/* 16bit,lo-tpd consumer idx */
+#define REG_TPD_PRI3_PIDX              0x1F18
+#define REG_TPD_PRI2_PIDX              0x1F1A
+#define REG_TPD_PRI3_CIDX              0x1F1C
+#define REG_TPD_PRI2_CIDX              0x1F1E
+
 
 #define REG_MB_RFD01_CONS_IDX		0x15F8
 #define MB_RFD0_CONS_IDX_MASK		0x0000FFFF
 #define MB_RFD1_CONS_IDX_MASK		0xFFFF0000
+#define REG_MB_RFD23_CONS_IDX          0x15FC
+#define MB_RFD2_CONS_IDX_MASK          0x0000FFFF
+#define MB_RFD3_CONS_IDX_MASK          0xFFFF0000
 
 /* Interrupt Status Register */
 #define REG_ISR    			0x1600
@@ -687,7 +707,7 @@ void atl1c_post_phy_linkchg(struct atl1c_hw *hw, u16 link_speed);
 /* GPHY low power state interrupt */
 #define ISR_GPHY_LPW           		0x00002000
 #define ISR_TXQ_TO_RST			0x00004000
-#define ISR_TX_PKT			0x00008000
+#define ISR_TX_PKT_0                   0x00008000
 #define ISR_RX_PKT_0			0x00010000
 #define ISR_RX_PKT_1			0x00020000
 #define ISR_RX_PKT_2			0x00040000
@@ -699,6 +719,9 @@ void atl1c_post_phy_linkchg(struct atl1c_hw *hw, u16 link_speed);
 #define ISR_NFERR_DETECTED		0x01000000
 #define ISR_CERR_DETECTED		0x02000000
 #define ISR_PHY_LINKDOWN		0x04000000
+#define ISR_TX_PKT_1                   0x10000000
+#define ISR_TX_PKT_2                   0x20000000
+#define ISR_TX_PKT_3                   0x40000000
 #define ISR_DIS_INT			0x80000000
 
 /* Interrupt Mask Register */
@@ -713,11 +736,15 @@ void atl1c_post_phy_linkchg(struct atl1c_hw *hw, u16 link_speed);
 		ISR_TXQ_TO_RST  |\
 		ISR_DMAW_TO_RST	|\
 		ISR_GPHY	|\
-		ISR_TX_PKT	|\
-		ISR_RX_PKT_0	|\
 		ISR_GPHY_LPW    |\
 		ISR_PHY_LINKDOWN)
 
+#define ISR_TX_PKT     (			\
+	ISR_TX_PKT_0    |			\
+	ISR_TX_PKT_1    |			\
+	ISR_TX_PKT_2    |			\
+	ISR_TX_PKT_3)
+
 #define ISR_RX_PKT 	(\
 	ISR_RX_PKT_0    |\
 	ISR_RX_PKT_1    |\
@@ -771,6 +798,7 @@ void atl1c_post_phy_linkchg(struct atl1c_hw *hw, u16 link_speed);
 #define REG_MT_VERSION			0x1F0C
 
 #define MT_MAGIC			0xaabb1234
+#define MT_MODE_4Q			BIT(0)
 
 #define L1D_MPW_PHYID1			0xD01C  /* V7 */
 #define L1D_MPW_PHYID2			0xD01D  /* V1-V6 */
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 79984735a2fd..1c6246a5dc22 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -36,6 +36,40 @@ MODULE_AUTHOR("Qualcomm Atheros Inc.");
 MODULE_DESCRIPTION("Qualcomm Atheros 100/1000M Ethernet Network Driver");
 MODULE_LICENSE("GPL");
 
+struct atl1c_qregs {
+	u16 tpd_addr_lo;
+	u16 tpd_prod;
+	u16 tpd_cons;
+	u16 rfd_addr_lo;
+	u16 rrd_addr_lo;
+	u16 rfd_prod;
+	u32 tx_isr;
+	u32 rx_isr;
+};
+
+static struct atl1c_qregs atl1c_qregs[AT_MAX_TRANSMIT_QUEUE] = {
+	{
+		REG_TPD_PRI0_ADDR_LO, REG_TPD_PRI0_PIDX, REG_TPD_PRI0_CIDX,
+		REG_RFD0_HEAD_ADDR_LO, REG_RRD0_HEAD_ADDR_LO,
+		REG_MB_RFD0_PROD_IDX, ISR_TX_PKT_0, ISR_RX_PKT_0
+	},
+	{
+		REG_TPD_PRI1_ADDR_LO, REG_TPD_PRI1_PIDX, REG_TPD_PRI1_CIDX,
+		REG_RFD1_HEAD_ADDR_LO, REG_RRD1_HEAD_ADDR_LO,
+		REG_MB_RFD1_PROD_IDX, ISR_TX_PKT_1, ISR_RX_PKT_1
+	},
+	{
+		REG_TPD_PRI2_ADDR_LO, REG_TPD_PRI2_PIDX, REG_TPD_PRI2_CIDX,
+		REG_RFD2_HEAD_ADDR_LO, REG_RRD2_HEAD_ADDR_LO,
+		REG_MB_RFD2_PROD_IDX, ISR_TX_PKT_2, ISR_RX_PKT_2
+	},
+	{
+		REG_TPD_PRI3_ADDR_LO, REG_TPD_PRI3_PIDX, REG_TPD_PRI3_CIDX,
+		REG_RFD3_HEAD_ADDR_LO, REG_RRD3_HEAD_ADDR_LO,
+		REG_MB_RFD3_PROD_IDX, ISR_TX_PKT_3, ISR_RX_PKT_3
+	},
+};
+
 static int atl1c_stop_mac(struct atl1c_hw *hw);
 static void atl1c_disable_l0s_l1(struct atl1c_hw *hw);
 static void atl1c_set_aspm(struct atl1c_hw *hw, u16 link_speed);
@@ -45,7 +79,8 @@ static void atl1c_down(struct atl1c_adapter *adapter);
 static int atl1c_reset_mac(struct atl1c_hw *hw);
 static void atl1c_reset_dma_ring(struct atl1c_adapter *adapter);
 static int atl1c_configure(struct atl1c_adapter *adapter);
-static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, bool napi_mode);
+static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, u32 queue,
+				 bool napi_mode);
 
 
 static const u32 atl1c_default_msg = NETIF_MSG_DRV | NETIF_MSG_PROBE |
@@ -761,7 +796,7 @@ static int atl1c_sw_init(struct atl1c_adapter *adapter)
 	struct atl1c_hw *hw   = &adapter->hw;
 	struct pci_dev	*pdev = adapter->pdev;
 	u32 revision;
-
+	int i;
 
 	adapter->wol = 0;
 	device_set_wakeup_enable(&pdev->dev, false);
@@ -786,6 +821,10 @@ static int atl1c_sw_init(struct atl1c_adapter *adapter)
 	atl1c_patch_assign(hw);
 
 	hw->intr_mask = IMR_NORMAL_MASK;
+	for (i = 0; i < adapter->tx_queue_count; ++i)
+		hw->intr_mask |= atl1c_qregs[i].tx_isr;
+	for (i = 0; i < adapter->rx_queue_count; ++i)
+		hw->intr_mask |= atl1c_qregs[i].rx_isr;
 	hw->phy_configured = false;
 	hw->preamble_len = 7;
 	hw->max_frame_size = adapter->netdev->mtu;
@@ -845,12 +884,12 @@ static inline void atl1c_clean_buffer(struct pci_dev *pdev,
 /**
  * atl1c_clean_tx_ring - Free Tx-skb
  * @adapter: board private structure
- * @type: type of transmit queue
+ * @queue: idx of transmit queue
  */
 static void atl1c_clean_tx_ring(struct atl1c_adapter *adapter,
-				enum atl1c_trans_queue type)
+				u32 queue)
 {
-	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[type];
+	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[queue];
 	struct atl1c_buffer *buffer_info;
 	struct pci_dev *pdev = adapter->pdev;
 	u16 index, ring_count;
@@ -873,11 +912,12 @@ static void atl1c_clean_tx_ring(struct atl1c_adapter *adapter,
 /**
  * atl1c_clean_rx_ring - Free rx-reservation skbs
  * @adapter: board private structure
+ * @queue: idx of transmit queue
  */
-static void atl1c_clean_rx_ring(struct atl1c_adapter *adapter)
+static void atl1c_clean_rx_ring(struct atl1c_adapter *adapter, u32 queue)
 {
-	struct atl1c_rfd_ring *rfd_ring = adapter->rfd_ring;
-	struct atl1c_rrd_ring *rrd_ring = adapter->rrd_ring;
+	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring[queue];
+	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring[queue];
 	struct atl1c_buffer *buffer_info;
 	struct pci_dev *pdev = adapter->pdev;
 	int j;
@@ -905,21 +945,23 @@ static void atl1c_init_ring_ptrs(struct atl1c_adapter *adapter)
 	struct atl1c_buffer *buffer_info;
 	int i, j;
 
-	for (i = 0; i < AT_MAX_TRANSMIT_QUEUE; i++) {
+	for (i = 0; i < adapter->tx_queue_count; i++) {
 		tpd_ring[i].next_to_use = 0;
 		atomic_set(&tpd_ring[i].next_to_clean, 0);
 		buffer_info = tpd_ring[i].buffer_info;
 		for (j = 0; j < tpd_ring->count; j++)
 			ATL1C_SET_BUFFER_STATE(&buffer_info[i],
-					ATL1C_BUFFER_FREE);
-	}
-	rfd_ring->next_to_use = 0;
-	rfd_ring->next_to_clean = 0;
-	rrd_ring->next_to_use = 0;
-	rrd_ring->next_to_clean = 0;
-	for (j = 0; j < rfd_ring->count; j++) {
-		buffer_info = &rfd_ring->buffer_info[j];
-		ATL1C_SET_BUFFER_STATE(buffer_info, ATL1C_BUFFER_FREE);
+					       ATL1C_BUFFER_FREE);
+	}
+	for (i = 0; i < adapter->rx_queue_count; i++) {
+		rfd_ring[i].next_to_use = 0;
+		rfd_ring[i].next_to_clean = 0;
+		rrd_ring[i].next_to_use = 0;
+		rrd_ring[i].next_to_clean = 0;
+		for (j = 0; j < rfd_ring[i].count; j++) {
+			buffer_info = &rfd_ring[i].buffer_info[j];
+			ATL1C_SET_BUFFER_STATE(buffer_info, ATL1C_BUFFER_FREE);
+		}
 	}
 }
 
@@ -932,20 +974,24 @@ static void atl1c_init_ring_ptrs(struct atl1c_adapter *adapter)
 static void atl1c_free_ring_resources(struct atl1c_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
+	int i;
 
 	dma_free_coherent(&pdev->dev, adapter->ring_header.size,
 			  adapter->ring_header.desc, adapter->ring_header.dma);
 	adapter->ring_header.desc = NULL;
 
 	/* Note: just free tdp_ring.buffer_info,
-	*  it contain rfd_ring.buffer_info, do not double free */
+	 * it contain rfd_ring.buffer_info, do not double free
+	 */
 	if (adapter->tpd_ring[0].buffer_info) {
 		kfree(adapter->tpd_ring[0].buffer_info);
 		adapter->tpd_ring[0].buffer_info = NULL;
 	}
-	if (adapter->rrd_ring[0].rx_page) {
-		put_page(adapter->rrd_ring[0].rx_page);
-		adapter->rrd_ring[0].rx_page = NULL;
+	for (i = 0; i < adapter->rx_queue_count; ++i) {
+		if (adapter->rrd_ring[i].rx_page) {
+			put_page(adapter->rrd_ring[i].rx_page);
+			adapter->rrd_ring[i].rx_page = NULL;
+		}
 	}
 }
 
@@ -962,36 +1008,43 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
 	struct atl1c_rfd_ring *rfd_ring = adapter->rfd_ring;
 	struct atl1c_rrd_ring *rrd_ring = adapter->rrd_ring;
 	struct atl1c_ring_header *ring_header = &adapter->ring_header;
+	int tqc = adapter->tx_queue_count;
+	int rqc = adapter->rx_queue_count;
 	int size;
 	int i;
 	int count = 0;
-	int rx_desc_count = 0;
 	u32 offset = 0;
 
-	rrd_ring->count = rfd_ring->count;
-	for (i = 1; i < AT_MAX_TRANSMIT_QUEUE; i++)
+	/* Even though only one tpd queue is actually used, the "high"
+	 * priority tpd queue also gets initialized
+	 */
+	if (tqc == 1)
+		tqc = 2;
+
+	for (i = 1; i < tqc; i++)
 		tpd_ring[i].count = tpd_ring[0].count;
 
-	/* 2 tpd queue, one high priority queue,
-	 * another normal priority queue */
-	size = sizeof(struct atl1c_buffer) * (tpd_ring->count * 2 +
-		rfd_ring->count);
+	size = sizeof(struct atl1c_buffer) * (tpd_ring->count * tqc +
+					      rfd_ring->count * rqc);
 	tpd_ring->buffer_info = kzalloc(size, GFP_KERNEL);
 	if (unlikely(!tpd_ring->buffer_info))
 		goto err_nomem;
 
-	for (i = 0; i < AT_MAX_TRANSMIT_QUEUE; i++) {
+	for (i = 0; i < tqc; i++) {
 		tpd_ring[i].adapter = adapter;
 		tpd_ring[i].num = i;
-		tpd_ring[i].buffer_info =
-			(tpd_ring->buffer_info + count);
+		tpd_ring[i].buffer_info = (tpd_ring->buffer_info + count);
 		count += tpd_ring[i].count;
 	}
 
-	rfd_ring->buffer_info =
-		(tpd_ring->buffer_info + count);
-	count += rfd_ring->count;
-	rx_desc_count += rfd_ring->count;
+	for (i = 0; i < rqc; i++) {
+		rrd_ring[i].adapter = adapter;
+		rrd_ring[i].num = i;
+		rrd_ring[i].count = rfd_ring[0].count;
+		rfd_ring[i].count = rfd_ring[0].count;
+		rfd_ring[i].buffer_info = (tpd_ring->buffer_info + count);
+		count += rfd_ring->count;
+	}
 
 	/*
 	 * real ring DMA buffer
@@ -999,9 +1052,9 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
 	 * additional bytes tacked onto the end.
 	 */
 	ring_header->size = size =
-		sizeof(struct atl1c_tpd_desc) * tpd_ring->count * 2 +
-		sizeof(struct atl1c_rx_free_desc) * rx_desc_count +
-		sizeof(struct atl1c_recv_ret_status) * rx_desc_count +
+		sizeof(struct atl1c_tpd_desc) * tpd_ring->count * tqc +
+		sizeof(struct atl1c_rx_free_desc) * rfd_ring->count * rqc +
+		sizeof(struct atl1c_recv_ret_status) * rfd_ring->count * rqc +
 		8 * 4;
 
 	ring_header->desc = dma_alloc_coherent(&pdev->dev, ring_header->size,
@@ -1014,27 +1067,28 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
 
 	tpd_ring[0].dma = roundup(ring_header->dma, 8);
 	offset = tpd_ring[0].dma - ring_header->dma;
-	for (i = 0; i < AT_MAX_TRANSMIT_QUEUE; i++) {
+	for (i = 0; i < tqc; i++) {
 		tpd_ring[i].dma = ring_header->dma + offset;
-		tpd_ring[i].desc = (u8 *) ring_header->desc + offset;
+		tpd_ring[i].desc = (u8 *)ring_header->desc + offset;
 		tpd_ring[i].size =
 			sizeof(struct atl1c_tpd_desc) * tpd_ring[i].count;
 		offset += roundup(tpd_ring[i].size, 8);
 	}
-	/* init RFD ring */
-	rfd_ring->dma = ring_header->dma + offset;
-	rfd_ring->desc = (u8 *) ring_header->desc + offset;
-	rfd_ring->size = sizeof(struct atl1c_rx_free_desc) * rfd_ring->count;
-	offset += roundup(rfd_ring->size, 8);
-
-	/* init RRD ring */
-	rrd_ring->adapter = adapter;
-	rrd_ring->num = 0;
-	rrd_ring->dma = ring_header->dma + offset;
-	rrd_ring->desc = (u8 *) ring_header->desc + offset;
-	rrd_ring->size = sizeof(struct atl1c_recv_ret_status) *
-		rrd_ring->count;
-	offset += roundup(rrd_ring->size, 8);
+	for (i = 0; i < rqc; i++) {
+		/* init RFD ring */
+		rfd_ring[i].dma = ring_header->dma + offset;
+		rfd_ring[i].desc = (u8 *)ring_header->desc + offset;
+		rfd_ring[i].size = sizeof(struct atl1c_rx_free_desc) *
+			rfd_ring[i].count;
+		offset += roundup(rfd_ring[i].size, 8);
+
+		/* init RRD ring */
+		rrd_ring[i].dma = ring_header->dma + offset;
+		rrd_ring[i].desc = (u8 *)ring_header->desc + offset;
+		rrd_ring[i].size = sizeof(struct atl1c_recv_ret_status) *
+			rrd_ring[i].count;
+		offset += roundup(rrd_ring[i].size, 8);
+	}
 
 	return 0;
 
@@ -1049,27 +1103,31 @@ static void atl1c_configure_des_ring(struct atl1c_adapter *adapter)
 	struct atl1c_rfd_ring *rfd_ring = adapter->rfd_ring;
 	struct atl1c_rrd_ring *rrd_ring = adapter->rrd_ring;
 	struct atl1c_tpd_ring *tpd_ring = adapter->tpd_ring;
+	int i;
+	int tx_queue_count = adapter->tx_queue_count;
+
+	if (tx_queue_count == 1)
+		tx_queue_count = 2;
 
 	/* TPD */
 	AT_WRITE_REG(hw, REG_TX_BASE_ADDR_HI,
-			(u32)((tpd_ring[atl1c_trans_normal].dma &
-				AT_DMA_HI_ADDR_MASK) >> 32));
+		     (u32)((tpd_ring[0].dma & AT_DMA_HI_ADDR_MASK) >> 32));
 	/* just enable normal priority TX queue */
-	AT_WRITE_REG(hw, REG_TPD_PRI0_ADDR_LO,
-			(u32)(tpd_ring[atl1c_trans_normal].dma &
-				AT_DMA_LO_ADDR_MASK));
-	AT_WRITE_REG(hw, REG_TPD_PRI1_ADDR_LO,
-			(u32)(tpd_ring[atl1c_trans_high].dma &
-				AT_DMA_LO_ADDR_MASK));
+	for (i = 0; i < tx_queue_count; i++) {
+		AT_WRITE_REG(hw, atl1c_qregs[i].tpd_addr_lo,
+			     (u32)(tpd_ring[i].dma & AT_DMA_LO_ADDR_MASK));
+	}
 	AT_WRITE_REG(hw, REG_TPD_RING_SIZE,
 			(u32)(tpd_ring[0].count & TPD_RING_SIZE_MASK));
 
 
 	/* RFD */
 	AT_WRITE_REG(hw, REG_RX_BASE_ADDR_HI,
-			(u32)((rfd_ring->dma & AT_DMA_HI_ADDR_MASK) >> 32));
-	AT_WRITE_REG(hw, REG_RFD0_HEAD_ADDR_LO,
-			(u32)(rfd_ring->dma & AT_DMA_LO_ADDR_MASK));
+		     (u32)((rfd_ring->dma & AT_DMA_HI_ADDR_MASK) >> 32));
+	for (i = 0; i < adapter->rx_queue_count; i++) {
+		AT_WRITE_REG(hw, atl1c_qregs[i].rfd_addr_lo,
+			     (u32)(rfd_ring[i].dma & AT_DMA_LO_ADDR_MASK));
+	}
 
 	AT_WRITE_REG(hw, REG_RFD_RING_SIZE,
 			rfd_ring->count & RFD_RING_SIZE_MASK);
@@ -1077,8 +1135,10 @@ static void atl1c_configure_des_ring(struct atl1c_adapter *adapter)
 			adapter->rx_buffer_len & RX_BUF_SIZE_MASK);
 
 	/* RRD */
-	AT_WRITE_REG(hw, REG_RRD0_HEAD_ADDR_LO,
-			(u32)(rrd_ring->dma & AT_DMA_LO_ADDR_MASK));
+	for (i = 0; i < adapter->rx_queue_count; i++) {
+		AT_WRITE_REG(hw, atl1c_qregs[i].rrd_addr_lo,
+			     (u32)(rrd_ring[i].dma & AT_DMA_LO_ADDR_MASK));
+	}
 	AT_WRITE_REG(hw, REG_RRD_RING_SIZE,
 			(rrd_ring->count & RRD_RING_SIZE_MASK));
 
@@ -1431,14 +1491,28 @@ static int atl1c_configure(struct atl1c_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	int num;
+	int i;
+
+	if (adapter->hw.nic_type == athr_mt) {
+		u32 mode;
+
+		AT_READ_REG(&adapter->hw, REG_MT_MODE, &mode);
+		if (adapter->rx_queue_count == 4)
+			mode |= MT_MODE_4Q;
+		else
+			mode &= ~MT_MODE_4Q;
+		AT_WRITE_REG(&adapter->hw, REG_MT_MODE, mode);
+	}
 
 	atl1c_init_ring_ptrs(adapter);
 	atl1c_set_multi(netdev);
 	atl1c_restore_vlan(adapter);
 
-	num = atl1c_alloc_rx_buffer(adapter, false);
-	if (unlikely(num == 0))
-		return -ENOMEM;
+	for (i = 0; i < adapter->rx_queue_count; ++i) {
+		num = atl1c_alloc_rx_buffer(adapter, i, false);
+		if (unlikely(num == 0))
+			return -ENOMEM;
+	}
 
 	if (atl1c_configure_mac(adapter))
 		return -EIO;
@@ -1537,6 +1611,8 @@ static int atl1c_clean_tx(struct napi_struct *napi, int budget)
 	struct atl1c_tpd_ring *tpd_ring =
 		container_of(napi, struct atl1c_tpd_ring, napi);
 	struct atl1c_adapter *adapter = tpd_ring->adapter;
+	struct netdev_queue *txq =
+		netdev_get_tx_queue(napi->dev, tpd_ring->num);
 	struct atl1c_buffer *buffer_info;
 	struct pci_dev *pdev = adapter->pdev;
 	u16 next_to_clean = atomic_read(&tpd_ring->next_to_clean);
@@ -1544,7 +1620,8 @@ static int atl1c_clean_tx(struct napi_struct *napi, int budget)
 	unsigned int total_bytes = 0, total_packets = 0;
 	unsigned long flags;
 
-	AT_READ_REGW(&adapter->hw, REG_TPD_PRI0_CIDX, &hw_next_to_clean);
+	AT_READ_REGW(&adapter->hw, atl1c_qregs[tpd_ring->num].tpd_cons,
+		     &hw_next_to_clean);
 
 	while (next_to_clean != hw_next_to_clean) {
 		buffer_info = &tpd_ring->buffer_info[next_to_clean];
@@ -1558,17 +1635,15 @@ static int atl1c_clean_tx(struct napi_struct *napi, int budget)
 		atomic_set(&tpd_ring->next_to_clean, next_to_clean);
 	}
 
-	netdev_completed_queue(adapter->netdev, total_packets, total_bytes);
+	netdev_tx_completed_queue(txq, total_packets, total_bytes);
 
-	if (netif_queue_stopped(adapter->netdev) &&
-			netif_carrier_ok(adapter->netdev)) {
-		netif_wake_queue(adapter->netdev);
-	}
+	if (netif_tx_queue_stopped(txq) && netif_carrier_ok(adapter->netdev))
+		netif_tx_wake_queue(txq);
 
 	if (total_packets < budget) {
 		napi_complete_done(napi, total_packets);
 		spin_lock_irqsave(&adapter->hw.intr_mask_lock, flags);
-		adapter->hw.intr_mask |= ISR_TX_PKT;
+		adapter->hw.intr_mask |= atl1c_qregs[tpd_ring->num].tx_isr;
 		AT_WRITE_REG(&adapter->hw, REG_IMR, adapter->hw.intr_mask);
 		spin_unlock_irqrestore(&adapter->hw.intr_mask_lock, flags);
 		return total_packets;
@@ -1576,6 +1651,38 @@ static int atl1c_clean_tx(struct napi_struct *napi, int budget)
 	return budget;
 }
 
+static void atl1c_intr_rx_tx(struct atl1c_adapter *adapter, u32 status)
+{
+	struct atl1c_hw *hw = &adapter->hw;
+	u32 intr_mask;
+	int i;
+
+	spin_lock(&hw->intr_mask_lock);
+	intr_mask = hw->intr_mask;
+	for (i = 0; i < adapter->rx_queue_count; ++i) {
+		if (!(status & atl1c_qregs[i].rx_isr))
+			continue;
+		if (napi_schedule_prep(&adapter->rrd_ring[i].napi)) {
+			intr_mask &= ~atl1c_qregs[i].rx_isr;
+			__napi_schedule(&adapter->rrd_ring[i].napi);
+		}
+	}
+	for (i = 0; i < adapter->tx_queue_count; ++i) {
+		if (!(status & atl1c_qregs[i].tx_isr))
+			continue;
+		if (napi_schedule_prep(&adapter->tpd_ring[i].napi)) {
+			intr_mask &= ~atl1c_qregs[i].tx_isr;
+			__napi_schedule(&adapter->tpd_ring[i].napi);
+		}
+	}
+
+	if (hw->intr_mask != intr_mask) {
+		hw->intr_mask = intr_mask;
+		AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
+	}
+	spin_unlock(&hw->intr_mask_lock);
+}
+
 /**
  * atl1c_intr - Interrupt Handler
  * @irq: interrupt number
@@ -1606,24 +1713,8 @@ static irqreturn_t atl1c_intr(int irq, void *data)
 			atl1c_clear_phy_int(adapter);
 		/* Ack ISR */
 		AT_WRITE_REG(hw, REG_ISR, status | ISR_DIS_INT);
-		if (status & ISR_RX_PKT) {
-			if (napi_schedule_prep(&adapter->rrd_ring[0].napi)) {
-				spin_lock(&hw->intr_mask_lock);
-				hw->intr_mask &= ~ISR_RX_PKT;
-				AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
-				spin_unlock(&hw->intr_mask_lock);
-				__napi_schedule(&adapter->rrd_ring[0].napi);
-			}
-		}
-		if (status & ISR_TX_PKT) {
-			if (napi_schedule_prep(&adapter->tpd_ring[0].napi)) {
-				spin_lock(&hw->intr_mask_lock);
-				hw->intr_mask &= ~ISR_TX_PKT;
-				AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
-				spin_unlock(&hw->intr_mask_lock);
-				__napi_schedule(&adapter->tpd_ring[0].napi);
-			}
-		}
+		if (status & (ISR_RX_PKT | ISR_TX_PKT))
+			atl1c_intr_rx_tx(adapter, status);
 
 		handled = IRQ_HANDLED;
 		/* check if PCIE PHY Link down */
@@ -1674,9 +1765,9 @@ static inline void atl1c_rx_checksum(struct atl1c_adapter *adapter,
 }
 
 static struct sk_buff *atl1c_alloc_skb(struct atl1c_adapter *adapter,
-				       bool napi_mode)
+				       u32 queue, bool napi_mode)
 {
-	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring[0];
+	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring[queue];
 	struct sk_buff *skb;
 	struct page *page;
 
@@ -1711,9 +1802,10 @@ static struct sk_buff *atl1c_alloc_skb(struct atl1c_adapter *adapter,
 	return skb;
 }
 
-static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, bool napi_mode)
+static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, u32 queue,
+				 bool napi_mode)
 {
-	struct atl1c_rfd_ring *rfd_ring = adapter->rfd_ring;
+	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring[queue];
 	struct pci_dev *pdev = adapter->pdev;
 	struct atl1c_buffer *buffer_info, *next_info;
 	struct sk_buff *skb;
@@ -1732,7 +1824,7 @@ static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, bool napi_mode)
 	while (next_info->flags & ATL1C_BUFFER_FREE) {
 		rfd_desc = ATL1C_RFD_DESC(rfd_ring, rfd_next_to_use);
 
-		skb = atl1c_alloc_skb(adapter, napi_mode);
+		skb = atl1c_alloc_skb(adapter, queue, napi_mode);
 		if (unlikely(!skb)) {
 			if (netif_msg_rx_err(adapter))
 				dev_warn(&pdev->dev, "alloc rx buffer failed\n");
@@ -1774,8 +1866,8 @@ static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, bool napi_mode)
 		/* TODO: update mailbox here */
 		wmb();
 		rfd_ring->next_to_use = rfd_next_to_use;
-		AT_WRITE_REG(&adapter->hw, REG_MB_RFD0_PROD_IDX,
-			rfd_ring->next_to_use & MB_RFDX_PROD_IDX_MASK);
+		AT_WRITE_REG(&adapter->hw, atl1c_qregs[queue].rfd_prod,
+			     rfd_ring->next_to_use & MB_RFDX_PROD_IDX_MASK);
 	}
 
 	return num_alloc;
@@ -1824,7 +1916,6 @@ static int atl1c_clean_rx(struct napi_struct *napi, int budget)
 		container_of(napi, struct atl1c_rrd_ring, napi);
 	struct atl1c_adapter *adapter = rrd_ring->adapter;
 	u16 rfd_num, rfd_index;
-	u16 count = 0;
 	u16 length;
 	struct pci_dev *pdev = adapter->pdev;
 	struct net_device *netdev  = adapter->netdev;
@@ -1897,16 +1988,15 @@ static int atl1c_clean_rx(struct napi_struct *napi, int budget)
 		napi_gro_receive(napi, skb);
 
 		work_done++;
-		count++;
 	}
-	if (count)
-		atl1c_alloc_rx_buffer(adapter, true);
+	if (work_done)
+		atl1c_alloc_rx_buffer(adapter, rrd_ring->num, true);
 
 	if (work_done < budget) {
 quit_polling:
 		napi_complete_done(napi, work_done);
 		spin_lock_irqsave(&adapter->hw.intr_mask_lock, flags);
-		adapter->hw.intr_mask |= ISR_RX_PKT;
+		adapter->hw.intr_mask |= atl1c_qregs[rrd_ring->num].rx_isr;
 		AT_WRITE_REG(&adapter->hw, REG_IMR, adapter->hw.intr_mask);
 		spin_unlock_irqrestore(&adapter->hw.intr_mask_lock, flags);
 	}
@@ -1930,9 +2020,9 @@ static void atl1c_netpoll(struct net_device *netdev)
 }
 #endif
 
-static inline u16 atl1c_tpd_avail(struct atl1c_adapter *adapter, enum atl1c_trans_queue type)
+static inline u16 atl1c_tpd_avail(struct atl1c_adapter *adapter, u32 queue)
 {
-	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[type];
+	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[queue];
 	u16 next_to_use = 0;
 	u16 next_to_clean = 0;
 
@@ -1950,9 +2040,9 @@ static inline u16 atl1c_tpd_avail(struct atl1c_adapter *adapter, enum atl1c_tran
  * there is enough tpd to use
  */
 static struct atl1c_tpd_desc *atl1c_get_tpd(struct atl1c_adapter *adapter,
-	enum atl1c_trans_queue type)
+					    u32 queue)
 {
-	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[type];
+	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[queue];
 	struct atl1c_tpd_desc *tpd_desc;
 	u16 next_to_use = 0;
 
@@ -1994,7 +2084,7 @@ static u16 atl1c_cal_tpd_req(const struct sk_buff *skb)
 static int atl1c_tso_csum(struct atl1c_adapter *adapter,
 			  struct sk_buff *skb,
 			  struct atl1c_tpd_desc **tpd,
-			  enum atl1c_trans_queue type)
+			  u32 queue)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	unsigned short offload_type;
@@ -2039,7 +2129,7 @@ static int atl1c_tso_csum(struct atl1c_adapter *adapter,
 				*(struct atl1c_tpd_ext_desc **)(tpd);
 
 			memset(etpd, 0, sizeof(struct atl1c_tpd_ext_desc));
-			*tpd = atl1c_get_tpd(adapter, type);
+			*tpd = atl1c_get_tpd(adapter, queue);
 			ipv6_hdr(skb)->payload_len = 0;
 			/* check payload == 0 byte ? */
 			hdr_len = (skb_transport_offset(skb) + tcp_hdrlen(skb));
@@ -2091,9 +2181,9 @@ static int atl1c_tso_csum(struct atl1c_adapter *adapter,
 
 static void atl1c_tx_rollback(struct atl1c_adapter *adpt,
 			      struct atl1c_tpd_desc *first_tpd,
-			      enum atl1c_trans_queue type)
+			      u32 queue)
 {
-	struct atl1c_tpd_ring *tpd_ring = &adpt->tpd_ring[type];
+	struct atl1c_tpd_ring *tpd_ring = &adpt->tpd_ring[queue];
 	struct atl1c_buffer *buffer_info;
 	struct atl1c_tpd_desc *tpd;
 	u16 first_index, index;
@@ -2112,8 +2202,8 @@ static void atl1c_tx_rollback(struct atl1c_adapter *adpt,
 }
 
 static int atl1c_tx_map(struct atl1c_adapter *adapter,
-		      struct sk_buff *skb, struct atl1c_tpd_desc *tpd,
-			enum atl1c_trans_queue type)
+			struct sk_buff *skb, struct atl1c_tpd_desc *tpd,
+			u32 queue)
 {
 	struct atl1c_tpd_desc *use_tpd = NULL;
 	struct atl1c_buffer *buffer_info = NULL;
@@ -2153,7 +2243,7 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 		if (mapped_len == 0)
 			use_tpd = tpd;
 		else {
-			use_tpd = atl1c_get_tpd(adapter, type);
+			use_tpd = atl1c_get_tpd(adapter, queue);
 			memcpy(use_tpd, tpd, sizeof(struct atl1c_tpd_desc));
 		}
 		buffer_info = atl1c_get_tx_buffer(adapter, use_tpd);
@@ -2175,7 +2265,7 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 	for (f = 0; f < nr_frags; f++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
-		use_tpd = atl1c_get_tpd(adapter, type);
+		use_tpd = atl1c_get_tpd(adapter, queue);
 		memcpy(use_tpd, tpd, sizeof(struct atl1c_tpd_desc));
 
 		buffer_info = atl1c_get_tx_buffer(adapter, use_tpd);
@@ -2208,23 +2298,22 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 	return -1;
 }
 
-static void atl1c_tx_queue(struct atl1c_adapter *adapter,
-			   enum atl1c_trans_queue type)
+static void atl1c_tx_queue(struct atl1c_adapter *adapter, u32 queue)
 {
-	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[type];
-	u16 reg;
+	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[queue];
 
-	reg = type == atl1c_trans_high ? REG_TPD_PRI1_PIDX : REG_TPD_PRI0_PIDX;
-	AT_WRITE_REGW(&adapter->hw, reg, tpd_ring->next_to_use);
+	AT_WRITE_REGW(&adapter->hw, atl1c_qregs[queue].tpd_prod,
+		      tpd_ring->next_to_use);
 }
 
 static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
 					  struct net_device *netdev)
 {
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
-	u16 tpd_req;
+	u32 queue = skb_get_queue_mapping(skb);
+	struct netdev_queue *txq = netdev_get_tx_queue(netdev, queue);
 	struct atl1c_tpd_desc *tpd;
-	enum atl1c_trans_queue type = atl1c_trans_normal;
+	u16 tpd_req;
 
 	if (test_bit(__AT_DOWN, &adapter->flags)) {
 		dev_kfree_skb_any(skb);
@@ -2233,18 +2322,18 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
 
 	tpd_req = atl1c_cal_tpd_req(skb);
 
-	if (atl1c_tpd_avail(adapter, type) < tpd_req) {
+	if (atl1c_tpd_avail(adapter, queue) < tpd_req) {
 		/* no enough descriptor, just stop queue */
-		atl1c_tx_queue(adapter, type);
-		netif_stop_queue(netdev);
+		atl1c_tx_queue(adapter, queue);
+		netif_tx_stop_queue(txq);
 		return NETDEV_TX_BUSY;
 	}
 
-	tpd = atl1c_get_tpd(adapter, type);
+	tpd = atl1c_get_tpd(adapter, queue);
 
 	/* do TSO and check sum */
-	if (atl1c_tso_csum(adapter, skb, &tpd, type) != 0) {
-		atl1c_tx_queue(adapter, type);
+	if (atl1c_tso_csum(adapter, skb, &tpd, queue) != 0) {
+		atl1c_tx_queue(adapter, queue);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
@@ -2262,17 +2351,17 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
 	if (skb_network_offset(skb) != ETH_HLEN)
 		tpd->word1 |= 1 << TPD_ETH_TYPE_SHIFT; /* Ethernet frame */
 
-	if (atl1c_tx_map(adapter, skb, tpd, type) < 0) {
+	if (atl1c_tx_map(adapter, skb, tpd, queue) < 0) {
 		netif_info(adapter, tx_done, adapter->netdev,
 			   "tx-skb dropped due to dma error\n");
 		/* roll back tpd/buffer */
-		atl1c_tx_rollback(adapter, tpd, type);
+		atl1c_tx_rollback(adapter, tpd, queue);
 		dev_kfree_skb_any(skb);
 	} else {
 		bool more = netdev_xmit_more();
 
-		if (__netdev_sent_queue(adapter->netdev, skb->len, more))
-			atl1c_tx_queue(adapter, type);
+		if (__netdev_tx_sent_queue(txq, skb->len, more))
+			atl1c_tx_queue(adapter, queue);
 	}
 
 	return NETDEV_TX_OK;
@@ -2326,16 +2415,19 @@ static int atl1c_request_irq(struct atl1c_adapter *adapter)
 
 static void atl1c_reset_dma_ring(struct atl1c_adapter *adapter)
 {
+	int i;
 	/* release tx-pending skbs and reset tx/rx ring index */
-	atl1c_clean_tx_ring(adapter, atl1c_trans_normal);
-	atl1c_clean_tx_ring(adapter, atl1c_trans_high);
-	atl1c_clean_rx_ring(adapter);
+	for (i = 0; i < adapter->tx_queue_count; ++i)
+		atl1c_clean_tx_ring(adapter, i);
+	for (i = 0; i < adapter->rx_queue_count; ++i)
+		atl1c_clean_rx_ring(adapter, i);
 }
 
 static int atl1c_up(struct atl1c_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	int err;
+	int i;
 
 	netif_carrier_off(netdev);
 
@@ -2349,20 +2441,24 @@ static int atl1c_up(struct atl1c_adapter *adapter)
 
 	atl1c_check_link_status(adapter);
 	clear_bit(__AT_DOWN, &adapter->flags);
-	napi_enable(&adapter->rrd_ring[0].napi);
-	napi_enable(&adapter->tpd_ring[0].napi);
+	for (i = 0; i < adapter->tx_queue_count; ++i)
+		napi_enable(&adapter->tpd_ring[i].napi);
+	for (i = 0; i < adapter->rx_queue_count; ++i)
+		napi_enable(&adapter->rrd_ring[i].napi);
 	atl1c_irq_enable(adapter);
 	netif_start_queue(netdev);
 	return err;
 
 err_up:
-	atl1c_clean_rx_ring(adapter);
+	for (i = 0; i < adapter->rx_queue_count; ++i)
+		atl1c_clean_rx_ring(adapter, i);
 	return err;
 }
 
 static void atl1c_down(struct atl1c_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
+	int i;
 
 	atl1c_del_timer(adapter);
 	adapter->work_event = 0; /* clear all event */
@@ -2370,8 +2466,10 @@ static void atl1c_down(struct atl1c_adapter *adapter)
 	 * reschedule our watchdog timer */
 	set_bit(__AT_DOWN, &adapter->flags);
 	netif_carrier_off(netdev);
-	napi_disable(&adapter->rrd_ring[0].napi);
-	napi_disable(&adapter->tpd_ring[0].napi);
+	for (i = 0; i < adapter->tx_queue_count; ++i)
+		napi_disable(&adapter->tpd_ring[i].napi);
+	for (i = 0; i < adapter->rx_queue_count; ++i)
+		napi_disable(&adapter->rrd_ring[i].napi);
 	atl1c_irq_disable(adapter);
 	atl1c_free_irq(adapter);
 	/* disable ASPM if device inactive */
@@ -2558,7 +2656,9 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	static int cards_found;
 	u8 __iomem *hw_addr;
 	enum atl1c_nic_type nic_type;
+	u32 queue_count = 1;
 	int err = 0;
+	int i;
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	err = pci_enable_device_mem(pdev);
@@ -2599,8 +2699,10 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	nic_type = atl1c_get_mac_type(pdev, hw_addr);
+	if (nic_type == athr_mt)
+		queue_count = 4;
 
-	netdev = alloc_etherdev(sizeof(struct atl1c_adapter));
+	netdev = alloc_etherdev_mq(sizeof(struct atl1c_adapter), queue_count);
 	if (netdev == NULL) {
 		err = -ENOMEM;
 		goto err_alloc_etherdev;
@@ -2619,6 +2721,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->hw.nic_type = nic_type;
 	adapter->msg_enable = netif_msg_init(-1, atl1c_default_msg);
 	adapter->hw.hw_addr = hw_addr;
+	adapter->tx_queue_count = queue_count;
+	adapter->rx_queue_count = queue_count;
 
 	/* init mii data */
 	adapter->mii.dev = netdev;
@@ -2627,8 +2731,12 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->mii.phy_id_mask = 0x1f;
 	adapter->mii.reg_num_mask = MDIO_CTRL_REG_MASK;
 	dev_set_threaded(netdev, true);
-	netif_napi_add(netdev, &adapter->rrd_ring[0].napi, atl1c_clean_rx, 64);
-	netif_napi_add(netdev, &adapter->tpd_ring[0].napi, atl1c_clean_tx, 64);
+	for (i = 0; i < adapter->rx_queue_count; ++i)
+		netif_napi_add(netdev, &adapter->rrd_ring[i].napi,
+			       atl1c_clean_rx, 64);
+	for (i = 0; i < adapter->tx_queue_count; ++i)
+		netif_napi_add(netdev, &adapter->tpd_ring[i].napi,
+			       atl1c_clean_tx, 64);
 	timer_setup(&adapter->phy_config_timer, atl1c_phy_config, 0);
 	/* setup the private structure */
 	err = atl1c_sw_init(adapter);
-- 
2.31.1

