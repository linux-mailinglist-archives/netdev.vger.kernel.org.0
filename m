Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B77C232294
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgG2QYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:42163 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbgG2QYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:17 -0400
IronPort-SDR: vywHAT8Cq75FIJyiiCSt3ihcSh25kJYisOMr/Z+ZXmCPiphNbXEbeXWcRGk1Ipu4ZD9u12tS56
 na/uuWC9rMvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982341"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982341"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:15 -0700
IronPort-SDR: /GNA6VtWlRMBEqUYHLKbnQluk4t47uRRPbcw5tNpHjdYUgLyHQg/puxckhZ525BP8Ae+XbCkv7
 rvd5++DY3NUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087584"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 10/15] ice: need_wakeup flag might not be set for Tx
Date:   Wed, 29 Jul 2020 09:24:00 -0700
Message-Id: <20200729162405.1596435-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>

This is a port of i40e commit 705639572e8c ("i40e: need_wakeup flag might
not be set for Tx").

Quoting the original commit message:

"The need_wakeup flag for Tx might not be set for AF_XDP sockets that
are only used to send packets. This happens if there is at least one
outstanding packet that has not been completed by the hardware and we
get that corresponding completion (which will not generate an interrupt
since interrupts are disabled in the napi poll loop) between the time we
stopped processing the Tx completions and interrupts are enabled again.
In this case, the need_wakeup flag will have been cleared at the end of
the Tx completion processing as we believe we will get an interrupt from
the outstanding completion at a later point in time. But if this
completion interrupt occurs before interrupts are enable, we lose it and
should at that point really have set the need_wakeup flag since there
are no more outstanding completions that can generate an interrupt to
continue the processing. When this happens, user space will see a Tx
queue need_wakeup of 0 and skip issuing a syscall, which means will
never get into the Tx processing again and we have a deadlock."

As a result, packet processing stops. This patch introduces a fix for
this issue, by always setting the need_wakeup flag at the end of an
interrupt processing. This ensures that the deadlock will not happen.

Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 6badfd62dc63..87862918bc7a 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -706,8 +706,6 @@ static bool ice_xmit_zc(struct ice_ring *xdp_ring, int budget)
 	if (tx_desc) {
 		ice_xdp_ring_update_tail(xdp_ring);
 		xsk_umem_consume_tx_done(xdp_ring->xsk_umem);
-		if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_umem))
-			xsk_clear_tx_need_wakeup(xdp_ring->xsk_umem);
 	}
 
 	return budget > 0 && work_done;
@@ -783,12 +781,8 @@ bool ice_clean_tx_irq_zc(struct ice_ring *xdp_ring, int budget)
 	if (xsk_frames)
 		xsk_umem_complete_tx(xdp_ring->xsk_umem, xsk_frames);
 
-	if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_umem)) {
-		if (xdp_ring->next_to_clean == xdp_ring->next_to_use)
-			xsk_set_tx_need_wakeup(xdp_ring->xsk_umem);
-		else
-			xsk_clear_tx_need_wakeup(xdp_ring->xsk_umem);
-	}
+	if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_umem))
+		xsk_set_tx_need_wakeup(xdp_ring->xsk_umem);
 
 	ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
 	xmit_done = ice_xmit_zc(xdp_ring, ICE_DFLT_IRQ_WORK);
-- 
2.26.2

