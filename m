Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F24643E2AD
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhJ1Nya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:54:30 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:51439 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhJ1NyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:54:22 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id D73E5C62DD;
        Thu, 28 Oct 2021 13:51:27 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 8C143FF815;
        Thu, 28 Oct 2021 13:51:04 +0000 (UTC)
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
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] net: ocelot: add FDMA support
Date:   Thu, 28 Oct 2021 15:49:32 +0200
Message-Id: <20211028134932.658167-4-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211028134932.658167-1-clement.leger@bootlin.com>
References: <20211028134932.658167-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethernet frames can be extracted or injected autonomously to or from the
device’s DDR3/DDR3L memory and/or PCIe memory space. Linked list data
structures in memory are used for injecting or extracting Ethernet frames.
The FDMA generates interrupts when frame extraction or injection is done
and when the linked lists need updating.

The FDMA is shared between all the ethernet ports of the switch and uses
a linked list of descriptors (DCB) to inject and extract packets.
Before adding descriptors, the FDMA channels must be stopped. It would
be inefficient to do that each time a descriptor would be added,

TX path uses multiple lists to handle descriptors. tx_ongoing is the list
of DCB currently owned by the hardware, tx_queued is a list of DCB that
will be given to the hardware when tx_ongoing is done and finally
tx_free_dcb is the list of DCB available for TX.

RX path uses two list, rx_hw is the list of DCB currently given to the
hardware and rx_sw is the list of descriptors that have been completed
by the FDMA and will be reinjected when the DMA hits the end of the
linked list.

Co-developed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/Makefile         |   1 +
 drivers/net/ethernet/mscc/ocelot.h         |   2 +
 drivers/net/ethernet/mscc/ocelot_fdma.c    | 811 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_fdma.h    |  60 ++
 drivers/net/ethernet/mscc/ocelot_net.c     |  30 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  15 +
 include/linux/dsa/ocelot.h                 |  40 +-
 include/soc/mscc/ocelot.h                  |   2 +
 8 files changed, 953 insertions(+), 8 deletions(-)
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
index 1952d6a1b98a..d06550c3610c 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -9,6 +9,7 @@
 #define _MSCC_OCELOT_H_
 
 #include <linux/bitops.h>
+#include <linux/dsa/ocelot.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/net_tstamp.h>
@@ -45,6 +46,7 @@ struct ocelot_port_private {
 	struct phylink_config phylink_config;
 	u8 chip_port;
 	struct ocelot_port_tc tc;
+	u8 ifh[OCELOT_TAG_LEN];
 };
 
 struct ocelot_dump_ctx {
diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
new file mode 100644
index 000000000000..4260bc1408d2
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
@@ -0,0 +1,811 @@
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
+#define FDMA_MAX_SKB				256
+#define FDMA_WEIGHT				32
+
+#define FDMA_RX_EXTRA_SIZE			\
+	(OCELOT_TAG_LEN + ETH_FCS_LEN + ETH_HLEN + 4)
+
+struct ocelot_fdma_dcb_hw_v2 {
+	u32 llp;
+	u32 datap;
+	u32 datal;
+	u32 stat;
+};
+
+struct ocelot_fdma_dcb {
+	struct ocelot_fdma_dcb_hw_v2	hw;
+	struct list_head		node;
+	struct sk_buff			*skb;
+	dma_addr_t			mapping;
+	size_t				mapped_size;
+	dma_addr_t			phys;
+};
+
+static int fdma_rx_compute_buffer_size(int mtu)
+{
+	return ALIGN(mtu + FDMA_RX_EXTRA_SIZE, 4);
+}
+
+static void fdma_writel(struct ocelot_fdma *fdma, u32 reg, u32 data)
+{
+	writel(data, fdma->base + reg);
+}
+
+static u32 fdma_readl(struct ocelot_fdma *fdma, u32 reg)
+{
+	return readl(fdma->base + reg);
+}
+
+static void fdma_activate_chan(struct ocelot_fdma *fdma,
+			       struct ocelot_fdma_dcb *dcb, int chan)
+{
+	fdma_writel(fdma, MSCC_FDMA_DCB_LLP(chan), dcb->phys);
+	fdma_writel(fdma, MSCC_FDMA_CH_ACTIVATE, BIT(chan));
+}
+
+static void fdma_stop_channel(struct ocelot_fdma *fdma, int chan)
+{
+	u32 safe;
+
+	fdma_writel(fdma, MSCC_FDMA_CH_DISABLE, BIT(chan));
+	do {
+		safe = fdma_readl(fdma, MSCC_FDMA_CH_SAFE);
+	} while (!(safe & BIT(chan)));
+}
+
+static bool ocelot_fdma_dcb_set_data(struct ocelot_fdma *fdma,
+				     struct ocelot_fdma_dcb *dcb, void *data,
+				     size_t size, enum dma_data_direction dir)
+{
+	u32 offset;
+
+	dcb->mapped_size = size;
+	dcb->mapping = dma_map_single(fdma->dev, data, size, dir);
+	if (unlikely(dma_mapping_error(fdma->dev, dcb->mapping)))
+		return false;
+
+	offset = dcb->mapping & 0x3;
+
+	dcb->hw.llp = 0;
+	dcb->hw.datap = dcb->mapping & ~0x3;
+	dcb->hw.datal = ALIGN_DOWN(size - offset, 4);
+	dcb->hw.stat = MSCC_FDMA_DCB_STAT_BLOCKO(offset);
+
+	WARN_ON(!IS_ALIGNED(dcb->hw.datal, 4));
+
+	return true;
+}
+
+static bool ocelot_fdma_dcb_set_rx_skb(struct ocelot_fdma *fdma,
+				       struct ocelot_fdma_dcb *dcb,
+				       struct sk_buff *skb, size_t size)
+{
+	dcb->skb = skb;
+	return ocelot_fdma_dcb_set_data(fdma, dcb, skb->data, size,
+				      DMA_FROM_DEVICE);
+}
+
+static bool ocelot_fdma_dcb_set_tx_skb(struct ocelot_fdma *fdma,
+				       struct ocelot_fdma_dcb *dcb,
+				       struct sk_buff *skb)
+{
+	if (!ocelot_fdma_dcb_set_data(fdma, dcb, skb->data, skb->len,
+				      DMA_TO_DEVICE))
+		return false;
+
+	dcb->skb = skb;
+	dcb->hw.stat |= MSCC_FDMA_DCB_STAT_BLOCKL(skb->len);
+
+	return true;
+}
+
+static struct ocelot_fdma_dcb *fdma_dcb_alloc(struct ocelot_fdma *fdma)
+{
+	struct ocelot_fdma_dcb *dcb;
+	dma_addr_t phys;
+
+	dcb = dma_pool_zalloc(fdma->dcb_pool, GFP_KERNEL, &phys);
+	if (unlikely(!dcb))
+		return NULL;
+
+	dcb->phys = phys;
+
+	return dcb;
+}
+
+static struct net_device *fdma_get_port_netdev(struct ocelot_fdma *fdma,
+					       int port_num)
+{
+	struct ocelot_port_private *port_priv;
+	struct ocelot *ocelot = fdma->ocelot;
+	struct ocelot_port *port;
+
+	if (port_num >= ocelot->num_phys_ports)
+		return NULL;
+
+	port = ocelot->ports[port_num];
+
+	if (!port)
+		return NULL;
+
+	port_priv = container_of(port, struct ocelot_port_private, port);
+
+	return port_priv->dev;
+}
+
+static bool ocelot_fdma_rx_process_skb(struct ocelot_fdma *fdma,
+				       struct ocelot_fdma_dcb *dcb,
+				       int budget)
+{
+	struct sk_buff *skb = dcb->skb;
+	struct net_device *ndev;
+	u64 src_port;
+	void *xfh;
+
+	dma_unmap_single(fdma->dev, dcb->mapping, dcb->mapped_size,
+			 DMA_FROM_DEVICE);
+
+	xfh = skb->data;
+	ocelot_xfh_get_src_port(xfh, &src_port);
+
+	skb_put(skb, MSCC_FDMA_DCB_STAT_BLOCKL(dcb->hw.stat));
+	skb_pull(skb, OCELOT_TAG_LEN);
+
+	ndev = fdma_get_port_netdev(fdma, src_port);
+	if (unlikely(!ndev)) {
+		napi_consume_skb(dcb->skb, budget);
+		return false;
+	}
+
+	skb->dev = ndev;
+	skb->protocol = eth_type_trans(skb, skb->dev);
+	skb->dev->stats.rx_bytes += skb->len;
+	skb->dev->stats.rx_packets++;
+
+	netif_receive_skb(skb);
+
+	return true;
+}
+
+static void ocelot_fdma_rx_refill(struct ocelot_fdma *fdma)
+{
+	struct ocelot_fdma_dcb *dcb, *last_dcb;
+
+	WARN_ON(list_empty(&fdma->rx_sw));
+
+	dcb = list_first_entry(&fdma->rx_sw, struct ocelot_fdma_dcb, node);
+	/* Splice old hardware DCB list + new one */
+	if (!list_empty(&fdma->rx_hw)) {
+		last_dcb = list_last_entry(&fdma->rx_hw, struct ocelot_fdma_dcb,
+					   node);
+		last_dcb->hw.llp = dcb->phys;
+	}
+
+	/* Move software list to hardware list */
+	list_splice_tail_init(&fdma->rx_sw, &fdma->rx_hw);
+
+	/* Finally reactivate the channel */
+	fdma_activate_chan(fdma, dcb, MSCC_FDMA_XTR_CHAN);
+}
+
+static void ocelot_fdma_list_add_dcb(struct list_head *list,
+				     struct ocelot_fdma_dcb *dcb)
+{
+	struct ocelot_fdma_dcb *last_dcb;
+
+	if (!list_empty(list)) {
+		last_dcb = list_last_entry(list, struct ocelot_fdma_dcb, node);
+		last_dcb->hw.llp = dcb->phys;
+	}
+
+	list_add_tail(&dcb->node, list);
+}
+
+static bool ocelot_fdma_rx_add_dcb_sw(struct ocelot_fdma *fdma,
+				      struct ocelot_fdma_dcb *dcb)
+{
+	struct sk_buff *new_skb;
+
+	/* Add DCB to end of list with new SKB */
+	new_skb = napi_alloc_skb(&fdma->napi, fdma->rx_buf_size);
+	if (unlikely(!new_skb)) {
+		pr_err("skb_alloc failed\n");
+		return false;
+	}
+
+	ocelot_fdma_dcb_set_rx_skb(fdma, dcb, new_skb, fdma->rx_buf_size);
+	ocelot_fdma_list_add_dcb(&fdma->rx_sw, dcb);
+
+	return true;
+}
+
+static bool ocelot_fdma_rx_get(struct ocelot_fdma *fdma, int budget)
+{
+	struct ocelot_fdma_dcb *dcb;
+	bool valid = true;
+	u32 stat;
+
+	dcb = list_first_entry_or_null(&fdma->rx_hw, struct ocelot_fdma_dcb,
+				       node);
+	if (!dcb || MSCC_FDMA_DCB_STAT_BLOCKL(dcb->hw.stat) == 0)
+		return false;
+
+	list_del(&dcb->node);
+
+	stat = dcb->hw.stat;
+	if (stat & MSCC_FDMA_DCB_STAT_ABORT || stat & MSCC_FDMA_DCB_STAT_PD)
+		valid = false;
+
+	if (!(stat & MSCC_FDMA_DCB_STAT_SOF) ||
+	    !(stat & MSCC_FDMA_DCB_STAT_EOF))
+		valid = false;
+
+	if (likely(valid)) {
+		if (!ocelot_fdma_rx_process_skb(fdma, dcb, budget))
+			pr_err("Process skb failed, stat %x\n", stat);
+	} else {
+		napi_consume_skb(dcb->skb, budget);
+	}
+
+	return ocelot_fdma_rx_add_dcb_sw(fdma, dcb);
+}
+
+static void ocelot_fdma_rx_check_stopped(struct ocelot_fdma *fdma)
+{
+	u32 llp = fdma_readl(fdma, MSCC_FDMA_DCB_LLP(MSCC_FDMA_XTR_CHAN));
+	/* LLP is non NULL, FDMA is still fetching packets */
+	if (llp)
+		return;
+
+	fdma_stop_channel(fdma, MSCC_FDMA_XTR_CHAN);
+	ocelot_fdma_rx_refill(fdma);
+}
+
+static void ocelot_fdma_tx_free_dcb(struct ocelot_fdma *fdma,
+				    struct list_head *list)
+{
+	struct ocelot_fdma_dcb *dcb;
+
+	if (list_empty(list))
+		return;
+
+	/* Free all SKBs that have been used for TX */
+	list_for_each_entry(dcb, list, node) {
+		dma_unmap_single(fdma->dev, dcb->mapping, dcb->mapped_size,
+				 DMA_TO_DEVICE);
+		dev_kfree_skb_any(dcb->skb);
+		dcb->skb = NULL;
+	}
+
+	/* All DCBs can now be given to free list */
+	spin_lock(&fdma->tx_free_lock);
+	list_splice_tail_init(list, &fdma->tx_free_dcb);
+	spin_unlock(&fdma->tx_free_lock);
+}
+
+/**
+ * ocelot_fdma_tx_cleanup - Free TX dcb that have been sent by the fdma
+ */
+static void ocelot_fdma_tx_cleanup(struct ocelot_fdma *fdma)
+{
+	struct list_head tx_done = LIST_HEAD_INIT(tx_done);
+	struct ocelot_fdma_dcb *dcb, *temp;
+
+	spin_lock(&fdma->tx_enqueue_lock);
+	if (list_empty(&fdma->tx_ongoing))
+		goto out_unlock;
+
+	/* TODO, use list_cut_before ? */
+	list_for_each_entry_safe(dcb, temp, &fdma->tx_ongoing, node) {
+		if (!(dcb->hw.stat & MSCC_FDMA_DCB_STAT_PD))
+			break;
+
+		list_move_tail(&dcb->node, &tx_done);
+	}
+
+out_unlock:
+	spin_unlock(&fdma->tx_enqueue_lock);
+
+	ocelot_fdma_tx_free_dcb(fdma, &tx_done);
+}
+
+void ocelot_fdma_tx_restart(struct ocelot_fdma *fdma)
+{
+	struct ocelot_fdma_dcb *dcb;
+	u32 safe;
+
+	spin_lock(&fdma->tx_enqueue_lock);
+
+	if (!list_empty(&fdma->tx_ongoing) || list_empty(&fdma->tx_queued))
+		goto out_unlock;
+
+	/* Ongoing list is empty, channel should be in safe mode */
+	do {
+		safe = fdma_readl(fdma, MSCC_FDMA_CH_SAFE);
+	} while (!(safe & BIT(MSCC_FDMA_INJ_CHAN)));
+
+	/* Move queued DCB to ongoing and restart the DMA */
+	list_splice_tail_init(&fdma->tx_queued, &fdma->tx_ongoing);
+	/* List can't be empty, no need to check */
+	dcb = list_first_entry(&fdma->tx_ongoing, struct ocelot_fdma_dcb, node);
+
+	fdma_activate_chan(fdma, dcb, MSCC_FDMA_INJ_CHAN);
+
+out_unlock:
+	spin_unlock(&fdma->tx_enqueue_lock);
+}
+
+static int ocelot_fdma_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct ocelot_fdma *fdma = container_of(napi, struct ocelot_fdma, napi);
+	int work_done = 0;
+
+	ocelot_fdma_tx_cleanup(fdma);
+	ocelot_fdma_tx_restart(fdma);
+
+	while (work_done < budget) {
+		if (!ocelot_fdma_rx_get(fdma, budget))
+			break;
+
+		work_done++;
+	}
+
+	ocelot_fdma_rx_check_stopped(fdma);
+
+	if (work_done < budget) {
+		napi_complete(&fdma->napi);
+		fdma_writel(fdma, MSCC_FDMA_INTR_ENA,
+			    BIT(MSCC_FDMA_INJ_CHAN) | BIT(MSCC_FDMA_XTR_CHAN));
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
+	ident = fdma_readl(fdma, MSCC_FDMA_INTR_IDENT);
+	frm = fdma_readl(fdma, MSCC_FDMA_INTR_FRM);
+	llp = fdma_readl(fdma, MSCC_FDMA_INTR_LLP);
+
+	fdma_writel(fdma, MSCC_FDMA_INTR_LLP, llp & ident);
+	fdma_writel(fdma, MSCC_FDMA_INTR_FRM, frm & ident);
+	if (frm | llp) {
+		fdma_writel(fdma, MSCC_FDMA_INTR_ENA, 0);
+		napi_schedule(&fdma->napi);
+	}
+
+	err = fdma_readl(fdma, MSCC_FDMA_EVT_ERR);
+	if (unlikely(err)) {
+		err_code = fdma_readl(fdma, MSCC_FDMA_EVT_ERR_CODE);
+		dev_err_ratelimited(fdma->dev,
+				    "Error ! chans mask: %#x, code: %#x\n",
+				    err, err_code);
+
+		fdma_writel(fdma, MSCC_FDMA_EVT_ERR, err);
+		fdma_writel(fdma, MSCC_FDMA_EVT_ERR_CODE, err_code);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct ocelot_fdma_dcb *fdma_tx_get_dcb(struct ocelot_fdma *fdma)
+{
+	struct ocelot_fdma_dcb *dcb = NULL;
+
+	spin_lock_bh(&fdma->tx_free_lock);
+	dcb = list_first_entry_or_null(&fdma->tx_free_dcb,
+				       struct ocelot_fdma_dcb, node);
+	if (dcb)
+		list_del(&dcb->node);
+
+	spin_unlock_bh(&fdma->tx_free_lock);
+
+	return dcb;
+}
+
+static void fdma_tx_set_ifh(void *ifh, u32 rew_op, struct sk_buff *skb)
+{
+	if (skb_vlan_tag_get(skb))
+		ocelot_ifh_set_vid_quirks(ifh, skb_vlan_tag_get(skb),
+					  QUIRK_LITTLE_ENDIAN);
+	if (rew_op)
+		ocelot_ifh_set_rew_op_quirks(ifh, rew_op, QUIRK_LITTLE_ENDIAN);
+}
+
+int ocelot_fdma_inject_frame(struct ocelot_fdma *fdma, u32 rew_op,
+			     struct sk_buff *skb, struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_fdma_dcb *dcb, *first_dcb, *last_dcb;
+	struct list_head dcbs = LIST_HEAD_INIT(dcbs);
+	struct sk_buff *new_skb;
+	u32 flags = 0;
+	void *ifh;
+	int i;
+
+	if (skb_headroom(skb) < OCELOT_TAG_LEN ||
+	    skb_tailroom(skb) < ETH_FCS_LEN) {
+		new_skb = skb_copy_expand(skb, OCELOT_TAG_LEN, ETH_FCS_LEN,
+					  GFP_ATOMIC);
+		dev_consume_skb_any(skb);
+		if (!new_skb)
+			return NETDEV_TX_OK;
+
+		skb = new_skb;
+	}
+
+	ifh = skb_push(skb, OCELOT_TAG_LEN);
+	memcpy(ifh, priv->ifh, OCELOT_TAG_LEN);
+	skb_put(skb, ETH_FCS_LEN);
+
+	fdma_tx_set_ifh(ifh, rew_op, skb);
+
+	first_dcb = fdma_tx_get_dcb(fdma);
+	if (unlikely(!first_dcb))
+		return NETDEV_TX_BUSY;
+
+	if (likely(skb_shinfo(skb)->nr_frags == 0))
+		flags = MSCC_FDMA_DCB_STAT_SOF | MSCC_FDMA_DCB_STAT_EOF;
+	else
+		flags = MSCC_FDMA_DCB_STAT_SOF;
+
+	if (!ocelot_fdma_dcb_set_tx_skb(fdma, first_dcb, skb))
+		goto abort_free_dcbs;
+
+	first_dcb->hw.stat |= flags;
+	ocelot_fdma_list_add_dcb(&dcbs, first_dcb);
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+
+		flags = 0;
+		skb = netdev_alloc_skb(dev, skb_frag_size(frag) +
+				       OCELOT_TAG_LEN + ETH_FCS_LEN);
+		if (!skb)
+			goto abort_free_dcbs;
+
+		dcb = fdma_tx_get_dcb(fdma);
+		if (!dcb) {
+			dev_kfree_skb_any(skb);
+			goto abort_free_dcbs;
+		}
+
+		/* Prepare SKB header and data */
+		ifh = skb_push(skb, OCELOT_TAG_LEN);
+		memcpy(ifh, priv->ifh, OCELOT_TAG_LEN);
+		fdma_tx_set_ifh(ifh, 0, skb);
+		skb_put(skb, ETH_FCS_LEN);
+
+		memcpy(skb->data + OCELOT_TAG_LEN, skb_frag_address(frag),
+		       skb_frag_size(frag));
+
+		if (i == skb_shinfo(skb)->nr_frags - 1)
+			flags |= MSCC_FDMA_DCB_STAT_EOF;
+
+		if (ocelot_fdma_dcb_set_tx_skb(fdma, dcb, skb))
+			goto abort_free_dcbs;
+		dcb->hw.stat |= flags;
+		ocelot_fdma_list_add_dcb(&dcbs, dcb);
+	}
+
+	spin_lock_bh(&fdma->tx_enqueue_lock);
+
+	if (list_empty(&fdma->tx_ongoing)) {
+		list_splice_tail(&dcbs, &fdma->tx_ongoing);
+		fdma_activate_chan(fdma, first_dcb, MSCC_FDMA_INJ_CHAN);
+	} else {
+		if (!list_empty(&fdma->tx_queued)) {
+			last_dcb = list_last_entry(&fdma->tx_queued,
+						   struct ocelot_fdma_dcb,
+						   node);
+			last_dcb->hw.llp = first_dcb->phys;
+		}
+		list_splice_tail(&dcbs, &fdma->tx_queued);
+	}
+
+	spin_unlock_bh(&fdma->tx_enqueue_lock);
+	return NETDEV_TX_OK;
+
+abort_free_dcbs:
+	ocelot_fdma_tx_free_dcb(fdma, &dcbs);
+	return NETDEV_TX_OK;
+}
+
+static void fdma_free_skbs_list(struct ocelot_fdma *fdma,
+				struct list_head *list,
+				enum dma_data_direction dir)
+{
+	struct ocelot_fdma_dcb *dcb;
+
+	if (list_empty(list))
+		return;
+
+	list_for_each_entry(dcb, list, node) {
+		if (dcb->skb) {
+			dma_unmap_single(fdma->dev, dcb->mapping,
+					 dcb->mapped_size, dir);
+			kfree_skb(dcb->skb);
+		}
+	}
+}
+
+int ocelot_fdma_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *port = &priv->port;
+	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_fdma *fdma = ocelot->fdma;
+	struct ocelot_fdma_dcb *dcb, *dcb_temp;
+	struct list_head tmp = LIST_HEAD_INIT(tmp);
+	u8 port_num;
+
+	/* The FDMA RX list is shared amongst all the port, get the max MTU from
+	 * all of them
+	 */
+	for (port_num = 0; port_num < ocelot->num_phys_ports; port_num++) {
+		port = ocelot->ports[port_num];
+		if (!port)
+			continue;
+
+		priv = container_of(port, struct ocelot_port_private, port);
+
+		if (READ_ONCE(priv->dev->mtu) > new_mtu)
+			new_mtu = READ_ONCE(priv->dev->mtu);
+
+		/* All ports must be down to change the RX buffer length */
+		if (netif_running(priv->dev))
+			return -EBUSY;
+	}
+	priv = netdev_priv(dev);
+	fdma->rx_buf_size = fdma_rx_compute_buffer_size(new_mtu);
+
+	ocelot_port_set_maxlen(ocelot, priv->chip_port, fdma->rx_buf_size);
+
+	fdma_stop_channel(fdma, MSCC_FDMA_INJ_CHAN);
+
+	/* Discard all pending RX software and hardware descriptor */
+	fdma_free_skbs_list(fdma, &fdma->rx_hw, DMA_FROM_DEVICE);
+	fdma_free_skbs_list(fdma, &fdma->rx_sw, DMA_FROM_DEVICE);
+
+	/* Move all DCBs to a temporary list that will be injected in sw list */
+	if (!list_empty(&fdma->rx_hw))
+		list_splice_tail_init(&fdma->rx_hw, &tmp);
+	if (!list_empty(&fdma->rx_sw))
+		list_splice_tail_init(&fdma->rx_sw, &tmp);
+
+	list_for_each_entry_safe(dcb, dcb_temp, &tmp, node) {
+		list_del(&dcb->node);
+		ocelot_fdma_rx_add_dcb_sw(fdma, dcb);
+	}
+
+	ocelot_fdma_rx_refill(fdma);
+
+	return 0;
+}
+
+static int fdma_init_tx(struct ocelot_fdma *fdma)
+{
+	int i;
+	struct ocelot_fdma_dcb *dcb;
+
+	for (i = 0; i < FDMA_MAX_SKB; i++) {
+		dcb = fdma_dcb_alloc(fdma);
+		if (!dcb)
+			return -ENOMEM;
+
+		list_add_tail(&dcb->node, &fdma->tx_free_dcb);
+	}
+
+	return 0;
+}
+
+static int fdma_init_rx(struct ocelot_fdma *fdma)
+{
+	struct ocelot_port_private *port_priv;
+	struct ocelot *ocelot = fdma->ocelot;
+	struct ocelot_fdma_dcb *dcb;
+	struct ocelot_port *port;
+	struct net_device *ndev;
+	int max_mtu = 0;
+	int i;
+	u8 port_num;
+
+	for (port_num = 0; port_num < ocelot->num_phys_ports; port_num++) {
+		port = ocelot->ports[port_num];
+		if (!port)
+			continue;
+
+		port_priv = container_of(port, struct ocelot_port_private,
+					 port);
+		ndev = port_priv->dev;
+
+		ndev->needed_headroom = OCELOT_TAG_LEN;
+		ndev->needed_tailroom = ETH_FCS_LEN;
+
+		ocelot_ifh_set_bypass_quirks(port_priv->ifh, 1,
+					     QUIRK_LITTLE_ENDIAN);
+		ocelot_ifh_set_dest_quirks(port_priv->ifh, BIT_ULL(port_num),
+					   QUIRK_LITTLE_ENDIAN);
+		ocelot_ifh_set_tag_type_quirks(port_priv->ifh, IFH_TAG_TYPE_C,
+					       QUIRK_LITTLE_ENDIAN);
+
+		ndev->max_mtu = 9000 - FDMA_RX_EXTRA_SIZE;
+
+		if (READ_ONCE(ndev->mtu) > max_mtu)
+			max_mtu = READ_ONCE(ndev->mtu);
+	}
+
+	if (!ndev)
+		return -ENODEV;
+
+	fdma->rx_buf_size = fdma_rx_compute_buffer_size(max_mtu);
+	netif_napi_add(ndev, &fdma->napi, ocelot_fdma_napi_poll,
+		       FDMA_WEIGHT);
+
+	for (i = 0; i < FDMA_MAX_SKB; i++) {
+		dcb = fdma_dcb_alloc(fdma);
+		if (!dcb)
+			return -ENOMEM;
+
+		ocelot_fdma_rx_add_dcb_sw(fdma, dcb);
+	}
+
+	napi_enable(&fdma->napi);
+
+	return 0;
+}
+
+struct ocelot_fdma *ocelot_fdma_init(struct platform_device *pdev,
+				     struct ocelot *ocelot)
+{
+	struct ocelot_fdma *fdma;
+	int ret;
+
+	fdma = devm_kzalloc(&pdev->dev, sizeof(*fdma), GFP_KERNEL);
+	if (!fdma)
+		return ERR_PTR(-ENOMEM);
+
+	fdma->ocelot = ocelot;
+	fdma->base = devm_platform_ioremap_resource_byname(pdev, "fdma");
+	if (IS_ERR_OR_NULL(fdma->base))
+		return fdma->base;
+
+	fdma->dev = &pdev->dev;
+	fdma->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+
+	spin_lock_init(&fdma->tx_enqueue_lock);
+	spin_lock_init(&fdma->tx_free_lock);
+
+	fdma_writel(fdma, MSCC_FDMA_INTR_ENA, 0);
+
+	fdma->irq = platform_get_irq_byname(pdev, "fdma");
+	ret = devm_request_irq(&pdev->dev, fdma->irq, ocelot_fdma_interrupt, 0,
+			       dev_name(&pdev->dev), fdma);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Create a pool of consistent memory blocks for hardware descriptors */
+	fdma->dcb_pool = dmam_pool_create("ocelot_fdma", &pdev->dev,
+					  sizeof(struct ocelot_fdma_dcb),
+					  __alignof__(struct ocelot_fdma_dcb),
+					  0);
+	if (!fdma->dcb_pool) {
+		dev_err(&pdev->dev, "unable to allocate DMA descriptor pool\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	INIT_LIST_HEAD(&fdma->tx_ongoing);
+	INIT_LIST_HEAD(&fdma->tx_free_dcb);
+	INIT_LIST_HEAD(&fdma->tx_queued);
+	INIT_LIST_HEAD(&fdma->rx_sw);
+	INIT_LIST_HEAD(&fdma->rx_hw);
+
+	return fdma;
+}
+
+int ocelot_fdma_start(struct ocelot_fdma *fdma)
+{
+	struct ocelot *ocelot = fdma->ocelot;
+	int ret;
+
+	ret = fdma_init_tx(fdma);
+	if (ret)
+		return ret;
+
+	ret = fdma_init_rx(fdma);
+	if (ret)
+		return ret;
+
+	/* Reconfigure for extraction and injection using DMA */
+	ocelot_write_rix(ocelot, QS_INJ_GRP_CFG_MODE(2), QS_INJ_GRP_CFG, 0);
+	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(0), QS_INJ_CTRL, 0);
+
+	ocelot_write_rix(ocelot, QS_XTR_GRP_CFG_MODE(2), QS_XTR_GRP_CFG, 0);
+
+	fdma_writel(fdma, MSCC_FDMA_INTR_LLP, 0xffffffff);
+	fdma_writel(fdma, MSCC_FDMA_INTR_FRM, 0xffffffff);
+
+	fdma_writel(fdma, MSCC_FDMA_INTR_LLP_ENA,
+		    BIT(MSCC_FDMA_INJ_CHAN) | BIT(MSCC_FDMA_XTR_CHAN));
+	fdma_writel(fdma, MSCC_FDMA_INTR_FRM_ENA, BIT(MSCC_FDMA_XTR_CHAN));
+	fdma_writel(fdma, MSCC_FDMA_INTR_ENA,
+		    BIT(MSCC_FDMA_INJ_CHAN) | BIT(MSCC_FDMA_XTR_CHAN));
+
+	ocelot_fdma_rx_refill(fdma);
+
+	return 0;
+}
+
+int ocelot_fdma_stop(struct ocelot_fdma *fdma)
+{
+	fdma_writel(fdma, MSCC_FDMA_INTR_ENA, 0);
+
+	fdma_stop_channel(fdma, MSCC_FDMA_XTR_CHAN);
+	fdma_stop_channel(fdma, MSCC_FDMA_INJ_CHAN);
+
+	/* Free potentially pending SKBs in DCB lists */
+	fdma_free_skbs_list(fdma, &fdma->rx_hw, DMA_FROM_DEVICE);
+	fdma_free_skbs_list(fdma, &fdma->rx_sw, DMA_FROM_DEVICE);
+	fdma_free_skbs_list(fdma, &fdma->tx_ongoing, DMA_TO_DEVICE);
+	fdma_free_skbs_list(fdma, &fdma->tx_queued, DMA_TO_DEVICE);
+
+	netif_napi_del(&fdma->napi);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.h b/drivers/net/ethernet/mscc/ocelot_fdma.h
new file mode 100644
index 000000000000..9a43fa2a7dba
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.h
@@ -0,0 +1,60 @@
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
+/**
+ * struct ocelot_fdma - FMDA struct
+ *
+ * @ocelot: Pointer to ocelot struct
+ * @base: base address of FDMA registers
+ * @dcb_pool: Pool used for DCB allocation
+ * @irq: FDMA interrupt
+ * @dev: Ocelot device
+ * @napi: napi handle
+ * @rx_buf_size: Size of RX buffer
+ * @tx_ongoing: List of DCB handed out to the FDMA
+ * @tx_queued: pending list of DCBs to be given to the hardware
+ * @tx_enqueue_lock: Lock used for tx_queued and tx_ongoing
+ * @tx_free_dcb: List of DCB available for TX
+ * @tx_free_lock: Lock used to access tx_free_dcb list
+ * @rx_hw: RX DCBs currently owned by the hardware and not completed
+ * @rx_sw: RX DCBs completed
+ */
+struct ocelot_fdma {
+	struct ocelot		*ocelot;
+	void __iomem		*base;
+	struct dma_pool		*dcb_pool;
+	int			irq;
+	struct device		*dev;
+	struct napi_struct	napi;
+	size_t			rx_buf_size;
+
+	struct list_head	tx_ongoing;
+	struct list_head	tx_queued;
+	/* Lock for tx_queued and tx_ongoing lists */
+	spinlock_t		tx_enqueue_lock;
+
+	struct list_head	tx_free_dcb;
+	/* Lock for tx_free_dcb list */
+	spinlock_t		tx_free_lock;
+
+	struct list_head	rx_hw;
+	struct list_head	rx_sw;
+};
+
+struct ocelot_fdma *ocelot_fdma_init(struct platform_device *pdev,
+				     struct ocelot *ocelot);
+int ocelot_fdma_start(struct ocelot_fdma *fdma);
+int ocelot_fdma_stop(struct ocelot_fdma *fdma);
+int ocelot_fdma_inject_frame(struct ocelot_fdma *fdma, u32 rew_op,
+			     struct sk_buff *skb, struct net_device *dev);
+int ocelot_fdma_change_mtu(struct net_device *dev, int new_mtu);
+
+#endif
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 2545727fd5b2..848618becd19 100644
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
@@ -475,13 +476,35 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 		rew_op = ocelot_ptp_rew_op(skb);
 	}
 
-	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
+	if (ocelot->fdma) {
+		ocelot_fdma_inject_frame(ocelot->fdma, rew_op, skb, dev);
+	} else {
+		ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
-	kfree_skb(skb);
+		kfree_skb(skb);
+	}
 
 	return NETDEV_TX_OK;
 }
 
+int ocelot_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int ret;
+
+	if (ocelot->fdma) {
+		ret = ocelot_fdma_change_mtu(dev, new_mtu);
+		if (ret)
+			return ret;
+	}
+
+	WRITE_ONCE(dev->mtu, new_mtu);
+
+	return 0;
+}
+
 enum ocelot_action_type {
 	OCELOT_MACT_LEARN,
 	OCELOT_MACT_FORGET,
@@ -768,6 +791,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_open			= ocelot_port_open,
 	.ndo_stop			= ocelot_port_stop,
 	.ndo_start_xmit			= ocelot_port_xmit,
+	.ndo_change_mtu			= ocelot_change_mtu,
 	.ndo_set_rx_mode		= ocelot_set_rx_mode,
 	.ndo_set_mac_address		= ocelot_port_set_mac_address,
 	.ndo_get_stats64		= ocelot_get_stats64,
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index c39118e5b3ee..9fdda70a8457 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -18,6 +18,7 @@
 
 #include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_hsio.h>
+#include "ocelot_fdma.h"
 #include "ocelot.h"
 
 static const u32 ocelot_ana_regmap[] = {
@@ -1083,6 +1084,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		ocelot->targets[io_target[i].id] = target;
 	}
 
+	ocelot->fdma = ocelot_fdma_init(pdev, ocelot);
+	if (IS_ERR(ocelot->fdma))
+		ocelot->fdma = NULL;
+
 	hsio = syscon_regmap_lookup_by_compatible("mscc,ocelot-hsio");
 	if (IS_ERR(hsio)) {
 		dev_err(&pdev->dev, "missing hsio syscon\n");
@@ -1146,6 +1151,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		goto out_ocelot_devlink_unregister;
 
+	if (ocelot->fdma) {
+		err = ocelot_fdma_start(ocelot->fdma);
+		if (err)
+			goto out_ocelot_devlink_unregister;
+	}
+
 	err = ocelot_devlink_sb_register(ocelot);
 	if (err)
 		goto out_ocelot_release_ports;
@@ -1172,6 +1183,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 out_ocelot_release_ports:
 	mscc_ocelot_release_ports(ocelot);
 	mscc_ocelot_teardown_devlink_ports(ocelot);
+	if (ocelot->fdma)
+		ocelot_fdma_stop(ocelot->fdma);
 out_ocelot_devlink_unregister:
 	devlink_unregister(devlink);
 out_ocelot_deinit:
@@ -1187,6 +1200,8 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 
+	if (ocelot->fdma)
+		ocelot_fdma_stop(ocelot->fdma);
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_devlink_sb_unregister(ocelot);
 	mscc_ocelot_release_ports(ocelot);
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index 8ae999f587c4..885afdb98156 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -207,19 +207,37 @@ static inline void ocelot_xfh_get_vlan_tci(void *extraction, u64 *vlan_tci)
 	packing(extraction, vlan_tci, 15, 0, OCELOT_TAG_LEN, UNPACK, 0);
 }
 
+static inline void ocelot_ifh_set_bypass_quirks(void *injection, u64 bypass,
+						u8 quirks)
+{
+	packing(injection, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, quirks);
+}
+
 static inline void ocelot_ifh_set_bypass(void *injection, u64 bypass)
 {
-	packing(injection, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, 0);
+	ocelot_ifh_set_bypass_quirks(injection, bypass, 0);
+}
+
+static inline void ocelot_ifh_set_rew_op_quirks(void *injection, u64 rew_op,
+						u8 quirks)
+{
+	packing(injection, &rew_op, 125, 117, OCELOT_TAG_LEN, PACK, quirks);
 }
 
 static inline void ocelot_ifh_set_rew_op(void *injection, u64 rew_op)
 {
-	packing(injection, &rew_op, 125, 117, OCELOT_TAG_LEN, PACK, 0);
+	ocelot_ifh_set_rew_op_quirks(injection, rew_op, 0);
+}
+
+static inline void ocelot_ifh_set_dest_quirks(void *injection, u64 dest,
+					      u8 quirks)
+{
+	packing(injection, &dest, 67, 56, OCELOT_TAG_LEN, PACK, quirks);
 }
 
 static inline void ocelot_ifh_set_dest(void *injection, u64 dest)
 {
-	packing(injection, &dest, 67, 56, OCELOT_TAG_LEN, PACK, 0);
+	ocelot_ifh_set_dest_quirks(injection, dest, 0);
 }
 
 static inline void ocelot_ifh_set_qos_class(void *injection, u64 qos_class)
@@ -237,14 +255,26 @@ static inline void ocelot_ifh_set_src(void *injection, u64 src)
 	packing(injection, &src, 46, 43, OCELOT_TAG_LEN, PACK, 0);
 }
 
+static inline void ocelot_ifh_set_tag_type_quirks(void *injection, u64 tag_type,
+						  u8 quirks)
+{
+	packing(injection, &tag_type, 16, 16, OCELOT_TAG_LEN, PACK, quirks);
+}
+
 static inline void ocelot_ifh_set_tag_type(void *injection, u64 tag_type)
 {
-	packing(injection, &tag_type, 16, 16, OCELOT_TAG_LEN, PACK, 0);
+	ocelot_ifh_set_tag_type_quirks(injection, tag_type, 0);
+}
+
+static inline void ocelot_ifh_set_vid_quirks(void *injection, u64 vid,
+					     u8 quirks)
+{
+	packing(injection, &vid, 11, 0, OCELOT_TAG_LEN, PACK, quirks);
 }
 
 static inline void ocelot_ifh_set_vid(void *injection, u64 vid)
 {
-	packing(injection, &vid, 11, 0, OCELOT_TAG_LEN, PACK, 0);
+	ocelot_ifh_set_vid_quirks(injection, vid, 0);
 }
 
 /* Determine the PTP REW_OP to use for injecting the given skb */
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index d7055b41982d..6756e13f69f7 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -679,6 +679,8 @@ struct ocelot {
 	/* Protects the PTP clock */
 	spinlock_t			ptp_clock_lock;
 	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
+
+	struct ocelot_fdma		*fdma;
 };
 
 struct ocelot_policer {
-- 
2.33.0

