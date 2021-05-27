Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19BE39313B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbhE0OqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236557AbhE0OqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 10:46:07 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021FFC061760;
        Thu, 27 May 2021 07:44:33 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lmHFM-0002jz-8b; Thu, 27 May 2021 17:44:28 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next v4 3/4] atl1c: prepare for multiple rx queues
Date:   Thu, 27 May 2021 17:44:22 +0300
Message-Id: <20210527144423.3395719-4-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527144423.3395719-1-gatis@mikrotik.com>
References: <20210527144423.3395719-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move napi and other per queue members into per rx queue struct.
Allocate max rx queues that any hw supported by the driver might have.
Patch that actually enables multiple rx queues will follow.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c.h    |  12 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 106 +++++++++---------
 2 files changed, 57 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index 2c8b72a7db03..9edf90e1f028 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -500,21 +500,23 @@ struct atl1c_rfd_ring {
 
 /* receive return descriptor (rrd) ring */
 struct atl1c_rrd_ring {
+	struct atl1c_adapter *adapter;
 	void *desc;		/* descriptor ring virtual address */
 	dma_addr_t dma;		/* descriptor ring physical address */
+	u16 num;
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
-	struct page         *rx_page;
-	unsigned int	    rx_page_offset;
 	unsigned int	    rx_frag_size;
 	struct atl1c_hw        hw;
 	struct atl1c_hw_stats  hw_stats;
@@ -545,8 +547,8 @@ struct atl1c_adapter {
 	/* All Descriptor memory */
 	struct atl1c_ring_header ring_header;
 	struct atl1c_tpd_ring tpd_ring[AT_MAX_TRANSMIT_QUEUE];
-	struct atl1c_rfd_ring rfd_ring;
-	struct atl1c_rrd_ring rrd_ring;
+	struct atl1c_rfd_ring rfd_ring[AT_MAX_RECEIVE_QUEUE];
+	struct atl1c_rrd_ring rrd_ring[AT_MAX_RECEIVE_QUEUE];
 	u32 bd_number;     /* board number;*/
 };
 
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index db60c1f706ae..79984735a2fd 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -40,8 +40,6 @@ static int atl1c_stop_mac(struct atl1c_hw *hw);
 static void atl1c_disable_l0s_l1(struct atl1c_hw *hw);
 static void atl1c_set_aspm(struct atl1c_hw *hw, u16 link_speed);
 static void atl1c_start_mac(struct atl1c_adapter *adapter);
-static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
-		   int *work_done, int work_to_do);
 static int atl1c_up(struct atl1c_adapter *adapter);
 static void atl1c_down(struct atl1c_adapter *adapter);
 static int atl1c_reset_mac(struct atl1c_hw *hw);
@@ -770,7 +768,7 @@ static int atl1c_sw_init(struct atl1c_adapter *adapter)
 	adapter->link_speed = SPEED_0;
 	adapter->link_duplex = FULL_DUPLEX;
 	adapter->tpd_ring[0].count = 1024;
-	adapter->rfd_ring.count = 512;
+	adapter->rfd_ring[0].count = 512;
 
 	hw->vendor_id = pdev->vendor;
 	hw->device_id = pdev->device;
@@ -878,8 +876,8 @@ static void atl1c_clean_tx_ring(struct atl1c_adapter *adapter,
  */
 static void atl1c_clean_rx_ring(struct atl1c_adapter *adapter)
 {
-	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
-	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring;
+	struct atl1c_rfd_ring *rfd_ring = adapter->rfd_ring;
+	struct atl1c_rrd_ring *rrd_ring = adapter->rrd_ring;
 	struct atl1c_buffer *buffer_info;
 	struct pci_dev *pdev = adapter->pdev;
 	int j;
@@ -902,8 +900,8 @@ static void atl1c_clean_rx_ring(struct atl1c_adapter *adapter)
 static void atl1c_init_ring_ptrs(struct atl1c_adapter *adapter)
 {
 	struct atl1c_tpd_ring *tpd_ring = adapter->tpd_ring;
-	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
-	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring;
+	struct atl1c_rfd_ring *rfd_ring = adapter->rfd_ring;
+	struct atl1c_rrd_ring *rrd_ring = adapter->rrd_ring;
 	struct atl1c_buffer *buffer_info;
 	int i, j;
 
@@ -945,9 +943,9 @@ static void atl1c_free_ring_resources(struct atl1c_adapter *adapter)
 		kfree(adapter->tpd_ring[0].buffer_info);
 		adapter->tpd_ring[0].buffer_info = NULL;
 	}
-	if (adapter->rx_page) {
-		put_page(adapter->rx_page);
-		adapter->rx_page = NULL;
+	if (adapter->rrd_ring[0].rx_page) {
+		put_page(adapter->rrd_ring[0].rx_page);
+		adapter->rrd_ring[0].rx_page = NULL;
 	}
 }
 
@@ -961,8 +959,8 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
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
@@ -1030,6 +1028,8 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
 	offset += roundup(rfd_ring->size, 8);
 
 	/* init RRD ring */
+	rrd_ring->adapter = adapter;
+	rrd_ring->num = 0;
 	rrd_ring->dma = ring_header->dma + offset;
 	rrd_ring->desc = (u8 *) ring_header->desc + offset;
 	rrd_ring->size = sizeof(struct atl1c_recv_ret_status) *
@@ -1046,10 +1046,9 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
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
 
 	/* TPD */
 	AT_WRITE_REG(hw, REG_TX_BASE_ADDR_HI,
@@ -1608,12 +1607,12 @@ static irqreturn_t atl1c_intr(int irq, void *data)
 		/* Ack ISR */
 		AT_WRITE_REG(hw, REG_ISR, status | ISR_DIS_INT);
 		if (status & ISR_RX_PKT) {
-			if (likely(napi_schedule_prep(&adapter->napi))) {
+			if (napi_schedule_prep(&adapter->rrd_ring[0].napi)) {
 				spin_lock(&hw->intr_mask_lock);
 				hw->intr_mask &= ~ISR_RX_PKT;
 				AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
 				spin_unlock(&hw->intr_mask_lock);
-				__napi_schedule(&adapter->napi);
+				__napi_schedule(&adapter->rrd_ring[0].napi);
 			}
 		}
 		if (status & ISR_TX_PKT) {
@@ -1677,33 +1676,35 @@ static inline void atl1c_rx_checksum(struct atl1c_adapter *adapter,
 static struct sk_buff *atl1c_alloc_skb(struct atl1c_adapter *adapter,
 				       bool napi_mode)
 {
+	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring[0];
 	struct sk_buff *skb;
 	struct page *page;
 
 	if (adapter->rx_frag_size > PAGE_SIZE) {
 		if (likely(napi_mode))
-			return napi_alloc_skb(&adapter->napi,
+			return napi_alloc_skb(&rrd_ring->napi,
 					      adapter->rx_buffer_len);
 		else
 			return netdev_alloc_skb_ip_align(adapter->netdev,
 							 adapter->rx_buffer_len);
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
@@ -1712,7 +1713,7 @@ static struct sk_buff *atl1c_alloc_skb(struct atl1c_adapter *adapter,
 
 static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, bool napi_mode)
 {
-	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
+	struct atl1c_rfd_ring *rfd_ring = adapter->rfd_ring;
 	struct pci_dev *pdev = adapter->pdev;
 	struct atl1c_buffer *buffer_info, *next_info;
 	struct sk_buff *skb;
@@ -1812,22 +1813,34 @@ static void atl1c_clean_rfd(struct atl1c_rfd_ring *rfd_ring,
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
 	u16 rfd_num, rfd_index;
 	u16 count = 0;
 	u16 length;
 	struct pci_dev *pdev = adapter->pdev;
 	struct net_device *netdev  = adapter->netdev;
-	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
-	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring;
+	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring[rrd_ring->num];
 	struct sk_buff *skb;
 	struct atl1c_recv_ret_status *rrs;
 	struct atl1c_buffer *buffer_info;
+	int work_done = 0;
+	unsigned long flags;
+
+	/* Keep link state information with original netdev */
+	if (!netif_carrier_ok(adapter->netdev))
+		goto quit_polling;
 
 	while (1) {
-		if (*work_done >= work_to_do)
+		if (work_done >= budget)
 			break;
 		rrs = ATL1C_RRD_DESC(rrd_ring, rrd_ring->next_to_clean);
 		if (likely(RRS_RXD_IS_VALID(rrs->word3))) {
@@ -1881,32 +1894,13 @@ static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
 			vlan = le16_to_cpu(vlan);
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan);
 		}
-		napi_gro_receive(&adapter->napi, skb);
+		napi_gro_receive(napi, skb);
 
-		(*work_done)++;
+		work_done++;
 		count++;
 	}
 	if (count)
 		atl1c_alloc_rx_buffer(adapter, true);
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
 
 	if (work_done < budget) {
 quit_polling:
@@ -2355,7 +2349,7 @@ static int atl1c_up(struct atl1c_adapter *adapter)
 
 	atl1c_check_link_status(adapter);
 	clear_bit(__AT_DOWN, &adapter->flags);
-	napi_enable(&adapter->napi);
+	napi_enable(&adapter->rrd_ring[0].napi);
 	napi_enable(&adapter->tpd_ring[0].napi);
 	atl1c_irq_enable(adapter);
 	netif_start_queue(netdev);
@@ -2376,7 +2370,7 @@ static void atl1c_down(struct atl1c_adapter *adapter)
 	 * reschedule our watchdog timer */
 	set_bit(__AT_DOWN, &adapter->flags);
 	netif_carrier_off(netdev);
-	napi_disable(&adapter->napi);
+	napi_disable(&adapter->rrd_ring[0].napi);
 	napi_disable(&adapter->tpd_ring[0].napi);
 	atl1c_irq_disable(adapter);
 	atl1c_free_irq(adapter);
@@ -2633,7 +2627,7 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->mii.phy_id_mask = 0x1f;
 	adapter->mii.reg_num_mask = MDIO_CTRL_REG_MASK;
 	dev_set_threaded(netdev, true);
-	netif_napi_add(netdev, &adapter->napi, atl1c_clean, 64);
+	netif_napi_add(netdev, &adapter->rrd_ring[0].napi, atl1c_clean_rx, 64);
 	netif_napi_add(netdev, &adapter->tpd_ring[0].napi, atl1c_clean_tx, 64);
 	timer_setup(&adapter->phy_config_timer, atl1c_phy_config, 0);
 	/* setup the private structure */
-- 
2.31.1

