Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38DF38278E
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbhEQIyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235786AbhEQIys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:54:48 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68327C061573;
        Mon, 17 May 2021 01:53:32 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1liYzz-0000jj-GZ; Mon, 17 May 2021 11:53:15 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next] atl1c: add 4 RX/TX queue support for Mikrotik 10/25G NIC
Date:   Mon, 17 May 2021 11:53:02 +0300
Message-Id: <20210517085302.1691101-1-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
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
 drivers/net/ethernet/atheros/atl1c/atl1c.h    |  25 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h |  34 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 547 +++++++++++-------
 3 files changed, 366 insertions(+), 240 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index 9d70cb7544f1..0f206d08a460 100644
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
@@ -475,6 +470,8 @@ struct atl1c_buffer {
 
 /* transimit packet descriptor (tpd) ring */
 struct atl1c_tpd_ring {
+	struct atl1c_adapter *adapter;
+	u16 num;
 	void *desc;		/* descriptor ring virtual address */
 	dma_addr_t dma;		/* descriptor ring physical address */
 	u16 size;		/* descriptor ring length in bytes */
@@ -482,6 +479,7 @@ struct atl1c_tpd_ring {
 	u16 next_to_use;
 	atomic_t next_to_clean;
 	struct atl1c_buffer *buffer_info;
+	struct napi_struct napi;
 };
 
 /* receive free descriptor (rfd) ring */
@@ -497,27 +495,30 @@ struct atl1c_rfd_ring {
 
 /* receive return descriptor (rrd) ring */
 struct atl1c_rrd_ring {
+	struct atl1c_adapter *adapter;
+	u16 num;
 	void *desc;		/* descriptor ring virtual address */
 	dma_addr_t dma;		/* descriptor ring physical address */
 	u16 size;		/* descriptor ring length in bytes */
 	u16 count;		/* number of descriptors in the ring */
 	u16 next_to_use;
 	u16 next_to_clean;
+	struct napi_struct napi;
+	struct page *rx_page;
+	unsigned int rx_page_offset;
 };
 
 /* board specific private data structure */
 struct atl1c_adapter {
 	struct net_device   *netdev;
 	struct pci_dev      *pdev;
-	struct napi_struct  napi;
-	struct napi_struct  tx_napi;
-	struct page         *rx_page;
-	unsigned int	    rx_page_offset;
 	unsigned int	    rx_frag_size;
 	struct atl1c_hw        hw;
 	struct atl1c_hw_stats  hw_stats;
 	struct mii_if_info  mii;    /* MII interface info */
 	u16 rx_buffer_len;
+	unsigned int tx_queue_count;
+	unsigned int rx_queue_count;
 
 	unsigned long flags;
 #define __AT_TESTING        0x0001
@@ -543,8 +544,8 @@ struct atl1c_adapter {
 	/* All Descriptor memory */
 	struct atl1c_ring_header ring_header;
 	struct atl1c_tpd_ring tpd_ring[AT_MAX_TRANSMIT_QUEUE];
-	struct atl1c_rfd_ring rfd_ring;
-	struct atl1c_rrd_ring rrd_ring;
+	struct atl1c_rfd_ring rfd_ring[AT_MAX_RECEIVE_QUEUE];
+	struct atl1c_rrd_ring rrd_ring[AT_MAX_RECEIVE_QUEUE];
 	u32 bd_number;     /* board number;*/
 };
 
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
index 740127a6a21d..abb90341c1fa 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -36,18 +36,50 @@ MODULE_AUTHOR("Qualcomm Atheros Inc.");
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
 static void atl1c_start_mac(struct atl1c_adapter *adapter);
-static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
-		   int *work_done, int work_to_do);
 static int atl1c_up(struct atl1c_adapter *adapter);
 static void atl1c_down(struct atl1c_adapter *adapter);
 static int atl1c_reset_mac(struct atl1c_hw *hw);
 static void atl1c_reset_dma_ring(struct atl1c_adapter *adapter);
 static int atl1c_configure(struct atl1c_adapter *adapter);
-static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, bool napi_mode);
+static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, u32 queue);
 
 
 static const u32 atl1c_default_msg = NETIF_MSG_DRV | NETIF_MSG_PROBE |
@@ -646,33 +678,26 @@ static int atl1c_alloc_queues(struct atl1c_adapter *adapter)
 	return 0;
 }
 
-static void atl1c_set_mac_type(struct atl1c_hw *hw)
+static enum atl1c_nic_type atl1c_get_mac_type(struct pci_dev *pdev,
+					      u8 __iomem *hw_addr)
 {
-	u32 magic;
-	switch (hw->device_id) {
+	switch (pdev->device) {
 	case PCI_DEVICE_ID_ATTANSIC_L2C:
-		hw->nic_type = athr_l2c;
-		break;
+		return athr_l2c;
 	case PCI_DEVICE_ID_ATTANSIC_L1C:
-		hw->nic_type = athr_l1c;
-		break;
+		return athr_l1c;
 	case PCI_DEVICE_ID_ATHEROS_L2C_B:
-		hw->nic_type = athr_l2c_b;
-		break;
+		return athr_l2c_b;
 	case PCI_DEVICE_ID_ATHEROS_L2C_B2:
-		hw->nic_type = athr_l2c_b2;
-		break;
+		return athr_l2c_b2;
 	case PCI_DEVICE_ID_ATHEROS_L1D:
-		hw->nic_type = athr_l1d;
-		break;
+		return athr_l1d;
 	case PCI_DEVICE_ID_ATHEROS_L1D_2_0:
-		hw->nic_type = athr_l1d_2;
-		AT_READ_REG(hw, REG_MT_MAGIC, &magic);
-		if (magic == MT_MAGIC)
-			hw->nic_type = athr_mt;
-		break;
+		if (readl(hw_addr + REG_MT_MAGIC) == MT_MAGIC)
+			return athr_mt;
+		return athr_l1d_2;
 	default:
-		break;
+		return athr_l1c;
 	}
 }
 
@@ -680,7 +705,6 @@ static int atl1c_setup_mac_funcs(struct atl1c_hw *hw)
 {
 	u32 link_ctrl_data;
 
-	atl1c_set_mac_type(hw);
 	AT_READ_REG(hw, REG_LINK_CTRL, &link_ctrl_data);
 
 	hw->ctrl_flags = ATL1C_INTR_MODRT_ENABLE  |
@@ -771,14 +795,14 @@ static int atl1c_sw_init(struct atl1c_adapter *adapter)
 	struct atl1c_hw *hw   = &adapter->hw;
 	struct pci_dev	*pdev = adapter->pdev;
 	u32 revision;
-
+	int i;
 
 	adapter->wol = 0;
 	device_set_wakeup_enable(&pdev->dev, false);
 	adapter->link_speed = SPEED_0;
 	adapter->link_duplex = FULL_DUPLEX;
 	adapter->tpd_ring[0].count = 1024;
-	adapter->rfd_ring.count = 512;
+	adapter->rfd_ring[0].count = 512;
 
 	hw->vendor_id = pdev->vendor;
 	hw->device_id = pdev->device;
@@ -796,6 +820,10 @@ static int atl1c_sw_init(struct atl1c_adapter *adapter)
 	atl1c_patch_assign(hw);
 
 	hw->intr_mask = IMR_NORMAL_MASK;
+	for (i = 0; i < adapter->tx_queue_count; ++i)
+		hw->intr_mask |= atl1c_qregs[i].tx_isr;
+	for (i = 0; i < adapter->rx_queue_count; ++i)
+		hw->intr_mask |= atl1c_qregs[i].rx_isr;
 	hw->phy_configured = false;
 	hw->preamble_len = 7;
 	hw->max_frame_size = adapter->netdev->mtu;
@@ -858,9 +886,9 @@ static inline void atl1c_clean_buffer(struct pci_dev *pdev,
  * @type: type of transmit queue
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
@@ -884,10 +912,10 @@ static void atl1c_clean_tx_ring(struct atl1c_adapter *adapter,
  * atl1c_clean_rx_ring - Free rx-reservation skbs
  * @adapter: board private structure
  */
-static void atl1c_clean_rx_ring(struct atl1c_adapter *adapter)
+static void atl1c_clean_rx_ring(struct atl1c_adapter *adapter, u32 queue)
 {
-	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
-	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring;
+	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring[queue];
+	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring[queue];
 	struct atl1c_buffer *buffer_info;
 	struct pci_dev *pdev = adapter->pdev;
 	int j;
@@ -910,26 +938,28 @@ static void atl1c_clean_rx_ring(struct atl1c_adapter *adapter)
 static void atl1c_init_ring_ptrs(struct atl1c_adapter *adapter)
 {
 	struct atl1c_tpd_ring *tpd_ring = adapter->tpd_ring;
-	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
-	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring;
+	struct atl1c_rfd_ring *rfd_ring = adapter->rfd_ring;
+	struct atl1c_rrd_ring *rrd_ring = adapter->rrd_ring;
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
 
@@ -942,20 +972,24 @@ static void atl1c_init_ring_ptrs(struct atl1c_adapter *adapter)
 static void atl1c_free_ring_resources(struct atl1c_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
+	int i;
 
 	dma_free_coherent(&pdev->dev, adapter->ring_header.size,
 			  adapter->ring_header.desc, adapter->ring_header.dma);
 	adapter->ring_header.desc = NULL;
 
 	/* Note: just free tdp_ring.buffer_info,
-	*  it contain rfd_ring.buffer_info, do not double free */
+	 *  it contain rfd_ring.buffer_info, do not double free
+	 */
 	if (adapter->tpd_ring[0].buffer_info) {
 		kfree(adapter->tpd_ring[0].buffer_info);
 		adapter->tpd_ring[0].buffer_info = NULL;
 	}
-	if (adapter->rx_page) {
-		put_page(adapter->rx_page);
-		adapter->rx_page = NULL;
+	for (i = 0; i < adapter->rx_queue_count; ++i) {
+		if (adapter->rrd_ring[i].rx_page) {
+			put_page(adapter->rrd_ring[i].rx_page);
+			adapter->rrd_ring[i].rx_page = NULL;
+		}
 	}
 }
 
@@ -969,37 +1003,46 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct atl1c_tpd_ring *tpd_ring = adapter->tpd_ring;
-	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
-	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring;
+	struct atl1c_rfd_ring *rfd_ring = adapter->rfd_ring;
+	struct atl1c_rrd_ring *rrd_ring = adapter->rrd_ring;
 	struct atl1c_ring_header *ring_header = &adapter->ring_header;
 	int size;
 	int i;
 	int count = 0;
-	int rx_desc_count = 0;
 	u32 offset = 0;
+	int tqc = adapter->tx_queue_count;
+	int rqc = adapter->rx_queue_count;
 
-	rrd_ring->count = rfd_ring->count;
-	for (i = 1; i < AT_MAX_TRANSMIT_QUEUE; i++)
+	/* even though only one tpd queue is actually used, the "high"
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
-		tpd_ring[i].buffer_info =
-			(tpd_ring->buffer_info + count);
+	for (i = 0; i < tqc; i++) {
+		tpd_ring[i].adapter = adapter;
+		tpd_ring[i].num = i;
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
@@ -1007,9 +1050,9 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
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
@@ -1022,25 +1065,28 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
 
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
+	for (i = 0; i < rqc; i++) {
+		/* init RFD ring */
+		rfd_ring[i].dma = ring_header->dma + offset;
+		rfd_ring[i].desc = (u8 *)ring_header->desc + offset;
+		rfd_ring[i].size = sizeof(struct atl1c_rx_free_desc) *
+			rfd_ring[i].count;
+		offset += roundup(rfd_ring[i].size, 8);
 
-	/* init RRD ring */
-	rrd_ring->dma = ring_header->dma + offset;
-	rrd_ring->desc = (u8 *) ring_header->desc + offset;
-	rrd_ring->size = sizeof(struct atl1c_recv_ret_status) *
-		rrd_ring->count;
-	offset += roundup(rrd_ring->size, 8);
+		/* init RRD ring */
+		rrd_ring[i].dma = ring_header->dma + offset;
+		rrd_ring[i].desc = (u8 *)ring_header->desc + offset;
+		rrd_ring[i].size = sizeof(struct atl1c_recv_ret_status) *
+			rrd_ring[i].count;
+		offset += roundup(rrd_ring[i].size, 8);
+	}
 
 	return 0;
 
@@ -1052,31 +1098,34 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
 static void atl1c_configure_des_ring(struct atl1c_adapter *adapter)
 {
 	struct atl1c_hw *hw = &adapter->hw;
-	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
-	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring;
-	struct atl1c_tpd_ring *tpd_ring = (struct atl1c_tpd_ring *)
-				adapter->tpd_ring;
+	struct atl1c_rfd_ring *rfd_ring = adapter->rfd_ring;
+	struct atl1c_rrd_ring *rrd_ring = adapter->rrd_ring;
+	struct atl1c_tpd_ring *tpd_ring = adapter->tpd_ring;
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
@@ -1084,8 +1133,10 @@ static void atl1c_configure_des_ring(struct atl1c_adapter *adapter)
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
 
@@ -1438,14 +1489,28 @@ static int atl1c_configure(struct atl1c_adapter *adapter)
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
+		num = atl1c_alloc_rx_buffer(adapter, i);
+		if (unlikely(num == 0))
+			return -ENOMEM;
+	}
 
 	if (atl1c_configure_mac(adapter))
 		return -EIO;
@@ -1541,9 +1606,11 @@ static inline void atl1c_clear_phy_int(struct atl1c_adapter *adapter)
 
 static int atl1c_clean_tx(struct napi_struct *napi, int budget)
 {
-	struct atl1c_adapter *adapter =
-		container_of(napi, struct atl1c_adapter, tx_napi);
-	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[atl1c_trans_normal];
+	struct atl1c_tpd_ring *tpd_ring =
+		container_of(napi, struct atl1c_tpd_ring, napi);
+	struct atl1c_adapter *adapter = tpd_ring->adapter;
+	struct netdev_queue *txq =
+		netdev_get_tx_queue(napi->dev, tpd_ring->num);
 	struct atl1c_buffer *buffer_info;
 	struct pci_dev *pdev = adapter->pdev;
 	u16 next_to_clean = atomic_read(&tpd_ring->next_to_clean);
@@ -1551,7 +1618,8 @@ static int atl1c_clean_tx(struct napi_struct *napi, int budget)
 	unsigned int total_bytes = 0, total_packets = 0;
 	unsigned long flags;
 
-	AT_READ_REGW(&adapter->hw, REG_TPD_PRI0_CIDX, &hw_next_to_clean);
+	AT_READ_REGW(&adapter->hw, atl1c_qregs[tpd_ring->num].tpd_cons,
+		     &hw_next_to_clean);
 
 	while (next_to_clean != hw_next_to_clean) {
 		buffer_info = &tpd_ring->buffer_info[next_to_clean];
@@ -1565,17 +1633,16 @@ static int atl1c_clean_tx(struct napi_struct *napi, int budget)
 		atomic_set(&tpd_ring->next_to_clean, next_to_clean);
 	}
 
-	netdev_completed_queue(adapter->netdev, total_packets, total_bytes);
+	netdev_tx_completed_queue(txq, total_packets, total_bytes);
 
-	if (netif_queue_stopped(adapter->netdev) &&
-			netif_carrier_ok(adapter->netdev)) {
-		netif_wake_queue(adapter->netdev);
+	if (netif_tx_queue_stopped(txq) && netif_carrier_ok(adapter->netdev)) {
+		netif_tx_wake_queue(txq);
 	}
 
 	if (total_packets < budget) {
 		napi_complete_done(napi, total_packets);
 		spin_lock_irqsave(&adapter->hw.intr_mask_lock, flags);
-		adapter->hw.intr_mask |= ISR_TX_PKT;
+		adapter->hw.intr_mask |= atl1c_qregs[tpd_ring->num].tx_isr;
 		AT_WRITE_REG(&adapter->hw, REG_IMR, adapter->hw.intr_mask);
 		spin_unlock_irqrestore(&adapter->hw.intr_mask_lock, flags);
 		return total_packets;
@@ -1583,6 +1650,38 @@ static int atl1c_clean_tx(struct napi_struct *napi, int budget)
 	return budget;
 }
 
+static void atl1c_intr_rx_tx(struct atl1c_adapter *adapter, u32 status)
+{
+	struct atl1c_hw *hw = &adapter->hw;
+	int i;
+	u32 intr_mask;
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
@@ -1613,24 +1712,8 @@ static irqreturn_t atl1c_intr(int irq, void *data)
 			atl1c_clear_phy_int(adapter);
 		/* Ack ISR */
 		AT_WRITE_REG(hw, REG_ISR, status | ISR_DIS_INT);
-		if (status & ISR_RX_PKT) {
-			if (likely(napi_schedule_prep(&adapter->napi))) {
-				spin_lock(&hw->intr_mask_lock);
-				hw->intr_mask &= ~ISR_RX_PKT;
-				AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
-				spin_unlock(&hw->intr_mask_lock);
-				__napi_schedule(&adapter->napi);
-			}
-		}
-		if (status & ISR_TX_PKT) {
-			if (napi_schedule_prep(&adapter->tx_napi)) {
-				spin_lock(&hw->intr_mask_lock);
-				hw->intr_mask &= ~ISR_TX_PKT;
-				AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
-				spin_unlock(&hw->intr_mask_lock);
-				__napi_schedule(&adapter->tx_napi);
-			}
-		}
+		if (status & (ISR_RX_PKT | ISR_TX_PKT))
+			atl1c_intr_rx_tx(adapter, status);
 
 		handled = IRQ_HANDLED;
 		/* check if PCIE PHY Link down */
@@ -1681,44 +1764,41 @@ static inline void atl1c_rx_checksum(struct atl1c_adapter *adapter,
 }
 
 static struct sk_buff *atl1c_alloc_skb(struct atl1c_adapter *adapter,
-				       bool napi_mode)
+				       u32 queue)
 {
+	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring[queue];
 	struct sk_buff *skb;
 	struct page *page;
 
 	if (adapter->rx_frag_size > PAGE_SIZE) {
-		if (likely(napi_mode))
-			return napi_alloc_skb(&adapter->napi,
-					      adapter->rx_buffer_len);
-		else
-			return netdev_alloc_skb_ip_align(adapter->netdev,
-							 adapter->rx_buffer_len);
+		return napi_alloc_skb(&rrd_ring->napi, adapter->rx_buffer_len);
 	}
 
-	page = adapter->rx_page;
+	page = rrd_ring->rx_page;
 	if (!page) {
-		adapter->rx_page = page = alloc_page(GFP_ATOMIC);
+		page = alloc_page(GFP_ATOMIC);
 		if (unlikely(!page))
 			return NULL;
-		adapter->rx_page_offset = 0;
+		rrd_ring->rx_page = page;
+		rrd_ring->rx_page_offset = 0;
 	}
 
-	skb = build_skb(page_address(page) + adapter->rx_page_offset,
+	skb = build_skb(page_address(page) + rrd_ring->rx_page_offset,
 			adapter->rx_frag_size);
 	if (likely(skb)) {
 		skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
-		adapter->rx_page_offset += adapter->rx_frag_size;
-		if (adapter->rx_page_offset >= PAGE_SIZE)
-			adapter->rx_page = NULL;
+		rrd_ring->rx_page_offset += adapter->rx_frag_size;
+		if (rrd_ring->rx_page_offset >= PAGE_SIZE)
+			rrd_ring->rx_page = NULL;
 		else
 			get_page(page);
 	}
 	return skb;
 }
 
-static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, bool napi_mode)
+static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, u32 queue)
 {
-	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
+	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring[queue];
 	struct pci_dev *pdev = adapter->pdev;
 	struct atl1c_buffer *buffer_info, *next_info;
 	struct sk_buff *skb;
@@ -1737,7 +1817,7 @@ static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, bool napi_mode)
 	while (next_info->flags & ATL1C_BUFFER_FREE) {
 		rfd_desc = ATL1C_RFD_DESC(rfd_ring, rfd_next_to_use);
 
-		skb = atl1c_alloc_skb(adapter, napi_mode);
+		skb = atl1c_alloc_skb(adapter, queue);
 		if (unlikely(!skb)) {
 			if (netif_msg_rx_err(adapter))
 				dev_warn(&pdev->dev, "alloc rx buffer failed\n");
@@ -1779,8 +1859,8 @@ static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, bool napi_mode)
 		/* TODO: update mailbox here */
 		wmb();
 		rfd_ring->next_to_use = rfd_next_to_use;
-		AT_WRITE_REG(&adapter->hw, REG_MB_RFD0_PROD_IDX,
-			rfd_ring->next_to_use & MB_RFDX_PROD_IDX_MASK);
+		AT_WRITE_REG(&adapter->hw, atl1c_qregs[queue].rfd_prod,
+			     rfd_ring->next_to_use & MB_RFDX_PROD_IDX_MASK);
 	}
 
 	return num_alloc;
@@ -1818,22 +1898,33 @@ static void atl1c_clean_rfd(struct atl1c_rfd_ring *rfd_ring,
 	rfd_ring->next_to_clean = rfd_index;
 }
 
-static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
-		   int *work_done, int work_to_do)
+/**
+ * atl1c_clean_rx - NAPI Rx polling callback
+ * @napi: napi info
+ * @budget: limit of packets to clean
+ */
+static int atl1c_clean_rx(struct napi_struct *napi, int budget)
 {
+	struct atl1c_rrd_ring *rrd_ring =
+		container_of(napi, struct atl1c_rrd_ring, napi);
+	struct atl1c_adapter *adapter = rrd_ring->adapter;
+	int work_done = 0;
+	unsigned long flags;
 	u16 rfd_num, rfd_index;
-	u16 count = 0;
 	u16 length;
 	struct pci_dev *pdev = adapter->pdev;
 	struct net_device *netdev  = adapter->netdev;
-	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
-	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring;
+	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring[rrd_ring->num];
 	struct sk_buff *skb;
 	struct atl1c_recv_ret_status *rrs;
 	struct atl1c_buffer *buffer_info;
 
+	/* Keep link state information with original netdev */
+	if (!netif_carrier_ok(adapter->netdev))
+		goto quit_polling;
+
 	while (1) {
-		if (*work_done >= work_to_do)
+		if (work_done >= budget)
 			break;
 		rrs = ATL1C_RRD_DESC(rrd_ring, rrd_ring->next_to_clean);
 		if (likely(RRS_RXD_IS_VALID(rrs->word3))) {
@@ -1887,38 +1978,18 @@ static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
 			vlan = le16_to_cpu(vlan);
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan);
 		}
-		napi_gro_receive(&adapter->napi, skb);
+		napi_gro_receive(napi, skb);
 
-		(*work_done)++;
-		count++;
+		work_done++;
 	}
-	if (count)
-		atl1c_alloc_rx_buffer(adapter, true);
-}
-
-/**
- * atl1c_clean - NAPI Rx polling callback
- * @napi: napi info
- * @budget: limit of packets to clean
- */
-static int atl1c_clean(struct napi_struct *napi, int budget)
-{
-	struct atl1c_adapter *adapter =
-			container_of(napi, struct atl1c_adapter, napi);
-	int work_done = 0;
-	unsigned long flags;
-
-	/* Keep link state information with original netdev */
-	if (!netif_carrier_ok(adapter->netdev))
-		goto quit_polling;
-	/* just enable one RXQ */
-	atl1c_clean_rx_irq(adapter, &work_done, budget);
+	if (work_done)
+		atl1c_alloc_rx_buffer(adapter, rrd_ring->num);
 
 	if (work_done < budget) {
 quit_polling:
 		napi_complete_done(napi, work_done);
 		spin_lock_irqsave(&adapter->hw.intr_mask_lock, flags);
-		adapter->hw.intr_mask |= ISR_RX_PKT;
+		adapter->hw.intr_mask |= atl1c_qregs[rrd_ring->num].rx_isr;
 		AT_WRITE_REG(&adapter->hw, REG_IMR, adapter->hw.intr_mask);
 		spin_unlock_irqrestore(&adapter->hw.intr_mask_lock, flags);
 	}
@@ -1942,9 +2013,9 @@ static void atl1c_netpoll(struct net_device *netdev)
 }
 #endif
 
-static inline u16 atl1c_tpd_avail(struct atl1c_adapter *adapter, enum atl1c_trans_queue type)
+static inline u16 atl1c_tpd_avail(struct atl1c_adapter *adapter, u32 queue)
 {
-	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[type];
+	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[queue];
 	u16 next_to_use = 0;
 	u16 next_to_clean = 0;
 
@@ -1962,9 +2033,9 @@ static inline u16 atl1c_tpd_avail(struct atl1c_adapter *adapter, enum atl1c_tran
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
 
@@ -2006,7 +2077,7 @@ static u16 atl1c_cal_tpd_req(const struct sk_buff *skb)
 static int atl1c_tso_csum(struct atl1c_adapter *adapter,
 			  struct sk_buff *skb,
 			  struct atl1c_tpd_desc **tpd,
-			  enum atl1c_trans_queue type)
+			  u32 queue)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	unsigned short offload_type;
@@ -2051,7 +2122,7 @@ static int atl1c_tso_csum(struct atl1c_adapter *adapter,
 				*(struct atl1c_tpd_ext_desc **)(tpd);
 
 			memset(etpd, 0, sizeof(struct atl1c_tpd_ext_desc));
-			*tpd = atl1c_get_tpd(adapter, type);
+			*tpd = atl1c_get_tpd(adapter, queue);
 			ipv6_hdr(skb)->payload_len = 0;
 			/* check payload == 0 byte ? */
 			hdr_len = (skb_transport_offset(skb) + tcp_hdrlen(skb));
@@ -2103,9 +2174,9 @@ static int atl1c_tso_csum(struct atl1c_adapter *adapter,
 
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
@@ -2124,8 +2195,8 @@ static void atl1c_tx_rollback(struct atl1c_adapter *adpt,
 }
 
 static int atl1c_tx_map(struct atl1c_adapter *adapter,
-		      struct sk_buff *skb, struct atl1c_tpd_desc *tpd,
-			enum atl1c_trans_queue type)
+			struct sk_buff *skb, struct atl1c_tpd_desc *tpd,
+			u32 queue)
 {
 	struct atl1c_tpd_desc *use_tpd = NULL;
 	struct atl1c_buffer *buffer_info = NULL;
@@ -2165,7 +2236,7 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 		if (mapped_len == 0)
 			use_tpd = tpd;
 		else {
-			use_tpd = atl1c_get_tpd(adapter, type);
+			use_tpd = atl1c_get_tpd(adapter, queue);
 			memcpy(use_tpd, tpd, sizeof(struct atl1c_tpd_desc));
 		}
 		buffer_info = atl1c_get_tx_buffer(adapter, use_tpd);
@@ -2187,7 +2258,7 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 	for (f = 0; f < nr_frags; f++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
-		use_tpd = atl1c_get_tpd(adapter, type);
+		use_tpd = atl1c_get_tpd(adapter, queue);
 		memcpy(use_tpd, tpd, sizeof(struct atl1c_tpd_desc));
 
 		buffer_info = atl1c_get_tx_buffer(adapter, use_tpd);
@@ -2220,23 +2291,22 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
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
-					  struct net_device *netdev)
+					struct net_device *netdev)
 {
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 	u16 tpd_req;
 	struct atl1c_tpd_desc *tpd;
-	enum atl1c_trans_queue type = atl1c_trans_normal;
+	u32 queue = skb_get_queue_mapping(skb);
+	struct netdev_queue *txq = netdev_get_tx_queue(netdev, queue);
 
 	if (test_bit(__AT_DOWN, &adapter->flags)) {
 		dev_kfree_skb_any(skb);
@@ -2245,18 +2315,18 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
 
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
@@ -2274,17 +2344,17 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
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
@@ -2338,16 +2408,19 @@ static int atl1c_request_irq(struct atl1c_adapter *adapter)
 
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
 
@@ -2361,20 +2434,24 @@ static int atl1c_up(struct atl1c_adapter *adapter)
 
 	atl1c_check_link_status(adapter);
 	clear_bit(__AT_DOWN, &adapter->flags);
-	napi_enable(&adapter->napi);
-	napi_enable(&adapter->tx_napi);
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
@@ -2382,8 +2459,10 @@ static void atl1c_down(struct atl1c_adapter *adapter)
 	 * reschedule our watchdog timer */
 	set_bit(__AT_DOWN, &adapter->flags);
 	netif_carrier_off(netdev);
-	napi_disable(&adapter->napi);
-	napi_disable(&adapter->tx_napi);
+	for (i = 0; i < adapter->tx_queue_count; ++i)
+		napi_disable(&adapter->tpd_ring[i].napi);
+	for (i = 0; i < adapter->rx_queue_count; ++i)
+		napi_disable(&adapter->rrd_ring[i].napi);
 	atl1c_irq_disable(adapter);
 	atl1c_free_irq(adapter);
 	/* disable ASPM if device inactive */
@@ -2568,8 +2647,11 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct net_device *netdev;
 	struct atl1c_adapter *adapter;
 	static int cards_found;
-
+	u8 __iomem *hw_addr;
+	enum atl1c_nic_type nic_type;
+	int i;
 	int err = 0;
+	u32 queue_count = 1;
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	err = pci_enable_device_mem(pdev);
@@ -2602,7 +2684,18 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	netdev = alloc_etherdev(sizeof(struct atl1c_adapter));
+	hw_addr = pci_ioremap_bar(pdev, 0);
+	if (!hw_addr) {
+		err = -EIO;
+		dev_err(&pdev->dev, "cannot map device registers\n");
+		goto err_ioremap;
+	}
+
+	nic_type = atl1c_get_mac_type(pdev, hw_addr);
+	if (nic_type == athr_mt)
+		queue_count = 4;
+
+	netdev = alloc_etherdev_mq(sizeof(struct atl1c_adapter), queue_count);
 	if (netdev == NULL) {
 		err = -ENOMEM;
 		goto err_alloc_etherdev;
@@ -2618,13 +2711,11 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
 	adapter->hw.adapter = adapter;
+	adapter->hw.nic_type = nic_type;
 	adapter->msg_enable = netif_msg_init(-1, atl1c_default_msg);
-	adapter->hw.hw_addr = ioremap(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
-	if (!adapter->hw.hw_addr) {
-		err = -EIO;
-		dev_err(&pdev->dev, "cannot map device registers\n");
-		goto err_ioremap;
-	}
+	adapter->hw.hw_addr = hw_addr;
+	adapter->tx_queue_count = queue_count;
+	adapter->rx_queue_count = queue_count;
 
 	/* init mii data */
 	adapter->mii.dev = netdev;
@@ -2633,8 +2724,14 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->mii.phy_id_mask = 0x1f;
 	adapter->mii.reg_num_mask = MDIO_CTRL_REG_MASK;
 	dev_set_threaded(netdev, true);
-	netif_napi_add(netdev, &adapter->napi, atl1c_clean, 64);
-	netif_napi_add(netdev, &adapter->tx_napi, atl1c_clean_tx, 64);
+	for (i = 0; i < adapter->rx_queue_count; ++i) {
+		netif_napi_add(netdev, &adapter->rrd_ring[i].napi,
+			       atl1c_clean_rx, 64);
+	}
+	for (i = 0; i < adapter->tx_queue_count; ++i) {
+		netif_napi_add(netdev, &adapter->tpd_ring[i].napi,
+			       atl1c_clean_tx, 64);
+	}
 	timer_setup(&adapter->phy_config_timer, atl1c_phy_config, 0);
 	/* setup the private structure */
 	err = atl1c_sw_init(adapter);
@@ -2687,11 +2784,11 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_reset:
 err_register:
 err_sw_init:
-	iounmap(adapter->hw.hw_addr);
 err_init_netdev:
-err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
+	iounmap(hw_addr);
+err_ioremap:
 	pci_release_regions(pdev);
 err_pci_reg:
 err_dma:

base-commit: 77091933e453a258bbe9ff2aeb1c8d6fc1db7ef9
-- 
2.31.1

