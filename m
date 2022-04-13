Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEDE4FFA36
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbiDMPdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236524AbiDMPdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:33:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFEA37A2F;
        Wed, 13 Apr 2022 08:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863840; x=1681399840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x0o6u3BnYrQT4VVNj0XRk9xfs3RfOLQKuz53r0geu0U=;
  b=RVnIcgjU3UB4CPUJhl9NITSB7Bewnxba4wgBabneH80mWntnreCpjWUh
   fJ4xOkDOwn/txmnVl/fcF0VsApMW4dzLmGrdEGt7m1sdwwaWqKtkbPMiH
   s8X5XpRSbhzVbwlUpotvBHnhSHCHTdH7AXYw4vYFdViU9NlwNKJoGXEVs
   v3NzCTp0SVuv3/ycTBacKGznHqzFB5Q8gm5/NPbW5CqcgopIVOZs+5sRA
   b0zOvJ1kD4fnuNBdh3+vwHi5DaM1+h4C2iXcKGepyDMf239r6lNe7SnA7
   PkHCNjZAV3gHa2M7cJWBhajgUS8PIX/+qa1z6PBEyA6fREJ1+imxqMqK3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544219"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544219"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:30:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318249"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:37 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH v2 bpf-next 04/14] ixgbe: xsk: decorate IXGBE_XDP_REDIR with likely()
Date:   Wed, 13 Apr 2022 17:30:05 +0200
Message-Id: <20220413153015.453864-5-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ixgbe_run_xdp_zc() suggests to compiler that XDP_REDIRECT is the most
probable action returned from BPF program that AF_XDP has in its
pipeline. Let's also bring this suggestion up to the callsite of
ixgbe_run_xdp_zc() so that compiler will be able to generate more
optimized code which in turn will make branch predictor happy.

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 25 ++++++++++----------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index dd7ff66d422f..85497bf10624 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -303,21 +303,22 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 		xsk_buff_dma_sync_for_cpu(bi->xdp, rx_ring->xsk_pool);
 		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp);
 
-		if (xdp_res) {
-			if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR))
-				xdp_xmit |= xdp_res;
-			else
-				xsk_buff_free(bi->xdp);
+		if (likely(xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR)))
+			xdp_xmit |= xdp_res;
+		else if (xdp_res == IXGBE_XDP_CONSUMED)
+			xsk_buff_free(bi->xdp);
+		else
+			goto construct_skb;
 
-			bi->xdp = NULL;
-			total_rx_packets++;
-			total_rx_bytes += size;
+		bi->xdp = NULL;
+		total_rx_packets++;
+		total_rx_bytes += size;
 
-			cleaned_count++;
-			ixgbe_inc_ntc(rx_ring);
-			continue;
-		}
+		cleaned_count++;
+		ixgbe_inc_ntc(rx_ring);
+		continue;
 
+construct_skb:
 		/* XDP_PASS path */
 		skb = ixgbe_construct_skb_zc(rx_ring, bi->xdp);
 		if (!skb) {
-- 
2.33.1

