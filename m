Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77031F97D0
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 15:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbgFONCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 09:02:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:13269 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730193AbgFONCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 09:02:31 -0400
IronPort-SDR: 2sIeHKazH6ctWwCYKohY62aVMWwNGon4oNpeR2NSNrQmadc0kolCMqrRjT3QQ1BATV0nFtXufU
 gmdxQeiLClyg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 06:01:43 -0700
IronPort-SDR: KmBY9PxTMxsG/CWCt3HTJ59bIIYIdb1paF+7N3Bh9BkzA/bNMgtnVbbPxgfK/18ra5lG0KZJKJ
 oBk/4itCXjaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,514,1583222400"; 
   d="scan'208";a="308115326"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 15 Jun 2020 06:01:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id C6E564D9; Mon, 15 Jun 2020 16:01:39 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH 4/4] thunderbolt: Get rid of E2E workaround
Date:   Mon, 15 Jun 2020 16:01:39 +0300
Message-Id: <20200615130139.83854-5-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.27.0.rc2
In-Reply-To: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The end-to-end (E2E) workaround is needed for Falcon Ridge (TBT 2)
controller when E2E is enabled for both ends of the host-to-host
connection. However, we never supported full E2E in the first place so
this code is not necessary at the moment. Further this allows us to use
all available rings for data except ring 0 which is reserved for the
control path.

The complete E2E flow control is explained in the USB4 spec so we may
add it back later if needed but at least the networking driver seems to
work fine without, and the higher level stack, like TCP will retransmit
lost packets anyway.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/net/thunderbolt.c   |  4 ++--
 drivers/thunderbolt/nhi.c   | 26 ++------------------------
 include/linux/thunderbolt.h |  2 --
 3 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index dacb4f680fd4..a812726703a4 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -866,8 +866,8 @@ static int tbnet_open(struct net_device *dev)
 	eof_mask = BIT(TBIP_PDF_FRAME_END);
 
 	ring = tb_ring_alloc_rx(xd->tb->nhi, -1, TBNET_RING_SIZE,
-				RING_FLAG_FRAME | RING_FLAG_E2E, sof_mask,
-				eof_mask, tbnet_start_poll, net);
+				RING_FLAG_FRAME, sof_mask, eof_mask,
+				tbnet_start_poll, net);
 	if (!ring) {
 		netdev_err(dev, "failed to allocate Rx ring\n");
 		tb_ring_free(net->tx_ring.ring);
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index b617922b5b0a..5f7489fa1327 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -24,12 +24,7 @@
 
 #define RING_TYPE(ring) ((ring)->is_tx ? "TX ring" : "RX ring")
 
-/*
- * Used to enable end-to-end workaround for missing RX packets. Do not
- * use this ring for anything else.
- */
-#define RING_E2E_UNUSED_HOPID	2
-#define RING_FIRST_USABLE_HOPID	TB_PATH_MIN_HOPID
+#define RING_FIRST_USABLE_HOPID	1
 
 /*
  * Minimal number of vectors when we use MSI-X. Two for control channel
@@ -440,7 +435,7 @@ static int nhi_alloc_hop(struct tb_nhi *nhi, struct tb_ring *ring)
 
 		/*
 		 * Automatically allocate HopID from the non-reserved
-		 * range 8 .. hop_count - 1.
+		 * range 1 .. hop_count - 1.
 		 */
 		for (i = RING_FIRST_USABLE_HOPID; i < nhi->hop_count; i++) {
 			if (ring->is_tx) {
@@ -496,10 +491,6 @@ static struct tb_ring *tb_ring_alloc(struct tb_nhi *nhi, u32 hop, int size,
 	dev_dbg(&nhi->pdev->dev, "allocating %s ring %d of size %d\n",
 		transmit ? "TX" : "RX", hop, size);
 
-	/* Tx Ring 2 is reserved for E2E workaround */
-	if (transmit && hop == RING_E2E_UNUSED_HOPID)
-		return NULL;
-
 	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
 	if (!ring)
 		return NULL;
@@ -614,19 +605,6 @@ void tb_ring_start(struct tb_ring *ring)
 		flags = RING_FLAG_ENABLE | RING_FLAG_RAW;
 	}
 
-	if (ring->flags & RING_FLAG_E2E && !ring->is_tx) {
-		u32 hop;
-
-		/*
-		 * In order not to lose Rx packets we enable end-to-end
-		 * workaround which transfers Rx credits to an unused Tx
-		 * HopID.
-		 */
-		hop = RING_E2E_UNUSED_HOPID << REG_RX_OPTIONS_E2E_HOP_SHIFT;
-		hop &= REG_RX_OPTIONS_E2E_HOP_MASK;
-		flags |= hop | RING_FLAG_E2E_FLOW_CONTROL;
-	}
-
 	ring_iowrite64desc(ring, ring->descriptors_dma, 0);
 	if (ring->is_tx) {
 		ring_iowrite32desc(ring, ring->size, 12);
diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
index ff397c0d5c07..5db2b11ab085 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -504,8 +504,6 @@ struct tb_ring {
 #define RING_FLAG_NO_SUSPEND	BIT(0)
 /* Configure the ring to be in frame mode */
 #define RING_FLAG_FRAME		BIT(1)
-/* Enable end-to-end flow control */
-#define RING_FLAG_E2E		BIT(2)
 
 struct ring_frame;
 typedef void (*ring_cb)(struct tb_ring *, struct ring_frame *, bool canceled);
-- 
2.27.0.rc2

