Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC86473087
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbhLMPbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:31:37 -0500
Received: from mga04.intel.com ([192.55.52.120]:4850 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240120AbhLMPbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 10:31:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639409495; x=1670945495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rfq5psmoi374dmziTJT7+nktFd6U4UtrIwbRZTJRL70=;
  b=RcByMco7Fq6PikLL+IiW/pqAkCloQVSwQRmffVhD5NENr1y+Z9uM6G/+
   xWlO/6b37A3lT/HasMS6CxqcDI0gYWyb3rx0c9SKqNRgkhDNrcrC67IgX
   mgyiwaqdf53PR4LIcAO9Wj48i5RMH1GZxGcotZQOszxppdmVEh9WA2LPk
   IYnLDStAjKxozrKW7KkQkz2Utckgiz1rybZrE/W6berO+GulaR+uorV0C
   eovlHHdp2+lmqSDHc+MBf6/wqT9FcunHMbzwdwaSGtVfdxt8JGCM9VU60
   BIETz+IxFrshaZ2Dw8qDAzc/RaNyHY03+YVNNnFIbEl6qDGDD5zIOqSyL
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="237490525"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="237490525"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:31:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="613864772"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 13 Dec 2021 07:31:33 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, elza.mathew@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-net 5/6] ice: xsk: allow empty Rx descriptors on XSK ZC data path
Date:   Mon, 13 Dec 2021 16:31:10 +0100
Message-Id: <20211213153111.110877-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
References: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ac6f733a7bd5 ("ice: allow empty Rx descriptors") stated that ice
HW can produce empty descriptors that are valid and they should be
processed.

Add this support to xsk ZC path to avoid potential processing problems.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index ffa9a160766a..c1491dc0675d 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -538,12 +538,18 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		 */
 		dma_rmb();
 
+		xdp = *ice_xdp_buf(rx_ring, rx_ring->next_to_clean);
+
 		size = le16_to_cpu(rx_desc->wb.pkt_len) &
 				   ICE_RX_FLX_DESC_PKT_LEN_M;
-		if (!size)
-			break;
+		if (!size) {
+			xdp->data = NULL;
+			xdp->data_end = NULL;
+			xdp->data_hard_start = NULL;
+			xdp->data_meta = NULL;
+			goto construct_skb;
+		}
 
-		xdp = *ice_xdp_buf(rx_ring, rx_ring->next_to_clean);
 		xsk_buff_set_size(xdp, size);
 		xsk_buff_dma_sync_for_cpu(xdp, rx_ring->xsk_pool);
 
@@ -561,7 +567,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 			ice_bump_ntc(rx_ring);
 			continue;
 		}
-
+construct_skb:
 		/* XDP_PASS path */
 		skb = ice_construct_skb_zc(rx_ring, xdp);
 		if (!skb) {
-- 
2.33.1

