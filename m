Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A1D1EDE8E
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 09:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgFDHfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 03:35:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:31680 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727916AbgFDHfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 03:35:31 -0400
IronPort-SDR: HUOKDfsyLOmjjsqPgJ06wgNNDMA6uclP9GvbqEjuTSEOdn6uAgAcAUvJZfZtsiPB3G87tko7JO
 p6WqkE49Wdxg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 00:35:30 -0700
IronPort-SDR: nBAjqdTvC6ma4zDetuflNWpqzFagi16kYk6qrgPCfQ+eZ/0NeHbifKk1H0zqLNEc/ObLyfhN0q
 VwtzcD0uk9yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,471,1583222400"; 
   d="scan'208";a="348021727"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga001.jf.intel.com with ESMTP; 04 Jun 2020 00:35:27 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>
Subject: [PATCH v3 09/10] net: eth: altera: add msgdma prefetcher
Date:   Thu,  4 Jun 2020 15:32:55 +0800
Message-Id: <20200604073256.25702-10-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200604073256.25702-1-joyce.ooi@intel.com>
References: <20200604073256.25702-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@intel.com>

Add support for the mSGDMA prefetcher.  The prefetcher adds support
for a linked list of descriptors in system memory.  The prefetcher
feeds these to the mSGDMA dispatcher.

The prefetcher is configured to poll for the next descriptor in the
list to be owned by hardware, then pass the descriptor to the
dispatcher.  It will then poll the next descriptor until it is
owned by hardware.

The dispatcher responses are written back to the appropriate
descriptor, and the owned by hardware bit is cleared.

The driver sets up a linked list twice the tx and rx ring sizes,
with the last descriptor pointing back to the first.  This ensures
that the ring of descriptors will always have inactive descriptors
preventing the prefetcher from looping over and reusing descriptors
inappropriately.  The prefetcher will continuously loop over these
descriptors.  The driver modifies descriptors as required to update
the skb address and length as well as the owned by hardware bit.

In addition to the above, the mSGDMA prefetcher can be used to
handle rx and tx timestamps coming from the ethernet ip.  These
can be included in the prefetcher response in the descriptor.

Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
---
v2: minor fixes and suggested edits
v3: queue is stopped before returning NETDEV_TX_BUSY
---
 drivers/net/ethernet/altera/Makefile               |   2 +-
 .../net/ethernet/altera/altera_msgdma_prefetcher.c | 431 +++++++++++++++++++++
 .../net/ethernet/altera/altera_msgdma_prefetcher.h |  30 ++
 .../ethernet/altera/altera_msgdmahw_prefetcher.h   |  87 +++++
 drivers/net/ethernet/altera/altera_tse.h           |  14 +
 drivers/net/ethernet/altera/altera_tse_main.c      |  51 +++
 6 files changed, 614 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma_prefetcher.c
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma_prefetcher.h
 create mode 100644 drivers/net/ethernet/altera/altera_msgdmahw_prefetcher.h

diff --git a/drivers/net/ethernet/altera/Makefile b/drivers/net/ethernet/altera/Makefile
index fc2e460926b3..4834e972e906 100644
--- a/drivers/net/ethernet/altera/Makefile
+++ b/drivers/net/ethernet/altera/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_ALTERA_TSE) += altera_tse.o
 altera_tse-objs := altera_tse_main.o altera_tse_ethtool.o \
 		   altera_msgdma.o altera_sgdma.o altera_utils.o \
-		   intel_fpga_tod.o
+		   intel_fpga_tod.o altera_msgdma_prefetcher.o
diff --git a/drivers/net/ethernet/altera/altera_msgdma_prefetcher.c b/drivers/net/ethernet/altera/altera_msgdma_prefetcher.c
new file mode 100644
index 000000000000..e8cd4d04730d
--- /dev/null
+++ b/drivers/net/ethernet/altera/altera_msgdma_prefetcher.c
@@ -0,0 +1,431 @@
+// SPDX-License-Identifier: GPL-2.0
+/* MSGDMA Prefetcher driver for Altera ethernet devices
+ *
+ * Copyright (C) 2020 Intel Corporation. All rights reserved.
+ * Author(s):
+ *   Dalon Westergreen <dalon.westergreen@intel.com>
+ */
+
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <linux/net_tstamp.h>
+#include "altera_tse.h"
+#include "altera_msgdma.h"
+#include "altera_msgdmahw.h"
+#include "altera_msgdma_prefetcher.h"
+#include "altera_msgdmahw_prefetcher.h"
+#include "altera_utils.h"
+
+int msgdma_pref_initialize(struct altera_tse_private *priv)
+{
+	int i;
+	struct msgdma_pref_extended_desc *rx_descs;
+	struct msgdma_pref_extended_desc *tx_descs;
+	dma_addr_t rx_descsphys;
+	dma_addr_t tx_descsphys;
+
+	priv->pref_rxdescphys = (dma_addr_t)0;
+	priv->pref_txdescphys = (dma_addr_t)0;
+
+	/* we need to allocate more pref descriptors than ringsize to
+	 * prevent all of the descriptors being owned by hw.  To do this
+	 * we just allocate twice ring_size descriptors.
+	 * rx_ring_size = priv->rx_ring_size * 2
+	 * tx_ring_size = priv->tx_ring_size * 2
+	 */
+
+	/* The prefetcher requires the descriptors to be aligned to the
+	 * descriptor read/write master's data width which worst case is
+	 * 512 bits.  Currently we DO NOT CHECK THIS and only support 32-bit
+	 * prefetcher masters.
+	 */
+
+	/* allocate memory for rx descriptors */
+	priv->pref_rxdesc =
+		dma_alloc_coherent(priv->device,
+				   sizeof(struct msgdma_pref_extended_desc)
+				   * priv->rx_ring_size * 2,
+				   &priv->pref_rxdescphys, GFP_KERNEL);
+
+	if (!priv->pref_rxdesc)
+		goto err_rx;
+
+	/* allocate memory for tx descriptors */
+	priv->pref_txdesc =
+		dma_alloc_coherent(priv->device,
+				   sizeof(struct msgdma_pref_extended_desc)
+				   * priv->tx_ring_size * 2,
+				   &priv->pref_txdescphys, GFP_KERNEL);
+
+	if (!priv->pref_txdesc)
+		goto err_tx;
+
+	/* setup base descriptor ring for tx & rx */
+	rx_descs = (struct msgdma_pref_extended_desc *)priv->pref_rxdesc;
+	tx_descs = (struct msgdma_pref_extended_desc *)priv->pref_txdesc;
+	tx_descsphys = priv->pref_txdescphys;
+	rx_descsphys = priv->pref_rxdescphys;
+
+	/* setup RX descriptors */
+	priv->pref_rx_prod = 0;
+	for (i = 0; i < priv->rx_ring_size * 2; i++) {
+		rx_descsphys = priv->pref_rxdescphys +
+			(((i + 1) % (priv->rx_ring_size * 2)) *
+			sizeof(struct msgdma_pref_extended_desc));
+		rx_descs[i].next_desc_lo = lower_32_bits(rx_descsphys);
+		rx_descs[i].next_desc_hi = upper_32_bits(rx_descsphys);
+		rx_descs[i].stride = MSGDMA_DESC_RX_STRIDE;
+		/* burst set to 0 so it defaults to max configured */
+		/* set seq number to desc number */
+		rx_descs[i].burst_seq_num = i;
+	}
+
+	/* setup TX descriptors */
+	for (i = 0; i < priv->tx_ring_size * 2; i++) {
+		tx_descsphys = priv->pref_txdescphys +
+			(((i + 1) % (priv->tx_ring_size * 2)) *
+			sizeof(struct msgdma_pref_extended_desc));
+		tx_descs[i].next_desc_lo = lower_32_bits(tx_descsphys);
+		tx_descs[i].next_desc_hi = upper_32_bits(tx_descsphys);
+		tx_descs[i].stride = MSGDMA_DESC_TX_STRIDE;
+		/* burst set to 0 so it defaults to max configured */
+		/* set seq number to desc number */
+		tx_descs[i].burst_seq_num = i;
+	}
+
+	if (netif_msg_ifup(priv))
+		netdev_info(priv->dev, "%s: RX Desc mem at 0x%x\n", __func__,
+			    priv->pref_rxdescphys);
+
+	if (netif_msg_ifup(priv))
+		netdev_info(priv->dev, "%s: TX Desc mem at 0x%x\n", __func__,
+			    priv->pref_txdescphys);
+
+	return 0;
+
+err_tx:
+	dma_free_coherent(priv->device,
+			  sizeof(struct msgdma_pref_extended_desc)
+			  * priv->rx_ring_size * 2,
+			  priv->pref_rxdesc, priv->pref_rxdescphys);
+err_rx:
+	return -ENOMEM;
+}
+
+void msgdma_pref_uninitialize(struct altera_tse_private *priv)
+{
+	if (priv->pref_rxdesc)
+		dma_free_coherent(priv->device,
+				  sizeof(struct msgdma_pref_extended_desc)
+				  * priv->rx_ring_size * 2,
+				  priv->pref_rxdesc, priv->pref_rxdescphys);
+
+	if (priv->pref_txdesc)
+		dma_free_coherent(priv->device,
+				  sizeof(struct msgdma_pref_extended_desc)
+				  * priv->tx_ring_size * 2,
+				  priv->pref_txdesc, priv->pref_txdescphys);
+}
+
+void msgdma_pref_enable_txirq(struct altera_tse_private *priv)
+{
+	tse_set_bit(priv->tx_pref_csr, msgdma_pref_csroffs(control),
+		    MSGDMA_PREF_CTL_GLOBAL_INTR);
+}
+
+void msgdma_pref_disable_txirq(struct altera_tse_private *priv)
+{
+	tse_clear_bit(priv->tx_pref_csr, msgdma_pref_csroffs(control),
+		      MSGDMA_PREF_CTL_GLOBAL_INTR);
+}
+
+void msgdma_pref_clear_txirq(struct altera_tse_private *priv)
+{
+	csrwr32(MSGDMA_PREF_STAT_IRQ, priv->tx_pref_csr,
+		msgdma_pref_csroffs(status));
+}
+
+void msgdma_pref_enable_rxirq(struct altera_tse_private *priv)
+{
+	tse_set_bit(priv->rx_pref_csr, msgdma_pref_csroffs(control),
+		    MSGDMA_PREF_CTL_GLOBAL_INTR);
+}
+
+void msgdma_pref_disable_rxirq(struct altera_tse_private *priv)
+{
+	tse_clear_bit(priv->rx_pref_csr, msgdma_pref_csroffs(control),
+		      MSGDMA_PREF_CTL_GLOBAL_INTR);
+}
+
+void msgdma_pref_clear_rxirq(struct altera_tse_private *priv)
+{
+	csrwr32(MSGDMA_PREF_STAT_IRQ, priv->rx_pref_csr,
+		msgdma_pref_csroffs(status));
+}
+
+static u64 timestamp_to_ns(struct msgdma_pref_extended_desc *desc)
+{
+	u64 ns = 0;
+	u64 second;
+	u32 tmp;
+
+	tmp = desc->timestamp_96b[0] >> 16;
+	tmp |= (desc->timestamp_96b[1] << 16);
+
+	second = desc->timestamp_96b[2];
+	second <<= 16;
+	second |= ((desc->timestamp_96b[1] & 0xffff0000) >> 16);
+
+	ns = second * NSEC_PER_SEC + tmp;
+
+	return ns;
+}
+
+/* Setup TX descriptor
+ *   -> this should never be called when a descriptor isn't available
+ */
+
+netdev_tx_t msgdma_pref_tx_buffer(struct altera_tse_private *priv,
+				  struct tse_buffer *buffer)
+{
+	u32 desc_entry = priv->tx_prod % (priv->tx_ring_size * 2);
+	struct msgdma_pref_extended_desc *tx_descs = priv->pref_txdesc;
+
+	/* if for some reason the descriptor is still owned by hardware */
+	if (unlikely(tx_descs[desc_entry].desc_control
+		     & MSGDMA_PREF_DESC_CTL_OWNED_BY_HW)) {
+		if (!netif_queue_stopped(priv->dev))
+			netif_stop_queue(priv->dev);
+		return NETDEV_TX_BUSY;
+	}
+
+	/* write descriptor entries */
+	tx_descs[desc_entry].len = buffer->len;
+	tx_descs[desc_entry].read_addr_lo = lower_32_bits(buffer->dma_addr);
+	tx_descs[desc_entry].read_addr_hi = upper_32_bits(buffer->dma_addr);
+
+	/* set the control bits and set owned by hw */
+	tx_descs[desc_entry].desc_control = (MSGDMA_DESC_CTL_TX_SINGLE
+			| MSGDMA_PREF_DESC_CTL_OWNED_BY_HW);
+
+	if (netif_msg_tx_queued(priv))
+		netdev_info(priv->dev, "%s: cons: %d prod: %d",
+			    __func__, priv->tx_cons, priv->tx_prod);
+
+	return NETDEV_TX_OK;
+}
+
+u32 msgdma_pref_tx_completions(struct altera_tse_private *priv)
+{
+	u32 control;
+	u32 ready = 0;
+	u32 cons = priv->tx_cons;
+	u32 desc_ringsize = priv->tx_ring_size * 2;
+	u32 ringsize = priv->tx_ring_size;
+	u64 ns = 0;
+	struct msgdma_pref_extended_desc *cur;
+	struct tse_buffer *tx_buff;
+	struct skb_shared_hwtstamps shhwtstamp;
+	int i;
+
+	if (netif_msg_tx_done(priv))
+		for (i = 0; i < desc_ringsize; i++)
+			netdev_info(priv->dev, "%s: desc: %d control 0x%x\n",
+				    __func__, i,
+				    priv->pref_txdesc[i].desc_control);
+
+	cur = &priv->pref_txdesc[cons % desc_ringsize];
+	control = cur->desc_control;
+	tx_buff = &priv->tx_ring[cons % ringsize];
+
+	while (!(control & MSGDMA_PREF_DESC_CTL_OWNED_BY_HW) &&
+	       (priv->tx_prod != (cons + ready)) && control) {
+		if (skb_shinfo(tx_buff->skb)->tx_flags & SKBTX_IN_PROGRESS) {
+			/* Timestamping is enabled, pass timestamp back */
+			ns = timestamp_to_ns(cur);
+			memset(&shhwtstamp, 0,
+			       sizeof(struct skb_shared_hwtstamps));
+			shhwtstamp.hwtstamp = ns_to_ktime(ns);
+			skb_tstamp_tx(tx_buff->skb, &shhwtstamp);
+		}
+
+		if (netif_msg_tx_done(priv))
+			netdev_info(priv->dev, "%s: cur: %d ts: %lld ns\n",
+				    __func__,
+				    ((cons + ready) % desc_ringsize), ns);
+
+		/* clear data */
+		cur->desc_control = 0;
+		cur->timestamp_96b[0] = 0;
+		cur->timestamp_96b[1] = 0;
+		cur->timestamp_96b[2] = 0;
+
+		ready++;
+		cur = &priv->pref_txdesc[(cons + ready) % desc_ringsize];
+		tx_buff = &priv->tx_ring[(cons + ready) % ringsize];
+		control = cur->desc_control;
+	}
+
+	return ready;
+}
+
+void msgdma_pref_reset(struct altera_tse_private *priv)
+{
+	int counter;
+
+	/* turn off polling */
+	tse_clear_bit(priv->rx_pref_csr, msgdma_pref_csroffs(control),
+		      MSGDMA_PREF_CTL_DESC_POLL_EN);
+	tse_clear_bit(priv->tx_pref_csr, msgdma_pref_csroffs(control),
+		      MSGDMA_PREF_CTL_DESC_POLL_EN);
+
+	/* Reset the RX Prefetcher */
+	csrwr32(MSGDMA_PREF_STAT_IRQ, priv->rx_pref_csr,
+		msgdma_pref_csroffs(status));
+	csrwr32(MSGDMA_PREF_CTL_RESET, priv->rx_pref_csr,
+		msgdma_pref_csroffs(control));
+
+	counter = 0;
+	while (counter++ < ALTERA_TSE_SW_RESET_WATCHDOG_CNTR) {
+		if (tse_bit_is_clear(priv->rx_pref_csr,
+				     msgdma_pref_csroffs(control),
+				     MSGDMA_PREF_CTL_RESET))
+			break;
+		udelay(1);
+	}
+
+	if (counter >= ALTERA_TSE_SW_RESET_WATCHDOG_CNTR)
+		netif_warn(priv, drv, priv->dev,
+			   "TSE Rx Prefetcher reset bit never cleared!\n");
+
+	/* Reset the TX Prefetcher */
+	csrwr32(MSGDMA_PREF_STAT_IRQ, priv->tx_pref_csr,
+		msgdma_pref_csroffs(status));
+	csrwr32(MSGDMA_PREF_CTL_RESET, priv->tx_pref_csr,
+		msgdma_pref_csroffs(control));
+
+	counter = 0;
+	while (counter++ < ALTERA_TSE_SW_RESET_WATCHDOG_CNTR) {
+		if (tse_bit_is_clear(priv->tx_pref_csr,
+				     msgdma_pref_csroffs(control),
+				     MSGDMA_PREF_CTL_RESET))
+			break;
+		udelay(1);
+	}
+
+	if (counter >= ALTERA_TSE_SW_RESET_WATCHDOG_CNTR)
+		netif_warn(priv, drv, priv->dev,
+			   "TSE Tx Prefetcher reset bit never cleared!\n");
+
+	/* clear all status bits */
+	csrwr32(MSGDMA_PREF_STAT_IRQ, priv->tx_pref_csr,
+		msgdma_pref_csroffs(status));
+
+	/* Reset mSGDMA dispatchers*/
+	msgdma_reset(priv);
+}
+
+/* Setup the RX and TX prefetchers to poll the descriptor chain */
+void msgdma_pref_start_rxdma(struct altera_tse_private *priv)
+{
+	csrwr32(priv->rx_poll_freq, priv->rx_pref_csr,
+		msgdma_pref_csroffs(desc_poll_freq));
+	csrwr32(lower_32_bits(priv->pref_rxdescphys), priv->rx_pref_csr,
+		msgdma_pref_csroffs(next_desc_lo));
+	csrwr32(upper_32_bits(priv->pref_rxdescphys), priv->rx_pref_csr,
+		msgdma_pref_csroffs(next_desc_hi));
+	tse_set_bit(priv->rx_pref_csr, msgdma_pref_csroffs(control),
+		    MSGDMA_PREF_CTL_DESC_POLL_EN | MSGDMA_PREF_CTL_RUN);
+}
+
+void msgdma_pref_start_txdma(struct altera_tse_private *priv)
+{
+	csrwr32(priv->tx_poll_freq, priv->tx_pref_csr,
+		msgdma_pref_csroffs(desc_poll_freq));
+	csrwr32(lower_32_bits(priv->pref_txdescphys), priv->tx_pref_csr,
+		msgdma_pref_csroffs(next_desc_lo));
+	csrwr32(upper_32_bits(priv->pref_txdescphys), priv->tx_pref_csr,
+		msgdma_pref_csroffs(next_desc_hi));
+	tse_set_bit(priv->tx_pref_csr, msgdma_pref_csroffs(control),
+		    MSGDMA_PREF_CTL_DESC_POLL_EN | MSGDMA_PREF_CTL_RUN);
+}
+
+/* Add MSGDMA Prefetcher Descriptor to descriptor list
+ *   -> This should never be called when a descriptor isn't available
+ */
+void msgdma_pref_add_rx_desc(struct altera_tse_private *priv,
+			     struct tse_buffer *rxbuffer)
+{
+	struct msgdma_pref_extended_desc *rx_descs = priv->pref_rxdesc;
+	u32 desc_entry = priv->pref_rx_prod % (priv->rx_ring_size * 2);
+
+	/* write descriptor entries */
+	rx_descs[desc_entry].len = priv->rx_dma_buf_sz;
+	rx_descs[desc_entry].write_addr_lo = lower_32_bits(rxbuffer->dma_addr);
+	rx_descs[desc_entry].write_addr_hi = upper_32_bits(rxbuffer->dma_addr);
+
+	/* set the control bits and set owned by hw */
+	rx_descs[desc_entry].desc_control = (MSGDMA_DESC_CTL_END_ON_EOP
+			| MSGDMA_DESC_CTL_END_ON_LEN
+			| MSGDMA_DESC_CTL_TR_COMP_IRQ
+			| MSGDMA_DESC_CTL_EARLY_IRQ
+			| MSGDMA_DESC_CTL_TR_ERR_IRQ
+			| MSGDMA_DESC_CTL_GO
+			| MSGDMA_PREF_DESC_CTL_OWNED_BY_HW);
+
+	/* we need to keep a separate one for rx as RX_DESCRIPTORS are
+	 * pre-configured at startup
+	 */
+	priv->pref_rx_prod++;
+
+	if (netif_msg_rx_status(priv)) {
+		netdev_info(priv->dev, "%s: desc: %d buf: %d control 0x%x\n",
+			    __func__, desc_entry,
+			    priv->rx_prod % priv->rx_ring_size,
+			    priv->pref_rxdesc[desc_entry].desc_control);
+	}
+}
+
+u32 msgdma_pref_rx_status(struct altera_tse_private *priv)
+{
+	u32 rxstatus = 0;
+	u32 pktlength;
+	u32 pktstatus;
+	u64 ns = 0;
+	u32 entry = priv->rx_cons % priv->rx_ring_size;
+	u32 desc_entry = priv->rx_prod % (priv->rx_ring_size * 2);
+	struct msgdma_pref_extended_desc *rx_descs = priv->pref_rxdesc;
+	struct skb_shared_hwtstamps *shhwtstamp = NULL;
+	struct tse_buffer *rx_buff = priv->rx_ring;
+
+	/* if the current entry is not owned by hardware, process it */
+	if (!(rx_descs[desc_entry].desc_control
+	      & MSGDMA_PREF_DESC_CTL_OWNED_BY_HW) &&
+	      rx_descs[desc_entry].desc_control) {
+		pktlength = rx_descs[desc_entry].bytes_transferred;
+		pktstatus = rx_descs[desc_entry].desc_status;
+		rxstatus = pktstatus;
+		rxstatus = rxstatus << 16;
+		rxstatus |= (pktlength & 0xffff);
+
+		/* get the timestamp */
+		if (priv->hwts_rx_en) {
+			ns = timestamp_to_ns(&rx_descs[desc_entry]);
+			shhwtstamp = skb_hwtstamps(rx_buff[entry].skb);
+			memset(shhwtstamp, 0,
+			       sizeof(struct skb_shared_hwtstamps));
+			shhwtstamp->hwtstamp = ns_to_ktime(ns);
+		}
+
+		/* clear data */
+		rx_descs[desc_entry].desc_control = 0;
+		rx_descs[desc_entry].timestamp_96b[0] = 0;
+		rx_descs[desc_entry].timestamp_96b[1] = 0;
+		rx_descs[desc_entry].timestamp_96b[2] = 0;
+
+		if (netif_msg_rx_status(priv))
+			netdev_info(priv->dev, "%s: desc: %d buf: %d ts: %lld ns",
+				    __func__, desc_entry, entry, ns);
+	}
+	return rxstatus;
+}
diff --git a/drivers/net/ethernet/altera/altera_msgdma_prefetcher.h b/drivers/net/ethernet/altera/altera_msgdma_prefetcher.h
new file mode 100644
index 000000000000..6507c2805a05
--- /dev/null
+++ b/drivers/net/ethernet/altera/altera_msgdma_prefetcher.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* MSGDMA Prefetcher driver for Altera ethernet devices
+ *
+ * Copyright (C) 2020 Intel Corporation. All rights reserved.
+ * Author(s):
+ *   Dalon Westergreen <dalon.westergreen@intel.com>
+ */
+
+#ifndef __ALTERA_PREF_MSGDMA_H__
+#define __ALTERA_PREF_MSGDMA_H__
+
+void msgdma_pref_reset(struct altera_tse_private *priv);
+void msgdma_pref_enable_txirq(struct altera_tse_private *priv);
+void msgdma_pref_enable_rxirq(struct altera_tse_private *priv);
+void msgdma_pref_disable_rxirq(struct altera_tse_private *priv);
+void msgdma_pref_disable_txirq(struct altera_tse_private *priv);
+void msgdma_pref_clear_rxirq(struct altera_tse_private *priv);
+void msgdma_pref_clear_txirq(struct altera_tse_private *priv);
+u32 msgdma_pref_tx_completions(struct altera_tse_private *priv);
+void msgdma_pref_add_rx_desc(struct altera_tse_private *priv,
+			     struct tse_buffer *buffer);
+netdev_tx_t msgdma_pref_tx_buffer(struct altera_tse_private *priv,
+				  struct tse_buffer *buffer);
+u32 msgdma_pref_rx_status(struct altera_tse_private *priv);
+int msgdma_pref_initialize(struct altera_tse_private *priv);
+void msgdma_pref_uninitialize(struct altera_tse_private *priv);
+void msgdma_pref_start_rxdma(struct altera_tse_private *priv);
+void msgdma_pref_start_txdma(struct altera_tse_private *priv);
+
+#endif /*  __ALTERA_PREF_MSGDMA_H__ */
diff --git a/drivers/net/ethernet/altera/altera_msgdmahw_prefetcher.h b/drivers/net/ethernet/altera/altera_msgdmahw_prefetcher.h
new file mode 100644
index 000000000000..efda31e491ca
--- /dev/null
+++ b/drivers/net/ethernet/altera/altera_msgdmahw_prefetcher.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* MSGDMA Prefetcher driver for Altera ethernet devices
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ * Contributors:
+ *   Dalon Westergreen
+ *   Thomas Chou
+ *   Ian Abbott
+ *   Yuriy Kozlov
+ *   Tobias Klauser
+ *   Andriy Smolskyy
+ *   Roman Bulgakov
+ *   Dmytro Mytarchuk
+ *   Matthew Gerlach
+ */
+
+#ifndef __ALTERA_MSGDMAHW_PREFETCHER_H__
+#define __ALTERA_MSGDMAHW_PREFETCHER_H__
+
+/* mSGDMA prefetcher extended prefectcher descriptor format
+ */
+struct msgdma_pref_extended_desc {
+	/* data buffer source address low bits */
+	u32 read_addr_lo;
+	/* data buffer destination address low bits */
+	u32 write_addr_lo;
+	/* the number of bytes to transfer */
+	u32 len;
+	/* next descriptor low address */
+	u32 next_desc_lo;
+	/* number of bytes transferred */
+	u32 bytes_transferred;
+	u32 desc_status;
+	u32 reserved_18;
+	/* bit 31:24 write burst */
+	/* bit 23:16 read burst */
+	/* bit 15:0  sequence number */
+	u32 burst_seq_num;
+	/* bit 31:16 write stride */
+	/* bit 15:0  read stride */
+	u32 stride;
+	/* data buffer source address high bits */
+	u32 read_addr_hi;
+	/* data buffer destination address high bits */
+	u32 write_addr_hi;
+	/* next descriptor high address */
+	u32 next_desc_hi;
+	/* prefetcher mod now writes these reserved bits*/
+	/* Response bits [191:160] */
+	u32 timestamp_96b[3];
+	/* desc_control */
+	u32 desc_control;
+};
+
+/* mSGDMA Prefetcher Descriptor Status bits */
+#define MSGDMA_PREF_DESC_STAT_STOPPED_ON_EARLY		BIT(8)
+#define MSGDMA_PREF_DESC_STAT_MASK			0xFF
+
+/* mSGDMA Prefetcher Descriptor Control bits */
+/* bit 31 and bits 29-0 are the same as the normal dispatcher ctl flags */
+#define MSGDMA_PREF_DESC_CTL_OWNED_BY_HW		BIT(30)
+
+/* mSGDMA Prefetcher CSR */
+struct msgdma_prefetcher_csr {
+	u32 control;
+	u32 next_desc_lo;
+	u32 next_desc_hi;
+	u32 desc_poll_freq;
+	u32 status;
+};
+
+/* mSGDMA Prefetcher Control */
+#define MSGDMA_PREF_CTL_PARK				BIT(4)
+#define MSGDMA_PREF_CTL_GLOBAL_INTR			BIT(3)
+#define MSGDMA_PREF_CTL_RESET				BIT(2)
+#define MSGDMA_PREF_CTL_DESC_POLL_EN			BIT(1)
+#define MSGDMA_PREF_CTL_RUN				BIT(0)
+
+#define MSGDMA_PREF_POLL_FREQ_MASK			0xFFFF
+
+/* mSGDMA Prefetcher Status */
+#define MSGDMA_PREF_STAT_IRQ				BIT(0)
+
+#define msgdma_pref_csroffs(a) (offsetof(struct msgdma_prefetcher_csr, a))
+#define msgdma_pref_descroffs(a) (offsetof(struct msgdma_pref_extended_desc, a))
+
+#endif /* __ALTERA_MSGDMAHW_PREFETCHER_H__*/
diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
index b7c176a808ac..35f99bfce4ef 100644
--- a/drivers/net/ethernet/altera/altera_tse.h
+++ b/drivers/net/ethernet/altera/altera_tse.h
@@ -382,6 +382,7 @@ struct altera_tse_private;
 
 #define ALTERA_DTYPE_SGDMA 1
 #define ALTERA_DTYPE_MSGDMA 2
+#define ALTERA_DTYPE_MSGDMA_PREF 3
 
 /* standard DMA interface for SGDMA and MSGDMA */
 struct altera_dmaops {
@@ -434,6 +435,19 @@ struct altera_tse_private {
 	void __iomem *tx_dma_csr;
 	void __iomem *tx_dma_desc;
 
+	/* mSGDMA Rx Prefecher address space */
+	void __iomem *rx_pref_csr;
+	struct msgdma_pref_extended_desc *pref_rxdesc;
+	dma_addr_t pref_rxdescphys;
+	u32 pref_rx_prod;
+
+	/* mSGDMA Tx Prefecher address space */
+	void __iomem *tx_pref_csr;
+	struct msgdma_pref_extended_desc *pref_txdesc;
+	dma_addr_t pref_txdescphys;
+	u32 rx_poll_freq;
+	u32 tx_poll_freq;
+
 	/* Rx buffers queue */
 	struct tse_buffer *rx_ring;
 	u32 rx_cons;
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index c874b8c1dd48..d061381bd545 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -44,6 +44,7 @@
 #include "altera_sgdma.h"
 #include "altera_msgdma.h"
 #include "intel_fpga_tod.h"
+#include "altera_msgdma_prefetcher.h"
 
 static atomic_t instance_count = ATOMIC_INIT(~0);
 /* Module parameters */
@@ -1500,6 +1501,34 @@ static int altera_tse_probe(struct platform_device *pdev)
 		priv->rxdescmem = resource_size(dma_res);
 		priv->rxdescmem_busaddr = dma_res->start;
 
+	} else if (priv->dmaops &&
+			   priv->dmaops->altera_dtype ==
+			   ALTERA_DTYPE_MSGDMA_PREF) {
+		/* mSGDMA Rx Prefetcher address space */
+		ret = request_and_map(pdev, "rx_pref", &dma_res,
+				      &priv->rx_pref_csr);
+		if (ret)
+			goto err_free_netdev;
+
+		/* mSGDMA Tx Prefetcher address space */
+		ret = request_and_map(pdev, "tx_pref", &dma_res,
+				      &priv->tx_pref_csr);
+		if (ret)
+			goto err_free_netdev;
+
+		/* get prefetcher rx poll frequency from device tree */
+		if (of_property_read_u32(pdev->dev.of_node, "rx-poll-freq",
+					 &priv->rx_poll_freq)) {
+			dev_info(&pdev->dev, "Defaulting RX Poll Frequency to 128\n");
+			priv->rx_poll_freq = 128;
+		}
+
+		/* get prefetcher rx poll frequency from device tree */
+		if (of_property_read_u32(pdev->dev.of_node, "tx-poll-freq",
+					 &priv->tx_poll_freq)) {
+			dev_info(&pdev->dev, "Defaulting TX Poll Frequency to 128\n");
+			priv->tx_poll_freq = 128;
+		}
 	} else {
 		goto err_free_netdev;
 	}
@@ -1758,7 +1787,29 @@ static const struct altera_dmaops altera_dtype_msgdma = {
 	.start_txdma = NULL,
 };
 
+static const struct altera_dmaops altera_dtype_prefetcher = {
+	.altera_dtype = ALTERA_DTYPE_MSGDMA_PREF,
+	.dmamask = 64,
+	.reset_dma = msgdma_pref_reset,
+	.enable_txirq = msgdma_pref_enable_txirq,
+	.enable_rxirq = msgdma_pref_enable_rxirq,
+	.disable_txirq = msgdma_pref_disable_txirq,
+	.disable_rxirq = msgdma_pref_disable_rxirq,
+	.clear_txirq = msgdma_pref_clear_txirq,
+	.clear_rxirq = msgdma_pref_clear_rxirq,
+	.tx_buffer = msgdma_pref_tx_buffer,
+	.tx_completions = msgdma_pref_tx_completions,
+	.add_rx_desc = msgdma_pref_add_rx_desc,
+	.get_rx_status = msgdma_pref_rx_status,
+	.init_dma = msgdma_pref_initialize,
+	.uninit_dma = msgdma_pref_uninitialize,
+	.start_rxdma = msgdma_pref_start_rxdma,
+	.start_txdma = msgdma_pref_start_txdma,
+};
+
 static const struct of_device_id altera_tse_ids[] = {
+	{ .compatible = "altr,tse-msgdma-2.0",
+		.data = &altera_dtype_prefetcher, },
 	{ .compatible = "altr,tse-msgdma-1.0", .data = &altera_dtype_msgdma, },
 	{ .compatible = "altr,tse-1.0", .data = &altera_dtype_sgdma, },
 	{ .compatible = "ALTR,tse-1.0", .data = &altera_dtype_sgdma, },
-- 
2.13.0

