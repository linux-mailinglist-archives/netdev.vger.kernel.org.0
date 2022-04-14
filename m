Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0719750190E
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240271AbiDNQul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240735AbiDNQuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:50:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F667CD641;
        Thu, 14 Apr 2022 09:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649953093; x=1681489093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=McvR1HU1Ve6awU9fFJkU+6/6nGmnxCIiq/4cHuAQ9eo=;
  b=mzJ0UQOrXUTXEfZ1Odvgihegm6cil69lexHKRVF/T5J0HK5m1Igto1a1
   96PJTWqOlw5ZTwbucUBtLZFQ9CiBqjbTP9ZAvggWaJynUENHJpB47VVCV
   g5u7IaanmPLAo5oO677kdxflkOQRAzmBumVIgGwPzTwc3zT8LVGhiSMGN
   8mi2ynzHXHKNY/l62G2DB5AYcWPLlFEsixZ55s23rE0D4q91ZH8L6BJzo
   nHlxnT+tG9Lgeu27UzmHy6w1OXC7gxKlDSy2XFcnqd8UtpPC7OwMCH4p5
   tbQ4eq6Hg0lFywTsFRK99zuDOvRutE4QcnhgCWKs9Caz1l037yAGITuYA
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="242901614"
X-IronPort-AV: E=Sophos;i="5.90,260,1643702400"; 
   d="scan'208";a="242901614"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 09:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,260,1643702400"; 
   d="scan'208";a="526970478"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2022 09:18:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Subject: [PATCH net 1/4] ice: xsk: check if Rx ring was filled up to the end
Date:   Thu, 14 Apr 2022 09:15:19 -0700
Message-Id: <20220414161522.2320694-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220414161522.2320694-1-anthony.l.nguyen@intel.com>
References: <20220414161522.2320694-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

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
Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 866ee4df9671..9dd38f667059 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -415,8 +415,8 @@ static u16 ice_fill_rx_descs(struct xsk_buff_pool *pool, struct xdp_buff **xdp,
  */
 static bool __ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 {
+	u32 nb_buffs_extra = 0, nb_buffs = 0;
 	union ice_32b_rx_flex_desc *rx_desc;
-	u32 nb_buffs_extra = 0, nb_buffs;
 	u16 ntu = rx_ring->next_to_use;
 	u16 total_count = count;
 	struct xdp_buff **xdp;
@@ -428,6 +428,10 @@ static bool __ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
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
@@ -441,6 +445,7 @@ static bool __ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 	if (ntu == rx_ring->count)
 		ntu = 0;
 
+exit:
 	if (rx_ring->next_to_use != ntu)
 		ice_release_rx_desc(rx_ring, ntu);
 
-- 
2.31.1

