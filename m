Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6CE462831
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 00:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhK2XWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 18:22:37 -0500
Received: from mga18.intel.com ([134.134.136.126]:54051 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231437AbhK2XWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 18:22:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="222980847"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="222980847"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 15:19:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="476901804"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 29 Nov 2021 15:19:01 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH net 1/1] ice: xsk: clear status_error0 for each allocated desc
Date:   Mon, 29 Nov 2021 15:17:46 -0800
Message-Id: <20211129231746.2767739-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Fix a bug in which the receiving of packets can stop in the zero-copy
driver. Ice HW ignores 3 lower bits from QRX_TAIL register, which means
that tail is bumped only on intervals of 8. Currently with XSK RX
batching in place, ice_alloc_rx_bufs_zc() clears the status_error0 only
of the last descriptor that has been allocated/taken from the XSK buffer
pool. status_error0 includes DD bit that is looked upon by the
ice_clean_rx_irq_zc() to tell if a descriptor can be processed.

The bug can be triggered when driver updates the ntu but not the
QRX_TAIL, so HW wouldn't have a chance to write to the ready
descriptors. Later on driver moves the ntc to the mentioned set of
descriptors and interprets them as a ready to be processed, since
corresponding DD bits were not cleared nor any writeback has happened
that would clear it. This can then lead to ntc == ntu case which means
that ring is empty and no further packet processing.

Fix the XSK traffic hang that can be observed when l2fwd scenario from
xdpsock is used by making sure that status_error0 is cleared for each
descriptor that is fed to HW and therefore we are sure that driver will
not processed non-valid DD bits. This will also prevent the driver from
processing the descriptors that were allocated in favor of the
previously processed ones, but writeback didn't happen yet.

Fixes: db804cfc21e9 ("ice: Use the xsk batched rx allocation interface")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index ff55cb415b11..bb9a80847298 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -383,6 +383,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 	while (i--) {
 		dma = xsk_buff_xdp_get_dma(*xdp);
 		rx_desc->read.pkt_addr = cpu_to_le64(dma);
+		rx_desc->wb.status_error0 = 0;
 
 		rx_desc++;
 		xdp++;
-- 
2.31.1

