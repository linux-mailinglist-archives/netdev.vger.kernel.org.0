Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93DB165224
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgBSWHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:07:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:62535 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727845AbgBSWHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:07:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824820"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/13] ice: Support XDP UMEM wake up mechanism
Date:   Wed, 19 Feb 2020 14:06:47 -0800
Message-Id: <20200219220652.2255171-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>

Add support for a new AF_XDP feature that has already been introduced in
upstreamed Intel NIC drivers. If a user space application signals that
it might sleep using the new bind flag XDP_USE_NEED_WAKEUP, the driver
will then set this flag if it has no more buffers on the NIC Rx ring and
yield to the application. For Tx, it will set the flag if it has no
outstanding Tx completion interrupts and return to the application.

Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 55d994f2d71e..3fd31ad73e0e 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -937,6 +937,15 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 	ice_finalize_xdp_rx(rx_ring, xdp_xmit);
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
 
+	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_umem)) {
+		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
+			xsk_set_rx_need_wakeup(rx_ring->xsk_umem);
+		else
+			xsk_clear_rx_need_wakeup(rx_ring->xsk_umem);
+
+		return (int)total_rx_packets;
+	}
+
 	return failure ? budget : (int)total_rx_packets;
 }
 
@@ -988,6 +997,8 @@ static bool ice_xmit_zc(struct ice_ring *xdp_ring, int budget)
 	if (tx_desc) {
 		ice_xdp_ring_update_tail(xdp_ring);
 		xsk_umem_consume_tx_done(xdp_ring->xsk_umem);
+		if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_umem))
+			xsk_clear_tx_need_wakeup(xdp_ring->xsk_umem);
 	}
 
 	return budget > 0 && work_done;
@@ -1063,6 +1074,13 @@ bool ice_clean_tx_irq_zc(struct ice_ring *xdp_ring, int budget)
 	if (xsk_frames)
 		xsk_umem_complete_tx(xdp_ring->xsk_umem, xsk_frames);
 
+	if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_umem)) {
+		if (xdp_ring->next_to_clean == xdp_ring->next_to_use)
+			xsk_set_tx_need_wakeup(xdp_ring->xsk_umem);
+		else
+			xsk_clear_tx_need_wakeup(xdp_ring->xsk_umem);
+	}
+
 	ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
 	xmit_done = ice_xmit_zc(xdp_ring, ICE_DFLT_IRQ_WORK);
 
-- 
2.24.1

