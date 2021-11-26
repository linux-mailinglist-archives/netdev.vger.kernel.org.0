Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BCF45F2F3
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhKZRdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:33:18 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:59977 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbhKZRbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:31:09 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 4FC4C240002;
        Fri, 26 Nov 2021 17:27:54 +0000 (UTC)
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
Subject: [PATCH net-next v3 4/4] net: ocelot: add FDMA support
Date:   Fri, 26 Nov 2021 18:27:39 +0100
Message-Id: <20211126172739.329098-5-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211126172739.329098-1-clement.leger@bootlin.com>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
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
by the driver.

Co-developed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/Makefile         |   1 +
 drivers/net/ethernet/mscc/ocelot.c         |  43 +-
 drivers/net/ethernet/mscc/ocelot.h         |   1 +
 drivers/net/ethernet/mscc/ocelot_fdma.c    | 713 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_fdma.h    |  96 +++
 drivers/net/ethernet/mscc/ocelot_net.c     |  18 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  13 +
 include/soc/mscc/ocelot.h                  |   4 +
 8 files changed, 869 insertions(+), 20 deletions(-)
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
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 1f7c9ff18ac5..4b2460d232c2 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -966,14 +966,37 @@ static int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp, u32 *xfh)
 	return 0;
 }
 
-int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
+void ocelot_ptp_rx_timestamp(struct ocelot *ocelot, struct sk_buff *skb,
+			     u64 timestamp)
 {
 	struct skb_shared_hwtstamps *shhwtstamps;
 	u64 tod_in_ns, full_ts_in_ns;
+	struct timespec64 ts;
+
+	if (!ocelot->ptp)
+		return;
+
+	ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
+
+	tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
+	if ((tod_in_ns & 0xffffffff) < timestamp)
+		full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
+				timestamp;
+	else
+		full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
+				timestamp;
+
+	shhwtstamps = skb_hwtstamps(skb);
+	memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
+	shhwtstamps->hwtstamp = full_ts_in_ns;
+}
+EXPORT_SYMBOL(ocelot_ptp_rx_timestamp);
+
+int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
+{
 	u64 timestamp, src_port, len;
 	u32 xfh[OCELOT_TAG_LEN / 4];
 	struct net_device *dev;
-	struct timespec64 ts;
 	struct sk_buff *skb;
 	int sz, buf_len;
 	u32 val, *buf;
@@ -1029,21 +1052,7 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
 		*buf = val;
 	}
 
-	if (ocelot->ptp) {
-		ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
-
-		tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
-		if ((tod_in_ns & 0xffffffff) < timestamp)
-			full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
-					timestamp;
-		else
-			full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
-					timestamp;
-
-		shhwtstamps = skb_hwtstamps(skb);
-		memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
-		shhwtstamps->hwtstamp = full_ts_in_ns;
-	}
+	ocelot_ptp_rx_timestamp(ocelot, skb, timestamp);
 
 	/* Everything we see on an interface that is in the HW bridge
 	 * has already been forwarded.
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e43da09b8f91..f1a7b403e221 100644
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
index 000000000000..e42c2c3ad273
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
@@ -0,0 +1,713 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Microsemi SoCs FDMA driver
+ *
+ * Copyright (c) 2021 Microchip
+ */
+
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
+#define MSCC_FDMA_DCB_LLP(x)			((x) * 4 + 0x0)
+#define MSCC_FDMA_DCB_LLP_PREV(x)		((x) * 4 + 0xA0)
+
+#define MSCC_FDMA_DCB_STAT_BLOCKO(x)		(((x) << 20) & GENMASK(31, 20))
+#define MSCC_FDMA_DCB_STAT_BLOCKO_M		GENMASK(31, 20)
+#define MSCC_FDMA_DCB_STAT_BLOCKO_X(x)		(((x) & GENMASK(31, 20)) >> 20)
+#define MSCC_FDMA_DCB_STAT_PD			BIT(19)
+#define MSCC_FDMA_DCB_STAT_ABORT		BIT(18)
+#define MSCC_FDMA_DCB_STAT_EOF			BIT(17)
+#define MSCC_FDMA_DCB_STAT_SOF			BIT(16)
+#define MSCC_FDMA_DCB_STAT_BLOCKL_M		GENMASK(15, 0)
+#define MSCC_FDMA_DCB_STAT_BLOCKL(x)		((x) & GENMASK(15, 0))
+
+#define MSCC_FDMA_CH_SAFE			0xcc
+
+#define MSCC_FDMA_CH_ACTIVATE			0xd0
+
+#define MSCC_FDMA_CH_DISABLE			0xd4
+
+#define MSCC_FDMA_EVT_ERR			0x164
+
+#define MSCC_FDMA_EVT_ERR_CODE			0x168
+
+#define MSCC_FDMA_INTR_LLP			0x16c
+
+#define MSCC_FDMA_INTR_LLP_ENA			0x170
+
+#define MSCC_FDMA_INTR_FRM			0x174
+
+#define MSCC_FDMA_INTR_FRM_ENA			0x178
+
+#define MSCC_FDMA_INTR_ENA			0x184
+
+#define MSCC_FDMA_INTR_IDENT			0x188
+
+#define MSCC_FDMA_INJ_CHAN			2
+#define MSCC_FDMA_XTR_CHAN			0
+
+#define OCELOT_FDMA_RX_MTU			ETH_DATA_LEN
+#define OCELOT_FDMA_WEIGHT			32
+#define OCELOT_FDMA_RX_REFILL_COUNT		(OCELOT_FDMA_MAX_DCB / 2)
+
+#define OCELOT_FDMA_CH_SAFE_TIMEOUT_MS		100
+
+#define OCELOT_FDMA_RX_EXTRA_SIZE \
+				(OCELOT_TAG_LEN + ETH_FCS_LEN + ETH_HLEN)
+
+static int ocelot_fdma_rx_buf_size(int mtu)
+{
+	return ALIGN(mtu + OCELOT_FDMA_RX_EXTRA_SIZE, 4);
+}
+
+static void ocelot_fdma_writel(struct ocelot_fdma *fdma, u32 reg, u32 data)
+{
+	writel(data, fdma->base + reg);
+}
+
+static u32 ocelot_fdma_readl(struct ocelot_fdma *fdma, u32 reg)
+{
+	return readl(fdma->base + reg);
+}
+
+static unsigned int ocelot_fdma_idx_incr(unsigned int idx)
+{
+	idx++;
+	if (idx == OCELOT_FDMA_MAX_DCB)
+		idx = 0;
+
+	return idx;
+}
+
+static unsigned int ocelot_fdma_idx_decr(unsigned int idx)
+{
+	if (idx == 0)
+		idx = OCELOT_FDMA_MAX_DCB - 1;
+	else
+		idx--;
+
+	return idx;
+}
+
+static int ocelot_fdma_tx_free_count(struct ocelot_fdma *fdma)
+{
+	struct ocelot_fdma_ring *ring = &fdma->inj;
+
+	if (ring->tail >= ring->head)
+		return OCELOT_FDMA_MAX_DCB - (ring->tail - ring->head) - 1;
+	else
+		return ring->head - ring->tail - 1;
+}
+
+static bool ocelot_fdma_ring_empty(struct ocelot_fdma_ring *ring)
+{
+	return ring->head == ring->tail;
+}
+
+static void ocelot_fdma_activate_chan(struct ocelot_fdma *fdma,
+				      struct ocelot_fdma_dcb *dcb, int chan)
+{
+	ocelot_fdma_writel(fdma, MSCC_FDMA_DCB_LLP(chan), dcb->hw_dma);
+	ocelot_fdma_writel(fdma, MSCC_FDMA_CH_ACTIVATE, BIT(chan));
+}
+
+static int ocelot_fdma_wait_chan_safe(struct ocelot_fdma *fdma, int chan)
+{
+	unsigned long timeout;
+	u32 safe;
+
+	timeout = jiffies + msecs_to_jiffies(OCELOT_FDMA_CH_SAFE_TIMEOUT_MS);
+	do {
+		safe = ocelot_fdma_readl(fdma, MSCC_FDMA_CH_SAFE);
+		if (safe & BIT(chan))
+			return 0;
+	} while (time_after(jiffies, timeout));
+
+	return -ETIMEDOUT;
+}
+
+static int ocelot_fdma_stop_channel(struct ocelot_fdma *fdma, int chan)
+{
+	ocelot_fdma_writel(fdma, MSCC_FDMA_CH_DISABLE, BIT(chan));
+
+	return ocelot_fdma_wait_chan_safe(fdma, chan);
+}
+
+static bool ocelot_fdma_dcb_set_data(struct ocelot_fdma *fdma,
+				     struct ocelot_fdma_dcb *dcb,
+				     struct sk_buff *skb,
+				     size_t size, enum dma_data_direction dir)
+{
+	struct ocelot_fdma_dcb_hw_v2 *hw = dcb->hw;
+	u32 offset;
+
+	dcb->skb = skb;
+	dcb->mapped_size = size;
+	dcb->mapping = dma_map_single(fdma->dev, skb->data, size, dir);
+	if (unlikely(dma_mapping_error(fdma->dev, dcb->mapping)))
+		return false;
+
+	offset = dcb->mapping & 0x3;
+
+	hw->llp = 0;
+	hw->datap = ALIGN_DOWN(dcb->mapping, 4);
+	hw->datal = ALIGN_DOWN(size, 4);
+	hw->stat = MSCC_FDMA_DCB_STAT_BLOCKO(offset);
+
+	return true;
+}
+
+static bool ocelot_fdma_rx_set_skb(struct ocelot_fdma *fdma,
+				   struct ocelot_fdma_dcb *dcb,
+				   struct sk_buff *skb, size_t size)
+{
+	return ocelot_fdma_dcb_set_data(fdma, dcb, skb, size,
+					DMA_FROM_DEVICE);
+}
+
+static bool ocelot_fdma_tx_dcb_set_skb(struct ocelot_fdma *fdma,
+				       struct ocelot_fdma_dcb *dcb,
+				       struct sk_buff *skb)
+{
+	if (!ocelot_fdma_dcb_set_data(fdma, dcb, skb, skb->len,
+				      DMA_TO_DEVICE))
+		return false;
+
+	dcb->hw->stat |= MSCC_FDMA_DCB_STAT_BLOCKL(skb->len);
+	dcb->hw->stat |= MSCC_FDMA_DCB_STAT_SOF | MSCC_FDMA_DCB_STAT_EOF;
+
+	return true;
+}
+
+static void ocelot_fdma_rx_restart(struct ocelot_fdma *fdma)
+{
+	struct ocelot_fdma_ring *ring = &fdma->xtr;
+	struct ocelot_fdma_dcb *dcb, *last_dcb;
+	unsigned int idx;
+	int ret;
+	u32 llp;
+
+	/* Check if the FDMA hits the DCB with LLP == NULL */
+	llp = ocelot_fdma_readl(fdma, MSCC_FDMA_DCB_LLP(MSCC_FDMA_XTR_CHAN));
+	if (llp)
+		return;
+
+	ret = ocelot_fdma_stop_channel(fdma, MSCC_FDMA_XTR_CHAN);
+	if (ret) {
+		dev_warn(fdma->dev, "Unable to stop RX channel\n");
+		return;
+	}
+
+	/* Chain the tail with the next DCB */
+	dcb = &ring->dcbs[ring->tail];
+	idx = ocelot_fdma_idx_incr(ring->tail);
+	dcb->hw->llp = ring->dcbs[idx].hw_dma;
+	dcb = &ring->dcbs[idx];
+
+	/* Place a NULL terminator in last DCB added (head - 1) */
+	idx = ocelot_fdma_idx_decr(ring->head);
+	last_dcb = &ring->dcbs[idx];
+	last_dcb->hw->llp = 0;
+	ring->tail = idx;
+
+	/* Finally reactivate the channel */
+	ocelot_fdma_activate_chan(fdma, dcb, MSCC_FDMA_XTR_CHAN);
+}
+
+static bool ocelot_fdma_rx_get(struct ocelot_fdma *fdma, int budget)
+{
+	struct ocelot_fdma_ring *ring = &fdma->xtr;
+	struct ocelot_fdma_dcb *dcb, *next_dcb;
+	struct ocelot *ocelot = fdma->ocelot;
+	struct net_device *ndev;
+	struct sk_buff *skb;
+	bool valid = true;
+	u64 timestamp;
+	u64 src_port;
+	void *xfh;
+	u32 stat;
+
+	/* We should not go past the tail */
+	if (ring->head == ring->tail)
+		return false;
+
+	dcb = &ring->dcbs[ring->head];
+	stat = dcb->hw->stat;
+	if (MSCC_FDMA_DCB_STAT_BLOCKL(stat) == 0)
+		return false;
+
+	ring->head = ocelot_fdma_idx_incr(ring->head);
+
+	if (stat & MSCC_FDMA_DCB_STAT_ABORT || stat & MSCC_FDMA_DCB_STAT_PD)
+		valid = false;
+
+	if (!(stat & MSCC_FDMA_DCB_STAT_SOF) ||
+	    !(stat & MSCC_FDMA_DCB_STAT_EOF))
+		valid = false;
+
+	dma_unmap_single(fdma->dev, dcb->mapping, dcb->mapped_size,
+			 DMA_FROM_DEVICE);
+
+	skb = dcb->skb;
+
+	if (unlikely(!valid)) {
+		dev_warn(fdma->dev, "Invalid packet\n");
+		goto refill;
+	}
+
+	xfh = skb->data;
+	ocelot_xfh_get_src_port(xfh, &src_port);
+
+	if (WARN_ON(src_port >= ocelot->num_phys_ports))
+		goto refill;
+
+	ndev = ocelot_port_to_netdev(ocelot, src_port);
+	if (unlikely(!ndev))
+		goto refill;
+
+	skb_put(skb, MSCC_FDMA_DCB_STAT_BLOCKL(stat) - ETH_FCS_LEN);
+	skb_pull(skb, OCELOT_TAG_LEN);
+
+	skb->dev = ndev;
+	skb->protocol = eth_type_trans(skb, skb->dev);
+	skb->dev->stats.rx_bytes += skb->len;
+	skb->dev->stats.rx_packets++;
+
+	ocelot_ptp_rx_timestamp(ocelot, skb, timestamp);
+
+	if (!skb_defer_rx_timestamp(skb))
+		netif_receive_skb(skb);
+
+	skb = napi_alloc_skb(&fdma->napi, fdma->rx_buf_size);
+	if (!skb)
+		return false;
+
+refill:
+	if (!ocelot_fdma_rx_set_skb(fdma, dcb, skb, fdma->rx_buf_size))
+		return false;
+
+	/* Chain the next DCB */
+	next_dcb = &ring->dcbs[ring->head];
+	dcb->hw->llp = next_dcb->hw_dma;
+
+	return true;
+}
+
+static void ocelot_fdma_tx_cleanup(struct ocelot_fdma *fdma, int budget)
+{
+	struct ocelot_fdma_ring *ring = &fdma->inj;
+	unsigned int tmp_head, new_null_llp_idx;
+	struct ocelot_fdma_dcb *dcb;
+	bool end_of_list = false;
+	int ret;
+
+	spin_lock_bh(&fdma->xmit_lock);
+
+	/* Purge the TX packets that have been sent up to the NULL llp or the
+	 * end of done list.
+	 */
+	while (!ocelot_fdma_ring_empty(&fdma->inj)) {
+		dcb = &ring->dcbs[ring->head];
+		if (!(dcb->hw->stat & MSCC_FDMA_DCB_STAT_PD))
+			break;
+
+		tmp_head = ring->head;
+		ring->head = ocelot_fdma_idx_incr(ring->head);
+
+		dma_unmap_single(fdma->dev, dcb->mapping, dcb->mapped_size,
+				 DMA_TO_DEVICE);
+		napi_consume_skb(dcb->skb, budget);
+
+		/* If we hit the NULL LLP, stop, we might need to reload FDMA */
+		if (dcb->hw->llp == 0) {
+			end_of_list = true;
+			break;
+		}
+	}
+
+	/* If there is still some DCBs to be processed by the FDMA or if the
+	 * pending list is empty, there is no need to restart the FDMA.
+	 */
+	if (!end_of_list || ocelot_fdma_ring_empty(&fdma->inj))
+		goto out_unlock;
+
+	ret = ocelot_fdma_wait_chan_safe(fdma, MSCC_FDMA_INJ_CHAN);
+	if (ret) {
+		dev_warn(fdma->dev, "Failed to wait for TX channel to stop\n");
+		goto out_unlock;
+	}
+
+	/* Set NULL LLP */
+	new_null_llp_idx = ocelot_fdma_idx_decr(ring->tail);
+	dcb = &ring->dcbs[new_null_llp_idx];
+	dcb->hw->llp = 0;
+
+	dcb = &ring->dcbs[ring->head];
+	ocelot_fdma_activate_chan(fdma, dcb, MSCC_FDMA_INJ_CHAN);
+
+out_unlock:
+	spin_unlock_bh(&fdma->xmit_lock);
+}
+
+static int ocelot_fdma_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct ocelot_fdma *fdma = container_of(napi, struct ocelot_fdma, napi);
+	int work_done = 0;
+
+	ocelot_fdma_tx_cleanup(fdma, budget);
+
+	while (work_done < budget) {
+		if (!ocelot_fdma_rx_get(fdma, budget))
+			break;
+
+		work_done++;
+	}
+
+	ocelot_fdma_rx_restart(fdma);
+
+	if (work_done < budget) {
+		napi_complete_done(&fdma->napi, work_done);
+		ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_ENA,
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
+	struct ocelot_fdma *fdma = dev_id;
+
+	ident = ocelot_fdma_readl(fdma, MSCC_FDMA_INTR_IDENT);
+	frm = ocelot_fdma_readl(fdma, MSCC_FDMA_INTR_FRM);
+	llp = ocelot_fdma_readl(fdma, MSCC_FDMA_INTR_LLP);
+
+	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_LLP, llp & ident);
+	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_FRM, frm & ident);
+	if (frm || llp) {
+		ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_ENA, 0);
+		napi_schedule(&fdma->napi);
+	}
+
+	err = ocelot_fdma_readl(fdma, MSCC_FDMA_EVT_ERR);
+	if (unlikely(err)) {
+		err_code = ocelot_fdma_readl(fdma, MSCC_FDMA_EVT_ERR_CODE);
+		dev_err_ratelimited(fdma->dev,
+				    "Error ! chans mask: %#x, code: %#x\n",
+				    err, err_code);
+
+		ocelot_fdma_writel(fdma, MSCC_FDMA_EVT_ERR, err);
+		ocelot_fdma_writel(fdma, MSCC_FDMA_EVT_ERR_CODE, err_code);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void ocelot_fdma_send_skb(struct ocelot_fdma *fdma, struct sk_buff *skb)
+{
+	struct ocelot_fdma_ring *ring = &fdma->inj;
+	struct ocelot_fdma_dcb *dcb, *next;
+
+	dcb = &ring->dcbs[ring->tail];
+	if (!ocelot_fdma_tx_dcb_set_skb(fdma, dcb, skb)) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
+	if (ocelot_fdma_ring_empty(&fdma->inj)) {
+		ocelot_fdma_activate_chan(fdma, dcb, MSCC_FDMA_INJ_CHAN);
+	} else {
+		next = &ring->dcbs[ocelot_fdma_idx_incr(ring->tail)];
+		dcb->hw->llp = next->hw_dma;
+	}
+
+	ring->tail = ocelot_fdma_idx_incr(ring->tail);
+
+	skb_tx_timestamp(skb);
+}
+
+static int ocelot_fdma_prepare_skb(struct ocelot_fdma *fdma, int port,
+				   u32 rew_op, struct sk_buff *skb,
+				   struct net_device *dev)
+{
+	int needed_headroom = max_t(int, OCELOT_TAG_LEN - skb_headroom(skb), 0);
+	int needed_tailroom = max_t(int, ETH_FCS_LEN - skb_tailroom(skb), 0);
+	struct ocelot_port *ocelot_port = fdma->ocelot->ports[port];
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
+	ocelot_ifh_port_set(ifh, ocelot_port, rew_op, skb_vlan_tag_get(skb));
+
+	return 0;
+}
+
+int ocelot_fdma_inject_frame(struct ocelot_fdma *fdma, int port, u32 rew_op,
+			     struct sk_buff *skb, struct net_device *dev)
+{
+	int ret = NETDEV_TX_OK;
+
+	spin_lock(&fdma->xmit_lock);
+
+	if (ocelot_fdma_tx_free_count(fdma) == 0) {
+		ret = NETDEV_TX_BUSY;
+		goto out;
+	}
+
+	if (ocelot_fdma_prepare_skb(fdma, port, rew_op, skb, dev))
+		goto out;
+
+	ocelot_fdma_send_skb(fdma, skb);
+
+out:
+	spin_unlock(&fdma->xmit_lock);
+
+	return ret;
+}
+
+static void ocelot_fdma_ring_free(struct ocelot_fdma *fdma,
+				  struct ocelot_fdma_ring *ring)
+{
+	dmam_free_coherent(fdma->dev, OCELOT_DCBS_HW_ALLOC_SIZE, ring->hw_dcbs,
+			   ring->hw_dcbs_dma);
+}
+
+static int ocelot_fdma_ring_alloc(struct ocelot_fdma *fdma,
+				  struct ocelot_fdma_ring *ring)
+{
+	struct ocelot_fdma_dcb_hw_v2 *hw_dcbs;
+	struct ocelot_fdma_dcb *dcb;
+	dma_addr_t hw_dcbs_dma;
+	unsigned int adjust;
+	int i;
+
+	/* Create a pool of consistent memory blocks for hardware descriptors */
+	ring->hw_dcbs = dmam_alloc_coherent(fdma->dev,
+					    OCELOT_DCBS_HW_ALLOC_SIZE,
+					    &ring->hw_dcbs_dma, GFP_KERNEL);
+	if (!ring->hw_dcbs)
+		return -ENOMEM;
+
+	/* DCBs must be aligned on a 32bit boundary */
+	hw_dcbs = ring->hw_dcbs;
+	hw_dcbs_dma = ring->hw_dcbs_dma;
+	if (!IS_ALIGNED(hw_dcbs_dma, 4)) {
+		adjust = hw_dcbs_dma & 0x3;
+		hw_dcbs_dma = ALIGN(hw_dcbs_dma, 4);
+		hw_dcbs = (void *)hw_dcbs + adjust;
+	}
+
+	for (i = 0; i < OCELOT_FDMA_MAX_DCB; i++) {
+		dcb = &ring->dcbs[i];
+		dcb->hw = &hw_dcbs[i];
+		dcb->hw_dma = hw_dcbs_dma +
+			     i * sizeof(struct ocelot_fdma_dcb_hw_v2);
+	}
+
+	return 0;
+}
+
+static int ocelot_fdma_rx_skb_alloc(struct ocelot_fdma *fdma)
+{
+	struct ocelot_fdma_dcb *dcb, *prev_dcb = NULL;
+	struct ocelot_fdma_ring *ring = &fdma->xtr;
+	struct sk_buff *skb;
+	int i;
+
+	for (i = 0; i < OCELOT_FDMA_MAX_DCB; i++) {
+		dcb = &ring->dcbs[i];
+		skb = napi_alloc_skb(&fdma->napi, fdma->rx_buf_size);
+		if (!skb)
+			goto skb_alloc_failed;
+
+		ocelot_fdma_rx_set_skb(fdma, dcb, skb, fdma->rx_buf_size);
+
+		if (prev_dcb)
+			prev_dcb->hw->llp = dcb->hw_dma;
+
+		prev_dcb = dcb;
+	}
+
+	ring->head = 0;
+	ring->tail = OCELOT_FDMA_MAX_DCB - 1;
+
+	return 0;
+
+skb_alloc_failed:
+	for (i = 0; i < OCELOT_FDMA_MAX_DCB; i++) {
+		dcb = &ring->dcbs[i];
+		if (!dcb->skb)
+			break;
+
+		dev_kfree_skb_any(dcb->skb);
+	}
+
+	return -ENOMEM;
+}
+
+static int ocelot_fdma_rx_init(struct ocelot_fdma *fdma)
+{
+	int ret;
+
+	fdma->rx_buf_size = ocelot_fdma_rx_buf_size(OCELOT_FDMA_RX_MTU);
+
+	ret = ocelot_fdma_rx_skb_alloc(fdma);
+	if (ret) {
+		netif_napi_del(&fdma->napi);
+		return ret;
+	}
+
+	napi_enable(&fdma->napi);
+
+	ocelot_fdma_activate_chan(fdma, &fdma->xtr.dcbs[0],
+				  MSCC_FDMA_XTR_CHAN);
+
+	return 0;
+}
+
+void ocelot_fdma_netdev_init(struct ocelot_fdma *fdma, struct net_device *dev)
+{
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
+void ocelot_fdma_netdev_deinit(struct ocelot_fdma *fdma, struct net_device *dev)
+{
+	if (dev == fdma->ndev)
+		netif_napi_del(&fdma->napi);
+}
+
+struct ocelot_fdma *ocelot_fdma_init(struct platform_device *pdev,
+				     struct ocelot *ocelot)
+{
+	struct ocelot_fdma *fdma;
+	void __iomem *base;
+	int ret;
+
+	base = devm_platform_ioremap_resource_byname(pdev, "fdma");
+	if (IS_ERR_OR_NULL(base))
+		return NULL;
+
+	fdma = devm_kzalloc(&pdev->dev, sizeof(*fdma), GFP_KERNEL);
+	if (!fdma)
+		goto err_release_resource;
+
+	fdma->ocelot = ocelot;
+	fdma->base = base;
+	fdma->dev = &pdev->dev;
+	fdma->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+
+	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_ENA, 0);
+
+	fdma->irq = platform_get_irq_byname(pdev, "fdma");
+	ret = devm_request_irq(&pdev->dev, fdma->irq, ocelot_fdma_interrupt, 0,
+			       dev_name(&pdev->dev), fdma);
+	if (ret)
+		goto err_free_fdma;
+
+	ret = ocelot_fdma_ring_alloc(fdma, &fdma->inj);
+	if (ret)
+		goto err_free_irq;
+
+	ret = ocelot_fdma_ring_alloc(fdma, &fdma->xtr);
+	if (ret)
+		goto free_inj_ring;
+
+	return fdma;
+
+free_inj_ring:
+	ocelot_fdma_ring_free(fdma, &fdma->inj);
+err_free_irq:
+	devm_free_irq(&pdev->dev, fdma->irq, fdma);
+err_free_fdma:
+	devm_kfree(&pdev->dev, fdma);
+err_release_resource:
+	devm_iounmap(&pdev->dev, base);
+
+	return NULL;
+}
+
+int ocelot_fdma_start(struct ocelot_fdma *fdma)
+{
+	struct ocelot *ocelot = fdma->ocelot;
+	int ret;
+
+	ret = ocelot_fdma_rx_init(fdma);
+	if (ret)
+		return -EINVAL;
+
+	/* Reconfigure for extraction and injection using DMA */
+	ocelot_write_rix(ocelot, QS_INJ_GRP_CFG_MODE(2), QS_INJ_GRP_CFG, 0);
+	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(0), QS_INJ_CTRL, 0);
+
+	ocelot_write_rix(ocelot, QS_XTR_GRP_CFG_MODE(2), QS_XTR_GRP_CFG, 0);
+
+	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_LLP, 0xffffffff);
+	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_FRM, 0xffffffff);
+
+	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_LLP_ENA,
+			   BIT(MSCC_FDMA_INJ_CHAN) | BIT(MSCC_FDMA_XTR_CHAN));
+	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_FRM_ENA, BIT(MSCC_FDMA_XTR_CHAN));
+	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_ENA,
+			   BIT(MSCC_FDMA_INJ_CHAN) | BIT(MSCC_FDMA_XTR_CHAN));
+
+	return 0;
+}
+
+int ocelot_fdma_stop(struct ocelot_fdma *fdma)
+{
+	struct ocelot_fdma_ring *ring = &fdma->xtr;
+	struct ocelot_fdma_dcb *dcb;
+	int i;
+
+	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_ENA, 0);
+
+	ocelot_fdma_stop_channel(fdma, MSCC_FDMA_XTR_CHAN);
+	ocelot_fdma_stop_channel(fdma, MSCC_FDMA_INJ_CHAN);
+
+	/* Free the SKB hold in the extraction ring */
+	for (i = 0; i < OCELOT_FDMA_MAX_DCB; i++) {
+		dcb = &ring->dcbs[i];
+		dev_kfree_skb_any(dcb->skb);
+	}
+
+	napi_synchronize(&fdma->napi);
+	napi_disable(&fdma->napi);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.h b/drivers/net/ethernet/mscc/ocelot_fdma.h
new file mode 100644
index 000000000000..b6f1dda0e0c7
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.h
@@ -0,0 +1,96 @@
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
+#define OCELOT_FDMA_MAX_DCB		128
+/* +4 allows for word alignment after allocation */
+#define OCELOT_DCBS_HW_ALLOC_SIZE	(OCELOT_FDMA_MAX_DCB * \
+					 sizeof(struct ocelot_fdma_dcb_hw_v2) + \
+					 4)
+
+struct ocelot_fdma_dcb_hw_v2 {
+	u32 llp;
+	u32 datap;
+	u32 datal;
+	u32 stat;
+};
+
+/**
+ * struct ocelot_fdma_dcb - Software DCBs description
+ *
+ * @hw: hardware DCB used by hardware(coherent memory)
+ * @hw_dma: DMA address of the DCB
+ * @skb: skb associated with the DCB
+ * @mapping: Address of the skb data mapping
+ * @mapped_size: Mapped size
+ */
+struct ocelot_fdma_dcb {
+	struct ocelot_fdma_dcb_hw_v2	*hw;
+	dma_addr_t			hw_dma;
+	struct sk_buff			*skb;
+	dma_addr_t			mapping;
+	size_t				mapped_size;
+};
+
+/**
+ * struct ocelot_fdma_ring - "Ring" description of DCBs
+ *
+ * @hw_dcbs: Hardware DCBs allocated for the ring
+ * @hw_dcbs_dma: DMA address of the DCBs
+ * @dcbs: List of software DCBs
+ * @head: pointer to first available DCB
+ * @tail: pointer to last available DCB
+ */
+struct ocelot_fdma_ring {
+	struct ocelot_fdma_dcb_hw_v2	*hw_dcbs;
+	dma_addr_t			hw_dcbs_dma;
+	struct ocelot_fdma_dcb		dcbs[OCELOT_FDMA_MAX_DCB];
+	unsigned int			head;
+	unsigned int			tail;
+};
+
+/**
+ * struct ocelot_fdma - FMDA struct
+ *
+ * @ocelot: Pointer to ocelot struct
+ * @base: base address of FDMA registers
+ * @irq: FDMA interrupt
+ * @dev: Ocelot device
+ * @napi: napi handle
+ * @rx_buf_size: Size of RX buffer
+ * @inj: Injection ring
+ * @xtr: Extraction ring
+ * @xmit_lock: Xmit lock
+ *
+ */
+struct ocelot_fdma {
+	struct ocelot			*ocelot;
+	void __iomem			*base;
+	int				irq;
+	struct device			*dev;
+	struct napi_struct		napi;
+	struct net_device		*ndev;
+	size_t				rx_buf_size;
+	struct ocelot_fdma_ring		inj;
+	struct ocelot_fdma_ring		xtr;
+	spinlock_t			xmit_lock;
+};
+
+struct ocelot_fdma *ocelot_fdma_init(struct platform_device *pdev,
+				     struct ocelot *ocelot);
+int ocelot_fdma_start(struct ocelot_fdma *fdma);
+int ocelot_fdma_stop(struct ocelot_fdma *fdma);
+int ocelot_fdma_inject_frame(struct ocelot_fdma *fdma, int port, u32 rew_op,
+			     struct sk_buff *skb, struct net_device *dev);
+void ocelot_fdma_netdev_init(struct ocelot_fdma *fdma, struct net_device *dev);
+void ocelot_fdma_netdev_deinit(struct ocelot_fdma *fdma,
+			       struct net_device *dev);
+
+#endif
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index b589ae95e29b..9dcaf421da12 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -15,6 +15,7 @@
 #include <net/pkt_cls.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
+#include "ocelot_fdma.h"
 
 #define OCELOT_MAC_QUIRKS	OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP
 
@@ -457,7 +458,7 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	int port = priv->chip_port;
 	u32 rew_op = 0;
 
-	if (!ocelot_can_inject(ocelot, 0))
+	if (!ocelot->fdma && !ocelot_can_inject(ocelot, 0))
 		return NETDEV_TX_BUSY;
 
 	/* Check if timestamping is needed */
@@ -475,9 +476,13 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 		rew_op = ocelot_ptp_rew_op(skb);
 	}
 
-	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
+	if (ocelot->fdma) {
+		ocelot_fdma_inject_frame(ocelot->fdma, port, rew_op, skb, dev);
+	} else {
+		ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
-	kfree_skb(skb);
+		consume_skb(skb);
+	}
 
 	return NETDEV_TX_OK;
 }
@@ -1717,6 +1722,9 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 	if (err)
 		goto out;
 
+	if (ocelot->fdma)
+		ocelot_fdma_netdev_init(ocelot->fdma, dev);
+
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(ocelot->dev, "register_netdev failed\n");
@@ -1737,9 +1745,13 @@ void ocelot_release_port(struct ocelot_port *ocelot_port)
 	struct ocelot_port_private *priv = container_of(ocelot_port,
 						struct ocelot_port_private,
 						port);
+	struct ocelot_fdma *fdma = ocelot_port->ocelot->fdma;
 
 	unregister_netdev(priv->dev);
 
+	if (fdma)
+		ocelot_fdma_netdev_deinit(fdma, priv->dev);
+
 	if (priv->phylink) {
 		rtnl_lock();
 		phylink_disconnect_phy(priv->phylink);
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 38103b0255b0..fa68eb23a333 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -18,6 +18,7 @@
 
 #include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_hsio.h>
+#include "ocelot_fdma.h"
 #include "ocelot.h"
 
 static const u32 ocelot_ana_regmap[] = {
@@ -1080,6 +1081,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		ocelot->targets[io_target[i].id] = target;
 	}
 
+	ocelot->fdma = ocelot_fdma_init(pdev, ocelot);
+	if (IS_ERR(ocelot->fdma))
+		ocelot->fdma = NULL;
+
 	hsio = syscon_regmap_lookup_by_compatible("mscc,ocelot-hsio");
 	if (IS_ERR(hsio)) {
 		dev_err(&pdev->dev, "missing hsio syscon\n");
@@ -1139,6 +1144,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		goto out_ocelot_devlink_unregister;
 
+	if (ocelot->fdma) {
+		err = ocelot_fdma_start(ocelot->fdma);
+		if (err)
+			goto out_ocelot_release_ports;
+	}
+
 	err = ocelot_devlink_sb_register(ocelot);
 	if (err)
 		goto out_ocelot_release_ports;
@@ -1179,6 +1190,8 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 
+	if (ocelot->fdma)
+		ocelot_fdma_stop(ocelot->fdma);
 	devlink_unregister(ocelot->devlink);
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_devlink_sb_unregister(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index b3381c90ff3e..351ab385ab98 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -695,6 +695,8 @@ struct ocelot {
 	/* Protects the PTP clock */
 	spinlock_t			ptp_clock_lock;
 	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
+
+	struct ocelot_fdma		*fdma;
 };
 
 struct ocelot_policer {
@@ -761,6 +763,8 @@ void ocelot_ifh_port_set(void *ifh, struct ocelot_port *port, u32 rew_op,
 			 u32 vlan_tag);
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
+void ocelot_ptp_rx_timestamp(struct ocelot *ocelot, struct sk_buff *skb,
+			     u64 timestamp);
 
 /* Hardware initialization */
 int ocelot_regfields_init(struct ocelot *ocelot,
-- 
2.33.1

