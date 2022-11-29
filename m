Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0148863C62F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbiK2RLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236414AbiK2RLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:11:39 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9095FBA5;
        Tue, 29 Nov 2022 09:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669741898; x=1701277898;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7M5v88T9DtcIFzCeKmaHBS7GEm5CVug8t2O/Fw9p5Cc=;
  b=Xmm/GOO55tzmPmEFi035KiY02vtZrsYGc3psIPqZwAx4YU6jb1td7dRM
   kjb+jGMk0TbveIDyeP1WxaCWKeUFinzZq4Lk8L9tO9nK30Fr+W+F2Sqk1
   RjLhv96lViJrnoXFB3SSw4aI5o+pUlfsRozhc59NAwg9bA5MmcszH0XPw
   LppO0HP+7iriB2foEI90rm06ppKisAavJFBBaEqUtYAwiI7uUTaKVK+gr
   9d6evhZfTrPSQSJ66CfNR5J6E9Ow4bShOpUKNZkhYBNTe0DF6xlKA58bC
   MdkoBz7bAGXms17jjKWWzvLMMTlf7F+AUExp3jxngtnQqOIjoPrzl8JgA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="312792136"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="312792136"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 09:11:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="643862494"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="643862494"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 29 Nov 2022 09:11:34 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Robin Cowley <robin.cowley@thehutgroup.com>
Subject: [PATCH intel-net] ice: xsk: do not use xdp_return_frame() on tx_buf->raw_buf
Date:   Tue, 29 Nov 2022 18:11:25 +0100
Message-Id: <20221129171125.4092238-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 056c904b83cc..79fa65d1cf20 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -772,7 +772,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 static void
 ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 {
-	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
+	page_frag_free(tx_buf->raw_buf);
 	xdp_ring->xdp_tx_active--;
 	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
 			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
-- 
2.34.1

