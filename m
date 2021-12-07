Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D61E46B6C3
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhLGJOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:14:23 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54035 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbhLGJOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:14:17 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 779C3E0011;
        Tue,  7 Dec 2021 09:10:45 +0000 (UTC)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next v5 4/4] net: ocelot: add FDMA support
Date:   Tue,  7 Dec 2021 10:08:53 +0100
Message-Id: <20211207090853.308328-5-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211207090853.308328-1-clement.leger@bootlin.com>
References: <20211207090853.308328-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethernet frames can be extracted or injected autonomously to or from
the device’s DDR3/DDR3L memory and/or PCIe memory space. Linked list
data structures in memory are used for injecting or extracting Ethernet
frames. The FDMA generates interrupts when frame extraction or
injection is done and when the linked lists need updating.

The FDMA is shared between all the ethernet ports of the switch and
uses a linked list of descriptors (DCB) to inject and extract packets.
Before adding descriptors, the FDMA channels must be stopped. It would
be inefficient to do that each time a descriptor would be added so the
channels are restarted only once they stopped.

Both channels uses ring-like structure to feed the DCBs to the FDMA.
head and tail are never touched by hardware and are completely handled
by the driver. On top of that, page recycling has been added and is
mostly taken from gianfar driver.

Co-developed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/Makefile         |   1 +
 drivers/net/ethernet/mscc/ocelot.h         |   1 +
 drivers/net/ethernet/mscc/ocelot_fdma.c    | 886 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_fdma.h    | 166 ++++
 drivers/net/ethernet/mscc/ocelot_net.c     |  25 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  22 +
 include/soc/mscc/ocelot.h                  |   3 +
 7 files changed, 1100 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.h

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 722c27694b21..d76a9b78b6ca 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -11,5 +11,6 @@ mscc_ocelot_switch_lib-y := \
 mscc_ocelot_switch_lib-$(CONFIG_BRIDGE_MRP) += ocelot_mrp.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
 mscc_ocelot-y := \
+	ocelot_fdma.o \
 	ocelot_vsc7514.o \
 	ocelot_net.o
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index bf4eff6d7086..deae54876e2e 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -9,6 +9,7 @@
 #define _MSCC_OCELOT_H_
 
 #include <linux/bitops.h>
+#include <linux/dsa/ocelot.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/net_tstamp.h>
diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
new file mode 100644
index 000000000000..41f59ae7c7a2
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
@@ -0,0 +1,886 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Microsemi SoCs FDMA driver
+ *
+ * Copyright (c) 2021 Microchip
+ *
+ * Page recycling code is mostly taken from gianfar driver.
+ */
+
+#include <linux/align.h>
+#include <linux/bitops.h>
+#include <linux/dmapool.h>
+#include <linux/dsa/ocelot.h>
+#include <linux/netdevice.h>
+#include <linux/of_platform.h>
+#include <linux/skbuff.h>
+
+#include "ocelot_fdma.h"
+#include "ocelot_qs.h"
+
+DEFINE_STATIC_KEY_FALSE(ocelot_fdma_enabled);
+
+static void ocelot_fdma_writel(struct ocelot *ocelot, u32 reg, u32 data)
+{
+	regmap_write(ocelot->targets[FDMA], reg, data);
+}
+
+static u32 ocelot_fdma_readl(struct ocelot *ocelot, u32 reg)
+{
+	u32 retval;
+
+	regmap_read(ocelot->targets[FDMA], reg, &retval);
+
+	return retval;
+}
+
+static dma_addr_t ocelot_fdma_idx_dma(dma_addr_t base, u16 idx)
+{
+	return base + idx * sizeof(struct ocelot_fdma_dcb);
+}
+
+static u16 ocelot_fdma_dma_idx(dma_addr_t base, dma_addr_t dma)
+{
+	return (dma - base) / sizeof(struct ocelot_fdma_dcb);
+}
+
+static u16 ocelot_fdma_idx_next(u16 idx, u16 ring_sz)
+{
+	return unlikely(idx == ring_sz - 1) ? 0 : idx + 1;
+}
+
+static u16 ocelot_fdma_idx_prev(u16 idx, u16 ring_sz)
+{
+	return unlikely(idx == 0) ? ring_sz - 1 : idx - 1;
+}
+
+static int ocelot_fdma_rx_ring_free(struct ocelot_fdma *fdma)
+{
+	struct ocelot_fdma_rx_ring *rx_ring = &fdma->rx_ring;
+
+	if (rx_ring->next_to_use >= rx_ring->next_to_clean)
+		return OCELOT_FDMA_RX_RING_SIZE -
+		       (rx_ring->next_to_use - rx_ring->next_to_clean) - 1;
+	else
+		return rx_ring->next_to_clean - rx_ring->next_to_use - 1;
+}
+
+static int ocelot_fdma_tx_ring_free(struct ocelot_fdma *fdma)
+{
+	struct ocelot_fdma_tx_ring *tx_ring = &fdma->tx_ring;
+
+	if (tx_ring->next_to_use >= tx_ring->next_to_clean)
+		return OCELOT_FDMA_TX_RING_SIZE -
+		       (tx_ring->next_to_use - tx_ring->next_to_clean) - 1;
+	else
+		return tx_ring->next_to_clean - tx_ring->next_to_use - 1;
+}
+
+static bool ocelot_fdma_tx_ring_empty(struct ocelot_fdma *fdma)
+{
+	struct ocelot_fdma_tx_ring *tx_ring = &fdma->tx_ring;
+
+	return tx_ring->next_to_clean == tx_ring->next_to_use;
+}
+
+static void ocelot_fdma_activate_chan(struct ocelot *ocelot, dma_addr_t dma,
+				      int chan)
+{
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_DCB_LLP(chan), dma);
+	/* Barrier to force memory writes to DCB to be completed before starting
+	 * the channel.
+	 */
+	wmb();
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_CH_ACTIVATE, BIT(chan));
+}
+
+static int ocelot_fdma_wait_chan_safe(struct ocelot *ocelot, int chan)
+{
+	unsigned long timeout;
+	u32 safe;
+
+	timeout = jiffies + usecs_to_jiffies(OCELOT_FDMA_CH_SAFE_TIMEOUT_US);
+	do {
+		safe = ocelot_fdma_readl(ocelot, MSCC_FDMA_CH_SAFE);
+		if (safe & BIT(chan))
+			return 0;
+	} while (time_after(jiffies, timeout));
+
+	return -ETIMEDOUT;
+}
+
+static void ocelot_fdma_dcb_set_data(struct ocelot_fdma_dcb *dcb,
+				     dma_addr_t dma_addr,
+				     size_t size)
+{
+	u32 offset = dma_addr & 0x3;
+
+	dcb->llp = 0;
+	dcb->datap = ALIGN_DOWN(dma_addr, 4);
+	dcb->datal = ALIGN_DOWN(size, 4);
+	dcb->stat = MSCC_FDMA_DCB_STAT_BLOCKO(offset);
+}
+
+static bool ocelot_fdma_rx_alloc_page(struct ocelot *ocelot,
+				      struct ocelot_fdma_rx_buf *rxb)
+{
+	dma_addr_t mapping;
+	struct page *page;
+
+	page = dev_alloc_page();
+	if (unlikely(!page))
+		return false;
+
+	mapping = dma_map_page(ocelot->dev, page, 0, PAGE_SIZE,
+			       DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(ocelot->dev, mapping))) {
+		__free_page(page);
+		return false;
+	}
+
+	rxb->page = page;
+	rxb->page_offset = 0;
+	rxb->dma_addr = mapping;
+
+	return true;
+}
+
+static int ocelot_fdma_alloc_rx_buffs(struct ocelot *ocelot, u16 alloc_cnt)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+	struct ocelot_fdma_rx_ring *rx_ring;
+	struct ocelot_fdma_rx_buf *rxb;
+	struct ocelot_fdma_dcb *dcb;
+	dma_addr_t dma_addr;
+	int ret = 0;
+	u16 idx;
+
+	rx_ring = &fdma->rx_ring;
+	idx = rx_ring->next_to_use;
+
+	while (alloc_cnt--) {
+		rxb = &rx_ring->bufs[idx];
+		/* try reuse page */
+		if (unlikely(!rxb->page)) {
+			if (unlikely(!ocelot_fdma_rx_alloc_page(ocelot, rxb))) {
+				dev_err_ratelimited(ocelot->dev,
+						    "Failed to allocate rx\n");
+				ret = -ENOMEM;
+				break;
+			}
+		}
+
+		dcb = &rx_ring->dcbs[idx];
+		dma_addr = rxb->dma_addr + rxb->page_offset;
+		ocelot_fdma_dcb_set_data(dcb, dma_addr, OCELOT_FDMA_RXB_SIZE);
+
+		idx = ocelot_fdma_idx_next(idx, OCELOT_FDMA_RX_RING_SIZE);
+		/* Chain the DCB to the next one */
+		dcb->llp = ocelot_fdma_idx_dma(rx_ring->dcbs_dma, idx);
+	}
+
+	rx_ring->next_to_use = idx;
+	rx_ring->next_to_alloc = idx;
+
+	return ret;
+}
+
+static bool ocelot_fdma_tx_dcb_set_skb(struct ocelot *ocelot,
+				       struct ocelot_fdma_tx_buf *tx_buf,
+				       struct ocelot_fdma_dcb *dcb,
+				       struct sk_buff *skb)
+{
+	dma_addr_t mapping;
+
+	mapping = dma_map_single(ocelot->dev, skb->data, skb->len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(ocelot->dev, mapping)))
+		return false;
+
+	dma_unmap_addr_set(tx_buf, dma_addr, mapping);
+
+	ocelot_fdma_dcb_set_data(dcb, mapping, OCELOT_FDMA_RX_SIZE);
+	tx_buf->skb = skb;
+	dcb->stat |= MSCC_FDMA_DCB_STAT_BLOCKL(skb->len);
+	dcb->stat |= MSCC_FDMA_DCB_STAT_SOF | MSCC_FDMA_DCB_STAT_EOF;
+
+	return true;
+}
+
+static bool ocelot_fdma_check_stop_rx(struct ocelot *ocelot)
+{
+	u32 llp;
+
+	/* Check if the FDMA hits the DCB with LLP == NULL */
+	llp = ocelot_fdma_readl(ocelot, MSCC_FDMA_DCB_LLP(MSCC_FDMA_XTR_CHAN));
+	if (unlikely(llp))
+		return false;
+
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_CH_DISABLE, BIT(MSCC_FDMA_XTR_CHAN));
+
+	return true;
+}
+
+static void ocelot_fdma_rx_set_llp(struct ocelot_fdma_rx_ring *rx_ring)
+{
+	struct ocelot_fdma_dcb *dcb;
+	unsigned int idx;
+
+	idx = ocelot_fdma_idx_prev(rx_ring->next_to_use,
+				   OCELOT_FDMA_RX_RING_SIZE);
+	dcb = &rx_ring->dcbs[idx];
+	dcb->llp = 0;
+}
+
+static void ocelot_fdma_rx_restart(struct ocelot *ocelot)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+	struct ocelot_fdma_rx_ring *rx_ring;
+	const u8 chan = MSCC_FDMA_XTR_CHAN;
+	dma_addr_t new_llp, dma_base;
+	unsigned int idx;
+	u32 llp_prev;
+	int ret;
+
+	rx_ring = &fdma->rx_ring;
+	ret = ocelot_fdma_wait_chan_safe(ocelot, chan);
+	if (ret) {
+		dev_err_ratelimited(ocelot->dev,
+				    "Unable to stop RX channel\n");
+		return;
+	}
+
+	ocelot_fdma_rx_set_llp(rx_ring);
+
+	/* FDMA stopped on the last DCB that contained a NULL LLP, since
+	 * we processed some DCBs in RX, there is free space, and  we must set
+	 * DCB_LLP to point to the next DCB
+	 */
+	llp_prev = ocelot_fdma_readl(ocelot, MSCC_FDMA_DCB_LLP_PREV(chan));
+	dma_base = rx_ring->dcbs_dma;
+
+	/* Get the next DMA addr located after LLP == NULL DCB */
+	idx = ocelot_fdma_dma_idx(dma_base, llp_prev);
+	idx = ocelot_fdma_idx_next(idx, OCELOT_FDMA_RX_RING_SIZE);
+	new_llp = ocelot_fdma_idx_dma(dma_base, idx);
+
+	/* Finally reactivate the channel */
+	ocelot_fdma_activate_chan(ocelot, new_llp, chan);
+}
+
+static bool ocelot_fdma_add_rx_frag(struct ocelot_fdma_rx_buf *rxb, u32 stat,
+				    struct sk_buff *skb, bool first)
+{
+	int size = MSCC_FDMA_DCB_STAT_BLOCKL(stat);
+	struct page *page = rxb->page;
+
+	if (likely(first)) {
+		skb_put(skb, size);
+	} else {
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
+				rxb->page_offset, size, OCELOT_FDMA_RX_SIZE);
+	}
+
+	/* Try to reuse page */
+	if (unlikely(page_ref_count(page) != 1 || page_is_pfmemalloc(page)))
+		return false;
+
+	/* Change offset to the other half */
+	rxb->page_offset ^= OCELOT_FDMA_RX_SIZE;
+
+	page_ref_inc(page);
+
+	return true;
+}
+
+static void ocelot_fdma_reuse_rx_page(struct ocelot *ocelot,
+				      struct ocelot_fdma_rx_buf *old_rxb)
+{
+	struct ocelot_fdma_rx_ring *rx_ring = &ocelot->fdma->rx_ring;
+	struct ocelot_fdma_rx_buf *new_rxb;
+
+	new_rxb = &rx_ring->bufs[rx_ring->next_to_alloc];
+	rx_ring->next_to_alloc = ocelot_fdma_idx_next(rx_ring->next_to_alloc,
+						      OCELOT_FDMA_RX_RING_SIZE);
+
+	/* Copy page reference */
+	*new_rxb = *old_rxb;
+
+	/* Sync for use by the device */
+	dma_sync_single_range_for_device(ocelot->dev, old_rxb->dma_addr,
+					 old_rxb->page_offset,
+					 OCELOT_FDMA_RX_SIZE, DMA_FROM_DEVICE);
+}
+
+static struct sk_buff *ocelot_fdma_get_skb(struct ocelot *ocelot, u32 stat,
+					   struct ocelot_fdma_rx_buf *rxb,
+					   struct sk_buff *skb)
+{
+	bool first = false;
+
+	/* Allocate skb head and data */
+	if (likely(!skb)) {
+		void *buff_addr = page_address(rxb->page) +
+				  rxb->page_offset;
+
+		skb = build_skb(buff_addr, OCELOT_FDMA_SKBFRAG_SIZE);
+		if (unlikely(!skb)) {
+			dev_err_ratelimited(ocelot->dev,
+					    "build_skb failed !\n");
+			return NULL;
+		}
+		first = true;
+	}
+
+	dma_sync_single_range_for_cpu(ocelot->dev, rxb->dma_addr,
+				      rxb->page_offset, OCELOT_FDMA_RX_SIZE,
+				      DMA_FROM_DEVICE);
+
+	if (ocelot_fdma_add_rx_frag(rxb, stat, skb, first)) {
+		/* Reuse the free half of the page for the next_to_alloc DCB*/
+		ocelot_fdma_reuse_rx_page(ocelot, rxb);
+	} else {
+		/* page cannot be reused, unmap it */
+		dma_unmap_page(ocelot->dev, rxb->dma_addr, PAGE_SIZE,
+			       DMA_FROM_DEVICE);
+	}
+
+	/* clear rx buff content */
+	rxb->page = NULL;
+
+	return skb;
+}
+
+static bool ocelot_fdma_receive_skb(struct ocelot *ocelot, struct sk_buff *skb)
+{
+	struct net_device *ndev;
+	void *xfh = skb->data;
+	u64 timestamp;
+	u64 src_port;
+
+	skb_pull(skb, OCELOT_TAG_LEN);
+
+	ocelot_xfh_get_src_port(xfh, &src_port);
+	if (unlikely(src_port >= ocelot->num_phys_ports))
+		return false;
+
+	ndev = ocelot_port_to_netdev(ocelot, src_port);
+	if (unlikely(!ndev))
+		return false;
+
+	pskb_trim(skb, skb->len - ETH_FCS_LEN);
+
+	skb->dev = ndev;
+	skb->protocol = eth_type_trans(skb, skb->dev);
+	skb->dev->stats.rx_bytes += skb->len;
+	skb->dev->stats.rx_packets++;
+
+	if (ocelot->ptp) {
+		ocelot_xfh_get_rew_val(xfh, &timestamp);
+		ocelot_ptp_rx_timestamp(ocelot, skb, timestamp);
+	}
+
+	if (likely(!skb_defer_rx_timestamp(skb)))
+		netif_receive_skb(skb);
+
+	return true;
+}
+
+static int ocelot_fdma_rx_get(struct ocelot *ocelot, int budget)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+	struct ocelot_fdma_rx_ring *rx_ring;
+	struct ocelot_fdma_rx_buf *rxb;
+	struct ocelot_fdma_dcb *dcb;
+	struct sk_buff *skb;
+	int work_done = 0;
+	int cleaned_cnt;
+	u32 stat;
+	u16 idx;
+
+	cleaned_cnt = ocelot_fdma_rx_ring_free(fdma);
+	rx_ring = &fdma->rx_ring;
+	skb = rx_ring->skb;
+
+	while (budget--) {
+		idx = rx_ring->next_to_clean;
+		dcb = &rx_ring->dcbs[idx];
+		stat = dcb->stat;
+		if (MSCC_FDMA_DCB_STAT_BLOCKL(stat) == 0)
+			break;
+
+		/* New packet is a start of frame but we already got a skb set,
+		 * we probably lost an EOF packet, free skb
+		 */
+		if (unlikely(skb && (stat & MSCC_FDMA_DCB_STAT_SOF))) {
+			dev_kfree_skb(skb);
+			skb = NULL;
+		}
+
+		rxb = &rx_ring->bufs[idx];
+		/* Fetch next to clean buffer from the rx_ring */
+		skb = ocelot_fdma_get_skb(ocelot, stat, rxb, skb);
+		if (unlikely(!skb))
+			break;
+
+		work_done++;
+		cleaned_cnt++;
+
+		idx = ocelot_fdma_idx_next(idx, OCELOT_FDMA_RX_RING_SIZE);
+		rx_ring->next_to_clean = idx;
+
+		if (unlikely(stat & MSCC_FDMA_DCB_STAT_ABORT ||
+			     stat & MSCC_FDMA_DCB_STAT_PD)) {
+			dev_err_ratelimited(ocelot->dev,
+					    "DCB aborted or pruned\n");
+			dev_kfree_skb(skb);
+			skb = NULL;
+			continue;
+		}
+
+		/* We still need to process the other fragment of the packet
+		 * before delivering it to the network stack
+		 */
+		if (!(stat & MSCC_FDMA_DCB_STAT_EOF))
+			continue;
+
+		if (unlikely(!ocelot_fdma_receive_skb(ocelot, skb)))
+			dev_kfree_skb(skb);
+
+		skb = NULL;
+	}
+
+	rx_ring->skb = skb;
+
+	if (cleaned_cnt)
+		ocelot_fdma_alloc_rx_buffs(ocelot, cleaned_cnt);
+
+	return work_done;
+}
+
+static void ocelot_fdma_wakeup_netdev(struct ocelot *ocelot)
+{
+	struct ocelot_port_private *priv;
+	struct ocelot_port *ocelot_port;
+	struct net_device *dev;
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		ocelot_port = ocelot->ports[port];
+		if (!ocelot_port)
+			continue;
+		priv = container_of(ocelot_port, struct ocelot_port_private, port);
+		dev = priv->dev;
+
+		if (unlikely(netif_queue_stopped(dev)))
+			netif_wake_queue(dev);
+	}
+}
+
+static void ocelot_fdma_tx_cleanup(struct ocelot *ocelot, int budget)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+	struct ocelot_fdma_tx_ring *tx_ring;
+	struct ocelot_fdma_tx_buf *buf;
+	unsigned int new_null_llp_idx;
+	struct ocelot_fdma_dcb *dcb;
+	bool end_of_list = false;
+	struct sk_buff *skb;
+	dma_addr_t dma;
+	u32 dcb_llp;
+	u16 ntc;
+	int ret;
+
+	tx_ring = &fdma->tx_ring;
+
+	/* Purge the TX packets that have been sent up to the NULL llp or the
+	 * end of done list.
+	 */
+	while (!ocelot_fdma_tx_ring_empty(fdma)) {
+		ntc = tx_ring->next_to_clean;
+		dcb = &tx_ring->dcbs[ntc];
+		if (!(dcb->stat & MSCC_FDMA_DCB_STAT_PD))
+			break;
+
+		buf = &tx_ring->bufs[ntc];
+		skb = buf->skb;
+		dma_unmap_single(ocelot->dev, dma_unmap_addr(buf, dma_addr),
+				 skb->len, DMA_TO_DEVICE);
+		napi_consume_skb(skb, budget);
+		dcb_llp = dcb->llp;
+
+		/* Only update after accessing all dcb fields */
+		tx_ring->next_to_clean = ocelot_fdma_idx_next(ntc, OCELOT_FDMA_TX_RING_SIZE);
+
+		/* If we hit the NULL LLP, stop, we might need to reload FDMA */
+		if (dcb_llp == 0) {
+			end_of_list = true;
+			break;
+		}
+	}
+
+	/* No need to try to wake if there were no TX cleaned_cnt up. */
+	if (ocelot_fdma_tx_ring_free(fdma))
+		ocelot_fdma_wakeup_netdev(ocelot);
+
+	/* If there is still some DCBs to be processed by the FDMA or if the
+	 * pending list is empty, there is no need to restart the FDMA.
+	 */
+	if (!end_of_list || ocelot_fdma_tx_ring_empty(fdma))
+		return;
+
+	ret = ocelot_fdma_wait_chan_safe(ocelot, MSCC_FDMA_INJ_CHAN);
+	if (ret) {
+		dev_warn(ocelot->dev, "Failed to wait for TX channel to stop\n");
+		return;
+	}
+
+	/* Set NULL LLP to be the last DCB used */
+	new_null_llp_idx = ocelot_fdma_idx_prev(tx_ring->next_to_use,
+						OCELOT_FDMA_TX_RING_SIZE);
+	dcb = &tx_ring->dcbs[new_null_llp_idx];
+	dcb->llp = 0;
+
+	dma = ocelot_fdma_idx_dma(tx_ring->dcbs_dma, tx_ring->next_to_clean);
+	ocelot_fdma_activate_chan(ocelot, dma, MSCC_FDMA_INJ_CHAN);
+}
+
+static int ocelot_fdma_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct ocelot_fdma *fdma = container_of(napi, struct ocelot_fdma, napi);
+	struct ocelot *ocelot = fdma->ocelot;
+	int work_done = 0;
+	bool rx_stopped;
+
+	ocelot_fdma_tx_cleanup(ocelot, budget);
+
+	rx_stopped = ocelot_fdma_check_stop_rx(ocelot);
+
+	work_done = ocelot_fdma_rx_get(ocelot, budget);
+
+	if (rx_stopped)
+		ocelot_fdma_rx_restart(ocelot);
+
+	if (work_done < budget) {
+		napi_complete_done(&fdma->napi, work_done);
+		ocelot_fdma_writel(ocelot, MSCC_FDMA_INTR_ENA,
+				   BIT(MSCC_FDMA_INJ_CHAN) |
+				   BIT(MSCC_FDMA_XTR_CHAN));
+	}
+
+	return work_done;
+}
+
+static irqreturn_t ocelot_fdma_interrupt(int irq, void *dev_id)
+{
+	u32 ident, llp, frm, err, err_code;
+	struct ocelot *ocelot = dev_id;
+
+	ident = ocelot_fdma_readl(ocelot, MSCC_FDMA_INTR_IDENT);
+	frm = ocelot_fdma_readl(ocelot, MSCC_FDMA_INTR_FRM);
+	llp = ocelot_fdma_readl(ocelot, MSCC_FDMA_INTR_LLP);
+
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_INTR_LLP, llp & ident);
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_INTR_FRM, frm & ident);
+	if (frm || llp) {
+		ocelot_fdma_writel(ocelot, MSCC_FDMA_INTR_ENA, 0);
+		napi_schedule(&ocelot->fdma->napi);
+	}
+
+	err = ocelot_fdma_readl(ocelot, MSCC_FDMA_EVT_ERR);
+	if (unlikely(err)) {
+		err_code = ocelot_fdma_readl(ocelot, MSCC_FDMA_EVT_ERR_CODE);
+		dev_err_ratelimited(ocelot->dev,
+				    "Error ! chans mask: %#x, code: %#x\n",
+				    err, err_code);
+
+		ocelot_fdma_writel(ocelot, MSCC_FDMA_EVT_ERR, err);
+		ocelot_fdma_writel(ocelot, MSCC_FDMA_EVT_ERR_CODE, err_code);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void ocelot_fdma_send_skb(struct ocelot *ocelot,
+				 struct ocelot_fdma *fdma, struct sk_buff *skb)
+{
+	struct ocelot_fdma_tx_ring *tx_ring = &fdma->tx_ring;
+	struct ocelot_fdma_tx_buf *tx_buf;
+	struct ocelot_fdma_dcb *dcb;
+	dma_addr_t dma;
+	u16 next_idx;
+
+	dcb = &tx_ring->dcbs[tx_ring->next_to_use];
+	tx_buf = &tx_ring->bufs[tx_ring->next_to_use];
+	if (!ocelot_fdma_tx_dcb_set_skb(ocelot, tx_buf, dcb, skb)) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
+	next_idx = ocelot_fdma_idx_next(tx_ring->next_to_use,
+					OCELOT_FDMA_TX_RING_SIZE);
+	/* If the FDMA TX chan is empty, then enqueue the DCB directly */
+	if (ocelot_fdma_tx_ring_empty(fdma)) {
+		dma = ocelot_fdma_idx_dma(tx_ring->dcbs_dma, tx_ring->next_to_use);
+		ocelot_fdma_activate_chan(ocelot, dma, MSCC_FDMA_INJ_CHAN);
+	} else {
+		/* Chain the DCBs */
+		dcb->llp = ocelot_fdma_idx_dma(tx_ring->dcbs_dma, next_idx);
+	}
+	skb_tx_timestamp(skb);
+
+	tx_ring->next_to_use = next_idx;
+}
+
+static int ocelot_fdma_prepare_skb(struct ocelot *ocelot, int port,
+				   u32 rew_op, struct sk_buff *skb,
+				   struct net_device *dev)
+{
+	int needed_headroom = max_t(int, OCELOT_TAG_LEN - skb_headroom(skb), 0);
+	int needed_tailroom = max_t(int, ETH_FCS_LEN - skb_tailroom(skb), 0);
+	void *ifh;
+	int err;
+
+	if (unlikely(needed_headroom || needed_tailroom ||
+		     skb_header_cloned(skb))) {
+		err = pskb_expand_head(skb, needed_headroom, needed_tailroom,
+				       GFP_ATOMIC);
+		if (unlikely(err)) {
+			dev_kfree_skb_any(skb);
+			return 1;
+		}
+	}
+
+	err = skb_linearize(skb);
+	if (err) {
+		net_err_ratelimited("%s: skb_linearize error (%d)!\n",
+				    dev->name, err);
+		dev_kfree_skb_any(skb);
+		return 1;
+	}
+
+	ifh = skb_push(skb, OCELOT_TAG_LEN);
+	skb_put(skb, ETH_FCS_LEN);
+	memset(ifh, 0, OCELOT_TAG_LEN);
+	ocelot_ifh_port_set(ifh, port, rew_op, skb_vlan_tag_get(skb));
+
+	return 0;
+}
+
+int ocelot_fdma_inject_frame(struct ocelot *ocelot, int port, u32 rew_op,
+			     struct sk_buff *skb, struct net_device *dev)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+	int ret = NETDEV_TX_OK;
+
+	spin_lock(&fdma->tx_ring.xmit_lock);
+
+	if (ocelot_fdma_tx_ring_free(fdma) == 0) {
+		netif_stop_queue(dev);
+		ret = NETDEV_TX_BUSY;
+		goto out;
+	}
+
+	if (ocelot_fdma_prepare_skb(ocelot, port, rew_op, skb, dev))
+		goto out;
+
+	ocelot_fdma_send_skb(ocelot, fdma, skb);
+
+out:
+	spin_unlock(&fdma->tx_ring.xmit_lock);
+
+	return ret;
+}
+
+static void ocelot_fdma_free_rx_ring(struct ocelot *ocelot)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+	struct ocelot_fdma_rx_ring *rx_ring;
+	struct ocelot_fdma_rx_buf *rxb;
+	u16 idx;
+
+	rx_ring = &fdma->rx_ring;
+	idx = rx_ring->next_to_clean;
+
+	/* Free the pages held in the RX ring */
+	while (idx != rx_ring->next_to_use) {
+		rxb = &rx_ring->bufs[idx];
+		dma_unmap_page(ocelot->dev, rxb->dma_addr, PAGE_SIZE,
+			       DMA_FROM_DEVICE);
+		__free_page(rxb->page);
+		idx = ocelot_fdma_idx_next(idx, OCELOT_FDMA_RX_RING_SIZE);
+	}
+
+	if (fdma->rx_ring.skb)
+		dev_kfree_skb_any(fdma->rx_ring.skb);
+}
+
+static void ocelot_fdma_free_tx_ring(struct ocelot *ocelot)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+	struct ocelot_fdma_tx_ring *tx_ring;
+	struct ocelot_fdma_tx_buf *txb;
+	struct sk_buff *skb;
+	u16 idx;
+
+	tx_ring = &fdma->tx_ring;
+	idx = tx_ring->next_to_clean;
+
+	while (idx != tx_ring->next_to_use) {
+		txb = &tx_ring->bufs[idx];
+		skb = txb->skb;
+		dma_unmap_single(ocelot->dev, txb->dma_addr, skb->len,
+				 DMA_TO_DEVICE);
+		dev_kfree_skb_any(skb);
+		idx = ocelot_fdma_idx_next(idx, OCELOT_FDMA_TX_RING_SIZE);
+	}
+}
+
+static int ocelot_fdma_rings_alloc(struct ocelot *ocelot)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+	struct ocelot_fdma_dcb *dcbs;
+	unsigned int adjust;
+	dma_addr_t dcbs_dma;
+	int ret;
+
+	/* Create a pool of consistent memory blocks for hardware descriptors */
+	fdma->dcbs_base = dmam_alloc_coherent(ocelot->dev,
+					      OCELOT_DCBS_HW_ALLOC_SIZE,
+					      &fdma->dcbs_dma_base, GFP_KERNEL);
+	if (!fdma->dcbs_base)
+		return -ENOMEM;
+
+	/* DCBs must be aligned on a 32bit boundary */
+	dcbs = fdma->dcbs_base;
+	dcbs_dma = fdma->dcbs_dma_base;
+	if (!IS_ALIGNED(dcbs_dma, 4)) {
+		adjust = dcbs_dma & 0x3;
+		dcbs_dma = ALIGN(dcbs_dma, 4);
+		dcbs = (void *)dcbs + adjust;
+	}
+
+	/* TX queue */
+	fdma->tx_ring.dcbs = dcbs;
+	fdma->tx_ring.dcbs_dma = dcbs_dma;
+	spin_lock_init(&fdma->tx_ring.xmit_lock);
+
+	/* RX queue */
+	fdma->rx_ring.dcbs = dcbs + OCELOT_FDMA_TX_RING_SIZE;
+	fdma->rx_ring.dcbs_dma = dcbs_dma + OCELOT_FDMA_TX_DCB_SIZE;
+	ret = ocelot_fdma_alloc_rx_buffs(ocelot, ocelot_fdma_tx_ring_free(fdma));
+	if (ret) {
+		ocelot_fdma_free_rx_ring(ocelot);
+		return ret;
+	}
+
+	/* Set the last DCB LLP as NULL, this is normally done when restarting
+	 * the RX chan, but this is for the first run
+	 */
+	ocelot_fdma_rx_set_llp(&fdma->rx_ring);
+
+	return 0;
+}
+
+void ocelot_fdma_netdev_init(struct ocelot *ocelot, struct net_device *dev)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+
+	dev->needed_headroom = OCELOT_TAG_LEN;
+	dev->needed_tailroom = ETH_FCS_LEN;
+
+	if (fdma->ndev)
+		return;
+
+	fdma->ndev = dev;
+	netif_napi_add(dev, &fdma->napi, ocelot_fdma_napi_poll,
+		       OCELOT_FDMA_WEIGHT);
+}
+
+void ocelot_fdma_netdev_deinit(struct ocelot *ocelot, struct net_device *dev)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+
+	if (fdma->ndev == dev) {
+		netif_napi_del(&fdma->napi);
+		fdma->ndev = NULL;
+	}
+}
+
+void ocelot_fdma_init(struct platform_device *pdev, struct ocelot *ocelot)
+{
+	struct device *dev = ocelot->dev;
+	struct ocelot_fdma *fdma;
+	int ret;
+
+	fdma = devm_kzalloc(dev, sizeof(*fdma), GFP_KERNEL);
+	if (!fdma)
+		return;
+
+	ocelot->fdma = fdma;
+	ocelot->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_INTR_ENA, 0);
+
+	fdma->ocelot = ocelot;
+	fdma->irq = platform_get_irq_byname(pdev, "fdma");
+	ret = devm_request_irq(dev, fdma->irq, ocelot_fdma_interrupt, 0,
+			       dev_name(dev), ocelot);
+	if (ret)
+		goto err_free_fdma;
+
+	ret = ocelot_fdma_rings_alloc(ocelot);
+	if (ret)
+		goto err_free_irq;
+
+	static_branch_enable(&ocelot_fdma_enabled);
+
+	return;
+
+err_free_irq:
+	devm_free_irq(dev, fdma->irq, fdma);
+err_free_fdma:
+	devm_kfree(dev, fdma);
+
+	ocelot->fdma = NULL;
+}
+
+void ocelot_fdma_start(struct ocelot *ocelot)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+
+	/* Reconfigure for extraction and injection using DMA */
+	ocelot_write_rix(ocelot, QS_INJ_GRP_CFG_MODE(2), QS_INJ_GRP_CFG, 0);
+	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(0), QS_INJ_CTRL, 0);
+
+	ocelot_write_rix(ocelot, QS_XTR_GRP_CFG_MODE(2), QS_XTR_GRP_CFG, 0);
+
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_INTR_LLP, 0xffffffff);
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_INTR_FRM, 0xffffffff);
+
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_INTR_LLP_ENA,
+			   BIT(MSCC_FDMA_INJ_CHAN) | BIT(MSCC_FDMA_XTR_CHAN));
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_INTR_FRM_ENA, BIT(MSCC_FDMA_XTR_CHAN));
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_INTR_ENA,
+			   BIT(MSCC_FDMA_INJ_CHAN) | BIT(MSCC_FDMA_XTR_CHAN));
+
+	napi_enable(&fdma->napi);
+
+	ocelot_fdma_activate_chan(ocelot, ocelot->fdma->rx_ring.dcbs_dma,
+				  MSCC_FDMA_XTR_CHAN);
+}
+
+void ocelot_fdma_deinit(struct ocelot *ocelot)
+{
+	struct ocelot_fdma *fdma = ocelot->fdma;
+
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_INTR_ENA, 0);
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_CH_FORCEDIS,
+			   BIT(MSCC_FDMA_XTR_CHAN));
+	ocelot_fdma_writel(ocelot, MSCC_FDMA_CH_FORCEDIS,
+			   BIT(MSCC_FDMA_INJ_CHAN));
+	napi_synchronize(&fdma->napi);
+	napi_disable(&fdma->napi);
+
+	ocelot_fdma_free_rx_ring(ocelot);
+	ocelot_fdma_free_tx_ring(ocelot);
+}
diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.h b/drivers/net/ethernet/mscc/ocelot_fdma.h
new file mode 100644
index 000000000000..b428a1855b3d
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.h
@@ -0,0 +1,166 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Microsemi SoCs FDMA driver
+ *
+ * Copyright (c) 2021 Microchip
+ */
+#ifndef _MSCC_OCELOT_FDMA_H_
+#define _MSCC_OCELOT_FDMA_H_
+
+#include "ocelot.h"
+
+#define MSCC_FDMA_DCB_STAT_BLOCKO(x)	(((x) << 20) & GENMASK(31, 20))
+#define MSCC_FDMA_DCB_STAT_BLOCKO_M	GENMASK(31, 20)
+#define MSCC_FDMA_DCB_STAT_BLOCKO_X(x)	(((x) & GENMASK(31, 20)) >> 20)
+#define MSCC_FDMA_DCB_STAT_PD		BIT(19)
+#define MSCC_FDMA_DCB_STAT_ABORT	BIT(18)
+#define MSCC_FDMA_DCB_STAT_EOF		BIT(17)
+#define MSCC_FDMA_DCB_STAT_SOF		BIT(16)
+#define MSCC_FDMA_DCB_STAT_BLOCKL_M	GENMASK(15, 0)
+#define MSCC_FDMA_DCB_STAT_BLOCKL(x)	((x) & GENMASK(15, 0))
+
+#define MSCC_FDMA_DCB_LLP(x)		((x) * 4 + 0x0)
+#define MSCC_FDMA_DCB_LLP_PREV(x)	((x) * 4 + 0xA0)
+#define MSCC_FDMA_CH_SAFE		0xcc
+#define MSCC_FDMA_CH_ACTIVATE		0xd0
+#define MSCC_FDMA_CH_DISABLE		0xd4
+#define MSCC_FDMA_CH_FORCEDIS		0xd8
+#define MSCC_FDMA_EVT_ERR		0x164
+#define MSCC_FDMA_EVT_ERR_CODE		0x168
+#define MSCC_FDMA_INTR_LLP		0x16c
+#define MSCC_FDMA_INTR_LLP_ENA		0x170
+#define MSCC_FDMA_INTR_FRM		0x174
+#define MSCC_FDMA_INTR_FRM_ENA		0x178
+#define MSCC_FDMA_INTR_ENA		0x184
+#define MSCC_FDMA_INTR_IDENT		0x188
+
+#define MSCC_FDMA_INJ_CHAN		2
+#define MSCC_FDMA_XTR_CHAN		0
+
+#define OCELOT_FDMA_WEIGHT		32
+
+#define OCELOT_FDMA_CH_SAFE_TIMEOUT_US	10
+
+#define OCELOT_FDMA_RX_RING_SIZE	512
+#define OCELOT_FDMA_TX_RING_SIZE	128
+
+#define OCELOT_FDMA_RX_DCB_SIZE		(OCELOT_FDMA_RX_RING_SIZE * \
+					 sizeof(struct ocelot_fdma_dcb))
+#define OCELOT_FDMA_TX_DCB_SIZE		(OCELOT_FDMA_TX_RING_SIZE * \
+					 sizeof(struct ocelot_fdma_dcb))
+/* +4 allows for word alignment after allocation */
+#define OCELOT_DCBS_HW_ALLOC_SIZE	(OCELOT_FDMA_RX_DCB_SIZE + \
+					 OCELOT_FDMA_TX_DCB_SIZE + \
+					 4)
+
+#define OCELOT_FDMA_RX_SIZE		(PAGE_SIZE / 2)
+
+#define OCELOT_FDMA_SKBFRAG_OVR		(4 + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+#define OCELOT_FDMA_RXB_SIZE		ALIGN_DOWN(OCELOT_FDMA_RX_SIZE - OCELOT_FDMA_SKBFRAG_OVR, 4)
+#define OCELOT_FDMA_SKBFRAG_SIZE	(OCELOT_FDMA_RXB_SIZE + OCELOT_FDMA_SKBFRAG_OVR)
+
+DECLARE_STATIC_KEY_FALSE(ocelot_fdma_enabled);
+
+struct ocelot_fdma_dcb {
+	u32 llp;
+	u32 datap;
+	u32 datal;
+	u32 stat;
+} __packed;
+
+/**
+ * struct ocelot_fdma_tx_buf - TX buffer structure
+ * @skb: SKB currently used in the corresponding DCB.
+ * @dma_addr: SKB DMA mapped address.
+ */
+struct ocelot_fdma_tx_buf {
+	struct sk_buff *skb;
+	DEFINE_DMA_UNMAP_ADDR(dma_addr);
+};
+
+/**
+ * struct ocelot_fdma_tx_ring - TX ring description of DCBs
+ *
+ * @dcbs: DCBs allocated for the ring
+ * @dcbs_dma: DMA base address of the DCBs
+ * @bufs: List of TX buffer associated to the DCBs
+ * @next_to_clean: Next DCB to be cleaned in tx_cleanup
+ * @next_to_use: Next available DCB to send SKB
+ * @xmit_lock: lock for concurrent xmit access
+ */
+struct ocelot_fdma_tx_ring {
+	struct ocelot_fdma_dcb *dcbs;
+	dma_addr_t dcbs_dma;
+	struct ocelot_fdma_tx_buf bufs[OCELOT_FDMA_TX_RING_SIZE];
+	/* Protect concurrent xmit calls */
+	spinlock_t xmit_lock;
+	u16 next_to_clean;
+	u16 next_to_use;
+};
+
+/**
+ * struct ocelot_fdma_rx_buf - RX buffer structure
+ * @page: Struct page used in this buffer
+ * @page_offset: Current page offset (either 0 or PAGE_SIZE/2)
+ * @dma_addr: DMA address of the page
+ */
+struct ocelot_fdma_rx_buf {
+	struct page *page;
+	u32 page_offset;
+	dma_addr_t dma_addr;
+};
+
+/**
+ * struct ocelot_fdma_rx_ring - TX ring description of DCBs
+ *
+ * @dcbs: DCBs allocated for the ring
+ * @dcbs_dma: DMA base address of the DCBs
+ * @bufs: List of RX buffer associated to the DCBs
+ * @skb: SKB currently received by the netdev
+ * @next_to_clean: Next DCB to be cleaned NAPI polling
+ * @next_to_use: Next available DCB to send SKB
+ * @next_to_alloc: Next buffer that needs to be allocated (page reuse or alloc)
+ */
+struct ocelot_fdma_rx_ring {
+	struct ocelot_fdma_dcb *dcbs;
+	dma_addr_t dcbs_dma;
+	struct ocelot_fdma_rx_buf bufs[OCELOT_FDMA_RX_RING_SIZE];
+	struct sk_buff *skb;
+	u16 next_to_clean;
+	u16 next_to_use;
+	u16 next_to_alloc;
+};
+
+/**
+ * struct ocelot_fdma - FDMA struct
+ *
+ * @ocelot: Pointer to ocelot struct
+ * @base: base address of FDMA registers
+ * @irq: FDMA interrupt
+ * @ndev: Net device used to initialize NAPI
+ * @dcbs_base: Memory coherent DCBs
+ * @dcbs_dma_base: DMA base address of memory coherent DCBs
+ * @tx_ring: Injection ring
+ * @rx_ring: Extraction ring
+ */
+struct ocelot_fdma {
+	int irq;
+	struct net_device *ndev;
+	struct ocelot_fdma_dcb *dcbs_base;
+	dma_addr_t dcbs_dma_base;
+	struct ocelot_fdma_tx_ring tx_ring;
+	struct ocelot_fdma_rx_ring rx_ring;
+	struct napi_struct napi;
+	struct ocelot *ocelot;
+};
+
+void ocelot_fdma_init(struct platform_device *pdev, struct ocelot *ocelot);
+void ocelot_fdma_start(struct ocelot *ocelot);
+void ocelot_fdma_deinit(struct ocelot *ocelot);
+int ocelot_fdma_inject_frame(struct ocelot *fdma, int port, u32 rew_op,
+			     struct sk_buff *skb, struct net_device *dev);
+void ocelot_fdma_netdev_init(struct ocelot *ocelot, struct net_device *dev);
+void ocelot_fdma_netdev_deinit(struct ocelot *ocelot,
+			       struct net_device *dev);
+
+#endif
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index d83d3ffba3ac..8115c3db252e 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -15,6 +15,7 @@
 #include <net/pkt_cls.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
+#include "ocelot_fdma.h"
 
 #define OCELOT_MAC_QUIRKS	OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP
 
@@ -457,7 +458,8 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	int port = priv->chip_port;
 	u32 rew_op = 0;
 
-	if (!ocelot_can_inject(ocelot, 0))
+	if (!static_branch_unlikely(&ocelot_fdma_enabled) &&
+	    !ocelot_can_inject(ocelot, 0))
 		return NETDEV_TX_BUSY;
 
 	/* Check if timestamping is needed */
@@ -475,9 +477,13 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 		rew_op = ocelot_ptp_rew_op(skb);
 	}
 
-	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
+	if (static_branch_unlikely(&ocelot_fdma_enabled)) {
+		ocelot_fdma_inject_frame(ocelot, port, rew_op, skb, dev);
+	} else {
+		ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
-	kfree_skb(skb);
+		consume_skb(skb);
+	}
 
 	return NETDEV_TX_OK;
 }
@@ -1702,14 +1708,20 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 	if (err)
 		goto out;
 
+	if (ocelot->fdma)
+		ocelot_fdma_netdev_init(ocelot, dev);
+
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(ocelot->dev, "register_netdev failed\n");
-		goto out;
+		goto out_fdma_deinit;
 	}
 
 	return 0;
 
+out_fdma_deinit:
+	if (ocelot->fdma)
+		ocelot_fdma_netdev_deinit(ocelot, dev);
 out:
 	ocelot->ports[port] = NULL;
 	free_netdev(dev);
@@ -1722,9 +1734,14 @@ void ocelot_release_port(struct ocelot_port *ocelot_port)
 	struct ocelot_port_private *priv = container_of(ocelot_port,
 						struct ocelot_port_private,
 						port);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_fdma *fdma = ocelot->fdma;
 
 	unregister_netdev(priv->dev);
 
+	if (fdma)
+		ocelot_fdma_netdev_deinit(ocelot, priv->dev);
+
 	if (priv->phylink) {
 		rtnl_lock();
 		phylink_disconnect_phy(priv->phylink);
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index cd3eb101f159..bee883a0b5b8 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -18,6 +18,7 @@
 
 #include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_hsio.h>
+#include "ocelot_fdma.h"
 #include "ocelot.h"
 
 #define VSC7514_VCAP_POLICER_BASE			128
@@ -275,6 +276,18 @@ static const u32 ocelot_ptp_regmap[] = {
 	REG(PTP_CLK_CFG_ADJ_FREQ,			0x0000a8),
 };
 
+static const u32 ocelot_fdma_regmap[] = {
+	REG(PTP_PIN_CFG,				0x000000),
+	REG(PTP_PIN_TOD_SEC_MSB,			0x000004),
+	REG(PTP_PIN_TOD_SEC_LSB,			0x000008),
+	REG(PTP_PIN_TOD_NSEC,				0x00000c),
+	REG(PTP_PIN_WF_HIGH_PERIOD,			0x000014),
+	REG(PTP_PIN_WF_LOW_PERIOD,			0x000018),
+	REG(PTP_CFG_MISC,				0x0000a0),
+	REG(PTP_CLK_CFG_ADJ_CFG,			0x0000a4),
+	REG(PTP_CLK_CFG_ADJ_FREQ,			0x0000a8),
+};
+
 static const u32 ocelot_dev_gmii_regmap[] = {
 	REG(DEV_CLOCK_CFG,				0x0),
 	REG(DEV_PORT_MISC,				0x4),
@@ -1048,6 +1061,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		{ S1, "s1" },
 		{ S2, "s2" },
 		{ PTP, "ptp", 1 },
+		{ FDMA, "fdma", 1 },
 	};
 
 	if (!np && !pdev->dev.platform_data)
@@ -1083,6 +1097,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		ocelot->targets[io_target[i].id] = target;
 	}
 
+	if (ocelot->targets[FDMA])
+		ocelot_fdma_init(pdev, ocelot);
+
 	hsio = syscon_regmap_lookup_by_compatible("mscc,ocelot-hsio");
 	if (IS_ERR(hsio)) {
 		dev_err(&pdev->dev, "missing hsio syscon\n");
@@ -1146,6 +1163,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		goto out_ocelot_devlink_unregister;
 
+	if (ocelot->fdma)
+		ocelot_fdma_start(ocelot);
+
 	err = ocelot_devlink_sb_register(ocelot);
 	if (err)
 		goto out_ocelot_release_ports;
@@ -1186,6 +1206,8 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 
+	if (ocelot->fdma)
+		ocelot_fdma_deinit(ocelot);
 	devlink_unregister(ocelot->devlink);
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_devlink_sb_unregister(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index f038062a97a9..3e9454b00562 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -118,6 +118,7 @@ enum ocelot_target {
 	S2,
 	HSIO,
 	PTP,
+	FDMA,
 	GCB,
 	DEV_GMII,
 	TARGET_MAX,
@@ -732,6 +733,8 @@ struct ocelot {
 	/* Protects the PTP clock */
 	spinlock_t			ptp_clock_lock;
 	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
+
+	struct ocelot_fdma		*fdma;
 };
 
 struct ocelot_policer {
-- 
2.34.1

