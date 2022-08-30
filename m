Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5625A6778
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiH3Pcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiH3Pck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:32:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366FB107C41;
        Tue, 30 Aug 2022 08:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661873560; x=1693409560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s6ThNQayhgxoGFufX0OFKDMWnUd2cZs0wkPKt2ZE1gY=;
  b=PdUmjYrz0zoLqWRgFhTDLdf+CD59habTeHDWYJLUZPjvxtOhb/MJ1ygk
   z8c3x1+eII6LkeZHhpwRDGLWYqZ0QNxCckQvIqe7H08X/mSL35sBV9qCJ
   N5qkbxd1wQVqWG+wbusSlUXgP92gH6qCZCkbV2i+ntTqzNOEHQ8HDNzLT
   B31kV5gG19Cg5b/O1n1FN7KAAjanmf2dRqVQvDgP2I2jmCk7CIGaW9sTS
   0bTK4z19v2SBzCG6t9wrGrLBNvnj6p6tNqPbTYKVH8mKil+0htXQx2Oyo
   FSBpEBjpaiQP26r9foPVbTk7/gB6F4kaWFfWqNGloi98qeuLbX1ZENN76
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="278225132"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="278225132"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 08:32:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="857136888"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 30 Aug 2022 08:32:36 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 3DAE519D; Tue, 30 Aug 2022 18:32:51 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Subject: [PATCH 3/5] thunderbolt: Add back Intel Falcon Ridge end-to-end flow control workaround
Date:   Tue, 30 Aug 2022 18:32:48 +0300
Message-Id: <20220830153250.15496-4-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
References: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we are now enabling full end-to-end flow control to the Thunderbolt
networking driver, in order for it to work properly on second generation
Thunderbolt hardware (Falcon Ridge), we need to add back the workaround
that was removed with commit 53f13319d131 ("thunderbolt: Get rid of E2E
workaround"). However, this time we only apply it for Falcon Ridge
controllers as a form of an additional quirk. For non-Falcon Ridge this
does nothing.

While there fix a typo 'reqister' -> 'register' in the comment.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/nhi.c | 49 +++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 75c8bfdeb1fe..caca9f164beb 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -28,7 +28,11 @@
 #define RING_TYPE(ring) ((ring)->is_tx ? "TX ring" : "RX ring")
 
 #define RING_FIRST_USABLE_HOPID	1
-
+/*
+ * Used with QUIRK_E2E to specify an unused HopID the Rx credits are
+ * transferred.
+ */
+#define RING_E2E_RESERVED_HOPID	RING_FIRST_USABLE_HOPID
 /*
  * Minimal number of vectors when we use MSI-X. Two for control channel
  * Rx/Tx and the rest four are for cross domain DMA paths.
@@ -38,7 +42,9 @@
 
 #define NHI_MAILBOX_TIMEOUT	500 /* ms */
 
+/* Host interface quirks */
 #define QUIRK_AUTO_CLEAR_INT	BIT(0)
+#define QUIRK_E2E		BIT(1)
 
 static int ring_interrupt_index(struct tb_ring *ring)
 {
@@ -458,8 +464,18 @@ static void ring_release_msix(struct tb_ring *ring)
 
 static int nhi_alloc_hop(struct tb_nhi *nhi, struct tb_ring *ring)
 {
+	unsigned int start_hop = RING_FIRST_USABLE_HOPID;
 	int ret = 0;
 
+	if (nhi->quirks & QUIRK_E2E) {
+		start_hop = RING_FIRST_USABLE_HOPID + 1;
+		if (ring->flags & RING_FLAG_E2E && !ring->is_tx) {
+			dev_dbg(&nhi->pdev->dev, "quirking E2E TX HopID %u -> %u\n",
+				ring->e2e_tx_hop, RING_E2E_RESERVED_HOPID);
+			ring->e2e_tx_hop = RING_E2E_RESERVED_HOPID;
+		}
+	}
+
 	spin_lock_irq(&nhi->lock);
 
 	if (ring->hop < 0) {
@@ -469,7 +485,7 @@ static int nhi_alloc_hop(struct tb_nhi *nhi, struct tb_ring *ring)
 		 * Automatically allocate HopID from the non-reserved
 		 * range 1 .. hop_count - 1.
 		 */
-		for (i = RING_FIRST_USABLE_HOPID; i < nhi->hop_count; i++) {
+		for (i = start_hop; i < nhi->hop_count; i++) {
 			if (ring->is_tx) {
 				if (!nhi->tx_rings[i]) {
 					ring->hop = i;
@@ -484,6 +500,11 @@ static int nhi_alloc_hop(struct tb_nhi *nhi, struct tb_ring *ring)
 		}
 	}
 
+	if (ring->hop > 0 && ring->hop < start_hop) {
+		dev_warn(&nhi->pdev->dev, "invalid hop: %d\n", ring->hop);
+		ret = -EINVAL;
+		goto err_unlock;
+	}
 	if (ring->hop < 0 || ring->hop >= nhi->hop_count) {
 		dev_warn(&nhi->pdev->dev, "invalid hop: %d\n", ring->hop);
 		ret = -EINVAL;
@@ -1097,12 +1118,26 @@ static void nhi_shutdown(struct tb_nhi *nhi)
 
 static void nhi_check_quirks(struct tb_nhi *nhi)
 {
-	/*
-	 * Intel hardware supports auto clear of the interrupt status
-	 * reqister right after interrupt is being issued.
-	 */
-	if (nhi->pdev->vendor == PCI_VENDOR_ID_INTEL)
+	if (nhi->pdev->vendor == PCI_VENDOR_ID_INTEL) {
+		/*
+		 * Intel hardware supports auto clear of the interrupt
+		 * status register right after interrupt is being
+		 * issued.
+		 */
 		nhi->quirks |= QUIRK_AUTO_CLEAR_INT;
+
+		switch (nhi->pdev->device) {
+		case PCI_DEVICE_ID_INTEL_FALCON_RIDGE_2C_NHI:
+		case PCI_DEVICE_ID_INTEL_FALCON_RIDGE_4C_NHI:
+			/*
+			 * Falcon Ridge controller needs the end-to-end
+			 * flow control workaround to avoid losing Rx
+			 * packets when RING_FLAG_E2E is set.
+			 */
+			nhi->quirks |= QUIRK_E2E;
+			break;
+		}
+	}
 }
 
 static int nhi_check_iommu_pdev(struct pci_dev *pdev, void *data)
-- 
2.35.1

