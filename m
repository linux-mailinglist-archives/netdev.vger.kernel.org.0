Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28404DCDEB
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbiCQSuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbiCQSuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:50:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E703314ACBE;
        Thu, 17 Mar 2022 11:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647542972; x=1679078972;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ijdQp/jnxn+WCsD8fYfPdKIMyKpfGqpynKIID8+tmXc=;
  b=ZGpSLKzSHmpZ2Hhv23qn98e3jaYCNexBBQ67mprksYnM0r7LPbcdWcK/
   kybIIvntpDR8nHemyBHURHkRwtkXp7nbknXGkjLPx7+dQtNmp9iz2wWWc
   h1mDLQ6Oiw3+k36P8tfwxhK+sHZ1n3vfjzqzKp5TugrTD51UC3HV4fb0s
   +lx5qfczTxr9I//QYgqSu7XuPvOP3Shqw8NA99kTAP1FeGqJd5oizOUfR
   S365yK2kDoyER70TIlnMTM7G6L7RbRG/WU1m4QMVczYu01R7NU3rM5i+h
   AkUnBlsg2A5E+AZ90ZpPKOKxPjKUfMQBCZLh4ENpJwj9tPN1SCnE9rCQe
   w==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="152385620"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 11:49:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 11:49:32 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 17 Mar 2022 11:49:30 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 4/5] net: lan966x: Add FDMA functionality
Date:   Thu, 17 Mar 2022 19:51:58 +0100
Message-ID: <20220317185159.1661469-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220317185159.1661469-1-horatiu.vultur@microchip.com>
References: <20220317185159.1661469-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethernet frames can be extracted or injected to or from the device's
DDR memory. There is one channel for injection and one channel for
extraction. Each of these channels contain a linked list of DCBs which
contains DB. The DCB for injection contains only 1 DB and the DCB for
extraction contains 3 DBs. Each DB contains a frame. Everytime when a
frame is received or transmitted an interrupt is generated.

It is not possible to use both the FDMA and the manual
injection/extraction of the frames. Therefore the FDMA has priority over
the manual because of better performance values.

FDMA:
[  5]   0.00-10.01  sec   456 MBytes   382 Mbits/sec    0 sender
[  5]   0.00-10.05  sec   315 MBytes   263 Mbits/sec      receiver

Manual:
[  5]   0.00-10.02  sec  94.0 MBytes  78.7 Mbits/sec    0 sender
[  5]   0.00-10.01  sec   118 MBytes  98.6 Mbits/sec      receiver

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 677 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  31 +-
 .../ethernet/microchip/lan966x/lan966x_main.h | 111 +++
 .../ethernet/microchip/lan966x/lan966x_port.c |   3 +
 5 files changed, 820 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index a9ffc719aa0e..fd2e0ebb2427 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
 			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o \
-			lan966x_ptp.o
+			lan966x_ptp.o lan966x_fdma.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
new file mode 100644
index 000000000000..c23e521a1f8b
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -0,0 +1,677 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+static int lan966x_fdma_channel_active(struct lan966x *lan966x)
+{
+	return lan_rd(lan966x, FDMA_CH_ACTIVE);
+}
+
+static struct sk_buff *lan966x_fdma_rx_alloc_skb(struct lan966x_rx *rx,
+						 struct lan966x_db *db)
+{
+	struct lan966x *lan966x = rx->lan966x;
+	struct sk_buff *skb;
+	dma_addr_t dma_addr;
+	struct page *page;
+	void *buff_addr;
+
+	page = dev_alloc_pages(rx->page_order);
+	if (unlikely(!page))
+		return NULL;
+
+	dma_addr = dma_map_page(lan966x->dev, page, 0,
+				PAGE_SIZE << rx->page_order,
+				DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(lan966x->dev, dma_addr))) {
+		__free_pages(page, rx->page_order);
+		return NULL;
+	}
+
+	buff_addr = page_address(page);
+	skb = build_skb(buff_addr, PAGE_SIZE << rx->page_order);
+
+	if (unlikely(!skb)) {
+		dev_err_ratelimited(lan966x->dev,
+				    "build_skb failed !\n");
+		dma_unmap_single(lan966x->dev, dma_addr,
+				 PAGE_SIZE << rx->page_order,
+				 DMA_FROM_DEVICE);
+		__free_pages(page, rx->page_order);
+		return NULL;
+	}
+
+	db->dataptr = dma_addr;
+	return skb;
+}
+
+static void lan966x_fdma_rx_free_skbs(struct lan966x_rx *rx)
+{
+	struct lan966x *lan966x = rx->lan966x;
+	struct lan966x_rx_dcb *dcb;
+	struct lan966x_db *db;
+	int i, j;
+
+	for (i = 0; i < FDMA_DCB_MAX; ++i) {
+		dcb = &rx->dcbs[i];
+
+		for (j = 0; j < FDMA_RX_DCB_MAX_DBS; ++j) {
+			db = &dcb->db[j];
+			dma_unmap_single(lan966x->dev,
+					 (dma_addr_t)db->dataptr,
+					 PAGE_SIZE << rx->page_order,
+					 DMA_FROM_DEVICE);
+			kfree_skb(rx->skb[i][j]);
+		}
+	}
+}
+
+static void lan966x_fdma_rx_add_dcb(struct lan966x_rx *rx,
+				    struct lan966x_rx_dcb *dcb,
+				    u64 nextptr)
+{
+	struct lan966x_db *db;
+	int i;
+
+	for (i = 0; i < FDMA_RX_DCB_MAX_DBS; ++i) {
+		db = &dcb->db[i];
+		db->status = FDMA_DCB_STATUS_INTR;
+	}
+
+	dcb->nextptr = FDMA_DCB_INVALID_DATA;
+	dcb->info = FDMA_DCB_INFO_DATAL(PAGE_SIZE << rx->page_order);
+
+	rx->last_entry->nextptr = nextptr;
+	rx->last_entry = dcb;
+}
+
+static int lan966x_fdma_rx_alloc(struct lan966x_rx *rx)
+{
+	struct lan966x *lan966x = rx->lan966x;
+	struct lan966x_rx_dcb *dcb;
+	struct lan966x_db *db;
+	struct sk_buff *skb;
+	int i, j;
+	int size;
+
+	/* calculate how many pages are needed to allocate the dcbs */
+	size = sizeof(struct lan966x_rx_dcb) * FDMA_DCB_MAX;
+	size = ALIGN(size, PAGE_SIZE);
+
+	rx->dcbs = dma_alloc_coherent(lan966x->dev, size, &rx->dma, GFP_ATOMIC);
+	rx->last_entry = rx->dcbs;
+	rx->db_index = 0;
+	rx->dcb_index = 0;
+
+	/* Now for each dcb allocate the dbs */
+	for (i = 0; i < FDMA_DCB_MAX; ++i) {
+		dcb = &rx->dcbs[i];
+		dcb->info = 0;
+
+		/* For each db allocate a skb and map skb data pointer to the DB
+		 * dataptr. In this way when the frame is received the skb->data
+		 * will contain the frame, so it is not needed any memcpy
+		 */
+		for (j = 0; j < FDMA_RX_DCB_MAX_DBS; ++j) {
+			db = &dcb->db[j];
+			skb = lan966x_fdma_rx_alloc_skb(rx, db);
+			if (!skb)
+				return -ENOMEM;
+
+			db->status = 0;
+			rx->skb[i][j] = skb;
+		}
+
+		lan966x_fdma_rx_add_dcb(rx, dcb, rx->dma + sizeof(*dcb) * i);
+	}
+
+	return 0;
+}
+
+static void lan966x_fdma_rx_free(struct lan966x_rx *rx)
+{
+	struct lan966x *lan966x = rx->lan966x;
+	u32 size;
+
+	/* Now it is possible to do the cleanup of dcb */
+	size = sizeof(struct lan966x_tx_dcb) * FDMA_DCB_MAX;
+	size = ALIGN(size, PAGE_SIZE);
+	dma_free_coherent(lan966x->dev, size, rx->dcbs, rx->dma);
+}
+
+static void lan966x_fdma_rx_start(struct lan966x_rx *rx)
+{
+	struct lan966x *lan966x = rx->lan966x;
+	u32 mask;
+
+	/* When activating a channel, first is required to write the first DCB
+	 * address and then to activate it
+	 */
+	lan_wr(((u64)rx->dma) & GENMASK(31, 0), lan966x,
+	       FDMA_DCB_LLP(rx->channel_id));
+	lan_wr(((u64)rx->dma) >> 32, lan966x, FDMA_DCB_LLP1(rx->channel_id));
+
+	lan_wr(FDMA_CH_CFG_CH_DCB_DB_CNT_SET(FDMA_RX_DCB_MAX_DBS) |
+	       FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY_SET(1) |
+	       FDMA_CH_CFG_CH_INJ_PORT_SET(0) |
+	       FDMA_CH_CFG_CH_MEM_SET(1),
+	       lan966x, FDMA_CH_CFG(rx->channel_id));
+
+	/* Start fdma */
+	lan_rmw(FDMA_PORT_CTRL_XTR_STOP_SET(0),
+		FDMA_PORT_CTRL_XTR_STOP,
+		lan966x, FDMA_PORT_CTRL(0));
+
+	/* Enable interrupts */
+	mask = lan_rd(lan966x, FDMA_INTR_DB_ENA);
+	mask = FDMA_INTR_DB_ENA_INTR_DB_ENA_GET(mask);
+	mask |= BIT(rx->channel_id);
+	lan_rmw(FDMA_INTR_DB_ENA_INTR_DB_ENA_SET(mask),
+		FDMA_INTR_DB_ENA_INTR_DB_ENA,
+		lan966x, FDMA_INTR_DB_ENA);
+
+	/* Activate the channel */
+	lan_rmw(FDMA_CH_ACTIVATE_CH_ACTIVATE_SET(BIT(rx->channel_id)),
+		FDMA_CH_ACTIVATE_CH_ACTIVATE,
+		lan966x, FDMA_CH_ACTIVATE);
+}
+
+static void lan966x_fdma_rx_disable(struct lan966x_rx *rx)
+{
+	struct lan966x *lan966x = rx->lan966x;
+	u32 val;
+
+	/* Disable the channel */
+	lan_rmw(FDMA_CH_DISABLE_CH_DISABLE_SET(BIT(rx->channel_id)),
+		FDMA_CH_DISABLE_CH_DISABLE,
+		lan966x, FDMA_CH_DISABLE);
+
+	readx_poll_timeout_atomic(lan966x_fdma_channel_active, lan966x,
+				  val, !(val & BIT(rx->channel_id)),
+				  READL_SLEEP_US, READL_TIMEOUT_US);
+
+	lan_rmw(FDMA_CH_DB_DISCARD_DB_DISCARD_SET(BIT(rx->channel_id)),
+		FDMA_CH_DB_DISCARD_DB_DISCARD,
+		lan966x, FDMA_CH_DB_DISCARD);
+}
+
+static void lan966x_fdma_rx_reload(struct lan966x_rx *rx)
+{
+	struct lan966x *lan966x = rx->lan966x;
+
+	lan_rmw(FDMA_CH_RELOAD_CH_RELOAD_SET(BIT(rx->channel_id)),
+		FDMA_CH_RELOAD_CH_RELOAD,
+		lan966x, FDMA_CH_RELOAD);
+}
+
+static void lan966x_fdma_tx_add_dcb(struct lan966x_tx *tx,
+				    struct lan966x_tx_dcb *dcb)
+{
+	dcb->nextptr = FDMA_DCB_INVALID_DATA;
+	dcb->info = 0;
+}
+
+static int lan966x_fdma_tx_alloc(struct lan966x_tx *tx)
+{
+	struct lan966x *lan966x = tx->lan966x;
+	struct lan966x_tx_dcb *dcb;
+	struct lan966x_db *db;
+	int size;
+	int i, j;
+
+	tx->dcbs_buf = kcalloc(FDMA_DCB_MAX, sizeof(struct lan966x_tx_dcb_buf),
+			       GFP_ATOMIC);
+	if (!tx->dcbs_buf)
+		return -ENOMEM;
+
+	/* calculate how many pages are needed to allocate the dcbs */
+	size = sizeof(struct lan966x_tx_dcb) * FDMA_DCB_MAX;
+	size = ALIGN(size, PAGE_SIZE);
+	tx->dcbs = dma_alloc_coherent(lan966x->dev, size, &tx->dma, GFP_ATOMIC);
+
+	/* Now for each dcb allocate the db */
+	for (i = 0; i < FDMA_DCB_MAX; ++i) {
+		dcb = &tx->dcbs[i];
+
+		for (j = 0; j < FDMA_TX_DCB_MAX_DBS; ++j) {
+			db = &dcb->db[j];
+			db->dataptr = 0;
+			db->status = 0;
+		}
+
+		lan966x_fdma_tx_add_dcb(tx, dcb);
+	}
+
+	return 0;
+}
+
+static void lan966x_fdma_tx_free(struct lan966x_tx *tx)
+{
+	struct lan966x *lan966x = tx->lan966x;
+	int size;
+
+	kfree(tx->dcbs_buf);
+
+	size = sizeof(struct lan966x_tx_dcb) * FDMA_DCB_MAX;
+	size = ALIGN(size, PAGE_SIZE);
+	dma_free_coherent(lan966x->dev, size, tx->dcbs, tx->dma);
+}
+
+static void lan966x_fdma_tx_activate(struct lan966x_tx *tx)
+{
+	struct lan966x *lan966x = tx->lan966x;
+	u32 mask;
+
+	/* When activating a channel, first is required to write the first DCB
+	 * address and then to activate it
+	 */
+	lan_wr(((u64)tx->dma) & GENMASK(31, 0), lan966x,
+	       FDMA_DCB_LLP(tx->channel_id));
+	lan_wr(((u64)tx->dma) >> 32, lan966x, FDMA_DCB_LLP1(tx->channel_id));
+
+	lan_wr(FDMA_CH_CFG_CH_DCB_DB_CNT_SET(FDMA_TX_DCB_MAX_DBS) |
+	       FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY_SET(1) |
+	       FDMA_CH_CFG_CH_INJ_PORT_SET(0) |
+	       FDMA_CH_CFG_CH_MEM_SET(1),
+	       lan966x, FDMA_CH_CFG(tx->channel_id));
+
+	/* Start fdma */
+	lan_rmw(FDMA_PORT_CTRL_INJ_STOP_SET(0),
+		FDMA_PORT_CTRL_INJ_STOP,
+		lan966x, FDMA_PORT_CTRL(0));
+
+	/* Enable interrupts */
+	mask = lan_rd(lan966x, FDMA_INTR_DB_ENA);
+	mask = FDMA_INTR_DB_ENA_INTR_DB_ENA_GET(mask);
+	mask |= BIT(tx->channel_id);
+	lan_rmw(FDMA_INTR_DB_ENA_INTR_DB_ENA_SET(mask),
+		FDMA_INTR_DB_ENA_INTR_DB_ENA,
+		lan966x, FDMA_INTR_DB_ENA);
+
+	/* Activate the channel */
+	lan_rmw(FDMA_CH_ACTIVATE_CH_ACTIVATE_SET(BIT(tx->channel_id)),
+		FDMA_CH_ACTIVATE_CH_ACTIVATE,
+		lan966x, FDMA_CH_ACTIVATE);
+}
+
+static void lan966x_fdma_tx_disable(struct lan966x_tx *tx)
+{
+	struct lan966x *lan966x = tx->lan966x;
+	u32 val;
+
+	/* Disable the channel */
+	lan_rmw(FDMA_CH_DISABLE_CH_DISABLE_SET(BIT(tx->channel_id)),
+		FDMA_CH_DISABLE_CH_DISABLE,
+		lan966x, FDMA_CH_DISABLE);
+
+	readx_poll_timeout_atomic(lan966x_fdma_channel_active, lan966x,
+				  val, !(val & BIT(tx->channel_id)),
+				  READL_SLEEP_US, READL_TIMEOUT_US);
+
+	lan_rmw(FDMA_CH_DB_DISCARD_DB_DISCARD_SET(BIT(tx->channel_id)),
+		FDMA_CH_DB_DISCARD_DB_DISCARD,
+		lan966x, FDMA_CH_DB_DISCARD);
+
+	tx->activated = false;
+}
+
+static void lan966x_fdma_tx_reload(struct lan966x_tx *tx)
+{
+	struct lan966x *lan966x = tx->lan966x;
+
+	/* Write the registers to reload the channel */
+	lan_rmw(FDMA_CH_RELOAD_CH_RELOAD_SET(BIT(tx->channel_id)),
+		FDMA_CH_RELOAD_CH_RELOAD,
+		lan966x, FDMA_CH_RELOAD);
+}
+
+static void lan966x_fdma_wakeup_netdev(struct lan966x *lan966x)
+{
+	struct lan966x_port *port;
+	int i;
+
+	for (i = 0; i < lan966x->num_phys_ports; ++i) {
+		port = lan966x->ports[i];
+		if (!port)
+			continue;
+
+		if (netif_queue_stopped(port->dev))
+			netif_wake_queue(port->dev);
+	}
+}
+
+static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
+{
+	struct lan966x_tx *tx = &lan966x->tx;
+	struct lan966x_tx_dcb_buf *dcb_buf;
+	struct lan966x_db *db;
+	unsigned long flags;
+	bool clear = false;
+	int i;
+
+	spin_lock_irqsave(&lan966x->tx_lock, flags);
+	for (i = 0; i < FDMA_DCB_MAX; ++i) {
+		dcb_buf = &tx->dcbs_buf[i];
+
+		if (!dcb_buf->used)
+			continue;
+
+		db = &tx->dcbs[i].db[0];
+		if (!(db->status & FDMA_DCB_STATUS_DONE))
+			continue;
+
+		dcb_buf->used = false;
+		dma_unmap_single(lan966x->dev,
+				 dcb_buf->dma_addr,
+				 dcb_buf->skb->len,
+				 DMA_TO_DEVICE);
+		if (!dcb_buf->ptp)
+			dev_kfree_skb_any(dcb_buf->skb);
+
+		clear = true;
+	}
+	spin_unlock_irqrestore(&lan966x->tx_lock, flags);
+
+	if (clear)
+		lan966x_fdma_wakeup_netdev(lan966x);
+}
+
+static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
+{
+	struct lan966x *lan966x = rx->lan966x;
+	u64 src_port, timestamp;
+	struct sk_buff *new_skb;
+	struct lan966x_db *db;
+	struct sk_buff *skb;
+
+	/* Check if there is any data */
+	db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
+	if (unlikely(!(db->status & FDMA_DCB_STATUS_DONE)))
+		return NULL;
+
+	/* Get the received frame and unmap it */
+	skb = rx->skb[rx->dcb_index][rx->db_index];
+	dma_unmap_single(lan966x->dev, (dma_addr_t)db->dataptr,
+			 FDMA_DCB_STATUS_BLOCKL(db->status),
+			 DMA_FROM_DEVICE);
+
+	/* Allocate a new skb and map it */
+	new_skb = lan966x_fdma_rx_alloc_skb(rx, db);
+	if (unlikely(!new_skb))
+		return NULL;
+
+	rx->skb[rx->dcb_index][rx->db_index] = new_skb;
+
+	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
+
+	lan966x_ifh_get_src_port(skb->data, &src_port);
+	lan966x_ifh_get_timestamp(skb->data, &timestamp);
+
+	WARN_ON(src_port >= lan966x->num_phys_ports);
+
+	skb->dev = lan966x->ports[src_port]->dev;
+	skb_pull(skb, IFH_LEN * sizeof(u32));
+
+	if (likely(!(skb->dev->features & NETIF_F_RXFCS)))
+		skb_trim(skb, skb->len - ETH_FCS_LEN);
+
+	lan966x_ptp_rxtstamp(lan966x, skb, timestamp);
+	skb->protocol = eth_type_trans(skb, skb->dev);
+
+	if (lan966x->bridge_mask & BIT(src_port)) {
+		skb->offload_fwd_mark = 1;
+
+		skb_reset_network_header(skb);
+		if (!lan966x_hw_offload(lan966x, src_port, skb))
+			skb->offload_fwd_mark = 0;
+	}
+
+	skb->dev->stats.rx_bytes += skb->len;
+	skb->dev->stats.rx_packets++;
+
+	return skb;
+}
+
+static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
+{
+	struct lan966x *lan966x = container_of(napi, struct lan966x, napi);
+	struct lan966x_rx *rx = &lan966x->rx;
+	struct list_head rx_list;
+	int counter = 0;
+
+	lan966x_fdma_tx_clear_buf(lan966x, weight);
+
+	INIT_LIST_HEAD(&rx_list);
+
+	while (counter < weight) {
+		struct lan966x_rx_dcb *old_dcb;
+		struct sk_buff *skb;
+		u64 nextptr;
+
+		skb = lan966x_fdma_rx_get_frame(rx);
+		if (!skb)
+			break;
+		list_add_tail(&skb->list, &rx_list);
+
+		rx->db_index++;
+		counter++;
+
+		/* Check if the DCB can be reused */
+		if (rx->db_index != FDMA_RX_DCB_MAX_DBS)
+			continue;
+
+		/* Now the DCB  can be reused, just advance the dcb_index
+		 * pointer and set the nextptr in the DCB
+		 */
+		rx->db_index = 0;
+
+		old_dcb = &rx->dcbs[rx->dcb_index];
+		rx->dcb_index++;
+		rx->dcb_index &= FDMA_DCB_MAX - 1;
+
+		nextptr = rx->dma + ((unsigned long)old_dcb -
+				     (unsigned long)rx->dcbs);
+		lan966x_fdma_rx_add_dcb(rx, old_dcb, nextptr);
+		lan966x_fdma_rx_reload(rx);
+	}
+
+	if (counter < weight) {
+		napi_complete_done(napi, counter);
+		lan_wr(0xff, lan966x, FDMA_INTR_DB_ENA);
+	}
+
+	netif_receive_skb_list(&rx_list);
+
+	return counter;
+}
+
+irqreturn_t lan966x_fdma_irq_handler(int irq, void *args)
+{
+	struct lan966x *lan966x = args;
+	u32 db, err, err_type;
+
+	db = lan_rd(lan966x, FDMA_INTR_DB);
+	err = lan_rd(lan966x, FDMA_INTR_ERR);
+
+	if (db) {
+		lan_wr(0, lan966x, FDMA_INTR_DB_ENA);
+		lan_wr(db, lan966x, FDMA_INTR_DB);
+
+		napi_schedule(&lan966x->napi);
+	}
+
+	if (err) {
+		err_type = lan_rd(lan966x, FDMA_ERRORS);
+
+		WARN(1, "Unexpected error: %d, error_type: %d\n", err, err_type);
+
+		lan_wr(err, lan966x, FDMA_INTR_ERR);
+		lan_wr(err_type, lan966x, FDMA_ERRORS);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int lan966x_fdma_get_next_dcb(struct lan966x_tx *tx)
+{
+	struct lan966x_tx_dcb_buf *dcb_buf;
+	int i;
+
+	for (i = 0; i < FDMA_DCB_MAX; ++i) {
+		dcb_buf = &tx->dcbs_buf[i];
+		if (!dcb_buf->used && i != tx->last_in_use)
+			return i;
+	}
+
+	return -1;
+}
+
+int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	struct lan966x_tx_dcb_buf *next_dcb_buf;
+	struct lan966x_tx_dcb *next_dcb, *dcb;
+	struct lan966x_tx *tx = &lan966x->tx;
+	struct lan966x_db *next_db;
+	dma_addr_t dma_addr;
+	int next_to_use;
+	int err;
+
+	/* Get next index */
+	next_to_use = lan966x_fdma_get_next_dcb(tx);
+	if (next_to_use < 0) {
+		netif_stop_queue(dev);
+		err = NETDEV_TX_BUSY;
+		goto out;
+	}
+
+	if (skb_put_padto(skb, ETH_ZLEN)) {
+		dev->stats.tx_dropped++;
+		err = NETDEV_TX_OK;
+		goto out;
+	}
+
+	/* skb processing */
+	skb_tx_timestamp(skb);
+	if (skb_headroom(skb) < IFH_LEN * sizeof(u32)) {
+		err = pskb_expand_head(skb,
+				       IFH_LEN * sizeof(u32) - skb_headroom(skb),
+				       0, GFP_ATOMIC);
+		if (unlikely(err)) {
+			dev->stats.tx_dropped++;
+			err = NETDEV_TX_OK;
+			goto release;
+		}
+	}
+
+	skb_push(skb, IFH_LEN * sizeof(u32));
+	memcpy(skb->data, ifh, IFH_LEN * sizeof(u32));
+	skb_put(skb, 4);
+
+	dma_addr = dma_map_single(lan966x->dev, skb->data, skb->len,
+				  DMA_TO_DEVICE);
+	if (dma_mapping_error(lan966x->dev, dma_addr)) {
+		dev->stats.tx_dropped++;
+		err = NETDEV_TX_OK;
+		goto release;
+	}
+
+	/* Setup next dcb */
+	next_dcb = &tx->dcbs[next_to_use];
+	next_dcb->nextptr = FDMA_DCB_INVALID_DATA;
+
+	next_db = &next_dcb->db[0];
+	next_db->dataptr = dma_addr;
+	next_db->status = FDMA_DCB_STATUS_SOF |
+			  FDMA_DCB_STATUS_EOF |
+			  FDMA_DCB_STATUS_INTR |
+			  FDMA_DCB_STATUS_BLOCKO(0) |
+			  FDMA_DCB_STATUS_BLOCKL(skb->len);
+
+	/* Fill up the buffer */
+	next_dcb_buf = &tx->dcbs_buf[next_to_use];
+	next_dcb_buf->skb = skb;
+	next_dcb_buf->dma_addr = dma_addr;
+	next_dcb_buf->used = true;
+	next_dcb_buf->ptp = false;
+
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    LAN966X_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		next_dcb_buf->ptp = true;
+
+	if (likely(lan966x->tx.activated)) {
+		/* Connect current dcb to the next db */
+		dcb = &tx->dcbs[tx->last_in_use];
+		dcb->nextptr = tx->dma + (next_to_use *
+					  sizeof(struct lan966x_tx_dcb));
+
+		lan966x_fdma_tx_reload(tx);
+	} else {
+		/* Because it is first time, then just activate */
+		lan966x->tx.activated = true;
+		lan966x_fdma_tx_activate(tx);
+	}
+
+	/* Move to next dcb because this last in use */
+	tx->last_in_use = next_to_use;
+
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
+
+	return NETDEV_TX_OK;
+
+out:
+	return err;
+
+release:
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    LAN966X_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		lan966x_ptp_txtstamp_release(port, skb);
+
+	dev_kfree_skb_any(skb);
+	return err;
+}
+
+void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev)
+{
+	if (lan966x->fdma_ndev)
+		return;
+
+	lan966x->fdma_ndev = dev;
+	netif_napi_add(dev, &lan966x->napi, lan966x_fdma_napi_poll,
+		       FDMA_WEIGHT);
+	napi_enable(&lan966x->napi);
+}
+
+void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev)
+{
+	if (lan966x->fdma_ndev == dev) {
+		netif_napi_del(&lan966x->napi);
+		lan966x->fdma_ndev = NULL;
+	}
+}
+
+void lan966x_fdma_init(struct lan966x *lan966x)
+{
+	lan966x->rx.lan966x = lan966x;
+	lan966x->rx.channel_id = FDMA_XTR_CHANNEL;
+	lan966x->tx.lan966x = lan966x;
+	lan966x->tx.channel_id = FDMA_INJ_CHANNEL;
+	lan966x->tx.last_in_use = -1;
+
+	lan966x_fdma_rx_alloc(&lan966x->rx);
+	lan966x_fdma_tx_alloc(&lan966x->tx);
+
+	lan966x_fdma_rx_start(&lan966x->rx);
+}
+
+void lan966x_fdma_deinit(struct lan966x *lan966x)
+{
+	lan966x_fdma_rx_disable(&lan966x->rx);
+	lan966x_fdma_tx_disable(&lan966x->tx);
+
+	lan966x_fdma_rx_free_skbs(&lan966x->rx);
+	lan966x_fdma_rx_free(&lan966x->rx);
+	lan966x_fdma_tx_free(&lan966x->tx);
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 2c82f847ae6d..6cb9fffc3058 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -341,7 +341,10 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	spin_lock(&lan966x->tx_lock);
-	err = lan966x_port_ifh_xmit(skb, ifh, dev);
+	if (port->lan966x->fdma)
+		err = lan966x_fdma_xmit(skb, ifh, dev);
+	else
+		err = lan966x_port_ifh_xmit(skb, ifh, dev);
 	spin_unlock(&lan966x->tx_lock);
 
 	return err;
@@ -640,6 +643,9 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 		if (port->dev)
 			unregister_netdev(port->dev);
 
+		if (lan966x->fdma && lan966x->fdma_ndev == port->dev)
+			lan966x_fdma_netdev_deinit(lan966x, port->dev);
+
 		if (port->phylink) {
 			rtnl_lock();
 			lan966x_port_stop(port->dev);
@@ -659,6 +665,11 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 		disable_irq(lan966x->ana_irq);
 		lan966x->ana_irq = -ENXIO;
 	}
+
+	if (lan966x->fdma_irq) {
+		disable_irq(lan966x->fdma_irq);
+		lan966x->fdma_irq = -ENXIO;
+	}
 }
 
 static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
@@ -787,12 +798,12 @@ static void lan966x_init(struct lan966x *lan966x)
 	/* Do byte-swap and expect status after last data word
 	 * Extraction: Mode: manual extraction) | Byte_swap
 	 */
-	lan_wr(QS_XTR_GRP_CFG_MODE_SET(1) |
+	lan_wr(QS_XTR_GRP_CFG_MODE_SET(lan966x->fdma ? 2 : 1) |
 	       QS_XTR_GRP_CFG_BYTE_SWAP_SET(1),
 	       lan966x, QS_XTR_GRP_CFG(0));
 
 	/* Injection: Mode: manual injection | Byte_swap */
-	lan_wr(QS_INJ_GRP_CFG_MODE_SET(1) |
+	lan_wr(QS_INJ_GRP_CFG_MODE_SET(lan966x->fdma ? 2 : 1) |
 	       QS_INJ_GRP_CFG_BYTE_SWAP_SET(1),
 	       lan966x, QS_INJ_GRP_CFG(0));
 
@@ -1014,6 +1025,17 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x->ptp = 1;
 	}
 
+	lan966x->fdma_irq = platform_get_irq_byname(pdev, "fdma");
+	if (lan966x->fdma_irq > 0) {
+		err = devm_request_threaded_irq(&pdev->dev, lan966x->fdma_irq, NULL,
+						lan966x_fdma_irq_handler, IRQF_ONESHOT,
+						"fdma irq", lan966x);
+		if (err)
+			return dev_err_probe(&pdev->dev, err, "Unable to use fdma irq");
+
+		lan966x->fdma = true;
+	}
+
 	/* init switch */
 	lan966x_init(lan966x);
 	lan966x_stats_init(lan966x);
@@ -1043,6 +1065,8 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x_port_init(lan966x->ports[p]);
 	}
 
+	lan966x_fdma_init(lan966x);
+
 	lan966x_mdb_init(lan966x);
 	err = lan966x_fdb_init(lan966x);
 	if (err)
@@ -1073,6 +1097,7 @@ static int lan966x_remove(struct platform_device *pdev)
 {
 	struct lan966x *lan966x = platform_get_drvdata(pdev);
 
+	lan966x_fdma_deinit(lan966x);
 	lan966x_cleanup_ports(lan966x);
 
 	cancel_delayed_work_sync(&lan966x->stats_work);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index b692c612f235..bfa7feea2b56 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -61,6 +61,23 @@
 #define IFH_REW_OP_ONE_STEP_PTP		0x3
 #define IFH_REW_OP_TWO_STEP_PTP		0x4
 
+#define FDMA_RX_DCB_MAX_DBS		3
+#define FDMA_TX_DCB_MAX_DBS		1
+#define FDMA_DCB_INFO_DATAL(x)		((x) & GENMASK(15, 0))
+
+#define FDMA_DCB_STATUS_BLOCKL(x)	((x) & GENMASK(15, 0))
+#define FDMA_DCB_STATUS_SOF		BIT(16)
+#define FDMA_DCB_STATUS_EOF		BIT(17)
+#define FDMA_DCB_STATUS_INTR		BIT(18)
+#define FDMA_DCB_STATUS_DONE		BIT(19)
+#define FDMA_DCB_STATUS_BLOCKO(x)	(((x) << 20) & GENMASK(31, 20))
+#define FDMA_DCB_INVALID_DATA		0x1
+
+#define FDMA_XTR_CHANNEL		6
+#define FDMA_INJ_CHANNEL		0
+#define FDMA_DCB_MAX			512
+#define FDMA_WEIGHT			64
+
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
@@ -76,6 +93,85 @@ enum macaccess_entry_type {
 
 struct lan966x_port;
 
+struct lan966x_db {
+	u64 dataptr;
+	u64 status;
+};
+
+struct lan966x_rx_dcb {
+	u64 nextptr;
+	u64 info;
+	struct lan966x_db db[FDMA_RX_DCB_MAX_DBS];
+};
+
+struct lan966x_tx_dcb {
+	u64 nextptr;
+	u64 info;
+	struct lan966x_db db[FDMA_TX_DCB_MAX_DBS];
+};
+
+struct lan966x_rx {
+	struct lan966x *lan966x;
+
+	/* Pointer to the array of hardware dcbs. */
+	struct lan966x_rx_dcb *dcbs;
+
+	/* Pointer to the last address in the dcbs. */
+	struct lan966x_rx_dcb *last_entry;
+
+	/* For each DB, there is a skb, and the skb data pointer is mapped in
+	 * the DB. Once a frame is received the skb is given to the upper layers
+	 * and a new skb is added to the db.
+	 */
+	struct sk_buff *skb[FDMA_DCB_MAX][FDMA_RX_DCB_MAX_DBS];
+
+	/* Represents the db_index, it can have a value between 0 and
+	 * FDMA_RX_DCB_MAX_DBS, once it reaches the value of FDMA_RX_DCB_MAX_DBS
+	 * it means that the DCB can be reused.
+	 */
+	int db_index;
+
+	/* Represents the index in the dcbs. It has a value between 0 and
+	 * FDMA_DCB_MAX
+	 */
+	int dcb_index;
+
+	/* Represents the dma address to the dcbs array */
+	dma_addr_t dma;
+
+	/* Represents the page order that is used to allocate the pages for the
+	 * RX buffers. This value is calculated based on max MTU of the devices.
+	 */
+	u8 page_order;
+
+	u8 channel_id;
+};
+
+struct lan966x_tx_dcb_buf {
+	struct sk_buff *skb;
+	dma_addr_t dma_addr;
+	bool used;
+	bool ptp;
+};
+
+struct lan966x_tx {
+	struct lan966x *lan966x;
+
+	/* Pointer to the dcb list */
+	struct lan966x_tx_dcb *dcbs;
+	u16 last_in_use;
+
+	/* Represents the DMA address to the first entry of the dcb entries. */
+	dma_addr_t dma;
+
+	/* Array of dcbs that are given to the HW */
+	struct lan966x_tx_dcb_buf *dcbs_buf;
+
+	u8 channel_id;
+
+	bool activated;
+};
+
 struct lan966x_stat_layout {
 	u32 offset;
 	char name[ETH_GSTRING_LEN];
@@ -137,6 +233,7 @@ struct lan966x {
 	int xtr_irq;
 	int ana_irq;
 	int ptp_irq;
+	int fdma_irq;
 
 	/* worqueue for fdb */
 	struct workqueue_struct *fdb_work;
@@ -153,6 +250,13 @@ struct lan966x {
 	spinlock_t ptp_ts_id_lock; /* lock for ts_id */
 	struct mutex ptp_lock; /* lock for ptp interface state */
 	u16 ptp_skbs;
+
+	/* fdma */
+	bool fdma;
+	struct net_device *fdma_ndev;
+	struct lan966x_rx rx;
+	struct lan966x_tx tx;
+	struct napi_struct napi;
 };
 
 struct lan966x_port_config {
@@ -292,6 +396,13 @@ void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
 				  struct sk_buff *skb);
 irqreturn_t lan966x_ptp_irq_handler(int irq, void *args);
 
+int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
+void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
+void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev);
+void lan966x_fdma_init(struct lan966x *lan966x);
+void lan966x_fdma_deinit(struct lan966x *lan966x);
+irqreturn_t lan966x_fdma_irq_handler(int irq, void *args);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index 237555845a52..f141644e4372 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -393,6 +393,9 @@ void lan966x_port_init(struct lan966x_port *port)
 
 	lan966x_port_config_down(port);
 
+	if (lan966x->fdma)
+		lan966x_fdma_netdev_init(lan966x, port->dev);
+
 	if (config->portmode != PHY_INTERFACE_MODE_QSGMII)
 		return;
 
-- 
2.33.0

