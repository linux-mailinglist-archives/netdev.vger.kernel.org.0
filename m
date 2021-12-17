Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A094794D7
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbhLQTcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:32:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:11893 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240662AbhLQTcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:32:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639769538; x=1671305538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K+xNIudu0nRnwNQpXcmMtITHz1TaJegslilJC36f9Kk=;
  b=amj9ZJvrRlO9/Cqsv1JyWl5qSSzcqAczLNp420YIoz4/exGZguUHAsNp
   bdwFfsCScO8ZiZycE3c+Hbn990VfY35PHwAelVGfZ142l30f4JLcumVo8
   ibOrqxD4l762qW3AAA8bgQkb1AT+ZKS2/0SlyhyyMBf+cnbqKmKZHmYd3
   iEzS4B1OVjsqYt6iSWDPChQxhJsTPxHgTH6QX3cKBBVo0b19HJknjiXM/
   k5SyjaqpthaJZzAQHwRP92KCpqjaX57SKmJS7r2I/oQkdrFidNptLpHDh
   7/Zhz9FPHOIVbbyJW2Wln0U2UqJcl0VLCblYTRaN27M2ndyD2ePGLulpw
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="263998137"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="263998137"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 11:32:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="754659464"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 17 Dec 2021 11:32:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 6/6] ice: xsk: fix cleaned_count setting
Date:   Fri, 17 Dec 2021 11:31:14 -0800
Message-Id: <20211217193114.392106-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
References: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Currently cleaned_count is initialized to ICE_DESC_UNUSED(rx_ring) and
later on during the Rx processing it is incremented per each frame that
driver consumed. This can result in excessive buffers requested from xsk
pool based on that value.

To address this, just drop cleaned_count and pass
ICE_DESC_UNUSED(rx_ring) directly as a function argument to
ice_alloc_rx_bufs_zc(). Idea is to ask for buffers as many as consumed.

Let us also call ice_alloc_rx_bufs_zc unconditionally at the end of
ice_clean_rx_irq_zc. This has been changed in that way for corresponding
ice_clean_rx_irq, but not here.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.h | 1 -
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 6 +-----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index c56dd1749903..b7b3bd4816f0 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -24,7 +24,6 @@
 #define ICE_MAX_DATA_PER_TXD_ALIGNED \
 	(~(ICE_MAX_READ_REQ_SIZE - 1) & ICE_MAX_DATA_PER_TXD)
 
-#define ICE_RX_BUF_WRITE	16	/* Must be power of 2 */
 #define ICE_MAX_TXQ_PER_TXQG	128
 
 /* Attempt to maximize the headroom available for incoming frames. We use a 2K
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index c1491dc0675d..c895351b25e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -505,7 +505,6 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
-	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
 	struct ice_tx_ring *xdp_ring;
 	unsigned int xdp_xmit = 0;
 	struct bpf_prog *xdp_prog;
@@ -562,7 +561,6 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 
 			total_rx_bytes += size;
 			total_rx_packets++;
-			cleaned_count++;
 
 			ice_bump_ntc(rx_ring);
 			continue;
@@ -575,7 +573,6 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 			break;
 		}
 
-		cleaned_count++;
 		ice_bump_ntc(rx_ring);
 
 		if (eth_skb_pad(skb)) {
@@ -597,8 +594,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		ice_receive_skb(rx_ring, skb, vlan_tag);
 	}
 
-	if (cleaned_count >= ICE_RX_BUF_WRITE)
-		failure = !ice_alloc_rx_bufs_zc(rx_ring, cleaned_count);
+	failure = !ice_alloc_rx_bufs_zc(rx_ring, ICE_DESC_UNUSED(rx_ring));
 
 	ice_finalize_xdp_rx(xdp_ring, xdp_xmit);
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
-- 
2.31.1

