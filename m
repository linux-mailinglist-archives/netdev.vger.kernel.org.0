Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE2647308E
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240049AbhLMPbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:31:39 -0500
Received: from mga04.intel.com ([192.55.52.120]:4850 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238225AbhLMPbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 10:31:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639409498; x=1670945498;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K3vnyLz2bxQysLYlwScP09dg12wIGh96QuIolR0pyVc=;
  b=HtL5bGt6JRf+2m2ODRZK3r1hrOhKOj0LG25LpLYa5OFWk9jMY3B0KfLk
   Yuw6RmiCASnc4dbX3xabSrKfQvMlz8J3iwfJLQl/kDmnmNGP3Vv+xG6BS
   hnQ1ajDois1wdS4I2I8CioGn/0iNtEKR2CnKXiPEIOIXBGDjFDgqLZ33E
   qENTqyMOSMTU4tYezx/MV9Lio+X+DcVSfwQjyXuEN3qcnFTPRrUGRsDV4
   Y/udacMNA8Xdgb2a0CH5VHG1MHZLnAjf+Dv8/e9CIm+h56dirqL61AGlO
   HGkni+zbRGUj8N/i1zb2+9VHkcQ6rmsyPdIzaWDySV9qN9qsv52lPVd2J
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="237490540"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="237490540"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:31:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="613864787"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 13 Dec 2021 07:31:35 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, elza.mathew@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-net 6/6] ice: xsk: fix cleaned_count setting
Date:   Mon, 13 Dec 2021 16:31:11 +0100
Message-Id: <20211213153111.110877-7-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
References: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.33.1

