Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D2921161B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgGAWed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:34:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:25457 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728010AbgGAWe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 18:34:28 -0400
IronPort-SDR: Umb8964WWjaBxkvsqHjTcmP1hd7MmRcgx3VNW7bWgdN2zpe/EJTh2Da/ewQa2t6sS7pE0TbUaZ
 q3j8WTwP6Tdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="134178605"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="134178605"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 15:34:22 -0700
IronPort-SDR: 4b61qQhQTUWcfDadWOPQkrG3p7HUYhVIPhh8g3QKPKl62GEfBOGvRXIEl7RZR3ojnLR5iIAkwq
 DlZkaS+MozQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="455276117"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 15:34:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [net-next 06/12] i40e: move check of full Tx ring to outside of send loop
Date:   Wed,  1 Jul 2020 15:34:06 -0700
Message-Id: <20200701223412.2675606-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
References: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Move the check if the HW Tx ring is full to outside the send
loop. Currently it is checked for every single descriptor that we
send. Instead, tell the send loop to only process a maximum number of
packets equal to the number of available slots in the Tx ring. This
way, we can remove the check inside the send loop to and gain some
performance.

Suggested-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 744861dc7acd..8ce57b507a21 100644
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
2.26.2

