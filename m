Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E945F39313F
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbhE0OqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236583AbhE0OqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 10:46:07 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0257AC0613CE;
        Thu, 27 May 2021 07:44:33 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lmHFM-0002jz-6U; Thu, 27 May 2021 17:44:28 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next v4 2/4] atl1c: move tx napi into tpd_ring
Date:   Thu, 27 May 2021 17:44:21 +0300
Message-Id: <20210527144423.3395719-3-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527144423.3395719-1-gatis@mikrotik.com>
References: <20210527144423.3395719-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To get more performance from using multiple tx queues one needs
a per tx queue napi.

Move tx napi from per adapter struct into per tx queue struct.
Patch that actually enables multiple tx queues will follow.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c.h     |  4 +++-
 .../net/ethernet/atheros/atl1c/atl1c_main.c    | 18 ++++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index 9d70cb7544f1..2c8b72a7db03 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -475,13 +475,16 @@ struct atl1c_buffer {
 
 /* transimit packet descriptor (tpd) ring */
 struct atl1c_tpd_ring {
+	struct atl1c_adapter *adapter;
 	void *desc;		/* descriptor ring virtual address */
 	dma_addr_t dma;		/* descriptor ring physical address */
+	u16 num;
 	u16 size;		/* descriptor ring length in bytes */
 	u16 count;		/* number of descriptors in the ring */
 	u16 next_to_use;
 	atomic_t next_to_clean;
 	struct atl1c_buffer *buffer_info;
+	struct napi_struct napi;
 };
 
 /* receive free descriptor (rfd) ring */
@@ -510,7 +513,6 @@ struct atl1c_adapter {
 	struct net_device   *netdev;
 	struct pci_dev      *pdev;
 	struct napi_struct  napi;
-	struct napi_struct  tx_napi;
 	struct page         *rx_page;
 	unsigned int	    rx_page_offset;
 	unsigned int	    rx_frag_size;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index e3a77d81fecb..db60c1f706ae 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -983,6 +983,8 @@ static int atl1c_setup_ring_resources(struct atl1c_adapter *adapter)
 		goto err_nomem;
 
 	for (i = 0; i < AT_MAX_TRANSMIT_QUEUE; i++) {
+		tpd_ring[i].adapter = adapter;
+		tpd_ring[i].num = i;
 		tpd_ring[i].buffer_info =
 			(tpd_ring->buffer_info + count);
 		count += tpd_ring[i].count;
@@ -1533,9 +1535,9 @@ static inline void atl1c_clear_phy_int(struct atl1c_adapter *adapter)
 
 static int atl1c_clean_tx(struct napi_struct *napi, int budget)
 {
-	struct atl1c_adapter *adapter =
-		container_of(napi, struct atl1c_adapter, tx_napi);
-	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[atl1c_trans_normal];
+	struct atl1c_tpd_ring *tpd_ring =
+		container_of(napi, struct atl1c_tpd_ring, napi);
+	struct atl1c_adapter *adapter = tpd_ring->adapter;
 	struct atl1c_buffer *buffer_info;
 	struct pci_dev *pdev = adapter->pdev;
 	u16 next_to_clean = atomic_read(&tpd_ring->next_to_clean);
@@ -1615,12 +1617,12 @@ static irqreturn_t atl1c_intr(int irq, void *data)
 			}
 		}
 		if (status & ISR_TX_PKT) {
-			if (napi_schedule_prep(&adapter->tx_napi)) {
+			if (napi_schedule_prep(&adapter->tpd_ring[0].napi)) {
 				spin_lock(&hw->intr_mask_lock);
 				hw->intr_mask &= ~ISR_TX_PKT;
 				AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
 				spin_unlock(&hw->intr_mask_lock);
-				__napi_schedule(&adapter->tx_napi);
+				__napi_schedule(&adapter->tpd_ring[0].napi);
 			}
 		}
 
@@ -2354,7 +2356,7 @@ static int atl1c_up(struct atl1c_adapter *adapter)
 	atl1c_check_link_status(adapter);
 	clear_bit(__AT_DOWN, &adapter->flags);
 	napi_enable(&adapter->napi);
-	napi_enable(&adapter->tx_napi);
+	napi_enable(&adapter->tpd_ring[0].napi);
 	atl1c_irq_enable(adapter);
 	netif_start_queue(netdev);
 	return err;
@@ -2375,7 +2377,7 @@ static void atl1c_down(struct atl1c_adapter *adapter)
 	set_bit(__AT_DOWN, &adapter->flags);
 	netif_carrier_off(netdev);
 	napi_disable(&adapter->napi);
-	napi_disable(&adapter->tx_napi);
+	napi_disable(&adapter->tpd_ring[0].napi);
 	atl1c_irq_disable(adapter);
 	atl1c_free_irq(adapter);
 	/* disable ASPM if device inactive */
@@ -2632,7 +2634,7 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->mii.reg_num_mask = MDIO_CTRL_REG_MASK;
 	dev_set_threaded(netdev, true);
 	netif_napi_add(netdev, &adapter->napi, atl1c_clean, 64);
-	netif_napi_add(netdev, &adapter->tx_napi, atl1c_clean_tx, 64);
+	netif_napi_add(netdev, &adapter->tpd_ring[0].napi, atl1c_clean_tx, 64);
 	timer_setup(&adapter->phy_config_timer, atl1c_phy_config, 0);
 	/* setup the private structure */
 	err = atl1c_sw_init(adapter);
-- 
2.31.1

