Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FB1204E4A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 11:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbgFWJol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 05:44:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:17330 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731921AbgFWJok (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 05:44:40 -0400
IronPort-SDR: Nrk2khhxosS+oqldTRFgwALcR1HhjvxUGYDc5ujkhqMae7mF04XIhzdgjj2uPPFJt859tcqQwg
 2lB1K3NDtYcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142272440"
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="142272440"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 02:44:40 -0700
IronPort-SDR: ov4vznMNjrsw38oS0rlYt//dIoniJRr6uJlnFKrgLwTQ4kenjGWYRs/EMg8JqHlIRuv0h2yCZM
 Vuetisg4Qt8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="422947161"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.33.84])
  by orsmga004.jf.intel.com with ESMTP; 23 Jun 2020 02:44:34 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        sridhar.samudrala@intel.com
Cc:     maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 3/3] i40e: move check of full Tx ring to outside of send loop
Date:   Tue, 23 Jun 2020 11:44:18 +0200
Message-Id: <1592905458-850-4-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592905458-850-1-git-send-email-magnus.karlsson@intel.com>
References: <1592905458-850-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the check if the Hw Tx ring is full to outside the send
loop. Currently it is checked for every single descriptor that we
send. Instead, tell the send loop to only process a maximum number of
packets equal to the number of available slots in the Tx ring. This
way, we can remove the check inside the send loop to and gain some
performance.

Suggested-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 86635f5..081783a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -381,17 +381,10 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 	unsigned int sent_frames = 0, total_bytes = 0;
 	struct i40e_tx_desc *tx_desc = NULL;
 	struct i40e_tx_buffer *tx_bi;
-	bool work_done = true;
 	struct xdp_desc desc;
 	dma_addr_t dma;
 
 	while (budget-- > 0) {
-		if (!unlikely(I40E_DESC_UNUSED(xdp_ring))) {
-			xdp_ring->tx_stats.tx_busy++;
-			work_done = false;
-			break;
-		}
-
 		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
 			break;
 
@@ -427,7 +420,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 		i40e_update_tx_stats(xdp_ring, sent_frames, total_bytes);
 	}
 
-	return !!budget && work_done;
+	return !!budget;
 }
 
 /**
@@ -448,19 +441,18 @@ static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
 
 /**
  * i40e_clean_xdp_tx_irq - Completes AF_XDP entries, and cleans XDP entries
+ * @vsi: Current VSI
  * @tx_ring: XDP Tx ring
- * @tx_bi: Tx buffer info to clean
  *
  * Returns true if cleanup/tranmission is done.
  **/
 bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
 {
-	unsigned int ntc, budget = vsi->work_limit;
 	struct xdp_umem *umem = tx_ring->xsk_umem;
 	u32 i, completed_frames, xsk_frames = 0;
 	u32 head_idx = i40e_get_head(tx_ring);
 	struct i40e_tx_buffer *tx_bi;
-	bool xmit_done;
+	unsigned int ntc;
 
 	if (head_idx < tx_ring->next_to_clean)
 		head_idx += tx_ring->count;
@@ -504,9 +496,7 @@ bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
 	if (xsk_umem_uses_need_wakeup(tx_ring->xsk_umem))
 		xsk_set_tx_need_wakeup(tx_ring->xsk_umem);
 
-	xmit_done = i40e_xmit_zc(tx_ring, budget);
-
-	return xmit_done;
+	return i40e_xmit_zc(tx_ring, I40E_DESC_UNUSED(tx_ring));
 }
 
 /**
@@ -570,7 +560,7 @@ void i40e_xsk_clean_rx_ring(struct i40e_ring *rx_ring)
 
 /**
  * i40e_xsk_clean_xdp_ring - Clean the XDP Tx ring on shutdown
- * @xdp_ring: XDP Tx ring
+ * @tx_ring: XDP Tx ring
  **/
 void i40e_xsk_clean_tx_ring(struct i40e_ring *tx_ring)
 {
-- 
2.7.4

