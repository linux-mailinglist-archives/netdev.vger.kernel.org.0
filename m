Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A3E5BD77C
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiISWeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiISWep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:34:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC7763BC
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663626882; x=1695162882;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8a9FmYWHeYGrhj3pV4TfJlrkEUo7pqRO/WC5zbiMyWo=;
  b=PXkelsjDjXyOZuKwh6BOrWXaeAe5HYnNcj1j1davhR58tSHUHh5JQUBP
   0LVxvy53DU8muEbMWFSI6XVADgEmrwn5kyb6gJq4dwVqcpUAAWD9DmABq
   V98tbsTKWKk1M+nmdm/j4WM/SpwkzK8G4wbBeVzEbFKuGKjcFC0cFg3wn
   aJkqgOwI1yuU2H77adjGxmEaKyI8+0PoR/wvFZEk//b2R9ojUcHPInGH3
   BjjGdE4sBTdm9jHXH4sHbjVMnCKUqfx5TbrMfaRpFCAkigfLVkcLzcxZh
   EAxHxky7rz5f5R2FGWc2PF5WT5xqFzgnE2VeGuRIDdzGA2kVueDspxjTo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="298265230"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="298265230"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 15:34:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="651855349"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 19 Sep 2022 15:34:37 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Norbert Zulinski <norbertx.zulinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/4] iavf: Fix bad page state
Date:   Mon, 19 Sep 2022 15:34:25 -0700
Message-Id: <20220919223428.572091-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220919223428.572091-1-anthony.l.nguyen@intel.com>
References: <20220919223428.572091-1-anthony.l.nguyen@intel.com>
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

From: Norbert Zulinski <norbertx.zulinski@intel.com>

Fix bad page state, free inappropriate page in handling dummy
descriptor. iavf_build_skb now has to check not only if rx_buffer is
NULL but also if size is zero, same thing in iavf_clean_rx_irq.
Without this patch driver would free page that will be used
by napi_build_skb.

Fixes: a9f49e006030 ("iavf: Fix handling of dummy receive descriptors")
Signed-off-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 4c3f3f419110..18b6a702a1d6 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1393,7 +1393,7 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 #endif
 	struct sk_buff *skb;
 
-	if (!rx_buffer)
+	if (!rx_buffer || !size)
 		return NULL;
 	/* prefetch first cache line of first page */
 	va = page_address(rx_buffer->page) + rx_buffer->page_offset;
@@ -1551,7 +1551,7 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_ring, int budget)
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
-			if (rx_buffer)
+			if (rx_buffer && size)
 				rx_buffer->pagecnt_bias++;
 			break;
 		}
-- 
2.35.1

