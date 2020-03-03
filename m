Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E78B177CC5
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgCCRGI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 Mar 2020 12:06:08 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:21486 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729301AbgCCRGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:06:08 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-95-M4Bb0UrWMk-MXoTJkpGRfw-1; Tue, 03 Mar 2020 17:06:03 +0000
X-MC-Unique: M4Bb0UrWMk-MXoTJkpGRfw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 3 Mar 2020 17:06:03 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 3 Mar 2020 17:06:03 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     Network Development <netdev@vger.kernel.org>
CC:     "'bruce.w.allan@intel.com'" <bruce.w.allan@intel.com>,
        "'jeffrey.e.pieper@intel.com'" <jeffrey.e.pieper@intel.com>,
        "'jeffrey.t.kirsher@intel.com'" <jeffrey.t.kirsher@intel.com>
Subject: [PATCH net 1/1] e1000e: Stop tx/rx setup spinning for upwards of
 300us.
Thread-Topic: [PATCH net 1/1] e1000e: Stop tx/rx setup spinning for upwards of
 300us.
Thread-Index: AdXxfY9+FmJkPOq/QT2LrEdhM24vhg==
Date:   Tue, 3 Mar 2020 17:06:03 +0000
Message-ID: <6ef1e257642743a786c8ddd39645bba3@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Instead of spinning waiting for the ME to be idle defer the ring
tail updates until one of the following:
- The next update for that ring.
- The receive frame processing.
- The next timer tick.

Reduce the delay between checks for the ME being idle from 50us
to uus.

Part fix for bdc125f7.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 This change probably applies as back as far as 3.16.

 drivers/net/ethernet/intel/e1000e/e1000.h   |   3 +
 drivers/net/ethernet/intel/e1000e/ich8lan.h |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c  | 131 ++++++++++++++++++++--------
 3 files changed, 99 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 6c51b1b..c7819e0 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -155,6 +155,8 @@ struct e1000_ring {
 
 	u16 next_to_use;
 	u16 next_to_clean;
+#define E1000_RING_NOT_DEFERRED 0xffff
+	u16 next_to_use_deferred;
 
 	void __iomem *head;
 	void __iomem *tail;
@@ -190,6 +192,7 @@ struct e1000_adapter {
 
 	struct work_struct reset_task;
 	struct delayed_work watchdog_task;
+	struct delayed_work delay_ring_write_task;
 
 	struct workqueue_struct *e1000_workqueue;
 
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 1502895..75e5a53 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -34,7 +34,7 @@
 /* FW established a valid mode */
 #define E1000_ICH_FWSM_FW_VALID	0x00008000
 #define E1000_ICH_FWSM_PCIM2PCI	0x01000000	/* ME PCIm-to-PCI active */
-#define E1000_ICH_FWSM_PCIM2PCI_COUNT	2000
+#define E1000_ICH_FWSM_PCIM2PCI_COUNT	20000
 
 #define E1000_ICH_MNG_IAMT_MODE		0x2
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index d7d56e4..299e5af 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -118,13 +118,20 @@ struct e1000_reg_info {
  * an incorrect value.  Workaround this by checking the FWSM register which
  * has bit 24 set while ME is accessing MAC CSR registers, wait if it is set
  * and try again a number of times.
+ * NB: This bit can stay set for 300us even if polled every 5us.
  **/
+
+static bool __ew32_prepare_busy(struct e1000_hw *hw)
+{
+	return (er32(FWSM) & E1000_ICH_FWSM_PCIM2PCI);
+}
+
 s32 __ew32_prepare(struct e1000_hw *hw)
 {
 	s32 i = E1000_ICH_FWSM_PCIM2PCI_COUNT;
 
-	while ((er32(FWSM) & E1000_ICH_FWSM_PCIM2PCI) && --i)
-		udelay(50);
+	while (__ew32_prepare_busy(hw) && --i)
+		udelay(5);
 
 	return i;
 }
@@ -603,38 +610,75 @@ static void e1000_rx_checksum(struct e1000_adapter *adapter, u32 status_err,
 	adapter->hw_csum_good++;
 }
 
-static void e1000e_update_rdt_wa(struct e1000_ring *rx_ring, unsigned int i)
+static bool deferred_update_dt_wa(struct e1000_ring *ring)
 {
-	struct e1000_adapter *adapter = rx_ring->adapter;
-	struct e1000_hw *hw = &adapter->hw;
-	s32 ret_val = __ew32_prepare(hw);
-
-	writel(i, rx_ring->tail);
+	struct e1000_adapter *adapter;
+	struct e1000_hw *hw;
+	unsigned long flags;
+	u32 deferred;
 
-	if (unlikely(!ret_val && (i != readl(rx_ring->tail)))) {
-		u32 rctl = er32(RCTL);
+	adapter = ring->adapter;
+	hw = &adapter->hw;
+	spin_lock_irqsave(&adapter->systim_lock, flags);
+	deferred = ring->next_to_use_deferred;
+	if (deferred != E1000_RING_NOT_DEFERRED) {
+		if (__ew32_prepare_busy(hw)) {
+			spin_unlock_irqrestore(&adapter->systim_lock, flags);
+			/* Caller needs to ensure timer running */
+			return true;
+		}
 
-		ew32(RCTL, rctl & ~E1000_RCTL_EN);
-		e_err("ME firmware caused invalid RDT - resetting\n");
-		schedule_work(&adapter->reset_task);
+		writel(deferred, ring->tail);
+		ring->next_to_use_deferred = E1000_RING_NOT_DEFERRED;
 	}
+	spin_unlock_irqrestore(&adapter->systim_lock, flags);
+	return false;
 }
 
-static void e1000e_update_tdt_wa(struct e1000_ring *tx_ring, unsigned int i)
+/* Inline the cheap unlocked test */
+#define e1000e_deferred_update_dt_wa(ring) \
+	(likely(READ_ONCE(ring->next_to_use_deferred) == \
+	        E1000_RING_NOT_DEFERRED) ? false : \
+					   deferred_update_dt_wa(ring))
+
+static void e1000e_delay_ring_write_task(struct work_struct *work)
 {
-	struct e1000_adapter *adapter = tx_ring->adapter;
-	struct e1000_hw *hw = &adapter->hw;
-	s32 ret_val = __ew32_prepare(hw);
+	struct e1000_adapter *adapter;
 
-	writel(i, tx_ring->tail);
+	adapter = container_of(work, struct e1000_adapter,
+			       delay_ring_write_task.work);
 
-	if (unlikely(!ret_val && (i != readl(tx_ring->tail)))) {
-		u32 tctl = er32(TCTL);
+	if (e1000e_deferred_update_dt_wa(adapter->tx_ring) |
+	    e1000e_deferred_update_dt_wa(adapter->rx_ring))
+		mod_delayed_work(adapter->e1000_workqueue,
+			 &adapter->delay_ring_write_task, 1);
+}
 
-		ew32(TCTL, tctl & ~E1000_TCTL_EN);
-		e_err("ME firmware caused invalid TDT - resetting\n");
-		schedule_work(&adapter->reset_task);
+static void e1000e_update_dt_wa(struct e1000_ring *ring, unsigned int i)
+{
+	struct e1000_adapter *adapter = ring->adapter;
+	struct e1000_hw *hw = &adapter->hw;
+	unsigned long flags;
+	u32 deferred;
+
+	deferred = READ_ONCE(ring->next_to_use_deferred);
+	if (unlikely(deferred != E1000_RING_NOT_DEFERRED)) {
+		/* previous write was deferred - forget about it */
+		spin_lock_irqsave(&adapter->systim_lock, flags);
+		ring->next_to_use_deferred = E1000_RING_NOT_DEFERRED;
+		spin_unlock_irqrestore(&adapter->systim_lock, flags);
+	}
+
+	if (!__ew32_prepare_busy(hw)) {
+		writel(i, ring->tail);
+		return;
 	}
+
+	/* We can't write now, defer to rx clean or timeout */
+	WRITE_ONCE(ring->next_to_use_deferred, i);
+
+	mod_delayed_work(adapter->e1000_workqueue,
+			 &adapter->delay_ring_write_task, 1);
 }
 
 /**
@@ -692,7 +736,7 @@ static void e1000_alloc_rx_buffers(struct e1000_ring *rx_ring,
 			 */
 			wmb();
 			if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA)
-				e1000e_update_rdt_wa(rx_ring, i);
+				e1000e_update_dt_wa(rx_ring, i);
 			else
 				writel(i, rx_ring->tail);
 		}
@@ -792,7 +836,7 @@ static void e1000_alloc_rx_buffers_ps(struct e1000_ring *rx_ring,
 			 */
 			wmb();
 			if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA)
-				e1000e_update_rdt_wa(rx_ring, i << 1);
+				e1000e_update_dt_wa(rx_ring, i << 1);
 			else
 				writel(i << 1, rx_ring->tail);
 		}
@@ -884,7 +928,7 @@ static void e1000_alloc_jumbo_rx_buffers(struct e1000_ring *rx_ring,
 		 */
 		wmb();
 		if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA)
-			e1000e_update_rdt_wa(rx_ring, i);
+			e1000e_update_dt_wa(rx_ring, i);
 		else
 			writel(i, rx_ring->tail);
 	}
@@ -1256,6 +1300,8 @@ static bool e1000_clean_tx_irq(struct e1000_ring *tx_ring)
 
 	tx_ring->next_to_clean = i;
 
+	e1000e_deferred_update_dt_wa(tx_ring);
+
 	netdev_completed_queue(netdev, pkts_compl, bytes_compl);
 
 #define TX_WAKE_THRESHOLD 32
@@ -1729,6 +1775,7 @@ static void e1000_clean_rx_ring(struct e1000_ring *rx_ring)
 
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
+	rx_ring->next_to_use_deferred = E1000_RING_NOT_DEFERRED;
 	adapter->flags2 &= ~FLAG2_IS_DISCARDING;
 }
 
@@ -2342,6 +2389,7 @@ int e1000e_setup_tx_resources(struct e1000_ring *tx_ring)
 
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
+	tx_ring->next_to_use_deferred = E1000_RING_NOT_DEFERRED;
 
 	return 0;
 err:
@@ -2388,6 +2436,7 @@ int e1000e_setup_rx_resources(struct e1000_ring *rx_ring)
 
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
+	rx_ring->next_to_use_deferred = E1000_RING_NOT_DEFERRED;
 	rx_ring->rx_skb_top = NULL;
 
 	return 0;
@@ -2427,6 +2476,7 @@ static void e1000_clean_tx_ring(struct e1000_ring *tx_ring)
 
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
+	tx_ring->next_to_use_deferred = E1000_RING_NOT_DEFERRED;
 }
 
 /**
@@ -2666,6 +2716,9 @@ static int e1000e_poll(struct napi_struct *napi, int budget)
 
 	adapter = netdev_priv(poll_dev);
 
+	e1000e_deferred_update_dt_wa(adapter->tx_ring);
+	e1000e_deferred_update_dt_wa(adapter->rx_ring);
+
 	if (!adapter->msix_entries ||
 	    (adapter->rx_ring->ims_val & adapter->tx_ring->ims_val))
 		tx_cleaned = e1000_clean_tx_irq(adapter->tx_ring);
@@ -2930,10 +2983,11 @@ static void e1000_configure_tx(struct e1000_adapter *adapter)
 	tx_ring->tail = adapter->hw.hw_addr + E1000_TDT(0);
 
 	writel(0, tx_ring->head);
-	if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA)
-		e1000e_update_tdt_wa(tx_ring, 0);
-	else
-		writel(0, tx_ring->tail);
+	if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA) {
+		while (__ew32_prepare_busy(hw))
+			usleep_range(50, 100);
+	}
+	writel(0, tx_ring->tail);
 
 	/* Set the Tx Interrupt Delay register */
 	ew32(TIDV, adapter->tx_int_delay);
@@ -3254,10 +3308,11 @@ static void e1000_configure_rx(struct e1000_adapter *adapter)
 	rx_ring->tail = adapter->hw.hw_addr + E1000_RDT(0);
 
 	writel(0, rx_ring->head);
-	if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA)
-		e1000e_update_rdt_wa(rx_ring, 0);
-	else
-		writel(0, rx_ring->tail);
+	if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA) {
+		while (__ew32_prepare_busy(hw))
+			usleep_range(50, 100);
+	}
+	writel(0, rx_ring->tail);
 
 	/* Enable Receive Checksum Offload for TCP and UDP */
 	rxcsum = er32(RXCSUM);
@@ -5908,8 +5963,8 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 		if (!netdev_xmit_more() ||
 		    netif_xmit_stopped(netdev_get_tx_queue(netdev, 0))) {
 			if (adapter->flags2 & FLAG2_PCIM2PCI_ARBITER_WA)
-				e1000e_update_tdt_wa(tx_ring,
-						     tx_ring->next_to_use);
+				e1000e_update_dt_wa(tx_ring,
+						    tx_ring->next_to_use);
 			else
 				writel(tx_ring->next_to_use, tx_ring->tail);
 		}
@@ -7271,6 +7326,9 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	queue_delayed_work(adapter->e1000_workqueue, &adapter->watchdog_task,
 			   0);
 
+	INIT_DELAYED_WORK(&adapter->delay_ring_write_task,
+			  e1000e_delay_ring_write_task);
+
 	timer_setup(&adapter->phy_info_timer, e1000_update_phy_info, 0);
 
 	INIT_WORK(&adapter->reset_task, e1000_reset_task);
@@ -7424,6 +7482,7 @@ static void e1000_remove(struct pci_dev *pdev)
 	cancel_work_sync(&adapter->print_hang_task);
 
 	cancel_delayed_work(&adapter->watchdog_task);
+	cancel_delayed_work(&adapter->delay_ring_write_task);
 	flush_workqueue(adapter->e1000_workqueue);
 	destroy_workqueue(adapter->e1000_workqueue);
 
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

