Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641DD4794D6
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240667AbhLQTcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:32:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:11895 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240636AbhLQTcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:32:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639769537; x=1671305537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=am/nFW9WLQzM893AbBViAoPk99MQ/JyyphvoMm4Tt6w=;
  b=ft+fy6ctWuAwm6sgGyuS1WAhTpjU5Jcyd9HDq0PwqWddqfVoVTW1Asf8
   v021kynaLyvOA/8WRYDtxlbNTxq04H3ESTTsUr8mtNRH3cR0YxXDAngkn
   KKS7QpINK7eh0yGc+4C5/nkCIste7ZlvQRltv4mqa8CAEs2rd7Dn1+BaW
   PaXXoWPOP17Xg1tYGD63TJZbhA5jROKYp/c1VSmyFNjfARgVNjmG8oDxO
   K3d11kPtaHSM07/vteAIIF8MJsb55jaGOrhDin8ZG9yaeNjpZibp+hBVm
   Upq4ZmWeC8rF0dfwKZb6slmNkKNOmVciSn00EmxrAIOL0qNUBsa2DPEEF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="263998135"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="263998135"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 11:32:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="754659461"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 17 Dec 2021 11:32:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 5/6] ice: xsk: allow empty Rx descriptors on XSK ZC data path
Date:   Fri, 17 Dec 2021 11:31:13 -0800
Message-Id: <20211217193114.392106-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
References: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Commit ac6f733a7bd5 ("ice: allow empty Rx descriptors") stated that ice
HW can produce empty descriptors that are valid and they should be
processed.

Add this support to xsk ZC path to avoid potential processing problems.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
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
2.31.1

