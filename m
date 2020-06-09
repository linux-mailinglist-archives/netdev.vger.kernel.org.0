Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAB11F3CCD
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 15:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgFINkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 09:40:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:22603 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbgFINku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 09:40:50 -0400
IronPort-SDR: 1Q8SS3e2XzwJrZmSCMlDxJM5bl2UJgf+idXHftm1IGKkOUJu44GILzbRKxCx9YmQOiuH1nhLrK
 MK4V96+mYKKA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 06:40:49 -0700
IronPort-SDR: ECVqyDBtTLe+m4htIZcsDLANRgIAyAN6h2NxYDwRiGAwljoEWYmcT36CjszigxgqFE9SSwqVs0
 Cv7OHMzLnxew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,492,1583222400"; 
   d="scan'208";a="295837449"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.8])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jun 2020 06:40:48 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ciara.loftus@intel.com
Subject: [PATCH net 2/3] i40e: protect ring accesses with READ- and WRITE_ONCE
Date:   Tue,  9 Jun 2020 13:19:44 +0000
Message-Id: <20200609131945.18373-2-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200609131945.18373-1-ciara.loftus@intel.com>
References: <20200609131945.18373-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

READ_ONCE should be used when reading rings prior to accessing the
statistics pointer. Introduce this as well as the corresponding WRITE_ONCE
usage when allocating and freeing the rings, to ensure protected access.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 29 ++++++++++++++-------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5d807c8004f8..56ecd6c3f236 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -439,11 +439,15 @@ static void i40e_get_netdev_stats_struct(struct net_device *netdev,
 		i40e_get_netdev_stats_struct_tx(ring, stats);
 
 		if (i40e_enabled_xdp_vsi(vsi)) {
-			ring++;
+			ring = READ_ONCE(vsi->xdp_rings[i]);
+			if (!ring)
+				continue;
 			i40e_get_netdev_stats_struct_tx(ring, stats);
 		}
 
-		ring++;
+		ring = READ_ONCE(vsi->rx_rings[i]);
+		if (!ring)
+			continue;
 		do {
 			start   = u64_stats_fetch_begin_irq(&ring->syncp);
 			packets = ring->stats.packets;
@@ -787,6 +791,8 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	for (q = 0; q < vsi->num_queue_pairs; q++) {
 		/* locate Tx ring */
 		p = READ_ONCE(vsi->tx_rings[q]);
+		if (!p)
+			continue;
 
 		do {
 			start = u64_stats_fetch_begin_irq(&p->syncp);
@@ -800,8 +806,11 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		tx_linearize += p->tx_stats.tx_linearize;
 		tx_force_wb += p->tx_stats.tx_force_wb;
 
-		/* Rx queue is part of the same block as Tx queue */
-		p = &p[1];
+		/* locate Rx ring */
+		p = READ_ONCE(vsi->rx_rings[q]);
+		if (!p)
+			continue;
+
 		do {
 			start = u64_stats_fetch_begin_irq(&p->syncp);
 			packets = p->stats.packets;
@@ -10824,10 +10833,10 @@ static void i40e_vsi_clear_rings(struct i40e_vsi *vsi)
 	if (vsi->tx_rings && vsi->tx_rings[0]) {
 		for (i = 0; i < vsi->alloc_queue_pairs; i++) {
 			kfree_rcu(vsi->tx_rings[i], rcu);
-			vsi->tx_rings[i] = NULL;
-			vsi->rx_rings[i] = NULL;
+			WRITE_ONCE(vsi->tx_rings[i], NULL);
+			WRITE_ONCE(vsi->rx_rings[i], NULL);
 			if (vsi->xdp_rings)
-				vsi->xdp_rings[i] = NULL;
+				WRITE_ONCE(vsi->xdp_rings[i], NULL);
 		}
 	}
 }
@@ -10861,7 +10870,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 		if (vsi->back->hw_features & I40E_HW_WB_ON_ITR_CAPABLE)
 			ring->flags = I40E_TXR_FLAGS_WB_ON_ITR;
 		ring->itr_setting = pf->tx_itr_default;
-		vsi->tx_rings[i] = ring++;
+		WRITE_ONCE(vsi->tx_rings[i], ring++);
 
 		if (!i40e_enabled_xdp_vsi(vsi))
 			goto setup_rx;
@@ -10879,7 +10888,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 			ring->flags = I40E_TXR_FLAGS_WB_ON_ITR;
 		set_ring_xdp(ring);
 		ring->itr_setting = pf->tx_itr_default;
-		vsi->xdp_rings[i] = ring++;
+		WRITE_ONCE(vsi->xdp_rings[i], ring++);
 
 setup_rx:
 		ring->queue_index = i;
@@ -10892,7 +10901,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 		ring->size = 0;
 		ring->dcb_tc = 0;
 		ring->itr_setting = pf->rx_itr_default;
-		vsi->rx_rings[i] = ring;
+		WRITE_ONCE(vsi->rx_rings[i], ring);
 	}
 
 	return 0;
-- 
2.17.1

