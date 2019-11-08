Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458E8F57FB
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388963AbfKHT6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:58:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:41924 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387400AbfKHT6S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 14:58:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 11:58:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="354188892"
Received: from unknown (HELO VM.ch.intel.com) ([10.78.3.78])
  by orsmga004.jf.intel.com with ESMTP; 08 Nov 2019 11:58:16 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org
Cc:     maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net 1/2] i40e: need_wakeup flag might not be set for Tx
Date:   Fri,  8 Nov 2019 20:58:09 +0100
Message-Id: <1573243090-2721-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index a05dfec..d07e1a8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -689,8 +689,6 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 		i40e_xdp_ring_update_tail(xdp_ring);
 
 		xsk_umem_consume_tx_done(xdp_ring->xsk_umem);
-		if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_umem))
-			xsk_clear_tx_need_wakeup(xdp_ring->xsk_umem);
 	}
 
 	return !!budget && work_done;
@@ -769,12 +767,8 @@ bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi,
 	i40e_update_tx_stats(tx_ring, completed_frames, total_bytes);
 
 out_xmit:
-	if (xsk_umem_uses_need_wakeup(tx_ring->xsk_umem)) {
-		if (tx_ring->next_to_clean == tx_ring->next_to_use)
-			xsk_set_tx_need_wakeup(tx_ring->xsk_umem);
-		else
-			xsk_clear_tx_need_wakeup(tx_ring->xsk_umem);
-	}
+	if (xsk_umem_uses_need_wakeup(tx_ring->xsk_umem))
+		xsk_set_tx_need_wakeup(tx_ring->xsk_umem);
 
 	xmit_done = i40e_xmit_zc(tx_ring, budget);
 
-- 
2.7.4

