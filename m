Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB63351F7C
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbhDATTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbhDATTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:19:25 -0400
X-Greylist: delayed 2182 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Apr 2021 11:08:54 PDT
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7304EC02FEBF;
        Thu,  1 Apr 2021 11:08:54 -0700 (PDT)
Received: from localhost ([127.0.0.1] helo=bute.mt.lv)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lS1B9-0005Pd-IB; Thu, 01 Apr 2021 20:32:23 +0300
MIME-Version: 1.0
Date:   Thu, 01 Apr 2021 20:32:23 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] atl1c: move tx cleanup processing out of interrupt
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <a5f7c8ea7e090921da7e8f3d4680e4c3@mikrotik.com>
X-Sender: gatis@mikrotik.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tx queue cleanup happens in interrupt handler on same core as rx queue 
processing.
Both can take considerable amount of processing in high 
packet-per-second scenarios.

Sending big amounts of packets can stall the rx processing which is 
unfair
and also can lead to to out-of-memory condition since 
__dev_kfree_skb_irq
queues the skbs for later kfree in softirq which is not allowed to 
happen
with heavy load in interrupt handler.

This puts tx cleanup in its own napi to be executed on different core 
than rx
cleanup which solves the mentioned problems and increases the 
throughput.

The ability to sustain equal amounts of tx/rx traffic increased:
from 280Kpps to 1130Kpps on Threadripper 3960X with upcoming Mikrotik 
10/25G NIC,
from 520Kpps to 850Kpps on Intel i3-3320 with Mikrotik RB44Ge adapter.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
  drivers/net/ethernet/atheros/atl1c/atl1c.h    |  3 ++
  .../net/ethernet/atheros/atl1c/atl1c_main.c   | 52 +++++++++++++++++--
  2 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h 
b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index a0562a90fb6d..3c3c5268bab4 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -506,6 +506,8 @@ struct atl1c_adapter {
  	struct net_device   *netdev;
  	struct pci_dev      *pdev;
  	struct napi_struct  napi;
+	struct napi_struct  tx_napi;
+	call_single_data_t  csd;
  	struct page         *rx_page;
  	unsigned int	    rx_page_offset;
  	unsigned int	    rx_frag_size;
@@ -529,6 +531,7 @@ struct atl1c_adapter {
  	u16 link_duplex;

  	spinlock_t mdio_lock;
+	spinlock_t irq_mask_lock;
  	atomic_t irq_sem;

  	struct work_struct common_task;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c 
b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 3f65f2b370c5..0b88cbdbfa7c 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -813,6 +813,7 @@ static int atl1c_sw_init(struct atl1c_adapter 
*adapter)
  	atl1c_set_rxbufsize(adapter, adapter->netdev);
  	atomic_set(&adapter->irq_sem, 1);
  	spin_lock_init(&adapter->mdio_lock);
+	spin_lock_init(&adapter->irq_mask_lock);
  	set_bit(__AT_DOWN, &adapter->flags);

  	return 0;
@@ -1530,7 +1531,7 @@ static inline void atl1c_clear_phy_int(struct 
atl1c_adapter *adapter)
  	spin_unlock(&adapter->mdio_lock);
  }

-static bool atl1c_clean_tx_irq(struct atl1c_adapter *adapter,
+static unsigned atl1c_clean_tx_irq(struct atl1c_adapter *adapter,
  				enum atl1c_trans_queue type)
  {
  	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[type];
@@ -1564,7 +1565,31 @@ static bool atl1c_clean_tx_irq(struct 
atl1c_adapter *adapter,
  		netif_wake_queue(adapter->netdev);
  	}

-	return true;
+	return total_packets;
+}
+
+static void atl1c_schedule_tx_napi(void *data)
+{
+	struct atl1c_adapter *adapter = data;
+	__napi_schedule(&adapter->tx_napi);
+}
+
+static int atl1c_clean_tx(struct napi_struct *napi, int budget)
+{
+	struct atl1c_adapter *adapter =
+		container_of(napi, struct atl1c_adapter, tx_napi);
+	unsigned long flags;
+	int work_done = atl1c_clean_tx_irq(adapter, atl1c_trans_normal);
+
+	if (work_done < budget) {
+		napi_complete_done(napi, work_done);
+		spin_lock_irqsave(&adapter->irq_mask_lock, flags);
+		adapter->hw.intr_mask |= ISR_TX_PKT;
+		AT_WRITE_REG(&adapter->hw, REG_IMR, adapter->hw.intr_mask);
+		spin_unlock_irqrestore(&adapter->irq_mask_lock, flags);
+		return work_done;
+	}
+	return budget;
  }

  /**
@@ -1599,13 +1624,25 @@ static irqreturn_t atl1c_intr(int irq, void 
*data)
  		AT_WRITE_REG(hw, REG_ISR, status | ISR_DIS_INT);
  		if (status & ISR_RX_PKT) {
  			if (likely(napi_schedule_prep(&adapter->napi))) {
+				spin_lock(&adapter->irq_mask_lock);
  				hw->intr_mask &= ~ISR_RX_PKT;
  				AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
+				spin_unlock(&adapter->irq_mask_lock);
  				__napi_schedule(&adapter->napi);
  			}
  		}
-		if (status & ISR_TX_PKT)
-			atl1c_clean_tx_irq(adapter, atl1c_trans_normal);
+		if (status & ISR_TX_PKT) {
+			if (napi_schedule_prep(&adapter->tx_napi)) {
+				int tx_cpu = (smp_processor_id() + 1) %
+					num_online_cpus();
+				spin_lock(&adapter->irq_mask_lock);
+				hw->intr_mask &= ~ISR_TX_PKT;
+				AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
+				spin_unlock(&adapter->irq_mask_lock);
+				smp_call_function_single_async(tx_cpu,
+							       &adapter->csd);
+			}
+		}

  		handled = IRQ_HANDLED;
  		/* check if PCIE PHY Link down */
@@ -1870,6 +1907,7 @@ static int atl1c_clean(struct napi_struct *napi, 
int budget)
  	struct atl1c_adapter *adapter =
  			container_of(napi, struct atl1c_adapter, napi);
  	int work_done = 0;
+	unsigned long flags;

  	/* Keep link state information with original netdev */
  	if (!netif_carrier_ok(adapter->netdev))
@@ -1880,8 +1918,10 @@ static int atl1c_clean(struct napi_struct *napi, 
int budget)
  	if (work_done < budget) {
  quit_polling:
  		napi_complete_done(napi, work_done);
+		spin_lock_irqsave(&adapter->irq_mask_lock, flags);
  		adapter->hw.intr_mask |= ISR_RX_PKT;
  		AT_WRITE_REG(&adapter->hw, REG_IMR, adapter->hw.intr_mask);
+		spin_unlock_irqrestore(&adapter->irq_mask_lock, flags);
  	}
  	return work_done;
  }
@@ -2319,6 +2359,7 @@ static int atl1c_up(struct atl1c_adapter *adapter)
  	atl1c_check_link_status(adapter);
  	clear_bit(__AT_DOWN, &adapter->flags);
  	napi_enable(&adapter->napi);
+	napi_enable(&adapter->tx_napi);
  	atl1c_irq_enable(adapter);
  	netif_start_queue(netdev);
  	return err;
@@ -2339,6 +2380,7 @@ static void atl1c_down(struct atl1c_adapter 
*adapter)
  	set_bit(__AT_DOWN, &adapter->flags);
  	netif_carrier_off(netdev);
  	napi_disable(&adapter->napi);
+	napi_disable(&adapter->tx_napi);
  	atl1c_irq_disable(adapter);
  	atl1c_free_irq(adapter);
  	/* disable ASPM if device inactive */
@@ -2588,6 +2630,8 @@ static int atl1c_probe(struct pci_dev *pdev, const 
struct pci_device_id *ent)
  	adapter->mii.phy_id_mask = 0x1f;
  	adapter->mii.reg_num_mask = MDIO_CTRL_REG_MASK;
  	netif_napi_add(netdev, &adapter->napi, atl1c_clean, 64);
+	netif_napi_add(netdev, &adapter->tx_napi, atl1c_clean_tx, 64);
+	INIT_CSD(&adapter->csd, atl1c_schedule_tx_napi, adapter);
  	timer_setup(&adapter->phy_config_timer, atl1c_phy_config, 0);
  	/* setup the private structure */
  	err = atl1c_sw_init(adapter);
-- 
2.28.0

