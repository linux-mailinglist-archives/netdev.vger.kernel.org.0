Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1949635FB5A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbhDNTKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 15:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbhDNTJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:09:58 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAE1C061574;
        Wed, 14 Apr 2021 12:09:35 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lWktD-0000fQ-BW; Wed, 14 Apr 2021 22:09:27 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next v6] atl1c: move tx cleanup processing out of interrupt
Date:   Wed, 14 Apr 2021 22:09:20 +0300
Message-Id: <20210414190920.2516572-1-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tx queue cleanup happens in interrupt handler on same core as rx queue
processing. Both can take considerable amount of processing in high
packet-per-second scenarios.

Sending big amounts of packets can stall the rx processing which is
unfair and also can lead to out-of-memory condition since
__dev_kfree_skb_irq queues the skbs for later kfree in softirq which
is not allowed to happen with heavy load in interrupt handler.

This puts tx cleanup in its own napi and enables threaded napi to
allow the rx/tx queue processing to happen on different cores.

The ability to sustain equal amounts of tx/rx traffic increased:
from 280Kpps to 1130Kpps on Threadripper 3960X with upcoming
Mikrotik 10/25G NIC,
from 520Kpps to 850Kpps on Intel i3-3320 with Mikrotik RB44Ge adapter.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
v6:
    - sent with git send-email
v5:
    - EXPORT_SYMBOL(dev_set_threaded) not needed, already there
v4:
    - made scripts/checkpatch.pl happy
    - moved the new intr_mask_lock to be besides the intr_mask it
      protects so they are more likely to be on same cacheline
v3:
    - addressed comments from Eric Dumazet
    - added EXPORT_SYMBOL for dev_set_threaded

 drivers/net/ethernet/atheros/atl1c/atl1c.h    |  2 +
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 44 ++++++++++++++-----
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index a0562a90fb6d..28ae5c16831e 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -367,6 +367,7 @@ struct atl1c_hw {
 	u16 phy_id1;
 	u16 phy_id2;
 
+	spinlock_t intr_mask_lock;	/* protect the intr_mask */
 	u32 intr_mask;
 
 	u8 preamble_len;
@@ -506,6 +507,7 @@ struct atl1c_adapter {
 	struct net_device   *netdev;
 	struct pci_dev      *pdev;
 	struct napi_struct  napi;
+	struct napi_struct  tx_napi;
 	struct page         *rx_page;
 	unsigned int	    rx_page_offset;
 	unsigned int	    rx_frag_size;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index d54375b255dc..1d17c24e6d75 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -813,6 +813,7 @@ static int atl1c_sw_init(struct atl1c_adapter *adapter)
 	atl1c_set_rxbufsize(adapter, adapter->netdev);
 	atomic_set(&adapter->irq_sem, 1);
 	spin_lock_init(&adapter->mdio_lock);
+	spin_lock_init(&adapter->hw.intr_mask_lock);
 	set_bit(__AT_DOWN, &adapter->flags);
 
 	return 0;
@@ -1530,20 +1531,19 @@ static inline void atl1c_clear_phy_int(struct atl1c_adapter *adapter)
 	spin_unlock(&adapter->mdio_lock);
 }
 
-static bool atl1c_clean_tx_irq(struct atl1c_adapter *adapter,
-				enum atl1c_trans_queue type)
+static int atl1c_clean_tx(struct napi_struct *napi, int budget)
 {
-	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[type];
+	struct atl1c_adapter *adapter =
+		container_of(napi, struct atl1c_adapter, tx_napi);
+	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[atl1c_trans_normal];
 	struct atl1c_buffer *buffer_info;
 	struct pci_dev *pdev = adapter->pdev;
 	u16 next_to_clean = atomic_read(&tpd_ring->next_to_clean);
 	u16 hw_next_to_clean;
-	u16 reg;
 	unsigned int total_bytes = 0, total_packets = 0;
+	unsigned long flags;
 
-	reg = type == atl1c_trans_high ? REG_TPD_PRI1_CIDX : REG_TPD_PRI0_CIDX;
-
-	AT_READ_REGW(&adapter->hw, reg, &hw_next_to_clean);
+	AT_READ_REGW(&adapter->hw, REG_TPD_PRI0_CIDX, &hw_next_to_clean);
 
 	while (next_to_clean != hw_next_to_clean) {
 		buffer_info = &tpd_ring->buffer_info[next_to_clean];
@@ -1564,7 +1564,15 @@ static bool atl1c_clean_tx_irq(struct atl1c_adapter *adapter,
 		netif_wake_queue(adapter->netdev);
 	}
 
-	return true;
+	if (total_packets < budget) {
+		napi_complete_done(napi, total_packets);
+		spin_lock_irqsave(&adapter->hw.intr_mask_lock, flags);
+		adapter->hw.intr_mask |= ISR_TX_PKT;
+		AT_WRITE_REG(&adapter->hw, REG_IMR, adapter->hw.intr_mask);
+		spin_unlock_irqrestore(&adapter->hw.intr_mask_lock, flags);
+		return total_packets;
+	}
+	return budget;
 }
 
 /**
@@ -1599,13 +1607,22 @@ static irqreturn_t atl1c_intr(int irq, void *data)
 		AT_WRITE_REG(hw, REG_ISR, status | ISR_DIS_INT);
 		if (status & ISR_RX_PKT) {
 			if (likely(napi_schedule_prep(&adapter->napi))) {
+				spin_lock(&hw->intr_mask_lock);
 				hw->intr_mask &= ~ISR_RX_PKT;
 				AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
+				spin_unlock(&hw->intr_mask_lock);
 				__napi_schedule(&adapter->napi);
 			}
 		}
-		if (status & ISR_TX_PKT)
-			atl1c_clean_tx_irq(adapter, atl1c_trans_normal);
+		if (status & ISR_TX_PKT) {
+			if (napi_schedule_prep(&adapter->tx_napi)) {
+				spin_lock(&hw->intr_mask_lock);
+				hw->intr_mask &= ~ISR_TX_PKT;
+				AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
+				spin_unlock(&hw->intr_mask_lock);
+				__napi_schedule(&adapter->tx_napi);
+			}
+		}
 
 		handled = IRQ_HANDLED;
 		/* check if PCIE PHY Link down */
@@ -1876,6 +1893,7 @@ static int atl1c_clean(struct napi_struct *napi, int budget)
 	struct atl1c_adapter *adapter =
 			container_of(napi, struct atl1c_adapter, napi);
 	int work_done = 0;
+	unsigned long flags;
 
 	/* Keep link state information with original netdev */
 	if (!netif_carrier_ok(adapter->netdev))
@@ -1886,8 +1904,10 @@ static int atl1c_clean(struct napi_struct *napi, int budget)
 	if (work_done < budget) {
 quit_polling:
 		napi_complete_done(napi, work_done);
+		spin_lock_irqsave(&adapter->hw.intr_mask_lock, flags);
 		adapter->hw.intr_mask |= ISR_RX_PKT;
 		AT_WRITE_REG(&adapter->hw, REG_IMR, adapter->hw.intr_mask);
+		spin_unlock_irqrestore(&adapter->hw.intr_mask_lock, flags);
 	}
 	return work_done;
 }
@@ -2325,6 +2345,7 @@ static int atl1c_up(struct atl1c_adapter *adapter)
 	atl1c_check_link_status(adapter);
 	clear_bit(__AT_DOWN, &adapter->flags);
 	napi_enable(&adapter->napi);
+	napi_enable(&adapter->tx_napi);
 	atl1c_irq_enable(adapter);
 	netif_start_queue(netdev);
 	return err;
@@ -2345,6 +2366,7 @@ static void atl1c_down(struct atl1c_adapter *adapter)
 	set_bit(__AT_DOWN, &adapter->flags);
 	netif_carrier_off(netdev);
 	napi_disable(&adapter->napi);
+	napi_disable(&adapter->tx_napi);
 	atl1c_irq_disable(adapter);
 	atl1c_free_irq(adapter);
 	/* disable ASPM if device inactive */
@@ -2593,7 +2615,9 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->mii.mdio_write = atl1c_mdio_write;
 	adapter->mii.phy_id_mask = 0x1f;
 	adapter->mii.reg_num_mask = MDIO_CTRL_REG_MASK;
+	dev_set_threaded(netdev, true);
 	netif_napi_add(netdev, &adapter->napi, atl1c_clean, 64);
+	netif_napi_add(netdev, &adapter->tx_napi, atl1c_clean_tx, 64);
 	timer_setup(&adapter->phy_config_timer, atl1c_phy_config, 0);
 	/* setup the private structure */
 	err = atl1c_sw_init(adapter);

base-commit: 5871d0c6b8ea805916c3135d0c53b095315bc674
-- 
2.31.1

