Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132094DCD0A
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 18:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbiCQR7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 13:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbiCQR7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 13:59:01 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D413021C069;
        Thu, 17 Mar 2022 10:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647539864; x=1679075864;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nEv5bKsEAap2hI7uLbqGDVy2KLkyTKhKSiHGliTE7jE=;
  b=TfzgozaLX12RQ0PAMNfDHX9JH0fdxGX0m27Naf+qaGzEeGjsEPAsCguQ
   3wcxiemXjzMERjKbE8fS7NAVOKHww0vVQ+vfUsJCCPC6YINsLCC9obN7z
   9fegrDhGSo/zF38QpaHOl8qH/lrj7HthmbTivbEIswk+hofLjFbiC6WT9
   I4WrPyEjTljJuwNOHnVUhvyJCW7Xd0xjFTStNL4TX9tSPkMOIz6/p7BhH
   xSrej3xFVOW+IVsKAjDE2fM1I1vdSJoNiYBR4VYIakiC7YaJ9cEulv/Lr
   nsiSRR5oEaaJ8lGF+uBWoS6x6FCqtxbPgGKWIfj59zN9zVjEOtcz0Leds
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="320150058"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="320150058"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 10:57:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="513515788"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 17 Mar 2022 10:57:42 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-next] ice: xsk: check if Rx ring was filled up to the end
Date:   Thu, 17 Mar 2022 18:57:27 +0100
Message-Id: <20220317175727.340251-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__ice_alloc_rx_bufs_zc() checks if a number of the descriptors to be
allocated would cause the ring wrap. In that case, driver will issue two
calls to xsk_buff_alloc_batch() - one that will fill the ring up to the
end and the second one that will start with filling descriptors from the
beginning of the ring.

ice_fill_rx_descs() is a wrapper for taking care of what
xsk_buff_alloc_batch() gave back to the driver. It works in a best
effort approach, so for example when driver asks for 64 buffers,
ice_fill_rx_descs() could assign only 32. Such case needs to be checked
when ring is being filled up to the end, because in that situation ntu
might not reached the end of the ring.

Fix the ring wrap by checking if nb_buffs_extra has the expected value.
If not, bump ntu and go directly to tail update.

Fixes: 3876ff525de7 ("ice: xsk: Handle SW XDP ring wrap and bump tail more often")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 88853a6ed931..6f15aa69cd5f 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -413,8 +413,8 @@ static u16 ice_fill_rx_descs(struct xsk_buff_pool *pool, struct xdp_buff **xdp,
  */
 static bool __ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 {
+	u32 nb_buffs_extra = 0, nb_buffs = 0;
 	union ice_32b_rx_flex_desc *rx_desc;
-	u32 nb_buffs_extra = 0, nb_buffs;
 	u16 ntu = rx_ring->next_to_use;
 	u16 total_count = count;
 	struct xdp_buff **xdp;
@@ -426,6 +426,10 @@ static bool __ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 		nb_buffs_extra = ice_fill_rx_descs(rx_ring->xsk_pool, xdp,
 						   rx_desc,
 						   rx_ring->count - ntu);
+		if (nb_buffs_extra != rx_ring->count - ntu) {
+			ntu += nb_buffs_extra;
+			goto exit;
+		}
 		rx_desc = ICE_RX_DESC(rx_ring, 0);
 		xdp = ice_xdp_buf(rx_ring, 0);
 		ntu = 0;
@@ -439,6 +443,7 @@ static bool __ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 	if (ntu == rx_ring->count)
 		ntu = 0;
 
+exit:
 	if (rx_ring->next_to_use != ntu)
 		ice_release_rx_desc(rx_ring, ntu);
 
-- 
2.27.0

