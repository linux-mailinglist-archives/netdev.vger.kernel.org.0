Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7336525D6
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 18:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiLTRzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 12:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLTRzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 12:55:01 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C8F63B9;
        Tue, 20 Dec 2022 09:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671558901; x=1703094901;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TQ71M0BvDd2eCZdZz2dnYmc4it8LKcserfixcOjTETA=;
  b=aBbOuBfDjfMcmF/CAjkiIQXyXokBrLH/XcjCM6a/+f8VP2XQEYBcoGlC
   vdvhVQ+okxP+DG+5CuJZ3fjnJihKaPxScux6P5FLt4ySnBe5XRSRV6Aqx
   cdo8RL79qljZCbPbpxIUxBOgr5UJ4MbDSp3y79diMupdkbQAAZz/UucgY
   yDuaZxTsfEKvEcEb7eQkoDvESzM62WD3tLo8XY1XmHtal7syc7zDBR55Z
   G84NX0srDbU5Nfvdw4NhqWnmViWtehD77NIfB8x0IIFkHNB7TJDi9IdUS
   uJY5uKwP3CaQ9y+I1O8hBXMdMiNoNKT8Tw4sNJxzFxpFjPyFs0klWJp2D
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="307358614"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="307358614"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 09:54:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="651113854"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="651113854"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 20 Dec 2022 09:54:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Robin Cowley <robin.cowley@thehutgroup.com>,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH net 1/1] ice: xsk: do not use xdp_return_frame() on tx_buf->raw_buf
Date:   Tue, 20 Dec 2022 09:54:48 -0800
Message-Id: <20221220175448.693999-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Previously ice XDP xmit routine was changed in a way that it avoids
xdp_buff->xdp_frame conversion as it is simply not needed for handling
XDP_TX action and what is more it saves us CPU cycles. This routine is
re-used on ZC driver to handle XDP_TX action.

Although for XDP_TX on Rx ZC xdp_buff that comes from xsk_buff_pool is
converted to xdp_frame, xdp_frame itself is not stored inside
ice_tx_buf, we only store raw data pointer. Casting this pointer to
xdp_frame and calling against it xdp_return_frame in
ice_clean_xdp_tx_buf() results in undefined behavior.

To fix this, simply call page_frag_free() on tx_buf->raw_buf.
Later intention is to remove the buff->frame conversion in order to
simplify the codebase and improve XDP_TX performance on ZC.

Fixes: 126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API")
Reported-and-tested-by: Robin Cowley <robin.cowley@thehutgroup.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 907055b77af0..7105de6fb344 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -783,7 +783,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 static void
 ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 {
-	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
+	page_frag_free(tx_buf->raw_buf);
 	xdp_ring->xdp_tx_active--;
 	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
 			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
-- 
2.35.1

