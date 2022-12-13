Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EFE64B3C1
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbiLMLEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiLMLEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:04:24 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C420E10C5;
        Tue, 13 Dec 2022 03:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670929463; x=1702465463;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tQWynMwI6beWgXu1++OI8/HcznIn+RkDmF5yOjh7mMw=;
  b=LFHpmRUCAAciOhXHarEHBH9Xn9PQTHdl9h1EBwSXrkZZI2jzcDc7RwZN
   7Y/J4Xyhy5MFsKOyz4pdiXNUBXIiWvBY7aD6UogaGztEnOtWFTrbKkMGE
   fl/kckpAOHtsKQultjo8ixpWxwhFqnY5byBB+9iQaTWgggJlb6LV6nLG5
   532jZv/wFjvaYa+/M8Mvn3YRgeJAMv3ztwtHoWAh2JY3m/Isu/gj/9k2p
   pKJbOoAX8vmkr+Zs7uZD/qJ2YeiLPqw44VVBERHsnxLJq6BzTNyIp334z
   EIDwo6hchPYaYFO9GnNDGe+6PGoNO6CDDBvLc8b7wsz7AUtyneFE4JfxL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="305744404"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="305744404"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 03:04:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="679263050"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="679263050"
Received: from unknown (HELO paamrpdk12-S2600BPB.aw.intel.com) ([10.228.151.145])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 03:04:21 -0800
From:   Tirthendu Sarkar <tirthendu.sarkar@intel.com>
To:     tirtha@gmail.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com
Subject: [PATCH intel-next 4/5] i40e: pull out rx buffer allocation to end of i40e_clean_rx_irq()
Date:   Tue, 13 Dec 2022 16:20:22 +0530
Message-Id: <20221213105023.196409-5-tirthendu.sarkar@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
References: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
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

Previously i40e_alloc_rx_buffers() was called for every 32 cleaned
buffers. For multi-buffers this may not be optimal as there may be more
cleaned buffers in each i40e_clean_rx_irq() call. So this is now pulled
out of the loop and moved to the end of i40e_clean_rx_irq().

As a consequence instead of counting the number of buffers to be cleaned,
I40E_DESC_UNUSED() can be used to call i40e_alloc_rx_buffers().

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index e01bcc91a196..dc9dc0acdd37 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2425,7 +2425,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			     unsigned int *rx_cleaned)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0, frame_sz = 0;
-	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
 	unsigned int offset = rx_ring->rx_offset;
 	struct sk_buff *skb = rx_ring->skb;
 	u16 ntp = rx_ring->next_to_process;
@@ -2450,13 +2449,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 		unsigned int size;
 		u64 qword;
 
-		/* return some buffers to hardware, one at a time is too slow */
-		if (cleaned_count >= I40E_RX_BUFFER_WRITE) {
-			failure = failure ||
-				  i40e_alloc_rx_buffers(rx_ring, cleaned_count);
-			cleaned_count = 0;
-		}
-
 		rx_desc = I40E_RX_DESC(rx_ring, ntp);
 
 		/* status_error_len will always be zero for unused descriptors
@@ -2479,7 +2471,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			rx_buffer = i40e_rx_bi(rx_ring, ntp);
 			I40E_INC_NEXT(ntp, ntc, rmax);
 			i40e_reuse_rx_page(rx_ring, rx_buffer);
-			cleaned_count++;
 			continue;
 		}
 
@@ -2531,7 +2522,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 		}
 
 		i40e_put_rx_buffer(rx_ring, rx_buffer);
-		cleaned_count++;
 
 		I40E_INC_NEXT(ntp, ntc, rmax);
 		if (i40e_is_non_eop(rx_ring, rx_desc))
@@ -2558,6 +2548,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 	rx_ring->next_to_process = ntp;
 	rx_ring->next_to_clean = ntc;
 
+	failure = i40e_alloc_rx_buffers(rx_ring, I40E_DESC_UNUSED(rx_ring));
+
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
 	rx_ring->skb = skb;
 
-- 
2.34.1

