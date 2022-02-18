Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817DB4BC251
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbiBRVuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:50:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiBRVuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:50:52 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9748E6D86;
        Fri, 18 Feb 2022 13:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645221034; x=1676757034;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rHLbGSPZIqYXX4HtomSqqnHiSr3268Fjo/PtvPjWgbU=;
  b=VWH2wnc0uLoM2fZtxR/0TU1xA7H5VwAnHf7G7Jufi6ExU08C71BMHIc7
   dReGaSk6qSd9U7IZ/uPTrSG1N+nVJFVrE1tB3TgSAlGwtCtUiwevmogzW
   bu50Zekx9RdkYv4ySvjCv1+bzWW+wF4QXxid9olEFekZffL7Woun5TtPY
   4odrWjFx1BJnNloojNV2yt4VKkJc1sDD3ilruzWFvGcetYoFgFyu4Xez2
   VOPKKgj2IFnq0YUvlB/4PUa4daKYKPxX6fostCWeCMmjUkebXehMCIfnt
   NaYWANxIjU8/wpN2qAsJCPMKLqlHJ+upZWx4ETu0SituQ9w3+EaMmufAB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251178516"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251178516"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:50:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="637898585"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 18 Feb 2022 13:50:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com, hawk@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net-next 1/1] i40e: remove dead stores on XSK hotpath
Date:   Fri, 18 Feb 2022 13:50:33 -0800
Message-Id: <20220218215033.415004-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

The 'if (ntu == rx_ring->count)' block in i40e_alloc_rx_buffers_zc()
was previously residing in the loop, but after introducing the
batched interface it is used only to wrap-around the NTU descriptor,
thus no more need to assign 'xdp'.

'cleaned_count' in i40e_clean_rx_irq_zc() was previously being
incremented in the loop, but after commit f12738b6ec06
("i40e: remove unnecessary cleaned_count updates") it gets
assigned only once after it, so the initialization can be dropped.

Fixes: 6aab0bb0c5cd ("i40e: Use the xsk batched rx allocation interface")
Fixes: f12738b6ec06 ("i40e: remove unnecessary cleaned_count updates")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 5a997b0d07d8..c1d25b0b0ca2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -218,7 +218,6 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 	ntu += nb_buffs;
 	if (ntu == rx_ring->count) {
 		rx_desc = I40E_RX_DESC(rx_ring, 0);
-		xdp = i40e_rx_bi(rx_ring, 0);
 		ntu = 0;
 	}
 
@@ -328,11 +327,11 @@ static void i40e_handle_xdp_result_zc(struct i40e_ring *rx_ring,
 int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
-	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
 	u16 next_to_clean = rx_ring->next_to_clean;
 	u16 count_mask = rx_ring->count - 1;
 	unsigned int xdp_res, xdp_xmit = 0;
 	bool failure = false;
+	u16 cleaned_count;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union i40e_rx_desc *rx_desc;
-- 
2.31.1

