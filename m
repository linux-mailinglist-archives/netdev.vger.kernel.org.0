Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB162A65B4
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbgKDOAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:00:50 -0500
Received: from mga18.intel.com ([134.134.136.126]:48401 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730252AbgKDOAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:00:44 -0500
IronPort-SDR: wF+RQaemNDjmdF1IircpR5p16EqKbn6XjKxHvjYpQKWHlm9dVPCV7wxQ3Me9Jxd96Y8MpZRhyJ
 S9605bcpsrdA==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="156992566"
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="156992566"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 06:00:37 -0800
IronPort-SDR: BEQPrM7N9DrAqe++bQETEawCLSsl/9lT4w6a8MR3btxZumS1A94V+WbFjLlcKx1phSHi71vUwu
 UMe/U1Vw8ZLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="426672237"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 04 Nov 2020 06:00:34 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 29BE9956; Wed,  4 Nov 2020 16:00:31 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 08/10] thunderbolt: Add support for end-to-end flow control
Date:   Wed,  4 Nov 2020 17:00:28 +0300
Message-Id: <20201104140030.6853-9-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
References: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB4 spec defines end-to-end (E2E) flow control that can be used between
hosts to prevent overflow of a RX ring. We previously had this partially
implemented but that code was removed with commit 53f13319d131
("thunderbolt: Get rid of E2E workaround") with the idea that we add it
back properly if there ever is need. Now that we are going to add DMA
traffic test driver (in subsequent patches) this can be useful.

For this reason we modify tb_ring_alloc_rx/tx() so that they accept
RING_FLAG_E2E and configure the hardware ring accordingly. The RX side
also requires passing TX HopID (e2e_tx_hop) used in the credit grant
packets.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/thunderbolt.c   |  2 +-
 drivers/thunderbolt/ctl.c   |  4 ++--
 drivers/thunderbolt/nhi.c   | 36 ++++++++++++++++++++++++++++++++----
 include/linux/thunderbolt.h |  8 +++++++-
 4 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 3160443ef3b9..d7b5f87eaa15 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -866,7 +866,7 @@ static int tbnet_open(struct net_device *dev)
 	eof_mask = BIT(TBIP_PDF_FRAME_END);
 
 	ring = tb_ring_alloc_rx(xd->tb->nhi, -1, TBNET_RING_SIZE,
-				RING_FLAG_FRAME, sof_mask, eof_mask,
+				RING_FLAG_FRAME, 0, sof_mask, eof_mask,
 				tbnet_start_poll, net);
 	if (!ring) {
 		netdev_err(dev, "failed to allocate Rx ring\n");
diff --git a/drivers/thunderbolt/ctl.c b/drivers/thunderbolt/ctl.c
index 9894b8f63064..1d86e27a0ef3 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -628,8 +628,8 @@ struct tb_ctl *tb_ctl_alloc(struct tb_nhi *nhi, event_cb cb, void *cb_data)
 	if (!ctl->tx)
 		goto err;
 
-	ctl->rx = tb_ring_alloc_rx(nhi, 0, 10, RING_FLAG_NO_SUSPEND, 0xffff,
-				0xffff, NULL, NULL);
+	ctl->rx = tb_ring_alloc_rx(nhi, 0, 10, RING_FLAG_NO_SUSPEND, 0, 0xffff,
+				   0xffff, NULL, NULL);
 	if (!ctl->rx)
 		goto err;
 
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index d3b6178d841a..9829e98174c3 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -483,7 +483,7 @@ static int nhi_alloc_hop(struct tb_nhi *nhi, struct tb_ring *ring)
 
 static struct tb_ring *tb_ring_alloc(struct tb_nhi *nhi, u32 hop, int size,
 				     bool transmit, unsigned int flags,
-				     u16 sof_mask, u16 eof_mask,
+				     int e2e_tx_hop, u16 sof_mask, u16 eof_mask,
 				     void (*start_poll)(void *),
 				     void *poll_data)
 {
@@ -506,6 +506,7 @@ static struct tb_ring *tb_ring_alloc(struct tb_nhi *nhi, u32 hop, int size,
 	ring->is_tx = transmit;
 	ring->size = size;
 	ring->flags = flags;
+	ring->e2e_tx_hop = e2e_tx_hop;
 	ring->sof_mask = sof_mask;
 	ring->eof_mask = eof_mask;
 	ring->head = 0;
@@ -550,7 +551,7 @@ static struct tb_ring *tb_ring_alloc(struct tb_nhi *nhi, u32 hop, int size,
 struct tb_ring *tb_ring_alloc_tx(struct tb_nhi *nhi, int hop, int size,
 				 unsigned int flags)
 {
-	return tb_ring_alloc(nhi, hop, size, true, flags, 0, 0, NULL, NULL);
+	return tb_ring_alloc(nhi, hop, size, true, flags, 0, 0, 0, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(tb_ring_alloc_tx);
 
@@ -560,6 +561,7 @@ EXPORT_SYMBOL_GPL(tb_ring_alloc_tx);
  * @hop: HopID (ring) to allocate. Pass %-1 for automatic allocation.
  * @size: Number of entries in the ring
  * @flags: Flags for the ring
+ * @e2e_tx_hop: Transmit HopID when E2E is enabled in @flags
  * @sof_mask: Mask of PDF values that start a frame
  * @eof_mask: Mask of PDF values that end a frame
  * @start_poll: If not %NULL the ring will call this function when an
@@ -568,10 +570,11 @@ EXPORT_SYMBOL_GPL(tb_ring_alloc_tx);
  * @poll_data: Optional data passed to @start_poll
  */
 struct tb_ring *tb_ring_alloc_rx(struct tb_nhi *nhi, int hop, int size,
-				 unsigned int flags, u16 sof_mask, u16 eof_mask,
+				 unsigned int flags, int e2e_tx_hop,
+				 u16 sof_mask, u16 eof_mask,
 				 void (*start_poll)(void *), void *poll_data)
 {
-	return tb_ring_alloc(nhi, hop, size, false, flags, sof_mask, eof_mask,
+	return tb_ring_alloc(nhi, hop, size, false, flags, e2e_tx_hop, sof_mask, eof_mask,
 			     start_poll, poll_data);
 }
 EXPORT_SYMBOL_GPL(tb_ring_alloc_rx);
@@ -618,6 +621,31 @@ void tb_ring_start(struct tb_ring *ring)
 		ring_iowrite32options(ring, sof_eof_mask, 4);
 		ring_iowrite32options(ring, flags, 0);
 	}
+
+	/*
+	 * Now that the ring valid bit is set we can configure E2E if
+	 * enabled for the ring.
+	 */
+	if (ring->flags & RING_FLAG_E2E) {
+		if (!ring->is_tx) {
+			u32 hop;
+
+			hop = ring->e2e_tx_hop << REG_RX_OPTIONS_E2E_HOP_SHIFT;
+			hop &= REG_RX_OPTIONS_E2E_HOP_MASK;
+			flags |= hop;
+
+			dev_dbg(&ring->nhi->pdev->dev,
+				"enabling E2E for %s %d with TX HopID %d\n",
+				RING_TYPE(ring), ring->hop, ring->e2e_tx_hop);
+		} else {
+			dev_dbg(&ring->nhi->pdev->dev, "enabling E2E for %s %d\n",
+				RING_TYPE(ring), ring->hop);
+		}
+
+		flags |= RING_FLAG_E2E_FLOW_CONTROL;
+		ring_iowrite32options(ring, flags, 0);
+	}
+
 	ring_interrupt_active(ring, true);
 	ring->running = true;
 err:
diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
index a844fd5d96ab..034dccf93955 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -481,6 +481,8 @@ struct tb_nhi {
  * @irq: MSI-X irq number if the ring uses MSI-X. %0 otherwise.
  * @vector: MSI-X vector number the ring uses (only set if @irq is > 0)
  * @flags: Ring specific flags
+ * @e2e_tx_hop: Transmit HopID when E2E is enabled. Only applicable to
+ *		RX ring. For TX ring this should be set to %0.
  * @sof_mask: Bit mask used to detect start of frame PDF
  * @eof_mask: Bit mask used to detect end of frame PDF
  * @start_poll: Called when ring interrupt is triggered to start
@@ -504,6 +506,7 @@ struct tb_ring {
 	int irq;
 	u8 vector;
 	unsigned int flags;
+	int e2e_tx_hop;
 	u16 sof_mask;
 	u16 eof_mask;
 	void (*start_poll)(void *data);
@@ -514,6 +517,8 @@ struct tb_ring {
 #define RING_FLAG_NO_SUSPEND	BIT(0)
 /* Configure the ring to be in frame mode */
 #define RING_FLAG_FRAME		BIT(1)
+/* Enable end-to-end flow control */
+#define RING_FLAG_E2E		BIT(2)
 
 struct ring_frame;
 typedef void (*ring_cb)(struct tb_ring *, struct ring_frame *, bool canceled);
@@ -562,7 +567,8 @@ struct ring_frame {
 struct tb_ring *tb_ring_alloc_tx(struct tb_nhi *nhi, int hop, int size,
 				 unsigned int flags);
 struct tb_ring *tb_ring_alloc_rx(struct tb_nhi *nhi, int hop, int size,
-				 unsigned int flags, u16 sof_mask, u16 eof_mask,
+				 unsigned int flags, int e2e_tx_hop,
+				 u16 sof_mask, u16 eof_mask,
 				 void (*start_poll)(void *), void *poll_data);
 void tb_ring_start(struct tb_ring *ring);
 void tb_ring_stop(struct tb_ring *ring);
-- 
2.28.0

