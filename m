Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C477AF5C71
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfKIAoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:44:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:25215 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfKIAoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 19:44:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 16:44:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="215111207"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2019 16:44:31 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 6/6] ixgbe: need_wakeup flag might not be set for Tx
Date:   Fri,  8 Nov 2019 16:44:30 -0800
Message-Id: <20191109004430.7219-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
References: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

The need_wakeup flag for Tx might not be set for AF_XDP sockets that
are only used to send packets. This happens if there is at least one
outstanding packet that has not been completed by the hardware and we
get that corresponding completion (which will not generate an
interrupt since interrupts are disabled in the napi poll loop) between
the time we stopped processing the Tx completions and interrupts are
enabled again. In this case, the need_wakeup flag will have been
cleared at the end of the Tx completion processing as we believe we
will get an interrupt from the outstanding completion at a later point
in time. But if this completion interrupt occurs before interrupts
are enable, we lose it and should at that point really have set the
need_wakeup flag since there are no more outstanding completions that
can generate an interrupt to continue the processing. When this
happens, user space will see a Tx queue need_wakeup of 0 and skip
issuing a syscall, which means will never get into the Tx processing
again and we have a deadlock.

This patch introduces a quick fix for this issue by just setting the
need_wakeup flag for Tx to 1 all the time. I am working on a proper
fix for this that will toggle the flag appropriately, but it is more
challenging than I anticipated and I am afraid that this patch will
not be completed before the merge window closes, therefore this easier
fix for now. This fix has a negative performance impact in the range
of 0% to 4%. Towards the higher end of the scale if you have driver
and application on the same core and issue a lot of packets, and
towards no negative impact if you use two cores, lower transmission
speeds and/or a workload that also receives packets.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 100ac89b345d..d6feaacfbf89 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -622,8 +622,6 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 	if (tx_desc) {
 		ixgbe_xdp_ring_update_tail(xdp_ring);
 		xsk_umem_consume_tx_done(xdp_ring->xsk_umem);
-		if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_umem))
-			xsk_clear_tx_need_wakeup(xdp_ring->xsk_umem);
 	}
 
 	return !!budget && work_done;
@@ -691,12 +689,8 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 	if (xsk_frames)
 		xsk_umem_complete_tx(umem, xsk_frames);
 
-	if (xsk_umem_uses_need_wakeup(tx_ring->xsk_umem)) {
-		if (tx_ring->next_to_clean == tx_ring->next_to_use)
-			xsk_set_tx_need_wakeup(tx_ring->xsk_umem);
-		else
-			xsk_clear_tx_need_wakeup(tx_ring->xsk_umem);
-	}
+	if (xsk_umem_uses_need_wakeup(tx_ring->xsk_umem))
+		xsk_set_tx_need_wakeup(tx_ring->xsk_umem);
 
 	return ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
 }
-- 
2.21.0

