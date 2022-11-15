Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07BF628DE7
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiKOADf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 19:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiKOADc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:03:32 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3385F68;
        Mon, 14 Nov 2022 16:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668470611; x=1700006611;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=80f3LvlDadPkLBAc1YxhgWEyEzQsb5j1nNeiZWjPLww=;
  b=nhHpv8G6dF/B8YDGyk0LsO+WpTsZX5Qypb+03uxCCnGxOTSTzGdUpHqU
   0XyLXMRvHmJQIrQVlVvtlDX/KZCSljgcTqeycC/RHOsXhI0Pn3jIJz7Mb
   2OSVJJgw8aAJ8qe4I9dau7gX5fNcoXHdtaq2/cRv0OptKvo4tWAQEZOYl
   BCzPTRIccnzAMh54wiT/r7kpIufOwxVi0rEfg1CECsJlWv5z5hs2e38Bd
   0G4Kcofps0gzsEnTk9Mo3tI24PSkK4BvG1iyM2lRN4LAt1guUvidFOxbn
   H5a4SR9/T+JnrIUEBpcureFHfZn6+dak+t5hTaIsnwZLRIIsAMnYE32KF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="310824664"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="310824664"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 16:03:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="669870400"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="669870400"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2022 16:03:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        bjorn@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Subject: [PATCH net 1/2] i40e: Fix failure message when XDP is configured in TX only mode
Date:   Mon, 14 Nov 2022 16:03:23 -0800
Message-Id: <20221115000324.3040207-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
References: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

When starting xdpsock program in TX only mode:

samples/bpf/xdpsock -i <interface> -t

there was an error on i40e driver:

Failed to allocate some buffers on AF_XDP ZC enabled Rx ring 0 (pf_q 81)

It was caused by trying to allocate RX buffers even though
no RX buffers are available because we run in TX only mode.

Fix this by checking for number of available buffers
for RX queue when allocating buffers during XDP setup.

Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b5dcd15ced36..41112f92f9ef 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3555,7 +3555,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	struct i40e_hw *hw = &vsi->back->hw;
 	struct i40e_hmc_obj_rxq rx_ctx;
 	i40e_status err = 0;
-	bool ok;
+	bool ok = true;
 	int ret;
 
 	bitmap_zero(ring->state, __I40E_RING_STATE_NBITS);
@@ -3653,7 +3653,9 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 
 	if (ring->xsk_pool) {
 		xsk_pool_set_rxq_info(ring->xsk_pool, &ring->xdp_rxq);
-		ok = i40e_alloc_rx_buffers_zc(ring, I40E_DESC_UNUSED(ring));
+		if (ring->xsk_pool->free_list_cnt)
+			ok = i40e_alloc_rx_buffers_zc(ring,
+						      I40E_DESC_UNUSED(ring));
 	} else {
 		ok = !i40e_alloc_rx_buffers(ring, I40E_DESC_UNUSED(ring));
 	}
-- 
2.35.1

