Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432C869E82A
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 20:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjBUTSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 14:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjBUTSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 14:18:43 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615522DE48;
        Tue, 21 Feb 2023 11:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677007119; x=1708543119;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1QLHechC5KU2ek3iDt+so0Iu+McFcm5kt7CRnULZiZ4=;
  b=d2xlpxUX8MFj4774Ks0tSK/NK3dTQF4b7jyT65LkLfd7S+vt/KEJlAsy
   Dwr8zg7xY4YSWInY2GeT2keYDSa6y4G85Hy6zNpgfe7yTy6WQl9VszTSD
   e0/qJ6oPXx+vLljcw2kk3ftNeHBA4zILuVRavmFplkZJc1a2IgMvBWvfo
   mImbOfvP3tNzeoVlcEkoaZinhsQxAY+LPHvodc5X/N2NQ0ZY7UBXawlK8
   CBjR8kjmqH1CgB2hhmFWbe8HUfU9Zy+yi3d8461BUmvWV7ACf7rFkyPRt
   pwF1nPBJXG2f/HYC6VsQimNNvecsu7uQQELhzYxLJVG/74gh+LAgaOVoW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="316451169"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="316451169"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 11:18:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="704170050"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="704170050"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 21 Feb 2023 11:18:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH net 1/1] ice: Fix missing cleanup routine in the case of partial memory allocation
Date:   Tue, 21 Feb 2023 11:17:50 -0800
Message-Id: <20230221191750.1196493-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>

Add missing memory free in the case of partial memory allocation
in the loop in ice_realloc_zc_buf function.

Fixes: 7e753eb675f0 ("ice: Fix DMA mappings leak")
Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 374b7f10b549..9ec02f80a2cf 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -377,8 +377,16 @@ int ice_realloc_zc_buf(struct ice_vsi *vsi, bool zc)
 	for_each_set_bit(q, vsi->af_xdp_zc_qps,
 			 max_t(int, vsi->alloc_txq, vsi->alloc_rxq)) {
 		rx_ring = vsi->rx_rings[q];
-		if (ice_realloc_rx_xdp_bufs(rx_ring, zc))
+		if (ice_realloc_rx_xdp_bufs(rx_ring, zc)) {
+			unsigned long qid = q;
+
+			for_each_set_bit(q, vsi->af_xdp_zc_qps, qid) {
+				rx_ring = vsi->rx_rings[q];
+				zc ? kfree(rx_ring->xdp_buf) :
+				     kfree(rx_ring->rx_buf);
+			}
 			return -ENOMEM;
+		}
 	}
 
 	return 0;
-- 
2.38.1

